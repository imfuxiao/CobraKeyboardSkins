// 底层样式工具：样式节点构造、深浅色递归解析、无用样式裁剪。
// 本文件不依赖任何业务模块。

// 把整棵配置树里所有 { light, dark } 令牌替换为当前主题色值。
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

local pick(obj, keys) = { [key]: obj[key] for key in keys if std.objectHas(obj, key) };

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

local assetImageKeys = ['insets', 'assetImageName', 'contentMode', 'normalColor', 'highlightColor'];

local fileImageKeys = ['insets', 'contentMode', 'normalImage', 'highlightImage'];

// 键盘配置根节点的结构性字段，裁剪时永远保留。
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

local collectStrings(value) =
  if std.isString(value) then [value]
  else if std.isArray(value) then std.flattenArrays([collectStrings(item) for item in value])
  else if std.isObject(value) then std.flattenArrays([collectStrings(value[k]) for k in std.objectFields(value)])
  else [];

{
  resolve: resolve,
  pick: pick,

  // 裁剪根节点下未被任何结构或样式引用的冗余节点。
  prune(document)::
    local referenced = std.set(collectStrings(document));
    {
      [name]: document[name]
      for name in std.objectFields(document)
      if std.setMember(name, structuralKeys) || std.setMember(name, referenced)
    },

  // ===== 五种样式节点构造器 =====
  geometry(params={}):: { buttonStyleType: 'geometry' } + pick(params, geometryKeys),
  text(params={}):: { buttonStyleType: 'text' } + pick(params, textKeys),
  systemImage(params={}):: { buttonStyleType: 'systemImage' } + pick(params, systemImageKeys),
  assetImage(params={}):: { buttonStyleType: 'assetImage' } + pick(params, assetImageKeys),
  fileImage(params={}):: { buttonStyleType: 'fileImage' } + pick(params, fileImageKeys),

  when(conditionKey, conditionValue, styleName):: {
    conditionKey: conditionKey,
    conditionValue: conditionValue,
    styleName: styleName,
  },

  merge(fragments):: std.foldl(function(acc, item) acc + item, fragments, {}),
}
