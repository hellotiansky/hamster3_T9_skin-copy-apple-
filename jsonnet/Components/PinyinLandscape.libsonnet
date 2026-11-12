local t9Keyboard = import 'T9Keyboard.libsonnet';

{
  new(isDark=false, isPortrait=false): t9Keyboard.new(isDark, isPortrait),
}
