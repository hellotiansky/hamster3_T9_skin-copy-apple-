local fonts = import '../Constants/Fonts.libsonnet';
local params = import '../Constants/Keyboard.libsonnet';
local colors = import '../Constants/Colors.libsonnet';
local basicStyle = import 'BasicStyle.libsonnet';
local preedit = import 'Preedit.libsonnet';
local toolbar = import 'Toolbar.libsonnet';
local utils = import 'Utils.libsonnet';

local rightBadgeLabelUpParams = {
  center: {
    x: 0.85,
    y: 0.25,
  },
  fontSize: fonts.iPhone.button.doubleLabelSmallFontSize,
};

local createRightBadgeForegroundStyle(isDark, buttonParams={}) = {
  [buttonParams.name + 'BadgeForegroundStyle']:
    basicStyle.newAlphabeticButtonSwipeForegroundStyle(isDark, buttonParams.params + rightBadgeLabelUpParams),
};

local createButtonForegroundStyle(isDark, buttonParams={}) = {
  [buttonParams.name + 'ForegroundStyle']:
    basicStyle.newAlphabeticButtonForegroundStyle(isDark, buttonParams.params),
};

// 行 / 列尺寸样式
local t9PinyinRowStyleName = 't9PinyinRowStyle';
local t9KeyRowStyleName = 't9KeyRowStyle';
local t9BottomLeftStyleName = 't9BottomLeftStyle';
local t9BottomCenterStyleName = 't9BottomCenterStyle';
local t9BottomRightStyleName = 't9BottomRightStyle';

local t9RowStyles(isPortrait) = {
  [t9PinyinRowStyleName]: {
    size: { height: if isPortrait then 28 else 24 },
  },
  [t9KeyRowStyleName]: {
    size: { height: if isPortrait then 54 else 40 },
  },
  [t9BottomLeftStyleName]: {
    size: { width: { percentage: 0.2 } },
  },
  [t9BottomCenterStyleName]: {
    size: { width: { percentage: 0.6 } },
  },
  [t9BottomRightStyleName]: {
    size: { width: { percentage: 0.2 } },
  },
};

// 单个九键数字键
local t9Button(isDark, button, badge, fontSize, preeditState=false, showBadge=true) =
  basicStyle.newAlphabeticButton(
    button.name,
    isDark,
    button.params {
      foregroundStyleName:
        if showBadge then
          [
            button.name + 'ForegroundStyle',
            badge.name + 'BadgeForegroundStyle',
          ]
        else
          [button.name + 'ForegroundStyle'],
    }
    + (
      if preeditState then
        { notification: [basicStyle.t9OneButtonPreeditNotificationName] }
      else {}
    )
    + {
      foregroundStyle:
        createButtonForegroundStyle(isDark, button {
          params: button.params { fontSize: fontSize },
        })
        + (
          if showBadge then
            createRightBadgeForegroundStyle(isDark, badge)
          else {}
        ),
    },
    needHint=false
  );

// iOS 17.6 风格九键布局
local alphabeticKeyboardLayout = {
  keyboardLayout: [
    // 第 1 行
    {
      HStack: {
        style: t9KeyRowStyleName,
        subviews: [
          {
            Cell: params.keyboard.numericButton.name,
          },
          {
            Cell: params.keyboard.t9OneButton.name,
          },
          {
            Cell: params.keyboard.t9TwoButton.name,
          },
          {
            Cell: params.keyboard.t9ThreeButton.name,
          },
          {
            Cell: params.keyboard.backspaceButton.name,
          },
        ],
      },
    },
    // 第 2 行
    {
      HStack: {
        style: t9KeyRowStyleName,
        subviews: [
          {
            Cell: params.keyboard.symbolicButton.name,
          },
          {
            Cell: params.keyboard.t9FourButton.name,
          },
          {
            Cell: params.keyboard.t9FiveButton.name,
          },
          {
            Cell: params.keyboard.t9SixButton.name,
          },
          {
            Cell: params.keyboard.t9RestInputButton.name,
          },
        ],
      },
    },
    // 第 3、4 行：确认键跨两行，0 在空格左侧，ABC 在左下
    {
      HStack: {
        subviews: [
          {
            VStack: {
              style: t9BottomLeftStyleName,
              subviews: [
                {
                  Cell: params.keyboard.abcSwitchButton.name,
                },
              ],
            },
          },
          {
            VStack: {
              style: t9BottomCenterStyleName,
              subviews: [
                {
                  HStack: {
                    subviews: [
                      {
                        Cell: params.keyboard.t9SevenButton.name,
                      },
                      {
                        Cell: params.keyboard.t9EightButton.name,
                      },
                      {
                        Cell: params.keyboard.t9NineButton.name,
                      },
                    ],
                  },
                },
                {
                  HStack: {
                    subviews: [
                      {
                        Cell: params.keyboard.t9ZeroButton.name,
                      },
                      {
                        Cell: params.keyboard.spaceButton.name,
                      },
                    ],
                  },
                },
              ],
            },
          },
          {
            VStack: {
              style: t9BottomRightStyleName,
              subviews: [
                {
                  Cell: params.keyboard.t9ConfirmButton.name,
                },
              ],
            },
          },
        ],
      },
    },
  ],
};


