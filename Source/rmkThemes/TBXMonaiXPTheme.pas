unit TBXMonaiXPTheme;

// TBX Package
// Copyright 2001-2002 Alex A. Denisov. All Rights Reserved
// See TBX.chm for license and installation instructions
//
// 'Monai' TBX theme © 2004 Roy Magne Klever
//
//  Last updated: 28.08.2004

interface

{$I TB2Ver.inc}
{$I TBX.inc}

uses
  Windows, Messages, Graphics, TBXThemes, TBXDefaultTheme, ImgList;

type
  TTBXMonaiXPTheme = class(TTBXDefaultTheme)
  protected
    DockPanelColor: TColor;
    DisabledColor: TColor;
    procedure SetupColorCache; override;
  public
    constructor Create(const AName: string); override;
    destructor Destroy; override;

    { Metrics access, etc. }
    function  GetBooleanMetrics(Index: Integer): Boolean; override;
    function  GetIntegerMetrics(Index: Integer): Integer; override;
    procedure GetMargins(MarginID: Integer; out Margins: TTBXMargins); override;
    function  GetItemColor(const ItemInfo: TTBXItemInfo): TColor; override;
    function  GetItemTextColor(const ItemInfo: TTBXItemInfo): TColor; override;
    function  GetPopupShadowType: Integer; override;
    procedure GetViewBorder(ViewType: Integer; out Border: TPoint); override;
    function  GetViewColor(AViewType: Integer): TColor; override;

    { Painting routines }
    procedure PaintBackgnd(Canvas: TCanvas; const ADockRect, ARect, AClipRect: TRect; AColor: TColor; Transparent: Boolean; AViewType: Integer); override;
    procedure PaintButton(Canvas: TCanvas; const ARect: TRect; const ItemInfo: TTBXItemInfo); override;
    procedure PaintCaption(Canvas: TCanvas; const ARect: TRect; const ItemInfo: TTBXItemInfo; const ACaption: string; AFormat: Cardinal; Rotated: Boolean); override;
    procedure PaintDock(Canvas: TCanvas; const ClientRect, DockRect: TRect; DockPosition: Integer); override;
    procedure PaintDockPanelNCArea(Canvas: TCanvas; R: TRect; const DockPanelInfo: TTBXDockPanelInfo); override;
    procedure PaintDropDownArrow(Canvas: TCanvas; const ARect: TRect; const ItemInfo: TTBXItemInfo); override;
    procedure PaintEditButton(Canvas: TCanvas; const ARect: TRect; var ItemInfo: TTBXItemInfo; ButtonInfo: TTBXEditBtnInfo); override;
    procedure PaintEditFrame(Canvas: TCanvas; const ARect: TRect; var ItemInfo: TTBXItemInfo; const EditInfo: TTBXEditInfo); override;
    procedure PaintFrame(Canvas: TCanvas; const ARect: TRect; const ItemInfo: TTBXItemInfo); override;
    procedure PaintFloatingBorder(Canvas: TCanvas; const ARect: TRect; const WindowInfo: TTBXWindowInfo); override;
    procedure PaintImage(Canvas: TCanvas; ARect: TRect; const ItemInfo: TTBXItemInfo; ImageList: TCustomImageList; ImageIndex: Integer); override;
    procedure PaintMenuItem(Canvas: TCanvas; const ARect: TRect; var ItemInfo: TTBXItemInfo); override;
    procedure PaintMenuItemFrame(Canvas: TCanvas; const ARect: TRect; const ItemInfo: TTBXItemInfo); override;
    procedure PaintPopupNCArea(Canvas: TCanvas; R: TRect; const PopupInfo: TTBXPopupInfo); override;
    procedure PaintPageScrollButton(Canvas: TCanvas; const ARect: TRect; ButtonType: Integer; Hot: Boolean); override;
    procedure PaintMDIButton(Canvas: TCanvas; ARect: TRect; const ItemInfo: TTBXItemInfo; ButtonKind: Cardinal); override;
    procedure PaintSeparator(Canvas: TCanvas; ARect: TRect; ItemInfo: TTBXItemInfo; Horizontal, LineSeparator: Boolean); override;
    procedure PaintToolbarNCArea(Canvas: TCanvas; R: TRect; const ToolbarInfo: TTBXToolbarInfo); override;
    procedure PaintFrameControl(Canvas: TCanvas; R: TRect; Kind, State: Integer; Params: Pointer); override;
    procedure PaintStatusBar(Canvas: TCanvas; R: TRect; Part: Integer); override;
  end;

implementation

uses TBXUtils, TB2Item, TB2Common, Classes, Controls, Forms, Commctrl;

var
  StockImgList: TImageList;
  StockPatternBitmap: TBitmap;
  CounterLock: Integer = 0;

procedure InitializeStock;
begin
  StockPatternBitmap := TBitmap.Create;
  StockPatternBitmap.Width := 8;
  StockPatternBitmap.Height := 8;
  StockImgList := TImageList.Create(nil);
  StockImgList.Handle := ImageList_LoadBitmap(HInstance, 'TBXGLYPHS', 16, 0, clWhite);
end;

procedure FinalizeStock;
begin
  StockPatternBitmap.Free;
  StockImgList.Free;
end;

procedure CreateDottedPattern(Color: TColor);
var
  Hi1, Lo1, Hi2, Lo2, Hi3, Lo3, Hi4: TColor;
begin
  with StockPatternBitmap.Canvas do
  begin
    Brush.Color := Color;
    Hi1:= GetNearestColor(Handle, MixColors(Color, clBtnShadow, 128));
    Lo1:= GetNearestColor(Handle, MixColors(Color, clBtnShadow, 96));
    Hi2:= GetNearestColor(Handle, MixColors(Color, clBtnShadow, 48));
    Lo2:= GetNearestColor(Handle, MixColors(Color, clBtnShadow, 8));

    Hi3:= GetNearestColor(Handle, MixColors(Color, clBtnHighlight, 128));
    Lo3:= GetNearestColor(Handle, MixColors(Color, clBtnHighlight, 96));
    Hi4:= GetNearestColor(Handle, MixColors(Color, clBtnHighlight, 72));

    FillRect(Rect(0, 0, 8, 8));
    Pixels[0, 0]:= Hi1;
    Pixels[0, 1]:= Hi2;
    Pixels[1, 0]:= Lo1;
    Pixels[1, 1]:= Lo2;
    Pixels[1, 2]:= Hi4;
    Pixels[2, 2]:= Hi3;
    Pixels[2, 1]:= Lo3;

    Pixels[4, 0]:= Hi1;
    Pixels[4, 1]:= Hi2;
    Pixels[5, 0]:= Lo1;
    Pixels[5, 1]:= Lo2;
    Pixels[5, 2]:= Hi4;
    Pixels[6, 2]:= Hi3;
    Pixels[6, 1]:= Lo3;

    Pixels[0, 4]:= Hi1;
    Pixels[0, 5]:= Hi2;
    Pixels[1, 4]:= Lo1;
    Pixels[1, 5]:= Lo2;
    Pixels[1, 6]:= Hi4;
    Pixels[2, 5]:= Hi3;
    Pixels[2, 6]:= Lo3;

    Pixels[4, 4]:= Hi1;
    Pixels[4, 5]:= Hi2;
    Pixels[5, 4]:= Lo1;
    Pixels[5, 5]:= Lo2;
    Pixels[5, 6]:= Hi4;
    Pixels[6, 5]:= Hi3;
    Pixels[6, 6]:= Lo3;
  end;
