// 配色表：每项都是 { light, dark } 一对，由 main.jsonnet 经 Style.resolve 一次性解开。

// 标签文字色
local labelColor = {
  primary: { light: '#000000', dark: '#FFFFFF' },
  secondary: { light: '#3c3c4399', dark: '#ebebf599' },
};

// 分割线颜色
local separatorColor = { light: '#C6C6C8', dark: '#38383A' };

// 键盘底板：03 约合 0.01 不透明度，透出系统键盘背景
local keyboardBackgroundColor = { light: '#ffffff03', dark: '#00000003' };

// 普通按键（米键：九键数字字母键、26 键字母键、空格键等）
local standardButtonBackgroundColor = { light: '#FFFFFF', dark: '#707070' };
local standardButtonHighlightedBackgroundColor = { light: '#C7CBD4', dark: '#4C4C4C' };
local standardButtonForegroundColor = labelColor.primary;
local standardButtonHighlightedForegroundColor = standardButtonForegroundColor;

// 系统功能键（删除、重输、切页、普通回车、左侧符号栏等）
// 浅色采用 iOS 风格冷灰（#C7CBD4），与系统浅色键盘底板（约 #E2E3E8）清晰区分
local systemButtonBackgroundColor = { light: '#C7CBD4', dark: '#4C4C4C' };
local systemButtonHighlightedBackgroundColor = { light: '#FFFFFF', dark: '#707070' };
local systemButtonForegroundColor = labelColor.primary;
local systemButtonHighlightedForegroundColor = systemButtonForegroundColor;

// 蓝色强调键（搜索 / 前往 / 发送等状态的回车键）
local blueButtonBackgroundColor = { light: '#007AFF', dark: '#0A84FF' };
local blueButtonHighlightedBackgroundColor = systemButtonHighlightedBackgroundColor;
local blueButtonForegroundColor = { light: '#FFFFFF', dark: '#FFFFFF' };
local blueButtonHighlightedForegroundColor = labelColor.primary;

// 按键底部立体边缘色
local lowerEdgeOfButtonNormalColor = { light: '#898A8D', dark: '#000000' };
local lowerEdgeOfButtonHighlightColor = lowerEdgeOfButtonNormalColor;

// 气泡与长按符号面板
local standardCalloutBackgroundColor = standardButtonBackgroundColor;
local standardCalloutForegroundColor = standardButtonForegroundColor;
local standardCalloutHighlightedForegroundColor = { light: '#FFFFFF', dark: '#FFFFFF' };
local standardCalloutSelectedBackgroundColor = blueButtonBackgroundColor;
local standardCalloutBorderColor = { light: '#C6C6C8', dark: '#69686A' };

{
  labelColor: labelColor,
  separatorColor: separatorColor,
  keyboardBackgroundColor: keyboardBackgroundColor,

  standardButtonBackgroundColor: standardButtonBackgroundColor,
  standardButtonHighlightedBackgroundColor: standardButtonHighlightedBackgroundColor,
  standardButtonForegroundColor: standardButtonForegroundColor,
  standardButtonHighlightedForegroundColor: standardButtonHighlightedForegroundColor,

  systemButtonBackgroundColor: systemButtonBackgroundColor,
  systemButtonHighlightedBackgroundColor: systemButtonHighlightedBackgroundColor,
  systemButtonForegroundColor: systemButtonForegroundColor,
  systemButtonHighlightedForegroundColor: systemButtonHighlightedForegroundColor,

  blueButtonBackgroundColor: blueButtonBackgroundColor,
  blueButtonHighlightedBackgroundColor: blueButtonHighlightedBackgroundColor,
  blueButtonForegroundColor: blueButtonForegroundColor,
  blueButtonHighlightedForegroundColor: blueButtonHighlightedForegroundColor,

  lowerEdgeOfButtonNormalColor: lowerEdgeOfButtonNormalColor,
  lowerEdgeOfButtonHighlightColor: lowerEdgeOfButtonHighlightColor,

  standardCalloutBackgroundColor: standardCalloutBackgroundColor,
  standardCalloutForegroundColor: standardCalloutForegroundColor,
  standardCalloutHighlightedForegroundColor: standardCalloutHighlightedForegroundColor,
  standardCalloutSelectedBackgroundColor: standardCalloutSelectedBackgroundColor,
  standardCalloutBorderColor: standardCalloutBorderColor,

  preeditForegroundColor: standardButtonForegroundColor,
  toolbarButtonForegroundColor: standardButtonForegroundColor,
  toolbarButtonHighlightedForegroundColor: standardButtonForegroundColor,

  candidateHighlightColor: standardButtonBackgroundColor,
  candidateForegroundColor: standardButtonForegroundColor,
  candidateSeparatorColor: separatorColor,
}
