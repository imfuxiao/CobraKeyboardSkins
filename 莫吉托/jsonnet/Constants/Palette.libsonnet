// 「莫吉托」色板 —— 全皮肤唯一的色值来源。
//
// 色值抄自 ../../README.md 的「一 主色板」「文字色」「三 深色模式」三张表，
// 改色时请两处同步（README 是给人看的说明，本文件是给编译器用的定义）。
//
// 每个色都是一对 { light, dark }：上层代码只写色名，
// 由 Components/Style.libsonnet 的 resolve() 在生成浅色 / 深色文件时二选一。
// 因此除本文件外，任何地方都不需要关心「现在是深色还是浅色」。
{
  // ===== 主色板：一条由薄荷叶背到汽水泡沫的青柠渐变 =====
  pine: { light: '#4F7A4A', dark: '#3E5C3A' },  // 松墨，最深的一档
  moss: { light: '#638A56', dark: '#4A6942' },  // 苔绿
  bamboo: { light: '#7CA265', dark: '#5A7B4C' },  // 竹青
  mint: { light: '#8CB471', dark: '#5E8A4E' },  // 薄荷，主题色
  mintDeep: { light: '#6E9E52', dark: '#4F7B40' },  // 深薄荷，强调
  lime: { light: '#9CC47C', dark: '#6B9457' },  // 青柠，杯口主光
  sprout: { light: '#A9CE84', dark: '#77A062' },  // 嫩芽
  soda: { light: '#DCEBC2', dark: '#6E7F52' },  // 苏打
  lemon: { light: '#E8EFBC', dark: '#77804A' },  // 柠檬黄
  cream: { light: '#F5F8EA', dark: '#2A3522' },  // 奶白，主键面
  fizz: { light: '#F2F6E6', dark: '#303C27' },  // 汽水白，空格
  frost: { light: '#E7EFDA', dark: '#161E14' },  // 冰砂，键盘底板
  divider: { light: '#D8E3C7', dark: '#232D1F' },  // 分割线 / 浅色键的下边缘

  // ===== 按下态 =====
  // 规则（README 五.4）：不换色相，只动明度——浅色向黑压 ~12%，深色向白提 ~12%。
  creamPressed: { light: '#E3EFCC', dark: '#3A4830' },
  fizzPressed: { light: '#E6EEDB', dark: '#3F4D34' },
  sodaPressed: { light: '#C7DCA5', dark: '#82945F' },
  sproutPressed: { light: '#95BF6C', dark: '#8AB273' },
  limePressed: { light: '#88B466', dark: '#7DA668' },
  bambooPressed: { light: '#6A9053', dark: '#6C8D5D' },
  mintPressed: { light: '#7AA25E', dark: '#709C5E' },
  mintDeepPressed: { light: '#5D8C42', dark: '#5F8C4E' },
  pinePressed: { light: '#42683E', dark: '#4E6E49' },

  // ===== 文字色 =====
  inkMint: { light: '#5C8A55', dark: '#AFD198' },  // 奶白 / 汽水白键面上的字
  inkMintSoft: { light: '#5C8A5599', dark: '#AFD19899' },  // 同上，减淡，用于角标
  inkOlive: { light: '#7A9A50', dark: '#C6D3A0' },  // 苏打 / 柠檬黄键面上的字
  inkLeaf: { light: '#F7FBEE', dark: '#EDF3E4' },  // 薄荷 / 青柠 / 嫩芽 / 竹青键面上的字
  inkPine: { light: '#E9F3E4', dark: '#D9E6D2' },  // 松墨 / 苔绿键面上的字

  // 文字的按下态：浅色压深，深色提亮，规则同上。
  inkMintPressed: { light: '#47713F', dark: '#C3DEAF' },
  inkOlivePressed: { light: '#61803C', dark: '#D3DCB4' },
  inkWhite: { light: '#FFFFFF', dark: '#FFFFFF' },
}
