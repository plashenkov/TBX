{*
 * rmkThemes common functions
 * Copyright 2003-2013 Roy Magne Klever. All rights reserved.
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

unit rmkThemes;

interface

uses
  Windows, Messages, Graphics, Types, TBXUtils;

type
  TGradDir = (tgLeftRight, tgTopBottom);

procedure ButtonFrame(Canvas: TCanvas; R: TRect; RL, RR: Integer; c1, c2, c3:
  TColor);

procedure SmartFrame(Canvas: TCanvas; R: TRect; RL, RR: Integer; c1, c2: TColor);
procedure GradientGlass(const Canvas: TCanvas; const ARect: TRect;
            const Aqua:Boolean; const Direction: TGradDir);  Overload;
procedure GradientGlass(const Canvas: TCanvas; const ARect: TRect;
            const Aqua, Dark: Boolean; const Direction: TGradDir); Overload;
procedure GradientFillOld(const Canvas: TCanvas; const ARect: TRect;
  const StartColor, EndColor: TColor; const Direction: TGradDir);

// ---
{ LOW LEVEL }
function GradientFillWinEnabled: Boolean;
function GradientFillWin(DC: HDC; PVertex: Pointer; NumVertex: Cardinal;
  PMesh: Pointer; NumMesh, Mode: Cardinal): BOOL;
{ HIGH LEVEL }
procedure GradientFill(DC: HDC; const ARect: TRect;
  StartColor, EndColor: TColor; Direction: TGradDir); overload;
procedure GradientFill(Canvas: TCanvas; const ARect: TRect;
  StartColor, EndColor: TColor; Direction: TGradDir); overload;

{ Redeclare TRIVERTEX }
type
  {$EXTERNALSYM COLOR16}
  COLOR16 = Word; { in Delphi Windows.pas wrong declared as Shortint }

  PTriVertex = ^TTriVertex;
  {$EXTERNALSYM _TRIVERTEX}
  _TRIVERTEX = packed record
    x     : Longint;
    y     : Longint;
    Red   : COLOR16;
    Green : COLOR16;
    Blue  : COLOR16;
    Alpha : COLOR16;
  end;
  TTriVertex = _TRIVERTEX;
  {$EXTERNALSYM TRIVERTEX}
  TRIVERTEX = _TRIVERTEX;
// ---


implementation

// ---
type
  TGradientFillWin = function(DC: HDC; PVertex: Pointer; NumVertex: ULONG;
    Mesh: Pointer; NumMesh, Mode: ULONG): BOOL; stdcall;
  TGradientFill = procedure(DC: HDC; const ARect: TRect;
    StartColor, EndColor: TColor; Direction: TGradDir);
var
  InitDone        : Boolean = False;
  MSImg32Module   : THandle;
  GradFillWinProc : TGradientFillWin;
  GradFillProc    : TGradientFill;
// ----

procedure ButtonFrame(Canvas: TCanvas; R: TRect; RL, RR: Integer; c1, c2, c3:
  TColor);
var
  Color: TColor;
begin
  with Canvas, R do
  begin
    Color := Pen.Color;
    Pen.Color := c1;
    Dec(Right);
    Dec(Bottom);
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

    if c2 <> clNone then
    begin
      Pen.Color := c2;
      PolyLine([
        Point(Right, Top + RR),
          Point(Right, Bottom - RR),
          Point(Right - RR, Bottom),
          Point(Left + RL - 1, Bottom)
          ]);
    end;

    Pen.Color := c3;
    if RR > 0 then
    begin
      Inc(Right);
      MoveTo(Right - RR, Top);
      LineTo(Right, Top + RR);
      MoveTo(Right - RR, Bottom);
      LineTo(Right, Bottom - RR);
      Dec(Right);
    end;

    if RL > 0 then
    begin
      Dec(Left);
      MoveTo(Left + RL, Top);
      LineTo(Left, Top + RL);
      MoveTo(Left + RL, Bottom);
      LineTo(Left, Bottom - RL);
      Inc(Left);
    end;

    Inc(Right);
    Inc(Bottom);
    Pen.Color := Color;
  end;
end;

// From Alex aluminum theme
procedure RoundFrame(DC: HDC; R: TRect; TL, TR, BL, BR: Integer; Color: TColor); overload;
var
  Radius: Integer;
  CornerID: Integer;

  procedure PutPixel(X, Y: Integer; Alpha: Integer);
  begin
    with R do
      case CornerID of
        0: SetPixelEx(DC, Left + X,  Top + Y,    Color, Alpha);
        1: SetPixelEx(DC, Right - X, Top + Y,    Color, Alpha);
        2: SetPixelEx(DC, Left + X,  Bottom - Y, Color, Alpha);
        3: SetPixelEx(DC, Right - X, Bottom - Y, Color, Alpha);
      end;
  end;

begin
  if Color = clNone then Exit;
  with R do
  begin
    Dec(Right); Dec(Bottom);
    if Color < 0 then Color := GetSysColor(Color and $FF);

    { Edges }
    DrawLineEx(DC, Left, Bottom - BL, Left, Top + TL - 1, Color);
    DrawLineEx(DC, Left + TL, Top, Right - TR + 1, Top, Color);
    DrawLineEx(DC, Left + BL, Bottom, Right - BR + 1, Bottom, Color);
    DrawLineEx(DC, Right, Top + TR, Right, Bottom - BR + 1, Color);

    { Corners }
    for CornerID := 0 to 3 do
    begin
      case CornerID of
        0: Radius := TL;
        1: Radius := TR;
        2: Radius := BL;
      else
        Radius := BR;
      end;
      case Radius of
        1: begin PutPixel(0, 0, $3F); PutPixel(1, 1, $3F); end;
        2: begin PutPixel(0, 0, $1F); PutPixel(1, 0, $4F); PutPixel(0, 1, $4F); PutPixel(1, 1, $FF); end;
      end;
    end;
  end;
end;

procedure SmartFrame(Canvas: TCanvas; R: TRect; RL, RR: Integer; c1, c2: TColor);
var
  Color: TColor;
begin
  RoundFrame(Canvas.Handle, R, RL, RR, RL, RR, c1);
  {
  with Canvas, R do
  begin
    Color := Pen.Color;
    Pen.Color := c1;
    Dec(Right);
    Dec(Bottom);
    Pen.Color := c1;
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
    if c2 <> clNone then
    begin
      Pen.Color := c2;
      PolyLine([
        Point(Right, Top + RR),
          Point(Right, Bottom - RR),
          Point(Right - RR, Bottom),
          Point(Left + RL - 1, Bottom)
          ]);
    end;

    Pen.Color := Blend(Pixels[Left, Top], c1, 60);
    if RL > 0 then
    begin
      Dec(Left);
      MoveTo(Left + RL, Top);
      LineTo(Left, Top + RL);
      MoveTo(Left + RL, Bottom);
      LineTo(Left, Bottom - RL);
      Inc(Left);
    end;

    if c2 <> clNone then
      Pen.Color := Blend(Pixels[Right, Bottom], c2, 60);
    if RR > 0 then
    begin
      Inc(Right);
      MoveTo(Right - RR, Top);
      LineTo(Right, Top + RR);
      MoveTo(Right - RR, Bottom);
      LineTo(Right, Bottom - RR);
      Dec(Right);
    end;

    Inc(Right);
    Inc(Bottom);
    Pen.Color := Color;
  end;
  }
end;

procedure GradientGlass(const Canvas: TCanvas; const ARect: TRect;
  const Aqua, Dark: Boolean; const Direction: TGradDir);
var
  GSize: Integer;
  rc1, rc2, gc1, gc2, bc1, bc2, rc3, gc3, bc3, rc4, gc4, bc4,
    r, g, b, y1, Counter, i, d1, d2, d3: Integer;

  Brush: HBrush;
begin
  if Aqua then
  begin
    if Dark then
    begin
      rc1 := $e0; rc2 := $70; rc3 := $60; rc4 := $A0;
      gc1 := $e8; gc2 := $A0; gc3 := $D0; gc4 := $EF;
      bc1 := $EF; bc2 := $D0; bc3 := $E0; bc4 := $EF;
    end else
    begin
      //rc1 := $ff; rc2 := $b0; rc3 := $4; rc4 := $30;
      //gc1 := $ff; gc2 := $B0; gc3 := $4; gc4 := $40;
      //bc1 := $Ff; bc2 := $b0; bc3 := $4; bc4 := $b0;

      rc1 := $f0; rc2 := $80; rc3 := $70; rc4 := $B0;
      gc1 := $f8; gc2 := $B0; gc3 := $E8; gc4 := $FF;
      bc1 := $FF; bc2 := $E0; bc3 := $F0; bc4 := $FF;
    end;
  end else
  begin
    //rc1 := $ff; rc2 := $10; rc3 := $4; rc4 := $60;
    //gc1 := $ff; gc2 := $10; gc3 := $4; gc4 := $80;
    //bc1 := $Ff; bc2 := $20; bc3 := $4; bc4 := $c0;

    rc1 := $F8; rc2 := $d8; rc3 := $f0; rc4 := $F8;
    gc1 := $F8; gc2 := $d8; gc3 := $f0; gc4 := $F8;
    bc1 := $F8; bc2 := $d8; bc3 := $f0; bc4 := $F8;
  end;

  if Direction = tGTopBottom then
  begin
    GSize := (ARect.Bottom - ARect.Top) - 1;
    y1 := GSize div 3;
    if y1 = 0  then y1:= 1;
    d1 := y1;
    d2 := y1 + y1;
    for i := 0 to y1 do
    begin
      r := rc1 + (((rc2 - rc1) * (i)) div y1);
      g := gc1 + (((gc2 - gc1) * (i)) div y1);
      b := bc1 + (((bc2 - bc1) * (i)) div y1);
      if r < 0 then r := 0 else if r > 255 then r := 255;
      if g < 0 then g := 0 else if g > 255 then g := 255;
      if b < 0 then b := 0 else if b > 255 then b := 255;
      Brush := CreateSolidBrush(
        RGB(r, g, b));
      Windows.FillRect(Canvas.Handle, Rect(ARect.Left, ARect.Top + i, ARect.Right, ARect.Top + i + 1), Brush);
      DeleteObject(Brush);
    end;

    for i := y1 to d2 do
    begin
      r := rc2 + (((rc3 - rc2) * (i - d1)) div y1);
      g := gc2 + (((gc3 - gc2) * (i - d1)) div y1);
      b := bc2 + (((bc3 - bc2) * (i - d1)) div y1);
      if r < 0 then r := 0 else if r > 255 then r := 255;
      if g < 0 then g := 0 else if g > 255 then g := 255;
      if b < 0 then b := 0 else if b > 255 then b := 255;
      Brush := CreateSolidBrush(
        RGB(r, g, b));
      Windows.FillRect(Canvas.Handle, Rect(ARect.Left, ARect.Top + i, ARect.Right, ARect.Top + i + 1), Brush);
      DeleteObject(Brush);
    end;

    for i := d2 to GSize do
    begin
      r := rc3 + (((rc4 - rc3) * (i - d2)) div y1);
      g := gc3 + (((gc4 - gc3) * (i - d2)) div y1);
      b := bc3 + (((bc4 - bc3) * (i - d2)) div y1);
      if r < 0 then r := 0 else if r > 255 then r := 255;
      if g < 0 then g := 0 else if g > 255 then g := 255;
      if b < 0 then b := 0 else if b > 255 then b := 255;
      Brush := CreateSolidBrush(
        RGB(r, g, b));
      Windows.FillRect(Canvas.Handle, Rect(ARect.Left, ARect.Top + i, ARect.Right, ARect.Top + i + 1), Brush);
      DeleteObject(Brush);
    end;
  end else
  begin
    GSize := (ARect.Right - ARect.Left) - 1;
    y1 := GSize div 3;
    if y1 = 0  then y1:= 1;
    d1 := y1;
    d2 := y1 + y1;
    for i := 0 to y1 do
    begin
      r := rc1 + (((rc2 - rc1) * (i)) div y1);
      g := gc1 + (((gc2 - gc1) * (i)) div y1);
      b := bc1 + (((bc2 - bc1) * (i)) div y1);
      if r < 0 then r := 0 else if r > 255 then r := 255;
      if g < 0 then g := 0 else if g > 255 then g := 255;
      if b < 0 then b := 0 else if b > 255 then b := 255;
      Brush := CreateSolidBrush(
        RGB(r, g, b));
      Windows.FillRect(Canvas.Handle, Rect(ARect.Left + i, ARect.Top, ARect.Left + i + 1, ARect.Bottom), Brush);
      DeleteObject(Brush);
    end;
    for i := y1 to d2 do
    begin
      r := rc2 + (((rc3 - rc2) * (i - d1)) div y1);
      g := gc2 + (((gc3 - gc2) * (i - d1)) div y1);
      b := bc2 + (((bc3 - bc2) * (i - d1)) div y1);
      if r < 0 then r := 0 else if r > 255 then r := 255;
      if g < 0 then g := 0 else if g > 255 then g := 255;
      if b < 0 then b := 0 else if b > 255 then b := 255;
      Brush := CreateSolidBrush(
        RGB(r, g, b));
      Windows.FillRect(Canvas.Handle, Rect(ARect.Left + i, ARect.Top, ARect.Left + i + 1, ARect.Bottom), Brush);
      DeleteObject(Brush);
    end;
    for i := d2 to GSize do
    begin
      r := rc3 + (((rc4 - rc3) * (i - d2)) div y1);
      g := gc3 + (((gc4 - gc3) * (i - d2)) div y1);
      b := bc3 + (((bc4 - bc3) * (i - d2)) div y1);
      if r < 0 then r := 0 else if r > 255 then r := 255;
      if g < 0 then g := 0 else if g > 255 then g := 255;
      if b < 0 then b := 0 else if b > 255 then b := 255;
      Brush := CreateSolidBrush(
        RGB(r, g, b));
      Windows.FillRect(Canvas.Handle, Rect(ARect.Left + i, ARect.Top, ARect.Left + i + 1, ARect.Bottom), Brush);
      DeleteObject(Brush);
    end;
  end;
end;

procedure GradientGlass(const Canvas: TCanvas; const ARect: TRect;
  const Aqua: Boolean; const Direction: TGradDir);
begin
  GradientGlass(Canvas, Arect, Aqua, False, Direction);
end;

procedure GradientFillOld(const Canvas: TCanvas; const ARect: TRect;
  const StartColor, EndColor: TColor;
  const Direction: TGradDir);
var
  rc1, rc2, gc1, gc2, bc1, bc2, Counter, GSize: Integer;
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
    if GSize = 0  then GSize:= 1;
    for Counter := 0 to GSize do
    begin
      Brush := CreateSolidBrush(
        RGB(
          Byte(rc1 + (((rc2 - rc1) * (Counter)) div GSize)),
          Byte(gc1 + (((gc2 - gc1) * (Counter)) div GSize)),
          Byte(bc1 + (((bc2 - bc1) * (Counter)) div GSize)))
        );
      Windows.FillRect(Canvas.Handle, Rect(ARect.Left,
                                           ARect.Top,
                                           ARect.Right,
                                           ARect.Bottom - Counter), Brush);
      DeleteObject(Brush);
    end;
  end else
  begin
    GSize := (ARect.Right - ARect.Left) - 1;
    if GSize = 0  then GSize:= 1;
    for Counter := 0 to GSize do
    begin
      Brush := CreateSolidBrush(
        RGB(Byte(rc1 + (((rc2 - rc1) * (Counter)) div GSize)),
        Byte(gc1 + (((gc2 - gc1) * (Counter)) div GSize)),
        Byte(bc1 + (((bc2 - bc1) * (Counter)) div GSize))));
      Windows.FillRect(Canvas.Handle, Rect(ARect.Left, ARect.Top, ARect.Right - Counter, ARect.Bottom), Brush);
      DeleteObject(Brush);
    end;
  end;
end;


// Code belowe is from Vladimir Bochkarev

(******************************************************************************)
procedure
  InitializeGradientFill; forward;
(******************************************************************************)
{ GradientFillWin }
(******************************************************************************)
function GradFillWinInitProc(DC: HDC; PVertex: Pointer; NumVertex: ULONG;
  Mesh: Pointer; NumMesh, Mode: ULONG): BOOL; stdcall;
begin
  InitializeGradientFill;
  Result := GradFillWinProc(DC, PVertex, NumVertex, Mesh, NumMesh, Mode);
end;
(******************************************************************************)
function GradFillWinNone(DC: HDC; PVertex: Pointer; NumVertex: ULONG;
  Mesh: Pointer; NumMesh, Mode: ULONG): BOOL; stdcall;
begin
  Result := False;
end;
(******************************************************************************)
function GradientFillWin(DC: HDC; PVertex: Pointer; NumVertex: Cardinal;
  PMesh: Pointer; NumMesh, Mode: Cardinal): BOOL;
begin
  Result := GradFillWinProc(DC, PVertex, NumVertex, PMesh, NumMesh, Mode);
end;
(******************************************************************************)
function GradientFillWinEnabled: Boolean;
begin
  if not InitDone then InitializeGradientFill;
  Result := @GradFillWinProc <> @GradFillWinNone;
end;
(******************************************************************************)
{ GradientFill }
(******************************************************************************)
procedure GradFillInitProc(DC: HDC; const ARect: TRect;
  StartColor, EndColor: TColor; Direction: TGradDir);
begin
  InitializeGradientFill;
  GradFillProc(DC, ARect, StartColor, EndColor, Direction);
end;
(*****************************************************************************)
procedure GradFillInt(DC: HDC; const ARect: TRect;
  StartColor, EndColor: TColor; Direction: TGradDir);
var
  FillRect    : TRect;
  RS, GS, BS  : TColor;
  RE, GE, BE  : TColor;
  LineCount   : Integer;
  CurLine     : Integer;
  //----------------------------------------------------------------------------
  procedure InternalFillRect;
  var Brush: HBRUSH;
  begin
    Brush := CreateSolidBrush(
      RGB((RS+ (((RE- RS)* CurLine) div LineCount)),
          (GS+ (((GE- GS)* CurLine) div LineCount)),
          (BS+ (((BE- BS)* CurLine) div LineCount))));
    Windows.FillRect(DC, FillRect, Brush);
    DeleteObject(Brush);
  end;
  //----------------------------------------------------------------------------
begin
  FillRect := ARect;
  if StartColor < 0 then
    StartColor := Integer(GetSysColor(StartColor and $000000FF));
  if EndColor < 0 then
    EndColor := Integer(GetSysColor(EndColor and $000000FF));
  RS := GetRValue(Cardinal(StartColor));
  GS := GetGValue(Cardinal(StartColor));
  BS := GetBValue(Cardinal(StartColor));
  RE := GetRValue(Cardinal(EndColor));
  GE := GetGValue(Cardinal(EndColor));
  BE := GetBValue(Cardinal(EndColor));
  if Direction = tgLeftRight then
  begin
    FillRect.Right := FillRect.Left+ 1;
    LineCount := ARect.Right- ARect.Left;
    for CurLine := 1 to LineCount do
    begin
      InternalFillRect;
      Inc(FillRect.Left);
      Inc(FillRect.Right);
    end;
  end
  else begin
    FillRect.Bottom := FillRect.Top+ 1;
    LineCount := ARect.Bottom- ARect.Top;
    for CurLine := 1 to LineCount do
    begin
      InternalFillRect;
      Inc(FillRect.Top);
      Inc(FillRect.Bottom);
    end;
  end;
end;
(******************************************************************************)
procedure GradFillWin(DC: HDC; const ARect: TRect;
  StartColor, EndColor: TColor; Direction: TGradDir);
var
  Vertexs: array[0..1] of TTriVertex;
  //----------------------------------------------------------------------------
  procedure SetVertex(Index, AX, AY, AColor: TColor);
  begin
    with Vertexs[Index] do
    begin
      X     := AX;
      Y     := AY;
      Red   := (AColor and $000000FF) shl 8;
      Green := (AColor and $0000FF00);
      Blue  := (AColor and $00FF0000) shr 8;
      Alpha := 0;
    end;
  end;
  //----------------------------------------------------------------------------
var
  GRect : TGradientRect;
  Mode  : Cardinal;
begin
  if StartColor < 0 then
    StartColor := Integer(GetSysColor(StartColor and $000000FF));
  if EndColor < 0 then
    EndColor := Integer(GetSysColor(EndColor and $000000FF));
  SetVertex(0, ARect.Left, ARect.Top, StartColor);
  SetVertex(1, ARect.Right, ARect.Bottom, EndColor);
  with GRect do
  begin
    UpperLeft  := 0;
    LowerRight := 1;
  end;
  if Direction = tgLeftRight
    then Mode := GRADIENT_FILL_RECT_H
    else Mode := GRADIENT_FILL_RECT_V;
  GradientFillWin(DC, @Vertexs, 2, @GRect, 1, Mode);
end;
(******************************************************************************)

procedure GradientFill(DC: HDC; const ARect: TRect;
  StartColor, EndColor: TColor; Direction: TGradDir);
begin
  GradFillProc(DC, ARect, StartColor, EndColor, Direction);
end;

(******************************************************************************)
procedure GradientFill(Canvas: TCanvas; const ARect: TRect;
  StartColor, EndColor: TColor; Direction: TGradDir);
begin
  GradientFill(Canvas.Handle, ARect, EndColor, StartColor, Direction);
end;

{ Initializations }
(******************************************************************************)
procedure InitializeGradientFill;
begin
  if InitDone then Exit;
  MSImg32Module := LoadLibrary('msimg32.dll');
  if MSImg32Module <> 0
    then GradFillWinProc := GetProcAddress(MSImg32Module, 'GradientFill')
    else GradFillWinProc := nil;
  if @GradFillWinProc = nil then
  begin
    GradFillWinProc := GradFillWinNone;
    GradFillProc    := GradFillInt;
  end
  else GradFillProc := GradFillWin;
  InitDone := True;
end;
(******************************************************************************)
procedure UninitializeGradientFill;
begin
  if MSImg32Module <> 0 then FreeLibrary(MSImg32Module);
end;
(******************************************************************************)
initialization
  GradFillWinProc := GradFillWinInitProc;
  GradFillProc    := GradFillInitProc;
finalization
  UninitializeGradientFill;
(******************************************************************************)
end.
