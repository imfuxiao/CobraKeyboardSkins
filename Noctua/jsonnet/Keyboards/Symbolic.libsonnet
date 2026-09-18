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
local Style = import '../Components/Style.libsonnet';
local Theme = import '../Components/Theme.libsonnet';
local Toolbar = import '../Components/Toolbar.libsonnet';
local Fonts = import '../Constants/Fonts.libsonnet';
local Metrics = import '../Constants/Metrics.libsonnet';

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

{
  new(device='iPhone', isPortrait=true)::
    local orientation = if isPortrait then 'portrait' else 'landscape';
    local insets = Metrics.keyInsets[device][orientation];
    local keysHeight = Metrics.height(device, orientation, rowCount);
    local sideInsets = if device == 'iPad' then Metrics.iPadSideInsets else {};

    Style.merge([
      Preedit.new(),
      Toolbar.new(sideInsets),
      Theme.shared(insets, keysHeight),
      {
        keyboardHeight: keysHeight,
        keyboardStyle: {
          backgroundStyle: Theme.keyboardBackgroundName,
          // 按键区整体的左右边距，与键间距是两回事，见 Metrics.keyboardAreaInsets
          insets: Metrics.keyboardAreaInsets[device][orientation],
        },
        keyboardLayout: keyboardLayout,
      },
      Style.merge([
        Keys.charKey(entry[0], entry[1], fontSize=Fonts.symbolKeyLabel)
        for entry in rowOne + rowTwo + rowThree
      ]),
      Keys.punctuationKey(ltId, '<', null, Keys.widths.unit),
      Keys.punctuationKey(gtId, '>', null, Keys.widths.unit),
      FunctionKeys.switchKeyboard(numericName, '?123', 'numeric', Keys.widths.rowThreeLeft),
      FunctionKeys.backspace(backspaceName, Keys.widths.rowThreeRight),
      FunctionKeys.returnPrimaryKeyboard(returnName, Keys.widths.rowFourSideLeft),
      FunctionKeys.numberPad(numberPadName, Keys.widths.unit),
      FunctionKeys.space(spaceName),
      FunctionKeys.enter(enterName, Keys.widths.rowFourSideRight),
    ]),
}
