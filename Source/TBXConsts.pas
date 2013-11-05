{*
 * TBX Package
 * Copyright 2001-2013 Alex A. Denisov and contributors. All rights reserved.
 *
 * The MIT License (MIT)
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom
 * the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 *}

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
