// iPad 拼音键盘：五行全键盘，键面是「上标 + 下标」双行。
//
// 顶上那一排数字 / 符号比其余四行矮（`firstRowStyle`），这也是 iPad 系统键盘的做法。
// 整块键盘的高度 = 四行正常行高 + 第一排，从拼音切到数字时键不会忽胖忽瘦。
//
// 这一页支持分体（Split）：Tab 键上划进分体，分体态下再上划一次合回来（同一个手势，
// 见 Components/Split.libsonnet 开头的说明）。分体版面的整套规矩在 Components/Split.libsonnet，
// 这里只写「哪颗键分体后多宽」。
local Keys = import '../Constants/Keys.libsonnet';
local fonts = import '../Constants/Fonts.libsonnet';
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

// 双标签的上下位置。上标贴着键面上沿，下标是真正会点出来的那个字符。
local upperLabel = { center: metrics.key.upperLabelCenter, fontSize: fonts.doubleLabel.iPad };
local lowerLabel = { center: metrics.key.lowerLabelCenter, fontSize: fonts.doubleLabel.iPad };

// Tab 与删除键的图标不居中，往各自那一侧的下角靠——与 iPad 系统键盘一致，
// 一眼就能看出这两颗是「行首 / 行尾」的宽键。
local cornerIconLeft = { center: { x: 0.25, y: 0.6 } };
local cornerIconRight = { center: { x: 0.75, y: 0.6 } };

// ===== 双标签表：[下标（直接点）, 上标（Shift 或上划）] =====
// 下标那个名字就是这颗键在布局里的名字；上标只贡献一层键面，不是一颗独立的键。
local numberRow = [
  ['graveButton', 'tildeButton'],
  ['oneButton', 'exclamationMarkButton'],
  ['twoButton', 'atButton'],
  ['threeButton', 'hashButton'],
  ['fourButton', 'dollarButton'],
  ['fiveButton', 'percentButton'],
  ['sixButton', 'caretButton'],
  ['sevenButton', 'ampersandButton'],
  ['eightButton', 'asteriskButton'],
  ['nineButton', 'leftParenthesisButton'],
  ['zeroButton', 'rightParenthesisButton'],
  ['hyphenButton', 'emDashButton'],
  ['equalButton', 'plusButton'],
];

local topPunctuation = [
  ['leftChineseBracketButton', 'leftChineseAngleQuoteButton'],
  ['rightChineseBracketButton', 'rightChineseAngleQuoteButton'],
  ['ideographicCommaButton', 'verticalBarButton'],
];

local homePunctuation = [
  ['chineseSemicolonButton', 'chineseColonButton'],
  // 这颗键点出 ‘、上划出 “，键面上下两标就该是这两个字符
  ['leftSingleQuoteButton', 'leftCurlyQuoteButton'],
];

local bottomPunctuation = [
  ['chineseCommaButton', 'leftBookTitleMarkButton'],
  ['chinesePeriodButton', 'rightBookTitleMarkButton'],
  ['forwardSlashButton', 'questionMarkEnButton'],
];

// 字母分成左右两半，中间夹中缝。第二 / 三行右半边的第一颗（g / v）在左半边也有一颗——
// 分体后中指那一列离哪边都不近，两边各放一颗，这是 iPad 系统分体键盘的做法。
local letterRows = [
  { left: 'qwert', right: 'yuiop' },
  { left: 'asdfg', right: 'hjkl', repeated: 'g' },
  { left: 'zxcv', right: 'bnm', repeated: 'v' },
];

local keyName(c) = c + 'Button';
local names(table) = [entry[0] for entry in table];
local letterNames(row) = [keyName(c) for c in std.stringChars(row)];

// 重复键在合并态是 0 宽，所以取一个独立的名字，好让它与本尊各有各的宽度
local repeatedName(c) = c + 'SplitButton';

// ===== 中缝与留白 =====
// 名字带 split 前缀，一眼看出它们只在分体态下占位置。
local gapTop = 'splitGapTopButton';
local padTop = 'splitPadTopButton';
local padHomeLeft = 'splitPadHomeLeftButton';
local gapHome = 'splitGapHomeButton';
local padHomeRight = 'splitPadHomeRightButton';
local padBottomLeft = 'splitPadBottomLeftButton';
local gapBottom = 'splitGapBottomButton';
local padBottomRight = 'splitPadBottomRightButton';
local gapSpace = 'splitGapSpaceButton';
// 分体态下右半边才出现的三颗键：空格、回车、删除
local spaceRight = 'spaceRightButton';
local enterRight = 'enterRightButton';
local backspaceRight = 'backspaceRightButton';

