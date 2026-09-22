// 主题层：全皮肤共用的那几个样式节点，以及引用它们的名字。
//
// 上层（Button / Keyboards）只写名字，具体长什么样全部由本文件决定；
// 反过来，本文件不知道有哪些键。
local colors = import '../Constants/Colors.libsonnet';
local fonts = import '../Constants/Fonts.libsonnet';
local metrics = import '../Constants/Metrics.libsonnet';
local Style = import 'Style.libsonnet';

// ===== 约定的样式名 =====
local keyboardBackgroundName = 'keyboardBackgroundStyle';
local alphabeticBackgroundName = 'alphabeticButtonBackgroundStyle';
local systemBackgroundName = 'systemButtonBackgroundStyle';
local blueBackgroundName = 'blueButtonBackgroundStyle';
local blueForegroundName = 'blueButtonForegroundStyle';
local enterForegroundName = 'enterButtonForegroundStyle';
local hintBackgroundName = 'alphabeticHintBackgroundStyle';
local commitCandidateForegroundName = 'commitCandidateForegroundStyle';
local shiftUppercasedForegroundName = 'shiftButtonUppercasedForegroundStyle';
local shiftCapsLockedForegroundName = 'shiftButtonCapsLockedForegroundStyle';

// ===== 回车键随 returnKeyType 换色 =====
// 「前往 / 搜索 / 发送」这一档是蓝底白字，其余是普通功能键的灰底黑字。
// 两张表必须互补：漏掉某个取值，那个场景下回车键就没有样式，整颗键变透明。
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

// 一份按键背景：圆角矩形 + 底部立体边缘。insets 决定键与键之间的缝隙，
// 随设备与方向变化，所以由调用方传进来。
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
  shiftUppercasedForegroundName: shiftUppercasedForegroundName,
  shiftCapsLockedForegroundName: shiftCapsLockedForegroundName,

  enterBackgroundStyle: enterBackgroundStyle,
  enterForegroundStyle: enterForegroundStyle,

  buttonBackground: buttonBackground,

  // 所有键盘都要带上的共享样式节点。insets 随设备与方向变化，所以做成参数。
  shared(insets):: {
    // 键盘底板。03 约合 0.01 的不透明度，几乎全透，透出系统键盘背景。
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
    // 预编辑中的空格键：键面从「space 图标」换成「选定」两个字，点一下上屏首选。
    [commitCandidateForegroundName]: Style.text({
      normalColor: colors.standardButtonForegroundColor,
      highlightColor: colors.standardButtonHighlightedForegroundColor,
      fontSize: fonts.systemKeyText,
      text: '选定',
    }),

    // 短按气泡的底：与按键同色，靠一条细描边分界
    [hintBackgroundName]: Style.geometry({
      normalColor: colors.standardCalloutBackgroundColor,
      normalBorderColor: colors.standardCalloutBorderColor,
      borderSize: 0.5,
      cornerRadius: metrics.hint.cornerRadius,
    }),

    // Shift 的两个状态态前景
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

    // ===== 通知：外部状态变了，按键换一套样式 =====
    // returnKeyType 变化时回车键换色；预编辑开始 / 结束时回车键与空格键换样式。
    returnKeyTypeChangedNotification: {
      notificationType: 'returnKeyType',
      // 只有「前往 / 搜索 / 发送」这三档会在输入过程中变来变去，另外两档（9 继续、10 路由）不会
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
