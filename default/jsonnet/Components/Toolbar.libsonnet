// 工具栏区：候选字栏。横排是默认形态，点右端的箭头展开成纵排。
//
// 纵排展开后会盖住工具栏 + 按键区，所以它自带一行翻页 / 收起 / 删除的按钮。
local colors = import '../Constants/Colors.libsonnet';
local fonts = import '../Constants/Fonts.libsonnet';
local metrics = import '../Constants/Metrics.libsonnet';
local Layout = import 'Layout.libsonnet';
local Style = import 'Style.libsonnet';
local Theme = import 'Theme.libsonnet';

// 候选字的配色与字号。横排纵排共用一份，纵排另加一点内边距。
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

// 工具栏上的图标按钮（展开候选、翻页、收起、删除、菜单……）共用一套外观。
local iconButton(name, systemImageName, action, background=null, size={}) = {
  [name]: {
    action: action,
    foregroundStyle: name + 'ForegroundStyle',
    [if background != null then 'backgroundStyle']: background,
  } + (if size == {} then {} else { size: size }),
  [name + 'ForegroundStyle']: Style.systemImage({
    systemImageName: systemImageName,
    normalColor: colors.toolbarButtonForegroundColor,
    highlightColor: colors.toolbarButtonHighlightedForegroundColor,
    fontSize: fonts.candidateStateButton,
  }),
};

// split 状态切换键：没有单张固定图，图标跟着 $keyboardSplitState 的条件样式换。
// 只给「支持 Split 布局」的键盘用（见 new() 的 supportsSplit 参数），
// 不支持的键盘不引用这颗键，Style.prune 会把它连同下面两张图一起从产物里删掉。
local splitToggleButton(name, action, size={}) = {
  [name]: {
    action: action,
    foregroundStyle: [
      Style.when('$keyboardSplitState', true, name + 'OnIcon'),
      Style.when('$keyboardSplitState', false, name + 'OffIcon'),
    ],
  } + (if size == {} then {} else { size: size }),
  [name + 'OnIcon']: Style.systemImage({
    systemImageName: 'rectangle.portrait.arrowtriangle.2.inward',
    normalColor: colors.toolbarButtonForegroundColor,
    highlightColor: colors.toolbarButtonHighlightedForegroundColor,
    fontSize: fonts.candidateStateButton,
  }),
  [name + 'OffIcon']: Style.systemImage({
    systemImageName: 'rectangle.portrait.arrowtriangle.2.outward',
    normalColor: colors.toolbarButtonForegroundColor,
    highlightColor: colors.toolbarButtonHighlightedForegroundColor,
    fontSize: fonts.candidateStateButton,
  }),
};

local menuButtonName = 'toolbarMenuButton';
local splitToggleButtonName = 'toolbarSplitToggleButton';
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
  // 两个 insets 是候选区的留白。iPhone 上横排微调一点、纵排贴边（纵排本来就在
  // 自己的 collection 里留了 8pt）；iPad 屏宽富余，两者都传 Metrics.iPadSideInsets 收窄。
  //
  // supportsSplit: 这份键盘布局是否有 Split（分体）版面。为 true 时在系统菜单键右侧
  // 加一颗 split 状态切换键；不支持的键盘（如 iPhone 竖屏）不加这颗键。
  new(horizontalInsets={ top: 8, left: 3, bottom: 1 }, verticalInsets=null, supportsSplit=false):: Style.merge([
    {
      toolbarHeight: metrics.toolbar.height,
      toolbarStyle: { backgroundStyle: Theme.keyboardBackgroundName },
      toolbarLayout: [
        { HStack: { subviews:
          [{ Cell: menuButtonName }]
          + (if supportsSplit then [{ Cell: splitToggleButtonName }] else [])
          + [{ Cell: toolbarSpacerName }, { Cell: dismissButtonName }]
        } },
      ],
      [toolbarSpacerName]: {},

      horizontalCandidatesStyle: {
        insets: horizontalInsets,
        backgroundStyle: Theme.keyboardBackgroundName,
      },
      horizontalCandidatesLayout: [Layout.row([horizontalName, expandName])],

      verticalCandidatesStyle: {
        [if verticalInsets != null then 'insets']: verticalInsets,
        backgroundStyle: Theme.keyboardBackgroundName,
      },
      verticalCandidatesLayout: [
        Layout.row([verticalName]),
        Layout.row([pageUpName, pageDownName, returnName, backspaceName], lastRowName),
      ],

      // TODO: 长按候选字弹出的菜单，暂未配置
      candidateContextMenu: [],

      [horizontalName]: {
        type: 'horizontalCandidates',
        candidateStyle: 'horizontalCandidateStyle',
      },
      horizontalCandidateStyle: candidateStyle,

      [verticalName]: {
        type: 'verticalCandidates',
        insets: { top: 8, left: 8, bottom: 8, right: 8 },
        maxRows: 5,
        maxColumns: 6,
        separatorColor: colors.candidateSeparatorColor,
        candidateStyle: 'verticalCandidateStyle',
      },
      verticalCandidateStyle: candidateStyle { insets: { top: 4, left: 6, bottom: 4, right: 6 } },

      [lastRowName]: { size: { height: 45 } },
    },
    // 左侧那颗开键盘菜单的键。用九宫格图标而不是 ⌘：菜单里是一格一格的功能入口，
    // 方块阵列一眼就读得出，⌘ 在 iOS 上另有含义。不带底色，直接浮在工具栏上。
    //
    // 菜单键 / split 切换键 / 收起键都是固定宽度（44pt），紧挨着排开；中间那颗
    // 没有 size 的 toolbarSpacer 吃掉剩余空间，把它们分别顶到左右两端。固定宽度
    // 而不是按比例分（如 1/8）是为了让 split 切换键紧贴在菜单键右边，不被工具栏
    // 越宽（如 iPad）就拉得越远。
    iconButton(menuButtonName, 'square.grid.2x2.fill', { shortcut: '#keyboardMenu' }, null, { width: 44 }),
    iconButton(dismissButtonName, 'chevron.down', 'dismissKeyboard', null, { width: 44 }),
    (if supportsSplit then
       splitToggleButton(splitToggleButtonName, { shortcut: '#toggleSplitState' }, { width: 44 })
     else {}),
    // 展开按钮不带底色，直接浮在候选栏右端
    iconButton(expandName, 'chevron.forward', { shortcut: '#candidatesBarStateToggle' })
    + { [expandName]+: { size: { width: 44 } } },
    iconButton(pageUpName, 'chevron.up', { shortcut: '#verticalCandidatesPageUp' }, Theme.systemBackgroundName),
    iconButton(pageDownName, 'chevron.down', { shortcut: '#verticalCandidatesPageDown' }, Theme.systemBackgroundName),
    iconButton(returnName, 'return', { shortcut: '#candidatesBarStateToggle' }, Theme.systemBackgroundName),
    iconButton(backspaceName, 'delete.left', 'backspace', Theme.systemBackgroundName),
  ]),
}
