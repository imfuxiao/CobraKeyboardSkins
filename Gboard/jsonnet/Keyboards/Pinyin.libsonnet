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

{
  // device      'iPhone' / 'iPad'
  // isPortrait  竖屏 / 横屏。两者只影响键盘高度与按键间距，布局完全相同。
  new(device='iPhone', isPortrait=true)::
    local orientation = if isPortrait then 'portrait' else 'landscape';
    local insets = Metrics.keyInsets[device][orientation];
    local keysHeight = Metrics.keyboardHeight[device][orientation];
    local sideInsets = if device == 'iPad' then Metrics.iPadSideInsets else {};

    Style.merge([
      Preedit.new(),
      Toolbar.new(sideInsets),
      Theme.shared(insets, keysHeight),
      {
        keyboardHeight: keysHeight,
        keyboardStyle: {
          backgroundStyle: Theme.keyboardBackgroundName,
          // 按键区整体的左右边距，与键间距是两回事，见 Metrics.keyboardAreaInsets
          insets: Metrics.keyboardAreaInsets[device][orientation],
        },
        keyboardLayout: keyboardLayout,
      },
      Style.merge([
        Keys.letterKey(
          letterRows[r][c][0],
          letterRows[r][c][1],
          letterCenter(r, c),
          !std.member(lowerFirstLetters, letterRows[r][c][0]),
          letterExtras(letterRows[r][c][0])
        )
        for r in std.range(0, std.length(letterRows) - 1)
        for c in std.range(0, std.length(letterRows[r]) - 1)
      ]),
      emojiCommaKey,
      periodKey,
      FunctionKeys.shift(shiftName, Keys.widths.rowThreeLeft),
      FunctionKeys.backspace(backspaceName, Keys.widths.rowThreeRight),
      // 最后一行两侧的两颗键在 Gboard 上都是胶囊：左边 ?123、右边回车。
      // switchKeyboard 默认给的是小圆角的灰键，这里把角色覆盖成 pill。
      FunctionKeys.switchKeyboard(
        numericName, '?123', 'numeric', Keys.widths.rowFourPillLeft { role: 'pill' }
      ),
      FunctionKeys.space(spaceName),
      FunctionKeys.enter(enterName, Keys.widths.rowFourPillRight),
    ]),
}