end;

procedure DotFill(Canvas: TCanvas; R: TRect; Color: TColor; Border: Integer);
var
  DC: HDC;
  Pt: TPoint;
  W, H, I, J: Integer;
  Brush: HBRUSH;
begin
  if Color <> clNone then
  begin
    CreateDottedPattern(Color);
    Canvas.Brush.Style := bsSolid;
    Canvas.Brush.Color := Color;
    Canvas.FillRect(R);
  end;
  InflateRect(R, -Border, -Border);
  W := R.Right - R.Left;
  H := R.Bottom - R.Top;
  W := ((W - 2) div 4) * 4 + 2;
  H := ((H - 2) div 4) * 4 + 2;
  R.Left := (R.Right + R.Left - W - 1) div 2;
  R.Right := R.Left + W;
  R.Top := (R.Top + R.Bottom - H - 1) div 2;
  R.Bottom := R.Top + H;

  if Color <> clNone then
  begin
    DC := Canvas.Handle;
    Brush := CreatePatternBrush(StockPatternBitmap.Handle);
    GetWindowOrgEx(DC, Pt);
    SetBrushOrgEx(DC, R.Left - Pt.X, R.Top - Pt.Y, nil);
    Windows.FillRect(DC, R, Brush);
    DeleteObject(Brush);
  end
  else
  begin
    for J := 0 to (R.Bottom - R.Top - 1) div 4 do
      for I := 0 to (R.Right - R.Left - 1) div 4 do
        begin
          Canvas.Pixels[R.Left + I * 4 + 1, R.Top + J * 4 + 1] := clBtnHighlight;
          Canvas.Pixels[R.Left + I * 4 + 2, R.Top + J * 4 + 2] := clBtnShadow;
        end;
  end;
end;

procedure DotFillNew(Canvas: TCanvas; R: TRect; Color: TColor; Border: Integer);
var
  DC: HDC;
  Pt: TPoint;
  Brush: HBRUSH;
begin
  CreateDottedPattern(Color);
  Canvas.Brush.Color := Color;
  Canvas.FillRect(R);
  InflateRect(R, -Border, -Border);
  DC := Canvas.Handle;
  Brush := CreatePatternBrush(StockPatternBitmap.Handle);
  GetWindowOrgEx(DC, Pt);
  SetBrushOrgEx(DC, R.Left - Pt.X, R.Top - Pt.Y, nil);
  Windows.FillRect(DC, R, Brush);
  DeleteObject(Brush);
end;

procedure DrawButtonBitmap(Canvas: TCanvas; R: TRect);
const
  Pattern: array [0..15] of Byte = ($C6, 0, $6C, 0, $38, 0, $38, 0, $6C, 0, $C6, 0, 0, 0, 0, 0);
begin
  DrawGlyph(Canvas.Handle, R, 7, 6, Pattern[0], clBtnText);
end;

procedure RoundFrame(DC: HDC; R: TRect; RL, RR: Integer; C: TColor);
var
  P: array [0..8] of TPoint;
  OldPen, Pen: HPen;
begin
  if C < 0 then C := GetSysColor(C and $FF);
  with R do
  begin
    Dec(Right); Dec(Bottom);
    with P[0] do begin X := Left + RL; Y := Top; end;
    with P[1] do begin X := Right - RR; Y := Top; end;
    with P[2] do begin X := Right; Y := Top + RR; end;
    with P[3] do begin X := Right; Y := Bottom - RR; end;
    with P[4] do begin X := Right - RR; Y := Bottom; end;
    with P[5] do begin X := Left + RL; Y := Bottom; end;
    with P[6] do begin X := Left; Y := Bottom - RL; end;
    with P[7] do begin X := Left; Y := Top + RL; end;
    with P[8] do begin X := Left + RL; Y := Top; end;
    Pen := CreatePen(PS_SOLID, 1, C);
    OldPen := SelectObject(DC, Pen);
    Windows.Polyline(DC, P[0], 9);
    SelectObject(DC, OldPen);
    DeleteObject(Pen);
    Inc(Right); Inc(Bottom);
  end;
end;

{ TTBXMonaiXPTheme }

function TTBXMonaiXPTheme.GetBooleanMetrics(Index: Integer): Boolean;
begin
  case Index of
    TMB_EDITHEIGHTEVEN:            Result := False;
    TMB_PAINTDOCKBACKGROUND:       Result := False;
    TMB_SOLIDTOOLBARNCAREA:        Result := False;
    TMB_SOLIDTOOLBARCLIENTAREA:    Result := False;
  else
    Result := inherited GetBooleanMetrics(Index);
  end;
end;

function TTBXMonaiXPTheme.GetViewColor(AViewType: Integer): TColor;
begin
  Result := ToolbarColor;
  if (AViewType and VT_TOOLBAR) = VT_TOOLBAR then Result := clBtnFace
  else if (AViewType and VT_POPUP) = VT_POPUP then
  begin
    if (AViewType and PVT_POPUPMENU) = PVT_POPUPMENU then Result := clPopup
    else if (AViewType and PVT_LISTBOX) = PVT_LISTBOX then Result := clWindow
    else if (AViewType and PVT_TOOLBOX) = PVT_TOOLBOX then Result := clWindow
    else if (AViewType and PVT_CHEVRONMENU) = PVT_CHEVRONMENU then Result := clPopup;
  end
  else if (AViewType and VT_DOCKPANEL) = VT_DOCKPANEL then Result := DockPanelColor;
end;

function TTBXMonaiXPTheme.GetItemColor(const ItemInfo: TTBXItemInfo): TColor;
begin
  Result := inherited GetItemColor(ItemInfo);
end;

function TTBXMonaiXPTheme.GetIntegerMetrics(Index: Integer): Integer;
begin
  case Index of
    TMI_SPLITBTN_ARROWWIDTH:         Result := 12;
    TMI_MENU_MDI_DW:                 Result := 1;
    TMI_MENU_MDI_DH:                 Result := 2;
    TMI_EDIT_FRAMEWIDTH:             Result := 2;
    TMI_EDIT_TEXTMARGINHORZ:         Result := 2;
    TMI_EDIT_TEXTMARGINVERT:         Result := 1;
    TMI_EDIT_BTNWIDTH:               Result := 14;
  else
    Result := inherited GetIntegerMetrics(Index);
  end;
end;

function TTBXMonaiXPTheme.GetItemTextColor(const ItemInfo: TTBXItemInfo): TColor;
var
  InMenuBar, ToolbarStyle, ShowInactive: Boolean;
begin
  with ItemInfo do
  begin
    InMenuBar := (ItemInfo.ViewType and TVT_MENUBAR) = TVT_MENUBAR;
    ToolbarStyle := Boolean(ItemOptions and IO_TOOLBARSTYLE);
    ShowInactive := InMenubar and not Boolean(ItemOptions and IO_APPACTIVE);

    if not ToolbarStyle and not Enabled and (HoverKind = hkKeyboardHover) then Result := clBtnShadow
    else if not Enabled then Result := DisabledColor
    else if not ToolbarStyle or InMenuBar then
    begin
      if HoverKind <> hkNone then Result := clHighlightText
      else if ShowInactive then Result := clGrayText
      else Result := clMenuText
    end
    else Result := clBtnText;
  end;
