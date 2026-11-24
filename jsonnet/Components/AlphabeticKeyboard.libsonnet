local fonts = import '../Constants/Fonts.libsonnet';
local params = import '../Constants/Keyboard.libsonnet';
local basicStyle = import 'BasicStyle.libsonnet';
local preedit = import 'Preedit.libsonnet';
local toolbar = import 'Toolbar.libsonnet';
local t9Keyboard = import 'T9Keyboard.libsonnet';
local utils = import 'Utils.libsonnet';


// 26 键英文输入直接上屏，不经过 preedit；监听实际发出的字母（含大写）和句号动作。
local alphabeticKeyboardActionSymbols = {
  a: 'a', b: 'b', c: 'c', d: 'd', e: 'e', f: 'f', g: 'g',
  h: 'h', i: 'i', j: 'j', k: 'k', l: 'l', m: 'm', n: 'n',
  o: 'o', p: 'p', q: 'q', r: 'r', s: 's', t: 't', u: 'u',
  v: 'v', w: 'w', x: 'x', y: 'y', z: 'z',
  A: 'A', B: 'B', C: 'C', D: 'D', E: 'E', F: 'F', G: 'G',
  H: 'H', I: 'I', J: 'J', K: 'K', L: 'L', M: 'M', N: 'N',
  O: 'O', P: 'P', Q: 'Q', R: 'R', S: 'S', T: 'T', U: 'U',
  V: 'V', W: 'W', X: 'X', Y: 'Y', Z: 'Z',
  period: '.',
};

local alphabeticKeyboardActionNotificationNames = [
  'alphabeticKeyboardAction' + name
  for name in std.objectFields(alphabeticKeyboardActionSymbols)
];

// 蓝色态回车文字写法：
//  'variable'  ：直接使用一个白字样式，text 为 $returnKeyType（keyboardAction 通知里可正常取到
//                回车类型）。不再为每个字母通知重复写 12 条条件样式，浅色 26 键文件约减半，
//                与 T9 之间互相切换更灵敏。
//  'conditions'：原写法，每个通知都带 12 条 $returnKeyType 条件样式。
// 注：T9 的 preeditChanged 通知里取不到回车类型，T9 仍使用条件样式，不受此开关影响。
// 注：不要用 // JavaScript getText() 写在通知的 foregroundStyle 里，实测不生效（文字消失）。
local enterBlueForegroundMode = 'variable';
local alphabeticEnterBlueTextStyleName = 'alphabeticEnterBlueTextStyle';

local alphabeticEnterBlueForegroundStyle =
  if enterBlueForegroundMode == 'variable'
  then alphabeticEnterBlueTextStyleName
  else basicStyle.t9ConfirmBlueForegroundStyleConditions;

local alphabeticKeyboardActionNotifications = {
  ['alphabeticKeyboardAction' + name]: {
    notificationType: 'keyboardAction',
    notificationKeyboardAction: { symbol: alphabeticKeyboardActionSymbols[name] },
    lockedNotificationMatchState: true,
    backgroundStyle: basicStyle.blueButtonBackgroundStyleName,
    foregroundStyle: alphabeticEnterBlueForegroundStyle,
  }
  for name in std.objectFields(alphabeticKeyboardActionSymbols)
};

local newAlphabeticEnterBlueTextStyles(isDark=false) =
  if enterBlueForegroundMode == 'variable' then
    {
      [alphabeticEnterBlueTextStyleName]: basicStyle.newT9ConfirmBlueTextStyles(isDark)[basicStyle.t9ConfirmBlueTextStylePrefix + '0'] {
        text: '$returnKeyType',
      },
    }
  else
    basicStyle.newT9ConfirmBlueTextStyles(isDark);

local hintStyle = {
  hintStyle: {
    size: { width: 50, height: 50 },
  },
};

local topBadgeLabelUpParams = {
  center: {
    y: 0.2,
  },
  fontSize: fonts.iPhone.button.doubleLabelSmallFontSize,
};

local leftBadgeLabelUpParams = {
  center: {
    x: 0.25,
    y: 0.2,
  },
  fontSize: fonts.iPhone.button.doubleLabelSmallFontSize,
};

local rightBadgeLabelUpParams = {
  center: {
    x: 0.75,
    y: 0.2,
  },
  fontSize: fonts.iPhone.button.doubleLabelSmallFontSize,
};

