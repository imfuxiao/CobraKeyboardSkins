// 按键构造器 —— 全皮肤唯一「拼装一个按键」的地方。
//
// 一个按键在配置文件里其实是一组平铺的样式节点（按键节点 + 前景 + 气泡……），
// 名字之间靠字符串互相引用，引用错一个字母该键就静默变空白。
// 这里把命名规则收敛成一处：所有派生样式名都由按键名加固定后缀得到。
//
//   <name>                按键节点（尺寸、动作、引用哪些样式）
//   <name>Label           主标签
//   <name>SecondaryLabel  副标签（双行键面的上排：emoji + 逗号、12 + 34）
//   <name>Badge           角标（右上角的上划符号）
//   <name>LabelUppercased 大写态标签
//   <name>LabelCapsLocked 大写锁定态标签
//   <name>Hint            短按气泡
//   <name>HintLabel       气泡主字
//   <name>HintSwipeUp     气泡上划字
//   <name>Grid            长按符号网格
//   <name>GridCell<i>     网格里的第 i 颗备选符号键
//   <name>GridCell<i>Label  它的字
local Colors = import '../Constants/Colors.libsonnet';
local Fonts = import '../Constants/Fonts.libsonnet';
local Metrics = import '../Constants/Metrics.libsonnet';
local Style = import 'Style.libsonnet';
local Theme = import 'Theme.libsonnet';

// 按键节点上允许出现的动作与布局 Key。不在表里的 Key 会被丢掉，
// 免得手滑写出的键名混进产物里（引擎对不认识的 Key 是静默忽略的）。
local passthroughKeys = [
  'size',
  'bounds',
  'action',
  'uppercasedStateAction',
  'preeditStateAction',
  'repeatAction',
  'swipeUpAction',
  'swipeDownAction',
  'notification',
  'animation',
  // Split（分体键盘）覆盖块，见 docs/键盘Split状态.md。漏掉这一项会导致所有
  // opts.split 被这里静默丢弃——Split 完全不生效，但也不报错，很难查。
  'split',
];

local passthrough(opts) = {
  [key]: opts[key]
  for key in passthroughKeys
  if std.objectHas(opts, key)
};

// ===== 字形偏心补偿 =====
// 引擎摆的是文字图层，对齐的是字形的**行盒**（ascent + descent），不是墨迹。
// 「。」的小圆缩在全角方框的左下角、「,」蹲在基线上，行盒摆正了，看着却偏左偏下——
// 句号在一颗 34pt 宽的键上会偏出去 5.7pt，肉眼一看就不在中间。
//
// 下表是「墨迹中心相对行盒中心的偏移」，单位 em，正数表示墨迹偏右 / 偏下。
// 量自 Hiragino Sans GB、Heiti SC 与 SF Pro（iOS 上对应 PingFang SC / SF Pro），
// 三套字体的差异在 0.03em 以内，22pt 下不到 0.7pt。换字体走样时**只改这张表**。
//
// ===== 全角标点这两行是逐字形实测的，别让它们共用一个值 =====
// 「。」与「，」虽然都缩在全角方框的左下角，缩的程度并不一样：实测差 0.056em，
// 22.5pt 下是 1.3pt（约 4 个设备像素），在一颗 39pt 宽的键上一眼看得出没对齐。
//
// 数值量自 Hiragino Sans GB，取的是**墨量加权质心相对行盒中心**的位移。
// 选它是因为它与 iOS 的 PingFang SC 同属 GB 简体字体，全角标点走的是同一套排版惯例
// （句号、逗号落在方框左下，右半留白）。
//
// > **换一套排版惯例的字体，这两行就得重量。** 同机上的 STHeiti Medium 把全角标点
// > **居中**放（实测 x ≈ +0.005），与 Hiragino 差了将近 0.3em——也就是说这一档补偿
// > 是跟着字体惯例走的，不是一个放之四海皆准的常数。本机没有 PingFang 字体文件，
// > 没能直接实测；真机上若看着这两个标点偏右，把这两行往 0 调即可。
//
// 重量的办法：用 PIL 以 anchor='mm' 把字画在空白画布上，求墨量质心与锚点的差，
// 再除以字号。scripts/gen_demo.py 渲出的键面可用来复核（注意取样带要避开键的
// 立体下边缘，那条横贯键面的深色条会把质心往键中心拽，量出来的偏差会小一半）。
local inkOffsets = {
  '。': { x: -0.275, y: 0.296 },
  '，': { x: -0.331, y: 0.363 },
  ',': { x: -0.02, y: 0.39 },
  '.': { x: -0.02, y: 0.38 },
};

// 把偏移折成 insets，把整块图层反向挪回来。
//
// 为什么是 insets 而不是 center：center 是**比例**，键宽随屏幕变，
// 同一个比例在 iPad 上会过头一倍；insets 是点值，与屏宽无关，四种设备共用一份。
// 左右 / 上下取相反数时 frame.inset 只平移、宽高不变，所以不会把字挤窄挤扁。
local inkInsets(desc, fontSize) =
  if std.objectHas(desc, 'text') && std.objectHas(inkOffsets, desc.text) then
    local o = inkOffsets[desc.text];
    local dx = -o.x * fontSize;
    local dy = -o.y * fontSize;
    { insets: { left: dx, right: -dx, top: dy, bottom: -dy } }
  else {};

