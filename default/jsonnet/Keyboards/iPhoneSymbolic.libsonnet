// iPhone 符号键盘：数字页按 `#+=` 进来的第二页。
// 骨架与数字页完全一样，只有「哪一行放哪些符号」不同。
//
// 横屏支持分体（Split），做法与拼音页一致（见 iPhonePinyin.libsonnet 顶部注释）：
// `numericButton`（行首、分体后仍要用）上划进分体，分体态下再上划一次合回来。
// 竖屏不适配，`new()` 里按 isPortrait 分叉，竖屏那支产物逐字节不变。
local Keys = import '../Constants/Keys.libsonnet';
local metrics = import '../Constants/Metrics.libsonnet';
local Button = import '../Components/Button.libsonnet';
local Layout = import '../Components/Layout.libsonnet';
local Preedit = import '../Components/Preedit.libsonnet';
local Split = import '../Components/Split.libsonnet';
local Style = import '../Components/Style.libsonnet';
local Theme = import '../Components/Theme.libsonnet';
local Toolbar = import '../Components/Toolbar.libsonnet';
local Widths = import '../Components/Widths.libsonnet';

local sw = Split.iPhoneWidths;

// 成对的全角括号 / 书名号：左半边的墨迹靠右、右半边的靠左，都按行盒摆会显得两颗键
// 之间空了一大块。把左半边往左推、右半边往右推，一对符号才看着是一对。
local pairLeftOffset = { center: { x: 0.35 } };
local pairRightOffset = { center: { x: 0.65 } };

// [按键名, 额外的键面参数]
local rowOne = [
  ['leftChineseBracketButton', pairLeftOffset],
  ['rightChineseBracketButton', pairRightOffset],
  ['leftChineseBraceButton', pairLeftOffset],
  ['rightChineseBraceButton', pairRightOffset],
  ['hashButton', {}],
  ['percentButton', {}],
  ['caretButton', {}],
  ['asteriskButton', {}],
  ['plusButton', {}],
  ['equalButton', {}],
];

local rowTwo = [
  ['underscoreButton', {}],
  ['emDashButton', {}],
  ['backslashButton', {}],
  ['verticalBarButton', {}],
  ['tildeButton', {}],
  ['leftBookTitleMarkButton', pairLeftOffset],
  ['rightBookTitleMarkButton', pairRightOffset],
  ['graveButton', {}],
  ['ampersandButton', {}],
  ['middleDotButton', {}],
];

local rowThree = [
  ['ellipsisButton', {}],
  ['commaButton', {}],
  ['periodButton', {}],
  ['questionMarkEnButton', {}],
  ['exclamationMarkButton', {}],
  ['leftSingleQuoteButton', {}],
  ['rightSingleQuoteButton', {}],
];

local names(table) = [entry[0] for entry in table];

local keyboardLayout = [
  Layout.row(names(rowOne)),
  Layout.row(names(rowTwo)),
  Layout.row(['numericButton'] + names(rowThree) + ['backspaceButton']),
  Layout.row(['pinyinButton', 'spaceButton', 'enterButton']),
];

// ===== 横屏分体版面 =====
// 前两行是纯十键行，偶数个对半分；第三行七颗，复制中间那颗（第 4 颗，rowThree[3]）
// 让两半都凑成四颗（docs/键盘Split状态.md 2.1）。
//
// 每行两端各加一颗留白键（平时 0 宽），让三行的错位看起来像键盘该有的样子——
// 具体每行留白 / 中缝多宽，见 Components/Split.libsonnet 的宽度表注释。
local padTopLeftName = 'splitPadTopLeftButton';
local padTopRightName = 'splitPadTopRightButton';
local gapTopName = 'splitGapTopButton';
local padHomeLeftName = 'splitPadHomeLeftButton';
local padHomeRightName = 'splitPadHomeRightButton';
local gapHomeName = 'splitGapHomeButton';
local padBottomLeftName = 'splitPadBottomLeftButton';
local padBottomRightName = 'splitPadBottomRightButton';
local gapBottomName = 'splitGapBottomButton';
local padSpaceLeftName = 'splitPadSpaceLeftButton';
local padSpaceRightName = 'splitPadSpaceRightButton';
local gapSpaceName = 'splitGapSpaceButton';
local repeatedName(name) = std.substr(name, 0, std.length(name) - std.length('Button')) + 'SplitButton';
local spaceRightName = 'spaceRightButton';

local rowThreeRepeated = rowThree[3];
local rowThreeLeft = rowThree[0:4];
local rowThreeRight = rowThree[3:7];

local landscapeKeyboardLayout = [
  Layout.row([padTopLeftName] + names(rowOne[0:5]) + [gapTopName] + names(rowOne[5:10]) + [padTopRightName]),
  Layout.row([padHomeLeftName] + names(rowTwo[0:5]) + [gapHomeName] + names(rowTwo[5:10]) + [padHomeRightName]),
  Layout.row(
    [padBottomLeftName, 'numericButton'] + names(rowThreeLeft) + [gapBottomName, repeatedName(rowThreeRepeated[0])]
    + names(rowThreeRight[1:4]) + ['backspaceButton', padBottomRightName]
  ),
  Layout.row(
    [padSpaceLeftName, 'pinyinButton', 'spaceButton', gapSpaceName, spaceRightName, 'enterButton', padSpaceRightName]
  ),
];

