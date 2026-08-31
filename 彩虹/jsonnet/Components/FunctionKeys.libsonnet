// 功能键 —— 每个功能键的「外观 + 动作 + 通知」都收在自己的一个函数里。
//
// 通知（notification）是引擎的状态回调：某个状态命中时按键改用另一套样式。
// 它必须和按键成对出现，所以不单独建文件，谁用谁定义。
//
// 所有函数都接受 name、role 与 opts：
//   name  按键名（iPad 左右各有一个 Shift，所以名字由调用方给）
//   role  按键角色（见 Constants/Colors.libsonnet）
//   opts  额外写进按键节点的 Key，通常只有 size / bounds
//
// role 是参数而不是写死的常量：本皮肤的色相跟着按键的**水平位置**走，
// 同一个功能键放在键盘左边和右边就该是两个颜色，只有键盘文件知道它在哪。
local Fonts = import '../Constants/Fonts.libsonnet';
local Button = import 'Button.libsonnet';
local Style = import 'Style.libsonnet';
local Theme = import 'Theme.libsonnet';

// 回车键随系统 returnKeyType 换色：普通场景用它所在位置的色相，
// 「前往 / 下一项 / 发送 / 完成」换成主题色玫红。
local plainReturnKeyTypes = [0, 2, 3, 5, 6, 8, 11];
local accentReturnKeyTypes = [1, 4, 7, 9, 10];

local iconLabel(systemImageName) = { systemImageName: systemImageName };
local textLabel(text) = { text: text, fontSize: Fonts.keyText };

