// 主题层：全皮肤共享的样式节点、条件样式与通知定义。
local colors = import '../Constants/Colors.libsonnet';
local fonts = import '../Constants/Fonts.libsonnet';
local metrics = import '../Constants/Metrics.libsonnet';
local Style = import 'Style.libsonnet';

local keyboardBackgroundName = 'keyboardBackgroundStyle';
local alphabeticBackgroundName = 'alphabeticButtonBackgroundStyle';
local systemBackgroundName = 'systemButtonBackgroundStyle';
local blueBackgroundName = 'blueButtonBackgroundStyle';
local blueForegroundName = 'blueButtonForegroundStyle';
local enterForegroundName = 'enterButtonForegroundStyle';
local hintBackgroundName = 'alphabeticHintBackgroundStyle';
local hintGridBackgroundName = 'hintGridBackgroundStyle';
local hintGridSelectedBackgroundName = 'hintGridSelectedBackgroundStyle';
local commitCandidateForegroundName = 'commitCandidateForegroundStyle';
local shiftUppercasedForegroundName = 'shiftButtonUppercasedForegroundStyle';
local shiftCapsLockedForegroundName = 'shiftButtonCapsLockedForegroundStyle';

// 回车键随 returnKeyType 切换样式：两组取值互补，覆盖全部 UIReturnKeyType。
local plainReturnKeyTypes = [0, 2, 3, 5, 6, 8, 11];
local blueReturnKeyTypes = [1, 4, 7, 9, 10];

local enterBackgroundStyle = [
  Style.when('$returnKeyType', plainReturnKeyTypes, systemBackgroundName),
  Style.when('$returnKeyType', blueReturnKeyTypes, blueBackgroundName),
];

local enterForegroundStyle = [
  Style.when('$returnKeyType', plainReturnKeyTypes, enterForegroundName),
  Style.when('$returnKeyType', blueReturnKeyTypes, blueForegroundName),
];

local buttonBackground(insets, normalColor, highlightColor) = Style.geometry({
  insets: insets,
  normalColor: normalColor,
  highlightColor: highlightColor,
  cornerRadius: metrics.key.cornerRadius,
  normalLowerEdgeColor: colors.lowerEdgeOfButtonNormalColor,
  highlightLowerEdgeColor: colors.lowerEdgeOfButtonHighlightColor,
});

{
  keyboardBackgroundName: keyboardBackgroundName,
  alphabeticBackgroundName: alphabeticBackgroundName,
  systemBackgroundName: systemBackgroundName,
  blueBackgroundName: blueBackgroundName,
  blueForegroundName: blueForegroundName,
  enterForegroundName: enterForegroundName,
  hintBackgroundName: hintBackgroundName,
  hintGridBackgroundName: hintGridBackgroundName,
  hintGridSelectedBackgroundName: hintGridSelectedBackgroundName,
  shiftUppercasedForegroundName: shiftUppercasedForegroundName,
  shiftCapsLockedForegroundName: shiftCapsLockedForegroundName,

  enterBackgroundStyle: enterBackgroundStyle,
  enterForegroundStyle: enterForegroundStyle,

  buttonBackground: buttonBackground,

  // 共享样式节点；未被当前键盘引用的节点会在 main.jsonnet 中被 Style.prune 自动裁剪。
  shared(insets):: {
    [keyboardBackgroundName]: Style.geometry({ normalColor: colors.keyboardBackgroundColor }),

    [alphabeticBackgroundName]: buttonBackground(
      insets, colors.standardButtonBackgroundColor, colors.standardButtonHighlightedBackgroundColor
    ),
    [systemBackgroundName]: buttonBackground(
      insets, colors.systemButtonBackgroundColor, colors.systemButtonHighlightedBackgroundColor
    ),
    [blueBackgroundName]: buttonBackground(
      insets, colors.blueButtonBackgroundColor, colors.blueButtonHighlightedBackgroundColor
    ),

    [blueForegroundName]: Style.text({
      normalColor: colors.blueButtonForegroundColor,
      highlightColor: colors.blueButtonHighlightedForegroundColor,
      fontSize: fonts.systemKeyText,
      text: '$returnKeyType',
    }),
    [enterForegroundName]: Style.text({
      normalColor: colors.systemButtonForegroundColor,
      highlightColor: colors.systemButtonHighlightedForegroundColor,
      fontSize: fonts.systemKeyText,
      text: '$returnKeyType',
    }),
    [commitCandidateForegroundName]: Style.text({
      normalColor: colors.standardButtonForegroundColor,
      highlightColor: colors.standardButtonHighlightedForegroundColor,
      fontSize: fonts.systemKeyText,
      text: '选定',
    }),

    [hintBackgroundName]: Style.geometry({
      normalColor: colors.standardCalloutBackgroundColor,
      normalBorderColor: colors.standardCalloutBorderColor,
      borderSize: 0.5,
      cornerRadius: metrics.hint.cornerRadius,
    }),

    [hintGridBackgroundName]: Style.geometry({
      normalColor: colors.standardCalloutBackgroundColor,
      normalBorderColor: colors.standardCalloutBorderColor,
      highlightBorderColor: colors.standardCalloutBorderColor,
      borderSize: 0.5,
      cornerRadius: metrics.hintGrid.cornerRadius,
    }),
    [hintGridSelectedBackgroundName]: Style.geometry({
      normalColor: colors.standardCalloutSelectedBackgroundColor,
      highlightColor: colors.standardCalloutSelectedBackgroundColor,
      cornerRadius: metrics.hintGrid.selectedCornerRadius,
    }),

    [shiftUppercasedForegroundName]: Style.systemImage({
      systemImageName: 'shift.fill',
      normalColor: colors.systemButtonForegroundColor,
      highlightColor: colors.systemButtonHighlightedForegroundColor,
      fontSize: fonts.systemKeyImage,
    }),
    [shiftCapsLockedForegroundName]: Style.systemImage({
      systemImageName: 'capslock.fill',
      normalColor: colors.systemButtonForegroundColor,
      highlightColor: colors.systemButtonHighlightedForegroundColor,
      fontSize: fonts.systemKeyImage,
    }),

    // 列宽样式（供九键与数字键盘引用，未引用时会被自动裁剪）
    halfVStackStyle: { size: { width: { percentage: metrics.stacks.halfWidth } } },
    narrowVStackStyle: { size: { width: { percentage: metrics.stacks.narrowWidth } } },
    wideVStackStyle: { size: { width: { percentage: metrics.stacks.wideWidth } } },

    // 状态通知
    returnKeyTypeChangedNotification: {
      notificationType: 'returnKeyType',
      returnKeyType: [1, 4, 7],
      backgroundStyle: blueBackgroundName,
      foregroundStyle: blueForegroundName,
    },
    preeditChangedForEnterButtonNotification: {
      notificationType: 'preeditChanged',
      backgroundStyle: enterBackgroundStyle,
      foregroundStyle: enterForegroundStyle,
    },
    preeditChangedForSpaceButtonNotification: {
      notificationType: 'preeditChanged',
      backgroundStyle: alphabeticBackgroundName,
      foregroundStyle: commitCandidateForegroundName,
    },
  },
}
