// 「Gboard」的用色规则 —— 回答「哪个色用在哪」，不定义任何新色值。
//
// 与 Palette 的分工：
//   Palette.libsonnet  有哪些颜色（换配色改这里）
//   Colors.libsonnet   这些颜色怎么用（换用色规则改这里）
//
// Gboard 的配色规则只有一句话：**键分两种，白的和灰的**。
// 白的是「会上屏的字」——字母、数字、符号、空格；
// 灰的是「改变键盘状态的」——Shift 位、删除、?123、返回、标点。
// 整块键盘上只有一颗彩色键——回车，它走 iOS systemBlue；
// Google Blue 不落在按键上，只出现在候选栏首选、工具栏图标按下态与长按网格的选中格。
//
// 每个角色都要给齐这五项，Components/Theme.libsonnet 照着它拼样式节点：
//   fill        常态底色
//   pressed     按下底色
//   ink         常态字色 / 图标色
//   inkPressed  按下字色
//   inkSoft     角标（上划符号）字色
//   pill        true 表示这颗键用胶囊圆角（半径 = 键高的一半），默认小圆角
local P = import 'Palette.libsonnet';

{
  roles: {
    // 白键：字母、数字、符号。Gboard 里键面上会上屏的东西一律是白的。
    letter: {
      fill: P.letterFill,
      pressed: P.letterPressed,
      ink: P.label,
      inkPressed: P.labelPressed,
      // 角标（第一行的 1~0、其余键的上划符号）比主标签淡一档，
      // 这是 Gboard 最好认的一处细节：一颗键上两级字重。
      inkSoft: P.labelMuted,
    },

    // 空格：也是白键，与字母键完全同色。键面写的是方案名（$rimeSchemaName）。
    space: {
      fill: P.letterFill,
      pressed: P.letterPressed,
      ink: P.labelMuted,
      inkPressed: P.label,
      inkSoft: P.labelMuted,
    },

    // 灰键：Shift 位的分词键、删除、?123 / =\< / !?#、标点、九宫格右列。
    // 'function' 在 jsonnet 里是关键字，字段名要加引号
    'function': {
      fill: P.functionFill,
      pressed: P.functionPressed,
      ink: P.label,
      inkPressed: P.labelPressed,
      inkSoft: P.labelMuted,
    },

    // 胶囊灰键：最后一行两端的那两颗——左边是 ?123 / 「返回」，右边是回车。
    // 它们是整块键盘上唯一带全圆角的键——Gboard 靠这个形状把最后一行的两端拎出来。
    pill: {
      fill: P.functionFill,
      pressed: P.functionPressed,
      ink: P.label,
      inkPressed: P.labelPressed,
      inkSoft: P.labelMuted,
      pill: true,
    },

    // 胶囊主色键：回车。整块键盘上唯一的彩色键面，**不随 returnKeyType 换色**——
    // 常态与「前往 / 搜索 / 发送 / 完成」都是 iOS systemBlue，只换键面上的字。
    primary: {
      fill: P.primary,
      pressed: P.primaryPressed,
      ink: P.labelOnPrimary,
      inkPressed: P.labelOnPrimary,
      inkSoft: P.labelOnPrimary,
      pill: true,
    },

    // 九宫格左侧的符号栏：一条灰底，内容由引擎填（App 内「数字键盘符号」设置）。
    // 单独立一个角色是因为它要的是**大圆角的一整条**，不是一颗键。
    symbolStrip: {
      fill: P.functionFill,
      pressed: P.functionPressed,
      ink: P.label,
      inkPressed: P.labelPressed,
      inkSoft: P.labelMuted,
    },
  },

  // ===== 区域配色 =====
  // 按键区 / 预编辑区 / 工具栏区 / 纵排候选栏共用这一份：几乎全透明，
  // 底交给系统键盘自己画，见 Palette 的 keyboardBackdrop。
  keyboardBackground: P.keyboardBackdrop,
  preeditText: P.preeditText,
  divider: P.divider,

  hint: {
    fill: P.hintFill,
    ink: P.hintLabel,
    shadow: P.hintShadow,
    border: P.hintBorder,
  },

  // 长按符号网格：一块白面板 + 一个强调色的高亮格
  hintGrid: {
    fill: P.hintGridFill,
    ink: P.hintGridLabel,
    shadow: P.hintShadow,
    border: P.hintBorder,
    selectedFill: P.hintGridSelectedFill,
    selectedInk: P.hintGridSelectedLabel,
  },

  toolbarIcon: {
    normal: P.toolbarIcon,
    pressed: P.toolbarIconPressed,
  },

  candidate: {
    text: P.candidateText,
    comment: P.candidateComment,
    index: P.candidateIndex,
    pressedBackground: P.candidatePressed,
    // Gboard 的首选不加药丸，只染成强调色；这里把「药丸色」设成底板色等于不画。
    preferredBackground: P.candidatePreferredBackground,
    preferredText: P.candidatePreferredText,
    preferredComment: P.candidatePreferredComment,
    preferredIndex: P.candidatePreferredIndex,
    separator: P.divider,
  },
}
