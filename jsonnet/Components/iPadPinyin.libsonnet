local fonts = import '../Constants/Fonts.libsonnet';
local params = import '../Constants/Keyboard.libsonnet';
local basicStyle = import 'BasicStyle.libsonnet';
local preedit = import 'Preedit.libsonnet';
local toolbar = import 'Toolbar.libsonnet';
local utils = import 'Utils.libsonnet';

local normalButtonSize = {
  size: { width: '1.1/16' },
};

local doubleLabelUpParams = {
  center: {
    y: 0.3,
  },
  fontSize: fonts.ipad.button.doubleLabelSmallFontSize,
};

local doubleLabelDownParams = {
  center: {
    y: 0.65,
  },
  fontSize: fonts.ipad.button.doubleLabelSmallFontSize,
};

local leftSystemButtonImageOffset = {
  center: {
    x: 0.25,
    y: 0.6,
  },
};

local rightSystemButtonImageOffset = {
  center: {
    x: 0.75,
    y: 0.6,
  },
};

local hintStyle = {
  // hintStyle: {
  //   size: { width: 50, height: 50 },
  // },
};

local candidateInsets = {
  insets: { top: 0, bottom: 0, left: 200, right: 200 },
};

local extraParams(isPortrait) =
  local insets = if isPortrait then params.keyboard.button.backgroundInsets.ipad.portrait else params.keyboard.button.backgroundInsets.ipad.landscape;
  {
    insets: insets,
  };

local firstRowStyleName = 'firstRowStyle';
local firstRowStyle(isPortrait=false) =
  local height = if isPortrait then 55 else 70;
  {
    firstRowStyle: {
      size: { height: height },
    },
  };


local keyboardLayout = {
  keyboardLayout: [
    {
      HStack: {
        style: firstRowStyleName,
        subviews: [
          { Cell: params.keyboard.graveButton.name },
          { Cell: params.keyboard.oneButton.name },
          { Cell: params.keyboard.twoButton.name },
          { Cell: params.keyboard.threeButton.name },
          { Cell: params.keyboard.fourButton.name },
          { Cell: params.keyboard.fiveButton.name },
          { Cell: params.keyboard.sixButton.name },
          { Cell: params.keyboard.sevenButton.name },
          { Cell: params.keyboard.eightButton.name },
          { Cell: params.keyboard.nineButton.name },
          { Cell: params.keyboard.zeroButton.name },
          { Cell: params.keyboard.hyphenButton.name },
          { Cell: params.keyboard.equalButton.name },
          { Cell: params.keyboard.backspaceButton.name },
        ],
      },
    },
    {
      HStack: {
        subviews: [
          { Cell: params.keyboard.tabButton.name },
          { Cell: params.keyboard.qButton.name },
          { Cell: params.keyboard.wButton.name },
          { Cell: params.keyboard.eButton.name },
          { Cell: params.keyboard.rButton.name },
          { Cell: params.keyboard.tButton.name },
          { Cell: params.keyboard.yButton.name },
          { Cell: params.keyboard.uButton.name },
          { Cell: params.keyboard.iButton.name },
          { Cell: params.keyboard.oButton.name },
          { Cell: params.keyboard.pButton.name },
          { Cell: params.keyboard.leftChineseBracketButton.name },
          { Cell: params.keyboard.rightChineseBracketButton.name },
          { Cell: params.keyboard.ideographicCommaButton.name },
        ],
      },
    },
    {
      HStack: {
        subviews: [
          { Cell: params.keyboard.asciiModeButton.name },
          { Cell: params.keyboard.aButton.name },
          { Cell: params.keyboard.sButton.name },
          { Cell: params.keyboard.dButton.name },
          { Cell: params.keyboard.fButton.name },
          { Cell: params.keyboard.gButton.name },
          { Cell: params.keyboard.hButton.name },
          { Cell: params.keyboard.jButton.name },
          { Cell: params.keyboard.kButton.name },
          { Cell: params.keyboard.lButton.name },
          { Cell: params.keyboard.chineseSemicolonButton.name },
          { Cell: params.keyboard.leftSingleQuoteButton.name },
          { Cell: params.keyboard.enterButton.name },
        ],
      },
    },
    {
      HStack: {
        subviews: [
          { Cell: 'left' + params.keyboard.shiftButton.name },
          { Cell: params.keyboard.zButton.name },
          { Cell: params.keyboard.xButton.name },
          { Cell: params.keyboard.cButton.name },
          { Cell: params.keyboard.vButton.name },
          { Cell: params.keyboard.bButton.name },
          { Cell: params.keyboard.nButton.name },
          { Cell: params.keyboard.mButton.name },
          { Cell: params.keyboard.chineseCommaButton.name },
          { Cell: params.keyboard.chinesePeriodButton.name },
          { Cell: params.keyboard.forwardSlashButton.name },
          { Cell: 'right' + params.keyboard.shiftButton.name },
        ],
      },
    },
    {
      HStack: {
        subviews: [
          { Cell: params.keyboard.otherKeyboardButton.name },
          { Cell: params.keyboard.numericButton.name },
          { Cell: params.keyboard.spaceButton.name },
          { Cell: params.keyboard.numericButton.name },
          { Cell: params.keyboard.dismissButton.name },
        ],
      },
    },
  ],
};


