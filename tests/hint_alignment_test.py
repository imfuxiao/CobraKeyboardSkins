"""五套官方皮肤的提示底部对齐回归。

先在各皮肤目录运行 make build，再执行：
  python3 Skins/tests/hint_alignment_test.py -v

检查 Jsonnet 源配置、所有 light/dark 生成布局及待分发 cskin，防止只改源码未更新包。
"""
import json
from pathlib import Path
import subprocess
import unittest
import zipfile

ROOT = Path(__file__).resolve().parents[1]
SKINS = ("Gboard", "胭云", "彩虹", "莫吉托", "hamster")


class HintAlignmentTest(unittest.TestCase):
    def test_source_grid_offset_is_zero(self):
        for name in SKINS:
            with self.subTest(skin=name):
                output = subprocess.check_output(
                    ["jsonnet", "-J", str(ROOT / name / "jsonnet"), "-e",
                     "(import 'Constants/Metrics.libsonnet').hintGrid.offset"],
                    text=True,
                )
                self.assertEqual(json.loads(output), {"x": 0, "y": 0})

    def test_all_generated_grids_keep_default_bottom_alignment(self):
        for name in SKINS:
            with self.subTest(skin=name):
                grids = 0
                for side in ("light", "dark"):
                    layouts = sorted((ROOT / name / side).glob("*.yaml"))
                    self.assertTrue(layouts, f"{name}/{side} 未生成布局")
                    for path in layouts:
                        document = json.loads(path.read_text())
                        for key, style in document.items():
                            if not isinstance(style, dict) or "symbolRows" not in style:
                                continue
                            grids += 1
                            self.assertEqual(style.get("offset", {}).get("y", 0), 0,
                                             f"{path.name}/{key} 仍有纵向偏移")
                            self.assertNotIn("anchor", style,
                                             f"{path.name}/{key} 不应切换为中心锚点定位")
                self.assertGreater(grids, 0, f"{name} 没有测到网格")

    def test_packages_match_generated_layouts_and_source(self):
        for name in SKINS:
            with self.subTest(skin=name):
                root = ROOT / name
                with zipfile.ZipFile(root / "build" / f"{name}.cskin") as archive:
                    self.assertIsNone(archive.testzip())
                    for side in ("light", "dark"):
                        for path in sorted((root / side).glob("*.yaml")):
                            self.assertEqual(archive.read(f"{name}/{side}/{path.name}"), path.read_bytes())
                    metrics = "jsonnet/Constants/Metrics.libsonnet"
                    self.assertEqual(archive.read(f"{name}/{metrics}"), (root / metrics).read_bytes())


if __name__ == "__main__":
    unittest.main()
