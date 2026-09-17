// 主题层：把「按键角色」翻译成实际的样式节点与样式名。
//
// 上层（Button / Keyboards）只说「这个键是 function 角色」，
// 具体长什么样全部由本文件决定；反过来，本文件不知道有哪些键。
local Colors = import '../Constants/Colors.libsonnet';
local Metrics = import '../Constants/Metrics.libsonnet';
local Style = import 'Style.libsonnet';

// ===== 约定的样式名 =====
local backgroundName(role) = role + 'KeyBackground';
// 按键区 / 预编辑区 / 工具栏区 / 纵排候选栏共用同一份背景样式。
// 四个名字留着是为了调用方读起来仍有区分，指向的是同一个节点。
local keyboardBackgroundName = 'keyboardBackground';
local preeditBackgroundName = keyboardBackgroundName;
local toolbarBackgroundName = keyboardBackgroundName;
local candidatePanelBackgroundName = keyboardBackgroundName;
local hintBackgroundName = 'hintBackground';
local hintGridBackgroundName = 'hintGridBackground';
local hintGridSelectedBackgroundName = 'hintGridSelectedBackground';
local pressAnimationName = 'keyPressScale';

// ===== 按压反馈 =====
// Gboard 按下时键面**不缩放**，只换底色（见 Colors 的 pressed 一档），
// 但完全没有形变会显得发木，所以只缩 2%，抬起再弹回。
// 某一颗键不要动画就给它传 animation: []。
local pressAnimation = {
  animationType: 'scale',
  isAutoReverse: false,
  scale: 0.98,
  pressDuration: 40,
  releaseDuration: 90,
};

local role(name) =
  assert std.objectHas(Colors.roles, name) : '未定义的按键角色: ' + name;
  Colors.roles[name];

local isPill(name) =
  local r = role(name);
  std.objectHas(r, 'pill') && r.pill;

// 胶囊圆角的半径 = 一行按键的**可视**高度的一半。
// 四种键盘都是四行，所以「行高 = keyboardHeight / 4」，再扣掉上下内边距就是可视高度。
// 写成计算式而不是常量，是为了横屏与 iPad 上键变矮时圆角自动跟着收，
// 不会出现「半径比键高的一半还大」导致的圆角失真。
local pillRadius(keysHeight, insets) =
  local rowHeight = keysHeight / Metrics.rowCount;
  local visible = rowHeight - insets.top - insets.bottom;
  std.max(Metrics.key.cornerRadius, visible / 2);

// 一个角色对应的按键背景。
// Gboard 是完全扁平的：没有立体下边缘、没有描边，按下就是整块键面换色。
local backgroundStyle(name, insets, keysHeight) =
  local r = role(name);
  Style.geometry({
    insets: insets,
    cornerRadius: if isPill(name) then pillRadius(keysHeight, insets) else Metrics.key.cornerRadius,
    normalColor: r.fill,
    highlightColor: r.pressed,
  });

{
  backgroundName: backgroundName,
  keyboardBackgroundName: keyboardBackgroundName,
  preeditBackgroundName: preeditBackgroundName,
  toolbarBackgroundName: toolbarBackgroundName,
  candidatePanelBackgroundName: candidatePanelBackgroundName,
  hintBackgroundName: hintBackgroundName,
  hintGridBackgroundName: hintGridBackgroundName,
  hintGridSelectedBackgroundName: hintGridSelectedBackgroundName,
  pressAnimationName: pressAnimationName,

  // 分割线色，符号栏一类的集合视图会用到
  dividerColor: Colors.divider,

  // 角色的字色，供 Button 构造前景样式时取用
  ink(name):: role(name).ink,
  inkPressed(name):: role(name).inkPressed,
  inkSoft(name):: (
    local r = role(name);
    if std.objectHas(r, 'inkSoft') then r.inkSoft else r.ink
  ),

  // 所有键盘都要带上的共享样式节点。
  // insets 与 keysHeight 随设备和方向变化，所以做成参数而不是常量。
  shared(insets, keysHeight):: {
    // 键盘整体背景：几乎全透明，底交给系统键盘自己画。
    // 四个区域共用这一份，所以顶边不会再出现「皮肤的底板色」与「系统的底」撞色的缝。
    [keyboardBackgroundName]: Style.geometry({
      normalColor: Colors.keyboardBackground,
    }),
    // 短按气泡：一个白色圆形，无描边。圆角取尺寸的一半就是正圆。
    // 气泡与它盖住的白键同色，只能靠投影分层，见 Metrics.hint 的说明。
    [hintBackgroundName]: Style.geometry({
      normalColor: Colors.hint.fill,
      cornerRadius: Metrics.hint.cornerRadius,
      borderSize: Metrics.hint.borderSize,
      normalBorderColor: Colors.hint.border,
      highlightBorderColor: Colors.hint.border,
      normalShadowColor: Colors.hint.shadow,
      highlightShadowColor: Colors.hint.shadow,
      shadowRadius: Metrics.hint.shadowRadius,
      shadowOffset: Metrics.hint.shadowOffset,
    }),
    // 长按符号网格的面板：与气泡同一套白 + 投影，只是圆角小、块更大
    [hintGridBackgroundName]: Style.geometry({
      normalColor: Colors.hintGrid.fill,
      cornerRadius: Metrics.hintGrid.cornerRadius,
      borderSize: Metrics.hintGrid.borderSize,
      normalBorderColor: Colors.hintGrid.border,
      highlightBorderColor: Colors.hintGrid.border,
      normalShadowColor: Colors.hintGrid.shadow,
      highlightShadowColor: Colors.hintGrid.shadow,
      shadowRadius: Metrics.hintGrid.shadowRadius,
      shadowOffset: Metrics.hintGrid.shadowOffset,
    }),
    // 高亮单元格的底：引擎创建这一层时固定传 isActive: true，所以只有 highlightColor 生效，
    // normalColor 写同一个色是为了这份样式单独拿去渲染时也不至于变透明。
    [hintGridSelectedBackgroundName]: Style.geometry({
      normalColor: Colors.hintGrid.selectedFill,
      highlightColor: Colors.hintGrid.selectedFill,
      cornerRadius: Metrics.hintGrid.cellCornerRadius,
    }),
    [pressAnimationName]: pressAnimation,
  } + {
    // 每个角色一份按键背景，全部由 Colors.roles 表驱动。
    // 没被引用到的由 Style.prune 在出文件前丢掉。
    [backgroundName(name)]: backgroundStyle(name, insets, keysHeight)
    for name in std.objectFields(Colors.roles)
  },
}
