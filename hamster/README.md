# 仓默认 26 键盘

皮肤文件通过 `Jsonnet` 语法编写，PC 端编译时需要安装 `jsonnet` 等命令行工具。


## 常见问题

### 如何添加分号键

在 jsonnet/main.jsonnet 文件中，有一个 `local addSemicolon = false;` 的变量，默认是 `false` 表示不添加分号键。

如需添加，请将 `false` 改为 `true`，保存后，长按皮肤并选择 `运行 main.jsonnet`。
