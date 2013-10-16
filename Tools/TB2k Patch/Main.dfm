object Form_Main: TForm_Main
  Left = 230
  Top = 130
  Caption = 'Toolbar2000 v2.2.2 Patch'
  ClientHeight = 293
  ClientWidth = 618
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Memo_Output: TMemo
    Left = 0
    Top = 33
    Width = 618
    Height = 260
    Align = alClient
    Color = 4207920
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 16773344
    Font.Height = -13
    Font.Name = 'Courier'
    Font.Style = []
    Lines.Strings = (
      'To start patching, please click the button above and select '
      'the folder where Toolbar2000 v2.2.2 is located...')
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Panel_Top: TPanel
    Left = 0
    Top = 0
    Width = 618
    Height = 33
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object Button_Select: TButton
      Left = 8
      Top = 5
      Width = 177
      Height = 23
      Caption = 'Select Toolbar2000 location...'
      TabOrder = 0
      OnClick = Button_SelectClick
    end
  end
end
