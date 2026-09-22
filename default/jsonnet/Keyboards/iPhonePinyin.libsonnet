// iPhone 拼音键盘：标准 26 键，四行。
//
// 第二行（asdfghjkl）只有九颗键，两端各补半颗键的触摸区：`size` 取触摸宽、
// `bounds` 取绘制宽，手指点到屏幕边缘也能命中 a / l，显示区仍与上一行对齐。
//
// 横屏支持分体（Split）：Shift 键上划进分体，分体态下再上划一次合回来——同一个手势
// 两态共用，不需要专门的「把手」键（iPad 借这个手势给 Tab；iPhone 没有 Tab，
// 借给 Shift，因为 Shift 分体后还要用，不能被顶掉，见 Components/Split.libsonnet
// 开头的说明）。竖屏不适配——屏幕太窄，分成两半没有使用价值，`new()` 里按
// isPortrait 分叉，竖屏那支产物与引入分体前逐字节相同。
local Keys = import '../Constants/Keys.libsonnet';
local metrics = import '../Constants/Metrics.libsonnet';
local Button = import '../Components/Button.libsonnet';
local Layout = import '../Components/Layout.libsonnet';
local Preedit = import '../Components/Preedit.libsonnet';
local Split = import '../Components/Split.libsonnet';
local Style = import '../Components/Style.libsonnet';
local Theme = import '../Components/Theme.libsonnet';
local Toolbar = import '../Components/Toolbar.libsonnet';
local Widths = import '../Components/Widths.libsonnet';

local widths = Widths.iPhone;
local sw = Split.iPhoneWidths;

local letterRows = ['qwertyuiop', 'asdfghjkl', 'zxcvbnm'];
local keyName(c) = c + 'Button';
local letterNames(row) = [keyName(c) for c in std.stringChars(row)];

local keyboardLayout = [
  Layout.row(letterNames(letterRows[0])),
  Layout.row(letterNames(letterRows[1])),
  Layout.row(['shiftButton'] + letterNames(letterRows[2]) + ['backspaceButton']),
  Layout.row(['numericButton', 'spaceButton', 'enterButton']),
];

// ===== 横屏分体版面 =====
// 三行字母按 iPad 拼音页同一套分法：偶数个左右对半分，奇数个复制中间那颗字母，
// 两半都凑成 5 / 4 颗键（docs/键盘Split状态.md 2.1「合并只做一层」）。
//
// 每行两端各加一颗留白键（平时 0 宽），四行共用同一条外侧留白——具体多宽、
// 中缝多宽，见 Components/Split.libsonnet 的宽度表注释。
local padLeftName = 'splitPadTopLeftButton';
local padRightName = 'splitPadTopRightButton';
local gapTopName = 'splitGapTopButton';
local padHomeLeftName = 'splitPadHomeLeftButton';
local padHomeRightName = 'splitPadHomeRightButton';
local gapHomeName = 'splitGapHomeButton';
local padBottomLeftName = 'splitPadBottomLeftButton';
local padBottomRightName = 'splitPadBottomRightButton';
local gapBottomName = 'splitGapBottomButton';
local padSpaceLeftName = 'splitPadSpaceLeftButton';
local padSpaceRightName = 'splitPadSpaceRightButton';
local gapSpaceName = 'splitGapSpaceButton';
local repeatedName(c) = c + 'SplitButton';
local spaceRightName = 'spaceRightButton';

local landscapeKeyboardLayout = [
  Layout.row(
    [padLeftName] + letterNames('qwert') + [gapTopName] + letterNames('yuiop') + [padRightName]
  ),
  Layout.row(
    [padHomeLeftName] + letterNames('asdfg') + [gapHomeName, repeatedName('g')] + letterNames('hjkl')
    + [padHomeRightName]
  ),
  Layout.row(
    [padBottomLeftName, 'shiftButton'] + letterNames('zxcv') + [gapBottomName, repeatedName('v')]
    + letterNames('bnm') + ['backspaceButton', padBottomRightName]
  ),
  Layout.row(
    [padSpaceLeftName, 'numericButton', 'spaceButton', gapSpaceName, spaceRightName, 'enterButton', padSpaceRightName]
  ),
];