local createSwipeUpHintStyle(isDark, params={}) = {
  [params.name + 'SwipeUpHintForegroundStyle']:
    basicStyle.newAlphabeticButtonHintStyle(isDark) + basicStyle.getKeyboardActionText(params.params),
};

local createSwipeDownHintStyle(isDark, params={}) = {
  [params.name + 'SwipeDownHintForegroundStyle']:
    basicStyle.newAlphabeticButtonHintStyle(isDark) + basicStyle.getKeyboardActionText(params.params),
};

local createButtonForegroundStyle(isDark, params={}) = {
  [params.name + 'ForegroundStyle']:
    basicStyle.newAlphabeticButtonForegroundStyle(isDark, params.params),
};

local createTopBadgeForegroundStyle(isDark, params={}) = {
  [params.name + 'BadgeForegroundStyle']:
    basicStyle.newAlphabeticButtonSwipeForegroundStyle(isDark, params.params + topBadgeLabelUpParams),
};

local createLeftTopBadgeForegroundStyle(isDark, params={}) = {
  [params.name + 'BadgeForegroundStyle']:
    basicStyle.newAlphabeticButtonSwipeForegroundStyle(isDark, params.params + leftBadgeLabelUpParams),
};

local createRightTopBadgeForegroundStyle(isDark, params={}) = {
  [params.name + 'BadgeForegroundStyle']:
    basicStyle.newAlphabeticButtonSwipeForegroundStyle(isDark, params.params + rightBadgeLabelUpParams),
};

// ---- 上滑角标 / 下滑提示 ----
// 角标文字直接取自按键定义里的 swipeUpAction / swipeDownAction；
// 快捷指令（剪切、复制…）没有可显示的字符，用 swipeUpText / swipeDownText 指定文字，
// 也可用 swipeDownSystemImageName 显示 SF Symbols 图标。
local bottomBadgeLabelDownParams = {
  center: {
    y: 0.8,
  },
  fontSize: fonts.iPhone.button.doubleLabelSmallFontSize,
};

// 动作对应的可输入字符；快捷指令、tab 等返回空串
local swipeActionText(action) =
  if std.type(action) == 'object' && std.objectHas(action, 'symbol') then action.symbol
  else if std.type(action) == 'object' && std.objectHas(action, 'character') then action.character
  else '';

local swipeLabelText(p, actionKey, textKey) =
  if std.objectHas(p, textKey) then p[textKey]
  else if std.objectHas(p, actionKey) then swipeActionText(p[actionKey])
  else '';

local newSwipeLetterButton(isDark, button, extraParams={}) =
  local p = button.params;
  local name = button.name;
  local upText = swipeLabelText(p, 'swipeUpAction', 'swipeUpText');
  local downText = swipeLabelText(p, 'swipeDownAction', 'swipeDownText');
  local downImage = if std.objectHas(p, 'swipeDownSystemImageName') then p.swipeDownSystemImageName else '';
  // 上 / 下滑气泡只给能输入字符的动作，快捷指令不弹气泡
  local upHint = if std.objectHas(p, 'swipeUpAction') then swipeActionText(p.swipeUpAction) else '';
  local downHint = if std.objectHas(p, 'swipeDownAction') then swipeActionText(p.swipeDownAction) else '';
  local upBadgeName = name + 'SwipeUpBadgeForegroundStyle';
  local downBadgeName = name + 'SwipeDownBadgeForegroundStyle';
  local upHintName = name + 'SwipeUpHintForegroundStyle';
  local downHintName = name + 'SwipeDownHintForegroundStyle';
  basicStyle.newAlphabeticButton(
    name,
    isDark,
    extraParams
    + p {
      hintStyle: hintStyle.hintStyle
                 + (if upHint != '' then { swipeUpForegroundStyle: upHintName } else {})
                 + (if downHint != '' then { swipeDownForegroundStyle: downHintName } else {}),
    }
    + {
      foregroundStyleName:
        [name + 'ForegroundStyle']
        + (if upText != '' then [upBadgeName] else [])
        + (if downText != '' || downImage != '' then [downBadgeName] else []),
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, button)
        + (
          if upText != '' then
            { [upBadgeName]: basicStyle.newAlphabeticButtonSwipeForegroundStyle(isDark, { text: upText } + topBadgeLabelUpParams) }
          else {}
        )
        + (
          if downImage != '' then
            { [downBadgeName]: basicStyle.newAlphabeticButtonSwipeForegroundStyle(isDark, { systemImageName: downImage } + bottomBadgeLabelDownParams) }
          else if downText != '' then
            { [downBadgeName]: basicStyle.newAlphabeticButtonSwipeForegroundStyle(isDark, { text: downText } + bottomBadgeLabelDownParams) }
          else {}
        ),
    }
  )
  + (if upHint != '' then { [upHintName]: basicStyle.newAlphabeticButtonHintStyle(isDark) + { text: upHint } } else {})
  + (if downHint != '' then { [downHintName]: basicStyle.newAlphabeticButtonHintStyle(isDark) + { text: downHint } } else {});


