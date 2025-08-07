local Parameters = import '../Variables/Toolbar.libsonnet';
local Utils = import 'Utils.libsonnet';


// 工具栏背景样式
local toolbarBackgroundStyle(isDark=false) =

  if Parameters.backgroundStyle.enable then
    Utils.newBackgroundStyle(isDark, Parameters.backgroundStyle)
  else
    {
      internal: {},
      external: {},
    };

// 工具栏主按键样式（左侧第一个按键）
local toolbarPrimaryButtonStyle(isDark=false) =
  if Parameters.toolbarPrimaryButton.enable then

    local styleName = 'toolbarPrimaryButtonStyle';
    local backgroundStyleName = 'toolbarPrimaryButtonBackgroundStyle';

    local buttonBackgroundStyle = Utils.newBackgroundStyle(isDark, Parameters.toolbarButtonBackgroundStyle);
    local buttonForegroundStyle = Utils.newForegroundStyle(isDark, Parameters.toolbarPrimaryButton.foregroundStyle);

    {
      internal: {
        primaryButtonStyle: styleName,
      },
      external: {
        [styleName]: {
          action: Parameters.toolbarPrimaryButton.action,
        } + buttonBackgroundStyle.internal + buttonForegroundStyle.internal,
      } + buttonBackgroundStyle.external + buttonForegroundStyle.external,
    }
  else
    {
      internal: {},
      external: {},
    };

local toolbarSecondaryButtonsStyle(isDark=false) =
  if std.objectHas(Parameters, 'toolbarSecondaryButtons') && std.length(Parameters.toolbarSecondaryButtons) > 0 then

    local buttonBackgroundStyle = Utils.newBackgroundStyle(isDark, Parameters.toolbarButtonBackgroundStyle);

    // 生成单个工具栏按键样式
    local createButtonStyle = function(button)
      local name = std.md5(std.toString(button));
      local buttonForegroundStyle = Utils.newForegroundStyle(isDark, button.foregroundStyle);
      {
        name: name,
        external: {
          [name]: {
            action: button.action,
          } + buttonBackgroundStyle.internal + buttonForegroundStyle.internal,
        } + buttonForegroundStyle.external,
      };

    local buttonStyles = std.map(createButtonStyle, Parameters.toolbarSecondaryButtons);

    std.foldl(function(acc, item) {
      internal: {
        secondaryButtonStyle: acc.internal.secondaryButtonStyle + [item.name],
      },
      external: acc.external + item.external,
    }, buttonStyles, { internal: { secondaryButtonStyle: [] }, external: buttonBackgroundStyle.external });


// 候选文字通用样式
local candidateTextStyle(isDark=false) =
  local candidateHighlightBackgroundColor = if isDark then Parameters.candidate.highlightState.backgroundColor.dark else Parameters.candidate.highlightState.backgroundColor.light;

  local candidatePreferredBackgroundColor = if isDark then Parameters.candidate.highlightState.backgroundColor.dark else Parameters.candidate.highlightState.backgroundColor.light;

  local candidateHighlightIndexColor = if isDark then Parameters.candidate.highlightState.indexColor.dark else Parameters.candidate.highlightState.indexColor.light;

  local candidateHighlightTextColor = if isDark then Parameters.candidate.highlightState.textColor.dark else Parameters.candidate.highlightState.textColor.light;

  local candidateHighlightCommentColor = if isDark then Parameters.candidate.highlightState.commentColor.dark else Parameters.candidate.highlightState.commentColor.light;

  local candidateNormalIndexColor = if isDark then Parameters.candidate.normalState.indexColor.dark else Parameters.candidate.normalState.indexColor.light;

  local candidateNormalTextColor = if isDark then Parameters.candidate.normalState.textColor.dark else Parameters.candidate.normalState.textColor.light;

  local candidateNormalCommentColor = if isDark then Parameters.candidate.normalState.commentColor.dark else Parameters.candidate.normalState.commentColor.light;

  // 返回值
  {
    highlightBackgroundColor: candidateHighlightBackgroundColor,
    preferredBackgroundColor: candidatePreferredBackgroundColor,
    preferredIndexColor: candidateHighlightIndexColor,
    preferredTextColor: candidateHighlightTextColor,
    preferredCommentColor: candidateHighlightCommentColor,
    indexColor: candidateNormalIndexColor,
    textColor: candidateNormalTextColor,
    commentColor: candidateNormalCommentColor,
    indexFontSize: Parameters.candidate.indexFontSize,
    textFontSize: Parameters.candidate.textFontSize,
    commentFontSize: Parameters.candidate.commentFontSize,
  };

// 水平候选栏样式
local toolbarHorizontalCandidateStyle(isDark=false) =
  local styleName = 'toolbarHorizontalCandidateStyle';
  local candidateStateStyleName = 'toolbarHorizontalCandidateStateButtonStyle';

  local buttonForegroundStyle = Utils.newForegroundStyle(isDark, Parameters.horizontalCandidateStyle.stateButton.foregroundStyle);
  local buttonBackgroundStyle = Utils.newBackgroundStyle(isDark, Parameters.toolbarButtonBackgroundStyle);


  local candidateForegroundStyle = Utils.newForegroundStyle(isDark, Parameters.horizontalCandidateStyle.stateButton)
                                   + buttonForegroundStyle;

  local textStyle = candidateTextStyle(isDark);

  {
    internal: {
      horizontalCandidateStyle: styleName,
    },
    external: {
      [styleName]: {
        insets: Parameters.horizontalCandidateStyle.insets,
        candidateStateButtonStyle: candidateStateStyleName,
      } + textStyle,
      [candidateStateStyleName]: buttonBackgroundStyle.internal + buttonForegroundStyle.internal,
    } + buttonBackgroundStyle.external + buttonForegroundStyle.external,
  };

