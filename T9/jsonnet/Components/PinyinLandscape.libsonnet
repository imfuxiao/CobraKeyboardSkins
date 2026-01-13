local fonts = import '../Constants/Fonts.libsonnet';
local params = import '../Constants/Keyboard.libsonnet';
local basicStyle = import 'BasicStyle.libsonnet';
local preedit = import 'Preedit.libsonnet';
local toolbar = import 'Toolbar.libsonnet';
local utils = import 'Utils.libsonnet';


local rightBadgeLabelUpParams = {
  center: {
    x: 0.85,
    y: 0.25,
  },
  fontSize: fonts.iPhone.button.doubleLabelSmallFontSize,
};

local createRightBadgeForegroundStyle(isDark, params={}) = {
  [params.name + 'BadgeForegroundStyle']:
    basicStyle.newAlphabeticButtonSwipeForegroundStyle(isDark, params.params + rightBadgeLabelUpParams),
};

local createButtonForegroundStyle(isDark, params={}) = {
  [params.name + 'ForegroundStyle']:
    basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.params),
};

// 半宽 VStack 宽度样式
local halfVStackStyle = {
  local this = self,
  name: 'halfVStackStyle',
  style: {
    [this.name]: {
      size: {
        width: { percentage: 0.45 },
      },
    },
  },
};

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
        style: halfVStackStyle.name,
        subviews: [
          {
            VStack: {
              style: narrowVStackStyle.name,
              subviews: [
                {
                  Cell: params.keyboard.t9SymbolsCollection.name,
                },
              ],
            },
          },
          {
            VStack: {
              subviews: [
                {
                  Cell: params.keyboard.t9CandidatesCollection.name,
                },
              ],
            },
          },
        ],
      },
    },

    // 中间留白
    {
      VStack: {
      },
    },

    // 左半侧数字键盘
    {
      VStack: {
        style: halfVStackStyle.name,
        subviews: [
          {
            VStack: {
              style: narrowVStackStyle.name,
              subviews: [
                {
                  Cell: params.keyboard.t9SymbolsCollection.name,
                },
                {
                  Cell: params.keyboard.symbolicButton.name,
                },
              ],
            },
          },
          {
            VStack: {
              subviews: [
                {
                  HStack: {
                    subviews: [
                      {
                        Cell: params.keyboard.t9OneButton.name,
                      },
                      {
                        Cell: params.keyboard.t9TwoButton.name,
                      },
                      {
                        Cell: params.keyboard.t9ThreeButton.name,
                      },
                    ],
                  },
                },
                {
                  HStack: {
                    subviews: [
                      {
                        Cell: params.keyboard.t9FourButton.name,
                      },
                      {
                        Cell: params.keyboard.t9FiveButton.name,
                      },
                      {
                        Cell: params.keyboard.t9SixButton.name,
                      },
                    ],
                  },
                },
                {
                  HStack: {
                    subviews: [
                      {
                        Cell: params.keyboard.t9SevenButton.name,
                      },
                      {
                        Cell: params.keyboard.t9EightButton.name,
                      },
                      {
                        Cell: params.keyboard.t9NineButton.name,
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
                        Cell: params.keyboard.spaceButton.name,
                      },
                      {
                        Cell: params.keyboard.alphabeticButton.name,
                      },
                    ],
                  },
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
                  Cell: params.keyboard.t9RestInputButton.name,
                },
                {
                  Cell: params.keyboard.t9ZeroButton.name,
                },
                {
                  Cell: params.keyboard.enterButton.name,
                },
              ],
            },
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
    [params.keyboard.t9SymbolsCollection.name]: {

    } + params.keyboard.t9SymbolsCollection.params,
  }

  + {
    // 集合视图定义
    [params.keyboard.t9CandidatesCollection.name]: {

    } + params.keyboard.t9CandidatesCollection.params,
  }


  + basicStyle.newAlphabeticButton(
    params.keyboard.t9OneButton.name,
    isDark,
    params.keyboard.t9OneButton.params
    {
      foregroundStyleName: [
        params.keyboard.t9OneButton.name + 'ForegroundStyle',
        params.keyboard.oneButton.name + 'BadgeForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.t9OneButton {
          params: params.keyboard.t9OneButton.params {
            fontSize: fonts.t9ButtonLandscapeTextFontSize,
          },
        })
        + createRightBadgeForegroundStyle(isDark, params.keyboard.oneButton),
    },
    needHint=false
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.t9TwoButton.name,
    isDark,
    params.keyboard.t9TwoButton.params
    {
      foregroundStyleName: [
        params.keyboard.t9TwoButton.name + 'ForegroundStyle',
        params.keyboard.twoButton.name + 'BadgeForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.t9TwoButton {
          params: params.keyboard.t9TwoButton.params {
            fontSize: fonts.t9ButtonLandscapeTextFontSize,
          },
        })
        + createRightBadgeForegroundStyle(isDark, params.keyboard.twoButton),
    },
    needHint=false
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.t9ThreeButton.name,
    isDark,
    params.keyboard.t9ThreeButton.params
    {
      foregroundStyleName: [
        params.keyboard.t9ThreeButton.name + 'ForegroundStyle',
        params.keyboard.threeButton.name + 'BadgeForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.t9ThreeButton {
          params: params.keyboard.t9ThreeButton.params {
            fontSize: fonts.t9ButtonLandscapeTextFontSize,
          },
        })
        + createRightBadgeForegroundStyle(isDark, params.keyboard.threeButton),
    },
    needHint=false
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.t9FourButton.name,
    isDark,
    params.keyboard.t9FourButton.params
    {
      foregroundStyleName: [
        params.keyboard.t9FourButton.name + 'ForegroundStyle',
        params.keyboard.fourButton.name + 'BadgeForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.t9FourButton {
          params: params.keyboard.t9FourButton.params {
            fontSize: fonts.t9ButtonLandscapeTextFontSize,
          },
        })
        + createRightBadgeForegroundStyle(isDark, params.keyboard.fourButton),
    },
    needHint=false
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.t9FiveButton.name,
    isDark,
    params.keyboard.t9FiveButton.params
    {
      foregroundStyleName: [
        params.keyboard.t9FiveButton.name + 'ForegroundStyle',
        params.keyboard.fiveButton.name + 'BadgeForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.t9FiveButton {
          params: params.keyboard.t9FiveButton.params {
            fontSize: fonts.t9ButtonLandscapeTextFontSize,
          },
        })
        + createRightBadgeForegroundStyle(isDark, params.keyboard.fiveButton),
    },
    needHint=false
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.t9SixButton.name,
    isDark,
    params.keyboard.t9SixButton.params
    {
      foregroundStyleName: [
        params.keyboard.t9SixButton.name + 'ForegroundStyle',
        params.keyboard.sixButton.name + 'BadgeForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.t9SixButton {
          params: params.keyboard.t9SixButton.params {
            fontSize: fonts.t9ButtonLandscapeTextFontSize,
          },
        })
        + createRightBadgeForegroundStyle(isDark, params.keyboard.sixButton),
    },
    needHint=false
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.t9SevenButton.name,
    isDark,
    params.keyboard.t9SevenButton.params
    {
      foregroundStyleName: [
        params.keyboard.t9SevenButton.name + 'ForegroundStyle',
        params.keyboard.sevenButton.name + 'BadgeForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.t9SevenButton {
          params: params.keyboard.t9SevenButton.params {
            fontSize: fonts.t9ButtonLandscapeTextFontSize,
          },
        })
        + createRightBadgeForegroundStyle(isDark, params.keyboard.sevenButton),
    },
    needHint=false
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.t9EightButton.name,
    isDark,
    params.keyboard.t9EightButton.params
    {
      foregroundStyleName: [
        params.keyboard.t9EightButton.name + 'ForegroundStyle',
        params.keyboard.eightButton.name + 'BadgeForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.t9EightButton {
          params: params.keyboard.t9EightButton.params {
            fontSize: fonts.t9ButtonLandscapeTextFontSize,
          },
        })
        + createRightBadgeForegroundStyle(isDark, params.keyboard.eightButton),
    },
    needHint=false
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.t9NineButton.name,
    isDark,
    params.keyboard.t9NineButton.params
    {
      foregroundStyleName: [
        params.keyboard.t9NineButton.name + 'ForegroundStyle',
        params.keyboard.nineButton.name + 'BadgeForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.t9NineButton {
          params: params.keyboard.t9NineButton.params {
            fontSize: fonts.t9ButtonLandscapeTextFontSize,
          },
        })
        + createRightBadgeForegroundStyle(isDark, params.keyboard.nineButton),
    },
    needHint=false
  )

  + basicStyle.newSystemButton(
    params.keyboard.t9ZeroButton.name,
    isDark,
    params.keyboard.t9ZeroButton.params
  )

  + basicStyle.newSystemButton(
    params.keyboard.symbolicButton.name,
    isDark,
    {
      size: { height: '1/4' },
    } + params.keyboard.symbolicButton.params
  )

  + basicStyle.newSystemButton(
    params.keyboard.numericButton.name,
    isDark,
    {
      size: {
        width: { percentage: 0.2 },
      },
    } + params.keyboard.numericButton.params
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
    params.keyboard.alphabeticButton.name,
    isDark,
    {
      size: {
        width: { percentage: 0.2 },
      },
    } + params.keyboard.alphabeticButton.params,
  )

  + basicStyle.newSystemButton(
    params.keyboard.t9RestInputButton.name,
    isDark,
    params.keyboard.t9RestInputButton.params,
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
    + halfVStackStyle.style
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
