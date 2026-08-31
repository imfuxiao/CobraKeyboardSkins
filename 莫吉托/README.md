## 莫吉托

根据 Nuphy「Halo75 V2」莫吉托配色键盘作为创作灵感，设计这款皮肤。

配色取自 `资料/` 目录中的整机实拍，通过对每颗键帽顶面像素取样（去除阴影与高光后取中位色），
再统一做屏幕显示补偿（照片整体偏灰，饱和度 +15%、深色一端再压一档明度）得到下列色板。

---

## 色板预览

![莫吉托色板](资料/palette.png)

> 这张图由 `scripts/gen_palette.py` 从下方三张表格（主色板 / 文字色 / 深色模式）自动生成，
> 色值的唯一来源就是本文件。调整颜色后重新生成：
>
> ```bash
> cd Skins/莫吉托 && python3 scripts/gen_palette.py
> ```
>
> 依赖 Pillow：`pip3 install Pillow`。

---

## 一 主色板

整套配色是一杯**「从杯底到杯口」的莫吉托**：从最深的薄荷叶背，经竹青、薄荷、青柠，
过渡到杯口的苏打与奶白泡沫，中间用奶白作留白。

| 序号 | 色名 | 十六进制 | 采样来源 | 说明 |
| :--: | --- | --- | --- | --- |
| 1 | 松墨 Pine | `#4F7A4A` | Esc / Shift / Ctrl / 方向键 | 最深的一档，薄荷叶背 |
| 2 | 苔绿 Moss | `#638A56` | 底壳侧裙 | 松墨的柔化版 |
| 3 | 竹青 Bamboo | `#7CA265` | Backspace / Enter / F 功能行 | 深绿向浅的过渡 |
| 4 | 薄荷 Mint | `#8CB471` | Tab / Caps | 皮肤主题色，取自「莫吉托」之薄荷 |
| 5 | 深薄荷 Mint Deep | `#6E9E52` | 左上角 LED 指示带 | 薄荷的加重色，用于强调 |
| 6 | 青柠 Lime | `#9CC47C` | Del / Home / End / PgUp | 杯口主光 |
| 7 | 嫩芽 Sprout | `#A9CE84` | Cmd / Opt / 数字行边键 | 泡沫上的浅绿 |
| 8 | 苏打 Soda | `#DCEBC2` | 数字行 / 顶排字母键 | 最浅的一档绿 |
| 9 | 柠檬黄 Lemon | `#E8EFBC` | HALO 徽标键 | 点缀色 |
| 10 | 奶白 Cream | `#F5F8EA` | 字母键 | 主键面 |
| 11 | 汽水白 Fizz | `#F2F6E6` | 空格 | 比奶白略冷 |
| 12 | 冰砂 Frost | `#E7EFDA` | 整机上盖 | 键盘底板 |

### 文字色

| 色名 | 十六进制 | 用法 |
| --- | --- | --- |
| 薄荷字 Mint Ink | `#5C8A55` | 奶白 / 汽水白键面上的字符 |
| 橄榄字 Olive Ink | `#7A9A50` | 苏打、柠檬黄键面上的字符 |
| 叶上字 Leaf Ink | `#F7FBEE` | 薄荷 / 青柠 / 嫩芽 / 竹青键面上的字符 |
| 潭上字 Pine Ink | `#E9F3E4` | 松墨 / 苔绿键面上的字符 |

---

## 二 区域映射

按元书皮肤的键盘分区，建议如下分配（沿用键帽「越靠外越深、越靠中越浅」的规律）：

| 键盘区域 | 常态底色 | 常态字色 | 按下底色 | 按下字色 |
| --- | --- | --- | --- | --- |
| 按键区背景 | `#E7EFDA` | — | — | — |
| 工具栏区背景 | `#E7EFDA` 向上渐隐至 `#E7EFDA03` | — | — | — |
| 预编辑区背景 | `#E7EFDA03` | `#5C8A55` | — | — |
| 候选栏背景 | 同工具栏区 | `#5C8A55` | — | — |
| 候选栏选中项 | `#8CB471` | `#F7FBEE` | — | — |
| 字母 / 数字键 | `#F5F8EA` | `#5C8A55` | `#E3EFCC` | `#47713F` |
| 空格 | `#F2F6E6` | `#5C8A55` | `#E6EEDB` | `#47713F` |
| Shift（未激活） | `#A9CE84` | `#F7FBEE` | `#95BF6C` | `#FFFFFF` |
| Shift（大写锁定） | `#9CC47C` | `#F7FBEE` | `#88B466` | `#FFFFFF` |
| 删除键 | `#7CA265` | `#F7FBEE` | `#6A9053` | `#FFFFFF` |
| 换行 / 回车键 | `#9CC47C` | `#F7FBEE` | `#88B466` | `#FFFFFF` |
| 符号 / 切换键 | `#DCEBC2` | `#7A9A50` | `#C7DCA5` | `#61803C` |
| 中英切换 / 功能键 | `#4F7A4A` | `#E9F3E4` | `#42683E` | `#FFFFFF` |
| 数字键盘运算符 | `#6E9E52` | `#F7FBEE` | `#5D8C42` | `#FFFFFF` |
| 分割线 / 边框 | `#D8E3C7` | — | — | — |

