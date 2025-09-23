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
    candidateStyle:: {
      highlightBackgroundColor: colors.candidateHighlightColor,
      preferredBackgroundColor: colors.candidateHighlightColor,
      preferredIndexColor: colors.candidateForegroundColor,
      preferredTextColor: colors.candidateForegroundColor,
      preferredCommentColor: colors.candidateForegroundColor,
      indexColor: colors.candidateForegroundColor,
      textColor: colors.candidateForegroundColor,
      commentColor: colors.candidateForegroundColor,
      indexFontSize: fonts.candidateIndexFontSize,
      textFontSize: fonts.candidateTextFontSize,
      commentFontSize: fonts.candidateCommentFontSize,
    },
    horizontalCandidateStyle:
      {
        insets: {
          top: 8,
          left: 3,
          bottom: 1,
        },
      }
      + root.toolbar.candidateStyle
      + {
        candidateStateButton: {
          systemImageName: 'chevron.down',
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
        candidateStyle: {
          // backgroundInsets 用于控制候选字区域背景色的内边距
          backgroundInsets: { top: 8, bottom: 8, left: 8, right: 8 },
          backgroundColor: colors.keyboardBackgroundColor,
          separatorColor: colors.candidateSeparatorColor,
        } + root.toolbar.candidateStyle,
        pageUpButton: {
          systemImageName: 'chevron.up',
          normalColor: colors.toolbarButtonForegroundColor,
          highlightColor: colors.toolbarButtonHighlightedForegroundColor,
          fontSize: fonts.candidateStateButtonFontSize,
        },
        pageDownButton: {
          systemImageName: 'chevron.down',
          normalColor: colors.toolbarButtonForegroundColor,
          highlightColor: colors.toolbarButtonHighlightedForegroundColor,
          fontSize: fonts.candidateStateButtonFontSize,
        },
        returnButton: {
          systemImageName: 'return',
          normalColor: colors.toolbarButtonForegroundColor,
          highlightColor: colors.toolbarButtonHighlightedForegroundColor,
          fontSize: fonts.candidateStateButtonFontSize,
        },
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
          portrait: { top: 6, left: 3, bottom: 6, right: 3 },
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
      },
    },
    wButton: {
      name: 'wButton',
      params: {
        action: { character: 'w' },
        uppercasedStateAction: { character: 'W' },
      },
    },
    eButton: {
      name: 'eButton',
      params: {
        action: { character: 'e' },
        uppercasedStateAction: { character: 'E' },
      },
    },
    rButton: {
      name: 'rButton',
      params: {
        action: { character: 'r' },
        uppercasedStateAction: { character: 'R' },
      },
    },
    tButton: {
      name: 'tButton',
      params: {
        action: { character: 't' },
        uppercasedStateAction: { character: 'T' },
      },
    },
    yButton: {
      name: 'yButton',
      params: {
        action: { character: 'y' },
        uppercasedStateAction: { character: 'Y' },
      },
    },
    uButton: {
      name: 'uButton',
      params: {
        action: { character: 'u' },
        uppercasedStateAction: { character: 'U' },
      },
    },
    iButton: {
      name: 'iButton',
      params: {
        action: { character: 'i' },
        uppercasedStateAction: { character: 'I' },
      },
    },
    oButton: {
      name: 'oButton',
      params: {
        action: { character: 'o' },
        uppercasedStateAction: { character: 'O' },
        swipeUpAction: { openURL: '#pasteboardContent' },
      },
    },
    pButton: {
      name: 'pButton',
      params: {
        action: { character: 'p' },
        uppercasedStateAction: { character: 'P' },
      },
    },

    // 第二行字母键 (ASDF)
    aButton: {
      name: 'aButton',
      params: {
        action: { character: 'a' },
        uppercasedStateAction: { character: 'A' },
        swipeUpAction: { shortcut: '#selectText' },
      },
    },
    sButton: {
      name: 'sButton',
      params: {
        action: { character: 's' },
        uppercasedStateAction: { character: 'S' },
      },
    },
    dButton: {
      name: 'dButton',
      params: {
        action: { character: 'd' },
        uppercasedStateAction: { character: 'D' },
        swipeUpAction: { shortcut: '#deleteText' },
      },
    },
    fButton: {
      name: 'fButton',
      params: {
        action: { character: 'f' },
        uppercasedStateAction: { character: 'F' },
      },
    },
    gButton: {
      name: 'gButton',
      params: {
        action: { character: 'g' },
        uppercasedStateAction: { character: 'G' },
      },
    },
    hButton: {
      name: 'hButton',
      params: {
        action: { character: 'h' },
        uppercasedStateAction: { character: 'H' },
      },
    },
    jButton: {
      name: 'jButton',
      params: {
        action: { character: 'j' },
        uppercasedStateAction: { character: 'J' },
        swipeUpAction: { shortcut: '#toggleScriptView' },
      },
    },
    kButton: {
      name: 'kButton',
      params: {
        action: { character: 'k' },
        uppercasedStateAction: { character: 'K' },
      },
    },
    lButton: {
      name: 'lButton',
      params: {
        action: { character: 'l' },
        uppercasedStateAction: { character: 'L' },
      },
    },

    // 第三行字母键 (ZXCV)
    zButton: {
      name: 'zButton',
      params: {
        action: { character: 'z' },
        uppercasedStateAction: { character: 'Z' },
        swipeUpAction: { shortcut: '#undo' },
        swipeDownAction: { shortcut: '#redo' },
      },
    },
    xButton: {
      name: 'xButton',
      params: {
        action: { character: 'x' },
        uppercasedStateAction: { character: 'X' },
        swipeUpAction: { shortcut: '#cut' },
      },
    },
    cButton: {
      name: 'cButton',
      params: {
        action: { character: 'c' },
        uppercasedStateAction: { character: 'C' },
        swipeUpAction: { shortcut: '#copy' },
      },
    },
    vButton: {
      name: 'vButton',
      params: {
        action: { character: 'v' },
        uppercasedStateAction: { character: 'V' },
        swipeUpAction: { shortcut: '#paste' },
      },
    },
    bButton: {
      name: 'bButton',
      params: {
        action: { character: 'b' },
        uppercasedStateAction: { character: 'B' },
      },
    },
    nButton: {
      name: 'nButton',
      params: {
        action: { character: 'n' },
        uppercasedStateAction: { character: 'N' },
      },
    },
    mButton: {
      name: 'mButton',
      params: {
        action: { character: 'm' },
        uppercasedStateAction: { character: 'M' },
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
        action: { symbol: ';' },
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
        action: { symbol: '.' },
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
        action: { symbol: '?' },
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
        action: { symbol: '!' },
      },
    },
    // ' 直撇号(单引号)
    apostropheButton: {
      name: 'apostropheButton',
      params: {
        action: { symbol: "'" },
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
  },
}
