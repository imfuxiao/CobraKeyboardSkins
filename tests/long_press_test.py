"""长按配置集成测试：只读真实源码，不读取 light/dark 生成物。

小测：python3 Skins/tests/long_press_test.py LongPressTest.test_rainbow_letter_long_press -v
全测：python3 Skins/tests/long_press_test.py -v
也可使用 python3 -m unittest discover -s Skins/tests -p 'long_press_test.py' -v。

每套皮肤每种布局仅执行一次 jsonnet，进程内缓存供所有断言复用。
矩阵检查原始引用与配色；深浅色 resolve/prune 只运行三个独立按钮场景。
"""
from functools import lru_cache
import json
from pathlib import Path
import re
import shutil
import string
import subprocess
import unittest

SKINS = Path(__file__).resolve().parents[1]
SKIN_NAMES = ("彩虹", "胭云", "莫吉托")
# 独立记录原有上划约定，不能仅比较网格与实现自身的 swipeUpAction。
SWIPES = dict(zip(
    "qwertyuiopasdfghjklzxcvbnm",
    [*"1234567890", "`", "/", ":", ";", "(", ")", "~", "“", "”",
     "@", "'", "#", "、", "?", "!", "…"],
))
COMMA_SYMBOLS = ["，", "、", "；", "：", "“", "”"]


def strings(value):
    if isinstance(value, str):
        yield value
    elif isinstance(value, dict):
        for item in value.values():
            yield from strings(item)
    elif isinstance(value, list):
        for item in value:
            yield from strings(item)


def objects(value):
    if isinstance(value, dict):
        yield value
        for item in value.values():
            yield from objects(item)
    elif isinstance(value, list):
        for item in value:
            yield from objects(item)


def effective(node, split=False):
    """split 的字段覆盖普通字段；未覆盖的动作/引用应继续存在。"""
    result = {key: value for key, value in node.items() if key != "split"}
    if split:
        result.update(node.get("split", {}))
    return result


def manifest(skin, scenario, portrait=True, semicolon=False):
    # 先补齐默认参数，避免 lru_cache 将省略参数与显式传参视为两个场景。
    return _manifest(skin, scenario, portrait, semicolon)


