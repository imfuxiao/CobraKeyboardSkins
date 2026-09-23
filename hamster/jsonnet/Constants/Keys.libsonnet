// 每颗键的动作与外观参数（不含尺寸、不含配色的具体值，只有动作与图标/文案）。
// 形状沿用重构前 Constants/Keyboard.libsonnet 的 { name, params, ... } 写法，
// 便于 Components/Button.libsonnet 与 Keyboards/*.libsonnet 原样引用。
local fonts = import 'Fonts.libsonnet';

{
  local root = self,

  // 第一行字母键 (QWERTY)
  qButton: { name: 'qButton', params: { action: { character: 'q' }, uppercasedStateAction: { character: 'Q' }, swipeUpAction: { character: '1' } } },
  wButton: { name: 'wButton', params: { action: { character: 'w' }, uppercasedStateAction: { character: 'W' }, swipeUpAction: { character: '2' } } },
  eButton: { name: 'eButton', params: { action: { character: 'e' }, uppercasedStateAction: { character: 'E' }, swipeUpAction: { character: '3' } } },
  rButton: { name: 'rButton', params: { action: { character: 'r' }, uppercasedStateAction: { character: 'R' }, swipeUpAction: { character: '4' } } },
  tButton: { name: 'tButton', params: { action: { character: 't' }, uppercasedStateAction: { character: 'T' }, swipeUpAction: { character: '5' } } },
  yButton: { name: 'yButton', params: { action: { character: 'y' }, uppercasedStateAction: { character: 'Y' }, swipeUpAction: { character: '6' } } },
  uButton: { name: 'uButton', params: { action: { character: 'u' }, uppercasedStateAction: { character: 'U' }, swipeUpAction: { character: '7' } } },
  iButton: { name: 'iButton', params: { action: { character: 'i' }, uppercasedStateAction: { character: 'I' }, swipeUpAction: { character: '8' } } },
  oButton: { name: 'oButton', params: { action: { character: 'o' }, uppercasedStateAction: { character: 'O' }, swipeUpAction: { character: '9' } } },
  pButton: { name: 'pButton', params: { action: { character: 'p' }, uppercasedStateAction: { character: 'P' }, swipeUpAction: { character: '0' } } },

  // 第二行字母键 (ASDF)
  aButton: { name: 'aButton', params: { action: { character: 'a' }, uppercasedStateAction: { character: 'A' }, swipeUpAction: { character: '`' } } },
  sButton: { name: 'sButton', params: { action: { character: 's' }, uppercasedStateAction: { character: 'S' }, swipeUpAction: { character: '/' } } },
  dButton: { name: 'dButton', params: { action: { character: 'd' }, uppercasedStateAction: { character: 'D' }, swipeUpAction: { character: ':' } } },
  fButton: { name: 'fButton', params: { action: { character: 'f' }, uppercasedStateAction: { character: 'F' }, swipeUpAction: { character: ';' } } },
  gButton: { name: 'gButton', params: { action: { character: 'g' }, uppercasedStateAction: { character: 'G' }, swipeUpAction: { character: '(' } } },
  hButton: { name: 'hButton', params: { action: { character: 'h' }, uppercasedStateAction: { character: 'H' }, swipeUpAction: { character: ')' } } },
  jButton: { name: 'jButton', params: { action: { character: 'j' }, uppercasedStateAction: { character: 'J' }, swipeUpAction: { character: '~' } } },
  kButton: { name: 'kButton', params: { action: { character: 'k' }, uppercasedStateAction: { character: 'K' }, swipeUpAction: { character: '“' } } },
  lButton: { name: 'lButton', params: { action: { character: 'l' }, uppercasedStateAction: { character: 'L' }, swipeUpAction: { character: '”' } } },

  // 第三行字母键 (ZXCV)
  zButton: { name: 'zButton', params: { action: { character: 'z' }, uppercasedStateAction: { character: 'Z' }, swipeUpAction: { character: '@' } } },
  xButton: { name: 'xButton', params: { action: { character: 'x' }, uppercasedStateAction: { character: 'X' }, swipeUpAction: { character: "'" } } },
  cButton: { name: 'cButton', params: { action: { character: 'c' }, uppercasedStateAction: { character: 'C' }, swipeUpAction: { character: '#' } } },
  vButton: { name: 'vButton', params: { action: { character: 'v' }, uppercasedStateAction: { character: 'V' }, swipeUpAction: { character: '、' } } },
  bButton: { name: 'bButton', params: { action: { character: 'b' }, uppercasedStateAction: { character: 'B' }, swipeUpAction: { character: '?' } } },
  nButton: { name: 'nButton', params: { action: { character: 'n' }, uppercasedStateAction: { character: 'N' }, swipeUpAction: { character: '!' } } },
  mButton: { name: 'mButton', params: { action: { character: 'm' }, uppercasedStateAction: { character: 'M' }, swipeUpAction: { character: '…' } } },

  // 数字键
  oneButton: { name: 'oneButton', params: { action: { character: '1' }, swipeUpAction: { character: '!' } } },
  twoButton: { name: 'twoButton', params: { action: { character: '2' }, swipeUpAction: { character: '@' } } },
  threeButton: { name: 'threeButton', params: { action: { character: '3' }, swipeUpAction: { character: '#' } } },
  fourButton: { name: 'fourButton', params: { action: { character: '4' }, swipeUpAction: { character: '$' } } },
  fiveButton: { name: 'fiveButton', params: { action: { character: '5' }, swipeUpAction: { character: '%' } } },
  sixButton: { name: 'sixButton', params: { action: { character: '6' }, swipeUpAction: { character: '^' } } },
  sevenButton: { name: 'sevenButton', params: { action: { character: '7' }, swipeUpAction: { character: '&' } } },
  eightButton: { name: 'eightButton', params: { action: { character: '8' }, swipeUpAction: { character: '*' } } },
  nineButton: { name: 'nineButton', params: { action: { character: '9' }, swipeUpAction: { character: '(' } } },
  zeroButton: { name: 'zeroButton', params: { action: { character: '0' }, swipeUpAction: { character: ')' } } },

  // 特殊功能键
  spaceButton: {
    name: 'spaceButton',
    params: {
      action: 'space',
      swipeUpAction: { shortcut: '#次选上屏' },
      systemImageName: 'space',
      notification: ['preeditChangedForSpaceButtonNotification'],
    },
  },

  tabButton: { name: 'tabButton', params: { action: 'tab', systemImageName: 'arrow.right.to.line' } },

  backspaceButton: {
    name: 'backspaceButton',
    params: {
      action: 'backspace',
      repeatAction: 'backspace',
      systemImageName: 'delete.left',
      highlightSystemImageName: 'delete.left.fill',
    },
  },

  shiftButton: {
    name: 'shiftButton',
    params: {
      systemImageName: 'shift',
      action: 'shift',
      preeditStateAction: { shortcut: '#重输' },
      swipeUpAction: { sendKeys: 'Tab' },
      swipeDownAction: { sendKeys: 'Tab' },
      swipeUpStyle: {
        name: 'shiftButtonSwipeUp',
        params: { text: '⇥', badgeFontSize: fonts.badgeTextChineseFontSize, hintFontSize: fonts.hintTextChineseFontSize },
      },
      notification: ['shiftSecondrayCandidatePreeditChangedNotification'],
    },
    uppercasedParams: { systemImageName: 'shift.fill' },
    capsLockedParams: { systemImageName: 'capslock.fill' },
  },

  asciiModeButton: {
    name: 'asciiModeButton',
    params: {
      action: { shortcut: '#中英切换' },
      preeditStateAction: { shortcut: '#次选上屏' },
      // 前景是按 ascii_mode 判定的条件样式（Components/Button.libsonnet 的 asciiModeForegroundStyle），
      // 由各键盘作为 foregroundStyleName 传入；这里只订阅英文态与预编辑两条通知。
      notification: ['asciiModeIsTrueChangedNotification', 'secondrayCandidatePreeditChangedNotification'],
    },
  },

  dismissButton: { name: 'dismissButton', params: { action: 'dismissKeyboard', systemImageName: 'keyboard.chevron.compact.down' } },

  enterButton: {
    name: 'enterButton',
    params: {
      action: 'enter',
      swipeUpAction: { symbol: '\r\n' },
      text: '$returnKeyType',
      notification: ['returnKeyTypeChangedNotification', 'preeditChangedForEnterButtonNotification'],
    },
  },

  symbolicButton: { name: 'symbolicButton', params: { action: { keyboardType: 'symbolic' }, text: '#+=' } },
  pinyinButton: { name: 'pinyinButton', params: { action: { keyboardType: 'pinyin' }, assetImageName: 'englishState2' } },
  alphabeticButton: { name: 'alphabeticButton', params: { action: { keyboardType: 'alphabetic' }, assetImageName: 'chineseState2' } },
  numericButton: { name: 'numericButton', params: { action: { keyboardType: 'numeric' }, text: '123' } },
  otherKeyboardButton: { name: 'otherKeyboardButton', params: { action: 'nextKeyboard', systemImageName: 'globe' } },

  // 标点符号键
  hyphenButton: { name: 'hyphenButton', params: { action: { character: '-' }, swipeUpAction: { character: '——' } } },
  forwardSlashButton: { name: 'forwardSlashButton', params: { action: { character: '/' } } },
  colonButton: { name: 'colonButton', params: { action: { character: ':' } } },
  chineseColonButton: { name: 'chineseColonButton', params: { action: { character: '：' } } },
  semicolonButton: { name: 'semicolonButton', params: { action: { character: ';' }, swipeUpAction: { character: ':' } } },
  chineseSemicolonButton: { name: 'chineseSemicolonButton', params: { action: { character: '；' }, swipeUpAction: { symbol: '：' } } },
  leftParenthesisButton: { name: 'leftParenthesisButton', params: { action: { character: '(' } } },
  rightParenthesisButton: { name: 'rightParenthesisButton', params: { action: { character: ')' } } },
  leftChineseParenthesisButton: { name: 'leftChineseParenthesisButton', params: { action: { character: '（' } } },
  rightChineseParenthesisButton: { name: 'rightChineseParenthesisButton', params: { action: { character: '）' } } },
  dollarButton: { name: 'dollarButton', params: { action: { character: '$' } } },
  atButton: { name: 'atButton', params: { action: { character: '@' } } },
  leftCurlyQuoteButton: { name: 'leftCurlyQuoteButton', params: { action: { character: '“' } } },
  rightCurlyQuoteButton: { name: 'rightCurlyQuoteButton', params: { action: { character: '”' } } },
  straightQuoteButton: { name: 'straightQuoteButton', params: { action: { character: '"' } } },
  chineseCommaButton: { name: 'chineseCommaButton', params: { action: { character: '，' }, swipeUpAction: { symbol: '《' } } },
  commaButton: { name: 'commaButton', params: { action: { character: ',' }, swipeUpAction: { character: '.' }, assetImageName: 'Comma' } },
  chinesePeriodButton: { name: 'chinesePeriodButton', params: { action: { character: '。' }, swipeUpAction: { symbol: '》' } } },
  periodButton: { name: 'periodButton', params: { action: { character: '.' } } },
  ideographicCommaButton: { name: 'ideographicCommaButton', params: { action: { character: '、' } } },
  chineseQuestionMarkButton: { name: 'questionMarkButton', params: { action: { character: '？' } } },
  questionMarkButton: { name: 'questionMarkEnButton', params: { action: { character: '?' } } },
  chineseExclamationMarkButton: { name: 'chineseExclamationMarkButton', params: { action: { character: '！' } } },
  exclamationMarkButton: { name: 'exclamationMarkButton', params: { action: { character: '!' } } },
  apostropheButton: { name: 'apostropheButton', params: { action: { character: "'" }, swipeUpAction: { character: '"' } } },
  leftSingleQuoteButton: { name: 'leftSingleQuoteButton', params: { action: { character: '‘' }, swipeUpAction: { symbol: '“' } } },
  rightSingleQuoteButton: { name: 'rightSingleQuoteButton', params: { action: { character: '’' } } },
  equalButton: { name: 'equalButton', params: { action: { character: '=' }, swipeUpAction: { character: '+' } } },
  multiplicationButton: { name: 'multiplicationButton', params: { action: { character: '×' } } },
  divisionButton: { name: 'divisionButton', params: { action: { character: '÷' } } },
  downArrowButton: { name: 'downArrowButton', params: { action: { character: '↓' } } },
  upArrowButton: { name: 'upArrowButton', params: { action: { character: '↑' } } },
  leftArrowButton: { name: 'leftArrowButton', params: { action: { character: '←' } } },
  rightArrowButton: { name: 'rightArrowButton', params: { action: { character: '→' } } },
  leftBracketButton: { name: 'leftBracketButton', params: { action: { character: '[' } } },
  rightBracketButton: { name: 'rightBracketButton', params: { action: { character: ']' } } },
  leftChineseBracketButton: { name: 'leftChineseBracketButton', params: { action: { character: '【' }, swipeUpAction: { symbol: '「' } } },
  rightChineseBracketButton: { name: 'rightChineseBracketButton', params: { action: { character: '】' }, swipeUpAction: { symbol: '」' } } },
  leftBraceButton: { name: 'leftBraceButton', params: { action: { character: '{' } } },
  rightBraceButton: { name: 'rightBraceButton', params: { action: { character: '}' } } },
  leftChineseBraceButton: { name: 'leftChineseBraceButton', params: { action: { character: '｛' } } },
  rightChineseBraceButton: { name: 'rightChineseBraceButton', params: { action: { character: '｝' } } },
  hashButton: { name: 'hashButton', params: { action: { character: '#' } } },
  percentButton: { name: 'percentButton', params: { action: { character: '%' } } },
  caretButton: { name: 'caretButton', params: { action: { character: '^' } } },
  asteriskButton: { name: 'asteriskButton', params: { action: { character: '*' } } },
  plusButton: { name: 'plusButton', params: { action: { character: '+' }, swipeUpAction: { character: '=' } } },
  underscoreButton: { name: 'underscoreButton', params: { action: { character: '_' } } },
  emDashButton: { name: 'emDashButton', params: { action: { character: '—' } } },
  backslashButton: { name: 'backslashButton', params: { action: { character: '\\' } } },
  verticalBarButton: { name: 'verticalBarButton', params: { action: { character: '|' } } },
  tildeButton: { name: 'tildeButton', params: { action: { character: '~' } } },
  lessThanButton: { name: 'lessThanButton', params: { action: { character: '<' } } },
  greaterThanButton: { name: 'greaterThanButton', params: { action: { character: '>' } } },
  leftBookTitleMarkButton: { name: 'leftBookTitleMarkButton', params: { action: { character: '《' } } },
  rightBookTitleMarkButton: { name: 'rightBookTitleMarkButton', params: { action: { character: '》' } } },
  euroButton: { name: 'euroButton', params: { action: { character: '€' } } },
  poundButton: { name: 'poundButton', params: { action: { character: '£' } } },
  rmbButton: { name: 'rmbButton', params: { action: { character: '¥' } } },
  ampersandButton: { name: 'ampersandButton', params: { action: { character: '&' } } },
  middleDotButton: { name: 'middleDotButton', params: { action: { character: '·' } } },
  ellipsisButton: { name: 'ellipsisButton', params: { action: { character: '…' } } },
  graveButton: { name: 'graveButton', params: { action: { character: '`' } } },
  plusMinusButton: { name: 'plusMinusButton', params: { action: { character: '±' } } },
  leftChineseAngleQuoteButton: { name: 'leftChineseAngleQuoteButton', params: { action: { character: '「' } } },
  rightChineseAngleQuoteButton: { name: 'rightChineseAngleQuoteButton', params: { action: { character: '」' } } },
}
