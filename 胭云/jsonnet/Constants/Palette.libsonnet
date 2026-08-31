// 「胭云」色板 —— 全皮肤唯一的色值来源。
//
// 色值抄自 ../../README.md 的「一 主色板」「文字色」「三 深色模式」三张表，
// 改色时请两处同步（README 是给人看的说明，本文件是给编译器用的定义）。
//
// 每个色都是一对 { light, dark }：上层代码只写色名，
// 由 Components/Style.libsonnet 的 resolve() 在生成浅色 / 深色文件时二选一。
// 因此除本文件外，任何地方都不需要关心「现在是深色还是浅色」。
{
  // ===== 主色板：一条由夜入昼的暮云渐变 =====
  night: { light: '#7A6CA0', dark: '#4B4270' },  // 夜紫，最深的一档
  dusk: { light: '#8D80A4', dark: '#5A4F72' },  // 暮紫
  mauve: { light: '#C491A2', dark: '#7B5A6B' },  // 藕粉紫
  carmine: { light: '#D78997', dark: '#8E5A68' },  // 胭脂，主题色
  carmineDeep: { light: '#D67891', dark: '#7E4C5B' },  // 深胭脂，强调
  coral: { light: '#F29B94', dark: '#A2635E' },  // 珊瑚，日落主光
  amber: { light: '#F8B194', dark: '#A8735D' },  // 蜜橙，霞光
  sand: { light: '#FAE0C5', dark: '#8C7458' },  // 暖沙
  moon: { light: '#F1E2C3', dark: '#7E6B4E' },  // 月奶油
  cloud: { light: '#FBF6F1', dark: '#332C3F' },  // 云白，主键面
  paper: { light: '#F8F7F0', dark: '#3A3347' },  // 纸白，空格
  canvas: { light: '#F4ECE4', dark: '#1C1826' },  // 纸底，键盘底板
  divider: { light: '#E7D9CE', dark: '#2C2536' },  // 分割线 / 浅色键的下边缘

  // ===== 按下态 =====
  // 规则（README 五.4）：不换色相，只动明度——浅色向黑压 ~12%，深色向白提 ~12%。
  cloudPressed: { light: '#F0DCDC', dark: '#453B54' },
  paperPressed: { light: '#EFE4DC', dark: '#4A4159' },
  sandPressed: { light: '#EFCBA9', dark: '#A08765' },
  amberPressed: { light: '#EC9A78', dark: '#B28470' },
  coralPressed: { light: '#E08079', dark: '#AD7671' },
  mauvePressed: { light: '#AE7A8D', dark: '#8B6E7D' },
  carminePressed: { light: '#C4718A', dark: '#9C6E7A' },
  carmineDeepPressed: { light: '#BE6480', dark: '#8D616F' },
  nightPressed: { light: '#665A88', dark: '#615981' },

  // ===== 文字色 =====
  inkCarmine: { light: '#C4718A', dark: '#E7A0B0' },  // 云白 / 纸白键面上的字
  inkCarmineSoft: { light: '#C4718A99', dark: '#E7A0B099' },  // 同上，减淡，用于角标
  inkSand: { light: '#D98A7D', dark: '#E0B79A' },  // 暖沙 / 月奶油键面上的字
  inkCloud: { light: '#FDF3EC', dark: '#F0E4DC' },  // 胭脂 / 珊瑚 / 蜜橙 / 藕粉紫键面上的字
  inkNight: { light: '#EDE7F2', dark: '#DCD3E6' },  // 夜紫 / 暮紫键面上的字

  // 文字的按下态：浅色压深，深色提亮，规则同上。
  inkCarminePressed: { light: '#B0607A', dark: '#EDB8C4' },
  inkSandPressed: { light: '#C4705F', dark: '#E8C9B3' },
  inkWhite: { light: '#FFFFFF', dark: '#FFFFFF' },
}
