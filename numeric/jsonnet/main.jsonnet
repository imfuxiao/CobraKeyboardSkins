local landscapeNumeric = import 'Components/LandscapeNumeric.libsonnet';
local portraitNumeric = import 'Components/PortraitNumeric.libsonnet';

local portraitNumericFileName = 'portraitNumeric';
local lightPortraitNumericFileContent = portraitNumeric.new(isDark=false, isPortrait=true);
local darkPortraitNumericFileContent = portraitNumeric.new(isDark=true, isPortrait=true);

local landscapeNumericFileName = 'landscapeNumeric';
local lightLandscapeNumericFileContent = landscapeNumeric.new(isDark=false, isPortrait=false);
local darkLandscapeNumericFileContent = landscapeNumeric.new(isDark=true, isPortrait=false);


local config = {
  pinyin: {
    iPhone: {
      portrait: portraitNumericFileName,
      landscape: landscapeNumericFileName,
    },
    iPad: {
      portrait: landscapeNumericFileName,
      landscape: landscapeNumericFileName,
      floating: portraitNumericFileName,
    },
  },
};

{
  'config.yaml': std.manifestYamlDoc(config, indent_array_in_object=true, quote_keys=false),

  // 拼音键盘
  // TODO: 这里用 std.toString 代替 std.manifestYamlDoc 是为了避免 jsonnet 在处理非常大的内容时耗时太严重
  // 在 PC 上调试的时候可以使用，方便排查问题
  // ['light/' + pinyinPortraitFileName + '.yaml']: std.manifestYamlDoc(lightPinyinPortraitFileContent, indent_array_in_object=false, quote_keys=false),
  ['light/' + portraitNumericFileName + '.yaml']: std.toString(lightPortraitNumericFileContent),
  ['dark/' + portraitNumericFileName + '.yaml']: std.toString(darkPortraitNumericFileContent),
  ['light/' + landscapeNumericFileName + '.yaml']: std.toString(lightLandscapeNumericFileContent),
  ['dark/' + landscapeNumericFileName + '.yaml']: std.toString(darkLandscapeNumericFileContent),
}
