local params = import '../Constants/Keyboard.libsonnet';
local basicStyle = import 'BasicStyle.libsonnet';
local preedit = import 'Preedit.libsonnet';
local toolbar = import 'Toolbar.libsonnet';
local utils = import 'Utils.libsonnet';

local portraitNormalButtonSize = {
  size: { width: '112.5/1125' },
};

local hintStyle = {
  hintStyle: {
    size: { width: 50, height: 50 },
  },
};

local chineseSymbolicOffset = {
  center: { x: 0.65 },
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
            Cell: params.keyboard.exclamationMarkButton.name,
          },
          {
            Cell: params.keyboard.atButton.name,
          },
          {
            Cell: params.keyboard.hashButton.name,
          },
          {
            Cell: params.keyboard.dollarButton.name,
          },
          {
            Cell: params.keyboard.percentButton.name,
          },
          {
            Cell: params.keyboard.caretButton.name,
          },
          {
            Cell: params.keyboard.ampersandButton.name,
          },
          {
            Cell: params.keyboard.asteriskButton.name,
          },
          {
            Cell: params.keyboard.leftParenthesisButton.name,
          },
          {
            Cell: params.keyboard.rightParenthesisButton.name,
          },
        ],
      },
    },
    {
      HStack: {
        subviews: [
          {
            Cell: params.keyboard.hyphenButton.name,
          },
          {
            Cell: params.keyboard.plusButton.name,
          },
          {
            Cell: params.keyboard.equalButton.name,
          },
          {
            Cell: params.keyboard.backslashButton.name,
          },
          {
            Cell: params.keyboard.colonButton.name,
          },
          {
            Cell: params.keyboard.semicolonButton.name,
          },
          {
            Cell: params.keyboard.leftBracketButton.name,
          },
          {
            Cell: params.keyboard.leftBraceButton.name,
          },
          {
            Cell: params.keyboard.leftCurlyQuoteButton.name,
          },
          {
            Cell: params.keyboard.rightCurlyQuoteButton.name,
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
            Cell: params.keyboard.chinesePeriodButton.name,
          },
          {
            Cell: params.keyboard.chineseCommaButton.name,
          },
          {
            Cell: params.keyboard.ideographicCommaButton.name,
          },
          {
            Cell: params.keyboard.verticalBarButton.name,
          },
          {
            Cell: params.keyboard.chineseQuestionMarkButton.name,
          },
          {
            Cell: params.keyboard.chineseExclamationMarkButton.name,
          },
          {
            Cell: params.keyboard.periodButton.name,
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
            Cell: params.keyboard.pinyinButton.name,
          },
          {
            Cell: params.keyboard.spaceButton.name,
          },
          {
            Cell: params.keyboard.enterButton.name,
          },
        ],
      },
    },
  ],
};


