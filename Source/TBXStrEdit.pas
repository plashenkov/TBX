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

unit TBXStrEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Dialogs, StdCtrls;

type
  TStrEditDlg = class(TForm)
    Memo: TMemo;
    OK: TButton;
    Cancel: TButton;
    procedure MemoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  protected
    procedure ArrangeControls;
    procedure DoShow; override;
    procedure Resize; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

procedure TStrEditDlg.ArrangeControls;
var
  R, B: TRect;
  W, H: Integer;
begin
  R := ClientRect;
  InflateRect(R, -6, -6);
  B := R;
  W := 70; H := 23;
  B.Left := B.Right - W;
  B.Top := B.Bottom - H;
  Cancel.BoundsRect := B;
  B.Right := B.Left - 4;
  B.Left := B.Right - W;
  OK.BoundsRect := B;
  Dec(R.Bottom, H + 8);
  Memo.BoundsRect := R;
end;

constructor TStrEditDlg.Create(AOwner: TComponent);
begin
  inherited CreateNew(AOwner);
  AutoScroll := False;
  Constraints.MinHeight := 200;
  Constraints.MinWidth := 300;
  Scaled := False;
  Position := poScreenCenter;
  Memo := TMemo.Create(Self);
  with Memo do
  begin
    ScrollBars := ssBoth;
    OnKeyDown := MemoKeyDown;
    Parent := Self;
  end;
  OK := TButton.Create(Self);
  with OK do
  begin
    Caption := 'OK';
    Default := True;
    ModalResult := mrOk;
    Parent := Self;
  end;
  Cancel := TButton.Create(Self);
  with Cancel do
  begin
    Cancel := True;
    Caption := 'Cancel';
    ModalResult := mrCancel;
    Parent := Self;
  end;
end;

procedure TStrEditDlg.DoShow;
begin
  Memo.SelStart := Length(Memo.Text) - 1;
end;

procedure TStrEditDlg.MemoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then Cancel.Click;
end;

procedure TStrEditDlg.Resize;
begin
  inherited;
  ArrangeControls;
end;

end.