local newKeyLayout(isDark=false, isPortrait=true) =
  local baseHeight = if isPortrait then params.keyboard.height.iPhone.portrait else params.keyboard.height.iPhone.landscape;
  local t9FontSize = if isPortrait then fonts.t9ButtonTextFontSize else fonts.t9ButtonLandscapeTextFontSize;
  local pinyinFontSize = if isPortrait then 20 else 17;

  {
    keyboardHeight: baseHeight,
    keyboardStyle: utils.newBackgroundStyle(style=basicStyle.keyboardBackgroundStyleName),
  }
  + alphabeticKeyboardLayout

  + t9RowStyles(isPortrait)

  + {
    // 横向拼音列表
    [params.keyboard.t9HorizontalSymbolsCollection.name]:
      params.keyboard.t9HorizontalSymbolsCollection.params,
  }

  + basicStyle.newT9PinyinCellStyles(isDark, pinyinFontSize)
  + basicStyle.newT9OneButtonPreeditStyles(isDark, pinyinFontSize)

  // 数字键（1 键在预编辑状态显示「分隔」）
  + t9Button(isDark, params.keyboard.t9OneButton, params.keyboard.oneButton, t9FontSize, true)
  + t9Button(isDark, params.keyboard.t9TwoButton, params.keyboard.twoButton, t9FontSize)
  + t9Button(isDark, params.keyboard.t9ThreeButton, params.keyboard.threeButton, t9FontSize)
  + t9Button(isDark, params.keyboard.t9FourButton, params.keyboard.fourButton, t9FontSize)
  + t9Button(isDark, params.keyboard.t9FiveButton, params.keyboard.fiveButton, t9FontSize)
  + t9Button(isDark, params.keyboard.t9SixButton, params.keyboard.sixButton, t9FontSize)
  + t9Button(isDark, params.keyboard.t9SevenButton, params.keyboard.sevenButton, t9FontSize)
  + t9Button(isDark, params.keyboard.t9EightButton, params.keyboard.eightButton, t9FontSize)
  + t9Button(isDark, params.keyboard.t9NineButton, params.keyboard.nineButton, t9FontSize)

  // 左侧列 / 右侧列
  + basicStyle.newSystemButton(
    params.keyboard.t9ZeroButton.name,
    isDark,
    {
      size: { width: '1/3' },
    } + params.keyboard.t9ZeroButton.params
  )
  + basicStyle.newSystemButton(
    params.keyboard.symbolicButton.name,
    isDark,
    params.keyboard.symbolicButton.params
  )
  + basicStyle.newSystemButton(
    params.keyboard.numericButton.name,
    isDark,
    params.keyboard.numericButton.params
  )
  + basicStyle.newSystemButton(
    params.keyboard.backspaceButton.name,
    isDark,
    params.keyboard.backspaceButton.params,
  )
  + basicStyle.newSystemButton(
    params.keyboard.t9RestInputButton.name,
    isDark,
    params.keyboard.t9RestInputButton.params,
  )
  + basicStyle.newSystemButton(
    params.keyboard.t9ConfirmButton.name,
    isDark,
    params.keyboard.t9ConfirmButton.params,
  )

  // 底行：ABC（中/英） + 空格（选定）
  + basicStyle.newSystemButton(
    params.keyboard.abcSwitchButton.name,
    isDark,
    params.keyboard.abcSwitchButton.params,
  )
  + basicStyle.newAlphabeticButton(
    params.keyboard.spaceButton.name,
    isDark,
    params.keyboard.spaceButton.params,
    needHint=false
  );


