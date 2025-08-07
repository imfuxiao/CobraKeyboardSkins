local PinyinPortraitLayout = import 'Components/PinyinPortraitLayout.libsonnet';

local pinyinPortraitFileName = 'PinyinPortrait';
local darkPinyinPortraitFileContent = std.manifestYamlDoc(PinyinPortraitLayout.new(isDark=true), indent_array_in_object=true, quote_keys=false);
local lightPinyinPortraitFileContent = std.manifestYamlDoc(PinyinPortraitLayout.new(isDark=false), indent_array_in_object=true, quote_keys=false);

local config = {
  pinyin: {
    iPhone: {
      portrait: pinyinPortraitFileName,
      landscape: pinyinPortraitFileName,
    },
    iPad: {
    },
  },
};

{
  'config.yaml': std.manifestYamlDoc(config, indent_array_in_object=true, quote_keys=false),
  ['dark/' + pinyinPortraitFileName + '.yaml']: darkPinyinPortraitFileContent,
  ['light/' + pinyinPortraitFileName + '.yaml']: lightPinyinPortraitFileContent,
}
