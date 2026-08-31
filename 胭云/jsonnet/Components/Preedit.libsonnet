// 预编辑区（输入过程中显示拼音串的那一条）。
local Colors = import '../Constants/Colors.libsonnet';
local Fonts = import '../Constants/Fonts.libsonnet';
local Metrics = import '../Constants/Metrics.libsonnet';
local Style = import 'Style.libsonnet';
local Theme = import 'Theme.libsonnet';

local textStyleName = 'preeditText';

{
  // insets: 区域内边距，iPad 用它把内容往中间收
  new(insets=Metrics.preedit.insets):: {
    preeditHeight: Metrics.preedit.height,
    preeditStyle: {
      insets: insets,
      backgroundStyle: Theme.keyboardBackgroundName,
      foregroundStyle: textStyleName,
    },
    // 预编辑区的前景节点不渲染成图层，引擎只从中读 fontSize / fontWeight / textColor，
    // 所以这里必须写 textColor 而不是 normalColor。
    [textStyleName]: Style.text({
      textColor: Colors.preeditText,
      fontSize: Fonts.preedit,
    }),
  },
}
