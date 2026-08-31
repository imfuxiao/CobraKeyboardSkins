// 「彩虹」色板 —— 全皮肤唯一的色值来源。
//
// 色值抄自 ../../README.md 的「一 主色板」「文字色」「三 深色模式」三张表，
// 改色时请两处同步（README 是给人看的说明，本文件是给编译器用的定义）。
//
// 与「莫吉托」「胭云」两套单色阶皮肤的区别：那两套是一条深浅渐变，
// 十几个色各写各的；本皮肤是**十档色相**，每一档都要配齐「纯色底 / 淡彩底 /
// 白键上的细线 / 字色」四五种衍生色，手写就是四十多个十六进制，抄错一位很难看出来。
// 所以这里只写十档色相的原色（每档一对 { light, dark }），衍生色一律按规则算出来，
// 规则写在下面 hue() 里，与 README「五 配色使用原则」一一对应。
//
// 每个色都是一对 { light, dark }：上层代码只写色名，
// 由 Components/Style.libsonnet 的 resolve() 在生成浅色 / 深色文件时二选一。
// 因此除本文件外，任何地方都不需要关心「现在是深色还是浅色」。

// ===== 色值运算 =====
// 只用到 std.codepoint / std.format 这类最老的内置函数，手机上的 jsonnet 也吃得下。
local hexVal(c) =
  local n = std.codepoint(std.asciiUpper(c));
  if n >= 65 then n - 55 else n - 48;
local channel(hex, i) = hexVal(hex[1 + i * 2]) * 16 + hexVal(hex[2 + i * 2]);
local byte(v) = std.format('%02X', std.max(0, std.min(255, std.round(v))));

// 两色按比例混合，t=0 全取 a，t=1 全取 b
local mix(a, b, t) = '#' + std.join('', [byte(channel(a, i) * (1 - t) + channel(b, i) * t) for i in [0, 1, 2]]);

local BLACK = '#000000';
local WHITE = '#FFFFFF';

local pair(light, dark) = { light: light, dark: dark };
// 混合一对色：浅色向 lightTarget 走，深色向 darkTarget 走
local mixPair(c, lightTarget, darkTarget, tLight, tDark) = pair(
  mix(c.light, lightTarget, tLight),
  mix(c.dark, darkTarget, tDark)
);
// 加重：浅色模式向黑压，深色模式向白提。两边都是「离底板更远一档」。
local press(c) = mixPair(c, BLACK, WHITE, 0.12, 0.12);

// 感知亮度（0~255），权重用 sRGB 那一组经验值
local luma(hex) = 0.299 * channel(hex, 0) + 0.587 * channel(hex, 1) + 0.114 * channel(hex, 2);

// 把一个色调到指定亮度：太亮就向黑压，太暗就向白提，色相与彼此的关系不动。
//
// 十档色相的原色亮度差得很远（柠檬 192，靛蓝 122），当底色用没问题——键面是白的，
// 深浅差反而像织纹。但拿来当**字色**就不行了：同一行字里柠檬那颗会淡到看不清，
// 靛蓝那颗又重得发黑。所以键面字统一压到同一个亮度，十列的字看起来才一样重。
local setLuma(hex, target) =
  local l = luma(hex);
  if l <= 0 then mix(hex, WHITE, target / 255)
  else if l > target then mix(hex, BLACK, 1 - target / l)
  else mix(hex, WHITE, (target - l) / (255 - l));

// 键面字的目标亮度。浅色模式压到 130（白键上够黑），深色模式提到 170（石色键上够亮）。
local inkLuma = { light: 130, dark: 170 };

// ===== 中性色 =====
// 取自表带的白色尼龙与表壳的星光色：底板略灰、键面近白、字是带紫调的墨。
local weave = pair('#E9E6EF', '#15141A');  // 织白，键盘底板
local cloud = pair('#FCFBFE', '#272430');  // 云白，主键面
local paper = pair('#F5F3F9', '#2E2A38');  // 纸白，空格
local graphite = pair('#332E40', '#443E56');  // 墨，最低频的功能键
local inkFace = pair('#413B4F', '#E4DFEE');  // 白键面上的字