// 把一个「外观描述」变成前景样式节点。
// desc 里出现 systemImageName / assetImageName 就画图标，否则画文字。
// desc 排在最后，所以它可以覆盖字号、颜色、center 等任何一项。
local paint(desc, tint, defaultFontSize) =
  if std.objectHas(desc, 'systemImageName') then
    Style.systemImage({ fontSize: Fonts.keyIcon } + tint + desc)
  else if std.objectHas(desc, 'assetImageName') then
    Style.assetImage(tint + desc)
  else
    // desc 排在最后，所以某一处要自己定位时写个 insets 就能盖掉自动补偿。
    local fontSize = if std.objectHas(desc, 'fontSize') then desc.fontSize else defaultFontSize;
    Style.text({ fontSize: defaultFontSize } + tint + inkInsets(desc, fontSize) + desc);

local roleTint(role) = {
  normalColor: Theme.ink(role),
  highlightColor: Theme.inkPressed(role),
};

local hintTint = {
  normalColor: Colors.hint.ink,
};

// 气泡：短按时浮在按键上方，是一块与键面同色的圆角矩形，
// 主字居中，该键能上划时右上角带上划字。
local hintFragment(name, hint) =
  local hasSwipeUp = std.objectHas(hint, 'swipeUp');
  {
    [name + 'Hint']: {
      size: Metrics.hint.size,
      backgroundStyle: Theme.hintBackgroundName,
      foregroundStyle: name + 'HintLabel',
    } + (
      if hasSwipeUp then { swipeUpForegroundStyle: name + 'HintSwipeUp' } else {}
    ),
    [name + 'HintLabel']: paint(hint.label, hintTint, Fonts.hintLabel),
  } + (
    if hasSwipeUp then
      { [name + 'HintSwipeUp']: paint(hint.swipeUp, hintTint, Fonts.hintLabel) }
    else {}
  );

// 长按符号网格：长按一颗键，键的上方弹出一条备选符号，手指左右滑动选、抬手上屏。
// 引擎的读法见 KeyboardUI/.../TouchView+HintSymbolsGrid.swift：
//   按键节点的 hintSymbolsGridStyle 指向一份网格样式，
//   网格样式的 symbolRows 是一张**样式名**表（不是字符表），
//   表里每个名字都得是一颗完整的按键样式节点——上屏什么由它自己的 action 说了算。
//
// 这里只铺一行。默认高亮哪一格由 anchorCol 按这颗键在键盘上的横向位置挑，见下。

// 默认高亮格：面板比键宽得多，贴着屏幕边的键，面板会被引擎推回屏内
// （TouchView+HintSymbolsGrid 里那两段 bounds 夹取），此时若仍默认选中间那格，
// 高亮就落到手指外面去了。所以越靠左的键越往左选、越靠右的键越往右选：
//
//   anchor（键中心占键盘宽的比例）   选哪一格
//   ---------------------------   --------
//   < 0.175                       最左格
//   < 0.275                       次左格
//   其余                           正中间那格
//   > 0.725                       次右格
//   > 0.825                       最右格
//
// 阈值取在相邻两颗键中心的正中间（第一行十键的中心是 0.05、0.15、0.25……），
// 这样不会踩到浮点数相等的边界。
local anchorCol(anchor, count) =
  if count <= 1 then 0
  else if anchor < 0.175 then 0
  else if anchor < 0.275 then 1
  else if anchor > 0.825 then count - 1
  else if anchor > 0.725 then std.max(0, count - 2)
  else std.floor((count - 1) / 2);

local gridFragment(name, symbols, anchor) =
  local last = std.length(symbols) - 1;
  local cellName(i) = name + 'GridCell' + i;
  {
    [name + 'Grid']: {
      size: Metrics.hintGrid.cell,
      spacing: Metrics.hintGrid.spacing,
      insets: Metrics.hintGrid.insets,
      offset: Metrics.hintGrid.offset,
      moveThreshold: Metrics.hintGrid.moveThreshold,
      backgroundStyle: Theme.hintGridBackgroundName,
      selectedBackgroundStyle: Theme.hintGridSelectedBackgroundName,
      selected: { row: 0, col: anchorCol(anchor, last + 1) },
      symbolRows: [[cellName(i) for i in std.range(0, last)]],
    },
  } + {
    // 单元格不给 backgroundStyle：面板已经是一整块白，格子自己再铺一层反而糊。
    // 高亮时引擎会把 selectedBackgroundStyle 插进这一层里，盖在字的下面。
    [cellName(i)]: {
      foregroundStyle: cellName(i) + 'Label',
      action: { character: symbols[i] },
    }
    for i in std.range(0, last)
  } + {
    // 走 paint 而不是直接 Style.text：网格里全是标点，字形偏心补偿在这里同样要生效，
    // 否则「。」在格子里也会缩到左下角。
    [cellName(i) + 'Label']: paint(
      { text: symbols[i] },
      { normalColor: Colors.hintGrid.ink, highlightColor: Colors.hintGrid.selectedInk },
      Fonts.hintGridLabel
    )
    for i in std.range(0, last)
  };

