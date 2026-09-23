// 主题层：把 Components/Button.libsonnet 里散落的共享样式名集中到一处，
// 让 Toolbar / Keyboards 用 Theme.xxx 这种一致的方式引用，不用直接摸 Button 的内部实现。
local Button = import 'Button.libsonnet';

{
  keyboardBackgroundName: Button.keyboardBackgroundStyleName,
  alphabeticButtonBackgroundName: Button.alphabeticButtonBackgroundStyleName,
  alphabeticHintBackgroundName: Button.alphabeticHintBackgroundStyleName,
  systemButtonBackgroundName: Button.systemButtonBackgroundStyleName,
  blueButtonBackgroundName: Button.blueButtonBackgroundStyleName,
  blueButtonForegroundName: Button.blueButtonForegroundStyleName,

  // 回车键按 $returnKeyType 换底色/换字的条件样式（send/go/done 等场景变蓝底）
  enterBackgroundStyle: Button.enterButtonBackgroundStyle,
  enterForegroundStyle: Button.enterButtonForegroundStyle,
}
