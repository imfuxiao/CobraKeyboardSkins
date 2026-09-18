// iPhone 26 键拼音键盘 —— 版面照「彩虹」那一套，不是 Gboard 那一套。
//
// 四行：
//   q w e r t y u i o p        每颗右上角带 1~0 的角标，上划即出
//   a s d f g h j k l          九键，首尾两颗把触摸区补到屏幕边缘
//   ⇧ z x c v b n m ⌫         两端是棕色键
//   123  ,  空格  中英  ⏎      空格上写的是当前方案名
//
// 与 Gboard 版拼音的差别就在第四行：那边是「?123 ☺/, 空格 。 ⏎」，把中英切换塞在
// 空格的上划手势里；「彩虹」这一套给中英切换留了一颗独立的键，代价是少一颗句号键
// ——句号挪到逗号键的上划上。本皮肤按需求取后者。
//
// 整个键盘由下面几张表描述，加键、改上划符号、调宽度都只动表，不动代码。
local FunctionKeys = import '../Components/FunctionKeys.libsonnet';
local Keys = import '../Components/Keys.libsonnet';
local Layout = import '../Components/Layout.libsonnet';
local Preedit = import '../Components/Preedit.libsonnet';
local Style = import '../Components/Style.libsonnet';
local Theme = import '../Components/Theme.libsonnet';
local Toolbar = import '../Components/Toolbar.libsonnet';
local Metrics = import '../Constants/Metrics.libsonnet';

local rowCount = 4;

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
//   第一行 10 × 112.5                              = 1125
//   第二行 168.75 + 7 × 112.5 + 168.75              = 1125
//   第三行 168.75 + 7 × 112.5 + 168.75              = 1125
//   第四行 225 + 112.5 + 空格 450 + 112.5 + 225     = 1125
local widths = {
  // 第四行。123 与回车比中间三颗宽一倍，这一行才压得住。
  numeric: { size: { width: '225/1125' } },
  comma: { size: { width: '112.5/1125' } },
  asciiMode: { size: { width: '112.5/1125' } },
  enter: { size: { width: '225/1125' } },
};

// ===== 每颗键的横向位置 =====
// 长按面板默认高亮哪一格、角标排在三格里的哪一格，都看这颗键的中心占键盘宽的比例
// （见 Components/Button.libsonnet 的 anchorCol）。
// 三行字母都是 10 格宽的网格，差别只在行首让出多少：
//   第一行顶格；第二行九键居中，两头各让半格；第三行让出一颗宽键（168.75/1125 = 0.15）。
//
// 注意取的是**显示区**的中心而不是触摸区的：第二、三行两端的键触摸区伸到屏幕边，
// 显示区仍与其余键对齐，按显示区算长按面板才不会偏。
local rowLeftOffset = [0, 0.05, 0.15];
local letterCenter(row, col) = rowLeftOffset[row] + (col + 0.5) / 10;

// 第二行只有九键，首尾两颗加宽触摸区（显示区不变）
local homeRowExtras = {
  a: Keys.widths.homeRowLeft,
  l: Keys.widths.homeRowRight,
};
local letterExtras(letter) =
  if std.objectHas(homeRowExtras, letter) then homeRowExtras[letter] else {};

// 角标居中的那一档，默认排成「大写 角标 小写」。这里列的几颗反过来排成「小写 角标 大写」。
local lowerFirstLetters = ['v'];

local shiftName = 'shiftButton';
local backspaceName = 'backspaceButton';
local numericName = 'numericButton';
local commaId = 'comma';
local commaName = Keys.keyName(commaId);
local spaceName = 'spaceButton';
local asciiModeName = 'asciiModeButton';
local enterName = 'enterButton';

// 逗号键的长按备选：中文里常用的那几个全角标点。
// 第一个就是键面上写的那个——长按后直接抬手，上屏的与点按一致
// （区别只在长按走的是全角，点按是半角交给输入方案转）。
local commaLongPress = ['，', '、', '；', '：', '“', '”'];

// 这颗键站在第四行第二格，横向位置与第一行的 e 差不多，长按面板的锚点直接借它的，
// 写成同一个式子，改行首偏移时两边一起动。
local commaAnchor = letterCenter(0, 2);

