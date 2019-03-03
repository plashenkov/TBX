{*
 * "Professional" Theme for TBX
 * Copyright 2008-2013 Yuri Plashenkov. All rights reserved.
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

unit TBXProfessionalTheme;

interface

{$I TB2Ver.inc}
{$I TBX.inc}

{$DEFINE MENUBAR_LIKE_TOOLBAR}

uses
  Windows, Graphics, ImgList, TBXThemes;

type
  TItemPart = (ipBody, ipText, ipFrame);
  TBtnItemState = (bisNormal, bisDisabled, bisSelected, bisPressed, bisHot,
    bisDisabledHot, bisSelectedHot, bisPopupParent);
  TMenuItemState = (misNormal, misDisabled, misHot, misDisabledHot);
  TWinFramePart = (wfpBorder, wfpCaption, wfpCaptionText);

  TTBXProfessionalTheme = class(TTBXTheme)
  protected
    DockColor: TColor;

    ToolbarColor1: TColor;
    ToolbarColor2: TColor;
    SeparatorColor1: TColor;
    SeparatorColor2: TColor;

    EmbeddedColor: TColor;
    EmbeddedFrameColor: TColor;

    PopupColor: TColor;
    PopupFrameColor: TColor;

    DockPanelColor: TColor;
    DockPanelCaptionColor1: TColor;
    DockPanelCaptionColor2: TColor;
    DockPanelCaptionFrameColor: TColor;

    WinFrameColors: array[TWinFramePart] of TColor;
    MenuItemColors: array[TMenuItemState, TItemPart] of TColor;
    BtnItemColors:  array[TBtnItemState, ipText..ipFrame] of TColor;
    BtnBodyColors:  array[TBtnItemState, Boolean] of TColor;

    StatusBarColor1: TColor;
    StatusBarColor2: TColor;
    StatusPanelFrameColor: TColor;

    procedure SetupColorCache; virtual;
  protected
    { Internal Methods }
    function GetPartColor(const ItemInfo: TTBXItemInfo; ItemPart: TItemPart): TColor;
    function GetBtnColor(const ItemInfo: TTBXItemInfo; ItemPart: TItemPart; GradColor2: Boolean = False): TColor;
  public
    constructor Create(const AName: string); override;
    destructor Destroy; override;

    { Metrics access }
    function  GetBooleanMetrics(Index: Integer): Boolean; override;
    function  GetIntegerMetrics(Index: Integer): Integer; override;
    function  GetImageOffset(Canvas: TCanvas; const ItemInfo: TTBXItemInfo; ImageList: TCustomImageList): TPoint; override;
    function  GetItemColor(const ItemInfo: TTBXItemInfo): TColor; override;
    function  GetItemTextColor(const ItemInfo: TTBXItemInfo): TColor; override;
    function  GetItemImageBackground(const ItemInfo: TTBXItemInfo): TColor; override;
    function  GetPopupShadowType: Integer; override;
    function  GetViewColor(AViewType: Integer): TColor; override;
    procedure GetMargins(MarginID: Integer; out Margins: TTBXMargins); override;
    procedure GetViewBorder(ViewType: Integer; out Border: TPoint); override;
    procedure GetViewMargins(ViewType: Integer; out Margins: TTBXMargins); override;

    { Painting routines }
    procedure PaintBackgnd(Canvas: TCanvas; const ADockRect, ARect, AClipRect: TRect; AColor: TColor; Transparent: Boolean; AViewType: Integer); override;
    procedure PaintButton(Canvas: TCanvas; const ARect: TRect; const ItemInfo: TTBXItemInfo); override;
    procedure PaintCaption(Canvas: TCanvas; const ARect: TRect; const ItemInfo: TTBXItemInfo; const ACaption: string; AFormat: Cardinal; Rotated: Boolean); override;
    procedure PaintCheckMark(Canvas: TCanvas; ARect: TRect; const ItemInfo: TTBXItemInfo); override;
    procedure PaintChevron(Canvas: TCanvas; ARect: TRect; const ItemInfo: TTBXItemInfo); override;
    procedure PaintDock(Canvas: TCanvas; const ClientRect, DockRect: TRect; DockPosition: Integer); override;
    procedure PaintDockPanelNCArea(Canvas: TCanvas; R: TRect; const DockPanelInfo: TTBXDockPanelInfo); override;
    procedure PaintDropDownArrow(Canvas: TCanvas; const ARect: TRect; const ItemInfo: TTBXItemInfo); override;
    procedure PaintEditButton(Canvas: TCanvas; const ARect: TRect; var ItemInfo: TTBXItemInfo; ButtonInfo: TTBXEditBtnInfo); override;
    procedure PaintEditFrame(Canvas: TCanvas; const ARect: TRect; var ItemInfo: TTBXItemInfo; const EditInfo: TTBXEditInfo); override;
    procedure PaintFloatingBorder(Canvas: TCanvas; const ARect: TRect; const WindowInfo: TTBXWindowInfo); override;
    procedure PaintFrame(Canvas: TCanvas; const ARect: TRect; const ItemInfo: TTBXItemInfo); override;
    procedure PaintImage(Canvas: TCanvas; ARect: TRect; const ItemInfo: TTBXItemInfo; ImageList: TCustomImageList; ImageIndex: Integer); override;
    procedure PaintMDIButton(Canvas: TCanvas; ARect: TRect; const ItemInfo: TTBXItemInfo; ButtonKind: Cardinal); override;
    procedure PaintMenuItem(Canvas: TCanvas; const ARect: TRect; var ItemInfo: TTBXItemInfo); override;
    procedure PaintMenuItemFrame(Canvas: TCanvas; const ARect: TRect; const ItemInfo: TTBXItemInfo); override;
    procedure PaintPageScrollButton(Canvas: TCanvas; const ARect: TRect; ButtonType: Integer; Hot: Boolean); override;
    procedure PaintPopupNCArea(Canvas: TCanvas; R: TRect; const PopupInfo: TTBXPopupInfo); override;
    procedure PaintSeparator(Canvas: TCanvas; ARect: TRect; ItemInfo: TTBXItemInfo; Horizontal, LineSeparator: Boolean); override;
    procedure PaintToolbarNCArea(Canvas: TCanvas; R: TRect; const ToolbarInfo: TTBXToolbarInfo); override;
    procedure PaintFrameControl(Canvas: TCanvas; R: TRect; Kind, State: Integer; Params: Pointer); override;
    procedure PaintStatusBar(Canvas: TCanvas; R: TRect; Part: Integer); override;
  end;

implementation

uses Classes, Controls, CommCtrl, Forms, TB2Common, TB2Item, TBXUtils;

procedure PaintGradient(DC: HDC; const ARect: TRect; Color1, Color2: TColor;
  const Horz: Boolean);
var
  r1, g1, b1, r2, g2, b2: Byte;
  I, Size: Integer;
  TempRect: TRect;
begin
  Color1 := ColorToRGB(Color1);
  Color2 := ColorToRGB(Color2);
  if Color1 = Color2 then
    FillRectEx(DC, ARect, Color1)
  else
  begin
    if IsRectEmpty(ARect) then Exit;

    r1 := GetRValue(Color1);
    g1 := GetGValue(Color1);
    b1 := GetBValue(Color1);
    r2 := GetRValue(Color2);
    g2 := GetGValue(Color2);
    b2 := GetBValue(Color2);

    TempRect := ARect;

    if Horz then
    begin
      Size := ARect.Right - ARect.Left;
      TempRect.Right := TempRect.Left + 1;
    end
    else
    begin
      Size := ARect.Bottom - ARect.Top;
      TempRect.Bottom := TempRect.Top + 1;
    end;

    Dec(Size);
    if Size = 0 then Exit;

    for I := 0 to Size do
    begin
      FillRectEx(DC, TempRect, RGB((r2 - r1) * I div Size + r1,
        (g2 - g1) * I div Size + g1, (b2 - b1) * I div Size + b1));
      OffsetRect(TempRect, Ord(Horz), Ord(not Horz));
    end;
  end;
end;

var
  StockImgList: TImageList;
  CounterLock: Integer;

procedure InitializeStock;
begin
  StockImgList := TImageList.Create(nil);
  StockImgList.Handle := ImageList_LoadBitmap(HInstance, 'TBXGLYPHS', 16, 0, clWhite);
end;

procedure FinalizeStock;
begin
  StockImgList.Free;
end;

{ TTBXProfessionalTheme }

function TTBXProfessionalTheme.GetBooleanMetrics(Index: Integer): Boolean;
begin
  Result := Index in [
    TMB_OFFICEXPPOPUPALIGNMENT,
    TMB_EDITMENUFULLSELECT,
    TMB_SOLIDTOOLBARNCAREA,
    TMB_SOLIDTOOLBARCLIENTAREA,
    TMB_PAINTDOCKBACKGROUND
  ];
end;

function TTBXProfessionalTheme.GetIntegerMetrics(Index: Integer): Integer;
begin
  case Index of
    TMI_SPLITBTN_ARROWWIDTH:  Result := 12;

    TMI_DROPDOWN_ARROWWIDTH:  Result := 8;
    TMI_DROPDOWN_ARROWMARGIN: Result := 3;

    TMI_MENU_IMGTEXTSPACE:    Result := 5;
    TMI_MENU_LCAPTIONMARGIN:  Result := 3;
    TMI_MENU_RCAPTIONMARGIN:  Result := 3;
    TMI_MENU_SEPARATORSIZE:   Result := 3;
    TMI_MENU_MDI_DW:          Result := 2;
    TMI_MENU_MDI_DH:          Result := 2;

    TMI_TLBR_SEPARATORSIZE:   Result := 6;

    TMI_EDIT_FRAMEWIDTH:      Result := 1;
    TMI_EDIT_TEXTMARGINHORZ:  Result := 2;
    TMI_EDIT_TEXTMARGINVERT:  Result := 2;
    TMI_EDIT_BTNWIDTH:        Result := 14;
    TMI_EDIT_MENURIGHTINDENT: Result := 1;
  else
    Result := -1;
  end;
end;

function TTBXProfessionalTheme.GetViewColor(AViewType: Integer): TColor;
begin
  Result := DockColor;
  if (AViewType and VT_TOOLBAR) = VT_TOOLBAR then
  begin
    if (AViewType and TVT_MENUBAR) = TVT_MENUBAR then Result := DockColor
    else Result := ToolbarColor1;
  end
  else if (AViewType and VT_POPUP) = VT_POPUP then
  begin
    if (AViewType and PVT_LISTBOX) = PVT_LISTBOX then Result := clWindow
    else Result := PopupColor;
  end
  else if (AViewType and VT_DOCKPANEL) = VT_DOCKPANEL then Result := DockPanelColor;
end;

function TTBXProfessionalTheme.GetBtnColor(const ItemInfo: TTBXItemInfo;
  ItemPart: TItemPart; GradColor2: Boolean = False): TColor;
const
  BFlags1: array[Boolean] of TBtnItemState = (bisDisabled, bisDisabledHot);
  BFlags2: array[Boolean] of TBtnItemState = (bisSelected, bisSelectedHot);
  BFlags3: array[Boolean] of TBtnItemState = (bisNormal, bisHot);
var
  B: TBtnItemState;
  Embedded: Boolean;
begin
  with ItemInfo do
  begin
    Embedded := (ViewType and VT_TOOLBAR = VT_TOOLBAR) and (ViewType and TVT_EMBEDDED = TVT_EMBEDDED);
    if not Enabled then B := BFlags1[HoverKind = hkKeyboardHover]
    else if ItemInfo.IsPopupParent then B := bisPopupParent
    else if Pushed then B := bisPressed
    else if Selected then B := BFlags2[HoverKind <> hkNone]
    else B := BFlags3[HoverKind <> hkNone];
    if ItemPart = ipBody then
      Result := BtnBodyColors[B, GradColor2]
    else
      Result := BtnItemColors[B, ItemPart];
    if Embedded and (Result = clNone) then
    begin
      if ItemPart = ipBody then Result := EmbeddedColor;
      if (ItemPart = ipFrame) and not Selected then Result := EmbeddedFrameColor;
    end;
  end;
end;

function TTBXProfessionalTheme.GetPartColor(const ItemInfo: TTBXItemInfo;
  ItemPart: TItemPart): TColor;
const
  MFlags1: array[Boolean] of TMenuItemState = (misDisabled, misDisabledHot);
  MFlags2: array[Boolean] of TMenuItemState = (misNormal, misHot);
  BFlags1: array[Boolean] of TBtnItemState = (bisDisabled, bisDisabledHot);
  BFlags2: array[Boolean] of TBtnItemState = (bisSelected, bisSelectedHot);
  BFlags3: array[Boolean] of TBtnItemState = (bisNormal, bisHot);
var
  IsMenuItem, Embedded: Boolean;
  M: TMenuItemState;
  B: TBtnItemState;
begin
  with ItemInfo do
  begin
    IsMenuItem := (ViewType and PVT_POPUPMENU = PVT_POPUPMENU) and
      (ItemOptions and IO_TOOLBARSTYLE = 0);
    Embedded := (ViewType and VT_TOOLBAR = VT_TOOLBAR) and
      (ViewType and TVT_EMBEDDED = TVT_EMBEDDED);
    if IsMenuItem then
    begin
      if not Enabled then M := MFlags1[HoverKind = hkKeyboardHover]
      else M := MFlags2[HoverKind <> hkNone];
      Result := MenuItemColors[M, ItemPart];
    end
    else
    begin
      if not Enabled then B := BFlags1[HoverKind = hkKeyboardHover]
      else if ItemInfo.IsPopupParent then B := bisPopupParent
      else if Pushed then B := bisPressed
      else if Selected then B := BFlags2[HoverKind <> hkNone]
      else B := BFlags3[HoverKind <> hkNone];
      if ItemPart = ipBody then
        Result := BtnBodyColors[B, False]
      else
        Result := BtnItemColors[B, ItemPart];
      if Embedded and (Result = clNone) then
      begin
        if ItemPart = ipBody then Result := EmbeddedColor;
        if ItemPart = ipFrame then Result := EmbeddedFrameColor;
      end;
    end;
  end;
end;

function TTBXProfessionalTheme.GetItemColor(const ItemInfo: TTBXItemInfo): TColor;
begin
  Result := GetPartColor(ItemInfo, ipBody);
  if Result = clNone then Result := GetViewColor(ItemInfo.ViewType);
end;

function TTBXProfessionalTheme.GetItemTextColor(const ItemInfo: TTBXItemInfo): TColor;
begin
  Result := GetPartColor(ItemInfo, ipText);
end;

function TTBXProfessionalTheme.GetItemImageBackground(const ItemInfo: TTBXItemInfo): TColor;
begin
  Result := GetBtnColor(ItemInfo, ipBody);
  if Result = clNone then Result := GetViewColor(ItemInfo.ViewType);
end;

procedure TTBXProfessionalTheme.GetViewBorder(ViewType: Integer;
  out Border: TPoint);
const
  XMetrics: array[Boolean] of Integer = (SM_CXDLGFRAME, SM_CXFRAME);
  YMetrics: array[Boolean] of Integer = (SM_CYDLGFRAME, SM_CYFRAME);
var
  Resizable: Boolean;

  procedure SetBorder(X, Y: Integer);
  begin
    Border.X := X;
    Border.Y := Y;
  end;

begin
  if (ViewType and VT_TOOLBAR) = VT_TOOLBAR then
  begin
    if (ViewType and TVT_FLOATING) = TVT_FLOATING then
    begin
      Resizable := (ViewType and TVT_RESIZABLE) = TVT_RESIZABLE;
      Border.X := GetSystemMetrics(XMetrics[Resizable]) - 1;
      Border.Y := GetSystemMetrics(YMetrics[Resizable]) - 1;
    end
    else SetBorder(2, 2);
  end
  else if (ViewType and VT_POPUP) = VT_POPUP then
  begin
    if (ViewType and PVT_POPUPMENU) = PVT_POPUPMENU then Border.X := 1
    else Border.X := 2;
    Border.Y := 2;
  end
  else if (ViewType and VT_DOCKPANEL) = VT_DOCKPANEL then
  begin
    if (ViewType and DPVT_FLOATING) = DPVT_FLOATING then
    begin
      Resizable := (ViewType and DPVT_RESIZABLE) = DPVT_RESIZABLE;
      Border.X := GetSystemMetrics(XMetrics[Resizable]) - 1;
      Border.Y := GetSystemMetrics(YMetrics[Resizable]) - 1;
    end
    else SetBorder(2, 2);
  end
  else SetBorder(0, 0);
end;

procedure TTBXProfessionalTheme.GetMargins(MarginID: Integer;
  out Margins: TTBXMargins);
begin
  with Margins do
    case MarginID of
      MID_TOOLBARITEM:
        begin
          LeftWidth := 2; RightWidth := 2;
          TopHeight := 2; BottomHeight := 2;
        end;

      MID_MENUITEM:
        begin
          LeftWidth := 1; RightWidth := 1;
          TopHeight := 3; BottomHeight := 3;
        end;

      MID_STATUSPANE:
        begin
          LeftWidth := 1; RightWidth := 3;
          TopHeight := 1; BottomHeight := 1;
        end;
    else
      LeftWidth := 0;
      RightWidth := 0;
      TopHeight := 0;
      BottomHeight := 0;
    end;
end;

procedure TTBXProfessionalTheme.PaintBackgnd(Canvas: TCanvas;
  const ADockRect, ARect, AClipRect: TRect; AColor: TColor;
  Transparent: Boolean; AViewType: Integer);
begin
  if AViewType and TVT_EMBEDDED <> TVT_EMBEDDED then
    if (AViewType and TVT_NORMALTOOLBAR = TVT_NORMALTOOLBAR) or
       {$IFDEF MENUBAR_LIKE_TOOLBAR}
       (AViewType and TVT_MENUBAR = TVT_MENUBAR) or
       {$ENDIF}
       (AViewType and TVT_TOOLWINDOW = TVT_TOOLWINDOW) then
    begin
      PaintGradient(Canvas.Handle, ARect, ToolbarColor1, ToolbarColor2,
        ARect.Right <= ARect.Bottom);
      Exit;
    end;

  if not Transparent then FillRectEx(Canvas.Handle, ARect, AColor);
end;

procedure TTBXProfessionalTheme.PaintCaption(Canvas: TCanvas;
  const ARect: TRect; const ItemInfo: TTBXItemInfo; const ACaption: string;
  AFormat: Cardinal; Rotated: Boolean);
var
  R: TRect;
begin
  with ItemInfo, Canvas do
  begin
    R := ARect;
    Brush.Style := bsClear;
    if Font.Color = clNone then Font.Color := GetPartColor(ItemInfo, ipText);
    if not Rotated then
      Windows.DrawText(Handle, PChar(ACaption), Length(ACaption), R, AFormat)
    else
      DrawRotatedText(Handle, ACaption, R, AFormat);
    Brush.Style := bsSolid;
  end;
end;

procedure TTBXProfessionalTheme.PaintCheckMark(Canvas: TCanvas; ARect: TRect;
  const ItemInfo: TTBXItemInfo);
var
  DC: HDC;
  X, Y: Integer;
  C: TColor;
begin
  DC := Canvas.Handle;
  X := (ARect.Left + ARect.Right) div 2 - 2;
  Y := (ARect.Top + ARect.Bottom) div 2 + 1;
  C := GetBtnColor(ItemInfo, ipText);
  if ItemInfo.ItemOptions and IO_RADIO > 0 then
  begin
    RoundRectEx(DC, X - 1, Y - 4, X + 5, Y + 2, 2, 2,
      MixColors(C, ToolbarColor1, 200), clNone);
    RoundRectEx(DC, X - 1, Y - 4, X + 5, Y + 2, 6, 6, C, C);
  end
  else
    PolylineEx(DC, [Point(X - 2, Y - 2), Point(X, Y), Point(X + 4, Y - 4),
      Point(X + 4, Y - 3), Point(X, Y + 1), Point(X - 2, Y - 1), Point(X - 2, Y - 2)], C);
end;

procedure TTBXProfessionalTheme.PaintChevron(Canvas: TCanvas; ARect: TRect;
  const ItemInfo: TTBXItemInfo);
const
  Pattern: array[Boolean, 0..15] of Byte = (
    ($CC, 0, $66, 0, $33, 0, $66, 0, $CC, 0, 0, 0, 0, 0, 0, 0),
    ($88, 0, $D8, 0, $70, 0, $20, 0, $88, 0, $D8, 0, $70, 0, $20, 0));
var
  R2: TRect;
  W, H: Integer;
begin
  R2 := ARect;
  PaintButton(Canvas, ARect, ItemInfo);
  if not ItemInfo.IsVertical then
  begin
    Inc(R2.Top, 4);
    R2.Bottom := R2.Top + 5;
    W := 8;
    H := 5;
  end
  else
  begin
    R2.Left := R2.Right - 9;
    R2.Right := R2.Left + 5;
    W := 5;
    H := 8;
  end;
  DrawGlyph(Canvas.Handle, R2, W, H, Pattern[ItemInfo.IsVertical][0],
    GetPartColor(ItemInfo, ipText));
end;

procedure TTBXProfessionalTheme.PaintEditButton(Canvas: TCanvas;
  const ARect: TRect; var ItemInfo: TTBXItemInfo; ButtonInfo: TTBXEditBtnInfo);
var
  DC: HDC;
  BtnDisabled, BtnHot, BtnPressed, Embedded: Boolean;
  R, BR: TRect;
  X, Y: Integer;
  SaveItemInfoPushed: Boolean;
  C: TColor;
begin
  DC := Canvas.Handle;
  R := ARect;
  Embedded := (ItemInfo.ViewType and VT_TOOLBAR = VT_TOOLBAR) and
    (ItemInfo.ViewType and TVT_EMBEDDED = TVT_EMBEDDED);

  InflateRect(R, 1, 1);
  Inc(R.Left);
  with Canvas do
    if ButtonInfo.ButtonType = EBT_DROPDOWN then
    begin
      BtnDisabled := (ButtonInfo.ButtonState and EBDS_DISABLED) <> 0;
      BtnHot := (ButtonInfo.ButtonState and EBDS_HOT) <> 0;
      BtnPressed := (ButtonInfo.ButtonState and EBDS_PRESSED) <> 0;
      if not BtnDisabled then
      begin
        if BtnPressed or BtnHot or Embedded then PaintButton(Canvas, R, ItemInfo)
        else if (ItemInfo.ViewType and VT_TOOLBAR) = VT_TOOLBAR then
        begin
          R := ARect;
          if not Embedded then
          begin
            FrameRectEx(DC, R, clWindow, False);
            C := clWindow;
          end
          else C := GetBtnColor(ItemInfo, ipFrame);
          DrawLineEx(DC, R.Left - 1, R.Top, R.Left - 1, R.Bottom, C);
        end;
      end;
      PaintDropDownArrow(Canvas, R, ItemInfo);
    end
    else if ButtonInfo.ButtonType = EBT_SPIN then
    begin
      BtnDisabled := (ButtonInfo.ButtonState and EBSS_DISABLED) <> 0;
      BtnHot := (ButtonInfo.ButtonState and EBSS_HOT) <> 0;

      { Upper button }
      BR := R;
      BR.Bottom := (R.Top + R.Bottom + 1) div 2;
      BtnPressed := (ButtonInfo.ButtonState and EBSS_UP) <> 0;
      SaveItemInfoPushed := ItemInfo.Pushed;
      ItemInfo.Pushed := BtnPressed;
      if not BtnDisabled then
      begin
        if BtnPressed or BtnHot or Embedded then PaintButton(Canvas, BR, ItemInfo)
        else if (ItemInfo.ViewType and VT_TOOLBAR) = VT_TOOLBAR then
        begin
          BR.Left := ARect.Left; BR.Top := ARect.Top; BR.Right := ARect.Right;
          if not Embedded then
          begin
            FrameRectEx(DC, BR, clWindow, False);
            C := clWindow;
          end
          else C := GetBtnColor(ItemInfo, ipFrame);
          DrawLineEx(DC, BR.Left - 1, BR.Top, BR.Left - 1, BR.Bottom, C);
        end;
      end;
      X := (BR.Left + BR.Right) div 2;
      Y := (BR.Top + BR.Bottom - 1) div 2;
      Pen.Color := GetPartColor(ItemInfo, ipText);
      Brush.Color := Pen.Color;
      Polygon([Point(X - 2, Y + 1), Point(X + 2, Y + 1), Point(X, Y - 1)]);

      { Lower button }
      BR := R;
      BR.Top := (R.Top + R.Bottom) div 2;
      BtnPressed := (ButtonInfo.ButtonState and EBSS_DOWN) <> 0;
      ItemInfo.Pushed := BtnPressed;
      if not BtnDisabled then
      begin
        if BtnPressed or BtnHot or Embedded then PaintButton(Canvas, BR, ItemInfo)
        else if (ItemInfo.ViewType and VT_TOOLBAR) = VT_TOOLBAR then
        begin
          BR.Left := ARect.Left; BR.Bottom := ARect.Bottom; BR.Right := ARect.Right;
          if not Embedded then
          begin
            FrameRectEx(DC, BR, clWindow, False);
            C := clWindow;
          end
          else C := GetBtnColor(ItemInfo, ipFrame);
          DrawLineEx(DC, BR.Left - 1, BR.Top, BR.Left - 1, BR.Bottom, C);
        end;
      end;
      X := (BR.Left + BR.Right) div 2;
      Y := (BR.Top + BR.Bottom) div 2;
      C := GetPartColor(ItemInfo, ipText);
      PolygonEx(DC, [Point(X - 2, Y - 1), Point(X + 2, Y - 1), Point(X, Y + 1)], C, C);

      ItemInfo.Pushed := SaveItemInfoPushed;
    end;
end;

procedure TTBXProfessionalTheme.PaintEditFrame(Canvas: TCanvas;
  const ARect: TRect; var ItemInfo: TTBXItemInfo; const EditInfo: TTBXEditInfo);
var
  DC: HDC;
  R: TRect;
  W: Integer;
  Embedded: Boolean;
begin
  DC := Canvas.Handle;
  R := ARect;
  PaintFrame(Canvas, R, ItemInfo);
  W := EditFrameWidth;
  InflateRect(R, -W, -W);
  Embedded := (ItemInfo.ViewType and VT_TOOLBAR = VT_TOOLBAR) and
    (ItemInfo.ViewType and TVT_EMBEDDED = TVT_EMBEDDED);
  if not (ItemInfo.Enabled or Embedded) then
    FrameRectEx(DC, R, BtnItemColors[bisDisabled, ipText], False);

  with EditInfo do if RightBtnWidth > 0 then Dec(R.Right, RightBtnWidth - 2);

  if ItemInfo.Enabled then
  begin
    if (ItemInfo.ViewType and VT_TOOLBAR <> VT_TOOLBAR) and
      (GetPartColor(ItemInfo, ipFrame) = clNone) then
      FrameRectEx(DC, R, SeparatorColor1, False)
    else
      FrameRectEx(DC, R, clWindow, False);

    InflateRect(R, -1, -1);
    FillRectEx(DC, R, clWindow);
    if (ItemInfo.ViewType and VT_TOOLBAR <> VT_TOOLBAR) and
      (GetPartColor(ItemInfo, ipFrame) = clNone) then
    begin
      R := ARect;
      InflateRect(R, -1, -1);
      FrameRectEx(DC, R, SeparatorColor1, False);
    end;
  end
  else InflateRect(R, -1, -1);

  with EditInfo do if LeftBtnWidth > 0 then Inc(R.Left, LeftBtnWidth - 2);

  if EditInfo.RightBtnWidth > 0 then
  begin
    R := ARect;
    InflateRect(R, -W, -W);
    R.Left := R.Right - EditInfo.RightBtnWidth;
    PaintEditButton(Canvas, R, ItemInfo, EditInfo.RightBtnInfo);
  end;
end;

procedure TTBXProfessionalTheme.PaintDropDownArrow(Canvas: TCanvas;
  const ARect: TRect; const ItemInfo: TTBXItemInfo);
var
  X, Y: Integer;
begin
  with ARect, Canvas do
  begin
    X := (Left + Right) div 2;
    Y := (Top + Bottom) div 2 - 1;
    Pen.Color := GetPartColor(ItemInfo, ipText);
    Brush.Color := Pen.Color;
    if ItemInfo.IsVertical then
      Polygon([Point(X, Y + 2), Point(X, Y - 2), Point(X - 2, Y)])
    else
      Polygon([Point(X - 2, Y), Point(X + 2, Y), Point(X, Y + 2)]);
  end;
end;

procedure TTBXProfessionalTheme.PaintButton(Canvas: TCanvas; const ARect: TRect;
  const ItemInfo: TTBXItemInfo);
var
  DC: HDC;
  R: TRect;
  tmpColor1, tmpColor2: TColor;
begin
  DC := Canvas.Handle;
  with ItemInfo do
  begin
    R := ARect;
    if ((ItemOptions and IO_DESIGNING) <> 0) and not Selected then
    begin
      if ComboPart = cpSplitRight then Dec(R.Left);
      FrameRectEx(DC, R, clNavy, False);
    end
    else
    begin
      FrameRectEx(DC, R, GetBtnColor(ItemInfo, ipFrame), True);
      if (ComboPart = cpSplitLeft) and IsPopupParent then Inc(R.Right);
      if ComboPart = cpSplitRight then Dec(R.Left);

      tmpColor1 := GetBtnColor(ItemInfo, ipBody);
      tmpColor2 := GetBtnColor(ItemInfo, ipBody, True);

      if (ItemInfo.ViewType and VT_POPUP = VT_POPUP) or
        (ItemInfo.ViewType and VT_TOOLBAR = VT_TOOLBAR) and
        (ItemInfo.ViewType and TVT_EMBEDDED = TVT_EMBEDDED) then
        FillRectEx(DC, R, tmpColor1)
      else if (tmpColor1 <> clNone) and (tmpColor2 <> clNone) then
        PaintGradient(DC, R, tmpColor1, tmpColor2, False);
    end;
    if ComboPart = cpSplitRight then PaintDropDownArrow(Canvas, R, ItemInfo);
  end;
end;

procedure TTBXProfessionalTheme.PaintFloatingBorder(Canvas: TCanvas;
  const ARect: TRect; const WindowInfo: TTBXWindowInfo);

  function GetBtnItemState(BtnState: Integer): TBtnItemState;
  begin
    if not WindowInfo.Active then Result := bisDisabled
    else if (BtnState and CDBS_PRESSED) <> 0 then Result := bisPressed
    else if (BtnState and CDBS_HOT) <> 0 then Result := bisHot
    else Result := bisNormal;
  end;

var
  BtnItemState: TBtnItemState;
  SaveIndex, X, Y: Integer;
  Sz: TPoint;
  R: TRect;
  BodyColor, CaptionColor, CaptionText: TColor;
  IsDockPanel: Boolean;
begin
  with Canvas do
  begin
    IsDockPanel := (WindowInfo.ViewType and VT_DOCKPANEL) = VT_DOCKPANEL;
    BodyColor := Brush.Color;

    if (WRP_BORDER and WindowInfo.RedrawPart) <> 0 then
    begin
      R := ARect;

      if not IsDockPanel then Brush.Color := WinFrameColors[wfpBorder]
      else Brush.Color := WinFrameColors[wfpBorder];

      SaveIndex := SaveDC(Canvas.Handle);
      Sz := WindowInfo.FloatingBorderSize;
      with R, Sz do
        ExcludeClipRect(Canvas.Handle, Left + X, Top + Y, Right - X, Bottom - Y);
      FillRect(R);
      RestoreDC(Canvas.Handle, SaveIndex);
      InflateRect(R, -Sz.X, -Sz.Y);
      Pen.Color := BodyColor;
      with R do
        if not IsDockPanel then
          Canvas.Polyline([
            Point(Left, Top - 1), Point(Right - 1, Top - 1),
            Point(Right, Top), Point(Right, Bottom - 1),
            Point(Right - 1, Bottom),
            Point(Left, Bottom), Point(Left - 1, Bottom - 1),
            Point(Left - 1, Top), Point(Left, Top - 1)])
        else
          Canvas.Polyline([
            Point(Left, Top - 1), Point(Right - 1, Top - 1),
            Point(Right, Top), Point(Right, Bottom),
            Point(Left - 1, Bottom),
            Point(Left - 1, Top), Point(Left, Top - 1)]);
    end;

    if not WindowInfo.ShowCaption then Exit;

    if (WindowInfo.ViewType and VT_TOOLBAR) = VT_TOOLBAR then
    begin
      CaptionColor := WinFrameColors[wfpCaption];
      CaptionText := WinFrameColors[wfpCaptionText];
    end
    else
    begin
      CaptionColor := WinFrameColors[wfpCaption];
      CaptionText := WinFrameColors[wfpCaptionText];
    end;

    { Caption }
    if (WRP_CAPTION and WindowInfo.RedrawPart) <> 0 then
    begin
      R := Rect(0, 0, WindowInfo.ClientWidth, GetSystemMetrics(SM_CYSMCAPTION) - 1);
      with WindowInfo.FloatingBorderSize do OffsetRect(R, X, Y);
      DrawLineEx(Canvas.Handle, R.Left, R.Bottom, R.Right, R.Bottom, BodyColor);

      if ((CDBS_VISIBLE and WindowInfo.CloseButtonState) <> 0) and
        ((WRP_CLOSEBTN and WindowInfo.RedrawPart) <> 0) then
        Dec(R.Right, GetSystemMetrics(SM_CYSMCAPTION) - 1);

      Brush.Color := CaptionColor;
      FillRect(R);
      InflateRect(R, -2, 0);
      Font.Assign(SmCaptionFont);
      Font.Color := CaptionText;
      DrawText(Canvas.Handle, WindowInfo.Caption, -1, R,
        DT_SINGLELINE or DT_VCENTER or DT_END_ELLIPSIS or DT_NOPREFIX);
    end;

    { Close button }
    if (CDBS_VISIBLE and WindowInfo.CloseButtonState) <> 0 then
    begin
      R := Rect(0, 0, WindowInfo.ClientWidth, GetSystemMetrics(SM_CYSMCAPTION) - 1);
      with WindowInfo.FloatingBorderSize do OffsetRect(R, X, Y);
      R.Left := R.Right - (R.Bottom - R.Top);
      DrawLineEx(Canvas.Handle, R.Left - 1, R.Bottom, R.Right, R.Bottom, BodyColor);
      Brush.Color := CaptionColor;
      FillRect(R);
      with R do
      begin
        X := (Left + Right - StockImgList.Width + 1) div 2;
        Y := (Top + Bottom - StockImgList.Height) div 2;
      end;
      BtnItemState := GetBtnItemState(WindowInfo.CloseButtonState);
      FrameRectEx(Canvas.Handle, R, BtnItemColors[BtnItemState, ipFrame], True);
      if FillRectEx(Canvas.Handle, R, BtnBodyColors[BtnItemState, False]) then
        DrawGlyph(Canvas.Handle, X, Y, StockImgList, 0, BtnItemColors[BtnItemState, ipText])
      else
        DrawGlyph(Canvas.Handle, X, Y, StockImgList, 0, CaptionText);
    end;
  end;
end;

procedure TTBXProfessionalTheme.PaintFrame(Canvas: TCanvas; const ARect: TRect;
  const ItemInfo: TTBXItemInfo);
var
  DC: HDC;
  R: TRect;
begin
  DC := Canvas.Handle;
  R := ARect;
  FrameRectEx(DC, R, GetPartColor(ItemInfo, ipFrame), True);
  FillRectEx(DC, R, GetPartColor(ItemInfo, ipBody));
end;

function TTBXProfessionalTheme.GetImageOffset(Canvas: TCanvas;
  const ItemInfo: TTBXItemInfo; ImageList: TCustomImageList): TPoint;
begin
  Result.X := 0;
  Result.Y := 0;
end;

procedure TTBXProfessionalTheme.PaintImage(Canvas: TCanvas; ARect: TRect;
  const ItemInfo: TTBXItemInfo; ImageList: TCustomImageList; ImageIndex: Integer);
begin
  with ItemInfo do
    if ImageList is TTBCustomImageList then
      TTBCustomImageList(ImageList).DrawState(Canvas, ARect.Left, ARect.Top,
        ImageIndex, Enabled, (HoverKind <> hkNone), Selected)
    else if Enabled then
      DrawTBXIcon(Canvas, ARect, ImageList, ImageIndex, False)
    else
      DrawTBXIconShadow(Canvas, ARect, ImageList, ImageIndex, 0);
end;

procedure TTBXProfessionalTheme.PaintMDIButton(Canvas: TCanvas; ARect: TRect;
  const ItemInfo: TTBXItemInfo; ButtonKind: Cardinal);
var
  Index: Integer;
begin
  PaintButton(Canvas, ARect, ItemInfo);
  Dec(ARect.Bottom);
  case ButtonKind of
    DFCS_CAPTIONMIN: Index := 2;
    DFCS_CAPTIONRESTORE: Index := 3;
    DFCS_CAPTIONCLOSE: Index := 0;
  else
    Exit;
  end;
  DrawGlyph(Canvas.Handle, ARect, StockImgList, Index, GetPartColor(ItemInfo, ipText));
end;

procedure TTBXProfessionalTheme.PaintMenuItemFrame(Canvas: TCanvas;
  const ARect: TRect; const ItemInfo: TTBXItemInfo);
var
  R: TRect;
begin
  R := ARect;
  if ItemInfo.ViewType and PVT_TOOLBOX <> PVT_TOOLBOX then
  begin
    R.Right := R.Left + ItemInfo.PopupMargin + 2;
    PaintGradient(Canvas.Handle, R, ToolbarColor1, ToolbarColor2, True);
    Inc(R.Left);
    R.Right := ARect.Right - 1;
  end;
  PaintFrame(Canvas, R, ItemInfo);
end;

procedure TTBXProfessionalTheme.PaintMenuItem(Canvas: TCanvas;
  const ARect: TRect; var ItemInfo: TTBXItemInfo);
var
  DC: HDC;
  R: TRect;
  X, Y: Integer;
  ArrowWidth: Integer;
  C, ClrText: TColor;
begin
  DC := Canvas.Handle;
  with ItemInfo do
  begin
    ArrowWidth := GetSystemMetrics(SM_CXMENUCHECK);
    PaintMenuItemFrame(Canvas, ARect, ItemInfo);
    ClrText := GetPartColor(ItemInfo, ipText);
    R := ARect;

    if (ItemOptions and IO_COMBO) <> 0 then
    begin
      X := R.Right - ArrowWidth - 1;
      if not ItemInfo.Enabled then C := ClrText
      else if HoverKind = hkMouseHover then C := GetPartColor(ItemInfo, ipFrame)
      else C := PopupFrameColor;
      DrawLineEx(DC, X, R.Top + 1, X, R.Bottom - 1, C);
    end;

    if (ItemOptions and IO_SUBMENUITEM) <> 0 then
    begin
      Y := ARect.Bottom div 2;
      X := ARect.Right - ArrowWidth * 2 div 3 - 1;
      PolygonEx(DC, [Point(X, Y - 3), Point(X, Y + 3), Point(X + 3, Y)], ClrText, ClrText);
    end;

    if Selected and Enabled then
    begin
      R := ARect;
      R.Left := ARect.Left + 1;
      R.Right := R.Left + ItemInfo.PopupMargin;
      InflateRect(R, -1, -1);
      FrameRectEx(DC, R, GetBtnColor(ItemInfo, ipFrame), True);
      FillRectEx(DC, R, GetBtnColor(ItemInfo, ipBody));
    end;
  end;
end;

procedure TTBXProfessionalTheme.PaintPopupNCArea(Canvas: TCanvas; R: TRect;
  const PopupInfo: TTBXPopupInfo);
var
  PR: TRect;
begin
  with Canvas do
  begin
    Brush.Color := PopupFrameColor;
    FrameRect(R);
    InflateRect(R, -1, -1);
    Brush.Color := PopupColor;
    FillRect(R);

    if not IsRectEmpty(PopupInfo.ParentRect) then
    begin
      PR := PopupInfo.ParentRect;
      if not IsRectEmpty(PR) then with PR do
      begin
        Pen.Color := PopupColor;
        if Bottom = R.Top then
        begin
          if Left <= R.Left then Left := R.Left - 1;
          if Right >= R.Right then Right := R.Right + 1;
          MoveTo(Left + 1, Bottom - 1); LineTo(Right - 1, Bottom - 1);
        end
        else if Top = R.Bottom then
        begin
          if Left <= R.Left then Left := R.Left - 1;
          if Right >= R.Right then Right := R.Right + 1;
          MoveTo(Left + 1, Top); LineTo(Right - 1, Top);
        end;
        if Right = R.Left then
        begin
          if Top <= R.Top then Top := R.Top - 1;
          if Bottom >= R.Bottom then Bottom := R.Bottom + 1;
          MoveTo(Right - 1, Top + 1); LineTo(Right - 1, Bottom - 1);
        end
        else if Left = R.Right then
        begin
          if Top <= R.Top then Top := R.Top - 1;
          if Bottom >= R.Bottom then Bottom := R.Bottom + 1;
          MoveTo(Left, Top + 1); LineTo(Left, Bottom - 1);
        end;
      end;
    end;
  end;
end;

procedure TTBXProfessionalTheme.PaintSeparator(Canvas: TCanvas; ARect: TRect;
  ItemInfo: TTBXItemInfo; Horizontal, LineSeparator: Boolean);
var
  DC: HDC;
  IsToolbox: Boolean;
  R: TRect;
  NewWidth: Integer;
begin
  { Note: for blank separators, Enabled = False }
  DC := Canvas.Handle;
  with ItemInfo, ARect do
  begin
    if Horizontal then
    begin
      IsToolbox := (ViewType and PVT_TOOLBOX) = PVT_TOOLBOX;
      if ((ItemOptions and IO_TOOLBARSTYLE) = 0) and not IsToolBox then
      begin
        R := ARect;
        R.Right := ItemInfo.PopupMargin + 2;
        PaintGradient(DC, R, ToolbarColor1, ToolbarColor2, True);
        Inc(Left, ItemInfo.PopupMargin + 9);
        Top := (Top + Bottom) div 2;
        if Enabled then DrawLineEx(DC, Left, Top, Right, Top, SeparatorColor1);
      end
      else
      begin
        Top := (Top + Bottom) div 2;
        Right := Right + 1;
        NewWidth := Round(0.6 * (Right - Left));
        Left := (Right - Left - NewWidth) div 2;
        Right := Left + NewWidth;
        if Enabled then
        begin
          DrawLineEx(DC, Left, Top, Right, Top, SeparatorColor1);
          OffsetRect(ARect, 1, 1);
          DrawLineEx(DC, Left, Top, Right, Top, SeparatorColor2);
        end;
      end;
    end
    else if Enabled then
    begin
      Left := (Left + Right) div 2;
      Bottom := Bottom + 1;
      NewWidth := Round(0.6 * (Bottom - Top));
      Top := (Bottom - Top - NewWidth) div 2;
      Bottom := Top + NewWidth;
      DrawLineEx(DC, Left, Top, Left, Bottom, SeparatorColor1);
      OffsetRect(ARect, 1, 1);
      DrawLineEx(DC, Left, Top, Left, Bottom, SeparatorColor2);
    end;
  end;
end;

procedure DrawButtonBitmap(DC: HDC; R: TRect; Color: TColor);
const
  Pattern: array[0..15] of Byte =
    ($C3, 0, $66, 0, $3C, 0, $18, 0, $3C, 0, $66, 0, $C3, 0, 0, 0);
begin
  DrawGlyph(DC, R, 8, 7, Pattern[0], Color);
end;

procedure TTBXProfessionalTheme.PaintToolbarNCArea(Canvas: TCanvas; R: TRect;
  const ToolbarInfo: TTBXToolbarInfo);
const
  DragHandleOffsets: array[Boolean, DHS_DOUBLE..DHS_SINGLE] of Integer = ((2, 0, 1), (5, 0, 5));

  function GetBtnItemState(BtnState: Integer): TBtnItemState;
  begin
    if (BtnState and CDBS_PRESSED) <> 0 then Result := bisPressed
    else if (BtnState and CDBS_HOT) <> 0 then Result := bisHot
    else Result := bisNormal;
  end;

  procedure DrawHandleElement(const P: TPoint);
  begin
    Canvas.Brush.Color := SeparatorColor2;
    Canvas.FillRect(Rect(P.X + 1, P.Y + 1, P.X + 3, P.Y + 3));
    Canvas.Brush.Color := SeparatorColor1;
    Canvas.FillRect(Rect(P.X, P.Y, P.X + 2, P.Y + 2));
  end;

var
  Sz: Integer;
  R2: TRect;
  I: Integer;
  BtnVisible, Horz: Boolean;
  BtnItemState: TBtnItemState;
  IsMenuBar: Boolean;
begin
  Horz := not ToolbarInfo.IsVertical;
  {$IFDEF MENUBAR_LIKE_TOOLBAR}
  IsMenuBar := False;
  {$ELSE}
  IsMenuBar := (ToolbarInfo.ViewType and TVT_MENUBAR = TVT_MENUBAR);
  {$ENDIF}

  with Canvas do
  begin
    FillRectEx(Handle, R, DockColor);
    if (ToolbarInfo.BorderStyle = bsSingle) and not IsMenuBar then
    begin
      Pen.Style := psSolid;
      if Horz then
      begin
        InflateRect(R, -1, 0);

        { Left }
        PaintGradient(Handle, Rect(R.Left - 1, R.Top, R.Left + 1, R.Bottom),
          ToolbarColor1, ToolbarColor2, False);
        { Right }
        PaintGradient(Handle, Rect(R.Right - 1, R.Top, R.Right + 1, R.Bottom),
          ToolbarColor1, ToolbarColor2, False);
        { Top }
        FillRectEx(Handle, Rect(R.Left, R.Top, R.Right, R.Top + 2), ToolbarColor1);
        { Bottom }
        FillRectEx(Handle, Rect(R.Left, R.Bottom - 2, R.Right, R.Bottom), ToolbarColor2);

        Inc(R.Top);
      end
      else
      begin
        InflateRect(R, 0, -1);

        { Left }
        FillRectEx(Handle, Rect(R.Left, R.Top, R.Left + 2, R.Bottom), ToolbarColor1);
        { Right }
        FillRectEx(Handle, Rect(R.Right - 2, R.Top, R.Right, R.Bottom), ToolbarColor2);
        { Top }
        PaintGradient(Handle, Rect(R.Left, R.Top - 1, R.Right, R.Top + 1),
          ToolbarColor1, ToolbarColor2, True);
        { Bottom }
        PaintGradient(Handle, Rect(R.Left, R.Bottom - 1, R.Right, R.Bottom + 1),
          ToolbarColor1, ToolbarColor2, True);

        Inc(R.Left);
      end;
      Brush.Style := bsSolid;
      Inc(R.Left); Inc(R.Top);
    end
    else
      InflateRect(R, -1, -1);
    InflateRect(R, -1, -1);

    if not ToolbarInfo.AllowDrag then Exit;

    BtnVisible := (ToolbarInfo.CloseButtonState and CDBS_VISIBLE) <> 0;
    Sz := GetTBXDragHandleSize(ToolbarInfo);
    if Horz then R.Right := R.Left + Sz
    else R.Bottom := R.Top + Sz;

    { Drag Handle }
    if ToolbarInfo.DragHandleStyle <> DHS_NONE then
    begin
      R2 := R;
      if Horz then
      begin
        Inc(R2.Left, DragHandleOffsets[BtnVisible, ToolbarInfo.DragHandleStyle]);
        if BtnVisible then Inc(R2.Top, Sz - 2);
        R2.Right := R2.Left + 3;
      end
      else
      begin
        Inc(R2.Top, DragHandleOffsets[BtnVisible, ToolbarInfo.DragHandleStyle]);
        if BtnVisible then Dec(R2.Right, Sz - 2);
        R2.Bottom := R2.Top + 3;
      end;

      if not IsMenuBar then
        PaintGradient(Canvas.Handle, Rect(R.Left - 1, R.Top - 1, R.Right, R.Bottom),
          ToolbarColor1, ToolbarColor2, not Horz)
      else
      begin
        Inc(R2.Left);
        Inc(R2.Top);
      end;

      if Horz then
      begin
        I := R2.Top + Sz div 2;
        while I < R2.Bottom - Sz div 2 - 2 do
        begin
          DrawHandleElement(Point(R2.Left, I));
          Inc(I, 4);
        end;
      end
      else
      begin
        I := R2.Left + Sz div 2;
        while I < R2.Right - Sz div 2 - 2 do
        begin
          DrawHandleElement(Point(I, R2.Top));
          Inc(I, 4);
        end;
      end;
    end;

    { Close button }
    if BtnVisible then
    begin
      R2 := R;
      if Horz then
      begin
        Dec(R2.Right);
        R2.Bottom := R2.Top + R2.Right - R2.Left;
      end
      else
      begin
        Dec(R2.Bottom);
        R2.Left := R2.Right - R2.Bottom + R2.Top;
      end;

      BtnItemState := GetBtnItemState(ToolbarInfo.CloseButtonState);
      FrameRectEx(Handle, R2, BtnItemColors[BtnItemState, ipFrame], True);
      FillRectEx(Handle, R2, BtnBodyColors[BtnItemState, False]);
      DrawButtonBitmap(Handle, R2, BtnItemColors[BtnItemState, ipText]);
    end;
  end;
end;

procedure TTBXProfessionalTheme.PaintDock(Canvas: TCanvas; const ClientRect,
  DockRect: TRect; DockPosition: Integer);
begin
  FillRectEx(Canvas.Handle, DockRect, DockColor);
end;

procedure TTBXProfessionalTheme.PaintDockPanelNCArea(Canvas: TCanvas; R: TRect;
  const DockPanelInfo: TTBXDockPanelInfo);

  function GetBtnItemState(BtnState: Integer): TBtnItemState;
  begin
    if (BtnState and CDBS_PRESSED) <> 0 then Result := bisPressed
    else if (BtnState and CDBS_HOT) <> 0 then Result := bisHot
    else Result := bisNormal;
  end;

var
  DC: HDC;
  Sz, Flags: Integer;
  R2: TRect;
  BtnItemState: TBtnItemState;
  OldBkMode: Cardinal;
  OldFont: HFONT;
  OldTextColor: TColorRef;
begin
  DC := Canvas.Handle;
  with DockPanelInfo do
  begin
    R2 := R;
    InflateRect(R, -BorderSize.X, -BorderSize.Y);

    { Frame }
    FrameRectEx(DC, R2, EffectiveColor, True);
    FrameRectEx(DC, R2, EffectiveColor, False);

    { Caption }
    Sz := GetSystemMetrics(SM_CYSMCAPTION);
    if IsVertical then
    begin
      R.Bottom := R.Top + Sz - 1;
      DrawLineEx(DC, R.Left, R.Bottom, R.Right, R.Bottom, EffectiveColor);
    end
    else
    begin
      R.Right := R.Left + Sz - 1;
      DrawLineEx(DC, R.Right, R.Top, R.Right, R.Bottom, EffectiveColor);
    end;
    PaintGradient(DC, R, DockPanelCaptionColor1, DockPanelCaptionColor2, False);
    R2 := R;
    InflateRect(R2, 1, 1);
    FrameRectEx(DC, R2, DockPanelCaptionFrameColor, False);

    { Close button }
    if (CDBS_VISIBLE and CloseButtonState) <> 0 then
    begin
      R2 := R;
      if IsVertical then
      begin
        R2.Left := R2.Right - Sz + 1;
        R.Right := R2.Left;
      end
      else
      begin
        R2.Top := R2.Bottom - Sz + 1;
        R.Bottom := R2.Top;
      end;

      BtnItemState := GetBtnItemState(CloseButtonState);
      FrameRectEx(DC, R2, BtnItemColors[BtnItemState, ipFrame], True);
      FillRectEx(DC, R2, BtnBodyColors[BtnItemState, False]);
      DrawButtonBitmap(DC, R2, BtnItemColors[BtnItemState, ipText]);
    end;

    if IsVertical then InflateRect(R, -4, 0)
    else InflateRect(R, 0, -4);

    { Caption text }
    OldFont := SelectObject(DC, SmCaptionFont.Handle);
    OldBkMode := SetBkMode(DC, TRANSPARENT);
    OldTextColor := SetTextColor(DC, ColorToRGB(SmCaptionFont.Color));
    Flags := DT_SINGLELINE or DT_VCENTER or DT_END_ELLIPSIS or DT_NOPREFIX;
    if IsVertical then DrawText(DC, Caption, -1, R, Flags)
    else DrawRotatedText(DC, string(Caption), R, Flags);
    SetTextColor(DC, OldTextColor);
    SetBkMode(DC, OldBkMode);
    SelectObject(DC, OldFont);
  end;
end;

procedure TTBXProfessionalTheme.SetupColorCache;
var
  MenuItemFrame, EnabledText, DisabledText: TColor;
begin
  DockColor                  := $F0F0F0;

  ToolbarColor1              := $E0E0E0;
  ToolbarColor2              := $EFEFEF;
  SeparatorColor1            := $9F9F9F;
  SeparatorColor2            := $FFFFFF;

  EmbeddedColor              := $E0E0E0;
  EmbeddedFrameColor         := $8D8D8D;

  PopupColor                 := $FFFFFF;
  PopupFrameColor            := $404040;

  DockPanelColor             := $F0F0F0;
  DockPanelCaptionColor1     := $B0B0B0;
  DockPanelCaptionColor2     := $BFBFBF;
  DockPanelCaptionFrameColor := $9F9F9F;

  EnabledText                := $000000;
  DisabledText               := $8D8D8D;
  MenuItemFrame              := $505050;

  WinFrameColors[wfpBorder]               := $808080;
  WinFrameColors[wfpCaption]              := $808080;
  WinFrameColors[wfpCaptionText]          := $FFFFFF;

  BtnItemColors[bisNormal, ipText]        := EnabledText;
  BtnItemColors[bisNormal, ipFrame]       := clNone;
  BtnItemColors[bisDisabled, ipText]      := DisabledText;
  BtnItemColors[bisDisabled, ipFrame]     := clNone;
  BtnItemColors[bisSelected, ipText]      := EnabledText;
  BtnItemColors[bisSelected, ipFrame]     := MenuItemFrame;
  BtnItemColors[bisPressed, ipText]       := EnabledText;
  BtnItemColors[bisPressed, ipFrame]      := MenuItemFrame;
  BtnItemColors[bisHot, ipText]           := EnabledText;
  BtnItemColors[bisHot, ipFrame]          := MenuItemFrame;
  BtnItemColors[bisDisabledHot, ipText]   := DisabledText;
  BtnItemColors[bisDisabledHot, ipFrame]  := MenuItemFrame;
  BtnItemColors[bisSelectedHot, ipText]   := EnabledText;
  BtnItemColors[bisSelectedHot, ipFrame]  := MenuItemFrame;
  BtnItemColors[bisPopupParent, ipText]   := EnabledText;
  BtnItemColors[bisPopupParent, ipFrame]  := PopupFrameColor;

  BtnBodyColors[bisNormal, False]         := clNone;
  BtnBodyColors[bisNormal, True]          := clNone;
  BtnBodyColors[bisDisabled, False]       := clNone;
  BtnBodyColors[bisDisabled, True]        := clNone;
  BtnBodyColors[bisSelected, False]       := $8CD5FF;
  BtnBodyColors[bisSelected, True]        := $55ADFF;
  BtnBodyColors[bisPressed, False]        := $4E91FE;
  BtnBodyColors[bisPressed, True]         := $8ED3FF;
  BtnBodyColors[bisHot, False]            := $CCF4FF;
  BtnBodyColors[bisHot, True]             := $91D0FF;
  BtnBodyColors[bisDisabledHot, False]    := BtnBodyColors[bisHot, False];
  BtnBodyColors[bisDisabledHot, True]     := BtnBodyColors[bisHot, True];
  BtnBodyColors[bisSelectedHot, False]    := BtnBodyColors[bisPressed, False];
  BtnBodyColors[bisSelectedHot, True]     := BtnBodyColors[bisPressed, True];
  BtnBodyColors[bisPopupParent, False]    := BtnBodyColors[bisHot, False];
  BtnBodyColors[bisPopupParent, True]     := BtnBodyColors[bisHot, True];

  MenuItemColors[misNormal, ipBody]       := clNone;
  MenuItemColors[misNormal, ipText]       := EnabledText;
  MenuItemColors[misNormal, ipFrame]      := clNone;
  MenuItemColors[misDisabled, ipBody]     := clNone;
  MenuItemColors[misDisabled, ipText]     := DisabledText;
  MenuItemColors[misDisabled, ipFrame]    := clNone;
  MenuItemColors[misHot, ipBody]          := $C2EEFF;
  MenuItemColors[misHot, ipText]          := MenuItemColors[misNormal, ipText];
  MenuItemColors[misHot, ipFrame]         := MenuItemFrame;
  MenuItemColors[misDisabledHot, ipBody]  := PopupColor;
  MenuItemColors[misDisabledHot, ipText]  := DisabledText;
  MenuItemColors[misDisabledHot, ipFrame] := MenuItemColors[misHot, ipFrame];

  StatusBarColor1 := ToolbarColor2;
  StatusBarColor2 := ToolbarColor1;
  StatusPanelFrameColor := SeparatorColor1;
end;

function TTBXProfessionalTheme.GetPopupShadowType: Integer;
begin
  Result := PST_OFFICEXP;
end;

constructor TTBXProfessionalTheme.Create(const AName: string);
begin
  inherited;
  if CounterLock = 0 then InitializeStock;
  Inc(CounterLock);
  SetupColorCache;
end;

destructor TTBXProfessionalTheme.Destroy;
begin
  Dec(CounterLock);
  if CounterLock = 0 then FinalizeStock;
  inherited;
end;

procedure TTBXProfessionalTheme.GetViewMargins(ViewType: Integer;
  out Margins: TTBXMargins);
begin
  Margins.LeftWidth := 0;
  Margins.TopHeight := 0;
  Margins.RightWidth := 0;
  Margins.BottomHeight := 0;
end;

procedure TTBXProfessionalTheme.PaintPageScrollButton(Canvas: TCanvas;
  const ARect: TRect; ButtonType: Integer; Hot: Boolean);
var
  DC: HDC;
  R: TRect;
  X, Y, Sz: Integer;
  C: TColor;
begin
  DC := Canvas.Handle;
  R := ARect;
  if Hot then C := BtnItemColors[bisHot, ipFrame]
  else C := EmbeddedFrameColor;
  FrameRectEx(DC, R, C, False);
  InflateRect(R, -1, -1);
  if Hot then C := BtnBodyColors[bisHot, False]
  else C := EmbeddedColor;
  FillRectEx(DC, R, C);
  X := (R.Left + R.Right) div 2;
  Y := (R.Top + R.Bottom) div 2;
  Sz := Min(X - R.Left, Y - R.Top) * 3 div 4;

  if Hot then C := BtnItemColors[bisHot, ipText]
  else C := BtnItemColors[bisNormal, ipText];

  case ButtonType of
    PSBT_UP:
      begin
        Inc(Y, Sz div 2);
        PolygonEx(DC, [Point(X + Sz, Y), Point(X, Y - Sz), Point(X - Sz, Y)], C, C);
      end;
    PSBT_DOWN:
      begin
        Y := (R.Top + R.Bottom - 1) div 2;
        Dec(Y, Sz div 2);
        PolygonEx(DC, [Point(X + Sz, Y), Point(X, Y + Sz), Point(X - Sz, Y)], C, C);
      end;
    PSBT_LEFT:
      begin
        Inc(X, Sz div 2);
        PolygonEx(DC, [Point(X, Y + Sz), Point(X - Sz, Y), Point(X, Y - Sz)], C, C);
      end;
    PSBT_RIGHT:
      begin
        X := (R.Left + R.Right - 1) div 2;
        Dec(X, Sz div 2);
        PolygonEx(DC, [Point(X, Y + Sz), Point(X + Sz, Y), Point(X, Y - Sz)], C, C);
      end;
  end;
end;

procedure TTBXProfessionalTheme.PaintFrameControl(Canvas: TCanvas; R: TRect;
  Kind, State: Integer; Params: Pointer);
var
  DC: HDC;
  X, Y: Integer;
  Pen, OldPen: HPen;
  Brush, OldBrush: HBRUSH;
  C: TColor;

  function GetPenColor: TColor;
  begin
    if Boolean(State and PFS_DISABLED) then Result := clBtnShadow
    else if Boolean(State and PFS_PUSHED) then Result := BtnItemColors[bisPressed, ipFrame]
    else if Boolean(State and PFS_HOT) then Result := BtnItemColors[bisHot, ipFrame]
    else Result := EmbeddedFrameColor;
  end;

  function GetBrush: HBRUSH;
  begin
    if Boolean(State and PFS_DISABLED) then Result := CreateDitheredBrush(clWindow, clBtnFace)
    else if Boolean(State and PFS_PUSHED) then Result := CreateBrushEx(BtnBodyColors[bisPressed, False])
    else if Boolean(State and PFS_HOT) then Result := CreateBrushEx(BtnBodyColors[bisHot, False])
    else if Boolean(State and PFS_MIXED) then Result := CreateDitheredBrush(clWindow, clBtnFace)
    else Result := CreateBrushEx(clNone);
  end;

  function GetTextColor: TColor;
  begin
    if Boolean(State and PFS_DISABLED) then Result := BtnItemColors[bisDisabled, ipText]
    else if Boolean(State and PFS_PUSHED) then Result := BtnItemColors[bisPressed, ipText]
    else if Boolean(State and PFS_MIXED) then Result := clBtnShadow
    else if Boolean(State and PFS_HOT) then Result := BtnItemColors[bisHot, ipText]
    else Result := BtnItemColors[bisNormal, ipText];
  end;

begin
  DC := Canvas.Handle;
  case Kind of
    PFC_CHECKBOX:
      begin
        InflateRect(R, -1, -1);
        FrameRectEx(DC, R, GetPenColor, True);
        Brush := GetBrush;
        Windows.FillRect(DC, R, Brush);
        DeleteObject(Brush);
        InflateRect(R, 1, 1);

        if Boolean(State and (PFS_CHECKED or PFS_MIXED)) then
        begin
          X := (R.Left + R.Right) div 2 - 1;
          Y := (R.Top + R.Bottom) div 2 + 1;
          C := GetTextColor;
          PolygonEx(DC, [Point(X - 2, Y), Point(X, Y + 2), Point(X + 4, Y - 2),
            Point(X + 4, Y - 4), Point(X, Y), Point(X - 2, Y - 2), Point(X - 2, Y)], C, C);
        end;
      end;
    PFC_RADIOBUTTON:
      begin
        InflateRect(R, -1, -1);

        with R do
        begin
          Brush := GetBrush;
          OldBrush := SelectObject(DC, Brush);
          Pen := CreatePenEx(GetPenColor);
          OldPen := SelectObject(DC, Pen);
          Windows.Ellipse(DC, Left, Top, Right, Bottom);
          SelectObject(DC, OldPen);
          DeleteObject(Pen);
          SelectObject(DC, OldBrush);
          DeleteObject(Brush);
        end;

        if Boolean(State and PFS_CHECKED) then
        begin
          InflateRect(R, -3, -3);
          C := GetTextColor;
          Brush := CreateBrushEx(C);
          OldBrush := SelectObject(DC, Brush);
          Pen := CreatePenEx(C);
          OldPen := SelectObject(DC, Pen);
          with R do Windows.Ellipse(DC, Left, Top, Right, Bottom);
          SelectObject(DC, OldPen);
          DeleteObject(Pen);
          SelectObject(DC, OldBrush);
          DeleteObject(Brush);
        end;
      end;
  end;
end;

procedure TTBXProfessionalTheme.PaintStatusBar(Canvas: TCanvas; R: TRect;
  Part: Integer);

  procedure DrawHandleElement(const P: TPoint);
  begin
    Canvas.Brush.Color := SeparatorColor2;
    Canvas.FillRect(Rect(P.X - 2, P.Y - 2, P.X, P.Y));
    Canvas.Brush.Color := SeparatorColor1;
    Canvas.FillRect(Rect(P.X - 3, P.Y - 3, P.X - 1, P.Y - 1));
  end;

begin
  case Part of
    SBP_BODY:
      PaintGradient(Canvas.Handle, R, StatusBarColor1, StatusBarColor2, False);
    SBP_PANE, SBP_LASTPANE:
      begin
        if Part = SBP_PANE then Dec(R.Right, 2);
        FrameRectEx(Canvas.Handle, R, StatusPanelFrameColor, False);
      end;
    SBP_GRIPPER:
      begin
        Dec(R.Right);
        Dec(R.Bottom);
        DrawHandleElement(Point(R.Right, R.Bottom));
        DrawHandleElement(Point(R.Right, R.Bottom - 4));
        DrawHandleElement(Point(R.Right, R.Bottom - 8));

        Dec(R.Right, 4);
        DrawHandleElement(Point(R.Right, R.Bottom));
        DrawHandleElement(Point(R.Right, R.Bottom - 4));

        Dec(R.Right, 4);
        DrawHandleElement(Point(R.Right, R.Bottom));
      end;
  end;
end;

initialization
  if not IsTBXThemeAvailable('Professional') then
    RegisterTBXTheme('Professional', TTBXProfessionalTheme);

end.
