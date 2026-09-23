// 符号键盘（数字键盘上 =\< 切过去的那一页）—— 版面照 Gboard 那一套。
//
// 它挂在自定义类型 `noctuaSymbolic` 下，不占内置的 `symbolic`——
// 后者留给引擎自带的分类符号键盘，见 main.jsonnet 里 builders 那段说明。
//
// 四行：
//   ~ ` | · √ π ÷ × * §
//   £ ¢ € ¥ ^ ° = 「 」 \
//   ?123 % ' ' ™ ✓ [ ] ⌫      第一颗切回数字键盘
//   返回 < 12·34 空格 > ⏎       12·34 切到九宫格数字键盘
//
// 四行，行高与拼音页完全一致。
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

local sw = Split.iPhoneWidths;
local nw = Split.numericWidths;

local rowCount = 4;

// ===== 表：三行米键 =====
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

// ===== 分体版面 =====
// 与 Numeric 页同构（十键一排 / 十键一排 / 切页键+7 米键+删除 / 自定义第四行），
// 数值同样复用 Split.libsonnet 的 iPhoneWidths / numericWidths。
local padRow1LeftName = 'splitPadRow1LeftButton';
local padRow1RightName = 'splitPadRow1RightButton';
local gapRow1Name = 'splitGapRow1Button';
local padRow2LeftName = 'splitPadRow2LeftButton';
local padRow2RightName = 'splitPadRow2RightButton';
local gapRow2Name = 'splitGapRow2Button';
local padRow3LeftName = 'splitPadRow3LeftButton';
local padRow3RightName = 'splitPadRow3RightButton';
local gapRow3Name = 'splitGapRow3Button';
local repeatedRowThreeName = Keys.keyName(rowThree[3][0] + 'Split');
local padRow4LeftName = 'splitPadRow4LeftButton';
local padRow4RightName = 'splitPadRow4RightButton';
local gapRow4Name = 'splitGapRow4Button';
local spaceRightName = 'spaceRightButton';

local landscapeKeyboardLayout = [
  Layout.row(
    [padRow1LeftName] + [Keys.keyName(entry[0]) for entry in rowOne[0:5]]
    + [gapRow1Name] + [Keys.keyName(entry[0]) for entry in rowOne[5:10]] + [padRow1RightName]
  ),
  Layout.row(
    [padRow2LeftName] + [Keys.keyName(entry[0]) for entry in rowTwo[0:5]]
    + [gapRow2Name] + [Keys.keyName(entry[0]) for entry in rowTwo[5:10]] + [padRow2RightName]
  ),
  Layout.row(
    [padRow3LeftName, numericName] + [Keys.keyName(entry[0]) for entry in rowThree[0:4]]
    + [gapRow3Name, repeatedRowThreeName] + [Keys.keyName(entry[0]) for entry in rowThree[4:7]]
    + [backspaceName, padRow3RightName]
  ),
  Layout.row([
    padRow4LeftName, returnName, ltName, numberPadName, spaceName, gapRow4Name,
    spaceRightName, gtName, enterName, padRow4RightName,
  ]),
];

{
  new(device='iPhone', isPortrait=true)::
    local orientation = if isPortrait then 'portrait' else 'landscape';
    local insets = Metrics.keyInsets[device][orientation];
    local keysHeight = Metrics.height(device, orientation, rowCount);
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
        keyboardLayout: if isSplitCapable then landscapeKeyboardLayout else keyboardLayout,
      },
      Style.merge([
        Keys.charKey(entry[0], entry[1], fontSize=Fonts.symbolKeyLabel, opts=splitOnly(Split.width(sw.unit)))
        for entry in rowOne + rowTwo + rowThree
      ]),
      Keys.punctuationKey(ltId, '<', null, Keys.widths.unit + splitOnly(Split.width(nw.small))),
      Keys.punctuationKey(gtId, '>', null, Keys.widths.unit + splitOnly(Split.width(nw.small))),
      FunctionKeys.switchKeyboard(
        numericName, '?123', 'numeric',
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
          rowThree[3][0] + 'Split', rowThree[3][1], fontSize=Fonts.symbolKeyLabel,
          opts={ size: { width: 0 } } + Split.width(sw.unit)
        ),
        FunctionKeys.space(spaceRightName, { size: { width: 0 } } + Split.width(nw.spaceRight)),
      ]
    )),
}
