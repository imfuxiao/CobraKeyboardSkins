// 按键构造器 —— 全皮肤唯一「拼装一颗按键」的地方。
//
// 一颗按键在产物里是一组平铺的样式节点，名字之间靠字符串互相引用，引用错一个字母
// 该键就静默变空白。这里把命名规则收敛成一处：派生样式名都由按键名加固定后缀得到。
//
//   <name>                     按键节点（尺寸、动作、引用哪些样式）
//   <name>ForegroundStyle      键面（文字或图标）
//   <name>UppercaseForegroundStyle  大写态键面
//   <name>BackgroundStyle      键帽——**只在这颗键单独配色时才生成**，否则共用主题里那一份
//   <name>HintStyle            短按气泡
//   <name>HintForegroundStyle  气泡里的大字
local colors = import '../Constants/Colors.libsonnet';
local fonts = import '../Constants/Fonts.libsonnet';
local Style = import 'Style.libsonnet';
local Theme = import 'Theme.libsonnet';

// 按键节点上允许出现的动作与布局 Key。不在表里的会被丢掉。
// `split` 在这里透传：分体状态下的覆盖块，语义见 docs/键盘Split状态.md。
local passthroughKeys = [
  'size',
  'bounds',
  'split',
  'action',
  'uppercasedStateAction',
  'preeditStateAction',
  'repeatAction',
  'swipeUpAction',
  'swipeDownAction',
  'swipeLeftAction',
  'swipeRightAction',
  'notification',
  'uppercasedStateForegroundStyle',
  'capsLockedStateForegroundStyle',
  'preeditStateForegroundStyle',
];

// 键面显示什么：显式写了 text 就用它，否则从动作里取要上屏的那个字符。
// 取不到（回车、删除这类图标键）就返回空，由 systemImageName 那条分支接手。
local labelOf(params, key='action', isUppercased=false) =
  local upper(text) = if isUppercased then std.asciiUpper(text) else text;
  if std.objectHas(params, 'text') then { text: params.text }
  else if !std.objectHas(params, key) || !std.isObject(params[key]) then {}
  else if std.objectHas(params[key], 'character') then { text: upper(params[key].character) }
  else if std.objectHas(params[key], 'symbol') then { text: upper(params[key].symbol) }
  else {};

// 一层键面：写了 systemImageName 就画图标，否则画文字。
// params 排在最后，所以 center / fontSize / insets 都能逐项覆盖。
local paint(params, tint, defaultFontSize, imageFontSize, label) =
  if std.objectHas(params, 'systemImageName') then
    Style.systemImage(tint { fontSize: imageFontSize } + params)
  else
    Style.text(tint { fontSize: defaultFontSize } + label + params);

// 米键（会上屏的键）与功能键各一套配色。
local alphabeticTint(params) = {
  normalColor: if std.objectHas(params, 'foregroundNormalColor')
  then params.foregroundNormalColor else colors.standardButtonForegroundColor,
  highlightColor: if std.objectHas(params, 'foregroundHighlightColor')
  then params.foregroundHighlightColor else colors.standardButtonHighlightedForegroundColor,
};

local systemTint = {
  normalColor: colors.systemButtonForegroundColor,
  highlightColor: colors.systemButtonHighlightedForegroundColor,
};

// 这颗键是否单独配了背景色。配了才生成自己那份键帽样式，没配就共用主题里那一份——
// 一份键盘上百颗键，逐键复制一遍一模一样的键帽只是把产物撑大。
local hasOwnBackground(params) =
  std.objectHas(params, 'backgroundNormalColor') || std.objectHas(params, 'backgroundHighlightColor');

local ownBackground(name, params, insets) = {
  [name + 'BackgroundStyle']: Theme.buttonBackground(
    insets,
    if std.objectHas(params, 'backgroundNormalColor')
    then params.backgroundNormalColor else colors.standardButtonBackgroundColor,
    if std.objectHas(params, 'backgroundHighlightColor')
    then params.backgroundHighlightColor else colors.standardButtonHighlightedBackgroundColor,
  ),
};

