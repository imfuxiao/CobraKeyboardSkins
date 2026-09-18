// 九宫格数字键盘 —— 版面照 Gboard 那一套。
//
// 文本框本身是数字类型（`UIKeyboardType.numberPad` 一族）时用它，
// 数字 / 符号键盘上的「12·34」键也切到这里。
//
// 版面分成上下两块，上块占四分之三高、下块一行：
//
//   ┌──────┬─────────────────┬──────┐
//   │ 符号 │  1    2    3    │  %   │
//   │ 列表 │  4    5    6    │  ␣   │   ← 上块，占 3/4 高
//   │      │  7    8    9    │  ⌫   │
//   ├──────┴─────────────────┴──────┤
//   │ 返回  ,  !?#   0   =  .   ⏎   │   ← 下块，占 1/4 高
//   └───────────────────────────────┘
//
// 左侧那一条沙色符号列表是引擎自带的集合视图（内容取自 App 内「数字键盘符号」设置），
// 皮肤能定的只有背景、内边距与分隔线色。
local Button = import '../Components/Button.libsonnet';
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

// ===== 表一：九宫格里的九个数字 =====
local digitRows = [
  ['1', '2', '3'],
  ['4', '5', '6'],
  ['7', '8', '9'],
];
local digitNames = ['zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine'];
local digitId(digit) = digitNames[std.parseInt(digit)];

// ===== 表二：上块的三列宽度（分母 100，加起来正好 100）=====
local upperColumns = {
  narrow: { size: { width: '14/100' } },  // 左侧符号列表 / 右侧功能列
  wide: { size: { width: '72/100' } },  // 中间九宫格
};

// ===== 表三：下面那一行的宽度（分母 100）=====
//   返回 17 + , 10.5 + !?# 12 + 0 21 + = 12 + . 10.5 + ⏎ 17 = 100
//
// 两端的「返回」与回车取 17，与其余几页第四行两端那两颗（Keys.widths.rowFourSide*，
// 205/1125 ≈ 18/100）差不多宽，四页的第四行因此看着是同一条。
local bottomWidths = {
  side: { size: { width: '17/100' } },
  punct: { size: { width: '10.5/100' } },
  switcher: { size: { width: '12/100' } },
  zero: { size: { width: '21/100' } },
  equal: { size: { width: '12/100' } },
};

// 只用来取尺寸的样式名（这类节点不需要 buttonStyleType）
local upperRegionName = 'numberPadUpperRegion';
local bottomRowName = 'numberPadBottomRow';
local leftColumnName = 'numberPadLeftColumn';
local centerColumnName = 'numberPadCenterColumn';
local rightColumnName = 'numberPadRightColumn';

local symbolStripName = 'numberPadSymbolStrip';
local percentId = 'percent';
local percentName = Keys.keyName(percentId);
local spaceName = 'numberPadSpaceButton';
local backspaceName = 'backspaceButton';

local returnName = 'returnPrimaryKeyboardButton';
local commaId = 'comma';
local commaName = Keys.keyName(commaId);
local symbolicName = 'toSymbolicButton';
local zeroName = Keys.keyName(digitId('0'));
local equalId = 'equal';
local equalName = Keys.keyName(equalId);
local periodId = 'period';
local periodName = Keys.keyName(periodId);
local enterName = 'enterButton';

// 左侧符号列表：一整条沙色底，内容由引擎填
local symbolStrip = {
  [symbolStripName]: {
    type: 'numericSymbols',
    insets: Metrics.symbolStrip.insets,
    backgroundStyle: Theme.backgroundName('symbolStrip'),
    separatorLineColor: Theme.dividerColor,
  },
};

// 右侧功能列中间那颗空格：与两侧的 % / ⌫ 同为沙键，键面是一个 ␣ 图标
local padSpaceKey = Button.new(spaceName, {
  role: 'function',
  label: { systemImageName: 'space' },
  action: 'space',
  swipeUpAction: { shortcut: '#次选上屏' },
});

local keyboardLayout = [
  // ===== 上块：左符号条 + 中九宫格 + 右功能列 =====
  Layout.rowOf(
    [
      Layout.column([symbolStripName], leftColumnName),
      Layout.columnOf(
        [Layout.row([Keys.keyName(digitId(digit)) for digit in row]) for row in digitRows],
        centerColumnName
      ),
      Layout.column([percentName, spaceName, backspaceName], rightColumnName),
    ],
    upperRegionName
  ),

  // ===== 下块：整屏一行 =====
  Layout.row(
    [returnName, commaName, symbolicName, zeroName, equalName, periodName, enterName],
    bottomRowName
  ),
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

        // 上块三行、下块一行，所以上下按 3:1 分高度——这样九宫格的行高与
        // 其余三种键盘的行高完全一致，来回切换时键不会跳。
        [upperRegionName]: { size: { height: '3/4' } },
        [bottomRowName]: { size: { height: '1/4' } },
        [leftColumnName]: upperColumns.narrow,
        [centerColumnName]: upperColumns.wide,
        [rightColumnName]: upperColumns.narrow,
      },
      symbolStrip,
      // 九宫格里的九颗数字：键面大，不带角标——这一页要的就是干净
      Style.merge([
        Keys.charKey(digitId(digit), digit, fontSize=Fonts.numericKeyLabel)
        for row in digitRows
        for digit in row
      ]),
      Keys.punctuationKey(percentId, '%'),
      padSpaceKey,
      FunctionKeys.backspace(backspaceName),

      FunctionKeys.returnPrimaryKeyboard(returnName, bottomWidths.side),
      Keys.punctuationKey(commaId, ',', null, bottomWidths.punct),
      // !?# 切到**引擎自带的**分类符号键盘（内置 symbolic）：本皮肤没有声明 symbolic，
      // 引擎就会挂上 SymbolicView，它自带「返回」与锁定按钮，不需要皮肤配任何东西。
      // 三种键盘里只有这一颗走内置那块，其余符号入口都进本皮肤的 noctuaSymbolic。
      // 这一颗按角色本该是沙键，但它左右两边（逗号、0）都是键，三颗沙键连成一片就分不出
      // 哪颗会上屏，所以角色覆盖成 letter（米键），让这一行的沙色只留在两端。
      FunctionKeys.switchKeyboard(symbolicName, '!?#', 'symbolic', bottomWidths.switcher { role: 'letter' }),
      Keys.charKey(digitId('0'), '0', fontSize=Fonts.numericKeyLabel, opts=bottomWidths.zero),
      Keys.charKey(equalId, '=', fontSize=Fonts.numericKeyLabel, opts=bottomWidths.equal),
      Keys.punctuationKey(periodId, '.', null, bottomWidths.punct),
      FunctionKeys.enter(enterName, bottomWidths.side),
    ]),
}
