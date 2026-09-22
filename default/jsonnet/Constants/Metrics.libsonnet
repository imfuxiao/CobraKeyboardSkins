// 几何尺寸表：高度、内边距、圆角。
//
// 宽度一律写成分数（'112.5/1125'、'1.1/16'），是「占父容器的多少」，天然跨设备；
// 这里的点值则是按 iPhone 竖屏 390pt / iPad 横屏 1024pt 调出来的。
local fonts = import 'Fonts.libsonnet';

{
  preedit: {
    height: 25,
    insets: { top: 2, left: 4 },
    fontSize: fonts.preedit,
  },

  toolbar: {
    height: 40,
  },

  // 按键区总高。iPad 拼音 / 数字都是五行，第一行（数字行）单独矮一档，
  // 所以总高 = 四行正常行高 + 第一行行高。
  keyboardHeight: {
    iPhone: { portrait: 216, landscape: 160 },  // 54 * 4 / 40 * 4
    iPad: { portrait: 311, landscape: 414 },  // 64 * 4 + 55 / 86 * 4 + 70
  },

  // iPad 第一行（数字行）的高度
  iPadFirstRowHeight: { portrait: 55, landscape: 70 },

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
    cornerRadius: 8.5,
    // 双行键面（上标 + 下标）的位置：0 是键面顶边，1 是底边
    upperLabelCenter: { y: 0.3 },
    lowerLabelCenter: { y: 0.65 },
  },

  // 短按气泡。iPhone 上给定尺寸，iPad 上跟随按键自身大小（留空）。
  hint: {
    cornerRadius: 10,
    iPhoneSize: { width: 50, height: 50 },
  },

  // iPad 屏宽富余，预编辑区与候选栏两侧留白，视线不用扫过整个屏幕
  iPadSideInsets: { top: 0, bottom: 0, left: 200, right: 200 },
}
