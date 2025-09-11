local colors = import '../Constants/Colors.libsonnet';
local keyboard = import '../Constants/Keyboard.libsonnet';
local basicStyle = import 'BasicStyle.libsonnet';
local utils = import 'Utils.libsonnet';

local preeditBackgroundStyleName = basicStyle.keyboardBackgroundStyleName;
local preeditForegroundStyleName = 'preeditForegroundStyle';

local newPreedit(isDark=false) = {
  preeditHeight: keyboard.preedit.height,
  preedit: {
             insets: keyboard.preedit.insets,
           } + utils.newBackgroundStyle(style=preeditBackgroundStyleName)
           + utils.newForegroundStyle(style=preeditForegroundStyleName),
  [preeditForegroundStyleName]: utils.newTextStyle({
    normalColor: colors.preeditForegroundColor,
    fontSize: keyboard.preedit.fontSize,
  }, isDark),
};

{
  new: newPreedit,
}
