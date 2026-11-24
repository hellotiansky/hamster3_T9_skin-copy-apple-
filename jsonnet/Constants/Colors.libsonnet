// 标签颜色常量定义
local labelColor = {
  primary: {
    light: '#000000',
    dark: '#FFFFFF',
  },
  secondary: {
    light: '#3c3c4399',
    dark: '#ebebf599',
  },
  tertiary: {
    light: '#3c3c434d',
    dark: '#ebebf54d',
  },
  quaternary: {
    light: '#3c3c432e',
    dark: '#ebebf529',
  },
};

// 分割线颜色
local separatorColor = {
  light: '#C6C6C8',
  dark: '#38383A',
};

// 键盘背景色（浅色使用苹果键盘的灰色，深色保持原来的透明效果）
local keyboardBackgroundColor = {
  light: '#D0D3DA',
  dark: '#00000003',
};

// 标准按键背景色（如字母按键、空格键等）
local standardButtonBackgroundColor = {
  light: '#FFFFFF',
  dark: '#707070',
};

// 标准按键按下时的背景色
local standardButtonHighlightedBackgroundColor = {
  light: '#E6E6E6',
  dark: '#4C4C4C',
};

// 标准按键前景色（如字母按键、空格键等），用于按键的字体，图片等
local standardButtonForegroundColor = labelColor.primary;

local standardButtonHighlightedForegroundColor = standardButtonForegroundColor;

// 标准按键阴影颜色
local standardButtonShadowColor = {
  light: '#898A8D',
  dark: '#000000',
};

// 系统按键（如回车、删除等）背景颜色
local systemButtonBackgroundColor = {
  light: '#A9AFBB',
  dark: '#4C4C4C',
};

local systemButtonHighlightedBackgroundColor = {
  light: '#C3C8D1',
  dark: '#707070',
};

// 系统按键（如回车、删除等）前景颜色
local systemButtonForegroundColor = labelColor.primary;

local systemButtonHighlightedForegroundColor = systemButtonForegroundColor;

local blueButtonBackgroundColor = {
  light: '#007AFF',
  dark: '#0A84FF',
};

// 蓝色按键按下时的背景色（比常态稍亮，模仿系统蓝色按键的按压反馈）
local blueButtonHighlightedBackgroundColor = {
  light: '#4A9FFF',
  dark: '#4DA3FF',
};

local blueButtonForegroundColor = {
  light: '#FFFFFF',
  dark: '#FFFFFF',
};

local blueButtonHighlightedForegroundColor = {
  light: '#FFFFFF',
  dark: '#FFFFFF',
};

// 按键底部边缘颜色
local lowerEdgeOfButtonNormalColor = {
  light: '#88898D',
  dark: '#000000',
};

// 按下状态下，按键底部边缘颜色
local lowerEdgeOfButtonHighlightColor = {
  light: '#88898D',
  dark: '#000000',
};

// 标准按键 Hint 背景色(包含长按符号列表的背景色)
local standardCalloutBackgroundColor = standardButtonBackgroundColor;

// 标准按键 Hint 前景色，用于按键的字体，图片等
local standardCalloutForegroundColor = standardButtonForegroundColor;

local standardCalloutHighlightedForegroundColor = {
  light: '#FFFFFF',
  dark: '#FFFFFF',
};

// 标准按键 Hint 选中背景色，如长按符号列表中选中的符号背景色
local standardCalloutSelectedBackgroundColor = blueButtonBackgroundColor;

// 标准按键 Hint 边框颜色
local standardCalloutBorderColor = {
  light: '#C6C6C8',
  dark: '#69686A',
};

// 预编辑区文字颜色
local preeditForegroundColor = standardButtonForegroundColor;

// 工具栏按钮前景色
local toolbarButtonForegroundColor = standardButtonForegroundColor;

// 工具栏按钮高亮前景色
local toolbarButtonHighlightedForegroundColor = standardButtonForegroundColor;

// 候选字亮候选字背景颜色
local candidateHighlightColor = {
  light: '#F7F8FA',
  dark: standardButtonBackgroundColor.dark,
};
local candidateForegroundColor = standardButtonForegroundColor;

// 候选字分隔线颜色
local candidateSeparatorColor = separatorColor;


// 拼音栏与候选词栏之间的分隔线（取自 iOS 17.6 原生九键截图实测）：
//  浅色：不透明 #8C8C8C（系统键盘底色 #D0D3D9 上）
//  深色：黑色 70% 不透明（#000000B3），叠在毛玻璃背景上，整条线始终是背景亮度的 30%
//  粗细：1 个物理像素（2 倍屏上即 0.5pt，与 dividerHeight 一致）
local t9PinyinDividerColor = {
  light: '#8C8C8C',
  dark: '#000000B3',
};

{
  labelColor: labelColor,
  separatorColor: separatorColor,
  t9PinyinDividerColor: t9PinyinDividerColor,
  keyboardBackgroundColor: keyboardBackgroundColor,
  standardButtonBackgroundColor: standardButtonBackgroundColor,
  standardButtonHighlightedBackgroundColor: standardButtonHighlightedBackgroundColor,
  standardButtonForegroundColor: standardButtonForegroundColor,
  standardButtonHighlightedForegroundColor: standardButtonHighlightedForegroundColor,
  standardButtonShadowColor: standardButtonShadowColor,
  systemButtonBackgroundColor: systemButtonBackgroundColor,
  systemButtonHighlightedBackgroundColor: systemButtonHighlightedBackgroundColor,
  systemButtonForegroundColor: systemButtonForegroundColor,
  systemButtonHighlightedForegroundColor: systemButtonHighlightedForegroundColor,
  blueButtonBackgroundColor: blueButtonBackgroundColor,
  blueButtonHighlightedBackgroundColor: blueButtonHighlightedBackgroundColor,
  blueButtonForegroundColor: blueButtonForegroundColor,
  blueButtonHighlightedForegroundColor: blueButtonHighlightedForegroundColor,
  lowerEdgeOfButtonNormalColor: lowerEdgeOfButtonNormalColor,
  lowerEdgeOfButtonHighlightColor: lowerEdgeOfButtonHighlightColor,
  standardCalloutBackgroundColor: standardCalloutBackgroundColor,
  standardCalloutForegroundColor: standardCalloutForegroundColor,
  standardCalloutHighlightedForegroundColor: standardCalloutHighlightedForegroundColor,
  standardCalloutSelectedBackgroundColor: standardCalloutSelectedBackgroundColor,
  standardCalloutBorderColor: standardCalloutBorderColor,
  preeditForegroundColor: preeditForegroundColor,
  toolbarButtonForegroundColor: toolbarButtonForegroundColor,
  toolbarButtonHighlightedForegroundColor: toolbarButtonHighlightedForegroundColor,
  candidateHighlightColor: candidateHighlightColor,
  candidateForegroundColor: candidateForegroundColor,
  candidateSeparatorColor: candidateSeparatorColor,
}
