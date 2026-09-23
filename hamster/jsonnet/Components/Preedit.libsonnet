local colors = import '../Constants/Colors.libsonnet';
local Metrics = import '../Constants/Metrics.libsonnet';
local Button = import 'Button.libsonnet';
local Theme = import 'Theme.libsonnet';
local utils = import 'Utils.libsonnet';

local preeditForegroundStyleName = 'preeditForegroundStyle';

// params: 直接合并进 preeditStyle 的额外字段（例如 iPad 传 { insets: Metrics.iPadSideInsets }
// 整体替换掉下面的默认 insets）。
local newPreedit(isDark=false, params={}) = {
  preeditHeight: Metrics.preedit.height,
  preeditStyle: { insets: Metrics.preedit.insets }
                + utils.newBackgroundStyle(style=Theme.keyboardBackgroundName)
                + utils.newForegroundStyle(style=preeditForegroundStyleName)
                + params,
  [preeditForegroundStyleName]: utils.newTextStyle({
    normalColor: colors.preeditForegroundColor,
    fontSize: Metrics.preedit.fontSize,
  }, isDark),
};

{
  new: newPreedit,
}
