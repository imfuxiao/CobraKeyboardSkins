// 「胭云」皮肤入口 —— 只负责声明「要出哪些文件」，具体内容全在 Keyboards/ 下。
//
// 编译：make compile（或长按皮肤选择「运行 main.jsonnet」）
local Style = import 'Components/Style.libsonnet';
local Numeric = import 'Keyboards/Numeric.libsonnet';
local iPadPinyin = import 'Keyboards/iPadPinyin.libsonnet';
local iPhonePinyin = import 'Keyboards/iPhonePinyin.libsonnet';

// 第二行末尾是否加分号键。改成 true 后保存重新编译即可。
local addSemicolon = false;

// ===== 产物矩阵 =====
// 文件名 -> 键盘定义。每份定义都会生成 light/ 与 dark/ 两个文件。
local keyboards = {
  pinyinPortrait: iPhonePinyin.new(isPortrait=true, addSemicolon=addSemicolon),
  pinyinLandscape: iPhonePinyin.new(isPortrait=false, addSemicolon=addSemicolon),
  iPadPinyinPortrait: iPadPinyin.new(isPortrait=true),
  iPadPinyinLandscape: iPadPinyin.new(isPortrait=false),

  // 数字键盘。只有 iPhone 竖屏窄到放不下符号面板，其余三种都是双栏。
  numericPortrait: Numeric.new(device='iPhone', isPortrait=true, symbolPanel=false),
  numericLandscape: Numeric.new(device='iPhone', isPortrait=false, symbolPanel=true),
  iPadNumericPortrait: Numeric.new(device='iPad', isPortrait=true, symbolPanel=true),
  iPadNumericLandscape: Numeric.new(device='iPad', isPortrait=false, symbolPanel=true),
};

// 哪种键盘、哪种设备与方向读哪个文件。
// 缺声明的场景键盘会显示为空白，不会回退，所以四个方向都要给全。
local config = {
  pinyin: {
    iPhone: {
      portrait: 'pinyinPortrait',
      landscape: 'pinyinLandscape',
    },
    iPad: {
      portrait: 'iPadPinyinPortrait',
      landscape: 'iPadPinyinLandscape',
      floating: 'pinyinPortrait',
    },
  },

  // numberPad 与 numeric 两种键盘类型都读这一项
  numeric: {
    iPhone: {
      portrait: 'numericPortrait',
      landscape: 'numericLandscape',
    },
    iPad: {
      portrait: 'iPadNumericPortrait',
      landscape: 'iPadNumericLandscape',
      floating: 'numericPortrait',
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