// 垂直候选栏样式
local toolbarVerticalCandidateStyle(isDark=false) =
  local styleName = 'toolbarVerticalCandidateStyle';

  local backgroundStyle = Utils.newBackgroundStyle(isDark, Parameters.verticalCandidateStyle.backgroundStyle);

  local textStyle = candidateTextStyle(isDark);

  local candidateAreaStyleName = 'verticalCandidateAreaStyle';

  local candidateAreaBackgroundColor = if isDark then
    Parameters.verticalCandidateStyle.candidateStyle.backgroundColor.dark
  else
    Parameters.verticalCandidateStyle.candidateStyle.backgroundColor.light;

  local candidateAreaSeparatorColor = if isDark then
    Parameters.verticalCandidateStyle.candidateStyle.separatorColor.dark
  else
    Parameters.verticalCandidateStyle.candidateStyle.separatorColor.light;


  local pageUpButtonStyleName = 'verticalCandidatePageUpButtonStyle';
  local pageDownButtonStyleName = 'verticalCandidatePageDownButtonStyle';

  local returnButtonStyleName = 'verticalCandidateReturnButtonStyle';

  local backspaceButtonStyleName = 'verticalCandidateBackspaceButtonStyle';


  local buttonBackgroundStyle = Utils.newBackgroundStyle(isDark, Parameters.verticalCandidateStyle.buttonBackgroundStyle);
  local buttonBackgroundStyleName = buttonBackgroundStyle.internal.backgroundStyle;

  local pageUpButtonForegroundStyle = Utils.newForegroundStyle(isDark, Parameters.verticalCandidateStyle.pageUpButtonStyle.foregroundStyle);
  local pageDownButtonForegroundStyle = Utils.newForegroundStyle(isDark, Parameters.verticalCandidateStyle.pageDownButtonStyle.foregroundStyle);
  local returnButtonForegroundStyle = Utils.newForegroundStyle(isDark, Parameters.verticalCandidateStyle.returnButtonStyle.foregroundStyle);
  local backspaceButtonForegroundStyle = Utils.newForegroundStyle(isDark, Parameters.verticalCandidateStyle.backspaceButtonStyle.foregroundStyle);

  {
    internal: {
      verticalCandidateStyle: styleName,
    },
    external: {
      [styleName]: {
        insets: Parameters.verticalCandidateStyle.insets,
        bottomRowHeight: Parameters.verticalCandidateStyle.bottomRowHeight,
        candidateStyle: candidateAreaStyleName,
        pageUpButtonStyle: pageUpButtonStyleName,
        pageDownButtonStyle: pageDownButtonStyleName,
        returnButtonStyle: returnButtonStyleName,
        backspaceButtonStyle: backspaceButtonStyleName,
      } + backgroundStyle.internal,
      [candidateAreaStyleName]: {
        insets: Parameters.verticalCandidateStyle.candidateStyle.insets,
        backgroundColor: candidateAreaBackgroundColor,
        separatorColor: candidateAreaSeparatorColor,
      } + textStyle,
      [pageUpButtonStyleName]: {
        backgroundStyle: buttonBackgroundStyleName,
      } + pageUpButtonForegroundStyle.internal,
      [pageDownButtonStyleName]: {
        backgroundStyle: buttonBackgroundStyleName,
      } + pageDownButtonForegroundStyle.internal,
      [returnButtonStyleName]: {
        backgroundStyle: buttonBackgroundStyleName,
      } + returnButtonForegroundStyle.internal,
      [backspaceButtonStyleName]: {
        backgroundStyle: buttonBackgroundStyleName,
      } + backspaceButtonForegroundStyle.internal,
    } + backgroundStyle.external + buttonBackgroundStyle.external + pageUpButtonForegroundStyle.external + pageDownButtonForegroundStyle.external + returnButtonForegroundStyle.external + backspaceButtonForegroundStyle.external,
  };


{
  new(isDark=false):

    local backgroundStyle = toolbarBackgroundStyle(isDark);

    local primaryButtonStyle = toolbarPrimaryButtonStyle(isDark);

    local secondaryButtonStyles = toolbarSecondaryButtonsStyle(isDark);

    local horizontalCandidateStyle = toolbarHorizontalCandidateStyle(isDark);

    local verticalCandidateStyle = toolbarVerticalCandidateStyle(isDark);

    {
      toolbarHeight: Parameters.height,
      toolbar: backgroundStyle.internal
               + primaryButtonStyle.internal
               + secondaryButtonStyles.internal
               + horizontalCandidateStyle.internal
               + verticalCandidateStyle.internal,
    } + backgroundStyle.external
    + primaryButtonStyle.external
    + secondaryButtonStyles.external
    + horizontalCandidateStyle.external
    + verticalCandidateStyle.external,
}
