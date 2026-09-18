// 「Noctua」的用色规则 —— 回答「哪个色用在哪」，不定义任何新色值。
//
// 与 Palette 的分工：
//   Palette.libsonnet  有哪些颜色（换配色改这里）
//   Colors.libsonnet   这些颜色怎么用（换用色规则改这里）
//
// ===== 规则一句话：米色的会上屏，沙色的换状态，棕色的最重要 =====
//
// 这是从风扇本身读出来的三档，不是凭空定的：
// 那只扇子的面积大头是米白的框体（对应键面），棕色只出现在扇叶与四角减震垫上
// （对应 Shift / 删除 / 回车这几颗最重的键），中间还有一档介于两者之间的过渡
// （对应功能键）。所以整块键盘上棕色键只有三颗，其余全是米与沙 —— 棕多了就腻。
//
// 每个角色都要给齐这六项，Components/Theme.libsonnet 照着它拼样式节点：
//   fill        常态底色
//   pressed     按下底色
//   edge        底部立体边缘（键帽的厚度，风扇是注塑件，键帽也该有厚度）
//   ink         常态字色 / 图标色
//   inkPressed  按下字色
//   inkSoft     角标（上划符号）字色
local P = import 'Palette.libsonnet';

{
  roles: {
    // 米键：字母、数字、符号、标点。会上屏的东西一律是米白的。
    letter: {
      fill: P.letterFill,
      pressed: P.letterPressed,
      edge: P.letterEdge,
      ink: P.label,
      inkPressed: P.labelPressed,
      // 角标（第一行的 1~0、其余键的上划符号）比主标签淡一档：一颗键上两级字重。
      inkSoft: P.labelMuted,
    },

    // 空格：也是米键，比字母键退一成（见 Palette 的 spaceFill）。
    // 它是一整条而不是一颗键，退这一档才读得出是另一块地方。
    // 键面写的是当前方案名（$rimeSchemaName）。
    space: {
      fill: P.spaceFill,
      pressed: P.spacePressed,
      edge: P.spaceEdge,
      ink: P.labelMuted,
      inkPressed: P.label,
      inkSoft: P.labelMuted,
    },

    // 沙键：123 / 中英 / ?123 / =\< / 返回 / 逗号句号 / 九宫格右列。
    //
    // **它与底板的明度差是这套配色最容易出事的一处**：沙键本来就介于底板与键面之间，
    // 两头各让一点就会贴上底板，深色模式下尤其明显（暗处的明度差本来就难分）。
    // 改 Palette 的 canvas / functionFill 时对着预览图确认这一档还看得出边界。
    //
    // 'function' 在 jsonnet 里是关键字，字段名要加引号。
    'function': {
      fill: P.functionFill,
      pressed: P.functionPressed,
      edge: P.functionEdge,
      ink: P.label,
      inkPressed: P.labelPressed,
      inkSoft: P.labelMuted,
    },

    // 主棕键：Shift 与删除，也就是第三行两端那两颗。
    // 对应风扇四角的减震垫——一整片米白里，棕色只钉在角上。
    accent: {
      fill: P.brown,
      pressed: P.brownPressed,
      edge: P.brownEdge,
      ink: P.labelOnBrown,
      inkPressed: P.labelOnBrownPressed,
      inkSoft: P.labelOnBrown,
    },

    // 深棕键：回车。整块键盘上最重的一档，**不随 returnKeyType 换色**，
    // 常态与「前往 / 搜索 / 发送 / 完成」都是这一个棕，只换键面上的字。
    primary: {
      fill: P.brownDeep,
      pressed: P.brownDeepPressed,
      edge: P.brownDeepEdge,
      ink: P.labelOnBrown,
      inkPressed: P.labelOnBrownPressed,
      inkSoft: P.labelOnBrown,
    },

    // 九宫格左侧的符号栏：一条沙色底，内容由引擎填（App 内「数字键盘符号」设置）。
    // 单独立一个角色是因为它要的是**一整条**，不是一颗键，将来想单独调它不必动功能键。
    symbolStrip: {
      fill: P.functionFill,
      pressed: P.functionPressed,
      edge: P.functionEdge,
      ink: P.label,
      inkPressed: P.labelPressed,
      inkSoft: P.labelMuted,
    },
  },

  // ===== 区域配色 =====
  // 按键区铺满底板色；工具栏区由它向上渐隐；预编辑区整条都是渐隐色。
  // 为什么要渐隐见 Components/Theme.libsonnet 的「工具栏区的向上渐隐」一节。
  keyboardBackground: P.canvas,
  preeditText: P.preeditText,
  divider: P.divider,

  hint: {
    fill: P.hintFill,
    ink: P.hintLabel,
    shadow: P.hintShadow,
    border: P.hintBorder,
  },

  // 长按符号网格：一块米色面板 + 一个主棕的高亮格
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
    // 首选做成一颗主棕药丸——棕是这只风扇最跳的那一档
    preferredBackground: P.candidatePreferredBackground,
    preferredText: P.candidatePreferredText,
    preferredComment: P.candidatePreferredComment,
    preferredIndex: P.candidatePreferredIndex,
    separator: P.divider,
  },

  // 供 Theme 派生渐隐色时用，见那里的说明
  withAlpha: P.withAlpha,
}
