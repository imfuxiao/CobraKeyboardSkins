// 工具栏区：非输入态显示 toolbarLayout，输入态被候选栏整片盖住。
// 候选栏横排是默认形态，点右端的箭头展开成纵排；纵排展开后会盖住工具栏 + 按键区，
// 所以它自带一行翻页 / 收起 / 删除的按钮。
//
// 版式照 Skins/default 的工具栏：左端菜单键（支持分体的版面紧跟一颗 split 切换键），
// 右端收起键，中间一颗没有 size 的 toolbarSpacer 吃掉剩余宽度。
local colors = import '../Constants/Colors.libsonnet';
local fonts = import '../Constants/Fonts.libsonnet';
local Metrics = import '../Constants/Metrics.libsonnet';
local Style = import 'Style.libsonnet';
local Theme = import 'Theme.libsonnet';
local utils = import 'Utils.libsonnet';

local candidateColorKeys = [
  'highlightBackgroundColor',
  'preferredBackgroundColor',
  'preferredIndexColor',
  'preferredTextColor',
  'preferredCommentColor',
  'indexColor',
  'textColor',
  'commentColor',
];

// 候选字的配色与字号。横排纵排共用一份，纵排另加一点内边距。
local candidateStyle(isDark) =
  utils.extractColors({
    highlightBackgroundColor: colors.candidateHighlightColor,
    preferredBackgroundColor: colors.candidateHighlightColor,
    preferredIndexColor: colors.candidateForegroundColor,
    preferredTextColor: colors.candidateForegroundColor,
    preferredCommentColor: colors.candidateForegroundColor,
    indexColor: colors.candidateForegroundColor,
    textColor: colors.candidateForegroundColor,
    commentColor: colors.candidateForegroundColor,
  }, candidateColorKeys, isDark)
  + {
    indexFontSize: fonts.candidateIndexFontSize,
    textFontSize: fonts.candidateTextFontSize,
    commentFontSize: fonts.candidateCommentFontSize,
  };

local iconStyle(isDark, systemImageName) = utils.newSystemImageStyle({
  systemImageName: systemImageName,
  normalColor: colors.toolbarButtonForegroundColor,
  highlightColor: colors.toolbarButtonHighlightedForegroundColor,
  fontSize: fonts.candidateStateButtonFontSize,
}, isDark);

// 工具栏上的图标按钮（菜单、收起、展开候选、翻页……）共用一套外观。
// background 为 null 时不带底色，直接浮在工具栏上。
local iconButton(isDark, name, systemImageName, action, background=null, size={}) = {
  [name]: {
    action: action,
    foregroundStyle: name + 'ForegroundStyle',
    [if background != null then 'backgroundStyle']: background,
  } + (if size == {} then {} else { size: size }),
  [name + 'ForegroundStyle']: iconStyle(isDark, systemImageName),
};

// split 状态切换键：没有单张固定图，图标跟着 $keyboardSplitState 的条件样式换。
// 只给「支持 Split 布局」的键盘用（new() 的 supportsSplit），按钮连同两张图标一起
// 按 supportsSplit 生成，不支持的键盘里这三个节点根本不出现。
local splitToggleButton(isDark, name, action, size={}) = {
  [name]: {
    action: action,
    foregroundStyle: [
      Style.when('$keyboardSplitState', true, name + 'OnIcon'),
      Style.when('$keyboardSplitState', false, name + 'OffIcon'),
    ],
  } + (if size == {} then {} else { size: size }),
  [name + 'OnIcon']: iconStyle(isDark, 'rectangle.portrait.arrowtriangle.2.inward'),
  [name + 'OffIcon']: iconStyle(isDark, 'rectangle.portrait.arrowtriangle.2.outward'),
};

local menuButtonName = 'toolbarMenuButton';
local splitToggleButtonName = 'toolbarSplitToggleButton';
local spacerName = 'toolbarSpacer';
local dismissButtonName = 'toolbarDismissButton';

local horizontalName = 'horizontalCandidates';
local expandName = 'expandButton';
local verticalName = 'verticalCandidates';
local lastRowName = 'verticalLastRowStyle';
local pageUpName = 'verticalPageUpButtonStyle';
local pageDownName = 'verticalPageDownButtonStyle';
local returnName = 'verticalReturnButtonStyle';
local backspaceName = 'verticalBackspaceButtonStyle';

