// 布局语法糖。
// 记牢引擎的命名与直觉相反：HStack 是「一行」（同级自左向右排开），
// VStack 是「一列」。`keyboardLayout` 是一个 HStack 数组，自上而下就是一行行按键。
{
  // 一行按键。style 指向一个只用来取 size 的样式名，不给则行高在剩余空间里均分。
  row(cells, style=null):: {
    HStack: {
      [if style != null then 'style']: style,
      subviews: [{ Cell: cell } for cell in cells],
    },
  },
}
