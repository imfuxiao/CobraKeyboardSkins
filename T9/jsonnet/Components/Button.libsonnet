// 按键构造器：全皮肤唯一拼装按键及其派生样式节点的地方。
//
// 派生样式命名规则：
//   <name>                         按键节点（尺寸、动作、样式引用）
//   <name>ForegroundStyle          主前景（文字 / SF Symbol / Asset 图标）
//   <name>BadgeForegroundStyle     角标前景（可选，次要文字色）
//   <name>UppercaseForegroundStyle 大写态前景（可选）
//   <name>BackgroundStyle          独立背景（仅单键自定义配色时生成）
//   <name>HintStyle                短按气泡（可选）
//   <name>HintForegroundStyle      短按气泡主字
//   <name>SwipeUpHintForegroundStyle 短按上划气泡字（可选）
//   <name>Grid                     长按符号网格（可选）
//   <name>GridCell<i> / Label      长按网格单元格与标签
local colors = import '../Constants/Colors.libsonnet';
local fonts = import '../Constants/Fonts.libsonnet';
local metrics = import '../Constants/Metrics.libsonnet';
local Style = import 'Style.libsonnet';
local Theme = import 'Theme.libsonnet';

local passthroughKeys = [
  'size',
  'bounds',
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

local labelOf(params, key='action', isUppercased=false) =
  local upper(text) = if isUppercased then std.asciiUpper(text) else text;
  if std.objectHas(params, 'text') then { text: params.text }
  else if !std.objectHas(params, key) || !std.isObject(params[key]) then {}
  else if std.objectHas(params[key], 'character') then { text: upper(params[key].character) }
  else if std.objectHas(params[key], 'symbol') then { text: upper(params[key].symbol) }
  else {};

local paint(params, tint, defaultFontSize, imageFontSize, label={}) =
  if std.objectHas(params, 'systemImageName') then
    Style.systemImage(tint { fontSize: imageFontSize } + params)
  else if std.objectHas(params, 'assetImageName') then
    Style.assetImage(tint + params)
  else
    Style.text(tint { fontSize: defaultFontSize } + label + params);

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

local badgeTint = {
  normalColor: colors.labelColor.secondary,
  highlightColor: colors.labelColor.secondary,
};

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

// 长按符号网格片段：动作走 symbol 通道，避免误触发 T9 拼写。
local hintGridFragment(name, symbols, selectedCol, isPortrait) =
  local orientation = if isPortrait then 'portrait' else 'landscape';
  local indices = std.range(0, std.length(symbols) - 1);
  local cellName(i) = name + 'GridCell' + i;
  local fontSize = fonts.hintGrid[orientation];
  {
    [name + 'Grid']: {
      size: metrics.hintGrid.cell[orientation],
      spacing: metrics.hintGrid.spacing,
      insets: metrics.hintGrid.insets,
      offset: metrics.hintGrid.offset,
      moveStep: metrics.hintGrid.moveStep,
      moveThreshold: metrics.hintGrid.moveThreshold,
      backgroundStyle: Theme.hintGridBackgroundName,
      selectedBackgroundStyle: Theme.hintGridSelectedBackgroundName,
      selected: { row: 0, col: selectedCol },
      symbolRows: [[cellName(i) for i in indices]],
    },
  } + {
    [cellName(i)]: {
      foregroundStyle: cellName(i) + 'Label',
      action: { symbol: symbols[i] },
    }
    for i in indices
  } + {
    [cellName(i) + 'Label']: Style.text({
      text: symbols[i],
      fontSize: fontSize,
      normalColor: colors.standardCalloutForegroundColor,
      highlightColor: colors.standardCalloutHighlightedForegroundColor,
    })
    for i in indices
  };

// 短按气泡片段（26 键英文页用）：支持附带上划气泡前景。
local hintFragment(name, opts, hint) =
  local hasSwipeUpText = std.objectHas(hint, 'swipeUpText');
  {
    [name + 'HintStyle']: Style.pick(hint, ['size']) + {
      backgroundStyle: Theme.hintBackgroundName,
      foregroundStyle: name + 'HintForegroundStyle',
    } + (
      if hasSwipeUpText then { swipeUpForegroundStyle: name + 'SwipeUpHintForegroundStyle' } else {}
    ),
    [name + 'HintForegroundStyle']: Style.text({
      normalColor: colors.standardCalloutForegroundColor,
      fontSize: fonts.hintLabel,
    } + Style.pick(opts, ['center', 'insets', 'fontWeight']) + labelOf(opts, isUppercased=true)),
  } + (
    if hasSwipeUpText then {
      [name + 'SwipeUpHintForegroundStyle']: Style.text({
        normalColor: colors.standardCalloutForegroundColor,
        fontSize: fonts.hintLabel,
        text: hint.swipeUpText,
      }),
    } else {}
  );

// 普通米键构造器
//   badge: 可选对象 { text, center, fontSize? }，存在时前景自动组合为 [主前景, 角标前景]
//   hint:  可选对象 { size?, swipeUpText? }，传 null 表示不弹短按气泡
local alphabetic(name, opts, insets, hint=null, isPortrait=true) =
  local tint = alphabeticTint(opts);
  local hasBadge = std.objectHas(opts, 'badge') && opts.badge != null;
  local hasLongPress = std.objectHas(opts, 'longPress') && std.length(opts.longPress) > 0;
  {
    [name]: {
      backgroundStyle:
        if std.objectHas(opts, 'backgroundStyle') then opts.backgroundStyle
        else if hasOwnBackground(opts) then name + 'BackgroundStyle'
        else Theme.alphabeticBackgroundName,
      foregroundStyle:
        if std.objectHas(opts, 'foregroundStyle') then opts.foregroundStyle
        else if hasBadge then [name + 'ForegroundStyle', name + 'BadgeForegroundStyle']
        else name + 'ForegroundStyle',
    } + Style.pick(opts, passthroughKeys) + (
      if std.objectHas(opts, 'uppercasedStateAction')
      then { uppercasedStateForegroundStyle: name + 'UppercaseForegroundStyle' } else {}
    ) + (
      if hint != null then { hintStyle: name + 'HintStyle' } else {}
    ) + (
      if hasLongPress then { hintSymbolsGridStyle: name + 'Grid' } else {}
    ),
  } + (
    if hasOwnBackground(opts) then ownBackground(name, opts, insets) else {}
  ) + (
    if std.objectHas(opts, 'foregroundStyle') then {} else {
      [name + 'ForegroundStyle']: paint(opts, tint, fonts.keyLabel, fonts.keyImage, labelOf(opts)),
    }
  ) + (
    if hasBadge then {
      [name + 'BadgeForegroundStyle']: Style.text(
        badgeTint { fontSize: fonts.keyBadge } + opts.badge
      ),
    } else {}
  ) + (
    if std.objectHas(opts, 'uppercasedStateAction') then {
      [name + 'UppercaseForegroundStyle']: Style.text(
        tint { fontSize: fonts.keyUppercasedLabel } + labelOf(opts, 'uppercasedStateAction')
      ),
    } else {}
  ) + (
    if hint != null then hintFragment(name, opts, hint) else {}
  ) + (
    if hasLongPress then hintGridFragment(
      name,
      opts.longPress,
      if std.objectHas(opts, 'longPressSelectedIndex') then opts.longPressSelectedIndex else 0,
      isPortrait
    ) else {}
  );

// 系统功能键构造器
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
}
