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
  [params.name + 'BadgeForegroundStyle']:
    basicStyle.newAlphabeticButtonSwipeForegroundStyle(isDark, params.params + topBadgeLabelUpParams),
};

local createLeftTopBadgeForegroundStyle(isDark, params={}) = {
  [params.name + 'BadgeForegroundStyle']:
    basicStyle.newAlphabeticButtonSwipeForegroundStyle(isDark, params.params + leftBadgeLabelUpParams),
};

local createRightTopBadgeForegroundStyle(isDark, params={}) = {
  [params.name + 'BadgeForegroundStyle']:
    basicStyle.newAlphabeticButtonSwipeForegroundStyle(isDark, params.params + rightBadgeLabelUpParams),
};


// 标准26键布局
local alphabeticKeyboardLayout(addSemicolon = false) = {
  keyboardLayout: [
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
          (
            if addSemicolon == true then
              {
                Cell: params.keyboard.semicolonButton.name,
              }
            else {}
          ),
        ],
      },
    },
    {
      HStack: {
        subviews: [
          {
            Cell: params.keyboard.shiftButton.name,
          },
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
            Cell: params.keyboard.backspaceButton.name,
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
            Cell: params.keyboard.commaButton.name,
          },
          {
            Cell: params.keyboard.spaceButton.name,
          },
          {
            Cell: params.keyboard.asciiModeButton.name,
          },
          {
            Cell: params.keyboard.enterButton.name,
          },
        ],
      },
    },
  ],
};


