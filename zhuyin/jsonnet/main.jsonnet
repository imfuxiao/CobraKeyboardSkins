local iPadPinyin = import 'Components/iPadPinyin.libsonnet';
local iPhonePinyin = import 'Components/iPhonePinyin.libsonnet';

local alphabeticKeyboard = import 'Components/AlphabeticKeyboard.libsonnet';

local alphabeticPortraitFileName = 'alphabeticPortrait';
local alphabeticLightPortraitFileContent = alphabeticKeyboard.new(isDark=false, isPortrait=true);
local alphabeticDarkPortraitFileContent = alphabeticKeyboard.new(isDark=true, isPortrait=true);

local alphabeticLandscapeFileName = 'alphabeticLandscape';
local alphabeticLightLandscapeFileContent = alphabeticKeyboard.new(isDark=false, isPortrait=false);
local alphabeticDarkLandscapeFileContent = alphabeticKeyboard.new(isDark=true, isPortrait=false);


local pinyinPortraitFileName = 'pinyinPortrait';
local lightPinyinPortraitFileContent = iPhonePinyin.new(isDark=false, isPortrait=true);
local darkPinyinPortraitFileContent = iPhonePinyin.new(isDark=true, isPortrait=true);
local pinyinLandscapeFileName = 'pinyinLandscape';
local lightPinyinLandscapeFileContent = iPhonePinyin.new(isDark=false, isPortrait=false);
local darkPinyinLandscapeFileContent = iPhonePinyin.new(isDark=true, isPortrait=false);

// local iPadPinyinPortraitName = 'iPadPinyinPortrait';
// local lightIpadPinyinPortraitContent = iPadPinyin.new(isDark=false, isPortrait=true);
// local darkIpadPinyinPortraitContent = iPadPinyin.new(isDark=true, isPortrait=true);

// local iPadPinyinLandscapeName = 'iPadPinyinLandscape';
// local lightIpadPinyinLandscapeContent = iPadPinyin.new(isDark=false, isPortrait=false);
// local darkIpadPinyinLandscapeContent = iPadPinyin.new(isDark=true, isPortrait=false);

local landscapeNumeric = import 'Components/LandscapeNumeric.libsonnet';
local portraitNumeric = import 'Components/PortraitNumeric.libsonnet';

local portraitNumericFileName = 'portraitNumeric';
local lightPortraitNumericFileContent = portraitNumeric.new(isDark=false, isPortrait=true);
local darkPortraitNumericFileContent = portraitNumeric.new(isDark=true, isPortrait=true);

local landscapeNumericFileName = 'landscapeNumeric';
local lightLandscapeNumericFileContent = landscapeNumeric.new(isDark=false, isPortrait=false);
local darkLandscapeNumericFileContent = landscapeNumeric.new(isDark=true, isPortrait=false);


local config = {
  name: '大千注音',
  pinyin: {
    iPhone: {
      portrait: pinyinPortraitFileName,
      landscape: pinyinLandscapeFileName,
    },
    // iPad: {
    //   portrait: iPadPinyinPortraitName,
    //   landscape: iPadPinyinLandscapeName,
    //   floating: pinyinPortraitFileName,
    // },
  },
  alphabetic: {
    iPhone: {
      portrait: alphabeticPortraitFileName,
      landscape: alphabeticLandscapeFileName,
    },
  },
  numeric: {
    iPhone: {
      portrait: portraitNumericFileName,
      landscape: landscapeNumericFileName,
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

  // iPad 拼音键盘
  // ['light/' + iPadPinyinPortraitName + '.yaml']: std.toString(lightIpadPinyinPortraitContent),
  // ['dark/' + iPadPinyinPortraitName + '.yaml']: std.toString(darkIpadPinyinPortraitContent),
  // ['light/' + iPadPinyinLandscapeName + '.yaml']: std.toString(lightIpadPinyinLandscapeContent),
  // ['dark/' + iPadPinyinLandscapeName + '.yaml']: std.toString(darkIpadPinyinLandscapeContent),

  // 字母键盘
  ['light/' + alphabeticPortraitFileName + '.yaml']: std.toString(alphabeticLightPortraitFileContent),
  ['dark/' + alphabeticPortraitFileName + '.yaml']: std.toString(alphabeticDarkPortraitFileContent),
  ['light/' + alphabeticLandscapeFileName + '.yaml']: std.toString(alphabeticLightLandscapeFileContent),
  ['dark/' + alphabeticLandscapeFileName + '.yaml']: std.toString(alphabeticDarkLandscapeFileContent),

  // 数字键盘
  ['light/' + portraitNumericFileName + '.yaml']: std.toString(lightPortraitNumericFileContent),
  ['dark/' + portraitNumericFileName + '.yaml']: std.toString(darkPortraitNumericFileContent),
  ['light/' + landscapeNumericFileName + '.yaml']: std.toString(lightLandscapeNumericFileContent),
  ['dark/' + landscapeNumericFileName + '.yaml']: std.toString(darkLandscapeNumericFileContent),
}
