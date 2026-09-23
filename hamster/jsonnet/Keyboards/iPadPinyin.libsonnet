// iPad 拼音键盘：五行全键盘，数字/符号行用「上标 + 下标」双行同显（与 iPhone 版的
// swipe-up 徽标是两套不同的视觉方案，重构前就是这样，原样保留）。
//
// 支持分体（Split），iPad 上不分方向（竖屏横屏都给）：Tab 键上划进分体、
// 分体态下再上划一次合回来。数字行（含删除）在分体态整行压成 0 高消失，删除、
// 回车、右侧「123」挪到下面几行的 split-only 新键上，写法照抄
// Skins/default/jsonnet/Keyboards/iPadPinyin.libsonnet 的手法，具体宽度见
// Components/Split.libsonnet 的 widths 表（denominator 16，与 default 同构，数值直接沿用）。
local fonts = import '../Constants/Fonts.libsonnet';
local Keys = import '../Constants/Keys.libsonnet';
local Metrics = import '../Constants/Metrics.libsonnet';
local Button = import '../Components/Button.libsonnet';
local Layout = import '../Components/Layout.libsonnet';
local Preedit = import '../Components/Preedit.libsonnet';
local Split = import '../Components/Split.libsonnet';
local Style = import '../Components/Style.libsonnet';
local Theme = import '../Components/Theme.libsonnet';
local Toolbar = import '../Components/Toolbar.libsonnet';
local utils = import '../Components/Utils.libsonnet';

local sw = Split.widths;

local normalButtonSize = { size: { width: '1.1/16' } };
local doubleLabelUpParams = { center: { y: 0.3 }, fontSize: fonts.ipad.button.doubleLabelSmallFontSize };
local doubleLabelDownParams = { center: { y: 0.65 }, fontSize: fonts.ipad.button.doubleLabelSmallFontSize };
local leftSystemButtonImageOffset = { center: { x: 0.25, y: 0.6 } };
local rightSystemButtonImageOffset = { center: { x: 0.75, y: 0.6 } };
local hintStyle = {};
local candidateInsets = Metrics.iPadSideInsets;

local firstRowStyleName = 'firstRowStyle';

// split-only 新键名
local padTopRight = 'splitPadTopRightButton';
local gapTop = 'splitGapTopButton';
local padHomeLeft = 'splitPadHomeLeftButton';
local padHomeRight = 'splitPadHomeRightButton';
local gapHome = 'splitGapHomeButton';
local padBottomLeft = 'splitPadBottomLeftButton';
local padBottomRight = 'splitPadBottomRightButton';
local gapBottom = 'splitGapBottomButton';
local gapSpace = 'splitGapSpaceButton';
local spaceRight = 'spaceRightButton';
local enterRight = 'enterRightButton';
local backspaceRight = 'backspaceRightButton';
local numericRight = 'numericRightButton';
local repeatedName(c) = c + 'SplitButton';

local keyboardLayout = [
  Layout.row([
    Keys.graveButton.name, Keys.oneButton.name, Keys.twoButton.name, Keys.threeButton.name, Keys.fourButton.name,
    Keys.fiveButton.name, Keys.sixButton.name, Keys.sevenButton.name, Keys.eightButton.name, Keys.nineButton.name,
    Keys.zeroButton.name, Keys.hyphenButton.name, Keys.equalButton.name, Keys.backspaceButton.name,
  ], firstRowStyleName),
  Layout.row(
    [Keys.tabButton.name, 'qButton', 'wButton', 'eButton', 'rButton', 'tButton', gapTop, 'yButton', 'uButton', 'iButton', 'oButton', 'pButton']
    + [Keys.leftChineseBracketButton.name, Keys.rightChineseBracketButton.name, Keys.ideographicCommaButton.name, padTopRight]
  ),
  Layout.row(
    [Keys.asciiModeButton.name, padHomeLeft, 'aButton', 'sButton', 'dButton', 'fButton', 'gButton', gapHome, repeatedName('g'), 'hButton', 'jButton', 'kButton', 'lButton']
    + [Keys.chineseSemicolonButton.name, Keys.leftSingleQuoteButton.name, Keys.enterButton.name, padHomeRight]
  ),
  Layout.row(
    [padBottomLeft, 'left' + Keys.shiftButton.name, 'zButton', 'xButton', 'cButton', 'vButton', gapBottom, repeatedName('v'), 'bButton', 'nButton', 'mButton']
    + [Keys.chineseCommaButton.name, Keys.chinesePeriodButton.name, Keys.forwardSlashButton.name, backspaceRight, 'right' + Keys.shiftButton.name, padBottomRight]
  ),
  Layout.row([Keys.otherKeyboardButton.name, Keys.numericButton.name, Keys.spaceButton.name, gapSpace, spaceRight, enterRight, numericRight, Keys.dismissButton.name]),
];

