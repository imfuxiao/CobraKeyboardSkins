local fonts = import '../Constants/Fonts.libsonnet';
local params = import '../Constants/Keyboard.libsonnet';
local basicStyle = import 'BasicStyle.libsonnet';
local preedit = import 'Preedit.libsonnet';
local toolbar = import 'Toolbar.libsonnet';
local utils = import 'Utils.libsonnet';

local hintStyle = {
  hintStyle: {
    size: { width: 50, height: 50 },
  },
};

local topBadgeLabelUpParams = {
  center: {
    y: 0.2,
  },
  fontSize: fonts.iPhone.button.doubleLabelSmallFontSize,
};

local leftBadgeLabelUpParams = {
  center: {
    x: 0.25,
    y: 0.2,
  },
  fontSize: fonts.iPhone.button.doubleLabelSmallFontSize,
};

local rightBadgeLabelUpParams = {
  center: {
    x: 0.75,
    y: 0.2,
  },
  fontSize: fonts.iPhone.button.doubleLabelSmallFontSize,
};

local createSwipeUpHintStyle(isDark, params={}) = {
  [params.name + 'SwipeUpHintForegroundStyle']:
    basicStyle.newAlphabeticButtonHintStyle(isDark) + basicStyle.getKeyboardActionText(params.params),
};

local createSwipeDownHintStyle(isDark, params={}) = {
  [params.name + 'SwipeDownHintForegroundStyle']:
    basicStyle.newAlphabeticButtonHintStyle(isDark) + basicStyle.getKeyboardActionText(params.params),
};

local createButtonForegroundStyle(isDark, params={}) = {
  [params.name + 'ForegroundStyle']:
    basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.params),
};

local createTopBadgeForegroundStyle(isDark, params={}) = {
  [params.name + 'ForegroundStyle']:
    basicStyle.newAlphabeticButtonSwipeForegroundStyle(isDark, params.params + topBadgeLabelUpParams),
};

local createLeftTopBadgeForegroundStyle(isDark, params={}) = {
  [params.name + 'ForegroundStyle']:
    basicStyle.newAlphabeticButtonSwipeForegroundStyle(isDark, params.params + leftBadgeLabelUpParams),
};

local createRightTopBadgeForegroundStyle(isDark, params={}) = {
  [params.name + 'ForegroundStyle']:
    basicStyle.newAlphabeticButtonSwipeForegroundStyle(isDark, params.params + rightBadgeLabelUpParams),
};


// 标准26键布局
local alphabeticKeyboardLayout = {
  keyboardLayout: [
    {
      HStack: {
        subviews: [
          {
            Cell: params.keyboard.oneButton.name,
          },
          {
            Cell: params.keyboard.twoButton.name,
          },
          {
            Cell: params.keyboard.threeButton.name,
          },
          {
            Cell: params.keyboard.fourButton.name,
          },
          {
            Cell: params.keyboard.fiveButton.name,
          },
          {
            Cell: params.keyboard.sixButton.name,
          },
          {
            Cell: params.keyboard.sevenButton.name,
          },
          {
            Cell: params.keyboard.eightButton.name,
          },
          {
            Cell: params.keyboard.nineButton.name,
          },
          {
            Cell: params.keyboard.zeroButton.name,
          },
        ],
      },
    },
    {
      HStack: {
        subviews: [
          {
            Cell: params.keyboard.qButton.name,
          },
          {
            Cell: params.keyboard.wButton.name,
          },
          {
            Cell: params.keyboard.eButton.name,
          },
          {
            Cell: params.keyboard.rButton.name,
          },
          {
            Cell: params.keyboard.tButton.name,
          },
          {
            Cell: params.keyboard.yButton.name,
          },
          {
            Cell: params.keyboard.uButton.name,
          },
          {
            Cell: params.keyboard.iButton.name,
          },
          {
            Cell: params.keyboard.oButton.name,
          },
          {
            Cell: params.keyboard.pButton.name,
          },
        ],
      },
    },
    {
      HStack: {
        subviews: [
          {
            Cell: params.keyboard.aButton.name,
          },
          {
            Cell: params.keyboard.sButton.name,
          },
          {
            Cell: params.keyboard.dButton.name,
          },
          {
            Cell: params.keyboard.fButton.name,
          },
          {
            Cell: params.keyboard.gButton.name,
          },
          {
            Cell: params.keyboard.hButton.name,
          },
          {
            Cell: params.keyboard.jButton.name,
          },
          {
            Cell: params.keyboard.kButton.name,
          },
          {
            Cell: params.keyboard.lButton.name,
          },
          {
            Cell: params.keyboard.semicolonButton.name,
          },
        ],
      },
    },
    {
      HStack: {
        subviews: [
          {
            Cell: params.keyboard.zButton.name,
          },
          {
            Cell: params.keyboard.xButton.name,
          },
          {
            Cell: params.keyboard.cButton.name,
          },
          {
            Cell: params.keyboard.vButton.name,
          },
          {
            Cell: params.keyboard.bButton.name,
          },
          {
            Cell: params.keyboard.nButton.name,
          },
          {
            Cell: params.keyboard.mButton.name,
          },
          {
            Cell: params.keyboard.commaButton.name,
          },
          {
            Cell: params.keyboard.periodButton.name,
          },
          {
            Cell: params.keyboard.forwardSlashButton.name,
          },
        ],
      },
    },
    {
      HStack: {
        subviews: [
          {
            Cell: params.keyboard.numericButton.name,
          },
          {
            Cell: params.keyboard.shiftButton.name,
          },
          {
            Cell: params.keyboard.apostropheButton.name,
          },
          {
            Cell: params.keyboard.spaceButton.name,
          },
          {
            Cell: params.keyboard.backspaceButton.name,
          },
          {
            Cell: params.keyboard.enterButton.name,
          },
        ],
      },
    },
  ],
};