// 菜单键 / split 切换键 / 收起键都是固定宽度，紧挨着排开。
// 不按比例分（如 1/8）：横屏和 iPad 的工具栏很宽，按比例的话每颗键都会被拉到上百 pt，
// split 切换键离菜单键越拉越远；固定宽度则两颗键始终贴在左端、收起键贴在右端，
// 分体态下正好各自落在左右两半键盘的上方。
local toolbarButtonSize = { width: 44 };

// insets: 候选区内边距（iPad 传 Metrics.iPadSideInsets 把候选字收到屏幕中间）。
// supportsSplit: 这份键盘布局是否有 Split（分体）版面。为 true 时在菜单键右侧
// 加一颗 split 状态切换键；不支持的键盘（iPhone 竖屏）不加这颗键。
local newToolbar(isDark=false, insets={}, supportsSplit=false) = Style.merge([
  {
    toolbarHeight: Metrics.toolbar.height,
    toolbarStyle: utils.newBackgroundStyle(style=Theme.keyboardBackgroundName),
    toolbarLayout: [
      { HStack: { subviews:
        [{ Cell: menuButtonName }]
        + (if supportsSplit then [{ Cell: splitToggleButtonName }] else [])
        + [{ Cell: spacerName }, { Cell: dismissButtonName }]
      } },
    ],
    [spacerName]: {},

    horizontalCandidatesStyle: {
      insets: Metrics.candidate.horizontalInsets + insets,
      backgroundStyle: Theme.keyboardBackgroundName,
    },
    horizontalCandidatesLayout: [
      { HStack: { subviews: [{ Cell: horizontalName }, { Cell: expandName }] } },
    ],
    [horizontalName]: { type: 'horizontalCandidates', candidateStyle: 'horizontalCandidateStyle' },
    horizontalCandidateStyle: candidateStyle(isDark),

    verticalCandidatesStyle: {
      [if insets != {} then 'insets']: insets,
      backgroundStyle: Theme.keyboardBackgroundName,
    },
    verticalCandidatesLayout: [
      { HStack: { subviews: [{ Cell: verticalName }] } },
      { HStack: { style: lastRowName, subviews: [{ Cell: pageUpName }, { Cell: pageDownName }, { Cell: returnName }, { Cell: backspaceName }] } },
    ],
    [verticalName]: {
      type: 'verticalCandidates',
      insets: Metrics.candidate.verticalInsets,
      maxRows: Metrics.candidate.verticalMaxRows,
      maxColumns: Metrics.candidate.verticalMaxColumns,
      candidateStyle: 'verticalCandidateStyle',
    } + utils.setColor('separatorColor', colors.candidateSeparatorColor, isDark),
    verticalCandidateStyle: candidateStyle(isDark) { insets: Metrics.candidate.cellInsets },
    [lastRowName]: { size: { height: Metrics.candidate.verticalBottomRowHeight } },

    // TODO: 长按候选字弹出的菜单，暂未配置
    candidateContextMenu: [],
  },
  // 左端开键盘菜单的键。用九宫格图标而不是 ⌘：菜单里是一格一格的功能入口，
  // 方块阵列一眼就读得出，⌘ 在 iOS 上另有含义。
  iconButton(isDark, menuButtonName, 'square.grid.2x2.fill', { shortcut: '#keyboardMenu' }, size=toolbarButtonSize),
  iconButton(isDark, dismissButtonName, 'chevron.down', 'dismissKeyboard', size=toolbarButtonSize),
  (if supportsSplit then
     splitToggleButton(isDark, splitToggleButtonName, { shortcut: '#toggleSplitState' }, toolbarButtonSize)
   else {}),
  // 展开按钮不带底色，直接浮在候选栏右端
  iconButton(isDark, expandName, 'chevron.forward', { shortcut: '#candidatesBarStateToggle' }, size={ width: 44 }),
  iconButton(isDark, pageUpName, 'chevron.up', { shortcut: '#verticalCandidatesPageUp' }, Theme.systemButtonBackgroundName),
  iconButton(isDark, pageDownName, 'chevron.down', { shortcut: '#verticalCandidatesPageDown' }, Theme.systemButtonBackgroundName),
  iconButton(isDark, returnName, 'return', { shortcut: '#candidatesBarStateToggle' }, Theme.systemButtonBackgroundName),
  iconButton(isDark, backspaceName, 'delete.left', 'backspace', Theme.systemButtonBackgroundName),
]);

{
  new: newToolbar,
}
