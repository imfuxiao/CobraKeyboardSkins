// iPad 拼音键盘：五行全键盘布局，键面是「上标 + 下标」双行。
//
// 与 iPhone 版的区别只在这个文件里：更多的行、双标签、以及 Tab / 地球键等 iPad 专属键。
// 配色、按键构造、候选栏全部复用 Components/ 下的同一套。
//
// 色相同样只看水平位置（竖条纹）：iPad 一行有十几颗键，十档彩虹平铺过去，
// 相邻两三颗键才换一档，条纹比 iPhone 上更宽，正好对上表带织纹放大后的样子。
//
// 这一页支持分体（Split）：Tab 键上划进分体，分体态下再上划一次合回来（同一个手势，
// 见 Components/Split.libsonnet 开头的说明）。不区分竖横屏——iPad 屏宽足够，
// 两个方向都值得分体。
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

local sw = Split.iPadWidths;

// ===== 表一：双标签键 =====
// [样式名前缀, 下排字符（直接点）, 上排字符（Shift 或上划）]
local numberRow = [
  ['grave', '`', '~'],
  ['one', '1', '!'],
  ['two', '2', '@'],
  ['three', '3', '#'],
  ['four', '4', '$'],
  ['five', '5', '%'],
  ['six', '6', '^'],
  ['seven', '7', '&'],
  ['eight', '8', '*'],
  ['nine', '9', '('],
  ['zero', '0', ')'],
  ['hyphen', '-', '_'],
  ['equal', '=', '+'],
];

local topPunctuation = [
  ['bracketLeft', '【', '「'],
  ['bracketRight', '】', '」'],
  ['ideographicComma', '、', '|'],
];

local homePunctuation = [
  ['semicolon', '；', '：'],
  ['quote', '‘', '“'],
];

local bottomPunctuation = [
  ['comma', '，', '《'],
  ['period', '。', '》'],
  ['slash', '/', '？'],
];

// ===== 表二：字母 =====
local letterRows = [
  'qwertyuiop',
  'asdfghjkl',
  'zxcvbnm',
];

// ===== 表三：宽度（分母 16，每行加起来正好 16）=====
local widths = {
  normal: { size: { width: '1.1/16' } },
  backspace: { size: { width: '1.7/16' } },
  tab: { size: { width: '1.7/16' } },
  asciiMode: { size: { width: '3.9/32' } },
  enter: { size: { width: '3.9/32' } },
  shift: { size: { width: '2.5/16' } },
  bottom: { size: { width: '1.65/16' } },
};

// ===== 表四：色带 =====
// 与表三同一套宽度，换成相对分子排成每行一列，用来算每颗键的水平中心 -> 色相。
// 第五行的空格不写 size，吃掉剩余的 16 - 4 × 1.65 = 9.4。
local n(count, unit) = [unit for _ in std.range(1, count)];
local rowUnits = [
  n(13, 1.1) + [1.7],
  [1.7] + n(13, 1.1),
  [1.95] + n(11, 1.1) + [1.95],
  [2.5] + n(10, 1.1) + [2.5],
  [1.65, 1.65, 9.4, 1.65, 1.65],
];
local centers = [Layout.centers(units) for units in rowUnits];
local at(treatment, row, slot) = Colors.roleAt(treatment, centers[row][slot]);

// 第一行比其余行矮，单独给一个只用来取高度的样式
local firstRowStyleName = 'firstRow';
local firstRowHeight = { portrait: 55, landscape: 70 };

// 双标签的上下位置：0 是键面顶边，1 是底边
local upperLabel = { fontSize: Fonts.iPadDoubleLabel, center: { y: 0.32 } };
local lowerLabel = { fontSize: Fonts.iPadDoubleLabel, center: { y: 0.68 } };

local keyName(prefix) = prefix + 'Button';

// 双标签键：点出下排字符，Shift 或上划出上排字符。
// extra 合进 Button.new 的 opts（而不是加在返回的整份样式片段外面），
// 这样 Split 覆盖块才会落在按键节点本层，不会在根节点凭空多出一个 `split` 键。
local dualKey(entry, role, extra={}) =
  local name = keyName(entry[0]);
  local lower = entry[1];
  local upper = entry[2];
  Button.new(name, {
    role: role,
    label: { text: lower } + lowerLabel,
    secondaryLabel: { text: upper } + upperLabel,
    action: { character: lower },
    uppercasedStateAction: { character: upper },
    swipeUpAction: { character: upper },
  } + widths.normal + extra);