end;

procedure TTBXMonaiXPTheme.GetViewBorder(ViewType: Integer; out Border: TPoint);
const
  XMetrics: array [Boolean] of Integer = (SM_CXDLGFRAME, SM_CXFRAME);
  YMetrics: array [Boolean] of Integer = (SM_CYDLGFRAME, SM_CYFRAME);
var
  Resizable: Boolean;
  Sz: Integer;
begin
  Sz := 0;
  if (ViewType and VT_TOOLBAR) = VT_TOOLBAR then
  begin
    if (ViewType and TVT_FLOATING) = TVT_FLOATING then
    begin
      Resizable := (ViewType and TVT_RESIZABLE) = TVT_RESIZABLE;
      Border.X := GetSystemMetrics(XMetrics[Resizable]);
      Border.Y := GetSystemMetrics(YMetrics[Resizable]);
      Exit;
    end
    else Sz := 2;
  end
  else if (ViewType and VT_POPUP) = VT_POPUP then
  begin
    if (ViewType and PVT_LISTBOX) = PVT_LISTBOX then Sz := 2
    else Sz := 3;
  end
  else if (ViewType and VT_DOCKPANEL) = VT_DOCKPANEL then
  begin
    if (ViewType and DPVT_FLOATING) = DPVT_FLOATING then
    begin
      Resizable := (ViewType and DPVT_RESIZABLE) = DPVT_RESIZABLE;
      Border.X := GetSystemMetrics(XMetrics[Resizable]);
      Border.Y := GetSystemMetrics(YMetrics[Resizable]);
      Exit;
    end
    else Sz := 2;
  end;
  Border.X := Sz;
  Border.Y := Sz;
end;

procedure TTBXMonaiXPTheme.PaintBackgnd(Canvas: TCanvas; const ADockRect, ARect, AClipRect: TRect;
  AColor: TColor; Transparent: Boolean; AViewType: Integer);
var
  Brush: HBrush;
  R: TRect;
begin
 if not Transparent then
  begin
    Brush:= CreateSolidBrush(ColorToRGB(AColor));
    IntersectRect(R, ARect, AClipRect);
    FillRect(Canvas.Handle, R, Brush);
    DeleteObject(Brush);
  end;
end;

procedure TTBXMonaiXPTheme.PaintCaption(Canvas: TCanvas; const ARect: TRect;
  const ItemInfo: TTBXItemInfo; const ACaption: string; AFormat: Cardinal; Rotated: Boolean);
var
  R: TRect;
  C: TColor;
  InMenuBar: Boolean;

  procedure _Draw(Color: TColor);
  begin
    Canvas.Font.Color := Color;
    if not Rotated then Windows.DrawText(Canvas.Handle, PChar(ACaption), Length(ACaption), R, AFormat)
    else DrawRotatedText(Canvas.Handle, ACaption, R, AFormat);
  end;

begin
  with ItemInfo, Canvas do
  begin
    R := ARect;
    Brush.Style := bsClear;
    InMenuBar := (ItemInfo.ViewType and TVT_MENUBAR) = TVT_MENUBAR;

    if (Pushed or Selected) and not InMenuBar then OffsetRect(R, 1, 1);
    C := Font.Color;
    if C = clNone then C := GetItemTextColor(ItemInfo);
    _Draw(C);
    Brush.Style := bsSolid;
  end;
end;

procedure TTBXMonaiXPTheme.PaintDropDownArrow(Canvas: TCanvas;
  const ARect: TRect; const ItemInfo: TTBXItemInfo);
const
  ArrowColor: array [Boolean] of TColor = (clBtnText, clMenuText);
var
  X, Y: Integer;
  C: TColor;
begin
  with ItemInfo, ARect, Canvas do
  begin
    X := (Left + Right) div 2 + Ord(Pushed or Selected);
    Y := (Top + Bottom) div 2 - 1 + Ord(Pushed or Selected);
    if Enabled then C := ArrowColor[not Boolean(ItemOptions and IO_TOOLBARSTYLE)]
    else C := DisabledColor;
    Pen.Color := C;
    Brush.Color := C;
    if ItemInfo.IsVertical then
      Polygon([Point(X, Y + 2), Point(X, Y - 2), Point(X - 2, Y)])
    else
      Polygon([Point(X - 2, Y), Point(X + 2, Y), Point(X, Y + 2)]);
  end;
end;

procedure TTBXMonaiXPTheme.PaintButton(Canvas: TCanvas; const ARect: TRect; const ItemInfo: TTBXItemInfo);
var
  DC: HDC;
  R: TRect;
  C: TColor;
  ShowHover, Embedded: Boolean;
  RL, RR: Integer;
begin
  DC := Canvas.Handle;
  R := ARect;
  with ItemInfo, Canvas do
  begin
    ShowHover := (Enabled and (HoverKind <> hkNone)) or
      (not Enabled and (HoverKind = hkKeyboardHover));
    Embedded := (ViewType and VT_TOOLBAR = VT_TOOLBAR) and
      (ViewType and TVT_EMBEDDED = TVT_EMBEDDED);
    RL := 2;
    RR := 2;

    if ComboPart = cpSplitRight then
    begin
      Dec(R.Left);
      Dec(RL);
    end;
    if ComboPart = cpSplitLeft then Dec(RR);
    if (ItemInfo.ItemOptions and IO_TOOLBARSTYLE) = 0 then
    begin
      RR := 1; RL := 1;
    end;

    if Embedded and not ShowHover then
    begin
      if Enabled then
      begin
        InflateRect(R, -1, -1);
        FillRectEx(DC, R, NearestMixedColor(clWindow, clBtnFace, 16));
        InflateRect(R, 1, 1);
        C := NearestMixedColor(clWindow, clBtnShadow, 64);
      end
      else
        C := clBtnFace;
      RoundFrame(DC, R, RL, RR, C);
    end;

    if (ViewType and TVT_MENUBAR) = TVT_MENUBAR then
    begin
      if ((Pushed or Selected) and Enabled) or ShowHover then
      begin
        Canvas.Brush.Color := clHighlight;
        Canvas.FillRect(R);
      end;
      Exit;
    end;

    if (Pushed or Selected) and Enabled then
    begin
      InflateRect(R, -1, -1);
      if not Pushed and (HoverKind = hkNone) then
        DitherRect(DC, R, clWindow, clBtnHighlight)
      else
      begin
        if not TBXLoColor then C := MixColors(clBtnHighlight, clBtnFace, 128)
        else C := clBtnHighlight;
        DitherRect(DC, R, C, clBtnHighlight);
      end;
      with Canvas, R do
      begin
        PolyLineEx(DC, [Point(Left, Bottom - 2), Point(Left, Top), Point(Right - 1, Top)], clBtnFace);
      end;
      InflateRect(R, 1, 1);
      RoundFrame(DC, R, RL, RR, clBtnShadow);
    end
    else if ShowHover or ((ItemOptions and IO_DESIGNING) <> 0) then
    begin
      if HoverKind <> hkNone then
      begin
        if not TBXLoColor then C := MixColors(clBtnHighlight, clBtnFace, 192)
        else C := clBtnFace;
        InflateRect(R, -1, -1);
        DitherRect(DC, R, clBtnFace, C);
        InflateRect(R, 1, 1);
      end;
      if not TBXLoColor then C := MixColors(clBtnShadow, clBtnFace, 192)
      else C := clBtnShadow;
      RoundFrame(DC, R, RL, RR, C);
    end;
    if ComboPart = cpSplitRight then PaintDropDownArrow(Canvas, R, ItemInfo);
  end;
