// 26 键拼音键盘 —— 对应 ../../资料/拼音键盘.png。
//
// 四行：
//   q w e r t y u i o p        每颗右上角带 1~0 的角标，上划即出
//   a s d f g h j k l          九键，首尾两颗把触摸区补到屏幕边缘
//   ⇧ z x c v b n m ⌫         上档键（分词符 ' 在下划，键面不标）
//   ?123 ☺/, 空格 。 ⏎         空格上写的是当前方案名
local Button = import '../Components/Button.libsonnet';
local FunctionKeys = import '../Components/FunctionKeys.libsonnet';
local Keys = import '../Components/Keys.libsonnet';
local Layout = import '../Components/Layout.libsonnet';
local Preedit = import '../Components/Preedit.libsonnet';
local Split = import '../Components/Split.libsonnet';
local Style = import '../Components/Style.libsonnet';
local Theme = import '../Components/Theme.libsonnet';
local Toolbar = import '../Components/Toolbar.libsonnet';
local Fonts = import '../Constants/Fonts.libsonnet';
local Metrics = import '../Constants/Metrics.libsonnet';

// ===== 表一：字母键与它们的上划符号 =====
// [字母, 上划符号]。上划符号同时是键面右上角的角标与气泡里的上划提示。
// 第一行的角标就是设计图上那排 1~0。
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
    ['a', '@'],
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
    ['z', '`'],
    ['x', "'"],
    ['c', '#'],
    ['v', '、'],
    ['b', '?'],
    ['n', '!'],
    ['m', '…'],
  ],
];

// 第二行只有九键，首尾两颗加宽触摸区（显示区不变）
local homeRowExtras = {
  a: Keys.widths.homeRowLeft,
  l: Keys.widths.homeRowRight,
};

// ===== 每颗键的横向位置 =====
// 长按面板默认高亮哪一格、角标排在三格里的哪一格，都看这颗键的中心占键盘宽的比例
// （见 Components/Button.libsonnet 的 anchorCol）。
// 三行字母都是 10 格宽的网格，差别只在行首让出多少：
//   第一行顶格；第二行九键居中，两头各让半格；第三行让出一颗宽键（168.75/1125 = 0.15）。
local rowLeftOffset = [0, 0.05, 0.15];
local letterCenter(row, col) = rowLeftOffset[row] + (col + 0.5) / 10;

// 角标居中的那一档，默认排成「大写 角标 小写」。这里列的几颗反过来排成「小写 角标 大写」。
local lowerFirstLetters = ['v'];

// 一颗字母键除了字母与上划符号之外还要带的东西：加宽的触摸区。
local letterExtras(letter) =
  if std.objectHas(homeRowExtras, letter) then homeRowExtras[letter] else {};

local shiftName = 'shiftButton';
local backspaceName = 'backspaceButton';
local numericName = 'numericButton';
local emojiCommaName = 'emojiCommaButton';
local spaceName = 'spaceButton';
local periodName = 'periodButton';
local enterName = 'enterButton';

// 第四行两颗标点键的长按备选：中文里常用的那几个全角标点。
// 与字母键不同，这两串的第一个就是键面上写的那个字符——长按后直接抬手，
// 上屏的与点按一致（区别只在长按走的是全角，点按是半角交给输入方案转）。
local commaLongPress = ['，', '、', '；', '：', '“', '”'];
local periodLongPress = ['。', '？', '！', '…', '—', '·'];

// 空格两侧这两颗键的长按锚点，直接借第一行 e 与 i 的位置——
// 它们在键盘上就站在同一档，写成同一个式子，改行首偏移时两边一起动。
local commaAnchor = letterCenter(0, 2);
local periodAnchor = letterCenter(0, 7);

// 第四行第二颗：上排一个笑脸、下排一个逗号，与设计图一致。
// 点按上逗号（高频），上划开表情键盘——笑脸画在上排，正好是「上划出什么」的提示，
// 与第一行「角标即上划符号」是同一条读法。
local emojiCommaKey = Button.new(emojiCommaName, {
  role: 'function',
  label: { text: ',', center: Metrics.key.doubleBottomCenter },
  labelFontSize: Fonts.keyLabel,
  // 用 SF Symbol 而不是 ☺（U+263A）：那个码位在 iOS 上会被渲染成彩色 emoji，
  // 与设计图上那个线条笑脸不是一回事。
  secondaryLabel: { systemImageName: 'face.smiling', center: Metrics.key.doubleTopCenter, fontSize: Fonts.keyDouble },
  action: { character: ',' },
  swipeUpAction: { keyboardType: 'emojis' },
  longPress: commaLongPress,
  longPressAnchor: commaAnchor,
} + Keys.widths.unit);

