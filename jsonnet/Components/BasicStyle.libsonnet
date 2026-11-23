local colors = import '../Constants/Colors.libsonnet';
local fonts = import '../Constants/Fonts.libsonnet';
local keyboardParams = import '../Constants/Keyboard.libsonnet';
local utils = import 'Utils.libsonnet';

local buttonCornerRadius = 6;

local getKeyboardActionText(params={}, key='action', isUppercase=false) =
  if std.objectHas(params, 'text') then
    { text: params.text }
  else if std.objectHas(params, key) then
    local action = params[key];
    if std.type(action) == 'object' then
      if std.objectHas(action, 'character') then
        local text = if isUppercase then std.asciiUpper(action.character) else action.character;
        { text: text }
      else if std.objectHas(action, 'symbol') then
        local text = if isUppercase then std.asciiUpper(action.symbol) else action.symbol;
        { text: text }
      else
        {}
    else
      {}
  else
    {};

// 通用键盘背景样式
local keyboardBackgroundStyleName = 'keyboardBackgroundStyle';
local newKeyboardBackgroundStyle(isDark=false, params={}) = {
  [keyboardBackgroundStyleName]: utils.newGeometryStyle({
    normalColor: colors.keyboardBackgroundColor,
  } + params, isDark),
};

// 字母键按钮背景样式
local alphabeticButtonBackgroundStyleName = 'alphabeticButtonBackgroundStyle';
local newAlphabeticButtonBackgroundStyle(isDark=false, params={}) = {
  [alphabeticButtonBackgroundStyleName]: utils.newGeometryStyle({
    insets: keyboardParams.keyboard.button.backgroundInsets.iPhone.portrait,
    normalColor: colors.standardButtonBackgroundColor,
    highlightColor: colors.standardButtonHighlightedBackgroundColor,
    cornerRadius: buttonCornerRadius,
  } + params, isDark),
};

// 字母键按钮前景样式
local newAlphabeticButtonForegroundStyle(isDark=false, params={}) =
  if std.objectHas(params, 'systemImageName') then
    utils.newSystemImageStyle({
      normalColor: colors.standardButtonForegroundColor,
      highlightColor: colors.standardButtonHighlightedForegroundColor,
      fontSize: fonts.standardButtonImageFontSize,
    } + params, isDark)
  else if std.objectHas(params, 'assetImageName') then
    utils.newAssetImageStyle({
      normalColor: colors.standardButtonForegroundColor,
      highlightColor: colors.standardButtonHighlightedForegroundColor,
      fontSize: fonts.standardButtonImageFontSize,
    } + params, isDark)
  else
    utils.newTextStyle({
      normalColor: colors.standardButtonForegroundColor,
      highlightColor: colors.standardButtonHighlightedForegroundColor,
      fontSize: fonts.standardButtonTextFontSize,
    } + params, isDark) + getKeyboardActionText(params);

// 字母键按钮前景样式
local newAlphabeticButtonSwipeForegroundStyle(isDark=false, params={}) =
  if std.objectHas(params, 'systemImageName') then
    utils.newSystemImageStyle({
      normalColor: colors.labelColor.secondary,
      highlightColor: colors.labelColor.secondary,
      fontSize: fonts.standardButtonImageFontSize,
    } + params, isDark)
  else
    utils.newTextStyle({
      normalColor: colors.labelColor.secondary,
      highlightColor: colors.labelColor.secondary,
      fontSize: fonts.standardButtonTextFontSize,
    } + params, isDark) + getKeyboardActionText(params);

// 大写字母键按钮前景样式
local newAlphabeticButtonUppercaseForegroundStyle(isDark=false, params={}) =
  utils.newTextStyle({
    normalColor: colors.standardButtonForegroundColor,
    highlightColor: colors.standardButtonHighlightedForegroundColor,
    fontSize: fonts.standardButtonUppercasedTextFontSize,
  } + params, isDark);

// 字母提示背景样式
local alphabeticHintBackgroundStyleName = 'alphabeticHintBackgroundStyle';
local newAlphabeticHintBackgroundStyle(isDark=false, params={}) = {
  [alphabeticHintBackgroundStyleName]: utils.newGeometryStyle({
    normalColor: colors.standardCalloutBackgroundColor,
    normalBorderColor: colors.standardCalloutBorderColor,
    borderSize: 0.5,
  } + params, isDark),
};

// 字母提示前景样式
local newAlphabeticButtonHintStyle(isDark=false, params={}) =
  utils.newTextStyle({
    normalColor: colors.standardCalloutForegroundColor,
    fontSize: fonts.hintTextFontSize,
  } + params, isDark);

