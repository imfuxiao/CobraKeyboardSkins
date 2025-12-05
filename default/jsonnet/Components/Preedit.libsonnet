local colors = import '../Constants/Colors.libsonnet';
local keyboardParams = import '../Constants/Keyboard.libsonnet';
local basicStyle = import 'BasicStyle.libsonnet';
local utils = import 'Utils.libsonnet';

local preeditBackgroundStyleName = basicStyle.keyboardBackgroundStyleName;
local preeditForegroundStyleName = 'preeditForegroundStyle';

local newPreedit(isDark=false, params={}) = {
  preeditHeight: keyboardParams.preedit.height,
  preeditStyle: {
             insets: keyboardParams.preedit.insets,
           }
           + utils.newBackgroundStyle(style=preeditBackgroundStyleName)
           + utils.newForegroundStyle(style=preeditForegroundStyleName)
           + params,
  [preeditForegroundStyleName]: utils.newTextStyle({
    normalColor: colors.preeditForegroundColor,
    fontSize: keyboardParams.preedit.fontSize,
  }, isDark),
};

{
  new: newPreedit,
}
