// 字号表。单位是 point，按 iPhone 竖屏 390pt 宽换算（设计图像素 ÷ 954 × 390）。
//
// Gboard 的键面字比 iOS 原生小一号、字重更轻，靠的是「字小、键面留白多」这个对比。
{
  preedit: 16,  // 预编辑区

  toolbarIcon: 20,  // 工具栏图标
  candidateStateIcon: 19,  // 候选栏展开 / 翻页图标

  keyLabel: 22,  // 字母键主标签
  numericKeyLabel: 24,  // 数字键盘的数字键，键面大，字也大一号
  symbolKeyLabel: 21,  // 符号键盘的符号键，字形普遍比字母宽，收小一点
  keyBadge: 10,  // 键面右上角标（上划符号）
  keyIcon: 21,  // 功能键图标（SF Symbols）
  keyText: 13,  // 功能键文字（?123、返回、=\<）。四个字符要塞进一颗窄键，比键面字小两号
  keyDouble: 13,  // 双行键面（emoji + 逗号、12 + 34）
  spaceLabel: 14,  // 空格上的方案名

  hintLabel: 26,  // 短按气泡里的大字
  hintGridLabel: 20,  // 长按符号网格里的备选符号。格子比按键窄，字也跟着小两号

  candidateIndex: 12,
  candidateText: 17,
  candidateComment: 13,
}
