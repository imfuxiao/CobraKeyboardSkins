// 分体键盘（Split）：机制与约定见 docs/键盘Split状态.md 与
// Skins/default/jsonnet/Components/Split.libsonnet 开头的说明，这里不重复，
// 只给「彩虹」自己的宽度表。
//
// - 拼音页（iPhone 与 iPad 两份）与 Noctua 的 iPhonePinyin / iPadPinyin 逐键同构
//   （Noctua 那一版本身就是照抄「彩虹」的版面写的，字母行、第四行、iPad 双标签行
//   一一对应），数值直接复用 Noctua 手算过的两张表。
// - numeric 页是「彩虹」独有的九宫格 + 侧边分类符号面板布局（VStack 分五列），
//   跟 Gboard/Noctua 那种「四行 QWERTY 数字页」完全不是一回事，宽度表要单独设计。
local Style = import 'Style.libsonnet';

// ===== iPhone 拼音页（denom 1125）=====
// 与 Noctua iPhonePinyin 逐键同构，数值原样复用：
//   第一行     8 + 5×79.2 + 317 + 5×79.2 + 8                   = 1125
//   第二/三行  8 + 99 + 4×79.2 + 277.4 + 79.2 + 3×79.2 + 99 + 8 = 1125
//   第四行     8 + 126 + 80 + 190 + 317 + 190 + 80 + 126 + 8    = 1125
local iPhoneWidths = {
  unit: '79.2/1125',
  margin: '8/1125',
  gap: '317/1125',
  side: '99/1125',
  sideVisibleFraction: '4/5',
  bottomGap: '277.4/1125',
  keyboardType: '126/1125',  // 第四行两端：numeric / enter
  smallKey: '80/1125',  // 第四行内侧：comma / asciiMode
  space: '190/1125',  // 第四行空格，左右各一颗
};

// ===== iPad 拼音页（denom 16）=====
// 与 Noctua iPadPinyin 逐键同构（同一套数字行 / 字母 / 标点 / 功能键位置），
// 数值原样复用。
local iPadWidths = {
  unit: '1/16',
  pad: '0.9/16',
  padHome: '1.4/16',
  gapTop: '4.2/16',
  gapHome: '3.2/16',
  gapBottom: '3.2/16',
  gapSpace: '4.2/16',
  tab: '0.9/16',
  shift: '1.5/16',
  backspace: '1.5/16',
  globe: '1.5/16',
  keyboardType: '1.9/16',
  space: '2.5/16',
  enter: '1.9/16',
  dismiss: '1.5/16',
};

// ===== numeric 页（denom 100，与 Keyboards/Numeric.libsonnet 的列宽同一套分母）=====
//
// 这一页是九宫格数字 + 侧边分类符号面板的「双栏」布局（VStack 分左右两个 45/100
// 的半屏，中间留 10/100 的缝），不是一排排键，没有天然的「拆成左右两半各拿一部分
// 键位」这种分法——本来就已经是左右两半了，左边数字、右边符号，硬拆没有意义。
//
// 采用与 numberPad 同一套保守方案：两个半屏内部排布完全不动，只在整行最外侧
// （左半屏最左边、右半屏最右边）各加一圈分体态才撑开的窄边，两个半屏因此各让出
// 同样的宽度给外侧留白，中间的 gap 不动：
//   3 + 42 + 10 + 42 + 3 = 100（原 45/10/45，两个半屏各让 3 给外侧留白）
//
// 注：只有 symbolPanel=true（双栏）的场景会读到 Split，config.yaml 里唯一的单栏
// 场景是 iPhone 竖屏，本来就不支持 Split，不必为单栏布局另设一张表。
local numericGridWidths = {
  margin: '3/100',
  half: '42/100',
};

// 分体态下把这颗键收成 0 宽——它在分体版面里没有位置。合并态不受影响。
local hidden = { split: { size: { width: 0 } } };

// 分体态下这颗键占多宽。
local width(value) = { split: { size: { width: value } } };

// 分体态下这颗键占多宽，且视觉区只占其中 visibleFraction、贴 alignment 那一侧显示——
// 用在第二 / 三行两端那些「触摸区补到屏幕边缘」的键（a/l、shift/backspace）。
local widthAnchored(value, visibleFraction, alignment) =
  { split: { size: { width: value }, bounds: { width: visibleFraction, alignment: alignment } } };

// 平时 0 宽、分体态撑开的实体键：中缝与两侧留白都是它。
// 必须是真实存在的样式节点、且不能有 action（见 docs/键盘Split状态.md 2.3），
// 否则落在缝上的触摸会被吸附到最近的真键，中缝两侧成片误触。
//
// 同一个节点既能当 HStack 里的 Cell 样式（行内留白 / 中缝），也能当 VStack 的
// style（列宽）+ 里面唯一那颗 Cell 的样式（列内留白）——两种上下文只是分别读
// 这份节点的 size / split 字段，互不冲突。
local blankBackgroundName = 'splitBlankBackgroundStyle';
local spacer(name, splitWidth) = {
  [name]: {
    backgroundStyle: blankBackgroundName,
    size: { width: 0 },
    split: { size: { width: splitWidth } },
  },
};

{
  iPhoneWidths: iPhoneWidths,
  iPadWidths: iPadWidths,
  numericGridWidths: numericGridWidths,
  hidden: hidden,
  width: width,
  widthAnchored: widthAnchored,
  spacer: spacer,
  blankBackgroundName: blankBackgroundName,

  // 进出分体的手势：挂在某颗键的上划上，由调用方决定挂在哪颗键。
  // 写在节点本层、不放进 split 块，所以合并态用它进分体，分体态用它再上划一次
  // 就合回去，两态共用同一个手势，不需要另开一颗「点一下合回去」的按钮。
  enterSplitGesture:: { swipeUpAction: { shortcut: '#toggleSplitState' } },

  // 分体版面要用到的共享样式节点：中缝 / 留白键的透明底。
  shared:: {
    [blankBackgroundName]: Style.geometry({ normalColor: '#00000000' }),
  },
}
