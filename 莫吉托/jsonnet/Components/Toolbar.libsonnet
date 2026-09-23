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

// split 状态切换键：没有单张固定图，图标跟着 $keyboardSplitState 的条件样式换。
// 只给「支持 Split 布局」的键盘用（见 new() 的 supportsSplit 参数）。按钮本体与它引用
// 的两张图标样式要作为一个整体一起放进 supportsSplit 分支：Style.prune 只按「文档里
// 是否出现过这个字符串」判断要不要保留一个样式名，按钮定义一旦写出来，它内部引用的
// OnIcon / OffIcon 名字就已经「出现过」，不会被当成孤儿样式清掉，所以不能指望 prune
// 帮忙清理只写了一半的按钮。
local splitToggleButton(name, size={}) = {
  [name]: {
    action: { shortcut: '#toggleSplitState' },
    foregroundStyle: [
      Style.when('$keyboardSplitState', true, name + 'OnIcon'),
      Style.when('$keyboardSplitState', false, name + 'OffIcon'),
    ],
  } + (if size == {} then {} else { size: size }),
  [name + 'OnIcon']: Style.systemImage(iconTint {
    systemImageName: 'rectangle.portrait.arrowtriangle.2.inward',
    fontSize: Fonts.toolbarIcon,
  }),
  [name + 'OffIcon']: Style.systemImage(iconTint {
    systemImageName: 'rectangle.portrait.arrowtriangle.2.outward',
    fontSize: Fonts.toolbarIcon,
  }),
};

// 工具栏中间的留白：一个既无背景也无前景的空按键，只用来吃掉剩余宽度
local spacerName = 'toolbarSpacer';

local menuButtonName = 'toolbarMenuButton';
local splitToggleButtonName = 'toolbarSplitToggleButton';
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
  // supportsSplit: 这份键盘布局是否有 Split（分体）版面。为 true 时在系统菜单键右侧
  // 加一颗 split 状态切换键；不支持的键盘（如 iPhone 竖屏）不加这颗键。
  new(insets={}, supportsSplit=false):: {
                     toolbarHeight: Metrics.toolbar.height,
                     toolbarStyle: { backgroundStyle: Theme.toolbarBackgroundName },
                     [spacerName]: {},
                     toolbarLayout: [
                       { HStack: { subviews:
                         [{ Cell: menuButtonName }]
                         + (if supportsSplit then [{ Cell: splitToggleButtonName }] else [])
                         + [{ Cell: spacerName }, { Cell: dismissButtonName }]
                       } },
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
                   // 菜单键 / split 切换键 / 收起键都是固定宽度（44pt），紧挨着排开；
                   // 中间没有 size 的 toolbarSpacer 吃掉剩余空间，把它们分别顶到左右两端。
                   // 固定宽度而不是按比例分（如 1/8）是为了让 split 切换键始终紧贴菜单键，
                   // 不被工具栏越宽（如 iPad）越拉越远。
                   + iconButton(menuButtonName, 'command', { shortcut: '#keyboardMenu' }, { width: 44 })
                   + iconButton(dismissButtonName, 'chevron.down', 'dismissKeyboard', { width: 44 })
                   // 按钮本体与它引用的两张图标样式必须一起放进 supportsSplit 分支：
                   // Style.prune 是按「整份文档里这个字符串出现过没有」判断要不要保留，
                   // 如果无条件写出这颗按钮，即使 supportsSplit=false 时 toolbarLayout
                   // 没有引用它、按钮本体会被 prune 掉，但它内部 foregroundStyle 引用的
                   // OnIcon / OffIcon 这两个名字已经「出现过」，不会被当成孤儿样式一起清掉，
                   // 会在产物里留下两个没人用的图标样式（校验器报「未被引用」的警告）。
                   + (if supportsSplit then splitToggleButton(splitToggleButtonName, { width: 44 }) else {})
                   + iconButton(expandButtonName,
                                'chevron.forward',
                                { shortcut: '#candidatesBarStateToggle' },
                                { width: Metrics.candidate.expandButtonWidth })
                   + panelButton(pageUpName, 'symbol', 'chevron.up', { shortcut: '#verticalCandidatesPageUp' })
                   + panelButton(pageDownName, 'symbol', 'chevron.down', { shortcut: '#verticalCandidatesPageDown' })
                   + panelButton(collapseName, 'symbol', 'return', { shortcut: '#candidatesBarStateToggle' })
                   + panelButton(panelBackspaceName, 'backspace', 'delete.left', 'backspace'),
}
