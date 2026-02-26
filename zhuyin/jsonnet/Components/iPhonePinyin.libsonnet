local fonts = import '../Constants/Fonts.libsonnet';
local params = import '../Constants/Keyboard.libsonnet';
local basicStyle = import 'BasicStyle.libsonnet';
local preedit = import 'Preedit.libsonnet';
local toolbar = import 'Toolbar.libsonnet';
local utils = import 'Utils.libsonnet';

local portraitNormalButtonSize = {
  size: { width: '1/11' },
};

local portraitSpecialButtonSize = {
  size: { width: '1.5/11' },
};

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
    basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.params) + {
      center: { y: 0.55 },
    },
};

local createButtonUppercasedForegroundStyle(isDark, params={}) = {
  [params.name + 'UppercaseForegroundStyle']:
    basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.params) + {
      center: { y: 0.55 },
    },
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

local asciiModeNotification(params={}) = {
  notification: params.name + 'AcciiModeChangeNotification',
};

local createAsciiModeNotifcation(params={}) = {
  [params.name + 'AcciiModeChangeNotification']: {
    notificationType: 'rime',
    rimeNotificationType: 'optionChanged',
    rimeOptionName: 'ascii_mode',
    rimeOptionValue: true,
    foregroundStyle: params.forgroundStyle,
    backgroundStyle: 'alphabeticButtonBackgroundStyle',
    action: params.action,
  } + (
    if std.objectHas(params, 'bounds') then
      {
        bounds: params.bounds,
      }
    else {}
  ),
};


