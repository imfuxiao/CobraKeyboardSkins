// iPhone 26 键拼音键盘。
//
// 横屏支持分体（Split）：Shift 键上划进分体、分体态下再上划一次合回来——同一个手势
// 两态共用（iPhone 没有 Tab，借给 Shift，因为 Shift 分体后仍要用，不能被顶掉，见
// Components/Split.libsonnet）。竖屏不适配：屏幕太窄，分成两半没有使用价值，`new()`
// 按 isPortrait 分叉，竖屏产物与引入 Split 前逐字节相同。
//
// 分体宽度表假定 addSemicolon=false（当前 main.jsonnet 的实际配置）；加了分号键之后
// 第二行会变成 10 键，与这里手算的宽度表（9 键 home row）不匹配，所以 addSemicolon=true
// 时一并关闭 Split，产物与引入前逐字节相同。
//
// 整个键盘由下面几张表描述，加键、改上划符号、调宽度都只动表，不动代码。
local Button = import '../Components/Button.libsonnet';
local FunctionKeys = import '../Components/FunctionKeys.libsonnet';
local Layout = import '../Components/Layout.libsonnet';
local Preedit = import '../Components/Preedit.libsonnet';
local Split = import '../Components/Split.libsonnet';
local Style = import '../Components/Style.libsonnet';
local Theme = import '../Components/Theme.libsonnet';
local Toolbar = import '../Components/Toolbar.libsonnet';
local Metrics = import '../Constants/Metrics.libsonnet';

local sw = Split.iPhoneWidths;

// ===== 表一：字母键与它们的上划符号 =====
// [字母, 上划符号]。上划符号同时是键面右上角的角标与气泡里的上划提示。
local letterRows = [
  [
    ['q', '1'],
    ['w', '2'],
    ['e', '3'],
    ['r', '4'],
    ['t', '5'],
    ['y', '6'],
    ['u', '7'],
    ['i', '8'],
    ['o', '9'],
    ['p', '0'],
  ],

  [
    ['a', '`'],
    ['s', '/'],
    ['d', ':'],
    ['f', ';'],
    ['g', '('],
    ['h', ')'],
    ['j', '~'],
    ['k', '“'],
    ['l', '”'],
  ],

  [
    ['z', '@'],
    ['x', "'"],
    ['c', '#'],
    ['v', '、'],
    ['b', '?'],
    ['n', '!'],
    ['m', '…'],
  ],
];

// ===== 表二：宽度 =====
// 统一按 1125 的虚拟设计宽度分配，一行内所有分子加起来正好是 1125 就铺满；
// 不写 size 的键（空格）自动吃掉剩余宽度。
//   第一行 10 × 112.5                                   = 1125
//   第二行 168.75 + 7 × 112.5 + 168.75                   = 1125
//   第三行 168.75 + 7 × 112.5 + 168.75                   = 1125
//   第四行 225 + 112.5 + 空格 450 + 112.5 + 225          = 1125
local widths = {
  // 第三行的 Shift 与退格：触摸区一直延伸到屏幕边缘，显示区略窄，边缘键更好按
  shift: { size: { width: '168.75/1125' }, bounds: { width: '151/168.75', alignment: 'left' } },
  backspace: { size: { width: '168.75/1125' }, bounds: { width: '151/168.75', alignment: 'right' } },
  // 第四行
  numeric: { size: { width: '225/1125' } },
  comma: { size: { width: '112.5/1125' } },
  asciiMode: { size: { width: '112.5/1125' } },
  enter: { size: { width: '225/1125' } },
  // 第二行不带分号键时只有 9 个键，同样把首尾两键的触摸区延伸到边缘
  homeRowLeftEdge: { size: { width: '168.75/1125' }, bounds: { width: '111/168.75', alignment: 'right' } },
  homeRowRightEdge: { size: { width: '168.75/1125' }, bounds: { width: '111/168.75', alignment: 'left' } },
};

local keyName(character) = character + 'Button';

