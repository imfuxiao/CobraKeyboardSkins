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
    height: 216,

    button: {
      backgroundInsets: { top: 6, left: 3, bottom: 6, right: 3 },
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
      },
    },
    xButton: {
      name: 'xButton',
      params: {
        action: { character: 'x' },
        uppercasedStateAction: { character: 'X' },
      },
    },
    cButton: {
      name: 'cButton',
      params: {
        action: { character: 'c' },
        uppercasedStateAction: { character: 'C' },
      },
    },
    vButton: {
      name: 'vButton',
      params: {
        action: { character: 'v' },
        uppercasedStateAction: { character: 'V' },
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
      },
    },
    twoButton: {
      name: 'twoButton',
      params: {
        action: { character: '2' },
      },
    },
    threeButton: {
      name: 'threeButton',
      params: {
        action: { character: '3' },
      },
    },
    fourButton: {
      name: 'fourButton',
      params: {
        action: { character: '4' },
      },
    },
    fiveButton: {
      name: 'fiveButton',
      params: {
        action: { character: '5' },
      },
    },
    sixButton: {
      name: 'sixButton',
      params: {
        action: { character: '6' },
      },
    },
    sevenButton: {
      name: 'sevenButton',
      params: {
        action: { character: '7' },
      },
    },
    eightButton: {
      name: 'eightButton',
      params: {
        action: { character: '8' },
      },
    },
    nineButton: {
      name: 'nineButton',
      params: {
        action: { character: '9' },
      },
    },
    zeroButton: {
      name: 'zeroButton',
      params: {
        action: { character: '0' },
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
    symbolButton: {
      name: 'symbolButton',
      params: {
        action: { type: 'toggleKeyboard' },
      },
    },

    // 其他功能键
    numericButton: {
      name: 'numericButton',
      params: {
        action: { keyboardType: 'numeric' },
        text: '123',
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

    // 标点符号键
    commaButton: {
      name: 'commaButton',
      params: {
        action: { character: ',' },
      },
    },
    periodButton: {
      name: 'periodButton',
      params: {
        action: { character: '.' },
      },
    },
    slashButton: {
      name: 'slashButton',
      params: {
        action: { character: '/' },
      },
    },
    semicolonButton: {
      name: 'semicolonButton',
      params: {
        action: { character: ';' },
      },
    },
    apostropheButton: {
      name: 'apostropheButton',
      params: {
        action: { character: "'" },
      },
    },
    hyphenButton: {
      name: 'hyphenButton',
      params: {
        action: { character: '-' },
      },
    },
    equalButton: {
      name: 'equalButton',
      params: {
        action: { character: '=' },
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
    backslashButton: {
      name: 'backslashButton',
      params: {
        action: { character: '\\' },
      },
    },
    graveButton: {
      name: 'graveButton',
      params: {
        action: { character: '`' },
      },
    },
  },
}
