#!/usr/bin/env python3
"""生成皮肤包必需的 demo.png（应用内预览图）。

图是从**编译产物** light/pinyinPortrait.yaml 里读出来画的：
布局、宽度、配色、键面文字全部取自皮肤本身，
所以改了 jsonnet 重新编译后跑一遍本脚本，预览图就跟着更新，不会对不上。

    cd Skins/莫吉托 && make compile && python3 scripts/gen_demo.py

依赖：Pillow（pip3 install Pillow）
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

SKIN_DIR = Path(__file__).resolve().parent.parent
SOURCE = SKIN_DIR / "light" / "pinyinPortrait.yaml"
OUTPUT = SKIN_DIR / "demo.png"

WIDTH = 390          # 按 iPhone 13 / 14 / 15 的屏宽出图
SCALE = 3            # 3 倍渲染，适配高分屏
CANDIDATES = [("莫吉托", True), ("薄荷", False), ("青柠", False), ("苏打", False), ("冰块", False)]
PREEDIT_TEXT = "mo'ji'tuo"

# 皮肤里用 SF Symbols 的地方，预览图用等价字形代替
GLYPHS = {
    "shift": "⇧",
    "delete.left": "⌫",
    "space": "␣",
    "globe": "地球",
    "keyboard.chevron.compact.down": "⌄",
    "arrow.right.to.line": "⇥",
}
# assetImage 同理
ASSET_GLYPHS = {"chineseState2": "中", "englishState2": "英"}

CJK_FONTS = [
    "/System/Library/Fonts/Hiragino Sans GB.ttc",
    "/System/Library/Fonts/STHeiti Medium.ttc",
    "/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc",
]
# 中文字体里没有 ⇧ ⌫ 这类键盘符号，画它们时换一套
SYMBOL_FONTS = [
    "/System/Library/Fonts/Apple Symbols.ttf",
    "/System/Library/Fonts/Supplemental/Arial Unicode.ttf",
    "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
]

_SYMBOLS = set("⇧⌫␣⇥⌄")


def load_font(size: int, text: str = "") -> ImageFont.FreeTypeFont:
    candidates = SYMBOL_FONTS if set(text) & _SYMBOLS else CJK_FONTS
    for path in candidates:
        if Path(path).exists():
            try:
                return ImageFont.truetype(path, size)
            except OSError:
                continue
    return ImageFont.load_default(size)


def fraction(value, total: float) -> float | None:
    """把皮肤里的 Size 解析成点数；'均分剩余' 返回 None。"""
    if value is None:
        return None
    if isinstance(value, (int, float)):
        return float(value)
    if isinstance(value, dict) and "percentage" in value:
        return total * float(value["percentage"])
    if isinstance(value, str) and "/" in value:
        num, den = value.split("/", 1)
        return total * float(num) / float(den)
    return None


def cell_text(skin: dict, name: str, suffix: str) -> str:
    style = skin.get(name + suffix)
    if not isinstance(style, dict):
        return ""
    if "text" in style:
        return "换行" if style["text"] == "$returnKeyType" else style["text"]
    if "systemImageName" in style:
        return GLYPHS.get(style["systemImageName"], "")
    if "assetImageName" in style:
        return ASSET_GLYPHS.get(style["assetImageName"], "")
    return ""


def background_of(skin: dict, name: str) -> dict:
    """按键节点 -> 它的背景样式节点。回车键的背景是条件数组，取第一项。"""
    ref = skin.get(name, {}).get("backgroundStyle")
    if isinstance(ref, list):
        ref = ref[0].get("styleName") if isinstance(ref[0], dict) else ref[0]
    return skin.get(ref, {}) if isinstance(ref, str) else {}


def rounded(draw, box, radius, **kw):
    draw.rounded_rectangle([v * SCALE for v in box], radius=radius * SCALE, **kw)


def draw_keyboard(skin: dict) -> Image.Image:
    preedit_h = skin["preeditHeight"]
    toolbar_h = skin["toolbarHeight"]
    keyboard_h = skin["keyboardHeight"]
    height = preedit_h + toolbar_h + keyboard_h

    ground = skin["keyboardBackground"]["normalColor"]
    img = Image.new("RGB", (WIDTH * SCALE, height * SCALE), ground)
    draw = ImageDraw.Draw(img, "RGBA")

    candidate = skin["horizontalCandidateStyle"]
    f_preedit = load_font(int(skin["preeditText"]["fontSize"] * SCALE))
    f_candidate = load_font(int(candidate["textFontSize"] * SCALE))

    # 预编辑区
    insets = skin["preeditStyle"].get("insets", {})
    draw.text(
        ((insets.get("left", 0) + 4) * SCALE, (insets.get("top", 0) + 2) * SCALE),
        PREEDIT_TEXT,
        font=f_preedit,
        fill=skin["preeditText"]["textColor"],
    )

    # 候选栏
    x = 10.0
    for word, preferred in CANDIDATES:
        w = draw.textlength(word, font=f_candidate) / SCALE + 22
        if preferred:
            rounded(
                draw,
                (x, preedit_h + 6, x + w, preedit_h + toolbar_h - 6),
                candidate["backgroundCornerRadius"],
                fill=candidate["preferredBackgroundColor"],
            )
        draw.text(
            ((x + w / 2) * SCALE, (preedit_h + toolbar_h / 2) * SCALE),
            word,
            font=f_candidate,
            fill=candidate["preferredTextColor"] if preferred else candidate["textColor"],
            anchor="mm",
        )
        x += w + 6

    # 按键区
    rows = [node["HStack"]["subviews"] for node in skin["keyboardLayout"]]
    row_h = keyboard_h / len(rows)
    for r, row in enumerate(rows):
        names = [cell["Cell"] for cell in row]
        widths = [fraction(skin.get(n, {}).get("size", {}).get("width"), WIDTH) for n in names]
        flexible = [i for i, w in enumerate(widths) if w is None]
        spare = (WIDTH - sum(w for w in widths if w)) / max(len(flexible), 1)
        for i in flexible:
            widths[i] = spare

        x = 0.0
        top = preedit_h + toolbar_h + r * row_h
        for name, width in zip(names, widths):
            style = background_of(skin, name)
            pad = style.get("insets", {})
            # bounds 只缩显示区，不缩触摸区
            bounds = skin.get(name, {}).get("bounds", {})
            visible = fraction(bounds.get("width"), width) or width
            offset = {"left": 0.0, "right": width - visible}.get(
                bounds.get("alignment", "center"), (width - visible) / 2
            )
            box = (
                x + offset + pad.get("left", 0),
                top + pad.get("top", 0),
                x + offset + visible - pad.get("right", 0),
                top + row_h - pad.get("bottom", 0),
            )
            edge = style.get("normalLowerEdgeColor")
            if edge:
                rounded(draw, (box[0], box[1] + 1, box[2], box[3] + 1), style.get("cornerRadius", 8), fill=edge)
            rounded(draw, box, style.get("cornerRadius", 8), fill=style.get("normalColor"))

            label = cell_text(skin, name, "Label")
            if label:
                size = skin.get(name + "Label", {}).get("fontSize", 20)
                draw.text(
                    ((box[0] + box[2]) / 2 * SCALE, (box[1] + box[3]) / 2 * SCALE),
                    label,
                    font=load_font(int(size * SCALE), label),
                    fill=skin[name + "Label"].get("normalColor"),
                    anchor="mm",
                )
            badge = cell_text(skin, name, "Badge")
            if badge:
                node = skin[name + "Badge"]
                cy = box[1] + (box[3] - box[1]) * node.get("center", {}).get("y", 0.2)
                draw.text(
                    ((box[0] + box[2]) / 2 * SCALE, cy * SCALE),
                    badge,
                    font=load_font(int(node.get("fontSize", 9) * SCALE), badge),
                    fill=node.get("normalColor"),
                    anchor="mm",
                )
            x += width
    return img


def main() -> int:
    if not SOURCE.exists():
        print(f"找不到 {SOURCE}，请先执行 make compile", file=sys.stderr)
        return 1
    # 产物是 JSON（JSON 是 YAML 的子集），直接用 json 读，不必依赖 PyYAML
    draw_keyboard(json.loads(SOURCE.read_text(encoding="utf-8"))).save(OUTPUT)
    print(f"已生成 {OUTPUT.relative_to(SKIN_DIR)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
