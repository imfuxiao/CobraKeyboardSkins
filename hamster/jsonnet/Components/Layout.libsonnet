// 布局树帮手：把「一行有哪些键」写成一个名字数组，而不是逐个手写 HStack/Cell 嵌套。
{
  // names: 样式名数组（哪些键，从左到右）；style: 这一行容器自身的样式名（可选，用来给整行设高度等）。
  row(names, style=null):: {
    HStack: { subviews: [{ Cell: name } for name in names] }
            + (if style == null then {} else { style: style }),
  },
}
