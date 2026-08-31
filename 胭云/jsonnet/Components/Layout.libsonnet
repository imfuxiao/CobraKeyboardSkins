// 布局语法糖。
// 记牢引擎的命名与直觉相反：HStack 是「一行」（同级自上而下堆叠），
// VStack 是「一列」（同级自左向右堆叠）。
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
}
