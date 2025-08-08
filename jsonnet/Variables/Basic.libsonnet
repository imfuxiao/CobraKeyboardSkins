local Colors = import 'Colors.libsonnet';
local Fonts = import 'Fonts.libsonnet';

{
  local root = self,

  // 按键动画
  buttonAnimation: {
    name: 'alphabeticBackgroundAnimation',
    animations: [
      {
        type: 'bounds',
        duration: 40,
        repeatCount: 1,
        fromScale: 1,
        toScale: 0.87,
      },
      {
        type: 'bounds',
        duration: 80,
        repeatCount: 1,
        fromScale: 0.87,
        toScale: 1,
      },
    ],
  },

  // 字母按键通用背景样式
  alphabeticButtonBackgroundStyle: {
    isOriginal: true,  // 使用原生背景色, false 则使用图片背景
    insets: { top: 6, left: 3, bottom: 6, right: 3 },
    normalColor: Colors.alphabeticButtonNormalBackgroundColor,
    highlightColor: Colors.alphabeticButtonHighlightBackgroundColor,
    cornerRadius: 6,
    normalLowerEdgeColor: Colors.lowerEdgeOfButtonNormalColor,
    highlightLowerEdgeColor: Colors.lowerEdgeOfButtonHighlightColor,
    animation: root.buttonAnimation.name,
  },

  // 系统按键通用背景样式
  systemButtonBackgroundStyle: root.alphabeticButtonBackgroundStyle {
    normalColor: Colors.systemButtonNormalBackgroundColor,
    highlightColor: Colors.systemButtonHighlightBackgroundColor,
  },

  // 蓝色系统按键通用背景样式
  blueSystemButtonBackgroundStyle: root.systemButtonBackgroundStyle {
    normalColor: Colors.blueButtonNormalBackgroundColor,
    highlightColor: Colors.blueButtonNormalBackgroundColor,
    normalLowerEdgeColor: '',
    highlightLowerEdgeColor: '',
  },

  local enterText = |||
    // JavaScript
    function getText() {
      const type = $getReturnKeyType();
      switch (type) {
        case 1:
          return "前往";
        case 3:
          return "加入";
        case 4:
          return "前往";
        case 6:
          return "搜索"
        case 7:
          return "发送"
        case 9:
          return "完成";
        default:
          return "换行";
      }
    }
  |||,

  enterButtonWhiteForegroundStyle: {
    text: enterText,
    normalColor: '#ffffff',
    highlightColor: '#ffffff',
    fontSize: Fonts.systemButtonFontSize,
  },

  enterButtonBlackForegroundStyle: {
    text: enterText,
    normalColor: Colors.primaryTextColor,
    highlightColor: Colors.primaryTextColor,
    fontSize: Fonts.systemButtonFontSize,
  },

  // 按键气泡或长按通用背景样式
  hintBackgroundStyle: {
    isOriginal: true,
    normalColor: Colors.hintBackgroundColor,
    cornerRadius: 6,
    // borderColor: Colors.hintBorderColor,
    // borderSize: 0.5,
  },

  // 字母按键长按符号选中背景样式
  hintSymbolSelectedBackgroundStyle: root.hintBackgroundStyle {
    normalColor: Colors.blueButtonNormalBackgroundColor,
  },
}
