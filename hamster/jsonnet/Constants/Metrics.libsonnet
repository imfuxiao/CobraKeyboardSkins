// 纯数字常量：高度、内边距、候选栏尺寸。不含颜色、不含按键动作。
local fonts = import 'Fonts.libsonnet';

{
  preedit: {
    height: 25,
    insets: { top: 2, left: 4 },
    fontSize: fonts.preeditFontSize,
  },

  toolbar: { height: 40 },

  candidate: {
    horizontalInsets: { top: 8, left: 3, bottom: 1 },
    verticalInsets: { top: 8, bottom: 8, left: 8, right: 8 },
    cellInsets: { left: 6, right: 6, top: 4, bottom: 4 },
    verticalMaxRows: 5,
    verticalMaxColumns: 6,
    verticalBottomRowHeight: 45,
  },

  // iPad 屏宽富余：预编辑区、候选栏两侧收窄留白
  iPadSideInsets: { top: 0, bottom: 0, left: 200, right: 200 },

  keyboardHeight: {
    iPhone: { portrait: 216, landscape: 160 },  // 54 * 4 / 40 * 4
    iPad: { portrait: 311, landscape: 414 },  // 64 * 4 + 55 / 86 * 4 + 70
  },

  keyInsets: {
    iPhone: {
      portrait: { top: 4, left: 3, bottom: 4, right: 3 },
      landscape: { top: 3, left: 3, bottom: 3, right: 3 },
    },
    iPad: {
      portrait: { top: 3, left: 3, bottom: 3, right: 3 },
      landscape: { top: 4, left: 6, bottom: 4, right: 6 },
    },
  },

  iPadFirstRowHeight: { portrait: 55, landscape: 70 },

  hint: {
    iPhoneSize: { width: 50, height: 50 },
  },

  // 长按符号网格：长按字母键时键的上方弹出的一行备选字符
  hintGrid: {
    cell: { width: 36, height: 42 },
    spacing: { horizontal: 3, vertical: 3 },
    insets: { top: 5, left: 5, bottom: 5, right: 5 },
    cornerRadius: 10,
    cellCornerRadius: 6,
    borderSize: 0.5,
    // 面板默认贴着按键上沿，再抬高一点，免得手指盖住格子
    offset: { x: 0, y: -6 },
    // 手指抖动小于这个距离时维持初始高亮，不误选
    moveThreshold: 8,
  },
}
