// 按键构造器 —— 全皮肤唯一「拼装一个按键」的地方。
//
// 一个按键在配置文件里其实是一组平铺的样式节点（按键节点 + 前景 + 气泡……），
// 名字之间靠字符串互相引用，引用错一个字母该键就静默变空白。
// 这里把命名规则收敛成一处：所有派生样式名都由按键名加固定后缀得到。
//
//   <name>                按键节点（尺寸、动作、引用哪些样式）
//   <name>Label           主标签
//   <name>SecondaryLabel  副标签（iPad 双标签的上排）
//   <name>Badge           角标（iPhone 上划符号）
//   <name>LabelUppercased 大写态标签
//   <name>LabelCapsLocked 大写锁定态标签
//   <name>Hint            短按气泡
//   <name>HintLabel       气泡主字
//   <name>HintSwipeUp     气泡上划字
local Colors = import '../Constants/Colors.libsonnet';
local Fonts = import '../Constants/Fonts.libsonnet';
local Metrics = import '../Constants/Metrics.libsonnet';
local Style = import 'Style.libsonnet';
local Theme = import 'Theme.libsonnet';

// 按键节点上允许出现的动作与布局 Key。不在表里的 Key 会被丢掉，
// 免得手滑写出的键名混进产物里（引擎对不认识的 Key 是静默忽略的）。
local passthroughKeys = [
  'size',
  'bounds',
  'action',
  'uppercasedStateAction',
  'preeditStateAction',
  'repeatAction',
  'swipeUpAction',
  'swipeDownAction',
  'notification',
  'animation',
];

local passthrough(opts) = {
  [key]: opts[key]
  for key in passthroughKeys
  if std.objectHas(opts, key)
};

// 把一个「外观描述」变成前景样式节点。
// desc 里出现 systemImageName / assetImageName 就画图标，否则画文字。
local paint(desc, tint, defaultFontSize) =
  if std.objectHas(desc, 'systemImageName') then
    Style.systemImage({ fontSize: Fonts.keyIcon } + tint + desc)
  else if std.objectHas(desc, 'assetImageName') then
    Style.assetImage(tint + desc)
  else
    Style.text({ fontSize: defaultFontSize } + tint + desc);

local roleTint(role) = {
  normalColor: Theme.ink(role),
  highlightColor: Theme.inkPressed(role),
};

local hintTint = {
  normalColor: Colors.hint.ink,
};

// 气泡：短按时浮在按键上方，主字居中，若该键能上划则右上角带上划字。
local hintFragment(name, hint) =
  local hasSwipeUp = std.objectHas(hint, 'swipeUp');
  {
    [name + 'Hint']: {
      size: Metrics.hint.size,
      backgroundStyle: Theme.hintBackgroundName,
      foregroundStyle: name + 'HintLabel',
    } + (
      if hasSwipeUp then { swipeUpForegroundStyle: name + 'HintSwipeUp' } else {}
    ),
    [name + 'HintLabel']: paint(hint.label, hintTint, Fonts.hintLabel),
  } + (
    if hasSwipeUp then
      { [name + 'HintSwipeUp']: paint(hint.swipeUp, hintTint, Fonts.hintLabel) }
    else {}
  );

// opts:
//   role              必填，见 Constants/Colors.libsonnet 的 roles 表
//   label             必填，主标签外观 { text } / { systemImageName } / { assetImageName }
//   secondaryLabel    可选，副标签（与主标签同等权重，iPad 双标签用）
//   badge             可选，角标（自动减淡、缩小、置顶）
//   uppercasedLabel   可选，大写态替换主标签
//   capsLockedLabel   可选，大写锁定态替换主标签
//   hint              可选，{ label: 外观, swipeUp: 外观 } 短按气泡
//   animation         可选，覆盖默认的按下缩放动画；传 [] 表示该键不要动画
//   backgroundStyle   可选，覆盖角色默认背景（回车键的条件样式用）
//   foregroundStyle   可选，覆盖自动拼装的前景列表（回车键的条件样式用）
//   其余 passthroughKeys 里的 Key 原样写进按键节点
local new(name, opts) =
  local role = opts.role;
  local tint = roleTint(role);

  local layers =
    [name + 'Label']
    + (if std.objectHas(opts, 'secondaryLabel') then [name + 'SecondaryLabel'] else [])
    + (if std.objectHas(opts, 'badge') then [name + 'Badge'] else []);

  {
    [name]: {
      backgroundStyle:
        if std.objectHas(opts, 'backgroundStyle') then opts.backgroundStyle
        else Theme.backgroundName(role),
      foregroundStyle:
        if std.objectHas(opts, 'foregroundStyle') then opts.foregroundStyle
        else layers,
      // 全皮肤统一的按下缩放反馈。opts 里写了 animation 会被 passthrough 覆盖掉，
      // 想让某个键不带动画就传 animation: []。
      animation: [Theme.pressAnimationName],
    } + passthrough(opts) + (
      if std.objectHas(opts, 'uppercasedLabel') then
        { uppercasedStateForegroundStyle: name + 'LabelUppercased' } else {}
    ) + (
      if std.objectHas(opts, 'capsLockedLabel') then
        { capsLockedStateForegroundStyle: name + 'LabelCapsLocked' } else {}
    ) + (
      if std.objectHas(opts, 'hint') then { hintStyle: name + 'Hint' } else {}
    ),

    [name + 'Label']: paint(opts.label, tint, Fonts.keyLabel),
  } + (
    if std.objectHas(opts, 'secondaryLabel') then
      { [name + 'SecondaryLabel']: paint(opts.secondaryLabel, tint, Fonts.keyLabel) }
    else {}
  ) + (
    if std.objectHas(opts, 'badge') then
      {
        [name + 'Badge']: paint(
          { fontSize: Fonts.keyBadge, center: Metrics.key.badgeCenter } + opts.badge,
          { normalColor: Theme.inkSoft(role), highlightColor: Theme.inkSoft(role) },
          Fonts.keyBadge
        ),
      }
    else {}
  ) + (
    if std.objectHas(opts, 'uppercasedLabel') then
      { [name + 'LabelUppercased']: paint(opts.uppercasedLabel, tint, Fonts.keyLabel) }
    else {}
  ) + (
    if std.objectHas(opts, 'capsLockedLabel') then
      { [name + 'LabelCapsLocked']: paint(opts.capsLockedLabel, tint, Fonts.keyLabel) }
    else {}
  ) + (
    if std.objectHas(opts, 'hint') then hintFragment(name, opts.hint) else {}
  );

{
  new: new,
  paint: paint,
  roleTint: roleTint,
}