end;

procedure TTBXMonaiXPTheme.PaintFloatingBorder(Canvas: TCanvas; const ARect: TRect;
  const WindowInfo: TTBXWindowInfo);
var
  DC: HDC;
  BorderColor, C: TColor;
  SaveIndex: Integer;
  Sz: TPoint;
  R, R2: TRect;
  Size: TSize;
  CaptionString: string;
  IsPushed, IsHovered: Boolean;
begin
  DC := Canvas.Handle;
  with Canvas do
  begin
    BorderColor := NearestMixedColor(clBtnShadow, clBlack, 127);
    if (WRP_BORDER and WindowInfo.RedrawPart) <> 0  then
    begin
      R := ARect;
      FrameRectEx(DC, R, BorderColor, True);
      Windows.DrawEdge(DC, R, BDR_RAISEDINNER, BF_RECT or BF_ADJUST);
      FrameRectEx(DC, R, clBtnFace, True);
      FrameRectEx(DC, R, clBtnFace, True);

      SaveIndex := SaveDC(Canvas.Handle);
      Sz := WindowInfo.FloatingBorderSize;
      with ARect, Sz do R2 := Rect(Left + X, Top + Y, Right - X, Bottom - Y);
      with R2 do ExcludeClipRect(Canvas.Handle, Left, Top, Right, Bottom);
      FillRectEx(DC, R, GetViewColor(WindowInfo.ViewType));
      RestoreDC(DC, SaveIndex);
    end;

    if not WindowInfo.ShowCaption then Exit;

    { Caption }
    if (WRP_CAPTION and WindowInfo.RedrawPart) <> 0 then
    begin
      R := Rect(0, 0, WindowInfo.ClientWidth, GetSystemMetrics(SM_CYSMCAPTION));
      with WindowInfo.FloatingBorderSize do OffsetRect(R, X, Y);

      Dec(R.Bottom);
      DrawLineEx(DC, R.Left, R.Bottom, R.Right, R.Bottom, clBtnFace);
      Dec(R.Bottom);
      DrawLineEx(DC, R.Left - 1, R.Bottom, R.Right + 1, R.Bottom, DisabledColor);

      if ((CDBS_VISIBLE and WindowInfo.CloseButtonState) <> 0) and
        ((WRP_CLOSEBTN and WindowInfo.RedrawPart) <> 0) then
        Dec(R.Right, GetSystemMetrics(SM_CYSMCAPTION));

      Canvas.Font.Assign(SmCaptionFont);
      Canvas.Font.Color := clBtnText;
      CaptionString := string(WindowInfo.Caption);
      Size := TextExtent(CaptionString);
      if Size.cx > 0 then Inc(Size.cx, 16);

      if WindowInfo.Active and (Size.cx < R.Right - R.Left) then
      begin
        if Size.cx = 0 then DotFill(Canvas, R, clBtnFace, 2)
        else
        begin
          R2 := R;
          R2.Right := (R.Left + R.Right - Size.cx) div 2;
          DotFill(Canvas, R2, clBtnFace, 2);
          R2.Right := R.Right;
          R2.Left := (R.Left + R.Right + Size.cx) div 2;
          DotFill(Canvas, R2, clBtnFace, 2);
          R2.Right := R2.Left;
          R2.Left := (R.Left + R.Right - Size.cx) div 2;
          Brush.Color := clBtnFace;
          FillRect(R2);
        end;
      end
      else FillRectEx(DC, R, clBtnFace);

      InflateRect(R, -2, 0);
      Dec(R.Top, 2);

      DrawText(DC, PChar(CaptionString), Length(CaptionString), R,
        DT_SINGLELINE or DT_CENTER or DT_VCENTER or DT_END_ELLIPSIS or DT_HIDEPREFIX);
    end;

    { Close button }
    if (CDBS_VISIBLE and WindowInfo.CloseButtonState) <> 0 then
    begin
      R := Rect(0, 0, WindowInfo.ClientWidth, GetSystemMetrics(SM_CYSMCAPTION));
      with Windowinfo.FloatingBorderSize do OffsetRect(R, X, Y);

      R.Left := R.Right - (R.Bottom - R.Top) - 1;      

      FillRectEx(DC, R, clBtnFace);

      Dec(R.Bottom, 2);
      DrawLineEx(DC, R.Left, R.Bottom, R.Right, R.Bottom, DisabledColor);
      Dec(R.Bottom, 2);
      Inc(R.Left, 4);

      IsPushed := (CDBS_PRESSED and WindowInfo.CloseButtonState) <> 0;
      IsHovered := (CDBS_HOT and WindowInfo.CloseButtonState) <> 0;

      if IsPushed or IsHovered then
      begin
        RoundFrame(DC, R, 1, 1, clBtnShadow);
        InflateRect(R, -1, -1);
        if IsPushed then FillRectEx(DC, R, clBtnHighlight)
        else
        begin
          if not TBXLoColor then C := MixColors(clBtnHighlight, clBtnFace, 192)
          else C := clBtnFace;
          DitherRect(DC, R, clBtnFace, C);
        end;
        if IsPushed then OffsetRect(R, 1, 1);
      end;

      DrawButtonBitmap(Canvas, R);
    end;
  end;
end;

procedure TTBXMonaiXPTheme.PaintFrame(Canvas: TCanvas; const ARect: TRect; const ItemInfo: TTBXItemInfo);
var
  DC: HDC;
  R: TRect;
  E: Boolean;
begin
  DC := Canvas.Handle;
  R := ARect;
  with ItemInfo do
  begin
    E := Enabled or (not Enabled and (HoverKind = hkKeyboardHover));
    if not E then
    begin
      InflateRect(R, -1, -1);
      FrameRectEx(DC, R, DisabledColor, False);
    end
    else if Pushed or Selected {or Embedded} or (HoverKind <> hkNone) or
      ((ItemOptions and IO_DESIGNING) <> 0) then
    begin
      InflateRect(R, -1, -1);
      FrameRectEx(DC, R, clWindow, False);
      InflateRect(R, 1, 1);
      RoundFrame(DC, R, 1, 1, DisabledColor);
    end
    else
    begin
      InflateRect(R, -1, -1);
      FrameRectEx(DC, R, DisabledColor, False);
    end;
  end;
end;

procedure TTBXMonaiXPTheme.PaintEditButton(Canvas: TCanvas; const ARect: TRect;
  var ItemInfo: TTBXItemInfo; ButtonInfo: TTBXEditBtnInfo);
const
  ArrowColor: array [Boolean] of TColor = (clBtnText, clMenuText);
