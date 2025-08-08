{
  local root = self,

  white: "#FFFFFF",

  // 键盘背景色
  backgroundColor: {
    dark: '#00000003',
    light: '#ffffff03',
  },

  // 非系统按键（如回车、删除等）正常状态下背景颜色
  alphabeticButtonNormalBackgroundColor: {
    dark: '#707070',
    light: root.white,
  },

  // 非系统按键（如车、删除等）高亮状态下背景颜色
  alphabeticButtonHighlightBackgroundColor: {
    dark: root.systemButtonNormalBackgroundColor.dark,
    light: root.systemButtonNormalBackgroundColor.light
  },

  // 系统按键（如回车、删除等）正常状态下背景颜色
  systemButtonNormalBackgroundColor: {
    dark: '#3F3F40',
    light: '#00000026',
  },

  // 系统按键（如回车、删除等）高亮状态下背景颜色
  systemButtonHighlightBackgroundColor: {
    dark: root.alphabeticButtonNormalBackgroundColor.dark,
    light: root.alphabeticButtonNormalBackgroundColor.light,
  },

  blueButtonNormalBackgroundColor: {
    dark: '#0A84FF',
    light: '#007AFF',
  },

  // 正常状态下按键底部边缘颜色
  lowerEdgeOfButtonNormalColor: {
    dark: '#000000',
    light: '#898A8D',
  },

  // 高亮状态下按键底部边缘颜色
  lowerEdgeOfButtonHighlightColor: {
    dark: '#000000',
    light: '#898A8D',
  },


  // 四种级别文字颜色
  primaryTextColor: {
    dark: '#FFFFFF',
    light: '#000000',
  },

  secondaryTextColor: {
    dark: '#BFBFBF',
    light: '#404040',
  },

  tertiaryTextColor: {
    dark: '#808080',
    light: '#808080',
  },

  quaternaryTextColor: {
    dark: '#404040',
    light: '#BFBFBF',
  },

  // 工具栏按钮前景色
  toolbarButtonForegroundNormalColor: {
    dark: '#B7BCC4',
    light: '#00000080',
  },

  // 工具栏按钮高亮前景色
  toolbarButtonForegroundHighlightColor: {
    dark: '#FFFFFF',
    light: '#000000',
  },

  // 高亮候选字背景颜色
  candidateHighlightColor: {
    dark: '#6F6F70',
    light: '#EBEDF0',
  },

  // 候选字分隔线颜色
  candidateSeparatorColor: {
    dark: '#383838',
    light: '#383838',
  },

  // 气泡及长按背景颜色
  hintBackgroundColor: {
    dark: '#707070',
    light: '#ffffff',
  },

  // 长按选中颜色
  hintSymbolSelectedColor: root.blueButtonNormalBackgroundColor,

  hintBorderColor: {
    dark: '#6E6E6E',
    light: '#69686A',
  }

}