@lru_cache(maxsize=None)
def _manifest(skin, scenario, portrait, semicolon):
    executable = shutil.which("jsonnet")
    if executable is None:
        raise AssertionError("需要本机 jsonnet；缺少依赖不能静默跳过测试")
    boolean = lambda value: str(value).lower()
    if scenario == "phone":
        keyboard = (
            "(import 'Keyboards/iPhonePinyin.libsonnet').new("
            f"isPortrait={boolean(portrait)}, addSemicolon={boolean(semicolon)})"
        )
    elif scenario == "pad":
        keyboard = (
            "(import 'Keyboards/iPadPinyin.libsonnet').new("
            f"isPortrait={boolean(portrait)})"
        )
    elif scenario in ("numeric_phone", "numeric_pad"):
        device = "iPhone" if scenario == "numeric_phone" else "iPad"
        keyboard = (
            "(import 'Keyboards/Numeric.libsonnet').new("
            f"device='{device}', isPortrait={boolean(portrait)}, "
            f"symbolPanel={boolean(device == 'iPad' or not portrait)})"
        )
    elif scenario == "button":
        role = "Colors.role('plain', 'rose')" if skin == "彩虹" else "'letter'"
        keyboard = """
            local Button = import 'Components/Button.libsonnet';
            local Theme = import 'Components/Theme.libsonnet';
            local Metrics = import 'Constants/Metrics.libsonnet';
            local Layout = import 'Components/Layout.libsonnet';
            local opts = { role: ROLE, label: { text: 'x' },
                           action: { character: 'x' },
                           swipeUpAction: { character: '#' },
                           hint: { label: { text: 'X' }, swipeUp: { text: '#' } } };
            Theme.shared(Metrics.keyInsets.iPhone.portrait, Metrics.keyboardHeight.iPhone.portrait)
            + Button.new('plainButton', opts)
            + Button.new('emptyButton', opts + { longPress: [] })
            + Button.new('customButton', opts + { longPress: ['#', 'x', 'X'] })
            + Button.new('leftButton', opts + { longPress: ['a', 'b'], longPressAnchor: 0.05 })
            + Button.new('rightButton', opts + { longPress: ['a', 'b'], longPressAnchor: 0.95 })
            + Button.new('singleButton', opts + { longPress: ['!'], longPressAnchor: 0.95 })
            + { keyboardLayout: [Layout.row([
                'plainButton', 'emptyButton', 'customButton',
                'leftButton', 'rightButton', 'singleButton',
              ])] }
        """.replace("ROLE", role)
    elif scenario == "routing":
        # 对入口只求值 config.yaml，不会触发所有主题文件的惰性生成。
        keyboard = "{ config: (import 'main.jsonnet')['config.yaml'] }"
    else:
        raise ValueError(scenario)

    source = """
        local Style = import 'Components/Style.libsonnet';
        local Colors = import 'Constants/Colors.libsonnet';
        local K = (KEYBOARD);
        local collect(value) =
          if std.isString(value) then [value]
          else if std.isArray(value) then std.flattenArrays([collect(x) for x in value])
          else if std.isObject(value) then
            std.flattenArrays([collect(value[n]) for n in std.objectFields(value)])
          else [];
        // 长按节点与所有引用者先放入子图；再补足引用的背景、标签等节点。
        local seeds = {
          [n]: K[n] for n in std.objectFields(K)
          if std.length(std.findSubstr('Grid', n)) > 0 ||
             (std.isObject(K[n]) && std.objectHas(K[n], 'hintSymbolsGridStyle'))
        };
        local refs = std.set(collect(seeds));
        local graph = seeds + {
          [n]: K[n] for n in std.objectFields(K) if std.setMember(n, refs)
        } + (if std.objectHas(K, 'keyboardLayout') then { keyboardLayout: K.keyboardLayout } else {});
        // 样式引用不随配色改变，先裁剪一次，再分别解析深浅色。
        local prepared = Style.prune(graph);
        local palette = {
          hint: Colors.hint,
          emphasisFill: Colors.hint.selectedFill,
          emphasisInk: Colors.hint.selectedInk,
        };
        {
          raw: K,
          colors: palette,
          themes: if WITH_THEMES then {
            [scheme]: {
              nodes: Style.resolve(prepared, scheme == 'dark'),
              colors: Style.resolve(palette, scheme == 'dark'),
            } for scheme in ['light', 'dark']
          } else {},
        }
    """.replace("KEYBOARD", keyboard).replace("WITH_THEMES", boolean(scenario == "button"))
    result = subprocess.run(
        [executable, "-J", str(SKINS / skin / "jsonnet"), "-e", source],
        capture_output=True, text=True, timeout=120,
    )
    if result.returncode:
        raise AssertionError(f"{skin}/{scenario}/{portrait}/{semicolon}\n{result.stderr}")
    return json.loads(result.stdout)


