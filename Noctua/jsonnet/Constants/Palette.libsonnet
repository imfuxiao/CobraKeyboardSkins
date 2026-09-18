// 「Noctua」色板 —— **全皮肤唯一的色值来源，改配色只需要动这一个文件**。
//
// 每个色都是一对 { light, dark }：上层代码一律只写色名，
// 由 Components/Style.libsonnet 的 resolve() 在生成 light/ 与 dark/ 文件时二选一。
// 因此除本文件外，任何地方都不需要关心「现在是深色还是浅色」。
//
// 色值取自 ../../资料/noctua_nf_a20_1.png 的实际像素（NF-A20 风扇官方图）：
//
//   扇框米    #E9DAC7 / #EAD5C0   风扇四周那圈米白色框体，本皮肤的「键面」
//   扇叶棕    #7D4133             叶片受光面，本皮肤的主棕
//   角垫深棕  #6E382B / #73392B   四角减震垫与轮毂，最深的一档
//
// 深色模式没有官方参照，取的是 Noctua chromax.black 那条线的读法：
// 黑棕色的机身 + 原本的棕，于是深色下底板发黑、键面是暖棕灰，
// 强调色反而比浅色更亮一档（暗底上棕色要提亮才压得住）。
//
// ===== 想换一套配色时 =====
// 只改下面 base 里那八个「基色」，其余全部由它们派生：
//
//   canvas / letterFill / functionFill / brown / brownDeep /
//   label / labelMuted / labelOnBrown
//
// 按下态、立体下边缘、分割线、候选栏、气泡的颜色都是从这八个基色算出来的
// （见文件末尾的派生段），所以换色时不会出现「底色改了、按下态还是旧色」这类对不上的情况。

// ===== 色值运算 =====
// 只用 std.codepoint / std.format 这类最老的内置函数，手机上内置的 jsonnet 也吃得下。
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

// 一对色同时混合：浅色向 lightTarget 走，深色向 darkTarget 走，比例可以分开给。
// 起点不一样，压同样的比例效果差很远，所以两档必须能各调各的。
local mixPair(c, lightTarget, darkTarget, tLight, tDark=null) =
  local d = if tDark == null then tLight else tDark;
  pair(mix(c.light, lightTarget, tLight), mix(c.dark, darkTarget, d));

// 给一对色换上指定的 alpha，得到八位色值。
// 先截到前 7 位，这样基色本身已带 alpha 时也不会越写越长。
local withAlpha(c, alpha) =
  local hex = std.format('%02X', alpha);
  pair(std.substr(c.light, 0, 7) + hex, std.substr(c.dark, 0, 7) + hex);

// ===== 八个基色 =====
// 换肤时改这里。上面那句「其余全部派生」指的就是这八个。
local base = {
  // 键盘底板。浅色是扇框米往下压一档——键面若与底板同色，键就浮不起来；
  // 深色是 chromax.black 的机身，带一点棕味的近黑，不是中性灰。
  canvas: pair('#D9C6A9', '#1B1512'),
  // 键面（字母 / 数字 / 符号 / 空格）：浅色就是扇框那圈米白，本皮肤面积最大的一块；
  // 深色是暖棕灰，比底板亮两档。
  letterFill: pair('#F6EDDF', '#453930'),
  // 功能键（123、中英、?123、=\<、返回、标点）：夹在底板与键面之间的沙色。
  // 三档明度拉开：底板最暗、功能键居中、键面最亮，一眼就分得出哪颗会上屏。
  functionFill: pair('#E2D1B6', '#322A24'),
  // 主棕 —— 扇叶的受光面。Shift、删除、候选栏首选、长按网格的选中格都是它。
  brown: pair('#7D4133', '#8E5142'),
  // 深棕 —— 四角减震垫与轮毂，整块键盘上最重的一档，只给回车。
  brownDeep: pair('#6E382B', '#743A2E'),
  // 键面主字：浅色是比深棕再深一档的棕，不用纯黑——纯黑落在米色上会发脏。
  label: pair('#3E241C', '#F0E3D0'),
  // 次要文字：角标（上划符号）、预编辑串、候选注释、工具栏图标、空格上的方案名
  labelMuted: pair('#8A6A56', '#B49B81'),
  // 棕色键面上的字，取扇框米：棕底米字就是这只风扇本身的配色
  labelOnBrown: pair('#F6EDDF', '#F4E7D5'),
};

// ===== 派生色 =====
// 全部由上面八个基色算出来，不要在这里硬写十六进制。

