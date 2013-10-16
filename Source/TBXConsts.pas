unit TBXConsts;

interface

{$I TB2Ver.inc}

resourcestring

  { Exceptions }
  STBXCannotInsertIntoMultiDock = 'Cannot insert %s into TTBXMultiDock';
  STBXCannotInsertOwnParent = 'Cannot insert own parent';

  { Themes }
  STBXCannotRegisterTheme = 'Cannot register theme';
  STBXThemeAlreadyRegistered = 'Theme %s is already registered';
  STBXCannotUnregisterUnknownTheme = 'Cannot unregister unknown theme %s';
  STBXUnknownTheme = 'Unknown theme %s';
  STBXCannotReleaseTheme = 'Cannot release theme %s';

  { TTBXCustomSpinEditItem }
  STBXSpinEditItemIncrementError = 'Increment should be a positive value';
  STBXSpinEditItemPostfixError = 'Invalid postfix';
  STBXSpinEditItemPrefixError = 'Invalid prefix';

  { TTBXSubmenuItem }
  STBXAutoEmptyItemCaption = '(Empty)';

  { TTBXDragHandleItem }
  STBXDragHandleItemHint = 'Drag to make this menu float|';

implementation

end.
