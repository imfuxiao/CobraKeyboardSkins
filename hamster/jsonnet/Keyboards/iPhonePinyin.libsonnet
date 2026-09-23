// iPhone 拼音键盘：标准 26 键，四行，键面上角带 swipe-up 徽标（小字提示上划能打什么）。
//
// 横屏支持分体（Split）：Shift 键上划进分体、分体态下再上划一次合回来——同一个手势两态
// 共用（借用 Shift 是因为它分体后仍要用，不能被顶掉，见 Components/Split.libsonnet）。
// 竖屏不适配（屏幕太窄，分体没有使用价值），`new()` 按 isPortrait 分叉，竖屏产物与
// 引入 Split 前逐字节相同。
//
// 分体宽度表假定 addSemicolon=false（当前 main.jsonnet 的实际配置）；addSemicolon=true
// 时第二行会多一颗分号键，与这里手算的宽度表不匹配，分体态不建议与 addSemicolon 同时使用。
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

local hintStyle = { hintStyle: { size: Metrics.hint.iPhoneSize } };

local topBadgeLabelUpParams = { center: { y: 0.2 }, fontSize: fonts.iPhone.button.doubleLabelSmallFontSize };

local createSwipeUpHintStyle(isDark, keyDef) = {
  [keyDef.name + 'SwipeUpHintForegroundStyle']: Button.newAlphabeticButtonHintStyle(isDark) + Button.getKeyboardActionText(keyDef.params),
};

local createButtonForegroundStyle(isDark, keyDef) = {
  [keyDef.name + 'ForegroundStyle']: Button.newAlphabeticButtonForegroundStyle(isDark, keyDef.params),
};

local createTopBadgeForegroundStyle(isDark, keyDef) = {
  [keyDef.name + 'BadgeForegroundStyle']: Button.newAlphabeticButtonSwipeForegroundStyle(isDark, keyDef.params + topBadgeLabelUpParams),
};

// 长按符号网格的三格：小写、大写、键面角标。
// **角标一定落在默认高亮的那一格**（Button.anchorCol 按键位算出来的那一格），
// 手指一按下去，底下亮着的就是这颗键上角标着的那个字符，抬手即出；
// 大写排到离角标最远的一端，小写填中间：
//
//   角标在最左（q a）   →  1 q Q
//   角标居中           →  E 3 e
//   角标在最右（p l）   →  P p 0
local letterLongPress(keyDef, badgeKey, anchor) =
  local lower = keyDef.params.action.character;
  local upper = keyDef.params.uppercasedStateAction.character;
  local badge = badgeKey.params.action.character;
  local badgeIndex = Button.anchorCol(anchor, 3);
  if badgeIndex <= 0 then [badge, lower, upper]
  else if badgeIndex >= 2 then [upper, lower, badge]
  else [upper, badge, lower];

// 一颗字母键：本体前景 + 右上角 swipe-up 徽标。badgeKey 提供徽标、气泡上划字与长按网格里
// 那一格的字符，必须与这颗键自己的 swipeUpAction 是同一个字符，否则键面标的和上划打出的对不上。
// anchor 是这颗键中心占键盘宽的比例，给了才带长按符号网格。
local letterKey(name, isDark, keyDef, badgeKey, insets, extra={}, anchor=null) =
  Button.newAlphabeticButton(
    name,
    isDark,
    keyDef.params
    + { hintStyle: hintStyle.hintStyle { swipeUpForegroundStyle: badgeKey.name + 'SwipeUpHintForegroundStyle' } }
    + { foregroundStyleName: [keyDef.name + 'ForegroundStyle', badgeKey.name + 'BadgeForegroundStyle'] }
    + { foregroundStyle: createButtonForegroundStyle(isDark, keyDef) + createTopBadgeForegroundStyle(isDark, badgeKey) }
    + (if anchor == null then {} else { longPress: letterLongPress(keyDef, badgeKey, anchor), longPressAnchor: anchor })
    + extra
  ) + createSwipeUpHintStyle(isDark, badgeKey);

