// 功能键 —— 每个功能键的「外观 + 动作 + 通知」都收在自己的一个函数里。
//
// 通知（notification）是引擎的状态回调：某个状态命中时按键改用另一套样式。
// 它必须和按键成对出现，所以不单独建文件，谁用谁定义。
//
// 本皮肤的角色不跟位置走（只有米 / 沙 / 棕三档，见 Constants/Colors.libsonnet），
// 所以角色写死在各函数里，调用方一般只需要传 name 与 size。
// 个别键要换档时，把 role 写进 opts 即可覆盖——opts 排在最后。
local Fonts = import '../Constants/Fonts.libsonnet';
local Metrics = import '../Constants/Metrics.libsonnet';
local Button = import 'Button.libsonnet';
local Theme = import 'Theme.libsonnet';

local iconLabel(systemImageName) = { systemImageName: systemImageName };
local textLabel(text) = { text: text, fontSize: Fonts.keyText };

// 三档角色，对应风扇上的三种面：米白的框、沙色的过渡、棕色的叶片与角垫
local plainRole = 'function';
local accentRole = 'accent';
local primaryRole = 'primary';

{
  // 上档键：常态 shift，大写 shift.fill，大写锁定 capslock.fill；
  // 有预编辑文本时整颗键变成 Esc（重输）——正在拼一个字的时候按它是要重来，
  // 不是要切大小写，所以这一档优先级最高。上下划都发 Tab。
  shift(name, opts={}):: Button.new(name, {
    role: accentRole,
    label: iconLabel('shift'),
    uppercasedLabel: iconLabel('shift.fill'),
    capsLockedLabel: iconLabel('capslock.fill'),
    action: 'shift',
    preeditStateAction: { shortcut: '#重输' },
    swipeUpAction: { sendKeys: 'Tab' },
    swipeDownAction: { sendKeys: 'Tab' },
    notification: [name + 'PreeditNotification'],
  } + opts) + {
    // 通知节点必须把样式写全：引擎在通知生效期间是拿它**当这颗键的样式节点**用的，
    // 少写一个 backgroundStyle，那颗键的底就会被整个清掉。
    [name + 'PreeditNotification']: {
      notificationType: 'preeditChanged',
      backgroundStyle: Theme.backgroundName(accentRole),
      foregroundStyle: name + 'EscLabel',
    },
    [name + 'EscLabel']: Button.paint(textLabel('Esc'), Button.roleTint(accentRole), Fonts.keyText),
  },

  backspace(name, opts={}):: Button.new(name, {
    role: accentRole,
    label: { systemImageName: 'delete.left', highlightSystemImageName: 'delete.left.fill' },
    action: 'backspace',
    repeatAction: 'backspace',
  } + opts),

  // 回车键：整块键盘上最重的一档——深棕，取自风扇的轮毂与四角减震垫。
  //
  // 键面写的是 `$returnKeyType`，引擎按当前输入框把它替换成「换行 / 前往 / 搜索 /
  // 发送 / 完成」。**底色不跟着 returnKeyType 换**，也不接条件样式与通知：
  // 条件样式（styleName 数组）与通知混用时，通知把状态切回常态那一下条件前景求不回来，
  // 那颗键会只剩一块空底色。既然深棕在任何场景下都是回车该有的分量，
  // 换色本来就没必要，索性把这一处的复杂度整个去掉。
  enter(name, opts={}):: Button.new(name, {
    role: primaryRole,
    label: textLabel('$returnKeyType'),
    action: 'enter',
    swipeUpAction: { symbol: '\r\n' },  // 上划换行
  } + opts),

  // 空格：键面写的是当前方案名（$rimeSchemaName），有预编辑文本时改成「选定」。
  // 上划次选上屏——中英切换另有一颗专门的键，不必挤在空格上。
  space(name, opts={}):: Button.new(name, {
    role: 'space',
    label: { text: '$rimeSchemaName' },
    labelFontSize: Fonts.spaceLabel,
    action: 'space',
    swipeUpAction: { shortcut: '#次选上屏' },
    notification: [name + 'PreeditNotification'],
  } + opts) + {
    [name + 'PreeditNotification']: {
      notificationType: 'preeditChanged',
      backgroundStyle: Theme.backgroundName('space'),
      foregroundStyle: name + 'CommitLabel',
    },
    [name + 'CommitLabel']: Button.paint(textLabel('选定'), Button.roleTint('space'), Fonts.spaceLabel),
  },

  // 中英切换：图标跟着 RIME 的 ascii_mode 走；有预编辑文本时变成「次」（次选上屏）。
  asciiMode(name, opts={}):: Button.new(name, {
    role: plainRole,
    label: { assetImageName: 'chineseState2' },
    action: { shortcut: '#中英切换' },
    preeditStateAction: { shortcut: '#次选上屏' },
    // 前景直接按 RIME 的 ascii_mode 当场判定：切走再切回键盘时按键会重新创建，
    // 此时不会补发 optionChanged 通知，只有条件样式能还原出正确的中/英图标。
    foregroundStyle: [
      {
        styleName: name + 'EnglishLabel',
        conditionKey: 'rime$ascii_mode',
        conditionValue: true,
      },
      {
        styleName: name + 'ChineseLabel',
        conditionKey: 'rime$ascii_mode',
        conditionValue: false,
      },
    ],
    // 只订阅 English 一条：中文态由它把 dynamicStyleName 清空、回落到上面的条件样式即可。
    // 中英两条都订阅会互相覆盖（后到的一条把先到的结果抹成 nil），状态因此不稳定。
    notification: [
      name + 'EnglishNotification',
      name + 'PreeditNotification',
    ],
  } + opts) + {
    [name + 'EnglishNotification']: {
      notificationType: 'rime',
      rimeNotificationType: 'optionChanged',
      rimeOptionName: 'ascii_mode',
      rimeOptionValue: true,
      backgroundStyle: Theme.backgroundName(plainRole),
      foregroundStyle: name + 'EnglishLabel',
    },
    [name + 'PreeditNotification']: {
      notificationType: 'preeditChanged',
      backgroundStyle: Theme.backgroundName(plainRole),
      foregroundStyle: name + 'SecondCandidateLabel',
    },
    [name + 'ChineseLabel']: Button.paint({ assetImageName: 'chineseState2' }, Button.roleTint(plainRole), Fonts.keyText),
    [name + 'EnglishLabel']: Button.paint({ assetImageName: 'englishState2' }, Button.roleTint(plainRole), Fonts.keyText),
    [name + 'SecondCandidateLabel']: Button.paint(textLabel('次'), Button.roleTint(plainRole), Fonts.keyText),
  },

  // 切到数字键盘（拼音页第四行最左那颗）
  numeric(name, opts={}):: Button.new(name, {
    role: plainRole,
    label: textLabel('123'),
    action: { keyboardType: 'numeric' },
  } + opts),

  // 切换键盘类型的沙色键：?123 / =\< / !?# 都走这一个函数。
  //   text          键面文字
  //   keyboardType  目标键盘类型
  switchKeyboard(name, text, keyboardType, opts={}):: Button.new(name, {
    role: plainRole,
    label: { text: text },
    labelFontSize: Fonts.keyText,
    action: { keyboardType: keyboardType },
  } + opts),

  // 「12 / 34」——切到九宫格数字键盘。键面是上下两行，所以单独一个函数。
  numberPad(name, opts={}):: Button.new(name, {
    role: 'letter',
    label: { text: '34', center: Metrics.key.doubleBottomCenter },
    labelFontSize: Fonts.keyDouble,
    secondaryLabel: { text: '12', center: Metrics.key.doubleTopCenter },
    action: { keyboardType: 'numberPad' },
  } + opts),

  // 「返回」：回到主键盘（用户设定的那一个，通常是拼音）。
  //
  // 用 returnPrimaryKeyboard 而不是 returnLastKeyboard：后者弹的是键盘类型栈，
  // 在「拼音 → 数字 → 符号 → 九宫格」这样连跳几页之后，按「返回」只退一格，
  // 要连按好几次才回得到拼音。returnPrimaryKeyboard 一步到位。
  returnPrimaryKeyboard(name, opts={}):: Button.new(name, {
    role: plainRole,
    label: { text: '返回' },
    labelFontSize: Fonts.keyText,
    action: 'returnPrimaryKeyboard',
  } + opts),

  tab(name, opts={}):: Button.new(name, {
    role: plainRole,
    label: iconLabel('arrow.right.to.line'),
    action: 'tab',
  } + opts),

  // 收起键盘
  dismiss(name, opts={}):: Button.new(name, {
    role: plainRole,
    label: iconLabel('keyboard.chevron.compact.down'),
    action: 'dismissKeyboard',
  } + opts),

  // 切换到下一个输入法
  nextKeyboard(name, opts={}):: Button.new(name, {
    role: plainRole,
    label: iconLabel('globe'),
    action: 'nextKeyboard',
  } + opts),
}