{
  new(isDark=false, isPortrait=true):
    local insets =
      if isPortrait then
        params.keyboard.button.backgroundInsets.iPhone.portrait
      else
        params.keyboard.button.backgroundInsets.iPhone.landscape;

    local t9Toolbar = toolbar.new(isDark);
    local t9CandidateTextFontSize = if isPortrait then 18 else 16;

    preedit.new(isDark)
    + t9Toolbar
    + {
      // 拼音预览固定在顶部；工具栏区放「拼音候选栏 + 候选词栏」
      preeditHeight: if isPortrait then 30 else 26,
      preeditStyle: {
        backgroundStyle: basicStyle.keyboardBackgroundStyleName,
        foregroundStyle: 't9PreeditForegroundStyle',
        insets: { left: 10, top: 2 },
      },
      t9PreeditForegroundStyle: utils.newTextStyle({
        normalColor: colors.standardButtonForegroundColor,
        fontSize: if isPortrait then 20 else 17,
      }, isDark),
      // 拼音栏较窄、候选词栏较高，贴近 iOS 的「上窄下宽」
      toolbarHeight: if isPortrait then 78 else 70,
      horizontalCandidateStyle: t9Toolbar.horizontalCandidateStyle {
        textFontSize: t9CandidateTextFontSize,
      },
      horizontalCandidatesLayout: [
        {
          VStack: {
            subviews: [
              {
                HStack: {
                  style: t9PinyinRowStyleName,
                  subviews: [
                    {
                      Cell: params.keyboard.t9HorizontalSymbolsCollection.name,
                    },
                  ],
                },
              },
              {
                HStack: {
                  subviews: [
                    {
                      Cell: 'horizontalCandidates',
                    },
                    {
                      Cell: 'expandButton',
                    },
                  ],
                },
              },
            ],
          },
        },
      ],
      // 展开全部候选时，顶部的预编辑拼音行保持可见；候选区只放候选网格和底部操作行
      verticalCandidatesLayout: [
        {
          HStack: {
            subviews: [
              {
                Cell: 'verticalCandidates',
              },
            ],
          },
        },
        {
          HStack: {
            style: 'verticalLastRowStyle',
            subviews: [
              {
                Cell: 'verticalPageUpButtonStyle',
              },
              {
                Cell: 'verticalPageDownButtonStyle',
              },
              {
                Cell: 'verticalReturnButtonStyle',
              },
              {
                Cell: 'verticalBackspaceButtonStyle',
              },
            ],
          },
        },
      ],
    }
    + basicStyle.newKeyboardBackgroundStyle(isDark)
    + basicStyle.newAlphabeticButtonBackgroundStyle(isDark, { insets: insets })
    + basicStyle.newAlphabeticButtonHintStyle(isDark)
    + basicStyle.newSystemButtonBackgroundStyle(isDark, { insets: insets })
    + basicStyle.newBlueButtonBackgroundStyle(isDark, { insets: insets })
    + basicStyle.newBlueButtonForegroundStyle(isDark, params.keyboard.enterButton.params)
    + basicStyle.newAlphabeticHintBackgroundStyle(isDark, { cornerRadius: 10 })
    + newKeyLayout(isDark, isPortrait)
    + basicStyle.newEnterButtonForegroundStyle(isDark, params.keyboard.enterButton.params)
    + basicStyle.newCommitCandidateForegroundStyle(isDark, { text: '选定' })
    // Notifications
    + basicStyle.returnKeyboardTypeChangedNotification
    + basicStyle.preeditChangedForEnterButtonNotification
    + basicStyle.preeditChangedForSpaceButtonNotification,
}
