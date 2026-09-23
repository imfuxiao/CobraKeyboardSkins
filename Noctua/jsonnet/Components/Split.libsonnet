// 分体键盘（Split）：机制与约定见 docs/键盘Split状态.md 与
// Skins/default/jsonnet/Components/Split.libsonnet 开头的说明，这里不重复，
// 只给 Noctua 自己的宽度表。
//
// - 拼音页（iPhone 与 iPad 两份）与 default 的 iPhonePinyin / iPadPinyin 逐键同构，
//   数值直接复用 default 手算过的那两张表。
// - numeric / noctuaSymbolic 两页第一~三行与 iPhone 拼音页同构（10 键 / 10 键 /
//   切页键+7 米键+删除），复用同一张 iPhoneWidths；第四行按钮不同，自行设计。
// - numberPad 是九宫格，分体没有天然的「左右两半」意义，采用保守方案：
//   内部排布不变，只在上下两块两侧各留一圈分体态才撑开的窄边。
local Style = import 'Style.libsonnet';

// ===== iPhone 拼音页（denom 1125）=====
// 第一~三行跟 default 的 iPhonePinyin 逐键同构（同样的 qwertyuiop / asdfghjkl /
// zxcvbnm + shift + backspace），数值直接沿用：
//   第一行     8 + 5×79.2 + 317 + 5×79.2 + 8                  = 1125
//   第二/三行  8 + 99 + 4×79.2 + 277.4 + 79.2 + 3×79.2 + 99 + 8 = 1125
// 第四行（numeric/逗号/空格/中英切换/enter）与 hamster 皮肤的第四行键位、
// 合并态比例（20% / 10% / auto / 10% / 20%）完全一致，照抄 hamster 那份设计：
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
// 与 default 的 iPadPinyin 逐键同构（同一套数字行 / 字母 / 标点 / 功能键位置，
// 包括「backspace 挂在第一行、分体后第一行连同 backspace 整个消失，靠第四行
// 补一颗 backspaceRight」与「enter 挂在第三行、第五行另补一颗 enterRight」这两处
// 设计），数值直接复用 default 手算过的这张表。
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

// ===== numeric / noctuaSymbolic（denom 1125）=====
// 第四行（返回 / 逗号或< / 12·34 / 空格 ‖ 空格 / 句号或> / 回车）照 default 的规矩：
// **左右两半各自与上面几行同宽**（8 + 396 = 404），中缝沿用第一行的 gap，
// 于是左半空格的右边缘贴着 5 的右边缘、右半空格的左边缘贴着 6 的左边缘。
// 左半比右半多一颗 12·34，多出的 80 只能从左半空格里扣，两颗空格因此不等宽：
//   左半  8 + 126 + 80 + 80 + 110 = 404
//   右半  190 + 80 + 126 + 8      = 404
//   整行  404 + 317 + 404         = 1125
local numericWidths = {
  side: '126/1125',  // 返回 / 回车，与拼音页 123 / 回车同宽
  small: '80/1125',  // 逗号(或<) / 12·34 / 句号(或>)
  spaceLeft: '110/1125',
  spaceRight: '190/1125',
  gap: '317/1125',
  margin: '8/1125',
};

// ===== numberPad（denom 100）=====
// 九宫格分体没有天然的「左右两半」意义，采用保守方案：内部排布完全不变，
// 只在上块三列两侧、下块一行两端各让出一圈分体态才撑开的窄边。
// 上下两块的窄边**必须一样宽**，否则上块与下块的左右外沿错开一截：
//   上块  2 + 12 + 72 + 12 + 2   = 100（原 14/72/14，两侧窄列各让 2 给窄边）
//   下块  2 + 15 + 10.5 + 12 + 21 + 12 + 10.5 + 15 + 2 = 100（原 17/…/17，两端各让 2）
local numberPadWidths = {
  upperMargin: '2/100',
  upperNarrow: '12/100',  // 原 14/100
  bottomMargin: '2/100',
  bottomSide: '15/100',  // 原 17/100
};

// 分体态下把这颗键收成 0 宽——它在分体版面里没有位置。合并态不受影响。
local hidden = { split: { size: { width: 0 } } };

// 分体态下这颗键占多宽。
local width(value) = { split: { size: { width: value } } };

// 分体态下这颗键占多宽，**同时把 bounds 复位成 1/1**。
// 合并态「触摸区宽于显示区」的键（第四行两端 192/205 那种）的 bounds 是相对自身宽度的比例，
// 分体把 size 改窄后同一个比例乘在更窄的宽度上，显示出来会比同宽的邻键瘦一圈。
// 对没有 bounds 的键这是无操作。
local widthNoClip(value) = { split: { size: { width: value }, bounds: { width: '1/1' } } };

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
  numberPadWidths: numberPadWidths,
  hidden: hidden,
  width: width,
  widthNoClip: widthNoClip,
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
