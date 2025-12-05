local basicStyle = import '../../Components/BasicStyle.libsonnet';

local newQButton(isDark) = basicStyle.newAlphabeticButton('qButton', isDark, {
  size: { width: 64, height: 64 },
  action: { character: 'q' },
  uppercasedStateAction: { character: 'Q' },
});

{
  lightKeyboardBackgroundStyle: basicStyle.newKeyboardBackgroundStyle(false),
  darkKeyboardBackgroundStyle: basicStyle.newKeyboardBackgroundStyle(true),
  lightButtons: newQButton(false),
  darkButtons: newQButton(true),
}
