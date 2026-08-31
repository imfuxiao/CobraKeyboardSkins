// 功能键 —— 每个功能键的「外观 + 动作 + 通知」都收在自己的一个函数里。
//
// 通知（notification）是引擎的状态回调：某个状态命中时按键改用另一套样式。
// 它必须和按键成对出现，所以不单独建文件，谁用谁定义。
//
// 所有函数都接受 name 与 opts：
//   name  按键名（iPad 左右各有一个 Shift，所以名字由调用方给）
//   opts  额外写进按键节点的 Key，通常只有 size / bounds
local Fonts = import '../Constants/Fonts.libsonnet';
local Button = import 'Button.libsonnet';
local Style = import 'Style.libsonnet';
local Theme = import 'Theme.libsonnet';

// 回车键随系统 returnKeyType 换色：普通场景用珊瑚，「前往 / 下一项 / 发送 / 完成」用深胭脂。
local plainReturnKeyTypes = [0, 2, 3, 5, 6, 8, 11];
local accentReturnKeyTypes = [1, 4, 7, 9, 10];

local iconLabel(systemImageName) = { systemImageName: systemImageName };
local textLabel(text) = { text: text, fontSize: Fonts.keyText };

{
  // 上档键：常态 shift，大写 shift.fill，大写锁定 capslock.fill；
  // 有预编辑文本时变成 Esc（重输），上下划发 Tab。
  shift(name, opts={}):: Button.new(name, {
    role: 'shift',
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
      backgroundStyle: Theme.backgroundName('shift'),
      foregroundStyle: name + 'EscLabel',
    },
    [name + 'EscLabel']: Button.paint(textLabel('Esc'), Button.roleTint('shift'), Fonts.keyText),
  },

  backspace(name, opts={}):: Button.new(name, {
    role: 'backspace',
    label: { systemImageName: 'delete.left', highlightSystemImageName: 'delete.left.fill' },
    action: 'backspace',
    repeatAction: 'backspace',
  } + opts),

  // 回车键：底色与文案都跟着 returnKeyType 走。
  // 条件样式负责首次渲染，两个通知负责后续状态变化时重新求值。
  enter(name, opts={})::
    local backgrounds = [
      Style.when('$returnKeyType', plainReturnKeyTypes, Theme.backgroundName('enter')),
      Style.when('$returnKeyType', accentReturnKeyTypes, Theme.backgroundName('enterAccent')),
    ];
    local foregrounds = [
      Style.when('$returnKeyType', plainReturnKeyTypes, name + 'Label'),
      Style.when('$returnKeyType', accentReturnKeyTypes, name + 'AccentLabel'),
    ];
    Button.new(name, {
      role: 'enter',
      label: textLabel('$returnKeyType'),
      backgroundStyle: backgrounds,
      foregroundStyle: foregrounds,
      action: 'enter',
      swipeUpAction: { symbol: '\r\n' },  // 上划换行
      notification: [name + 'ReturnKeyTypeNotification', name + 'PreeditNotification'],
    } + opts) + {
      [name + 'AccentLabel']: Button.paint(textLabel('$returnKeyType'), Button.roleTint('enterAccent'), Fonts.keyText),
      [name + 'ReturnKeyTypeNotification']: {
        notificationType: 'returnKeyType',
        returnKeyType: accentReturnKeyTypes,
        backgroundStyle: Theme.backgroundName('enterAccent'),
        foregroundStyle: name + 'AccentLabel',
      },
      [name + 'PreeditNotification']: {
        notificationType: 'preeditChanged',
        backgroundStyle: backgrounds,
        foregroundStyle: foregrounds,
      },
    },

  // 空格：有预编辑文本时提示「选定」，上划次选上屏。
  space(name, opts={}):: Button.new(name, {
    role: 'space',
    label: iconLabel('space'),
    action: 'space',
    swipeUpAction: { shortcut: '#次选上屏' },
    notification: [name + 'PreeditNotification'],
  } + opts) + {
    [name + 'PreeditNotification']: {
      notificationType: 'preeditChanged',
      backgroundStyle: Theme.backgroundName('space'),
      foregroundStyle: name + 'CommitLabel',
    },
    [name + 'CommitLabel']: Button.paint(textLabel('选定'), Button.roleTint('space'), Fonts.keyText),
  },

  // 中英切换：图标跟着 RIME 的 ascii_mode 走；有预编辑文本时变成「次」（次选上屏）。
  asciiMode(name, opts={}):: Button.new(name, {
    role: 'functional',
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
      backgroundStyle: Theme.backgroundName('functional'),
      foregroundStyle: name + 'ChineseLabel',
    },
    [name + 'EnglishNotification']: {
      notificationType: 'rime',
      rimeNotificationType: 'optionChanged',
      rimeOptionName: 'ascii_mode',
      rimeOptionValue: true,
      backgroundStyle: Theme.backgroundName('functional'),
      foregroundStyle: name + 'EnglishLabel',
    },
    [name + 'PreeditNotification']: {
      notificationType: 'preeditChanged',
      backgroundStyle: Theme.backgroundName('functional'),
      foregroundStyle: name + 'SecondCandidateLabel',
    },
    [name + 'ChineseLabel']: Button.paint({ assetImageName: 'chineseState2' }, Button.roleTint('functional'), Fonts.keyText),
    [name + 'EnglishLabel']: Button.paint({ assetImageName: 'englishState2' }, Button.roleTint('functional'), Fonts.keyText),
    [name + 'SecondCandidateLabel']: Button.paint(textLabel('次'), Button.roleTint('functional'), Fonts.keyText),
  },

  // 切到数字键盘
  numeric(name, opts={}):: Button.new(name, {
    role: 'symbol',
    label: textLabel('123'),
    action: { keyboardType: 'numeric' },
  } + opts),

  // 切到符号键盘
  symbolic(name, opts={}):: Button.new(name, {
    role: 'symbol',
    label: textLabel('#+='),
    action: { keyboardType: 'symbolic' },
  } + opts),

  // 数字键盘上的「返回」：回到进入数字键盘之前的那个键盘
  returnLastKeyboard(name, opts={}):: Button.new(name, {
    role: 'symbol',
    label: textLabel('返回'),
    action: 'returnLastKeyboard',
  } + opts),

  tab(name, opts={}):: Button.new(name, {
    role: 'symbol',
    label: iconLabel('arrow.right.to.line'),
    action: 'tab',
  } + opts),

  // 收起键盘
  dismiss(name, opts={}):: Button.new(name, {
    role: 'functional',
    label: iconLabel('keyboard.chevron.compact.down'),
    action: 'dismissKeyboard',
  } + opts),

  // 切换到下一个输入法
  nextKeyboard(name, opts={}):: Button.new(name, {
    role: 'functional',
    label: iconLabel('globe'),
    action: 'nextKeyboard',
  } + opts),
}
