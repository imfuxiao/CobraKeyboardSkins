// 按键表：一颗键「做什么」。
//
// 每个字段名就是这颗键在产物里的**样式名**，也是布局（`keyboardLayout`）里写的名字。
// 值是这颗键节点上的动作类字段，原样写进产物；键面显示什么由构造器从 `action` 推导
// （见 Components/Button.libsonnet 的 labelOf），只有推不出来的才写 `text` / `systemImageName`。
//
// 要改某颗键的上下划动，在这里加 `swipeUpAction` / `swipeDownAction` 即可；
// 要给某颗键单独配色，在这里加 `backgroundNormalColor` 等四个颜色字段（见 README）。
//
// 本表只有数据，不 import 任何东西——哪颗键出现在哪一页由 Keyboards/ 下的布局决定。

// 一颗普通字母键：点出小写，Shift 态出大写。
local letter(c) = {
  action: { character: c },
  uppercasedStateAction: { character: std.asciiUpper(c) },
};

// 一颗数字键：点出数字，上划出它头顶那个符号。
local digit(c, swipeUp) = {
  action: { character: c },
  swipeUpAction: { character: swipeUp },
};

// 会上屏的字符键。character 走键盘的字符通道（受大小写、预编辑影响），
// symbol 走符号通道（原样上屏），两者不能混。
local char(c, extra={}) = { action: { character: c } } + extra;
local symbol(s, extra={}) = { action: { symbol: s } } + extra;

