// 数字键盘：中间九宫格数字，两侧挂符号与功能键。
//
// 布局由 Constants/Colors 的角色表着色，规律与拼音键盘一致——
// 彩色集中在最外两列，中间三列数字保持云白留白。
//
// 色相仍然只看水平位置，但这里是**按整块九宫格算的**：横屏与 iPad 上九宫格只占左半屏，
// 若按整屏算，十档彩虹就会被挤进左边 45%，右半的符号面板反而没有颜色可分。
// 所以九宫格自成一条彩虹，竖屏与横屏的同一颗键因此颜色一致。
//
// 屏幕够宽时（横屏、iPad）右侧再挂一块分类符号面板，由 symbolPanel 开关控制。
//
// 支持 Split 的场景（iPhone 横屏 + iPad 两个方向）在 config.yaml 里全部对应
// symbolPanel=true（双栏），唯一的单栏场景是 iPhone 竖屏，本来就不支持 Split，
// 所以 Split 只需要处理 wideLayout，不必为 compactLayout 另设一张表。
// 分体手势挂在左列顶部的 #+= 键上（这一页没有天然的「Tab/Shift」角落键，
// #+= 是左列唯一贯穿合并 / 分体两态都还在的功能键）。
local Button = import '../Components/Button.libsonnet';
local FunctionKeys = import '../Components/FunctionKeys.libsonnet';
local Layout = import '../Components/Layout.libsonnet';
local Preedit = import '../Components/Preedit.libsonnet';
local Split = import '../Components/Split.libsonnet';
local Style = import '../Components/Style.libsonnet';
local Theme = import '../Components/Theme.libsonnet';
local Toolbar = import '../Components/Toolbar.libsonnet';
local Colors = import '../Constants/Colors.libsonnet';
local Fonts = import '../Constants/Fonts.libsonnet';
local Metrics = import '../Constants/Metrics.libsonnet';

local sw = Split.numericGridWidths;

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

// ===== 表三：色带 =====
// 五列的宽度就是色带的刻度：符号列 -> 玫红，三列数字 -> 琥珀 / 翠绿 / 天蓝，
// 最右的功能列 -> 紫罗兰，与拼音键盘上「左暖右冷」的走向一致。
local columnCenters = Layout.centers([17, 22, 22, 22, 17]);
local at(treatment, column) = Colors.roleAt(treatment, columnCenters[column]);

local keyName(digit) = digitNames[std.parseInt(digit)] + 'Button';

// 数字键：键面大一号，右上角带上划符号角标
local digitKey(entry, role) =
  Button.new(keyName(entry[0]), {
    role: role,
    label: { text: entry[0], fontSize: Fonts.numericKeyLabel },
    badge: { text: entry[1] },
    action: { character: entry[0] },
    swipeUpAction: { character: entry[1] },
  });

// 小数点：数字键盘上直接上屏，有预编辑文本时才交给输入方案处理
local periodName = 'periodButton';
local periodKey = Button.new(periodName, {
  role: at('pale', 4),
  label: { text: '.', fontSize: Fonts.numericKeyLabel },
  badge: { text: ',' },
  action: { symbol: '.' },
  preeditStateAction: { character: '.' },
  swipeUpAction: { character: ',' },
});

// 等号是整块键盘上唯一不跟位置走的键：最右列已经是一条紫罗兰，
// 再多一颗紫的就分不出主次了，所以点名主题色玫红，把它从那一列里拎出来。
local equalName = 'equalButton';
local equalKey = Button.new(equalName, {
  role: Colors.role('solid', 'rose'),
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
    backgroundStyle: Theme.backgroundName(at('space', 0)),
    separatorLineColor: Theme.dividerColor,
  },
};

