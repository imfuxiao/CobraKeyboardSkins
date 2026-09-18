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
local Style = import '../Components/Style.libsonnet';
local Theme = import '../Components/Theme.libsonnet';
local Toolbar = import '../Components/Toolbar.libsonnet';
local Fonts = import '../Constants/Fonts.libsonnet';
local Metrics = import '../Constants/Metrics.libsonnet';

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
local dualKey(entry) =
  Button.new(keyName(entry[0]), {
    role: 'letter',
    label: { text: entry[1] } + lowerLabel,
    secondaryLabel: { text: entry[2] } + upperLabel,
    action: { character: entry[1] },
    uppercasedStateAction: { character: entry[2] },
    swipeUpAction: { character: entry[2] },
  } + widths.normal);

// 字母键：单标签居中，短按弹大写气泡。
// iPad 上不配长按符号网格：这一页本身就有整排数字与标点，长按再塞一层是重复。
local letterKey(character) =
  local upper = std.asciiUpper(character);
  Button.new(keyName(character), {
    role: 'letter',
    label: { text: character },
    uppercasedLabel: { text: upper },
    hint: { label: { text: upper } },
    action: { character: character },
    uppercasedStateAction: { character: upper },
  } + widths.normal);

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

local keyboardLayout = [
  Layout.row(names(numberRow) + [backspaceName], firstRowStyleName),
  Layout.row([tabName] + letterNames(letterRows[0]) + names(topPunctuation)),
  Layout.row([asciiModeName] + letterNames(letterRows[1]) + names(homePunctuation) + [enterName]),
  Layout.row([leftShiftName] + letterNames(letterRows[2]) + names(bottomPunctuation) + [rightShiftName]),
  Layout.row([globeName, numericLeftName, spaceName, numericRightName, dismissName]),
];

local dualKeysOf(table) = Style.merge([dualKey(entry) for entry in table]);
local letterKeysOf(row) = Style.merge([letterKey(c) for c in std.stringChars(row)]);

{
  new(isPortrait=false)::
    local orientation = if isPortrait then 'portrait' else 'landscape';
    local insets = Metrics.keyInsets.iPad[orientation];
    // 下面四行按标准行高，再加上顶部那一排矮数字行
    local keysHeight = Metrics.height('iPad', orientation, 4) + firstRowHeight[orientation];

    Style.merge([
      // iPad 屏宽富余，预编辑区与候选栏两侧留白，视线不用扫过整个屏幕
      Preedit.new(Metrics.iPadSideInsets),
      Toolbar.new(Metrics.iPadSideInsets),
      Theme.shared(insets, keysHeight),
      {
        keyboardHeight: keysHeight,
        keyboardStyle: {
          backgroundStyle: Theme.keyboardBackgroundName,
          insets: Metrics.keyboardAreaInsets.iPad[orientation],
        },
        keyboardLayout: keyboardLayout,
        [firstRowStyleName]: { size: { height: firstRowHeight[orientation] } },
      },
      dualKeysOf(numberRow),
      dualKeysOf(topPunctuation),
      dualKeysOf(homePunctuation),
      dualKeysOf(bottomPunctuation),
      letterKeysOf(letterRows[0]),
      letterKeysOf(letterRows[1]),
      letterKeysOf(letterRows[2]),
      FunctionKeys.tab(tabName, widths.tab),
      FunctionKeys.backspace(backspaceName, widths.backspace),
      FunctionKeys.asciiMode(asciiModeName, widths.asciiMode),
      FunctionKeys.enter(enterName, widths.enter),
      FunctionKeys.shift(leftShiftName, widths.shift),
      FunctionKeys.shift(rightShiftName, widths.shift),
      FunctionKeys.nextKeyboard(globeName, widths.bottom),
      FunctionKeys.numeric(numericLeftName, widths.bottom),
      FunctionKeys.numeric(numericRightName, widths.bottom),
      FunctionKeys.space(spaceName),
      FunctionKeys.dismiss(dismissName, widths.bottom),
    ]),
}
