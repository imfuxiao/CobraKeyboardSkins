// 「Gboard」色板 —— **全皮肤唯一的色值来源，改配色只需要动这一个文件**。
//
// 每个色都是一对 { light, dark }：上层代码一律只写色名，
// 由 Components/Style.libsonnet 的 resolve() 在生成 light/ 与 dark/ 文件时二选一。
// 因此除本文件外，任何地方都不需要关心「现在是深色还是浅色」。
//
// 色值取自 ../../资料/ 下四张设计图的实际像素：
//   底板 #EFEFEF、白键 #FFFFFF、灰功能键 #D1D1D1，深色模式补的是 Gboard 官方夜间配色。
//
// ===== 想换一套配色时 =====
// 只改下面 base 里那七个「基色」，其余全部由它们派生：
//
//   background / letterFill / functionFill / accent / label / labelMuted / labelOnAccent
//
// 按下态、分割线、候选栏、气泡的颜色都是从这七个基色算出来的（见文件末尾的 derive），
// 所以换色时不会出现「底色改了、按下态还是旧色」这类对不上的情况。

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

// 一对色同时混合：浅色向 lightTarget 走，深色向 darkTarget 走
local mixPair(c, lightTarget, darkTarget, t) = pair(mix(c.light, lightTarget, t), mix(c.dark, darkTarget, t));

// 按下态：浅色模式向黑压一档，深色模式向白提一档。两边都是「离底板更远一档」。
//
// 浅深两档的力度可以分开给（tDark 省略时跟 tLight 走）：起点不一样，压同样的比例效果差很远。
// 浅色的白键起点是纯白 #FFFFFF，又不画底板、缝里透的是系统键盘底（约 #D1D5DB），
// 压得不够狠就夹在「白」和「系统底」中间两头不像，看着跟没按一样；
// 深色的键面本来就不白，提一点就看得出来，再多反而刺眼。
local press(c, tLight, tDark=null) =
  local d = if tDark == null then tLight else tDark;
  pair(mix(c.light, BLACK, tLight), mix(c.dark, WHITE, d));

// 只给深色那一半加 alpha，浅色保持不透明。
// 深色键盘的底是系统那层模糊，键面透一点会跟着底走，比一块死色好看；
// 浅色底是亮的，键面再透就糊了，所以只做深色。
local darkAlpha(c, alpha) = pair(c.light, std.substr(c.dark, 0, 7) + std.format('%02X', alpha));

// 给一对色换上指定的 alpha，得到八位色值。
// 先截到前 7 位，这样基色本身已带 alpha 时也不会越写越长。
local withAlpha(c, alpha) =
  local hex = std.format('%02X', alpha);
  pair(std.substr(c.light, 0, 7) + hex, std.substr(c.dark, 0, 7) + hex);

// ===== 七个基色 =====
// 换肤时改这里。上面那句「其余全部派生」指的就是这七个。
local base = {
  // 键盘底板的**名义色**。设计图取样 #EFEFEF；深色是 Gboard 夜间的 #202124。
  //
  // 注意：这个色**不会被画出来**。整块键盘的四个区域一律用 keyboardBackdrop
  // （几乎全透明），底是系统键盘自己的——见下面 keyboardBackdrop 的说明。
  // 它留在这里是因为分割线、候选按下态这些派生色仍以「底板应有的明度」为基准。
  background: pair('#EFEFEF', '#202124'),
  // 字母 / 数字 / 符号键：浅色模式是纯白，深色模式比底板亮一档。
  //
  // 深色值比原先（#3C4043）提亮了一档，是为了配下面 keyAlpha 的半透明：
  // 按 20% 的透明度叠在系统深色键盘底（约 #1C1C1E）上，合成回来正好还是 #3C4043，
  // 观感不变，但键面会跟着系统那层模糊走，不再是一块焊死的色。
  letterFill: pair('#FFFFFF', '#44494C'),
  // 功能键（Shift、删除、?123、返回、标点）：浅色模式比底板暗一档，
  // 深色模式仍比底板亮，但比字母键暗——Gboard 夜间两种键都浮在底板之上。
  // 深色值同样是按 30% 透明度反推的，合成回来等于原先的 #26282B。
  functionFill: pair('#D1D1D1', '#2A2D31'),
  // 强调色：Google Blue。用在候选栏首选、工具栏图标按下态、长按网格的选中格。
  accent: pair('#1A73E8', '#8AB4F8'),
  // 回车键的底色：iOS systemBlue，与 Skins/default 的蓝键同色。
  // 它与 accent 是两个色：Gboard 的蓝归 Gboard 管（候选栏那些），回车键单独跟 iOS 走。
  primary: pair('#007AFF', '#0A84FF'),
  // systemBlue 两档都够深，键面字一律给白
  labelOnPrimary: pair('#FFFFFF', '#FFFFFF'),
  // 键面主字
  label: pair('#1F1F1F', '#E8EAED'),
  // 次要文字：角标（上划符号）、预编辑串、候选注释、工具栏图标
  labelMuted: pair('#6E6E6E', '#9AA0A6'),
  // 强调色块上的字
  labelOnAccent: pair('#FFFFFF', '#202124'),
};

