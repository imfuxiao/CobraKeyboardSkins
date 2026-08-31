// iPhone 26 键拼音键盘。
//
// 整个键盘由下面几张表描述，加键、改上划符号、调宽度都只动表，不动代码。
local Button = import '../Components/Button.libsonnet';
local FunctionKeys = import '../Components/FunctionKeys.libsonnet';
local Layout = import '../Components/Layout.libsonnet';
local Preedit = import '../Components/Preedit.libsonnet';
local Style = import '../Components/Style.libsonnet';
local Theme = import '../Components/Theme.libsonnet';
local Toolbar = import '../Components/Toolbar.libsonnet';
local Metrics = import '../Constants/Metrics.libsonnet';

// ===== 表一：字母键与它们的上划符号 =====
// [字母, 上划符号]。上划符号同时是键面右上角的角标与气泡里的上划提示。
local letterRows = [
  [
    ['q', '1'],
    ['w', '2'],
    ['e', '3'],
    ['r', '4'],
    ['t', '5'],
    ['y', '6'],
    ['u', '7'],
    ['i', '8'],
    ['o', '9'],
    ['p', '0'],
  ],

  [
    ['a', '`'],
    ['s', '/'],
    ['d', ':'],
    ['f', ';'],
    ['g', '('],
    ['h', ')'],
    ['j', '~'],
    ['k', '“'],
    ['l', '”'],
  ],

  [
    ['z', '@'],
    ['x', "'"],
    ['c', '#'],
    ['v', '、'],
    ['b', '?'],
    ['n', '!'],
    ['m', '…'],
  ],
];

// ===== 表二：宽度 =====
// 统一按 1125 的虚拟设计宽度分配，一行内所有分子加起来正好是 1125 就铺满；
// 不写 size 的键（空格）自动吃掉剩余宽度。
//   第一行 10 × 112.5                                   = 1125
//   第二行 168.75 + 7 × 112.5 + 168.75                   = 1125
//   第三行 168.75 + 7 × 112.5 + 168.75                   = 1125
//   第四行 225 + 112.5 + 空格 450 + 112.5 + 225          = 1125
local widths = {
  // 第三行的 Shift 与退格：触摸区一直延伸到屏幕边缘，显示区略窄，边缘键更好按
  shift: { size: { width: '168.75/1125' }, bounds: { width: '151/168.75', alignment: 'left' } },
  backspace: { size: { width: '168.75/1125' }, bounds: { width: '151/168.75', alignment: 'right' } },
  // 第四行
  numeric: { size: { width: '225/1125' } },
  comma: { size: { width: '112.5/1125' } },
  asciiMode: { size: { width: '112.5/1125' } },
  enter: { size: { width: '225/1125' } },
  // 第二行不带分号键时只有 9 个键，同样把首尾两键的触摸区延伸到边缘
  homeRowLeftEdge: { size: { width: '168.75/1125' }, bounds: { width: '111/168.75', alignment: 'right' } },
  homeRowRightEdge: { size: { width: '168.75/1125' }, bounds: { width: '111/168.75', alignment: 'left' } },
};

local keyName(character) = character + 'Button';

// 一个字母键：主标签 + 角标 + 短按气泡（大写字母，右上角是上划符号）
local letterKey(character, swipe, extra={}) =
  local upper = std.asciiUpper(character);
  Button.new(keyName(character), {
    role: 'letter',
    label: { text: character },
    uppercasedLabel: { text: upper },
    badge: { text: swipe },
    hint: { label: { text: upper }, swipeUp: { text: swipe } },
    action: { character: character },
    uppercasedStateAction: { character: upper },
    swipeUpAction: { character: swipe },
  } + extra);

// 一个标点键：没有大小写，也不弹气泡
local punctuationKey(name, character, swipe, extra={}) =
  Button.new(name, {
    role: 'letter',
    label: { text: character },
    badge: { text: swipe },
    action: { character: character },
    swipeUpAction: { character: swipe },
  } + extra);

local semicolonName = 'semicolonButton';
local commaName = 'commaButton';
local shiftName = 'shiftButton';
local backspaceName = 'backspaceButton';
local numericName = 'numericButton';
local spaceName = 'spaceButton';
local asciiModeName = 'asciiModeButton';
local enterName = 'enterButton';

// 不带分号键时，第二行首尾两键加宽
local homeRowExtras(addSemicolon) =
  if addSemicolon then {}
  else { a: widths.homeRowLeftEdge, l: widths.homeRowRightEdge };

local letterKeys(addSemicolon) =
  local extras = homeRowExtras(addSemicolon);
  Style.merge([
    letterKey(entry[0], entry[1], if std.objectHas(extras, entry[0]) then extras[entry[0]] else {})
    for row in letterRows
    for entry in row
  ]);

local keyboardLayout(addSemicolon) = [
  Layout.row([keyName(entry[0]) for entry in letterRows[0]]),
  Layout.row(
    [keyName(entry[0]) for entry in letterRows[1]]
    + (if addSemicolon then [semicolonName] else [])
  ),
  Layout.row([shiftName] + [keyName(entry[0]) for entry in letterRows[2]] + [backspaceName]),
  Layout.row([numericName, commaName, spaceName, asciiModeName, enterName]),
];

{
  // isPortrait     竖屏 / 横屏，只影响键盘高度与按键间距
  // addSemicolon   第二行末尾是否加一个分号键（加了以后 a / l 不再加宽）
  new(isPortrait=true, addSemicolon=false)::
    local orientation = if isPortrait then 'portrait' else 'landscape';
    local insets = Metrics.keyInsets.iPhone[orientation];

    Style.merge([
      Preedit.new(),
      Toolbar.new(),
      Theme.shared(insets),
      {
        keyboardHeight: Metrics.keyboardHeight.iPhone[orientation],
        keyboardStyle: { backgroundStyle: Theme.keyboardBackgroundName },
        keyboardLayout: keyboardLayout(addSemicolon),
      },
      letterKeys(addSemicolon),
      if addSemicolon then punctuationKey(semicolonName, ';', ':') else {},
      punctuationKey(commaName, ',', '.', widths.comma),
      FunctionKeys.shift(shiftName, widths.shift),
      FunctionKeys.backspace(backspaceName, widths.backspace),
      FunctionKeys.numeric(numericName, widths.numeric),
      FunctionKeys.space(spaceName),
      FunctionKeys.asciiMode(asciiModeName, widths.asciiMode),
      FunctionKeys.enter(enterName, widths.enter),
    ]),
}
