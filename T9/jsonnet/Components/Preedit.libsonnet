// 预编辑区：键盘顶部显示正在输入的编码。
local colors = import '../Constants/Colors.libsonnet';
local metrics = import '../Constants/Metrics.libsonnet';
local Style = import 'Style.libsonnet';
local Theme = import 'Theme.libsonnet';

local foregroundName = 'preeditForegroundStyle';

{
  new(insets=metrics.preedit.insets):: {
    preeditHeight: metrics.preedit.height,
    preeditStyle: {
      insets: insets,
      backgroundStyle: Theme.keyboardBackgroundName,
      foregroundStyle: foregroundName,
    },
    [foregroundName]: Style.text({
      normalColor: colors.preeditForegroundColor,
      fontSize: metrics.preedit.fontSize,
    }),
  },
}
