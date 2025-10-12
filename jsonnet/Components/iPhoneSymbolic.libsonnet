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

local chineseSymbolicLeftOffset = {
  center: { x: 0.35 },
};

local chineseSymbolicRightOffset = {
  center: { x: 0.65 },
};


// 标准26键布局
local alphabeticKeyboardLayout = {
  keyboardLayout: [
    {
      HStack: {
        subviews: [
          {
            Cell: params.keyboard.leftChineseBracketButton.name,
          },
          {
            Cell: params.keyboard.rightChineseBracketButton.name,
          },
          {
            Cell: params.keyboard.leftChineseBraceButton.name,
          },
          {
            Cell: params.keyboard.rightChineseBraceButton.name,
          },
          {
            Cell: params.keyboard.hashButton.name,
          },
          {
            Cell: params.keyboard.percentButton.name,
          },
          {
            Cell: params.keyboard.caretButton.name,
          },
          {
            Cell: params.keyboard.asteriskButton.name,
          },
          {
            Cell: params.keyboard.plusButton.name,
          },
          {
            Cell: params.keyboard.hyphenButton.name,
          },
        ],
      },
    },
    {
      HStack: {
        subviews: [
          {
            Cell: params.keyboard.underscoreButton.name,
          },
          {
            Cell: params.keyboard.emDashButton.name,
          },
          {
            Cell: params.keyboard.backslashButton.name,
          },
          {
            Cell: params.keyboard.verticalBarButton.name,
          },
          {
            Cell: params.keyboard.tildeButton.name,
          },
          {
            Cell: params.keyboard.leftBookTitleMarkButton.name,
          },
          {
            Cell: params.keyboard.rightBookTitleMarkButton.name,
          },
          {
            Cell: params.keyboard.graveButton.name,
          },
          {
            Cell: params.keyboard.ampersandButton.name,
          },
          {
            Cell: params.keyboard.middleDotButton.name,
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
            Cell: params.keyboard.ellipsisButton.name,
          },
          {
            Cell: params.keyboard.commaButton.name,
          },
          {
            Cell: params.keyboard.periodButton.name,
          },
          {
            Cell: params.keyboard.questionMarkButton.name,
          },
          {
            Cell: params.keyboard.exclamationMarkButton.name,
          },
          {
            Cell: params.keyboard.leftSingleQuoteButton.name,
          },
          {
            Cell: params.keyboard.rightSingleQuoteButton.name,
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
  {
    keyboardHeight: if isPortrait then params.keyboard.height.iPhone.portrait else params.keyboard.height.iPhone.landscape,
    keyboardStyle: utils.newBackgroundStyle(style=basicStyle.keyboardBackgroundStyleName),
  }
  + alphabeticKeyboardLayout
  // First Row
  + basicStyle.newAlphabeticButton(
    params.keyboard.leftChineseBracketButton.name,
    isDark,
    portraitNormalButtonSize
    + chineseSymbolicLeftOffset
    + params.keyboard.leftChineseBracketButton.params
    + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.rightChineseBracketButton.name,
    isDark,
    portraitNormalButtonSize
    + chineseSymbolicRightOffset
    + params.keyboard.rightChineseBracketButton.params
    + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.leftChineseBraceButton.name,
    isDark,
    portraitNormalButtonSize
    + chineseSymbolicLeftOffset
    + params.keyboard.leftChineseBraceButton.params
    + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.rightChineseBraceButton.name,
    isDark,
    portraitNormalButtonSize
    + chineseSymbolicRightOffset
    + params.keyboard.rightChineseBraceButton.params
    + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.hashButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.hashButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.percentButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.percentButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.caretButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.caretButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.asteriskButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.asteriskButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.plusButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.plusButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.hyphenButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.hyphenButton.params + hintStyle
  )

  // Second Row
  + basicStyle.newAlphabeticButton(
    params.keyboard.underscoreButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.underscoreButton.params + hintStyle,
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.emDashButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.emDashButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.backslashButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.backslashButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.verticalBarButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.verticalBarButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.tildeButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.tildeButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.leftBookTitleMarkButton.name,
    isDark,
    portraitNormalButtonSize
    + chineseSymbolicLeftOffset
    + params.keyboard.leftBookTitleMarkButton.params
    + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.rightBookTitleMarkButton.name,
    isDark,
    portraitNormalButtonSize
    + chineseSymbolicRightOffset
    + params.keyboard.rightBookTitleMarkButton.params
    + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.graveButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.graveButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.ampersandButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.ampersandButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.middleDotButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.middleDotButton.params + hintStyle
  )

  // Third Row
  + basicStyle.newSystemButton(
    params.keyboard.numericButton.name,
    isDark,
    {
      size:
        { width: '168.75/1125' },
      bounds:
        { width: '151/168.75', alignment: 'left' },
    }
    + params.keyboard.numericButton.params
  )

  + basicStyle.newAlphabeticButton(
    params.keyboard.ellipsisButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.ellipsisButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.commaButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.commaButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.periodButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.periodButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.questionMarkButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.questionMarkButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.exclamationMarkButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.exclamationMarkButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.leftSingleQuoteButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.leftSingleQuoteButton.params + hintStyle
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.rightSingleQuoteButton.name,
    isDark,
    portraitNormalButtonSize + params.keyboard.rightSingleQuoteButton.params + hintStyle
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


{
  new(isDark, isPortrait):

    local insets = if isPortrait
    then
      params.keyboard.button.backgroundInsets.iPhone.portrait
    else
      params.keyboard.button.backgroundInsets.iPhone.landscape;

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