// 标准26键布局
local alphabeticKeyboardLayout(addSemicolon=false) = {
  keyboardLayout: [
    {
      HStack: {
        subviews: [
          {
            Cell: params.keyboard.qButton.name,
          },
          {
            Cell: params.keyboard.wButton.name,
          },
          {
            Cell: params.keyboard.eButton.name,
          },
          {
            Cell: params.keyboard.rButton.name,
          },
          {
            Cell: params.keyboard.tButton.name,
          },
          {
            Cell: params.keyboard.yButton.name,
          },
          {
            Cell: params.keyboard.uButton.name,
          },
          {
            Cell: params.keyboard.iButton.name,
          },
          {
            Cell: params.keyboard.oButton.name,
          },
          {
            Cell: params.keyboard.pButton.name,
          },
        ],
      },
    },
    {
      HStack: {
        subviews: [
          {
            Cell: params.keyboard.aButton.name,
          },
          {
            Cell: params.keyboard.sButton.name,
          },
          {
            Cell: params.keyboard.dButton.name,
          },
          {
            Cell: params.keyboard.fButton.name,
          },
          {
            Cell: params.keyboard.gButton.name,
          },
          {
            Cell: params.keyboard.hButton.name,
          },
          {
            Cell: params.keyboard.jButton.name,
          },
          {
            Cell: params.keyboard.kButton.name,
          },
          {
            Cell: params.keyboard.lButton.name,
          },
          (
            if addSemicolon == true then
              {
                Cell: params.keyboard.semicolonButton.name,
              }
            else {}
          ),
        ],
      },
    },
    {
      HStack: {
        subviews: [
          {
            Cell: params.keyboard.shiftButton.name,
          },
          {
            Cell: params.keyboard.zButton.name,
          },
          {
            Cell: params.keyboard.xButton.name,
          },
          {
            Cell: params.keyboard.cButton.name,
          },
          {
            Cell: params.keyboard.vButton.name,
          },
          {
            Cell: params.keyboard.bButton.name,
          },
          {
            Cell: params.keyboard.nButton.name,
          },
          {
            Cell: params.keyboard.mButton.name,
          },
          {
            Cell: params.keyboard.backspaceButton.name,
          },
        ],
      },
    },
    {
      HStack: {
        subviews: [
          {
            Cell: params.keyboard.abcPinyinButton.name,
          },
          {
            Cell: params.keyboard.symbolicButton.name,
          },
          {
            Cell: params.keyboard.spaceButton.name,
          },
          {
            Cell: params.keyboard.commaButton.name,
          },
          {
            Cell: params.keyboard.enterButton.name,
          },
        ],
      },
    },
  ],
};