local categoryPanelName = 'numericCategoryPanel';
local categoryPanel = {
  [categoryPanelName]: {
    type: 'categorySymbols',
    insets: { top: 4, left: 4, bottom: 4, right: 4 },
    backgroundStyle: Theme.backgroundName(at('space', 2)),
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

// ===== 分体版面（只用于双栏 wideLayout）=====
// 左右两个半屏内部排布完全不动，只在整行最外侧（左半屏最左边、右半屏最右边）
// 各加一圈分体态才撑开的窄边，两个半屏因此各让出同样的宽度给外侧留白，
// 中间的 gap 不动。账目见 Components/Split.libsonnet 的 numericGridWidths 注释。
local splitMarginLeftName = 'splitMarginLeftColumn';
local splitMarginRightName = 'splitMarginRightColumn';
local splitLayout = [
  Layout.column([splitMarginLeftName], splitMarginLeftName),
  { VStack: { style: halfColumnStyleName, subviews: numericColumns } },
  Layout.column([gapCellName], gapColumnStyleName),
  { VStack: { style: halfColumnStyleName, subviews: [{ Cell: categoryPanelName }] } },
  Layout.column([splitMarginRightName], splitMarginRightName),
];

{
  // device       'iPhone' / 'iPad'，决定键盘高度与按键间距
  // isPortrait   竖屏 / 横屏
  // symbolPanel  是否在右侧挂一块分类符号面板（屏幕够宽时才开）
  new(device='iPhone', isPortrait=true, symbolPanel=false)::
    local orientation = if isPortrait then 'portrait' else 'landscape';
    local insets = Metrics.keyInsets[device][orientation];
    // 支持 Split 的场景：iPad 不分方向、iPhone 只在横屏——与 config.yaml 里
    // symbolPanel=true 的场景完全重合，但仍按条件算，不写死假设。
    local isSplitCapable = symbolPanel && (device == 'iPad' || !isPortrait);

    Style.merge([
      Preedit.new(),
      Toolbar.new(supportsSplit=isSplitCapable),
      Theme.shared(insets, Metrics.keyboardHeight[device][orientation]),
      if isSplitCapable then Split.shared else {},
      {
        keyboardHeight: Metrics.keyboardHeight[device][orientation],
        keyboardStyle: { backgroundStyle: Theme.keyboardBackgroundName },
        keyboardLayout:
          if isSplitCapable then splitLayout
          else if symbolPanel then wideLayout
          else compactLayout,
        [narrowColumnStyleName]: columnWidths.narrow,
        [wideColumnStyleName]: columnWidths.wide,
      } + (
        if symbolPanel then {
          [halfColumnStyleName]: columnWidths.half + (
            if isSplitCapable then { split: { size: { width: sw.half } } } else {}
          ),
          [gapColumnStyleName]: columnWidths.gap,
          [gapCellName]: {},
        } else {}
      ) + (
        if isSplitCapable then
          Split.spacer(splitMarginLeftName, sw.margin) + Split.spacer(splitMarginRightName, sw.margin)
        else {}
      ),
      symbolList,
      if symbolPanel then categoryPanel else {},
      Style.merge([
        digitKey(entry, at('plain', column + 1))
        for column in std.range(0, std.length(digitColumns) - 1)
        for entry in digitColumns[column]
      ]),
      digitKey(zeroKey, at('plain', 2)),
      periodKey,
      equalKey,
      // #+= 只占最左列的四分之一高，上面留给符号列表。这一页没有天然的
      // 「Tab/Shift」角落键，#+= 是左列唯一贯穿合并 / 分体两态都还在的功能键，
      // 分体手势就借它的上划。
      FunctionKeys.symbolic(
        symbolicName, at('pale', 0),
        { size: { height: '1/4' } } + (if isSplitCapable then Split.enterSplitGesture else {})
      ),
      FunctionKeys.returnLastKeyboard(returnName, at('pale', 1)),
      FunctionKeys.space(spaceName, at('space', 3)),
      FunctionKeys.backspace(backspaceName, at('solid', 4)),
      // 回车的强调态（前往 / 发送 / 完成）不跟位置走，点名主题色玫红
      FunctionKeys.enter(enterName, at('solid', 4), Colors.role('solid', 'rose')),
    ]),
}
