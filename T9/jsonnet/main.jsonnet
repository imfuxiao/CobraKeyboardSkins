// 中文九键（T9）皮肤入口：声明产物矩阵与 config.yaml 路由。
//
// 编译：make compile（或在手机上长按皮肤选择「运行 main.jsonnet」）
local Style = import 'Components/Style.libsonnet';
local Alphabetic = import 'Keyboards/Alphabetic.libsonnet';
local Numeric = import 'Keyboards/Numeric.libsonnet';
local Pinyin = import 'Keyboards/Pinyin.libsonnet';

// 产物矩阵：文件名 -> 键盘定义（每份自动生成 light/ 与 dark/ 两份）。
local keyboards = {
  portraitPinyin: Pinyin.new(isPortrait=true),
  landscapePinyin: Pinyin.new(isPortrait=false),
  alphabeticPortrait: Alphabetic.new(isPortrait=true),
  alphabeticLandscape: Alphabetic.new(isPortrait=false),
  portraitNumeric: Numeric.new(isPortrait=true),
  landscapeNumeric: Numeric.new(isPortrait=false),
};

local config = {
  name: '中文九键',
  author: 'Morse',
  pinyin: {
    phone: {
      portrait: 'portraitPinyin',
      landscape: 'landscapePinyin',
    },
  },
  alphabetic: {
    phone: {
      portrait: 'alphabeticPortrait',
      landscape: 'alphabeticLandscape',
    },
  },
  numeric: {
    phone: {
      portrait: 'portraitNumeric',
      landscape: 'landscapeNumeric',
    },
  },
};

{
  'config.yaml': std.manifestYamlDoc(config, indent_array_in_object=true, quote_keys=false),
}
+ {
  // 使用 JSON 序列化（YAML 子集）兼顾手机端实时编译性能，产物与引擎完全等价。
  [scheme + '/' + name + '.yaml']: std.toString(Style.prune(Style.resolve(keyboards[name], scheme == 'dark')))
  for name in std.objectFields(keyboards)
  for scheme in ['light', 'dark']
}
