// 几何尺寸表。
//
// 以 point 为单位的值（高度、内边距、圆角、气泡尺寸）必须按同一个屏宽换算，
// 本皮肤统一按 iPhone 竖屏 390pt / iPad 竖屏 834pt 调；宽度一律用分数，天然跨设备。
{
  preedit: {
    height: 25,
    insets: { top: 2, left: 4 },
  },

  toolbar: {
    height: 40,
  },

  // ===== 高度按「一行多高」给，不按「一整块键盘多高」给 =====
  //
  // 本皮肤的五种版面行数并不一致：iPhone 拼音、数字、符号、九宫格都是四行，
  // iPad 拼音是五行（多一排数字）。若像别的皮肤那样直接写死整块键盘的高度，
  // iPad 上从拼音切到数字时行高会跳一大截——五行的高度摊给四行，键立刻变胖。
  //
  // 所以这里只定行高，整块键盘的高度由 height() 乘出来：
  // 不管哪一页、几行，一行永远这么高，来回切键盘时键不会跳。
  rowHeight: {
    iPhone: { portrait: 54, landscape: 40 },
    iPad: { portrait: 62, landscape: 82 },
  },

  height(device, orientation, rows):: self.rowHeight[device][orientation] * rows,

  // 按键背景相对触摸区收缩的边距，决定键与键之间的缝隙
  keyInsets: {
    iPhone: {
      portrait: { top: 4, left: 3, bottom: 4, right: 3 },
      landscape: { top: 3, left: 3, bottom: 3, right: 3 },
    },
    iPad: {
      portrait: { top: 4, left: 3.5, bottom: 4, right: 3.5 },
      landscape: { top: 5, left: 6, bottom: 5, right: 6 },
    },
  },

  // 按键区整体的左右边距，与键间距是两回事：
  // 最外侧的键离屏幕边要比键与键之间稍宽一点，键盘才不显得顶着屏幕。
  //
  // iPhone 横屏是 0：横屏支持分体，分体版面两侧已经有一条 8/1125 的留白键
  // （Components/Split.libsonnet），宽度表照 default 手算、以「按键区贴满整行」为前提。
  // keyboardStyle 挂在根节点上，split 覆盖块够不着，没法只在分体态去掉这 2pt，
  // 所以横屏干脆与 default 一样不留，合并态最外侧的键因此外移 2pt。
  keyboardAreaInsets: {
    iPhone: {
      portrait: { left: 2, right: 2 },
      landscape: { left: 0, right: 0 },
    },
    iPad: {
      portrait: { left: 4, right: 4 },
      landscape: { left: 6, right: 6 },
    },
  },

  key: {
    // 键面圆角。风扇是注塑件，边角是圆的但不是胶囊，9 差不多是可视键高的六分之一。
    cornerRadius: 9,
    // 角标（上划符号）在键面中的位置：0 是左 / 上边，1 是右 / 下边。
    // 顶在右上角，主标签才能老老实实待在键面正中。
    badgeCenter: { x: 0.80, y: 0.25 },
    // 双行键面（12 + 34）上下两行的位置。
    // 这两个数说的是**墨迹**要落在哪，不是图层落在哪：字形本身的偏心
    // 由 Components/Button.libsonnet 的 inkOffsets 补掉了。
    doubleTopCenter: { y: 0.30 },
    doubleBottomCenter: { y: 0.66 },
  },

  // 短按气泡：浮在按键正上方，比按键宽一圈。
  // 气泡与它盖住的键同色，靠一条细描边 + 一道投影分界，见 Components/Theme.libsonnet。
  hint: {
    size: { width: 50, height: 50 },
    cornerRadius: 12,
    borderSize: 0.5,
    shadowRadius: 4,
    shadowOffset: { x: 0, y: 3 },
  },

  // 长按符号网格（hintSymbolsGridStyle）：长按一颗键弹出的那一条备选符号。
  // 单元格比按键窄一点，一整条才塞得下六个备选而不顶到屏幕边。
  hintGrid: {
    cell: { width: 36, height: 42 },
    spacing: { horizontal: 3, vertical: 3 },
    insets: { top: 5, left: 5, bottom: 5, right: 5 },
    cornerRadius: 10,
    cellCornerRadius: 6,
    borderSize: 0.5,
    // 面板默认贴着按键上沿，再抬高一点，免得手指盖住最下面一行
    offset: { x: 0, y: -6 },
    // 手指抖动小于这个距离时维持初始高亮，不误选
    moveThreshold: 8,
    shadowRadius: 5,
    shadowOffset: { x: 0, y: 4 },
  },

  // 九宫格左侧符号条的内边距
  symbolStrip: {
    insets: { top: 6, left: 4, bottom: 6, right: 4 },
  },

  candidate: {
    cornerRadius: 6,
    horizontalInsets: { top: 6, left: 6, bottom: 4, right: 0 },
    verticalInsets: { top: 6, left: 6, bottom: 6, right: 6 },
    cellInsets: {},
    expandButtonWidth: 44,
    verticalBottomRowHeight: 45,
    verticalMaxRows: 5,
    verticalMaxColumns: 6,
  },

  // iPad 屏宽富余，候选区两侧留白
  iPadSideInsets: { top: 0, bottom: 0, left: 200, right: 200 },
}
