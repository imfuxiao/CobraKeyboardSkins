local colors = import 'Colors.libsonnet';
local fonts = import 'Fonts.libsonnet';

{
  local root = self,

  preedit: {
    height: 25,
    insets: {
      top: 2,
      left: 4,
    },
    fontSize: fonts.preeditFontSize,
  },

  toolbar: {
    height: 40,
  },

  candidateStyle: {
    highlightBackgroundColor: colors.candidateHighlightColor,
    preferredBackgroundColor: colors.candidateHighlightColor,
    preferredIndexColor: colors.candidateForegroundColor,
    preferredTextColor: colors.candidateForegroundColor,
    preferredCommentColor: colors.candidateForegroundColor,
    indexColor: colors.candidateForegroundColor,
    textColor: colors.candidateForegroundColor,
    commentColor: colors.candidateForegroundColor,
    indexFontSize: fonts.candidateIndexFontSize,
    //indexFontWeight: 'ultraLight',
    textFontSize: fonts.candidateTextFontSize,
    //textFontWeight: 'regular',
    commentFontSize: fonts.candidateCommentFontSize,
    //commentFontWeight: 'black',
  },

  horizontalCandidateStyle:
    {
      insets: {
        top: 8,
        left: 3,
        bottom: 1,
      },
      expandButton: {
        systemImageName: 'chevron.forward',
        normalColor: colors.toolbarButtonForegroundColor,
        highlightColor: colors.toolbarButtonHighlightedForegroundColor,
        fontSize: fonts.candidateStateButtonFontSize,
      },
    },

  verticalCandidateStyle:
    {
      // insets 用于展开候选字后的区域内边距
      // insets: { top: 3, bottom: 3, left: 4, right: 4 },
      bottomRowHeight: 45,
      candidateCollectionStyle: {
        insets: { top: 8, bottom: 8, left: 8, right: 8 },
        backgroundColor: colors.keyboardBackgroundColor,
        maxRows: 5,
        maxColumns: 6,
        separatorColor: colors.candidateSeparatorColor,
      },
      pageUpButton: {
        action: { shortcut: '#verticalCandidatesPageUp' },
        systemImageName: 'chevron.up',
        normalColor: colors.toolbarButtonForegroundColor,
        highlightColor: colors.toolbarButtonHighlightedForegroundColor,
        fontSize: fonts.candidateStateButtonFontSize,
      },
      pageDownButton: {
        action: { shortcut: '#verticalCandidatesPageDown' },
        systemImageName: 'chevron.down',
        normalColor: colors.toolbarButtonForegroundColor,
        highlightColor: colors.toolbarButtonHighlightedForegroundColor,
        fontSize: fonts.candidateStateButtonFontSize,
      },
      returnButton: {
        action: { shortcut: '#candidatesBarStateToggle' },
        systemImageName: 'return',
        normalColor: colors.toolbarButtonForegroundColor,
        highlightColor: colors.toolbarButtonHighlightedForegroundColor,
        fontSize: fonts.candidateStateButtonFontSize,
      },
    },

  keyboard: {
    height: {
      iPhone: {
        portrait: 216,  // 54 * 4
        landscape: 160,  // 40 * 4
      },
      iPad: {
        portrait: 311,  // 64 * 4 + 55
        landscape: 414,  // 86 * 4 + 70
      },
    },

    button: {
      backgroundInsets: {
        iPhone: {
          portrait: { top: 3, left: 3, bottom: 3, right: 3 },
          landscape: { top: 3, left: 3, bottom: 3, right: 3 },
        },
        ipad: {
          portrait: { top: 3, left: 3, bottom: 3, right: 3 },
          landscape: { top: 4, left: 6, bottom: 4, right: 6 },
        },
      },
    },

    // 按键定义
    qButton: {
      name: 'qButton',
      params: {
        action: { symbol: 'q' },
        uppercasedStateAction: { symbol: 'Q' },
        swipeUpAction: { symbol: '1' },
      },
    },
    wButton: {
      name: 'wButton',
      params: {
        action: { symbol: 'w' },
        uppercasedStateAction: { symbol: 'W' },
        swipeUpAction: { symbol: '2' },
      },
    },
    eButton: {
      name: 'eButton',
      params: {
        action: { symbol: 'e' },
        uppercasedStateAction: { symbol: 'E' },
        swipeUpAction: { symbol: '3' },
      },
    },
    rButton: {
      name: 'rButton',
      params: {
        action: { symbol: 'r' },
        uppercasedStateAction: { symbol: 'R' },
        swipeUpAction: { symbol: '4' },
      },
    },
    tButton: {
      name: 'tButton',
      params: {
        action: { symbol: 't' },
        uppercasedStateAction: { symbol: 'T' },
        swipeUpAction: { symbol: '5' },
      },
    },
    yButton: {
      name: 'yButton',
      params: {
        action: { symbol: 'y' },
        uppercasedStateAction: { symbol: 'Y' },
        swipeUpAction: { symbol: '6' },
      },
    },
    uButton: {
      name: 'uButton',
      params: {
        action: { symbol: 'u' },
        uppercasedStateAction: { symbol: 'U' },
        swipeUpAction: { symbol: '7' },
      },
    },
    iButton: {
      name: 'iButton',
      params: {
        action: { symbol: 'i' },
        uppercasedStateAction: { symbol: 'I' },
        swipeUpAction: { symbol: '8' },
      },
    },
    oButton: {
      name: 'oButton',
      params: {
        action: { symbol: 'o' },
        uppercasedStateAction: { symbol: 'O' },
        swipeUpAction: { symbol: '9' },
      },
    },
    pButton: {
      name: 'pButton',
      params: {
        action: { symbol: 'p' },
        uppercasedStateAction: { symbol: 'P' },
        swipeUpAction: { symbol: '0' },
      },
    },

    // 第二行字母键 (ASDF)
    aButton: {
      name: 'aButton',
      params: {
        action: { symbol: 'a' },
        uppercasedStateAction: { symbol: 'A' },
        swipeUpAction: { symbol: '`' },
      },
    },
    sButton: {
      name: 'sButton',
      params: {
        action: { symbol: 's' },
        uppercasedStateAction: { symbol: 'S' },
        swipeUpAction: { symbol: '/' },
      },
    },
    dButton: {
      name: 'dButton',
      params: {
        action: { symbol: 'd' },
        uppercasedStateAction: { symbol: 'D' },
        swipeUpAction: { symbol: ':' },
      },
    },
    fButton: {
      name: 'fButton',
      params: {
        action: { symbol: 'f' },
        uppercasedStateAction: { symbol: 'F' },
        swipeUpAction: { symbol: ';' },
      },
    },
    gButton: {
      name: 'gButton',
      params: {
        action: { symbol: 'g' },
        uppercasedStateAction: { symbol: 'G' },
        swipeUpAction: { symbol: '(' },
      },
    },
    hButton: {
      name: 'hButton',
      params: {
        action: { symbol: 'h' },
        uppercasedStateAction: { symbol: 'H' },
        swipeUpAction: { symbol: ')' },
      },
    },
    jButton: {
      name: 'jButton',
      params: {
        action: { symbol: 'j' },
        uppercasedStateAction: { symbol: 'J' },
        swipeUpAction: { symbol: '~' },
      },
    },
    kButton: {
      name: 'kButton',
      params: {
        action: { symbol: 'k' },
        uppercasedStateAction: { symbol: 'K' },
        swipeUpAction: { symbol: '“' },
      },
    },

    lButton: {
      name: 'lButton',
      params: {
        action: { symbol: 'l' },
        uppercasedStateAction: { symbol: 'L' },
        swipeUpAction: { symbol: '”' },
      },
    },

    // 第三行字母键 (ZXCV)
    zButton: {
      name: 'zButton',
      params: {
        action: { symbol: 'z' },
        uppercasedStateAction: { symbol: 'Z' },
        swipeUpAction: { symbol: '@' },
      },
    },
    xButton: {
      name: 'xButton',
      params: {
        action: { symbol: 'x' },
        uppercasedStateAction: { symbol: 'X' },
        swipeUpAction: { symbol: '.' },
      },
    },
    cButton: {
      name: 'cButton',
      params: {
        action: { symbol: 'c' },
        uppercasedStateAction: { symbol: 'C' },
        swipeUpAction: { symbol: '#' },
      },
    },
    vButton: {
      name: 'vButton',
      params: {
        action: { symbol: 'v' },
        uppercasedStateAction: { symbol: 'V' },
        swipeUpAction: { symbol: '、' },
      },
    },
    bButton: {
      name: 'bButton',
      params: {
        action: { symbol: 'b' },
        uppercasedStateAction: { symbol: 'B' },
        swipeUpAction: { symbol: '?' },
      },
    },
    nButton: {
      name: 'nButton',
      params: {
        action: { symbol: 'n' },
        uppercasedStateAction: { symbol: 'N' },
        swipeUpAction: { symbol: '!' },
      },
    },
    mButton: {
      name: 'mButton',
      params: {
        action: { symbol: 'm' },
        uppercasedStateAction: { symbol: 'M' },
        swipeUpAction: { symbol: '…' },
      },
    },

    // 数字键
    oneButton: {
      name: 'oneButton',
      params: {
        action: { character: '1' },
        swipeUpAction: { character: '!' },
      },
    },
    twoButton: {
      name: 'twoButton',
      params: {
        action: { character: '2' },
        swipeUpAction: { character: '@' },
      },
    },
    threeButton: {
      name: 'threeButton',
      params: {
        action: { character: '3' },
        swipeUpAction: { character: '#' },
      },
    },
    fourButton: {
      name: 'fourButton',
      params: {
        action: { character: '4' },
        swipeUpAction: { character: '$' },
      },
    },
    fiveButton: {
      name: 'fiveButton',
      params: {
        action: { character: '5' },
        swipeUpAction: { character: '%' },
      },
    },
    sixButton: {
      name: 'sixButton',
      params: {
        action: { character: '6' },
        swipeUpAction: { character: '^' },
      },
    },
    sevenButton: {
      name: 'sevenButton',
      params: {
        action: { character: '7' },
        swipeUpAction: { character: '&' },
      },
    },
    eightButton: {
      name: 'eightButton',
      params: {
        action: { character: '8' },
        swipeUpAction: { character: '*' },
      },
    },
    nineButton: {
      name: 'nineButton',
      params: {
        action: { character: '9' },
        swipeUpAction: { character: '(' },
      },
    },
    zeroButton: {
      name: 'zeroButton',
      params: {
        action: { character: '0' },
        swipeUpAction: { character: ')' },
      },
    },

    // T9 按键
    t9OneButton: {
      name: 't9OneButton',
      params: {
        action: { character: '1' },
        swipeUpAction: { symbol: '1' },
        text: '@/.',
        fontSize: fonts.t9ButtonTextFontSize,
      },
    },
    t9TwoButton: {
      name: 't9TwoButton',
      params: {
        action: { character: '2' },
        swipeUpAction: { symbol: '2' },
        text: 'ABC',
        fontSize: fonts.t9ButtonTextFontSize,
      },
    },
    t9ThreeButton: {
      name: 't9ThreeButton',
      params: {
        action: { character: '3' },
        swipeUpAction: { symbol: '3' },
        text: 'DEF',
        fontSize: fonts.t9ButtonTextFontSize,
      },
    },
    t9FourButton: {
      name: 't9FourButton',
      params: {
        action: { character: '4' },
        swipeUpAction: { symbol: '4' },
        text: 'GHI',
        fontSize: fonts.t9ButtonTextFontSize,
      },
    },
    t9FiveButton: {
      name: 't9FiveButton',
      params: {
        action: { character: '5' },
        swipeUpAction: { symbol: '5' },
        text: 'JKL',
        fontSize: fonts.t9ButtonTextFontSize,
      },
    },
    t9SixButton: {
      name: 't9SixButton',
      params: {
        action: { character: '6' },
        swipeUpAction: { symbol: '6' },
        text: 'MNO',
        fontSize: fonts.t9ButtonTextFontSize,
      },
    },
    t9SevenButton: {
      name: 't9SevenButton',
      params: {
        action: { character: '7' },
        swipeUpAction: { symbol: '7' },
        text: 'PQRS',
        fontSize: fonts.t9ButtonTextFontSize,
      },
    },
    t9EightButton: {
      name: 't9EightButton',
      params: {
        action: { character: '8' },
        swipeUpAction: { symbol: '8' },
        text: 'TUV',
        fontSize: fonts.t9ButtonTextFontSize,
      },
    },
    t9NineButton: {
      name: 't9NineButton',
      params: {
        action: { character: '9' },
        swipeUpAction: { symbol: '9' },
        text: 'WXYZ',
        fontSize: fonts.t9ButtonTextFontSize,
      },
    },
    t9ZeroButton: {
      name: 't9ZeroButton',
      params: {
        action: { character: '0' },
        swipeUpAction: { symbol: '0' },
        fontSize: 20,
      },
    },

    t9RestInputButton: {
      name: 't9ResetInputButton',
      params: {
        action: { shortcut: '#重输' },
        text: '重输',
      },
    },

    // 特殊功能键
    spaceButton: {
      name: 'spaceButton',
      params: {
        action: 'space',
        swipeUpAction: { shortcut: '#次选上屏' },
        systemImageName: 'space',
        notification: [
          'preeditChangedForSpaceButtonNotification',
        ],
      },
    },

    tabButton: {
      name: 'tabButton',
      params: {
        action: 'tab',
        systemImageName: 'arrow.right.to.line',
      },
    },

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
      },
      uppercasedParams: {
        systemImageName: 'shift.fill',
      },
      capsLockedParams: {
        systemImageName: 'capslock.fill',
      },
    },

    asciiModeButton: {
      name: 'asciiModeButton',
      params: {
        action: { shortcut: '#中英切换' },
        text: '中/英',
      },
    },

    dismissButton: {
      name: 'dismissButton',
      params: {
        action: 'dismissKeyboard',
        systemImageName: 'keyboard.chevron.compact.down',
      },
    },

    enterButton: {
      name: 'enterButton',
      params: {
        action: 'enter',
        text: '$returnKeyType',
        notification: [
          'returnKeyTypeChangedNotification',
          'preeditChangedForEnterButtonNotification',
        ],
      },
    },

    symbolicButton: {
      name: 'symbolicButton',
      params: {
        action: { keyboardType: 'symbolic' },
        text: '#+=',
      },
    },

    numericButton: {
      name: 'numericButton',
      params: {
        action: { keyboardType: 'numeric' },
        text: '123',
      },
    },

    pinyinButton: {
      name: 'pinyinButton',
      params: {
        action: { keyboardType: 'pinyin' },
        text: '拼音',
      },
    },

    alphabeticButton: {
      name: 'alphabeticButton',
      params: {
        action: { keyboardType: 'alphabetic' },
        assetImageName: 'chineseState2',
      },
    },

    t9PinyinButton: {
      name: 't9PinyinButton',
      params: {
        action: { keyboardType: 'pinyin' },
        assetImageName: 'englishState2',
      },
    },

    otherKeyboardButton: {
      name: 'otherKeyboardButton',
      params: {
        action: 'nextKeyboard',
        systemImageName: 'globe',
      },
    },

    // 标点符号键

    // 连接号(减号)
    hyphenButton: {
      name: 'hyphenButton',
      params: {
        action: { character: '-' },
        swipeUpAction: { character: '——' },
      },
    },
    // 斜杠
    forwardSlashButton: {
      name: 'forwardSlashButton',
      params: {
        action: { character: '/' },
        swipeUpAction: { character: '?' },
      },
    },
    // 冒号
    colonButton: {
      name: 'colonButton',
      params: {
        action: { character: ':' },
      },
    },

    // 中文冒号
    chineseColonButton: {
      name: 'chineseColonButton',
      params: {
        action: { symbol: '：' },
      },
    },

    // 分号
    semicolonButton: {
      name: 'semicolonButton',
      params: {
        action: { character: ';' },
      },
    },

    // 中文分号
    chineseSemicolonButton: {
      name: 'chineseSemicolonButton',
      params: {
        action: { symbol: '；' },
        swipeUpAction: { symbol: '：' },
      },
    },

    // 左括号
    leftParenthesisButton: {
      name: 'leftParenthesisButton',
      params: {
        action: { symbol: '(' },
      },
    },

    // 右括号
    rightParenthesisButton: {
      name: 'rightParenthesisButton',
      params: {
        action: { symbol: ')' },
      },
    },

    // 中文左括号
    leftChineseParenthesisButton: {
      name: 'leftChineseParenthesisButton',
      params: {
        action: { symbol: '（' },
      },
    },

    // 中文右括号
    rightChineseParenthesisButton: {
      name: 'rightChineseParenthesisButton',
      params: {
        action: { symbol: '）' },
      },
    },

    // 美元符号
    dollarButton: {
      name: 'dollarButton',
      params: {
        action: { symbol: '$' },
      },
    },

    // 地址符号
    atButton: {
      name: 'atButton',
      params: {
        action: { symbol: '@' },
      },
    },

    // “ 双引号(有方向性的引号)
    leftCurlyQuoteButton: {
      name: 'leftCurlyQuoteButton',
      params: {
        action: { symbol: '“' },
      },
    },
    // ” 双引号(有方向性的引号)
    rightCurlyQuoteButton: {
      name: 'rightCurlyQuoteButton',
      params: {
        action: { symbol: '”' },
      },
    },
    // " 直引号(没有方向性的引号)
    straightQuoteButton: {
      name: 'straightQuoteButton',
      params: {
        action: { symbol: '"' },
      },
    },
    chineseCommaButton: {
      name: 'chineseCommaButton',
      params: {
        action: { symbol: '，' },
        swipeUpAction: { symbol: '《' },
      },
    },
    commaButton: {
      name: 'commaButton',
      params: {
        action: { symbol: ',' },
      },
    },
    chinesePeriodButton: {
      name: 'chinesePeriodButton',
      params: {
        action: { symbol: '。' },
        swipeUpAction: { symbol: '》' },
      },
    },
    periodButton: {
      name: 'periodButton',
      params: {
        action: { character: '.' },
        swipeUpAction: { character: ',' },
      },
    },
    // 顿号(只在中文中使用)
    ideographicCommaButton: {
      name: 'ideographicCommaButton',
      params: {
        action: { symbol: '、' },
        swipeUpAction: { symbol: '|' },
      },
    },
    // 中文问号
    chineseQuestionMarkButton: {
      name: 'questionMarkButton',
      params: {
        action: { symbol: '？' },
      },
    },
    // 英文问号
    questionMarkButton: {
      name: 'questionMarkEnButton',
      params: {
        action: { character: '?' },
      },
    },
    // 中文感叹号
    chineseExclamationMarkButton: {
      name: 'chineseExclamationMarkButton',
      params: {
        action: { symbol: '！' },
      },
    },
    // 英文感叹号
    exclamationMarkButton: {
      name: 'exclamationMarkButton',
      params: {
        action: { character: '!' },
      },
    },
    // ' 直撇号(单引号)
    apostropheButton: {
      name: 'apostropheButton',
      params: {
        action: { character: "'" },
      },
    },
    // 中文左单引号(有方向性的单引号)
    leftSingleQuoteButton: {
      name: 'leftSingleQuoteButton',
      params: {
        action: { symbol: '‘' },
        swipeUpAction: { symbol: '“' },
      },
    },
    // 中文右单引号(有方向性的单引号)
    rightSingleQuoteButton: {
      name: 'rightSingleQuoteButton',
      params: {
        action: { symbol: '’' },
      },
    },
    // 等号
    equalButton: {
      name: 'equalButton',
      params: {
        action: { character: '=' },
        swipeUpAction: { character: '+' },
      },
    },
    leftBracketButton: {
      name: 'leftBracketButton',
      params: {
        action: { symbol: '[' },
      },
    },
    rightBracketButton: {
      name: 'rightBracketButton',
      params: {
        action: { symbol: ']' },
      },
    },

    // 中文左中括号
    leftChineseBracketButton: {
      name: 'leftChineseBracketButton',
      params: {
        action: { symbol: '【' },
        swipeUpAction: { symbol: '「' },
      },
    },

    // 中文右中括号
    rightChineseBracketButton: {
      name: 'rightChineseBracketButton',
      params: {
        action: { symbol: '】' },
        swipeUpAction: { symbol: '」' },
      },
    },

    // 英文左大括号
    leftBraceButton: {
      name: 'leftBraceButton',
      params: {
        action: { symbol: '{' },
      },
    },

    // 英文右大括号
    rightBraceButton: {
      name: 'rightBraceButton',
      params: {
        action: { symbol: '}' },
      },
    },

    // 中文左大括号
    leftChineseBraceButton: {
      name: 'leftChineseBraceButton',
      params: {
        action: { symbol: '｛' },
      },
    },

    // 中文右大括号
    rightChineseBraceButton: {
      name: 'rightChineseBraceButton',
      params: {
        action: { symbol: '｝' },
      },
    },


    // 井号
    hashButton: {
      name: 'hashButton',
      params: {
        action: { symbol: '#' },
      },
    },

    // 百分号
    percentButton: {
      name: 'percentButton',
      params: {
        action: { symbol: '%' },
      },
    },

    // ^符号
    caretButton: {
      name: 'caretButton',
      params: {
        action: { symbol: '^' },
      },
    },

    // '*' 符号
    asteriskButton: {
      name: 'asteriskButton',
      params: {
        action: { character: '*' },
      },
    },

    // + 符号
    plusButton: {
      name: 'plusButton',
      params: {
        action: { character: '+' },
        swipeUpAction: { character: '=' },
      },
    },

    // _ 符号(下划线)
    underscoreButton: {
      name: 'underscoreButton',
      params: {
        action: { symbol: '_' },
      },
    },

    // —— 符号(破折号)
    emDashButton: {
      name: 'emDashButton',
      params: {
        action: { character: '—' },
      },
    },

    // \ 符号(反斜杠)
    backslashButton: {
      name: 'backslashButton',
      params: {
        action: { symbol: '\\' },
      },
    },

    // | 符号(竖线)
    verticalBarButton: {
      name: 'verticalBarButton',
      params: {
        action: { symbol: '|' },
      },
    },

    // ~ 符号
    tildeButton: {
      name: 'tildeButton',
      params: {
        action: { symbol: '~' },
      },
    },

    // < 符号(小于号)
    lessThanButton: {
      name: 'lessThanButton',
      params: {
        action: { symbol: '<' },
      },
    },

    // > 符号(大于号)
    greaterThanButton: {
      name: 'greaterThanButton',
      params: {
        action: { symbol: '>' },
      },
    },

    // 中文左书名号
    leftBookTitleMarkButton: {
      name: 'leftBookTitleMarkButton',
      params: {
        action: { symbol: '《' },
      },
    },

    // 中文右书名号
    rightBookTitleMarkButton: {
      name: 'rightBookTitleMarkButton',
      params: {
        action: { symbol: '》' },
      },
    },

    // € 符号(欧元符号)
    euroButton: {
      name: 'euroButton',
      params: {
        action: { symbol: '€' },
      },
    },

    // £ 符号(英镑符号)
    poundButton: {
      name: 'poundButton',
      params: {
        action: { symbol: '£' },
      },
    },

    // 人民币符号
    rmbButton: {
      name: 'rmbButton',
      params: {
        action: { symbol: '¥' },
      },
    },

    // & 符号(和号)
    ampersandButton: {
      name: 'ampersandButton',
      params: {
        action: { symbol: '&' },
      },
    },

    // · 中点符号
    middleDotButton: {
      name: 'middleDotButton',
      params: {
        action: { symbol: '·' },
      },
    },

    // …… 符号(省略号)
    ellipsisButton: {
      name: 'ellipsisButton',
      params: {
        action: { symbol: '…' },
      },
    },

    // ` 符号(重音符)
    graveButton: {
      name: 'graveButton',
      params: {
        action: { character: '`' },
        swipeUpAction: { character: '~' },
      },
    },

    // ± 符号(正负号)
    plusMinusButton: {
      name: 'plusMinusButton',
      params: {
        action: { symbol: '±' },
      },
    },

    // 「 中文左引号
    leftChineseAngleQuoteButton: {
      name: 'leftChineseAngleQuoteButton',
      params: {
        action: { symbol: '「' },
      },
    },

    // 」 中文右引号
    rightChineseAngleQuoteButton: {
      name: 'rightChineseAngleQuoteButton',
      params: {
        action: { symbol: '」' },
      },
    },

    // 返回上一个使用的键盘
    returnLastKeyboardButton: {
      name: 'returnLastKeyboardButton',
      params: {
        text: '返回',
        action: 'returnLastKeyboard',
      },
    },

    // 数字键盘符号列表
    numericSymbolsCollection: {
      name: 'numericSymbolsCollection',
      params: {
        type: 't9Symbols',
        insets: { top: 8, left: 4, bottom: 4, right: 4 },
        backgroundStyle: 'systemButtonBackgroundStyle',
      },
    },

    // 数字键盘横向时全部部分视图
    numericCategorySymbolCollection: {
      name: 'numericCategorySymbolCollection',
      params: {
        type: 'categorySymbols',
        insets: { top: 4, left: 4, bottom: 4, right: 4 },
        backgroundStyle: 'systemButtonBackgroundStyle',
      },
    },
  },
}
