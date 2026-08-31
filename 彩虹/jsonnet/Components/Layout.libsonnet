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

  // 一行的宽度序列 -> 每颗键的中心占整行的比例（0 最左，1 最右）。
  //
  // 本皮肤靠这个值给按键分配色相（竖条纹，见 Constants/Colors.libsonnet）。
  // 单位随便给，只看相互比例，所以键盘文件里直接拿宽度表的分子来用即可；
  // 改宽度、加减键之后条纹自动跟着重排，不必再维护第二张表。
  centers(units)::
    local total = std.foldl(function(a, b) a + b, units, 0);
    local edges = std.foldl(function(acc, w) acc + [acc[std.length(acc) - 1] + w], units, [0]);
    [(edges[i] + units[i] / 2) / total for i in std.range(0, std.length(units) - 1)],
}