local newKeyLayout(isDark=false, isPortrait=false) =
  local keyboardHeight = if isPortrait then Metrics.keyboardHeight.iPad.portrait else Metrics.keyboardHeight.iPad.landscape;
  local firstRowHeight = if isPortrait then Metrics.iPadFirstRowHeight.portrait else Metrics.iPadFirstRowHeight.landscape;

  {
    keyboardHeight: keyboardHeight,
    keyboardStyle: utils.newBackgroundStyle(style=Theme.keyboardBackgroundName),
    keyboardLayout: keyboardLayout,
    // 分体态整行压成 0 高，行内所有键（含删除）不建图层；删除挪到第四行的 backspaceRight。
    [firstRowStyleName]: { size: { height: firstRowHeight }, split: { size: { height: 0 } } },
  }

  // ===== 第一行：数字 / 符号，双标签，分体态整行消失，键本身不用写 split =====
  + Button.newAlphabeticButton(Keys.graveButton.name, isDark,
                                normalButtonSize + Keys.graveButton.params + hintStyle
                                + { foregroundStyleName: [Keys.tildeButton.name + 'ForegroundStyle', Keys.graveButton.name + 'ForegroundStyle'] }
                                + { foregroundStyle: {
                                  [Keys.tildeButton.name + 'ForegroundStyle']: Button.newAlphabeticButtonForegroundStyle(isDark, Keys.tildeButton.params + doubleLabelUpParams),
                                  [Keys.graveButton.name + 'ForegroundStyle']: Button.newAlphabeticButtonForegroundStyle(isDark, Keys.graveButton.params + doubleLabelDownParams),
                                } })
  + Button.newAlphabeticButton(Keys.oneButton.name, isDark,
                                normalButtonSize + Keys.oneButton.params + hintStyle
                                + { foregroundStyleName: [Keys.exclamationMarkButton.name + 'ForegroundStyle', Keys.oneButton.name + 'ForegroundStyle'] }
                                + { foregroundStyle: {
                                  [Keys.exclamationMarkButton.name + 'ForegroundStyle']: Button.newAlphabeticButtonForegroundStyle(isDark, Keys.exclamationMarkButton.params + doubleLabelUpParams),
                                  [Keys.oneButton.name + 'ForegroundStyle']: Button.newAlphabeticButtonForegroundStyle(isDark, Keys.oneButton.params + doubleLabelDownParams),
                                } })
  + Button.newAlphabeticButton(Keys.twoButton.name, isDark,
                                normalButtonSize + Keys.twoButton.params + hintStyle
                                + { foregroundStyleName: [Keys.atButton.name + 'ForegroundStyle', Keys.twoButton.name + 'ForegroundStyle'] }
                                + { foregroundStyle: {
                                  [Keys.atButton.name + 'ForegroundStyle']: Button.newAlphabeticButtonForegroundStyle(isDark, Keys.atButton.params + doubleLabelUpParams),
                                  [Keys.twoButton.name + 'ForegroundStyle']: Button.newAlphabeticButtonForegroundStyle(isDark, Keys.twoButton.params + doubleLabelDownParams),
                                } })
  + Button.newAlphabeticButton(Keys.threeButton.name, isDark,
                                normalButtonSize + Keys.threeButton.params + hintStyle
                                + { foregroundStyleName: [Keys.hashButton.name + 'ForegroundStyle', Keys.threeButton.name + 'ForegroundStyle'] }
                                + { foregroundStyle: {
                                  [Keys.hashButton.name + 'ForegroundStyle']: Button.newAlphabeticButtonForegroundStyle(isDark, Keys.hashButton.params + doubleLabelUpParams),
                                  [Keys.threeButton.name + 'ForegroundStyle']: Button.newAlphabeticButtonForegroundStyle(isDark, Keys.threeButton.params + doubleLabelDownParams),
                                } })
  + Button.newAlphabeticButton(Keys.fourButton.name, isDark,
                                normalButtonSize + Keys.fourButton.params + hintStyle
                                + { foregroundStyleName: [Keys.dollarButton.name + 'ForegroundStyle', Keys.fourButton.name + 'ForegroundStyle'] }
                                + { foregroundStyle: {
                                  [Keys.dollarButton.name + 'ForegroundStyle']: Button.newAlphabeticButtonForegroundStyle(isDark, Keys.dollarButton.params + doubleLabelUpParams),
                                  [Keys.fourButton.name + 'ForegroundStyle']: Button.newAlphabeticButtonForegroundStyle(isDark, Keys.fourButton.params + doubleLabelDownParams),
                                } })
  + Button.newAlphabeticButton(Keys.fiveButton.name, isDark,
                                normalButtonSize + Keys.fiveButton.params + hintStyle
                                + { foregroundStyleName: [Keys.percentButton.name + 'ForegroundStyle', Keys.fiveButton.name + 'ForegroundStyle'] }
                                + { foregroundStyle: {
                                  [Keys.percentButton.name + 'ForegroundStyle']: Button.newAlphabeticButtonForegroundStyle(isDark, Keys.percentButton.params + doubleLabelUpParams),
                                  [Keys.fiveButton.name + 'ForegroundStyle']: Button.newAlphabeticButtonForegroundStyle(isDark, Keys.fiveButton.params + doubleLabelDownParams),
                                } })
  + Button.newAlphabeticButton(Keys.sixButton.name, isDark,
                                normalButtonSize + Keys.sixButton.params + hintStyle
                                + { foregroundStyleName: [Keys.caretButton.name + 'ForegroundStyle', Keys.sixButton.name + 'ForegroundStyle'] }
                                + { foregroundStyle: {
                                  [Keys.caretButton.name + 'ForegroundStyle']: Button.newAlphabeticButtonForegroundStyle(isDark, Keys.caretButton.params + doubleLabelUpParams),
                                  [Keys.sixButton.name + 'ForegroundStyle']: Button.newAlphabeticButtonForegroundStyle(isDark, Keys.sixButton.params + doubleLabelDownParams),
                                } })
  + Button.newAlphabeticButton(Keys.sevenButton.name, isDark,
                                normalButtonSize + Keys.sevenButton.params + hintStyle
                                + { foregroundStyleName: [Keys.ampersandButton.name + 'ForegroundStyle', Keys.sevenButton.name + 'ForegroundStyle'] }
                                + { foregroundStyle: {
                                  [Keys.ampersandButton.name + 'ForegroundStyle']: Button.newAlphabeticButtonForegroundStyle(isDark, Keys.ampersandButton.params + doubleLabelUpParams),
                                  [Keys.sevenButton.name + 'ForegroundStyle']: Button.newAlphabeticButtonForegroundStyle(isDark, Keys.sevenButton.params + doubleLabelDownParams),
                                } })
  + Button.newAlphabeticButton(Keys.eightButton.name, isDark,
                                normalButtonSize + Keys.eightButton.params + hintStyle
                                + { foregroundStyleName: [Keys.asteriskButton.name + 'ForegroundStyle', Keys.eightButton.name + 'ForegroundStyle'] }
                                + { foregroundStyle: {
                                  [Keys.asteriskButton.name + 'ForegroundStyle']: Button.newAlphabeticButtonForegroundStyle(isDark, Keys.asteriskButton.params + doubleLabelUpParams),
                                  [Keys.eightButton.name + 'ForegroundStyle']: Button.newAlphabeticButtonForegroundStyle(isDark, Keys.eightButton.params + doubleLabelDownParams),
                                } })
  + Button.newAlphabeticButton(Keys.nineButton.name, isDark,
                                normalButtonSize + Keys.nineButton.params + hintStyle
                                + { foregroundStyleName: [Keys.leftParenthesisButton.name + 'ForegroundStyle', Keys.nineButton.name + 'ForegroundStyle'] }
                                + { foregroundStyle: {
                                  [Keys.leftParenthesisButton.name + 'ForegroundStyle']: Button.newAlphabeticButtonForegroundStyle(isDark, Keys.leftParenthesisButton.params + doubleLabelUpParams),
                                  [Keys.nineButton.name + 'ForegroundStyle']: Button.newAlphabeticButtonForegroundStyle(isDark, Keys.nineButton.params + doubleLabelDownParams),
                                } })
  + Button.newAlphabeticButton(Keys.zeroButton.name, isDark,
                                normalButtonSize + Keys.zeroButton.params + hintStyle
                                + { foregroundStyleName: [Keys.rightParenthesisButton.name + 'ForegroundStyle', Keys.zeroButton.name + 'ForegroundStyle'] }
                                + { foregroundStyle: {
                                  [Keys.rightParenthesisButton.name + 'ForegroundStyle']: Button.newAlphabeticButtonForegroundStyle(isDark, Keys.rightParenthesisButton.params + doubleLabelUpParams),
                                  [Keys.zeroButton.name + 'ForegroundStyle']: Button.newAlphabeticButtonForegroundStyle(isDark, Keys.zeroButton.params + doubleLabelDownParams),
                                } })
  + Button.newAlphabeticButton(Keys.hyphenButton.name, isDark,
                                normalButtonSize + Keys.hyphenButton.params + hintStyle
                                + { foregroundStyleName: [Keys.emDashButton.name + 'ForegroundStyle', Keys.hyphenButton.name + 'ForegroundStyle'] }
                                + { foregroundStyle: {
                                  [Keys.emDashButton.name + 'ForegroundStyle']: Button.newAlphabeticButtonForegroundStyle(isDark, Keys.emDashButton.params + doubleLabelUpParams),
                                  [Keys.hyphenButton.name + 'ForegroundStyle']: Button.newAlphabeticButtonForegroundStyle(isDark, Keys.hyphenButton.params + doubleLabelDownParams),
                                } })
  + Button.newAlphabeticButton(Keys.equalButton.name, isDark,
                                normalButtonSize + Keys.equalButton.params + hintStyle
                                + { foregroundStyleName: [Keys.plusButton.name + 'ForegroundStyle', Keys.equalButton.name + 'ForegroundStyle'] }
                                + { foregroundStyle: {
                                  [Keys.plusButton.name + 'ForegroundStyle']: Button.newAlphabeticButtonForegroundStyle(isDark, Keys.plusButton.params + doubleLabelUpParams),
                                  [Keys.equalButton.name + 'ForegroundStyle']: Button.newAlphabeticButtonForegroundStyle(isDark, Keys.equalButton.params + doubleLabelDownParams),
                                } })
  + Button.newSystemButton(Keys.backspaceButton.name, isDark, { size: { width: '1.7/16' } } + rightSystemButtonImageOffset + Keys.backspaceButton.params)

  // ===== 第二行：Tab 上划进出分体；字母左右分半；标点分体态隐藏 =====
  + Button.newSystemButton(Keys.tabButton.name, isDark,
                            { size: { width: '1.7/16' } } + leftSystemButtonImageOffset + Keys.tabButton.params + Split.enterSplitGesture + Split.width(sw.tab))
  + Style.merge([
    Button.newAlphabeticButton(c + 'Button', isDark, normalButtonSize + Keys[c + 'Button'].params + hintStyle + Split.width(sw.unit))
    for c in std.stringChars('qwertyuiop')
  ])
  + Button.newAlphabeticButton(repeatedName('g'), isDark, Keys.gButton.params { size: { width: 0 } } + hintStyle + Split.width(sw.unit))
  + Button.newAlphabeticButton(Keys.leftChineseBracketButton.name, isDark,
                                normalButtonSize + Keys.leftChineseBracketButton.params + hintStyle + Split.hidden
                                + { foregroundStyleName: [Keys.leftChineseAngleQuoteButton.name + 'ForegroundStyle', Keys.leftChineseBracketButton.name + 'ForegroundStyle'] }
                                + { foregroundStyle: {
                                  [Keys.leftChineseAngleQuoteButton.name + 'ForegroundStyle']: Button.newAlphabeticButtonForegroundStyle(isDark, Keys.leftChineseAngleQuoteButton.params + doubleLabelUpParams),
                                  [Keys.leftChineseBracketButton.name + 'ForegroundStyle']: Button.newAlphabeticButtonForegroundStyle(isDark, Keys.leftChineseBracketButton.params + doubleLabelDownParams),
                                } })
  + Button.newAlphabeticButton(Keys.rightChineseBracketButton.name, isDark,
                                normalButtonSize + Keys.rightChineseBracketButton.params + hintStyle + Split.hidden
                                + { foregroundStyleName: [Keys.rightChineseAngleQuoteButton.name + 'ForegroundStyle', Keys.rightChineseBracketButton.name + 'ForegroundStyle'] }
                                + { foregroundStyle: {
                                  [Keys.rightChineseAngleQuoteButton.name + 'ForegroundStyle']: Button.newAlphabeticButtonForegroundStyle(isDark, Keys.rightChineseAngleQuoteButton.params + doubleLabelUpParams),
                                  [Keys.rightChineseBracketButton.name + 'ForegroundStyle']: Button.newAlphabeticButtonForegroundStyle(isDark, Keys.rightChineseBracketButton.params + doubleLabelDownParams),
                                } })
  + Button.newAlphabeticButton(Keys.ideographicCommaButton.name, isDark,
                                normalButtonSize + Keys.ideographicCommaButton.params + hintStyle + Split.hidden
                                + { foregroundStyleName: [Keys.verticalBarButton.name + 'ForegroundStyle', Keys.ideographicCommaButton.name + 'ForegroundStyle'] }
                                + { foregroundStyle: {
                                  [Keys.verticalBarButton.name + 'ForegroundStyle']: Button.newAlphabeticButtonForegroundStyle(isDark, Keys.verticalBarButton.params + doubleLabelUpParams),
                                  [Keys.ideographicCommaButton.name + 'ForegroundStyle']: Button.newAlphabeticButtonForegroundStyle(isDark, Keys.ideographicCommaButton.params + doubleLabelDownParams),
                                } })

  // ===== 第三行：asciiMode 分体态隐藏；字母左右分半；回车分体态隐藏（挪到 enterRight）=====
  + Button.newSystemButton(Keys.asciiModeButton.name, isDark, { size: { width: '3.9/32' } } + Keys.asciiModeButton.params
                                                              + { foregroundStyleName: Button.asciiModeForegroundStyle } + Split.hidden)
  + Style.merge([
    Button.newAlphabeticButton(c + 'Button', isDark, normalButtonSize + Keys[c + 'Button'].params + hintStyle + Split.width(sw.unit))
    for c in std.stringChars('asdfghjkl')
  ])
  + Button.newAlphabeticButton(Keys.chineseSemicolonButton.name, isDark,
                                normalButtonSize + Keys.chineseSemicolonButton.params + hintStyle + Split.hidden
                                + { foregroundStyleName: [Keys.chineseColonButton.name + 'ForegroundStyle', Keys.chineseSemicolonButton.name + 'ForegroundStyle'] }
                                + { foregroundStyle: {
                                  [Keys.chineseColonButton.name + 'ForegroundStyle']: Button.newAlphabeticButtonForegroundStyle(isDark, Keys.chineseColonButton.params + doubleLabelUpParams),
                                  [Keys.chineseSemicolonButton.name + 'ForegroundStyle']: Button.newAlphabeticButtonForegroundStyle(isDark, Keys.chineseSemicolonButton.params + doubleLabelDownParams),
                                } })
  // leftSingleQuoteButton 的双标签重构前就都引用别的键（rightCurlyQuote / rightSingleQuote），
  // 不是自身，这是既有行为，原样保留。
  + Button.newAlphabeticButton(Keys.leftSingleQuoteButton.name, isDark,
                                normalButtonSize + Keys.leftSingleQuoteButton.params + hintStyle + Split.hidden
                                + { foregroundStyleName: [Keys.rightCurlyQuoteButton.name + 'ForegroundStyle', Keys.rightSingleQuoteButton.name + 'ForegroundStyle'] }
                                + { foregroundStyle: {
                                  [Keys.rightCurlyQuoteButton.name + 'ForegroundStyle']: Button.newAlphabeticButtonForegroundStyle(isDark, Keys.rightCurlyQuoteButton.params + doubleLabelUpParams),
                                  [Keys.rightSingleQuoteButton.name + 'ForegroundStyle']: Button.newAlphabeticButtonForegroundStyle(isDark, Keys.rightSingleQuoteButton.params + doubleLabelDownParams),
                                } })
  + Button.newSystemButton(Keys.enterButton.name, isDark,
                            { size: { width: '3.9/32' }, backgroundStyle: Theme.enterBackgroundStyle, foregroundStyle: Theme.enterForegroundStyle }
                            + Keys.enterButton.params + Split.hidden)

  // ===== 第四行：leftShift 保留（分体态收窄）；rightShift 隐藏；标点隐藏；删除挪到 backspaceRight =====
  + Button.newSystemButton('left' + Keys.shiftButton.name, isDark,
                            { size: { width: '2.5/16' } } + Keys.shiftButton.params
                            + { uppercasedStateForegroundStyle: Keys.shiftButton.name + 'UppercasedForegroundStyle', capsLockedStateForegroundStyle: Keys.shiftButton.name + 'CapsLockedForegroundStyle' }
                            + Split.width(sw.shift))
  + {
    [Keys.shiftButton.name + 'UppercasedForegroundStyle']: Button.newImageSystemButtonForegroundStyle(isDark, Keys.shiftButton.uppercasedParams),
    [Keys.shiftButton.name + 'CapsLockedForegroundStyle']: Button.newImageSystemButtonForegroundStyle(isDark, Keys.shiftButton.capsLockedParams),
  }
  + Style.merge([
    Button.newAlphabeticButton(c + 'Button', isDark, normalButtonSize + Keys[c + 'Button'].params + hintStyle + Split.width(sw.unit))
    for c in std.stringChars('zxcvbnm')
  ])
  + Button.newAlphabeticButton(repeatedName('v'), isDark, Keys.vButton.params { size: { width: 0 } } + hintStyle + Split.width(sw.unit))
  + Button.newAlphabeticButton(Keys.chineseCommaButton.name, isDark,
                                normalButtonSize + Keys.chineseCommaButton.params + hintStyle + Split.hidden
                                + { foregroundStyleName: [Keys.leftBookTitleMarkButton.name + 'ForegroundStyle', Keys.chineseCommaButton.name + 'ForegroundStyle'] }
                                + { foregroundStyle: {
                                  [Keys.leftBookTitleMarkButton.name + 'ForegroundStyle']: Button.newAlphabeticButtonForegroundStyle(isDark, Keys.leftBookTitleMarkButton.params + doubleLabelUpParams),
                                  [Keys.chineseCommaButton.name + 'ForegroundStyle']: Button.newAlphabeticButtonForegroundStyle(isDark, Keys.chineseCommaButton.params + doubleLabelDownParams),
                                } })
  + Button.newAlphabeticButton(Keys.chinesePeriodButton.name, isDark,
                                normalButtonSize + Keys.chinesePeriodButton.params + hintStyle + Split.hidden
                                + { foregroundStyleName: [Keys.rightBookTitleMarkButton.name + 'ForegroundStyle', Keys.chinesePeriodButton.name + 'ForegroundStyle'] }
                                + { foregroundStyle: {
                                  [Keys.rightBookTitleMarkButton.name + 'ForegroundStyle']: Button.newAlphabeticButtonForegroundStyle(isDark, Keys.rightBookTitleMarkButton.params + doubleLabelUpParams),
                                  [Keys.chinesePeriodButton.name + 'ForegroundStyle']: Button.newAlphabeticButtonForegroundStyle(isDark, Keys.chinesePeriodButton.params + doubleLabelDownParams),
                                } })
  + Button.newAlphabeticButton(Keys.forwardSlashButton.name, isDark,
                                normalButtonSize + Keys.forwardSlashButton.params + hintStyle + Split.hidden
                                + { foregroundStyleName: [Keys.questionMarkButton.name + 'ForegroundStyle', Keys.forwardSlashButton.name + 'ForegroundStyle'] }
                                + { foregroundStyle: {
                                  [Keys.questionMarkButton.name + 'ForegroundStyle']: Button.newAlphabeticButtonForegroundStyle(isDark, Keys.questionMarkButton.params + doubleLabelUpParams),
                                  [Keys.forwardSlashButton.name + 'ForegroundStyle']: Button.newAlphabeticButtonForegroundStyle(isDark, Keys.forwardSlashButton.params + doubleLabelDownParams),
                                } })
  + Button.newSystemButton('right' + Keys.shiftButton.name, isDark,
                            { size: { width: '2.5/16' } } + Keys.shiftButton.params
                            + { uppercasedStateForegroundStyle: Keys.shiftButton.name + 'UppercasedForegroundStyle', capsLockedStateForegroundStyle: Keys.shiftButton.name + 'CapsLockedForegroundStyle' }
                            + Split.hidden)

  // ===== 第五行：数字键在分体态右侧隐藏（重复的「123」，与 default 处理一致）=====
  + Button.newSystemButton(Keys.otherKeyboardButton.name, isDark, { size: { width: '1.65/16' } } + Keys.otherKeyboardButton.params + Split.width(sw.globe))
  + Button.newSystemButton(Keys.numericButton.name, isDark, { size: { width: '1.65/16' } } + Keys.numericButton.params + Split.width(sw.keyboardType))
  + Button.newAlphabeticButton(Keys.spaceButton.name, isDark, Keys.spaceButton.params + Split.width(sw.space), needHint=false)
  + Button.newSystemButton(numericRight, isDark, { size: { width: '1.65/16' } } + Keys.numericButton.params { name: numericRight } + Split.hidden)
  + Button.newSystemButton(Keys.dismissButton.name, isDark, { size: { width: '1.65/16' } } + Keys.dismissButton.params + Split.width(sw.dismiss))

  // ===== 分体态新增：中缝、两侧留白、右半边补出的空格 / 回车 / 删除 =====
  + Split.spacer(padTopRight, sw.pad)
  + Split.spacer(gapTop, sw.gapTop)
  + Split.spacer(padHomeLeft, sw.padHome)
  + Split.spacer(gapHome, sw.gapHome)
  + Split.spacer(padHomeRight, sw.padHome)
  + Split.spacer(padBottomLeft, sw.pad)
  + Split.spacer(gapBottom, sw.gapBottom)
  + Split.spacer(padBottomRight, sw.pad)
  + Split.spacer(gapSpace, sw.gapSpace)
  + Button.newAlphabeticButton(spaceRight, isDark, Keys.spaceButton.params { size: { width: 0 } } + Split.width(sw.space), needHint=false)
  + Button.newSystemButton(enterRight, isDark,
                            { size: { width: 0 }, backgroundStyle: Theme.enterBackgroundStyle, foregroundStyle: Theme.enterForegroundStyle }
                            + Keys.enterButton.params { name: enterRight } + Split.width(sw.enter))
  + Button.newSystemButton(backspaceRight, isDark,
                            { size: { width: 0 } } + rightSystemButtonImageOffset + Keys.backspaceButton.params { name: backspaceRight } + Split.width(sw.backspace))