// 系统功能键按钮背景样式
local systemButtonBackgroundStyleName = 'systemButtonBackgroundStyle';
local newSystemButtonBackgroundStyle(isDark=false, params={}) = {
  [systemButtonBackgroundStyleName]: utils.newGeometryStyle({
    insets: keyboardParams.keyboard.button.backgroundInsets.iPhone.portrait,
    normalColor: colors.systemButtonBackgroundColor,
    highlightColor: colors.systemButtonHighlightedBackgroundColor,
    cornerRadius: buttonCornerRadius,
  } + params, isDark),
};

local enterButtonForegroundStyleName = 'enterButtonForegroundStyle';
local newEnterButtonForegroundStyle(isDark=false, params={}) = {
  [enterButtonForegroundStyleName]: utils.newTextStyle({
    normalColor: colors.systemButtonForegroundColor,
    highlightColor: colors.systemButtonHighlightedForegroundColor,
    fontSize: fonts.systemButtonTextFontSize,
  } + params, isDark) + getKeyboardActionText(params),
};

// 九键确认键「已上屏内容」蓝色样式
local blueButtonBackgroundStyleName = 'blueButtonBackgroundStyle';
local newBlueButtonBackgroundStyle(isDark=false, params={}) = {
  [blueButtonBackgroundStyleName]: utils.newGeometryStyle({
    insets: keyboardParams.keyboard.button.backgroundInsets.iPhone.portrait,
    normalColor: colors.blueButtonBackgroundColor,
    highlightColor: colors.blueButtonHighlightedBackgroundColor,
    cornerRadius: buttonCornerRadius,
  } + params, isDark),
};

// 九键确认键蓝色状态下的文案。
// 注意：preeditChanged 通知的上下文里没有回车键类型，
// 直接使用 `$returnKeyType` 会回落成固定「确定」，
// 因此这里按系统回车键类型（UIReturnKeyType 原始值）生成条件样式，
// 每种类型对应一份固定文案的白字样式。
// 索引与 UIReturnKeyType 原始值一致：
// 0 default / 1 go / 2 google / 3 join / 4 next / 5 route
// 6 search / 7 send / 8 yahoo / 9 done / 10 emergencyCall / 11 continue
local t9ConfirmBlueLabelByReturnKey = [
  '换行',
  '前往',
  'Google',
  '加入',
  'next',
  'route',
  '搜索',
  '发送',
  'Yahoo',
  '完成',
  'emergencyCall',
  'continue',
];

local t9ConfirmBlueTextStylePrefix = 't9ConfirmBlueTextStyle';

local newT9ConfirmBlueTextStyles(isDark=false) = {
  [t9ConfirmBlueTextStylePrefix + std.toString(i)]: utils.newTextStyle({
    normalColor: colors.blueButtonForegroundColor,
    highlightColor: colors.blueButtonHighlightedForegroundColor,
    fontSize: fonts.systemButtonTextFontSize,
    text: t9ConfirmBlueLabelByReturnKey[i],
  }, isDark)
  for i in std.range(0, std.length(t9ConfirmBlueLabelByReturnKey) - 1)
};

local t9ConfirmBlueForegroundStyleConditions = [
  {
    conditionKey: '$returnKeyType',
    conditionValue: [i],
    styleName: t9ConfirmBlueTextStylePrefix + std.toString(i),
  }
  for i in std.range(0, std.length(t9ConfirmBlueLabelByReturnKey) - 1)
];


// 文本文字系统功能键按钮前景样式
local newTextSystemButtonForegroundStyle(isDark=false, params={}) =
  utils.newTextStyle({
    normalColor: colors.systemButtonForegroundColor,
    highlightColor: colors.systemButtonHighlightedForegroundColor,
    fontSize: fonts.systemButtonTextFontSize,
  } + params, isDark);

local newImageSystemButtonForegroundStyle(isDark=false, params={}) =
  utils.newSystemImageStyle({
    normalColor: colors.systemButtonForegroundColor,
    highlightColor: colors.systemButtonHighlightedForegroundColor,
    fontSize: fonts.systemButtonImageFontSize,
  } + params, isDark);

local newAssetImageSystemButtonForegroundStyle(isDark=false, params={}) =
  utils.newAssetImageStyle({
    normalColor: colors.systemButtonForegroundColor,
    highlightColor: colors.systemButtonHighlightedForegroundColor,
    fontSize: fonts.systemButtonImageFontSize,
  } + params, isDark);


