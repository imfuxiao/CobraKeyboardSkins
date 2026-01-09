// local landscapePinyin = import 'Components/LandscapePinyin.libsonnet';
local portraitPinyin = import 'Components/PortraitPinyin.libsonnet';
local alphabeticKeyboard = import 'Components/iPhoneAlphabetic.libsonnet';

local portraitPinyinFileName = 'portraitPinyin';
local lightPortraitPinyinFileContent = portraitPinyin.new(isDark=false, isPortrait=true);
local darkPortraitPinyinFileContent = portraitPinyin.new(isDark=true, isPortrait=true);

// local landscapePinyinFileName = 'landscapePinyin';
// local lightLandscapePinyinFileContent = landscapePinyin.new(isDark=false, isPortrait=false);
// local darkLandscapePinyinFileContent = landscapePinyin.new(isDark=true, isPortrait=true);
//
local alphabeticFileName = 'iPhoneAlphabetic';
local lightAlphabeticFileContent = alphabeticKeyboard.new(isDark=false, isPortrait=true);
local darkAlphabeticFileContent = alphabeticKeyboard.new(isDark=true, isPortrait=true);


local config = {
  pinyin: {
    iPhone: {
      portrait: portraitPinyinFileName,
      landscape: portraitPinyinFileName,
    },
  },
  alphabetic: {
    iPhone: {
      portrait: alphabeticFileName,
      landscape: alphabeticFileName,
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
  // ['light/' + landscapePinyinFileName + '.yaml']: std.toString(lightLandscapePinyinFileContent),
  // ['dark/' + landscapePinyinFileName + '.yaml']: std.toString(darkLandscapePinyinFileContent),
  ['light/' + alphabeticFileName + '.yaml']: std.toString(lightAlphabeticFileContent),
  ['dark/' + alphabeticFileName + '.yaml']: std.toString(darkAlphabeticFileContent),
}
