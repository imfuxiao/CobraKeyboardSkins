// 几何尺寸表。
//
// 以 point 为单位的值（高度、内边距、圆角、气泡尺寸）必须按同一个屏宽换算，
// 本皮肤统一按 iPhone 竖屏 390pt / iPad 竖屏 834pt 调；宽度一律用分数，天然跨设备。
//
// 下面的数值由 ../../资料/ 里四张设计图量出来再折算：
// 设计图宽 954px 对应一整屏，所以「设计图像素 ÷ 954 × 390」就是 iPhone 竖屏的点值。
//
//   横向缝隙 10.7px -> 4.4pt   -> 单边内边距 2.2
//   纵向缝隙 26.5px -> 10.8pt  -> 单边内边距 5.4
//   键面圆角 8px    -> 3.3pt   （不直接采用，见下）
//
// 「纵向缝隙是横向的两倍半」是 Gboard 最好认的比例，改高度时别把这个比例改掉。
//
// 高度不按设计图折算。设计图是一张裁过的截图，按它算出来的 205pt 比装到手机上的
// Gboard 矮了整整一截（键的可视高度只剩 41pt）。真机上 Gboard 的键可视高约 48pt，
// 加上 10.8pt 的纵向缝隙，一行 ≈ 59pt，四行 ≈ 236pt——所以竖屏取 240。
{
  preedit: {
    height: 26,
    insets: { top: 2, left: 6 },
  },

  toolbar: {
    height: 42,
  },

  // 按键区高度（固定点值，不随屏宽缩放）。四种键盘都是四行，所以共用这一张表。
  keyboardHeight: {
    iPhone: { portrait: 240, landscape: 176 },
    iPad: { portrait: 330, landscape: 430 },
  },

  // 按键背景相对触摸区收缩的边距，决定键与键之间的缝隙。
  // 上下比左右大得多，这是 Gboard 与 iOS 原生键盘最直观的区别。
  keyInsets: {
    iPhone: {
      portrait: { top: 5.4, left: 2.2, bottom: 5.4, right: 2.2 },
      landscape: { top: 3.6, left: 2.2, bottom: 3.6, right: 2.2 },
    },
    iPad: {
      portrait: { top: 6, left: 3, bottom: 6, right: 3 },
      landscape: { top: 8, left: 4, bottom: 8, right: 4 },
    },
  },

  // 按键区整体的边距。设计图上最外侧的键离屏幕边 11px，而键与键之间是 13px，
  // 也就是说外边距比「半条缝」还多出约 2pt——这一档就补在这里，不动键与键的间距。
  keyboardAreaInsets: {
    iPhone: {
      portrait: { left: 2, right: 2 },
      landscape: { left: 2, right: 2 },
    },
    iPad: {
      portrait: { left: 4, right: 4 },
      landscape: { left: 6, right: 6 },
    },
  },

  key: {
    // 键面圆角。
    //
    // 设计图与真机截图量出来都是 3.6~3.9pt，但那两张图上的键只有 43pt 高；
    // 本皮肤的键高一档（49pt，见 keyboardHeight 的说明），同样的半径摊在更大的键面上
    // 看着就偏方了。半径按键高同比放大到 8——约等于可视键高的六分之一，
    // 仍然是个圆角矩形，离胶囊（半径 24.6）还远。
    cornerRadius: 8,
    // 角标（上划符号）在键面中的位置：0 是左 / 上边，1 是右 / 下边。
    // Gboard 把它顶在右上角，与 iOS 把上划符号居中放的做法不同。
    badgeCenter: { x: 0.82, y: 0.24 },
    // 双行键面（emoji + 逗号、12 + 34）上下两行的位置。
    //
    // 这两个数说的是**墨迹**要落在哪，不是图层落在哪：字形本身的偏心
    // 由 Components/Button.libsonnet 的 inkOffsets 补掉了（逗号蹲在基线上，
    // 不补的话实际会掉到 0.87，与笑脸拉开大半颗键的距离）。
    doubleTopCenter: { y: 0.30 },
    doubleBottomCenter: { y: 0.66 },
  },

  // 短按气泡：Gboard 弹的是一个白色圆形，比按键宽。
  //
  // 气泡浮在按键正上方，两者又是同一个白，不做分界就看不出哪块是气泡、哪块是键面。
  // 分界分两层做，因为**单靠投影做不出来**：
  //
  //   引擎给几何图层的投影路径是图层**底边那一道 1pt 的弧**
  //   （CAShapeLayer.underPath，本来是给 iOS 那种立体下沿用的），
  //   一条 1pt 的线再一模糊，墨量摊开后峰值就没了——参照图上气泡下方最深处比底板暗 13%、
  //   摊开约 10pt，这个量 1pt 的线怎么调都到不了。
  //
  //   所以：投影**收紧**（半径 4）压成底边一道实线，管「下沿」这一侧；
  //   四周另加一条 0.5pt 描边，管左右和上方。
  //   参照图的层次本来也是这样：正下方最深、两侧很淡、正上方几乎没有。
  hint: {
    size: { width: 48, height: 48 },
    cornerRadius: 24,
    borderSize: 0.5,
    shadowRadius: 4,
    shadowOffset: { x: 0, y: 3 },
  },

  // 长按符号网格（hintSymbolsGridStyle）：Gboard 长按一颗键弹出的那一条备选符号。
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
    // 与气泡同一套做法：投影收紧管底边，描边管四周，见上面 hint 的说明
    shadowRadius: 5,
    shadowOffset: { x: 0, y: 4 },
  },

  // 九宫格左侧符号条的内边距与圆角
  symbolStrip: {
    insets: { top: 6, left: 4, bottom: 6, right: 4 },
  },

  candidate: {
    cornerRadius: 6,
    horizontalInsets: { top: 6, left: 6, bottom: 4, right: 0 },
    verticalInsets: { top: 6, left: 6, bottom: 6, right: 6 },
    cellInsets: {},
    expandButtonWidth: 44,
    verticalBottomRowHeight: 46,
    verticalMaxRows: 5,
    verticalMaxColumns: 6,
  },

  // iPad 屏宽富余，候选区两侧留白
  iPadSideInsets: { top: 0, bottom: 0, left: 180, right: 180 },

  // 四种键盘都是四行；胶囊键的圆角要按「一行的可视高度」算，见 Theme.pillRadius。
  rowCount: 4,
}
