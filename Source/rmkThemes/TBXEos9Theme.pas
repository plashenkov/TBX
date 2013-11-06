{*
 * "Eos 9" Theme for TBX
 * Copyright 2004-2013 Roy Magne Klever. All rights reserved.
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

unit TBXEos9Theme;

interface

uses
  Windows, Messages, Graphics, TBXThemes, ImgList;

{$DEFINE ALTERNATIVE_DISABLED_STYLE} // remove the asterisk to change appearance of disabled images
{*$DEFINE SMALL_CLOSE_BUTTON}// remove the asterisk for smaller close button size

type
  TGradDir = (tGLeftRight, tGTopBottom);
  TItemPart = (ipBody, ipText, ipFrame);
  TBtnItemState = (bisNormal, bisDisabled, bisSelected, bisPressed, bisHot,
    bisDisabledHot, bisSelectedHot, bisPopupParent);
  TMenuItemState = (misNormal, misDisabled, misHot, misDisabledHot);
  TWinFramePart = (wfpBorder, wfpCaption, wfpCaptionText);
  TWinFrameState = (wfsActive, wfsInactive);

  TTBXEos9Theme = class(TTBXTheme)
  private
    procedure TBXSysCommand(var Message: TMessage); message TBX_SYSCOMMAND;
  protected
    { View/Window Colors }
    MenubarColor: TColor;
    ToolbarColor: TColor;
    PopupColor: TColor;
    DockPanelColor: TColor;
    BarSepColor: TColor;
    EditFrameColor: TColor;
    EditFrameDisColor: TColor;

    PopupFrameColor: TColor;
    WinFrameColors: array[TWinFrameState, TWinFramePart] of TColor;
    PnlFrameColors: array[TWinFrameState, TWinFramePart] of TColor;
    MenuItemColors: array[TMenuItemState, TItemPart] of TColor;
    BtnItemColors: array[TBtnItemState, TItemPart] of TColor;

    { Other Colors }
    DragHandleColor: TColor;
    PopupSeparatorColor: TColor;
    ToolbarSeparatorColor: TColor;
    IconShadowColor: TColor;
    StatusPanelFrameColor: TColor;

    procedure SetupColorCache; virtual;
  protected
    { Internal Methods }
    function GetPartColor(const ItemInfo: TTBXItemInfo; ItemPart: TItemPart): TColor;
    function GetBtnColor(const ItemInfo: TTBXItemInfo; ItemPart: TItemPart): TColor;
  public
    constructor Create(const AName: string); override;
    destructor Destroy; override;

    { Metrics access}
    function GetBooleanMetrics(Index: Integer): Boolean; override;
    function GetImageOffset(Canvas: TCanvas; const ItemInfo: TTBXItemInfo; ImageList: TCustomImageList): TPoint; override;
    function GetIntegerMetrics(Index: Integer): Integer; override;
    function GetItemColor(const ItemInfo: TTBXItemInfo): TColor; override;
    function GetItemTextColor(const ItemInfo: TTBXItemInfo): TColor; override;
    function GetItemImageBackground(const ItemInfo: TTBXItemInfo): TColor; override;
    procedure GetMargins(MarginID: Integer; out Margins: TTBXMargins); override;
    function GetPopupShadowType: Integer; override;
    procedure GetViewBorder(ViewType: Integer; out Border: TPoint); override;
    function GetViewColor(AViewType: Integer): TColor; override;
    procedure GetViewMargins(ViewType: Integer; out Margins: TTBXMargins); override;

    { Painting routines }
    procedure PaintBackgnd(Canvas: TCanvas; const ADockRect, ARect, AClipRect: TRect; AColor: TColor; Transparent: Boolean; AViewType: Integer); override;
    procedure PaintButton(Canvas: TCanvas; const ARect: TRect; const ItemInfo: TTBXItemInfo); override;
    procedure PaintCaption(Canvas: TCanvas; const ARect: TRect; const ItemInfo: TTBXItemInfo; const ACaption: string; AFormat: Cardinal; Rotated: Boolean); override;
    procedure PaintCheckMark(Canvas: TCanvas; ARect: TRect; const ItemInfo: TTBXItemInfo); override;
    procedure PaintChevron(Canvas: TCanvas; ARect: TRect; const ItemInfo: TTBXItemInfo); override;
    procedure PaintDock(Canvas: TCanvas; const ClientRect, DockRect: TRect;
      DockPosition: Integer); override;
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

var
  MenuButtons, BarLines, AltCaption,
    Aqua, DarkAqua, CaptionOutline, DottedGrip: boolean;
  SelGradient: integer;
  HotColor, BaseColor, BaseShade: TColor;

implementation

{.$R tbx_glyphs.res}

uses TBXUtils, TB2Common, TB2Item, Classes, Controls, Commctrl, Forms;

const
  ZERO_RECT: TRect = (Left: 0; Top: 0; Right: 0; Bottom: 0);
var
  StockImgList: TImageList;
  CounterLock: Integer;
  gradCol1, gradCol2, gradHandle1, gradHandle2, gradHandle3, gradBL: TColor;

procedure InitializeStock;
begin
  StockImgList := TImageList.Create(nil);
  StockImgList.Handle := ImageList_LoadBitmap(HInstance, 'TBXGLYPHS', 16, 0, clWhite);
end;

procedure FinalizeStock;
begin
  StockImgList.Free;
end;

{ TTBXEos9Theme }

procedure RoundFrame(Canvas: TCanvas; R: TRect; RL, RR: Integer);
begin
  with Canvas, R do
  begin
    Dec(Right); Dec(Bottom);
    PolyLine([
      Point(Left + RL, Top),
        Point(Right - RR, Top),
        Point(Right, Top + RR),
        Point(Right, Bottom - RR),
        Point(Right - RR, Bottom),
        Point(Left + RL, Bottom),
        Point(Left, Bottom - RL),
        Point(Left, Top + RL),
        Point(Left + RL, Top)
        ]);
    Inc(Right); Inc(Bottom);
  end;
end;

function TTBXEos9Theme.GetBooleanMetrics(Index: Integer): Boolean;
begin
  case Index of
    TMB_OFFICEXPPOPUPALIGNMENT: Result := False;
    TMB_EDITHEIGHTEVEN: Result := False;
    TMB_PAINTDOCKBACKGROUND: Result := True;
    TMB_SOLIDTOOLBARNCAREA: Result := True;
    TMB_SOLIDTOOLBARCLIENTAREA: Result := True;

  else
    Result := False;
  end;
end;

function TTBXEos9Theme.GetIntegerMetrics(Index: Integer): Integer;
const
  DEFAULT = -1;
begin
  case Index of
    TMI_SPLITBTN_ARROWWIDTH: Result := 12;

    TMI_DROPDOWN_ARROWWIDTH: Result := 8;
    TMI_DROPDOWN_ARROWMARGIN: Result := 3;

    TMI_MENU_IMGTEXTSPACE: Result := 0;
    TMI_MENU_LCAPTIONMARGIN: Result := 8;
    TMI_MENU_RCAPTIONMARGIN: Result := 3;
    TMI_MENU_SEPARATORSIZE: Result := 7;
    TMI_MENU_MDI_DW: Result := 2;
    TMI_MENU_MDI_DH: Result := 2;

    TMI_TLBR_SEPARATORSIZE: Result := 5; //DEFAULT;

    TMI_EDIT_MENURIGHTINDENT: Result := 1;
    TMI_EDIT_FRAMEWIDTH: Result := 1;
    TMI_EDIT_TEXTMARGINHORZ: Result := 2;
    TMI_EDIT_TEXTMARGINVERT: Result := 2;
    TMI_EDIT_BTNWIDTH: Result := 14;
  else
    Result := DEFAULT;
  end;
end;

function TTBXEos9Theme.GetViewColor(AViewType: Integer): TColor;
begin
  Result := clBtnFace;
  if (AViewType and VT_TOOLBAR) = VT_TOOLBAR then
  begin
    if (AViewType and TVT_MENUBAR) = TVT_MENUBAR then Result := MenubarColor
    else Result := ToolbarColor;
  end
  else if (AViewType and VT_POPUP) = VT_POPUP then
  begin
    if (AViewType and PVT_LISTBOX) = PVT_LISTBOX then Result := clWindow
    else Result := PopupColor;
  end
  else if (AViewType and VT_DOCKPANEL) = VT_DOCKPANEL then Result := DockPanelColor;
end;

function TTBXEos9Theme.GetBtnColor(const ItemInfo: TTBXItemInfo; ItemPart: TItemPart): TColor;
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
    Embedded := (ViewType and VT_TOOLBAR = VT_TOOLBAR) and
      (ViewType and TVT_EMBEDDED = TVT_EMBEDDED);
    if not Enabled then B := BFlags1[HoverKind = hkKeyboardHover]
    else if ItemInfo.IsPopupParent then
      B := bisPopupParent
    else if Pushed then B := bisPressed
    else if Selected then B := BFlags2[HoverKind <> hkNone]
    else B := BFlags3[HoverKind <> hkNone];
    Result := BtnItemColors[B, ItemPart];
    if Embedded then
    begin
      if (ItemPart = ipBody) and (Result = clNone) then Result := ToolbarColor;
      if ItemPart = ipFrame then
      begin
        if Selected then Result := clWindowFrame
        else if (Result = clNone) then Result := clBtnShadow;
      end;
    end;
  end;
end;

function TTBXEos9Theme.GetPartColor(const ItemInfo: TTBXItemInfo; ItemPart: TItemPart): TColor;
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
    IsMenuItem := ((ViewType and PVT_POPUPMENU) = PVT_POPUPMENU) and
      ((ItemOptions and IO_TOOLBARSTYLE) = 0);
    Embedded := ((ViewType and VT_TOOLBAR) = VT_TOOLBAR) and
      ((ViewType and TVT_EMBEDDED) = TVT_EMBEDDED);
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
      Result := BtnItemColors[B, ItemPart];
      if Embedded and (Result = clNone) then
      begin
        if ItemPart = ipBody then Result := ToolbarColor;
        if ItemPart = ipFrame then Result := clBtnShadow;
      end;
    end;
  end;
end;

procedure DrawButtonBitmap(Canvas: TCanvas; R: TRect; Color: TColor);
const
{$IFNDEF SMALL_CLOSE_BUTTON}
  Pattern: array[0..15] of Byte =
  ($C3, 0, $66, 0, $3C, 0, $18, 0, $3C, 0, $66, 0, $C3, 0, 0, 0);
{$ELSE}
  Pattern: array[0..15] of Byte =
  (0, 0, $63, 0, $36, 0, $1C, 0, $1C, 0, $36, 0, $63, 0, 0, 0);
{$ENDIF}
var
  Bmp: TBitmap;
  W, H: Integer;
  Index: Integer;
begin
  Bmp := TBitmap.Create;
  try
    Bmp.Handle := CreateBitmap(8, 8, 1, 1, @Pattern);
    Index := SaveDC(Canvas.Handle);
    Canvas.Brush.Color := Color;
    SetTextColor(Canvas.Handle, clBlack);
    SetBkColor(Canvas.Handle, clWhite);
    W := 8;
    H := 7;
    with R do
    begin
      BitBlt(Canvas.Handle, (Left + Right - W + 1) div 2, (Top + Bottom - H) div 2, W, H,
        Bmp.Canvas.Handle, 0, 0, ROP_DSPDxax);
    end;
    RestoreDC(Canvas.Handle, Index);
  finally
    Bmp.Free;
  end;
end;

function TTBXEos9Theme.GetItemColor(const ItemInfo: TTBXItemInfo): TColor;
begin
  Result := GetPartColor(ItemInfo, ipBody);
  if Result = clNone then Result := GetViewColor(ItemInfo.ViewType);
end;

function TTBXEos9Theme.GetItemTextColor(const ItemInfo: TTBXItemInfo): TColor;
begin
  Result := GetPartColor(ItemInfo, ipText);
end;

function TTBXEos9Theme.GetItemImageBackground(const ItemInfo: TTBXItemInfo): TColor;
begin
  Result := GetBtnColor(ItemInfo, ipBody);
  if Result = clNone then result := GetViewColor(ItemInfo.ViewType);
end;

procedure TTBXEos9Theme.GetViewBorder(ViewType: Integer; out Border: TPoint);
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
  if ((ViewType and VT_TOOLBAR) = VT_TOOLBAR) or ((ViewType and TVT_MENUBAR) = TVT_MENUBAR) then
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
    if (ViewType and PVT_POPUPMENU) = PVT_POPUPMENU then
    begin
      Border.X := 2; {1} // rmkO
      Border.Y := 2;
    end else
    begin
      Border.X := 2;
      Border.Y := 2;
    end;
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

procedure TTBXEos9Theme.GetMargins(MarginID: Integer; out Margins: TTBXMargins);
begin
  with Margins do
    case MarginID of
      MID_TOOLBARITEM:
        begin
          LeftWidth := 2;
          RightWidth := 2;
          TopHeight := 2;
          BottomHeight := 2;
        end;
      MID_STATUSPANE:
        begin
          LeftWidth := 3; {1}
          RightWidth := 3;
          TopHeight := 1;
          BottomHeight := 1;
        end;
      MID_MENUITEM:
        begin
          LeftWidth := 1;
          RightWidth := 1;
          TopHeight := 3;
          BottomHeight := 3;
        end;
    else
      LeftWidth := 0;
      RightWidth := 0;
      TopHeight := 0;
      BottomHeight := 0;
    end;
end;

procedure TTBXEos9Theme.PaintBackgnd(Canvas: TCanvas; const ADockRect, ARect, AClipRect: TRect;
  AColor: TColor; Transparent: Boolean; AViewType: Integer);
var
  R: TRect;
begin
  //if TBXLoColor then inherited
  //else
  IntersectRect(R, ARect, AClipRect);
  if not Transparent then
  with Canvas do
  begin
    Brush.Color := AColor;
    FillRect(R);
  end;
end;

procedure TTBXEos9Theme.PaintCaption(Canvas: TCanvas;
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
    if not Rotated then Windows.DrawText(Handle, PChar(ACaption), Length(ACaption), R, AFormat)
    else DrawRotatedText(Handle, ACaption, R, AFormat);
    Brush.Style := bsSolid;
  end;
end;

procedure TTBXEos9Theme.PaintCheckMark(Canvas: TCanvas; ARect: TRect; const ItemInfo: TTBXItemInfo);
var
  X, Y: Integer;
begin
  X := (ARect.Left + ARect.Right) div 2 - 2;
  Y := (ARect.Top + ARect.Bottom) div 2 + 1;
  if ItemInfo.Enabled and (Iteminfo.HoverKind <> hkNone) then
    Canvas.Pen.Color := clWhite
  else
    if not ItemInfo.Enabled then
      Canvas.Pen.Color := MenuItemColors[misDisabled, ipText]
    else
      Canvas.Pen.Color := clBlack;
  Canvas.Polyline([Point(X - 2, Y - 2), Point(X, Y), Point(X + 4, Y - 4),
    Point(X + 4, Y - 3), Point(X, Y + 1), Point(X - 2, Y - 1), Point(X - 2, Y - 2)]);
end;

procedure TTBXEos9Theme.PaintChevron(Canvas: TCanvas; ARect: TRect; const ItemInfo: TTBXItemInfo);
const
  Pattern: array[Boolean, 0..15] of Byte = (
    ($CC, 0, $66, 0, $33, 0, $66, 0, $CC, 0, 0, 0, 0, 0, 0, 0),
    ($88, 0, $D8, 0, $70, 0, $20, 0, $88, 0, $D8, 0, $70, 0, $20, 0));
var
  R2: TRect;
  Bmp: TBitmap;
begin
  R2 := ARect;
  PaintButton(Canvas, ARect, ItemInfo);
  if not ItemInfo.IsVertical then
  begin
    R2.Top := 4;
    R2.Bottom := R2.Top + 5;
    Inc(R2.Left, 2);
    R2.Right := R2.Left + 8;
  end
  else
  begin
    R2.Left := R2.Right - 9;
    R2.Right := R2.Left + 5;
    Inc(R2.Top, 2);
    R2.Bottom := R2.Top + 8;
  end;
  Bmp := TBitmap.Create;
  try
    Bmp.Handle := CreateBitmap(8, 8, 1, 1, @Pattern[ItemInfo.IsVertical]);
    Canvas.Brush.Color := GetPartColor(ItemInfo, ipText);
    SetTextColor(Canvas.Handle, clBlack);
    SetBkColor(Canvas.Handle, clWhite);
    with R2 do BitBlt(Canvas.Handle, Left, Top, Right - Left,
        Bottom - Top, Bmp.Canvas.Handle, 0, 0, ROP_DSPDxax);
  finally
    Bmp.Free;
  end;
end;

procedure TTBXEos9Theme.PaintEditButton(Canvas: TCanvas; const ARect: TRect;
  var ItemInfo: TTBXItemInfo; ButtonInfo: TTBXEditBtnInfo);
const
  ArrowColor: array[Boolean] of TColor = (clBtnText, clMenuText);
var
  BtnDisabled, BtnHot, BtnPressed, Embedded: Boolean;
  R, BR: TRect;
  X, Y: Integer;
  SaveItemInfoPushed: Boolean;

  procedure PaintEnabled(R: TRect; Pressed: Boolean);
  var
    C: TColor;
  begin
    if BtnDisabled then
      C := GetBtnColor(ItemInfo, ipFrame)
    else if BtnHot or BtnPressed then
      C := BtnItemColors[bisHot, ipFrame]
    else
    begin
      if Embedded then
        c := blend(gradCol1, gradCol2, 90)
      else
      begin
        if (ItemInfo.ViewType and VT_TOOLBAR) <> VT_TOOLBAR then
          c := blend(gradCol1, gradCol2, 90)
        else
          c := clWindow;
      end;
    end;
    if Embedded then
    begin
      if not (BtnPressed or BtnHot) then
        FillRectEx(Canvas.Handle, R, ToolBarColor);
      FrameRectEx(Canvas.Handle, R, C, True);
    end
    else
      FrameRectEx(Canvas.Handle, R, C, True);
  end;

begin
  R := ARect;
  Embedded := ((ItemInfo.ViewType and VT_TOOLBAR) = VT_TOOLBAR) and
    ((ItemInfo.ViewType and TVT_EMBEDDED) = TVT_EMBEDDED);
  Inc(R.Left);
  with Canvas do
    if ButtonInfo.ButtonType = EBT_DROPDOWN then
    begin
      BtnDisabled := (ButtonInfo.ButtonState and EBDS_DISABLED) <> 0;
      BtnHot := (ButtonInfo.ButtonState and EBDS_HOT) <> 0;
      BtnPressed := (ButtonInfo.ButtonState and EBDS_PRESSED) <> 0;
      if not BtnDisabled then
      begin
        if BtnPressed or BtnHot then
        begin
          InflateRect(R, 1, 1);
          PaintButton(Canvas, R, ItemInfo);
          PaintEnabled(R, BtnPressed);
        end
        else
          PaintEnabled(R, BtnPressed);
      end;
      PaintDropDownArrow(Canvas, R, ItemInfo);
    end
    else if ButtonInfo.ButtonType = EBT_SPIN then
    begin
      BtnDisabled := (ButtonInfo.ButtonState and EBSS_DISABLED) <> 0;
      BtnHot := (ButtonInfo.ButtonState and EBSS_HOT) <> 0;
      BtnPressed := (ButtonInfo.ButtonState and EBSS_UP) <> 0;

      // Upper button
      BR := R;
      BR.Bottom := (R.Top + R.Bottom + 1) div 2;
      SaveItemInfoPushed := ItemInfo.Pushed;
      ItemInfo.Pushed := BtnPressed;
      if not BtnDisabled then
      begin
        if BtnPressed or BtnHot then
        begin
          InflateRect(BR, 1, 1);
          PaintButton(Canvas, BR, ItemInfo);
          PaintEnabled(BR, BtnPressed);
        end
        else
          PaintEnabled(BR, BtnPressed);
      end;
      X := (BR.Left + BR.Right) div 2;
      Y := (BR.Top + BR.Bottom - 1) div 2;
      if (not BtnPressed) then
        Pen.Color := GetPartColor(ItemInfo, ipText)
      else
        Pen.Color := GetPartColor(ItemInfo, ipText);
      Brush.Color := Pen.Color;
      Polygon([Point(X - 2, Y + 1), Point(X + 2, Y + 1), Point(X, Y - 1)]);

      // Lower button
      BR := R;
      BR.Top := (R.Top + R.Bottom) div 2;
      BtnPressed := (ButtonInfo.ButtonState and EBSS_DOWN) <> 0;
      ItemInfo.Pushed := BtnPressed;
      if not BtnDisabled then
      begin
        if BtnPressed or BtnHot then
        begin
          InflateRect(BR, 1, 1);
          BR.Top := BR.Top + 1;
          PaintButton(Canvas, BR, ItemInfo);
          PaintEnabled(BR, BtnPressed);
        end
        else
        begin
          PaintEnabled(BR, BtnPressed);
        end;
      end;
      X := (BR.Left + BR.Right) div 2;
      Y := (BR.Top + BR.Bottom) div 2;
      if (not BtnPressed) then
        Pen.Color := GetPartColor(ItemInfo, ipText)
      else
        Pen.Color := GetPartColor(ItemInfo, ipText);
      Brush.Color := Pen.Color;
      Polygon([Point(X - 2, Y - 1), Point(X + 2, Y - 1), Point(X, Y + 1)]);
      ItemInfo.Pushed := SaveItemInfoPushed;
    end;
end;

procedure TTBXEos9Theme.PaintEditFrame(Canvas: TCanvas;
  const ARect: TRect; var ItemInfo: TTBXItemInfo; const EditInfo: TTBXEditInfo);
var
  R: TRect;
  W: Integer;
  Embedded: Boolean;
begin
  R := ARect;
  if ItemInfo.HoverKind <> hkNone then
    FrameRectEx(Canvas.Handle, R, BtnItemColors[bisHot, ipFrame], true);
  W := EditFrameWidth;
  InflateRect(R, -W, -W);
  Embedded := ((ItemInfo.ViewType and VT_TOOLBAR) = VT_TOOLBAR) and
    ((ItemInfo.ViewType and TVT_EMBEDDED) = TVT_EMBEDDED);
  if not (ItemInfo.Enabled or Embedded) then
    FrameRectEx(Canvas.Handle, R, BtnItemColors[bisDisabled, ipText], true);

  with EditInfo do
    if RightBtnWidth > 0 then
      Dec(R.Right, RightBtnWidth - 2);

  if ItemInfo.Enabled then
  begin
    if ItemInfo.HoverKind = hkNone then
      if Embedded then
        FrameRectEx(Canvas.Handle, R, blend(gradCol1, gradCol2, 90), True)
      else
        FrameRectEx(Canvas.Handle, R, clWindow, True)
    else
    begin
      Canvas.Brush.Color := clWindow;
      Canvas.FrameRect(R);
    end;
  end;
  if ItemInfo.Enabled then
  begin
    Canvas.Brush.Color := clWindow;
    Canvas.FillRect(R);
    if ((ItemInfo.ViewType and VT_TOOLBAR) <> VT_TOOLBAR) and
      (GetPartColor(ItemInfo, ipFrame) = clNone) then
    begin
      Canvas.Brush.Color := blend(gradCol1, gradCol2, 90);
      R := ARect;
      InflateRect(R, -1, -1);
      Canvas.FrameRect(R);
    end;
  end;

  if EditInfo.RightBtnWidth > 0 then
  begin
    R := ARect;
    InflateRect(R, -W, -W);
    R.Left := R.Right - EditInfo.RightBtnWidth;
    PaintEditButton(Canvas, R, ItemInfo, EditInfo.RightBtnInfo);
  end;
end;

procedure TTBXEos9Theme.PaintDropDownArrow(Canvas: TCanvas;
  const ARect: TRect; const ItemInfo: TTBXItemInfo);
var
  X, Y: Integer;
begin
  with ARect, Canvas do
    if (ItemInfo.ComboPart = cpNone) or (ItemInfo.ComboPart = cpCombo) then
    begin
      if ItemInfo.IsVertical then
      begin
        X := (Left + Right) div 2 - 1;
        Y := (Top + Bottom) div 2;
      end else
      begin
        X := (Left + Right) div 2;
        Y := (Top + Bottom) div 2 + 1;
      end;
      Pen.Color := GetPartColor(ItemInfo, ipText);
      Brush.Color := Pen.Color;
      if ItemInfo.IsVertical then
        Polygon([Point(X, Y + 2), Point(X, Y - 2), Point(X - 2, Y)])
      else
        Polygon([Point(X - 2, Y), Point(X + 2, Y), Point(X, Y + 2)]);

      if ItemInfo.IsVertical then
      begin
        X := (Left + Right) div 2 + 2;
        Y := (Top + Bottom) div 2;
      end else
      begin
        X := (Left + Right) div 2;
        Y := (Top + Bottom) div 2 - 2;
      end;
      Pen.Color := GetPartColor(ItemInfo, ipText);
      Brush.Color := Pen.Color;
      if ItemInfo.IsVertical then
        Polygon([Point(X, Y + 2), Point(X, Y - 2), Point(X + 2, Y)])
      else
        Polygon([Point(X - 2, Y), Point(X + 2, Y), Point(X, Y - 2)]);
    end else
    begin
      X := (Left + Right) div 2;
      Y := (Top + Bottom) div 2 - 1;
      Pen.Color := GetPartColor(ItemInfo, ipText);
      Brush.Color := Pen.Color;
      if ItemInfo.IsVertical then Polygon([Point(X, Y + 2), Point(X, Y - 2), Point(X - 2, Y)])
      else Polygon([Point(X - 2, Y), Point(X + 2, Y), Point(X, Y + 2)]);
    end;
end;

procedure TTBXEos9Theme.PaintButton(Canvas: TCanvas; const ARect: TRect; const ItemInfo: TTBXItemInfo);
var
  R: TRect;
  ShowHover, Embedded: Boolean;
begin
  R := ARect;
  with ItemInfo, Canvas do
  begin
    ShowHover := (Enabled and (HoverKind <> hkNone)) or
      (not Enabled and (HoverKind = hkKeyboardHover));
    Embedded := (ViewType and VT_TOOLBAR = VT_TOOLBAR) and
      (ViewType and TVT_EMBEDDED = TVT_EMBEDDED);

    if ComboPart = cpSplitRight then Dec(R.Left);  // rmkPS

    if Embedded and not ShowHover then
    begin
      if Enabled then
      begin
        InflateRect(R, -1, -1);
        FillRectEx(Canvas.Handle, R, ToolBarColor);
        InflateRect(R, 1, 1);
        Pen.Color := Blend(clHighLight, clWindow, 20);
      end
      else
        Pen.Color := Blend(clHighLight, clWindow, 15);
    end;

    if ((ViewType and TVT_MENUBAR) = TVT_MENUBAR) and (not MenuButtons) then
    begin
      if ((Pushed or Selected) and Enabled) or ShowHover then
        PaintBackgnd(Canvas, ZERO_RECT, ARect, ARect, MenuItemColors[misHot, ipBody], False, VT_UNKNOWN);
      Exit;
    end;

    if (Pushed or Selected) and Enabled then
    begin
      if not Pushed and (HoverKind = hkNone) then
      begin
        Brush.Color := BtnItemColors[bisSelected, ipBody];
        InflateRect(R, -1, -1);
        FillRect(R);
        InflateRect(R, 1, 1);
        Pen.Color := BtnItemColors[bisSelected, ipFrame];
        //with R do Rectangle(Left, Top, Right, Bottom);
      end else
      begin
        Brush.Color := BtnItemColors[bisPressed, ipBody];
        FillRect(R);
        Pen.Color := BtnItemColors[bisPressed, ipFrame];
        //with R do Rectangle(Left, Top, Right, Bottom);
      end;
      if Selected and (not Pushed) and (HoverKind <> hkNone) then
      begin
        Brush.Color := BtnItemColors[bisSelectedHot, ipBody];
        FillRect(R);
        Pen.Color := BtnItemColors[bisSelected, ipFrame];
        //with R do Rectangle(Left, Top, Right, Bottom);
      end;
    end
    else
      if ShowHover or ((ItemOptions and IO_DESIGNING) <> 0) then
      begin
        Brush.Color := GetBtnColor(ItemInfo, ipBody);
        FillRect(R);
        Pen.Color := GetBtnColor(ItemInfo, ipFrame);
        //with R do Rectangle(Left, Top, Right, Bottom);
      end;
    if ComboPart = cpSplitRight then PaintDropDownArrow(Canvas, R, ItemInfo);
  end;
end;

procedure TTBXEos9Theme.PaintFloatingBorder(Canvas: TCanvas; const ARect: TRect;
  const WindowInfo: TTBXWindowInfo);
const
  WinStates: array[Boolean] of TWinFramestate = (wfsInactive, wfsActive);
  ZERO_RECT: TRect = (Left: 0; Top: 0; Right: 0; Bottom: 0);

  function GetBtnItemState(BtnState: Integer): TBtnItemState;
  begin
    if not WindowInfo.Active then Result := bisDisabled
    else if (BtnState and CDBS_PRESSED) <> 0 then Result := bisPressed
    else if (BtnState and CDBS_HOT) <> 0 then Result := bisHot
    else Result := bisNormal;
  end;

var
  WinState: TWinFrameState;
  BtnItemState: TBtnItemState;
  SaveIndex, X, Y: Integer;
  Sz: TPoint;
  R, R2: TRect;
  BodyColor, CaptionColor, CaptionText: TColor;
  IsDockPanel: Boolean;

  procedure DrawGlyph(C: TColor);
  var
    Bmp: TBitmap;
    DC: HDC;
  begin
    Bmp := TBitmap.Create;
    try
      Bmp.Monochrome := True;
      StockImgList.GetBitmap(0, Bmp);
      Canvas.Brush.Color := C;
      DC := Canvas.Handle;
      SetTextColor(DC, clBlack);
      SetBkColor(DC, clWhite);
      BitBlt(DC, X, Y, StockImgList.Width, StockImgList.Height,
        Bmp.Canvas.Handle, 0, 0, ROP_DSPDxax);
    finally
      Bmp.Free;
    end;
  end;

begin
  with Canvas do
  begin
    WinState := WinStates[WindowInfo.Active];
    IsDockPanel := (WindowInfo.ViewType and VT_DOCKPANEL) = VT_DOCKPANEL;
    BodyColor := Brush.Color;

    if (WRP_BORDER and WindowInfo.RedrawPart) <> 0 then
    begin
      R := ARect;
      if not IsDockPanel then
        Brush.Color := WinFrameColors[WinState, wfpBorder]
      else
        Brush.Color := PnlFrameColors[WinState, wfpBorder];

      SaveIndex := SaveDC(Canvas.Handle);
      Sz := WindowInfo.FloatingBorderSize;
      with R, Sz do
        ExcludeClipRect(Canvas.Handle, Left + X, Top + Y, Right - X, Bottom - Y);
      FillRect(R);
      RestoreDC(Canvas.Handle, SaveIndex);
      InflateRect(R, -Sz.X, -Sz.Y);
      Pen.Color := BodyColor;
      with R do
        Rectangle(Left - 1, Top + GetSystemMetrics(SM_CYSMCAPTION) - 1, Right + 1, Bottom + 1);
    end;

    if not WindowInfo.ShowCaption then Exit;

    if (WindowInfo.ViewType and VT_TOOLBAR) = VT_TOOLBAR then
    begin
      CaptionColor := PopupFrameColor;//WinFrameColors[WinState, wfpCaption];
      CaptionText := WinFrameColors[WinState, wfpCaptionText];
    end
    else
    begin
      CaptionColor := PopupFrameColor;//PnlFrameColors[WinState, wfpCaption];
      CaptionText := PnlFrameColors[WinState, wfpCaptionText];
    end;

    // Caption
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
      Brush.Style := bsClear;
      R.Bottom := R.Bottom - 1;

      // rmkNew
      if CaptionOutline then
      begin
        Font.Color := gradCol1;
        R2 := R;
        for y := -2 to 1 do
          for x := -1 to 1 do
          begin
            R2.Top := R.Top + y;
            R2.Left := R.Left + x;
            DrawText(Canvas.Handle, WindowInfo.Caption, -1, R2,
              DT_SINGLELINE or DT_VCENTER or DT_END_ELLIPSIS or DT_HIDEPREFIX);
          end;
        Font.Color := CaptionText;
      end;

      DrawText(Canvas.Handle, WindowInfo.Caption, -1, R,
        DT_SINGLELINE or DT_VCENTER or DT_END_ELLIPSIS or DT_HIDEPREFIX);
    end;

    // Close button
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

      if BtnItemState = bisHot then
      begin
        FrameRectEx(Canvas.Handle, R, BtnItemColors[BtnItemState, ipFrame], True);
        if not AltCaption then
          FillRectEx(Canvas.Handle, R, BtnItemColors[BtnItemState, ipBody]);
        DrawButtonBitmap(Canvas, R, BtnItemColors[BtnItemState, ipText]);
      end else
        if BtnItemState = bisPressed then
        begin
          FrameRectEx(Canvas.Handle, R, WinFrameColors[wfsActive, wfpCaption], True);
          if not AltCaption then
            FillRectEx(Canvas.Handle, R, BtnItemColors[BtnItemState, ipBody]);
          DrawButtonBitmap(Canvas, R, BtnItemColors[BtnItemState, ipText]);
        end else
        begin
          FrameRectEx(Canvas.Handle, R, BtnItemColors[BtnItemState, ipFrame], True);
          if not AltCaption then
            FillRectEx(Canvas.Handle, R, BtnItemColors[BtnItemState, ipBody]);
          if AltCaption then
            DrawButtonBitmap(Canvas, R, HotColor)
          else
            DrawButtonBitmap(Canvas, R, WinFrameColors[wfsActive, wfpCaptionText]);
        end;
    end;
  end;
end;

procedure TTBXEos9Theme.PaintFrame(Canvas: TCanvas; const ARect: TRect; const ItemInfo: TTBXItemInfo);
var
  R: TRect;
  E: Boolean;
begin
  R := ARect;
  with ItemInfo do
  begin
    E := Enabled or (not Enabled and (HoverKind = hkKeyboardHover));
    if not E then
    begin
      InflateRect(R, -1, -1);
      FrameRectEx(Canvas.Handle, R, ToolBarColor, True);
    end
    else if Pushed or Selected {or Embedded} or (HoverKind <> hkNone) or // rmkO? Embedded ?
      ((ItemOptions and IO_DESIGNING) <> 0) then
    begin
      InflateRect(R, -1, -1);
      if Pushed then
        Canvas.Pen.Color := BtnItemColors[bisSelected, ipFrame]
      else
        Canvas.Pen.Color := GetPartColor(ItemInfo, ipFrame);
      InflateRect(R, 1, 1);
      RoundFrame(Canvas, R, 0, 0);
    end;
  end;
end;


function TTBXEos9Theme.GetImageOffset(Canvas: TCanvas;
  const ItemInfo: TTBXItemInfo; ImageList: TCustomImageList): TPoint;
begin
  Result.X := 0;
  if not (ImageList is TTBCustomImageList) then
    with ItemInfo do
      if Enabled and (HoverKind <> hkNone) and
        not (Selected or Pushed and not IsPopupParent) then
        Result.X := -1;
  Result.Y := Result.X
end;

procedure TTBXEos9Theme.PaintImage(Canvas: TCanvas; ARect: TRect;
  const ItemInfo: TTBXItemInfo; ImageList: TCustomImageList; ImageIndex: Integer);
var
  HiContrast: Boolean;
begin
  with ItemInfo do
  begin
    if ImageList is TTBCustomImageList then
    begin
      TTBCustomImageList(ImageList).DrawState(Canvas, ARect.Left, ARect.Top,
        ImageIndex, Enabled, (HoverKind <> hkNone), Selected);
      Exit;
    end;

{$IFNDEF ALTERNATIVE_DISABLED_STYLE}
    HiContrast := false; //IsDarkColor(GetItemImageBackground(ItemInfo), 64);

    if not Enabled then
    begin
      DrawTBXIconFlatShadow(Canvas, ARect, ImageList, ImageIndex,
        BtnItemColors[bisDisabled, ipText]);
    end
    else if Selected or Pushed or (HoverKind <> hkNone) then
    begin
      if not (Selected or Pushed and not IsPopupParent) then
      begin
        OffsetRect(ARect, 1, 1);
        DrawTBXIconFullShadow(Canvas, ARect, ImageList, ImageIndex, IconShadowColor);
        OffsetRect(ARect, -2, -2);
      end;
      DrawTBXIcon(Canvas, ARect, ImageList, ImageIndex, HiContrast);
    end
    else if HiContrast or TBXHiContrast or TBXLoColor then
      DrawTBXIcon(Canvas, ARect, ImageList, ImageIndex, HiContrast)
    else
      HighlightTBXIcon(Canvas, ARect, ImageList, ImageIndex, clWindow, 178);
{$ELSE}
    HiContrast := False; // ColorIntensity(GetItemImageBackground(ItemInfo)) < 80;
    if not Enabled then
    begin
      if not HiContrast then
        DrawTBXIconShadow(Canvas, ARect, ImageList, ImageIndex, 0)
      else
        DrawTBXIconFlatShadow(Canvas, ARect, ImageList, ImageIndex, clBtnShadow);
    end
    else if Selected or Pushed or (HoverKind <> hkNone) then
      DrawTBXIcon(Canvas, ARect, ImageList, ImageIndex, HiContrast)
    else if HiContrast or TBXHiContrast or TBXLoColor then
      DrawTBXIcon(Canvas, ARect, ImageList, ImageIndex, HiContrast)
    else // rmk Removed washed out glyphs
      HighlightTBXIcon(Canvas, ARect, ImageList, ImageIndex, clWindow, {178} 255);
{$ENDIF}
  end;
end;

procedure TTBXEos9Theme.PaintMDIButton(Canvas: TCanvas; ARect: TRect;
  const ItemInfo: TTBXItemInfo; ButtonKind: Cardinal);
var
  Index: Integer;
  X, Y: Integer;
  Bmp: TBitmap;
begin
  PaintButton(Canvas, ARect, ItemInfo);
  with ARect do
  begin
    X := (Left + Right - StockImgList.Width) div 2;
    Y := (Top + Bottom - StockImgList.Height) div 2;
  end;
  case ButtonKind of
    DFCS_CAPTIONMIN: Index := 2;
    DFCS_CAPTIONRESTORE: Index := 3;
    DFCS_CAPTIONCLOSE: Index := 0;
  else
    Exit;
  end;
  Bmp := TBitmap.Create;
  Bmp.Monochrome := True;
  StockImgList.GetBitmap(Index, Bmp);
  Canvas.Brush.Color := GetPartColor(ItemInfo, ipText);
  SetTextColor(Canvas.Handle, clBlack);
  SetBkColor(Canvas.Handle, clWhite);
  BitBlt(Canvas.Handle, X, Y, StockImgList.Width, StockImgList.Height,
    Bmp.Canvas.Handle, 0, 0, ROP_DSPDxax);
  Bmp.Free;
end;

procedure TTBXEos9Theme.PaintMenuItemFrame(Canvas: TCanvas;
  const ARect: TRect; const ItemInfo: TTBXItemInfo);
const
  ZERO_RECT: TRect = (Left: 0; Top: 0; Right: 0; Bottom: 0);
begin
  with ItemInfo do if (Enabled and (HoverKind <> hkNone)) or
    (not Enabled and (HoverKind = hkKeyboardHover)) then
    begin
      PaintBackgnd(Canvas, ZERO_RECT, ARect, ARect, MenuItemColors[misHot, ipBody], False, VT_UNKNOWN);
    end;
end;

procedure TTBXEos9Theme.PaintMenuItem(Canvas: TCanvas; const ARect: TRect; var ItemInfo: TTBXItemInfo);
var
  R, R2: TRect;
  X, Y: Integer;
  ArrowWidth: Integer;
  ClrText: TColor;

  procedure DrawArrow(AColor: TColor);
  begin
    Canvas.Pen.Color := AColor;
    Canvas.Brush.Color := AColor;
    Canvas.Polygon([Point(X, Y - 3), Point(X, Y + 3), Point(X + 3, Y)]);
  end;

  procedure PaintButton(Canvas: TCanvas; const ARect: TRect; const ItemInfo: TTBXItemInfo);
  var
    R: TRect;
    ShowHover, Embedded: Boolean;
  begin
    R := ARect;
    with ItemInfo, Canvas do
    begin
      ShowHover := (Enabled and (HoverKind <> hkNone)) or
        (not Enabled and (HoverKind = hkKeyboardHover));
      Embedded := (ViewType and VT_TOOLBAR = VT_TOOLBAR) and
        (ViewType and TVT_EMBEDDED = TVT_EMBEDDED);

      if ComboPart = cpSplitRight then Dec(R.Left);

      {
      if Embedded and not ShowHover then
      begin
        if Enabled then
        begin
          InflateRect(R, -1, -1);
          FillRectEx(Canvas.Handle, R, ToolBarColor);
          InflateRect(R, 1, 1);
          Pen.Color := Blend(clHighLight, clWindow, 20);
        end else
          Pen.Color := Blend(clHighLight, clWindow, 15);
      end;

      if ((ViewType and TVT_MENUBAR) = TVT_MENUBAR) and (not MenuButtons) then
      begin
        if ((Pushed or Selected) and Enabled) or ShowHover then
        begin
          PaintBackgnd(Canvas, ZERO_RECT, ARect, ARect, MenuItemColors[misHot, ipBody], False, VT_UNKNOWN);
        end;
        Exit;
      end;
      }
      if {(Pushed or Selected or ) and }Enabled then
      begin
        InflateRect(R, -1, -1);
        if HoverKind = hkNone then
        begin
          Pen.Color := BtnItemColors[bisSelected, ipFrame]
        end else
        begin
          Pen.Color := Blend(clHighLight, clWindow, 20);//BaseColor;
        end;
        if HoverKind = hkNone then
          Brush.Color:= BtnItemColors[bisSelected, ipBody]
        else
        if HoverKind = hkMouseHover then
          if Selected then
            Brush.Color:= BtnItemColors[bisPressed, ipBody]
          else
            Brush.Color:= PopupColor;
        FillRect(R);
        //Rectangle(R);
        InflateRect(R, 1, 1);
      end
      else if ShowHover or ((ItemOptions and IO_DESIGNING) <> 0) then
      begin
        Canvas.Pen.Color := Blend(clred, clWindow, 40); //rmkO
      end;
      if ComboPart = cpSplitRight then PaintDropDownArrow(Canvas, R, ItemInfo);
    end;
  end;

begin
  with Canvas, ItemInfo do
  begin
    ArrowWidth := GetSystemMetrics(SM_CXMENUCHECK);
    PaintMenuItemFrame(Canvas, ARect, ItemInfo);
    ClrText := GetPartColor(ItemInfo, ipText);
    R := ARect;

    if (ItemOptions and IO_COMBO) <> 0 then
    begin
      X := R.Right - ArrowWidth - 1;
      if not ItemInfo.Enabled then Pen.Color := ClrText
      else if HoverKind = hkMouseHover then Pen.Color := ClrText
      else Pen.Color := PopupSeparatorColor;
      MoveTo(X, R.Top + 1);
      LineTo(X, R.Bottom - 1);
    end;

    if (ItemOptions and IO_SUBMENUITEM) <> 0 then
    begin
      Y := ARect.Bottom div 2;
      X := ARect.Right - ArrowWidth * 2 div 3 - 1;
      DrawArrow(ClrText);
    end;

    R2:= ARect;
    InflateRect(R2, -1, -1);

    if ((Selected) and (Enabled)) then
    begin
      R.Left := R2.Left;
      R.Right := R.Left + ItemInfo.PopupMargin;
      //InflateRect(R, -1, -1); // smaller button in menu? rmkP
      PaintButton(Canvas, R, ItemInfo);
    end;
  end;
end;

procedure TTBXEos9Theme.PaintPopupNCArea(Canvas: TCanvas; R: TRect; const PopupInfo: TTBXPopupInfo);
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
          Pen.Color := ToolbarColor;
          if Bottom = R.Top then
          begin
            if Left <= R.Left then Left := R.Left - 1;
            if Right >= R.Right then Right := R.Right + 1;
            MoveTo(Left + 1, Bottom - 1);
            LineTo(Right - 1, Bottom - 1);
          end
          else if Top = R.Bottom then
          begin
            if Left <= R.Left then Left := R.Left - 1;
            if Right >= R.Right then Right := R.Right + 1;
            MoveTo(Left + 1, Top);
            LineTo(Right - 1, Top);
          end;
          if Right = R.Left then
          begin
            if Top <= R.Top then Top := R.Top - 1;
            if Bottom >= R.Bottom then Bottom := R.Bottom + 1;
            MoveTo(Right - 1, Top + 1);
            LineTo(Right - 1, Bottom - 1);
          end
          else if Left = R.Right then
          begin
            if Top <= R.Top then Top := R.Top - 1;
            if Bottom >= R.Bottom then Bottom := R.Bottom + 1;
            MoveTo(Left, Top + 1);
            LineTo(Left, Bottom - 1);
          end;
        end;
    end;
  end;
end;

procedure TTBXEos9Theme.PaintSeparator(Canvas: TCanvas; ARect: TRect;
  ItemInfo: TTBXItemInfo; Horizontal, LineSeparator: Boolean);
var
  IsToolbox: Boolean;
  R: TRect;
begin
  with ItemInfo, ARect, Canvas do
  begin
    if Horizontal then
    begin
      IsToolbox := (ViewType and PVT_TOOLBOX) = PVT_TOOLBOX;
      if ((ItemOptions and IO_TOOLBARSTYLE) = 0) and not IsToolBox then
      begin
        R := ARect;
        R.Right := ItemInfo.PopupMargin + 2;
        Brush.Color := ToolbarColor;
        Inc(Left, ItemInfo.PopupMargin + 9);
        Pen.Color := PopupSeparatorColor;
      end
      else
        Pen.Color := ToolbarSeparatorColor;

      if (ItemInfo.ViewType and VT_TOOLBAR) = VT_TOOLBAR then
      begin
        Top := Bottom div 2;
        Left := Left + 4;
        Right := Right - 2;
        Bottom := Top + 1;
        DrawLineEx(Canvas.Handle, Left, Top, Right, Top, ToolbarSeparatorColor);
      end else
      begin
        Top := Bottom div 2;
        MoveTo(14, Top); LineTo(Right - 14, Top);
      end;
    end else if Enabled then
    begin
      Top := Top + 2;
      Bottom := Bottom - 3;
      Left := Right div 2;
      DrawLineEx(Canvas.Handle, Left, Top, Left, Bottom, ToolbarSeparatorColor);
    end;
  end;
end;

procedure TTBXEos9Theme.PaintToolbarNCArea(Canvas: TCanvas; R: TRect;
   const ToolbarInfo: TTBXToolbarInfo);
const
  DragHandleOffsets: array[Boolean, DHS_DOUBLE..DHS_SINGLE] of Integer = ((2, 0, 1), (5, 0, 5));

  function GetBtnItemState(BtnState: Integer): TBtnItemState;
  begin
    if (BtnState and CDBS_PRESSED) <> 0 then Result := bisPressed
    else if (BtnState and CDBS_HOT) <> 0 then Result := bisHot
    else Result := bisNormal;
  end;

var
  Sz: Integer;
  R2: TRect;
  C, c1, c2: TColor;
  Hi1, Lo1, Hi2, Lo2, Hi3, Lo3, Hi4: TColor;
  I: Integer;
  BtnVisible, Horz: Boolean;
  BtnItemState: TBtnItemState;
begin
  with Canvas do
  begin
    if (ToolbarInfo.ViewType and TVT_MENUBAR) = TVT_MENUBAR then
      PaintBackgnd(Canvas, ZERO_RECT, R, R, MenubarColor, false, VT_UNKNOWN)
    else
      PaintBackgnd(Canvas, ZERO_RECT, R, R, ToolbarColor, false, VT_UNKNOWN);
    if ((ToolbarInfo.ViewType and TVT_NORMALTOOLBAR) = TVT_NORMALTOOLBAR)
      or (((ToolbarInfo.ViewType and TVT_MENUBAR) = TVT_MENUBAR))
      or ((ToolbarInfo.ViewType and TVT_TOOLWINDOW) = TVT_TOOLWINDOW)
      then
      if BarLines then
      begin
        c1:= Blend(ToolbarColor, clBtnHighlight,50);
        c2:= Blend(ToolbarColor, clBtnShadow, 50);
        if (ToolbarInfo.ViewType and TVT_MENUBAR) = TVT_MENUBAR then
        begin
          DrawLineEx(Canvas.Handle, R.Left, R.Bottom - 1, R.Right, R.Bottom - 1, c2);
          DrawLineEx(Canvas.Handle, R.Right - 1, R.Top + 1, R.Right - 1, R.Bottom - 1, c2);
        end else
        begin
          DrawLineEx(Canvas.Handle, R.Left, R.Bottom, R.Left, R.Top, c1); // Left
          DrawLineEx(Canvas.Handle, R.Left, R.Top, R.Right, R.Top, c1); // Top

          DrawLineEx(Canvas.Handle, R.Left + 1, R.Bottom - 1, R.Right, R.Bottom - 1, c2);  // Bottom
          DrawLineEx(Canvas.Handle, R.Right - 1, R.Top + 1, R.Right - 1, R.Bottom - 1, c2);  // Right
        end;
      end else
      begin
        R2 := R;
        while R2.Left < R.Right do
        begin
          Canvas.Pixels[R2.Left, R.Bottom - 1] := BarSepColor;
          R2.Left := R2.Left + 3;
        end;
        R2 := R;
        while R2.Top < R.Bottom - 1 do
        begin
          Canvas.Pixels[R2.Right - 1, R2.Top] := BarSepColor;
          R2.Top := R2.Top + 3;
        end;
      end;
    R.Top := R.Top + 1;
    InflateRect(R, -2, -2);

    if not ToolbarInfo.AllowDrag then Exit;

    BtnVisible := (ToolbarInfo.CloseButtonState and CDBS_VISIBLE) <> 0;
    Sz := GetTBXDragHandleSize(ToolbarInfo);
    Horz := not ToolbarInfo.IsVertical;
    if Horz then R.Right := R.Left + Sz
    else R.Bottom := R.Top + Sz;

    { Drag Handle }
    c := gradHandle1;
    Brush.Color := c;
    Hi1 := GetNearestColor(Handle, MixColors(c, gradHandle2, 64));
    Lo1 := GetNearestColor(Handle, MixColors(c, gradHandle2, 48));
    Hi2 := GetNearestColor(Handle, MixColors(c, gradHandle2, 32));
    Lo2 := GetNearestColor(Handle, MixColors(c, gradHandle2, 16));
    Hi3 := GetNearestColor(Handle, MixColors(c, gradHandle3, 128));
    Lo3 := GetNearestColor(Handle, MixColors(c, gradHandle3, 96));
    Hi4 := GetNearestColor(Handle, MixColors(c, gradHandle3, 72));

    if ToolbarInfo.DragHandleStyle <> DHS_NONE then
    begin
      R2 := R;
      if ToolbarInfo.DragHandleStyle = DHS_DOUBLE then
        if Horz then
          OffsetRect(R2, -2, 0)
        else
          OffsetRect(R2, 0, -2);
      if Horz then
      begin
        Inc(R2.Top, 3);
        Dec(R2.Bottom, 1);
        Inc(R2.Left, 1);
        if BtnVisible then begin
          Inc(R2.Top, Sz - 2);
          Inc(R2.Left, 4);
          Dec(R2.Right, 4);
        end;
        i := R2.Top;
        while (i < R2.Bottom - 3) do
        begin
          Pixels[R2.Left, i] := Hi1;
          Pixels[R2.Left, i + 1] := Hi2;
          Pixels[R2.Left + 1, i] := Lo1;
          Pixels[R2.Left + 1, i + 1] := Lo2;
          Pixels[R2.Left + 1, i + 2] := Hi4;
          Pixels[R2.Left + 2, i + 2] := Hi3;
          Pixels[R2.Left + 2, i + 1] := Lo3;
          if ToolbarInfo.DragHandleStyle = DHS_DOUBLE then
          begin
            Pixels[R2.Left + 4, i] := Hi1;
            Pixels[R2.Left + 4, i + 1] := Hi2;
            Pixels[R2.Left + 4 + 1, i] := Lo1;
            Pixels[R2.Left + 4 + 1, i + 1] := Lo2;
            Pixels[R2.Left + 4 + 1, i + 2] := Hi4;
            Pixels[R2.Left + 4 + 2, i + 2] := Hi3;
            Pixels[R2.Left + 4 + 2, i + 1] := Lo3;
          end;
          Inc(i, 4);
        end;
      end else
      begin
        Inc(R2.Left, 3);
        Dec(R2.Right, 1);
        Inc(R2.Top, 1);
        if BtnVisible then begin
          Dec(R2.Right, Sz - 2);
          Inc(R2.Top, 4);
          Dec(R2.Bottom, 4);
        end;
        i := R2.Left;
        while (i < R2.Right - 3) do
        begin
          Pixels[i, R2.Top] := Hi1;
          Pixels[i, R2.Top + 1] := Hi2;
          Pixels[i + 1, R2.Top] := Lo1;
          Pixels[i + 1, R2.Top + 1] := Lo2;
          Pixels[i + 1, R2.Top + 2] := Hi4;
          Pixels[i + 2, R2.Top + 2] := Hi3;
          Pixels[i + 2, R2.Top + 1] := Lo3;
          if ToolbarInfo.DragHandleStyle = DHS_DOUBLE then
          begin
            Pixels[i, R2.Top + 4] := Hi1;
            Pixels[i, R2.Top + 1 + 4] := Hi2;
            Pixels[i + 1, R2.Top + 4] := Lo1;
            Pixels[i + 1, R2.Top + 1 + 4] := Lo2;
            Pixels[i + 1, R2.Top + 2 + 4] := Hi4;
            Pixels[i + 2, R2.Top + 2 + 4] := Hi3;
            Pixels[i + 2, R2.Top + 1 + 4] := Lo3;
          end;
          Inc(i, 4);
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
      FrameRectEx(Canvas.Handle, R2, BtnItemColors[BtnItemState, ipFrame], True);
      FillRectEx(Canvas.Handle, R2, BtnItemColors[BtnItemState, ipBody]);
      DrawButtonBitmap(Canvas, R2, BtnItemColors[BtnItemState, ipText]);
    end;
  end;
end;

procedure TTBXEos9Theme.PaintDock(Canvas: TCanvas; const ClientRect,
  DockRect: TRect; DockPosition: Integer);
var
  R: TRect;
begin
  Canvas.Pen.Width := 0;
  Canvas.Brush.Style := bsSolid;
  Canvas.Brush.Color := clBtnFace;
  R := DockRect;
  InFlateRect(R, 1, 1);
  Canvas.Rectangle(R);
end;

procedure TTBXEos9Theme.PaintDockPanelNCArea(Canvas: TCanvas; R: TRect; const DockPanelInfo: TTBXDockPanelInfo);

  function GetBtnItemState(BtnState: Integer): TBtnItemState;
  begin
    if (BtnState and CDBS_PRESSED) <> 0 then Result := bisPressed
    else if (BtnState and CDBS_HOT) <> 0 then Result := bisHot
    else Result := bisNormal;
  end;

var
  C, C1, C2, HeaderColor: TColor;
  I, Sz, Flags, X, Y: Integer;
  R2: TRect;
  BtnItemState: TBtnItemState;
begin
  with Canvas, DockPanelInfo do
  begin
    C := Brush.Color; // Dock panel passes its body color in Canvas.Brush
    C1:= Blend(ToolbarColor, clBtnHighlight,50);
    C2:= Blend(ToolbarColor, clBtnShadow, 50);

    I := ColorIntensity(ColorToRGB(clBtnFace));
    R2 := R;
    if not TBXLoColor and (I in [64..250]) then
    begin
      FrameRectEx(Canvas.Handle, R, ToolbarColor, true);
      FrameRectEx(Canvas.Handle, R, ToolbarColor, false);
      R:= R2;
      DrawLineEx(Canvas.Handle, R.Left, R.Bottom, R.Left, R.Top, c1); // Left
      DrawLineEx(Canvas.Handle, R.Left, R.Top, R.Right, R.Top, c1); // Top
      DrawLineEx(Canvas.Handle, R.Left + 1, R.Bottom - 1, R.Right, R.Bottom - 1, c2);  // Bottom
      DrawLineEx(Canvas.Handle, R.Right - 1, R.Top + 1, R.Right - 1, R.Bottom - 1, c2);
    end
    else
    begin
      FrameRectEx(Canvas.Handle, R, clRed, True);
      if I < 64 then Brush.Bitmap := AllocPatternBitmap(C, clWhite)
      else Brush.Bitmap := AllocPatternBitmap(C, clBtnShadow);
      FrameRect(R);
      InflateRect(R, -1, -1);
      FrameRectEx(Canvas.Handle, R, C, True);
    end;
    R := R2;
    InflateRect(R, -BorderSize.X, -BorderSize.Y);
    Sz := GetSystemMetrics(SM_CYSMCAPTION);
    if IsVertical then
    begin
      R.Bottom := R.Top + Sz - 1;
      DrawLineEx(Canvas.Handle, R.Left, R.Bottom, R.Right, R.Bottom, ToolBarColor);
      HeaderColor := clBtnFace;
      R.Bottom := R.Bottom + 1;
      if AltCaption then
      begin
        Brush.Color := PnlFrameColors[wfsActive, wfpCaption]; // rmkCap
        FillRect(R);
      end else
      begin
        Brush.Color := PnlFrameColors[wfsActive, wfpCaption];
        FillRect(R);
        DrawLineEx(Canvas.Handle, R.Left, R.Bottom - 1, R.Right, R.Bottom - 1, ToolBarColor);
      end;
      R.Bottom := R.Bottom - 1;
    end
    else
    begin
      R.Right := R.Left + Sz - 1;
      DrawLineEx(Canvas.Handle, R.Right, R.Top, R.Right, R.Bottom, ToolBarColor);
      HeaderColor := clBtnFace;
      R.Right := R.Right + 1;
      if AltCaption then
      begin
        Brush.Color := PnlFrameColors[wfsActive, wfpCaption];
        FillRect(R);
      end else
      begin
        Brush.Color := PnlFrameColors[wfsActive, wfpCaption];
        FillRect(R);
        DrawLineEx(Canvas.Handle, R.Right - 1, R.Top, R.Right - 1, R.Bottom, BarSepColor);
      end;
      R.Right := R.Right - 1;
    end;

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
      if BtnItemState = bisHot then
      begin
        FrameRectEx(Canvas.Handle, R2, BtnItemColors[BtnItemState, ipFrame], True);
        if not AltCaption then
          FillRectEx(Canvas.Handle, R2, BtnItemColors[BtnItemState, ipBody]);
        DrawButtonBitmap(Canvas, R2, BtnItemColors[BtnItemState, ipText]);
      end else
        if BtnItemState = bisPressed then
        begin
          FrameRectEx(Canvas.Handle, R2, WinFrameColors[wfsActive, wfpCaption], True);
          if not AltCaption then
            FillRectEx(Canvas.Handle, R2, BtnItemColors[BtnItemState, ipBody]);
          DrawButtonBitmap(Canvas, R2, BtnItemColors[BtnItemState, ipText]);
        end else
        begin
          FrameRectEx(Canvas.Handle, R2, BtnItemColors[BtnItemState, ipFrame], True);
          if not AltCaption then
            FillRectEx(Canvas.Handle, R2, BtnItemColors[BtnItemState, ipBody]);
          if AltCaption then
            DrawButtonBitmap(Canvas, R2, HotColor)
          else
            DrawButtonBitmap(Canvas, R2, WinFrameColors[wfsActive, wfpCaptionText]);
        end;
    end;

    if IsVertical then InflateRect(R, -4, 0)
    else InflateRect(R, 0, -4);
    Font.Assign(SmCaptionFont);
    if AltCaption then
      Font.Color := HotColor
    else
      Font.Color := WinFrameColors[wfsActive, wfpCaptionText];
    Brush.Color := HeaderColor;
    Brush.Style := bsClear;
    Flags := DT_SINGLELINE or DT_VCENTER or DT_END_ELLIPSIS or DT_HIDEPREFIX;

    // rmkNew
    if CaptionOutline then
    begin
      R2 := R;
      C := Font.Color;
      Font.Color := gradCol1;
      R2 := R;
      for y := -1 to 2 do
        for x := -1 to 1 do
        begin
          R2.Top := R.Top + y;
          R2.Left := R.Left + x;
          if IsVertical then DrawText(Canvas.Handle, Caption, -1, R2, Flags)
          else DrawRotatedText(Canvas.Handle, string(Caption), R2, Flags);
        end;
      Font.Color := C;
    end;

    if IsVertical then DrawText(Canvas.Handle, Caption, -1, R, Flags)
    else DrawRotatedText(Canvas.Handle, string(Caption), R, Flags);
  end;
end;

procedure TTBXEos9Theme.SetupColorCache;
var
  DC: HDC;
  HotBtnFace, DisabledText: TColor;

  procedure Undither(var C: TColor);
  begin
    if C <> clNone then C := GetNearestColor(DC, ColorToRGB(C));
  end;

begin
  DC := StockCompatibleBitmap.Canvas.Handle;

  BaseColor:= clBtnFace;

  HotColor:= clHighLightText;//Blend(clBtnFace, clBtnHighLight, 50);
  SetContrast(HotColor, BaseColor, 120);

  gradCol1 := Blend(BaseColor, clBtnHighlight, 80);
  gradCol2 := clWhite;

  gradHandle1 := Blend(BaseColor, clWhite, 75);
  gradHandle2 := Blend(BaseColor, clBlack, 35);
  gradHandle3 := clWhite;

  gradBL := NearestMixedColor(BaseColor, gradCol1, 64);

  MenubarColor := BaseColor;
  ToolbarColor := MenuBarColor;

  PopupColor := clWindow;
  DockPanelColor := PopupColor;
  PopupFrameColor := Blend(BaseColor, clBtnShadow, 40);

  BarSepColor := Blend(ToolBarColor, clBtnShadow, 50);

  EditFrameColor := ToolBarColor;
  EditFrameDisColor := Blend(ToolbarColor, clBtnHighlight, 75); ;

  HotBtnFace := BaseColor;
  SetContrast(HotBtnFace, ToolbarColor, 50);
  DisabledText := clBtnFace;

  WinFrameColors[wfsActive, wfpBorder] := Blend(BaseColor, clBtnShadow, 40);
  WinFrameColors[wfsActive, wfpCaption] := ToolbarColor;//Blend(BaseColor, clBtnShadow, 40); {85}
  WinFrameColors[wfsActive, wfpCaptionText] := clBtnText;

  WinFrameColors[wfsInactive, wfpBorder] := WinFrameColors[wfsActive, wfpBorder];
  WinFrameColors[wfsInactive, wfpCaption] := WinFrameColors[wfsActive, wfpBorder];
  WinFrameColors[wfsInactive, wfpCaptionText] := clBtnText;
  SetContrast(WinFrameColors[wfsInactive, wfpCaptionText], BaseColor, 120);

  PnlFrameColors[wfsActive, wfpBorder] := WinFrameColors[wfsActive, wfpBorder];
  PnlFrameColors[wfsActive, wfpCaption] := WinFrameColors[wfsActive, wfpCaption];
  PnlFrameColors[wfsActive, wfpCaptionText] := WinFrameColors[wfsActive, wfpCaptionText];

  PnlFrameColors[wfsInactive, wfpBorder] := clBtnFace;
  PnlFrameColors[wfsInactive, wfpCaption] := clBtnShadow;
  PnlFrameColors[wfsInactive, wfpCaptionText] := clBtnText;
  SetContrast(PnlFrameColors[wfsInactive, wfpCaptionText], BaseColor, 120);

  BtnItemColors[bisNormal, ipBody] := clNone;
  BtnItemColors[bisNormal, ipText] := clBtnText;
  SetContrast(BtnItemColors[bisNormal, ipText], ToolbarColor, 180);
  BtnItemColors[bisNormal, ipFrame] := clNone;

  BtnItemColors[bisDisabled, ipBody] := clNone;
  BtnItemColors[bisDisabled, ipText] := Blend(clBtnText, ToolbarColor, 25);
  SetContrast(BtnItemColors[bisDisabled, ipText], ToolbarColor, 80);
  BtnItemColors[bisDisabled, ipFrame] := Blend(BaseColor, clBtnHighlight, 75);

  BtnItemColors[bisSelected, ipBody] := Blend(clBtnHighlight, clHighLight, 50);//Blend(clBtnHighlight, ToolbarColor, 75);
  BtnItemColors[bisSelected, ipText] := clHighlightText;
  BtnItemColors[bisSelected, ipFrame] := clHighlight;

  BtnItemColors[bisPressed, ipBody] := Blend(ToolbarColor, clHighLight, 50);
  BtnItemColors[bisPressed, ipText] := clHighlightText;
  BtnItemColors[bisPressed, ipFrame] := clHighlight;

  BtnItemColors[bisHot, ipBody] := Blend(clBtnHighlight, clHighLight, 50);
  BtnItemColors[bisHot, ipText] := clHighlightText;
  BtnItemColors[bisHot, ipFrame]:= Blend(clBtnHighlight, clHighLight, 50);

  BtnItemColors[bisDisabledHot, ipBody] := clRed; // ???
  BtnItemColors[bisDisabledHot, ipText] := clRed;
  BtnItemColors[bisDisabledHot, ipFrame] := clNone;

  BtnItemColors[bisSelectedHot, ipBody] := Blend(ToolbarColor, clHighLight, 75);
  BtnItemColors[bisSelectedHot, ipText] := clHighlightText;
  BtnItemColors[bisSelectedHot, ipFrame] := BaseColor;

  BtnItemColors[bisPopupParent, ipBody] := BtnItemColors[bisHot, ipBody];
  BtnItemColors[bisPopupParent, ipText] := clHighLightText;
  BtnItemColors[bisPopupParent, ipFrame] := BtnItemColors[bisHot, ipFrame];

  MenuItemColors[misNormal, ipBody] := clNone;
  MenuItemColors[misNormal, ipText] := clBtnText;
  SetContrast(MenuItemColors[misNormal, ipText], PopupColor, 180);
  MenuItemColors[misNormal, ipFrame] := clNone;

  MenuItemColors[misDisabled, ipBody] := clNone;
  MenuItemColors[misDisabled, ipText] := BtnItemColors[bisDisabled, ipText];
  SetContrast(MenuItemColors[misDisabled, ipText], PopupColor, 80);
  MenuItemColors[misDisabled, ipFrame] := clNone;

  MenuItemColors[misHot, ipBody] := BtnItemColors[bisHot, ipBody];
  MenuItemColors[misHot, ipText] := BtnItemColors[bisHot, ipText];
  MenuItemColors[misHot, ipFrame] := BtnItemColors[bisHot, ipFrame];

  MenuItemColors[misDisabledHot, ipBody] := PopupColor;
  MenuItemColors[misDisabledHot, ipText] := Blend(BaseColor, clWhite, 50);
  MenuItemColors[misDisabledHot, ipFrame] := clNone;

  DragHandleColor := Blend(BaseColor, clWhite, 60);
  SetContrast(DragHandleColor, ToolbarColor, 85);
  IconShadowColor := Blend(clBtnShadow, HotBtnFace, 25);

  ToolbarSeparatorColor := Blend(BaseColor, clBtnShadow, 60);
  PopupSeparatorColor := ToolbarSeparatorColor;

  Undither(MenubarColor);
  Undither(ToolbarColor);
  Undither(PopupColor);
  Undither(DockPanelColor);
  Undither(PopupFrameColor);
  Undither(WinFrameColors[wfsActive, wfpBorder]);
  Undither(WinFrameColors[wfsActive, wfpCaption]);
  Undither(WinFrameColors[wfsActive, wfpCaptionText]);
  Undither(WinFrameColors[wfsInactive, wfpBorder]);
  Undither(WinFrameColors[wfsInactive, wfpCaption]);
  Undither(WinFrameColors[wfsInactive, wfpCaptionText]);
  Undither(PnlFrameColors[wfsActive, wfpBorder]);
  Undither(PnlFrameColors[wfsActive, wfpCaption]);
  Undither(PnlFrameColors[wfsActive, wfpCaptionText]);
  Undither(PnlFrameColors[wfsInactive, wfpBorder]);
  Undither(PnlFrameColors[wfsInactive, wfpCaption]);
  Undither(PnlFrameColors[wfsInactive, wfpCaptionText]);
  Undither(BtnItemColors[bisNormal, ipBody]);
  Undither(BtnItemColors[bisNormal, ipText]);
  Undither(BtnItemColors[bisNormal, ipFrame]);
  Undither(BtnItemColors[bisDisabled, ipBody]);
  Undither(BtnItemColors[bisDisabled, ipText]);
  Undither(BtnItemColors[bisDisabled, ipFrame]);
  Undither(BtnItemColors[bisSelected, ipBody]);
  Undither(BtnItemColors[bisSelected, ipText]);
  Undither(BtnItemColors[bisSelected, ipFrame]);
  Undither(BtnItemColors[bisPressed, ipBody]);
  Undither(BtnItemColors[bisPressed, ipText]);
  Undither(BtnItemColors[bisPressed, ipFrame]);
  Undither(BtnItemColors[bisHot, ipBody]);
  Undither(BtnItemColors[bisHot, ipText]);
  Undither(BtnItemColors[bisHot, ipFrame]);
  Undither(BtnItemColors[bisDisabledHot, ipBody]);
  Undither(BtnItemColors[bisDisabledHot, ipText]);
  Undither(BtnItemColors[bisDisabledHot, ipFrame]);
  Undither(BtnItemColors[bisSelectedHot, ipBody]);
  Undither(BtnItemColors[bisSelectedHot, ipText]);
  Undither(BtnItemColors[bisSelectedHot, ipFrame]);
  Undither(BtnItemColors[bisPopupParent, ipBody]);
  Undither(BtnItemColors[bisPopupParent, ipText]);
  Undither(BtnItemColors[bisPopupParent, ipFrame]);
  Undither(MenuItemColors[misNormal, ipBody]);
  Undither(MenuItemColors[misNormal, ipText]);
  Undither(MenuItemColors[misNormal, ipFrame]);
  Undither(MenuItemColors[misDisabled, ipBody]);
  Undither(MenuItemColors[misDisabled, ipText]);
  Undither(MenuItemColors[misDisabled, ipFrame]);
  Undither(MenuItemColors[misHot, ipBody]);
  Undither(MenuItemColors[misHot, ipText]);
  Undither(MenuItemColors[misHot, ipFrame]);
  Undither(MenuItemColors[misDisabledHot, ipBody]);
  Undither(MenuItemColors[misDisabledHot, ipText]);
  Undither(MenuItemColors[misDisabledHot, ipFrame]);
  Undither(DragHandleColor);
  Undither(IconShadowColor);
  Undither(ToolbarSeparatorColor);
  Undither(PopupSeparatorColor);
  Undither(StatusPanelFrameColor);
end;

function TTBXEos9Theme.GetPopupShadowType: Integer;
begin
  Result := PST_WINDOWS2K;
end;

constructor TTBXEos9Theme.Create(const AName: string);
begin
  inherited;
  if CounterLock = 0 then InitializeStock;
  Inc(CounterLock);
  AddTBXSysChangeNotification(Self);
  SetupColorCache;
end;

destructor TTBXEos9Theme.Destroy;
begin
  RemoveTBXSysChangeNotification(Self);
  Dec(CounterLock);
  if CounterLock = 0 then FinalizeStock;
  inherited;
end;

procedure TTBXEos9Theme.GetViewMargins(ViewType: Integer;
  out Margins: TTBXMargins);
begin
  Margins.LeftWidth := 0;
  Margins.TopHeight := 0;
  Margins.RightWidth := 0;
  Margins.BottomHeight := 0;
end;

procedure TTBXEos9Theme.PaintPageScrollButton(Canvas: TCanvas;
  const ARect: TRect; ButtonType: Integer; Hot: Boolean);
var
  R: TRect;
  X, Y, Sz: Integer;
begin
  R := ARect;
  InflateRect(R, -1, -1);
  if Hot then
  begin
    Canvas.Brush.Color:= BtnItemColors[bisHot, ipBody];
    Canvas.FillRect(R);;
    Canvas.Pen.Color := BtnItemColors[bisHot, ipFrame];
  end
  else
  begin
    Canvas.Brush.Color := ToolBarColor;
    Canvas.FillRect(R);
    Canvas.Pen.Color := BtnItemColors[bisNormal, ipFrame];
  end;
  InflateRect(R, 1, 1);

  Canvas.Pen.Color := ToolBarColor;

  { Arrow }
  X := (R.Left + R.Right) div 2;
  Y := (R.Top + R.Bottom) div 2;
  Sz := Min(X - R.Left, Y - R.Top) * 3 div 4;
  if hot then
    Canvas.Pen.Color := BtnItemColors[bisHot, ipText]
  else
    Canvas.Pen.Color := BtnItemColors[bisNormal, ipText];
  Canvas.Brush.Color := Canvas.Pen.Color;
  case ButtonType of
    PSBT_UP:
      begin
        Inc(Y, Sz div 2);
        Canvas.Polygon([Point(X + Sz, Y), Point(X, Y - Sz), Point(X - Sz, Y)]);
      end;
    PSBT_DOWN:
      begin
        Y := (R.Top + R.Bottom - 1) div 2;
        Dec(Y, Sz div 2);
        Canvas.Polygon([Point(X + Sz, Y), Point(X, Y + Sz), Point(X - Sz, Y)]);
      end;
    PSBT_LEFT:
      begin
        Inc(X, Sz div 2);
        Canvas.Polygon([Point(X, Y + Sz), Point(X - Sz, Y), Point(X, Y - Sz)]);
      end;
    PSBT_RIGHT:
      begin
        X := (R.Left + R.Right - 1) div 2;
        Dec(X, Sz div 2);
        Canvas.Polygon([Point(X, Y + Sz), Point(X + Sz, Y), Point(X, Y - Sz)]);
      end;
  end;
end;

procedure TTBXEos9Theme.PaintFrameControl(Canvas: TCanvas; R: TRect; Kind, State: Integer; Params: Pointer);
var
  X, Y: Integer;

  procedure SetupPen;
  begin
    if Boolean(State and PFS_DISABLED) then Canvas.Pen.Color := clBtnShadow
    else if Boolean(State and PFS_PUSHED) then Canvas.Pen.Color := BtnItemColors[bisPressed, ipFrame]
    else if Boolean(State and PFS_HOT) then Canvas.Pen.Color := BtnItemColors[bisHot, ipFrame]
    else Canvas.Pen.Color := BtnItemColors[bisNormal, ipText];
  end;

  procedure SetupBrush;
  begin
    Canvas.Brush.Style := bsSolid;
    if Boolean(State and PFS_DISABLED) then Canvas.Brush.Style := bsClear
    else if Boolean(State and PFS_PUSHED) then Canvas.Brush.Color := BtnItemColors[bisPressed, ipBody]
    else if Boolean(State and PFS_HOT) then Canvas.Brush.Color := BtnItemColors[bisHot, ipBody]
    else if Boolean(State and PFS_MIXED) then Canvas.Brush.Bitmap := AllocPatternBitmap(clWindow, clBtnFace)
    else Canvas.Brush.Style:= bsClear;//[bisNormal, ipBody];
  end;

  function TextColor: TColor;
  begin
    if Boolean(State and PFS_DISABLED) then Result := BtnItemColors[bisDisabled, ipText]
    else if Boolean(State and PFS_PUSHED) then Result := BtnItemColors[bisPressed, ipText]
    else if Boolean(State and PFS_MIXED) then Result := clBtnShadow
    else if Boolean(State and PFS_HOT) then Result := BtnItemColors[bisHot, ipText]
    else Result := BtnItemColors[bisNormal, ipText];
  end;

  {
  procedure DiagLine(C: TColor);
  begin
    with Canvas, R do
    begin
      Pen.Color := C;
      MoveTo(Right - 1 - X, Bottom - 1); LineTo(Right, Bottom - X - 2);
      Inc(X);
    end;
  end;
  }

begin
  with Canvas do
    case Kind of
      PFC_CHECKBOX:
        begin
          SetupPen;
          SetupBrush;
          //InflateRect(R, -1, -1);
          //Brush.Color:= Pen.Color;
          with R do Rectangle(Left, Top, Right, Bottom);
          {
          begin
            if Boolean(State and not (PFS_CHECKED)) then
            //if Boolean(State and (PFS_CHECKED or PFS_HOT)) then
            begin
              Pen.Color:= Blend(BarSepColor, ClWhite, 50);
              MoveTo(R.Left, R.Bottom);
              LineTo(R.Left, R.Top);
              LineTo(R.Right, R.Top);
              Pen.Color:= BarSepColor;
              MoveTo(R.Right, R.Top);
              LineTo(R.Right, R.Bottom);
              LineTo(R.Left, R.Bottom);
            end
            else
            begin
              Pen.Color:= BarSepColor;
              MoveTo(R.Left, R.Bottom - 1);
              LineTo(R.Left, R.Top);
              LineTo(R.Right, R.Top);
              Pen.Color:= Blend(BarSepColor, ClWhite, 50);
              MoveTo(R.Right, R.Top);
              LineTo(R.Right, R.Bottom);
              LineTo(R.Left, R.Bottom);
              //Rectangle(Left, Top, Right, Bottom);
            end;
          end;
          }

          Pen.Style := psSolid;
          Brush.Style := bsSolid;

          if Boolean(State and (PFS_CHECKED or PFS_MIXED)) then
          begin
            X := (R.Left + R.Right) div 2 - 1;
            Y := (R.Top + R.Bottom) div 2 + 1;
            Pen.Color := TextColor;
            Brush.Color := Pen.Color;
            Polygon([Point(X - 2, Y), Point(X, Y + 2), Point(X + 4, Y - 2),
              Point(X + 4, Y - 4), Point(X, Y), Point(X - 2, Y - 2), Point(X - 2, Y)]);
          end;
        end;
      PFC_RADIOBUTTON:
        begin
          SetupPen;
          SetupBrush;
          InflateRect(R, -1, -1);
          with R do Ellipse(Left, Top, Right, Bottom);
          Pen.Style := psSolid;
          Brush.Style := bsSolid;
          if Boolean(State and PFS_CHECKED) then
          begin
            InflateRect(R, -3, -3);
            Pen.Color := TextColor;
            Brush.Color := Pen.Color;
            with R do Ellipse(Left, Top, Right, Bottom);
          end;
        end;
    end;
end;

procedure TTBXEos9Theme.PaintStatusBar(Canvas: TCanvas; R: TRect; Part: Integer);
const
  ZERO_RECT: TRect = (Left: 0; Top: 0; Right: 0; Bottom: 0);
var
  Color, Hi, Lo, Lo1, Hi1, Lo2, Hi2, Lo3, Hi3, Hi4: TColor;
  D, Sz, i: Integer;

  procedure DiagLine(C: TColor);
  begin
    with R do
      DrawLineEx(Canvas.Handle, Right - 1 - D, Bottom - 1, Right, Bottom - D - 2, C);
    Inc(D);
  end;

begin
  with Canvas do
    case Part of
      SBP_BODY:
        begin
          PaintBackgnd(Canvas, ZERO_RECT, R, R, ToolBarColor, False, VT_UNKNOWN);
          DrawLineEx(Canvas.Handle, R.Left, R.Top, R.Right, R.Top, Blend(ToolbarColor, clBtnHighlight,50));
        end;
      SBP_PANE, SBP_LASTPANE:
        begin
          if Part = SBP_PANE then Dec(R.Right, 3);
          R.Top := R.Top + 2;
          R.Bottom := R.Bottom - 3;
          R.Left := R.Right;
          DrawLineEx(Canvas.Handle, R.Left, R.Top, R.Left, R.Bottom, ToolbarSeparatorColor);
        end;
      SBP_GRIPPER:
        if DottedGrip then
        begin
          Color := gradHandle1;
          Hi1 := GetNearestColor(Handle, MixColors(Color, gradHandle2, 64));
          Lo1 := GetNearestColor(Handle, MixColors(Color, gradHandle2, 48));
          Hi2 := GetNearestColor(Handle, MixColors(Color, gradHandle2, 32));
          Lo2 := GetNearestColor(Handle, MixColors(Color, gradHandle2, 16));
          Hi3 := GetNearestColor(Handle, MixColors(Color, gradHandle3, 128));
          Lo3 := GetNearestColor(Handle, MixColors(Color, gradHandle3, 96));
          Hi4 := GetNearestColor(Handle, MixColors(Color, gradHandle3, 72));

          with R do
          begin
            Pixels[Right - 12, Bottom - 4] := Lo2;
            Pixels[Right - 12, Bottom - 3] := Hi2;
            Pixels[Right - 11, Bottom - 4] := Lo1;
            Pixels[Right - 11, Bottom - 3] := Hi1;
            Pixels[Right - 11, Bottom - 2] := Hi4;
            Pixels[Right - 10, Bottom - 2] := Hi3;
            Pixels[Right - 10, Bottom - 3] := Lo3;

            Pixels[Right - 8, Bottom - 4] := Lo2;
            Pixels[Right - 8, Bottom - 3] := Hi2;
            Pixels[Right - 7, Bottom - 4] := Lo1;
            Pixels[Right - 7, Bottom - 3] := Hi1;
            Pixels[Right - 7, Bottom - 2] := Hi4;
            Pixels[Right - 6, Bottom - 2] := Hi3;
            Pixels[Right - 6, Bottom - 3] := Lo3;

            Pixels[Right - 4, Bottom - 4] := Lo2;
            Pixels[Right - 4, Bottom - 3] := Hi2;
            Pixels[Right - 3, Bottom - 4] := Lo1;
            Pixels[Right - 3, Bottom - 3] := Hi1;
            Pixels[Right - 3, Bottom - 2] := Hi4;
            Pixels[Right - 2, Bottom - 2] := Hi3;
            Pixels[Right - 2, Bottom - 3] := Lo3;

            Pixels[Right - 8, Bottom - 8] := Lo2;
            Pixels[Right - 8, Bottom - 7] := Hi2;
            Pixels[Right - 7, Bottom - 8] := Lo1;
            Pixels[Right - 7, Bottom - 7] := Hi1;
            Pixels[Right - 7, Bottom - 6] := Hi4;
            Pixels[Right - 6, Bottom - 6] := Hi3;
            Pixels[Right - 6, Bottom - 7] := Lo3;

            Pixels[Right - 4, Bottom - 8] := Lo2;
            Pixels[Right - 4, Bottom - 7] := Hi2;
            Pixels[Right - 3, Bottom - 8] := Lo1;
            Pixels[Right - 3, Bottom - 7] := Hi1;
            Pixels[Right - 3, Bottom - 6] := Hi4;
            Pixels[Right - 2, Bottom - 6] := Hi3;
            Pixels[Right - 2, Bottom - 7] := Lo3;

            Pixels[Right - 4, Bottom - 12] := Lo2;
            Pixels[Right - 4, Bottom - 11] := Hi2;
            Pixels[Right - 3, Bottom - 12] := Lo1;
            Pixels[Right - 3, Bottom - 11] := Hi1;
            Pixels[Right - 3, Bottom - 10] := Hi4;
            Pixels[Right - 2, Bottom - 10] := Hi3;
            Pixels[Right - 2, Bottom - 11] := Lo3;
          end;
        end else
        begin
          Sz := Min(R.Right - R.Left, R.Bottom - R.Top);
          Hi := NearestMixedColor(clBtnFace, clBtnHighlight, 64);
          Lo := NearestMixedColor(clBtnFace, clBtnShadow, 64);

          D := 2;
          for I := 1 to 3 do
          begin
            case Sz of
              0..8:
                begin
                  DiagLine(Lo);
                  DiagLine(Hi);
                end;
              9..12:
                begin
                  DiagLine(Lo);
                  DiagLine(Hi);
                  Inc(D);
                end;
            else
              DiagLine(Lo);
              Inc(D, 1);
              DiagLine(Hi);
              Inc(D, 1);
            end;
          end;
        end;
    end;
end;

procedure TTBXEos9Theme.TBXSysCommand(var Message: TMessage);
begin
  if Message.WParam = TSC_VIEWCHANGE then SetupColorCache;
end;

initialization
  BarLines := true;
  RegisterTBXTheme('Eos9', TTBXEos9Theme);
end.

