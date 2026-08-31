// 几何尺寸表。
//
// 注意：以 point 为单位的值（高度、内边距、圆角、气泡尺寸）必须按同一个屏宽换算，
// 本皮肤统一按 iPhone 竖屏 390pt / iPad 竖屏 834pt 调。宽度一律用分数，天然跨设备。
{
  preedit: {
    height: 25,
    insets: { top: 2, left: 4 },
  },

  toolbar: {
    height: 40,
  },

  // 按键区高度（固定点值，不随屏宽缩放）
  keyboardHeight: {
    iPhone: { portrait: 216, landscape: 160 },
    iPad: { portrait: 311, landscape: 414 },
  },

  // 按键背景相对触摸区收缩的边距，决定键与键之间的缝隙
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

  key: {
    cornerRadius: 9,
    // 角标（上划符号）在键面中的位置，0 是顶边、1 是底边
    badgeCenter: { y: 0.2 },
  },

  hint: {
    size: { width: 50, height: 50 },
    cornerRadius: 12,
    borderSize: 0.5,
  },

  candidate: {
    cornerRadius: 6,
    horizontalInsets: { top: 8, left: 3, bottom: 1 },
    verticalInsets: { top: 6, left: 6, bottom: 6, right: 6 },
    cellInsets: { top: 4, left: 6, bottom: 4, right: 6 },
    expandButtonWidth: 44,
    verticalBottomRowHeight: 45,
    verticalMaxRows: 5,
    verticalMaxColumns: 6,
  },

  // iPad 屏宽富余，候选区两侧留白
  iPadSideInsets: { top: 0, bottom: 0, left: 200, right: 200 },
}
