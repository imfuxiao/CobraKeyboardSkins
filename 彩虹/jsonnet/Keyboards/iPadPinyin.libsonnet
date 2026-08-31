// iPad 拼音键盘：五行全键盘布局，键面是「上标 + 下标」双行。
//
// 与 iPhone 版的区别只在这个文件里：更多的行、双标签、以及 Tab / 地球键等 iPad 专属键。
// 配色、按键构造、候选栏全部复用 Components/ 下的同一套。
//
// 色相同样只看水平位置（竖条纹）：iPad 一行有十几颗键，十档彩虹平铺过去，
// 相邻两三颗键才换一档，条纹比 iPhone 上更宽，正好对上表带织纹放大后的样子。
local Button = import '../Components/Button.libsonnet';
local FunctionKeys = import '../Components/FunctionKeys.libsonnet';
local Layout = import '../Components/Layout.libsonnet';
local Preedit = import '../Components/Preedit.libsonnet';
local Style = import '../Components/Style.libsonnet';
local Theme = import '../Components/Theme.libsonnet';
local Toolbar = import '../Components/Toolbar.libsonnet';
local Colors = import '../Constants/Colors.libsonnet';
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

// 双标签键：点出下排字符，Shift 或上划出上排字符
local dualKey(entry, role) =
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
  } + widths.normal);

// 字母键：单标签居中，短按弹大写气泡
local letterKey(character, role) =
  local upper = std.asciiUpper(character);
  Button.new(keyName(character), {
    role: role,
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

// 每一行里的白键面：行号 + 该行第一颗白键的位置 + 那张表
local dualKeysOf(table, row, firstSlot) = Style.merge([
  dualKey(table[i], at('plain', row, firstSlot + i))
  for i in std.range(0, std.length(table) - 1)
]);
local letterKeysOf(row, rowIndex, firstSlot) = Style.merge([
  letterKey(std.stringChars(row)[i], at('plain', rowIndex, firstSlot + i))
  for i in std.range(0, std.length(row) - 1)
]);

{
  new(isPortrait=false)::
    local orientation = if isPortrait then 'portrait' else 'landscape';
    local insets = Metrics.keyInsets.iPad[orientation];

    Style.merge([
      // iPad 屏宽富余，预编辑区与候选栏两侧留白，视线不用扫过整个屏幕
      Preedit.new(Metrics.iPadSideInsets),
      Toolbar.new(Metrics.iPadSideInsets),
      Theme.shared(insets, Metrics.keyboardHeight.iPad[orientation]),
      {
        keyboardHeight: Metrics.keyboardHeight.iPad[orientation],
        keyboardStyle: { backgroundStyle: Theme.keyboardBackgroundName },
        keyboardLayout: keyboardLayout,
        [firstRowStyleName]: { size: { height: firstRowHeight[orientation] } },
      },
      dualKeysOf(numberRow, 0, 0),
      dualKeysOf(topPunctuation, 1, 11),
      dualKeysOf(homePunctuation, 2, 10),
      dualKeysOf(bottomPunctuation, 3, 8),
      letterKeysOf(letterRows[0], 1, 1),
      letterKeysOf(letterRows[1], 2, 1),
      letterKeysOf(letterRows[2], 3, 1),
      FunctionKeys.tab(tabName, at('pale', 1, 0), widths.tab),
      FunctionKeys.backspace(backspaceName, at('solid', 0, 13), widths.backspace),
      FunctionKeys.asciiMode(asciiModeName, at('stone', 2, 0), widths.asciiMode),
      // 回车的强调态（前往 / 发送 / 完成）不跟位置走，点名主题色玫红
      FunctionKeys.enter(enterName, at('solid', 2, 12), Colors.role('solid', 'rose'), widths.enter),
      FunctionKeys.shift(leftShiftName, at('solid', 3, 0), widths.shift),
      FunctionKeys.shift(rightShiftName, at('solid', 3, 11), widths.shift),
      FunctionKeys.nextKeyboard(globeName, at('stone', 4, 0), widths.bottom),
      FunctionKeys.numeric(numericLeftName, at('pale', 4, 1), widths.bottom),
      FunctionKeys.numeric(numericRightName, at('pale', 4, 3), widths.bottom),
      FunctionKeys.space(spaceName, at('space', 4, 2)),
      FunctionKeys.dismiss(dismissName, at('stone', 4, 4), widths.bottom),
    ]),
}