{
  // ===== 字母 =====
  qButton: letter('q'),
  wButton: letter('w'),
  eButton: letter('e') { swipeUpAction: { keyboardType: 'emojis' } },
  rButton: letter('r'),
  tButton: letter('t'),
  yButton: letter('y'),
  uButton: letter('u'),
  iButton: letter('i'),
  oButton: letter('o'),
  pButton: letter('p') { swipeUpAction: { shortcut: '#showPasteboardView' } },

  aButton: letter('a') { swipeUpAction: { shortcut: '#中英切换' } },
  sButton: letter('s') { swipeUpAction: { shortcut: '#toggleScriptView' } },
  dButton: letter('d'),
  fButton: letter('f'),
  gButton: letter('g'),
  hButton: letter('h'),
  jButton: letter('j'),
  kButton: letter('k'),
  lButton: letter('l'),

  zButton: letter('z'),
  xButton: letter('x'),
  cButton: letter('c'),
  vButton: letter('v'),
  bButton: letter('b'),
  nButton: letter('n'),
  mButton: letter('m'),

  // ===== 数字 =====
  oneButton: digit('1', '!'),
  twoButton: digit('2', '@'),
  threeButton: digit('3', '#'),
  fourButton: digit('4', '$'),
  fiveButton: digit('5', '%'),
  sixButton: digit('6', '^'),
  sevenButton: digit('7', '&'),
  eightButton: digit('8', '*'),
  nineButton: digit('9', '('),
  zeroButton: digit('0', ')'),

  // ===== 功能键 =====
  spaceButton: {
    action: 'space',
    swipeUpAction: { shortcut: '#次选上屏' },
    systemImageName: 'space',
    notification: ['preeditChangedForSpaceButtonNotification'],
  },
  tabButton: {
    action: 'tab',
    systemImageName: 'arrow.right.to.line',
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
  // Shift 的两个状态态样式：大写一次 / 大写锁定
  shiftUppercased: { systemImageName: 'shift.fill' },
  shiftCapsLocked: { systemImageName: 'capslock.fill' },

  asciiModeButton: {
    action: { shortcut: '#中英切换' },
    text: '中/英',
  },
  dismissButton: {
    action: 'dismissKeyboard',
    systemImageName: 'keyboard.chevron.compact.down',
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
  symbolicButton: { action: { keyboardType: 'symbolic' }, text: '#+=' },
  numericButton: { action: { keyboardType: 'numeric' }, text: '123' },
  pinyinButton: { action: { keyboardType: 'pinyin' }, text: '拼音' },
  otherKeyboardButton: { action: 'nextKeyboard', systemImageName: 'globe' },

  // ===== 标点、符号 =====
  hyphenButton: char('-', { swipeUpAction: { character: '——' } }),  // 连接号(减号)
  forwardSlashButton: char('/', { swipeUpAction: { character: '?' } }),  // 斜杠
  colonButton: char(':'),
  chineseColonButton: symbol('：'),
  semicolonButton: char(';'),
  chineseSemicolonButton: symbol('；', { swipeUpAction: { symbol: '：' } }),

  leftParenthesisButton: symbol('('),
  rightParenthesisButton: symbol(')'),
  leftChineseParenthesisButton: symbol('（'),
  rightChineseParenthesisButton: symbol('）'),

  dollarButton: symbol('$'),
  atButton: symbol('@'),

  leftCurlyQuoteButton: symbol('“'),  // 有方向性的双引号
  rightCurlyQuoteButton: symbol('”'),
  straightQuoteButton: symbol('"'),  // 没有方向性的双引号
  leftSingleQuoteButton: symbol('‘', { swipeUpAction: { symbol: '“' } }),
  rightSingleQuoteButton: symbol('’'),
  apostropheButton: char("'"),

  chineseCommaButton: symbol('，', { swipeUpAction: { symbol: '《' } }),
  commaButton: symbol(','),
  chinesePeriodButton: symbol('。', { swipeUpAction: { symbol: '》' } }),
  // 英文句点：预编辑中按下时走 character 通道，好让码表接得住
  periodButton: symbol('.', {
    preeditStateAction: { character: '.' },
    swipeUpAction: { character: ',' },
  }),
  ideographicCommaButton: symbol('、', { swipeUpAction: { symbol: '|' } }),  // 顿号

  // 中文问号叫 questionMarkButton，英文的才带 En——沿用产物里既有的名字，改名会让
  // 所有引用这份皮肤做二次开发的配置失效。
  questionMarkButton: symbol('？'),
  questionMarkEnButton: char('?'),
  chineseExclamationMarkButton: symbol('！'),
  exclamationMarkButton: char('!'),

  equalButton: char('=', { swipeUpAction: { character: '+' } }),
  plusButton: char('+', { swipeUpAction: { character: '=' } }),

  leftBracketButton: symbol('['),
  rightBracketButton: symbol(']'),
  leftChineseBracketButton: symbol('【', { swipeUpAction: { symbol: '「' } }),
  rightChineseBracketButton: symbol('】', { swipeUpAction: { symbol: '」' } }),
  leftBraceButton: symbol('{'),
  rightBraceButton: symbol('}'),
  leftChineseBraceButton: symbol('｛'),
  rightChineseBraceButton: symbol('｝'),

  hashButton: symbol('#'),
  percentButton: symbol('%'),
  caretButton: symbol('^'),
  asteriskButton: char('*'),
  underscoreButton: symbol('_'),
  emDashButton: char('—'),  // 破折号
  backslashButton: symbol('\\'),
  verticalBarButton: symbol('|'),
  tildeButton: symbol('~'),
  graveButton: char('`', { swipeUpAction: { character: '~' } }),
  lessThanButton: symbol('<'),
  greaterThanButton: symbol('>'),
  leftBookTitleMarkButton: symbol('《'),
  rightBookTitleMarkButton: symbol('》'),
  leftChineseAngleQuoteButton: symbol('「'),
  rightChineseAngleQuoteButton: symbol('」'),

  euroButton: symbol('€'),
  poundButton: symbol('£'),
  rmbButton: symbol('¥'),
  ampersandButton: symbol('&'),
  middleDotButton: symbol('·'),
  ellipsisButton: symbol('…'),
  plusMinusButton: symbol('±'),
}
