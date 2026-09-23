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

// split 状态切换键：没有单张固定图，图标跟着 $keyboardSplitState 的条件样式换。
// 只给「支持 Split 布局」的键盘用（见 new() 的 supportsSplit 参数），不支持的键盘
// 不引用这颗键，Style.prune 会把它连同下面两张图一起从产物里删掉。
local splitToggleButton(name, action, size={}) = {
  [name]: {
    action: action,
    foregroundStyle: [
      { conditionKey: '$keyboardSplitState', conditionValue: true, styleName: name + 'OnIcon' },
      { conditionKey: '$keyboardSplitState', conditionValue: false, styleName: name + 'OffIcon' },
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
                   // 菜单键 / split 切换键 / 收起键改成固定宽度（44pt），紧挨着排开；中间那颗
                   // 没有 size 的 toolbarSpacer 吃掉剩余空间，把它们分别顶到左右两端。固定宽度
                   // 而不是按比例分（原先的 1/8）是为了让 split 切换键紧贴在菜单键右边，
                   // 不被工具栏越宽（如 iPad）就拉得越远。
                   + iconButton(menuButtonName, 'command', { shortcut: '#keyboardMenu' }, { width: 44 })
                   + iconButton(dismissButtonName, 'chevron.down', 'dismissKeyboard', { width: 44 })
                   // 整份定义（按键 + 两张图）都按 supportsSplit 门控，不单靠 Style.prune 兜底：
                   // prune 只扫一遍「整棵原始文档里出现过的字符串」，splitToggleButton 自己的
                   // foregroundStyle 里就写着 OnIcon/OffIcon 这两个名字，即使按键本身没被
                   // toolbarLayout 引用、会被 prune 删掉，这两张图的名字依然「出现过」，
                   // 单靠 prune 会把它们孤儿式地留在产物里（校验器报「从未被引用」）。
                   + (if supportsSplit then
                        splitToggleButton(splitToggleButtonName, { shortcut: '#toggleSplitState' }, { width: 44 })
                      else {})
                   + iconButton(expandButtonName,
                                'chevron.forward',
                                { shortcut: '#candidatesBarStateToggle' },
                                { width: Metrics.candidate.expandButtonWidth })
                   // 纵排候选栏底部这一行四颗键等宽，中心依次落在 1/8、3/8、5/8、7/8，
                   // 于是它们的色相由 hueAt 顺着取出四档，和按键区的竖条纹对得上。
                   + panelButton(pageUpName, Colors.roleAt('pale', 0.125), 'chevron.up', { shortcut: '#verticalCandidatesPageUp' })
                   + panelButton(pageDownName, Colors.roleAt('pale', 0.375), 'chevron.down', { shortcut: '#verticalCandidatesPageDown' })
                   + panelButton(collapseName, Colors.roleAt('pale', 0.625), 'return', { shortcut: '#candidatesBarStateToggle' })
                   + panelButton(panelBackspaceName, Colors.roleAt('solid', 0.875), 'delete.left', 'backspace'),
}