local newKeyLayout(isDark=false, isPortrait=true) =
  local keyboardHeight = if isPortrait then params.keyboard.height.iPhone.portrait else params.keyboard.height.iPhone.landscape;
  {
    keyboardHeight: keyboardHeight,
    keyboardStyle: utils.newBackgroundStyle(style=basicStyle.keyboardBackgroundStyleName),
  }
  + alphabeticKeyboardLayout

  // zero Row
  + basicStyle.newAlphabeticButton(
    params.keyboard.oneButton.name,
    isDark,
    params.keyboard.oneButton.params
    {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.exclamationMarkButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.oneButton.name + 'ForegroundStyle',
        params.keyboard.exclamationMarkButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.oneButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.exclamationMarkButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.exclamationMarkButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.twoButton.name,
    isDark,
    params.keyboard.twoButton.params
    {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.atButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.twoButton.name + 'ForegroundStyle',
        params.keyboard.atButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.twoButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.atButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.atButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.threeButton.name,
    isDark,
    params.keyboard.threeButton.params
    {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.hashButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.threeButton.name + 'ForegroundStyle',
        params.keyboard.hashButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.threeButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.hashButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.hashButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.fourButton.name,
    isDark,
    params.keyboard.fourButton.params
    {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.dollarButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.fourButton.name + 'ForegroundStyle',
        params.keyboard.dollarButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.fourButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.dollarButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.dollarButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.fiveButton.name,
    isDark,
    params.keyboard.fiveButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.percentButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.fiveButton.name + 'ForegroundStyle',
        params.keyboard.percentButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.fiveButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.percentButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.percentButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.sixButton.name,
    isDark,
    params.keyboard.sixButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.caretButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.sixButton.name + 'ForegroundStyle',
        params.keyboard.caretButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.sixButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.caretButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.caretButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.sevenButton.name,
    isDark,
    params.keyboard.sevenButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.ampersandButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.sevenButton.name + 'ForegroundStyle',
        params.keyboard.ampersandButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.sevenButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.ampersandButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.ampersandButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.eightButton.name,
    isDark,
    params.keyboard.eightButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.asteriskButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.eightButton.name + 'ForegroundStyle',
        params.keyboard.asteriskButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.eightButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.asteriskButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.asteriskButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.nineButton.name,
    isDark,
    params.keyboard.nineButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.leftParenthesisButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.nineButton.name + 'ForegroundStyle',
        params.keyboard.leftParenthesisButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.nineButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.leftParenthesisButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.leftParenthesisButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.zeroButton.name,
    isDark,
    params.keyboard.zeroButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.rightParenthesisButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.zeroButton.name + 'ForegroundStyle',
        params.keyboard.rightParenthesisButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.zeroButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.rightParenthesisButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.rightParenthesisButton)

  // First Row
  + basicStyle.newAlphabeticButton(
    params.keyboard.qButton.name,
    isDark,
    params.keyboard.qButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.graveButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.qButton.name + 'ForegroundStyle',
        params.keyboard.graveButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.qButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.graveButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.graveButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.wButton.name,
    isDark,
    params.keyboard.wButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.tildeButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.wButton.name + 'ForegroundStyle',
        params.keyboard.tildeButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.wButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.tildeButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.tildeButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.eButton.name,
    isDark,
    params.keyboard.eButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.plusButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.eButton.name + 'ForegroundStyle',
        params.keyboard.plusButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.eButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.plusButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.plusButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.rButton.name,
    isDark,
    params.keyboard.rButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.hyphenButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.rButton.name + 'ForegroundStyle',
        params.keyboard.hyphenButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.rButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.hyphenButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.hyphenButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.tButton.name,
    isDark,
    params.keyboard.tButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.equalButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.tButton.name + 'ForegroundStyle',
        params.keyboard.equalButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.tButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.equalButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.equalButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.yButton.name,
    isDark,
    params.keyboard.yButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.underscoreButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.yButton.name + 'ForegroundStyle',
        params.keyboard.underscoreButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.yButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.underscoreButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.underscoreButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.uButton.name,
    isDark,
    params.keyboard.uButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.leftBraceButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.uButton.name + 'ForegroundStyle',
        params.keyboard.leftBraceButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.uButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.leftBraceButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.leftBraceButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.iButton.name,
    isDark,
    params.keyboard.iButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.rightBraceButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.iButton.name + 'ForegroundStyle',
        params.keyboard.rightBraceButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.iButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.rightBraceButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.rightBraceButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.oButton.name,
    isDark,
    params.keyboard.oButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.leftBracketButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.oButton.name + 'ForegroundStyle',
        params.keyboard.leftBracketButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.oButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.leftBracketButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.leftBracketButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.pButton.name,
    isDark,
    params.keyboard.pButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.rightBracketButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.pButton.name + 'ForegroundStyle',
        params.keyboard.rightBracketButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.pButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.rightBracketButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.rightBracketButton)

  // Second Row
  + basicStyle.newAlphabeticButton(
    params.keyboard.aButton.name,
    isDark,
    params.keyboard.aButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.straightQuoteButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.aButton.name + 'ForegroundStyle',
        params.keyboard.straightQuoteButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.aButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.straightQuoteButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.straightQuoteButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.sButton.name,
    isDark,
    params.keyboard.sButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.verticalBarButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.sButton.name + 'ForegroundStyle',
        params.keyboard.verticalBarButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.sButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.verticalBarButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.verticalBarButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.dButton.name,
    isDark,
    params.keyboard.dButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.multiplicationButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.dButton.name + 'ForegroundStyle',
        params.keyboard.multiplicationButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.dButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.multiplicationButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.multiplicationButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.fButton.name,
    isDark,
    params.keyboard.fButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.divisionButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.fButton.name + 'ForegroundStyle',
        params.keyboard.divisionButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.fButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.divisionButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.divisionButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.gButton.name,
    isDark,
    params.keyboard.gButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.downArrowButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.gButton.name + 'ForegroundStyle',
        params.keyboard.downArrowButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.gButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.downArrowButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.downArrowButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.hButton.name,
    isDark,
    params.keyboard.hButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.upArrowButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.hButton.name + 'ForegroundStyle',
        params.keyboard.upArrowButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.hButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.upArrowButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.upArrowButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.jButton.name,
    isDark,
    params.keyboard.jButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.leftArrowButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.jButton.name + 'ForegroundStyle',
        params.keyboard.leftArrowButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.jButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.leftArrowButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.leftArrowButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.kButton.name,
    isDark,
    params.keyboard.kButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.rightArrowButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.kButton.name + 'ForegroundStyle',
        params.keyboard.rightArrowButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.kButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.rightArrowButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.rightArrowButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.lButton.name,
    isDark,
    params.keyboard.lButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.lButton.params.swipeUpStyle.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.lButton.name + 'ForegroundStyle',
        params.keyboard.lButton.params.swipeUpStyle.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.lButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.lButton.params.swipeUpStyle),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.lButton.params.swipeUpStyle)

  + basicStyle.newAlphabeticButton(
    params.keyboard.semicolonButton.name,
    isDark,
    params.keyboard.semicolonButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.colonButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.semicolonButton.name + 'ForegroundStyle',
        params.keyboard.colonButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.semicolonButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.colonButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.colonButton)


  // Third Row

  + basicStyle.newAlphabeticButton(
    params.keyboard.zButton.name,
    isDark,
    params.keyboard.zButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.zButton.params.swipeUpStyle.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.zButton.name + 'ForegroundStyle',
        params.keyboard.zButton.params.swipeUpStyle.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.zButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.zButton.params.swipeUpStyle),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.zButton.params.swipeUpStyle)

  + basicStyle.newAlphabeticButton(
    params.keyboard.xButton.name,
    isDark,
    params.keyboard.xButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.xButton.params.swipeUpStyle.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.xButton.name + 'ForegroundStyle',
        params.keyboard.xButton.params.swipeUpStyle.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.xButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.xButton.params.swipeUpStyle),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.xButton.params.swipeUpStyle)


  + basicStyle.newAlphabeticButton(
    params.keyboard.cButton.name,
    isDark,
    params.keyboard.cButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.cButton.params.swipeUpStyle.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.cButton.name + 'ForegroundStyle',
        params.keyboard.cButton.params.swipeUpStyle.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.cButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.cButton.params.swipeUpStyle),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.cButton.params.swipeUpStyle)

  + basicStyle.newAlphabeticButton(
    params.keyboard.vButton.name,
    isDark,
    params.keyboard.vButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.vButton.params.swipeUpStyle.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.vButton.name + 'ForegroundStyle',
        params.keyboard.vButton.params.swipeUpStyle.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.vButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.vButton.params.swipeUpStyle),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.vButton.params.swipeUpStyle)

  + basicStyle.newAlphabeticButton(
    params.keyboard.bButton.name,
    isDark,
    params.keyboard.bButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.bButton.params.swipeUpStyle.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.bButton.name + 'ForegroundStyle',
        params.keyboard.bButton.params.swipeUpStyle.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.bButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.bButton.params.swipeUpStyle),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.bButton.params.swipeUpStyle)

  + basicStyle.newAlphabeticButton(
    params.keyboard.nButton.name,
    isDark,
    params.keyboard.nButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.nButton.params.swipeUpStyle.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.nButton.name + 'ForegroundStyle',
        params.keyboard.nButton.params.swipeUpStyle.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.nButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.nButton.params.swipeUpStyle),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.nButton.params.swipeUpStyle)

  + basicStyle.newAlphabeticButton(
    params.keyboard.mButton.name,
    isDark,
    params.keyboard.mButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.mButton.params.swipeUpStyle.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.mButton.name + 'ForegroundStyle',
        params.keyboard.mButton.params.swipeUpStyle.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.mButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.mButton.params.swipeUpStyle),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.mButton.params.swipeUpStyle)

  + basicStyle.newAlphabeticButton(
    params.keyboard.commaButton.name,
    isDark,
    params.keyboard.commaButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.lessThanButton.name + 'SwipeUpHintForegroundStyle',
        swipeDownForegroundStyle: params.keyboard.commaButton.params.swipeDownStyle.name + 'SwipeDownHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.commaButton.name + 'ForegroundStyle',
        params.keyboard.lessThanButton.name + 'ForegroundStyle',
        params.keyboard.commaButton.params.swipeDownStyle.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.commaButton)
        + createLeftTopBadgeForegroundStyle(isDark, params.keyboard.lessThanButton)
        + createRightTopBadgeForegroundStyle(isDark, params.keyboard.commaButton.params.swipeDownStyle),
    }
  )
  + createSwipeUpHintStyle(isDark, params.keyboard.lessThanButton)
  + createSwipeDownHintStyle(isDark, params.keyboard.commaButton.params.swipeDownStyle)

  + basicStyle.newAlphabeticButton(
    params.keyboard.periodButton.name,
    isDark,
    params.keyboard.periodButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.greaterThanButton.name + 'SwipeUpHintForegroundStyle',
        swipeDownForegroundStyle: params.keyboard.periodButton.params.swipeDownStyle.name + 'SwipeDownHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.periodButton.name + 'ForegroundStyle',
        params.keyboard.greaterThanButton.name + 'ForegroundStyle',
        params.keyboard.periodButton.params.swipeDownStyle.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.periodButton)
        + createLeftTopBadgeForegroundStyle(isDark, params.keyboard.greaterThanButton)
        + createRightTopBadgeForegroundStyle(isDark, params.keyboard.periodButton.params.swipeDownStyle),
    }
  )
  + createSwipeUpHintStyle(isDark, params.keyboard.greaterThanButton)
  + createSwipeDownHintStyle(isDark, params.keyboard.periodButton.params.swipeDownStyle)

  + basicStyle.newAlphabeticButton(
    params.keyboard.forwardSlashButton.name,
    isDark,
    params.keyboard.forwardSlashButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.questionMarkButton.name + 'SwipeUpHintForegroundStyle',
        swipeDownForegroundStyle: params.keyboard.forwardSlashButton.params.swipeDownStyle.name + 'SwipeDownHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.forwardSlashButton.name + 'ForegroundStyle',
        params.keyboard.questionMarkButton.name + 'ForegroundStyle',
        params.keyboard.forwardSlashButton.params.swipeDownStyle.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.forwardSlashButton)
        + createLeftTopBadgeForegroundStyle(isDark, params.keyboard.questionMarkButton)
        + createRightTopBadgeForegroundStyle(isDark, params.keyboard.forwardSlashButton.params.swipeDownStyle) + { fontSize: params.keyboard.forwardSlashButton.params.swipeDownStyle.params.badgeFontSize },
    }
  )
  + createSwipeUpHintStyle(isDark, params.keyboard.questionMarkButton)
  + createSwipeDownHintStyle(isDark, params.keyboard.forwardSlashButton.params.swipeDownStyle) + { fontSize: params.keyboard.forwardSlashButton.params.swipeDownStyle.params.hintFontSize }

  // Fourth Row

  + basicStyle.newSystemButton(
    params.keyboard.numericButton.name,
    isDark,
    {
      size:
        { width: { percentage: 0.15 } },
    }
    + params.keyboard.numericButton.params
    + {
      foregroundStyleName: [
        params.keyboard.numericButton.name + 'ForegroundStyle',
        params.keyboard.numericButton.params.swipeUpStyle.name + 'ForegroundStyle',
      ],
    }
  )
  + createButtonForegroundStyle(isDark, params.keyboard.numericButton)
  + createTopBadgeForegroundStyle(isDark, params.keyboard.numericButton.params.swipeUpStyle)

  + basicStyle.newSystemButton(
    params.keyboard.shiftButton.name,
    isDark,
    {
      size:
        { width: { percentage: 0.15 } },
    } + params.keyboard.shiftButton.params {
      uppercasedStateForegroundStyle: params.keyboard.shiftButton.name + 'UppercasedForegroundStyle',
      capsLockedStateForegroundStyle: params.keyboard.shiftButton.name + 'CapsLockedForegroundStyle',
    }
    + {
      foregroundStyleName: [
        params.keyboard.shiftButton.name + 'ForegroundStyle',
        params.keyboard.shiftButton.params.swipeUpStyle.name + 'ForegroundStyle',
      ],
    }
  ) + {
    [params.keyboard.shiftButton.name + 'UppercasedForegroundStyle']:
      basicStyle.newImageSystemButtonForegroundStyle(isDark, params.keyboard.shiftButton.uppercasedParams),
    [params.keyboard.shiftButton.name + 'CapsLockedForegroundStyle']:
      basicStyle.newImageSystemButtonForegroundStyle(isDark, params.keyboard.shiftButton.capsLockedParams),
  }
  + createButtonForegroundStyle(isDark, params.keyboard.shiftButton)
  + createTopBadgeForegroundStyle(isDark, params.keyboard.shiftButton.params.swipeUpStyle)

  + basicStyle.newAlphabeticButton(
    params.keyboard.apostropheButton.name,
    isDark,
    {
      size:
        { width: { percentage: 0.1 } },
    } + params.keyboard.apostropheButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.straightQuoteButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.apostropheButton.name + 'ForegroundStyle',
        params.keyboard.straightQuoteButton.name + 'ForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.apostropheButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.straightQuoteButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.straightQuoteButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.spaceButton.name,
    isDark,
    params.keyboard.spaceButton.params,
    needHint=false
  )
  + basicStyle.newSystemButton(
    params.keyboard.backspaceButton.name,
    isDark,
    {
      size:
        { width: { percentage: 0.15 } },
    } + params.keyboard.backspaceButton.params,
  )
  + basicStyle.newSystemButton(
    params.keyboard.enterButton.name,
    isDark,
    {
      size:
        { width: { percentage: 0.15 } },
    } + params.keyboard.enterButton.params
  )
;

{
  new(isDark, isPortrait):
    local insets = if isPortrait then params.keyboard.button.backgroundInsets.iPhone.portrait else params.keyboard.button.backgroundInsets.iPhone.landscape;

    local extraParams = {
      insets: insets,
    };

    preedit.new(isDark)
    + toolbar.new(isDark)
    + basicStyle.newKeyboardBackgroundStyle(isDark)
    + basicStyle.newAlphabeticButtonBackgroundStyle(isDark, extraParams)
    + basicStyle.newAlphabeticButtonHintStyle(isDark)
    + basicStyle.newSystemButtonBackgroundStyle(isDark, extraParams)
    + basicStyle.newBlueButtonBackgroundStyle(isDark, extraParams)
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
