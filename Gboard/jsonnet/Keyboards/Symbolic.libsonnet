// 符号键盘（数字键盘上 =\< 切过去的那一页）—— 对应 ../../资料/符号键盘.png。
//
// 它挂在自定义类型 `gboardSymbolic` 下，不占内置的 `symbolic`——
// 后者留给引擎自带的分类符号键盘，见 main.jsonnet 里 builders 那段说明。
//
// 四行：
//   ~ ` | · √ π ÷ × * §
//   £ ¢ € ¥ ^ ° = 「 」 \
//   ?123 % ' ' ™ ✓ [ ] ⌫      第一颗切回数字键盘
//   返回 < 12·34 空格 > ⏎       12·34 切到九宫格数字键盘
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
// [按键名, 上屏字符]。按键名必须是 ASCII 标识符——这一页有两颗单引号键。
local rowOne = [
  ['tilde', '~'],
  ['backquote', '`'],
  ['pipe', '|'],
  ['middot', '·'],
  ['sqrt', '√'],
  ['pi', 'π'],
  ['divide', '÷'],
  ['times', '×'],
  ['asterisk', '*'],
  ['section', '§'],
];

local rowTwo = [
  ['pound', '£'],
  ['cent', '¢'],
  ['euro', '€'],
  ['yen', '¥'],
  ['caret', '^'],
  ['degree', '°'],
  ['equal', '='],
  ['cornerL', '「'],
  ['cornerR', '」'],
  ['backslash', '\\'],
];

local rowThree = [
  ['percent', '%'],
  ['quoteSingleL', '‘'],
  ['quoteSingleR', '’'],
  ['trademark', '™'],
  ['check', '✓'],
  ['bracketL', '['],
  ['bracketR', ']'],
];

local numericName = 'toNumericButton';
local backspaceName = 'backspaceButton';
local returnName = 'returnPrimaryKeyboardButton';
local ltId = 'lessThan';
local ltName = Keys.keyName(ltId);
local numberPadName = 'toNumberPadButton';
local spaceName = 'spaceButton';
local gtId = 'greaterThan';
local gtName = Keys.keyName(gtId);
local enterName = 'enterButton';

local keyboardLayout = [
  Layout.row([Keys.keyName(entry[0]) for entry in rowOne]),
  Layout.row([Keys.keyName(entry[0]) for entry in rowTwo]),
  Layout.row([numericName] + [Keys.keyName(entry[0]) for entry in rowThree] + [backspaceName]),
  Layout.row([returnName, ltName, numberPadName, spaceName, gtName, enterName]),
];

// ===== 分体（Split）版面 =====
// 与 Numeric.libsonnet 同形状（10-10-9-6），宽度表照搬，只是键位换了一套。
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

// 第四行：与 Numeric 页一致，margin(8)+keyboardType(126)+unit(79.2)×3+space(195.1)×2
//   +gap(229.2)+margin(8) = 1125
local rowFour = {
  margin: '8/1125',
  keyboardType: '126/1125',
  unit: '79.2/1125',
  space: '195.1/1125',
  gap: '229.2/1125',
};

local splitKeyboardLayout = [
  Layout.row(
    [padTopLeftName] + [Keys.keyName(entry[0]) for entry in rowOne[0:5]]
    + [gapTopName] + [Keys.keyName(entry[0]) for entry in rowOne[5:10]]
    + [padTopRightName]
  ),
  Layout.row(
    [padRowTwoLeftName] + [Keys.keyName(entry[0]) for entry in rowTwo[0:5]]
    + [gapRowTwoName] + [Keys.keyName(entry[0]) for entry in rowTwo[5:10]]
    + [padRowTwoRightName]
  ),
  Layout.row(
    [padRowThreeLeftName, numericName] + [Keys.keyName(entry[0]) for entry in rowThree[0:4]]
    + [gapRowThreeName, repeatedName('trademark')] + [Keys.keyName(entry[0]) for entry in rowThree[4:7]]
    + [backspaceName, padRowThreeRightName]
  ),
  Layout.row([
    padRowFourLeftName, returnName, ltName, numberPadName, spaceName,
    gapRowFourName, spaceRightName, gtName, enterName, padRowFourRightName,
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
      Style.merge([
        Keys.charKey(entry[0], entry[1], fontSize=Fonts.symbolKeyLabel)
        + { [Keys.keyName(entry[0])]+: splitOnly(Split.width(Split.row10.unit)) }
        for entry in rowOne + rowTwo
      ]),
      Style.merge([
        Keys.charKey(entry[0], entry[1], fontSize=Fonts.symbolKeyLabel)
        + { [Keys.keyName(entry[0])]+: splitOnly(Split.width(Split.nineKeyRow.unit)) }
        for entry in rowThree
      ]),
      Keys.punctuationKey(ltId, '<', null, Keys.widths.unit + splitOnly(Split.width(rowFour.unit))),
      Keys.punctuationKey(gtId, '>', null, Keys.widths.unit + splitOnly(Split.width(rowFour.unit))),
      // 上划进出分体——这一行行首的灰键，分体后仍要用
      FunctionKeys.switchKeyboard(numericName, '?123', 'numeric', Keys.widths.rowThreeLeft
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
        Keys.charKey('trademark', '™', fontSize=Fonts.symbolKeyLabel,
                      opts={ size: { width: 0 } } + Split.width(Split.nineKeyRow.unit),
                      name=repeatedName('trademark')),
        FunctionKeys.space(spaceRightName, { size: { width: 0 } } + Split.width(rowFour.space)),
      ]
    )),
}