local letterRow1 = [['qButton', 'oneButton'], ['wButton', 'twoButton'], ['eButton', 'threeButton'], ['rButton', 'fourButton'], ['tButton', 'fiveButton'], ['yButton', 'sixButton'], ['uButton', 'sevenButton'], ['iButton', 'eightButton'], ['oButton', 'nineButton'], ['pButton', 'zeroButton']];
local letterRow2 = [['aButton', 'graveButton'], ['sButton', 'forwardSlashButton'], ['dButton', 'colonButton'], ['fButton', 'semicolonButton'], ['gButton', 'leftParenthesisButton'], ['hButton', 'rightParenthesisButton'], ['jButton', 'tildeButton'], ['kButton', 'leftCurlyQuoteButton'], ['lButton', 'rightCurlyQuoteButton']];
local letterRow3 = [['zButton', 'atButton'], ['xButton', 'apostropheButton'], ['cButton', 'hashButton'], ['vButton', 'ideographicCommaButton'], ['bButton', 'questionMarkButton'], ['nButton', 'exclamationMarkButton'], ['mButton', 'ellipsisButton']];

// ===== 每颗字母键的横向位置（合并态），决定长按面板默认高亮哪一格 =====
// 三行字母都是 10 格宽的网格，差别只在行首让出多少：
//   第一行顶格；第二行九键居中，两头各让半格（a / l 的可视区与上一行错开半颗键）；
//   第三行让出一颗 Shift（0.15）。
// addSemicolon=true 时第二行是十键顶格，不再让半格。
local letterAnchors(addSemicolon) =
  local rows = [letterRow1, letterRow2, letterRow3];
  local rowLeftOffset = [0, if addSemicolon then 0 else 0.05, 0.15];
  {
    [rows[r][c][0]]: rowLeftOffset[r] + (c + 0.5) / 10
    for r in std.range(0, 2)
    for c in std.range(0, std.length(rows[r]) - 1)
  };

// 逗号键的长按备选：中文里常用的那几个全角标点。
// 锚点取它自己的中心（左边 123 占 0.2、自身占 0.1）。
local commaLongPress = ['，', '、', '；', '：', '“', '”'];
local commaAnchor = 0.25;

local keyboardLayout(addSemicolon) = [
  Layout.row([e[0] for e in letterRow1]),
  Layout.row([e[0] for e in letterRow2] + (if addSemicolon then [Keys.semicolonButton.name] else [])),
  Layout.row(['shiftButton'] + [e[0] for e in letterRow3] + ['backspaceButton']),
  Layout.row(['numericButton', 'commaButton', 'spaceButton', 'asciiModeButton', 'enterButton']),
];

// ===== 横屏分体版面：三行字母左右各 5/4 颗（奇数行复制中间那颗），两端留白 + 中缝 =====
local padTopLeft = 'splitPadTopLeftButton';
local padTopRight = 'splitPadTopRightButton';
local gapTop = 'splitGapTopButton';
local padHomeLeft = 'splitPadHomeLeftButton';
local padHomeRight = 'splitPadHomeRightButton';
local gapHome = 'splitGapHomeButton';
local padBottomLeft = 'splitPadBottomLeftButton';
local padBottomRight = 'splitPadBottomRightButton';
local gapBottom = 'splitGapBottomButton';
local padRow4Left = 'splitPadRow4LeftButton';
local padRow4Right = 'splitPadRow4RightButton';
local gapRow4 = 'splitGapRow4Button';
local spaceRightName = 'spaceRightButton';
local repeatedName(c) = c + 'SplitButton';

local landscapeKeyboardLayout = [
  Layout.row([padTopLeft] + ['qButton', 'wButton', 'eButton', 'rButton', 'tButton'] + [gapTop] + ['yButton', 'uButton', 'iButton', 'oButton', 'pButton'] + [padTopRight]),
  Layout.row([padHomeLeft] + ['aButton', 'sButton', 'dButton', 'fButton', 'gButton'] + [gapHome, repeatedName('g')] + ['hButton', 'jButton', 'kButton', 'lButton'] + [padHomeRight]),
  Layout.row([padBottomLeft, 'shiftButton'] + ['zButton', 'xButton', 'cButton', 'vButton'] + [gapBottom, repeatedName('v')] + ['bButton', 'nButton', 'mButton'] + ['backspaceButton', padBottomRight]),
  Layout.row([padRow4Left, 'numericButton', 'commaButton', 'spaceButton', gapRow4, spaceRightName, 'asciiModeButton', 'enterButton', padRow4Right]),
];