> **键盘上半部不铺满底板色。** iOS 26 起系统会在键盘顶部强制加一段带圆角的高度，
> 底板色若一路铺到顶边，会在那圈圆角处与系统背景撞出一条色差。所以自下而上分三段：
> 按键区是纯底板色 `#E7EFDA`，工具栏区由它向上渐隐到 `#E7EFDA03`（末两位是透明度，
> 约 0.01），预编辑区整条都是 `#E7EFDA03`。三段颜色连续，最上方几乎全透明，
> 圆角处就看不出边界了。深色模式同理，底板色换成 `#161E14`。
>
> 渐隐色是**底板色本身压低透明度**，不是白色也不是黑色——渐变只降 alpha、不动色相，
> 否则中段 alpha 还高的地方会整体偏向那个颜色，深色底板上会浮出一条发黑的带子。
> 这也是它不在色板里单列的原因：由 `Theme.libsonnet` 从底板色派生，改底板色自动跟着变。
>
> 横排候选栏与工具栏同占一块地方，用同一份渐变；纵排候选栏展开后盖住工具栏区 +
> 按键区，渐隐带被压回原本工具栏所占的那一段高度里。

---

## 三 深色模式

深色模式保留同一组色相，压低明度、降低饱和，整体落到「夜色里的一杯莫吉托」：

| 对应亮色 | 深色值 | 用途 |
| --- | --- | --- |
| 冰砂 Frost | `#161E14` | 键盘背景 |
| 奶白 Cream | `#2A3522` | 字母 / 数字键 |
| 汽水白 Fizz | `#303C27` | 空格 |
| 松墨 Pine | `#3E5C3A` | 功能键 |
| 苔绿 Moss | `#4A6942` | 次级功能键 |
| 竹青 Bamboo | `#5A7B4C` | 删除键 |
| 薄荷 Mint | `#5E8A4E` | 主题色 / 候选栏选中 |
| 深薄荷 Mint Deep | `#4F7B40` | 强调回车 / 运算符 |
| 青柠 Lime | `#6B9457` | 换行键 |
| 嫩芽 Sprout | `#77A062` | Shift |
| 苏打 Soda | `#6E7F52` | 符号键 |
| 柠檬黄 Lemon | `#77804A` | 点缀 |
| 薄荷字 Mint Ink | `#AFD198` | 键面字符 |
| 叶上字 Leaf Ink | `#EDF3E4` | 深色键面字符 |
| 分割线 Divider | `#232D1F` | 边框 |

---

## 四 色值落到代码里的位置

上面三张表已经被翻译成 `jsonnet/Constants/Palette.libsonnet`，那里是编译时的唯一色值来源：

```jsonnet
{
  pine:  { light: '#4F7A4A', dark: '#3E5C3A' },  // 松墨
  mint:  { light: '#8CB471', dark: '#5E8A4E' },  // 薄荷
  cream: { light: '#F5F8EA', dark: '#2A3522' },  // 奶白
  // …… 共 30 个色，每个都是 { light, dark } 一对
}
```

「哪个色用在哪」则在 `jsonnet/Constants/Colors.libsonnet`，它把上面第二节的区域映射表
写成了一张**按键角色表**——一行一个角色，改一行就换掉一整类按键的配色：

```jsonnet
roles: {
  //          底色         按下底色              下边缘        字色         按下字色
  letter: { fill: P.cream,  pressed: P.creamPressed,  edge: P.divider,       ink: P.inkMint, inkPressed: P.inkMintPressed },
  shift:  { fill: P.sprout, pressed: P.sproutPressed, edge: P.sproutPressed, ink: P.inkLeaf, inkPressed: P.inkWhite },
  // ……
}
```

> 改色只需要动 `Palette.libsonnet` 与 `Colors.libsonnet` 两个文件，
> `Components/` 与 `Keyboards/` 下的代码一律不必碰。

---

## 五 配色使用原则

