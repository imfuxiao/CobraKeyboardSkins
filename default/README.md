# 「极简」

皮肤文件通过 `Jsonnet` 语法编写，PC 端编译时需要安装 `jsonnet` 等命令行工具。

## 使用说明

本皮肤不包含「英文键盘」，如需输入英文，可使用 RIME 的 `ascii_mode` 切换，或者使用系统自带的英文输入法。

快捷键：

- `e` 键上划：打开 Emoji 键盘
- `s` 键上划：打开脚本页面(助记：脚本 = Script，所以放在 `s` 键上划)
- `p` 键上划：打开剪贴板页面（助记：剪贴板 = Pasteboard，所以放在 `p` 键上划）
- `a` 键上划：RIME `ascii_mode` 状态切换

## 自定义皮肤调整说明

- `jsonnet/Constants/Keyboard.libsonnet`: 定义了键盘按键，各区域高度等常量。

  如想对按键上下划动进行调整，可在此文件中添加或修改对应按键的 `swipeUpAction` 或 `swipeDownAction` 属性。

## 如何为单个按键设置颜色

在 `jsonnet/Constants/Keyboard.libsonnet` 中找到对应按键的定义，在 `params` 属性中添加或修改 `color` 相关属性。

- backgroundNormalColor： 背景颜色（正常状态）
- backgroundHighlightColor： 背景颜色（高亮状态）
- foregroundNormalColor： 前景颜色（正常状态）
- foregroundHighlightColor： 前景颜色（高亮状态）

注意：每种颜色需要分别设置 light 和 dark 两个模式的值，以适配不同的系统主题。例如：

```jsonnet
{
  // ...
  qButton: {
    name: 'qButton',
    params: {
      action: { character: 'q' },
      uppercasedStateAction: { character: 'Q' },
      backgroundNormalColor: {
        light: '#fff1bc',
        dark: '#FFFFFF',
      },
      backgroundHighlightColor: {
        light: '#699c78',
        dark: '#FFFFFF',
      },
      foregroundNormalColor: {
        light: '#DD105E',
        dark: '#FFFFFF',
      },
      foregroundHighlightColor: {
        light: '#BDBDD7',
        dark: '#FFFFFF',
      },
    },
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
