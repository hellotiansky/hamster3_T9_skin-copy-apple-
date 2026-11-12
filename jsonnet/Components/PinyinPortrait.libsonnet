local t9Keyboard = import 'T9Keyboard.libsonnet';

{
  new(isDark=false, isPortrait=true): t9Keyboard.new(isDark, isPortrait),
}
