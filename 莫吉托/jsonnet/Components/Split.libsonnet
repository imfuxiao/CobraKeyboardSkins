// 分体键盘（Split）：机制与约定见 docs/键盘Split状态.md 与
// Skins/default/jsonnet/Components/Split.libsonnet 开头的说明，这里不重复，
// 只给莫吉托自己的宽度表。
//
// - 拼音页（iPhone 与 iPad 两份）与 Noctua 的 Keyboards/iPhonePinyin.libsonnet /
//   iPadPinyin.libsonnet 逐键同构（同一套字母表、同样的「numeric/逗号/空格/中英切换/
//   enter」第四行、同样的 iPad 双标签五行全键盘），数值直接复用 Noctua 手算过的两张表。
// - numeric 页不在这里放宽度表：它是九宫格 + 符号面板的双栏布局（VStack 分栏），
//   宽屏场景（iPhone 横屏 / iPad 两个方向）本来就已经是「数字区 + 符号面板」左右两半
//   夹一条中缝，分体态只需要把中缝撑宽、两个半区相应收窄，直接在
//   Keyboards/Numeric.libsonnet 自己的列宽表上加 split 覆盖块即可，不需要这里的通用
//   spacer 机制（中缝本来就是一个实体、非零宽的空白列，不是「平时零宽分体态撑开」的
//   那种键，不适用 spacer() 的语义）。
local Style = import 'Style.libsonnet';

// ===== iPhone 拼音页（denom 1125）=====
// 第一~三行（qwertyuiop / asdfghjkl / zxcvbnm + shift + backspace）跟 Noctua 逐键同构：
//   第一行     8 + 5×79.2 + 317 + 5×79.2 + 8                    = 1125
//   第二/三行  8 + 99 + 4×79.2 + 277.4 + 79.2 + 3×79.2 + 99 + 8  = 1125
// 第四行（numeric/逗号/空格/中英切换/enter）与 Noctua 的设计（本身照抄 hamster）
// 完全一致：
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
// 与 Noctua 的 iPadPinyin 逐键同构（同一套数字行 / 字母 / 标点 / 功能键位置，包括
// 「backspace 挂第一行、分体后第一行连同 backspace 整个消失，靠第四行补一颗
// backspaceRight」与「enter 挂第三行、第五行另补一颗 enterRight」两处设计），
// 数值直接复用。
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

// 分体态下把这颗键收成 0 宽——它在分体版面里没有位置。合并态不受影响。
local hidden = { split: { size: { width: 0 } } };

// 分体态下这颗键占多宽。
local width(value) = { split: { size: { width: value } } };

// 分体态下这颗键占多宽，且视觉区只占其中 visibleFraction、贴 alignment 那一侧显示——
// 用在两端「触摸区补到屏幕边缘」的键（a/l、shift/backspace）。
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
  hidden: hidden,
  width: width,
  widthAnchored: widthAnchored,
  spacer: spacer,
  blankBackgroundName: blankBackgroundName,

  // 进出分体的手势：挂在某颗键的上划上（iPad 挂 Tab，iPhone 挂 Shift），
  // 写在节点本层、不放进 split 块，合并 / 分体两态共用同一个手势。
  enterSplitGesture:: { swipeUpAction: { shortcut: '#toggleSplitState' } },

  // 分体版面要用到的共享样式节点：中缝 / 留白键的透明底。
  shared:: {
    [blankBackgroundName]: Style.geometry({ normalColor: '#00000000' }),
  },
}