class LongPressTest(unittest.TestCase):
    def phone_scenarios(self):
        for skin in SKIN_NAMES:
            for portrait in (True, False):
                for semicolon in (False, True):
                    yield skin, portrait, semicolon, manifest(skin, "phone", portrait, semicolon)

    def grid(self, document, name, split=False):
        key = effective(document[name], split)
        self.assertEqual(key.get("hintSymbolsGridStyle"), name + "Grid", name)
        self.assertIn(name + "Grid", document)
        grid = effective(document[name + "Grid"], split)
        self.assertEqual(len(grid["symbolRows"]), 1)
        row = grid["symbolRows"][0]
        self.assertTrue(row)
        self.assertEqual(len(set(row)), len(row))
        # 与 Gboard/hamster 一致，省略 anchor 才走引擎的键上方定位分支。
        self.assertNotIn("anchor", grid)
        self.assertLess(grid["offset"]["y"], 0)
        self.assertEqual(grid["selected"]["row"], 0)
        column = grid["selected"]["col"]
        self.assertIs(type(column), int)
        self.assertGreaterEqual(column, 0)
        self.assertLess(column, len(row))
        symbols = []
        for index, cell_name in enumerate(row):
            self.assertEqual(cell_name, f"{name}GridCell{index}")
            self.assertIn(cell_name, document)
            cell = effective(document[cell_name], split)
            self.assertEqual(set(cell["action"]), {"character"})
            symbol = cell["action"]["character"]
            self.assertIsInstance(symbol, str)
            self.assertTrue(symbol)
            label_name = cell["foregroundStyle"]
            self.assertEqual(label_name, cell_name + "Label")
            self.assertIn(label_name, document)
            label = document[label_name]
            self.assertEqual(label["buttonStyleType"], "text")
            self.assertEqual(label["text"], symbol)
            symbols.append(symbol)
        return symbols, column

    def assert_letter(self, document, character, name=None, split=False):
        name = name or character + "Button"
        key = effective(document[name], split)
        self.assertEqual(key["action"], {"character": character})
        self.assertEqual(key["uppercasedStateAction"], {"character": character.upper()})
        self.assertEqual(key["swipeUpAction"], {"character": SWIPES[character]})
        foregrounds = set(strings(key["foregroundStyle"]))
        self.assertIn(name + "Label", foregrounds)
        self.assertIn(name + "Badge", foregrounds)
        self.assertEqual(document[name + "Label"]["text"], character)
        symbols, column = self.grid(document, name, split)
        self.assertCountEqual(symbols, [SWIPES[character], character, character.upper()])
        self.assertEqual(symbols[column], SWIPES[character], name)
        # 常规短按气泡和上划提示不能被长按面板替代。
        hint = document[key["hintStyle"]]
        self.assertEqual(document[hint["foregroundStyle"]]["text"], character.upper())
        self.assertEqual(document[hint["swipeUpForegroundStyle"]]["text"], SWIPES[character])
        self.assertEqual(document[name + "Badge"]["text"], SWIPES[character])

    def test_rainbow_letter_long_press(self):
        self.assert_letter(manifest("彩虹", "phone")["raw"], "q")

    def test_phone_letters_and_existing_hints_swipes(self):
        for skin, portrait, semicolon, payload in self.phone_scenarios():
            document = payload["raw"]
            layout = set(strings(document["keyboardLayout"]))
            for character in string.ascii_lowercase:
                with self.subTest(skin=skin, portrait=portrait, semicolon=semicolon, key=character):
                    self.assertIn(character + "Button", layout)
                    self.assert_letter(document, character)

    def test_comma_and_optional_semicolon(self):
        for skin, portrait, semicolon, payload in self.phone_scenarios():
            document = payload["raw"]
            layout = set(strings(document["keyboardLayout"]))
            self.assertIn("commaButton", layout)
            symbols, column = self.grid(document, "commaButton")
            self.assertEqual(symbols, COMMA_SYMBOLS)
            # 逗号中心 0.25，六格默认第 2 格；不能强制默认第 1 格。
            self.assertEqual(column, 1)
            self.assertEqual(document["commaButton"]["action"], {"character": ","})
            self.assertEqual(document["commaButton"]["swipeUpAction"], {"character": "."})
            if semicolon:
                self.assertIn("semicolonButton", layout)
                symbols, column = self.grid(document, "semicolonButton")
                self.assertEqual(symbols, [";", ":"])
                self.assertEqual(column, 1)
                self.assertEqual(document["semicolonButton"]["action"], {"character": ";"})
                self.assertEqual(document["semicolonButton"]["swipeUpAction"], {"character": ":"})
            else:
                self.assertNotIn("semicolonButton", document)
                self.assertFalse(any(name.startswith("semicolonButtonGrid") for name in document))

    def test_split_effective_keys_and_repeated_letters(self):
        for skin, portrait, semicolon, payload in self.phone_scenarios():
            document = payload["raw"]
            if portrait or semicolon:
                self.assertNotIn("gSplitButton", document)
                self.assertNotIn("vSplitButton", document)
                continue
            layout = set(strings(document["keyboardLayout"]))
            for character in string.ascii_lowercase:
                self.assert_letter(document, character, split=True)
            for character in "gv":
                name = character + "SplitButton"
                self.assertIn(name, layout)
                self.assertEqual(document[name]["size"]["width"], 0)
                self.assertNotEqual(effective(document[name], True)["size"]["width"], 0)
                self.assert_letter(document, character, name, split=True)
            self.assertEqual(self.grid(document, "commaButton", True)[0], COMMA_SYMBOLS)

    def assert_grid_palette(self, document, grid_name, colors, resolved=False):
        grid = document[grid_name]
        self.grid(document, grid_name[:-4])
        for field, expected_color in (
            ("backgroundStyle", colors["hint"]["fill"]),
            ("selectedBackgroundStyle", colors["emphasisFill"]),
        ):
            self.assertIn(grid[field], document)
            background = document[grid[field]]
            self.assertEqual(background["buttonStyleType"], "geometry")
            self.assertEqual(background["normalColor"], expected_color)
            if resolved:
                self.assertRegex(background["normalColor"], r"^#[0-9a-fA-F]{6}(?:[0-9a-fA-F]{2})?$")
        self.assertEqual(document[grid["backgroundStyle"]]["normalBorderColor"], colors["hint"]["border"])
        for cell_name in grid["symbolRows"][0]:
            cell = document[cell_name]
            label = document[cell["foregroundStyle"]]
            self.assertEqual(label["normalColor"], colors["hint"]["ink"])
            self.assertEqual(label["highlightColor"], colors["emphasisInk"])
            if resolved:
                for field in ("normalColor", "highlightColor"):
                    self.assertRegex(label[field], r"^#[0-9a-fA-F]{6}(?:[0-9a-fA-F]{2})?$")
            if "backgroundStyle" in cell:
                self.assertIn(cell["backgroundStyle"], document)

    def test_all_phone_grid_references_and_colors(self):
        for skin, portrait, semicolon, payload in self.phone_scenarios():
            with self.subTest(skin=skin, portrait=portrait, semicolon=semicolon):
                document = payload["raw"]
                referenced_grids = {
                    node["hintSymbolsGridStyle"] for node in objects(document)
                    if "hintSymbolsGridStyle" in node
                }
                grid_nodes = {name for name, node in document.items()
                              if isinstance(node, dict) and "symbolRows" in node}
                self.assertEqual(referenced_grids, grid_nodes)
                expected_count = 27 + int(semicolon) + (2 if not portrait and not semicolon else 0)
                self.assertEqual(len(grid_nodes), expected_count)
                for grid_name in referenced_grids:
                    self.assert_grid_palette(document, grid_name, payload["colors"])

    def test_light_dark_colors_resolve_prune_and_contrast(self):
        for skin in SKIN_NAMES:
            payload = manifest(skin, "button")
            for scheme, theme in payload["themes"].items():
                with self.subTest(skin=skin, scheme=scheme):
                    document = theme["nodes"]
                    colors = theme["colors"]
                    for name in ("customButton", "leftButton", "rightButton", "singleButton"):
                        self.assert_grid_palette(document, name + "Grid", colors, resolved=True)
                    self.assertFalse(any("light" in node and "dark" in node for node in objects(document)))
                    # 网格字号为20pt，按大字号文本检查至少3:1的选中态对比度。
                    def luminance(color):
                        self.assertTrue(len(color) == 7 or color[-2:].lower() == "ff",
                                        "选中态对比度检查要求使用不透明颜色")
                        rgb = [int(color[index:index + 2], 16) / 255 for index in (1, 3, 5)]
                        linear = [value / 12.92 if value <= 0.04045
                                  else ((value + 0.055) / 1.055) ** 2.4 for value in rgb]
                        return sum(value * weight for value, weight in zip(linear, (0.2126, 0.7152, 0.0722)))
                    ink = luminance(colors["emphasisInk"])
                    fill = luminance(colors["emphasisFill"])
                    ratio = (max(ink, fill) + 0.05) / (min(ink, fill) + 0.05)
                    self.assertGreaterEqual(ratio, 3, f"{skin}/{scheme} 选中态对比度仅 {ratio:.2f}:1")

    def test_button_long_press_is_opt_in_and_empty_array_omits_grid(self):
        for skin in SKIN_NAMES:
            with self.subTest(skin=skin):
                payload = manifest(skin, "button")
                document = payload["raw"]
                for name in ("plainButton", "emptyButton"):
                    self.assertNotIn("hintSymbolsGridStyle", document[name])
                    self.assertFalse(any(node.startswith(name + "Grid") for node in document))
                    self.assertEqual(document[name]["swipeUpAction"], {"character": "#"})
                    self.assertIn(document[name]["hintStyle"], document)
                self.assertEqual(self.grid(document, "customButton"), (["#", "x", "X"], 1))
                self.assertEqual(self.grid(document, "leftButton"), (["a", "b"], 0))
                self.assertEqual(self.grid(document, "rightButton"), (["a", "b"], 1))
                self.assertEqual(self.grid(document, "singleButton"), (["!"], 0))

    def test_ipad_full_and_all_numeric_layouts_do_not_gain_grids(self):
        for skin in SKIN_NAMES:
            for scenario in ("pad", "numeric_phone", "numeric_pad"):
                for portrait in (True, False):
                    with self.subTest(skin=skin, scenario=scenario, portrait=portrait):
                        document = manifest(skin, scenario, portrait)["raw"]
                        self.assertIn("keyboardLayout", document)
                        for node in objects(document):
                            self.assertNotIn("hintSymbolsGridStyle", node)
                            self.assertNotIn("symbolRows", node)
                        self.assertFalse(any("GridCell" in name or name.endswith("Grid") for name in document))

    def test_ipad_floating_routes_to_phone_source_configuration(self):
        for skin in SKIN_NAMES:
            with self.subTest(skin=skin):
                config = manifest(skin, "routing")["raw"]["config"]
                # 标准库没有 YAML 解析器；入口仅有缩进映射与字符串标量。
                stack = [(-1, {})]
                mapping = stack[0][1]
                for line in config.splitlines():
                    if not line.strip() or line.lstrip().startswith("#"):
                        continue
                    match = re.fullmatch(r"( *)([A-Za-z]+):(?:\s*[\"']?([A-Za-z]+)[\"']?)?", line)
                    self.assertIsNotNone(match, f"不支持的配置行：{line!r}")
                    indent, key, value = match.groups()
                    while stack[-1][0] >= len(indent):
                        stack.pop()
                    parent = stack[-1][1]
                    parent[key] = value if value is not None else {}
                    if value is None:
                        stack.append((len(indent), parent[key]))
                self.assertEqual(mapping["pinyin"]["pad"]["floating"], "pinyinPortrait")
                self.assertEqual(mapping["pinyin"]["pad"]["floating"], mapping["pinyin"]["phone"]["portrait"])
                self.assertEqual(mapping["numeric"]["pad"]["floating"], mapping["numeric"]["phone"]["portrait"])
                self.assert_letter(manifest(skin, "phone")["raw"], "q")


if __name__ == "__main__":
    unittest.main()
