local keyboardLayout26KeysPortrait = import 'Components/KeyboardLayout26KeysPortrait.libsonnet';

local pinyinPortraitFileName = 'pinyinPortrait';
local lightPinyinPortraitFileContent = keyboardLayout26KeysPortrait.new(isDark=false);
local darkPinyinPortraitFileContent = keyboardLayout26KeysPortrait.new(isDark=true);

local config = {
  pinyin: {
    iPhone: {
      portrait: pinyinPortraitFileName,
      landscape: pinyinPortraitFileName,
    },
  },
};

{
  'config.yaml': std.manifestYamlDoc(config, indent_array_in_object=true, quote_keys=false),
  // TODO: 这里用 std.toString 代替 std.manifestYamlDoc 是为了避免 jsonnet 在处理非常大的内容时耗时太严重
  // 在 PC 上调试的时候可以使用，方便排查问题
  ['light/' + pinyinPortraitFileName + '.yaml']: std.manifestYamlDoc(lightPinyinPortraitFileContent, indent_array_in_object=false, quote_keys=false),
  // ['light/' + pinyinPortraitFileName + '.yaml']: std.toString(lightPinyinPortraitFileContent),
  ['dark/' + pinyinPortraitFileName + '.yaml']: std.toString(darkPinyinPortraitFileContent),
}
