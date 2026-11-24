// 按键数据表：声明每颗键「做什么」与集合视图配置。
//
// 每个字段名即该键在产物里的样式名；键面文字优先由 Button.labelOf 从 action 推导，
// 推不出来时再显式写 text / systemImageName / assetImageName。
// 本表纯数据，不依赖任何样式或布局模块。

// 26 键英文页的字母键：直接通过 symbol 通道输出英文，避免触发 T9 拼写。
local alphabeticLetter(c, swipeUp) = {
  action: { symbol: c },
  uppercasedStateAction: { symbol: std.asciiUpper(c) },
  swipeUpAction: { symbol: swipeUp },
  badgeText: swipeUp,
};

// 数字九宫格按键
local digit(n) = {
  action: { symbol: n },
};

// 九键拼音按键：点击送给 Rime（character），上划与长按直接上屏（symbol）
local t9Key(digitText, label, longPress, selectedIndex) = {
  action: { character: digitText },
  swipeUpAction: { symbol: digitText },
  text: label,
  badgeText: digitText,
  longPress: longPress,
  longPressSelectedIndex: selectedIndex,
};

{
  // ===== 九键拼音（1 ~ 9） =====
  t9OneButton: t9Key('1', '@/.', ['/', '-', '_', '1', '@', '#', '.'], 3),
  t9TwoButton: t9Key('2', 'ABC', ['a', 'b', 'c', '2', 'A', 'B', 'C'], 3),
  t9ThreeButton: t9Key('3', 'DEF', ['d', 'e', 'f', '3', 'D', 'E', 'F'], 3),
  t9FourButton: t9Key('4', 'GHI', ['g', 'h', 'i', '4', 'G', 'H', 'I'], 3),
  t9FiveButton: t9Key('5', 'JKL', ['j', 'k', 'l', '5', 'J', 'K', 'L'], 3),
  t9SixButton: t9Key('6', 'MNO', ['m', 'n', 'o', '6', 'M', 'N', 'O'], 3),
  t9SevenButton: t9Key('7', 'PQRS', ['p', 'q', 'r', 's', '7', 'P', 'Q', 'R', 'S'], 4),
  t9EightButton: t9Key('8', 'TUV', ['t', 'u', 'v', '8', 'T', 'U', 'V'], 3),
  t9NineButton: t9Key('9', 'WXYZ', ['w', 'x', 'y', 'z', '9', 'W', 'X', 'Y', 'Z'], 4),

  t9ResetInputButton: {
    action: { shortcut: '#重输' },
    text: '重输',
  },

  // ===== 26 键英文（QWERTY） =====
  qButton: alphabeticLetter('q', '1'),
  wButton: alphabeticLetter('w', '2'),
  eButton: alphabeticLetter('e', '3'),
  rButton: alphabeticLetter('r', '4'),
  tButton: alphabeticLetter('t', '5'),
  yButton: alphabeticLetter('y', '6'),
  uButton: alphabeticLetter('u', '7'),
  iButton: alphabeticLetter('i', '8'),
  oButton: alphabeticLetter('o', '9'),
  pButton: alphabeticLetter('p', '0'),

  aButton: alphabeticLetter('a', '`'),
  sButton: alphabeticLetter('s', '/'),
  dButton: alphabeticLetter('d', ':'),
  fButton: alphabeticLetter('f', ';'),
  gButton: alphabeticLetter('g', '('),
  hButton: alphabeticLetter('h', ')'),
  jButton: alphabeticLetter('j', '~'),
  kButton: alphabeticLetter('k', '“'),
  lButton: alphabeticLetter('l', '”'),

  zButton: alphabeticLetter('z', '@'),
  xButton: alphabeticLetter('x', '.'),
  cButton: alphabeticLetter('c', '#'),
  vButton: alphabeticLetter('v', '、'),
  bButton: alphabeticLetter('b', '?'),
  nButton: alphabeticLetter('n', '!'),
  mButton: alphabeticLetter('m', '…'),

  // ===== 数字键（0 ~ 9） =====
  oneButton: digit('1'),
  twoButton: digit('2'),
  threeButton: digit('3'),
  fourButton: digit('4'),
  fiveButton: digit('5'),
  sixButton: digit('6'),
  sevenButton: digit('7'),
  eightButton: digit('8'),
  nineButton: digit('9'),
  zeroButton: digit('0'),

  // ===== 功能键与常用标点 =====
  spaceButton: {
    action: 'space',
    swipeUpAction: { shortcut: '#次选上屏' },
    systemImageName: 'space',
    notification: ['preeditChangedForSpaceButtonNotification'],
  },
  backspaceButton: {
    action: 'backspace',
    repeatAction: 'backspace',
    systemImageName: 'delete.left',
    highlightSystemImageName: 'delete.left.fill',
  },
  shiftButton: {
    action: 'shift',
    systemImageName: 'shift',
  },
  enterButton: {
    action: 'enter',
    swipeUpAction: { symbol: '\r\n' },
    text: '$returnKeyType',
    notification: [
      'returnKeyTypeChangedNotification',
      'preeditChangedForEnterButtonNotification',
    ],
  },
  symbolicButton: {
    action: { keyboardType: 'symbolic' },
    text: '#+=',
  },
  numericButton: {
    action: { keyboardType: 'numeric' },
    text: '123',
  },
  alphabeticButton: {
    action: { keyboardType: 'alphabetic' },
    assetImageName: 'chineseState2',
  },
  t9PinyinButton: {
    action: { keyboardType: 'pinyin' },
    assetImageName: 'englishState2',
  },
  returnLastKeyboardButton: {
    action: 'returnLastKeyboard',
    text: '返回',
  },
  commaButton: {
    action: { symbol: ',' },
    swipeUpAction: { symbol: '.' },
  },
  periodButton: {
    action: { symbol: '.' },
    preeditStateAction: { character: '.' },
    swipeUpAction: { character: ',' },
  },
  equalButton: {
    action: { character: '=' },
    swipeUpAction: { character: '+' },
  },

  // ===== 集合视图 =====
  collections: {
    t9SymbolsCollection: {
      type: 't9Symbols',
      insets: { top: 8, left: 4, bottom: 4, right: 4 },
      backgroundStyle: 'systemButtonBackgroundStyle',
    },
    t9CandidatesCollection: {
      type: 'verticalCandidates',
      insets: { top: 4, left: 4, bottom: 4, right: 4 },
      backgroundStyle: 'systemButtonBackgroundStyle',
    },
    numericSymbolsCollection: {
      type: 'numericSymbols',
      insets: { top: 8, left: 4, bottom: 4, right: 4 },
      backgroundStyle: 'systemButtonBackgroundStyle',
    },
    numericCategorySymbolCollection: {
      type: 'categorySymbols',
      insets: { top: 4, left: 4, bottom: 4, right: 4 },
      backgroundStyle: 'systemButtonBackgroundStyle',
    },
  },
}
