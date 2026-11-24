// 几何尺寸表：高度、内边距、圆角、列宽及长按网格尺寸。
local fonts = import 'Fonts.libsonnet';

{
  preedit: {
    height: 25,
    insets: { top: 2, left: 4 },
    fontSize: fonts.preedit,
  },

  toolbar: {
    height: 40,
    buttonWidth: 44,
  },

  candidates: {
    horizontalInsets: { top: 8, left: 3, bottom: 1 },
    verticalInsets: { top: 8, bottom: 8, left: 8, right: 8 },
    verticalCellInsets: { top: 4, left: 6, bottom: 4, right: 6 },
    verticalMaxRows: 5,
    verticalMaxColumns: 6,
    verticalBottomRowHeight: 45,
  },

  // 按键区总高（4 行）
  keyboardHeight: {
    portrait: 216,  // 54 * 4
    landscape: 160,  // 40 * 4
  },

  // 按键背景相对触摸区收缩的边距
  keyInsets: {
    portrait: { top: 3, left: 3, bottom: 3, right: 3 },
    landscape: { top: 3, left: 3, bottom: 3, right: 3 },
  },

  key: {
    cornerRadius: 8.5,
    topBadgeCenter: { y: 0.2 },
    rightBadgeCenter: { x: 0.85, y: 0.25 },
  },

  // 短按气泡（26 键英文页）
  hint: {
    cornerRadius: 10,
    size: { width: 50, height: 50 },
  },

  // 九键长按符号网格：兼容最多 9 项（7 / 9 键），在窄屏与横屏下均可完整显示
  hintGrid: {
    cornerRadius: 10,
    selectedCornerRadius: 6,
    cell: {
      portrait: { width: 32, height: 38 },
      landscape: { width: 30, height: 34 },
    },
    spacing: { horizontal: 2, vertical: 2 },
    insets: { top: 4, left: 4, bottom: 4, right: 4 },
    offset: { x: 0, y: 0 },
    moveStep: { horizontal: 24, vertical: 24 },
    moveThreshold: 8,
  },

  // 九键与数字键盘的列宽比例
  stacks: {
    halfWidth: 0.45,
    narrowWidth: 0.17,
    wideWidth: 0.22,
  },
}
