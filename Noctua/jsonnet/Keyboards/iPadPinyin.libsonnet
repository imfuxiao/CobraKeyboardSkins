// iPad 拼音键盘：五行全键盘布局，键面是「上标 + 下标」双行 —— 版面照「彩虹」那一套。
//
// 与 iPhone 版的区别只在这个文件里：多一排数字、双标签、以及 Tab / 地球键等 iPad 专属键。
// 配色、按键构造、候选栏全部复用 Components/ 下的同一套。
//
// 这一页是五行，数字 / 符号 / 九宫格三页是四行。键盘高度不写死，按
// 「四行正常行高 + 第一排的高度」算出来：下面四行与那三页的行高分毫不差，
// 多出来的只是顶上那一排矮数字行。在 iPad 上从拼音切到数字时键不会忽胖忽瘦。
local Button = import '../Components/Button.libsonnet';
local FunctionKeys = import '../Components/FunctionKeys.libsonnet';
local Layout = import '../Components/Layout.libsonnet';
local Preedit = import '../Components/Preedit.libsonnet';
local Split = import '../Components/Split.libsonnet';
local Style = import '../Components/Style.libsonnet';
local Theme = import '../Components/Theme.libsonnet';
local Toolbar = import '../Components/Toolbar.libsonnet';
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
//   第一行 13 × 1.1 + 1.7                      = 16
//   第二行 1.7 + 13 × 1.1                      = 16
//   第三行 1.95 + 11 × 1.1 + 1.95              = 16
//   第四行 2.5 + 10 × 1.1 + 2.5                = 16
//   第五行 4 × 1.65 + 空格 9.4                  = 16
local widths = {
  normal: { size: { width: '1.1/16' } },
  backspace: { size: { width: '1.7/16' } },
  tab: { size: { width: '1.7/16' } },
  asciiMode: { size: { width: '3.9/32' } },
  enter: { size: { width: '3.9/32' } },
  shift: { size: { width: '2.5/16' } },
  bottom: { size: { width: '1.65/16' } },
};

// 第一行比其余行矮：那一排是数字与符号，不是主力输入行。
// 这也是 iPad 系统键盘的做法。整块键盘的高度就是「它 + 四行正常行高」，见下面的 keysHeight。
local firstRowStyleName = 'firstRow';
local firstRowHeight = { portrait: 48, landscape: 62 };

// 双标签的上下位置：0 是键面顶边，1 是底边
local upperLabel = { fontSize: Fonts.iPadDoubleLabel, center: { y: 0.32 } };
local lowerLabel = { fontSize: Fonts.iPadDoubleLabel, center: { y: 0.68 } };

local keyName(prefix) = prefix + 'Button';

// 双标签键：点出下排字符，Shift 或上划出上排字符
// extra 合进 Button.new 的 opts（而不是加在返回的整份样式片段外面），
// 这样 Split 覆盖块才会落在按键节点本层，不会在根节点凭空多出一个 `split` 键。
local dualKey(entry, extra={}) =
  Button.new(keyName(entry[0]), {
    role: 'letter',
    label: { text: entry[1] } + lowerLabel,
    secondaryLabel: { text: entry[2] } + upperLabel,
    action: { character: entry[1] },
    uppercasedStateAction: { character: entry[2] },
    swipeUpAction: { character: entry[2] },
  } + widths.normal + extra);