// 字母键：单标签居中，短按弹大写气泡。
// iPad 上不配长按符号网格：这一页本身就有整排数字与标点，长按再塞一层是重复。
local letterKey(character, role, extra={}) =
  local upper = std.asciiUpper(character);
  Button.new(keyName(character), {
    role: role,
    label: { text: character },
    uppercasedLabel: { text: upper },
    hint: { label: { text: upper } },
    action: { character: character },
    uppercasedStateAction: { character: upper },
  } + widths.normal + extra);

local tabName = 'tabButton';
local backspaceName = 'backspaceButton';
local asciiModeName = 'asciiModeButton';
local enterName = 'enterButton';
local leftShiftName = 'leftShiftButton';
local rightShiftName = 'rightShiftButton';
local globeName = 'globeButton';
local numericLeftName = 'numericButton';
local numericRightName = 'numericRightButton';
local spaceName = 'spaceButton';
local dismissName = 'dismissButton';

local names(table) = [keyName(entry[0]) for entry in table];
local letterNames(row) = [keyName(c) for c in std.stringChars(row)];

// ===== 分体版面要用到的新键 =====
// 这一页任何方向都支持 Split：数字行分体态整行压成 0 高，与它一起消失的 backspace
// 靠第四行补一颗 backspaceRight；第三行原本的 enter 分体态隐藏，靠第五行补一颗
// enterRight——两处都是「原键隐藏、别处补一颗」的同一手法，具体数值见
// Components/Split.libsonnet 的 iPadWidths 注释。
local gapTopName = 'splitGapTopButton';
local padTopName = 'splitPadTopButton';
local padHomeLeftName = 'splitPadHomeLeftButton';
local gapHomeName = 'splitGapHomeButton';
local padHomeRightName = 'splitPadHomeRightButton';
local padBottomLeftName = 'splitPadBottomLeftButton';
local gapBottomName = 'splitGapBottomButton';
local padBottomRightName = 'splitPadBottomRightButton';
local gapSpaceName = 'splitGapSpaceButton';
local backspaceRightName = 'backspaceRightButton';
local spaceRightName = 'spaceRightButton';
local enterRightName = 'enterRightButton';
local repeatedName(c) = c + 'SplitButton';

local keyboardLayout = [
  // 第一行（数字行）在分体态下高度为 0，整行连同键一起消失，不必写中缝
  Layout.row(names(numberRow) + [backspaceName], firstRowStyleName),
  Layout.row(
    [tabName] + letterNames('qwert') + [gapTopName] + letterNames('yuiop')
    + names(topPunctuation) + [padTopName]
  ),
  Layout.row(
    [asciiModeName, padHomeLeftName] + letterNames('asdfg') + [gapHomeName, repeatedName('g')]
    + letterNames('hjkl') + names(homePunctuation) + [enterName, padHomeRightName]
  ),
  Layout.row(
    [padBottomLeftName, leftShiftName] + letterNames('zxcv') + [gapBottomName, repeatedName('v')]
    + letterNames('bnm') + names(bottomPunctuation) + [backspaceRightName, rightShiftName, padBottomRightName]
  ),
  Layout.row([globeName, numericLeftName, spaceName, gapSpaceName, spaceRightName, enterRightName, numericRightName, dismissName]),
];

// 每一行里的白键面：行号 + 该行第一颗白键的位置 + 那张表
local dualKeysOf(table, row, firstSlot, extra={}) = Style.merge([
  dualKey(table[i], at('plain', row, firstSlot + i), extra)
  for i in std.range(0, std.length(table) - 1)
]);
local letterKeysOf(row, rowIndex, firstSlot, extra={}) = Style.merge([
  letterKey(std.stringChars(row)[i], at('plain', rowIndex, firstSlot + i), extra)
  for i in std.range(0, std.length(row) - 1)
]);

