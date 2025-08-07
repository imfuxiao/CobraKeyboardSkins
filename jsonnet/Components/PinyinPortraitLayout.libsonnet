local Keyboard = import '../Variables/Keyboard.libsonnet';
local Preedit = import 'Preedit.libsonnet';
local Toolbar = import 'Toolbar.libsonnet';
local Utils = import 'Utils.libsonnet';


local buttonAnimation = if std.objectHas(Keyboard, 'buttonAnimation') then
  local animation = Keyboard.buttonAnimation;
  local name = std.get(animation, 'name', default='buttonAnimation');
  {
    [name]: std.get(animation, 'animations', default=[]),
  }
else
  {};


local createButtonName = function(button)
  std.md5(std.toString(button));

local createButtonNode = function(isDark=false, button, name)
  local buttonSize = { size: std.get(button, 'size', default={}) };
  local buttonBounds = if std.objectHas(button, 'bounds') then { bounds: std.get(button, 'bounds', default={}) } else {};
  local backgroundStyle = Utils.newBackgroundStyle(isDark, std.get(button, 'backgroundStyle', default={}));
  local foregroundStyle = Utils.newForegroundStyle(isDark, std.get(button, 'foregroundStyle', default={}));

  local uppercasedStateForegroundStyle = Utils.newForegroundStyle(isDark, std.get(button, 'uppercasedStateForegroundStyle', default={}), 'uppercasedStateForegroundStyle');
  local capsLockedStateForegroundStyle = Utils.newForegroundStyle(isDark, std.get(button, 'capsLockedStateForegroundStyle', default={}), 'capsLockedStateForegroundStyle');

  // HintStyle
  local hintStyle = if std.objectHas(button, 'hintStyle') then
    local node = std.get(button, 'hintStyle', default={});
    local size = if std.objectHas(node, 'size') then
      { size: node.size }
    else
      {};
    local backgroundStyle = Utils.newBackgroundStyle(isDark, std.get(node, 'backgroundStyle', default={}));
    local foregroundStyle = Utils.newForegroundStyle(isDark, std.get(node, 'foregroundStyle', default={}));
    local swipeUpForegroundStyle = Utils.newForegroundStyle(isDark, std.get(node, 'swipeUpForegroundStyle', default={}), 'swipeUpForegroundStyle');
    {
      internal: {
        hintStyle: name + '_hintStyle',
      },
      external:
        {
          [name + '_hintStyle']:
            size
            + backgroundStyle.internal
            + foregroundStyle.internal
            + swipeUpForegroundStyle.internal,
        }
        + backgroundStyle.external
        + foregroundStyle.external
        + swipeUpForegroundStyle.external,
    }
  else
    { internal: {}, external: {} };

  // HintSymbolsStyle
  local hintSymbolsStyle = if std.objectHas(button, 'hintSymbolsStyle') then
    local node = std.get(button, 'hintSymbolsStyle', default={});
    local size = if std.objectHas(node, 'size') then
      { size: node.size }
    else
      {};
    local insets = if std.objectHas(node, 'insets') then
      { insets: node.insets }
    else
      {};

    local selectedIndex = if std.objectHas(node, 'selectedIndex') then
      { selectedIndex: node.selectedIndex }
    else
      {};

    local backgroundStyle = Utils.newBackgroundStyle(isDark, std.get(node, 'backgroundStyle', default={}));

    // 生成单个符号按键样式
    local createSymbolStyle = function(symbol)
      local name = std.md5(std.toString(symbol));

      local action = if std.objectHas(symbol, 'action') then
        { action: std.get(symbol, 'action', default={}) }
      else
        {};

      local symbolBackgroundStyle = Utils.newBackgroundStyle(isDark, std.get(symbol, 'backgroundStyle', default={}));
      local symbolForegroundStyle = Utils.newForegroundStyle(isDark, std.get(symbol, 'foregroundStyle', default={}, inc_hidden=true));
      {
        name: name,
        external: {
          [name]: action + symbolBackgroundStyle.internal + symbolForegroundStyle.internal,
        } + symbolBackgroundStyle.external + symbolForegroundStyle.external,
      };

    local _symbolsStyles = std.map(createSymbolStyle, std.get(node, 'symbolsStyle', default=[]));

    local symbolsStyle = std.foldl(function(acc, item) {
      internal: {
        symbolsStyle: acc.internal.symbolsStyle + [item.name],
      },
      external: acc.external + item.external,
    }, _symbolsStyles, { internal: { symbolsStyle: [] }, external: {} });

    {
      internal: {
        hintSymbolsStyle: name + '_hintSymbolsStyle',
      },
      external:
        {
          [name + '_hintSymbolsStyle']:
            size
            + insets
            + selectedIndex
            + backgroundStyle.internal
            + symbolsStyle.internal,
        }
        + backgroundStyle.external
        + symbolsStyle.external,
    }
  else
    { internal: {}, external: {} };

  {
    [name]:
      button.actions
      + buttonSize
      + buttonBounds
      + backgroundStyle.internal
      + foregroundStyle.internal
      + uppercasedStateForegroundStyle.internal
      + capsLockedStateForegroundStyle.internal
      + hintStyle.internal
      + hintSymbolsStyle.internal,
  }
  + backgroundStyle.external
  + foregroundStyle.external
  + uppercasedStateForegroundStyle.external
  + capsLockedStateForegroundStyle.external
  + hintStyle.external
  + hintSymbolsStyle.external;


