// 九键拼音键盘（竖屏与横屏共用同一份九键主体）。
//
// 竖屏：左侧符号栏 + 中间 3×3 九键与底行 + 右侧功能列（删除 / 重输 / 合并占 2/4 高的回车）。
// 横屏：左半侧为符号栏与纵排候选区，中间留白，右半侧复用竖屏九键主体。
local fonts = import '../Constants/Fonts.libsonnet';
local Keys = import '../Constants/Keys.libsonnet';
local metrics = import '../Constants/Metrics.libsonnet';
local Button = import '../Components/Button.libsonnet';
local Layout = import '../Components/Layout.libsonnet';
local Preedit = import '../Components/Preedit.libsonnet';
local Style = import '../Components/Style.libsonnet';
local Theme = import '../Components/Theme.libsonnet';
local Toolbar = import '../Components/Toolbar.libsonnet';

local t9KeyNames = [
  't9OneButton',
  't9TwoButton',
  't9ThreeButton',
  't9FourButton',
  't9FiveButton',
  't9SixButton',
  't9SevenButton',
  't9EightButton',
  't9NineButton',
];

local padColumns = [
  Layout.column(['t9SymbolsCollection', 'symbolicButton'], 'narrowVStackStyle'),
  Layout.column([
    Layout.row(['t9OneButton', 't9TwoButton', 't9ThreeButton']),
    Layout.row(['t9FourButton', 't9FiveButton', 't9SixButton']),
    Layout.row(['t9SevenButton', 't9EightButton', 't9NineButton']),
    Layout.row(['numericButton', 'spaceButton', 'alphabeticButton']),
  ]),
  Layout.column(['backspaceButton', 't9ResetInputButton', 'enterButton'], 'narrowVStackStyle'),
];

local landscapeLayout = [
  Layout.column([
    Layout.column(['t9SymbolsCollection'], 'narrowVStackStyle'),
    Layout.column(['t9CandidatesCollection']),
  ], 'halfVStackStyle'),
  Layout.emptyColumn(),
  Layout.column(padColumns, 'halfVStackStyle'),
];

{
  new(isPortrait=true)::
    local orientation = if isPortrait then 'portrait' else 'landscape';
    local insets = metrics.keyInsets[orientation];
    local t9FontSize = if isPortrait then fonts.t9Key else fonts.t9KeyLandscape;

    Style.merge([
      Preedit.new(),
      Toolbar.new(),
      Theme.shared(insets),
      {
        keyboardHeight: metrics.keyboardHeight[orientation],
        keyboardStyle: { backgroundStyle: Theme.keyboardBackgroundName },
        keyboardLayout: if isPortrait then padColumns else landscapeLayout,
        t9SymbolsCollection: Keys.collections.t9SymbolsCollection,
      } + (
        if isPortrait then {} else {
          t9CandidatesCollection: Keys.collections.t9CandidatesCollection,
        }
      ),

      // 1 ~ 9 九键按键（含右上角数字角标与长按符号网格）
      Style.merge([
        Button.alphabetic(
          name,
          Keys[name] {
            fontSize: t9FontSize,
            badge: { text: Keys[name].badgeText, center: metrics.key.rightBadgeCenter },
          },
          insets,
          hint=null,
          isPortrait=isPortrait
        )
        for name in t9KeyNames
      ]),

      // 左侧底部符号切换键
      Button.system('symbolicButton', Keys.symbolicButton { size: { height: '1/4' } }),

      // 中间底行：123 / 空格 / 切英文
      Button.system('numericButton', Keys.numericButton { size: { width: { percentage: 0.2 } } }),
      Button.alphabetic('spaceButton', Keys.spaceButton, insets, hint=null),
      Button.system('alphabeticButton', Keys.alphabeticButton { size: { width: { percentage: 0.2 } } }),

      // 右侧功能列：删除（1/4）、重输（1/4）、回车（2/4，占满原 0 键空间）
      Button.system('backspaceButton', Keys.backspaceButton { size: { height: '1/4' } }),
      Button.system('t9ResetInputButton', Keys.t9ResetInputButton { size: { height: '1/4' } }),
      Button.system('enterButton', Keys.enterButton {
        size: { height: '2/4' },
        backgroundStyle: Theme.enterBackgroundStyle,
        foregroundStyle: Theme.enterForegroundStyle,
      }),
    ]),
}
