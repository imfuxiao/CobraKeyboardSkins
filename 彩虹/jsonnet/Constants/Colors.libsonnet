// 「彩虹」的用色规则 —— 回答「哪个色用在哪」，不定义任何新色值。
//
// 与 Palette 的分工：
//   Palette.libsonnet  有哪些颜色
//   Colors.libsonnet   这些颜色怎么用
//
// 换肤只需改这两个文件，Components/ 与 Keyboards/ 下的代码一律不必动。
//
// ===== 本皮肤的用色规则和另外两套不一样 =====
// 「莫吉托」「胭云」是一条深浅渐变，一个按键属于哪个角色就定死了颜色。
// 「彩虹」的灵感是 Apple Watch 彩虹表带上那些**竖条纹**，所以拆成正交的两问：
//
//   色相（哪一档彩虹）  只看这颗键在键盘上的**水平位置**，与它是什么键、在第几行无关
//   处理（怎么用这个色）由按键的角色决定：白键面 / 纯色 / 淡彩 / 墨色
//
// 于是一个角色名就是「处理 + 色相」，例如 plainAzure（天蓝那一列的白键面）、
// solidViolet（最右一列的纯紫功能键）。角色表由下面两个循环乘出来，不手写。
local P = import 'Palette.libsonnet';

// ===== 五种处理 =====
// 每种处理都是一个函数：给它一档色相，还回一套完整的按键配色。
//
//   fill        常态底色
//   pressed     按下底色
//   edge        底部立体边缘
//   ink         常态字色 / 图标色
//   inkPressed  按下字色
//   inkSoft     角标字色，可省略，省略时退回 ink
local treatments = {
  // 白键面：字母、数字、标点。底色始终是云白——大面积留白是表带的白尼龙，
  // 色相全部交给键面上的字：主标签、右上角的角标、下边缘那道细线，
  // 以及按下时透出的一层淡彩。
  //
  // 这里不写 inkSoft（角标色）：省略时 Theme 会退回 ink，
  // 于是**主标签与它的上划符号永远同色**——看到什么颜色的字母，上划出来的就是那个颜色的符号。
  plain(h): {
    fill: P.cloud,
    pressed: h.face,
    edge: h.rim,
    ink: h.chroma,
    inkPressed: h.inkDeep,
  },
  // 空格：与白键面同一套，底色换成略冷的纸白
  space(h): self.plain(h) { fill: P.paper },
  // 纯色：Shift、删除、回车、运算符。整颗键就是那一档彩虹。
  solid(h): {
    fill: h.base,
    pressed: h.basePressed,
    edge: h.basePressed,
    ink: P.inkOnColor,
    inkPressed: P.inkWhite,
  },
  // 淡彩：123、#+=、返回、Tab、候选栏翻页。比白键重、比纯色轻的中间档。
  pale(h): {
    fill: h.pale,
    pressed: h.palePressed,
    edge: h.palePressed,
    ink: h.inkDeep,
    inkPressed: h.inkDeep,
  },
  // 墨色：中英切换、收起键盘、地球键。整块键盘上最重的一档，
  // 对应表带上那两条黑与棕的包容色条；墨里掺一点所在列的色相，深块也跟着竖条纹走。
  stone(h): {
    fill: h.stone,
    pressed: h.stonePressed,
    edge: h.stonePressed,
    ink: P.inkOnColor,
    inkPressed: P.inkWhite,
  },
};

local capitalize(name) = std.asciiUpper(name[0]) + std.substr(name, 1, std.length(name) - 1);
local roleName(treatment, hue) = treatment + capitalize(hue);

// 水平位置 -> 色相。center 是这颗键的中心占整行宽度的比例（0 最左，1 最右）。
// 十档色相正好对应第一行十个字母键，所以直接按十等分取整。
local hueCount = std.length(P.order);
local hueAt(center) = P.order[std.max(0, std.min(hueCount - 1, std.floor(center * hueCount)))];

{
  hueAt: hueAt,
  // 键盘文件只调这一个函数：「我要一颗位于 center、做 treatment 处理的键」。
  roleAt(treatment, center):: roleName(treatment, hueAt(center)),
  // 少数几颗键不跟位置走（回车的强调态、数字键盘的等号），直接点名色相。
  role: roleName,

  // ===== 按键角色 =====
  // 五种处理 × 十档色相 = 50 个角色。一份键盘只会用到其中十来个，
  // 没被引用到的样式节点由 Components/Style.libsonnet 的 prune() 在出文件前丢掉。
  roles: {
    [roleName(treatment, hue)]: treatments[treatment](P.hues[hue])
    for treatment in std.objectFields(treatments)
    for hue in P.order
  },

  // ===== 区域配色 =====
  // 键盘底板。想让皮肤透出系统键盘背景（iOS 26 起系统自带圆角背景），
  // 把它改成 { light: '#FFFFFF03', dark: '#00000003' } 即可，其余不用动。
  keyboardBackground: P.weave,
  // 工具栏区与预编辑区用的「渐隐色」不在这里单列：它就是上面这个底板色配一档
  // 极低的透明度，由 Components/Theme.libsonnet 派生，改了底板色它自动跟着变。
  preeditText: P.inkPreedit,
  divider: P.divider,  // 分割线 / 面板里的分隔线

  // 短按气泡
  hint: {
    fill: P.cloud,
    border: P.divider,
    ink: P.inkFace,
  },

  // 工具栏图标（命令菜单、收起键盘、候选栏翻页等）。
  // 它们是这一条上的次要元素，比候选字轻一档；按下时才亮成主题色。
  toolbarIcon: {
    normal: P.inkQuiet,
    pressed: P.hues.rose.chroma,
  },

  // ===== 候选栏 =====
  // 候选字是整片彩虹里唯一一段要连着读的文本，所以这一条上一个色相都不放，
  // 只按「候选字 > 注释 > 序号」分三档轻重；颜色留给首选那颗玫红药丸。
  candidate: {
    text: P.inkFace,
    comment: P.inkQuiet,
    index: P.inkFaint,
    // 点住某个候选字时透出一层淡玫红，与按键「按下才开出颜色」是同一套手感
    pressedBackground: P.hues.rose.face,
    // 首选候选字做成一颗玫红色药丸——玫红是主题色，也是表带上最跳的那一条
    preferredBackground: P.hues.rose.base,
    preferredText: P.inkOnColor,
    preferredComment: P.inkOnColorQuiet,
    preferredIndex: P.inkOnColorFaint,
    separator: P.divider,
  },
}