var
  DC: HDC;
  BtnDisabled, BtnHot, BtnPressed, Embedded: Boolean;
  R, BR: TRect;
  X, Y: Integer;
  C: TColor;

  procedure PaintEnabled(R: TRect; Pressed: Boolean);
  begin
    if Pressed then
    begin
      if not TBXLoColor then C := MixColors(clBtnHighlight, clBtnFace, 126)
      else C := clBtnHighlight;
      DitherRect(DC, R, C, clBtnHighlight);
    end
    else if BtnHot then
    begin
      if not TBXLoColor then C := NearestMixedColor(clBtnHighlight, clBtnFace, 192)
      else C := clBtnFace;
      DitherRect(DC, R, clBtnFace, C)
    end
    else if Embedded then FillRectEx(DC, R, clBtnFace);
  end;

begin
  DC := Canvas.Handle;
  with Canvas, ItemInfo do
  begin
    R := ARect;
//    W := EditFrameWidth;
    Inc(R.Left);
    Embedded := ((ViewType and VT_TOOLBAR) = VT_TOOLBAR) and ((ViewType and TVT_EMBEDDED) = TVT_EMBEDDED);
    BtnDisabled := (ButtonInfo.ButtonState and EBDS_DISABLED) <> 0;

    if ButtonInfo.ButtonType = EBT_DROPDOWN then
    begin
      BtnHot := (ButtonInfo.ButtonState and EBDS_HOT) <> 0;
      BtnPressed := (ButtonInfo.ButtonState and EBDS_PRESSED) <> 0;
      if BtnHot or BtnPressed then InflateRect(R, -1, -1)
      else InflateRect(R, -2, -2);
      if not BtnDisabled then
      begin
        PaintEnabled(R, BtnPressed);
        DrawLineEx(DC, R.Left - 1, R.Top, R.Left - 1, R.Bottom, DisabledColor);
      end;
      PaintDropDownArrow(Canvas, R, ItemInfo);
    end
    else if ButtonInfo.ButtonType = EBT_SPIN then
    begin
      BtnHot := (ButtonInfo.ButtonState and EBSS_HOT) <> 0;
      BtnPressed := (ButtonInfo.ButtonState and (EBSS_UP or EBSS_DOWN)) <> 0;
      if BtnHot or BtnPressed then InflateRect(R, -1, -1)
      else InflateRect(R, -2, -2);

      if not BtnDisabled then
      begin
        { Upper button }
        BR := R; BR.Bottom := (R.Top + R.Bottom + 1) div 2;

        PaintEnabled(BR, (ButtonInfo.ButtonState and EBSS_UP) <> 0);

        { Lower button }
        BR := R; BR.Top := (R.Top + R.Bottom) div 2;
        PaintEnabled(BR, (ButtonInfo.ButtonState and EBSS_DOWN) <> 0);

        DrawLineEx(DC, R.Left - 1, R.Top, R.Left - 1, R.Bottom, DisabledColor);
        Y := (R.Top + R.Bottom - 1) div 2;
        DrawLineEx(DC, R.Left, Y, R.Right, Y, DisabledColor);
        Y := (R.Top + R.Bottom) div 2;
        DrawLineEx(DC, R.Left, Y, R.Right, Y, DisabledColor);
      end;

      { Arrows }
      if not BtnDisabled then Pen.Color := ArrowColor[not Boolean(ItemOptions and IO_TOOLBARSTYLE)]
      else Pen.Color := DisabledColor;
      Brush.Color := Pen.Color;

      BtnPressed := (ButtonInfo.ButtonState and EBSS_UP) <> 0;
      X := (R.Left + R.Right) div 2 + Ord(BtnPressed);
      Y := (3 * R.Top + R.Bottom) div 4 + Ord(BtnPressed);
      Polygon([Point(X - 2, Y + 1), Point(X + 2, Y + 1), Point(X, Y - 1)]);

      BtnPressed := (ButtonInfo.ButtonState and EBSS_DOWN) <> 0;
      X := (R.Left + R.Right) div 2 + Ord(BtnPressed);
      Y := (R.Top + 3 * R.Bottom) div 4 + Ord(BtnPressed);
      Polygon([Point(X - 2, Y - 1), Point(X + 2, Y - 1), Point(X, Y + 1)]);
    end;
  end;
end;

procedure TTBXMonaiXPTheme.PaintEditFrame(Canvas: TCanvas;
  const ARect: TRect; var ItemInfo: TTBXItemInfo; const EditInfo: TTBXEditInfo);
var
  DC: HDC;
  R: TRect;
  W: Integer;
begin
  DC := Canvas.Handle;
  R := ARect;
  PaintFrame(Canvas, R, ItemInfo);
  W := EditFrameWidth;
  InflateRect(R, -W, -W);
  
  with EditInfo do
    if RightBtnWidth > 0 then Dec(R.Right, RightBtnWidth - 2);
  
  if ItemInfo.Enabled then FillRectEx(DC, R, clWindow);
  InflateRect(R, -1, -1);

  with EditInfo do if LeftBtnWidth > 0 then Inc(R.Left, LeftBtnWidth - 2);

  if EditInfo.RightBtnWidth > 0 then
  begin
    R := ARect;
    R.Left := R.Right - EditInfo.RightBtnWidth - W;
    PaintEditButton(Canvas, R, ItemInfo, EditInfo.RightBtnInfo);
  end;
end;

procedure TTBXMonaiXPTheme.PaintImage(Canvas: TCanvas; ARect: TRect;
  const ItemInfo: TTBXItemInfo; ImageList: TCustomImageList; ImageIndex: Integer);
var
  HiContrast: Boolean;
begin
  with ItemInfo do
  begin
    if ImageList is TTBCustomImageList then
    begin
      if Selected or Pushed then OffsetRect(ARect, 1, 1);
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
        DrawTBXIconFlatShadow(Canvas, ARect, ImageList, ImageIndex, clBtnShadow);
    end
    else if Selected or Pushed or (HoverKind <> hkNone) then
    begin
      if Selected or Pushed then OffsetRect(ARect, 1, 1)
      else
      begin
        OffsetRect(ARect, 1, 1);
        DrawTBXIconShadow(Canvas, ARect, ImageList, ImageIndex, 1);
        OffsetRect(ARect, 1, 1);
        DrawTBXIconShadow(Canvas, ARect, ImageList, ImageIndex, 1);
        OffsetRect(ARect, -2, -2);
      end;
      DrawTBXIcon(Canvas, ARect, ImageList, ImageIndex, HiContrast);
    end
    else if HiContrast or TBXHiContrast then
      DrawTBXIcon(Canvas, ARect, ImageList, ImageIndex, HiContrast)
    else
      BlendTBXIcon(Canvas, ARect, ImageList, ImageIndex, 200);
  end;
end;

procedure TTBXMonaiXPTheme.PaintMenuItemFrame(Canvas: TCanvas;
  const ARect: TRect; const ItemInfo: TTBXItemInfo);
const
  ZERO_RECT: TRect = (Left: 0; Top: 0; Right: 0; Bottom: 0);
begin
  with ItemInfo do if (Enabled and (HoverKind <> hkNone)) or
    (not Enabled and (HoverKind = hkKeyboardHover)) then
  begin
    PaintBackgnd(Canvas, ZERO_RECT, ARect, ARect, clHighlight, False, VT_UNKNOWN);
  end;
end;

procedure TTBXMonaiXPTheme.PaintMenuItem(Canvas: TCanvas; const ARect: TRect; var ItemInfo: TTBXItemInfo);
const
  ZERO_RECT: TRect = (Left: 0; Top: 0; Right: 0; Bottom: 0);