1. **同一行内不要出现两个跨度过大的色阶。** 键帽原设计里，每一行的功能键颜色都是相邻色阶（如 Tab 薄荷 → Caps 薄荷 → Shift 松墨 → Ctrl 松墨），自上而下逐行加深。
2. **字母区永远是奶白。** 所有绿色只出现在两侧功能键与顶行，中央保持大面积留白，这是杯口那层泡沫。
3. **最深的松墨只用在低频键上。** 它对应键帽套装里 Esc 与右侧导航区那几颗压舱色，在皮肤中留给中英切换 / 收起键盘。
4. **按下态 = 常态色加深约 10%~12% 明度**，不换色相，保持整体清爽。
5. **底板色不要碰到键盘顶边。** 工具栏区往上渐隐、预编辑区整条透明，把键盘顶边让给系统的圆角背景，见第二节表格下的说明。

---

## 六 键盘布局

已覆盖拼音与数字两种键盘、各四种场景，`config.yaml` 由编译自动生成：

| 键盘 | 设备 / 方向 | 文件 | 布局 |
| --- | --- | --- | --- |
| 拼音 | iPhone 竖屏 / 横屏 | `pinyinPortrait` / `pinyinLandscape` | 26 键四行，字母键带上划角标 |
| 拼音 | iPad 竖屏 / 横屏 | `iPadPinyinPortrait` / `iPadPinyinLandscape` | 全键盘五行，键面上标 + 下标 |
| 拼音 | iPad 浮动 | 复用 `pinyinPortrait` | 同 iPhone 竖屏 |
| 数字 | iPhone 竖屏 | `numericPortrait` | 九宫格单栏 |
| 数字 | iPhone 横屏 | `numericLandscape` | 九宫格 + 右侧分类符号面板 |
| 数字 | iPad 竖屏 / 横屏 | `iPadNumericPortrait` / `iPadNumericLandscape` | 同上双栏 |

> `numeric` 一项同时供 `numeric` 与 `numberPad` 两种键盘类型使用。

布局本身就写成表格，加键、换上划符号、调宽度都只改表，不动代码。
`jsonnet/Keyboards/iPhonePinyin.libsonnet` 的第一张表长这样：

```jsonnet
// [字母, 上划符号]。上划符号同时是键面右上角的角标与气泡里的上划提示。
local letterRows = [
  [['q', '1'], ['w', '2'], ['e', '3'], /* …… */ ['p', '0']],
  [['a', '`'], ['s', '/'], ['d', ':'], /* …… */ ['l', '”']],
  [['z', '@'], ['x', "'"], ['c', '#'], /* …… */ ['m', '…']],
];
```

第二张表是宽度，按 1125 的虚拟设计宽度分配，一行内分子加起来正好 1125 就铺满：

```
第一行 10 × 112.5                          = 1125
第二行 168.75 + 7 × 112.5 + 168.75          = 1125
第三行 168.75 + 7 × 112.5 + 168.75          = 1125
第四行 225 + 112.5 + 空格 450 + 112.5 + 225 = 1125
```

### 数字键盘

九宫格分五列，宽度 17 / 22 / 22 / 22 / 17，加起来正好 100：

| 列 | 内容 |
| --- | --- |
| 1（窄） | 符号列表（占四分之三高）+ `#+=` |
| 2 | 1 / 4 / 7 / 返回 |
| 3 | 2 / 5 / 8 / 0 |
| 4 | 3 / 6 / 9 / 空格 |
| 5（窄） | 删除 / `.` / `=` / 回车 |

配色沿用第五节原则 2：绿色只落在最外两列，中间三列数字保持奶白。
`=` 用第二节表里的「数字键盘运算符」深薄荷，是整块键盘上唯一的重色。

屏幕够宽时（横屏、iPad）右半边再挂一块分类符号面板，左右各占 45%，中间留 10% 的空隙。
这两块面板的内容由引擎自己填（符号取自 App 内的「数字键盘符号」设置），
皮肤能定的只有背景、内边距与分隔线色——它们的 `cellStyle` 引擎读了但不用，所以没写。

> `#+=` 切到符号键盘。本皮肤没有定义 `symbolic`，此时用的是引擎内置的符号键盘，
> 观感与本皮肤不一致。要接上的话，照 `Keyboards/Numeric.libsonnet` 的写法加一个
> `Keyboards/Symbolic.libsonnet`，再在 `main.jsonnet` 的产物矩阵与 `config` 里各加一项即可。

### 几个已经接好的交互