local newKeyLayout(isDark=false, isPortrait=true, addSemicolon=true) =
  local keyboardHeight = if isPortrait then params.keyboard.height.iPhone.portrait else params.keyboard.height.iPhone.landscape;
  {
    keyboardHeight: keyboardHeight,
    keyboardStyle: utils.newBackgroundStyle(style=basicStyle.keyboardBackgroundStyleName),
  }
  + alphabeticKeyboardLayout(addSemicolon)

  // First Row
  + basicStyle.newAlphabeticButton(
    params.keyboard.qButton.name,
    isDark,
    params.keyboard.qButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.oneButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.qButton.name + 'ForegroundStyle',
        params.keyboard.oneButton.name + 'BadgeForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.qButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.oneButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.oneButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.wButton.name,
    isDark,
    params.keyboard.wButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.twoButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.wButton.name + 'ForegroundStyle',
        params.keyboard.twoButton.name + 'BadgeForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.wButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.twoButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.twoButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.eButton.name,
    isDark,
    params.keyboard.eButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.threeButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.eButton.name + 'ForegroundStyle',
        params.keyboard.threeButton.name + 'BadgeForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.eButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.threeButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.threeButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.rButton.name,
    isDark,
    params.keyboard.rButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.fourButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.rButton.name + 'ForegroundStyle',
        params.keyboard.fourButton.name + 'BadgeForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.rButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.fourButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.fourButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.tButton.name,
    isDark,
    params.keyboard.tButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.fiveButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.tButton.name + 'ForegroundStyle',
        params.keyboard.fiveButton.name + 'BadgeForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.tButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.fiveButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.fiveButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.yButton.name,
    isDark,
    params.keyboard.yButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.sixButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.yButton.name + 'ForegroundStyle',
        params.keyboard.sixButton.name + 'BadgeForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.yButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.sixButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.sixButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.uButton.name,
    isDark,
    params.keyboard.uButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.sevenButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.uButton.name + 'ForegroundStyle',
        params.keyboard.sevenButton.name + 'BadgeForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.uButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.sevenButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.sevenButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.iButton.name,
    isDark,
    params.keyboard.iButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.eightButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.iButton.name + 'ForegroundStyle',
        params.keyboard.eightButton.name + 'BadgeForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.iButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.eightButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.eightButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.oButton.name,
    isDark,
    params.keyboard.oButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.nineButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.oButton.name + 'ForegroundStyle',
        params.keyboard.nineButton.name + 'BadgeForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.oButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.nineButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.nineButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.pButton.name,
    isDark,
    params.keyboard.pButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.zeroButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.pButton.name + 'ForegroundStyle',
        params.keyboard.zeroButton.name + 'BadgeForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.pButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.zeroButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.zeroButton)

  // Second Row
  + basicStyle.newAlphabeticButton(
    params.keyboard.aButton.name,
    isDark,
    (
      if addSemicolon == false then
        {
          size:
            { width: '168.75/1125' },
          bounds:
            { width: '111/168.75', alignment: 'right' },
        }
      else {}
    )
    + params.keyboard.aButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.graveButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.aButton.name + 'ForegroundStyle',
        params.keyboard.graveButton.name + 'BadgeForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.aButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.graveButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.graveButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.sButton.name,
    isDark,
    params.keyboard.sButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.forwardSlashButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.sButton.name + 'ForegroundStyle',
        params.keyboard.forwardSlashButton.name + 'BadgeForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.sButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.forwardSlashButton),
    }
  )
  + createSwipeUpHintStyle(isDark, params.keyboard.forwardSlashButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.dButton.name,
    isDark,
    params.keyboard.dButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.colonButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.dButton.name + 'ForegroundStyle',
        params.keyboard.colonButton.name + 'BadgeForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.dButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.colonButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.colonButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.fButton.name,
    isDark,
    params.keyboard.fButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.semicolonButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.fButton.name + 'ForegroundStyle',
        params.keyboard.semicolonButton.name + 'BadgeForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.fButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.semicolonButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.semicolonButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.gButton.name,
    isDark,
    params.keyboard.gButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.leftParenthesisButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.gButton.name + 'ForegroundStyle',
        params.keyboard.leftParenthesisButton.name + 'BadgeForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.gButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.leftParenthesisButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.leftParenthesisButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.hButton.name,
    isDark,
    params.keyboard.hButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.rightParenthesisButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.hButton.name + 'ForegroundStyle',
        params.keyboard.rightParenthesisButton.name + 'BadgeForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.hButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.rightParenthesisButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.rightParenthesisButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.jButton.name,
    isDark,
    params.keyboard.jButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.tildeButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.jButton.name + 'ForegroundStyle',
        params.keyboard.tildeButton.name + 'BadgeForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.jButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.tildeButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.tildeButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.kButton.name,
    isDark,
    params.keyboard.kButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.leftCurlyQuoteButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.kButton.name + 'ForegroundStyle',
        params.keyboard.leftCurlyQuoteButton.name + 'BadgeForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.kButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.leftCurlyQuoteButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.leftCurlyQuoteButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.lButton.name,
    isDark,
    (
      if addSemicolon == false then
        {
          size:
            { width: '168.75/1125' },
          bounds:
            { width: '111/168.75', alignment: 'left' },
        }
      else {}
    )
    + params.keyboard.lButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.rightCurlyQuoteButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.lButton.name + 'ForegroundStyle',
        params.keyboard.rightCurlyQuoteButton.name + 'BadgeForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.lButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.rightCurlyQuoteButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.rightCurlyQuoteButton)

  + (
    if addSemicolon == true then
      basicStyle.newAlphabeticButton(
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
            params.keyboard.colonButton.name + 'BadgeForegroundStyle',
          ],
        }
        + {
          foregroundStyle:
            createButtonForegroundStyle(isDark, params.keyboard.semicolonButton)
            + createTopBadgeForegroundStyle(isDark, params.keyboard.colonButton),
        }
      ) + createSwipeUpHintStyle(isDark, params.keyboard.colonButton)
    else {}
  )


  // Third Row

  + basicStyle.newSystemButton(
    params.keyboard.shiftButton.name,
    isDark,
    {
      size:
        { width: { percentage: 0.15 } },
      bounds:
        { width: '151/168.75', alignment: 'left' },
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
    params.keyboard.zButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.atButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.zButton.name + 'ForegroundStyle',
        params.keyboard.atButton.name + 'BadgeForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.zButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.atButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.atButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.xButton.name,
    isDark,
    params.keyboard.xButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.periodButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.xButton.name + 'ForegroundStyle',
        params.keyboard.periodButton.name + 'BadgeForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.xButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.periodButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.periodButton)


  + basicStyle.newAlphabeticButton(
    params.keyboard.cButton.name,
    isDark,
    params.keyboard.cButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.hashButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.cButton.name + 'ForegroundStyle',
        params.keyboard.hashButton.name + 'BadgeForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.cButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.hashButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.hashButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.vButton.name,
    isDark,
    params.keyboard.vButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.ideographicCommaButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.vButton.name + 'ForegroundStyle',
        params.keyboard.ideographicCommaButton.name + 'BadgeForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.vButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.ideographicCommaButton),
    },
  ) + createSwipeUpHintStyle(isDark, params.keyboard.ideographicCommaButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.bButton.name,
    isDark,
    params.keyboard.bButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.questionMarkButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.bButton.name + 'ForegroundStyle',
        params.keyboard.questionMarkButton.name + 'BadgeForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.bButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.questionMarkButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.questionMarkButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.nButton.name,
    isDark,
    params.keyboard.nButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.exclamationMarkButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.nButton.name + 'ForegroundStyle',
        params.keyboard.exclamationMarkButton.name + 'BadgeForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.nButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.exclamationMarkButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.exclamationMarkButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.mButton.name,
    isDark,
    params.keyboard.mButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.ellipsisButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.mButton.name + 'ForegroundStyle',
        params.keyboard.ellipsisButton.name + 'BadgeForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.mButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.ellipsisButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.ellipsisButton)

  + basicStyle.newSystemButton(
    params.keyboard.backspaceButton.name,
    isDark,
    {
      size:
        { width: { percentage: 0.15 } },
      bounds:
        { width: '151/168.75', alignment: 'right' },
    } + params.keyboard.backspaceButton.params,
  )

  // Fourth Row

  + basicStyle.newSystemButton(
    params.keyboard.numericButton.name,
    isDark,
    {
      size:
        { width: { percentage: 0.2 } },
    }
    + params.keyboard.numericButton.params
  )


  + basicStyle.newAlphabeticButton(
    params.keyboard.commaButton.name,
    isDark,
    {
      size:
        { width: { percentage: 0.1 } },
    }
    + params.keyboard.commaButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.periodButton.name + 'SwipeUpHintForegroundStyle',
      },
    },
    needHint = false,
  ) + createSwipeUpHintStyle(isDark, params.keyboard.periodButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.spaceButton.name,
    isDark,
    params.keyboard.spaceButton.params,
    needHint=false
  )

  +
  basicStyle.newAlphabeticButton(
    params.keyboard.asciiModeButton.name,
    isDark,
    {
      size:
        { width: { percentage: 0.1 } },
    }
    + params.keyboard.asciiModeButton.params,
    needHint = false,
  )
  + { asciiModeIsTrueForegroundStyle: basicStyle.newAlphabeticButtonForegroundStyle(isDark, { assetImageName: 'englishState2' }) }
  + { asciiModeIsFalseForegroundStyle: basicStyle.newAlphabeticButtonForegroundStyle(isDark, { assetImageName: 'chineseState2' }) }


  + basicStyle.newSystemButton(
    params.keyboard.enterButton.name,
    isDark,
    {
      size:
        { width: { percentage: 0.2 } },
    } + params.keyboard.enterButton.params
  )
;

{
  new(isDark, isPortrait, addSemicolon):
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
    + newKeyLayout(isDark, isPortrait, addSemicolon)
    + basicStyle.newEnterButtonForegroundStyle(isDark, params.keyboard.enterButton.params)
    + basicStyle.newCommitCandidateForegroundStyle(isDark, { text: '选定' })
    // Notifications
    + basicStyle.returnKeyboardTypeChangedNotification
    + basicStyle.preeditChangedForEnterButtonNotification
    + basicStyle.preeditChangedForSpaceButtonNotification
    + basicStyle.asciiModeIsFalseChangedNotification
    + basicStyle.asciiModeIsTrueChangedNotification,
}