local newAlphabeticButton(name, isDark=false, params={}, needHint=true) =
  {
    [name]: utils.newBackgroundStyle(style=alphabeticButtonBackgroundStyleName)
            + (
              if std.objectHas(params, 'foregroundStyleName') then
                { foregroundStyle: params.foregroundStyleName }
              else
                utils.newForegroundStyle(style=name + 'ForegroundStyle')
            )
            + (
              if std.objectHas(params, 'uppercasedStateAction') then
                utils.newForegroundStyle('uppercasedStateForegroundStyle', name + 'UppercaseForegroundStyle')
              else {}
            )
            + (
              if needHint then
                utils.newForegroundStyle('hintStyle', name + 'HintStyle')
              else {

              }
            )
            + utils.extractProperties(
              params,
              [
                'size',
                'bounds',
                'action',
                'uppercasedStateAction',
                'repeatAction',
                'preeditStateAction',
                'swipeUpAction',
                'swipeDownAction',
                'swipeLeftAction',
                'swipeRightAction',
                'capsLockedStateForegroundStyle',
                'preeditStateForegroundStyle',
                'notification',
              ]
            ),
  }
  + (
    if std.objectHas(params, 'foregroundStyle') then
      params.foregroundStyle
    else
      { [name + 'ForegroundStyle']: newAlphabeticButtonForegroundStyle(isDark, params) }
  )
  + (
    if std.objectHas(params, 'uppercasedStateAction') then
      {

        [name + 'UppercaseForegroundStyle']: newAlphabeticButtonUppercaseForegroundStyle(isDark, params) + getKeyboardActionText(params, 'uppercasedStateAction'),
      }
    else {}
  )
  + (
    if needHint then
      {

        [name + 'HintStyle']:
          (
            if std.objectHas(params, 'hintStyle') then
              params.hintStyle
            else
              {}
          )
          + utils.newBackgroundStyle(style=alphabeticHintBackgroundStyleName)
          + utils.newForegroundStyle(style=name + 'HintForegroundStyle'),
        [name + 'HintForegroundStyle']: newAlphabeticButtonHintStyle(isDark, params) + getKeyboardActionText(params, isUppercase=true),
      }
    else
      {}
  );

local newSystemButton(name, isDark=false, params={}) =
  {
    [name]: (
              if std.objectHas(params, 'backgroundStyle') then
                { backgroundStyle: params.backgroundStyle }
              else
                utils.newBackgroundStyle(style=systemButtonBackgroundStyleName)

            )
            + (
              if std.objectHas(params, 'foregroundStyle') then
                { foregroundStyle: params.foregroundStyle }
              else
                utils.newForegroundStyle(style=name + 'ForegroundStyle')
            )
            + utils.extractProperties(
              params,
              [
                'size',
                'bounds',
                'action',
                'uppercasedStateAction',
                'repeatAction',
                'preeditStateAction',
                'swipeUpAction',
                'swipeDownAction',
                'swipeLeftAction',
                'swipeRightAction',
                'uppercasedStateForegroundStyle',
                'capsLockedStateForegroundStyle',
                'preeditStateForegroundStyle',
                'notification',
              ]
            ),
  }
  + {
    [name + 'ForegroundStyle']: (
      if std.objectHas(params, 'systemImageName') then
        newImageSystemButtonForegroundStyle(isDark, params)
      else if std.objectHas(params, 'assetImageName') then
        newAssetImageSystemButtonForegroundStyle(isDark, params)
      else
        newTextSystemButtonForegroundStyle(isDark, params) + getKeyboardActionText(params)
    ),
  };


// 回车键类型变化通知：只刷新文案（前往/搜索/发送/换行等），不改变按键颜色
local returnKeyboardTypeChangedNotification = {
  returnKeyTypeChangedNotification: {
    notificationType: 'returnKeyType',
    returnKeyType: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11],
    backgroundStyle: systemButtonBackgroundStyleName,
    foregroundStyle: enterButtonForegroundStyleName,
  },
};

local commitCandidateForegroundStyleName = 'commitCandidateForegroundStyle';
local preeditChangedForSpaceButtonNotification = {
  preeditChangedForSpaceButtonNotification: {
    notificationType: 'preeditChanged',
    backgroundStyle: alphabeticButtonBackgroundStyleName,
    foregroundStyle: commitCandidateForegroundStyleName,
  },
};

// 九键确认键蓝色激活通知：
// 监听预编辑文本出现（开始打拼音），命中后锁定蓝色样式。
// 这样空格上屏、点候选字上屏都能处在这个蓝色状态。
// 前景用条件样式按回车键类型选择文案，避免蓝色状态固定显示「确定」。
local t9ConfirmBlueNotification = {
  t9ConfirmBlueNotification: {
    notificationType: 'preeditChanged',
    lockedNotificationMatchState: true,
    backgroundStyle: blueButtonBackgroundStyleName,
    foregroundStyle: t9ConfirmBlueForegroundStyleConditions,
  },
};

local newCommitCandidateForegroundStyle(isDark=false, params={}) = {
  [commitCandidateForegroundStyleName]: utils.newTextStyle({
    normalColor: colors.standardButtonForegroundColor,
    highlightColor: colors.standardButtonHighlightedForegroundColor,
    fontSize: fonts.systemButtonTextFontSize,
  } + params, isDark) + params,
};