- **上划**：字母键上划出角标里的符号；空格上划次选上屏；回车上划换行；Shift 上下划发 Tab。
- **随状态换装**：回车键跟着系统 `returnKeyType` 在青柠 / 深薄荷之间切换并改文案；
  中英切换键跟着 RIME 的 `ascii_mode` 换图标；有预编辑文本时空格显示「选定」、Shift 显示「Esc」。
- **短按气泡**：字母键弹出大写字母，右上角带上划符号提示。
- **按下缩放**：所有按键按下时整键缩到 92%（40ms）并保持，抬起用 90ms 弹回。
  参数在 `Components/Theme.libsonnet` 的 `pressAnimation`；某一颗键不要动画就给它传 `animation: []`。

### 两处与色板的取舍

- **Shift 大写锁定**：引擎只支持切换前景样式，不支持切换背景，所以第二节表里
  「Shift（大写锁定）用青柠」改为保持嫩芽底色、把图标换成 `capslock.fill` 并提亮到纯白。
- **中英切换键用松墨**：这一颗是第四行里唯一的深色块，与相邻的青柠回车键色阶跨度偏大，
  和第五节原则 1 有张力。这里选择遵从第二节的区域映射表——它对应键帽套装里最深的 Esc
  与导航键，读起来是有意为之的锚点。想让整行更柔和，把 `Colors.libsonnet` 里 `functional`
  角色的 `P.pine` 换成 `P.moss` 即可。

---

## 七 目录结构与构建

```
莫吉托/
├── Makefile
├── README.md                  ← 你正在看的这份，也是色值的说明书
├── demo.png                   ← 由 scripts/gen_demo.py 从编译产物生成
├── 资料/                       ← 整机实拍与色板预览图
├── scripts/
│   ├── gen_palette.py         ← 从本文件的三张表生成色板预览图
│   └── gen_demo.py            ← 从编译产物生成 demo.png
└── jsonnet/
    ├── main.jsonnet           ← 入口：声明要出哪些文件
    ├── Constants/             ← 数据，不含逻辑
    │   ├── Palette.libsonnet    有哪些颜色
    │   ├── Colors.libsonnet     这些颜色怎么用（按键角色表）
    │   ├── Fonts.libsonnet      字号
    │   └── Metrics.libsonnet    高度、间距、圆角
    ├── Components/            ← 通用构件，不知道有哪些键盘
    │   ├── Style.libsonnet      样式节点构造 + 深浅色解析（不依赖任何模块）
    │   ├── Theme.libsonnet      角色 → 样式名与样式节点
    │   ├── Button.libsonnet     按键构造，收敛全部命名规则
    │   ├── FunctionKeys.libsonnet 功能键，每个键的外观 + 动作 + 通知收在一处
    │   ├── Layout.libsonnet     HStack / VStack 语法糖
    │   ├── Preedit.libsonnet    预编辑区
    │   └── Toolbar.libsonnet    工具栏与横 / 纵候选栏
    └── Keyboards/             ← 一种键盘一个文件，只写表
        ├── iPhonePinyin.libsonnet
        ├── iPadPinyin.libsonnet
        └── Numeric.libsonnet
```

依赖方向是单向的：`Constants ← Components ← Keyboards ← main`，没有环。
`Style.libsonnet` 不 import 任何东西，可以整份搬到别的皮肤里用。

**深浅色只处理一次。** 所有构件都只写色名（`{ light, dark }` 一对），
到 `main.jsonnet` 最后一步才把整棵配置树 `resolve` 成具体色值，
于是 `isDark` 不必作为参数穿过每一个函数。

**没用到的样式不写进产物。** 通用构件是按「全套角色」生成的，
但一份键盘往往只用到其中几个——数字键盘没有 Shift，也不弹气泡。
`Style.prune` 在出文件前扫一遍，把没有任何地方引用的样式节点丢掉，
所以加角色、加构件不会让每份产物都跟着变胖。

### 常用命令

```bash
make compile    # 只编译出 config.yaml / light/ / dark/
make validate   # 编译后跑结构校验，查「引用了不存在的样式」这类会让按键静默变空白的问题
make preview    # 编译后渲染预览图，查「某行没铺满」这类校验器看不出的几何问题
make build      # 打包成 build/莫吉托.cskin，可直接安装
```

在手机上改皮肤时，长按皮肤选择「运行 main.jsonnet」即可重新编译。

### 加一个分号键

`jsonnet/main.jsonnet` 顶部：

```jsonnet
local addSemicolon = false;   // 改成 true，第二行末尾会多出一个分号键
```

打开后第二行变成 10 个键，`a` 与 `l` 不再加宽。