var
  DC: HDC;
  R: TRect;
  ShowImageOrCheck: Boolean;
  IsCombo: Boolean;
  X, Y: Integer;
  ArrowWidth: Integer;

  procedure DrawArrow(AColor: TColor);
  begin
    Canvas.Pen.Color := AColor;
    Canvas.Brush.Color := AColor;
    Canvas.Polygon([Point(X, Y - 3), Point(X, Y + 3), Point(X + 3, Y)]);
  end;

begin
  DC := Canvas.Handle;
  with ItemInfo do
  begin
    ShowImageOrCheck := (ImageWidth > 0) or Selected;
    IsCombo := ((ItemOptions and IO_COMBO) <> 0);
    ArrowWidth := GetSystemMetrics(SM_CXMENUCHECK);

    R := ARect;
    if ShowImageOrCheck then Inc(R.Left, ItemInfo.PopupMargin + MenuImageTextSpace);
    if IsCombo and Enabled then Dec(R.Right, ArrowWidth + 1);

    PaintMenuItemFrame(Canvas, R, ItemInfo);

    if IsCombo then
    begin
      R.Left := ARect.Right - ArrowWidth;
      R.Right := ARect.Right;
      if Enabled and (HoverKind <> hkNone) then
        PaintBackgnd(Canvas, ZERO_RECT, R, R, clHighlight, False, PVT_POPUPMENU)
      else
      begin
        Dec(R.Left);
        DrawLineEx(DC, R.Left, R.Top, R.Left, R.Bottom, DisabledColor);
      end;
    end;

    if (ItemOptions and IO_SUBMENUITEM) <> 0 then 
    begin
      Y := ARect.Bottom div 2;
      X := ARect.Right - ArrowWidth * 2 div 3;
      if not Enabled then
      begin
        if HoverKind = hkKeyboardHover then DrawArrow(clBtnShadow)
        else DrawArrow(DisabledColor);
      end
      else if (HoverKind <> hkNone) {and not IsCombo} then DrawArrow(clHighlightText)
      else DrawArrow(clMenuText);
    end;

    if ShowImageOrCheck and ((HoverKind <> hkNone) or Selected) then
    begin
      R.Left := ARect.Left;
      R.Right := R.Left + ItemInfo.PopupMargin;
      PaintButton(Canvas, R, ItemInfo);
    end;
  end;
end;

procedure TTBXMonaiXPTheme.PaintPopupNCArea(Canvas: TCanvas; R: TRect; const PopupInfo: TTBXPopupInfo);
begin
  Canvas.Brush.Color := GetNearestColor(Canvas.Handle, MixColors(clBtnShadow, clBlack, 127));
  Canvas.FrameRect(R);
  InflateRect(R, -1, -1);

  if (PopupInfo.ViewType and PVT_LISTBOX) = PVT_LISTBOX then
  begin
    Windows.FillRect(Canvas.Handle, R, GetSysColorBrush(COLOR_WINDOW));
  end
  else if not USE_FLATMENUS or ((PopupInfo.ViewType and PVT_TOOLBOX) = PVT_TOOLBOX) then
  begin
    Canvas.Brush.Color := DockPanelColor;  // ToolbarColor;
    Canvas.FillRect(R);
  end
  else
  begin
    Canvas.Brush.Color := clPopup;
    Canvas.FillRect(R);
  end;
end;

procedure TTBXMonaiXPTheme.PaintSeparator(Canvas: TCanvas; ARect: TRect;
  ItemInfo: TTBXItemInfo; Horizontal, LineSeparator: Boolean);
var
  DC: HDC;
begin
  DC := Canvas.Handle;
  with ItemInfo, ARect do
  if Enabled then
  begin
    if Horizontal then
    begin
      Top := Bottom div 2;
      DrawLineEx(DC, Left + 1, Top, Right - 1, Top, DisabledColor)
    end
    else if enabled then
    begin
      Left := Right div 2;
      DrawLineEx(DC, Left, Top + 1, Left, Bottom - 1, DisabledColor);
    end;
  end;
end;

procedure TTBXMonaiXPTheme.PaintToolbarNCArea(Canvas: TCanvas; R: TRect; const ToolbarInfo: TTBXToolbarInfo);
var
  Sz: Integer;
  R2: TRect;
  C, SaveColor: TColor;
  SaveStyle: TBrushStyle;
  BtnVisible, Horz, CloseButtondown, CloseButtonHover: Boolean;
begin
  with Canvas do
  begin
    { Border }
    SaveColor := Brush.Color;
    SaveStyle := Brush.Style;
    if ToolbarInfo.BorderStyle = bsSingle then
      Windows.DrawEdge(Canvas.Handle, R, BDR_RAISEDINNER, BF_RECT or BF_ADJUST);
    FillRect(R);
    Inflaterect(R, -1, -1);

    if not ToolbarInfo.AllowDrag then Exit;

    if not ToolbarInfo.AllowDrag then Exit;

    BtnVisible := (ToolbarInfo.CloseButtonState and CDBS_VISIBLE) <> 0;
    Sz := GetTBXDragHandleSize(ToolbarInfo);
    Horz := not ToolbarInfo.IsVertical;
    if Horz then R.Right := R.Left + Sz
    else R.Bottom := R.Top + Sz;

    { Drag Handle }
    if ToolbarInfo.DragHandleStyle <> DHS_NONE then
    begin
      R2 := R;
      if Horz then
      begin
        Dec(R2.Left, 1);
        Inc(R2.Right, 1);
        if BtnVisible then
        begin
          Inc(R2.Top, Sz - 2);
          Inc(R2.Left, 1);
          Dec(R2.Right, 4);
        end;
      end
      else
      begin
        Dec(R2.Top, 1);
        Inc(R2.Bottom, 1);
        if BtnVisible then
        begin
          Dec(R2.Right, Sz - 2);
          Inc(R2.Top, 1);
          Dec(R2.Bottom, 4);
        end;
      end;
      InflateRect(R2, -1, -1);
      if SaveStyle = bsClear then DotFillNew(Canvas, R2, clNone, 1)
      else DotFillNew(Canvas, R2, SaveColor, 1);
    end;

    { Close button }
    if BtnVisible then
    begin
      CloseButtonDown := (ToolbarInfo.CloseButtonState and CDBS_PRESSED) <> 0;
      CloseButtonHover := (ToolbarInfo.CloseButtonState and CDBS_HOT) <> 0;
      R2 := GetTBXDockedCloseButtonRect(ToolbarInfo);
      if Horz then OffsetRect(R2, -1, 0)
      else Offsetrect(R2, 0, -1);

      InflateRect(R2, -1, -1);
      if CloseButtonDown or CloseButtonHover then
      begin
        if CloseButtonDown then
        begin
          if not TBXLoColor then C := MixColors(clBtnHighlight, clBtnFace, 126)
          else C := clBtnHighlight;
          DitherRect(Canvas.Handle, R2, clBtnHighlight, C);
        end
        else
        begin
          if not TBXLoColor then C := MixColors(clBtnHighlight, clBtnFace, 192)
          else C := clBtnFace;
          DitherRect(Canvas.Handle, R2, clBtnFace, C);
        end;

        InflateRect(R2, 1, 1);
        if not TBXLoColor or not CloseButtonDown then
          Pen.Color := NearestMixedColor(clBtnShadow, clBtnFace, 191)
        else
          Pen.Color := clBtnShadow;
        RoundFrame(Canvas.Handle, R2, 1, 1, Pen.Color);
      end;

      if CloseButtonDown then OffsetRect(R2, 1, 1);
      DrawButtonBitmap(Canvas, R2);
    end;
  end;
