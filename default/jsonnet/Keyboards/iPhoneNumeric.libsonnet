// iPhone 数字键盘：四行，骨架与拼音页一致（前两行十键、第三行切页 + 七键 + 删除、
// 第四行切回拼音 + 空格 + 回车），所以宽度表直接复用拼音页那一份。
//
// 横屏支持分体（Split），做法与拼音页一致（见 iPhonePinyin.libsonnet 顶部注释）：
// `symbolicButton`（行首、分体后仍要用）上划进分体，分体态下再上划一次合回来。
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

// 全角标点的墨迹缩在方框左下角，行盒摆正了看着却偏左，往右推一点才像居中。
local cjkPunctuationOffset = { center: { x: 0.55 } };

local rowOne = ['oneButton', 'twoButton', 'threeButton', 'fourButton', 'fiveButton',
                'sixButton', 'sevenButton', 'eightButton', 'nineButton', 'zeroButton'];

local rowTwo = ['hyphenButton', 'forwardSlashButton', 'colonButton', 'semicolonButton',
                'leftParenthesisButton', 'rightParenthesisButton', 'dollarButton', 'atButton',
                'leftCurlyQuoteButton', 'rightCurlyQuoteButton'];

// 第三行中间那七颗。前三颗是全角标点，要往右推。
local rowThreeCjk = ['chinesePeriodButton', 'chineseCommaButton', 'ideographicCommaButton'];
local rowThreeAscii = ['hashButton', 'questionMarkEnButton', 'exclamationMarkButton', 'periodButton'];
local rowThree = rowThreeCjk + rowThreeAscii;

local keyboardLayout = [
  Layout.row(rowOne),
  Layout.row(rowTwo),
  Layout.row(['symbolicButton'] + rowThree + ['backspaceButton']),
  Layout.row(['pinyinButton', 'spaceButton', 'enterButton']),
];

// ===== 横屏分体版面 =====
// 前两行是纯十键行，偶数个对半分；第三行七颗，复制中间那颗（第 4 颗，rowThree[3]，
// 正好是 CJK 与 ASCII 的分界）让两半都凑成四颗（docs/键盘Split状态.md 2.1）。
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
  Layout.row([padTopLeftName] + rowOne[0:5] + [gapTopName] + rowOne[5:10] + [padTopRightName]),
  Layout.row([padHomeLeftName] + rowTwo[0:5] + [gapHomeName] + rowTwo[5:10] + [padHomeRightName]),
  Layout.row(
    [padBottomLeftName, 'symbolicButton'] + rowThreeLeft + [gapBottomName, repeatedName(rowThreeRepeated)]
    + rowThreeRight[1:4] + ['backspaceButton', padBottomRightName]
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

    // 全角标点（rowThreeCjk 那三颗）要带上 cjkPunctuationOffset，其余不带。
    local key(name, extraWidth) =
      local offset = if std.count(rowThreeCjk, name) > 0 then cjkPunctuationOffset else {};
      Button.alphabetic(name, Keys[name] + offset + extraWidth, insets, hint);

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
        key(name, Widths.iPhone.unit + splitOnly(Split.width(sw.unit)))
        for name in rowOne
      ]),

      // 第二行两端（rowTwo 的第一颗、最后一颗）比普通字母宽（sw.side），把第三行
      // symbolicButton / 删除让出去的中缝宽度分回来（见 Components/Split.libsonnet 的
      // 注释）。可见区域仍是普通字母大小，贴内侧显示。
      key(rowTwo[0], Widths.iPhone.unit + splitOnly(Split.widthAnchored(sw.side, sw.sideVisibleFraction, 'right'))),
      Style.merge([
        key(name, Widths.iPhone.unit + splitOnly(Split.width(sw.unit)))
        for name in rowTwo[1:9]
      ]),
      key(rowTwo[9], Widths.iPhone.unit + splitOnly(Split.widthAnchored(sw.side, sw.sideVisibleFraction, 'left'))),

      // 第三行。symbolicButton 上划进入分体——行首、分体后仍要用的那颗键。
      // 比普通字母宽（sw.side），但可见区域只占 sw.sideVisibleFraction、贴左显示，
      // 宽出来的部分变成它与下一颗字母之间的一道空隙（见 Components/Split.libsonnet 的注释）。
      Button.system('symbolicButton',
        Keys.symbolicButton + Widths.iPhone.sideLeft
        + splitOnly(
          Split.widthAnchored(sw.side, sw.sideVisibleFraction, 'left') + Split.enterSplitGesture
        )),
      Style.merge([key(name, Widths.iPhone.unit + splitOnly(Split.width(sw.unit))) for name in rowThree]),
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
        Button.alphabetic(repeatedName(rowThreeRepeated),
          Keys[rowThreeRepeated] + { size: { width: 0 } } + Split.width(sw.unit), insets, hint),
        Button.alphabetic(spaceRightName,
          Keys.spaceButton + { size: { width: 0 } } + Split.width(sw.space), insets, hint=null),
      ]
    )),
}
