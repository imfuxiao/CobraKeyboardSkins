// 按键构造：字母键 / 系统键的背景、前景、长按气泡、通知样式。
// 沿用重构前 BasicStyle.libsonnet 的 isDark 参数模型，只搬了文件位置、
// 换了 Constants 的引用来源（Constants/Keys.libsonnet + Constants/Metrics.libsonnet）。
local colors = import '../Constants/Colors.libsonnet';
local fonts = import '../Constants/Fonts.libsonnet';
local Metrics = import '../Constants/Metrics.libsonnet';
local utils = import 'Utils.libsonnet';

local buttonCornerRadius = 8.5;

local getKeyboardActionText(params={}, key='action', isUppercase=false) =
  {} + (
    if std.objectHas(params, 'text') then
      { text: params.text }
    else if std.objectHas(params, key) then
      local action = params[key];
      if std.type(action) == 'object' then
        if std.objectHas(action, 'character') then
          local text = if isUppercase then std.asciiUpper(action.character) else action.character;
          { text: text }
        else if std.objectHas(action, 'symbol') then
          local text = if isUppercase then std.asciiUpper(action.symbol) else action.symbol;
          { text: text }
        else
          {}
      else
        {}
    else
      {}
  );

// 通用键盘背景样式
local keyboardBackgroundStyleName = 'keyboardBackgroundStyle';
local newKeyboardBackgroundStyle(isDark=false, params={}) = {
  [keyboardBackgroundStyleName]: utils.newGeometryStyle({
    normalColor: colors.keyboardBackgroundColor,
  } + params, isDark),
};

// 字母键按钮背景样式
local alphabeticButtonBackgroundStyleName = 'alphabeticButtonBackgroundStyle';
local newAlphabeticButtonBackgroundStyle(isDark=false, params={}) = {
  [alphabeticButtonBackgroundStyleName]: utils.newGeometryStyle({
    insets: Metrics.keyInsets.iPhone.portrait,
    normalColor: colors.standardButtonBackgroundColor,
    highlightColor: colors.standardButtonHighlightedBackgroundColor,
    cornerRadius: buttonCornerRadius,
    normalLowerEdgeColor: colors.lowerEdgeOfButtonNormalColor,
    highlightLowerEdgeColor: colors.lowerEdgeOfButtonHighlightColor,
  } + params, isDark),
};

// 字母键按钮前景样式
local newAlphabeticButtonForegroundStyle(isDark=false, params={}) =
  if std.objectHas(params, 'systemImageName') then
    utils.newSystemImageStyle({
      normalColor: colors.standardButtonForegroundColor,
      highlightColor: colors.standardButtonHighlightedForegroundColor,
      fontSize: fonts.standardButtonImageFontSize,
    } + params, isDark)
  else if std.objectHas(params, 'assetImageName') then
    utils.newAssetImageStyle({
      normalColor: colors.standardButtonForegroundColor,
      highlightColor: colors.standardButtonHighlightedForegroundColor,
      fontSize: fonts.standardButtonImageFontSize,
    } + params, isDark)
  else
    utils.newTextStyle({
      normalColor: colors.standardButtonForegroundColor,
      highlightColor: colors.standardButtonHighlightedForegroundColor,
      fontSize: fonts.standardButtonTextFontSize,
    } + params, isDark) + getKeyboardActionText(params);

// swipe-up 徽标前景样式（键面上角的小字/小图标）
local newAlphabeticButtonSwipeForegroundStyle(isDark=false, params={}) =
  if std.objectHas(params, 'systemImageName') then
    utils.newSystemImageStyle({
      normalColor: colors.labelColor.secondary,
      highlightColor: colors.labelColor.secondary,
      fontSize: fonts.standardButtonImageFontSize,
    } + params, isDark)
  else
    utils.newTextStyle({
      normalColor: colors.labelColor.secondary,
      highlightColor: colors.labelColor.secondary,
      fontSize: fonts.standardButtonTextFontSize,
    } + params, isDark) + getKeyboardActionText(params);

