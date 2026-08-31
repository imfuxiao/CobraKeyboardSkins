// 与皮肤内容无关的底层工具：样式节点构造 + 深浅色解析。
// 本文件不 import 任何东西，也不知道「莫吉托」的存在，可以整份搬到别的皮肤里用。

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

// 键盘配置根节点里的结构性 Key（keys.md 4.1）。它们不是样式名，永远保留。
local structuralKeys = std.set([
  'preeditHeight',
  'toolbarHeight',
  'keyboardHeight',
  'preeditStyle',
  'toolbarStyle',
  'toolbarLayout',
  'keyboardStyle',
  'keyboardLayout',
  'horizontalCandidatesStyle',
  'horizontalCandidatesLayout',
  'verticalCandidatesStyle',
  'verticalCandidatesLayout',
  'candidateContextMenu',
  'floatTargetScale',
  'floatKeyboardAlpha',
  'floatKeyboardLockedState',
]);

// 收集整棵树里出现过的全部字符串。样式之间的引用都是字符串，
// 所以「被引用的样式名」一定在这个集合里。
local collectStrings(value) =
  if std.isString(value) then
    [value]
  else if std.isArray(value) then
    std.flattenArrays([collectStrings(item) for item in value])
  else if std.isObject(value) then
    std.flattenArrays([collectStrings(value[k]) for k in std.objectFields(value)])
  else
    [];

{
  resolve: resolve,

  // ===== 五种样式节点 =====
  // buttonStyleType 是必填项，缺失时该样式静默不渲染，所以统一由这几个构造函数补上。
  geometry(params={}):: { buttonStyleType: 'geometry' } + params,
  text(params={}):: { buttonStyleType: 'text' } + params,
  systemImage(params={}):: { buttonStyleType: 'systemImage' } + params,
  assetImage(params={}):: { buttonStyleType: 'assetImage' } + params,
  fileImage(params={}):: { buttonStyleType: 'fileImage' } + params,

  // 条件样式：命中 conditionKey 的取值时改用 styleName。
  // 用于回车键随 returnKeyType（前往 / 搜索 / 发送……）换色。
  when(conditionKey, conditionValue, styleName):: {
    conditionKey: conditionKey,
    conditionValue: conditionValue,
    styleName: styleName,
  },

  // 把若干个「样式名 -> 样式节点」的片段合并成一份扁平配置。
  // 键盘配置文件的根节点就是这样一个大字典。
  merge(fragments):: std.foldl(function(acc, item) acc + item, fragments, {}),

  // 丢掉没有任何地方引用的样式节点。
  //
  // 通用构件（按键背景、气泡背景……）是按「全套角色」生成的，
  // 但一份键盘往往只用到其中几个——数字键盘就没有 Shift，也不弹气泡。
  // 这里在出文件前扫一遍：根节点下的名字，除结构性 Key 外，
  // 只要整棵树里没有任何字符串引用它，就不写进产物。
  prune(document)::
    local referenced = std.set(collectStrings(document));
    {
      [name]: document[name]
      for name in std.objectFields(document)
      if std.setMember(name, structuralKeys) || std.setMember(name, referenced)
    },
}