// 一个字母键：主标签 + 角标 + 短按气泡（大写字母，右上角是上划符号）
local letterKey(character, swipe, extra={}) =
  local upper = std.asciiUpper(character);
  Button.new(keyName(character), {
    role: 'letter',
    label: { text: character },
    uppercasedLabel: { text: upper },
    badge: { text: swipe },
    hint: { label: { text: upper }, swipeUp: { text: swipe } },
    action: { character: character },
    uppercasedStateAction: { character: upper },
    swipeUpAction: { character: swipe },
  } + extra);

// 一个标点键：没有大小写，也不弹气泡
local punctuationKey(name, character, swipe, extra={}) =
  Button.new(name, {
    role: 'letter',
    label: { text: character },
    badge: { text: swipe },
    action: { character: character },
    swipeUpAction: { character: swipe },
  } + extra);

local semicolonName = 'semicolonButton';
local commaName = 'commaButton';
local shiftName = 'shiftButton';
local backspaceName = 'backspaceButton';
local numericName = 'numericButton';
local spaceName = 'spaceButton';
local asciiModeName = 'asciiModeButton';
local enterName = 'enterButton';

// 不带分号键时，第二行首尾两键加宽
local homeRowExtras(addSemicolon) =
  if addSemicolon then {}
  else { a: widths.homeRowLeftEdge, l: widths.homeRowRightEdge };

local keyboardLayout(addSemicolon) = [
  Layout.row([keyName(entry[0]) for entry in letterRows[0]]),
  Layout.row(
    [keyName(entry[0]) for entry in letterRows[1]]
    + (if addSemicolon then [semicolonName] else [])
  ),
  Layout.row([shiftName] + [keyName(entry[0]) for entry in letterRows[2]] + [backspaceName]),
  Layout.row([numericName, commaName, spaceName, asciiModeName, enterName]),
];

// ===== 横屏分体版面 =====
// 三行字母按「偶数个左右对半分、奇数个复制中间那颗字母」分左右两半（与 default /
// hamster / Noctua 的 iPhonePinyin 同一套手法），每行两端各加一颗留白键、中间加一颗
// 中缝键，平时 0 宽，Split 态才撑开。第四行（numeric/逗号/空格/中英切换/enter）
// 宽度表见 Components/Split.libsonnet 的 iPhoneWidths 注释。
local padTopLeftName = 'splitPadTopLeftButton';
local padTopRightName = 'splitPadTopRightButton';
local gapTopName = 'splitGapTopButton';
local padHomeLeftName = 'splitPadHomeLeftButton';
local padHomeRightName = 'splitPadHomeRightButton';
local gapHomeName = 'splitGapHomeButton';
local padBottomLeftName = 'splitPadBottomLeftButton';
local padBottomRightName = 'splitPadBottomRightButton';
local gapBottomName = 'splitGapBottomButton';
local padRow4LeftName = 'splitPadRow4LeftButton';
local padRow4RightName = 'splitPadRow4RightButton';
local gapRow4Name = 'splitGapRow4Button';
local spaceRightName = 'spaceRightButton';
local repeatedName(c) = c + 'SplitButton';

local landscapeKeyboardLayout = [
  Layout.row(
    [padTopLeftName] + [keyName(c) for c in std.stringChars('qwert')]
    + [gapTopName] + [keyName(c) for c in std.stringChars('yuiop')] + [padTopRightName]
  ),
  Layout.row(
    [padHomeLeftName] + [keyName(c) for c in std.stringChars('asdfg')]
    + [gapHomeName, repeatedName('g')]
    + [keyName(c) for c in std.stringChars('hjkl')] + [padHomeRightName]
  ),
  Layout.row(
    [padBottomLeftName, shiftName] + [keyName(c) for c in std.stringChars('zxcv')]
    + [gapBottomName, repeatedName('v')]
    + [keyName(c) for c in std.stringChars('bnm')] + [backspaceName, padBottomRightName]
  ),
  Layout.row([
    padRow4LeftName, numericName, commaName, spaceName, gapRow4Name, spaceRightName,
    asciiModeName, enterName, padRow4RightName,
  ]),
];