// 大写字母键按钮前景样式
local newAlphabeticButtonUppercaseForegroundStyle(isDark=false, params={}) =
  utils.newTextStyle({
    normalColor: colors.standardButtonForegroundColor,
    highlightColor: colors.standardButtonHighlightedForegroundColor,
    fontSize: fonts.standardButtonUppercasedTextFontSize,
  } + params, isDark);

// 长按气泡背景样式
local alphabeticHintBackgroundStyleName = 'alphabeticHintBackgroundStyle';
local newAlphabeticHintBackgroundStyle(isDark=false, params={}) = {
  [alphabeticHintBackgroundStyleName]: utils.newGeometryStyle({
    normalColor: colors.standardCalloutBackgroundColor,
    normalBorderColor: colors.standardCalloutBorderColor,
    borderSize: 0.5,
  } + params, isDark),
};

// 长按气泡前景样式
local newAlphabeticButtonHintStyle(isDark=false, params={}) =
  utils.newTextStyle({
    normalColor: colors.standardCalloutForegroundColor,
    fontSize: fonts.hintTextFontSize,
  } + params, isDark);

// ===== 长按符号网格 =====
// 长按一颗键，键的上方弹出一行备选字符，手指左右滑动选、抬手上屏。
// 引擎的读法见 KeyboardUI/.../TouchView+HintSymbolsGrid.swift：
//   按键节点的 hintSymbolsGridStyle 指向一份网格样式，
//   网格样式的 symbolRows 是一张**样式名**表（不是字符表），
//   表里每个名字都得是一颗完整的按键样式节点——上屏什么由它自己的 action 说了算。

// 面板底板与长按气泡同色同边框，两者是同一类浮层
local hintGridBackgroundStyleName = 'hintGridBackgroundStyle';
// 高亮格的底：引擎创建这一层时固定传 isActive: true，所以只有 highlightColor 生效，
// normalColor 写同一个色是为了这份样式单独拿去渲染时也不至于变透明。
local hintGridSelectedBackgroundStyleName = 'hintGridSelectedBackgroundStyle';
local newHintGridBackgroundStyles(isDark=false) = {
  [hintGridBackgroundStyleName]: utils.newGeometryStyle({
    normalColor: colors.standardCalloutBackgroundColor,
    normalBorderColor: colors.standardCalloutBorderColor,
    highlightBorderColor: colors.standardCalloutBorderColor,
    borderSize: Metrics.hintGrid.borderSize,
    cornerRadius: Metrics.hintGrid.cornerRadius,
  }, isDark),
  [hintGridSelectedBackgroundStyleName]: utils.newGeometryStyle({
    normalColor: colors.standardCalloutSelectedBackgroundColor,
    highlightColor: colors.standardCalloutSelectedBackgroundColor,
    cornerRadius: Metrics.hintGrid.cellCornerRadius,
  }, isDark),
};

// 默认高亮格：面板比键宽得多，贴着屏幕边的键，面板会被引擎推回屏内
// （TouchView+HintSymbolsGrid 里那两段 bounds 夹取），此时若仍默认选中间那格，
// 高亮就落到手指外面去了。所以越靠左的键越往左选、越靠右的键越往右选：
//
//   anchor（键中心占键盘宽的比例）   选哪一格
//   < 0.175                       最左格
//   < 0.275                       次左格
//   其余                           正中间那格
//   > 0.725                       次右格
//   > 0.825                       最右格
//
// 阈值取在相邻两颗键中心的正中间（第一行十键的中心是 0.05、0.15、0.25……），
// 不会踩到浮点数相等的边界。
local anchorCol(anchor, count) =
  if count <= 1 then 0
  else if anchor < 0.175 then 0
  else if anchor < 0.275 then 1
  else if anchor > 0.825 then count - 1
  else if anchor > 0.725 then std.max(0, count - 2)
  else std.floor((count - 1) / 2);