// opts（除 passthroughKeys 外）：
//   text / systemImageName / highlightSystemImageName / center / fontSize / insets
//                     键面外观，见 paint
//   layers            可选，双行键面：[{ name, params }]，自上而下画。给了它就不再
//                     生成 <name>ForegroundStyle，键面完全由这张表决定
//   hint              可选，短按气泡的额外字段（如 size）；传 null 表示这颗键不弹气泡
//   insets            可选，键帽内边距，只在这颗键单独配色时用得上
//   backgroundStyle / foregroundStyle  可选，直接指定引用哪份样式（回车键的条件样式用）
local alphabetic(name, opts, insets, hint={}) =
  local tint = alphabeticTint(opts);
  local layerName(layer) = layer.name + 'ForegroundStyle';
  {
    [name]: {
      backgroundStyle:
        if std.objectHas(opts, 'backgroundStyle') then opts.backgroundStyle
        else if hasOwnBackground(opts) then name + 'BackgroundStyle'
        else Theme.alphabeticBackgroundName,
      foregroundStyle:
        if std.objectHas(opts, 'foregroundStyle') then opts.foregroundStyle
        else if std.objectHas(opts, 'layers') then [layerName(l) for l in opts.layers]
        else name + 'ForegroundStyle',
    } + Style.pick(opts, passthroughKeys) + (
      if std.objectHas(opts, 'uppercasedStateAction')
      then { uppercasedStateForegroundStyle: name + 'UppercaseForegroundStyle' } else {}
    ) + (
      if hint != null then { hintStyle: name + 'HintStyle' } else {}
    ),
  } + (
    if hasOwnBackground(opts) then ownBackground(name, opts, insets) else {}
  ) + (
    if std.objectHas(opts, 'layers') then {
      [layerName(layer)]: paint(
        layer.params, alphabeticTint(layer.params), fonts.keyLabel, fonts.keyImage, labelOf(layer.params)
      )
      for layer in opts.layers
    } else {
      [name + 'ForegroundStyle']: paint(opts, tint, fonts.keyLabel, fonts.keyImage, labelOf(opts)),
    }
  ) + (
    if std.objectHas(opts, 'uppercasedStateAction') then {
      [name + 'UppercaseForegroundStyle']: Style.text(
        tint { fontSize: fonts.keyUppercasedLabel } + labelOf(opts, 'uppercasedStateAction')
      ),
    } else {}
  ) + (
    if hint != null then {
      [name + 'HintStyle']: hint {
        backgroundStyle: Theme.hintBackgroundName,
        foregroundStyle: name + 'HintForegroundStyle',
      },
      // 气泡里显示大写：CJK 标点取大写等于原样，所以一条分支就够。
      // center / insets 跟着键面一起带进来：全角标点在键面上推了多少，
      // 在气泡里就得推多少，否则同一个字两处对不齐。
      [name + 'HintForegroundStyle']: Style.text({
        normalColor: colors.standardCalloutForegroundColor,
        fontSize: fonts.hintLabel,
      } + Style.pick(opts, ['center', 'insets', 'fontWeight']) + labelOf(opts, isUppercased=true)),
    } else {}
  );

// 功能键：灰底，不弹气泡，不参与大小写。
local system(name, opts) = {
  [name]: {
    backgroundStyle: if std.objectHas(opts, 'backgroundStyle') then opts.backgroundStyle
    else Theme.systemBackgroundName,
    foregroundStyle: if std.objectHas(opts, 'foregroundStyle') then opts.foregroundStyle
    else name + 'ForegroundStyle',
  } + Style.pick(opts, passthroughKeys),
} + (
  if std.objectHas(opts, 'foregroundStyle') then {} else {
    [name + 'ForegroundStyle']: paint(opts, systemTint, fonts.systemKeyText, fonts.systemKeyImage, labelOf(opts)),
  }
);

{
  alphabetic: alphabetic,
  system: system,
  labelOf: labelOf,
  paint: paint,
}
