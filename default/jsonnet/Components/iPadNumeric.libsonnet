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
          { Cell: params.keyboard.periodButton.name },
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
          { Cell: params.keyboard.lessThanButton.name },
          { Cell: params.keyboard.greaterThanButton.name },
          { Cell: params.keyboard.backspaceButton.name },
        ],
      },
    },
    {
      HStack: {
        subviews: [
          { Cell: params.keyboard.tabButton.name },
          { Cell: params.keyboard.leftChineseBracketButton.name },
          { Cell: params.keyboard.rightChineseBracketButton.name },
          { Cell: params.keyboard.leftChineseBraceButton.name },
          { Cell: params.keyboard.rightChineseBraceButton.name },
          { Cell: params.keyboard.hashButton.name },
          { Cell: params.keyboard.percentButton.name },
          { Cell: params.keyboard.caretButton.name },
          { Cell: params.keyboard.asteriskButton.name },
          { Cell: params.keyboard.plusButton.name },
          { Cell: params.keyboard.equalButton.name },
          { Cell: params.keyboard.backslashButton.name },
          { Cell: params.keyboard.verticalBarButton.name },
          { Cell: params.keyboard.underscoreButton.name },
        ],
      },
    },
    {
      HStack: {
        subviews: [
          { Cell: params.keyboard.asciiModeButton.name },
          { Cell: params.keyboard.hyphenButton.name },
          { Cell: params.keyboard.forwardSlashButton.name },
          { Cell: params.keyboard.chineseColonButton.name },
          { Cell: params.keyboard.chineseSemicolonButton.name },
          { Cell: params.keyboard.leftChineseParenthesisButton.name },
          { Cell: params.keyboard.rightChineseParenthesisButton.name },
          { Cell: params.keyboard.dollarButton.name },
          { Cell: params.keyboard.ampersandButton.name },
          { Cell: params.keyboard.atButton.name },
          { Cell: params.keyboard.leftSingleQuoteButton.name },
          { Cell: params.keyboard.euroButton.name },
          { Cell: params.keyboard.enterButton.name },
        ],
      },
    },
    {
      HStack: {
        subviews: [
          { Cell: 'left' + params.keyboard.shiftButton.name },
          { Cell: params.keyboard.ellipsisButton.name },
          { Cell: params.keyboard.middleDotButton.name },
          { Cell: params.keyboard.chinesePeriodButton.name },
          { Cell: params.keyboard.chineseCommaButton.name },
          { Cell: params.keyboard.ideographicCommaButton.name },
          { Cell: params.keyboard.chineseQuestionMarkButton.name },
          { Cell: params.keyboard.chineseExclamationMarkButton.name },
          { Cell: params.keyboard.tildeButton.name },
          { Cell: params.keyboard.leftCurlyQuoteButton.name },
          { Cell: params.keyboard.rightCurlyQuoteButton.name },
          { Cell: 'right' + params.keyboard.shiftButton.name },
        ],
      },
    },
    {
      HStack: {
        subviews: [
          { Cell: params.keyboard.otherKeyboardButton.name },
          { Cell: params.keyboard.pinyinButton.name },
          { Cell: params.keyboard.spaceButton.name },
          { Cell: params.keyboard.pinyinButton.name },
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
    params.keyboard.periodButton.name,
    isDark,
    normalButtonSize
    + params.keyboard.periodButton.params
    + hintStyle
    + {
      foregroundStyleName: [
        params.keyboard.periodButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle: {
        [params.keyboard.periodButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.periodButton.params),
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
        params.keyboard.oneButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle: {
        [params.keyboard.oneButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.oneButton.params),
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
        params.keyboard.twoButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle: {
        [params.keyboard.twoButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.twoButton.params),
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
        params.keyboard.threeButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle: {
        [params.keyboard.threeButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.threeButton.params),
      },
    }
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.fourButton.name,
    isDark,
    normalButtonSize + params.keyboard.fourButton.params + hintStyle
    + {
      foregroundStyleName: [
        params.keyboard.fourButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle: {
        [params.keyboard.fourButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.fourButton.params),
      },
    }
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.fiveButton.name,
    isDark,
    normalButtonSize + params.keyboard.fiveButton.params + hintStyle
    + {
      foregroundStyleName: [
        params.keyboard.fiveButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle: {
        [params.keyboard.fiveButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.fiveButton.params),
      },
    }
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.sixButton.name,
    isDark,
    normalButtonSize + params.keyboard.sixButton.params + hintStyle
    + {
      foregroundStyleName: [
        params.keyboard.sixButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle: {
        [params.keyboard.sixButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.sixButton.params),
      },
    }
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.sevenButton.name,
    isDark,
    normalButtonSize + params.keyboard.sevenButton.params + hintStyle
    + {
      foregroundStyleName: [
        params.keyboard.sevenButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle: {
        [params.keyboard.sevenButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.sevenButton.params),
      },
    }
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.eightButton.name,
    isDark,
    normalButtonSize + params.keyboard.eightButton.params + hintStyle
    + {
      foregroundStyleName: [
        params.keyboard.eightButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle: {
        [params.keyboard.eightButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.eightButton.params),
      },
    }
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.nineButton.name,
    isDark,
    normalButtonSize + params.keyboard.nineButton.params + hintStyle
    + {
      foregroundStyleName: [
        params.keyboard.nineButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle: {
        [params.keyboard.nineButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.nineButton.params),
      },
    }
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.zeroButton.name,
    isDark,
    normalButtonSize + params.keyboard.zeroButton.params + hintStyle
    + {
      foregroundStyleName: [
        params.keyboard.zeroButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle: {
        [params.keyboard.zeroButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.zeroButton.params),
      },
    }
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.lessThanButton.name,
    isDark,
    normalButtonSize + params.keyboard.lessThanButton.params + hintStyle
    + {
      foregroundStyleName: [
        params.keyboard.lessThanButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle: {
        [params.keyboard.lessThanButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.lessThanButton.params),
      },
    }
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.greaterThanButton.name,
    isDark,
    normalButtonSize + params.keyboard.greaterThanButton.params + hintStyle
    + {
      foregroundStyleName: [
        params.keyboard.greaterThanButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle: {
        [params.keyboard.greaterThanButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.greaterThanButton.params),
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
    params.keyboard.leftChineseBracketButton.name,
    isDark,
    normalButtonSize + params.keyboard.leftChineseBracketButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.rightChineseBracketButton.name,
    isDark,
    normalButtonSize + params.keyboard.rightChineseBracketButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.leftChineseBraceButton.name,
    isDark,
    normalButtonSize + params.keyboard.leftChineseBraceButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.rightChineseBraceButton.name,
    isDark,
    normalButtonSize + params.keyboard.rightChineseBraceButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.hashButton.name,
    isDark,
    normalButtonSize + params.keyboard.hashButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.percentButton.name,
    isDark,
    normalButtonSize + params.keyboard.percentButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.caretButton.name,
    isDark,
    normalButtonSize + params.keyboard.caretButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.asteriskButton.name,
    isDark,
    normalButtonSize + params.keyboard.asteriskButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.plusButton.name,
    isDark,
    normalButtonSize + params.keyboard.plusButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.equalButton.name,
    isDark,
    normalButtonSize + params.keyboard.equalButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.backslashButton.name,
    isDark,
    normalButtonSize + params.keyboard.backslashButton.params + hintStyle
    + {
      foregroundStyleName: [
        params.keyboard.backslashButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle: {
        [params.keyboard.backslashButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.backslashButton.params),
      },
    }
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.verticalBarButton.name,
    isDark,
    normalButtonSize + params.keyboard.verticalBarButton.params + hintStyle
    + {
      foregroundStyleName: [
        params.keyboard.verticalBarButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle: {
        [params.keyboard.verticalBarButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.verticalBarButton.params),
      },
    }
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.underscoreButton.name,
    isDark,
    normalButtonSize + params.keyboard.underscoreButton.params + hintStyle
    + {
      foregroundStyleName: [
        params.keyboard.underscoreButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle: {
        [params.keyboard.underscoreButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.underscoreButton.params),
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
    params.keyboard.hyphenButton.name,
    isDark,
    normalButtonSize + params.keyboard.hyphenButton.params + hintStyle,
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.forwardSlashButton.name,
    isDark,
    normalButtonSize + params.keyboard.forwardSlashButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.chineseColonButton.name,
    isDark,
    normalButtonSize + params.keyboard.chineseColonButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.chineseSemicolonButton.name,
    isDark,
    normalButtonSize + params.keyboard.chineseSemicolonButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.leftChineseParenthesisButton.name,
    isDark,
    normalButtonSize + params.keyboard.leftChineseParenthesisButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.rightChineseParenthesisButton.name,
    isDark,
    normalButtonSize + params.keyboard.rightChineseParenthesisButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.dollarButton.name,
    isDark,
    normalButtonSize + params.keyboard.dollarButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.ampersandButton.name,
    isDark,
    normalButtonSize + params.keyboard.ampersandButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.atButton.name,
    isDark,
    normalButtonSize + params.keyboard.atButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.leftSingleQuoteButton.name,
    isDark,
    normalButtonSize + params.keyboard.leftSingleQuoteButton.params + hintStyle
    + {
      foregroundStyleName: [
        params.keyboard.leftSingleQuoteButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle: {
        [params.keyboard.leftSingleQuoteButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.leftSingleQuoteButton.params + doubleLabelDownParams),
      },
    }
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.euroButton.name,
    isDark,
    normalButtonSize + params.keyboard.euroButton.params + hintStyle
    + {
      foregroundStyleName: [
        params.keyboard.euroButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle: {
        [params.keyboard.euroButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.euroButton.params),
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
    params.keyboard.ellipsisButton.name,
    isDark,
    normalButtonSize + params.keyboard.ellipsisButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.middleDotButton.name,
    isDark,
    normalButtonSize + params.keyboard.middleDotButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.chinesePeriodButton.name,
    isDark,
    normalButtonSize + params.keyboard.chinesePeriodButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.chineseCommaButton.name,
    isDark,
    normalButtonSize + params.keyboard.chineseCommaButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.ideographicCommaButton.name,
    isDark,
    normalButtonSize + params.keyboard.ideographicCommaButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.chineseQuestionMarkButton.name,
    isDark,
    normalButtonSize + params.keyboard.chineseQuestionMarkButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.chineseExclamationMarkButton.name,
    isDark,
    normalButtonSize + params.keyboard.chineseExclamationMarkButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.tildeButton.name,
    isDark,
    normalButtonSize + params.keyboard.tildeButton.params + hintStyle
    + {
      foregroundStyleName: [
        params.keyboard.tildeButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle: {
        [params.keyboard.tildeButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.tildeButton.params + doubleLabelDownParams),
      },
    }
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.leftCurlyQuoteButton.name,
    isDark,
    normalButtonSize + params.keyboard.leftCurlyQuoteButton.params + hintStyle
    + {
      foregroundStyleName: [
        params.keyboard.leftCurlyQuoteButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle: {
        [params.keyboard.leftCurlyQuoteButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.leftCurlyQuoteButton.params + doubleLabelDownParams),
      },
    }
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.rightCurlyQuoteButton.name,
    isDark,
    normalButtonSize + params.keyboard.rightCurlyQuoteButton.params + hintStyle
    + {
      foregroundStyleName: [
        params.keyboard.rightCurlyQuoteButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle: {
        [params.keyboard.rightCurlyQuoteButton.name + 'ForegroundStyle']:
          basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.keyboard.rightCurlyQuoteButton.params + doubleLabelDownParams),
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
    params.keyboard.pinyinButton.name,
    isDark,
    {
      size: { width: '1.65/16' },
    }
    + params.keyboard.pinyinButton.params
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.spaceButton.name,
    isDark,
    params.keyboard.spaceButton.params,
    needHint=false
  )
  + basicStyle.newSystemButton(
    params.keyboard.pinyinButton.name,
    isDark,
    {
      size: { width: '1.65/16' },
    } + params.keyboard.pinyinButton.params
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