// 字母键：单标签居中，短按弹大写气泡。
// iPad 上不配长按符号网格：这一页本身就有整排数字与标点，长按再塞一层是重复。
local letterKey(character, extra={}) =
  local upper = std.asciiUpper(character);
  Button.new(keyName(character), {
    role: 'letter',
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
// 这一页任何方向都支持 Split（不像 iPhone 只有横屏）：数字行分体态整行压成 0 高，
// 与它一起消失的 backspace 靠第四行补一颗 backspaceRight；第三行原本的 enter 分体态
// 隐藏，靠第五行补一颗 enterRight——两处都是「原键隐藏、别处补一颗」的同一手法，
// 具体数值见 Components/Split.libsonnet 的 iPadWidths 注释。
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

local dualKeysOf(table, extra={}) = Style.merge([dualKey(entry, extra) for entry in table]);
local letterKeysOf(row) = Style.merge([letterKey(c, Split.width(sw.unit)) for c in std.stringChars(row)]);
local repeatedLetterKey(character) =
  Button.new(repeatedName(character), {
    role: 'letter',
    label: { text: character },
    uppercasedLabel: { text: std.asciiUpper(character) },
    hint: { label: { text: std.asciiUpper(character) } },
    action: { character: character },
    uppercasedStateAction: { character: std.asciiUpper(character) },
    size: { width: 0 },
  } + Split.width(sw.unit));

{
  // 这一页支持分体（Split）：Tab 键上划进分体，分体态下再上划一次合回来（同一个手势，
  // 见 Components/Split.libsonnet 开头的说明）。不区分竖横屏——iPad 屏宽足够，
  // 两个方向都值得分体。
  new(isPortrait=false)::
    local orientation = if isPortrait then 'portrait' else 'landscape';
    local insets = Metrics.keyInsets.iPad[orientation];
    // 下面四行按标准行高，再加上顶部那一排矮数字行
    local keysHeight = Metrics.height('iPad', orientation, 4) + firstRowHeight[orientation];

    Style.merge([
      // iPad 屏宽富余，预编辑区与候选栏两侧留白，视线不用扫过整个屏幕
      Preedit.new(Metrics.iPadSideInsets),
      Toolbar.new(Metrics.iPadSideInsets, supportsSplit=true),
      Theme.shared(insets, keysHeight),
      Split.shared,
      {
        keyboardHeight: keysHeight,
        keyboardStyle: {
          backgroundStyle: Theme.keyboardBackgroundName,
          insets: Metrics.keyboardAreaInsets.iPad[orientation],
        },
        keyboardLayout: keyboardLayout,
        // 分体态下这一行压成 0 高，整行的键不建图层，下面四行分掉整块高度
        [firstRowStyleName]: {
          size: { height: firstRowHeight[orientation] },
          split: { size: { height: 0 } },
        },
      },
      // ===== 第一行：数字与符号。分体态整行消失，不必写 split =====
      dualKeysOf(numberRow),
      // ===== 标点：分体态下让位给中缝 =====
      dualKeysOf(topPunctuation, Split.hidden),
      dualKeysOf(homePunctuation, Split.hidden),
      dualKeysOf(bottomPunctuation, Split.hidden),
      // ===== 字母 =====
      letterKeysOf(letterRows[0]),
      letterKeysOf(letterRows[1]),
      letterKeysOf(letterRows[2]),
      repeatedLetterKey('g'),
      repeatedLetterKey('v'),
      // ===== 行首行尾的功能键 =====
      FunctionKeys.tab(tabName, widths.tab + Split.width(sw.tab) + Split.enterSplitGesture),
      // 原本挂在第一行的 backspace 随第一行一起消失，第四行补一颗 backspaceRight
      FunctionKeys.backspace(backspaceName, widths.backspace + Split.hidden),
      FunctionKeys.backspace(backspaceRightName, { size: { width: 0 } } + Split.width(sw.backspace)),
      FunctionKeys.asciiMode(asciiModeName, widths.asciiMode + Split.hidden),
      // 原本挂在第三行的 enter 分体态隐藏，第五行补一颗 enterRight
      FunctionKeys.enter(enterName, widths.enter + Split.hidden),
      FunctionKeys.enter(enterRightName, { size: { width: 0 } } + Split.width(sw.enter)),
      FunctionKeys.shift(leftShiftName, widths.shift + Split.width(sw.shift)),
      FunctionKeys.shift(rightShiftName, widths.shift + Split.hidden),
      FunctionKeys.nextKeyboard(globeName, widths.bottom + Split.width(sw.globe)),
      FunctionKeys.numeric(numericLeftName, widths.bottom + Split.width(sw.keyboardType)),
      FunctionKeys.numeric(numericRightName, widths.bottom + Split.hidden),
      FunctionKeys.space(spaceName, Split.width(sw.space)),
      FunctionKeys.space(spaceRightName, { size: { width: 0 } } + Split.width(sw.space)),
      FunctionKeys.dismiss(dismissName, widths.bottom + Split.width(sw.dismiss)),
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