{
  // isPortrait     竖屏 / 横屏，只影响键盘高度与按键间距（Split 布局除外）
  // addSemicolon   第二行末尾是否加一个分号键（加了以后 a / l 不再加宽，Split 也一并关闭）
  new(isPortrait=true, addSemicolon=false)::
    local orientation = if isPortrait then 'portrait' else 'landscape';
    local insets = Metrics.keyInsets.iPhone[orientation];
    local isSplitCapable = !isPortrait && !addSemicolon;
    local splitOnly(extra) = if isSplitCapable then extra else {};

    local extras = homeRowExtras(addSemicolon);
    local letterKeys = Style.merge([
      letterKey(
        entry[0], entry[1],
        (if std.objectHas(extras, entry[0]) then extras[entry[0]] else {})
        + (
          if entry[0] == 'a' then splitOnly(Split.widthAnchored(sw.side, sw.sideVisibleFraction, 'right'))
          else if entry[0] == 'l' then splitOnly(Split.widthAnchored(sw.side, sw.sideVisibleFraction, 'left'))
          else splitOnly(Split.width(sw.unit))
        )
      )
      for row in letterRows
      for entry in row
    ]);

    Style.merge([
      Preedit.new(),
      Toolbar.new(supportsSplit=isSplitCapable),
      Theme.shared(insets, Metrics.keyboardHeight.iPhone[orientation]),
      splitOnly(Split.shared),
      {
        keyboardHeight: Metrics.keyboardHeight.iPhone[orientation],
        keyboardStyle: { backgroundStyle: Theme.keyboardBackgroundName },
        keyboardLayout: if isSplitCapable then landscapeKeyboardLayout else keyboardLayout(addSemicolon),
      },
      letterKeys,
      if addSemicolon then punctuationKey(semicolonName, ';', ':') else {},
      punctuationKey(commaName, ',', '.', widths.comma + splitOnly(Split.width(sw.smallKey))),
      FunctionKeys.shift(
        shiftName,
        widths.shift
        + splitOnly(Split.widthAnchored(sw.side, sw.sideVisibleFraction, 'left') + Split.enterSplitGesture)
      ),
      FunctionKeys.backspace(
        backspaceName,
        widths.backspace + splitOnly(Split.widthAnchored(sw.side, sw.sideVisibleFraction, 'right'))
      ),
      FunctionKeys.numeric(numericName, widths.numeric + splitOnly(Split.width(sw.keyboardType))),
      FunctionKeys.space(spaceName, splitOnly(Split.width(sw.space))),
      FunctionKeys.asciiMode(asciiModeName, widths.asciiMode + splitOnly(Split.width(sw.smallKey))),
      FunctionKeys.enter(enterName, widths.enter + splitOnly(Split.width(sw.keyboardType))),
    ] + (
      if !isSplitCapable then [] else [
        // ===== 只在横屏出现的新键：两端留白、中缝、右半空格、重复字母 =====
        Split.spacer(padTopLeftName, sw.margin),
        Split.spacer(padTopRightName, sw.margin),
        Split.spacer(gapTopName, sw.gap),
        Split.spacer(padHomeLeftName, sw.margin),
        Split.spacer(padHomeRightName, sw.margin),
        Split.spacer(gapHomeName, sw.bottomGap),
        Split.spacer(padBottomLeftName, sw.margin),
        Split.spacer(padBottomRightName, sw.margin),
        Split.spacer(gapBottomName, sw.bottomGap),
        Split.spacer(padRow4LeftName, sw.margin),
        Split.spacer(padRow4RightName, sw.margin),
        Split.spacer(gapRow4Name, sw.gap),
        Button.new(repeatedName('g'), {
          role: 'letter',
          label: { text: 'g' },
          action: { character: 'g' },
          size: { width: 0 },
        } + Split.width(sw.unit)),
        Button.new(repeatedName('v'), {
          role: 'letter',
          label: { text: 'v' },
          action: { character: 'v' },
          size: { width: 0 },
        } + Split.width(sw.unit)),
        FunctionKeys.space(spaceRightName, { size: { width: 0 } } + Split.width(sw.space)),
      ]
    )),
}
