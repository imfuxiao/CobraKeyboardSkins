local Basic = import 'Basic.libsonnet';
local Colors = import 'Colors.libsonnet';
local Fonts = import 'Fonts.libsonnet';

{
  height: 26,
  insets: {
    left: 4,
    top: 2,
  },
  fontSize: Fonts.preeditFontSize,
  textColor: Colors.primaryTextColor,
}
