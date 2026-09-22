// 「极简」皮肤入口 —— 只负责声明「要出哪些文件」，具体内容全在 Keyboards/ 下。
//
// 编译：make compile（或在手机上长按皮肤选择「运行 main.jsonnet」）
local Style = import 'Components/Style.libsonnet';
local iPadNumeric = import 'Keyboards/iPadNumeric.libsonnet';
local iPadPinyin = import 'Keyboards/iPadPinyin.libsonnet';
local iPhoneNumeric = import 'Keyboards/iPhoneNumeric.libsonnet';
local iPhonePinyin = import 'Keyboards/iPhonePinyin.libsonnet';
local iPhoneSymbolic = import 'Keyboards/iPhoneSymbolic.libsonnet';

// ===== 产物矩阵：文件名 -> 键盘定义 =====
// 每份定义都会生成 light/ 与 dark/ 两个文件，两者的差别只在色值上，
// 由 Style.resolve 在最后一步一次性解开（见 Components/Style.libsonnet）。
local keyboards = {
  pinyinPortrait: iPhonePinyin.new(isPortrait=true),
  pinyinLandscape: iPhonePinyin.new(isPortrait=false),
  numericPortrait: iPhoneNumeric.new(isPortrait=true),
  numericLandscape: iPhoneNumeric.new(isPortrait=false),
  symbolicPortrait: iPhoneSymbolic.new(isPortrait=true),
  symbolicLandscape: iPhoneSymbolic.new(isPortrait=false),

  iPadPinyinPortrait: iPadPinyin.new(isPortrait=true),
  iPadPinyinLandscape: iPadPinyin.new(isPortrait=false),
  iPadNumericPortrait: iPadNumeric.new(isPortrait=true),
  iPadNumericLandscape: iPadNumeric.new(isPortrait=false),
};

// 哪种键盘、哪种设备与方向读哪个文件。
// 缺声明的场景键盘会显示为空白，不会回退，所以每种键盘的四个场景都要给全。
//
// iPad 上没有单独的符号页：iPad 的数字页一页就放下了 iPhone 上两页的内容，
// 所以 symbolic 在 iPad 上直接指回拼音页（按 `123` 走数字页，不存在第二页）。
local config = {
  pinyin: {
    iPhone: { portrait: 'pinyinPortrait', landscape: 'pinyinLandscape' },
    iPad: {
      portrait: 'iPadPinyinPortrait',
      landscape: 'iPadPinyinLandscape',
      // iPad 浮动键盘的宽度接近 iPhone 竖屏，直接复用那一份
      floating: 'pinyinPortrait',
    },
  },
  numeric: {
    iPhone: { portrait: 'numericPortrait', landscape: 'numericLandscape' },
    iPad: {
      portrait: 'iPadNumericPortrait',
      landscape: 'iPadNumericLandscape',
      floating: 'numericPortrait',
    },
  },
  symbolic: {
    iPhone: { portrait: 'symbolicPortrait', landscape: 'symbolicLandscape' },
    iPad: {
      portrait: 'iPadPinyinPortrait',
      landscape: 'iPadPinyinLandscape',
      floating: 'symbolicPortrait',
    },
  },
};

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
