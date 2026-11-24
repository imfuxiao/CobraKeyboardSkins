// 布局语法糖：HStack 表示一行（横向排列），VStack 表示一列（纵向排列）。
// 子项传字符串时自动包装为 { Cell: name }，传嵌套容器对象时原样保留。

local toSubview(item) = if std.isString(item) then { Cell: item } else item;

{
  row(items, style=null):: {
    HStack: {
      [if style != null then 'style']: style,
      subviews: [toSubview(item) for item in items],
    },
  },

  column(items, style=null):: {
    VStack: {
      [if style != null then 'style']: style,
      subviews: [toSubview(item) for item in items],
    },
  },

  emptyColumn():: { VStack: {} },
}
