local skins = [
  {
    name: '彩虹',
    phone: import '../彩虹/jsonnet/Keyboards/iPhonePinyin.libsonnet',
    pad: import '../彩虹/jsonnet/Keyboards/iPadPinyin.libsonnet',
  },
  {
    name: '莫吉托',
    phone: import '../莫吉托/jsonnet/Keyboards/iPhonePinyin.libsonnet',
    pad: import '../莫吉托/jsonnet/Keyboards/iPadPinyin.libsonnet',
  },
  {
    name: '胭云',
    phone: import '../胭云/jsonnet/Keyboards/iPhonePinyin.libsonnet',
    pad: import '../胭云/jsonnet/Keyboards/iPadPinyin.libsonnet',
  },
  {
    name: 'Gboard',
    phone: { new(isPortrait):: (import '../Gboard/jsonnet/Keyboards/Pinyin.libsonnet').new(device='iPhone', isPortrait=isPortrait) },
    pad: { new(isPortrait):: (import '../Gboard/jsonnet/Keyboards/Pinyin.libsonnet').new(device='iPad', isPortrait=isPortrait) },
  },
  {
    name: 'Noctua',
    phone: import '../Noctua/jsonnet/Keyboards/iPhonePinyin.libsonnet',
    pad: import '../Noctua/jsonnet/Keyboards/iPadPinyin.libsonnet',
  },
] + [
  {
    name: 'hamster-' + (if dark then 'dark' else 'light'),
    phone: { new(isPortrait):: (import '../hamster/jsonnet/Keyboards/iPhonePinyin.libsonnet').new(isDark=dark, isPortrait=isPortrait, addSemicolon=false) },
    pad: { new(isPortrait):: (import '../hamster/jsonnet/Keyboards/iPadPinyin.libsonnet').new(isDark=dark, isPortrait=isPortrait) },
  }
  for dark in [false, true]
];

local effective(node, split) = node + (if split && std.objectHas(node, 'split') then node.split else {});
local bounds(node) = if std.objectHas(node, 'bounds') then node.bounds else {};
local cases = [
  { skin: skin.name, device: device, portrait: portrait, keyboard: skin[device].new(isPortrait=portrait) }
  for skin in skins
  for device in ['phone', 'pad']
  for portrait in [true, false]
];
local checks = [
  local keyboard = case.keyboard;
  local button = keyboard[name];
  local notification = keyboard[notificationName];
  local original = effective(button, split);
  local preedit = effective(notification, split);
  {
    skin: case.skin,
    device: case.device,
    portrait: case.portrait,
    split: split,
    button: name,
    matches: bounds(original) == bounds(preedit),
    backgroundMatches: original.backgroundStyle == preedit.backgroundStyle,
    text: keyboard[notification.foregroundStyle].text,
  }
  for case in cases
  for name in std.objectFields(case.keyboard)
  if std.isObject(case.keyboard[name])
     && std.objectHas(case.keyboard[name], 'action')
     && case.keyboard[name].action == 'shift'
  for notificationName in case.keyboard[name].notification
  if case.keyboard[notificationName].notificationType == 'preeditChanged'
  for split in [false, true]
];
local failures = [c for c in checks if !c.matches || !c.backgroundMatches || c.text != 'Esc'];
assert std.length(checks) > 0;
assert std.length(failures) == 0 : std.manifestJson(failures);
{ checked: std.length(checks), result: 'PASS' }