local newKeyLayout(isDark=false, isPortrait=false) =
  local keyboardHeight = if isPortrait then params.keyboard.height.iPad.portrait else params.keyboard.height.iPad.landscape;

  {
    keyboardHeight: keyboardHeight,
    keyboardStyle: utils.newBackgroundStyle(style=basicStyle.keyboardBackgroundStyleName),
  }
  + keyboardLayout
  + firstRowStyle(isPortrait)

  // First Row
  + basicStyle.newAlphabeticButton(
    params.keyboard.graveButton.name,
    isDark,
    normalButtonSize
    + params.keyboard.graveButton.params
    + hintStyle
    + {
      foregroundStyleName: [
        params.keyboard.graveButton.name + 'ForegroundStyle',
        params.keyboard.tildeButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle: {
        [params.keyboard.tildeButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.tildeButton.params + doubleLabelUpParams),
        [params.keyboard.graveButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.graveButton.params + doubleLabelDownParams),
      },
    }
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.oneButton.name,
    isDark,
    normalButtonSize
    + params.keyboard.oneButton.params
    + hintStyle
    + {
      foregroundStyleName: [
        params.keyboard.exclamationMarkButton.name + 'ForegroundStyle',
        params.keyboard.oneButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle: {
        [params.keyboard.exclamationMarkButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.exclamationMarkButton.params + doubleLabelUpParams),
        [params.keyboard.oneButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.oneButton.params + doubleLabelDownParams),
      },
    }
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.twoButton.name,
    isDark,
    normalButtonSize
    + params.keyboard.twoButton.params
    + hintStyle
    + {
      foregroundStyleName: [
        params.keyboard.atButton.name + 'ForegroundStyle',
        params.keyboard.twoButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle: {
        [params.keyboard.atButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.atButton.params + doubleLabelUpParams),
        [params.keyboard.twoButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.twoButton.params + doubleLabelDownParams),
      },
    }
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.threeButton.name,
    isDark,
    normalButtonSize
    + params.keyboard.threeButton.params
    + hintStyle
    + {
      foregroundStyleName: [
        params.keyboard.hashButton.name + 'ForegroundStyle',
        params.keyboard.threeButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle: {
        [params.keyboard.hashButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.hashButton.params + doubleLabelUpParams),
        [params.keyboard.threeButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.threeButton.params + doubleLabelDownParams),
      },
    }
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.fourButton.name,
    isDark,
    normalButtonSize + params.keyboard.fourButton.params + hintStyle
    + {
      foregroundStyleName: [
        params.keyboard.dollarButton.name + 'ForegroundStyle',
        params.keyboard.fourButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle: {
        [params.keyboard.dollarButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.dollarButton.params + doubleLabelUpParams),
        [params.keyboard.fourButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.fourButton.params + doubleLabelDownParams),
      },
    }
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.fiveButton.name,
    isDark,
    normalButtonSize + params.keyboard.fiveButton.params + hintStyle
    + {
      foregroundStyleName: [
        params.keyboard.percentButton.name + 'ForegroundStyle',
        params.keyboard.fiveButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle: {
        [params.keyboard.percentButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.percentButton.params + doubleLabelUpParams),
        [params.keyboard.fiveButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.fiveButton.params + doubleLabelDownParams),
      },
    }
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.sixButton.name,
    isDark,
    normalButtonSize + params.keyboard.sixButton.params + hintStyle
    + {
      foregroundStyleName: [
        params.keyboard.caretButton.name + 'ForegroundStyle',
        params.keyboard.sixButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle: {
        [params.keyboard.caretButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.caretButton.params + doubleLabelUpParams),
        [params.keyboard.sixButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.sixButton.params + doubleLabelDownParams),
      },
    }
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.sevenButton.name,
    isDark,
    normalButtonSize + params.keyboard.sevenButton.params + hintStyle
    + {
      foregroundStyleName: [
        params.keyboard.ampersandButton.name + 'ForegroundStyle',
        params.keyboard.sevenButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle: {
        [params.keyboard.ampersandButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.ampersandButton.params + doubleLabelUpParams),
        [params.keyboard.sevenButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.sevenButton.params + doubleLabelDownParams),
      },
    }
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.eightButton.name,
    isDark,
    normalButtonSize + params.keyboard.eightButton.params + hintStyle
    + {
      foregroundStyleName: [
        params.keyboard.asteriskButton.name + 'ForegroundStyle',
        params.keyboard.eightButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle: {
        [params.keyboard.asteriskButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.asteriskButton.params + doubleLabelUpParams),
        [params.keyboard.eightButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.eightButton.params + doubleLabelDownParams),
      },
    }
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.nineButton.name,
    isDark,
    normalButtonSize + params.keyboard.nineButton.params + hintStyle
    + {
      foregroundStyleName: [
        params.keyboard.leftParenthesisButton.name + 'ForegroundStyle',
        params.keyboard.nineButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle: {
        [params.keyboard.leftParenthesisButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.leftParenthesisButton.params + doubleLabelUpParams),
        [params.keyboard.nineButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.nineButton.params + doubleLabelDownParams),
      },
    }
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.zeroButton.name,
    isDark,
    normalButtonSize + params.keyboard.zeroButton.params + hintStyle
    + {
      foregroundStyleName: [
        params.keyboard.rightParenthesisButton.name + 'ForegroundStyle',
        params.keyboard.zeroButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle: {
        [params.keyboard.rightParenthesisButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.rightParenthesisButton.params + doubleLabelUpParams),
        [params.keyboard.zeroButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.zeroButton.params + doubleLabelDownParams),
      },
    }
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.hyphenButton.name,
    isDark,
    normalButtonSize + params.keyboard.hyphenButton.params + hintStyle
    + {
      foregroundStyleName: [
        params.keyboard.emDashButton.name + 'ForegroundStyle',
        params.keyboard.hyphenButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle: {
        [params.keyboard.emDashButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.emDashButton.params + doubleLabelUpParams),
        [params.keyboard.hyphenButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.hyphenButton.params + doubleLabelDownParams),
      },
    }
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.equalButton.name,
    isDark,
    normalButtonSize + params.keyboard.equalButton.params + hintStyle
    + {
      foregroundStyleName: [
        params.keyboard.plusButton.name + 'ForegroundStyle',
        params.keyboard.equalButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle: {
        [params.keyboard.plusButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.plusButton.params + doubleLabelUpParams),
        [params.keyboard.equalButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.equalButton.params + doubleLabelDownParams),
      },
    }
  )
  + basicStyle.newSystemButton(
    params.keyboard.backspaceButton.name,
    isDark,
    {
      size: { width: '1.7/16' },

    } + rightSystemButtonImageOffset + params.keyboard.backspaceButton.params,
  )

  // Second Row
  + basicStyle.newSystemButton(
    params.keyboard.tabButton.name,
    isDark,
    {
      size: { width: '1.7/16' },
    } + leftSystemButtonImageOffset + params.keyboard.tabButton.params,
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.qButton.name,
    isDark,
    normalButtonSize + params.keyboard.qButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.wButton.name,
    isDark,
    normalButtonSize + params.keyboard.wButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.eButton.name,
    isDark,
    normalButtonSize + params.keyboard.eButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.rButton.name,
    isDark,
    normalButtonSize + params.keyboard.rButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.tButton.name,
    isDark,
    normalButtonSize + params.keyboard.tButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.yButton.name,
    isDark,
    normalButtonSize + params.keyboard.yButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.uButton.name,
    isDark,
    normalButtonSize + params.keyboard.uButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.iButton.name,
    isDark,
    normalButtonSize + params.keyboard.iButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.oButton.name,
    isDark,
    normalButtonSize + params.keyboard.oButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.pButton.name,
    isDark,
    normalButtonSize + params.keyboard.pButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.leftChineseBracketButton.name,
    isDark,
    normalButtonSize + params.keyboard.leftChineseBracketButton.params + hintStyle
    + {
      foregroundStyleName: [
        params.keyboard.leftChineseAngleQuoteButton.name + 'ForegroundStyle',
        params.keyboard.leftChineseBracketButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle: {
        [params.keyboard.leftChineseAngleQuoteButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.leftChineseAngleQuoteButton.params + doubleLabelUpParams),
        [params.keyboard.leftChineseBracketButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.leftChineseBracketButton.params + doubleLabelDownParams),
      },
    }
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.rightChineseBracketButton.name,
    isDark,
    normalButtonSize + params.keyboard.rightChineseBracketButton.params + hintStyle
    + {
      foregroundStyleName: [
        params.keyboard.rightChineseAngleQuoteButton.name + 'ForegroundStyle',
        params.keyboard.rightChineseBracketButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle: {
        [params.keyboard.rightChineseAngleQuoteButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.rightChineseAngleQuoteButton.params + doubleLabelUpParams),
        [params.keyboard.rightChineseBracketButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.rightChineseBracketButton.params + doubleLabelDownParams),
      },
    }
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.ideographicCommaButton.name,
    isDark,
    normalButtonSize + params.keyboard.ideographicCommaButton.params + hintStyle
    + {
      foregroundStyleName: [
        params.keyboard.verticalBarButton.name + 'ForegroundStyle',
        params.keyboard.ideographicCommaButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle: {
        [params.keyboard.verticalBarButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.verticalBarButton.params + doubleLabelUpParams),
        [params.keyboard.ideographicCommaButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.ideographicCommaButton.params + doubleLabelDownParams),
      },
    }
  )

  // three Row
  + basicStyle.newSystemButton(
    params.keyboard.asciiModeButton.name,
    isDark,
    {
      size:
        { width: '3.9/32' },
    } + params.keyboard.asciiModeButton.params
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.aButton.name,
    isDark,
    normalButtonSize + params.keyboard.aButton.params + hintStyle,
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.sButton.name,
    isDark,
    normalButtonSize + params.keyboard.sButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.dButton.name,
    isDark,
    normalButtonSize + params.keyboard.dButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.fButton.name,
    isDark,
    normalButtonSize + params.keyboard.fButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.gButton.name,
    isDark,
    normalButtonSize + params.keyboard.gButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.hButton.name,
    isDark,
    normalButtonSize + params.keyboard.hButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.jButton.name,
    isDark,
    normalButtonSize + params.keyboard.jButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.kButton.name,
    isDark,
    normalButtonSize + params.keyboard.kButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.lButton.name,
    isDark,
    normalButtonSize + params.keyboard.lButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.chineseSemicolonButton.name,
    isDark,
    normalButtonSize + params.keyboard.chineseSemicolonButton.params + hintStyle
    + {
      foregroundStyleName: [
        params.keyboard.chineseColonButton.name + 'ForegroundStyle',
        params.keyboard.chineseSemicolonButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle: {
        [params.keyboard.chineseColonButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.chineseColonButton.params + doubleLabelUpParams),
        [params.keyboard.chineseSemicolonButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.chineseSemicolonButton.params + doubleLabelDownParams),
      },
    }
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.leftSingleQuoteButton.name,
    isDark,
    normalButtonSize + params.keyboard.leftSingleQuoteButton.params + hintStyle
    + {
      foregroundStyleName: [
        params.keyboard.rightCurlyQuoteButton.name + 'ForegroundStyle',
        params.keyboard.rightSingleQuoteButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle: {
        [params.keyboard.rightCurlyQuoteButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.rightCurlyQuoteButton.params + doubleLabelUpParams),
        [params.keyboard.rightSingleQuoteButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.rightSingleQuoteButton.params + doubleLabelDownParams),
      },
    }
  )
  + basicStyle.newSystemButton(
    params.keyboard.enterButton.name,
    isDark,
    {
      size: { width: '3.9/32' },
      backgroundStyle: basicStyle.enterButtonBackgroundStyle,
      foregroundStyle: basicStyle.enterButtonForegroundStyle,
    } + params.keyboard.enterButton.params
  )

  // fourth Row
  + basicStyle.newSystemButton(
    'left' + params.keyboard.shiftButton.name,
    isDark,
    {
      size: { width: '2.5/16' },
    }
    + params.keyboard.shiftButton.params
    + {
      uppercasedStateForegroundStyle: params.keyboard.shiftButton.name + 'UppercasedForegroundStyle',
    }
    + {
      capsLockedStateForegroundStyle: params.keyboard.shiftButton.name + 'CapsLockedForegroundStyle',
    }
  )
  + {
    [params.keyboard.shiftButton.name + 'UppercasedForegroundStyle']:
      basicStyle.newImageSystemButtonForegroundStyle(isDark, params.keyboard.shiftButton.uppercasedParams),
    [params.keyboard.shiftButton.name + 'CapsLockedForegroundStyle']:
      basicStyle.newImageSystemButtonForegroundStyle(isDark, params.keyboard.shiftButton.capsLockedParams),
  }

  + basicStyle.newAlphabeticButton(
    params.keyboard.zButton.name,
    isDark,
    normalButtonSize + params.keyboard.zButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.xButton.name,
    isDark,
    normalButtonSize + params.keyboard.xButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.cButton.name,
    isDark,
    normalButtonSize + params.keyboard.cButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.vButton.name,
    isDark,
    normalButtonSize + params.keyboard.vButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.bButton.name,
    isDark,
    normalButtonSize + params.keyboard.bButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.nButton.name,
    isDark,
    normalButtonSize + params.keyboard.nButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.mButton.name,
    isDark,
    normalButtonSize + params.keyboard.mButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.chineseCommaButton.name,
    isDark,
    normalButtonSize + params.keyboard.chineseCommaButton.params + hintStyle
    + {
      foregroundStyleName: [
        params.keyboard.leftBookTitleMarkButton.name + 'ForegroundStyle',
        params.keyboard.chineseCommaButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle: {
        [params.keyboard.leftBookTitleMarkButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.leftBookTitleMarkButton.params + doubleLabelUpParams),
        [params.keyboard.chineseCommaButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.chineseCommaButton.params + doubleLabelDownParams),
      },
    }
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.chinesePeriodButton.name,
    isDark,
    normalButtonSize + params.keyboard.chinesePeriodButton.params + hintStyle
    + {
      foregroundStyleName: [
        params.keyboard.rightBookTitleMarkButton.name + 'ForegroundStyle',
        params.keyboard.chinesePeriodButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle: {
        [params.keyboard.rightBookTitleMarkButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.rightBookTitleMarkButton.params + doubleLabelUpParams),
        [params.keyboard.chinesePeriodButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.chinesePeriodButton.params + doubleLabelDownParams),
      },
    }
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.forwardSlashButton.name,
    isDark,
    normalButtonSize + params.keyboard.forwardSlashButton.params + hintStyle
    + {
      foregroundStyleName: [
        params.keyboard.questionMarkButton.name + 'ForegroundStyle',
        params.keyboard.forwardSlashButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle: {
        [params.keyboard.questionMarkButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.questionMarkButton.params + doubleLabelUpParams),
        [params.keyboard.forwardSlashButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.forwardSlashButton.params + doubleLabelDownParams),
      },
    }
  )
  + basicStyle.newSystemButton(
    'right' + params.keyboard.shiftButton.name,
    isDark,
    {
      size: { width: '2.5/16' },
    }
    + params.keyboard.shiftButton.params
    + {
      uppercasedStateForegroundStyle: params.keyboard.shiftButton.name + 'UppercasedForegroundStyle',
    }
    + {
      capsLockedStateForegroundStyle: params.keyboard.shiftButton.name + 'CapsLockedForegroundStyle',
    }
  )
  + {
    [params.keyboard.shiftButton.name + 'UppercasedForegroundStyle']:
      basicStyle.newImageSystemButtonForegroundStyle(isDark, params.keyboard.shiftButton.uppercasedParams),
    [params.keyboard.shiftButton.name + 'CapsLockedForegroundStyle']:
      basicStyle.newImageSystemButtonForegroundStyle(isDark, params.keyboard.shiftButton.capsLockedParams),
  }


  // five Row
  + basicStyle.newSystemButton(
    params.keyboard.otherKeyboardButton.name,
    isDark,
    {
      size: { width: '1.65/16' },
    }
    + params.keyboard.otherKeyboardButton.params
  )
  + basicStyle.newSystemButton(
    params.keyboard.numericButton.name,
    isDark,
    {
      size: { width: '1.65/16' },
    }
    + params.keyboard.numericButton.params
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.spaceButton.name,
    isDark,
    params.keyboard.spaceButton.params,
    needHint=false
  )
  + basicStyle.newSystemButton(
    params.keyboard.numericButton.name,
    isDark,
    {
      size: { width: '1.65/16' },
    } + params.keyboard.numericButton.params
  )
  + basicStyle.newSystemButton(
    params.keyboard.dismissButton.name,
    isDark,
    {
      size: { width: '1.65/16' },
    } + params.keyboard.dismissButton.params
  )
;


{
  new(isDark, isPortrait):
    preedit.new(isDark, candidateInsets)
    + toolbar.new(isDark, candidateInsets)
    + basicStyle.newKeyboardBackgroundStyle(isDark)
    + basicStyle.newAlphabeticButtonBackgroundStyle(isDark, extraParams(isPortrait))
    + basicStyle.newAlphabeticButtonHintStyle(isDark)
    + basicStyle.newSystemButtonBackgroundStyle(isDark, extraParams(isPortrait))
    + basicStyle.newBlueButtonBackgroundStyle(isDark)
    + basicStyle.newBlueButtonForegroundStyle(isDark, params.keyboard.enterButton.params)
    + basicStyle.newAlphabeticHintBackgroundStyle(isDark, { cornerRadius: 10 })
    + newKeyLayout(isDark, isPortrait)
    + basicStyle.newEnterButtonForegroundStyle(isDark, params.keyboard.enterButton.params)
    + basicStyle.newCommitCandidateForegroundStyle(isDark, { text: '选定' })
    // Notifications
    + basicStyle.returnKeyboardTypeChangedNotification
    + basicStyle.preeditChangedForEnterButtonNotification
    + basicStyle.preeditChangedForSpaceButtonNotification,
}
