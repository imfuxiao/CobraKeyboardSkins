local Utils = import '../Components/Utils.libsonnet';
local Basic = import 'Basic.libsonnet';
local Colors = import 'Colors.libsonnet';
local Fonts = import 'Fonts.libsonnet';

{
  local root = self,

  height: 216,

  insets: {},

  backgroundStyle: {
    enable: true,
    isOriginal: true,
    normalColor: Colors.backgroundColor,
  },

  // 字母按键通用背景样式
  alphabeticButtonBackgroundStyle: {
    isOriginal: true,  // 使用原生背景色, false 则使用图片背景
    insets: { top: 6, left: 3, bottom: 6, right: 3 },
    normalColor: Colors.alphabeticButtonNormalBackgroundColor,
    highlightColor: Colors.alphabeticButtonHighlightBackgroundColor,
    cornerRadius: 6,
    normalLowerEdgeColor: Colors.lowerEdgeOfButtonNormalColor,
    highlightLowerEdgeColor: Colors.lowerEdgeOfButtonHighlightColor,
    animation: root.buttonAnimation.name,
  },

  // 蓝色按键通用背景样式
  local _blueButtonBackgroundStyle = Basic.systemButtonBackgroundStyle {
    normalColor: Colors.blueButtonNormalBackgroundColor,
  },
  local _changedBlueButtonBackgroundStyle = std.objectRemoveKey(std.objectRemoveKey(_blueButtonBackgroundStyle, 'normalLowerEdgeColor'), 'highlightLowerEdgeColor'),
  blueButtonBackgroundStyle: _changedBlueButtonBackgroundStyle,

  // 字母按键通用前景样式
  alphabeticButtonForegroundStyle:: {
    fontSize: Fonts.buttonFontSize,
    normalColor: Colors.primaryTextColor,
    highlightColor: Colors.primaryTextColor,
  },

  // 字母按键大写状态下前景样式
  alphabeticButtonUppercasedStateForegroundStyle:: root.alphabeticButtonForegroundStyle {
    fontSize: Fonts.uppercaseButtonFontSize,
  },

  // 系统按键通用前景样式
  systemButtonForegroundStyle: root.alphabeticButtonForegroundStyle {
    fontSize: Fonts.systemButtonFontSize,
  },

  // 字母按键通用徽标样式
  buttonBadgeStyle:: {
    fontSize: Fonts.buttonBadgeFontSize,
    normalColor: Colors.secondaryTextColor,
    highlightColor: Colors.secondaryTextColor,
    center: {
      y: 0.1,
    },
  },

  // 按键气泡或长按通用背景样式
  hintBackgroundStyle: {
    isOriginal: true,
    normalColor: Colors.hintBackgroundColor,
    cornerRadius: 6,
  },

  // 按键气泡或者长按通用前景样式
  hintForegroundStyle: {
    normalColor: Colors.primaryTextColor,
    fontSize: Fonts.hintFontSize,
    fontWeight: Fonts.hintFontWeight,
  },

  hintSize:: {
    size: {
      width: 40,
      height: 50,
    },
  },

  hintSymbolsInsets:: {
    insets: { top: 4, left: 4, bottom: 4, right: 4 },
  },

  // 字母键长按符号通用前景样式
  hintSymbolForegroundStyle:: {
    fontSize: Fonts.hintSymbolFontSize,
    fontWeight: Fonts.hintSymbolFontWeight,
    normalColor: Colors.primaryTextColor,
    highlightColor: Colors.primaryTextColor,
  },

  // 字母按键长按符号选中背景样式
  hintSymbolSelectedBackgroundStyle: {
    isOriginal: true,  // 使用原生背景色, false 则使用图片背景
    normalColor: Colors.hintSymbolSelectedColor,
    cornerRadius: 6,
  },

  // 按键动画
  buttonAnimation: {
    name: 'alphabeticBackgroundAnimation',
    animations: [
      {
        type: 'bounds',
        duration: 40,
        repeatCount: 1,
        fromScale: 1,
        toScale: 0.87,
      },
      {
        type: 'bounds',
        duration: 80,
        repeatCount: 1,
        fromScale: 0.87,
        toScale: 1,
      },
    ],
  },

  buttons: {
    // 按键通用样式变量
    local basicAlphabeticButtonBackgroundStyle = { backgroundStyle: 'alphabeticButtonBackgroundStyle' },
    local basicSystemButtonBackgroundStyle = { backgroundStyle: 'systemButtonBackgroundStyle' },
    local basicButtonHintBackgroundStyle = { backgroundStyle: 'hintBackgroundStyle' },
    local basicHintSymbolsStyle = root.hintSymbolsInsets + basicButtonHintBackgroundStyle,
    local basicHintSymbolsSelectedBackgroundStyle = {
      backgroundStyle: 'hintSymbolSelectedBackgroundStyle',
    },

    // 创建字母按键的通用函数
    local createButton = function(
      actions={
        action: {},
        uppercasedStateAction: {},
        preeditStateAction: {},
        repeatAction: {},
        swipeUpAction: {},
        swipeDownAction: {},
        swipeLeftAction: {},
        swipeRightAction: {},
      },
      styles={
        backgroundStyle: {},
        foregroundStyle: {},
        swipeUpForegroundStyle: {},
        swipeDownForegroundStyle: {},
        uppercasedStateForegroundStyle: {},
        capsLockedStateForegroundStyle: {},
        preeditStateForegroundStyle: {},
        hintStyle: { size: {} },
        hintSymbolsStyle: { size: {}, selectedIndex: 0, symbolsStyle: [{ action: {}, foregroundStyle: {} }] },
      },
      isSystemButton=false,
      hiddenHintStyle=false,
                        )

      local backgroundStyle = if std.objectHas(styles, 'backgroundStyle') then
        {
          backgroundStyle: styles.backgroundStyle,
        }
      else
        if isSystemButton then basicSystemButtonBackgroundStyle else basicAlphabeticButtonBackgroundStyle;


      local buttonBasicForegroundStyle = (if isSystemButton then root.systemButtonForegroundStyle else root.alphabeticButtonForegroundStyle);

      local createForegroundStyle = function(node, foregroundStyleName='foregroundStyle')
        if std.objectHas(styles, foregroundStyleName) then
          if std.type(styles[foregroundStyleName]) == 'string' then
            { [foregroundStyleName]: styles.foregroundStyle }
          else
            if foregroundStyleName == 'preeditStateForegroundStyle' then
              {

                [foregroundStyleName]: [styles[foregroundStyleName] + buttonBasicForegroundStyle],
              }
            else
              {
                [foregroundStyleName]: [styles[foregroundStyleName] + buttonBasicForegroundStyle]
                                       + (if std.objectHas(styles, 'swipeUpForegroundStyle') then
                                            [styles.swipeUpForegroundStyle + root.buttonBadgeStyle]
                                          else [])
                                       + (if std.objectHas(styles, 'swipeDownForegroundStyle') then
                                            [styles.swipeDownForegroundStyle + root.buttonBadgeStyle]
                                          else []),
              }
        else {};

      local foregroundStyle = createForegroundStyle(styles, 'foregroundStyle');

      local uppercasedStateForegroundStyle = createForegroundStyle(styles, 'uppercasedStateForegroundStyle');
      local capsLockedStateForegroundStyle = createForegroundStyle(styles, 'capsLockedStateForegroundStyle');
      local preeditStateForegroundStyle = createForegroundStyle(styles, 'preeditStateForegroundStyle');


      local hintStyle = if hiddenHintStyle then {} else
        if std.objectHas(styles, 'hintStyle') then
          local style = styles.hintStyle;

          local size = if std.objectHas(style, 'size') then
            { size: style.size }
          else
            {};

          local backgroundStyle = {
            backgroundStyle: std.get(style, 'backgroundStyle', default={}),
          };

          local foregroundStyle = {
            foregroundStyle: std.get(style, 'foregroundStyle', {}),
          };


          local hintSwipeUpForegroundStyle = {
            swipeUpForegroundStyle: std.get(style, 'swipeUpForegroundStyle', {}),
          };

          {
            hintStyle: size + backgroundStyle + foregroundStyle + hintSwipeUpForegroundStyle,
          }
        else
          local foregroundStyle = if std.objectHas(styles, 'foregroundStyle') then
            { foregroundStyle: styles.foregroundStyle + root.hintForegroundStyle }
          else
            {};

          local hintSwipeUpForegroundStyle = if std.objectHas(styles, 'swipeUpForegroundStyle') then
            { swipeUpForegroundStyle: styles.swipeUpForegroundStyle + root.hintForegroundStyle }
          else
            {};

          { hintStyle: root.hintSize + basicButtonHintBackgroundStyle + foregroundStyle + hintSwipeUpForegroundStyle };

      local hintSymbolsStyle = if std.objectHas(styles, 'hintSymbolsStyle') then
        local style = styles.hintSymbolsStyle;

        local symbolsStyle = if std.objectHas(style, 'symbolsStyle') && std.type(style.symbolsStyle) == 'array' then
          std.foldl(function(acc, symbolStyle)
            local backgroundStyle = if std.objectHas(symbolStyle, 'backgroundStyle') then
              {
                backgroundStyle: symbolStyle.backgroundStyle,
              }
            else
              basicHintSymbolsSelectedBackgroundStyle;

            acc + [
              {
                action: symbolStyle.action,
                foregroundStyle: symbolStyle.foregroundStyle + root.hintSymbolForegroundStyle,
              } + backgroundStyle,
            ]
                    , style.symbolsStyle, [])
        else
          [];

        {
          hintSymbolsStyle:
            (if std.objectHas(style, 'size') then { size: style.size } else root.hintSize)
            + (if std.objectHas(style, 'insets') then { insets: style.insets } else root.hintSymbolsInsets)
            + (if std.objectHas(style, 'selectedIndex') then { selectedIndex: style.selectedIndex } else {})
            + (if std.objectHas(style, 'backgroundStyle') then
                 { backgroundStyle: style.backgroundStyle }
               else basicHintSymbolsSelectedBackgroundStyle)
            + basicButtonHintBackgroundStyle
            + { symbolsStyle: symbolsStyle },
        }
      else
        {};


      { actions: actions }
      + backgroundStyle
      + foregroundStyle
      + uppercasedStateForegroundStyle
      + capsLockedStateForegroundStyle
      + preeditStateForegroundStyle
      + hintStyle
      + hintSymbolsStyle,

    // 按键定义
    q: createButton(actions={
      action: { character: 'q' },
      uppercasedStateAction: { character: 'Q' },
      swipeUpAction: { symbol: 1 },
    }, styles={
      foregroundStyle: { text: 'q' },
      uppercasedStateForegroundStyle: { text: 'Q' },
      swipeUpForegroundStyle: { text: '1' },
      hintSymbolsStyle: {
        selectedIndex: 0,
        symbolsStyle: [
          { action: { character: 'q' }, foregroundStyle: { text: 'q' } },
          { action: { symbol: 1 }, foregroundStyle: { text: '1' } },
          { action: { character: 'Q' }, foregroundStyle: { text: 'Q' } },
        ],
      },
    }),

    w: createButton(actions={
      action: { character: 'w' },
      uppercasedStateAction: { character: 'W' },
      swipeUpAction: { symbol: 2 },
    }, styles={
      foregroundStyle: { text: 'w' },
      uppercasedStateForegroundStyle: { text: 'W' },
      swipeUpForegroundStyle: { text: '2' },
      hintSymbolsStyle: {
        selectedIndex: 1,
        symbolsStyle: [
          { action: { character: 'w' }, foregroundStyle: { text: 'w' } },
          { action: { symbol: 2 }, foregroundStyle: { text: '2' } },
          { action: { character: 'W' }, foregroundStyle: { text: 'W' } },
        ],
      },
    }),

    e: createButton(actions={
      action: { character: 'e' },
      uppercasedStateAction: { character: 'E' },
      swipeUpAction: { symbol: 3 },
    }, styles={
      foregroundStyle: { text: 'e' },
      uppercasedStateForegroundStyle: { text: 'E' },
      swipeUpForegroundStyle: { text: '3' },
      hintSymbolsStyle: {
        selectedIndex: 1,
        symbolsStyle: [
          { action: { character: 'w' }, foregroundStyle: { text: 'w' } },
          { action: { symbol: 3 }, foregroundStyle: { text: '3' } },
          { action: { character: 'W' }, foregroundStyle: { text: 'W' } },
        ],
      },
    }),

    r: createButton(actions={
      action: { character: 'r' },
      uppercasedStateAction: { character: 'R' },
      swipeUpAction: { symbol: 4 },
    }, styles={
      foregroundStyle: { text: 'r' },
      uppercasedStateForegroundStyle: { text: 'R' },
      swipeUpForegroundStyle: { text: '4' },
      hintSymbolsStyle: {
        selectedIndex: 1,
        symbolsStyle: [
          { action: { character: 'r' }, foregroundStyle: { text: 'r' } },
          { action: { symbol: 4 }, foregroundStyle: { text: '4' } },
          { action: { character: 'R' }, foregroundStyle: { text: 'R' } },
        ],
      },
    }),

    t: createButton(actions={
      action: { character: 't' },
      uppercasedStateAction: { character: 'T' },
      swipeUpAction: { symbol: 5 },
    }, styles={
      foregroundStyle: { text: 't' },
      uppercasedStateForegroundStyle: { text: 'T' },
      swipeUpForegroundStyle: { text: '5' },
      hintSymbolsStyle: {
        selectedIndex: 1,
        symbolsStyle: [
          { action: { character: 't' }, foregroundStyle: { text: 't' } },
          { action: { symbol: 5 }, foregroundStyle: { text: '5' } },
          { action: { character: 'T' }, foregroundStyle: { text: 'T' } },
        ],
      },
    }),

    y: createButton(actions={
      action: { character: 'y' },
      uppercasedStateAction: { character: 'Y' },
      swipeUpAction: { symbol: 6 },
    }, styles={
      foregroundStyle: { text: 'y' },
      uppercasedStateForegroundStyle: { text: 'Y' },
      swipeUpForegroundStyle: { text: '6' },
      hintSymbolsStyle: {
        selectedIndex: 1,
        symbolsStyle: [
          { action: { character: 'y' }, foregroundStyle: { text: 'y' } },
          { action: { symbol: 6 }, foregroundStyle: { text: '6' } },
          { action: { character: 'Y' }, foregroundStyle: { text: 'Y' } },
        ],
      },
    }),

    u: createButton(actions={
      action: { character: 'u' },
      uppercasedStateAction: { character: 'U' },
      swipeUpAction: { symbol: 7 },
    }, styles={
      foregroundStyle: { text: 'u' },
      uppercasedStateForegroundStyle: { text: 'U' },
      swipeUpForegroundStyle: { text: '7' },
      hintSymbolsStyle: {
        selectedIndex: 1,
        symbolsStyle: [
          { action: { character: 'u' }, foregroundStyle: { text: 'u' } },
          { action: { symbol: 7 }, foregroundStyle: { text: '7' } },
          { action: { character: 'U' }, foregroundStyle: { text: 'U' } },
        ],
      },
    }),

    i: createButton(actions={
      action: { character: 'i' },
      uppercasedStateAction: { character: 'I' },
      swipeUpAction: { symbol: 8 },
    }, styles={
      foregroundStyle: { text: 'i' },
      uppercasedStateForegroundStyle: { text: 'I' },
      swipeUpForegroundStyle: { text: '8' },
      hintSymbolsStyle: {
        selectedIndex: 1,
        symbolsStyle: [
          { action: { character: 'i' }, foregroundStyle: { text: 'i' } },
          { action: { symbol: 8 }, foregroundStyle: { text: '8' } },
          { action: { character: 'I' }, foregroundStyle: { text: 'I' } },
        ],
      },
    }),

    o: createButton(actions={
      action: { character: 'o' },
      uppercasedStateAction: { character: 'O' },
      swipeUpAction: { symbol: 9 },
    }, styles={
      foregroundStyle: { text: 'o' },
      uppercasedStateForegroundStyle: { text: 'O' },
      swipeUpForegroundStyle: { text: '9' },
      hintSymbolsStyle: {
        selectedIndex: 1,
        symbolsStyle: [
          { action: { character: 'o' }, foregroundStyle: { text: 'o' } },
          { action: { symbol: 9 }, foregroundStyle: { text: '9' } },
          { action: { character: 'O' }, foregroundStyle: { text: 'O' } },
        ],
      },
    }),

    p: createButton(actions={
      action: { character: 'p' },
      uppercasedStateAction: { character: 'P' },
      swipeUpAction: { symbol: 0 },
    }, styles={
      foregroundStyle: { text: 'p' },
      uppercasedStateForegroundStyle: { text: 'P' },
      swipeUpForegroundStyle: { text: '0' },
      hintSymbolsStyle: {
        selectedIndex: 2,
        symbolsStyle: [
          { action: { character: 'p' }, foregroundStyle: { text: 'p' } },
          { action: { symbol: 0 }, foregroundStyle: { text: '0' } },
          { action: { character: 'P' }, foregroundStyle: { text: 'P' } },
        ],
      },
    }),

    a: createButton(actions={
      action: { character: 'a' },
      uppercasedStateAction: { character: 'A' },
    }, styles={
      foregroundStyle: { text: 'a' },
      uppercasedStateForegroundStyle: { text: 'A' },
    }),

    s: createButton(actions={
      action: { character: 's' },
      uppercasedStateAction: { character: 'S' },
    }, styles={
      foregroundStyle: { text: 's' },
      uppercasedStateForegroundStyle: { text: 'S' },
    }),

    d: createButton(actions={
      action: { character: 'd' },
      uppercasedStateAction: { character: 'D' },
    }, styles={
      foregroundStyle: { text: 'd' },
      uppercasedStateForegroundStyle: { text: 'D' },
    }),

    f: createButton(actions={
      action: { character: 'f' },
      uppercasedStateAction: { character: 'F' },
    }, styles={
      foregroundStyle: { text: 'f' },
      uppercasedStateForegroundStyle: { text: 'F' },
    }),

    g: createButton(actions={
      action: { character: 'g' },
      uppercasedStateAction: { character: 'G' },
    }, styles={
      foregroundStyle: { text: 'g' },
      uppercasedStateForegroundStyle: { text: 'G' },
    }),

    h: createButton(actions={
      action: { character: 'h' },
      uppercasedStateAction: { character: 'H' },
    }, styles={
      foregroundStyle: { text: 'h' },
      uppercasedStateForegroundStyle: { text: 'H' },
    }),

    j: createButton(actions={
      action: { character: 'j' },
      uppercasedStateAction: { character: 'J' },
    }, styles={
      foregroundStyle: { text: 'j' },
      uppercasedStateForegroundStyle: { text: 'J' },
    }),

    k: createButton(actions={
      action: { character: 'k' },
      uppercasedStateAction: { character: 'K' },
    }, styles={
      foregroundStyle: { text: 'k' },
      uppercasedStateForegroundStyle: { text: 'K' },
    }),

    l: createButton(actions={
      action: { character: 'l' },
      uppercasedStateAction: { character: 'L' },
    }, styles={
      foregroundStyle: { text: 'l' },
      uppercasedStateForegroundStyle: { text: 'L' },
    }),

    z: createButton(actions={
      action: { character: 'z' },
      uppercasedStateAction: { character: 'Z' },
    }, styles={
      foregroundStyle: { text: 'z' },
      uppercasedStateForegroundStyle: { text: 'Z' },
    }),

    x: createButton(actions={
      action: { character: 'x' },
      uppercasedStateAction: { character: 'X' },
    }, styles={
      foregroundStyle: { text: 'x' },
      uppercasedStateForegroundStyle: { text: 'X' },
    }),

    c: createButton(actions={
      action: { character: 'c' },
      uppercasedStateAction: { character: 'C' },
    }, styles={
      foregroundStyle: { text: 'c' },
      uppercasedStateForegroundStyle: { text: 'C' },
    }),

    v: createButton(actions={
      action: { character: 'v' },
      uppercasedStateAction: { character: 'V' },
    }, styles={
      foregroundStyle: { text: 'v' },
      uppercasedStateForegroundStyle: { text: 'V' },
    }),

    b: createButton(actions={
      action: { character: 'b' },
      uppercasedStateAction: { character: 'B' },
    }, styles={
      foregroundStyle: { text: 'b' },
      uppercasedStateForegroundStyle: { text: 'B' },
    }),

    n: createButton(actions={
      action: { character: 'n' },
      uppercasedStateAction: { character: 'N' },
    }, styles={
      foregroundStyle: { text: 'n' },
      uppercasedStateForegroundStyle: { text: 'N' },
    }),

    m: createButton(actions={
      action: { character: 'm' },
      uppercasedStateAction: { character: 'M' },
    }, styles={
      foregroundStyle: { text: 'm' },
      uppercasedStateForegroundStyle: { text: 'M' },
    }),

    '1': createButton(actions={
      action: { character: '1' },
    }, styles={
      foregroundStyle: { text: '1' },
    }),

    '2': createButton(actions={
      action: { character: '2' },
    }, styles={
      foregroundStyle: { text: '2' },
    }),

    '3': createButton(actions={
      action: { character: '3' },
    }, styles={
      foregroundStyle: { text: '3' },
    }),

    '4': createButton(actions={
      action: { character: '4' },
    }, styles={
      foregroundStyle: { text: '4' },
    }),

    '5': createButton(actions={
      action: { character: '5' },
    }, styles={
      foregroundStyle: { text: '5' },
    }),

    '6': createButton(actions={
      action: { character: '6' },
    }, styles={
      foregroundStyle: { text: '6' },
    }),

    '7': createButton(actions={
      action: { character: '7' },
    }, styles={
      foregroundStyle: { text: '7' },
    }),

    '8': createButton(actions={
      action: { character: '8' },
    }, styles={
      foregroundStyle: { text: '8' },
    }),

    '9': createButton(actions={
      action: { character: '9' },
    }, styles={
      foregroundStyle: { text: '9' },
    }),

    '0': createButton(actions={
      action: { character: '0' },
    }, styles={
      foregroundStyle: { text: '0' },
    }),

    shift: createButton(actions={
      action: 'shift',
    }, styles={
      foregroundStyle: { systemImageName: 'shift' },
      uppercasedStateForegroundStyle: { systemImageName: 'shift.fill' },
      capsLockedStateForegroundStyle: { systemImageName: 'capslock.fill' },
    }, isSystemButton=true, hiddenHintStyle=true),

    backspace: createButton(actions={
      action: 'backspace',
    }, styles={
      foregroundStyle: { systemImageName: 'delete.left' },
    }, isSystemButton=true, hiddenHintStyle=true),

    space: createButton(actions={
      action: 'space',
      swipeUpAction: { shortcutCommand: '#次选上屏' },
    }, styles={
      foregroundStyle: { systemImageName: 'space' },
    }),

    local enterBackgroundStyle = |||
      // JavaScript
      function getText() {
        let type = $getReturnKeyType();
        if (type === 1 || type === 4 || type === 7) {
          return "blueSystemButtonBackgroundStyle";
        }
        return "systemButtonBackgroundStyle";
      }
    |||,
    local enterForegroundStyle = |||
      // JavaScript
      function getText() {
        let type = $getReturnKeyType();
        if (type === 1 || type === 4 || type === 7) {
          return "enterButtonWhiteForegroundStyle";
        }
        return "enterButtonBlackForegroundStyle";
      }
    |||,
    enter: createButton(actions={
      action: 'enter',
    }, styles={
      backgroundStyle: enterBackgroundStyle,
      foregroundStyle: enterForegroundStyle,
    }, isSystemButton=true, hiddenHintStyle=true),

    // Emoji键盘切换键
    emojis: createButton(actions={
      action: { keyboardType: 'emojis' },
    }, styles={
      foregroundStyle: { systemImageName: 'face.smiling' },
    }, isSystemButton=true, hiddenHintStyle=true),

    // 数字键盘切换键
    numeric: createButton(actions={
      action: { keyboardType: 'numeric' },
    }, styles={
      foregroundStyle: { text: '123' },
    }, isSystemButton=true, hiddenHintStyle=true),

    // 符号键盘切换键
    symbolic: createButton(actions={
      action: { keyboardType: 'symbolic' },
    }, styles={
      foregroundStyle: { text: '#+=' },
    }, isSystemButton=true, hiddenHintStyle=true),

    // 英文键盘切换键
    alphabetic: createButton(actions={
      action: { keyboardType: 'alphabetic' },
    }, styles={
      foregroundStyle: { text: 'ABC' },
    }, isSystemButton=true, hiddenHintStyle=true),

    // 中文键盘切换键
    pinyin: createButton(actions={
      action: { keyboardType: 'pinyin' },
    }, styles={
      foregroundStyle: { text: '中文' },
    }, isSystemButton=true, hiddenHintStyle=true),
  },
} + Basic
