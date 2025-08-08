{
  local root = self,

  newStyle(isDark=false, node)::
    if std.type(node) == 'object' then
      local normalColor = if std.objectHas(node, 'normalColor') then
        if std.type(node.normalColor) == 'string' then
          { normalColor: node.normalColor }
        else
          if isDark then
            {
              normalColor: node.normalColor.dark,
            }
          else
            {
              normalColor: node.normalColor.light,
            }
      else
        {};

      local highlightColor = if std.objectHas(node, 'highlightColor') then
        if std.type(node.highlightColor) == 'string' then
          { highlightColor: node.highlightColor }
        else
          if isDark then
            {
              highlightColor: node.highlightColor.dark,
            }
          else
            {
              highlightColor: node.highlightColor.light,
            }
      else
        {};

      local textColor = if std.objectHas(node, 'textColor') then
        if std.type(node.textColor) == 'string' then
          { textColor: node.textColor }
        else
          if isDark then
            {
              textColor: node.textColor.dark,
            }
          else
            {
              textColor: node.textColor.light,
            }
      else
        {};

      local systemImageName = if std.objectHas(node, 'systemImageName') then
        {
          systemImageName: node.systemImageName,
        }
      else
        {};

      local text = if std.objectHas(node, 'text') then
        {
          text: node.text,
        }
      else
        {};

      local cornerRadius = if std.objectHas(node, 'cornerRadius') then
        {
          cornerRadius: node.cornerRadius,
        }
      else
        {};

      local insets = if std.objectHas(node, 'insets') then
        {
          insets: node.insets,
        }
      else
        {};

      local normalLowerEdgeColor = if std.objectHas(node, 'normalLowerEdgeColor') then
        if std.type(node.normalLowerEdgeColor) == 'string' then
          { normalLowerEdgeColor: node.normalLowerEdgeColor }
        else
          if isDark then
            {
              normalLowerEdgeColor: node.normalLowerEdgeColor.dark,
            }
          else
            {
              normalLowerEdgeColor: node.normalLowerEdgeColor.light,
            }
      else
        {};

      local highlightLowerEdgeColor = if std.objectHas(node, 'highlightLowerEdgeColor') then
        if std.type(node.highlightLowerEdgeColor) == 'string' then
          { highlightLowerEdgeColor: node.highlightLowerEdgeColor }
        else
          if isDark then
            {
              highlightLowerEdgeColor: node.highlightLowerEdgeColor.dark,
            }
          else
            {
              highlightLowerEdgeColor: node.highlightLowerEdgeColor.light,
            }
      else
        {};

      local normalImage = if std.objectHas(node, 'normalImage') then
        {
          normalImage: node.normalImage,
        }
      else
        {};

      local highlightImage = if std.objectHas(node, 'highlightImage') then
        {
          highlightImage: node.highlightImage,
        }
      else
        {};

      local fontSize = if std.objectHas(node, 'fontSize') then
        {
          fontSize: node.fontSize,
        }
      else
        {};

      local animation = if std.objectHas(node, 'animation') then
        {
          animation: node.animation,
        }
      else
        {};

      local original = if std.objectHas(node, 'isOriginal') then
        { type: 'original' }
      else
        {};

      local center = if std.objectHas(node, 'center') then
        { center: node.center }
      else
        {};

      local contentMode = if std.objectHas(node, 'contentMode') then
        { contentMode: node.contentMode }
      else
        {};

      local borderColor = if std.objectHas(node, 'borderColor') then
        if std.type(node.borderColor) == 'string' then
          { borderColor: node.borderColor }
        else
          if isDark then
            {
              borderColor: node.borderColor.dark,
            }
          else
            {
              borderColor: node.borderColor.light,
            }
      else
        {};

      local borderSize = if std.objectHas(node, 'borderSize') then
        { borderSize: node.borderSize }
      else
        {};

      normalColor
      + highlightColor
      + textColor
      + systemImageName
      + text
      + cornerRadius
      + insets
      + normalLowerEdgeColor
      + highlightLowerEdgeColor
      + normalImage
      + highlightImage
      + fontSize
      + animation
      + original
      + center
      + contentMode
      + borderColor
      + borderSize
    else {},

  newBackgroundStyle(isDark=false, node, styleKeyName='backgroundStyle')::
    if std.type(node) == 'object' && std.length(node) > 0 then
      local style = root.newStyle(isDark, node);

      local name = std.md5(std.toString(style));

      { internal: { [styleKeyName]: name }, external: { [name]: style } }
    else if std.type(node) == 'string' then
      { internal: { [styleKeyName]: node }, external: {} }
    else
      { internal: {}, external: {} },

  newForegroundStyle(isDark=false, node=[], styleKeyName='foregroundStyle')::
    local reducerArray = function(acc, item)
      local name = std.md5(std.toString(item));
      {
        internal: {
          [styleKeyName]: acc.internal[styleKeyName] + [name],
        },
        external: acc.external { [name]: item },
      };

    if std.type(node) == 'array' && std.length(node) > 0 then
      local stylesArray = std.map(function(item) root.newStyle(isDark, item), node);
      std.foldl(reducerArray, stylesArray, { internal: { [styleKeyName]: [] }, external: {} })
    else if std.type(node) == 'object' && std.length(node) > 0 then
      std.foldl(reducerArray, [root.newStyle(isDark, node)], { internal: { [styleKeyName]: [] }, external: {} })
    else if std.type(node) == 'string' then
      { internal: { [styleKeyName]: node }, external: {} }
    else
      { internal: {}, external: {} },
}
