{*
 * "Echo" Theme for TBX
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

unit TBXEchoTheme;

interface

uses
  Windows, Messages, Graphics, TBXThemes, ImgList;

{$DEFINE ALTERNATIVE_DISABLED_STYLE}
{.$DEFINE ALT_HEADER_STYLE}
{.$DEFINE ALT_VISUAL_STYLE}

type
  TItemPart = (ipBody, ipText, ipFrame);
  TBtnItemState = (bisNormal, bisDisabled, bisSelected, bisPressed, bisHot,
    bisDisabledHot, bisSelectedHot, bisPopupParent);
  TMenuItemState = (misNormal, misDisabled, misHot, misDisabledHot);
  TWinFramePart = (wfpBorder, wfpCaption, wfpCaptionText);
  TWinFrameState = (wfsActive, wfsInactive);

  TTBXEchoTheme = class(TTBXTheme)
  private
    procedure TBXSysCommand(var Message: TMessage); message TBX_SYSCOMMAND;
  protected
    { View/Window Colors }
    MenubarColor: TColor;
    ToolbarColor: TColor;
    PopupColor: TColor;
    DockPanelColor: TColor;

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
    function GetPartColor(const ItemInfo: TTBXItemInfo; ItemPart: TItemPart):
      TColor;
    function GetBtnColor(const ItemInfo: TTBXItemInfo; ItemPart: TItemPart):
      TColor;
  public
    constructor Create(const AName: string); override;
    destructor Destroy; override;

    { Metrics access}
    function GetBooleanMetrics(Index: Integer): Boolean; override;
    function GetImageOffset(Canvas: TCanvas; const ItemInfo: TTBXItemInfo;
      ImageList: TCustomImageList): TPoint; override;
    function GetIntegerMetrics(Index: Integer): Integer; override;
    function GetItemColor(const ItemInfo: TTBXItemInfo): TColor; override;
    function GetItemTextColor(const ItemInfo: TTBXItemInfo): TColor; override;
    function GetItemImageBackground(const ItemInfo: TTBXItemInfo): TColor;
      override;
    procedure GetMargins(MarginID: Integer; out Margins: TTBXMargins); override;
    function GetPopupShadowType: Integer; override;
    procedure GetViewBorder(ViewType: Integer; out Border: TPoint); override;
    function GetViewColor(AViewType: Integer): TColor; override;
    procedure GetViewMargins(ViewType: Integer; out Margins: TTBXMargins);
      override;

    { Painting routines }
    procedure PaintBackgnd(Canvas: TCanvas; const ADockRect, ARect, AClipRect:
      TRect; AColor: TColor; Transparent: Boolean; AViewType: Integer);
      override;
    procedure PaintButton(Canvas: TCanvas; const ARect: TRect; const ItemInfo:
      TTBXItemInfo); override;
    procedure PaintCaption(Canvas: TCanvas; const ARect: TRect; const ItemInfo:
      TTBXItemInfo; const ACaption: string; AFormat: Cardinal; Rotated:
      Boolean);
      override;
    procedure PaintCheckMark(Canvas: TCanvas; ARect: TRect; const ItemInfo:
      TTBXItemInfo); override;
    procedure PaintChevron(Canvas: TCanvas; ARect: TRect; const ItemInfo:
      TTBXItemInfo); override;
    procedure PaintDock(Canvas: TCanvas; const ClientRect, DockRect: TRect;
      DockPosition: Integer); override;
    procedure PaintDockPanelNCArea(Canvas: TCanvas; R: TRect; const
      DockPanelInfo: TTBXDockPanelInfo); override;
    procedure PaintDropDownArrow(Canvas: TCanvas; const ARect: TRect; const
      ItemInfo: TTBXItemInfo); override;
    procedure PaintEditButton(Canvas: TCanvas; const ARect: TRect; var ItemInfo:
      TTBXItemInfo; ButtonInfo: TTBXEditBtnInfo); override;
    procedure PaintEditFrame(Canvas: TCanvas; const ARect: TRect; var ItemInfo:
      TTBXItemInfo; const EditInfo: TTBXEditInfo); override;
    procedure PaintFloatingBorder(Canvas: TCanvas; const ARect: TRect; const
      WindowInfo: TTBXWindowInfo); override;
    procedure PaintFrame(Canvas: TCanvas; const ARect: TRect; const ItemInfo:
      TTBXItemInfo); override;
    procedure PaintImage(Canvas: TCanvas; ARect: TRect; const ItemInfo:
      TTBXItemInfo; ImageList: TCustomImageList; ImageIndex: Integer); override;
    procedure PaintMDIButton(Canvas: TCanvas; ARect: TRect; const ItemInfo:
      TTBXItemInfo; ButtonKind: Cardinal); override;
    procedure PaintMenuItem(Canvas: TCanvas; const ARect: TRect; var ItemInfo:
      TTBXItemInfo); override;
    procedure PaintMenuItemFrame(Canvas: TCanvas; const ARect: TRect; const
      ItemInfo: TTBXItemInfo); override;
    procedure PaintPageScrollButton(Canvas: TCanvas; const ARect: TRect;
      ButtonType: Integer; Hot: Boolean); override;
    procedure PaintPopupNCArea(Canvas: TCanvas; R: TRect; const PopupInfo:
      TTBXPopupInfo); override;
    procedure PaintSeparator(Canvas: TCanvas; ARect: TRect; ItemInfo:
      TTBXItemInfo; Horizontal, LineSeparator: Boolean); override;
    procedure PaintToolbarNCArea(Canvas: TCanvas; R: TRect; const ToolbarInfo:
      TTBXToolbarInfo); override;
    procedure PaintFrameControl(Canvas: TCanvas; R: TRect; Kind, State: Integer;
      Params: Pointer); override;
    procedure PaintStatusBar(Canvas: TCanvas; R: TRect; Part: Integer);
      override;
  end;

{$IFDEF DTM_Package}
function TBXThemeName: shortstring; stdcall;
procedure TBXRegisterTheme(RegisterTheme: boolean); stdcall;
{$ENDIF}

implementation

{.$R tbx_glyphs.res}

uses
  TBXUtils, TB2Common, TB2Item, Classes, Controls, Commctrl, Forms, rmkThemes;

{$IFDEF DTM_Package}
exports
  TBXThemeName,
  TBXRegisterTheme;

const
  cThemeName = 'Echo';

function TBXThemeName: shortstring; stdcall;
begin
  result := cThemeName;
end;

procedure TBXRegisterTheme(RegisterTheme: boolean); stdcall;
begin
  if RegisterTheme then
    RegisterTBXTheme(cThemeName, TTBXEchoTheme)
  else
    UnregisterTBXTheme(cThemeName);
end;
{$ENDIF}

var
  StockImgList: TImageList;
  CounterLock: Integer;
  GradientBmp: TBitmap;
  gradCol1, gradCol2, gradHandle1, gradHandle2, gradHandle3, gradBL: TColor;

procedure InitializeStock;
begin
  StockImgList := TImageList.Create(nil);
  StockImgList.Handle := ImageList_LoadBitmap(HInstance, 'TBXGLYPHS', 16, 0,
    clWhite);
  GradientBmp := TBitmap.Create;
  GradientBmp.PixelFormat := pf24bit;
end;

procedure FinalizeStock;
begin
  GradientBmp.Free;
  StockImgList.Free;
end;

{ TTBXEchoTheme }

function TTBXEchoTheme.GetBooleanMetrics(Index: Integer): Boolean;
begin
  case Index of
    TMB_OFFICEXPPOPUPALIGNMENT: Result := True;
    TMB_EDITHEIGHTEVEN: Result := False;
    TMB_PAINTDOCKBACKGROUND: Result := True;
    TMB_SOLIDTOOLBARNCAREA: Result := True;
    TMB_SOLIDTOOLBARCLIENTAREA: Result := True;
  else
    Result := False;
  end;
end;

function TTBXEchoTheme.GetIntegerMetrics(Index: Integer): Integer;
const
  DEFAULT = -1;
begin
  case Index of
    TMI_SPLITBTN_ARROWWIDTH: Result := 12;

    TMI_DROPDOWN_ARROWWIDTH: Result := 8;
    TMI_DROPDOWN_ARROWMARGIN: Result := 3;

    TMI_MENU_IMGTEXTSPACE: Result := 3;
    TMI_MENU_LCAPTIONMARGIN: Result := 8;
    TMI_MENU_RCAPTIONMARGIN: Result := 3;
    TMI_MENU_SEPARATORSIZE: Result := 3;
    TMI_MENU_MDI_DW: Result := 2;
    TMI_MENU_MDI_DH: Result := 2;

    TMI_TLBR_SEPARATORSIZE: Result := DEFAULT;

    TMI_EDIT_MENURIGHTINDENT: Result := 1;
    TMI_EDIT_FRAMEWIDTH: Result := 1;
    TMI_EDIT_TEXTMARGINHORZ: Result := 2;
    TMI_EDIT_TEXTMARGINVERT: Result := 2;
    TMI_EDIT_BTNWIDTH: Result := 14;
  else
    Result := DEFAULT;
  end;
end;

function TTBXEchoTheme.GetViewColor(AViewType: Integer): TColor;
begin
  Result := clBtnFace;
  if (AViewType and VT_TOOLBAR) = VT_TOOLBAR then
  begin
    if (AViewType and TVT_MENUBAR) = TVT_MENUBAR then
      Result := MenubarColor
    else
      Result := ToolbarColor;
  end
  else if (AViewType and VT_POPUP) = VT_POPUP then
  begin
    if (AViewType and PVT_LISTBOX) = PVT_LISTBOX then
      Result := clWindow
    else
      Result := PopupColor;
  end
  else if (AViewType and VT_DOCKPANEL) = VT_DOCKPANEL then
    Result := DockPanelColor;
end;

function TTBXEchoTheme.GetBtnColor(const ItemInfo: TTBXItemInfo; ItemPart:
  TItemPart): TColor;
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
    if not Enabled then
      B := BFlags1[HoverKind = hkKeyboardHover]
    else if ItemInfo.IsPopupParent then
      B := bisPopupParent
    else if Pushed then
      B := bisPressed
    else if Selected then
      B := BFlags2[HoverKind <> hkNone]
    else
      B := BFlags3[HoverKind <> hkNone];
    Result := BtnItemColors[B, ItemPart];
    if Embedded then
    begin
      if (ItemPart = ipBody) and (Result = clNone) then
        Result := ToolbarColor;
      if ItemPart = ipFrame then
      begin
        if Selected then
          Result := clWindowFrame
        else if (Result = clNone) then
          Result := clBtnShadow;
      end;
    end;
  end;
end;

function TTBXEchoTheme.GetPartColor(const ItemInfo: TTBXItemInfo;
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
    IsMenuItem := ((ViewType and PVT_POPUPMENU) = PVT_POPUPMENU) and
      ((ItemOptions and IO_TOOLBARSTYLE) = 0);
    Embedded := ((ViewType and VT_TOOLBAR) = VT_TOOLBAR) and
      ((ViewType and TVT_EMBEDDED) = TVT_EMBEDDED);
    if IsMenuItem then
    begin
      if not Enabled then
        M := MFlags1[HoverKind = hkKeyboardHover]
      else
        M := MFlags2[HoverKind <> hkNone];
      Result := MenuItemColors[M, ItemPart];
    end
    else
    begin
      if not Enabled then
        B := BFlags1[HoverKind = hkKeyboardHover]
      else if ItemInfo.IsPopupParent then
        B := bisPopupParent
      else if Pushed then
        B := bisPressed
      else if Selected then
        B := BFlags2[HoverKind <> hkNone]
      else
        B := BFlags3[HoverKind <> hkNone];
      Result := BtnItemColors[B, ItemPart];
      if Embedded and (Result = clNone) then
      begin
        if ItemPart = ipBody then
          Result := ToolbarColor;
        if ItemPart = ipFrame then
          Result := clBtnShadow;
      end;
    end;
  end;
end;

{
procedure GradientFill(const Canvas: TCanvas; const ARect: TRect;
  const StartColor, EndColor: TColor;
  const Direction: TGradDir);
var
  rc1, rc2, gc1, gc2,
    bc1, bc2, Counter, GSize: Integer;
  Brush: HBrush;
begin
  rc1 := GetRValue(ColorToRGB(StartColor));
  gc1 := GetGValue(ColorToRGB(StartColor));
  bc1 := GetBValue(ColorToRGB(StartColor));
  rc2 := GetRValue(ColorToRGB(EndColor));
  gc2 := GetGValue(ColorToRGB(EndColor));
  bc2 := GetBValue(ColorToRGB(EndColor));

  if Direction = tGTopBottom then
  begin
    GSize := (ARect.Bottom - ARect.Top) - 1;
    if GSize = 0 then
      GSize := 1;
    for Counter := 0 to GSize do
    begin
      Brush := CreateSolidBrush(
        RGB(Byte(rc1 + (((rc2 - rc1) * (Counter)) div GSize)),
        Byte(gc1 + (((gc2 - gc1) * (Counter)) div GSize)),
        Byte(bc1 + (((bc2 - bc1) * (Counter)) div GSize))));
      Windows.FillRect(Canvas.Handle, Rect(ARect.Left, ARect.Bottom - Counter -
        1, ARect.Right, ARect.Bottom - Counter), Brush);
      DeleteObject(Brush);
    end;
  end
  else
  begin
    GSize := (ARect.Right - ARect.Left) - 1;
    if GSize = 0 then
      GSize := 1;
    for Counter := 0 to GSize do
    begin
      Brush := CreateSolidBrush(
        RGB(Byte(rc1 + (((rc2 - rc1) * (Counter)) div GSize)),
        Byte(gc1 + (((gc2 - gc1) * (Counter)) div GSize)),
        Byte(bc1 + (((bc2 - bc1) * (Counter)) div GSize))));
      Windows.FillRect(Canvas.Handle, Rect(ARect.Right - Counter - 1, ARect.Top,
        ARect.Right - Counter, ARect.Bottom), Brush);
      DeleteObject(Brush);
    end;
  end;
end;
}

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
      BitBlt(Canvas.Handle, (Left + Right - W + 1) div 2, (Top + Bottom - H) div
        2, W, H,
        Bmp.Canvas.Handle, 0, 0, ROP_DSPDxax);
    end;
    RestoreDC(Canvas.Handle, Index);
  finally
    Bmp.Free;
  end;
end;

function TTBXEchoTheme.GetItemColor(const ItemInfo: TTBXItemInfo): TColor;
begin
  Result := GetPartColor(ItemInfo, ipBody);
  if Result = clNone then
    Result := GetViewColor(ItemInfo.ViewType);
end;

function TTBXEchoTheme.GetItemTextColor(const ItemInfo: TTBXItemInfo):
  TColor;
begin
  Result := GetPartColor(ItemInfo, ipText);
end;

function TTBXEchoTheme.GetItemImageBackground(const ItemInfo:
  TTBXItemInfo): TColor;
begin
  Result := GetBtnColor(ItemInfo, ipBody);
  if Result = clNone then
    result := GetViewColor(ItemInfo.ViewType);
end;

procedure TTBXEchoTheme.GetViewBorder(ViewType: Integer; out Border:
  TPoint);
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
    else
      SetBorder(2, 2);
  end
  else if (ViewType and VT_POPUP) = VT_POPUP then
  begin
    if (ViewType and PVT_POPUPMENU) = PVT_POPUPMENU then
      Border.X := 1
    else
      Border.X := 2;
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
    else
      SetBorder(2, 2);
  end
  else
    SetBorder(0, 0);
end;

procedure TTBXEchoTheme.GetMargins(MarginID: Integer; out Margins:
  TTBXMargins);
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
          LeftWidth := 3;
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

procedure TTBXEchoTheme.PaintBackgnd(Canvas: TCanvas; const ADockRect,
  ARect, AClipRect: TRect;
  AColor: TColor; Transparent: Boolean; AViewType: Integer);
var
  Brush: HBrush;
  R: TRect;
  IsHoriz: boolean;
begin
  if not Transparent then
  begin
    if AColor <> ToolbarColor then
    begin
      IntersectRect(R, ARect, AClipRect);
      FillRectEx(Canvas.Handle, R, AColor);
    end
    else
    begin
      if ((AViewType and TVT_NORMALTOOLBAR) = TVT_NORMALTOOLBAR)
        and (not (AViewType and TVT_EMBEDDED = TVT_EMBEDDED))
        or ((AViewType and TVT_TOOLWINDOW) = TVT_TOOLWINDOW) then
      begin
        IntersectRect(R, ARect, AClipRect);
        if (ADockRect.Top = 0) and
          (ADockRect.Left = 0) and
          (ADockRect.Right = 0) and
          (ADockRect.Bottom = 0) then
          IsHoriz := (ARect.Right > ARect.Bottom)
        else
          IsHoriz := Abs(R.Right - R.Left) > Abs(R.Bottom - R.Top);
        if IsHoriz then
        begin
          R.Top := R.Top - 1;
          R.Bottom := R.Bottom + 1;
          GradientFill(Canvas, R, gradCol1, gradCol2, TGTopBottom);
          R.Bottom := R.Bottom - 1;
          R.Top := R.Top + 1;
        end
        else
        begin
          R.Left := R.Left - 1;
          R.Right := R.Right + 1;
          GradientFill(Canvas, R, gradCol1, gradCol2, TGLeftRight);
          R.Right := R.Right - 1;
          R.Left := R.Left + 1;
        end;
      end
      else
      begin
        Brush := CreateSolidBrush(ColorToRGB(AColor));
        IntersectRect(R, ARect, AClipRect);
        //The rects are compared to determine if we're drawing a toolbar, not a popup menu...
        //if (ADockRect.Left <> ARect.Left) or (ADockRect.Top <> ARect.Top)
        //  or (ADockRect.Right <> ARect.Right) or (ADockRect.Bottom <>
        //  ARect.Bottom) then
        //  GradientFill(Canvas, R, gradCol2, clBtnFace, TGLeftRight)
        //else
          FillRect(Canvas.Handle, R, Brush);
        DeleteObject(Brush);
      end;
    end;
  end;
end;

procedure TTBXEchoTheme.PaintCaption(Canvas: TCanvas;
  const ARect: TRect; const ItemInfo: TTBXItemInfo; const ACaption: string;
  AFormat: Cardinal; Rotated: Boolean);
var
  R: TRect;
begin
  with ItemInfo, Canvas do
  begin
    R := ARect;
    Brush.Style := bsClear;
    if Font.Color = clNone then
      Font.Color := GetPartColor(ItemInfo, ipText);
    //Font.Color := GetPartColor(ItemInfo, ipText);
    if not Rotated then
      Windows.DrawText(Handle, PChar(ACaption), Length(ACaption), R, AFormat)
    else
      DrawRotatedText(Handle, ACaption, R, AFormat);
    Brush.Style := bsSolid;
  end;
end;

procedure TTBXEchoTheme.PaintCheckMark(Canvas: TCanvas; ARect: TRect; const
  ItemInfo: TTBXItemInfo);
var
  X, Y: Integer;
begin
  X := (ARect.Left + ARect.Right) div 2 - 2;
  Y := (ARect.Top + ARect.Bottom) div 2 + 1;
  Canvas.Pen.Color := GetBtnColor(ItemInfo, ipText);
  Canvas.Polyline([Point(X - 2, Y - 2), Point(X, Y), Point(X + 4, Y - 4),
    Point(X + 4, Y - 3), Point(X, Y + 1), Point(X - 2, Y - 1), Point(X - 2, Y -
      2)]);
end;

procedure TTBXEchoTheme.PaintChevron(Canvas: TCanvas; ARect: TRect; const
  ItemInfo: TTBXItemInfo);
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
    with R2 do
      BitBlt(Canvas.Handle, Left, Top, Right - Left,
        Bottom - Top, Bmp.Canvas.Handle, 0, 0, ROP_DSPDxax);
  finally
    Bmp.Free;
  end;
end;

procedure TTBXEchoTheme.PaintEditButton(Canvas: TCanvas; const ARect:
  TRect;
  var ItemInfo: TTBXItemInfo; ButtonInfo: TTBXEditBtnInfo);
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

procedure TTBXEchoTheme.PaintEditFrame(Canvas: TCanvas;
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

procedure TTBXEchoTheme.PaintDropDownArrow(Canvas: TCanvas;
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

procedure TTBXEchoTheme.PaintButton(Canvas: TCanvas; const ARect: TRect;
  const ItemInfo: TTBXItemInfo);
var
  R: TRect;
begin
  with ItemInfo, Canvas do
  begin
    R := ARect;

    if ((ItemOptions and IO_DESIGNING) <> 0) and not Selected then
    begin
      Brush.Color := clRed;
      if ComboPart = cpSplitRight then
        Dec(R.Left);
      FrameRect(R);
    end
    else
    begin
      if ((ItemInfo.ViewType and TVT_EMBEDDED) <> 0) and (HoverKind = hkNone)
        then
        FrameRectEx(Canvas.Handle, R, GetBtnColor(ItemInfo, ipFrame), true)
      else
        FrameRectEx(Canvas.Handle, R, GetBtnColor(ItemInfo, ipFrame), true);
      if (ComboPart = cpSplitLeft) and IsPopupParent then
        Inc(R.Right);
      if ComboPart = cpSplitRight then
        Dec(R.Left);

      if (Selected) and ((ViewType and VT_TOOLBAR) = VT_TOOLBAR) then
      begin
        if (HoverKind <> hkNone) then
        begin
          if Pushed then
            FillRectEx(Canvas.Handle, R, GetBtnColor(ItemInfo, ipBody))
          else
{$IFDEF ALT_VISUAL_STYLE}
            FillRectEx(Canvas.Handle, R, Blend($0080E0FF, $002090E8, 50));
{$ELSE}
            FillRectEx(Canvas.Handle, R, GetBtnColor(ItemInfo, ipBody));
{$ENDIF}
        end
        else
{$IFDEF ALT_VISUAL_STYLE}
          GradientFill(Canvas, R, $0080E0FF, $002090E8, TGTopBottom);
{$ELSE}
          FillRectEx(Canvas.Handle, R, GetBtnColor(ItemInfo, ipBody));
{$ENDIF}
      end
      else if ((ViewType and TVT_MENUBAR) = TVT_MENUBAR) and (HoverKind <>
        hkNone) then
      begin
        FillRectEx(Canvas.Handle, R, GetBtnColor(ItemInfo, ipBody));
        //GradientFill(Canvas, R, gradCol1, gradCol2, TGTopBottom);
      end
      else
        FillRectEx(Canvas.Handle, R, GetBtnColor(ItemInfo, ipBody));
    end;
    if ComboPart = cpSplitRight then
      PaintDropDownArrow(Canvas, R, ItemInfo);
  end;
end;

procedure TTBXEchoTheme.PaintFloatingBorder(Canvas: TCanvas; const ARect:
  TRect;
  const WindowInfo: TTBXWindowInfo);
const
  WinStates: array[Boolean] of TWinFramestate = (wfsInactive, wfsActive);

  function GetBtnItemState(BtnState: Integer): TBtnItemState;
  begin
    if not WindowInfo.Active then
      Result := bisDisabled
    else if (BtnState and CDBS_PRESSED) <> 0 then
      Result := bisPressed
    else if (BtnState and CDBS_HOT) <> 0 then
      Result := bisHot
    else
      Result := bisNormal;
  end;

var
  WinState: TWinFrameState;
  BtnItemState: TBtnItemState;
  SaveIndex, X, Y: Integer;
  Sz: TPoint;
  R: TRect;
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
        ExcludeClipRect(Canvas.Handle, Left + X, Top + Y, Right - X, Bottom -
          Y);
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
              Point(Left - 1, Top), Point(Left, Top - 1)
              ])
        else
          Canvas.Polyline([
            Point(Left, Top - 1), Point(Right - 1, Top - 1),
              Point(Right, Top), Point(Right, Bottom),
              Point(Left - 1, Bottom),
              Point(Left - 1, Top), Point(Left, Top - 1)
              ]);
    end;

    if not WindowInfo.ShowCaption then
      Exit;

    if (WindowInfo.ViewType and VT_TOOLBAR) = VT_TOOLBAR then
    begin
      CaptionColor := WinFrameColors[WinState, wfpCaption];
      CaptionText := WinFrameColors[WinState, wfpCaptionText];
    end
    else
    begin
      CaptionColor := PnlFrameColors[WinState, wfpCaption];
      CaptionText := PnlFrameColors[WinState, wfpCaptionText];
    end;

    { Caption }
    if (WRP_CAPTION and WindowInfo.RedrawPart) <> 0 then
    begin
      R := Rect(0, 0, WindowInfo.ClientWidth, GetSystemMetrics(SM_CYSMCAPTION) -
        1);
      with WindowInfo.FloatingBorderSize do
        OffsetRect(R, X, Y);
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
        DT_SINGLELINE or DT_VCENTER or DT_END_ELLIPSIS or DT_HIDEPREFIX);
    end;

    { Close button }
    if (CDBS_VISIBLE and WindowInfo.CloseButtonState) <> 0 then
    begin
      R := Rect(0, 0, WindowInfo.ClientWidth, GetSystemMetrics(SM_CYSMCAPTION) -
        1);
      with WindowInfo.FloatingBorderSize do
        OffsetRect(R, X, Y);
      R.Left := R.Right - (R.Bottom - R.Top);
      DrawLineEx(Canvas.Handle, R.Left - 1, R.Bottom, R.Right, R.Bottom,
        BodyColor);
      Brush.Color := CaptionColor;
      FillRect(R);
      with R do
      begin
        X := (Left + Right - StockImgList.Width + 1) div 2;
        Y := (Top + Bottom - StockImgList.Height) div 2;
      end;
      BtnItemState := GetBtnItemState(WindowInfo.CloseButtonState);
      FrameRectEx(Canvas.Handle, R, BtnItemColors[BtnItemState, ipFrame], True);
      if FillRectEx(Canvas.Handle, R, BtnItemColors[BtnItemState, ipBody]) then
        DrawGlyph(BtnItemColors[BtnItemState, ipText])
      else
        DrawGlyph(CaptionText);
    end;
  end;
end;

procedure TTBXEchoTheme.PaintFrame(Canvas: TCanvas; const ARect: TRect;
  const ItemInfo: TTBXItemInfo);
var
  R: TRect;
begin
  R := ARect;
  with ItemInfo do
    if Enabled and (HoverKind <> hkNone) then
      FillRectEx(Canvas.Handle, R, GetPartColor(ItemInfo, ipBody));
  FrameRectEx(Canvas.Handle, R, GetPartColor(ItemInfo, ipFrame), True);
end;

function TTBXEchoTheme.GetImageOffset(Canvas: TCanvas;
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

procedure TTBXEchoTheme.PaintImage(Canvas: TCanvas; ARect: TRect;
  const ItemInfo: TTBXItemInfo; ImageList: TCustomImageList; ImageIndex:
  Integer);
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

    HiContrast := ColorIntensity(GetItemImageBackground(ItemInfo)) < 80;
    if not Enabled then
    begin
      if not HiContrast then
        DrawTBXIconShadow(Canvas, ARect, ImageList, ImageIndex, 0)
      else
        DrawTBXIconFlatShadow(Canvas, ARect, ImageList, ImageIndex,
          clBtnShadow);
    end
    else if Selected or Pushed or (HoverKind <> hkNone) then
    begin
      if not (Selected or Pushed and not IsPopupParent) then
      begin
      end;
      DrawTBXIcon(Canvas, ARect, ImageList, ImageIndex, HiContrast);
    end
    else if HiContrast or TBXHiContrast or TBXLoColor then
      DrawTBXIcon(Canvas, ARect, ImageList, ImageIndex, HiContrast)
    else
      HighlightTBXIcon(Canvas, ARect, ImageList, ImageIndex, clWindow, 255);
  end;
end;

procedure TTBXEchoTheme.PaintMDIButton(Canvas: TCanvas; ARect: TRect;
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

procedure TTBXEchoTheme.PaintMenuItemFrame(Canvas: TCanvas;
  const ARect: TRect; const ItemInfo: TTBXItemInfo);
var
  R: TRect;
begin
  R := ARect;
  if ((ItemInfo.ViewType and PVT_TOOLBOX) <> PVT_TOOLBOX) then
  begin
    R.Right := R.Left + ItemInfo.PopupMargin + 2;
    GradientFill(Canvas, R, gradCol1, gradCol2, TGLeftRight);
    Inc(R.Left);
    R.Right := ARect.Right - 1;
  end;
  PaintFrame(Canvas, R, ItemInfo);
end;

procedure TTBXEchoTheme.PaintMenuItem(Canvas: TCanvas; const ARect: TRect;
  var ItemInfo: TTBXItemInfo);
var
  R, R2: TRect;
  X, Y, I: Integer;
  ArrowWidth: Integer;
  ClrText: TColor;

  procedure DrawArrow(AColor: TColor);
  begin
    Canvas.Pen.Color := AColor;
    Canvas.Brush.Color := AColor;
    Canvas.Polygon([Point(X, Y - 3), Point(X, Y + 3), Point(X + 3, Y)]);
  end;

begin
  with Canvas, ItemInfo do
  begin
    ArrowWidth := GetSystemMetrics(SM_CXMENUCHECK);
    ClrText := GetPartColor(ItemInfo, ipText);

    R := ARect;
    PaintMenuItemFrame(Canvas, R, ItemInfo);
    if (ItemOptions and IO_COMBO) <> 0 then
    begin
      X := R.Right - ArrowWidth - 1;
      if not ItemInfo.Enabled then
        Pen.Color := ClrText
      else if HoverKind = hkMouseHover then
        Pen.Color := GetPartColor(ItemInfo, ipFrame)
      else
        Pen.Color := PopupSeparatorColor;
      MoveTo(X, R.Top + 1);
      LineTo(X, R.Bottom - 1);
    end;

    if (ItemOptions and IO_SUBMENUITEM) <> 0 then
    begin
      Y := ARect.Bottom div 2;
      X := ARect.Right - ArrowWidth * 2 div 3 - 1;
      DrawArrow(ClrText);
    end;

    if Selected and Enabled then
    begin
      R2 := ARect;
      if HoverKind = hkNone then
      begin
        InflateRect(R2, -1, -1);
        i := 2;
        R := R2;
        R.Left := R2.Left + 1;
        R.Right := R.Left + ItemInfo.PopupMargin - i;
        FrameRectEx(Canvas.Handle, R, GetBtnColor(ItemInfo, ipFrame), True);
{$IFDEF ALT_VISUAL_STYLE}
        GradientFill(Canvas, R, $0080E0FF, $002090E8, TGTopBottom)
{$ELSE}
        FillRectEx(Canvas.Handle, R, GetBtnColor(ItemInfo, ipBody))
{$ENDIF}
      end
      else
      begin
{$IFDEF ALT_VISUAL_STYLE}
        i := 0;
{$ELSE}
        InflateRect(R2, -1, -1);
        i := 2;
{$ENDIF}
        R := R2;
        R.Left := R2.Left + 1;
        R.Right := R.Left + ItemInfo.PopupMargin - i;
        FrameRectEx(Canvas.Handle, R, GetBtnColor(ItemInfo, ipFrame), True);
{$IFDEF ALT_VISUAL_STYLE}
        FillRectEx(Canvas.Handle, R, Blend($0080E0FF, $002090E8, 50));
{$ELSE}
        FillRectEx(Canvas.Handle, R, GetBtnColor(ItemInfo, ipBody));
{$ENDIF}
      end;
    end;
  end;
end;

procedure TTBXEchoTheme.PaintPopupNCArea(Canvas: TCanvas; R: TRect; const
  PopupInfo: TTBXPopupInfo);
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
      if not IsRectEmpty(PR) then
        with PR do
        begin
          Pen.Color := PopupColor; //ToolbarColor;
          if Bottom = R.Top then
          begin
            if Left <= R.Left then
              Left := R.Left - 1;
            if Right >= R.Right then
              Right := R.Right + 1;
            MoveTo(Left + 1, Bottom - 1);
            LineTo(Right - 1, Bottom - 1);
          end
          else if Top = R.Bottom then
          begin
            if Left <= R.Left then
              Left := R.Left - 1;
            if Right >= R.Right then
              Right := R.Right + 1;
            MoveTo(Left + 1, Top);
            LineTo(Right - 1, Top);
          end;
          if Right = R.Left then
          begin
            if Top <= R.Top then
              Top := R.Top - 1;
            if Bottom >= R.Bottom then
              Bottom := R.Bottom + 1;
            MoveTo(Right - 1, Top + 1);
            LineTo(Right - 1, Bottom - 1);
          end
          else if Left = R.Right then
          begin
            if Top <= R.Top then
              Top := R.Top - 1;
            if Bottom >= R.Bottom then
              Bottom := R.Bottom + 1;
            MoveTo(Left, Top + 1);
            LineTo(Left, Bottom - 1);
          end;
        end;
    end;
  end;
end;

procedure TTBXEchoTheme.PaintSeparator(Canvas: TCanvas; ARect: TRect;
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
        GradientFill(Canvas, R, gradCol1, gradCol2, TGLeftRight);
        Inc(Left, ItemInfo.PopupMargin + 9);
        Pen.Color := PopupSeparatorColor;
      end
      else
        Pen.Color := ToolbarSeparatorColor;

      if not enabled then
        exit;

      if (ItemInfo.ViewType and VT_TOOLBAR) = VT_TOOLBAR then
      begin
        Top := Bottom div 2;
        Left := Left + 4;
        Right := Right - 2;
        Bottom := Top + 1;
        DrawLineEx(Canvas.Handle, Left, Top, Right, Top, clBtnHighLight);
        Top := Top - 1;
        Left := Left - 1;
        Right := Right - 1;
        DrawLineEx(Canvas.Handle, Left, Top, Right, Top,
          ToolbarSeparatorColor);
      end
      else
      begin
        Top := Bottom div 2;
        Left := Left + 1;
        Right := Right - 1;
        Bottom := Top + 1;
        DrawLineEx(Canvas.Handle, Left, Top, Right, Top, PopupSeparatorColor);
      end;
    end
    else if enabled then
    begin
      Top := Top + 4;
      Bottom := Bottom - 2;
      Left := Right div 2;
      DrawLineEx(Canvas.Handle, Left, Top, Left, Bottom, clBtnHighLight);
      Top := Top - 1;
      Left := Left - 1;
      Bottom := Bottom - 1;
      DrawLineEx(Canvas.Handle, Left, Top, Left, Bottom,
        ToolbarSeparatorColor);
    end;
  end;
end;

procedure TTBXEchoTheme.PaintToolbarNCArea(Canvas: TCanvas; R: TRect;
  const ToolbarInfo: TTBXToolbarInfo);
const
  DragHandleOffsets: array[Boolean, DHS_DOUBLE..DHS_SINGLE] of Integer = ((2, 0,
    1), (5, 0, 5));

  function GetBtnItemState(BtnState: Integer): TBtnItemState;
  begin
    if (BtnState and CDBS_PRESSED) <> 0 then
      Result := bisPressed
    else if (BtnState and CDBS_HOT) <> 0 then
      Result := bisHot
    else
      Result := bisNormal;
  end;

var
  Sz, DHSize: Integer;
  R2: TRect;
  C: TColor;
  Hi1, Lo1, Hi2, Lo2, Hi3, Lo3, Hi4: TColor;
  I: Integer;
  BtnVisible, Horz: Boolean;
  BtnItemState: TBtnItemState;
  C1, C2: TColor;
begin
  with Canvas do
  begin
    C := Brush.Color;
    if ToolbarInfo.BorderStyle = bsSingle then
    begin
      if ((ToolbarInfo.ViewType and TVT_NORMALTOOLBAR) = TVT_NORMALTOOLBAR)
        or (ToolbarInfo.ViewType = VT_TOOLBAR)
        or ((ToolbarInfo.ViewType and TVT_TOOLWINDOW) = TVT_TOOLWINDOW) then
      begin
        with R do
        begin
          if C = ToolbarColor then
          begin
            if (Toolbarinfo.IsVertical) then
            begin
              GradientFill(Canvas, R, gradCol1, gradCol2, TGLeftRight);
              R2 := R;
              R2.Top := R2.Bottom - 1;
              R2.Right := R2.Right - 1;

              GradientFill(Canvas, R2, gradBL, Blend(gradCol1, gradCol2, 50),
                TGLeftRight);

              Pen.Color := gradBL;
              MoveTo(Right - 1, Top + 1);
              LineTo(Right - 1, Bottom - 1);

              Pixels[Left, Top] := Blend(gradCol1, gradCol2, 60);
              Pixels[Left, Bottom - 1] := gradCol1;
              Pixels[Right - 2, Top] := Blend(gradCol1, gradBL, 50);

              Pixels[Left, Bottom - 2] := Blend(gradCol1, gradCol2, 25);
              Pixels[Right - 1, Bottom - 1] := gradCol1;
              Pixels[Right - 2, Bottom - 2] := Blend(gradCol1, gradBL, 50);
            end
            else
            begin
              GradientFill(Canvas, R, gradCol1, gradCol2, TGTopBottom);
              R2 := R;
              R2.Top := R.Top + 1;
              R2.Left := R2.Right - 1;

              if ToolbarInfo.BorderStyle <> bsSingle then
                exit;

              GradientFill(Canvas, R2, GradBL, Blend(gradCol1, gradCol2, 50),
                TGTopBottom);

              Pen.Color := gradBL;
              MoveTo(Left + 1, Bottom - 1);
              LineTo(Right - 1, Bottom - 1);

              Pixels[Left, Top] := Blend(gradCol1, gradCol2, 60);
              Pixels[Left, Bottom - 1] := gradCol1;
              Pixels[Left, Bottom - 2] := Blend(gradCol1, gradBL, 50);

              Pixels[Right - 2, Top] := Blend(gradCol1, gradCol2, 25);
              Pixels[Right - 1, Bottom - 1] := gradCol1;
              Pixels[Right - 2, Bottom - 2] := Blend(gradCol1, gradBL, 50);
            end;
          end else
            FillRect(R);
          InflateRect(R, -2, -2);
        end;
      end else
      begin
        FillRect(R);
        InflateRect(R, -2, -2);
      end;
    end else
      FillRect(R);

    if not ToolbarInfo.AllowDrag then
      Exit;

    BtnVisible := (ToolbarInfo.CloseButtonState and CDBS_VISIBLE) <> 0;
    Sz := GetTBXDragHandleSize(ToolbarInfo);
    Horz := not ToolbarInfo.IsVertical;
    if Horz then
      R.Right := R.Left + Sz
    else
      R.Bottom := R.Top + Sz;

    // Drag Handle
    DHSize := GetTBXDragHandleSize(ToolbarInfo);
    if Horz then
      R.Right := R.Left + DHSize
    else
      R.Bottom := R.Top + DHSize;

    if ToolbarInfo.DragHandleStyle <> DHS_NONE then
    begin

      c1 := Blend(clBtnShadow, clBtnFace, 50);
      c2 := clBtnHighLight;

      R2 := R;
      if Horz then
      begin
        Inc(R2.Left, DragHandleOffsets[BtnVisible, ToolbarInfo.DragHandleStyle]);
        if BtnVisible then
          Inc(R2.Top, Sz + 1);
        I:= R2.Top - 1;

        Pen.Color := C1;
        MoveTo(R2.Left + 2, I);
        LineTo(R2.Left + 2, R2.Bottom - 1);
        LineTo(R2.Left, R2.Bottom - 1);

        Pen.Color := C2;
        MoveTo(R2.Left + 1, I);
        LineTo(R2.Left, i);
        LineTo(R2.Left, R2.Bottom);
      end
      else
      begin
        Inc(R2.Top, DragHandleOffsets[BtnVisible, ToolbarInfo.DragHandleStyle]);
        if BtnVisible then
          Dec(R2.Right, Sz + 1);
        I:= R2.Left - 1;

        Pen.Color := C2;
        MoveTo(R2.Right - 1, R2.Top);
        LineTo(I, R2.Top);
        LineTo(I, R2.Bottom - 2);

        Pen.Color := C1;
        MoveTo(R2.Right - 1, R2.Top);
        LineTo(R2.Right - 1, R2.Top + 2);
        LineTo(R2.Left - 1, R2.Top + 2);
      end;
    end;

    // Close button
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
      FrameRectEx(Canvas.Handle, R2, BtnItemColors[BtnItemState, ipFrame],
        True);
      FillRectEx(Canvas.Handle, R2, BtnItemColors[BtnItemState, ipBody]);
      DrawButtonBitmap(Canvas, R2, BtnItemColors[BtnItemState, ipText]);
    end;
end;
end;

procedure TTBXEchoTheme.PaintDockPanelNCArea(Canvas: TCanvas; R: TRect;
  const DockPanelInfo: TTBXDockPanelInfo);

  function GetBtnItemState(BtnState: Integer): TBtnItemState;
  begin
    if (BtnState and CDBS_PRESSED) <> 0 then
      Result := bisPressed
    else if (BtnState and CDBS_HOT) <> 0 then
      Result := bisHot
    else
      Result := bisNormal;
  end;

var
  C: TColor;
{$IFDEF ALT_HEADER_STYLE}
  Hi1, Lo1, Hi2, Lo2, Hi3, Lo3, Hi4: TColor;
  i: integer;
{$ENDIF}
  Sz, Flags: Integer;
  R2: TRect;
  BtnItemState: TBtnItemState;
begin
  with Canvas, DockPanelInfo do
  begin
    C := Brush.Color; // Dock panel passes its body color in Canvas.Brush
    R2 := R;

    FrameRectEx(Canvas.Handle, R, clBtnFace, True);
    FrameRectEx(Canvas.Handle, R, C, True);
    with R do
    begin
      Pixels[Left, Top] := clBtnFace;
      if IsVertical then
        Pixels[Right - 1, Top] := clBtnFace
      else
        Pixels[Left, Bottom - 1] := clBtnFace;
    end;

    R := R2;
    InflateRect(R, -BorderSize.X, -BorderSize.Y);
    Sz := GetSystemMetrics(SM_CYSMCAPTION);
{$IFDEF ALT_HEADER_STYLE}
    C := clBtnShadow;
    if IsVertical then
    begin
      R.Bottom := R.Top + Sz - 1;
      GradientFill(Canvas, R, gradCol1, gradCol2, TGTopBottom);
      DrawLineEx(Canvas.Handle, R.Left, R.Bottom, R.Right, R.Bottom, C);
    end
    else
    begin
      R.Right := R.Left + Sz - 1;
      GradientFill(Canvas, R, gradCol1, gradCol2, TGLeftRight);
      DrawLineEx(Canvas.Handle, R.Right, R.Top, R.Right, R.Bottom, C);
    end;
{$ELSE}
    C := clBtnFace;
    Canvas.Brush.Color:= PnlFrameColors[wfsActive, wfpCaption];
    if IsVertical then
    begin
      R.Bottom := R.Top + Sz;
      Canvas.FillRect(R);
      DrawLineEx(Canvas.Handle, R.Left, R.Bottom - 1, R.Right, R.Bottom - 1, C);
    end
    else
    begin
      R.Right := R.Left + Sz;
      Canvas.FillRect(R);
      DrawLineEx(Canvas.Handle, R.Right - 1, R.Top, R.Right - 1, R.Bottom, C);
    end;
{$ENDIF}

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
      FrameRectEx(Canvas.Handle, R2, BtnItemColors[BtnItemState, ipFrame],
        True);
      FillRectEx(Canvas.Handle, R2, BtnItemColors[BtnItemState, ipBody]);
      DrawButtonBitmap(Canvas, R2, BtnItemColors[BtnItemState, ipText]);
    end;

{$IFDEF ALT_HEADER_STYLE}
    c := gradHandle1;
    Hi1 := GetNearestColor(Handle, MixColors(c, gradHandle2, 64));
    Lo1 := GetNearestColor(Handle, MixColors(c, gradHandle2, 48));
    Hi2 := GetNearestColor(Handle, MixColors(c, gradHandle2, 32));
    Lo2 := GetNearestColor(Handle, MixColors(c, gradHandle2, 16));
    Hi3 := GetNearestColor(Handle, MixColors(c, gradHandle3, 128));
    Lo3 := GetNearestColor(Handle, MixColors(c, gradHandle3, 96));
    Hi4 := GetNearestColor(Handle, MixColors(c, gradHandle3, 72));
    R2 := R;
    if IsVertical then
    begin
      Inc(R2.Top, 2);
      Dec(R2.Bottom, 2);
      Inc(R2.Left, 1);
      i := R2.Top;
      while (i < R2.Bottom - 1) do
      begin
        Pixels[R2.Left, i] := Hi1;
        Pixels[R2.Left, i + 1] := Hi2;
        Pixels[R2.Left + 1, i] := Lo1;
        Pixels[R2.Left + 1, i + 1] := Lo2;
        Pixels[R2.Left + 1, i + 2] := Hi4;
        Pixels[R2.Left + 2, i + 2] := Hi3;
        Pixels[R2.Left + 2, i + 1] := Lo3;
        Inc(i, 4);
      end;
    end
    else
    begin
      Inc(R2.Left, 2);
      Dec(R2.Right, 2);
      Inc(R2.Top, 1);
      i := R2.Left;
      while (i < R2.Right - 1) do
      begin
        Pixels[i, R2.Top] := Hi1;
        Pixels[i, R2.Top + 1] := Hi2;
        Pixels[i + 1, R2.Top] := Lo1;
        Pixels[i + 1, R2.Top + 1] := Lo2;
        Pixels[i + 1, R2.Top + 2] := Hi4;
        Pixels[i + 2, R2.Top + 2] := Hi3;
        Pixels[i + 2, R2.Top + 1] := Lo3;
        Inc(i, 4);
      end;
    end;
    if IsVertical then
      InflateRect(R, -9, 0)
    else
      InflateRect(R, 0, -9);
{$ELSE}
    if IsVertical then
      InflateRect(R, -4, 0)
    else
      InflateRect(R, 0, -4);
{$ENDIF}
    Font.Assign(SmCaptionFont);
    Font.Color := clBtnText;
    Brush.Style := bsClear;
    Flags := DT_SINGLELINE or DT_VCENTER or DT_END_ELLIPSIS or DT_HIDEPREFIX;
    if IsVertical then
      DrawText(Canvas.Handle, Caption, -1, R, Flags)
    else
      DrawRotatedText(Canvas.Handle, string(Caption), R, Flags);
  end;
end;

procedure TTBXEchoTheme.PaintDock(Canvas: TCanvas; const ClientRect,
  DockRect: TRect; DockPosition: Integer);
var
  R: TRect;
begin
  {
  if ClientRect.Bottom - ClientRect.Top > 2 then
    GradientFill(Canvas, DockRect, gradCol2, clBtnFace, TGLeftRight)
  else
  begin
  }
    Canvas.Pen.Width := 0;
    Canvas.Brush.Style := bsSolid;
    Canvas.Brush.Color := MenubarColor; //clBtnFace;
    R := DockRect;
    InFlateRect(R, 1, 1);
    Canvas.Rectangle(R);
  //end;
end;

procedure TTBXEchoTheme.SetupColorCache;
var
  DC: HDC;
  SwapC, HotBtnFace, DisabledText: TColor;
  i1, i2: integer;

  procedure Undither(var C: TColor);
  begin
    if C <> clNone then
      C := GetNearestColor(DC, ColorToRGB(C));
  end;

begin
  DC := StockCompatibleBitmap.Canvas.Handle;

  gradCol1 := clBtnFace;
  gradCol2 := clWindow;
  i1 := ColorIntensity(GradCol1);
  i2 := ColorIntensity(GradCol2);

  if i1 > i2 then
  begin
    SwapC := gradCol1;
    gradCol1 := gradCol2;
    gradCol2 := SwapC;
  end;

  if IsDarkColor(gradCol1) then
  begin
    if (i2 - i1) < 30 then
      gradCol2 := Lighten(gradCol2, (i1 - i2));
  end
  else if (i2 - i1) < 30 then
    gradCol1 := Lighten(gradCol1, (i1 - i2));

  gradHandle1 := gradCol1;
  gradHandle2 := clBtnShadow;
  gradHandle3 := clBtnHighlight;
  gradBL := Blend(clBtnShadow, gradCol1, 95);

  MenubarColor := Blend(gradCol1, gradCol2, 50);
  ToolbarColor := Blend(gradCol1, gradCol2, 50);
  PopupColor := Blend(clBtnFace, clWindow, 143);
  DockPanelColor := PopupColor;
  PopupFrameColor := Blend(clBtnText, clBtnShadow, 20);
  SetContrast(PopupFrameColor, PopupColor, 100);

  HotBtnFace := Blend(clHighlight, clWindow, 20);
  DisabledText := blend(clBtnText, gradCol2, 50);

  WinFrameColors[wfsActive, wfpBorder] := Blend(clBtnText, clBtnShadow, 15);
  SetContrast(WinFrameColors[wfsActive, wfpBorder], ToolbarColor, 120);
  WinFrameColors[wfsActive, wfpCaption] := clBtnShadow;
  WinFrameColors[wfsActive, wfpCaptionText] := clBtnHighlight;
  SetContrast(WinFrameColors[wfsActive, wfpCaptionText], clBtnShadow, 180);
  WinFrameColors[wfsInactive, wfpBorder] := WinFrameColors[wfsActive,
    wfpBorder];
  WinFrameColors[wfsInactive, wfpCaption] := clBtnFace;
  WinFrameColors[wfsInactive, wfpCaptionText] := DisabledText;
  SetContrast(WinFrameColors[wfsInactive, wfpCaptionText], clBtnFace, 120);

  PnlFrameColors[wfsActive, wfpBorder] := clBtnShadow;
  PnlFrameColors[wfsActive, wfpCaption] := clBtnHighLight;
  PnlFrameColors[wfsActive, wfpCaptionText] := clBtnText;
  PnlFrameColors[wfsInactive, wfpBorder] := clBtnShadow;
  PnlFrameColors[wfsInactive, wfpCaption] := clBtnFace;
  PnlFrameColors[wfsInactive, wfpCaptionText] := DisabledText;
  SetContrast(PnlFrameColors[wfsInactive, wfpCaptionText], clBtnFace, 120);

  BtnItemColors[bisNormal, ipBody] := clNone;
  BtnItemColors[bisNormal, ipText] := clBtnText;
  SetContrast(BtnItemColors[bisNormal, ipText], ToolbarColor, 180);
  BtnItemColors[bisNormal, ipFrame] := clNone;
  BtnItemColors[bisDisabled, ipBody] := clNone;
  BtnItemColors[bisDisabled, ipText] := DisabledText;

  BtnItemColors[bisDisabled, ipFrame] := clNone;
  BtnItemColors[bisSelected, ipBody] := Blend(clHighlight, Blend(clBtnFace,
    clWindow, 50), 10);
  SetContrast(BtnItemColors[bisSelected, ipBody], ToolbarColor, 5);
  BtnItemColors[bisSelected, ipText] := BtnItemColors[bisNormal, ipText];
  BtnItemColors[bisSelected, ipFrame] := clHighlight;
  BtnItemColors[bisPressed, ipBody] := Blend(clHighlight, clWindow, 50);
  BtnItemColors[bisPressed, ipText] := clHighlightText;
  BtnItemColors[bisPressed, ipFrame] := clHighlight;
  SetContrast(BtnItemColors[bisPressed, ipFrame], ToolbarColor, 80);
  BtnItemColors[bisHot, ipBody] := HotBtnFace;
  BtnItemColors[bisHot, ipText] := clMenuText;
  SetContrast(BtnItemColors[bisHot, ipText], BtnItemColors[bisHot, ipBody],
    180);
  BtnItemColors[bisHot, ipFrame] := clHighlight;
  SetContrast(BtnItemColors[bisHot, ipFrame], ToolbarColor, 100);
  BtnItemColors[bisDisabledHot, ipBody] := HotBtnFace;
  BtnItemColors[bisDisabledHot, ipText] := DisabledText;
  BtnItemColors[bisDisabledHot, ipFrame] := clHighlight;
  BtnItemColors[bisSelectedHot, ipBody] := Blend(clHighlight, clWindow, 40);

  SetContrast(BtnItemColors[bisSelectedHot, ipBody], ToolbarColor, 30);
  BtnItemColors[bisSelectedHot, ipText] := clHighlightText;
  SetContrast(BtnItemColors[bisSelectedHot, ipText],
    BtnItemColors[bisSelectedHot, ipBody], 180);
  BtnItemColors[bisSelectedHot, ipFrame] := clHighlight;
  SetContrast(BtnItemColors[bisSelectedHot, ipFrame],
    BtnItemColors[bisSelectedHot, ipBody], 100);
  BtnItemColors[bisPopupParent, ipBody] := Blend(clBtnFace, clWindow, 183);
  //ToolbarColor;
  BtnItemColors[bisPopupParent, ipText] := BtnItemColors[bisNormal, ipText];
  BtnItemColors[bisPopupParent, ipFrame] := PopupFrameColor;

  MenuItemColors[misNormal, ipBody] := clNone;
  MenuItemColors[misNormal, ipText] := clWindowText;
  SetContrast(MenuItemColors[misNormal, ipText], PopupColor, 180);

  MenuItemColors[misNormal, ipFrame] := clNone;
  MenuItemColors[misDisabled, ipBody] := clNone;
  MenuItemColors[misDisabled, ipText] := DisabledText;
  MenuItemColors[misDisabled, ipFrame] := clNone;

  MenuItemColors[misHot, ipBody] := BtnItemColors[bisHot, ipBody];
  MenuItemColors[misHot, ipText] := BtnItemColors[bisHot, ipText];
  MenuItemColors[misHot, ipFrame] := BtnItemColors[bisHot, ipFrame];
  MenuItemColors[misDisabledHot, ipBody] := PopupColor;
  MenuItemColors[misDisabledHot, ipText] := Blend(clGrayText, clWindow, 70);
  MenuItemColors[misDisabledHot, ipFrame] := clHighlight;

  DragHandleColor := Blend(clBtnShadow, clWindow, 75);
  SetContrast(DragHandleColor, ToolbarColor, 85);
  IconShadowColor := Blend(clBlack, HotBtnFace, 25);
  ToolbarSeparatorColor := Blend(clBtnShadow, clWindow, 70);
  PopupSeparatorColor := ToolbarSeparatorColor;
  SetContrast(PopupSeparatorColor, PopupColor, 50);
  StatusPanelFrameColor := Blend(clBtnFace, clBtnHighLight, 50);
  SetContrast(StatusPanelFrameColor, ToolBarColor, 30);

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

function TTBXEchoTheme.GetPopupShadowType: Integer;
begin
  Result := PST_OFFICEXP;
end;

constructor TTBXEchoTheme.Create(const AName: string);
begin
  inherited;
  if CounterLock = 0 then
    InitializeStock;
  Inc(CounterLock);
  AddTBXSysChangeNotification(Self);
  SetupColorCache;
end;

destructor TTBXEchoTheme.Destroy;
begin
  RemoveTBXSysChangeNotification(Self);
  Dec(CounterLock);
  if CounterLock = 0 then
    FinalizeStock;
  inherited;
end;

procedure TTBXEchoTheme.GetViewMargins(ViewType: Integer;
  out Margins: TTBXMargins);
begin
  Margins.LeftWidth := 0;
  Margins.TopHeight := 0;
  Margins.RightWidth := 0;
  Margins.BottomHeight := 0;
end;

procedure TTBXEchoTheme.PaintPageScrollButton(Canvas: TCanvas;
  const ARect: TRect; ButtonType: Integer; Hot: Boolean);
var
  R: TRect;
  X, Y, Sz: Integer;
begin
  R := ARect;
  if Hot then
    Canvas.Brush.Color := BtnItemColors[bisHot, ipFrame]
  else
    Canvas.Brush.Color := clBtnShadow;
  Canvas.FrameRect(R);
  if Hot then
    Canvas.Brush.Color := BtnItemColors[bisHot, ipBody]
  else
    Canvas.Brush.Color := clBtnFace;
  InflateRect(R, -1, -1);
  Canvas.FillRect(R);
  X := (R.Left + R.Right) div 2;
  Y := (R.Top + R.Bottom) div 2;
  Sz := Min(X - R.Left, Y - R.Top) * 3 div 4;
  if Hot then
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

procedure TTBXEchoTheme.PaintFrameControl(Canvas: TCanvas; R: TRect; Kind,
  State: Integer; Params: Pointer);
var
  X, Y: Integer;

  procedure SetupPen;
  begin
    if Boolean(State and PFS_DISABLED) then
      Canvas.Pen.Color := clBtnShadow
    else if Boolean(State and PFS_PUSHED) then
      Canvas.Pen.Color := BtnItemColors[bisPressed, ipFrame]
    else if Boolean(State and PFS_HOT) then
      Canvas.Pen.Color := BtnItemColors[bisHot, ipFrame]
    else
      Canvas.Pen.Color := clBtnShadow;
  end;

  procedure SetupBrush;
  begin
    Canvas.Brush.Style := bsSolid;
    if Boolean(State and PFS_DISABLED) then
      Canvas.Brush.Style := bsClear
    else if Boolean(State and PFS_PUSHED) then
      Canvas.Brush.Color := BtnItemColors[bisPressed, ipBody]
    else if Boolean(State and PFS_HOT) then
      Canvas.Brush.Color := BtnItemColors[bisHot, ipBody]
    else if Boolean(State and PFS_MIXED) then
      Canvas.Brush.Bitmap := AllocPatternBitmap(clWindow, clBtnFace)
    else
      Canvas.Brush.Style := bsClear;
  end;

  function TextColor: TColor;
  begin
    if Boolean(State and PFS_DISABLED) then
      Result := BtnItemColors[bisDisabled, ipText]
    else if Boolean(State and PFS_PUSHED) then
      Result := BtnItemColors[bisPressed, ipText]
    else if Boolean(State and PFS_MIXED) then
      Result := clBtnShadow
    else if Boolean(State and PFS_HOT) then
      Result := BtnItemColors[bisHot, ipText]
    else
      Result := BtnItemColors[bisNormal, ipText];
  end;

  procedure DiagLine(C: TColor);
  begin
    with Canvas, R do
    begin
      Pen.Color := C;
      MoveTo(Right - 1 - X, Bottom - 1);
      LineTo(Right, Bottom - X - 2);
      Inc(X);
    end;
  end;

begin
  with Canvas do
    case Kind of
      PFC_CHECKBOX:
        begin
          SetupPen;
          SetupBrush;
          InflateRect(R, -1, -1);
          with R do
            Rectangle(Left, Top, Right, Bottom);
          Pen.Style := psSolid;
          Brush.Style := bsSolid;

          if Boolean(State and (PFS_CHECKED or PFS_MIXED)) then
          begin
            X := (R.Left + R.Right) div 2 - 1;
            Y := (R.Top + R.Bottom) div 2 + 1;
            Pen.Color := TextColor;
            Brush.Color := Pen.Color;
            Polygon([Point(X - 2, Y), Point(X, Y + 2), Point(X + 4, Y - 2),
              Point(X + 4, Y - 4), Point(X, Y), Point(X - 2, Y - 2), Point(X -
                2, Y)]);
          end;
        end;
      PFC_RADIOBUTTON:
        begin
          SetupPen;
          SetupBrush;
          InflateRect(R, -1, -1);
          with R do
            Ellipse(Left, Top, Right, Bottom);
          Pen.Style := psSolid;
          Brush.Style := bsSolid;
          if Boolean(State and PFS_CHECKED) then
          begin
            InflateRect(R, -3, -3);
            Pen.Color := TextColor;
            Brush.Color := Pen.Color;
            with R do
              Ellipse(Left, Top, Right, Bottom);
          end;
        end;
    end;
end;

procedure TTBXEchoTheme.PaintStatusBar(Canvas: TCanvas; R: TRect; Part:
  Integer);
var
  Color, Lo1, Hi1, Lo2, Hi2, Lo3, Hi3, Hi4: TColor;

begin
  with Canvas, R do
    case Part of
      SBP_BODY:
        begin
          FillRectEx(Canvas.Handle, R, ToolBarColor);
          DrawLineEx(Canvas.Handle, R.Left, R.Top + 0, R.Right, R.Top + 0, clBtnShadow);
          DrawLineEx(Canvas.Handle, R.Left, R.Top + 1, R.Right, R.Top + 1,
            NearestMixedColor(clBtnShadow, ToolBarColor,  128));
          DrawLineEx(Canvas.Handle, R.Left, R.Top + 2, R.Right, R.Top + 2,
            NearestMixedColor(clBtnShadow, ToolBarColor,  64));
          DrawLineEx(Canvas.Handle, R.Left, R.Top + 3, R.Right, R.Top + 3,
            NearestMixedColor(clBtnShadow, ToolBarColor,  32));
          DrawLineEx(Canvas.Handle, R.Left, R.Top + 4, R.Right, R.Top + 4,
            NearestMixedColor(clBtnShadow, ToolBarColor,  12));

          DrawLineEx(Canvas.Handle, R.Left, R.Bottom - 3, R.Right, R.Bottom - 3,
            NearestMixedColor(clBtnShadow, ToolBarColor,  8));
          DrawLineEx(Canvas.Handle, R.Left, R.Bottom - 2, R.Right, R.Bottom - 2,
            NearestMixedColor(clBtnShadow, ToolBarColor,  16));
          DrawLineEx(Canvas.Handle, R.Left, R.Bottom - 1, R.Right, R.Bottom - 1,
            NearestMixedColor(clBtnShadow, ToolBarColor,  24));
        end;
      SBP_PANE, SBP_LASTPANE:
        begin
          if Part = SBP_PANE then
            Dec(R.Right, 2);
          FrameRectEx(Handle, R, StatusPanelFrameColor, True);
        end;
      SBP_GRIPPER:
        begin
          Color:= ToolBarColor;
          Hi1:= GetNearestColor(Handle, MixColors(Color, clBtnShadow, 64));
          Lo1:= GetNearestColor(Handle, MixColors(Color, clBtnShadow, 48));
          Hi2:= GetNearestColor(Handle, MixColors(Color, clBtnShadow, 32));
          Lo2:= GetNearestColor(Handle, MixColors(Color, clBtnShadow, 16));
          Hi3:= GetNearestColor(Handle, MixColors(Color, clBtnHighlight, 128));
          Lo3:= GetNearestColor(Handle, MixColors(Color, clBtnHighlight, 96));
          Hi4:= GetNearestColor(Handle, MixColors(Color, clBtnHighlight, 72));

          with R do begin
            Pixels[Right - 12, Bottom - 4]:= Lo2;
            Pixels[Right - 12, Bottom - 3]:= Hi2;
            Pixels[Right - 11, Bottom - 4]:= Lo1;
            Pixels[Right - 11, Bottom - 3]:= Hi1;
            Pixels[Right - 11, Bottom - 2]:= Hi4;
            Pixels[Right - 10, Bottom - 2]:= Hi3;
            Pixels[Right - 10, Bottom - 3]:= Lo3;

            Pixels[Right - 8, Bottom - 4]:= Lo2;
            Pixels[Right - 8, Bottom - 3]:= Hi2;
            Pixels[Right - 7, Bottom - 4]:= Lo1;
            Pixels[Right - 7, Bottom - 3]:= Hi1;
            Pixels[Right - 7, Bottom - 2]:= Hi4;
            Pixels[Right - 6, Bottom - 2]:= Hi3;
            Pixels[Right - 6, Bottom - 3]:= Lo3;

            Pixels[Right - 4, Bottom - 4]:= Lo2;
            Pixels[Right - 4, Bottom - 3]:= Hi2;
            Pixels[Right - 3, Bottom - 4]:= Lo1;
            Pixels[Right - 3, Bottom - 3]:= Hi1;
            Pixels[Right - 3, Bottom - 2]:= Hi4;
            Pixels[Right - 2, Bottom - 2]:= Hi3;
            Pixels[Right - 2, Bottom - 3]:= Lo3;

            Pixels[Right - 8, Bottom - 8]:= Lo2;
            Pixels[Right - 8, Bottom - 7]:= Hi2;
            Pixels[Right - 7, Bottom - 8]:= Lo1;
            Pixels[Right - 7, Bottom - 7]:= Hi1;
            Pixels[Right - 7, Bottom - 6]:= Hi4;
            Pixels[Right - 6, Bottom - 6]:= Hi3;
            Pixels[Right - 6, Bottom - 7]:= Lo3;

            Pixels[Right - 4, Bottom - 8]:= Lo2;
            Pixels[Right - 4, Bottom - 7]:= Hi2;
            Pixels[Right - 3, Bottom - 8]:= Lo1;
            Pixels[Right - 3, Bottom - 7]:= Hi1;
            Pixels[Right - 3, Bottom - 6]:= Hi4;
            Pixels[Right - 2, Bottom - 6]:= Hi3;
            Pixels[Right - 2, Bottom - 7]:= Lo3;

            Pixels[Right - 4, Bottom - 12]:= Lo2;
            Pixels[Right - 4, Bottom - 11]:= Hi2;
            Pixels[Right - 3, Bottom - 12]:= Lo1;
            Pixels[Right - 3, Bottom - 11]:= Hi1;
            Pixels[Right - 3, Bottom - 10]:= Hi4;
            Pixels[Right - 2, Bottom - 10]:= Hi3;
            Pixels[Right - 2, Bottom - 11]:= Lo3;
          end;
        end;
    end;
end;

procedure TTBXEchoTheme.TBXSysCommand(var Message: TMessage);
begin
  if Message.WParam = TSC_VIEWCHANGE then
    SetupColorCache;
end;

{$IFNDEF DTM_Package}
initialization
  RegisterTBXTheme('Echo', TTBXEchoTheme);
{$ENDIF}

end.