// - 按键区域定义

local basicSize = {
  size: {
    width: '1/10',
  },
};
local qButton = Keyboard.buttons.q + basicSize;
local wButton = Keyboard.buttons.w + basicSize;
local eButton = Keyboard.buttons.e + basicSize;
local rButton = Keyboard.buttons.r + basicSize;
local tButton = Keyboard.buttons.t + basicSize;
local yButton = Keyboard.buttons.y + basicSize;
local uButton = Keyboard.buttons.u + basicSize;
local iButton = Keyboard.buttons.i + basicSize;
local oButton = Keyboard.buttons.o + basicSize;
local pButton = Keyboard.buttons.p + basicSize;

local aButton = Keyboard.buttons.a {
  size: {
    width: '1.5/10',
  },
  bounds: {
    width: '2/3',
    alignment: 'right',
  },
};
local sButton = Keyboard.buttons.s + basicSize;
local dButton = Keyboard.buttons.d + basicSize;
local fButton = Keyboard.buttons.f + basicSize;
local gButton = Keyboard.buttons.g + basicSize;
local hButton = Keyboard.buttons.h + basicSize;
local jButton = Keyboard.buttons.j + basicSize;
local kButton = Keyboard.buttons.k + basicSize;
local lButton = Keyboard.buttons.l {
  size: {
    width: '1.5/10',
  },
  bounds: {
    width: '2/3',
    alignment: 'left',
  },
};

local shiftButton = Keyboard.buttons.shift {
  size: {
    width: '1.5/10',
  },
  bounds: {
    width: '79/100',
    alignment: 'left',
  },
};
local zButton = Keyboard.buttons.z + basicSize;
local xButton = Keyboard.buttons.x + basicSize;
local cButton = Keyboard.buttons.c + basicSize;
local vButton = Keyboard.buttons.v + basicSize;
local bButton = Keyboard.buttons.b + basicSize;
local nButton = Keyboard.buttons.n + basicSize;
local mButton = Keyboard.buttons.m + basicSize;
local backspaceButton = Keyboard.buttons.backspace {
  size: {
    width: '1.5/10',
  },
  bounds: {
    width: '79/100',
    alignment: 'right',
  },
};

local numericButton = Keyboard.buttons.numeric {
  size: {
    width: '1.25/10',
  },
};

local emojisButton = Keyboard.buttons.emojis {
  size: {
    width: '1.25/10',
  },
};

local spaceButton = Keyboard.buttons.space {
  size: {
    width: '5/10',
  },
};

local enterButton = Keyboard.buttons.enter {
  size: {
    width: '2.5/10',
  },
};

local qButtonName = createButtonName(qButton);
local wButtonName = createButtonName(wButton);
local eButtonName = createButtonName(eButton);
local rButtonName = createButtonName(rButton);
local tButtonName = createButtonName(tButton);
local yButtonName = createButtonName(yButton);
local uButtonName = createButtonName(uButton);
local iButtonName = createButtonName(iButton);
local oButtonName = createButtonName(oButton);
local pButtonName = createButtonName(pButton);

local aButtonName = createButtonName(aButton);
local sButtonName = createButtonName(sButton);
local dButtonName = createButtonName(dButton);
local fButtonName = createButtonName(fButton);
local gButtonName = createButtonName(gButton);
local hButtonName = createButtonName(hButton);
local jButtonName = createButtonName(jButton);
local kButtonName = createButtonName(kButton);
local lButtonName = createButtonName(lButton);

local shiftButtonName = createButtonName(shiftButton);
local zButtonName = createButtonName(zButton);
local xButtonName = createButtonName(xButton);
local cButtonName = createButtonName(cButton);
local vButtonName = createButtonName(vButton);
local bButtonName = createButtonName(bButton);
local nButtonName = createButtonName(nButton);
local mButtonName = createButtonName(mButton);
local backspaceButtonName = createButtonName(backspaceButton);

local numericButtonName = createButtonName(numericButton);
local emojisButtonName = createButtonName(emojisButton);
local spaceButtonName = createButtonName(spaceButton);
local enterButtonName = createButtonName(enterButton);