// 只铺一行。单元格不给 backgroundStyle：面板已经是一整块底，格子再铺一层反而糊；
// 高亮时引擎会把 selectedBackgroundStyle 插进这一层里，盖在字的下面。
local newHintSymbolsGrid(name, isDark, symbols, anchor) =
  local last = std.length(symbols) - 1;
  local cellName(i) = name + 'GridCell' + i;
  {
    [name + 'Grid']: {
      size: Metrics.hintGrid.cell,
      spacing: Metrics.hintGrid.spacing,
      insets: Metrics.hintGrid.insets,
      offset: Metrics.hintGrid.offset,
      moveThreshold: Metrics.hintGrid.moveThreshold,
      backgroundStyle: hintGridBackgroundStyleName,
      selectedBackgroundStyle: hintGridSelectedBackgroundStyleName,
      selected: { row: 0, col: anchorCol(anchor, last + 1) },
      symbolRows: [[cellName(i) for i in std.range(0, last)]],
    },
  } + {
    [cellName(i)]: {
      foregroundStyle: cellName(i) + 'Label',
      action: { character: symbols[i] },
    }
    for i in std.range(0, last)
  } + {
    [cellName(i) + 'Label']: utils.newTextStyle({
      text: symbols[i],
      fontSize: fonts.hintGridTextFontSize,
      normalColor: colors.standardCalloutForegroundColor,
      highlightColor: colors.standardCalloutHighlightedForegroundColor,
    }, isDark)
    for i in std.range(0, last)
  };

// 系统功能键按钮背景样式
local systemButtonBackgroundStyleName = 'systemButtonBackgroundStyle';
local newSystemButtonBackgroundStyle(isDark=false, params={}) = {
  [systemButtonBackgroundStyleName]: utils.newGeometryStyle({
    insets: Metrics.keyInsets.iPhone.portrait,
    normalColor: colors.systemButtonBackgroundColor,
    highlightColor: colors.systemButtonHighlightedBackgroundColor,
    cornerRadius: buttonCornerRadius,
    normalLowerEdgeColor: colors.lowerEdgeOfButtonNormalColor,
    highlightLowerEdgeColor: colors.lowerEdgeOfButtonHighlightColor,
  } + params, isDark),
};

local enterButtonForegroundStyleName = 'enterButtonForegroundStyle';
local newEnterButtonForegroundStyle(isDark=false, params={}) = {
  [enterButtonForegroundStyleName]: utils.newTextStyle({
    normalColor: colors.systemButtonForegroundColor,
    highlightColor: colors.systemButtonHighlightedForegroundColor,
    fontSize: fonts.systemButtonTextFontSize,
  } + params, isDark) + getKeyboardActionText(params),
};

// 蓝色功能键按钮背景样式（回车键在 send/go/done 这类 returnKeyType 下换的底色）
local blueButtonBackgroundStyleName = 'blueButtonBackgroundStyle';
local newBlueButtonBackgroundStyle(isDark=false, params={}) = {
  [blueButtonBackgroundStyleName]: utils.newGeometryStyle({
    insets: Metrics.keyInsets.iPhone.portrait,
    normalColor: colors.blueButtonBackgroundColor,
    highlightColor: colors.blueButtonHighlightedBackgroundColor,
    cornerRadius: buttonCornerRadius,
    normalLowerEdgeColor: colors.lowerEdgeOfButtonNormalColor,
    highlightLowerEdgeColor: colors.lowerEdgeOfButtonHighlightColor,
  } + params, isDark),
};

local blueButtonForegroundStyleName = 'blueButtonForegroundStyle';
local newBlueButtonForegroundStyle(isDark=false, params={}) = {
  [blueButtonForegroundStyleName]: utils.newTextStyle({
    normalColor: colors.blueButtonForegroundColor,
    highlightColor: colors.blueButtonHighlightedForegroundColor,
    fontSize: fonts.systemButtonTextFontSize,
  } + params, isDark) + getKeyboardActionText(params),
};

