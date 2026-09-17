// 「Gboard」皮肤入口 —— 只负责声明「要出哪些文件」，具体内容全在 Keyboards/ 下。
//
// 编译：make compile（或在手机上长按皮肤选择「运行 main.jsonnet」）
local Style = import 'Components/Style.libsonnet';
local NumberPad = import 'Keyboards/NumberPad.libsonnet';
local Numeric = import 'Keyboards/Numeric.libsonnet';
local Pinyin = import 'Keyboards/Pinyin.libsonnet';
local Symbolic = import 'Keyboards/Symbolic.libsonnet';

// ===== 产物矩阵 =====
// 文件名 -> 键盘定义。每份定义都会生成 light/ 与 dark/ 两个文件。
//
// 四种键盘的**布局在四种场景下完全相同**，只有键盘高度与按键间距不一样
// （见 Constants/Metrics.libsonnet 的两张表），所以这里只是同一个构造函数换参数。
local variants = {
  Portrait: { device: 'iPhone', isPortrait: true },
  Landscape: { device: 'iPhone', isPortrait: false },
  iPadPortrait: { device: 'iPad', isPortrait: true },
  iPadLandscape: { device: 'iPad', isPortrait: false },
};

// 这张表的**键就是键盘类型 id**：config.yaml 按它分组，按键的
// `action: { keyboardType: ... }` 也写它，产物文件名同样由它派生。
//
// 符号页挂在 `gboardSymbolic` 这个自定义类型下，而不是内置的 `symbolic`——
// 引擎在「keyboardType == symbolic 且皮肤没声明 symbolic」时会挂上自带的分类符号键盘
// （KeyboardUI/.../KeyboardView+Layout.swift 的 layoutInternalSymbolic）。
// 占着 `symbolic` 就把那块键盘顶掉了，腾开之后两套符号键盘可以各走各的：
// 数字页的 `=\<` 进本皮肤这一套，九宫格的 `!?#` 进引擎自带的那一套。
//
// 类型名不在 Keyboard.KeyboardType 的枚举里时，引擎按 `.custom(named:)` 处理
// （见 HamsterKit/.../Keyboard+KeyboardType.swift 的 from(identifier:)），所以自定义名字是合法的。
local builders = {
  pinyin: Pinyin,
  numeric: Numeric,
  gboardSymbolic: Symbolic,
  numberPad: NumberPad,
};

// 文件名规则：iPhone 是「类型 + 方向」，iPad 是「iPad + 首字母大写的类型 + 方向」。
// 与仓库里其他皮肤（default / 彩虹）的命名一致。
local capitalize(name) = std.asciiUpper(name[0]) + std.substr(name, 1, std.length(name) - 1);
local fileName(type, variant) =
  if std.startsWith(variant, 'iPad') then
    'iPad' + capitalize(type) + std.substr(variant, 4, std.length(variant) - 4)
  else
    type + variant;

local keyboards = {
  [fileName(type, variant)]: builders[type].new(
    device=variants[variant].device,
    isPortrait=variants[variant].isPortrait,
  )
  for type in std.objectFields(builders)
  for variant in std.objectFields(variants)
};

// 哪种键盘、哪种设备与方向读哪个文件。
// 缺声明的场景键盘会显示为空白，不会回退，所以四个方向都要给全。
//
// 注意 `numberPad` 这一项：引擎原本让 numberPad 与 numeric 共读 `numeric`，
// 本仓库在 KeyboardUI/.../Node+.swift 的 getKeyboardName 里改成了
// 「numberPad 先查自己这一项，查不到再回退 numeric」，所以九宫格才能独立排版。
// 只写 numeric 的老皮肤行为不变。
local scenes(type) = {
  iPhone: {
    portrait: fileName(type, 'Portrait'),
    landscape: fileName(type, 'Landscape'),
  },
  iPad: {
    portrait: fileName(type, 'iPadPortrait'),
    landscape: fileName(type, 'iPadLandscape'),
    // iPad 浮动键盘的宽度接近 iPhone 竖屏，直接复用那一份
    floating: fileName(type, 'Portrait'),
  },
};

local config = { [type]: scenes(type) for type in std.objectFields(builders) };

{
  'config.yaml': std.manifestYamlDoc(config, indent_array_in_object=true, quote_keys=false),
}
+ {
  // JSON 是 YAML 的子集，这里用 std.toString 而不是 std.manifestYamlDoc：
  // 后者在这个体量下慢到影响手机上的实时编译，产物对引擎完全等价。
  [scheme + '/' + name + '.yaml']: std.toString(Style.prune(Style.resolve(keyboards[name], scheme == 'dark')))
  for name in std.objectFields(keyboards)
  for scheme in ['light', 'dark']
}
