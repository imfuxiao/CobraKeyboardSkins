// 分体键盘（Split）：机制与约定见 docs/键盘Split状态.md 与
// Skins/default/jsonnet/Components/Split.libsonnet 开头的说明，这里不重复，
// 只给胭云自己的宽度表。
//
// - 拼音页（iPhone 与 iPad 两份）跟 Skins/Noctua 的拼音页逐键同构（第一~三行同样的
//   qwertyuiop / asdfghjkl / zxcvbnm + shift + backspace，第四行同样的
//   numeric/逗号/空格/中英切换/enter；iPad 版同样的双标签数字行 + 三行字母 + 标点 +
//   底行，backspace 挂第一行、enter 挂第三行），数值直接复用 Noctua 手算过的两张表。
// - numeric 页是九宫格数字键盘（VStack 分五列：符号列表+#+=、三列数字+功能键、
//   分类符号面板），不是字母行结构，跟 iPhone 拼音页不同构。分体没有天然的
//   「左右两半」意义，采用与 Gboard/Noctua 的 numberPad 相同的保守方案：内部排布
//   完全不变，只在整块两侧各让出一圈分体态才撑开的窄边。
local Style = import 'Style.libsonnet';

// ===== iPhone 拼音页（denom 1125）=====
// 第一~三行跟 Noctua 的 iPhonePinyin 逐键同构，数值直接沿用：
//   第一行     8 + 5×79.2 + 317 + 5×79.2 + 8                  = 1125
//   第二/三行  8 + 99 + 4×79.2 + 277.4 + 79.2 + 3×79.2 + 99 + 8 = 1125
// 第四行（numeric/逗号/空格/中英切换/enter）与合并态比例（20% / 10% / auto / 10% /
// 20%）完全一致，照抄 Noctua 那份设计：
//   第四行  8 + 126 + 80 + 190 + 317 + 190 + 80 + 126 + 8 = 1125
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
// 与 Noctua 的 iPadPinyin 逐键同构（同一套数字行 / 字母 / 标点 / 功能键位置，
// 包括「backspace 挂在第一行、分体后第一行连同 backspace 整个消失，靠第四行
// 补一颗 backspaceRight」与「enter 挂在第三行、第五行另补一颗 enterRight」这两处
// 设计），数值直接复用 Noctua 手算过的这张表。
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

// ===== numeric（denom 100，跟 wideLayout 的 half/gap 列同一套分母）=====
// 只在双栏（symbolPanel=true，即 iPhone 横屏与 iPad 全部方向，正好是 Split 可用的
// 场景）时接入：两侧各让出一圈窄边，两个 half 列各让 2 份出来，gap 列不动：
//   2 + 43 + 10 + 43 + 2 = 100（原 45/10/45，两个 half 列各让 2 给两侧窄边）
local numericWidths = {
  margin: '2/100',
  halfSplit: '43/100',
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
  numericWidths: numericWidths,
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
