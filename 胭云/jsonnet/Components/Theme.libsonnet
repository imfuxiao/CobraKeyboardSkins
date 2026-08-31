// 主题层：把「按键角色」翻译成实际的样式节点与样式名。
//
// 上层（Button / Keyboards）只说「这个键是 letter 角色」，
// 具体长什么样全部由本文件决定；反过来，本文件不知道有哪些键。
local Colors = import '../Constants/Colors.libsonnet';
local Metrics = import '../Constants/Metrics.libsonnet';
local Style = import 'Style.libsonnet';

// ===== 约定的样式名 =====
local backgroundName(role) = role + 'KeyBackground';
local keyboardBackgroundName = 'keyboardBackground';
local hintBackgroundName = 'hintBackground';

local role(name) =
  assert std.objectHas(Colors.roles, name) : '未定义的按键角色: ' + name;
  Colors.roles[name];

// 一个角色对应的按键背景：圆角矩形 + 底部立体边缘
local backgroundStyle(name) =
  local r = role(name);
  function(insets) Style.geometry({
    insets: insets,
    cornerRadius: Metrics.key.cornerRadius,
    normalColor: r.fill,
    highlightColor: r.pressed,
    normalLowerEdgeColor: r.edge,
    highlightLowerEdgeColor: r.edge,
  });

{
  backgroundName: backgroundName,
  keyboardBackgroundName: keyboardBackgroundName,
  hintBackgroundName: hintBackgroundName,

  // 分割线色，符号面板一类的集合视图会用到
  dividerColor: Colors.divider,

  // 角色的字色，供 Button 构造前景样式时取用
  ink(name):: role(name).ink,
  inkPressed(name):: role(name).inkPressed,
  // 减淡字色，用于角标；角色没单独声明时退回常态字色
  inkSoft(name):: (
    local r = role(name);
    if std.objectHas(r, 'inkSoft') then r.inkSoft else r.ink
  ),

  // 所有键盘都要带上的共享样式节点。
  // insets 随设备与方向变化，所以做成参数而不是常量。
  shared(insets):: {
    [keyboardBackgroundName]: Style.geometry({
      normalColor: Colors.keyboardBackground,
    }),
    [hintBackgroundName]: Style.geometry({
      normalColor: Colors.hint.fill,
      normalBorderColor: Colors.hint.border,
      borderSize: Metrics.hint.borderSize,
      cornerRadius: Metrics.hint.cornerRadius,
    }),
  } + {
    // 每个角色一份按键背景，共 8 份，全部由 Colors.roles 表驱动
    [backgroundName(name)]: backgroundStyle(name)(insets)
    for name in std.objectFields(Colors.roles)
  },
}
