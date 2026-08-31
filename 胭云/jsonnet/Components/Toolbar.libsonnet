// 工具栏区：非输入态显示 toolbarLayout，输入态被候选栏整片盖住。
// 候选栏有横排（盖住工具栏）与纵排（展开后盖住工具栏 + 按键区）两套。
local Colors = import '../Constants/Colors.libsonnet';
local Fonts = import '../Constants/Fonts.libsonnet';
local Metrics = import '../Constants/Metrics.libsonnet';
local Button = import 'Button.libsonnet';
local Style = import 'Style.libsonnet';
local Theme = import 'Theme.libsonnet';

local iconTint = {
  normalColor: Colors.toolbarIcon.normal,
  highlightColor: Colors.toolbarIcon.pressed,
};

// 工具栏上的无底色图标按钮
local iconButton(name, systemImageName, action, size={}) = {
  [name]: {
    foregroundStyle: name + 'Icon',
    action: action,
  } + (if size == {} then {} else { size: size }),
  [name + 'Icon']: Style.systemImage(iconTint {
    systemImageName: systemImageName,
    fontSize: Fonts.toolbarIcon,
  }),
};

// 纵排候选栏底部那一行的功能键：有底色，走正常的角色配色
local panelButton(name, role, systemImageName, action) = Button.new(name, {
  role: role,
  label: { systemImageName: systemImageName, fontSize: Fonts.candidateStateIcon },
  action: action,
});

local candidateCellStyle(insets) = {
  insets: insets,
  backgroundCornerRadius: Metrics.candidate.cornerRadius,
  highlightBackgroundColor: Colors.candidate.pressedBackground,
  preferredBackgroundColor: Colors.candidate.preferredBackground,
  preferredTextColor: Colors.candidate.preferredText,
  preferredCommentColor: Colors.candidate.preferredComment,
  preferredIndexColor: Colors.candidate.preferredIndex,
  textColor: Colors.candidate.text,
  commentColor: Colors.candidate.comment,
  indexColor: Colors.candidate.index,
  indexFontSize: Fonts.candidateIndex,
  textFontSize: Fonts.candidateText,
  commentFontSize: Fonts.candidateComment,
};

// 工具栏中间的留白：一个既无背景也无前景的空按键，只用来吃掉剩余宽度
local spacerName = 'toolbarSpacer';

local menuButtonName = 'toolbarMenuButton';
local dismissButtonName = 'toolbarDismissButton';
local expandButtonName = 'candidatesExpandButton';
local horizontalListName = 'horizontalCandidates';
local verticalListName = 'verticalCandidates';
local verticalBottomRowName = 'verticalCandidatesBottomRow';
local pageUpName = 'candidatesPageUpButton';
local pageDownName = 'candidatesPageDownButton';
local collapseName = 'candidatesCollapseButton';
local panelBackspaceName = 'candidatesBackspaceButton';

{
  // insets: 候选区内边距，iPad 用它把候选字收到屏幕中间
  new(insets={}):: {
                     toolbarHeight: Metrics.toolbar.height,
                     toolbarStyle: { backgroundStyle: Theme.toolbarBackgroundName },
                     [spacerName]: {},
                     toolbarLayout: [
                       { HStack: { subviews: [
                         { Cell: menuButtonName },
                         { Cell: spacerName },
                         { Cell: dismissButtonName },
                       ] } },
                     ],

                     // ===== 横排候选栏 =====
                     horizontalCandidatesStyle: {
                       insets: Metrics.candidate.horizontalInsets + insets,
                       // 横排候选栏与工具栏同一块地方，底板必须完全一致
                       backgroundStyle: Theme.toolbarBackgroundName,
                     },
                     horizontalCandidatesLayout: [
                       { HStack: { subviews: [
                         { Cell: horizontalListName },
                         { Cell: expandButtonName },
                       ] } },
                     ],
                     [horizontalListName]: {
                       type: 'horizontalCandidates',
                       candidateStyle: 'horizontalCandidateStyle',
                     },
                     horizontalCandidateStyle: candidateCellStyle(Metrics.candidate.cellInsets),

                     // ===== 纵排候选栏（展开态）=====
                     verticalCandidatesStyle: {
                       insets: insets,
                       // 展开后盖住工具栏区 + 按键区，底板要把这两块的渐变一起接上
                       backgroundStyle: Theme.candidatePanelBackgroundName,
                     },
                     verticalCandidatesLayout: [
                       { HStack: { subviews: [{ Cell: verticalListName }] } },
                       { HStack: { style: verticalBottomRowName, subviews: [
                         { Cell: pageUpName },
                         { Cell: pageDownName },
                         { Cell: collapseName },
                         { Cell: panelBackspaceName },
                       ] } },
                     ],
                     [verticalListName]: {
                       type: 'verticalCandidates',
                       insets: Metrics.candidate.verticalInsets,
                       maxRows: Metrics.candidate.verticalMaxRows,
                       maxColumns: Metrics.candidate.verticalMaxColumns,
                       separatorColor: Colors.candidate.separator,
                       candidateStyle: 'verticalCandidateStyle',
                     },
                     verticalCandidateStyle: candidateCellStyle(Metrics.candidate.cellInsets),
                     [verticalBottomRowName]: {
                       size: { height: Metrics.candidate.verticalBottomRowHeight },
                     },
                   }
                   + iconButton(menuButtonName, 'command', { shortcut: '#keyboardMenu' }, { width: '1/8' })
                   + iconButton(dismissButtonName, 'chevron.down', 'dismissKeyboard', { width: '1/8' })
                   + iconButton(expandButtonName,
                                'chevron.forward',
                                { shortcut: '#candidatesBarStateToggle' },
                                { width: Metrics.candidate.expandButtonWidth })
                   + panelButton(pageUpName, 'symbol', 'chevron.up', { shortcut: '#verticalCandidatesPageUp' })
                   + panelButton(pageDownName, 'symbol', 'chevron.down', { shortcut: '#verticalCandidatesPageDown' })
                   + panelButton(collapseName, 'symbol', 'return', { shortcut: '#candidatesBarStateToggle' })
                   + panelButton(panelBackspaceName, 'backspace', 'delete.left', 'backspace'),
}
