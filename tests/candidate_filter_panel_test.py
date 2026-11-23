"""构建后检查实际分发包：make build && make solid && python3 tests/candidate_filter_panel_test.py"""
import json
from pathlib import Path
import unittest
from zipfile import ZipFile

ROOT = Path(__file__).resolve().parents[1]
THEMED = {"Noctua", "Gboard", "彩虹", "胭云", "莫吉托"}
FILTER = "#candidateFilterPanelToggle"
LEGACY = "#candidatesBarStateToggle"
HEX_COLOR = r"^#[0-9a-fA-F]{6}(?:[0-9a-fA-F]{2})?$"
OPAQUE_HEX = r"^#[0-9a-fA-F]{6}(?:[fF]{2})?$"


def cells(nodes):
    for node in nodes:
        if "Cell" in node:
            yield node["Cell"]
        else:
            stack, = node.values()
            yield from cells(stack["subviews"])


def shortcuts(layout, area):
    return [action.get("shortcut") for name in cells(layout[area])
            if isinstance(action := layout[name].get("action"), dict)]


def resolve_state(base, part_key, state_key, field, inheriting=None):
    part = base.get(part_key)
    nodes = [part] if inheriting is not None else [part, base]
    for node in nodes:
        if not isinstance(node, dict):
            continue
        state = node.get(state_key)
        if isinstance(state, dict) and isinstance(state.get(field), str):
            return state[field]
        if state_key == "normal" and isinstance(node.get(field), str):
            return node[field]
    if inheriting is not None:
        return inheriting.get((state_key, field))
    return None


def resolve_paint(base, part_key, inheriting=None):
    paint = {}
    for state in ("normal", "selected", "pressed"):
        for field in ("textColor", "backgroundColor"):
            paint[(state, field)] = resolve_state(base, part_key, state, field, inheriting)
    if paint[("selected", "textColor")] is None:
        paint[("selected", "textColor")] = paint[("normal", "textColor")]
    if paint[("pressed", "textColor")] is None:
        paint[("pressed", "textColor")] = paint[("normal", "textColor")]
    return paint


class CandidateFilterPanelTest(unittest.TestCase):
    def test_packaged_layouts(self):
        skins = {p.parent.parent.name for p in ROOT.glob("*/jsonnet/main.jsonnet")}
        self.assertTrue(THEMED <= skins)
        for build, solid in ((ROOT / "build", False), (ROOT / "build-solid", True)):
            packages = sorted(build.glob("*.cskin"))
            self.assertEqual({p.stem for p in packages}, skins, str(build))
            for package in packages:
                with self.subTest(build=build.name, package=package.name), ZipFile(package) as archive:
                    self.check_package(archive, package.stem in THEMED, solid)

    def check_package(self, archive, themed, solid):
        # 从包内索引取路径，不依赖 zip 对中文顶层目录的编码。
        layouts = {side: {Path(n).name: n for n in archive.namelist()
                          if Path(n).parent.name == side and n.endswith(".yaml")}
                   for side in ("light", "dark")}
        self.assertTrue(layouts["light"])
        self.assertEqual(layouts["light"].keys(), layouts["dark"].keys())
        for name in layouts["light"]:
            with self.subTest(layout=name):
                signatures = [self.check_layout(json.loads(archive.read(paths[name])), themed, solid)
                              for paths in layouts.values()]
                if themed:
                    self.assertNotEqual(*signatures, "深浅色不应共用同一套筛选面板配色")

    def check_layout(self, layout, themed, solid):
        horizontal = shortcuts(layout, "horizontalCandidatesLayout")
        self.assertEqual(horizontal.count(FILTER), 1)
        self.assertNotIn(LEGACY, horizontal)
        self.assertIn(LEGACY, shortcuts(layout, "verticalCandidatesLayout"))
        if not themed:
            self.assertNotIn("candidateFilterPanelStyle", layout)
            return None

        panel = layout["candidateFilterPanelStyle"]
        if solid:
            # Android 纯色版：面板铺主题底板色
            self.assertIn("backgroundColor", panel)
            self.assertRegex(panel["backgroundColor"], OPAQUE_HEX)
        else:
            # iOS 版：不设底色以沿用系统内置背景，避免与顶部 17px 圆角区割裂
            self.assertNotIn("backgroundColor", panel)

        # 候选字配色（常态、首选高亮、按压底色）必须与未展开时的横向候选栏一致
        hc = layout["horizontalCandidateStyle"]
        cand = resolve_paint(panel, "candidate")
        self.assertEqual(cand[("normal", "textColor")], hc["textColor"])
        self.assertEqual(cand[("selected", "textColor")], hc["preferredTextColor"])
        self.assertEqual(cand[("selected", "backgroundColor")], hc["preferredBackgroundColor"])
        self.assertEqual(cand[("pressed", "backgroundColor")], hc["highlightBackgroundColor"])

        # 首笔与范围分段选中态必须是不透明强调色胶囊，且字色与底色区分明显
        stroke = resolve_paint(panel, "stroke", inheriting=cand)
        tool = resolve_paint(panel, "tool")
        seg_tint = (panel.get("tool", {}).get("selected", {}).get("backgroundColor")
                    or panel.get("selected", {}).get("backgroundColor"))
        self.assertIsNotNone(seg_tint)
        self.assertRegex(seg_tint, OPAQUE_HEX)
        self.assertRegex(stroke[("selected", "backgroundColor")], OPAQUE_HEX)
        self.assertNotEqual(stroke[("selected", "backgroundColor")], stroke[("selected", "textColor")])
        self.assertNotEqual(seg_tint, tool[("selected", "textColor")])

        # 校验所有解析出的颜色值格式合法
        for paint in (cand, stroke, tool):
            for value in paint.values():
                if value is not None:
                    self.assertRegex(value, HEX_COLOR)

        return (
            panel.get("backgroundColor"),
            cand[("normal", "textColor")],
            cand[("selected", "backgroundColor")],
            seg_tint,
        )


if __name__ == "__main__":
    unittest.main()
