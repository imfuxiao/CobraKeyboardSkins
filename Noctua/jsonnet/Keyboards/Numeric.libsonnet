// 数字键盘（拼音页的「123」切过去的那一页）—— 版面照 Gboard 那一套。
//
// 四行：
//   1 2 3 4 5 6 7 8 9 0
//   @ # $ _ & - + ( ) /
//   =\< 、 " " : ; ! ? ⌫       第一颗切到本皮肤的符号页
//   返回 , 12·34 空格 . ⏎       12·34 切到九宫格数字键盘
//
// 四行，行高与拼音页完全一致（见 Constants/Metrics.libsonnet 的 rowHeight），
// 来回切页时键不会跳。
local FunctionKeys = import '../Components/FunctionKeys.libsonnet';
local Keys = import '../Components/Keys.libsonnet';
local Layout = import '../Components/Layout.libsonnet';
local Preedit = import '../Components/Preedit.libsonnet';
local Split = import '../Components/Split.libsonnet';
local Style = import '../Components/Style.libsonnet';
local Theme = import '../Components/Theme.libsonnet';
local Toolbar = import '../Components/Toolbar.libsonnet';
local Fonts = import '../Constants/Fonts.libsonnet';
local Metrics = import '../Constants/Metrics.libsonnet';
local Button = import '../Components/Button.libsonnet';

local sw = Split.iPhoneWidths;
local nw = Split.numericWidths;

local rowCount = 4;

// ===== 表：三行米键 =====
// [按键名, 上屏字符, 键面文字（省略即字符本身）]。
// 按键名要是 ASCII 标识符：这一页有两颗引号键，直接拿字符当名字会撞车。
local digitRow = [
  ['num1', '1'],
  ['num2', '2'],
  ['num3', '3'],
  ['num4', '4'],
  ['num5', '5'],
  ['num6', '6'],
  ['num7', '7'],
  ['num8', '8'],
  ['num9', '9'],
  ['num0', '0'],
];

local symbolRow = [
  ['at', '@'],
  ['hash', '#'],
  ['dollar', '$'],
  ['underscore', '_'],
  ['amp', '&'],
  ['minus', '-'],
  ['plus', '+'],
  ['parenL', '('],
  ['parenR', ')'],
  ['slash', '/'],
];

// 第三行中间七颗
local punctRow = [
  ['dun', '、'],
  ['quoteL', '“'],
  ['quoteR', '”'],
  ['colon', ':'],
  ['semicolon', ';'],
  ['bang', '!'],
  ['question', '?'],
];

local symbolicName = 'toSymbolicButton';
local backspaceName = 'backspaceButton';
local returnName = 'returnPrimaryKeyboardButton';
local commaId = 'comma';
local commaName = Keys.keyName(commaId);
local numberPadName = 'toNumberPadButton';
local spaceName = 'spaceButton';
local periodId = 'period';
local periodName = Keys.keyName(periodId);
local enterName = 'enterButton';

local keyboardLayout = [
  Layout.row([Keys.keyName(entry[0]) for entry in digitRow]),
  Layout.row([Keys.keyName(entry[0]) for entry in symbolRow]),
  Layout.row([symbolicName] + [Keys.keyName(entry[0]) for entry in punctRow] + [backspaceName]),
  Layout.row([returnName, commaName, numberPadName, spaceName, periodName, enterName]),
];

// ===== 分体版面 =====
// 第一 / 二行都是十键一排，跟 iPhone 拼音页第一行同构，直接复用同一套 margin/gap；
// 第三行是「切页键 + 7 米键 + 删除」，跟拼音页第三行（shift+7 字母+backspace）同构，
// 复用 side/bottomGap；第四行（返回/逗号/12·34/空格/句号/回车）自行设计，
// 数值见 Components/Split.libsonnet 的 numericWidths 注释。
local padRow1LeftName = 'splitPadRow1LeftButton';
local padRow1RightName = 'splitPadRow1RightButton';
local gapRow1Name = 'splitGapRow1Button';
local padRow2LeftName = 'splitPadRow2LeftButton';
local padRow2RightName = 'splitPadRow2RightButton';
local gapRow2Name = 'splitGapRow2Button';
local padRow3LeftName = 'splitPadRow3LeftButton';
local padRow3RightName = 'splitPadRow3RightButton';
local gapRow3Name = 'splitGapRow3Button';
local repeatedPunctName = Keys.keyName(punctRow[3][0] + 'Split');
local padRow4LeftName = 'splitPadRow4LeftButton';
local padRow4RightName = 'splitPadRow4RightButton';
local gapRow4Name = 'splitGapRow4Button';
local spaceRightName = 'spaceRightButton';