// 标准26键布局
local alphabeticKeyboardLayout() = {
  keyboardLayout: [
    {
      HStack: {
        subviews: [
          {
            Cell: params.keyboard.zhuyin.oneButton.name,
          },
          {
            Cell: params.keyboard.zhuyin.twoButton.name,
          },
          {
            Cell: params.keyboard.zhuyin.threeButton.name,
          },
          {
            Cell: params.keyboard.zhuyin.fourButton.name,
          },
          {
            Cell: params.keyboard.zhuyin.fiveButton.name,
          },
          {
            Cell: params.keyboard.zhuyin.sixButton.name,
          },
          {
            Cell: params.keyboard.zhuyin.sevenButton.name,
          },
          {
            Cell: params.keyboard.zhuyin.eightButton.name,
          },
          {
            Cell: params.keyboard.zhuyin.nineButton.name,
          },
          {
            Cell: params.keyboard.zhuyin.zeroButton.name,
          },
          {
            Cell: params.keyboard.zhuyin.hyphenButton.name,
          },
        ],
      },
    },
    {
      HStack: {
        subviews: [
          {
            Cell: params.keyboard.zhuyin.qButton.name,
          },
          {
            Cell: params.keyboard.zhuyin.wButton.name,
          },
          {
            Cell: params.keyboard.zhuyin.eButton.name,
          },
          {
            Cell: params.keyboard.zhuyin.rButton.name,
          },
          {
            Cell: params.keyboard.zhuyin.tButton.name,
          },
          {
            Cell: params.keyboard.zhuyin.yButton.name,
          },
          {
            Cell: params.keyboard.zhuyin.uButton.name,
          },
          {
            Cell: params.keyboard.zhuyin.iButton.name,
          },
          {
            Cell: params.keyboard.zhuyin.oButton.name,
          },
          {
            Cell: params.keyboard.zhuyin.pButton.name,
          },
        ],
      },
    },
    {
      HStack: {
        subviews: [
          {
            Cell: params.keyboard.zhuyin.aButton.name,
          },
          {
            Cell: params.keyboard.zhuyin.sButton.name,
          },
          {
            Cell: params.keyboard.zhuyin.dButton.name,
          },
          {
            Cell: params.keyboard.zhuyin.fButton.name,
          },
          {
            Cell: params.keyboard.zhuyin.gButton.name,
          },
          {
            Cell: params.keyboard.zhuyin.hButton.name,
          },
          {
            Cell: params.keyboard.zhuyin.jButton.name,
          },
          {
            Cell: params.keyboard.zhuyin.kButton.name,
          },
          {
            Cell: params.keyboard.zhuyin.lButton.name,
          },
          {
            Cell: params.keyboard.zhuyin.semicolonButton.name,
          },
        ],
      },
    },
    {
      HStack: {
        subviews: [
          {
            Cell: params.keyboard.zhuyin.zButton.name,
          },
          {
            Cell: params.keyboard.zhuyin.xButton.name,
          },
          {
            Cell: params.keyboard.zhuyin.cButton.name,
          },
          {
            Cell: params.keyboard.zhuyin.vButton.name,
          },
          {
            Cell: params.keyboard.zhuyin.bButton.name,
          },
          {
            Cell: params.keyboard.zhuyin.nButton.name,
          },
          {
            Cell: params.keyboard.zhuyin.mButton.name,
          },
          {
            Cell: params.keyboard.zhuyin.commaButton.name,
          },
          {
            Cell: params.keyboard.zhuyin.periodButton.name,
          },
          {
            Cell: params.keyboard.zhuyin.forwardSlashButton.name,
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
            Cell: params.keyboard.symbolicButton.name,
          },
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
            Cell: params.keyboard.alphabeticButton.name,
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
  + alphabeticKeyboardLayout()

  // zero Row
  + basicStyle.newAlphabeticButton(
    params.keyboard.zhuyin.oneButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.zhuyin.oneButton.params,
    needHint=false,
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.zhuyin.twoButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.zhuyin.twoButton.params,
    needHint=false,
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.zhuyin.threeButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.zhuyin.threeButton.params,
    needHint=false,
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.zhuyin.fourButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.zhuyin.fourButton.params,
    needHint=false,
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.zhuyin.fiveButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.zhuyin.fiveButton.params,
    needHint=false,
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.zhuyin.sixButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.zhuyin.sixButton.params,
    needHint=false,
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.zhuyin.sevenButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.zhuyin.sevenButton.params,
    needHint=false,
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.zhuyin.eightButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.zhuyin.eightButton.params,
    needHint=false,
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.zhuyin.nineButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.zhuyin.nineButton.params,
    needHint=false,
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.zhuyin.zeroButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.zhuyin.zeroButton.params,
    needHint=false,
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.zhuyin.hyphenButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.zhuyin.hyphenButton.params,
    needHint=false,
  )

  // First Row
  + basicStyle.newAlphabeticButton(
    params.keyboard.zhuyin.qButton.name,
    isDark,
    portraitSpecialButtonSize {
      bounds:
        { width: '2/3', alignment: 'right' },
    } + params.keyboard.zhuyin.qButton.params,
    needHint=false,
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.zhuyin.wButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.zhuyin.wButton.params,
    needHint=false,
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.zhuyin.eButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.zhuyin.eButton.params,
    needHint=false,
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.zhuyin.rButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.zhuyin.rButton.params,
    needHint=false,
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.zhuyin.tButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.zhuyin.tButton.params,
    needHint=false,
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.zhuyin.yButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.zhuyin.yButton.params,
    needHint=false,
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.zhuyin.uButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.zhuyin.uButton.params,
    needHint=false,
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.zhuyin.iButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.zhuyin.iButton.params,
    needHint=false,
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.zhuyin.oButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.zhuyin.oButton.params,
    needHint=false,
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.zhuyin.pButton.name,
    isDark,
    portraitSpecialButtonSize {
      bounds:
        { width: '2/3', alignment: 'left' },
    } + params.keyboard.zhuyin.pButton.params,
    needHint=false,
  )

  // Second Row
  + basicStyle.newAlphabeticButton(
    params.keyboard.zhuyin.aButton.name,
    isDark,
    portraitSpecialButtonSize {
      bounds:
        { width: '2/3', alignment: 'right' },
    } + params.keyboard.zhuyin.aButton.params,
    needHint=false,
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.zhuyin.sButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.zhuyin.sButton.params,
    needHint=false,
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.zhuyin.dButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.zhuyin.dButton.params,
    needHint=false,
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.zhuyin.fButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.zhuyin.fButton.params,
    needHint=false,
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.zhuyin.gButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.zhuyin.gButton.params,
    needHint=false,
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.zhuyin.hButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.zhuyin.hButton.params,
    needHint=false,
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.zhuyin.jButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.zhuyin.jButton.params,
    needHint=false,
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.zhuyin.kButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.zhuyin.kButton.params,
    needHint=false,
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.zhuyin.lButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.zhuyin.lButton.params,
    needHint=false,
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.zhuyin.semicolonButton.name,
    isDark,
    portraitSpecialButtonSize {
      bounds:
        { width: '2/3', alignment: 'left' },
    } + params.keyboard.zhuyin.semicolonButton.params,
    needHint=false,
  )

  // Third Row
  + basicStyle.newAlphabeticButton(
    params.keyboard.zhuyin.zButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.zhuyin.zButton.params,
    needHint=false,
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.zhuyin.xButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.zhuyin.xButton.params,
    needHint=false,
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.zhuyin.cButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.zhuyin.cButton.params,
    needHint=false,
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.zhuyin.vButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.zhuyin.vButton.params,
    needHint=false,
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.zhuyin.bButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.zhuyin.bButton.params,
    needHint=false,
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.zhuyin.nButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.zhuyin.nButton.params,
    needHint=false,
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.zhuyin.mButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.zhuyin.mButton.params,
    needHint=false,
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.zhuyin.commaButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.zhuyin.commaButton.params,
    needHint=false,
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.zhuyin.periodButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.zhuyin.periodButton.params,
    needHint=false,
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.zhuyin.forwardSlashButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.zhuyin.forwardSlashButton.params,
    needHint=false,
  )
  + basicStyle.newSystemButton(
    params.keyboard.backspaceButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.backspaceButton.params,
  )

  // Fourth Row
  + basicStyle.newSystemButton(
    params.keyboard.symbolicButton.name,
    isDark,
    {
      size:
        { width: { percentage: 0.125 } },
    }
    + params.keyboard.symbolicButton.params
  )
  + basicStyle.newSystemButton(
    params.keyboard.numericButton.name,
    isDark,
    {
      size:
        { width: { percentage: 0.125 } },
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
      swipeUpForegroundStyle: params.keyboard.periodButton.name + 'SwipeUpHintForegroundStyle',
    },
    needHint=false,
  ) + createSwipeUpHintStyle(isDark, params.keyboard.periodButton)
  + basicStyle.newAlphabeticButton(
    params.keyboard.spaceButton.name,
    isDark,
    params.keyboard.spaceButton.params,
    needHint=false
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.alphabeticButton.name,
    isDark,
    {
      size: {
        width: { percentage: 0.1 },
      },
    } + params.keyboard.alphabeticButton.params,
    needHint=false,
  )
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
    + basicStyle.preeditChangedForSpaceButtonNotification
    + basicStyle.asciiModeIsFalseChangedNotification
    + basicStyle.asciiModeIsTrueChangedNotification,
}
