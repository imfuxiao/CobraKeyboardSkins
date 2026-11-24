// 九宫格数字键盘（竖屏与横屏共用同一份五列数字主体）。
//
// 竖屏：左侧符号栏 + 三列数字与底部控制键 + 右侧功能列。
// 横屏：左半侧复用数字主体，中间留白，右半侧为分类符号集合视图。
local Keys = import '../Constants/Keys.libsonnet';
local metrics = import '../Constants/Metrics.libsonnet';
local Button = import '../Components/Button.libsonnet';
local Layout = import '../Components/Layout.libsonnet';
local Preedit = import '../Components/Preedit.libsonnet';
local Style = import '../Components/Style.libsonnet';
local Theme = import '../Components/Theme.libsonnet';
local Toolbar = import '../Components/Toolbar.libsonnet';

local digitKeyNames = [
  'oneButton',
  'twoButton',
  'threeButton',
  'fourButton',
  'fiveButton',
  'sixButton',
  'sevenButton',
  'eightButton',
  'nineButton',
  'zeroButton',
];

local padColumns = [
  Layout.column(['numericSymbolsCollection', 'symbolicButton'], 'narrowVStackStyle'),
  Layout.column(['oneButton', 'fourButton', 'sevenButton', 'returnLastKeyboardButton'], 'wideVStackStyle'),
  Layout.column(['twoButton', 'fiveButton', 'eightButton', 'zeroButton'], 'wideVStackStyle'),
  Layout.column(['threeButton', 'sixButton', 'nineButton', 'spaceButton'], 'wideVStackStyle'),
  Layout.column(['backspaceButton', 'periodButton', 'equalButton', 'enterButton'], 'narrowVStackStyle'),
];

local landscapeLayout = [
  Layout.column(padColumns, 'halfVStackStyle'),
  Layout.emptyColumn(),
  Layout.column(['numericCategorySymbolCollection'], 'halfVStackStyle'),
];

{
  new(isPortrait=true)::
    local orientation = if isPortrait then 'portrait' else 'landscape';
    local insets = metrics.keyInsets[orientation];

    Style.merge([
      Preedit.new(),
      Toolbar.new(),
      Theme.shared(insets),
      {
        keyboardHeight: metrics.keyboardHeight[orientation],
        keyboardStyle: { backgroundStyle: Theme.keyboardBackgroundName },
        keyboardLayout: if isPortrait then padColumns else landscapeLayout,
        numericSymbolsCollection: Keys.collections.numericSymbolsCollection,
      } + (
        if isPortrait then {} else {
          numericCategorySymbolCollection: Keys.collections.numericCategorySymbolCollection,
        }
      ),

      // 0 ~ 9 数字键
      Style.merge([
        Button.alphabetic(name, Keys[name], insets, hint=null)
        for name in digitKeyNames
      ]),

      // 功能与标点键
      Button.system('symbolicButton', Keys.symbolicButton { size: { height: '1/4' } }),
      Button.system('returnLastKeyboardButton', Keys.returnLastKeyboardButton),
      Button.system('spaceButton', Keys.spaceButton),
      Button.system('backspaceButton', Keys.backspaceButton),
      Button.system('periodButton', Keys.periodButton),
      Button.system('equalButton', Keys.equalButton),
      Button.system('enterButton', Keys.enterButton {
        backgroundStyle: Theme.enterBackgroundStyle,
        foregroundStyle: Theme.enterForegroundStyle,
      }),
    ]),
}
