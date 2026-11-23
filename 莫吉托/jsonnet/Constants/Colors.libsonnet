// 「莫吉托」的用色规则 —— 回答「哪个色用在哪」，不定义任何新色值。
//
// 与 Palette 的分工：
//   Palette.libsonnet  有哪些颜色
//   Colors.libsonnet   这些颜色怎么用
//
// 换肤只需改这两个文件，Components/ 与 Keyboards/ 下的代码一律不必动。
local Options = import 'Options.libsonnet';
local P = import 'Palette.libsonnet';

{
  // ===== 按键角色 =====
  // 对应 README「二 区域映射」表的每一行。一个角色 = 一套完整的按键配色，
  // 按键只声明自己属于哪个角色，不直接引用色板。
  //
  //   fill        常态底色
  //   pressed     按下底色
  //   edge        底部立体边缘（默认与按下色同族，浅色键改用冰砂色更柔）
  //   ink         常态字色 / 图标色
  //   inkPressed  按下字色
  //   inkSoft     角标字色，可省略，省略时退回 ink
  roles: {
    letter: { fill: P.cream, pressed: P.creamPressed, edge: P.divider, ink: P.inkMint, inkPressed: P.inkMintPressed, inkSoft: P.inkMintSoft },
    space: { fill: P.fizz, pressed: P.fizzPressed, edge: P.divider, ink: P.inkMint, inkPressed: P.inkMintPressed },
    shift: { fill: P.sprout, pressed: P.sproutPressed, edge: P.sproutPressed, ink: P.inkLeaf, inkPressed: P.inkWhite },
    backspace: { fill: P.bamboo, pressed: P.bambooPressed, edge: P.bambooPressed, ink: P.inkLeaf, inkPressed: P.inkWhite },
    enter: { fill: P.lime, pressed: P.limePressed, edge: P.limePressed, ink: P.inkLeaf, inkPressed: P.inkWhite },
    // 回车键在「前往 / 搜索 / 发送」等场景下换成深薄荷，用色板里最重的一档作强调。
    enterAccent: { fill: P.mintDeep, pressed: P.mintDeepPressed, edge: P.mintDeepPressed, ink: P.inkLeaf, inkPressed: P.inkWhite },
    symbol: { fill: P.soda, pressed: P.sodaPressed, edge: P.sodaPressed, ink: P.inkOlive, inkPressed: P.inkOlivePressed },
    // 数字键盘上的运算符（=、+ 之类），用色板里最重的一档把它从数字堆里拎出来
    operator: { fill: P.mintDeep, pressed: P.mintDeepPressed, edge: P.mintDeepPressed, ink: P.inkLeaf, inkPressed: P.inkWhite },
    // 松墨只给低频功能键（README 五.3）：中英切换、收起键盘、Tab。
    functional: { fill: P.bamboo, pressed: P.bambooPressed, edge: P.bambooPressed, ink: P.inkPine, inkPressed: P.inkWhite },
  },

  // ===== 区域配色 =====
  // 键盘底板。想让皮肤透出系统键盘背景（iOS 26 起系统自带圆角背景），
  // 把它改成 { light: '#FFFFFF03', dark: '#00000003' } 即可，其余不用动。
  keyboardBackground: P.frost,
  // 工具栏区与预编辑区用的「渐隐色」不在这里单列：它就是上面这个底板色配一档
  // 极低的透明度，由 Components/Theme.libsonnet 派生，改了底板色它自动跟着变。
  preeditText: P.inkMint,
  divider: P.divider,  // 分割线 / 面板里的分隔线

  // 短按气泡
  hint: {
    fill: P.cream,
    border: P.divider,
    ink: P.inkMint,
    selectedFill: P.mintDeepPressed,
    selectedInk: P.inkLeaf,
  },

  // 工具栏图标（命令菜单、收起键盘、候选栏翻页等）
  toolbarIcon: {
    normal: P.inkMint,
    pressed: P.inkMintPressed,
  },

  // iOS 版（Options.gradient）不设底色以透出系统内置背景，避免与 iOS 26+ 顶部 17px 圆角区割裂；
  // 纯色版（Android）铺冰砂 / 深墨绿底板。
  // 候选字与未展开的横排候选栏完全一致（薄荷字 + 薄荷药丸 + 淡绿按压）；
  // 首笔、范围分段与工具图标字号较小，采用深一档的薄荷按压字与深薄荷胶囊，在系统内置背景上更清晰。
  filterPanel: (if Options.gradient then {} else { backgroundColor: P.frost }) + {
    textColor: P.inkMint,
    selected: { backgroundColor: P.mint, textColor: P.inkLeaf },
    pressed: { backgroundColor: P.creamPressed, textColor: P.inkMint },
    stroke: {
      textColor: P.inkMintPressed,
      selected: { backgroundColor: P.mintDeepPressed, textColor: P.inkLeaf },
      pressed: { backgroundColor: P.creamPressed, textColor: P.inkMintPressed },
    },
    tool: {
      textColor: P.inkMintPressed,
      selected: { backgroundColor: P.mintDeepPressed, textColor: P.inkLeaf },
      pressed: { backgroundColor: P.creamPressed, textColor: P.inkMintPressed },
    },
    heading: { textColor: P.inkMint },
  },

  // 候选栏
  candidate: {
    text: P.inkMint,
    comment: P.inkOlive,
    index: P.inkMintSoft,
    pressedBackground: P.creamPressed,
    // 首选候选字做成一颗薄荷色药丸
    preferredBackground: P.mint,
    preferredText: P.inkLeaf,
    preferredComment: P.inkLeaf,
    preferredIndex: P.inkLeaf,
    separator: P.divider,
  },
}