// ===== 十档色相 =====
// 每一档只写原色，其余按下面的规则派生。
//
//   base          纯色功能键的底色，就是原色本身
//   basePressed   纯色键按下：加重一档
//   pale          淡彩键的底色：云白里掺两成色相
//   palePressed   淡彩键按下：色相再掺三成
//   rim           白键的彩色下边缘，是这套皮肤的「织纹」
//   face          白键按下时透出的淡彩
//   chroma        这一列的「字色」：色相调到统一亮度，见上面的 setLuma
//   ink           白键上的字，就是 chroma——键面字与角标同色
//   badge         角标（上划符号），同样是 chroma
//   inkDeep       白键按下时的字 / 淡彩键上的字：在 chroma 上再重一档
//   stone         墨色功能键的底色：墨里掺一成半色相，深色块也跟着竖条纹走
//   stonePressed  同上，加重一档
local hue(light, dark) =
  local c = pair(light, dark);
  // 一颗键的主标签与它右上角的上划符号是同一个色：看到什么颜色的字母，
  // 上划出来的就是同一颗键上那个颜色的符号。
  local chroma = pair(setLuma(light, inkLuma.light), setLuma(dark, inkLuma.dark));
  {
    base: c,
    basePressed: press(c),
    pale: mixPair(cloud, c.light, c.dark, 0.20, 0.20),
    palePressed: mixPair(cloud, c.light, c.dark, 0.32, 0.32),
    rim: mixPair(cloud, c.light, c.dark, 0.38, 0.52),
    face: mixPair(cloud, c.light, c.dark, 0.12, 0.26),
    chroma: chroma,
    ink: chroma,
    badge: chroma,
    inkDeep: mixPair(chroma, BLACK, WHITE, 0.22, 0.18),
    stone: mixPair(graphite, c.light, c.dark, 0.15, 0.22),
    stonePressed: press(mixPair(graphite, c.light, c.dark, 0.15, 0.22)),
  };

// ===== 主色板：一条从表带左端读到右端的彩虹 =====
local hues = {
    rose: hue('#F2517A', '#B84B68'),  // 玫红，主题色
    coral: hue('#F86B4F', '#BC5643'),  // 珊瑚
    amber: hue('#F5993C', '#B87433'),  // 琥珀
    lemon: hue('#EDC13F', '#B39237'),  // 柠檬
    lime: hue('#A6CB4C', '#7E9A3E'),  // 嫩绿
    jade: hue('#4CBE7C', '#3B9060'),  // 翠绿
    aqua: hue('#3EBDD1', '#33909E'),  // 湖蓝
    azure: hue('#4098EC', '#3675B2'),  // 天蓝
    indigo: hue('#6E6BE2', '#5654AC'),  // 靛蓝
    violet: hue('#A55FDC', '#7E4CA6'),  // 紫罗兰
};

{
  // 顺序即键盘上从左到右的顺序，Colors.libsonnet 的 hueAt() 按这个顺序取色。
  order: ['rose', 'coral', 'amber', 'lemon', 'lime', 'jade', 'aqua', 'azure', 'indigo', 'violet'],
  hues: hues,

  // ===== 中性色 =====
  weave: weave,  // 键盘底板
  cloud: cloud,  // 字母 / 数字键面
  cloudPressed: pair('#F1EFF6', '#332F3E'),  // 无色相可掺时的白键按下态
  paper: paper,  // 空格
  graphite: graphite,  // 墨色功能键
  divider: pair('#DDD9E7', '#211E2A'),  // 分割线 / 白键的默认下边缘

  // ===== 文字色 =====
  // 预编辑区与候选栏是整片彩虹里唯一一段长文本，按「候选字 > 注释 > 序号」
  // 三档由重到轻排开；键盘那十个颜色一个都不进来，只有预编辑串带一点主题色。
  inkFace: inkFace,  // 候选字，也是白键面字的基色
  inkQuiet: pair('#7A7391', '#A9A2BC'),  // 候选栏注释 / 工具栏图标：比候选字轻一档
  inkFaint: pair('#A49CB6', '#8B84A0'),  // 候选序号：最轻的一档
  // 预编辑串（正在输入的拼音）：墨里掺三成玫红，与首选那颗玫红药丸遥相呼应
  inkPreedit: mixPair(inkFace, hues.rose.chroma.light, hues.rose.chroma.dark, 0.28, 0.30),
  inkOnColor: pair('#FFFFFF', '#F6F2FB'),  // 纯色键 / 墨色键上的字
  // 首选药丸上的注释与序号：同样退两档，否则一颗药丸上三样东西一样重
  inkOnColorQuiet: pair('#FFFFFFCC', '#F6F2FBCC'),
  inkOnColorFaint: pair('#FFFFFFA6', '#F6F2FBA6'),
  inkWhite: pair('#FFFFFF', '#FFFFFF'),  // 按下时的字，一律提到纯白
}