local keyboardLayout = [
  // 第一行（数字行）在分体态下高度为 0，整行连同键一起消失，不必写中缝
  Layout.row(names(numberRow) + ['backspaceButton'], firstRowStyleName),
  Layout.row(
    ['tabButton'] + letterNames(letterRows[0].left) + [gapTop] + letterNames(letterRows[0].right)
    + names(topPunctuation) + [padTop]
  ),
  Layout.row(
    ['asciiModeButton', padHomeLeft] + letterNames(letterRows[1].left) + [gapHome]
    + [repeatedName(letterRows[1].repeated)] + letterNames(letterRows[1].right)
    + names(homePunctuation) + ['enterButton', padHomeRight]
  ),
  Layout.row(
    [padBottomLeft, 'leftshiftButton'] + letterNames(letterRows[2].left) + [gapBottom]
    + [repeatedName(letterRows[2].repeated)] + letterNames(letterRows[2].right)
    + names(bottomPunctuation) + [backspaceRight, 'rightshiftButton', padBottomRight]
  ),
  Layout.row([
    'otherKeyboardButton',
    'numericButton',
    'spaceButton',
    gapSpace,
    spaceRight,
    enterRight,
    'numericRightButton',
    'dismissButton',
  ]),
];

{
  new(isPortrait=false)::
    local orientation = if isPortrait then 'portrait' else 'landscape';
    local insets = metrics.keyInsets.iPad[orientation];
    local sw = Split.widths;

    // iPad 的气泡不写尺寸，跟着按键自身大小走
    local key(name, extra={}) = Button.alphabetic(name, Keys[name] + extra, insets, hint={});

    // 一颗双标签键：两层键面自上而下摆，动作沿用下标那颗键的
    local dualKey(entry, extra={}) = key(entry[0], Widths.iPad.unit + extra {
      layers: [
        { name: entry[1], params: Keys[entry[1]] + upperLabel },
        { name: entry[0], params: Keys[entry[0]] + lowerLabel },
      ],
    });

    // 一颗字母键。分体态下所有字母同宽，不分行。
    local letterKey(c, name=null) =
      local styleName = if name == null then keyName(c) else name;
      Button.alphabetic(
        styleName, Keys[keyName(c)] + Widths.iPad.unit + Split.width(sw.unit), insets, hint={}
      );

    // 分体态下只出现在右半边的那颗字母键：合并态 0 宽，不建图层
    local repeatedKey(c) = Button.alphabetic(
      repeatedName(c), Keys[keyName(c)] + { size: { width: 0 } } + Split.width(sw.unit), insets, hint={}
    );

    local shift(name, splitOverride) = Button.system(name, Keys.shiftButton + Widths.iPad.shift + splitOverride {
      uppercasedStateForegroundStyle: Theme.shiftUppercasedForegroundName,
      capsLockedStateForegroundStyle: Theme.shiftCapsLockedForegroundName,
    });

    local enterKey(name, size) = Button.system(name, Keys.enterButton + size {
      backgroundStyle: Theme.enterBackgroundStyle,
      foregroundStyle: Theme.enterForegroundStyle,
    });

    Style.merge([
      // iPad 屏宽富余，预编辑区与候选栏两侧留白，视线不用扫过整个屏幕
      Preedit.new(metrics.iPadSideInsets),
      Toolbar.new(metrics.iPadSideInsets, metrics.iPadSideInsets, supportsSplit=true),
      Theme.shared(insets),
      Split.shared,
      {
        keyboardHeight: metrics.keyboardHeight.iPad[orientation],
        keyboardStyle: { backgroundStyle: Theme.keyboardBackgroundName },
        keyboardLayout: keyboardLayout,
        // 分体态下这一行压成 0 高，整行的键不建图层，下面四行分掉整块高度
        [firstRowStyleName]: {
          size: { height: metrics.iPadFirstRowHeight[orientation] },
          split: { size: { height: 0 } },
        },
      },

      // ===== 第一行：数字与符号。分体态整行消失，不必写 split =====
      Style.merge([dualKey(entry) for entry in numberRow]),
      Button.system('backspaceButton', Keys.backspaceButton + Widths.iPad.backspace + cornerIconRight),

      // ===== 字母 =====
      Style.merge([
        letterKey(c)
        for row in letterRows
        for c in std.stringChars(row.left + row.right)
      ]),
      Style.merge([repeatedKey(row.repeated) for row in letterRows if std.objectHas(row, 'repeated')]),

      // ===== 行首行尾的功能键 =====
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

      // ===== 标点。分体态下让位给中缝 =====
      Style.merge([
        dualKey(entry, Split.hidden)
        for entry in topPunctuation + homePunctuation + bottomPunctuation
      ]),

      // ===== 最后一行 =====
      Button.system('otherKeyboardButton', Keys.otherKeyboardButton + Widths.iPad.bottom + Split.width(sw.globe)),
      Button.system('numericButton', Keys.numericButton + Widths.iPad.bottom + Split.width(sw.keyboardType)),
      Button.alphabetic('spaceButton', Keys.spaceButton + Split.width(sw.space), insets, hint=null),
      Button.system('numericRightButton', Keys.numericButton + Widths.iPad.bottom + Split.hidden),
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
