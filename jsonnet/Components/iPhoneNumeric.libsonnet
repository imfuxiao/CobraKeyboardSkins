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
            Cell: params.keyboard.hyphenButton.name,
          },
          {
            Cell: params.keyboard.forwardSlashButton.name,
          },
          {
            Cell: params.keyboard.chineseColonButton.name,
          },
          {
            Cell: params.keyboard.chineseSemicolonButton.name,
          },
          {
            Cell: params.keyboard.leftParenthesisButton.name,
          },
          {
            Cell: params.keyboard.rightParenthesisButton.name,
          },
          {
            Cell: params.keyboard.dollarButton.name,
          },
          {
            Cell: params.keyboard.atButton.name,
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
            Cell: params.keyboard.hashButton.name,
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
  // First Row
  + basicStyle.newAlphabeticButton(
    params.keyboard.oneButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.oneButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.twoButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.twoButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.threeButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.threeButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.fourButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.fourButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.fiveButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.fiveButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.sixButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.sixButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.sevenButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.sevenButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.eightButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.eightButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.nineButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.nineButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.zeroButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.zeroButton.params + hintStyle
  )

  // Second Row
  + basicStyle.newAlphabeticButton(
    params.keyboard.hyphenButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.hyphenButton.params + hintStyle,
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.forwardSlashButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.forwardSlashButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.chineseColonButton.name,
    isDark,
    portraitNormalButtonSize
    + chineseSymbolicOffset
    + params.keyboard.chineseColonButton.params
    + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.chineseSemicolonButton.name,
    isDark,
    portraitNormalButtonSize
    + chineseSymbolicOffset
    + params.keyboard.chineseSemicolonButton.params
    + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.leftParenthesisButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.leftParenthesisButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.rightParenthesisButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.rightParenthesisButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.dollarButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.dollarButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.atButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.atButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.leftCurlyQuoteButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.leftCurlyQuoteButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.rightCurlyQuoteButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.rightCurlyQuoteButton.params + hintStyle
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
    params.keyboard.hashButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.hashButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.ideographicCommaButton.name,
    isDark,
    portraitNormalButtonSize
    + chineseSymbolicOffset
    + params.keyboard.ideographicCommaButton.params
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
    params.keyboard.chinesePeriodButton.name,
    isDark,
    portraitNormalButtonSize
    + chineseSymbolicOffset
    + params.keyboard.chinesePeriodButton.params
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