{
  new(isDark, isPortrait, addSemicolon):
    local orientation = if isPortrait then 'portrait' else 'landscape';
    local insets = Metrics.keyInsets.iPhone[orientation];
    local extraParams = { insets: insets };

    // Split 只在横屏生效（竖屏产物与引入 Split 前逐字节相同），且要求 addSemicolon=false
    // （分体宽度表按 9 字母第二行手算，见文件头注释）。
    local isSplitCapable = !isPortrait && !addSemicolon;
    local splitOnly(extra) = if isSplitCapable then extra else {};
    local iw = Split.iPhoneWidths;

    local anchors = letterAnchors(addSemicolon);
    local letters(rowSpec, extraByName={}) = Style.merge([
      letterKey(e[0], isDark, Keys[e[0]], Keys[e[1]], insets,
                if std.objectHas(extraByName, e[0]) then extraByName[e[0]] else {},
                anchors[e[0]])
      for e in rowSpec
    ]);

    Style.merge([
      Preedit.new(isDark),
      Toolbar.new(isDark, {}, supportsSplit=isSplitCapable),
      Button.newKeyboardBackgroundStyle(isDark)
      + Button.newAlphabeticButtonBackgroundStyle(isDark, extraParams)
      + Button.newSystemButtonBackgroundStyle(isDark, extraParams)
      + Button.newBlueButtonBackgroundStyle(isDark, extraParams)
      + Button.newBlueButtonForegroundStyle(isDark, Keys.enterButton.params)
      + Button.newAlphabeticHintBackgroundStyle(isDark, { cornerRadius: 10 })
      + Button.newHintGridBackgroundStyles(isDark)
      + Button.newEnterButtonForegroundStyle(isDark, Keys.enterButton.params)
      + Button.newCommitCandidateForegroundStyle(isDark, { text: '选定' })
      + Button.returnKeyboardTypeChangedNotification
      + Button.preeditChangedForEnterButtonNotification
      + Button.preeditChangedForSpaceButtonNotification
      + Button.asciiModeIsTrueChangedNotification
      + Button.secondrayCandidatePreeditChangedNotification
      + Button.shiftSecondrayCandidatePreeditChangedNotification,
      splitOnly(Split.shared),
      {
        keyboardHeight: Metrics.keyboardHeight.iPhone[orientation],
        keyboardStyle: utils.newBackgroundStyle(style=Theme.keyboardBackgroundName),
        keyboardLayout: if isSplitCapable then landscapeKeyboardLayout else keyboardLayout(addSemicolon),
      },

      // 第一行：分体态左右各 5 颗字母（qwert / yuiop），两端留白 + 中缝
      letters(letterRow1, {
        [e[0]]: splitOnly(Split.width(iw.unit))
        for e in letterRow1
      }),

      // 第二行：a/l 触摸区伸到屏幕边缘（重构前既有技巧），分体态额外宽出 side、贴内侧显示
      letterKey('aButton', isDark, Keys.aButton, Keys.graveButton, insets,
                (if addSemicolon then {} else { size: { width: '168.75/1125' }, bounds: { width: '111/168.75', alignment: 'right' } })
                + splitOnly(Split.widthAnchored(iw.side, iw.sideVisibleFraction, 'right')),
                anchors.aButton),
      letters([e for e in letterRow2 if e[0] != 'aButton' && e[0] != 'lButton'], {
        [e[0]]: splitOnly(Split.width(iw.unit))
        for e in letterRow2
      }),
      letterKey('lButton', isDark, Keys.lButton, Keys.rightCurlyQuoteButton, insets,
                (if addSemicolon then {} else { size: { width: '168.75/1125' }, bounds: { width: '111/168.75', alignment: 'left' } })
                + splitOnly(Split.widthAnchored(iw.side, iw.sideVisibleFraction, 'left')),
                anchors.lButton),
      (if addSemicolon then
         letterKey(Keys.semicolonButton.name, isDark, Keys.semicolonButton, Keys.colonButton, insets)
       else {}),

      // 第三行：Shift 上划进分体（横屏专属手势），删除键镜像处理
      Button.newSystemButton('shiftButton', isDark,
                              { size: { width: { percentage: 0.15 } }, bounds: { width: '151/168.75', alignment: 'left' } }
                              + Keys.shiftButton.params
                              + { uppercasedStateForegroundStyle: 'shiftButtonUppercasedForegroundStyle', capsLockedStateForegroundStyle: 'shiftButtonCapsLockedForegroundStyle' }
                              + splitOnly(Split.widthAnchored(iw.side, iw.sideVisibleFraction, 'left') + Split.enterSplitGesture))
      + {
        shiftButtonUppercasedForegroundStyle: Button.newImageSystemButtonForegroundStyle(isDark, Keys.shiftButton.uppercasedParams),
        shiftButtonCapsLockedForegroundStyle: Button.newImageSystemButtonForegroundStyle(isDark, Keys.shiftButton.capsLockedParams),
        shiftSecondrayCandidatePreeditChangedForegroundStyle: Button.newTextSystemButtonForegroundStyle(isDark, { text: 'Esc', fontSize: 16 }),
      },
      letters(letterRow3, {
        [e[0]]: splitOnly(Split.width(iw.unit))
        for e in letterRow3
      }),
      Button.newSystemButton('backspaceButton', isDark,
                              { size: { width: { percentage: 0.15 } }, bounds: { width: '151/168.75', alignment: 'right' } } + Keys.backspaceButton.params
                              + splitOnly(Split.widthAnchored(iw.side, iw.sideVisibleFraction, 'right'))),

      // 第四行。逗号键重构前就没有长按气泡也没有 swipe-up 徽标（needHint=false 且
      // 没有 foregroundStyleName 覆盖），这里保留同样的裸样式，只是加了 split 宽度。
      Button.newSystemButton('numericButton', isDark, { size: { width: { percentage: 0.2 } } } + Keys.numericButton.params + splitOnly(Split.width(iw.keyboardType))),
      Button.newAlphabeticButton('commaButton', isDark,
                                  { size: { width: { percentage: 0.1 } } } + Keys.commaButton.params + splitOnly(Split.width(iw.smallKey))
                                  + { longPress: commaLongPress, longPressAnchor: commaAnchor },
                                  needHint=false),
      Button.newAlphabeticButton('spaceButton', isDark, Keys.spaceButton.params + splitOnly(Split.width(iw.space)), needHint=false),
      Button.newAlphabeticButton('asciiModeButton', isDark,
                                  { size: { width: { percentage: 0.1 } } } + Keys.asciiModeButton.params
                                  + { foregroundStyleName: Button.asciiModeForegroundStyle }
                                  + splitOnly(Split.width(iw.smallKey)),
                                  needHint=false)
      + { asciiModeIsTrueForegroundStyle: Button.newAlphabeticButtonForegroundStyle(isDark, { assetImageName: 'englishState2' }) }
      + { asciiModeIsFalseForegroundStyle: Button.newAlphabeticButtonForegroundStyle(isDark, { assetImageName: 'chineseState2' }) }
      + { secondrayCandidatePreeditChangedForegroundStyle: Button.newAlphabeticButtonForegroundStyle(isDark, { text: '次', fontSize: 16 }) },
      Button.newSystemButton('enterButton', isDark, { size: { width: { percentage: 0.2 } } } + Keys.enterButton.params + splitOnly(Split.width(iw.keyboardType))),
    ] + (
      if !isSplitCapable then [] else [
        Split.spacer(padTopLeft, iw.margin),
        Split.spacer(padTopRight, iw.margin),
        Split.spacer(gapTop, iw.gap),
        Split.spacer(padHomeLeft, iw.margin),
        Split.spacer(padHomeRight, iw.margin),
        Split.spacer(gapHome, iw.bottomGap),
        Split.spacer(padBottomLeft, iw.margin),
        Split.spacer(padBottomRight, iw.margin),
        Split.spacer(gapBottom, iw.bottomGap),
        Split.spacer(padRow4Left, iw.margin),
        Split.spacer(padRow4Right, iw.margin),
        Split.spacer(gapRow4, iw.gap),
        // 这两颗只在分体态出现，站在右半边的行首，离键盘中线不远，长按面板默认选中间那格
        letterKey(repeatedName('g'), isDark, Keys.gButton { name: repeatedName('g') }, Keys.leftParenthesisButton, insets, { size: { width: 0 } } + Split.width(iw.unit), 0.5),
        letterKey(repeatedName('v'), isDark, Keys.vButton { name: repeatedName('v') }, Keys.ideographicCommaButton, insets, { size: { width: 0 } } + Split.width(iw.unit), 0.5),
        Button.newAlphabeticButton(spaceRightName, isDark, Keys.spaceButton.params { size: { width: 0 } } + Split.width(iw.space), needHint=false),
      ]
    )),
}
