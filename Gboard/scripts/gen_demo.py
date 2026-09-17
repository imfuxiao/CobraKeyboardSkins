#!/usr/bin/env python3
"""生成皮肤包必需的 demo.png（应用内预览图）。

图是从**编译产物** light/pinyinPortrait.yaml 里读出来画的：
布局、宽度、配色、键面文字全部取自皮肤本身，
所以改了 jsonnet 重新编译后跑一遍本脚本，预览图就跟着更新，不会对不上。

出图分两步：先按皮肤画出键盘，再贴到带皮肤名和作者名的背景板上（见「预览板」一节）。

    cd Skins/彩虹 && make compile && python3 scripts/gen_demo.py

依赖：Pillow（pip3 install Pillow）
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter, ImageFont

SKIN_DIR = Path(__file__).resolve().parent.parent
SOURCE = SKIN_DIR / "light" / "pinyinPortrait.yaml"
OUTPUT = SKIN_DIR / "demo.png"

# 皮肤本身**不画底板**（keyboardBackground 几乎全透明，见 README「键盘整体背景」），
# 真机上透出来的是系统键盘自己的底。预览图得把这层底补上，
# 否则键缝里是一片纯白，与真机差得远。下面两个值只用于出图，不进产物：
#   SYSTEM_BACKDROP  iOS 浅色键盘底的近似取样，垫在键盘图下面
#   BOARD_BACKGROUND 预览板（标题那张卡片）的底，与键盘拉开一档才看得出键盘的轮廓
SYSTEM_BACKDROP = "#D1D5DB"
BOARD_BACKGROUND = "#EFEFEF"

WIDTH = 390          # 按 iPhone 13 / 14 / 15 的屏宽出图
SCALE = 3            # 3 倍渲染，适配高分屏
CANDIDATES = [("键盘", True), ("剑拔", False), ("兼办", False), ("检班", False), ("见帮", False)]
PREEDIT_TEXT = "jian'ban"

# 皮肤里用 SF Symbols 的地方，预览图用等价字形代替
GLYPHS = {
    "shift": "⇧",
    "delete.left": "⌫",
    "space": "␣",
    "return": "⏎",
    "globe": "地球",
    "keyboard.chevron.compact.down": "⌄",
    "arrow.right.to.line": "⇥",
    "face.smiling": "☺",
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

_SYMBOLS = set("⇧⌫␣⇥⌄⏎☺")


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
        # 键面上的变量在真机上由引擎替换，出图时给一份示例值
        return {"$returnKeyType": "换行", "$rimeSchemaName": "拼音"}.get(style["text"], style["text"])
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


def over(color: str, under: str = SYSTEM_BACKDROP) -> str:
    """把 #RRGGBBAA 压到不透明底上；6 位色原样返回。

    皮肤里的背景色带 alpha（如 #FFFFFF03），PIL 的 RGB 画布吃不下，
    也不该按不透明色画——真机上它是叠在系统底上的。
    """
    if not (isinstance(color, str) and color.startswith("#") and len(color) == 9):
        return color
    a = int(color[7:9], 16) / 255
    top = [int(color[i:i + 2], 16) for i in (1, 3, 5)]
    bottom = [int(under[i:i + 2], 16) for i in (1, 3, 5)]
    return "#%02X%02X%02X" % tuple(round(t * a + b * (1 - a)) for t, b in zip(top, bottom))


def rounded(draw, box, radius, **kw):
    draw.rounded_rectangle([v * SCALE for v in box], radius=radius * SCALE, **kw)


def draw_keyboard(skin: dict) -> Image.Image:
    preedit_h = skin["preeditHeight"]
    toolbar_h = skin["toolbarHeight"]
    keyboard_h = skin["keyboardHeight"]
    height = preedit_h + toolbar_h + keyboard_h

    ground = over(skin["keyboardBackground"]["normalColor"])
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

            # 主标签 / 副标签 / 角标都可能带 center（双行键面、右上角标），
            # 所以统一走一个函数：不写 center 就居中。
            for suffix, default_size in (("Label", 20), ("SecondaryLabel", 13), ("Badge", 10)):
                text = cell_text(skin, name, suffix)
                if not text:
                    continue
                node = skin[name + suffix]
                # 引擎先把图层 frame 按 insets 收一遍，再按 center 在收完的 frame 里定位。
                # 皮肤用「左右 / 上下取相反数」的 insets 补字形偏心（见 Button.libsonnet 的
                # inkOffsets），这里不跟着做的话，预览图上的句号还会是歪的。
                ins = node.get("insets", {})
                lx = box[0] + ins.get("left", 0)
                ly = box[1] + ins.get("top", 0)
                lw = (box[2] - box[0]) - ins.get("left", 0) - ins.get("right", 0)
                lh = (box[3] - box[1]) - ins.get("top", 0) - ins.get("bottom", 0)
                center = node.get("center", {})
                cx = lx + lw * center.get("x", 0.5)
                cy = ly + lh * center.get("y", 0.5)
                draw.text(
                    (cx * SCALE, cy * SCALE),
                    text,
                    font=load_font(int(node.get("fontSize", default_size) * SCALE), text),
                    fill=node.get("normalColor"),
                    anchor="mm",
                )
            x += width
    return img


# ===== 预览板 =====
# 键盘截图本身是长条形，直接当 demo.png 用，在应用里会被裁掉一部分。
# 统一贴到 996x770 的背景板上（与其它皮肤的 demo 同比例），顶部标皮肤名和作者。
BOARD_SIZE = (996, 770)
BOARD_SCALE = 2          # 板子也 2 倍渲染，最后缩回，文字边缘更干净
TITLE = "Gboard"
AUTHOR = "作者：morse"
SHADOW = (60, 64, 67, 60)
# 标题下面那条线取皮肤的强调色（Palette 的 accent），改配色时它跟着变
RIBBON_TOP = 157
RIBBON_HEIGHT = 6
KEYBOARD_WIDTH = 764     # 键盘预览贴在板上的宽度，高度按原图比例算
KEYBOARD_TOP = 172
KEYBOARD_RADIUS = 22


def board_palette(skin: dict) -> dict:
    """板子的配色从编译产物里读，不另写一份，改 Palette 后 demo 自动跟着变。"""
    return {
        "background": BOARD_BACKGROUND,
        "title": skin["qButtonLabel"]["normalColor"],
        "author": skin["preeditText"]["textColor"],
        "accent": skin["horizontalCandidateStyle"]["preferredTextColor"],
    }


def board_font(size: int, bold: bool = False) -> ImageFont.FreeTypeFont:
    path = Path(CJK_FONTS[0])
    if path.exists():
        try:
            return ImageFont.truetype(str(path), size, index=2 if bold else 0)
        except OSError:
            pass
    return load_font(size)


def compose_board(keyboard: Image.Image, palette: dict) -> Image.Image:
    w, h = (v * BOARD_SCALE for v in BOARD_SIZE)
    board = Image.new("RGB", (w, h), palette["background"])
    draw = ImageDraw.Draw(board)

    left = (BOARD_SIZE[0] - KEYBOARD_WIDTH) // 2 * BOARD_SCALE
    draw.text((left, 44 * BOARD_SCALE), TITLE, font=board_font(50 * BOARD_SCALE, True), fill=palette["title"])
    draw.text((left + 2, 118 * BOARD_SCALE), AUTHOR, font=board_font(26 * BOARD_SCALE), fill=palette["author"])

    # 标题下那条强调色细线，两端切成圆角
    ribbon_w = KEYBOARD_WIDTH * BOARD_SCALE
    ribbon_h = RIBBON_HEIGHT * BOARD_SCALE
    draw.rounded_rectangle(
        (left, RIBBON_TOP * BOARD_SCALE, left + ribbon_w, RIBBON_TOP * BOARD_SCALE + ribbon_h),
        ribbon_h // 2,
        fill=palette["accent"],
    )

    kw = KEYBOARD_WIDTH * BOARD_SCALE
    kh = round(kw * keyboard.height / keyboard.width)
    keyboard = keyboard.resize((kw, kh), Image.LANCZOS)
    mask = Image.new("L", (kw, kh), 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, kw - 1, kh - 1), KEYBOARD_RADIUS * BOARD_SCALE, fill=255)

    # 柔和投影，让键盘从背景色上浮起来
    pad = 30 * BOARD_SCALE
    shadow = Image.new("RGBA", (kw + pad * 2, kh + pad * 2), (0, 0, 0, 0))
    ImageDraw.Draw(shadow).rounded_rectangle(
        (pad, pad + 6 * BOARD_SCALE, pad + kw, pad + kh + 6 * BOARD_SCALE),
        KEYBOARD_RADIUS * BOARD_SCALE,
        fill=SHADOW,
    )
    shadow = shadow.filter(ImageFilter.GaussianBlur(14 * BOARD_SCALE))
    top = KEYBOARD_TOP * BOARD_SCALE
    board.paste(shadow, (left - pad, top - pad), shadow)
    board.paste(keyboard, (left, top), mask)
    return board.resize(BOARD_SIZE, Image.LANCZOS)


def main() -> int:
    if not SOURCE.exists():
        print(f"找不到 {SOURCE}，请先执行 make compile", file=sys.stderr)
        return 1
    # 产物是 JSON（JSON 是 YAML 的子集），直接用 json 读，不必依赖 PyYAML
    skin = json.loads(SOURCE.read_text(encoding="utf-8"))
    compose_board(draw_keyboard(skin), board_palette(skin)).save(OUTPUT)
    print(f"已生成 {OUTPUT.relative_to(SKIN_DIR)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