local newKeyLayout(isDark=false, isPortrait=false) =

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
    params.keyboard.oneButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.twoButton.name,
    isDark,
    params.keyboard.twoButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.threeButton.name,
    isDark,
    params.keyboard.threeButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.fourButton.name,
    isDark,
    params.keyboard.fourButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.fiveButton.name,
    isDark,
    params.keyboard.fiveButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.sixButton.name,
    isDark,
    params.keyboard.sixButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.sevenButton.name,
    isDark,
    params.keyboard.sevenButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.eightButton.name,
    isDark,
    params.keyboard.eightButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.nineButton.name,
    isDark,
    params.keyboard.nineButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.zeroButton.name,
    isDark,
    params.keyboard.zeroButton.params + hintStyle
  )

  // First Row

  + basicStyle.newAlphabeticButton(
    params.keyboard.exclamationMarkButton.name,
    isDark,
    params.keyboard.exclamationMarkButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.atButton.name,
    isDark,
    params.keyboard.atButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.hashButton.name,
    isDark,
    params.keyboard.hashButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.dollarButton.name,
    isDark,
    params.keyboard.dollarButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.percentButton.name,
    isDark,
    params.keyboard.percentButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.caretButton.name,
    isDark,
    params.keyboard.caretButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.ampersandButton.name,
    isDark,
    params.keyboard.ampersandButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.asteriskButton.name,
    isDark,
    params.keyboard.asteriskButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.leftParenthesisButton.name,
    isDark,
    params.keyboard.leftParenthesisButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.rightParenthesisButton.name,
    isDark,
    params.keyboard.rightParenthesisButton.params + hintStyle
  )

  // Second Row

  + basicStyle.newAlphabeticButton(
    params.keyboard.hyphenButton.name,
    isDark,
    params.keyboard.hyphenButton.params + hintStyle,
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.plusButton.name,
    isDark,
    params.keyboard.plusButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.equalButton.name,
    isDark,
    params.keyboard.equalButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.backslashButton.name,
    isDark,
    params.keyboard.backslashButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.colonButton.name,
    isDark,
    params.keyboard.colonButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.semicolonButton.name,
    isDark,
    params.keyboard.semicolonButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.leftBracketButton.name,
    isDark,
    params.keyboard.leftBracketButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.leftBraceButton.name,
    isDark,
    params.keyboard.leftBraceButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.leftCurlyQuoteButton.name,
    isDark,
    params.keyboard.leftCurlyQuoteButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.rightCurlyQuoteButton.name,
    isDark,
    params.keyboard.rightCurlyQuoteButton.params + hintStyle
  )

  // Third Row
  + basicStyle.newSystemButton(
    params.keyboard.symbolicButton.name,
    isDark,
    {
      size:
        { width: '168.75/1125' },
      bounds:
        { width: '151/168.75', alignment: 'left' },
    }
    + params.keyboard.symbolicButton.params
  )

  + basicStyle.newAlphabeticButton(
    params.keyboard.chinesePeriodButton.name,
    isDark,
    portraitNormalButtonSize
    + chineseSymbolicOffset
    + params.keyboard.chinesePeriodButton.params
    + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.chineseCommaButton.name,
    isDark,
    portraitNormalButtonSize
    + chineseSymbolicOffset
    + params.keyboard.chineseCommaButton.params
    + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.ideographicCommaButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.ideographicCommaButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.verticalBarButton.name,
    isDark,
    portraitNormalButtonSize
    + chineseSymbolicOffset
    + params.keyboard.verticalBarButton.params
    + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.chineseQuestionMarkButton.name,
    isDark,
    portraitNormalButtonSize
    + chineseSymbolicOffset
    + params.keyboard.chineseQuestionMarkButton.params
    + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.chineseExclamationMarkButton.name,
    isDark,
    portraitNormalButtonSize
    + chineseSymbolicOffset
    + params.keyboard.chineseExclamationMarkButton.params
    + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.periodButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.periodButton.params + hintStyle
  )
  + basicStyle.newSystemButton(
    params.keyboard.backspaceButton.name,
    isDark,
    {
      size:
        { width: '168.75/1125' },
      bounds:
        { width: '151/168.75', alignment: 'right' },
    } + params.keyboard.backspaceButton.params,
  )

  // Fourth Row
  + basicStyle.newSystemButton(
    params.keyboard.pinyinButton.name,
    isDark,
    {
      size:
        { width: '280/1125' },
    } + params.keyboard.pinyinButton.params
  )

  + basicStyle.newAlphabeticButton(
    params.keyboard.spaceButton.name,
    isDark,
    params.keyboard.spaceButton.params,
    needHint=false
  )

  + basicStyle.newSystemButton(
    params.keyboard.enterButton.name,
    isDark,
    {
      size: { width: '280/1125' },
      backgroundStyle: basicStyle.enterButtonBackgroundStyle,
      foregroundStyle: basicStyle.enterButtonForegroundStyle,
    } + params.keyboard.enterButton.params
  );

local extraParams = {
  insets: params.keyboard.button.backgroundInsets.iPhone.landscape,
};

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
