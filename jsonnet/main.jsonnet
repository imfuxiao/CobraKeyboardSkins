local NumericPortrait = import 'Components/NumericPortrait.libsonnet';
local PinyinPortrait = import 'Components/PinyinPortrait.libsonnet';
local SymbolicPortrait = import 'Components/SymbolicPortrait.libsonnet';

local pinyinPortraitFileName = 'pinyinPortrait';
local lightPinyinPortraitFileContent = PinyinPortrait.new(isDark=false);
local darkPinyinPortraitFileContent = PinyinPortrait.new(isDark=true);

local numericPortraitFileName = 'numericPortrait';
local lightNumericPortraitFileContent = NumericPortrait.new(isDark=false);
local darkNumericPortraitFileContent = NumericPortrait.new(isDark=true);

local symbolicPortraitFileName = 'symbolicPortrait';
local lightSymbolicPortraitFileContent = SymbolicPortrait.new(isDark=false);
local darkSymbolicPortraitFileContent = SymbolicPortrait.new(isDark=true);

local config = {
  pinyin: {
    iPhone: {
      portrait: pinyinPortraitFileName,
      landscape: pinyinPortraitFileName,
    },
  },
  numeric: {
    iPhone: {
      portrait: numericPortraitFileName,
      landscape: numericPortraitFileName,
    },
    // iPad: {
    //   portrait: iPad_numeric_26_portrait,
    //   landscape: iPad_numeric_26_landscape,
    //   floating: numeric_9_portrait,
    // },
  },

  // 符号键盘
  symbolic: {
    iPhone: {
      portrait: symbolicPortraitFileName,
      landscape: symbolicPortraitFileName,
    },
    // iPad: {
    //   portrait: iPad_symbolic_portrait,
    //   landscape: iPad_symbolic_landscape,
    //   floating: iPad_symbolic_float,
    // },
  },
};

{
  'config.yaml': std.manifestYamlDoc(config, indent_array_in_object=true, quote_keys=false),
  // TODO: 这里用 std.toString 代替 std.manifestYamlDoc 是为了避免 jsonnet 在处理非常大的内容时耗时太严重
  // 在 PC 上调试的时候可以使用，方便排查问题
  // ['light/' + pinyinPortraitFileName + '.yaml']: std.manifestYamlDoc(lightPinyinPortraitFileContent, indent_array_in_object=false, quote_keys=false),
  ['light/' + pinyinPortraitFileName + '.yaml']: std.toString(lightPinyinPortraitFileContent),
  ['dark/' + pinyinPortraitFileName + '.yaml']: std.toString(darkPinyinPortraitFileContent),
  // ['light/' + numericPortraitFileName + '.yaml']: std.manifestYamlDoc(lightNumericPortraitFileContent, indent_array_in_object=false, quote_keys=false),
  ['light/' + numericPortraitFileName + '.yaml']: std.toString(lightNumericPortraitFileContent),
  ['dark/' + numericPortraitFileName + '.yaml']: std.toString(darkNumericPortraitFileContent),
  ['light/' + symbolicPortraitFileName + '.yaml']: std.toString(lightSymbolicPortraitFileContent),
  ['dark/' + symbolicPortraitFileName + '.yaml']: std.toString(darkSymbolicPortraitFileContent),
}
