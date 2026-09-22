// iPad 数字 / 符号键盘：骨架与 iPad 拼音页完全一致（同样五行、同样的行首行尾宽键），
// 只是把字母换成了数字与符号，且键面都是单标签。
//
// 这一页同时承担 iPhone 上「数字页 + 符号页」两页的内容——iPad 屏宽放得下。
//
// 分体（Split）与拼音页同一套规矩，见 Components/Split.libsonnet：
// 中缝两侧各留五颗（末行四颗），放不下的符号在分体态收成 0 宽。
// 两页都支持分体，是为了「分体状态下按 123 切过来，键盘不会忽然合上」。
local Keys = import '../Constants/Keys.libsonnet';
local metrics = import '../Constants/Metrics.libsonnet';
local Button = import '../Components/Button.libsonnet';
local Layout = import '../Components/Layout.libsonnet';
local Preedit = import '../Components/Preedit.libsonnet';
local Split = import '../Components/Split.libsonnet';
local Style = import '../Components/Style.libsonnet';
local Theme = import '../Components/Theme.libsonnet';
local Toolbar = import '../Components/Toolbar.libsonnet';
local Widths = import '../Components/Widths.libsonnet';

local firstRowStyleName = 'firstRowStyle';

// Tab 与删除键的图标往各自那一侧的下角靠，与 iPad 系统键盘一致
local cornerIconLeft = { center: { x: 0.25, y: 0.6 } };
local cornerIconRight = { center: { x: 0.75, y: 0.6 } };

// 第一行在分体态整行消失（高度压成 0），所以不分左右
local numberRow = ['periodButton', 'oneButton', 'twoButton', 'threeButton', 'fourButton', 'fiveButton',
                   'sixButton', 'sevenButton', 'eightButton', 'nineButton', 'zeroButton',
                   'lessThanButton', 'greaterThanButton'];

// 其余三行按分体版面分成三段：中缝左边、中缝右边、分体态下放不下的。
// 三段顺序拼起来就是合并态的那一行，一个符号都没挪位置。
local rowTwo = {
  left: ['leftChineseBracketButton', 'rightChineseBracketButton',
         'leftChineseBraceButton', 'rightChineseBraceButton', 'hashButton'],
  right: ['percentButton', 'caretButton', 'asteriskButton', 'plusButton', 'equalButton'],
  hidden: ['backslashButton', 'verticalBarButton', 'underscoreButton'],
};

local rowThree = {
  left: ['hyphenButton', 'forwardSlashButton', 'chineseColonButton',
         'chineseSemicolonButton', 'leftChineseParenthesisButton'],
  right: ['rightChineseParenthesisButton', 'dollarButton', 'ampersandButton',
          'atButton', 'leftSingleQuoteButton'],
  hidden: ['euroButton'],
};

local rowFour = {
  left: ['ellipsisButton', 'middleDotButton', 'chinesePeriodButton', 'chineseCommaButton'],
  right: ['ideographicCommaButton', 'questionMarkButton', 'chineseExclamationMarkButton', 'tildeButton'],
  hidden: ['leftCurlyQuoteButton', 'rightCurlyQuoteButton'],
};

// ===== 中缝与留白 =====
local gapTop = 'splitGapTopButton';
local padTop = 'splitPadTopButton';
local padHomeLeft = 'splitPadHomeLeftButton';
local gapHome = 'splitGapHomeButton';
local padHomeRight = 'splitPadHomeRightButton';
local padBottomLeft = 'splitPadBottomLeftButton';
local gapBottom = 'splitGapBottomButton';
local padBottomRight = 'splitPadBottomRightButton';
local gapSpace = 'splitGapSpaceButton';
local spaceRight = 'spaceRightButton';
local enterRight = 'enterRightButton';
local backspaceRight = 'backspaceRightButton';

local keyboardLayout = [
  Layout.row(numberRow + ['backspaceButton'], firstRowStyleName),
  Layout.row(['tabButton'] + rowTwo.left + [gapTop] + rowTwo.right + rowTwo.hidden + [padTop]),
  Layout.row(['asciiModeButton', padHomeLeft] + rowThree.left + [gapHome] + rowThree.right
             + rowThree.hidden + ['enterButton', padHomeRight]),
  Layout.row([padBottomLeft, 'leftshiftButton'] + rowFour.left + [gapBottom] + rowFour.right
             + rowFour.hidden + [backspaceRight, 'rightshiftButton', padBottomRight]),
  Layout.row([
    'otherKeyboardButton',
    'pinyinButton',
    'spaceButton',
    gapSpace,
    spaceRight,
    enterRight,
    'pinyinRightButton',
    'dismissButton',
  ]),
];