// 句号键。送出的是半角 .，中文状态下由输入方案转成 。——键面直接写成 。，
// 与 Gboard 中文键盘一致。
//
// 键面高度取 doubleBottomCenter：与空格另一侧那颗键的逗号**同一个数**，
// 两边的标点因此落在同一条水平线上，改一处两边一起动，不会各走各的。
// 左右居中不用管——「。」的墨迹偏心由 Button 的 inkOffsets 自动补掉。
local periodKey = Keys.punctuationKey(
  'period', '.', '。',
  Keys.widths.unit { longPress: periodLongPress, longPressAnchor: periodAnchor },
  { center: Metrics.key.doubleBottomCenter }
);

local keyboardLayout = [
  Layout.row([Keys.keyName(entry[0]) for entry in letterRows[0]]),
  Layout.row([Keys.keyName(entry[0]) for entry in letterRows[1]]),
  Layout.row([shiftName] + [Keys.keyName(entry[0]) for entry in letterRows[2]] + [backspaceName]),
  Layout.row([numericName, emojiCommaName, spaceName, periodName, enterName]),
];

// ===== 分体（Split）版面 =====
// 三行字母的行结构与 default / hamster 完全一致（10 键行 / 9 键带宽边行），
// 宽度表直接复用 Components/Split.libsonnet 的 row10 / nineKeyRow。
// 第四行键位是本皮肤特有的（多了表情逗号 / 句号两颗键），宽度表在本文件本地定义。
local padTopLeftName = 'splitPadTopLeftButton';
local padTopRightName = 'splitPadTopRightButton';
local gapTopName = 'splitGapTopButton';
local padHomeLeftName = 'splitPadHomeLeftButton';
local padHomeRightName = 'splitPadHomeRightButton';
local gapHomeName = 'splitGapHomeButton';
local padBottomLeftName = 'splitPadBottomLeftButton';
local padBottomRightName = 'splitPadBottomRightButton';
local gapBottomName = 'splitGapBottomButton';
local padRowFourLeftName = 'splitPadRowFourLeftButton';
local padRowFourRightName = 'splitPadRowFourRightButton';
local gapRowFourName = 'splitGapRowFourButton';
local spaceRightName = 'spaceRightButton';
local repeatedName(c) = c + 'SplitButton';

// 第四行分体宽度表：margin(8) + keyboardType(126) + unit(79.2) + space(220) + gap(258.6)
//   + space(220) + unit(79.2) + keyboardType(126) + margin(8) = 1125
local rowFour = {
  margin: '8/1125',
  keyboardType: '126/1125',
  unit: '79.2/1125',
  space: '220/1125',
  gap: '258.6/1125',
};

local splitKeyboardLayout = [
  Layout.row(
    [padTopLeftName] + [Keys.keyName(entry[0]) for entry in letterRows[0][0:5]]
    + [gapTopName] + [Keys.keyName(entry[0]) for entry in letterRows[0][5:10]]
    + [padTopRightName]
  ),
  Layout.row(
    [padHomeLeftName, Keys.keyName('a')] + [Keys.keyName(entry[0]) for entry in letterRows[1][1:5]]
    + [gapHomeName, repeatedName('g')] + [Keys.keyName(entry[0]) for entry in letterRows[1][5:8]]
    + [Keys.keyName('l'), padHomeRightName]
  ),
  Layout.row(
    [padBottomLeftName, shiftName] + [Keys.keyName(entry[0]) for entry in letterRows[2][0:4]]
    + [gapBottomName, repeatedName('v')] + [Keys.keyName(entry[0]) for entry in letterRows[2][4:7]]
    + [backspaceName, padBottomRightName]
  ),
  Layout.row([
    padRowFourLeftName, numericName, emojiCommaName, spaceName,
    gapRowFourName, spaceRightName, periodName, enterName, padRowFourRightName,
  ]),
];