;

{
  new(isDark, isPortrait):
    Preedit.new(isDark, { insets: candidateInsets })
    + Toolbar.new(isDark, candidateInsets, supportsSplit=true)
    + Button.newKeyboardBackgroundStyle(isDark)
    + Button.newAlphabeticButtonBackgroundStyle(isDark, { insets: if isPortrait then Metrics.keyInsets.iPad.portrait else Metrics.keyInsets.iPad.landscape })
    + Button.newSystemButtonBackgroundStyle(isDark, { insets: if isPortrait then Metrics.keyInsets.iPad.portrait else Metrics.keyInsets.iPad.landscape })
    + Button.newBlueButtonBackgroundStyle(isDark)
    + Button.newBlueButtonForegroundStyle(isDark, Keys.enterButton.params)
    + Button.newAlphabeticHintBackgroundStyle(isDark, { cornerRadius: 10 })
    + Split.shared
    + newKeyLayout(isDark, isPortrait)
    + Button.newEnterButtonForegroundStyle(isDark, Keys.enterButton.params)
    + Button.newCommitCandidateForegroundStyle(isDark, { text: '选定' })
    // 重构前 iPad 拼音页缺这三条通知定义，但 asciiModeButton / shiftButton 的
    // params 里已经在引用它们（iPhone 页一直有定义）——补全，修掉「引用不存在样式」
    // 的错误，让 iPad 上的中英切换 / Esc 反馈跟 iPhone 一致。
    + Button.returnKeyboardTypeChangedNotification
    + Button.preeditChangedForEnterButtonNotification
    + Button.preeditChangedForSpaceButtonNotification
    + Button.asciiModeIsTrueChangedNotification
    + Button.secondrayCandidatePreeditChangedNotification
    + Button.shiftSecondrayCandidatePreeditChangedNotification
    + { shiftSecondrayCandidatePreeditChangedForegroundStyle: Button.newTextSystemButtonForegroundStyle(isDark, { text: 'Esc', fontSize: 16 }) }
    + { asciiModeIsTrueForegroundStyle: Button.newAlphabeticButtonForegroundStyle(isDark, { assetImageName: 'englishState2' }) }
    + { asciiModeIsFalseForegroundStyle: Button.newAlphabeticButtonForegroundStyle(isDark, { assetImageName: 'chineseState2' }) }
    + { secondrayCandidatePreeditChangedForegroundStyle: Button.newAlphabeticButtonForegroundStyle(isDark, { text: '次', fontSize: 16 }) },
}