local newKeyLayout(isDark=false, isPortrait=true, addSemicolon=true) =
  local keyboardHeight = if isPortrait then params.keyboard.height.iPhone.portrait else params.keyboard.height.iPhone.landscape;
  {
    keyboardHeight: keyboardHeight,
    keyboardStyle: utils.newBackgroundStyle(style=basicStyle.keyboardBackgroundStyleName),
  }
  + alphabeticKeyboardLayout(addSemicolon)

  // First Row
  + newSwipeLetterButton(isDark, params.keyboard.qButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.wButton.name,
    isDark,
    params.keyboard.wButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.twoButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.wButton.name + 'ForegroundStyle',
        params.keyboard.twoButton.name + 'BadgeForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.wButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.twoButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.twoButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.eButton.name,
    isDark,
    params.keyboard.eButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.threeButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.eButton.name + 'ForegroundStyle',
        params.keyboard.threeButton.name + 'BadgeForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.eButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.threeButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.threeButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.rButton.name,
    isDark,
    params.keyboard.rButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.fourButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.rButton.name + 'ForegroundStyle',
        params.keyboard.fourButton.name + 'BadgeForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.rButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.fourButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.fourButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.tButton.name,
    isDark,
    params.keyboard.tButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.fiveButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.tButton.name + 'ForegroundStyle',
        params.keyboard.fiveButton.name + 'BadgeForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.tButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.fiveButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.fiveButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.yButton.name,
    isDark,
    params.keyboard.yButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.sixButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.yButton.name + 'ForegroundStyle',
        params.keyboard.sixButton.name + 'BadgeForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.yButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.sixButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.sixButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.uButton.name,
    isDark,
    params.keyboard.uButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.sevenButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.uButton.name + 'ForegroundStyle',
        params.keyboard.sevenButton.name + 'BadgeForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.uButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.sevenButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.sevenButton)

  + basicStyle.newAlphabeticButton(
    params.keyboard.iButton.name,
    isDark,
    params.keyboard.iButton.params {
      hintStyle: hintStyle.hintStyle {
        swipeUpForegroundStyle: params.keyboard.eightButton.name + 'SwipeUpHintForegroundStyle',
      },
    }
    + {
      foregroundStyleName: [
        params.keyboard.iButton.name + 'ForegroundStyle',
        params.keyboard.eightButton.name + 'BadgeForegroundStyle',
      ],
    }
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, params.keyboard.iButton)
        + createTopBadgeForegroundStyle(isDark, params.keyboard.eightButton),
    }
  ) + createSwipeUpHintStyle(isDark, params.keyboard.eightButton)

  + newSwipeLetterButton(isDark, params.keyboard.oButton)

  + newSwipeLetterButton(isDark, params.keyboard.pButton)

  // Second Row
  + newSwipeLetterButton(
    isDark,
    params.keyboard.aButton,
    (
      if addSemicolon == false then
        {
          size:
            { width: '168.75/1125' },
          bounds:
            { width: '111/168.75', alignment: 'right' },
        }
      else {}
    )
  )

  + newSwipeLetterButton(isDark, params.keyboard.sButton)

  + newSwipeLetterButton(isDark, params.keyboard.dButton)

  + newSwipeLetterButton(isDark, params.keyboard.fButton)

  + newSwipeLetterButton(isDark, params.keyboard.gButton)

  + newSwipeLetterButton(isDark, params.keyboard.hButton)

  + newSwipeLetterButton(isDark, params.keyboard.jButton)

  + newSwipeLetterButton(isDark, params.keyboard.kButton)

  + newSwipeLetterButton(
    isDark,
    params.keyboard.lButton,
    (
      if addSemicolon == false then
        {
          size:
            { width: '168.75/1125' },
          bounds:
            { width: '111/168.75', alignment: 'left' },
        }
      else {}
    )
  )

  + (
    if addSemicolon == true then
      basicStyle.newAlphabeticButton(
        params.keyboard.semicolonButton.name,
        isDark,
        params.keyboard.semicolonButton.params {
          hintStyle: hintStyle.hintStyle {
            swipeUpForegroundStyle: params.keyboard.colonButton.name + 'SwipeUpHintForegroundStyle',
          },
        }
        + {
          foregroundStyleName: [
            params.keyboard.semicolonButton.name + 'ForegroundStyle',
            params.keyboard.colonButton.name + 'BadgeForegroundStyle',
          ],
        }
        + {
          foregroundStyle:
            createButtonForegroundStyle(isDark, params.keyboard.semicolonButton)
            + createTopBadgeForegroundStyle(isDark, params.keyboard.colonButton),
        }
      ) + createSwipeUpHintStyle(isDark, params.keyboard.colonButton)
    else {}
  )


  // Third Row

  + basicStyle.newSystemButton(
    params.keyboard.shiftButton.name,
    isDark,
    {
      size:
        { width: { percentage: 0.15 } },
      bounds:
        { width: '151/168.75', alignment: 'left' },
    }
    + params.keyboard.shiftButton.params
    + {
      uppercasedStateForegroundStyle: params.keyboard.shiftButton.name + 'UppercasedForegroundStyle',
    }
    + {
      capsLockedStateForegroundStyle: params.keyboard.shiftButton.name + 'CapsLockedForegroundStyle',
    }
  )
  + {
    [params.keyboard.shiftButton.name + 'UppercasedForegroundStyle']:
      basicStyle.newImageSystemButtonForegroundStyle(isDark, params.keyboard.shiftButton.uppercasedParams),
    [params.keyboard.shiftButton.name + 'CapsLockedForegroundStyle']:
      basicStyle.newImageSystemButtonForegroundStyle(isDark, params.keyboard.shiftButton.capsLockedParams),
  }

  + newSwipeLetterButton(isDark, params.keyboard.zButton)

  + newSwipeLetterButton(isDark, params.keyboard.xButton)


  + newSwipeLetterButton(isDark, params.keyboard.cButton)

  + newSwipeLetterButton(isDark, params.keyboard.vButton)

  + newSwipeLetterButton(isDark, params.keyboard.bButton)

  + newSwipeLetterButton(isDark, params.keyboard.nButton)

  + newSwipeLetterButton(isDark, params.keyboard.mButton)

  + basicStyle.newSystemButton(
    params.keyboard.backspaceButton.name,
    isDark,
    {
      size:
        { width: { percentage: 0.15 } },
      bounds:
        { width: '151/168.75', alignment: 'right' },
    } + params.keyboard.backspaceButton.params,
  )

  // Fourth Row

  + basicStyle.newSystemButton(
    params.keyboard.abcPinyinButton.name,
    isDark,
    {
      size:
        { width: { percentage: 0.2 } },
    }
    + params.keyboard.abcPinyinButton.params
  )


  // 英文句点键：不设上滑 / 下滑
  + newSwipeLetterButton(
    isDark,
    params.keyboard.commaButton,
    {
      size:
        { width: { percentage: 0.1 } },
    }
  )

  + basicStyle.newAlphabeticButton(
    params.keyboard.spaceButton.name,
    isDark,
    params.keyboard.spaceButton.params,
    needHint=false
  )

  +
  basicStyle.newSystemButton(
    params.keyboard.symbolicButton.name,
    isDark,
    {
      size:
        { width: { percentage: 0.1 } },
    }
    + params.keyboard.symbolicButton.params,
  )

  + basicStyle.newSystemButton(
    params.keyboard.enterButton.name,
    isDark,
    {
      size:
        { width: { percentage: 0.2 } },
    } + params.keyboard.enterButton.params {
      notification:
        ['returnKeyTypeChangedNotification']
        + (if isDark then [] else alphabeticKeyboardActionNotificationNames),
    }
  )
