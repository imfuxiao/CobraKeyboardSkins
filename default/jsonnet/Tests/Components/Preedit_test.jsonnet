local preedit = import '../../Components/Preedit.libsonnet';

local lightPreedit = preedit.newPreedit(false);
local darkPreedit = preedit.newPreedit(true);

{
  lightPreedit: lightPreedit,
  darkPreedit: darkPreedit,
}
