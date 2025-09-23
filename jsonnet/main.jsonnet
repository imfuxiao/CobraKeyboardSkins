local PinyinLandscape = import 'Components/PinyinLandscape.libsonnet';
local PinyinPortrait = import 'Components/PinyinPortrait.libsonnet';

local NumericLandscape = import 'Components/NumericLandscape.libsonnet';
local NumericPortrait = import 'Components/NumericPortrait.libsonnet';

local SymbolicLandscape = import 'Components/SymbolicLandscape.libsonnet';
local SymbolicPortrait = import 'Components/SymbolicPortrait.libsonnet';

local iPadPinyin = import 'Components/iPadPinyin.libsonnet';

local pinyinPortraitFileName = 'pinyinPortrait';
local lightPinyinPortraitFileContent = PinyinPortrait.new(isDark=false);
local darkPinyinPortraitFileContent = PinyinPortrait.new(isDark=true);

local pinyinLandscapeFileName = 'pinyinLandscape';
local lightPinyinLandscapeFileContent = PinyinLandscape.new(isDark=false);
local darkPinyinLandscapeFileContent = PinyinLandscape.new(isDark=true);

local numericPortraitFileName = 'numericPortrait';
local lightNumericPortraitFileContent = NumericPortrait.new(isDark=false);
local darkNumericPortraitFileContent = NumericPortrait.new(isDark=true);

local numericLandscapeName = 'numericLandscape';
local lightNumericLandscapeFileContent = NumericLandscape.new(isDark=false);
local darkNumericLandscapeFileContent = NumericLandscape.new(isDark=true);

local symbolicPortraitFileName = 'symbolicPortrait';
local lightSymbolicPortraitFileContent = SymbolicPortrait.new(isDark=false);
local darkSymbolicPortraitFileContent = SymbolicPortrait.new(isDark=true);

local symbolicLandscapeName = 'symbolicLandscape';
local lightSymbolicLandscapeFileContent = SymbolicLandscape.new(isDark=false);
local darkSymbolicLandscapeFileContent = SymbolicLandscape.new(isDark=true);

local iPadPinyinPortraitName = 'iPadPinyinPortrait';
local lightIpadPinyinPortraitContent = iPadPinyin.new(isDark=false, isPortrait=true);
local darkIpadPinyinPortraitContent = iPadPinyin.new(isDark=true, isPortrait=true);

local iPadPinyinLandscapeName = 'iPadPinyinLandscape';
local lightIpadPinyinLandscapeContent = iPadPinyin.new(isDark=false, isPortrait=false);
local darkIpadPinyinLandscapeContent = iPadPinyin.new(isDark=true, isPortrait=false);

local config = {
  pinyin: {
    iPhone: {
      portrait: pinyinPortraitFileName,
      landscape: pinyinLandscapeFileName,
    },
    iPad: {
      portrait: iPadPinyinPortraitName,
      landscape: iPadPinyinLandscapeName,
      floating: pinyinPortraitFileName,
    },
  },
  numeric: {
    iPhone: {
      portrait: numericPortraitFileName,
      landscape: numericLandscapeName,
    },
  },

  // 符号键盘
  symbolic: {
    iPhone: {
      portrait: symbolicPortraitFileName,
      landscape: symbolicLandscapeName,
    },
  },
};

{
  'config.yaml': std.manifestYamlDoc(config, indent_array_in_object=true, quote_keys=false),

  // 拼音键盘
  // TODO: 这里用 std.toString 代替 std.manifestYamlDoc 是为了避免 jsonnet 在处理非常大的内容时耗时太严重
  // 在 PC 上调试的时候可以使用，方便排查问题
  // ['light/' + pinyinPortraitFileName + '.yaml']: std.manifestYamlDoc(lightPinyinPortraitFileContent, indent_array_in_object=false, quote_keys=false),
  ['light/' + pinyinPortraitFileName + '.yaml']: std.toString(lightPinyinPortraitFileContent),
  ['dark/' + pinyinPortraitFileName + '.yaml']: std.toString(darkPinyinPortraitFileContent),
  ['light/' + pinyinLandscapeFileName + '.yaml']: std.toString(lightPinyinLandscapeFileContent),
  ['dark/' + pinyinLandscapeFileName + '.yaml']: std.toString(darkPinyinLandscapeFileContent),

  // 数字键盘
  // ['light/' + numericPortraitFileName + '.yaml']: std.manifestYamlDoc(lightNumericPortraitFileContent, indent_array_in_object=false, quote_keys=false),
  ['light/' + numericPortraitFileName + '.yaml']: std.toString(lightNumericPortraitFileContent),
  ['dark/' + numericPortraitFileName + '.yaml']: std.toString(darkNumericPortraitFileContent),
  ['light/' + numericLandscapeName + '.yaml']: std.toString(lightNumericLandscapeFileContent),
  ['dark/' + numericLandscapeName + '.yaml']: std.toString(darkNumericLandscapeFileContent),

  // 符号键盘
  ['light/' + symbolicPortraitFileName + '.yaml']: std.toString(lightSymbolicPortraitFileContent),
  ['dark/' + symbolicPortraitFileName + '.yaml']: std.toString(darkSymbolicPortraitFileContent),
  ['light/' + symbolicLandscapeName + '.yaml']: std.toString(lightSymbolicLandscapeFileContent),
  ['dark/' + symbolicLandscapeName + '.yaml']: std.toString(darkSymbolicLandscapeFileContent),

  // iPad 拼音键盘
  ['light/' + iPadPinyinPortraitName + '.yaml']: std.toString(lightIpadPinyinPortraitContent),
  ['dark/' + iPadPinyinPortraitName + '.yaml']: std.toString(darkIpadPinyinPortraitContent),
  ['light/' + iPadPinyinLandscapeName + '.yaml']: std.toString(lightIpadPinyinLandscapeContent),
  ['dark/' + iPadPinyinLandscapeName + '.yaml']: std.toString(darkIpadPinyinLandscapeContent),
}