local enterButtonBackgroundStyle = [
  { styleName: systemButtonBackgroundStyleName, conditionKey: '$returnKeyType', conditionValue: [0, 2, 3, 5, 6, 8, 11] },
  { styleName: blueButtonBackgroundStyleName, conditionKey: '$returnKeyType', conditionValue: [1, 4, 7, 9, 10] },
];

local enterButtonForegroundStyle = [
  { styleName: enterButtonForegroundStyleName, conditionKey: '$returnKeyType', conditionValue: [0, 2, 3, 5, 6, 8, 11] },
  { styleName: blueButtonForegroundStyleName, conditionKey: '$returnKeyType', conditionValue: [1, 4, 7, 9, 10] },
];

// 文本文字系统功能键按钮前景样式
local newTextSystemButtonForegroundStyle(isDark=false, params={}) =
  utils.newTextStyle({
    normalColor: colors.systemButtonForegroundColor,
    highlightColor: colors.systemButtonHighlightedForegroundColor,
    fontSize: fonts.systemButtonTextFontSize,
  } + params, isDark);

local newImageSystemButtonForegroundStyle(isDark=false, params={}) =
  utils.newSystemImageStyle({
    normalColor: colors.systemButtonForegroundColor,
    highlightColor: colors.systemButtonHighlightedForegroundColor,
    fontSize: fonts.systemButtonImageFontSize,
  } + params, isDark);

// params.longPress        可选，字符数组，长按弹出的备选字符
// params.longPressAnchor  可选，这颗键中心占键盘宽的比例（0 左边缘、1 右边缘），
//                         决定长按面板默认高亮哪一格，见 anchorCol；不给按正中算
local newAlphabeticButton(name, isDark=false, params={}, needHint=true) =
  local hasLongPress = std.objectHas(params, 'longPress') && std.length(params.longPress) > 0;
  {
    [name]: utils.newBackgroundStyle(style=alphabeticButtonBackgroundStyleName)
            + (
              if std.objectHas(params, 'foregroundStyleName') then
                { foregroundStyle: params.foregroundStyleName }
              else
                utils.newForegroundStyle(style=name + 'ForegroundStyle')
            )
            + (
              if std.objectHas(params, 'uppercasedStateAction') then
                utils.newForegroundStyle('uppercasedStateForegroundStyle', name + 'UppercaseForegroundStyle')
              else {}
            )
            + (
              if needHint then
                utils.newForegroundStyle('hintStyle', name + 'HintStyle')
              else {}
            )
            + (if hasLongPress then { hintSymbolsGridStyle: name + 'Grid' } else {})
            + utils.extractProperties(
              params,
              [
                'size',
                'bounds',
                'action',
                'uppercasedStateAction',
                'repeatAction',
                'preeditStateAction',
                'swipeUpAction',
                'swipeDownAction',
                'swipeLeftAction',
                'swipeRightAction',
                'capsLockedStateForegroundStyle',
                'preeditStateForegroundStyle',
                'notification',
                'split',
              ]
            ),
  }
  + (
    if std.objectHas(params, 'foregroundStyle') then
      params.foregroundStyle
    else
      { [name + 'ForegroundStyle']: newAlphabeticButtonForegroundStyle(isDark, params) }
  )
  + (
    if std.objectHas(params, 'uppercasedStateAction') then
      { [name + 'UppercaseForegroundStyle']: newAlphabeticButtonUppercaseForegroundStyle(isDark, params) + getKeyboardActionText(params, 'uppercasedStateAction') }
    else {}
  )
  + (
    if needHint then
      {
        [name + 'HintStyle']:
          (if std.objectHas(params, 'hintStyle') then params.hintStyle else {})
          + utils.newBackgroundStyle(style=alphabeticHintBackgroundStyleName)
          + utils.newForegroundStyle(style=name + 'HintForegroundStyle'),
        [name + 'HintForegroundStyle']: newAlphabeticButtonHintStyle(isDark, params) + getKeyboardActionText(params, isUppercase=true),
      }
    else
      {}
  )
  + (
    if hasLongPress then
      newHintSymbolsGrid(
        name,
        isDark,
        params.longPress,
        if std.objectHas(params, 'longPressAnchor') then params.longPressAnchor else 0.5
      )
    else {}
  );

