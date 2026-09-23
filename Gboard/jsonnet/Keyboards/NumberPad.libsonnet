// 九宫格数字键盘 —— 对应 ../../资料/九宫格数字键.png。
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
// 左侧那一条灰色符号列表是引擎自带的集合视图（内容取自 App 内「数字键盘符号」设置），
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
// 两端的胶囊取 17：这一行的行高与其余三种键盘一致（可视高 49pt），
// 胶囊要读得出是胶囊，可视宽得到 61pt 上下，也就是 17/100 减去一条缝。
// 与 Keys.widths.rowFourPillLeft 是同一笔账，见那里的说明。
local bottomWidths = {
  pill: { size: { width: '17/100' } },
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

// 左侧符号列表：一整条灰底，内容由引擎填
local symbolStrip = {
  [symbolStripName]: {
    type: 'numericSymbols',
    insets: Metrics.symbolStrip.insets,
    backgroundStyle: Theme.backgroundName('symbolStrip'),
    separatorLineColor: Theme.dividerColor,
  },
};

// 右侧功能列中间那颗空格：与两侧的 % / ⌫ 同为灰键，键面是一个 ␣ 图标
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

// ===== 分体（Split）版面 =====
// 九宫格数字键盘不是 26 键字母排布，3 列的数字网格没法拆成左右两个有意义的分体半区——
// 劈开数字格只会让数字东倒西歪、反而更难点。这里采用保守方案：**符号条 / 数字网格 /
// 右侧功能列内部排布完全不变**，只在上块的最外侧、下块整行的最外侧各加一圈分体态才
// 撑开的留白，让分体开关在这一页上仍然生效（键往边缘让一让），但不改变任何一颗
// 数字键的位置。宽度表见 Components/Split.libsonnet 的 numberPad 系列（分母 100）。
local padUpperLeftName = 'splitPadUpperLeftColumn';
local padUpperRightName = 'splitPadUpperRightColumn';
local padBottomLeftName = 'splitPadBottomLeftButton';
local padBottomRightName = 'splitPadBottomRightButton';

local splitKeyboardLayout = [
  Layout.rowOf(
    [
      Layout.column([padUpperLeftName], padUpperLeftName),
      Layout.column([symbolStripName], leftColumnName),
      Layout.columnOf(
        [Layout.row([Keys.keyName(digitId(digit)) for digit in row]) for row in digitRows],
        centerColumnName
      ),
      Layout.column([percentName, spaceName, backspaceName], rightColumnName),
      Layout.column([padUpperRightName], padUpperRightName),
    ],
    upperRegionName
  ),
  Layout.row(
    [padBottomLeftName, returnName, commaName, symbolicName, zeroName, equalName, periodName, enterName, padBottomRightName],
    bottomRowName
  ),
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

        // 上块三行、下块一行，所以上下按 3:1 分高度——这样九宫格的行高与
        // 其余三种键盘的行高完全一致，来回切换时键不会跳。
        [upperRegionName]: { size: { height: '3/4' } },
        [bottomRowName]: { size: { height: '1/4' } },
        // 分体态下三列整体等比缩小，给两侧新增的留白让位，列内排布不变
        // （见 Components/Split.libsonnet 的 numberPad 系列，分母 100）。
        [leftColumnName]: upperColumns.narrow + splitOnly(Split.width(Split.numberPadUpper.left)),
        [centerColumnName]: upperColumns.wide + splitOnly(Split.width(Split.numberPadUpper.center)),
        [rightColumnName]: upperColumns.narrow + splitOnly(Split.width(Split.numberPadUpper.right)),
      },
      symbolStrip,
      // 九宫格里的九颗数字：键面大，不带角标（设计图上这一页是干净的）
      Style.merge([
        Keys.charKey(digitId(digit), digit, fontSize=Fonts.numericKeyLabel)
        for row in digitRows
        for digit in row
      ]),
      Keys.punctuationKey(percentId, '%'),
      padSpaceKey,
      FunctionKeys.backspace(backspaceName),

      FunctionKeys.returnPrimaryKeyboard(returnName, bottomWidths.pill
        + splitOnly(Split.width(Split.numberPadBottom.pill))),
      Keys.punctuationKey(commaId, ',', null, bottomWidths.punct
        + splitOnly(Split.width(Split.numberPadBottom.punct))),
      // !?# 切到**引擎自带的**分类符号键盘（内置 symbolic）：本皮肤没有声明 symbolic，
      // 引擎就会挂上 SymbolicView，它自带「返回」与锁定按钮，不需要皮肤配任何东西。
      // 三种键盘里只有这一颗走内置那块，其余符号入口都进本皮肤的 gboardSymbolic。
      // 设计图上它是白键，所以在这里把角色覆盖成 letter。
      FunctionKeys.switchKeyboard(symbolicName, '!?#', 'symbolic', bottomWidths.switcher { role: 'letter' }
        + splitOnly(Split.width(Split.numberPadBottom.switcher))
        // 进出分体的手势挂在这颗键上：下块行首、分体后两半都用得到（切符号键盘这个功能
        // 不因为分体而只属于哪一侧），且它天然在左上角，符合「行首功能键」的一贯做法。
        + splitOnly(Split.enterSplitGesture)),
      Keys.charKey(digitId('0'), '0', fontSize=Fonts.numericKeyLabel,
                   opts=bottomWidths.zero + splitOnly(Split.width(Split.numberPadBottom.zero))),
      Keys.charKey(equalId, '=', fontSize=Fonts.numericKeyLabel,
                   opts=bottomWidths.equal + splitOnly(Split.width(Split.numberPadBottom.equal))),
      Keys.punctuationKey(periodId, '.', null, bottomWidths.punct
        + splitOnly(Split.width(Split.numberPadBottom.punct))),
      FunctionKeys.enter(enterName, bottomWidths.pill
        + splitOnly(Split.width(Split.numberPadBottom.pill))),
    ] + (
      if !isSplitCapable then [] else [
        Split.spacer(padUpperLeftName, Split.numberPadMargin),
        Split.spacer(padUpperRightName, Split.numberPadMargin),
        Split.spacer(padBottomLeftName, Split.numberPadMargin),
        Split.spacer(padBottomRightName, Split.numberPadMargin),
      ]
    )),
}