{
  new(isPortrait=false)::
    local orientation = if isPortrait then 'portrait' else 'landscape';
    local insets = metrics.keyInsets.iPad[orientation];
    local sw = Split.widths;
    local key(name, extra={}) = Button.alphabetic(name, Keys[name] + Widths.iPad.unit + extra, insets, hint={});

    local shift(name, splitOverride) = Button.system(name, Keys.shiftButton + Widths.iPad.shift + splitOverride {
      uppercasedStateForegroundStyle: Theme.shiftUppercasedForegroundName,
      capsLockedStateForegroundStyle: Theme.shiftCapsLockedForegroundName,
    });

    local enterKey(name, size) = Button.system(name, Keys.enterButton + size {
      backgroundStyle: Theme.enterBackgroundStyle,
      foregroundStyle: Theme.enterForegroundStyle,
    });

    Style.merge([
      Preedit.new(metrics.iPadSideInsets),
      Toolbar.new(metrics.iPadSideInsets, metrics.iPadSideInsets, supportsSplit=true),
      Theme.shared(insets),
      Split.shared,
      {
        keyboardHeight: metrics.keyboardHeight.iPad[orientation],
        keyboardStyle: { backgroundStyle: Theme.keyboardBackgroundName },
        keyboardLayout: keyboardLayout,
        [firstRowStyleName]: {
          size: { height: metrics.iPadFirstRowHeight[orientation] },
          split: { size: { height: 0 } },
        },
      },

      // 第一行：分体态整行消失，不必写 split
      Style.merge([key(name) for name in numberRow]),

      // 中缝两侧留下的符号在分体态同宽，放不下的收成 0 宽
      Style.merge([
        key(name, Split.width(sw.unit))
        for row in [rowTwo, rowThree, rowFour]
        for name in row.left + row.right
      ]),
      Style.merge([
        key(name, Split.hidden)
        for row in [rowTwo, rowThree, rowFour]
        for name in row.hidden
      ]),

      // ===== 行首行尾的功能键 =====
      Button.system('backspaceButton', Keys.backspaceButton + Widths.iPad.backspace + cornerIconRight),
      // Tab 键分体后变窄，仍是 Tab；上划进 / 出分体是同一个手势（见 Split.enterSplitGesture）
      Button.system('tabButton', Keys.tabButton + Widths.iPad.tab + cornerIconLeft
                                 + Split.enterSplitGesture + Split.width(sw.tab)),
      Button.system('asciiModeButton', Keys.asciiModeButton + Widths.iPad.asciiMode + Split.hidden),
      enterKey('enterButton', Widths.iPad.enter + Split.hidden),
      shift('leftshiftButton', Split.width(sw.shift)),
      shift('rightshiftButton', Split.hidden),

      // ===== 分体态下右半边补出来的键 =====
      enterKey(enterRight, { size: { width: 0 } } + Split.width(sw.enter)),
      Button.system(backspaceRight, Keys.backspaceButton + { size: { width: 0 } }
                                    + Split.width(sw.backspace) + cornerIconRight),
      Button.alphabetic(spaceRight, Keys.spaceButton + { size: { width: 0 } }
                                    + Split.width(sw.space), insets, hint=null),

      // ===== 最后一行 =====
      Button.system('otherKeyboardButton', Keys.otherKeyboardButton + Widths.iPad.bottom + Split.width(sw.globe)),
      Button.system('pinyinButton', Keys.pinyinButton + Widths.iPad.bottom + Split.width(sw.keyboardType)),
      Button.alphabetic('spaceButton', Keys.spaceButton + Split.width(sw.space), insets, hint=null),
      Button.system('pinyinRightButton', Keys.pinyinButton + Widths.iPad.bottom + Split.hidden),
      Button.system('dismissButton', Keys.dismissButton + Widths.iPad.bottom + Split.width(sw.dismiss)),

      // ===== 中缝与两侧留白 =====
      Split.spacer(gapTop, sw.gapTop),
      Split.spacer(padTop, sw.pad),
      Split.spacer(padHomeLeft, sw.padHome),
      Split.spacer(gapHome, sw.gapHome),
      Split.spacer(padHomeRight, sw.padHome),
      Split.spacer(padBottomLeft, sw.pad),
      Split.spacer(gapBottom, sw.gapBottom),
      Split.spacer(padBottomRight, sw.pad),
      Split.spacer(gapSpace, sw.gapSpace),
    ]),
}
