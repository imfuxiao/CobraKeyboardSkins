// 与皮肤内容无关的底层工具：片段合并、条件样式、未引用样式清理。
// 本文件不 import 任何东西。颜色沿用 hamster 既有的 isDark 参数模型
// （BasicStyle/Utils 里每个构造函数都显式接收 isDark），不做 default 那种
// { light, dark } 树 + 统一 resolve 的模型迁移，避免大范围改动引入回归。

// 键盘配置根节点里的结构性 Key。它们不是样式名，prune 时永远保留。
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
  // 把若干个「样式名 -> 样式节点」的片段合并成一份扁平配置。
  // 键盘配置文件的根节点就是这样一个大字典。
  merge(fragments):: std.foldl(function(acc, item) acc + item, fragments, {}),

  // 条件样式：命中 conditionKey 的取值时改用 styleName。
  when(conditionKey, conditionValue, styleName):: {
    conditionKey: conditionKey,
    conditionValue: conditionValue,
    styleName: styleName,
  },

  // 丢掉没有任何地方引用的样式节点（split 状态切换键在不支持 Split 的
  // 键盘里不会被 toolbarLayout 引用，靠这个自动从产物里消失）。
  prune(document)::
    local referenced = std.set(collectStrings(document));
    {
      [name]: document[name]
      for name in std.objectFields(document)
      if std.setMember(name, structuralKeys) || std.setMember(name, referenced)
    },
}