// ===== 派生色 =====
// 全部由上面七个基色算出来，不要在这里硬写十六进制。
// 深色键面的透明度。数值越小越透；两档拉开是为了**深色下仍分得出白键和灰键**——
// 合成后的明度差与原先的 #3C4043 / #26282B 完全一样，只是各自透了一点。
local keyAlpha = { letter: 204, 'function': 179 };  // 0xCC = 80%，0xB3 = 70%（function 是关键字，要加引号）

{
  // 直接透出的基色
  background: base.background,
  letterFill: darkAlpha(base.letterFill, keyAlpha.letter),
  functionFill: darkAlpha(base.functionFill, keyAlpha['function']),
  accent: base.accent,
  primary: base.primary,
  labelOnPrimary: base.labelOnPrimary,
  label: base.label,
  labelMuted: base.labelMuted,
  labelOnAccent: base.labelOnAccent,

  // 按下态：三种键面各自加重一档。
  // Gboard 没有立体下边缘，按下就是整块键面换色，所以这三个色是唯一的按压反馈。
  // 按下态与常态用同一档透明度，否则一按下去键面会连带「变实」，看着像闪了一下。
  // 白键浅色压 20%（#CCCCCC）——比系统键盘底还暗一点，按下去读作「陷进去」；
  // 灰键与回车键没这个问题，起点本来就不是白的，维持原来的力度。
  letterPressed: darkAlpha(press(base.letterFill, 0.20, 0.11), keyAlpha.letter),
  functionPressed: darkAlpha(press(base.functionFill, 0.11), keyAlpha['function']),
  accentPressed: press(base.accent, 0.14),
  // 回车键不跟着透明：它是整块键盘上唯一的彩色键，透了就压不住
  primaryPressed: press(base.primary, 0.14),

  // 键面字的按下态：比常态再重一点，让「按住不放」时字也跟着实一档
  labelPressed: press(base.label, 0.20),

  // 分割线 / 符号列表里的横线：底板向主字色掺一成半，浅深两色都比底板重一点点
  divider: mixPair(base.background, base.label.light, base.label.dark, 0.15),

  // 短按气泡：Gboard 是一个白色圆形，浮在按键正上方，没有描边。
  // 取的是**不透明**的基色：气泡浮在键上面，再透就跟下面的键糊成一片了。
  hintFill: base.letterFill,
  hintLabel: base.label,

  // 气泡 / 长按面板的投影。**不从基色派生**：投影是黑的，与配色无关，
  // 深浅两档的差别只在 alpha——底板越暗，投影要越实才看得出来。
  //
  // alpha 比一般的投影高不少（0.45 / 0.65），因为引擎只肯沿着**底边那一道 1pt 的弧**
  // 投影（见 Metrics.hint），墨量本来就少，再按常规的 0.2 去给就什么都看不见了。
  hintShadow: pair('#00000073', '#000000A6'),

  // 气泡 / 长按面板的描边：一条 0.5pt 的细线，只在气泡压住同色按键时才显出边界。
  // Gboard 的气泡本身没有描边，这条线是补引擎的短板——投影只能落在底边，
  // 白气泡压在白键上时，左右和上方一点分界都没有。用半透明黑 / 白，深浅两套都能用。
  hintBorder: pair('#00000026', '#FFFFFF26'),

  // 长按符号网格：面板与气泡同色；高亮单元格用强调色，格子上的字随之翻成 labelOnAccent
  hintGridFill: base.letterFill,
  hintGridLabel: base.label,
  hintGridSelectedFill: base.accent,
  hintGridSelectedLabel: base.labelOnAccent,

  // 候选栏。Gboard 的候选条不给首选加药丸，只把首选染成强调色，
  // 候选之间用一条细竖线分开——所以这里 preferredBackground 直接取底板色（等于不画）。
  candidateText: base.label,
  candidateComment: base.labelMuted,
  candidateIndex: mixPair(base.labelMuted, base.background.light, base.background.dark, 0.30),
  candidatePressed: press(base.background, 0.08),
  // 首选不加药丸：底板既然不画，这里也得是透明的，画上底板色反倒会凭空冒出一颗药丸
  candidatePreferredBackground: withAlpha(pair(WHITE, BLACK), 3),
  candidatePreferredText: base.accent,
  candidatePreferredComment: base.accent,
  candidatePreferredIndex: base.accent,

  // 预编辑串（正在输入的拼音）与工具栏图标：都走次要文字这一档
  preeditText: base.labelMuted,
  toolbarIcon: base.labelMuted,
  toolbarIconPressed: base.accent,

  // ===== 键盘整体背景 =====
  // 几乎全透明，让系统键盘自己的底透上来，与 Skins/default 一致（那边是 #ffffff03 / #00000003）。
  // alpha 只有 3/255，色相基本看不出来；浅色给白、深色给黑，纯粹是为了不把系统底压出色偏。
  //
  // 这样做顺带把 iOS 26 的老问题解决了：系统从那一版起在键盘顶部加了一段带圆角的高度，
  // 底板色一路铺到顶边会在圆角处撞出一条色差。原先是拿一条自下而上的渐隐带去遮，
  // 现在整块不画底，问题不存在了，那套渐变也随之删掉。
  keyboardBackdrop: withAlpha(pair(WHITE, BLACK), 3),
  withAlpha: withAlpha,
}