local newSystemButton(name, isDark=false, params={}) =
  {
    [name]: (
              if std.objectHas(params, 'backgroundStyle') then
                { backgroundStyle: params.backgroundStyle }
              else
                utils.newBackgroundStyle(style=systemButtonBackgroundStyleName)
            )
            + (
              if std.objectHas(params, 'foregroundStyleName') then
                { foregroundStyle: params.foregroundStyleName }
              else
                if std.objectHas(params, 'foregroundStyle') then
                  { foregroundStyle: params.foregroundStyle }
                else
                  utils.newForegroundStyle(style=name + 'ForegroundStyle')
            )
            + utils.extractProperties(
              params,
              [
                'size',
                'bounds',
                'action',
                'uppercasedStateAction',
                'repeatAction',
                'preeditStateAction',
                'swipeUpAction',
                'swipeDownAction',
                'swipeLeftAction',
                'swipeRightAction',
                'uppercasedStateForegroundStyle',
                'capsLockedStateForegroundStyle',
                'preeditStateForegroundStyle',
                'notification',
                'split',
              ]
            ),
  }
  + {
    [name + 'ForegroundStyle']: (
      if std.objectHas(params, 'systemImageName') then
        newImageSystemButtonForegroundStyle(isDark, params)
      else
        newTextSystemButtonForegroundStyle(isDark, params) + getKeyboardActionText(params)
    ),
  };

local returnKeyboardTypeChangedNotification = {
  returnKeyTypeChangedNotification: {
    notificationType: 'returnKeyType',
    returnKeyType: [1, 4, 7],
    backgroundStyle: blueButtonBackgroundStyleName,
    foregroundStyle: blueButtonForegroundStyleName,
  },
};

local preeditChangedForEnterButtonNotification = {
  preeditChangedForEnterButtonNotification: {
    notificationType: 'preeditChanged',
    backgroundStyle: enterButtonBackgroundStyle,
    foregroundStyle: enterButtonForegroundStyle,
  },
};

// 中英切换键的前景：按 RIME 的 ascii_mode 当场判定。
// 切到数字键盘再切回来时按键会重新创建，此时不会补发 optionChanged 通知，
// 前景若是写死的「中」图标就会与实际状态不符，只有条件样式能还原出正确的中 / 英图标。
local asciiModeForegroundStyle = [
  { styleName: 'asciiModeIsTrueForegroundStyle', conditionKey: 'rime$ascii_mode', conditionValue: true },
  { styleName: 'asciiModeIsFalseForegroundStyle', conditionKey: 'rime$ascii_mode', conditionValue: false },
];

// 只订阅切到英文这一条：切回中文时由它把动态样式清空、回落到上面的条件样式即可。
// 中英两条都订阅会互相覆盖（后到的一条把先到的结果抹掉），状态因此不稳定。
local asciiModeIsTrueChangedNotification = {
  asciiModeIsTrueChangedNotification: {
    notificationType: 'rime',
    rimeNotificationType: 'optionChanged',
    rimeOptionName: 'ascii_mode',
    rimeOptionValue: true,
    backgroundStyle: 'alphabeticButtonBackgroundStyle',
    foregroundStyle: 'asciiModeIsTrueForegroundStyle',
  },
};

local secondrayCandidatePreeditChangedNotification = {
  secondrayCandidatePreeditChangedNotification: {
    notificationType: 'preeditChanged',
    backgroundStyle: 'alphabeticButtonBackgroundStyle',
    foregroundStyle: 'secondrayCandidatePreeditChangedForegroundStyle',
  },
};

