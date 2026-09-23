local Style = import 'Style.libsonnet';

// 分体键盘（Split）：机制与约束见 docs/键盘Split状态.md，具体数值参考
// Skins/default/jsonnet/Components/Split.libsonnet 与 Skins/hamster 的同名文件——
// 三份皮肤字母键的行结构完全一样（10 键行 / 9 键带宽边行），宽度表可以直接照搬。
//
// Gboard 特有的地方：拼音 / 数字 / 符号三页共用同一套「10-10(或9)-9-底部」骨架
// （见 Components/Keys.libsonnet 顶部的说明），所以这里只留**一套**标准宽度表，
// 三个 Keyboards 文件各自只需要补一张「底部行」专属的表（三页底部行的键位都不一样）。
// 九宫格数字键盘（NumberPad）形状完全不同，走单独一张表，见文件末尾。
//
// ===== 三条硬约束（抄自 default，务必遵守）=====
// 1. 不新增布局文件、不改变合并态的树形状：分体只用的键（中缝、留白、复制键）必须
//    平时就在树上、宽度写 0；本皮肤里这些键只出现在「分体可用」的 keyboardLayout
//    分支里（iPhone 横屏 + iPad），iPhone 竖屏走另一份不带这些键的 layout，两者互不影响。
// 2. 不改键盘总高度：split 覆盖块够不着 keyboardHeight。
// 3. 每一行的分体宽度必须自平：本文件每张表下面都记了账。

// ===== 表一：10 键行（数字/符号行、拼音的 q-p 行）=====
// 8 + 5×79.2 + 317 + 5×79.2 + 8 = 1125
local row10 = {
  margin: '8/1125',
  unit: '79.2/1125',
  gap: '317/1125',
};

// ===== 表二：9 键行，两端带宽触摸区（拼音 asdfghjkl 行）
//        或两端是灰键（shift/backspace 那一行、数字符号页的功能键+标点行）=====
// 两种情况数值相同，因为都是「7 个普通位 + 2 个两端宽位」的骨架：
//   8 + 99 + 4×79.2 + 277.4 + 79.2 + 3×79.2 + 99 + 8 = 1125
// （左半：宽位 + 4 个普通位；中缝挟带一颗复制键；右半：3 个普通位 + 宽位）
local nineKeyRow = {
  margin: '8/1125',
  unit: '79.2/1125',
  side: '99/1125',
  sideVisibleFraction: '4/5',
  bottomGap: '277.4/1125',
};

// 分体态下把这颗键收成 0 宽——它在分体版面里没有位置。合并态不受影响。
local hidden = { split: { size: { width: 0 } } };

// 分体态下这颗键占多宽。
local width(value) = { split: { size: { width: value } } };

// 分体态下这颗键占多宽，同时把 bounds.width 复位成 1/1，关掉「触摸区宽于显示区」
// 的技巧（该技巧按合并态的触摸宽标定，分体后原样保留会让显示区跟着变窄）。
local widthNoClip(value) = { split: { size: { width: value }, bounds: { width: '1/1' } } };

// 分体态下这颗键占多宽，且显示区只占其中 visibleFraction、贴 alignment 那一侧。
local widthAnchored(value, visibleFraction, alignment) =
  { split: { size: { width: value }, bounds: { width: visibleFraction, alignment: alignment } } };

// 平时 0 宽、分体态撑开的实体键：中缝与两侧留白都是它。
// 必须是真实存在的样式节点（取不到样式就不建层，触摸会被吸附到最近的真键），
// 且不能有 action。
local blankBackgroundName = 'splitBlankBackgroundStyle';
local spacer(name, splitWidth) = {
  [name]: {
    backgroundStyle: blankBackgroundName,
    size: { width: 0 },
    split: { size: { width: splitWidth } },
  },
};

// ===== 九宫格数字键盘（NumberPad）=====
// 形状与其余三页完全不同（左符号条 + 中 3×3 数字格 + 右功能列，下方一整行功能键），
// 3 列的数字网格没法拆成左右两个「有意义」的分体半区——把网格劈开只会让数字东倒西歪，
// 反而更难点。这里采用保守方案：**不改动符号条/数字网格/功能列内部的排布**，
// 只在整体两侧（以及底部整行两侧）加一圈分体态才撑开的留白，让键盘在分体时
// 也「往边缘让一让」而不是纹丝不动——即分体开关在这一页上仍然生效，
// 只是视觉变化很轻微，这是刻意的设计取舍，不是漏做。
//
// 分母改用 100（与 Keyboards/NumberPad.libsonnet 的 upperColumns / bottomWidths 一致）。
// 留白各占 6，其余三列 / 七个底部键按原比例等比缩小 (100-12)/100 = 0.88：
//   上块：6 + 14×0.88 + 72×0.88 + 14×0.88 + 6
//       = 6 + 12.32 + 63.36 + 12.32 + 6 = 100
//   下块：6 + 17×0.88 + 10.5×0.88 + 12×0.88 + 21×0.88 + 12×0.88 + 10.5×0.88 + 17×0.88 + 6
//       = 6 + 14.96 + 9.24 + 10.56 + 18.48 + 10.56 + 9.24 + 14.96 + 6 = 100
// 数值是 (原分数 × 0.88) 手算好的结果，写成字面量避免浮点乘法产生的舍入噪声。
local numberPadMargin = '6/100';
local numberPadUpper = {
  left: '12.32/100',
  center: '63.36/100',
  right: '12.32/100',
};
local numberPadBottom = {
  pill: '14.96/100',
  punct: '9.24/100',
  switcher: '10.56/100',
  zero: '18.48/100',
  equal: '10.56/100',
};

{
  row10: row10,
  nineKeyRow: nineKeyRow,
  hidden: hidden,
  width: width,
  widthNoClip: widthNoClip,
  widthAnchored: widthAnchored,
  spacer: spacer,
  blankBackgroundName: blankBackgroundName,

  numberPadMargin: numberPadMargin,
  numberPadUpper: numberPadUpper,
  numberPadBottom: numberPadBottom,

  // 进出分体的手势：挂在某颗键的上划上，挂在哪颗键由各 Keyboards 文件决定。
  // 写在节点本层、不放进 split 覆盖块，所以合并态用它进分体，分体态用它再上划一次
  // 就合回去，两态共用同一个手势。
  enterSplitGesture:: { swipeUpAction: { shortcut: '#toggleSplitState' } },

  // 分体版面要用到的共享样式节点：中缝 / 留白键的底，全透明，只为了让它有图层能占住位置。
  shared:: {
    [blankBackgroundName]: Style.geometry({ normalColor: '#00000000' }),
  },
}
