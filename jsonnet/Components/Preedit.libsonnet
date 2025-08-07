local Parameters = import '../Variables/Preedit.libsonnet';

{
  new(isDark=false): {
    local textColor = if isDark then Parameters.textColor.dark else Parameters.textColor.light,

    preeditHeight: Parameters.height,
    preedit: {
      insets: Parameters.insets,
      foregroundStyle: 'preeditForegroundStyle',
    },
    preeditForegroundStyle: {
      fontSize: Parameters.fontSize,
      textColor: textColor,
    },
  },
}
