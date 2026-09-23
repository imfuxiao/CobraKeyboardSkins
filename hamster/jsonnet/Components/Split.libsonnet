// 分体键盘（Split）：机制与约定见 docs/键盘Split状态.md 与
// Skins/default/jsonnet/Components/Split.libsonnet 开头的说明，这里不重复，
// 只给 hamster 自己的宽度表（hamster 的行结构与 default 大体相同，
// 第四行多出逗号 / 中英切换两颗键，宽度表在这一行单独设计）。
local Style = import 'Style.libsonnet';

// ===== iPad 分体态的宽度表（分母 16）=====
// hamster 的 iPad 拼音页跟 default 逐行同构（同一套字母/标点/功能键位置），
// 直接沿用 default 那份手算过的宽度表。
local w = {
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

// ===== iPhone 横屏分体态的宽度表（分母 1125）=====
//
// 第一~三行（字母 + shift/backspace）跟 default 的 iPhonePinyin 逐键同构
// （同样的 qwertyuiop / asdfghjkl / zxcvbnm + shift + backspace），数值直接沿用。
//
//   第一行  8 + 5×79.2 + 317     + 5×79.2 + 8              = 1125
//   第二/三行 8 + 99 + 4×79.2 + 277.4 + 79.2 + 3×79.2 + 99 + 8 = 1125
//
// 第四行 hamster 比 default 多两颗键（逗号、中英切换），自己设计：
// 两侧留白 margin 与中缝 gap 沿用第一行的数值（边界对齐：t/y 与第四行中缝重合），
// numeric/enter 沿用 default 的「切页键」宽度 126，逗号/中英切换给 80，
// 空格分左右各 190。
//
//   第四行  8 + 126 + 80 + 190 + 317 + 190 + 80 + 126 + 8 = 1125
local iw = {
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

local hidden = { split: { size: { width: 0 } } };
local width(value) = { split: { size: { width: value } } };
local widthAnchored(value, visibleFraction, alignment) =
  { split: { size: { width: value }, bounds: { width: visibleFraction, alignment: alignment } } };

// 平时 0 宽、分体态撑开的实体键：中缝与两侧留白都是它。必须是真实存在的样式节点、
// 且不能有 action（见 docs/键盘Split状态.md 2.3）。
local blankBackgroundName = 'splitBlankBackgroundStyle';
local spacer(name, splitWidth) = {
  [name]: {
    backgroundStyle: blankBackgroundName,
    size: { width: 0 },
    split: { size: { width: splitWidth } },
  },
};

{
  widths: w,
  iPhoneWidths: iw,
  hidden: hidden,
  width: width,
  widthAnchored: widthAnchored,
  spacer: spacer,
  blankBackgroundName: blankBackgroundName,

  // 进出分体的手势：挂在某颗键的上划上（iPad 挂 Tab，iPhone 挂 Shift），
  // 写在节点本层、不放进 split 块，合并 / 分体两态共用同一个手势。
  enterSplitGesture:: { swipeUpAction: { shortcut: '#toggleSplitState' } },

  shared:: {
    [blankBackgroundName]: { buttonStyleType: 'geometry', normalColor: '#00000000' },
  },
}
