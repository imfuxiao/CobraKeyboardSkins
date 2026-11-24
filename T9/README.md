# 中文九键皮肤

注意：暂不支持 iPad。

皮肤文件通过 `Jsonnet` 语法编写，PC 端编译时需要安装 `jsonnet` 等命令行工具。

## 功能说明

- **九键拼音页**：右侧回车键占满下方两格空间；`1`~`9` 键支持上划直接输入对应数字，长按弹出紧凑符号/字母网格菜单（默认高亮对应数字，可直接松手输入或滑动选择大小写字母与常用符号）。
- **工具栏**：非输入态展示左侧键盘菜单按钮与右侧收起键盘按钮，输入态自动切换为横排或纵排候选字栏。
- **26 键英文页与九宫格数字页**：提供完整英文直出键盘与数字键盘，横竖屏自适应布局。

## 目录结构

```
jsonnet/
  main.jsonnet            产物矩阵与 config.yaml 路由
  Constants/
    Colors.libsonnet      配色（{ light, dark } 令牌对）
    Fonts.libsonnet       字号表
    Metrics.libsonnet     高度、内边距、圆角、列宽与长按网格尺寸
    Keys.libsonnet        按键数据表（动作、上划、长按选项与集合视图）
  Components/
    Style.libsonnet       样式节点构造、深浅色递归解析、无用节点裁剪
    Layout.libsonnet      布局语法糖（HStack / VStack）
    Theme.libsonnet       共享样式节点、回车条件样式、Shift 状态与通知
    Button.libsonnet      按键构造器（普通键、系统键、角标、气泡、长按网格）
    Preedit.libsonnet     预编辑区
    Toolbar.libsonnet     工具栏与横/纵排候选字栏
  Keyboards/
    Pinyin.libsonnet      九键拼音键盘（横竖屏共用）
    Alphabetic.libsonnet  26 键英文键盘（横竖屏共用）
    Numeric.libsonnet     九宫格数字键盘（横竖屏共用）
```

## 自定义调整

- 修改按键动作、上划或长按候选列表：编辑 `jsonnet/Constants/Keys.libsonnet`。
- 修改配色：编辑 `jsonnet/Constants/Colors.libsonnet`（按 `{ light, dark }` 成对配置）。
- 修改高度、边距或长按网格单元格尺寸：编辑 `jsonnet/Constants/Metrics.libsonnet`。
- 为单个普通按键自定义颜色：在 `Keys.libsonnet` 中给该键添加 `backgroundNormalColor`、`backgroundHighlightColor`、`foregroundNormalColor`、`foregroundHighlightColor`。

## 手机端编译

长按皮肤，选择「运行 main.jsonnet」。

## PC 端编译

```shell
make
```
