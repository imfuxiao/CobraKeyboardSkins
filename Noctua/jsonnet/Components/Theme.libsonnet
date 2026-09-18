// 主题层：把「按键角色」翻译成实际的样式节点与样式名。
//
// 上层（Button / Keyboards）只说「这个键是 accent 角色」，
// 具体长什么样全部由本文件决定；反过来，本文件不知道有哪些键。
local Colors = import '../Constants/Colors.libsonnet';
local Metrics = import '../Constants/Metrics.libsonnet';
local Style = import 'Style.libsonnet';

// ===== 约定的样式名 =====
local backgroundName(role) = role + 'KeyBackground';
local keyboardBackgroundName = 'keyboardBackground';
local preeditBackgroundName = 'preeditBackground';
local toolbarBackgroundName = 'toolbarBackground';
local candidatePanelBackgroundName = 'candidatePanelBackground';
local hintBackgroundName = 'hintBackground';
local hintGridBackgroundName = 'hintGridBackground';
local hintGridSelectedBackgroundName = 'hintGridSelectedBackground';
local pressAnimationName = 'keyPressScale';

// ===== 按压反馈 =====
// 按下时整键缩小并保持，抬起再弹回，时长单位为毫秒。
// isAutoReverse 为 false 时按下与抬起分别触发：手指按住期间键帽一直是缩小的，
// 与系统键盘的手感一致；设为 true 会变成「缩一下就自己弹回」的一次性脉冲。
//
// 幅度取 0.95 而不是更狠的 0.92：本皮肤的键带立体下边缘，缩得太多时
// 那道边缘会跟着一起缩，看着像键帽整个陷进底板里。
local pressAnimation = {
  animationType: 'scale',
  isAutoReverse: false,
  scale: 0.95,
  pressDuration: 40,
  releaseDuration: 90,
};

// ===== 工具栏区的向上渐隐 =====
// iOS 26 起系统在键盘顶部强制加了一段带圆角的高度。底板色若一路铺到顶边，
// 就会在那圈圆角处与系统背景撞出一条色差。本皮肤的底板是实打实的米色
// （Noctua 的框体色是这套皮肤的半条命，不能像 Gboard 那样整块不画），
// 所以改用「彩虹」那套分三段的做法：
//
//   按键区    纯底板色
//   工具栏区  底板色 → 渐隐色，自下而上
//   预编辑区  整条都是渐隐色
//
// 三块拼起来颜色连续，最上方那一条几乎全透明，圆角处再看不出边界。
//
// 关键一点：整条渐变只降 alpha，不动色相。渐变的两端若换了 RGB（比如收到纯白或
// 纯黑），中段 alpha 还高的地方就会整体偏向那个颜色。所以渐隐终点用的是底板色本身，
// 只是把 alpha 压到 03。
//
// 采样点数取 2 就是线性渐变，肉眼能在渐变起点看到一条淡淡的界线，
// 所以按 smoothstep(3t²-2t³) 多取几个点，让渐变两端都平滑收口。
local fadeStopCount = 5;
local smoothstep(t) = t * t * (3 - 2 * t);

// 渐隐终点的不透明度。03 约合 0.01，与元书内置皮肤「透出系统键盘背景」同一档。
local fadeAlpha = 3;

local fadeColor = Colors.withAlpha(Colors.keyboardBackground, fadeAlpha);

// t 从 0（最上方）到 1（按键区那一侧）。各采样点色相相同，只有 alpha 按
// smoothstep 逐级提高，最后一档是完全不透明的底板色。
local fadeLocations = [i / (fadeStopCount - 1) for i in std.range(0, fadeStopCount - 1)];
local fadeColors = [fadeColor] + [
  Colors.withAlpha(
    Colors.keyboardBackground,
    std.max(fadeAlpha, std.round(smoothstep(fadeLocations[i]) * 255))
  )
  for i in std.range(1, fadeStopCount - 1)
];

// 渐变坐标以图层左上角为原点（y=0 顶边、y=1 底边），与「屏幕左下角为原点」
// 的说法上下相反：颜色数组第一项对应最上方。
// endY 是渐变收口的位置，图层比工具栏高时用它把渐隐带压在顶部一段里，
// 越过 endY 之后 CAGradientLayer 会一直沿用最后一个颜色，也就是纯底板色。
local fadeGradient(endY=1) = {
  normalColor: fadeColors,
  colorLocation: fadeLocations,
  colorStartPoint: { x: 0.5, y: 0 },
  colorEndPoint: { x: 0.5, y: endY },
};

local role(name) =
  assert std.objectHas(Colors.roles, name) : '未定义的按键角色: ' + name;
  Colors.roles[name];

// 一个角色对应的按键背景：圆角矩形 + 底部立体边缘。
// 那道下边缘是这套皮肤与 Gboard 最直观的区别——风扇是注塑件，键帽该有厚度。
local backgroundStyle(name, insets) =
  local r = role(name);
  Style.geometry({
    insets: insets,
    cornerRadius: Metrics.key.cornerRadius,
    normalColor: r.fill,
    highlightColor: r.pressed,
    normalLowerEdgeColor: r.edge,
    highlightLowerEdgeColor: r.edge,
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
  // 减淡字色，用于角标；角色没单独声明时退回常态字色
  inkSoft(name):: (
    local r = role(name);
    if std.objectHas(r, 'inkSoft') then r.inkSoft else r.ink
  ),

  // 所有键盘都要带上的共享样式节点。
  // insets 与 keysHeight 随设备、方向和行数变化，所以做成参数而不是常量。
  shared(insets, keysHeight):: {
    // 按键区：纯底板色
    [keyboardBackgroundName]: Style.geometry({
      normalColor: Colors.keyboardBackground,
    }),
    // 预编辑区：整条都是渐隐色，正好落在 iOS 26 那段圆角高度里
    [preeditBackgroundName]: Style.geometry({
      normalColor: fadeColor,
    }),
    // 工具栏区：下缘接按键区的底板色，上缘接预编辑区的渐隐色
    [toolbarBackgroundName]: Style.geometry(fadeGradient()),
    // 纵排候选栏展开后会盖住工具栏区 + 按键区，自带的底板要替这两块一起画，
    // 所以把渐隐带压回原本工具栏所占的那一段高度里。
    [candidatePanelBackgroundName]: Style.geometry(
      fadeGradient(Metrics.toolbar.height / (Metrics.toolbar.height + keysHeight))
    ),
    // 短按气泡。它与盖住的键同色，分界分两层做：
    // 投影收紧压成底边一道实线管「下沿」，0.5pt 的描边管左右和上方——
    // 引擎给几何图层的投影路径是图层底边那一道 1pt 的弧（CAShapeLayer.underPath），
    // 单靠它做不出四周的层次。
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
    // 长按符号网格的面板：与气泡同一套做法，只是圆角小、块更大
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
    [backgroundName(name)]: backgroundStyle(name, insets)
    for name in std.objectFields(Colors.roles)
  },
}