;

{
  new(isDark, isPortrait, addSemicolon=false):
    local insets = if isPortrait then params.keyboard.button.backgroundInsets.iPhone.portrait else params.keyboard.button.backgroundInsets.iPhone.landscape;

    local extraParams = {
      insets: insets,
    };

    // 与 T9 拼音键盘共用顶部区域（预编辑 + 音节栏 + 候选词栏），三种键盘总高度一致：
    // 来回切换时键盘高度不变（不卡顿、无落差），T9 打字中切过来时候选词也不会叠到按键上。
    t9Keyboard.topArea(isDark, isPortrait)
    + basicStyle.newKeyboardBackgroundStyle(isDark)
    + basicStyle.newAlphabeticButtonBackgroundStyle(isDark, extraParams)
    + basicStyle.newAlphabeticButtonHintStyle(isDark)
    + basicStyle.newSystemButtonBackgroundStyle(isDark, extraParams)
    + (if isDark then {} else basicStyle.newBlueButtonBackgroundStyle(isDark, extraParams))
    + basicStyle.newAlphabeticHintBackgroundStyle(isDark, { cornerRadius: 10 })
    + newKeyLayout(isDark, isPortrait, addSemicolon)
    + basicStyle.newEnterButtonForegroundStyle(isDark, params.keyboard.enterButton.params)
    + (if isDark then {} else newAlphabeticEnterBlueTextStyles(isDark))
    + basicStyle.newCommitCandidateForegroundStyle(isDark, { text: '选定' })
    // Notifications
    + basicStyle.returnKeyboardTypeChangedNotification
    + (if isDark then {} else alphabeticKeyboardActionNotifications)
    + basicStyle.preeditChangedForSpaceButtonNotification,
}
