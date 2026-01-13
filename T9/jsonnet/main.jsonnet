local alphabeticKeyboard = import 'Components/AlphabeticKeyboard.libsonnet';

local alphabeticPortraitFileName = 'alphabeticPortrait';
local alphabeticLightPortraitFileContent = alphabeticKeyboard.new(isDark=false, isPortrait=true);
local alphabeticDarkPortraitFileContent = alphabeticKeyboard.new(isDark=true, isPortrait=true);

local alphabeticLandscapeFileName = 'alphabeticLandscape';
local alphabeticLightLandscapeFileContent = alphabeticKeyboard.new(isDark=false, isPortrait=false);
local alphabeticDarkLandscapeFileContent = alphabeticKeyboard.new(isDark=true, isPortrait=false);


local portraitPinyin = import 'Components/PinyinPortrait.libsonnet';
local portraitPinyinFileName = 'portraitPinyin';
local lightPortraitPinyinFileContent = portraitPinyin.new(isDark=false, isPortrait=true);
local darkPortraitPinyinFileContent = portraitPinyin.new(isDark=true, isPortrait=true);

local landscapePinyin = import 'Components/PinyinLandscape.libsonnet';
local landscapePinyinFileName = 'landscapePinyin';
local lightLandscapePinyinFileContent = landscapePinyin.new(isDark=false, isPortrait=false);
local darkLandscapePinyinFileContent = landscapePinyin.new(isDark=true, isPortrait=true);


local portraitNumeric = import 'Components/NumericPortrait.libsonnet';
local portraitNumericFileName = 'portraitNumeric';
local lightPortraitNumericFileContent = portraitNumeric.new(isDark=false, isPortrait=true);
local darkPortraitNumericFileContent = portraitNumeric.new(isDark=true, isPortrait=true);

local landscapeNumeric = import 'Components/NumericLandscape.libsonnet';
local landscapeNumericFileName = 'landscapeNumeric';
local lightLandscapeNumericFileContent = landscapeNumeric.new(isDark=false, isPortrait=false);
local darkLandscapeNumericFileContent = landscapeNumeric.new(isDark=true, isPortrait=true);

local config = {
  pinyin: {
    iPhone: {
      portrait: portraitPinyinFileName,
      landscape: landscapePinyinFileName,
    },
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
  ['light/' + portraitPinyinFileName + '.yaml']: std.toString(lightPortraitPinyinFileContent),
  ['dark/' + portraitPinyinFileName + '.yaml']: std.toString(darkPortraitPinyinFileContent),
  ['light/' + landscapePinyinFileName + '.yaml']: std.toString(lightLandscapePinyinFileContent),
  ['dark/' + landscapePinyinFileName + '.yaml']: std.toString(darkLandscapePinyinFileContent),
  ['light/' + alphabeticPortraitFileName + '.yaml']: std.toString(alphabeticLightPortraitFileContent),
  ['dark/' + alphabeticPortraitFileName + '.yaml']: std.toString(alphabeticDarkPortraitFileContent),
  ['light/' + alphabeticLandscapeFileName + '.yaml']: std.toString(alphabeticLightLandscapeFileContent),
  ['dark/' + alphabeticLandscapeFileName + '.yaml']: std.toString(alphabeticDarkLandscapeFileContent),
  ['light/' + portraitNumericFileName + '.yaml']: std.toString(lightPortraitNumericFileContent),
  ['dark/' + portraitNumericFileName + '.yaml']: std.toString(darkPortraitNumericFileContent),
  ['light/' + landscapeNumericFileName + '.yaml']: std.toString(lightLandscapeNumericFileContent),
  ['dark/' + landscapeNumericFileName + '.yaml']: std.toString(darkLandscapeNumericFileContent),
}
