local Colors = import 'Colors.libsonnet';

{
  systemButtonBackgroundStyle: {
    isOriginal: true,  // 使用原生背景色, false 则使用图片背景
    insets: { top: 6, left: 3, bottom: 6, right: 3 },
    normalColor: Colors.systemButtonNormalBackgroundColor,
    highlightColor: Colors.systemButtonHighlightBackgroundColor,
    cornerRadius: 6,
    normalLowerEdgeColor: Colors.lowerEdgeOfButtonNormalColor,
    highlightLowerEdgeColor: Colors.lowerEdgeOfButtonHighlightColor,
    animation: 'alphabeticBackgroundAnimation',
  },
}
