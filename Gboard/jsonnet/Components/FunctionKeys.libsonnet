// 功能键 —— 每个功能键的「外观 + 动作 + 通知」都收在自己的一个函数里。
//
// 通知（notification）是引擎的状态回调：某个状态命中时按键改用另一套样式。
// 它必须和按键成对出现，所以不单独建文件，谁用谁定义。
//
// 与「彩虹」不同的是，本皮肤的角色不跟位置走（Gboard 只有白键和灰键两种），
// 所以角色写死在各函数里，调用方一般只需要传 name 与 size。
local Fonts = import '../Constants/Fonts.libsonnet';
local Metrics = import '../Constants/Metrics.libsonnet';
local Button = import 'Button.libsonnet';
local Theme = import 'Theme.libsonnet';

local iconLabel(systemImageName) = { systemImageName: systemImageName };
local textLabel(text) = { text: text, fontSize: Fonts.keyText };

local plainRole = 'function';
local pillRole = 'pill';
local primaryRole = 'primary';

{
  // 上档键（z 键左边那颗）。
  //
  // Gboard 中文键盘这个位置放的是分词键，本皮肤反过来：**点按是 Shift**，
  // 分词符 ' 挪到**下划**，键面右上角标着它。
  // 大写态换 shift.fill、大写锁定换 capslock.fill，与仓库里其他皮肤的上档键一致。
  //
  // 这颗键**不接上划**：它上面就是 z 那一行，往上划很容易是在够上一行的字母，
  // 接了动作只会误触。角标也跟着去掉——这套皮肤里角标的读法只有一个，
  // 就是「上划出这个」，上划空了还画着角标就是在说假话。
  // 分词符仍在下划上，只是键面不再标它。
  //
  // 有预编辑文本时整颗键变成 Esc（重输）：这一档优先级最高，
  // 正在拼一个字的时候按它是要重来，不是要切大小写。
  shift(name, opts={}):: Button.new(name, {
    role: plainRole,
    label: iconLabel('shift'),
    uppercasedLabel: iconLabel('shift.fill'),
    capsLockedLabel: iconLabel('capslock.fill'),
    action: 'shift',
    preeditStateAction: { shortcut: '#重输' },
    swipeDownAction: { character: "'" },
    notification: [name + 'PreeditNotification'],
  } + opts) + {
    [name + 'PreeditNotification']: {
      notificationType: 'preeditChanged',
      backgroundStyle: Theme.backgroundName(plainRole),
      foregroundStyle: name + 'EscLabel',
    },
    [name + 'EscLabel']: Button.paint(textLabel('Esc'), Button.roleTint(plainRole), Fonts.keyText),
  },

  backspace(name, opts={}):: Button.new(name, {
    role: plainRole,
    label: { systemImageName: 'delete.left', highlightSystemImageName: 'delete.left.fill' },
    action: 'backspace',
    repeatAction: 'backspace',
  } + opts),

  // 回车键：iOS systemBlue 的胶囊 + ⏎ 图标，按下换深一档的蓝。整块键盘上唯一的彩色键面。
  //
  // **不接任何条件样式与通知**，任何状态下都是这一套。原先让它跟着 returnKeyType 换
  // 「前往 / 搜索 / 发送」文案、跟着 preedit 重新求值，实测两头都不讨好：
  // 通知节点在生效期间会整个替代按键的样式节点（见下），漏写一项那一层就被清掉；
  // 条件前景（styleName 数组）在通知把状态切回常态时也求不回来，于是变成一颗纯蓝的空键。
  // 底色反正不随 returnKeyType 变，条件与通知就都没有存在的必要了。
  enter(name, opts={}):: Button.new(name, {
    role: primaryRole,
    label: iconLabel('return'),
    action: 'enter',
    swipeUpAction: { symbol: '\r\n' },  // 上划换行
  } + opts),

  // 空格：键面写的是当前方案名（Gboard 上写「拼音」的就是这一处），
  // 有预编辑文本时改成「选定」。
  //
  // 上划切中英（`#中英切换` 翻的是 Rime 的 ascii_mode）。拼音、数字、符号三页共用这一档：
  // 中英切换是跨页面的全局状态，切到哪一页都该能翻，手势记一次就够。
  // 九宫格那颗空格在右侧功能列里，另有自己的构造，不走这里。
  space(name, opts={}):: Button.new(name, {
    role: 'space',
    label: { text: '$rimeSchemaName' },
    labelFontSize: Fonts.spaceLabel,
    action: 'space',
    swipeUpAction: { shortcut: '#中英切换' },
    notification: [name + 'PreeditNotification'],
  } + opts) + {
    [name + 'PreeditNotification']: {
      notificationType: 'preeditChanged',
      backgroundStyle: Theme.backgroundName('space'),
      foregroundStyle: name + 'CommitLabel',
    },
    [name + 'CommitLabel']: Button.paint(textLabel('选定'), Button.roleTint('space'), Fonts.spaceLabel),
  },

  // 切换键盘类型的灰键：?123 / =\< / !?# / 12·34 都走这一个函数。
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

  // 「返回」：回到主键盘（用户设定的那一个，通常是拼音）。与回车一样是灰胶囊。
  //
  // 用 returnPrimaryKeyboard 而不是 returnLastKeyboard：后者弹的是键盘类型栈，
  // 在「拼音 → 数字 → 符号 → 九宫格」这样连跳几页之后，按「返回」只退一格，
  // 要连按好几次才回得到拼音。returnPrimaryKeyboard 一步到位。
  returnPrimaryKeyboard(name, opts={}):: Button.new(name, {
    role: pillRole,
    label: { text: '返回' },
    labelFontSize: Fonts.keyText,
    action: 'returnPrimaryKeyboard',
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