{
  // 上档键：常态 shift，大写 shift.fill，大写锁定 capslock.fill；
  // 有预编辑文本时变成 Esc（重输），上下划发 Tab。
  shift(name, role, opts={}):: Button.new(name, {
    role: role,
    label: iconLabel('shift'),
    uppercasedLabel: iconLabel('shift.fill'),
    capsLockedLabel: iconLabel('capslock.fill'),
    action: 'shift',
    preeditStateAction: { shortcut: '#重输' },
    swipeUpAction: { sendKeys: 'Tab' },
    swipeDownAction: { sendKeys: 'Tab' },
    notification: [name + 'PreeditNotification'],
  } + opts) + {
    [name + 'PreeditNotification']: {
      notificationType: 'preeditChanged',
      backgroundStyle: Theme.backgroundName(role),
      foregroundStyle: name + 'EscLabel',
    },
    [name + 'EscLabel']: Button.paint(textLabel('Esc'), Button.roleTint(role), Fonts.keyText),
  },

  backspace(name, role, opts={}):: Button.new(name, {
    role: role,
    label: { systemImageName: 'delete.left', highlightSystemImageName: 'delete.left.fill' },
    action: 'backspace',
    repeatAction: 'backspace',
  } + opts),

  // 回车键：底色与文案都跟着 returnKeyType 走。
  // 条件样式负责首次渲染，两个通知负责后续状态变化时重新求值。
  //   role        普通场景的角色（跟着位置走）
  //   accentRole  「前往 / 发送」等场景的角色（点名主题色）
  enter(name, role, accentRole, opts={})::
    local backgrounds = [
      Style.when('$returnKeyType', plainReturnKeyTypes, Theme.backgroundName(role)),
      Style.when('$returnKeyType', accentReturnKeyTypes, Theme.backgroundName(accentRole)),
    ];
    local foregrounds = [
      Style.when('$returnKeyType', plainReturnKeyTypes, name + 'Label'),
      Style.when('$returnKeyType', accentReturnKeyTypes, name + 'AccentLabel'),
    ];
    Button.new(name, {
      role: role,
      label: textLabel('$returnKeyType'),
      backgroundStyle: backgrounds,
      foregroundStyle: foregrounds,
      action: 'enter',
      swipeUpAction: { symbol: '\r\n' },  // 上划换行
      notification: [name + 'ReturnKeyTypeNotification', name + 'PreeditNotification'],
    } + opts) + {
      [name + 'AccentLabel']: Button.paint(textLabel('$returnKeyType'), Button.roleTint(accentRole), Fonts.keyText),
      [name + 'ReturnKeyTypeNotification']: {
        notificationType: 'returnKeyType',
        returnKeyType: accentReturnKeyTypes,
        backgroundStyle: Theme.backgroundName(accentRole),
        foregroundStyle: name + 'AccentLabel',
      },
      [name + 'PreeditNotification']: {
        notificationType: 'preeditChanged',
        backgroundStyle: backgrounds,
        foregroundStyle: foregrounds,
      },
    },

  // 空格：有预编辑文本时提示「选定」，上划次选上屏。
  space(name, role, opts={}):: Button.new(name, {
    role: role,
    label: iconLabel('space'),
    action: 'space',
    swipeUpAction: { shortcut: '#次选上屏' },
    notification: [name + 'PreeditNotification'],
  } + opts) + {
    [name + 'PreeditNotification']: {
      notificationType: 'preeditChanged',
      backgroundStyle: Theme.backgroundName(role),
      foregroundStyle: name + 'CommitLabel',
    },
    [name + 'CommitLabel']: Button.paint(textLabel('选定'), Button.roleTint(role), Fonts.keyText),
  },

  // 中英切换：图标跟着 RIME 的 ascii_mode 走；有预编辑文本时变成「次」（次选上屏）。
  asciiMode(name, role, opts={}):: Button.new(name, {
    role: role,
    label: { assetImageName: 'chineseState2' },
    action: { shortcut: '#中英切换' },
    preeditStateAction: { shortcut: '#次选上屏' },
    notification: [
      name + 'ChineseNotification',
      name + 'EnglishNotification',
      name + 'PreeditNotification',
    ],
  } + opts) + {
    [name + 'ChineseNotification']: {
      notificationType: 'rime',
      rimeNotificationType: 'optionChanged',
      rimeOptionName: 'ascii_mode',
      rimeOptionValue: false,
      backgroundStyle: Theme.backgroundName(role),
      foregroundStyle: name + 'ChineseLabel',
    },
    [name + 'EnglishNotification']: {
      notificationType: 'rime',
      rimeNotificationType: 'optionChanged',
      rimeOptionName: 'ascii_mode',
      rimeOptionValue: true,
      backgroundStyle: Theme.backgroundName(role),
      foregroundStyle: name + 'EnglishLabel',
    },
    [name + 'PreeditNotification']: {
      notificationType: 'preeditChanged',
      backgroundStyle: Theme.backgroundName(role),
      foregroundStyle: name + 'SecondCandidateLabel',
    },
    [name + 'ChineseLabel']: Button.paint({ assetImageName: 'chineseState2' }, Button.roleTint(role), Fonts.keyText),
    [name + 'EnglishLabel']: Button.paint({ assetImageName: 'englishState2' }, Button.roleTint(role), Fonts.keyText),
    [name + 'SecondCandidateLabel']: Button.paint(textLabel('次'), Button.roleTint(role), Fonts.keyText),
  },

  // 切到数字键盘
  numeric(name, role, opts={}):: Button.new(name, {
    role: role,
    label: textLabel('123'),
    action: { keyboardType: 'numeric' },
  } + opts),

  // 切到符号键盘
  symbolic(name, role, opts={}):: Button.new(name, {
    role: role,
    label: textLabel('#+='),
    action: { keyboardType: 'symbolic' },
  } + opts),

  // 数字键盘上的「返回」：回到进入数字键盘之前的那个键盘
  returnLastKeyboard(name, role, opts={}):: Button.new(name, {
    role: role,
    label: textLabel('返回'),
    action: 'returnLastKeyboard',
  } + opts),

  tab(name, role, opts={}):: Button.new(name, {
    role: role,
    label: iconLabel('arrow.right.to.line'),
    action: 'tab',
  } + opts),

  // 收起键盘
  dismiss(name, role, opts={}):: Button.new(name, {
    role: role,
    label: iconLabel('keyboard.chevron.compact.down'),
    action: 'dismissKeyboard',
  } + opts),

  // 切换到下一个输入法
  nextKeyboard(name, role, opts={}):: Button.new(name, {
    role: role,
    label: iconLabel('globe'),
    action: 'nextKeyboard',
  } + opts),
}