end;

procedure TTBXMonaiXPTheme.PaintMDIButton(Canvas: TCanvas; ARect: TRect;
  const ItemInfo: TTBXItemInfo; ButtonKind: Cardinal);
var
  Index: Integer;
  X, Y: Integer;
begin
  PaintButton(Canvas, ARect, ItemInfo);
  with ARect do
  begin
    X := (Left + Right - StockImgList.Width) div 2 + Ord(ItemInfo.Pushed);
    Y := (Top + Bottom - StockImgList.Height - 1) div 2 + Ord(ItemInfo.Pushed);
  end;
  case ButtonKind of
    DFCS_CAPTIONMIN: Index := 2;
    DFCS_CAPTIONRESTORE: Index := 3;
    DFCS_CAPTIONCLOSE: Index := 0;
  else
    Exit;
  end;
  DrawGlyph(Canvas.Handle, X, Y, StockImgList, Index, clBtnText);
end;

function TTBXMonaiXPTheme.GetPopupShadowType: Integer;
begin
  Result := PST_WINDOWS2K;
end;

constructor TTBXMonaiXPTheme.Create(const AName: string);
begin
  inherited;
  if CounterLock = 0 then InitializeStock;
  Inc(CounterLock);
end;

destructor TTBXMonaiXPTheme.Destroy;
begin
  Dec(CounterLock);
  if CounterLock = 0 then FinalizeStock;
  inherited;
end;

procedure TTBXMonaiXPTheme.PaintDock(Canvas: TCanvas; const ClientRect,
  DockRect: TRect; DockPosition: Integer);
begin
  // this theme does not support dock painting
end;

procedure TTBXMonaiXPTheme.PaintDockPanelNCArea(Canvas: TCanvas; R: TRect;
  const DockPanelInfo: TTBXDockPanelInfo);
var
  DC: HDC;
  Sz: Integer;
  R2: TRect;
  Flags: Integer;
  CloseButtonDown, CloseButtonHover: Boolean;
  C: TColor;
  TextSize, TextSize2: TSize;
begin
  DC := Canvas.Handle;
  with Canvas, DockPanelInfo do
  begin
    Sz := GetSystemMetrics(SM_CYSMCAPTION);

    { Border }
    FrameRectEx(DC, R, ToolbarColor, True);
    R2 := R;
    if ShowCaption then
      if IsVertical then Inc(R2.Top, Sz)
      else Inc(R2.Left, Sz);
    Brush.Color := DockPanelInfo.EffectiveColor;
    FrameRect(R2);

    if not ShowCaption then Exit;

    C := DockPanelInfo.EffectiveColor;
    Brush.Color := C;

    R2 := R;
    Pen.Color := NearestMixedColor(clBtnShadow, clBtnFace,  128);
    if IsVertical then R.Bottom := R.Top + Sz
    else R.Right := R.Left + Sz;
    Windows.DrawEdge(Handle, R, BDR_RAISEDINNER, BF_RECT or BF_MIDDLE or BF_ADJUST);

    { Close button }
    if (CDBS_VISIBLE and CloseButtonState) <> 0 then
    begin
      CloseButtonDown := (CloseButtonState and CDBS_PRESSED) <> 0;
      CloseButtonHover := (CloseButtonState and CDBS_HOT) <> 0;
      R2 := R;
      Brush.Color := clBtnFace;

      if IsVertical then
      begin
        Dec(R2.Right);
        R2.Left := R2.Right - Sz + 1;
        R.Right := R2.Left;
      end
      else
      begin
        Dec(R2.Bottom);
        R2.Top := R2.Bottom - Sz + 2;
        R.Bottom := R2.Top;
      end;

      InflateRect(R2, -2, -2);
      if CloseButtonDown or CloseButtonHover then
      begin
        if CloseButtonDown then
        begin
          if not TBXLoColor then C := NearestMixedColor(clBtnHighlight, clBtnFace, 126)
          else C := clBtnHighlight;
          DitherRect(DC, R2, clBtnHighlight, C);
        end
        else
        begin
          if not TBXLoColor then C := NearestMixedColor(clBtnHighlight, clBtnFace, 192)
          else C := clBtnFace;
          DitherRect(DC, R2, clBtnFace, C);
        end;

        InflateRect(R2, 1, 1);
        if not TBXLoColor or not CloseButtonDown then
          C := NearestMixedColor(clBtnShadow, clBtnFace, 191)
        else
          C := clBtnShadow;

        RoundFrame(DC, R2, 1, 1, C);
      end;

      if CloseButtonDown then OffsetRect(R2, 1, 1);
      DrawButtonBitmap(Canvas, R2);
    end;

    { Caption }
    Brush.Color := ToolbarColor;
    if IsVertical then InflateRect(R, -1, 0)
    else Inflaterect(R, 0, -1);
    Font.Assign(SmCaptionFont);
    Font.Color := clBtnText;

    if IsVertical then
    begin
      TextSize := TextExtent(string(Caption));
      if TextSize.Cx > 0 then Inc(TextSize.Cx, 12);
      if TextSize.Cx < R.Right - R.Left then
      begin
        R2 := R;
        Inc(R2.Top);
        if TextSize.Cx = 0 then DotFill(Canvas, R2, clBtnFace, 1)
        else
        begin
          R2.Right := (R.Left + R.Right - TextSize.cx) div 2;
          Inc(R2.Left);
          DotFill(Canvas, R2, clBtnFace, 1);
          R2.Right := R.Right;
          R2.Left := (R.Left + R.Right + TextSize.cx) div 2;
          DotFill(Canvas, R2, clBtnFace, 1);
          R2.Right := R2.Left;
          R2.Left := (R.Left + R.Right - TextSize.cx) div 2;
          FillRectEx(DC, R2, clBtnFace);
        end;
      end;
    end
    else
    begin
      TextSize2 := TextExtent(string(Caption));
      TextSize.cx := TextSize2.cy;
      TextSize.cy := TextSize2.cx;
      if TextSize.cy > 0 then Inc(TextSize.cy, 12);
      if TextSize.cy < R.Bottom - R.Top then
      begin
        R2 := R;
        Inc(R2.Left);
        if TextSize.cy = 0 then DotFill(Canvas, R2, clBtnFace, 1)
        else
        begin
          R2.Bottom := (R.Top + R.Bottom - TextSize.cy) div 2;
          Inc(R2.Top);
          DotFill(Canvas, R2, clBtnFace, 1);
          R2.Bottom := R.Bottom;
          R2.Top := (R.Top + R.Bottom + TextSize.cy) div 2;
          DotFill(Canvas, R2, clBtnFace, 1);
          R2.Bottom := R2.Top;
          R2.Top := (R.Top + R.Bottom - TextSize.cy) div 2;
          FillRectEx(DC, R2, clBtnFace);
        end;
      end;
    end;

    Brush.Style := bsClear;
    Flags := DT_SINGLELINE or DT_CENTER or DT_VCENTER or DT_END_ELLIPSIS or DT_NOPREFIX;
    if IsVertical then DrawText(Canvas.Handle, Caption, -1, R, Flags)
    else DrawRotatedText(Canvas.Handle, string(Caption), R, Flags);
    Brush.Style := bsSolid;
  end;
