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
local Split = import '../Components/Split.libsonnet';
local Style = import '../Components/Style.libsonnet';
local Theme = import '../Components/Theme.libsonnet';
local Toolbar = import '../Components/Toolbar.libsonnet';
local Fonts = import '../Constants/Fonts.libsonnet';
local Metrics = import '../Constants/Metrics.libsonnet';

local npw = Split.numberPadWidths;

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

// ===== 分体：保守方案 =====
// 九宫格拆开没有实际意义（数字键的排布不是靠左右手分工的），所以不改内部排布，
// 只在上块三列两侧、下块一行两端各让出一圈分体态才撑开的窄边——功能上仍然响应
// Split 开关，但视觉变化很轻，这是刻意的设计取舍。窄边挤占的宽度从两侧「窄列」
// （上块）与「返回 / 回车」（下块）上扣，其余键不动，具体账见 Components/Split.libsonnet
// 的 numberPadWidths 注释。
local marginLeftColumnName = 'numberPadMarginLeftColumn';
local marginRightColumnName = 'numberPadMarginRightColumn';
local marginLeftButtonName = 'numberPadMarginLeftButton';
local marginRightButtonName = 'numberPadMarginRightButton';
local bottomMarginLeftName = 'numberPadBottomMarginLeftButton';
local bottomMarginRightName = 'numberPadBottomMarginRightButton';

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
  // ===== 上块：左边距 + 左符号条 + 中九宫格 + 右功能列 + 右边距 =====
  Layout.rowOf(
    [
      Layout.column([marginLeftButtonName], marginLeftColumnName),
      Layout.column([symbolStripName], leftColumnName),
      Layout.columnOf(
        [Layout.row([Keys.keyName(digitId(digit)) for digit in row]) for row in digitRows],
        centerColumnName
      ),
      Layout.column([percentName, spaceName, backspaceName], rightColumnName),
      Layout.column([marginRightButtonName], marginRightColumnName),
    ],
    upperRegionName
  ),

  // ===== 下块：左边距 + 整屏一行 + 右边距 =====
  Layout.row(
    [bottomMarginLeftName, returnName, commaName, symbolicName, zeroName, equalName, periodName, enterName, bottomMarginRightName],
    bottomRowName
  ),
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
      // keyboardLayout 不分支（唯一一份，portrait/landscape/iPad 共用），两侧边距键
      // 因此始终在布局树上，样式定义也必须始终存在——不能只在 isSplitCapable 时才定义，
      // 否则不支持分体的场景（iPhone 竖屏）会引用到不存在的样式。
      Split.shared,
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
        // 两侧窄列在分体态收窄 14→12，给新增的边距列让出宽度（账见 Split.libsonnet）
        [leftColumnName]: upperColumns.narrow + splitOnly(Split.width(npw.upperNarrow)),
        [centerColumnName]: upperColumns.wide,
        [rightColumnName]: upperColumns.narrow + splitOnly(Split.width(npw.upperNarrow)),
        [marginLeftColumnName]: { size: { width: 0 } } + splitOnly(Split.width(npw.upperMargin)),
        [marginRightColumnName]: { size: { width: 0 } } + splitOnly(Split.width(npw.upperMargin)),
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
      // 分体开关就近挂在这颗角落键上：上下两块都在，分体后两侧都够得着
      FunctionKeys.backspace(backspaceName, splitOnly(Split.enterSplitGesture)),

      FunctionKeys.returnPrimaryKeyboard(
        returnName, bottomWidths.side + splitOnly(Split.width(npw.bottomSide))
      ),
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
      FunctionKeys.enter(
        enterName, bottomWidths.side + splitOnly(Split.width(npw.bottomSide))
      ),
      // 两侧边距键：始终存在（平时 0 宽，真实样式节点、无 action），分体态才撑开；
      // 不支持分体的场景（iPhone 竖屏）split 覆盖块干脆不写，逐像素不变，
      // 见 docs/键盘Split状态.md 2.1（不能直接用 Split.spacer：那个帮手固定带 split 块，
      // 这里要按 isSplitCapable 决定要不要这个块）。
      { [marginLeftButtonName]: { backgroundStyle: Split.blankBackgroundName, size: { width: 0 } } + splitOnly(Split.width(npw.upperMargin)) },
      { [marginRightButtonName]: { backgroundStyle: Split.blankBackgroundName, size: { width: 0 } } + splitOnly(Split.width(npw.upperMargin)) },
      { [bottomMarginLeftName]: { backgroundStyle: Split.blankBackgroundName, size: { width: 0 } } + splitOnly(Split.width(npw.bottomMargin)) },
      { [bottomMarginRightName]: { backgroundStyle: Split.blankBackgroundName, size: { width: 0 } } + splitOnly(Split.width(npw.bottomMargin)) },
    ]),
}
