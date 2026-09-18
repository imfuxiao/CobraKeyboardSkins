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
local Style = import '../Components/Style.libsonnet';
local Theme = import '../Components/Theme.libsonnet';
local Toolbar = import '../Components/Toolbar.libsonnet';
local Fonts = import '../Constants/Fonts.libsonnet';
local Metrics = import '../Constants/Metrics.libsonnet';

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
      // 数字键面比字母大一号，符号键则收小一点——符号的字形普遍比字母宽
      Style.merge([
        Keys.charKey(entry[0], entry[1], fontSize=Fonts.numericKeyLabel)
        for entry in digitRow
      ]),
      Style.merge([
        Keys.charKey(entry[0], entry[1], fontSize=Fonts.symbolKeyLabel)
        for entry in symbolRow + punctRow
      ]),
      Keys.punctuationKey(commaId, ',', null, Keys.widths.unit),
      Keys.punctuationKey(periodId, '.', null, Keys.widths.unit),
      // 指向本皮肤的符号页（自定义类型 noctuaSymbolic），不是引擎自带的 symbolic
      FunctionKeys.switchKeyboard(symbolicName, '=\\<', 'noctuaSymbolic', Keys.widths.rowThreeLeft),
      FunctionKeys.backspace(backspaceName, Keys.widths.rowThreeRight),
      FunctionKeys.returnPrimaryKeyboard(returnName, Keys.widths.rowFourSideLeft),
      FunctionKeys.numberPad(numberPadName, Keys.widths.unit),
      FunctionKeys.space(spaceName),
      FunctionKeys.enter(enterName, Keys.widths.rowFourSideRight),
    ]),
}