// 按下态：**两档都向主棕靠一档**。
//
// 常见做法是「浅色向黑压、深色向白提」，但那样按下去的键会掉出这套暖色，
// 浅色下变成灰米、深色下变成冷白。这里改成向扇叶棕混：
// 浅色的米键起点亮，混进棕就变暗；深色的棕灰键起点暗，而深色的主棕比它亮，
// 混进去反而提亮——同一条规则，两边都是「离常态更远一档」，且始终留在棕色家族里。
local towardBrown(c, tLight, tDark=null) = mixPair(c, base.brown.light, base.brown.dark, tLight, tDark);

// 棕色键自己没法再向棕靠，改用老规矩：浅色压黑、深色提白。
local press(c, tLight, tDark=null) = mixPair(c, BLACK, WHITE, tLight, tDark);

// 底部立体边缘。iOS 原生键盘那道下沿，本皮肤留着它——
// 风扇是注塑件，键帽做出厚度比纯扁平更像这只扇子。
// 浅色一律向最深的那档棕走，深色向黑走（深色底本来就暗，再掺棕就看不见了）。
local edgeOf(c) = mixPair(c, '#5A2C20', BLACK, 0.30, 0.45);

{
  // 直接透出的基色
  canvas: base.canvas,
  letterFill: base.letterFill,
  functionFill: base.functionFill,
  brown: base.brown,
  brownDeep: base.brownDeep,
  label: base.label,
  labelMuted: base.labelMuted,
  labelOnBrown: base.labelOnBrown,

  // 空格：键面色往底板那边退一成。它是一整条而不是一颗键，退这一档就读得出来了，
  // 又远不到功能键那一档——三种键的明度关系仍然是「底板 < 功能键 < 空格 < 字母键」。
  spaceFill: mixPair(base.letterFill, base.canvas.light, base.canvas.dark, 0.10),

  // ===== 按下态 =====
  letterPressed: towardBrown(base.letterFill, 0.16, 0.26),
  spacePressed: towardBrown(base.letterFill, 0.16, 0.26),
  functionPressed: towardBrown(base.functionFill, 0.20, 0.30),
  brownPressed: press(base.brown, 0.16, 0.14),
  brownDeepPressed: press(base.brownDeep, 0.18, 0.16),

  // 键面字的按下态：比常态再重一点，让「按住不放」时字也跟着实一档
  labelPressed: press(base.label, 0.22, 0.00),
  labelOnBrownPressed: pair(WHITE, WHITE),

  // ===== 立体下边缘 =====
  letterEdge: edgeOf(base.letterFill),
  spaceEdge: edgeOf(base.letterFill),
  functionEdge: edgeOf(base.functionFill),
  brownEdge: edgeOf(base.brown),
  brownDeepEdge: edgeOf(base.brownDeep),

  // 分割线 / 符号列表里的横线：底板向主字色掺两成
  divider: mixPair(base.canvas, base.label.light, base.label.dark, 0.20, 0.35),

  // ===== 短按气泡 / 长按符号网格 =====
  // 气泡浮在键上面，取的是**不透明**的键面色，再透就跟下面的键糊成一片了。
  hintFill: base.letterFill,
  hintLabel: base.label,
  hintBorder: mixPair(base.canvas, base.label.light, base.label.dark, 0.28, 0.45),
  // 投影**不从基色派生**：投影是黑的，与配色无关，深浅两档的差别只在 alpha
  hintShadow: pair('#00000038', '#00000073'),
  hintGridFill: base.letterFill,
  hintGridLabel: base.label,
  hintGridSelectedFill: base.brown,
  hintGridSelectedLabel: base.labelOnBrown,

  // ===== 候选栏 =====
  // 候选字按「候选字 > 注释 > 序号」分三档轻重；颜色留给首选那颗棕色药丸。
  candidateText: base.label,
  candidateComment: base.labelMuted,
  candidateIndex: mixPair(base.labelMuted, base.canvas.light, base.canvas.dark, 0.35),
  candidatePressed: towardBrown(base.canvas, 0.12, 0.20),
  candidatePreferredBackground: base.brown,
  candidatePreferredText: base.labelOnBrown,
  candidatePreferredComment: mixPair(base.labelOnBrown, base.brown.light, base.brown.dark, 0.30),
  candidatePreferredIndex: mixPair(base.labelOnBrown, base.brown.light, base.brown.dark, 0.45),

  // 预编辑串（正在输入的拼音）与工具栏图标：都走次要文字这一档，按下才亮成主棕
  preeditText: base.labelMuted,
  toolbarIcon: base.labelMuted,
  toolbarIconPressed: base.brown,

  withAlpha: withAlpha,
}
