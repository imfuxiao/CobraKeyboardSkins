local params = import '../Constants/Keyboard.libsonnet';
local basicStyle = import 'BasicStyle.libsonnet';
local preedit = import 'Preedit.libsonnet';
local toolbar = import 'Toolbar.libsonnet';
local utils = import 'Utils.libsonnet';


// 窄 VStack 宽度样式
local narrowVStackStyle = {
  local this = self,
  name: 'narrowVStackStyle',
  style: {
    [this.name]: {
      size: {
        width: { percentage: 0.17 },
      },
    },
  },
};

// 宽 VStack 宽度样式
local wideVStackStyle = {
  local this = self,
  name: 'wideVStackStyle',
  style: {
    [this.name]: {
      size: {
        width: { percentage: 0.22 },
      },
    },
  },
};

// 9 键布局
local alphabeticKeyboardLayout = {
  keyboardLayout: [
    {
      VStack: {
        style: narrowVStackStyle.name,
        subviews: [
          {
            Cell: params.keyboard.numericSymbolsCollection.name,
          },
          {
            Cell: params.keyboard.symbolicButton.name,
          },
        ],
      },
    },
    {
      VStack: {
        style: wideVStackStyle.name,
        subviews: [
          {
            Cell: params.keyboard.symbolsNumber.oneButton.name,
          },
          {
            Cell: params.keyboard.symbolsNumber.fourButton.name,
          },
          {
            Cell: params.keyboard.symbolsNumber.sevenButton.name,
          },
          {
            Cell: params.keyboard.returnLastKeyboardButton.name,
          },
        ],
      },
    },
    {
      VStack: {
        style: wideVStackStyle.name,
        subviews: [
          {
            Cell: params.keyboard.symbolsNumber.twoButton.name,
          },
          {
            Cell: params.keyboard.symbolsNumber.fiveButton.name,
          },
          {
            Cell: params.keyboard.symbolsNumber.eightButton.name,
          },
          {
            Cell: params.keyboard.symbolsNumber.zeroButton.name,
          },
        ],
      },
    },
    {
      VStack: {
        style: wideVStackStyle.name,
        subviews: [
          {
            Cell: params.keyboard.symbolsNumber.threeButton.name,
          },
          {
            Cell: params.keyboard.symbolsNumber.sixButton.name,
          },
          {
            Cell: params.keyboard.symbolsNumber.nineButton.name,
          },
          {
            Cell: params.keyboard.spaceButton.name,
          },
        ],
      },
    },
    {
      VStack: {
        style: narrowVStackStyle.name,
        subviews: [
          {
            Cell: params.keyboard.backspaceButton.name,
          },
          {
            Cell: params.keyboard.periodButton.name,
          },
          {
            Cell: params.keyboard.equalButton.name,
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

  + {
    // 集合视图定义
    [params.keyboard.numericSymbolsCollection.name]: {

    } + params.keyboard.numericSymbolsCollection.params,
  }

  + basicStyle.newAlphabeticButton(
    params.keyboard.symbolsNumber.oneButton.name,
    isDark,
    params.keyboard.symbolsNumber.oneButton.params,
    needHint=false
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.symbolsNumber.twoButton.name,
    isDark,
    params.keyboard.symbolsNumber.twoButton.params,
    needHint=false
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.symbolsNumber.threeButton.name,
    isDark,
    params.keyboard.symbolsNumber.threeButton.params,
    needHint=false
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.symbolsNumber.fourButton.name,
    isDark,
    params.keyboard.symbolsNumber.fourButton.params,
    needHint=false
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.symbolsNumber.fiveButton.name,
    isDark,
    params.keyboard.symbolsNumber.fiveButton.params,
    needHint=false
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.symbolsNumber.sixButton.name,
    isDark,
    params.keyboard.symbolsNumber.sixButton.params,
    needHint=false
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.symbolsNumber.sevenButton.name,
    isDark,
    params.keyboard.symbolsNumber.sevenButton.params,
    needHint=false
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.symbolsNumber.eightButton.name,
    isDark,
    params.keyboard.symbolsNumber.eightButton.params,
    needHint=false
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.symbolsNumber.nineButton.name,
    isDark,
    params.keyboard.symbolsNumber.nineButton.params,
    needHint=false
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.symbolsNumber.zeroButton.name,
    isDark,
    params.keyboard.symbolsNumber.zeroButton.params,
    needHint=false
  )

  + basicStyle.newSystemButton(
    params.keyboard.symbolicButton.name,
    isDark,
    {
      size: { height: '1/4' },
    } + params.keyboard.symbolicButton.params
  )

  + basicStyle.newSystemButton(
    params.keyboard.returnLastKeyboardButton.name,
    isDark,
    params.keyboard.returnLastKeyboardButton.params
  )

  + basicStyle.newSystemButton(
    params.keyboard.spaceButton.name,
    isDark,
    params.keyboard.spaceButton.params
  )

  + basicStyle.newSystemButton(
    params.keyboard.backspaceButton.name,
    isDark,
    params.keyboard.backspaceButton.params,
  )

  + basicStyle.newSystemButton(
    params.keyboard.periodButton.name,
    isDark,
    params.keyboard.periodButton.params {
      action: { symbol: '.' },
    },
  )

  + basicStyle.newSystemButton(
    params.keyboard.equalButton.name,
    isDark,
    params.keyboard.equalButton.params,
  )

  + basicStyle.newSystemButton(
    params.keyboard.enterButton.name,
    isDark,
    {
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
    + narrowVStackStyle.style
    + wideVStackStyle.style
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