{
  new(isPortrait=false)::
    local orientation = if isPortrait then 'portrait' else 'landscape';
    local insets = Metrics.keyInsets.iPad[orientation];

    Style.merge([
      // iPad 屏宽富余，预编辑区与候选栏两侧留白，视线不用扫过整个屏幕
      Preedit.new(Metrics.iPadSideInsets),
      Toolbar.new(Metrics.iPadSideInsets, supportsSplit=true),
      Theme.shared(insets, Metrics.keyboardHeight.iPad[orientation]),
      Split.shared,
      {
        keyboardHeight: Metrics.keyboardHeight.iPad[orientation],
        keyboardStyle: { backgroundStyle: Theme.keyboardBackgroundName },
        keyboardLayout: keyboardLayout,
        // 分体态下这一行压成 0 高，整行的键不建图层，下面四行分掉整块高度
        [firstRowStyleName]: {
          size: { height: firstRowHeight[orientation] },
          split: { size: { height: 0 } },
        },
      },
      // ===== 第一行：数字与符号。分体态整行消失，不必写 split =====
      dualKeysOf(numberRow, 0, 0),
      // ===== 标点：分体态下让位给中缝 =====
      dualKeysOf(topPunctuation, 1, 11, Split.hidden),
      dualKeysOf(homePunctuation, 2, 10, Split.hidden),
      dualKeysOf(bottomPunctuation, 3, 8, Split.hidden),
      // ===== 字母 =====
      letterKeysOf(letterRows[0], 1, 1, Split.width(sw.unit)),
      letterKeysOf(letterRows[1], 2, 1, Split.width(sw.unit)),
      letterKeysOf(letterRows[2], 3, 1, Split.width(sw.unit)),
      Button.new(repeatedName('g'), {
        role: at('plain', 2, 5),
        label: { text: 'g' },
        uppercasedLabel: { text: 'G' },
        hint: { label: { text: 'G' } },
        action: { character: 'g' },
        uppercasedStateAction: { character: 'G' },
        size: { width: 0 },
      } + Split.width(sw.unit)),
      Button.new(repeatedName('v'), {
        role: at('plain', 3, 4),
        label: { text: 'v' },
        uppercasedLabel: { text: 'V' },
        hint: { label: { text: 'V' } },
        action: { character: 'v' },
        uppercasedStateAction: { character: 'V' },
        size: { width: 0 },
      } + Split.width(sw.unit)),
      // ===== 行首行尾的功能键 =====
      // Tab 键分体后变窄，仍是 Tab；上划进 / 出分体是同一个手势
      FunctionKeys.tab(tabName, at('pale', 1, 0), widths.tab + Split.width(sw.tab) + Split.enterSplitGesture),
      // 原本挂在第一行的 backspace 随第一行一起消失，第四行补一颗 backspaceRight
      FunctionKeys.backspace(backspaceName, at('solid', 0, 13), widths.backspace + Split.hidden),
      FunctionKeys.backspace(
        backspaceRightName, at('solid', 3, 9), { size: { width: 0 } } + Split.width(sw.backspace)
      ),
      FunctionKeys.asciiMode(asciiModeName, at('stone', 2, 0), widths.asciiMode + Split.hidden),
      // 原本挂在第三行的 enter 分体态隐藏，第五行补一颗 enterRight
      // 回车的强调态（前往 / 发送 / 完成）不跟位置走，点名主题色玫红
      FunctionKeys.enter(enterName, at('solid', 2, 12), Colors.role('solid', 'rose'), widths.enter + Split.hidden),
      FunctionKeys.enter(
        enterRightName, at('solid', 4, 3), Colors.role('solid', 'rose'),
        { size: { width: 0 } } + Split.width(sw.enter)
      ),
      FunctionKeys.shift(leftShiftName, at('solid', 3, 0), widths.shift + Split.width(sw.shift)),
      FunctionKeys.shift(rightShiftName, at('solid', 3, 11), widths.shift + Split.hidden),
      FunctionKeys.nextKeyboard(globeName, at('stone', 4, 0), widths.bottom + Split.width(sw.globe)),
      FunctionKeys.numeric(numericLeftName, at('pale', 4, 1), widths.bottom + Split.width(sw.keyboardType)),
      FunctionKeys.numeric(numericRightName, at('pale', 4, 3), widths.bottom + Split.hidden),
      FunctionKeys.space(spaceName, at('space', 4, 2), Split.width(sw.space)),
      FunctionKeys.space(spaceRightName, at('space', 4, 2), { size: { width: 0 } } + Split.width(sw.space)),
      FunctionKeys.dismiss(dismissName, at('stone', 4, 4), widths.bottom + Split.width(sw.dismiss)),
      // ===== 中缝与两侧留白 =====
      Split.spacer(gapTopName, sw.gapTop),
      Split.spacer(padTopName, sw.pad),
      Split.spacer(padHomeLeftName, sw.padHome),
      Split.spacer(gapHomeName, sw.gapHome),
      Split.spacer(padHomeRightName, sw.padHome),
      Split.spacer(padBottomLeftName, sw.pad),
      Split.spacer(gapBottomName, sw.gapBottom),
      Split.spacer(padBottomRightName, sw.pad),
      Split.spacer(gapSpaceName, sw.gapSpace),
    ]),
}