// 逗号键：点按上逗号，上划上句号。「彩虹」那一套第四行没有单独的句号键，
// 句号就挂在这颗键的上划上，角标写的正是它。
//
// **键面写全角、上屏半角。** 键面上下两个字都是全角的「。」「，」，送出去的却是半角的
// '.' ','，中文状态下由输入方案转成全角——与 Gboard 那套句号键是同一个做法。
// 这样做的理由是键面要跟中文标点看齐（半角逗号在一颗中文键上显得瘦小、位置也偏），
// 而上屏交给方案转，英文状态下仍然出半角，不会写中文时对、写英文时错。
//
// 这颗键的角标**横向居中**，不走 Metrics.key.badgeCenter 那个右上角的位置：
// 字母键的角标是挤在一个填满键面的字母旁边，靠边站才不打架；这颗键的两个标点都只是
// 蹲在全角框左下角的一个小点，角标再顶到右上角，两个小点各站一边，
// 读不出「上划出这个」这层关系。横向对齐之后句号就正落在逗号上方，一竖列两个标点，
// 一眼看得出是一对。
//
// ===== 两个标点为什么真的在键的正中 =====
// 全角标点的墨迹缩在方框的左下角，行盒摆正了看着却偏左——「，」在 22.5pt 下要偏出
// 7.4pt，在一颗 39pt 宽的键上一眼就看得出不在中间。这一档偏心由 Button 的 inkOffsets
// 按字号折成 insets 反向补掉，所以这里两处都给 center.x = 0.5，
// 出来的是**墨迹**落在键的横向正中，不是行盒落在正中——上下两个标点因此既彼此对齐，
// 也与按键中心对齐。主标签与角标的字号不同（22.5 / 9.5），补偿各按各的字号算，不受影响。
//
// 注意「。」与「，」的补偿值**不一样**（-0.275em / -0.331em）：两者缩在方框里的
// 程度差 0.056em，共用一个值的话逗号会比句号偏左约 1.3pt。见 Button 的 inkOffsets。
local commaCenterX = 0.5;

local commaKey = Keys.punctuationKey(
  commaId, ',', '，',
  widths.comma {
    badge: { text: '。', center: { x: commaCenterX, y: 0.25 } },
    swipeUpAction: { character: '。' },
    longPress: commaLongPress,
    longPressAnchor: commaAnchor,
  },
  { center: { x: commaCenterX, y: 0.5 } }
);

local keyboardLayout = [
  Layout.row([Keys.keyName(entry[0]) for entry in letterRows[0]]),
  Layout.row([Keys.keyName(entry[0]) for entry in letterRows[1]]),
  Layout.row([shiftName] + [Keys.keyName(entry[0]) for entry in letterRows[2]] + [backspaceName]),
  Layout.row([numericName, commaName, spaceName, asciiModeName, enterName]),
];

{
  // isPortrait  竖屏 / 横屏。两者只影响键盘高度与按键间距，布局完全相同。
  new(isPortrait=true)::
    local orientation = if isPortrait then 'portrait' else 'landscape';
    local insets = Metrics.keyInsets.iPhone[orientation];
    local keysHeight = Metrics.height('iPhone', orientation, rowCount);

    Style.merge([
      Preedit.new(),
      Toolbar.new(),
      Theme.shared(insets, keysHeight),
      {
        keyboardHeight: keysHeight,
        keyboardStyle: {
          backgroundStyle: Theme.keyboardBackgroundName,
          // 按键区整体的左右边距，与键间距是两回事，见 Metrics.keyboardAreaInsets
          insets: Metrics.keyboardAreaInsets.iPhone[orientation],
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
      commaKey,
      FunctionKeys.shift(shiftName, Keys.widths.rowThreeLeft),
      FunctionKeys.backspace(backspaceName, Keys.widths.rowThreeRight),
      FunctionKeys.numeric(numericName, widths.numeric),
      FunctionKeys.space(spaceName),
      FunctionKeys.asciiMode(asciiModeName, widths.asciiMode),
      FunctionKeys.enter(enterName, widths.enter),
    ]),
}