// 九键横向拼音列表的单元格样式
local t9PinyinCellStyleName = 't9PinyinCellStyle';
local t9PinyinCellBackgroundStyleName = 't9PinyinCellBackgroundStyle';
local t9PinyinCellForegroundStyleName = 't9PinyinCellForegroundStyle';

local newT9PinyinCellStyles(isDark=false, fontSize=17) = {
  [t9PinyinCellStyleName]: {
    backgroundStyle: t9PinyinCellBackgroundStyleName,
    foregroundStyle: t9PinyinCellForegroundStyleName,
    // 控制九键拼音词组的横向间距（集合单元格内边距）
    insets: { left: 24, right: 24 },
  },
  [t9PinyinCellBackgroundStyleName]: utils.newGeometryStyle({
    normalColor: '#00000000',
    highlightColor: colors.labelColor.quaternary,
    cornerRadius: 6,
  }, isDark),
  [t9PinyinCellForegroundStyleName]: utils.newTextStyle({
    normalColor: colors.standardButtonForegroundColor,
    highlightColor: colors.standardButtonForegroundColor,
    fontSize: fontSize,
  }, isDark),
};

// 九键 1 键在预编辑（正在输入拼音）时显示为「分隔」
local t9SeparatorForegroundStyleName = 't9SeparatorForegroundStyle';
local t9OneButtonPreeditNotificationName = 't9OneButtonPreeditNotification';

local newT9OneButtonPreeditStyles(isDark=false, fontSize=17) = {
  [t9SeparatorForegroundStyleName]: utils.newTextStyle({
    normalColor: colors.standardButtonForegroundColor,
    highlightColor: colors.standardButtonHighlightedForegroundColor,
    fontSize: fontSize,
    text: '分隔',
  }, isDark),
  [t9OneButtonPreeditNotificationName]: {
    notificationType: 'preeditChanged',
    backgroundStyle: alphabeticButtonBackgroundStyleName,
    foregroundStyle: t9SeparatorForegroundStyleName,
    action: { character: '1' },
    swipeUpAction: { symbol: '1' },
  },
};


{
  keyboardBackgroundStyleName: keyboardBackgroundStyleName,
  newKeyboardBackgroundStyle: newKeyboardBackgroundStyle,

  alphabeticButtonBackgroundStyleName: alphabeticButtonBackgroundStyleName,
  newAlphabeticButtonBackgroundStyle: newAlphabeticButtonBackgroundStyle,

  newAlphabeticButtonForegroundStyle: newAlphabeticButtonForegroundStyle,
  newAlphabeticButtonSwipeForegroundStyle: newAlphabeticButtonSwipeForegroundStyle,

  newAlphabeticButtonUppercaseForegroundStyle: newAlphabeticButtonUppercaseForegroundStyle,

  alphabeticHintBackgroundStyleName: alphabeticHintBackgroundStyleName,
  newAlphabeticHintBackgroundStyle: newAlphabeticHintBackgroundStyle,

  newAlphabeticButtonHintStyle: newAlphabeticButtonHintStyle,

  systemButtonBackgroundStyleName: systemButtonBackgroundStyleName,
  newSystemButtonBackgroundStyle: newSystemButtonBackgroundStyle,

  newTextSystemButtonForegroundStyle: newTextSystemButtonForegroundStyle,
  newImageSystemButtonForegroundStyle: newImageSystemButtonForegroundStyle,

  newAlphabeticButton: newAlphabeticButton,
  getKeyboardActionText: getKeyboardActionText,

  newSystemButton: newSystemButton,

  newEnterButtonForegroundStyle: newEnterButtonForegroundStyle,
  newCommitCandidateForegroundStyle: newCommitCandidateForegroundStyle,

  // 九键确认键蓝色激活样式
  blueButtonBackgroundStyleName: blueButtonBackgroundStyleName,
  newBlueButtonBackgroundStyle: newBlueButtonBackgroundStyle,
  t9ConfirmBlueTextStylePrefix: t9ConfirmBlueTextStylePrefix,
  newT9ConfirmBlueTextStyles: newT9ConfirmBlueTextStyles,
  t9ConfirmBlueForegroundStyleConditions: t9ConfirmBlueForegroundStyleConditions,

  // 九键横向拼音列表
  t9PinyinCellStyleName: t9PinyinCellStyleName,
  newT9PinyinCellStyles: newT9PinyinCellStyles,

  // 九键 1 键「分隔」状态
  t9OneButtonPreeditNotificationName: t9OneButtonPreeditNotificationName,
  newT9OneButtonPreeditStyles: newT9OneButtonPreeditStyles,

  // notification
  returnKeyboardTypeChangedNotification: returnKeyboardTypeChangedNotification,
  t9ConfirmBlueNotification: t9ConfirmBlueNotification,
  preeditChangedForSpaceButtonNotification: preeditChangedForSpaceButtonNotification,
}
