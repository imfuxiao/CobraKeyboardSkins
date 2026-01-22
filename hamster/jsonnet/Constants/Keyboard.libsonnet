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
          portrait: { top: 4, left: 3, bottom: 4, right: 3 },
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
        action: { character: 'q' },
        uppercasedStateAction: { character: 'Q' },
        swipeUpAction: { character: '1' },
      },
    },
    wButton: {
      name: 'wButton',
      params: {
        action: { character: 'w' },
        uppercasedStateAction: { character: 'W' },
        swipeUpAction: { character: '2' },
      },
    },
    eButton: {
      name: 'eButton',
      params: {
        action: { character: 'e' },
        uppercasedStateAction: { character: 'E' },
        swipeUpAction: { character: '3' },
      },
    },
    rButton: {
      name: 'rButton',
      params: {
        action: { character: 'r' },
        uppercasedStateAction: { character: 'R' },
        swipeUpAction: { character: '4' },
      },
    },
    tButton: {
      name: 'tButton',
      params: {
        action: { character: 't' },
        uppercasedStateAction: { character: 'T' },
        swipeUpAction: { character: '5' },
      },
    },
    yButton: {
      name: 'yButton',
      params: {
        action: { character: 'y' },
        uppercasedStateAction: { character: 'Y' },
        swipeUpAction: { character: '6' },
      },
    },
    uButton: {
      name: 'uButton',
      params: {
        action: { character: 'u' },
        uppercasedStateAction: { character: 'U' },
        swipeUpAction: { character: '7' },
      },
    },
    iButton: {
      name: 'iButton',
      params: {
        action: { character: 'i' },
        uppercasedStateAction: { character: 'I' },
        swipeUpAction: { character: '8' },
      },
    },
    oButton: {
      name: 'oButton',
      params: {
        action: { character: 'o' },
        uppercasedStateAction: { character: 'O' },
        swipeUpAction: { character: '9' },
      },
    },
    pButton: {
      name: 'pButton',
      params: {
        action: { character: 'p' },
        uppercasedStateAction: { character: 'P' },
        swipeUpAction: { character: '0' },
      },
    },

    // 第二行字母键 (ASDF)
    aButton: {
      name: 'aButton',
      params: {
        action: { character: 'a' },
        uppercasedStateAction: { character: 'A' },
        swipeUpAction: { character: '`' },
      },
    },
    sButton: {
      name: 'sButton',
      params: {
        action: { character: 's' },
        uppercasedStateAction: { character: 'S' },
        swipeUpAction: { character: '/' },
      },
    },
    dButton: {
      name: 'dButton',
      params: {
        action: { character: 'd' },
        uppercasedStateAction: { character: 'D' },
        swipeUpAction: { character: ':' },
      },
    },
    fButton: {
      name: 'fButton',
      params: {
        action: { character: 'f' },
        uppercasedStateAction: { character: 'F' },
        swipeUpAction: { character: ';' },
      },
    },
    gButton: {
      name: 'gButton',
      params: {
        action: { character: 'g' },
        uppercasedStateAction: { character: 'G' },
        swipeUpAction: { character: '(' },
      },
    },
    hButton: {
      name: 'hButton',
      params: {
        action: { character: 'h' },
        uppercasedStateAction: { character: 'H' },
        swipeUpAction: { character: ')' },
      },
    },
    jButton: {
      name: 'jButton',
      params: {
        action: { character: 'j' },
        uppercasedStateAction: { character: 'J' },
        swipeUpAction: { character: '~' },
      },
    },
    kButton: {
      name: 'kButton',
      params: {
        action: { character: 'k' },
        uppercasedStateAction: { character: 'K' },
        swipeUpAction: { character: '“' },
      },
    },

    lButton: {
      name: 'lButton',
      params: {
        action: { character: 'l' },
        uppercasedStateAction: { character: 'L' },
        swipeUpAction: { character: '”' },
      },
    },

    // 第三行字母键 (ZXCV)
    zButton: {
      name: 'zButton',
      params: {
        action: { character: 'z' },
        uppercasedStateAction: { character: 'Z' },
        swipeUpAction: { character: '@' },
      },
    },
    xButton: {
      name: 'xButton',
      params: {
        action: { character: 'x' },
        uppercasedStateAction: { character: 'X' },
        swipeUpAction: { character: '.' },
      },
    },
    cButton: {
      name: 'cButton',
      params: {
        action: { character: 'c' },
        uppercasedStateAction: { character: 'C' },
        swipeUpAction: { character: '#' },
      },
    },
    vButton: {
      name: 'vButton',
      params: {
        action: { character: 'v' },
        uppercasedStateAction: { character: 'V' },
        swipeUpAction: { character: '、' },
      },
    },
    bButton: {
      name: 'bButton',
      params: {
        action: { character: 'b' },
        uppercasedStateAction: { character: 'B' },
        swipeUpAction: { character: '?' },
      },
    },
    nButton: {
      name: 'nButton',
      params: {
        action: { character: 'n' },
        uppercasedStateAction: { character: 'N' },
        swipeUpAction: { character: '!' },
      },
    },
    mButton: {
      name: 'mButton',
      params: {
        action: { character: 'm' },
        uppercasedStateAction: { character: 'M' },
        swipeUpAction: { character: '…' },
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

    // 特殊功能键
    spaceButton: {
      name: 'spaceButton',
      params: {
        action: 'space',
        // swipeUpAction: { shortcut: '#中英切换' },
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
        swipeUpAction: { sendKeys: 'Tab' },
        swipeDownAction: { sendKeys: 'Tab' },
        swipeUpStyle: {
          name: 'shiftButtonSwipeUp',
          params: {
            text: '⇥',
            badgeFontSize: fonts.badgeTextChineseFontSize,
            hintFontSize: fonts.hintTextChineseFontSize,
          },
        },
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
        assetImageName: 'chineseState2',
        notification: [
          'asciiModeIsFalseChangedNotification',
          'asciiModeIsTrueChangedNotification',
        ],
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

    pinyinButton: {
      name: 'pinyinButton',
      params: {
        action: { keyboardType: 'pinyin' },
        assetImageName: 'englishState2',
      },
    },

    alphabeticButton: {
      name: 'alphabeticButton',
      params: {
        action: { keyboardType: 'alphabetic' },
        assetImageName: 'chineseState2',
      },
    },

    numericButton: {
      name: 'numericButton',
      params: {
        action: { keyboardType: 'numeric' },
        text: '123',
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
        // swipeUpAction: { character: '?' },
        // swipeDownAction: { shortcut: '#简繁切换' },
        // swipeDownStyle: {
        //   name: 'forwardSlashButtonSwipeDown',
        //   params: {
        //     text: '简繁',
        //     badgeFontSize: fonts.badgeTextChineseFontSize,
        //     hintFontSize: fonts.hintTextChineseFontSize,
        //   },
        // },
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
        action: { character: '：' },
      },
    },

    // 分号
    semicolonButton: {
      name: 'semicolonButton',
      params: {
        action: { character: ';' },
        swipeUpAction: { character: ':' },
      },
    },

    // 中文分号
    chineseSemicolonButton: {
      name: 'chineseSemicolonButton',
      params: {
        action: { character: '；' },
        swipeUpAction: { symbol: '：' },
      },
    },

    // 左括号
    leftParenthesisButton: {
      name: 'leftParenthesisButton',
      params: {
        action: { character: '(' },
      },
    },

    // 右括号
    rightParenthesisButton: {
      name: 'rightParenthesisButton',
      params: {
        action: { character: ')' },
      },
    },

    // 中文左括号
    leftChineseParenthesisButton: {
      name: 'leftChineseParenthesisButton',
      params: {
        action: { character: '（' },
      },
    },

    // 中文右括号
    rightChineseParenthesisButton: {
      name: 'rightChineseParenthesisButton',
      params: {
        action: { character: '）' },
      },
    },

    // 美元符号
    dollarButton: {
      name: 'dollarButton',
      params: {
        action: { character: '$' },
      },
    },

    // 地址符号
    atButton: {
      name: 'atButton',
      params: {
        action: { character: '@' },
      },
    },

    // “ 双引号(有方向性的引号)
    leftCurlyQuoteButton: {
      name: 'leftCurlyQuoteButton',
      params: {
        action: { character: '“' },
      },
    },
    // ” 双引号(有方向性的引号)
    rightCurlyQuoteButton: {
      name: 'rightCurlyQuoteButton',
      params: {
        action: { character: '”' },
      },
    },
    // " 直引号(没有方向性的引号)
    straightQuoteButton: {
      name: 'straightQuoteButton',
      params: {
        action: { character: '"' },
      },
    },
    chineseCommaButton: {
      name: 'chineseCommaButton',
      params: {
        action: { character: '，' },
        swipeUpAction: { symbol: '《' },
      },
    },
    commaButton: {
      name: 'commaButton',
      params: {
        action: { character: ',' },
        swipeUpAction: { character: '.' },
        assetImageName: 'Comma',
      },
    },
    chinesePeriodButton: {
      name: 'chinesePeriodButton',
      params: {
        action: { character: '。' },
        swipeUpAction: { symbol: '》' },
      },
    },
    periodButton: {
      name: 'periodButton',
      params: {
        action: { character: '.' },
      },
    },
    // 顿号(只在中文中使用)
    ideographicCommaButton: {
      name: 'ideographicCommaButton',
      params: {
        action: { character: '、' },
        // swipeUpAction: { symbol: '|' },
      },
    },
    // 中文问号
    chineseQuestionMarkButton: {
      name: 'questionMarkButton',
      params: {
        action: { character: '？' },
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
        action: { character: '！' },
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
        swipeUpAction: { character: '"' },
      },
    },
    // 中文左单引号(有方向性的单引号)
    leftSingleQuoteButton: {
      name: 'leftSingleQuoteButton',
      params: {
        action: { character: '‘' },
        swipeUpAction: { symbol: '“' },
      },
    },
    // 中文右单引号(有方向性的单引号)
    rightSingleQuoteButton: {
      name: 'rightSingleQuoteButton',
      params: {
        action: { character: '’' },
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
    // 乘号
    multiplicationButton: {
      name: 'multiplicationButton',
      params: {
        action: { character: '×' },
      },
    },
    // 除号
    divisionButton: {
      name: 'divisionButton',
      params: {
        action: { character: '÷' },
      },
    },
    // '↓'
    downArrowButton: {
      name: 'downArrowButton',
      params: {
        action: { character: '↓' },
      },
    },
    // '↑'
    upArrowButton: {
      name: 'upArrowButton',
      params: {
        action: { character: '↑' },
      },
    },
    // '←'
    leftArrowButton: {
      name: 'leftArrowButton',
      params: {
        action: { character: '←' },
      },
    },
    // '→'
    rightArrowButton: {
      name: 'rightArrowButton',
      params: {
        action: { character: '→' },
      },
    },


    leftBracketButton: {
      name: 'leftBracketButton',
      params: {
        action: { character: '[' },
      },
    },
    rightBracketButton: {
      name: 'rightBracketButton',
      params: {
        action: { character: ']' },
      },
    },

    // 中文左中括号
    leftChineseBracketButton: {
      name: 'leftChineseBracketButton',
      params: {
        action: { character: '【' },
        swipeUpAction: { symbol: '「' },
      },
    },

    // 中文右中括号
    rightChineseBracketButton: {
      name: 'rightChineseBracketButton',
      params: {
        action: { character: '】' },
        swipeUpAction: { symbol: '」' },
      },
    },

    // 英文左大括号
    leftBraceButton: {
      name: 'leftBraceButton',
      params: {
        action: { character: '{' },
      },
    },

    // 英文右大括号
    rightBraceButton: {
      name: 'rightBraceButton',
      params: {
        action: { character: '}' },
      },
    },

    // 中文左大括号
    leftChineseBraceButton: {
      name: 'leftChineseBraceButton',
      params: {
        action: { character: '｛' },
      },
    },

    // 中文右大括号
    rightChineseBraceButton: {
      name: 'rightChineseBraceButton',
      params: {
        action: { character: '｝' },
      },
    },


    // 井号
    hashButton: {
      name: 'hashButton',
      params: {
        action: { character: '#' },
      },
    },

    // 百分号
    percentButton: {
      name: 'percentButton',
      params: {
        action: { character: '%' },
      },
    },

    // ^符号
    caretButton: {
      name: 'caretButton',
      params: {
        action: { character: '^' },
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
        action: { character: '_' },
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
        action: { character: '\\' },
      },
    },

    // | 符号(竖线)
    verticalBarButton: {
      name: 'verticalBarButton',
      params: {
        action: { character: '|' },
      },
    },

    // ~ 符号
    tildeButton: {
      name: 'tildeButton',
      params: {
        action: { character: '~' },
      },
    },

    // < 符号(小于号)
    lessThanButton: {
      name: 'lessThanButton',
      params: {
        action: { character: '<' },
      },
    },

    // > 符号(大于号)
    greaterThanButton: {
      name: 'greaterThanButton',
      params: {
        action: { character: '>' },
      },
    },

    // 中文左书名号
    leftBookTitleMarkButton: {
      name: 'leftBookTitleMarkButton',
      params: {
        action: { character: '《' },
      },
    },

    // 中文右书名号
    rightBookTitleMarkButton: {
      name: 'rightBookTitleMarkButton',
      params: {
        action: { character: '》' },
      },
    },

    // € 符号(欧元符号)
    euroButton: {
      name: 'euroButton',
      params: {
        action: { character: '€' },
      },
    },

    // £ 符号(英镑符号)
    poundButton: {
      name: 'poundButton',
      params: {
        action: { character: '£' },
      },
    },

    // 人民币符号
    rmbButton: {
      name: 'rmbButton',
      params: {
        action: { character: '¥' },
      },
    },

    // & 符号(和号)
    ampersandButton: {
      name: 'ampersandButton',
      params: {
        action: { character: '&' },
      },
    },

    // · 中点符号
    middleDotButton: {
      name: 'middleDotButton',
      params: {
        action: { character: '·' },
      },
    },

    // …… 符号(省略号)
    ellipsisButton: {
      name: 'ellipsisButton',
      params: {
        action: { character: '…' },
      },
    },

    // ` 符号(重音符)
    graveButton: {
      name: 'graveButton',
      params: {
        action: { character: '`' },
        // swipeUpAction: { character: '~' },
      },
    },

    // ± 符号(正负号)
    plusMinusButton: {
      name: 'plusMinusButton',
      params: {
        action: { character: '±' },
      },
    },

    // 「 中文左引号
    leftChineseAngleQuoteButton: {
      name: 'leftChineseAngleQuoteButton',
      params: {
        action: { character: '「' },
      },
    },

    // 」 中文右引号
    rightChineseAngleQuoteButton: {
      name: 'rightChineseAngleQuoteButton',
      params: {
        action: { character: '」' },
      },
    },
  },
}
