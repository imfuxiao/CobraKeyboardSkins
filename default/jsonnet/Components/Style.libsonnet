// 与皮肤内容无关的底层工具：样式节点构造 + 深浅色解析。
// 本文件不 import 任何东西，也不知道「极简」的存在。

// 把整棵配置树里所有 { light, dark } 形式的值替换成当前配色方案下的具体色值。
//
// 这是本皮肤唯一处理「深色 / 浅色」的地方：所有构造函数都只写色名，
// 到最后一步（main.jsonnet）才把整棵树 resolve 一次，
// 于是 isDark 不必作为参数穿过每一个函数。
local resolve(value, isDark) =
  if std.isObject(value) then
    if std.objectHas(value, 'light') && std.objectHas(value, 'dark') then
      (if isDark then value.dark else value.light)
    else
      { [k]: resolve(value[k], isDark) for k in std.objectFields(value) }
  else if std.isArray(value) then
    [resolve(item, isDark) for item in value]
  else
    value;

// 从对象里挑出指定的字段，没有的就不出现。
local pick(obj, keys) = { [key]: obj[key] for key in keys if std.objectHas(obj, key) };

// 各类样式节点允许出现的字段。不在表里的字段会被丢掉，
// 免得手滑写出的键名混进产物里（引擎对不认识的 Key 是静默忽略的）。
local geometryKeys = [
  'insets',
  'size',
  'normalColor',
  'highlightColor',
  'normalBorderColor',
  'highlightBorderColor',
  'normalLowerEdgeColor',
  'highlightLowerEdgeColor',
  'normalShadowColor',
  'highlightShadowColor',
  'colorLocation',
  'colorStartPoint',
  'colorEndPoint',
  'colorGradientType',
  'cornerRadius',
  'borderSize',
  'shadowRadius',
  'shadowOffset',
  'shadowOpacity',
];

local textKeys = ['insets', 'center', 'text', 'fontSize', 'fontWeight', 'normalColor', 'highlightColor'];

local systemImageKeys = [
  'insets',
  'center',
  'systemImageName',
  'highlightSystemImageName',
  'contentMode',
  'fontSize',
  'fontWeight',
  'normalColor',
  'highlightColor',
];

// 键盘配置根节点里的结构性 Key。它们不是样式名，永远保留。
local structuralKeys = std.set([
  'preeditHeight',
  'preeditStyle',
  'toolbarHeight',
  'toolbarStyle',
  'toolbarLayout',
  'keyboardHeight',
  'keyboardStyle',
  'keyboardLayout',
  'horizontalCandidatesStyle',
  'horizontalCandidatesLayout',
  'verticalCandidatesStyle',
  'verticalCandidatesLayout',
  'candidateContextMenu',
]);

// 收集整棵树里出现过的全部字符串。样式之间的引用都是字符串，
// 所以「被引用的样式名」一定在这个集合里。
local collectStrings(value) =
  if std.isString(value) then [value]
  else if std.isArray(value) then std.flattenArrays([collectStrings(item) for item in value])
  else if std.isObject(value) then std.flattenArrays([collectStrings(value[k]) for k in std.objectFields(value)])
  else [];

{
  resolve: resolve,
  pick: pick,

  // 丢掉没有任何地方引用的样式节点。
  //
  // 共享构件（Shift 的两个状态态前景、蓝色回车……）是按「全套角色」生成的，
  // 但一份键盘往往只用到其中几个——数字页就没有 Shift。
  // 这里在出文件前扫一遍：根节点下的名字，除结构性 Key 外，
  // 只要整棵树里没有任何字符串引用它，就不写进产物。
  prune(document)::
    local referenced = std.set(collectStrings(document));
    {
      [name]: document[name]
      for name in std.objectFields(document)
      if std.setMember(name, structuralKeys) || std.setMember(name, referenced)
    },

  // ===== 五种样式节点 =====
  // buttonStyleType 是必填项，缺失时该样式静默不渲染，所以统一由这几个构造函数补上。
  geometry(params={}):: { buttonStyleType: 'geometry' } + pick(params, geometryKeys),
  text(params={}):: { buttonStyleType: 'text' } + pick(params, textKeys),
  systemImage(params={}):: { buttonStyleType: 'systemImage' } + pick(params, systemImageKeys),
  assetImage(params={}):: { buttonStyleType: 'assetImage' }
                          + pick(params, ['insets', 'assetImageName', 'contentMode', 'normalColor', 'highlightColor']),
  fileImage(params={}):: { buttonStyleType: 'fileImage' }
                         + pick(params, ['insets', 'contentMode', 'normalImage', 'highlightImage']),

  // 条件样式：命中 conditionKey 的取值时改用 styleName。
  when(conditionKey, conditionValue, styleName):: {
    conditionKey: conditionKey,
    conditionValue: conditionValue,
    styleName: styleName,
  },

  // 把若干个「样式名 -> 样式节点」的片段合并成一份扁平配置。
  // 键盘配置文件的根节点就是这样一个大字典。
  merge(fragments):: std.foldl(function(acc, item) acc + item, fragments, {}),
}