{
  new(isPortrait=true)::
    local orientation = if isPortrait then 'portrait' else 'landscape';
    local insets = metrics.keyInsets.iPhone[orientation];
    local hint = { size: metrics.hint.iPhoneSize };
    local key(name, extra={}) = Button.alphabetic(name, Keys[name] + extra, insets, hint);

    // 横屏才挂分体覆盖块；竖屏 splitOnly 永远是 {}，产物与引入分体前逐字节相同。
    local isSplitCapable = !isPortrait;
    local splitOnly(extra) = if isSplitCapable then extra else {};

    Style.merge([
      Preedit.new(),
      Toolbar.new(supportsSplit=isSplitCapable),
      Theme.shared(insets),
      splitOnly(Split.shared),
      {
        keyboardHeight: metrics.keyboardHeight.iPhone[orientation],
        keyboardStyle: { backgroundStyle: Theme.keyboardBackgroundName },
        keyboardLayout: if isSplitCapable then landscapeKeyboardLayout else keyboardLayout,
      },

      // 第一行
      Style.merge([
        key(keyName(c), widths.unit + splitOnly(Split.width(sw.unit)))
        for c in std.stringChars(letterRows[0])
      ]),

      // 第二行：a / l 比普通字母宽（sw.side），把第三行 Shift / 删除让出去的中缝
      // 宽度分回来（见 Components/Split.libsonnet 的注释）。可见区域仍是普通字母大小，
      // 贴内侧显示——a 贴 s 一侧（居右），l 贴 k 一侧（居左）——宽出来的部分落在
      // a / l 与外侧留白之间，方向上跟合并态「触摸区补到屏幕边缘」那个技巧一致。
      key('aButton', widths.homeRowLeft + splitOnly(Split.widthAnchored(sw.side, sw.sideVisibleFraction, 'right'))),
      Style.merge([
        key(keyName(c), widths.unit + splitOnly(Split.width(sw.unit)))
        for c in std.stringChars('sdfghjk')
      ]),
      key('lButton', widths.homeRowRight + splitOnly(Split.widthAnchored(sw.side, sw.sideVisibleFraction, 'left'))),

      // 第三行。Shift 上划进入分体——这一行唯一天然在角落、且分体后仍要用的键。
      // Shift 比普通字母宽（sw.side），但可见区域只占 sw.sideVisibleFraction、贴左显示，
      // 宽出来的部分变成 Shift 与 z 之间的一道空隙（见 Components/Split.libsonnet 的注释）。
      Button.system('shiftButton',
        Keys.shiftButton + widths.sideLeft
        + splitOnly(
          Split.widthAnchored(sw.side, sw.sideVisibleFraction, 'left') + Split.enterSplitGesture
        ) + {
          uppercasedStateForegroundStyle: Theme.shiftUppercasedForegroundName,
          capsLockedStateForegroundStyle: Theme.shiftCapsLockedForegroundName,
        }),
      Style.merge([
        key(keyName(c), widths.unit + splitOnly(Split.width(sw.unit)))
        for c in std.stringChars(letterRows[2])
      ]),
      // 删除键做镜像处理：同样宽出 sw.side，可见区域贴右显示，空隙落在 m 与删除之间。
      Button.system('backspaceButton',
        Keys.backspaceButton + widths.sideRight
        + splitOnly(Split.widthAnchored(sw.side, sw.sideVisibleFraction, 'right'))),

      // 第四行。空格是米键（白底），但不弹气泡。
      Button.system('numericButton',
        Keys.numericButton + widths.bottomSide + splitOnly(Split.width(sw.keyboardType))),
      Button.alphabetic('spaceButton',
        Keys.spaceButton + splitOnly(Split.width(sw.space)), insets, hint=null),
      Button.system('enterButton',
        Keys.enterButton + widths.bottomSide + splitOnly(Split.width(sw.keyboardType)) + {
          backgroundStyle: Theme.enterBackgroundStyle,
          foregroundStyle: Theme.enterForegroundStyle,
        }),
    ] + (
      if !isSplitCapable then [] else [
        // ===== 只在横屏出现的新键：两端留白、中缝、右半空格、重复字母 =====
        // 平时 0 宽，分体态才撑开（见 Components/Split.libsonnet 开头的三条约束）。
        // 四行共用 sw.margin，q、Shift、123 三颗键左侧因此对齐（p、删除、回车右侧同理）；
        // 第一 / 四行还共用 sw.gap 且左右两侧内容等宽，中缝边界精确重合——
        // t 贴着左半空格右边，y 贴着右半空格左边。第二行的中缝改用 sw.bottomGap，
        // 跟第三行对齐——g 的右边与 v 的右边对齐，见宽度表注释。
        Split.spacer(padLeftName, sw.margin),
        Split.spacer(padRightName, sw.margin),
        Split.spacer(gapTopName, sw.gap),
        Split.spacer(padHomeLeftName, sw.margin),
        Split.spacer(padHomeRightName, sw.margin),
        Split.spacer(gapHomeName, sw.bottomGap),
        Split.spacer(padBottomLeftName, sw.margin),
        Split.spacer(padBottomRightName, sw.margin),
        Split.spacer(gapBottomName, sw.bottomGap),
        Split.spacer(padSpaceLeftName, sw.margin),
        Split.spacer(padSpaceRightName, sw.margin),
        Split.spacer(gapSpaceName, sw.gap),
        Button.alphabetic(repeatedName('g'),
          Keys.gButton + { size: { width: 0 } } + Split.width(sw.unit), insets, hint),
        Button.alphabetic(repeatedName('v'),
          Keys.vButton + { size: { width: 0 } } + Split.width(sw.unit), insets, hint),
        Button.alphabetic(spaceRightName,
          Keys.spaceButton + { size: { width: 0 } } + Split.width(sw.space), insets, hint=null),
      ]
    )),
}
