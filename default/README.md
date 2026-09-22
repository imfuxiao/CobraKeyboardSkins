# 「极简」

皮肤文件通过 `Jsonnet` 语法编写，PC 端编译时需要安装 `jsonnet` 等命令行工具。

## 使用说明

本皮肤不包含「英文键盘」，如需输入英文，可使用 RIME 的 `ascii_mode` 切换，或者使用系统自带的英文输入法。

快捷键：

- `e` 键上划：打开 Emoji 键盘
- `s` 键上划：打开脚本页面(助记：脚本 = Script，所以放在 `s` 键上划)
- `p` 键上划：打开剪贴板页面（助记：剪贴板 = Pasteboard，所以放在 `p` 键上划）
- `a` 键上划：RIME `ascii_mode` 状态切换
- iPad `Tab` 键上划：键盘分体（Split）开关，见下
- iPhone 横屏 `Shift`（拼音页）/ `#+=`（数字页）/ `123`（符号页）键上划：键盘分体开关，见下

## 分体键盘（Split）

键盘可以从中间分开，两个大拇指各管一边：iPad 不限方向，iPhone 只在横屏（竖屏太窄，
分成两半没有使用价值）。

**分开 / 合并是同一个手势**——上划该页行首那颗功能键：iPad 上是 `Tab`（左上角）；
iPhone 上是拼音页 `Shift`、数字页 `#+=`、符号页 `123`（iPhone 没有 Tab 键，
选它们是因为都在行首角落、且分体后仍要用，不会被顶掉）。这颗键上划一次进分体，
分体态下再上划一次就合回去，没有另外的「点一下合并」按钮。

支持分体的页面，工具栏系统菜单键右侧也有一颗状态切换键（图标随 `$keyboardSplitState`
在「展开」「收起」两态间切换），点它效果一样；不支持分体的页面（iPhone 竖屏）不显示这颗键。
状态会记住，下次启动键盘还是分体的；状态是全局的，同一页面上分体、切到另一页也还是分体的
（前提是那一页也适配了分体）。

几点说明：

- 分体只在 iPad 与 iPhone 横屏的拼音 / 数字 / 符号页生效，iPhone 竖屏两种状态逐像素相同。
- 分体后键盘**总高度不变**：iPad 靠把顶上那排数字行收起来腾出地方，剩下四行分掉整块高度，
  所以键会比合并态高一截；iPhone 横屏本来就是四行、没有独立的数字行，分体不影响总高。
  这是机制决定的：总高挂在配置根节点上，分体覆盖块够不着它（见 `docs/键盘Split状态.md`）。
- 分体后放不下的键会收起来，它们的字符仍可由上划取得（iPad 的 `【】、；‘ ，。/` 等；
  iPhone 上每行的字母/数字/符号本身放得下，只是键距变窄）。
- 分体与单手模式互斥，开启单手模式会自动合并键盘。

## 目录结构

```
jsonnet/
  main.jsonnet            出哪些文件、config.yaml 怎么写
  Constants/
    Colors.libsonnet      配色（每项都是 { light, dark } 一对）
    Fonts.libsonnet       字号
    Metrics.libsonnet     高度、内边距、圆角
    Keys.libsonnet        按键表：一颗键「做什么」（动作、上下划）
  Components/
    Style.libsonnet       样式节点构造、深浅色解析、无用节点裁剪
    Layout.libsonnet      布局语法糖
    Widths.libsonnet      宽度表：一颗键「占一行的多少」
    Button.libsonnet      按键构造器（唯一拼装按键的地方）
    Theme.libsonnet       全皮肤共用的样式节点
    Split.libsonnet       分体键盘的版面
    Preedit.libsonnet     预编辑区
    Toolbar.libsonnet     系统菜单/分体切换/收起键盘 + 候选字栏
  Keyboards/              五份版面，各自只写「哪一行放哪些键」
```

## 自定义皮肤调整说明

- `jsonnet/Constants/Keys.libsonnet`：每颗键做什么。

  想调整某颗键的上下划动，在这里给它加 `swipeUpAction` / `swipeDownAction`。

- `jsonnet/Constants/Metrics.libsonnet`：各区域的高度、键与键之间的缝隙、圆角。

- `jsonnet/Components/Widths.libsonnet`：每颗键占一行的多少。

  **一行里所有键的宽度加起来必须正好是一整行**，多了少了都不会报错，但画出来一定是错的。

## 如何为单个按键设置颜色

在 `jsonnet/Constants/Keys.libsonnet` 中找到对应按键，加上颜色字段即可。
只有加了颜色的键才会单独生成一份键帽样式，其余的键共用同一份。

- `backgroundNormalColor`：背景颜色（正常状态）
- `backgroundHighlightColor`：背景颜色（按下状态）
- `foregroundNormalColor`：前景颜色（正常状态）
- `foregroundHighlightColor`：前景颜色（按下状态）

每种颜色都要分别给 light 与 dark 两个值，以适配系统主题。例如：

```jsonnet
{
  // ...
  qButton: letter('q') {
    backgroundNormalColor: { light: '#fff1bc', dark: '#FFFFFF' },
    backgroundHighlightColor: { light: '#699c78', dark: '#FFFFFF' },
    foregroundNormalColor: { light: '#DD105E', dark: '#FFFFFF' },
    foregroundHighlightColor: { light: '#BDBDD7', dark: '#FFFFFF' },
  },
  // ...
}
```

## 手机端编译

长按皮肤，选择「运行 main.jsonnet」

## PC 端编译

```shell
make
```
