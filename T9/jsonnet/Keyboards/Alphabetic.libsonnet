// 26 键英文键盘（九键皮肤内的英文切页，横竖屏共用）。
//
// 第二行（asdfghjkl）只有 9 颗键，两端 a / l 用 size 与 bounds 错开触摸区与显示区，
// 既保证边缘可点，又让键帽视觉与第一行对齐。
local Keys = import '../Constants/Keys.libsonnet';
local metrics = import '../Constants/Metrics.libsonnet';
local Button = import '../Components/Button.libsonnet';
local Layout = import '../Components/Layout.libsonnet';
local Preedit = import '../Components/Preedit.libsonnet';
local Style = import '../Components/Style.libsonnet';
local Theme = import '../Components/Theme.libsonnet';
local Toolbar = import '../Components/Toolbar.libsonnet';

local letterRows = ['qwertyuiop', 'asdfghjkl', 'zxcvbnm'];
local keyName(c) = c + 'Button';
local letterNames(row) = [keyName(c) for c in std.stringChars(row)];

local keyboardLayout = [
  Layout.row(letterNames(letterRows[0])),
  Layout.row(letterNames(letterRows[1])),
  Layout.row(['shiftButton'] + letterNames(letterRows[2]) + ['backspaceButton']),
  Layout.row(['numericButton', 'commaButton', 'spaceButton', 't9PinyinButton', 'enterButton']),
];

{
  new(isPortrait=true)::
    local orientation = if isPortrait then 'portrait' else 'landscape';
    local insets = metrics.keyInsets[orientation];

    local letterKey(c, extra={}) =
      local name = keyName(c);
      local spec = Keys[name];
      Button.alphabetic(
        name,
        spec + extra + {
          badge: { text: spec.badgeText, center: metrics.key.topBadgeCenter },
        },
        insets,
        hint={ size: metrics.hint.size, swipeUpText: spec.badgeText },
        isPortrait=isPortrait
      );

    Style.merge([
      Preedit.new(),
      Toolbar.new(),
      Theme.shared(insets),
      {
        keyboardHeight: metrics.keyboardHeight[orientation],
        keyboardStyle: { backgroundStyle: Theme.keyboardBackgroundName },
        keyboardLayout: keyboardLayout,
      },

      // 第一行（QWERTYUIOP）
      Style.merge([letterKey(c) for c in std.stringChars(letterRows[0])]),

      // 第二行（ASDFGHJKL）
      letterKey('a', {
        size: { width: '168.75/1125' },
        bounds: { width: '111/168.75', alignment: 'right' },
      }),
      Style.merge([letterKey(c) for c in std.stringChars('sdfghjk')]),
      letterKey('l', {
        size: { width: '168.75/1125' },
        bounds: { width: '111/168.75', alignment: 'left' },
      }),

      // 第三行（Shift + ZXCVBNM + 删除）
      Button.system('shiftButton', Keys.shiftButton {
        size: { width: { percentage: 0.15 } },
        bounds: { width: '151/168.75', alignment: 'left' },
        uppercasedStateForegroundStyle: Theme.shiftUppercasedForegroundName,
        capsLockedStateForegroundStyle: Theme.shiftCapsLockedForegroundName,
      }),
      Style.merge([letterKey(c) for c in std.stringChars(letterRows[2])]),
      Button.system('backspaceButton', Keys.backspaceButton {
        size: { width: { percentage: 0.15 } },
        bounds: { width: '151/168.75', alignment: 'right' },
      }),

      // 第四行（123 / 逗号 / 空格 / 切九键拼音 / 回车）
      Button.system('numericButton', Keys.numericButton { size: { width: { percentage: 0.2 } } }),
      Button.alphabetic('commaButton', Keys.commaButton { size: { width: { percentage: 0.1 } } }, insets, hint=null),
      Button.alphabetic('spaceButton', Keys.spaceButton, insets, hint=null),
      Button.alphabetic('t9PinyinButton', Keys.t9PinyinButton { size: { width: { percentage: 0.1 } } }, insets, hint=null),
      Button.system('enterButton', Keys.enterButton {
        size: { width: { percentage: 0.2 } },
        backgroundStyle: Theme.enterBackgroundStyle,
        foregroundStyle: Theme.enterForegroundStyle,
      }),
    ]),
}
