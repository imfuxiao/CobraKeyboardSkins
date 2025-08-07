local Basic = import 'Basic.libsonnet';
local Colors = import 'Colors.libsonnet';
local Fonts = import 'Fonts.libsonnet';

{
  local root = self,

  height: 40,

  backgroundStyle: {
    enable: true,
    isOriginal: true,  // 使用原生背景色, false 则使用图片背景

    // 工具栏背景色(使用原生背景色)
    normalColor: Colors.backgroundColor,
  },

  // 工具栏按键通用背景样式
  toolbarButtonBackgroundStyle: {},

  // 工具栏按键通用属性
  // 注意：对外不可见，只用于内部引用
  toolbarButtonForegroundStyle:: {
    normalColor: Colors.toolbarButtonForegroundNormalColor,
    highlightColor: Colors.toolbarButtonForegroundHighlightColor,
    fontSize: Fonts.toolbarButtonFontSize,
  },

  // 工具栏主按键(左侧第一个按键)
  // text 与 systemImageName 二选一
  // 优先使用 systemImageName
  toolbarPrimaryButton: {
    enable: true,
    action: { openURL: 'hamster3://' },
    foregroundStyle: [
      {
        systemImageName: 'paperplane.circle',
      } + root.toolbarButtonForegroundStyle,
    ],
  },


  // 工具栏从右侧开始的按键
  toolbarSecondaryButtons: [
    {
      action: 'dismissKeyboard',
      foregroundStyle: [
        {
          systemImageName: 'chevron.down.circle',
        } + root.toolbarButtonForegroundStyle,
      ],
    },
    {
      action: { shortcutCommand: '#中英切换' },
      foregroundStyle: [
        {
          text: |||
            // JavaScript
            function getText() {
              return $getRimeOptionState("ascii_mode") ? "英" : "中";
            }
          |||,
        } + root.toolbarButtonForegroundStyle,
      ],
    },
    {
      action: { shortcutCommand: '#toggleScriptView' },
      foregroundStyle: [
        {
          systemImageName: 'function',
        } + root.toolbarButtonForegroundStyle,
      ],
    },
    {
      action: { shortcutCommand: '#showPasteboardView' },
      foregroundStyle: [
        {
          systemImageName: 'doc.on.clipboard',
        } + root.toolbarButtonForegroundStyle,
      ],
    },
    {
      action: { shortcutCommand: '#简繁切换' },
      foregroundStyle: [
        {
          text: |||
            // JavaScript
            function getText() {
              return $getRimeOptionState("traditional_chinese") ? "简" : "繁";
            }
          |||,
        } + root.toolbarButtonForegroundStyle,
      ],
    },
    {
      action: { shortcutCommand: '#RimeSwitcher' },
      foregroundStyle: [
        {
          systemImageName: 'switch.2',
        } + root.toolbarButtonForegroundStyle,
      ],
    },
    {
      action: { shortcutCommand: '#行尾' },
      foregroundStyle: [
        {
          systemImageName: 'forward.end',
        } + root.toolbarButtonForegroundStyle,
      ],
    },
    {
      action: { shortcutCommand: '#行首' },
      foregroundStyle: [
        {
          systemImageName: 'backward.end',
        } + root.toolbarButtonForegroundStyle,
      ],
    },
  ],


  // 候选字
  // 注意：对外不可见，只用于内部引用
  candidate:: {
    indexFontSize: Fonts.candidateIndexFontSize,
    textFontSize: Fonts.candidateTextFontSize,
    commentFontSize: Fonts.candidateCommentFontSize,
    highlightState: {
      backgroundColor: Colors.candidateHighlightColor,
      indexColor: Colors.primaryTextColor,
      textColor: Colors.primaryTextColor,
      commentColor: Colors.primaryTextColor,
    },
    normalState: {
      indexColor: Colors.primaryTextColor,
      textColor: Colors.primaryTextColor,
      commentColor: Colors.primaryTextColor,
    },
  },

  // 水平候选栏
  horizontalCandidateStyle: {
    insets: { left: 3, bottom: 1, top: 3 },
    stateButton: {
      foregroundStyle: [
        {
          systemImageName: 'chevron.down',
        } + root.toolbarButtonForegroundStyle,
      ],
    },
    candidateStyle: root.candidate,
  },

  // 垂直候选栏
  verticalCandidateStyle: {
    insets: { top: 3, bottom: 3, left: 4, right: 4 },

    bottomRowHeight: 54,

    backgroundStyle: {
      isOriginal: true,  // 使用原生背景色, false 则使用图片背景
      normalColor: Colors.backgroundColor,
    },

    candidateStyle: {
      insets: { top: 8, bottom: 8, left: 8, right: 8 },
      backgroundColor: Colors.backgroundColor,
      separatorColor: Colors.candidateSeparatorColor,
    } + root.candidate,

    buttonBackgroundStyle: 'systemButtonBackgroundStyle',

    pageUpButtonStyle: {
      foregroundStyle: [
        {
          systemImageName: 'chevron.up',
        } + root.toolbarButtonForegroundStyle,
      ],
    },

    pageDownButtonStyle: {
      foregroundStyle: [
        {
          systemImageName: 'chevron.down',
        } + root.toolbarButtonForegroundStyle,
      ],
    },

    returnButtonStyle: {
      foregroundStyle: [
        {
          systemImageName: 'return',
        } + root.toolbarButtonForegroundStyle,
      ],
    },

    backspaceButtonStyle: {
      foregroundStyle: [
        {
          systemImageName: 'delete.left',
        } + root.toolbarButtonForegroundStyle,
      ],
    },
  },
}