{
  new(isPortrait=true)::
    local orientation = if isPortrait then 'portrait' else 'landscape';
    local insets = metrics.keyInsets.iPhone[orientation];
    local hint = { size: metrics.hint.iPhoneSize };

    // 横屏才挂分体覆盖块；竖屏 splitOnly 永远是 {}，产物与引入分体前逐字节相同。
    local isSplitCapable = !isPortrait;
    local splitOnly(extra) = if isSplitCapable then extra else {};

    local key(entry, extraWidth) = Button.alphabetic(
      entry[0], Keys[entry[0]] + entry[1] + extraWidth, insets, hint
    );

    Style.merge([
      Preedit.new(),
      Toolbar.new(supportsSplit=isSplitCapable),
      Theme.shared(insets),
      splitOnly(Split.shared),
      {
        keyboardHeight: metrics.keyboardHeight.iPhone[orientation],
        keyboardStyle: { backgroundStyle: Theme.keyboardBackgroundName },
        keyboardLayout: if isSplitCapable then landscapeKeyboardLayout else keyboardLayout,
      },

      Style.merge([
        key(entry, Widths.iPhone.unit + splitOnly(Split.width(sw.unit)))
        for entry in rowOne + rowTwo[1:9] + rowThree
      ]),

      // 第二行两端（rowTwo 的第一颗、最后一颗）比普通字母宽（sw.side），把第三行
      // numericButton / 删除让出去的中缝宽度分回来（见 Components/Split.libsonnet 的
      // 注释）。可见区域仍是普通字母大小，贴内侧显示。
      key(rowTwo[0], Widths.iPhone.unit + splitOnly(Split.widthAnchored(sw.side, sw.sideVisibleFraction, 'right'))),
      key(rowTwo[9], Widths.iPhone.unit + splitOnly(Split.widthAnchored(sw.side, sw.sideVisibleFraction, 'left'))),

      // numericButton 上划进入分体——行首、分体后仍要用的那颗键。
      // 比普通字母宽（sw.side），但可见区域只占 sw.sideVisibleFraction、贴左显示，
      // 宽出来的部分变成它与下一颗字母之间的一道空隙（见 Components/Split.libsonnet 的注释）。
      Button.system('numericButton',
        Keys.numericButton + Widths.iPhone.sideLeft
        + splitOnly(
          Split.widthAnchored(sw.side, sw.sideVisibleFraction, 'left') + Split.enterSplitGesture
        )),
      // 删除键镜像处理：同样宽出 sw.side，可见区域贴右显示，空隙落在上一颗字母与删除之间。
      Button.system('backspaceButton',
        Keys.backspaceButton + Widths.iPhone.sideRight
        + splitOnly(Split.widthAnchored(sw.side, sw.sideVisibleFraction, 'right'))),

      Button.system('pinyinButton',
        Keys.pinyinButton + Widths.iPhone.bottomSide + splitOnly(Split.width(sw.keyboardType))),
      Button.alphabetic('spaceButton',
        Keys.spaceButton + splitOnly(Split.width(sw.space)), insets, hint=null),
      Button.system('enterButton',
        Keys.enterButton + Widths.iPhone.bottomSide + splitOnly(Split.width(sw.keyboardType)) + {
          backgroundStyle: Theme.enterBackgroundStyle,
          foregroundStyle: Theme.enterForegroundStyle,
        }),
    ] + (
      if !isSplitCapable then [] else [
        // ===== 只在横屏出现的新键：两端留白、中缝、右半空格、重复键 =====
        Split.spacer(padTopLeftName, sw.margin),
        Split.spacer(padTopRightName, sw.margin),
        Split.spacer(gapTopName, sw.gap),
        Split.spacer(padHomeLeftName, sw.margin),
        Split.spacer(padHomeRightName, sw.margin),
        Split.spacer(gapHomeName, sw.bottomGap),
        Split.spacer(padBottomLeftName, sw.margin),
        Split.spacer(padBottomRightName, sw.margin),
        Split.spacer(gapBottomName, sw.bottomGap),
        Split.spacer(padSpaceLeftName, sw.margin),
        Split.spacer(padSpaceRightName, sw.margin),
        Split.spacer(gapSpaceName, sw.gap),
        Button.alphabetic(repeatedName(rowThreeRepeated[0]),
          Keys[rowThreeRepeated[0]] + rowThreeRepeated[1] + { size: { width: 0 } } + Split.width(sw.unit),
          insets, hint),
        Button.alphabetic(spaceRightName,
          Keys.spaceButton + { size: { width: 0 } } + Split.width(sw.space), insets, hint=null),
      ]
    )),
}
