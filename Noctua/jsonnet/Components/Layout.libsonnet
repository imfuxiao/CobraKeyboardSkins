// 布局语法糖。
// 记牢引擎的命名与直觉相反：HStack 是「一行」（同级自上而下堆叠），
// VStack 是「一列」（同级自左向右堆叠）。
//
// 同级不能混用 HStack / VStack / Cell，但**嵌套是自由的**：
// 九宫格数字键盘就是「上半部一个 HStack 里塞三个 VStack、下半部一个 HStack 排一行键」。
{
  // 一行按键。style 指向一个只用来取 size 的样式名，不给则行高均分。
  row(cells, style=null):: {
    HStack: {
      [if style != null then 'style']: style,
      subviews: [{ Cell: cell } for cell in cells],
    },
  },

  // 一列按键
  column(cells, style=null):: {
    VStack: {
      [if style != null then 'style']: style,
      subviews: [{ Cell: cell } for cell in cells],
    },
  },

  // 一行容器，子节点由调用方给（用来在一行里横向摆若干列）
  rowOf(subviews, style=null):: {
    HStack: {
      [if style != null then 'style']: style,
      subviews: subviews,
    },
  },

  // 一列容器，子节点由调用方给（用来在一列里纵向摆若干行）
  columnOf(subviews, style=null):: {
    VStack: {
      [if style != null then 'style']: style,
      subviews: subviews,
    },
  },
}
