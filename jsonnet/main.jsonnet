local iPhoneNumeric = import 'Components/iPhoneNumeric.libsonnet';
local iPhonePinyin = import 'Components/iPhonePinyin.libsonnet';
local iPhoneSymbolic = import 'Components/iPhoneSymbolic.libsonnet';
local iPadPinyin = import 'Components/iPadPinyin.libsonnet';
local iPadNumeric = import 'Components/iPadNumeric.libsonnet';

local pinyinPortraitFileName = 'pinyinPortrait';
local lightPinyinPortraitFileContent = iPhonePinyin.new(isDark=false, isPortrait=true);
local darkPinyinPortraitFileContent = iPhonePinyin.new(isDark=true, isPortrait=true);

local pinyinLandscapeFileName = 'pinyinLandscape';
local lightPinyinLandscapeFileContent = iPhonePinyin.new(isDark=false, isPortrait=false);
local darkPinyinLandscapeFileContent = iPhonePinyin.new(isDark=true, isPortrait=false);

local numericPortraitFileName = 'numericPortrait';
local lightNumericPortraitFileContent = iPhoneNumeric.new(isDark=false, isPortrait=true);
local darkNumericPortraitFileContent = iPhoneNumeric.new(isDark=true, isPortrait=true);

local numericLandscapeName = 'numericLandscape';
local lightNumericLandscapeFileContent = iPhoneNumeric.new(isDark=false, isPortrait=false);
local darkNumericLandscapeFileContent = iPhoneNumeric.new(isDark=true, isPortrait=false);

local symbolicPortraitFileName = 'symbolicPortrait';
local lightSymbolicPortraitFileContent = iPhoneSymbolic.new(isDark=false, isPortrait=true);
local darkSymbolicPortraitFileContent = iPhoneSymbolic.new(isDark=true, isPortrait=true);

local symbolicLandscapeName = 'symbolicLandscape';
local lightSymbolicLandscapeFileContent = iPhoneSymbolic.new(isDark=false, isPortrait=false);
local darkSymbolicLandscapeFileContent = iPhoneSymbolic.new(isDark=true, isPortrait=false);

local iPadPinyinPortraitName = 'iPadPinyinPortrait';
local lightIpadPinyinPortraitContent = iPadPinyin.new(isDark=false, isPortrait=true);
local darkIpadPinyinPortraitContent = iPadPinyin.new(isDark=true, isPortrait=true);

local iPadPinyinLandscapeName = 'iPadPinyinLandscape';
local lightIpadPinyinLandscapeContent = iPadPinyin.new(isDark=false, isPortrait=false);
local darkIpadPinyinLandscapeContent = iPadPinyin.new(isDark=true, isPortrait=false);

local iPadNumericPortraitName = 'iPadNumericPortrait';
local lightIpadNumericPortraitContent = iPadNumeric.new(isDark=false, isPortrait=true);
local darkIpadNumericPortraitContent = iPadNumeric.new(isDark=true, isPortrait=true);

local iPadNumericLandscapeName = 'iPadNumericLandscape';
local lightIpadNumericLandscapeContent = iPadNumeric.new(isDark=false, isPortrait=false);
local darkIpadNumericLandscapeContent = iPadNumeric.new(isDark=true, isPortrait=false);

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
    iPad: {
      portrait: iPadNumericPortraitName,
      landscape: iPadNumericLandscapeName,
      floating: numericPortraitFileName,
    },
  },

  // 符号键盘
  symbolic: {
    iPhone: {
      portrait: symbolicPortraitFileName,
      landscape: symbolicLandscapeName,
    },
    iPad: {
      portrait: iPadPinyinPortraitName,
      landscape: iPadPinyinLandscapeName,
      floating: symbolicPortraitFileName,
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

  // iPad 数字键盘
  ['light/' + iPadNumericPortraitName + '.yaml']: std.toString(lightIpadNumericPortraitContent),
  ['dark/' + iPadNumericPortraitName + '.yaml']: std.toString(darkIpadNumericPortraitContent),
  ['light/' + iPadNumericLandscapeName + '.yaml']: std.toString(lightIpadNumericLandscapeContent),
  ['dark/' + iPadNumericLandscapeName + '.yaml']: std.toString(darkIpadNumericLandscapeContent),
}
