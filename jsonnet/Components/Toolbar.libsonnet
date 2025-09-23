local colors = import '../Constants/Colors.libsonnet';
local keyboardParams = import '../Constants/Keyboard.libsonnet';
local basicStyle = import 'BasicStyle.libsonnet';
local utils = import 'Utils.libsonnet';


local toolbarBackgroundStyleName = basicStyle.keyboardBackgroundStyleName;
local horizontalCandidateStyleName = 'horizontalCandidateStyle';
local verticalCandidateStyleName = 'verticalCandidateStyle';
local candidateContextMenuStyleName = 'candidateContextMenuStyle';

local newCandidateStyle(param={}, isDark=false) =
  utils.extractProperties(
    param,
    [
      'insets',
      'backgroundInsets',
      'indexFontSize',
      'textFontSize',
      'commentFontSize',
    ]
  )
  + utils.extractColors(
    param,
    [
      'backgroundColor',
      'separatorColor',
      'highlightBackgroundColor',
      'preferredBackgroundColor',
      'preferredIndexColor',
      'preferredTextColor',
      'preferredCommentColor',
      'indexColor',
      'textColor',
      'commentColor',
    ],
    isDark
  );

local newToolbar(isDark=false, params={}) =


  local candidateStateButtonStyleName = 'candidateStateButtonStyle';
  local candidateStateButtonStyle = {
    [candidateStateButtonStyleName]:
      utils.newForegroundStyle(style=candidateStateButtonStyleName + 'ForegroundStyle'),
    [candidateStateButtonStyleName + 'ForegroundStyle']:
      utils.newSystemImageStyle(keyboardParams.toolbar.horizontalCandidateStyle.candidateStateButton, isDark),
  };


  local verticalCandidateBackgroundStyleName = basicStyle.keyboardBackgroundStyleName;

  local verticalCandidateAreaStyleName = 'verticalCandidateOfCandidateStyle';
  local verticalCandidateAreaStyle = {
    [verticalCandidateAreaStyleName]: newCandidateStyle(keyboardParams.toolbar.verticalCandidateStyle.candidateStyle, isDark),
  };

  local verticalCandidatePageUpButtonStyleName = 'verticalCandidatePageUpButtonStyle';
  local verticalCandidatePageUpButtonStyle = {
    [verticalCandidatePageUpButtonStyleName]:
      utils.newBackgroundStyle(style=basicStyle.systemButtonBackgroundStyleName)
      + utils.newForegroundStyle(style=verticalCandidatePageUpButtonStyleName + 'ForegroundStyle'),
    [verticalCandidatePageUpButtonStyleName + 'ForegroundStyle']:
      utils.newSystemImageStyle(keyboardParams.toolbar.verticalCandidateStyle.pageUpButton, isDark),
  };

  local verticalCandidatePageDownButtonStyleName = 'verticalCandidatePageDownButtonStyle';
  local verticalCandidatePageDownButtonStyle = {
    [verticalCandidatePageDownButtonStyleName]:
      utils.newBackgroundStyle(style=basicStyle.systemButtonBackgroundStyleName)
      + utils.newForegroundStyle(style=verticalCandidatePageDownButtonStyleName + 'ForegroundStyle'),
    [verticalCandidatePageDownButtonStyleName + 'ForegroundStyle']:
      utils.newSystemImageStyle(keyboardParams.toolbar.verticalCandidateStyle.pageDownButton, isDark),
  };


  local verticalCandidateReturnButtonStyleName = 'verticalCandidateReturnButtonStyle';
  local verticalCandidateReturnButtonStyle = {
    [verticalCandidateReturnButtonStyleName]:
      utils.newBackgroundStyle(style=basicStyle.systemButtonBackgroundStyleName)
      + utils.newForegroundStyle(style=verticalCandidateReturnButtonStyleName + 'ForegroundStyle'),
    [verticalCandidateReturnButtonStyleName + 'ForegroundStyle']:
      utils.newSystemImageStyle(keyboardParams.toolbar.verticalCandidateStyle.returnButton, isDark),
  };

  local verticalCandidateBackspaceButtonStyleName = 'verticalCandidateBackspaceButtonStyle';
  local verticalCandidateBackspaceButtonStyle = {
    [verticalCandidateBackspaceButtonStyleName]:
      utils.newBackgroundStyle(style=basicStyle.systemButtonBackgroundStyleName)
      + utils.newForegroundStyle(style=verticalCandidateBackspaceButtonStyleName + 'ForegroundStyle'),
    [verticalCandidateBackspaceButtonStyleName + 'ForegroundStyle']:
      utils.newSystemImageStyle(
        {
          systemImageName: 'delete.left',
          normalColor: colors.toolbarButtonForegroundColor,
          highlightColor: colors.toolbarButtonHighlightedForegroundColor,
          fontSize: keyboardParams.toolbar.verticalCandidateStyle.pageUpButton.fontSize,
        },
        isDark
      ),
  };

  local verticalCandidateStyle = newCandidateStyle(keyboardParams.toolbar.verticalCandidateStyle, isDark);

  {
    toolbarHeight: keyboardParams.toolbar.height,
    toolbar:
      utils.newBackgroundStyle(style=toolbarBackgroundStyleName)
      + {
        // TODO: 工具栏按键
      }
      + {
        horizontalCandidateStyle: horizontalCandidateStyleName,
        verticalCandidateStyle: verticalCandidateStyleName,
        candidateContextMenu: candidateContextMenuStyleName,
      },
    [horizontalCandidateStyleName]:
      newCandidateStyle(keyboardParams.toolbar.horizontalCandidateStyle + params, isDark)
      { candidateStateButtonStyle: candidateStateButtonStyleName },
    [verticalCandidateStyleName]:
      utils.extractProperties(keyboardParams.toolbar.verticalCandidateStyle, ['insets', 'backgroundInsets', 'bottomRowHeight'])
      {
        backgroundStyle: verticalCandidateBackgroundStyleName,
        candidateStyle: verticalCandidateAreaStyleName,
        pageUpButtonStyle: verticalCandidatePageUpButtonStyleName,
        pageDownButtonStyle: verticalCandidatePageDownButtonStyleName,
        returnButtonStyle: verticalCandidateReturnButtonStyleName,
        backspaceButtonStyle: verticalCandidateBackspaceButtonStyleName,
      },
    [candidateContextMenuStyleName]: [
      // TODO: 长按候选字菜单
      // {
      //   name: '空格',
      //   action: 'space',
      // },
    ],
  }
  + candidateStateButtonStyle
  + verticalCandidateAreaStyle
  + verticalCandidatePageUpButtonStyle
  + verticalCandidatePageDownButtonStyle
  + verticalCandidateReturnButtonStyle
  + verticalCandidateBackspaceButtonStyle;

{
  new: newToolbar,
}