end;

procedure TTBXMonaiXPTheme.PaintPageScrollButton(Canvas: TCanvas;
  const ARect: TRect; ButtonType: Integer; Hot: Boolean);
var
  DC: HDC;
  R: TRect;
  X, Y, Sz: Integer;
  C: Longword;
begin
  DC := Canvas.Handle;
  R := ARect;
  InflateRect(R, -1, -1);
  if Hot then DitherRect(DC, R, clBtnFace, clBtnHighlight)
  else FillRectEx(DC, R, clBtnFace);
  InflateRect(R, 1, 1);
  RoundFrame(DC, R, 1, 1, NearestMixedColor(clWindow, clBtnShadow, 64));
  C := GetSysColor(COLOR_BTNFACE);
  with R do
  begin
    SetPixelV(DC, Left, Top, C);
    SetPixelV(DC, Left, Top, C);
    SetPixelV(DC, Right + 1, Top, C);
    SetPixelV(DC, Right + 1, Bottom + 1, C);
    SetPixelV(DC, Left, Bottom + 1, C);
  end;

  { Arrow }
  X := (R.Left + R.Right) div 2;
  Y := (R.Top + R.Bottom) div 2;
  Sz := Min(X - R.Left, Y - R.Top) * 3 div 4;
  Canvas.Pen.Color := clBtnText;
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

procedure TTBXMonaiXPTheme.PaintFrameControl(Canvas: TCanvas; R: TRect; Kind, State: Integer; Params: Pointer);
var
  X, Y: Integer;
  C: TColor;

  procedure SetupPen;
  begin
    if Boolean(State and PFS_DISABLED) then Canvas.Pen.Color := clBtnShadow
    else if Boolean(State and PFS_PUSHED) then Canvas.Pen.Color := clBtnText
    else if Boolean(State and PFS_HOT) then Canvas.Pen.Color := clBtnText
    else Canvas.Pen.Color := clBtnShadow;
  end;

  procedure SetupBrush;
  begin
    Canvas.Brush.Style := bsSolid;
    if Boolean(State and PFS_DISABLED) then Canvas.Brush.Style := bsClear
    else if Boolean(State and PFS_PUSHED) then
    begin
      if not TBXLoColor then C := MixColors(clBtnHighlight, clBtnFace, 126)
      else C := clBtnHighlight;
      Canvas.Brush.Bitmap := AllocPatternBitmap(C, clBtnHighlight);
    end
    else if Boolean(State and PFS_HOT) then
    begin
      if not TBXLoColor then C := MixColors(clBtnHighlight, clBtnFace, 192)
      else C := clBtnFace;
      Canvas.Brush.Bitmap := AllocPatternBitmap(clBtnFace, C);
    end
    else if Boolean(State and PFS_MIXED) then Canvas.Brush.Bitmap := AllocPatternBitmap(clWindow, clBtnFace)
    else Canvas.Brush.Style := bsClear;
  end;

  function TextColor: TColor;
  begin
    if Boolean(State and PFS_DISABLED) then Result := clBtnFace
    else if Boolean(State and PFS_MIXED) then Result := clBtnShadow
    else Result := clBtnText;
  end;

begin
  with Canvas do case Kind of
    PFC_CHECKBOX:
      begin
        SetupPen;
        SetupBrush;
        InflateRect(R, -1, -1);
        with R do Rectangle(Left, Top, Right, Bottom);
        Pen.Style := psSolid;
        Brush.Style := bsSolid;

        if Boolean(State and (PFS_CHECKED or PFS_MIXED)) then
        begin
          X := (R.Left + R.Right) div 2 - 1;
          Y := (R.Top + R.Bottom) div 2 + 1;
          Pen.Color := TextColor;
          Brush.Color := Pen.Color;
          Polygon([Point(X-2, Y), Point(X, Y+2), Point(X+4, Y-2),
            Point(X+4, Y-4), Point(X, Y), Point(X-2, Y-2), Point(X-2, Y)]);
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
  else
    inherited;
  end;
end;

procedure TTBXMonaiXPTheme.PaintStatusBar(Canvas: TCanvas; R: TRect; Part: Integer);
var
  Color, Lo1, Hi1, Lo2, Hi2, Lo3, Hi3, Hi4: TColor;
begin
  with Canvas do
    case Part of
      SBP_BODY:
        begin
          FillRectEx(Canvas.Handle, R, clBtnFace);
          DrawLineEx(Canvas.Handle, R.Left, R.Top + 0, R.Right, R.Top + 0, clBtnShadow);
          DrawLineEx(Canvas.Handle, R.Left, R.Top + 1, R.Right, R.Top + 1,
            NearestMixedColor(clBtnShadow, clBtnFace,  128));
          DrawLineEx(Canvas.Handle, R.Left, R.Top + 2, R.Right, R.Top + 2,
            NearestMixedColor(clBtnShadow, clBtnFace,  64));
          DrawLineEx(Canvas.Handle, R.Left, R.Top + 3, R.Right, R.Top + 3,
            NearestMixedColor(clBtnShadow, clBtnFace,  32));
          DrawLineEx(Canvas.Handle, R.Left, R.Top + 4, R.Right, R.Top + 4,
            NearestMixedColor(clBtnShadow, clBtnFace,  12));

          DrawLineEx(Canvas.Handle, R.Left, R.Bottom - 3, R.Right, R.Bottom - 3,
            NearestMixedColor(clBtnShadow, clBtnFace,  8));
          DrawLineEx(Canvas.Handle, R.Left, R.Bottom - 2, R.Right, R.Bottom - 2,
            NearestMixedColor(clBtnShadow, clBtnFace,  16));
          DrawLineEx(Canvas.Handle, R.Left, R.Bottom - 1, R.Right, R.Bottom - 1,
            NearestMixedColor(clBtnShadow, clBtnFace,  24));
        end;
      SBP_PANE, SBP_LASTPANE:
        begin
          if Part = SBP_PANE then Dec(R.Right, 3);
          DrawLineEx(Canvas.Handle, R.Right, R.Top + 4, R.Right, R.Bottom - 3, DisabledColor);
        end;
      SBP_GRIPPER:
        begin
          Color:= clBtnFace;
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

procedure TTBXMonaiXPTheme.SetupColorCache;
begin
  DockPanelColor := NearestMixedColor(clBtnFace, clWindow, 64);
  if not TBXLoColor then DisabledColor := MixColors(clBtnShadow, clBtnFace, 210)
  else DisabledColor := clBtnShadow;
  ToolbarColor := clBtnFace;
end;

procedure TTBXMonaiXPTheme.GetMargins(MarginID: Integer; out Margins: TTBXMargins);
begin
  inherited;
  if MarginID = MID_MENUITEM then
  begin
    Margins.TopHeight := 2;
    Margins.BottomHeight := 2;
  end;
end;

initialization

RegisterTBXTheme('MonaiXP', TTBXMonaiXPTheme);

end.