// opts:
//   role              必填，见 Constants/Colors.libsonnet 的 roles 表
//   label             必填，主标签外观 { text } / { systemImageName } / { assetImageName }
//   labelFontSize     可选，主标签默认字号（label 里再写 fontSize 可继续覆盖）
//   secondaryLabel    可选，副标签，双行键面的上排
//   badge             可选，角标（自动减淡、缩小、顶到右上角）
//   uppercasedLabel   可选，大写态替换主标签
//   capsLockedLabel   可选，大写锁定态替换主标签
//   hint              可选，{ label: 外观, swipeUp: 外观 } 短按气泡
//   longPress         可选，字符数组，长按弹出的备选符号
//   longPressAnchor   可选，这颗键中心占键盘宽的比例（0 左边缘、1 右边缘），
//                     决定长按面板默认高亮哪一格，见 anchorCol；不给按正中算
//   animation         可选，覆盖默认的按下动画；传 [] 表示该键不要动画
//   backgroundStyle   可选，覆盖角色默认背景（回车键的条件样式用）
//   foregroundStyle   可选，覆盖自动拼装的前景列表（回车键的条件样式用）
//   其余 passthroughKeys 里的 Key 原样写进按键节点
local new(name, opts) =
  local role = opts.role;
  local tint = roleTint(role);
  local labelFontSize = if std.objectHas(opts, 'labelFontSize') then opts.labelFontSize else Fonts.keyLabel;

  // 主标签之外还要一起画的层。大小写态只换主标签，副标签与角标照画——
  // 写成一份列表再拼，是因为状态样式给的是**整张前景表**：
  // 只写一个大写标签的话，一按 Shift 满键盘的角标会跟着消失。
  local extraLayers =
    (if std.objectHas(opts, 'secondaryLabel') then [name + 'SecondaryLabel'] else [])
    + (if std.objectHas(opts, 'badge') then [name + 'Badge'] else []);
  local layers = [name + 'Label'] + extraLayers;

  {
    [name]: {
      backgroundStyle:
        if std.objectHas(opts, 'backgroundStyle') then opts.backgroundStyle
        else Theme.backgroundName(role),
      foregroundStyle:
        if std.objectHas(opts, 'foregroundStyle') then opts.foregroundStyle
        else layers,
      animation: [Theme.pressAnimationName],
    } + passthrough(opts) + (
      if std.objectHas(opts, 'uppercasedLabel') then
        { uppercasedStateForegroundStyle: [name + 'LabelUppercased'] + extraLayers } else {}
    ) + (
      if std.objectHas(opts, 'capsLockedLabel') then
        { capsLockedStateForegroundStyle: [name + 'LabelCapsLocked'] + extraLayers } else {}
    ) + (
      if std.objectHas(opts, 'hint') then { hintStyle: name + 'Hint' } else {}
    ) + (
      if std.objectHas(opts, 'longPress') && std.length(opts.longPress) > 0 then
        { hintSymbolsGridStyle: name + 'Grid' } else {}
    ),

    [name + 'Label']: paint(opts.label, tint, labelFontSize),
  } + (
    if std.objectHas(opts, 'secondaryLabel') then
      { [name + 'SecondaryLabel']: paint(opts.secondaryLabel, tint, Fonts.keyDouble) }
    else {}
  ) + (
    if std.objectHas(opts, 'badge') then
      {
        // 角标默认小一号、淡一档、顶在右上角；opts.badge 里可以逐项覆盖。
        [name + 'Badge']: paint(
          { fontSize: Fonts.keyBadge, center: Metrics.key.badgeCenter } + opts.badge,
          { normalColor: Theme.inkSoft(role), highlightColor: Theme.inkSoft(role) },
          Fonts.keyBadge
        ),
      }
    else {}
  ) + (
    if std.objectHas(opts, 'uppercasedLabel') then
      { [name + 'LabelUppercased']: paint(opts.uppercasedLabel, tint, labelFontSize) }
    else {}
  ) + (
    if std.objectHas(opts, 'capsLockedLabel') then
      { [name + 'LabelCapsLocked']: paint(opts.capsLockedLabel, tint, labelFontSize) }
    else {}
  ) + (
    if std.objectHas(opts, 'hint') then hintFragment(name, opts.hint) else {}
  ) + (
    if std.objectHas(opts, 'longPress') && std.length(opts.longPress) > 0 then
      gridFragment(
        name,
        opts.longPress,
        if std.objectHas(opts, 'longPressAnchor') then opts.longPressAnchor else 0.5
      )
    else {}
  );

{
  new: new,
  paint: paint,
  roleTint: roleTint,
  // 导出给 Keys 用：候选内容要按「角标落在默认高亮那一格」来排，
  // 排内容与定高亮必须用同一个函数算，否则两边会各走各的。
  anchorCol: anchorCol,
}
