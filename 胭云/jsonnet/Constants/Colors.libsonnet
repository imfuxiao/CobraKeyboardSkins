// 「胭云」的用色规则 —— 回答「哪个色用在哪」，不定义任何新色值。
//
// 与 Palette 的分工：
//   Palette.libsonnet  有哪些颜色
//   Colors.libsonnet   这些颜色怎么用
//
// 换肤只需改这两个文件，Components/ 与 Keyboards/ 下的代码一律不必动。
local P = import 'Palette.libsonnet';

{
  // ===== 按键角色 =====
  // 对应 README「二 区域映射」表的每一行。一个角色 = 一套完整的按键配色，
  // 按键只声明自己属于哪个角色，不直接引用色板。
  //
  //   fill        常态底色
  //   pressed     按下底色
  //   edge        底部立体边缘（默认与按下色同族，浅色键改用纸底色更暖）
  //   ink         常态字色 / 图标色
  //   inkPressed  按下字色
  //   inkSoft     角标字色，可省略，省略时退回 ink
  roles: {
    letter: { fill: P.cloud, pressed: P.cloudPressed, edge: P.divider, ink: P.inkCarmine, inkPressed: P.inkCarminePressed, inkSoft: P.inkCarmineSoft },
    space: { fill: P.paper, pressed: P.paperPressed, edge: P.divider, ink: P.inkCarmine, inkPressed: P.inkCarminePressed },
    shift: { fill: P.amber, pressed: P.amberPressed, edge: P.amberPressed, ink: P.inkCloud, inkPressed: P.inkWhite },
    backspace: { fill: P.mauve, pressed: P.mauvePressed, edge: P.mauvePressed, ink: P.inkCloud, inkPressed: P.inkWhite },
    enter: { fill: P.coral, pressed: P.coralPressed, edge: P.coralPressed, ink: P.inkCloud, inkPressed: P.inkWhite },
    // 回车键在「前往 / 搜索 / 发送」等场景下换成深胭脂，用色板里最重的一档作强调。
    enterAccent: { fill: P.carmineDeep, pressed: P.carmineDeepPressed, edge: P.carmineDeepPressed, ink: P.inkCloud, inkPressed: P.inkWhite },
    symbol: { fill: P.sand, pressed: P.sandPressed, edge: P.sandPressed, ink: P.inkSand, inkPressed: P.inkSandPressed },
    // 数字键盘上的运算符（=、+ 之类），用色板里最重的一档把它从数字堆里拎出来
    operator: { fill: P.carmineDeep, pressed: P.carmineDeepPressed, edge: P.carmineDeepPressed, ink: P.inkCloud, inkPressed: P.inkWhite },
    // 紫色只给低频功能键（README 五.3）：中英切换、收起键盘、Tab。
    functional: { fill: P.night, pressed: P.nightPressed, edge: P.nightPressed, ink: P.inkNight, inkPressed: P.inkWhite },
  },

  // ===== 区域配色 =====
  // 键盘底板。想让皮肤透出系统键盘背景（iOS 26 起系统自带圆角背景），
  // 把它改成 { light: '#FFFFFF03', dark: '#00000003' } 即可，其余不用动。
  keyboardBackground: P.canvas,
  preeditText: P.inkCarmine,
  divider: P.divider,  // 分割线 / 面板里的分隔线

  // 短按气泡
  hint: {
    fill: P.cloud,
    border: P.divider,
    ink: P.inkCarmine,
  },

  // 工具栏图标（命令菜单、收起键盘、候选栏翻页等）
  toolbarIcon: {
    normal: P.inkCarmine,
    pressed: P.inkCarminePressed,
  },

  // 候选栏
  candidate: {
    text: P.inkCarmine,
    comment: P.inkSand,
    index: P.inkCarmineSoft,
    pressedBackground: P.cloudPressed,
    // 首选候选字做成一颗胭脂色药丸
    preferredBackground: P.carmine,
    preferredText: P.inkCloud,
    preferredComment: P.inkCloud,
    preferredIndex: P.inkCloud,
    separator: P.divider,
  },
}
