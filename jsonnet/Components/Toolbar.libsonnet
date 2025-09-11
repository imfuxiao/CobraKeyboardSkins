local colors = import '../Constants/Colors.libsonnet';
local keyboard = import '../Constants/Keyboard.libsonnet';
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

local newToolbar(isDark=false) =


  local candidateStateButtonStyleName = 'candidateStateButtonStyle';
  local candidateStateButtonStyle = {
    [candidateStateButtonStyleName]:
      utils.newForegroundStyle(style=candidateStateButtonStyleName + 'ForegroundStyle'),
    [candidateStateButtonStyleName + 'ForegroundStyle']:
      utils.newSystemImageStyle(keyboard.toolbar.horizontalCandidateStyle.candidateStateButton, isDark),
  };


  local verticalCandidateBackgroundStyleName = basicStyle.keyboardBackgroundStyleName;

  local verticalCandidateAreaStyleName = 'verticalCandidateOfCandidateStyle';
  local verticalCandidateAreaStyle = {
    [verticalCandidateAreaStyleName]: newCandidateStyle(keyboard.toolbar.verticalCandidateStyle.candidateStyle, isDark),
  };

  local verticalCandidatePageUpButtonStyleName = 'verticalCandidatePageUpButtonStyle';
  local verticalCandidatePageUpButtonStyle = {
    [verticalCandidatePageUpButtonStyleName]:
      utils.newBackgroundStyle(style=basicStyle.systemButtonBackgroundStyleName)
      + utils.newForegroundStyle(style=verticalCandidatePageUpButtonStyleName + 'ForegroundStyle'),
    [verticalCandidatePageUpButtonStyleName + 'ForegroundStyle']:
      utils.newSystemImageStyle(keyboard.toolbar.verticalCandidateStyle.pageUpButton, isDark),
  };

  local verticalCandidatePageDownButtonStyleName = 'verticalCandidatePageDownButtonStyle';
  local verticalCandidatePageDownButtonStyle = {
    [verticalCandidatePageDownButtonStyleName]:
      utils.newBackgroundStyle(style=basicStyle.systemButtonBackgroundStyleName)
      + utils.newForegroundStyle(style=verticalCandidatePageDownButtonStyleName + 'ForegroundStyle'),
    [verticalCandidatePageDownButtonStyleName + 'ForegroundStyle']:
      utils.newSystemImageStyle(keyboard.toolbar.verticalCandidateStyle.pageDownButton, isDark),
  };


  local verticalCandidateReturnButtonStyleName = 'verticalCandidateReturnButtonStyle';
  local verticalCandidateReturnButtonStyle = {
    [verticalCandidateReturnButtonStyleName]:
      utils.newBackgroundStyle(style=basicStyle.systemButtonBackgroundStyleName)
      + utils.newForegroundStyle(style=verticalCandidateReturnButtonStyleName + 'ForegroundStyle'),
    [verticalCandidateReturnButtonStyleName + 'ForegroundStyle']:
      utils.newSystemImageStyle(keyboard.toolbar.verticalCandidateStyle.returnButton, isDark),
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
          fontSize: keyboard.toolbar.verticalCandidateStyle.pageUpButton.fontSize,
        },
        isDark
      ),
  };

  local verticalCandidateStyle = newCandidateStyle(keyboard.toolbar.verticalCandidateStyle, isDark);

  {
    toolbarHeight: keyboard.toolbar.height,
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
      newCandidateStyle(keyboard.toolbar.horizontalCandidateStyle, isDark)
      { candidateStateButtonStyle: candidateStateButtonStyleName },
    [verticalCandidateStyleName]:
      utils.extractProperties(keyboard.toolbar.verticalCandidateStyle, ['insets', 'backgroundInsets', 'bottomRowHeight'])
      {
        backgroundStyle: verticalCandidateBackgroundStyleName,
        candidateStyle: verticalCandidateAreaStyleName,
        pageUpButtonStyle: verticalCandidatePageUpButtonStyleName,
        pageDownButtonStyle: verticalCandidatePageDownButtonStyleName,
        returnButtonStyle: verticalCandidateReturnButtonStyleName,
        backspaceButtonStyle: verticalCandidateBackspaceButtonStyleName,
      },
    [candidateContextMenuStyleName]: {
      // TODO: 长按候选字菜单
    },
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