local shiftSecondrayCandidatePreeditChangedNotification = {
  shiftSecondrayCandidatePreeditChangedNotification: {
    notificationType: 'preeditChanged',
    backgroundStyle: 'systemButtonBackgroundStyle',
    foregroundStyle: 'shiftSecondrayCandidatePreeditChangedForegroundStyle',
  },
};

local commitCandidateForegroundStyleName = 'commitCandidateForegroundStyle';
local preeditChangedForSpaceButtonNotification = {
  preeditChangedForSpaceButtonNotification: {
    notificationType: 'preeditChanged',
    backgroundStyle: alphabeticButtonBackgroundStyleName,
    foregroundStyle: commitCandidateForegroundStyleName,
  },
};

local newCommitCandidateForegroundStyle(isDark=false, params={}) = {
  [commitCandidateForegroundStyleName]: utils.newTextStyle({
    normalColor: colors.standardButtonForegroundColor,
    highlightColor: colors.standardButtonHighlightedForegroundColor,
    fontSize: fonts.systemButtonTextFontSize,
  } + params, isDark) + params,
};

{
  keyboardBackgroundStyleName: keyboardBackgroundStyleName,
  newKeyboardBackgroundStyle: newKeyboardBackgroundStyle,

  alphabeticButtonBackgroundStyleName: alphabeticButtonBackgroundStyleName,
  newAlphabeticButtonBackgroundStyle: newAlphabeticButtonBackgroundStyle,

  newAlphabeticButtonForegroundStyle: newAlphabeticButtonForegroundStyle,
  newAlphabeticButtonSwipeForegroundStyle: newAlphabeticButtonSwipeForegroundStyle,
  newAlphabeticButtonUppercaseForegroundStyle: newAlphabeticButtonUppercaseForegroundStyle,

  alphabeticHintBackgroundStyleName: alphabeticHintBackgroundStyleName,
  newAlphabeticHintBackgroundStyle: newAlphabeticHintBackgroundStyle,
  newAlphabeticButtonHintStyle: newAlphabeticButtonHintStyle,

  newHintGridBackgroundStyles: newHintGridBackgroundStyles,
  anchorCol: anchorCol,

  systemButtonBackgroundStyleName: systemButtonBackgroundStyleName,
  newSystemButtonBackgroundStyle: newSystemButtonBackgroundStyle,

  blueButtonBackgroundStyleName: blueButtonBackgroundStyleName,
  newBlueButtonBackgroundStyle: newBlueButtonBackgroundStyle,
  blueButtonForegroundStyleName: blueButtonForegroundStyleName,
  newBlueButtonForegroundStyle: newBlueButtonForegroundStyle,

  newTextSystemButtonForegroundStyle: newTextSystemButtonForegroundStyle,
  newImageSystemButtonForegroundStyle: newImageSystemButtonForegroundStyle,

  newAlphabeticButton: newAlphabeticButton,
  getKeyboardActionText: getKeyboardActionText,
  newSystemButton: newSystemButton,

  enterButtonForegroundStyleName: enterButtonForegroundStyleName,
  enterButtonBackgroundStyle: enterButtonBackgroundStyle,
  enterButtonForegroundStyle: enterButtonForegroundStyle,
  newEnterButtonForegroundStyle: newEnterButtonForegroundStyle,
  newCommitCandidateForegroundStyle: newCommitCandidateForegroundStyle,

  // notification
  returnKeyboardTypeChangedNotification: returnKeyboardTypeChangedNotification,
  preeditChangedForEnterButtonNotification: preeditChangedForEnterButtonNotification,
  preeditChangedForSpaceButtonNotification: preeditChangedForSpaceButtonNotification,
  asciiModeForegroundStyle: asciiModeForegroundStyle,
  asciiModeIsTrueChangedNotification: asciiModeIsTrueChangedNotification,
  secondrayCandidatePreeditChangedNotification: secondrayCandidatePreeditChangedNotification,
  shiftSecondrayCandidatePreeditChangedNotification: shiftSecondrayCandidatePreeditChangedNotification,
}
