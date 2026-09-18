// 会上屏的米键（字母 / 数字 / 符号 / 标点）与它们的宽度表。
//
// 数字、符号两种键盘的骨架完全一样——四行、前两行十键、
// 第三行是「一颗沙键 + 七颗米键 + 删除」、第四行是「返回 + 标点 + 12·34 + 空格 + 标点 + 回车」——
// 所以宽度表与键构造器都收在这里，键盘文件里只剩下「哪一行放哪些字」这张表。
// 拼音键盘走的是另一套版面（见 Keyboards/iPhonePinyin.libsonnet），它的宽度写在自己那边，
// 但字母键、标点键的构造器仍然复用这里的。
local Fonts = import '../Constants/Fonts.libsonnet';
local Button = import 'Button.libsonnet';

// ===== 宽度表 =====
// 统一按 1125 的虚拟设计宽度分配，一行内所有分子加起来正好 1125 就铺满；
// 不写 size 的键（空格）自动吃掉剩余宽度。
//
//   第一 / 二行  10 × 112.5                                  = 1125
//   第三行       168.75 + 7 × 112.5 + 168.75                  = 1125
//   第四行       205 + 112.5 + 112.5 + 377.5 + 112.5 + 205     = 1125
//
// 行首 / 行尾的宽键用 size 取触摸宽、bounds 取绘制宽：触摸区一直延伸到屏幕边缘，
// 显示区仍与其余键对齐，边缘键因此更好按。
local widths = {
  // 普通米键
  unit: { size: { width: '112.5/1125' } },

  // 第三行两侧（切页键 / 删除）：显示区几乎占满触摸区
  rowThreeLeft: { size: { width: '168.75/1125' }, bounds: { width: '152/168.75', alignment: 'left' } },
  rowThreeRight: { size: { width: '168.75/1125' }, bounds: { width: '152/168.75', alignment: 'right' } },

  // 第四行两端：左边是「返回」、右边是回车。它们比一颗普通键宽出一截，
  // 触摸格（205）又比显示格（192）再宽 13 个单位，让触摸区一直延伸到屏幕边缘。
  rowFourSideLeft: { size: { width: '205/1125' }, bounds: { width: '192/205', alignment: 'left' } },
  rowFourSideRight: { size: { width: '205/1125' }, bounds: { width: '192/205', alignment: 'right' } },

  // 九键那一行的首尾两颗：把触摸区补到屏幕边缘，显示区不变
  homeRowLeft: { size: { width: '168.75/1125' }, bounds: { width: '112.5/168.75', alignment: 'right' } },
  homeRowRight: { size: { width: '168.75/1125' }, bounds: { width: '112.5/168.75', alignment: 'left' } },
};

local keyName(id) = id + 'Button';

// 一颗普通米键：主标签 +（可选）右上角角标，角标上划即出。
//   id         按键名前缀。必须是 ASCII 标识符——符号键盘上的 " 、 ' 各出现两次，
//              直接拿字符当名字会撞车，所以名字与字符分开写。
//   character  上屏的字符，同时是默认的键面文字
//   swipe      上划符号，省略则不带角标也不能上划
//   label      键面显示的字，省略时就是 character 本身
local charKey(id, character, swipe=null, label=null, fontSize=Fonts.keyLabel, opts={}) =
  Button.new(keyName(id), {
    role: 'letter',
    label: { text: if label == null then character else label },
    labelFontSize: fontSize,
    action: { character: character },
  } + (
    if swipe == null then {} else {
      badge: { text: swipe },
      swipeUpAction: { character: swipe },
    }
  ) + opts);

// 一颗字母键的长按面板：三格，角标（数字 / 符号）+ 小写 + 大写。
//
// **角标一定落在默认高亮的那一格**，也就是 Button.anchorCol 按键位算出来的那一格：
// 手指一按下去，底下亮着的就是这颗键右上角标着的那个字符，抬手即出，与上划同结果。
// 剩下两格里，大写排到离角标**最远**的一端，小写填中间：
//
//   角标在最左（q w a）  →  1 q Q
//   角标居中（e r t y u i）→  E 3 e
//   角标在最右（o p l）  →  O o 9
//
// 角标居中时两端离得一样远，谁排左边是自由选择，默认把大写放左边；
// 个别键要反过来（小写在左）就传 upperFirst=false。
local letterLongPress(character, swipe, badgeIndex, upperFirst) =
  local upper = std.asciiUpper(character);
  if badgeIndex <= 0 then [swipe, character, upper]
  else if badgeIndex >= 2 then [upper, character, swipe]
  else if upperFirst then [upper, swipe, character]
  else [character, swipe, upper];

// 一颗字母键：比 charKey 多了大小写、短按气泡与长按符号网格。
// 气泡里是大写字母，右上角重复一次上划符号。
//
//   anchor      这颗键中心占键盘宽的比例，既定长按面板默认高亮哪一格，
//               也定角标排在三格里的哪一格——两处用的是同一个 Button.anchorCol，不会走岔
//   upperFirst  角标居中时大写排左边（默认）还是右边
local letterKey(character, swipe, anchor, upperFirst=true, opts={}) =
  local upper = std.asciiUpper(character);
  Button.new(keyName(character), {
    role: 'letter',
    label: { text: character },
    uppercasedLabel: { text: upper },
    badge: { text: swipe },
    hint: { label: { text: upper }, swipeUp: { text: swipe } },
    longPress: letterLongPress(character, swipe, Button.anchorCol(anchor, 3), upperFirst),
    longPressAnchor: anchor,
    action: { character: character },
    uppercasedStateAction: { character: upper },
    swipeUpAction: { character: swipe },
  } + opts);

// 一颗沙色标点键（第四行的 , 。 < >）：会上屏，但归到功能键那一档——
// 它们是版面上的分隔物，颜色跟着两侧的功能键走，整行才不至于被米色切成碎块。
// labelOpts 补在键面文字的外观上（要与相邻的标点同高时靠它传 center）。
local punctuationKey(id, character, label=null, opts={}, labelOpts={}) =
  Button.new(keyName(id), {
    role: 'function',
    label: { text: if label == null then character else label } + labelOpts,
    labelFontSize: Fonts.keyLabel,
    action: { character: character },
  } + opts);

{
  widths: widths,
  keyName: keyName,
  charKey: charKey,
  letterKey: letterKey,
  punctuationKey: punctuationKey,
}
