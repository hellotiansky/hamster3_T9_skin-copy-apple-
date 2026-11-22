local params = import '../Constants/Keyboard.libsonnet';
local basicStyle = import 'BasicStyle.libsonnet';
local preedit = import 'Preedit.libsonnet';
local toolbar = import 'Toolbar.libsonnet';
local t9Keyboard = import 'T9Keyboard.libsonnet';
local utils = import 'Utils.libsonnet';


// 窄 VStack 宽度样式
local narrowVStackStyle = {
  local this = self,
  name: 'narrowVStackStyle',
  style: {
    [this.name]: {
      size: {
        width: { percentage: 0.17 },
      },
    },
  },
};

// 宽 VStack 宽度样式
local wideVStackStyle = {
  local this = self,
  name: 'wideVStackStyle',
  style: {
    [this.name]: {
      size: {
        width: { percentage: 0.22 },
      },
    },
  },
};

// 9 键布局
local alphabeticKeyboardLayout = {
  keyboardLayout: [
    {
      VStack: {
        style: narrowVStackStyle.name,
        subviews: [
          {
            Cell: params.keyboard.returnLastKeyboardButton.name,
          },
          {
            Cell: params.keyboard.numericSymbolsCollection.name,
          },
        ],
      },
    },
    {
      VStack: {
        style: wideVStackStyle.name,
        subviews: [
          {
            Cell: params.keyboard.oneButton.name,
          },
          {
            Cell: params.keyboard.fourButton.name,
          },
          {
            Cell: params.keyboard.sevenButton.name,
          },
          {
            Cell: params.keyboard.symbolicButton.name,
          },
        ],
      },
    },
    {
      VStack: {
        style: wideVStackStyle.name,
        subviews: [
          {
            Cell: params.keyboard.twoButton.name,
          },
          {
            Cell: params.keyboard.fiveButton.name,
          },
          {
            Cell: params.keyboard.eightButton.name,
          },
          {
            Cell: params.keyboard.zeroButton.name,
          },
        ],
      },
    },
    {
      VStack: {
        style: wideVStackStyle.name,
        subviews: [
          {
            Cell: params.keyboard.threeButton.name,
          },
          {
            Cell: params.keyboard.sixButton.name,
          },
          {
            Cell: params.keyboard.nineButton.name,
          },
          {
            Cell: params.keyboard.spaceButton.name,
          },
        ],
      },
    },
    {
      VStack: {
        style: narrowVStackStyle.name,
        subviews: [
          {
            Cell: params.keyboard.backspaceButton.name,
          },
          {
            Cell: params.keyboard.periodButton.name,
          },
          {
            Cell: params.keyboard.equalButton.name,
          },
          {
            Cell: params.keyboard.enterButton.name,
          },
        ],
      },
    },
  ],
};


local newKeyLayout(isDark=false, isPortrait=false) =

  local keyboardHeight = if isPortrait then params.keyboard.height.iPhone.portrait else params.keyboard.height.iPhone.landscape;

  {
    keyboardHeight: keyboardHeight,
    keyboardStyle: utils.newBackgroundStyle(style=basicStyle.keyboardBackgroundStyleName),
  }

  + alphabeticKeyboardLayout

  + {
    // 集合视图定义
    [params.keyboard.numericSymbolsCollection.name]: {

    } + params.keyboard.numericSymbolsCollection.params,
  }

  + basicStyle.newAlphabeticButton(
    params.keyboard.oneButton.name,
    isDark,
    params.keyboard.oneButton.params,
    needHint=false
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.twoButton.name,
    isDark,
    params.keyboard.twoButton.params,
    needHint=false
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.threeButton.name,
    isDark,
    params.keyboard.threeButton.params,
    needHint=false
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.fourButton.name,
    isDark,
    params.keyboard.fourButton.params,
    needHint=false
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.fiveButton.name,
    isDark,
    params.keyboard.fiveButton.params,
    needHint=false
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.sixButton.name,
    isDark,
    params.keyboard.sixButton.params,
    needHint=false
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.sevenButton.name,
    isDark,
    params.keyboard.sevenButton.params,
    needHint=false
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.eightButton.name,
    isDark,
    params.keyboard.eightButton.params,
    needHint=false
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.nineButton.name,
    isDark,
    params.keyboard.nineButton.params,
    needHint=false
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.zeroButton.name,
    isDark,
    params.keyboard.zeroButton.params,
    needHint=false
  )

  + basicStyle.newSystemButton(
    params.keyboard.symbolicButton.name,
    isDark,
    {
      size: { height: '1/4' },
    } + params.keyboard.symbolicButton.params
  )

  + basicStyle.newSystemButton(
    params.keyboard.returnLastKeyboardButton.name,
    isDark,
    { size: { height: '1/4' } } + params.keyboard.returnLastKeyboardButton.params
  )

  + basicStyle.newSystemButton(
    params.keyboard.spaceButton.name,
    isDark,
    params.keyboard.spaceButton.params
  )

  + basicStyle.newSystemButton(
    params.keyboard.backspaceButton.name,
    isDark,
    params.keyboard.backspaceButton.params,
  )

  + basicStyle.newSystemButton(
    params.keyboard.periodButton.name,
    isDark,
    params.keyboard.periodButton.params,
  )

  + basicStyle.newSystemButton(
    params.keyboard.equalButton.name,
    isDark,
    params.keyboard.equalButton.params,
  )

  + basicStyle.newSystemButton(
    params.keyboard.enterButton.name,
    isDark,
    params.keyboard.enterButton.params
  );

local extraParams = {
  insets: params.keyboard.button.backgroundInsets.iPhone.landscape,
};

{
  new(isDark, isPortrait):
    local insets = if isPortrait then params.keyboard.button.backgroundInsets.iPhone.portrait else params.keyboard.button.backgroundInsets.iPhone.landscape;

    local extraParams = {
      insets: insets,
    };

    // 与 T9 拼音键盘共用顶部区域（预编辑 + 音节栏 + 候选词栏），三种键盘总高度一致，
    // 从 T9 按「123」切换时没有高度落差。
    t9Keyboard.topArea(isDark, isPortrait)
    + narrowVStackStyle.style
    + wideVStackStyle.style
    + basicStyle.newKeyboardBackgroundStyle(isDark)
    + basicStyle.newAlphabeticButtonBackgroundStyle(isDark, extraParams)
    + basicStyle.newAlphabeticButtonHintStyle(isDark)
    + basicStyle.newSystemButtonBackgroundStyle(isDark, extraParams)
    + basicStyle.newAlphabeticHintBackgroundStyle(isDark, { cornerRadius: 10 })
    + newKeyLayout(isDark, isPortrait)
    + basicStyle.newEnterButtonForegroundStyle(isDark, params.keyboard.enterButton.params)
    + basicStyle.newCommitCandidateForegroundStyle(isDark, { text: '选定' })
    // Notifications
    + basicStyle.returnKeyboardTypeChangedNotification
    + basicStyle.preeditChangedForSpaceButtonNotification,

}
