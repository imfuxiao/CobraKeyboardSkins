// hamster 皮肤入口——只负责声明「要出哪些文件」，具体内容在 Keyboards/ 下。
// 结构对齐 default / Noctua：Constants 放纯数据，Components 放构造函数，
// Keyboards 组装成具体键盘，这里只是产物矩阵。
//
// 编译：make compile（或在手机上长按皮肤选择「运行 main.jsonnet」）
local Style = import 'Components/Style.libsonnet';
local iPadPinyin = import 'Keyboards/iPadPinyin.libsonnet';
local iPhonePinyin = import 'Keyboards/iPhonePinyin.libsonnet';

// 是否添加分号键（打开后横屏第二行会多一颗键，与 Split 的分体宽度表不匹配，
// 见 Keyboards/iPhonePinyin.libsonnet 文件头注释）
local addSemicolon = false;

// ===== 产物矩阵：文件名 -> 键盘定义 =====
// 目前只出拼音键盘（numeric/symbolic 尚未启用，config.yaml 里对应项保持注释）。
local keyboards = {
  pinyinPortrait: iPhonePinyin.new(isDark=false, isPortrait=true, addSemicolon=addSemicolon),
  pinyinLandscape: iPhonePinyin.new(isDark=false, isPortrait=false, addSemicolon=addSemicolon),

  iPadPinyinPortrait: iPadPinyin.new(isDark=false, isPortrait=true),
  iPadPinyinLandscape: iPadPinyin.new(isDark=false, isPortrait=false),
};

// hamster 的构造函数用 isDark 参数模型（不是 default 那种 {light,dark} 树 + resolve），
// 所以这里对每个键盘各生成一次 isDark=false / isDark=true 两份，而不是调用 Style.resolve。
local darkKeyboards = {
  pinyinPortrait: iPhonePinyin.new(isDark=true, isPortrait=true, addSemicolon=addSemicolon),
  pinyinLandscape: iPhonePinyin.new(isDark=true, isPortrait=false, addSemicolon=addSemicolon),

  iPadPinyinPortrait: iPadPinyin.new(isDark=true, isPortrait=true),
  iPadPinyinLandscape: iPadPinyin.new(isDark=true, isPortrait=false),
};

local config = {
  pinyin: {
    iPhone: { portrait: 'pinyinPortrait', landscape: 'pinyinLandscape' },
    iPad: {
      portrait: 'iPadPinyinPortrait',
      landscape: 'iPadPinyinLandscape',
      floating: 'pinyinPortrait',
    },
  },
  // numeric / symbolic 尚未启用，缺声明时该场景使用内置键盘。
};

{
  'config.yaml': std.manifestYamlDoc(config, indent_array_in_object=true, quote_keys=false),
}
+ {
  // JSON 是 YAML 的子集，用 std.toString 而不是 std.manifestYamlDoc 避免在这个体量下
  // 编译过慢（原代码里的既有取舍，继续沿用）。
  ['light/' + name + '.yaml']: std.toString(Style.prune(keyboards[name]))
  for name in std.objectFields(keyboards)
} + {
  ['dark/' + name + '.yaml']: std.toString(Style.prune(darkKeyboards[name]))
  for name in std.objectFields(darkKeyboards)
}