{
  // device      'iPhone' / 'iPad'
  // isPortrait  竖屏 / 横屏。两者只影响键盘高度与按键间距，布局完全相同。
  new(device='iPhone', isPortrait=true)::
    local orientation = if isPortrait then 'portrait' else 'landscape';
    local insets = Metrics.keyInsets[device][orientation];
    local keysHeight = Metrics.keyboardHeight[device][orientation];
    local sideInsets = if device == 'iPad' then Metrics.iPadSideInsets else {};

    // iPhone 竖屏太窄，分体没有使用价值：产物与引入 Split 前逐字节相同。
    local isSplitCapable = device == 'iPad' || !isPortrait;
    local splitOnly(extra) = if isSplitCapable then extra else {};

    // 每颗字母键在分体态下的宽度覆盖：第一行 10 键对半分；第二行 a/l 宽边、
    // 其余 7 键普通宽；第三行（z-m）全部普通宽，两端的 shift/backspace 另在下面处理。
    local splitLetterExtra(r, letter) =
      if r == 0 then Split.width(Split.row10.unit)
      else if r == 1 then
        if letter == 'a' then
          Split.widthAnchored(Split.nineKeyRow.side, Split.nineKeyRow.sideVisibleFraction, 'right')
        else if letter == 'l' then
          Split.widthAnchored(Split.nineKeyRow.side, Split.nineKeyRow.sideVisibleFraction, 'left')
        else Split.width(Split.nineKeyRow.unit)
      else Split.width(Split.nineKeyRow.unit);

    Style.merge([
      Preedit.new(),
      Toolbar.new(sideInsets, supportsSplit=isSplitCapable),
      Theme.shared(insets, keysHeight),
      splitOnly(Split.shared),
      {
        keyboardHeight: keysHeight,
        keyboardStyle: {
          backgroundStyle: Theme.keyboardBackgroundName,
          // 按键区整体的左右边距，与键间距是两回事，见 Metrics.keyboardAreaInsets
          insets: Metrics.keyboardAreaInsets[device][orientation],
        },
        keyboardLayout: if isSplitCapable then splitKeyboardLayout else keyboardLayout,
      },
      Style.merge([
        Keys.letterKey(
          letterRows[r][c][0],
          letterRows[r][c][1],
          letterCenter(r, c),
          !std.member(lowerFirstLetters, letterRows[r][c][0]),
          letterExtras(letterRows[r][c][0]) + splitOnly(splitLetterExtra(r, letterRows[r][c][0]))
        )
        for r in std.range(0, std.length(letterRows) - 1)
        for c in std.range(0, std.length(letterRows[r]) - 1)
      ]),
      emojiCommaKey + { [emojiCommaName]+: splitOnly(Split.width(rowFour.unit)) },
      periodKey + { [periodName]+: splitOnly(Split.width(rowFour.unit)) },
      // Shift 上划进出分体——这一行唯一天然在角落、分体后仍要用的键。
      FunctionKeys.shift(shiftName, Keys.widths.rowThreeLeft
                                     + splitOnly(
                                       Split.widthAnchored(
                                         Split.nineKeyRow.side, Split.nineKeyRow.sideVisibleFraction, 'left'
                                       ) + Split.enterSplitGesture
                                     )),
      FunctionKeys.backspace(backspaceName, Keys.widths.rowThreeRight
                                             + splitOnly(Split.widthAnchored(
                                               Split.nineKeyRow.side, Split.nineKeyRow.sideVisibleFraction, 'right'
                                             ))),
      // 最后一行两侧的两颗键在 Gboard 上都是胶囊：左边 ?123、右边回车。
      // switchKeyboard 默认给的是小圆角的灰键，这里把角色覆盖成 pill。
      FunctionKeys.switchKeyboard(
        numericName, '?123', 'numeric',
        Keys.widths.rowFourPillLeft { role: 'pill' } + splitOnly(Split.width(rowFour.keyboardType))
      ),
      FunctionKeys.space(spaceName, splitOnly(Split.width(rowFour.space))),
      FunctionKeys.enter(enterName, Keys.widths.rowFourPillRight + splitOnly(Split.width(rowFour.keyboardType))),
    ] + (
      if !isSplitCapable then [] else [
        // ===== 只在分体可用的场景出现的新键：两端留白、中缝、复制键 =====
        // 平时 0 宽，分体态才撑开，见 Components/Split.libsonnet 开头的约束。
        Split.spacer(padTopLeftName, Split.row10.margin),
        Split.spacer(padTopRightName, Split.row10.margin),
        Split.spacer(gapTopName, Split.row10.gap),
        Split.spacer(padHomeLeftName, Split.nineKeyRow.margin),
        Split.spacer(padHomeRightName, Split.nineKeyRow.margin),
        Split.spacer(gapHomeName, Split.nineKeyRow.bottomGap),
        Split.spacer(padBottomLeftName, Split.nineKeyRow.margin),
        Split.spacer(padBottomRightName, Split.nineKeyRow.margin),
        Split.spacer(gapBottomName, Split.nineKeyRow.bottomGap),
        Split.spacer(padRowFourLeftName, rowFour.margin),
        Split.spacer(padRowFourRightName, rowFour.margin),
        Split.spacer(gapRowFourName, rowFour.gap),
        // 合并态下 0 宽、不建层；分体态撑开成普通字母键，与本尊各有各的样式名
        Keys.letterKey(
          'g', letterRows[1][4][1], letterCenter(1, 4), true,
          { size: { width: 0 } } + Split.width(Split.nineKeyRow.unit), repeatedName('g')
        ),
        Keys.letterKey(
          'v', letterRows[2][3][1], letterCenter(2, 3), true,
          { size: { width: 0 } } + Split.width(Split.nineKeyRow.unit), repeatedName('v')
        ),
        // 分体态下空格右半边：与本尊同一套外观（键面同样显示方案名），
        // 合并态 0 宽不建层
        FunctionKeys.space(spaceRightName, { size: { width: 0 } } + Split.width(rowFour.space)),
      ]
    )),
}
