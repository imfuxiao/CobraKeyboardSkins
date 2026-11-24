// 工具栏与候选字栏：非输入态展示工具栏（菜单 / 占位 / 收起），输入态切换为横排或纵排候选栏。
local colors = import '../Constants/Colors.libsonnet';
local fonts = import '../Constants/Fonts.libsonnet';
local metrics = import '../Constants/Metrics.libsonnet';
local Layout = import 'Layout.libsonnet';
local Style = import 'Style.libsonnet';
local Theme = import 'Theme.libsonnet';

local candidateStyle = {
  highlightBackgroundColor: colors.candidateHighlightColor,
  preferredBackgroundColor: colors.candidateHighlightColor,
  preferredIndexColor: colors.candidateForegroundColor,
  preferredTextColor: colors.candidateForegroundColor,
  preferredCommentColor: colors.candidateForegroundColor,
  indexColor: colors.candidateForegroundColor,
  textColor: colors.candidateForegroundColor,
  commentColor: colors.candidateForegroundColor,
  indexFontSize: fonts.candidateIndex,
  textFontSize: fonts.candidateText,
  commentFontSize: fonts.candidateComment,
};

local iconButton(name, systemImageName, action, background=null, size={}, fontSize=fonts.candidateStateButton) = {
  [name]: {
    action: action,
    foregroundStyle: name + 'ForegroundStyle',
    [if background != null then 'backgroundStyle']: background,
  } + (if size == {} then {} else { size: size }),
  [name + 'ForegroundStyle']: Style.systemImage({
    systemImageName: systemImageName,
    normalColor: colors.toolbarButtonForegroundColor,
    highlightColor: colors.toolbarButtonHighlightedForegroundColor,
    fontSize: fontSize,
  }),
};

local menuButtonName = 'toolbarMenuButton';
local toolbarSpacerName = 'toolbarSpacer';
local dismissButtonName = 'toolbarDismissButton';

local horizontalName = 'horizontalCandidates';
local expandName = 'expandButton';
local verticalName = 'verticalCandidates';
local lastRowName = 'verticalLastRowStyle';
local pageUpName = 'verticalPageUpButtonStyle';
local pageDownName = 'verticalPageDownButtonStyle';
local returnName = 'verticalReturnButtonStyle';
local backspaceName = 'verticalBackspaceButtonStyle';

{
  new():: Style.merge([
    {
      toolbarHeight: metrics.toolbar.height,
      toolbarStyle: { backgroundStyle: Theme.keyboardBackgroundName },
      toolbarLayout: [Layout.row([menuButtonName, toolbarSpacerName, dismissButtonName])],
      [toolbarSpacerName]: {},

      horizontalCandidatesStyle: {
        insets: metrics.candidates.horizontalInsets,
        backgroundStyle: Theme.keyboardBackgroundName,
      },
      horizontalCandidatesLayout: [Layout.row([horizontalName, expandName])],

      verticalCandidatesStyle: {
        backgroundStyle: Theme.keyboardBackgroundName,
      },
      verticalCandidatesLayout: [
        Layout.row([verticalName]),
        Layout.row([pageUpName, pageDownName, returnName, backspaceName], lastRowName),
      ],

      candidateContextMenu: [],

      [horizontalName]: {
        type: 'horizontalCandidates',
        candidateStyle: 'horizontalCandidateStyle',
      },
      horizontalCandidateStyle: candidateStyle,

      [verticalName]: {
        type: 'verticalCandidates',
        insets: metrics.candidates.verticalInsets,
        maxRows: metrics.candidates.verticalMaxRows,
        maxColumns: metrics.candidates.verticalMaxColumns,
        separatorColor: colors.candidateSeparatorColor,
        candidateStyle: 'verticalCandidateStyle',
      },
      verticalCandidateStyle: candidateStyle { insets: metrics.candidates.verticalCellInsets },

      [lastRowName]: { size: { height: metrics.candidates.verticalBottomRowHeight } },
    },

    // 工具栏按钮（左右固定 44pt，中间 toolbarSpacer 撑开）
    iconButton(
      menuButtonName,
      'square.grid.2x2.fill',
      { shortcut: '#keyboardMenu' },
      null,
      { width: metrics.toolbar.buttonWidth },
      fonts.toolbarButtonImage
    ),
    iconButton(
      dismissButtonName,
      'chevron.down',
      'dismissKeyboard',
      null,
      { width: metrics.toolbar.buttonWidth },
      fonts.toolbarButtonImage
    ),

    // 横排展开候选字筛选面板
    iconButton(
      expandName,
      'chevron.forward',
      { shortcut: '#candidateFilterPanelToggle' },
      null,
      { width: metrics.toolbar.buttonWidth }
    ),

    // 纵排底部控制键
    iconButton(pageUpName, 'chevron.up', { shortcut: '#verticalCandidatesPageUp' }, Theme.systemBackgroundName),
    iconButton(pageDownName, 'chevron.down', { shortcut: '#verticalCandidatesPageDown' }, Theme.systemBackgroundName),
    iconButton(returnName, 'return', { shortcut: '#candidatesBarStateToggle' }, Theme.systemBackgroundName),
    iconButton(backspaceName, 'delete.left', 'backspace', Theme.systemBackgroundName),
  ]),
}
