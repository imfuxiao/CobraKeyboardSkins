#!/usr/bin/env python3
"""生成「胭云」皮肤的色板预览图。

色值的唯一来源是同目录上层的 README.md —— 脚本解析其中的
「主色板」「文字色」「深色模式」三张表格，因此调整颜色时
只需修改 README.md，然后重新运行本脚本即可：

    python3 scripts/gen_palette.py

依赖：Pillow（pip install Pillow）
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

SKIN_DIR = Path(__file__).resolve().parent.parent
README = SKIN_DIR / "README.md"
OUTPUT = SKIN_DIR / "资料" / "palette.png"

# README 中需要提取的小节标题 -> 图中的分组标题
SECTIONS = [
    ("主色板", "主色板 Palette", "light"),
    ("文字色", "文字色 Ink", "light"),
    ("深色模式", "深色模式 Dark", "dark"),
]

SCALE = 2  # 2 倍渲染，适配高分屏
COLS = 4
CARD_W = 252
SWATCH_H = 108
NAME_H = 26
USAGE_H = 20
CARD_H = SWATCH_H + NAME_H + USAGE_H + 10
GAP = 24
MARGIN = 40
SECTION_TITLE_H = 54
PANEL_PAD = 24

LIGHT_BG = "#F4ECE4"
LIGHT_FG = "#4A3B3F"
LIGHT_MUTED = "#96837F"
DARK_BG = "#1C1826"
DARK_FG = "#F0E4DC"
DARK_MUTED = "#8B7F94"

HEX_RE = re.compile(r"#[0-9A-Fa-f]{6}")

CJK_FONTS = [
    "/System/Library/Fonts/Hiragino Sans GB.ttc",
    "/System/Library/Fonts/STHeiti Medium.ttc",
    "/System/Library/Fonts/Supplemental/Songti.ttc",
    "/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc",
]
MONO_FONTS = [
    "/System/Library/Fonts/Menlo.ttc",
    "/System/Library/Fonts/Monaco.ttf",
    "/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf",
]


def load_font(candidates: list[str], size: int) -> ImageFont.FreeTypeFont:
    for path in candidates:
        if Path(path).exists():
            try:
                return ImageFont.truetype(path, size)
            except OSError:
                continue
    return ImageFont.load_default(size)


def parse_readme(text: str) -> list[tuple[str, str, list[tuple[str, str, str]]]]:
    """按小节抓取表格里的 (色名, 十六进制, 用途)。

    列位置不写死：一行里第一个纯 hex 单元格是色值，它之前最后一个
    非 hex 单元格是色名，之后第一个单元格是用途。
    """
    groups: list[tuple[str, str, list[tuple[str, str, str]]]] = []
    wanted = {key: (title, mode) for key, title, mode in SECTIONS}
    current: str | None = None
    rows: dict[str, list[tuple[str, str, str]]] = {}

    for line in text.splitlines():
        if line.startswith("#"):
            heading = line.lstrip("#").strip()
            current = next((k for k in wanted if k in heading), None)
            continue
        if current is None or not line.startswith("|"):
            continue

        cells = [c.replace("`", "").strip() for c in line.strip().strip("|").split("|")]
        hex_idx = next(
            (i for i, c in enumerate(cells) if HEX_RE.fullmatch(c)), None
        )
        if hex_idx is None:
            continue  # 表头、分隔行、或没有色值的行
        name = next(
            (cells[i] for i in range(hex_idx - 1, -1, -1) if cells[i] and not cells[i].isdigit()),
            "",
        )
        usage = cells[hex_idx + 1] if hex_idx + 1 < len(cells) else ""
        if usage in ("—", "-"):
            usage = ""
        rows.setdefault(current, []).append((name, cells[hex_idx].upper(), usage))

    for key, title, mode in SECTIONS:
        if rows.get(key):
            groups.append((title, mode, rows[key]))
    return groups


def ideal_text_color(hex_color: str) -> str:
    r, g, b = (int(hex_color[i : i + 2], 16) for i in (1, 3, 5))
    # sRGB 相对亮度
    lum = 0.2126 * r + 0.7152 * g + 0.0722 * b
    return "#2B2230" if lum > 150 else "#FFFFFF"


def fit(draw: ImageDraw.ImageDraw, text: str, font, max_w: int) -> str:
    """超出卡片宽度的文本截断并加省略号，避免压到相邻卡片。"""
    if not text or draw.textlength(text, font=font) <= max_w:
        return text
    ellipsis = "…"
    end = len(text)
    while end > 0 and draw.textlength(text[:end] + ellipsis, font=font) > max_w:
        end -= 1
    return text[:end] + ellipsis


def rounded(draw: ImageDraw.ImageDraw, box, radius, **kw) -> None:
    draw.rounded_rectangle(box, radius=radius, **kw)


def render(groups) -> Image.Image:
    grid_w = COLS * CARD_W + (COLS - 1) * GAP
    width = grid_w + MARGIN * 2

    # 先量高度
    height = MARGIN
    for _title, mode, rows in groups:
        nrows = (len(rows) + COLS - 1) // COLS
        block = SECTION_TITLE_H + nrows * CARD_H + (nrows - 1) * GAP
        height += block + (PANEL_PAD * 2 if mode == "dark" else 0) + GAP * 2
    height += MARGIN - GAP * 2

    s = SCALE
    img = Image.new("RGB", (width * s, height * s), LIGHT_BG)
    draw = ImageDraw.Draw(img)

    f_section = load_font(CJK_FONTS, 26 * s)
    f_name = load_font(CJK_FONTS, 17 * s)
    f_usage = load_font(CJK_FONTS, 13 * s)
    f_hex = load_font(MONO_FONTS, 18 * s)

    y = MARGIN
    for title, mode, rows in groups:
        nrows = (len(rows) + COLS - 1) // COLS
        block_h = SECTION_TITLE_H + nrows * CARD_H + (nrows - 1) * GAP
        fg, muted = (LIGHT_FG, LIGHT_MUTED) if mode == "light" else (DARK_FG, DARK_MUTED)

        if mode == "dark":
            rounded(
                draw,
                [
                    (MARGIN - PANEL_PAD) * s,
                    y * s,
                    (width - MARGIN + PANEL_PAD) * s,
                    (y + block_h + PANEL_PAD * 2) * s,
                ],
                18 * s,
                fill=DARK_BG,
            )
            y += PANEL_PAD

        draw.text((MARGIN * s, y * s), title, font=f_section, fill=fg)
        y += SECTION_TITLE_H

        for i, (name, hex_color, usage) in enumerate(rows):
            col, row = i % COLS, i // COLS
            x = MARGIN + col * (CARD_W + GAP)
            cy = y + row * (CARD_H + GAP)

            rounded(
                draw,
                [x * s, cy * s, (x + CARD_W) * s, (cy + SWATCH_H) * s],
                12 * s,
                fill=hex_color,
                outline="#00000018",
                width=max(1, s // 2),
            )
            draw.text(
                (x * s + 14 * s, (cy + SWATCH_H) * s - 14 * s),
                hex_color,
                font=f_hex,
                fill=ideal_text_color(hex_color),
                anchor="ls",
            )
            draw.text(
                (x * s, (cy + SWATCH_H + 8) * s),
                fit(draw, name, f_name, CARD_W * s),
                font=f_name,
                fill=fg,
            )
            if usage:
                draw.text(
                    (x * s, (cy + SWATCH_H + 8 + NAME_H) * s),
                    fit(draw, usage, f_usage, CARD_W * s),
                    font=f_usage,
                    fill=muted,
                )

        y += nrows * CARD_H + (nrows - 1) * GAP
        y += PANEL_PAD + GAP * 2 if mode == "dark" else GAP * 2

    return img


def main() -> int:
    if not README.exists():
        print(f"找不到 {README}", file=sys.stderr)
        return 1

    groups = parse_readme(README.read_text(encoding="utf-8"))
    missing = [key for key, _t, _m in SECTIONS if not any(t == _t for t, _m2, _r in groups)]
    if missing:
        print(f"README.md 中未找到这些小节的表格：{missing}", file=sys.stderr)
        return 1

    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    render(groups).save(OUTPUT)
    total = sum(len(rows) for _t, _m, rows in groups)
    print(f"已生成 {OUTPUT.relative_to(SKIN_DIR)}（{total} 个色值，{len(groups)} 组）")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
