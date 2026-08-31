// 数字键盘：中间九宫格数字，两侧挂符号与功能键。
//
// 布局由 Constants/Colors 的角色表着色，规律与拼音键盘一致——
// 彩色集中在最外两列，中间的数字区保持奶白留白。
//
// 屏幕够宽时（横屏、iPad）右侧再挂一块分类符号面板，由 symbolPanel 开关控制。
local Button = import '../Components/Button.libsonnet';
local FunctionKeys = import '../Components/FunctionKeys.libsonnet';
local Layout = import '../Components/Layout.libsonnet';
local Preedit = import '../Components/Preedit.libsonnet';
local Style = import '../Components/Style.libsonnet';
local Theme = import '../Components/Theme.libsonnet';
local Toolbar = import '../Components/Toolbar.libsonnet';
local Fonts = import '../Constants/Fonts.libsonnet';
local Metrics = import '../Constants/Metrics.libsonnet';

// ===== 表一：九宫格数字与它们的上划符号 =====
// 三列，每列自上而下。第四行不是数字，单独排。
local digitColumns = [
  [['1', '!'], ['4', '$'], ['7', '&']],
  [['2', '@'], ['5', '%'], ['8', '*']],
  [['3', '#'], ['6', '^'], ['9', '(']],
];
local zeroKey = ['0', ')'];

local digitNames = ['zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine'];

// ===== 表二：列宽（分母 100，一行加起来正好 100）=====
local columnWidths = {
  narrow: { size: { width: '17/100' } },  // 最左的符号列与最右的功能列
  wide: { size: { width: '22/100' } },  // 中间三列数字
  half: { size: { width: '45/100' } },  // 双栏时的左右两半
  gap: { size: { width: '10/100' } },  // 双栏中间的空隙
};

local keyName(digit) = digitNames[std.parseInt(digit)] + 'Button';

// 数字键：键面大一号，右上角带上划符号角标
local digitKey(entry) =
  Button.new(keyName(entry[0]), {
    role: 'letter',
    label: { text: entry[0], fontSize: Fonts.numericKeyLabel },
    badge: { text: entry[1] },
    action: { character: entry[0] },
    swipeUpAction: { character: entry[1] },
  });

// 小数点：数字键盘上直接上屏，有预编辑文本时才交给输入方案处理
local periodName = 'periodButton';
local periodKey = Button.new(periodName, {
  role: 'symbol',
  label: { text: '.', fontSize: Fonts.numericKeyLabel },
  badge: { text: ',' },
  action: { symbol: '.' },
  preeditStateAction: { character: '.' },
  swipeUpAction: { character: ',' },
});

local equalName = 'equalButton';
local equalKey = Button.new(equalName, {
  role: 'operator',
  label: { text: '=', fontSize: Fonts.numericKeyLabel },
  badge: { text: '+' },
  action: { character: '=' },
  swipeUpAction: { character: '+' },
});

// ===== 集合视图 =====
// 这两块面板由引擎自己填内容（符号取自 App 内的「数字键盘符号」设置），
// 皮肤能定的只有背景、内边距与分隔线；它们的 cellStyle 引擎读了但不用，所以不写。
local symbolListName = 'numericSymbolList';
local symbolList = {
  [symbolListName]: {
    type: 'numericSymbols',
    insets: { top: 8, left: 4, bottom: 4, right: 4 },
    backgroundStyle: Theme.backgroundName('space'),
    separatorLineColor: Theme.dividerColor,
  },
};

local categoryPanelName = 'numericCategoryPanel';
local categoryPanel = {
  [categoryPanelName]: {
    type: 'categorySymbols',
    insets: { top: 4, left: 4, bottom: 4, right: 4 },
    backgroundStyle: Theme.backgroundName('space'),
  },
};

local symbolicName = 'symbolicButton';
local returnName = 'returnLastKeyboardButton';
local spaceName = 'spaceButton';
local backspaceName = 'backspaceButton';
local enterName = 'enterButton';

// ===== 五列九宫格 =====
// 只用来取宽度的样式名，同一份宽度在双栏布局里也复用
local narrowColumnStyleName = 'narrowColumn';
local wideColumnStyleName = 'wideColumn';
local halfColumnStyleName = 'halfColumn';
local gapColumnStyleName = 'gapColumn';
// 既无背景也无前景的空按键，只用来占位
local gapCellName = 'layoutSpacer';

local numericColumns = [
  // 最左：符号列表占四分之三高，下面压一颗 #+=
  Layout.column([symbolListName, symbolicName], narrowColumnStyleName),
  Layout.column([keyName(entry[0]) for entry in digitColumns[0]] + [returnName], wideColumnStyleName),
  Layout.column([keyName(entry[0]) for entry in digitColumns[1]] + [keyName(zeroKey[0])], wideColumnStyleName),
  Layout.column([keyName(entry[0]) for entry in digitColumns[2]] + [spaceName], wideColumnStyleName),
  // 最右：删除 / 小数点 / 等号 / 回车
  Layout.column([backspaceName, periodName, equalName, enterName], narrowColumnStyleName),
];

// 单栏：整屏就是九宫格
local compactLayout = numericColumns;

// 双栏：左半九宫格，右半分类符号面板，中间留一条空隙
local wideLayout = [
  { VStack: { style: halfColumnStyleName, subviews: numericColumns } },
  Layout.column([gapCellName], gapColumnStyleName),
  { VStack: { style: halfColumnStyleName, subviews: [{ Cell: categoryPanelName }] } },
];

{
  // device       'iPhone' / 'iPad'，决定键盘高度与按键间距
  // isPortrait   竖屏 / 横屏
  // symbolPanel  是否在右侧挂一块分类符号面板（屏幕够宽时才开）
  new(device='iPhone', isPortrait=true, symbolPanel=false)::
    local orientation = if isPortrait then 'portrait' else 'landscape';
    local insets = Metrics.keyInsets[device][orientation];

    Style.merge([
      Preedit.new(),
      Toolbar.new(),
      Theme.shared(insets, Metrics.keyboardHeight[device][orientation]),
      {
        keyboardHeight: Metrics.keyboardHeight[device][orientation],
        keyboardStyle: { backgroundStyle: Theme.keyboardBackgroundName },
        keyboardLayout: if symbolPanel then wideLayout else compactLayout,
        [narrowColumnStyleName]: columnWidths.narrow,
        [wideColumnStyleName]: columnWidths.wide,
      } + (
        if symbolPanel then {
          [halfColumnStyleName]: columnWidths.half,
          [gapColumnStyleName]: columnWidths.gap,
          [gapCellName]: {},
        } else {}
      ),
      symbolList,
      if symbolPanel then categoryPanel else {},
      Style.merge([digitKey(entry) for column in digitColumns for entry in column]),
      digitKey(zeroKey),
      periodKey,
      equalKey,
      // #+= 只占最左列的四分之一高，上面留给符号列表
      FunctionKeys.symbolic(symbolicName, { size: { height: '1/4' } }),
      FunctionKeys.returnLastKeyboard(returnName),
      FunctionKeys.space(spaceName),
      FunctionKeys.backspace(backspaceName),
      FunctionKeys.enter(enterName),
    ]),
}
