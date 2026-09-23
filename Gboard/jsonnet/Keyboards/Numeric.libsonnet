// 数字键盘（?123 切过去的那一页）—— 对应 ../../资料/数字键盘.png。
//
// 四行：
//   1 2 3 4 5 6 7 8 9 0
//   @ # $ _ & - + ( ) /
//   =\< 、 " " : ; ! ? ⌫       第一颗切到本皮肤的符号页
//   返回 , 12·34 空格 . ⏎       12·34 切到九宫格数字键盘
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

// ===== 表：三行白键 =====
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

// ===== 分体（Split）版面 =====
// 第一 / 二行都是整齐的 10 键行，直接用 Split.row10 对半分；
// 第三行「灰键 + 7 白键 + 灰键」与拼音页第三行同形状，用 Split.nineKeyRow。
// 第四行是本页特有的「返回 + 逗号 + 12·34 + 空格 + 句号 + 回车」六键行，宽度表本地定义。
local padTopLeftName = 'splitPadTopLeftButton';
local padTopRightName = 'splitPadTopRightButton';
local gapTopName = 'splitGapTopButton';
local padRowTwoLeftName = 'splitPadRowTwoLeftButton';
local padRowTwoRightName = 'splitPadRowTwoRightButton';
local gapRowTwoName = 'splitGapRowTwoButton';
local padRowThreeLeftName = 'splitPadRowThreeLeftButton';
local padRowThreeRightName = 'splitPadRowThreeRightButton';
local gapRowThreeName = 'splitGapRowThreeButton';
local padRowFourLeftName = 'splitPadRowFourLeftButton';
local padRowFourRightName = 'splitPadRowFourRightButton';
local gapRowFourName = 'splitGapRowFourButton';
local spaceRightName = 'spaceRightButton';
local repeatedName(c) = c + 'SplitButton';

// 第四行分体宽度表：margin(8) + keyboardType(126) + unit(79.2)×3 + space(195.1)×2
//   + gap(229.2) + margin(8) = 1125
local rowFour = {
  margin: '8/1125',
  keyboardType: '126/1125',
  unit: '79.2/1125',
  space: '195.1/1125',
  gap: '229.2/1125',
};

local splitKeyboardLayout = [
  Layout.row(
    [padTopLeftName] + [Keys.keyName(entry[0]) for entry in digitRow[0:5]]
    + [gapTopName] + [Keys.keyName(entry[0]) for entry in digitRow[5:10]]
    + [padTopRightName]
  ),
  Layout.row(
    [padRowTwoLeftName] + [Keys.keyName(entry[0]) for entry in symbolRow[0:5]]
    + [gapRowTwoName] + [Keys.keyName(entry[0]) for entry in symbolRow[5:10]]
    + [padRowTwoRightName]
  ),
  Layout.row(
    [padRowThreeLeftName, symbolicName] + [Keys.keyName(entry[0]) for entry in punctRow[0:4]]
    + [gapRowThreeName, repeatedName('colon')] + [Keys.keyName(entry[0]) for entry in punctRow[4:7]]
    + [backspaceName, padRowThreeRightName]
  ),
  Layout.row([
    padRowFourLeftName, returnName, commaName, numberPadName, spaceName,
    gapRowFourName, spaceRightName, periodName, enterName, padRowFourRightName,
  ]),
];

{
  new(device='iPhone', isPortrait=true)::
    local orientation = if isPortrait then 'portrait' else 'landscape';
    local insets = Metrics.keyInsets[device][orientation];
    local keysHeight = Metrics.keyboardHeight[device][orientation];
    local sideInsets = if device == 'iPad' then Metrics.iPadSideInsets else {};

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
        keyboardLayout: if isSplitCapable then splitKeyboardLayout else keyboardLayout,
      },
      // 数字键面比字母大一号，符号键则收小一点——符号的字形普遍比字母宽
      Style.merge([
        Keys.charKey(entry[0], entry[1], fontSize=Fonts.numericKeyLabel)
        + { [Keys.keyName(entry[0])]+: splitOnly(Split.width(Split.row10.unit)) }
        for entry in digitRow
      ]),
      Style.merge([
        Keys.charKey(entry[0], entry[1], fontSize=Fonts.symbolKeyLabel)
        + { [Keys.keyName(entry[0])]+: splitOnly(Split.width(Split.row10.unit)) }
        for entry in symbolRow
      ]),
      Style.merge([
        Keys.charKey(entry[0], entry[1], fontSize=Fonts.symbolKeyLabel)
        + { [Keys.keyName(entry[0])]+: splitOnly(Split.width(Split.nineKeyRow.unit)) }
        for entry in punctRow
      ]),
      Keys.punctuationKey(commaId, ',', null, Keys.widths.unit + splitOnly(Split.width(rowFour.unit))),
      Keys.punctuationKey(periodId, '.', null, Keys.widths.unit + splitOnly(Split.width(rowFour.unit))),
      // 指向本皮肤的符号页（自定义类型 gboardSymbolic），不是引擎自带的 symbolic
      // 上划进出分体——这一行行首的灰键，分体后仍要用
      FunctionKeys.switchKeyboard(symbolicName, '=\\<', 'gboardSymbolic', Keys.widths.rowThreeLeft
        + splitOnly(Split.widthAnchored(Split.nineKeyRow.side, Split.nineKeyRow.sideVisibleFraction, 'left')
                    + Split.enterSplitGesture)),
      FunctionKeys.backspace(backspaceName, Keys.widths.rowThreeRight
        + splitOnly(Split.widthAnchored(Split.nineKeyRow.side, Split.nineKeyRow.sideVisibleFraction, 'right'))),
      FunctionKeys.returnPrimaryKeyboard(returnName, Keys.widths.rowFourPillLeft
        + splitOnly(Split.width(rowFour.keyboardType))),
      FunctionKeys.numberPad(numberPadName, Keys.widths.unit + splitOnly(Split.width(rowFour.unit))),
      FunctionKeys.space(spaceName, splitOnly(Split.width(rowFour.space))),
      FunctionKeys.enter(enterName, Keys.widths.rowFourPillRight + splitOnly(Split.width(rowFour.keyboardType))),
    ] + (
      if !isSplitCapable then [] else [
        Split.spacer(padTopLeftName, Split.row10.margin),
        Split.spacer(padTopRightName, Split.row10.margin),
        Split.spacer(gapTopName, Split.row10.gap),
        Split.spacer(padRowTwoLeftName, Split.row10.margin),
        Split.spacer(padRowTwoRightName, Split.row10.margin),
        Split.spacer(gapRowTwoName, Split.row10.gap),
        Split.spacer(padRowThreeLeftName, Split.nineKeyRow.margin),
        Split.spacer(padRowThreeRightName, Split.nineKeyRow.margin),
        Split.spacer(gapRowThreeName, Split.nineKeyRow.bottomGap),
        Split.spacer(padRowFourLeftName, rowFour.margin),
        Split.spacer(padRowFourRightName, rowFour.margin),
        Split.spacer(gapRowFourName, rowFour.gap),
        // 合并态 0 宽不建层，分体态撑开成普通符号键，与本尊各有各的样式名
        Keys.charKey('colon', ':', fontSize=Fonts.symbolKeyLabel,
                      opts={ size: { width: 0 } } + Split.width(Split.nineKeyRow.unit),
                      name=repeatedName('colon')),
        FunctionKeys.space(spaceRightName, { size: { width: 0 } } + Split.width(rowFour.space)),
      ]
    )),
}