// 键盘布局
local keyboardLayout = {
  keyboardLayout: [
    {
      HStack: {
        subviews: [
          {
            Cell: qButtonName,
          },
          {
            Cell: wButtonName,
          },
          {
            Cell: eButtonName,
          },
          {
            Cell: rButtonName,
          },
          {
            Cell: tButtonName,
          },
          {
            Cell: yButtonName,
          },
          {
            Cell: uButtonName,
          },
          {
            Cell: iButtonName,
          },
          {
            Cell: oButtonName,
          },
          {
            Cell: pButtonName,
          },
        ],
      },
    },
    {
      HStack: {
        subviews: [
          {
            Cell: aButtonName,
          },
          {
            Cell: sButtonName,
          },
          {
            Cell: dButtonName,
          },
          {
            Cell: fButtonName,
          },
          {
            Cell: gButtonName,
          },
          {
            Cell: hButtonName,
          },
          {
            Cell: jButtonName,
          },
          {
            Cell: kButtonName,
          },
          {
            Cell: lButtonName,
          },
        ],
      },
    },
    {
      HStack: {
        subviews: [
          {
            Cell: shiftButtonName,
          },
          {
            Cell: zButtonName,
          },
          {
            Cell: xButtonName,
          },
          {
            Cell: cButtonName,
          },
          {
            Cell: vButtonName,
          },
          {
            Cell: bButtonName,
          },
          {
            Cell: nButtonName,
          },
          {
            Cell: mButtonName,
          },
          {
            Cell: backspaceButtonName,
          },
        ],
      },
    },
    {
      HStack: {
        subviews: [
          {
            Cell: numericButtonName,
          },
          {
            Cell: emojisButtonName,
          },
          {
            Cell: spaceButtonName,
          },
          {
            Cell: enterButtonName,
          },
        ],
      },
    },
  ],
};

{
  new(isDark=false)::

    local alphabeticButtonBackgroundStyle = if std.objectHas(Keyboard, 'alphabeticButtonBackgroundStyle') then
      {
        alphabeticButtonBackgroundStyle: Utils.newStyle(isDark, Keyboard.alphabeticButtonBackgroundStyle),
      }
    else
      {};

    local systemButtonBackgroundStyle = if std.objectHas(Keyboard, 'systemButtonBackgroundStyle') then
      {
        systemButtonBackgroundStyle: Utils.newStyle(isDark, Keyboard.systemButtonBackgroundStyle),
      }
    else
      {};


    local hintBackgroundStyle = if std.objectHas(Keyboard, 'hintBackgroundStyle') then
      {
        hintBackgroundStyle: Utils.newStyle(isDark, Keyboard.hintBackgroundStyle),
      }
    else
      {};

    local hintSymbolSelectedBackgroundStyle = if std.objectHas(Keyboard, 'hintSymbolSelectedBackgroundStyle') then
      {
        hintSymbolSelectedBackgroundStyle: Utils.newStyle(isDark, Keyboard.hintSymbolSelectedBackgroundStyle),
      }
    else
      {};

    local keyboardBackgroundStyle = Utils.newBackgroundStyle(isDark, Keyboard.backgroundStyle);


    Preedit.new(isDark)
    + Toolbar.new(isDark)
    + {
      keyboardHeight: Keyboard.height,
    }
    + alphabeticButtonBackgroundStyle
    + systemButtonBackgroundStyle
    + hintBackgroundStyle
    + hintSymbolSelectedBackgroundStyle
    + buttonAnimation
    + keyboardLayout
    + {
      keyboardStyle: {

      } + keyboardBackgroundStyle.internal,
    }
    + keyboardBackgroundStyle.external
    + createButtonNode(isDark, qButton, qButtonName)
    + createButtonNode(isDark, wButton, wButtonName)
    + createButtonNode(isDark, eButton, eButtonName)
    + createButtonNode(isDark, rButton, rButtonName)
    + createButtonNode(isDark, tButton, tButtonName)
    + createButtonNode(isDark, yButton, yButtonName)
    + createButtonNode(isDark, uButton, uButtonName)
    + createButtonNode(isDark, iButton, iButtonName)
    + createButtonNode(isDark, oButton, oButtonName)
    + createButtonNode(isDark, pButton, pButtonName)
    + createButtonNode(isDark, aButton, aButtonName)
    + createButtonNode(isDark, sButton, sButtonName)
    + createButtonNode(isDark, dButton, dButtonName)
    + createButtonNode(isDark, fButton, fButtonName)
    + createButtonNode(isDark, gButton, gButtonName)
    + createButtonNode(isDark, hButton, hButtonName)
    + createButtonNode(isDark, jButton, jButtonName)
    + createButtonNode(isDark, kButton, kButtonName)
    + createButtonNode(isDark, lButton, lButtonName)
    + createButtonNode(isDark, shiftButton, shiftButtonName)
    + createButtonNode(isDark, zButton, zButtonName)
    + createButtonNode(isDark, xButton, xButtonName)
    + createButtonNode(isDark, cButton, cButtonName)
    + createButtonNode(isDark, vButton, vButtonName)
    + createButtonNode(isDark, bButton, bButtonName)
    + createButtonNode(isDark, nButton, nButtonName)
    + createButtonNode(isDark, mButton, mButtonName)
    + createButtonNode(isDark, backspaceButton, backspaceButtonName)
    + createButtonNode(isDark, numericButton, numericButtonName)
    + createButtonNode(isDark, emojisButton, emojisButtonName)
    + createButtonNode(isDark, spaceButton, spaceButtonName)
    + createButtonNode(isDark, enterButton, enterButtonName),
}