local landscapeKeyboardLayout = [
  Layout.row(
    [padRow1LeftName] + [Keys.keyName(entry[0]) for entry in digitRow[0:5]]
    + [gapRow1Name] + [Keys.keyName(entry[0]) for entry in digitRow[5:10]] + [padRow1RightName]
  ),
  Layout.row(
    [padRow2LeftName] + [Keys.keyName(entry[0]) for entry in symbolRow[0:5]]
    + [gapRow2Name] + [Keys.keyName(entry[0]) for entry in symbolRow[5:10]] + [padRow2RightName]
  ),
  Layout.row(
    [padRow3LeftName, symbolicName] + [Keys.keyName(entry[0]) for entry in punctRow[0:4]]
    + [gapRow3Name, repeatedPunctName] + [Keys.keyName(entry[0]) for entry in punctRow[4:7]]
    + [backspaceName, padRow3RightName]
  ),
  Layout.row([
    padRow4LeftName, returnName, commaName, numberPadName, spaceName, gapRow4Name,
    spaceRightName, periodName, enterName, padRow4RightName,
  ]),
];

{
  new(device='iPhone', isPortrait=true)::
    local orientation = if isPortrait then 'portrait' else 'landscape';
    local insets = Metrics.keyInsets[device][orientation];
    local keysHeight = Metrics.height(device, orientation, rowCount);
    local sideInsets = if device == 'iPad' then Metrics.iPadSideInsets else {};
    // 支持 Split 的场景：iPad 不分方向、iPhone 只在横屏
    local isSplitCapable = device == 'iPad' || !isPortrait;
    local splitOnly(extra) = if isSplitCapable then extra else {};

    Style.merge([
      Preedit.new(),
      Toolbar.new(sideInsets, supportsSplit=isSplitCapable),
      Theme.shared(insets, keysHeight),
      splitOnly(Split.shared),
      {
        keyboardHeight: keysHeight,
        keyboardStyle: {
          backgroundStyle: Theme.keyboardBackgroundName,
          // 按键区整体的左右边距，与键间距是两回事，见 Metrics.keyboardAreaInsets
          insets: Metrics.keyboardAreaInsets[device][orientation],
        },
        keyboardLayout: if isSplitCapable then landscapeKeyboardLayout else keyboardLayout,
      },
      // 数字键面比字母大一号，符号键则收小一点——符号的字形普遍比字母宽
      Style.merge([
        Keys.charKey(entry[0], entry[1], fontSize=Fonts.numericKeyLabel, opts=splitOnly(Split.width(sw.unit)))
        for entry in digitRow
      ]),
      Style.merge([
        Keys.charKey(entry[0], entry[1], fontSize=Fonts.symbolKeyLabel, opts=splitOnly(Split.width(sw.unit)))
        for entry in symbolRow + punctRow
      ]),
      Keys.punctuationKey(commaId, ',', null, Keys.widths.unit + splitOnly(Split.width(nw.small))),
      Keys.punctuationKey(periodId, '.', null, Keys.widths.unit + splitOnly(Split.width(nw.small))),
      // 指向本皮肤的符号页（自定义类型 noctuaSymbolic），不是引擎自带的 symbolic
      FunctionKeys.switchKeyboard(
        symbolicName, '=\\<', 'noctuaSymbolic',
        Keys.widths.rowThreeLeft + splitOnly(Split.widthAnchored(sw.side, sw.sideVisibleFraction, 'left'))
      ),
      FunctionKeys.backspace(
        backspaceName,
        Keys.widths.rowThreeRight + splitOnly(Split.widthAnchored(sw.side, sw.sideVisibleFraction, 'right'))
      ),
      FunctionKeys.returnPrimaryKeyboard(returnName, Keys.widths.rowFourSideLeft + splitOnly(Split.widthNoClip(nw.side))),
      FunctionKeys.numberPad(numberPadName, Keys.widths.unit + splitOnly(Split.width(nw.small))),
      FunctionKeys.space(spaceName, splitOnly(Split.width(nw.spaceLeft))),
      FunctionKeys.enter(enterName, Keys.widths.rowFourSideRight + splitOnly(Split.widthNoClip(nw.side))),
    ] + (
      if !isSplitCapable then [] else [
        // ===== 只在分体可用场景出现的新键：两端留白、中缝、右半空格、重复标点 =====
        Split.spacer(padRow1LeftName, sw.margin),
        Split.spacer(padRow1RightName, sw.margin),
        Split.spacer(gapRow1Name, sw.gap),
        Split.spacer(padRow2LeftName, sw.margin),
        Split.spacer(padRow2RightName, sw.margin),
        Split.spacer(gapRow2Name, sw.gap),
        Split.spacer(padRow3LeftName, sw.margin),
        Split.spacer(padRow3RightName, sw.margin),
        Split.spacer(gapRow3Name, sw.bottomGap),
        Split.spacer(padRow4LeftName, nw.margin),
        Split.spacer(padRow4RightName, nw.margin),
        Split.spacer(gapRow4Name, nw.gap),
        Keys.charKey(
          punctRow[3][0] + 'Split', punctRow[3][1], fontSize=Fonts.symbolKeyLabel,
          opts={ size: { width: 0 } } + Split.width(sw.unit)
        ),
        FunctionKeys.space(spaceRightName, { size: { width: 0 } } + Split.width(nw.spaceRight)),
      ]
    )),
}
