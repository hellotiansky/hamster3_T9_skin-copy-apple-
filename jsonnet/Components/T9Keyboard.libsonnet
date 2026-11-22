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
local t9HorizontalCandidatesRowStyleName = 't9HorizontalCandidatesRowStyle';
local t9KeyRowStyleName = 't9KeyRowStyle';
local t9BottomLeftStyleName = 't9BottomLeftStyle';
local t9BottomCenterStyleName = 't9BottomCenterStyle';
local t9BottomRightStyleName = 't9BottomRightStyle';
local t9PinyinDividerRowStyleName = 't9PinyinDividerRowStyle';
local t9PinyinDividerName = 't9PinyinDivider';
local t9PinyinDividerBackgroundStyleName = 't9PinyinDividerBackgroundStyle';
local t9PinyinDividerSpacerRowStyleName = 't9PinyinDividerSpacerRowStyle';
local t9PinyinDividerSpacerName = 't9PinyinDividerSpacer';
local t9PinyinDividerSpacerBackgroundStyleName = 't9PinyinDividerSpacerBackgroundStyle';

local t9RowStyles(isPortrait) = {
  [t9KeyRowStyleName]: {
    size: { height: if isPortrait then 55.5 else 41 },
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
  + basicStyle.newAlphabeticButton(
    params.keyboard.t9ZeroButton.name,
    isDark,
    {
      size: { width: '1/3' },
    } + params.keyboard.t9ZeroButton.params,
    needHint=false
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
    params.keyboard.t9ConfirmButton.params {
      notification:
        if isDark then
          ['returnKeyTypeChangedNotification']
        else
          ['returnKeyTypeChangedNotification', 't9ConfirmBlueNotification'],
    },
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


// MARK: - 顶部区域（预编辑 + 拼音音节栏 + 候选词栏）
//
// 1) 防跳动：横向候选（常态）与纵向候选（展开态）顶部「音节栏 + 分隔线 + 间隔」
//    使用同一组行样式和同样的行高，容器 insets 统一为 0；常态各行高度之和恰好等于
//    toolbarHeight，不会被等比压缩，展开 / 收起时音节栏位置与高度完全不变。
// 2) 等高：T9、数字键盘、26 键都使用这一套顶部区域，三种键盘总高度一致，
//    来回切换时键盘不需要改变高度（避免落差感与连续切换卡顿），
//    在 T9 打字中切到其他键盘时候选词也有地方显示，不会叠到按键上。
local t9TopMetrics(isPortrait) = {
  preeditHeight: if isPortrait then 30 else 26,
  pinyinRowHeight: if isPortrait then 36 else 31.5,
  dividerHeight: 0.5,
  dividerSpacerHeight: 4,
  candidatesRowHeight: if isPortrait then 39.5 else 36,
};

local t9TopZeroInsets = { top: 0, left: 0, bottom: 0, right: 0 };

local t9TopArea(isDark=false, isPortrait=true) =
  local m = t9TopMetrics(isPortrait);
  local t9Toolbar = toolbar.new(isDark);
  local pinyinFontSize = if isPortrait then 20 else 17;
  local t9CandidateTextFontSize = if isPortrait then 18 else 16;
  // 常态与展开态共用的顶部三行
  local topRows = [
    {
      HStack: {
        style: t9PinyinRowStyleName,
        subviews: [{ Cell: params.keyboard.t9HorizontalSymbolsCollection.name }],
      },
    },
    {
      HStack: {
        style: t9PinyinDividerRowStyleName,
        subviews: [{ Cell: t9PinyinDividerName }],
      },
    },
    {
      HStack: {
        style: t9PinyinDividerSpacerRowStyleName,
        subviews: [{ Cell: t9PinyinDividerSpacerName }],
      },
    },
  ];

  preedit.new(isDark)
  + t9Toolbar
  + {
    // 拼音预览固定在顶部；工具栏区放「拼音候选栏 + 候选词栏」
    preeditHeight: m.preeditHeight,
    preeditStyle: {
      backgroundStyle: basicStyle.keyboardBackgroundStyleName,
      foregroundStyle: 't9PreeditForegroundStyle',
      insets: { left: 10, top: 2 },
    },
    t9PreeditForegroundStyle: utils.newTextStyle({
      normalColor: colors.standardButtonForegroundColor,
      fontSize: if isPortrait then 20 else 17,
    }, isDark),
    // 拼音栏与候选词栏之间的分割线，常态下也显示
    [t9PinyinDividerName]: {
      action: 'none',
      backgroundStyle: t9PinyinDividerBackgroundStyleName,
    },
    [t9PinyinDividerBackgroundStyleName]: utils.newGeometryStyle({
      normalColor: colors.labelColor.tertiary,
      highlightColor: colors.labelColor.tertiary,
    }, isDark),
    // 分隔线与候选词区域之间的透明间距
    [t9PinyinDividerSpacerName]: {
      action: 'none',
      backgroundStyle: t9PinyinDividerSpacerBackgroundStyleName,
    },
    [t9PinyinDividerSpacerBackgroundStyleName]: utils.newGeometryStyle({
      normalColor: '#00000000',
      highlightColor: '#00000000',
    }, isDark),
    // 拼音栏较窄、候选词栏较高，贴近 iOS 的「上窄下宽」；高度 = 各行之和
    toolbarHeight: m.pinyinRowHeight + m.dividerHeight + m.dividerSpacerHeight + m.candidatesRowHeight,
    horizontalCandidatesStyle: t9Toolbar.horizontalCandidatesStyle { insets: t9TopZeroInsets },
    verticalCandidatesStyle: t9Toolbar.verticalCandidatesStyle { insets: t9TopZeroInsets },
    horizontalCandidateStyle: t9Toolbar.horizontalCandidateStyle {
      textFontSize: t9CandidateTextFontSize,
    },
    // 行高（常态与展开态共用）
    [t9PinyinRowStyleName]: { size: { height: m.pinyinRowHeight } },
    [t9PinyinDividerRowStyleName]: { size: { height: m.dividerHeight } },
    [t9PinyinDividerSpacerRowStyleName]: { size: { height: m.dividerSpacerHeight } },
    [t9HorizontalCandidatesRowStyleName]: { size: { height: m.candidatesRowHeight } },
    // 横向拼音列表
    // 注意：实测元书的 t9HorizontalSymbols 不读取皮肤里的间距、宽度、字号等设置，
    // 音节间距由元书内部决定（interCellSpacing / maxColumns / cellStyle insets 修改均无效果）。
    [params.keyboard.t9HorizontalSymbolsCollection.name]:
      params.keyboard.t9HorizontalSymbolsCollection.params,
    horizontalCandidatesLayout: [
      {
        VStack: {
          subviews: topRows + [
            {
              HStack: {
                style: t9HorizontalCandidatesRowStyleName,
                subviews: [
                  { Cell: 'horizontalCandidates' },
                  { Cell: 'expandButton' },
                ],
              },
            },
          ],
        },
      },
    ],
    // 展开全部候选时仍保留顶部九键拼音候选（与常态完全相同），便于继续点选/筛选拼音
    verticalCandidatesLayout: [
      {
        VStack: {
          subviews: topRows + [
            {
              HStack: {
                subviews: [{ Cell: 'verticalCandidates' }],
              },
            },
            {
              HStack: {
                style: 'verticalLastRowStyle',
                subviews: [
                  { Cell: 'verticalPageUpButtonStyle' },
                  { Cell: 'verticalPageDownButtonStyle' },
                  { Cell: 'verticalReturnButtonStyle' },
                  { Cell: 'verticalBackspaceButtonStyle' },
                ],
              },
            },
          ],
        },
      },
    ],
  }
  + basicStyle.newT9PinyinCellStyles(isDark, pinyinFontSize);


{
  // 顶部区域，供数字键盘、26 键复用，保证三种键盘总高度一致
  topArea: t9TopArea,

  new(isDark=false, isPortrait=true):
    local insets =
      if isPortrait then
        params.keyboard.button.backgroundInsets.iPhone.portrait
      else
        params.keyboard.button.backgroundInsets.iPhone.landscape;

    t9TopArea(isDark, isPortrait)
    + basicStyle.newKeyboardBackgroundStyle(isDark)
    + basicStyle.newAlphabeticButtonBackgroundStyle(isDark, { insets: insets })
    + basicStyle.newAlphabeticButtonHintStyle(isDark)
    + basicStyle.newSystemButtonBackgroundStyle(isDark, { insets: insets })
    + (if isDark then {} else basicStyle.newBlueButtonBackgroundStyle(isDark, { insets: insets }))
    + basicStyle.newAlphabeticHintBackgroundStyle(isDark, { cornerRadius: 10 })
    + newKeyLayout(isDark, isPortrait)
    + basicStyle.newEnterButtonForegroundStyle(isDark, params.keyboard.enterButton.params)
    + (if isDark then {} else basicStyle.newT9ConfirmBlueTextStyles(isDark))
    + basicStyle.newCommitCandidateForegroundStyle(isDark, { text: '选定' })
    // Notifications
    + basicStyle.returnKeyboardTypeChangedNotification
    + (if isDark then {} else basicStyle.t9ConfirmBlueNotification)
    + basicStyle.preeditChangedForSpaceButtonNotification,
}
