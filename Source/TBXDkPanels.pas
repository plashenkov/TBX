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

unit TBXDkPanels;

interface

{$I TB2Ver.inc}
{$I TBX.inc}

uses
  Windows, Messages, Classes, Graphics, Controls, StdCtrls, ExtCtrls, Forms,
  ImgList, Menus, {$IFDEF JR_D17} UITypes,{$ENDIF}
  TB2Dock, TB2Item, TBX, TBXThemes;

const
  { New hit test constants for page scrollers }
  HTSCROLLPREV = 30;
  HTSCROLLNEXT = 31;

type
  { TTBXControlMargins }

  TTBXControlMargins = class(TPersistent)
  private
    FLeft, FTop, FRight, FBottom: Integer;
    FOnChange: TNotifyEvent;
    procedure SetBottom(Value: Integer);
    procedure SetLeft(Value: Integer);
    procedure SetRight(Value: Integer);
    procedure SetTop(Value: Integer);
  public
    procedure Assign(Src: TPersistent); override;
    procedure Modified; dynamic;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  published
    property Left: Integer read FLeft write SetLeft default 0;
    property Top: Integer read FTop write SetTop default 0;
    property Right: Integer read FRight write SetRight default 0;
    property Bottom: Integer read FBottom write SetBottom default 0;
  end;

  { TTBXMultiDock }

  TTBXMultiDock = class(TTBDock)
  protected
    LastValidRowSize: Integer;
    function  Accepts(ADockableWindow: TTBCustomDockableWindow): Boolean; override;
    procedure ValidateInsert(AComponent: TComponent); override;
  public
    procedure ArrangeToolbars; override;
    procedure Paint; override;
    procedure ResizeVisiblePanels(NewSize: Integer);
    {$IFDEF JR_D9}
    property OnMouseActivate;
    {$ENDIF}
  end;


  { TTBXCustomDockablePanel }

  TDPCaptionRotation = (dpcrAuto, dpcrAlwaysHorz, dpcrAlwaysVert);
  TTBXResizingStage = (rsBeginResizing, rsResizing, rsEndResizing);
  TTBXDockedResizing = procedure(Sender: TObject; Vertical: Boolean;
    var NewSize: Integer; Stage: TTBXResizingStage; var AllowResize: Boolean) of object;
  TDockKinds = set of (dkStandardDock, dkMultiDock);

  TTBXCustomDockablePanel = class(TTBCustomDockableWindow)
  private
    FBorderSize: Integer;
    FCaptionRotation: TDPCaptionRotation;
    FDockedWidth: Integer;
    FDockedHeight: Integer;
    FEffectiveColor: TColor;
    FFloatingWidth: Integer;
    FFloatingHeight: Integer;
    FHorzResizeCursor: TCursor;
    FHorzSplitCursor : TCursor;
    FIsResizing: Boolean;
    FIsSplitting: Boolean;
    FMinClientWidth: Integer;
    FMinClientHeight: Integer;
    FMaxClientWidth: Integer;
    FMaxClientHeight: Integer;
    FSmoothDockedResize: Boolean;
    FSnapDistance: Integer;
    FShowCaptionWhenDocked: Boolean;
    FSplitHeight: Integer;
    FSplitWidth: Integer;
    FSupportedDocks: TDockKinds;
    FVertResizeCursor: TCursor;
    FVertSplitCursor : TCursor;
    FOnDockedResizing: TTBXDockedResizing;
    function  CalcSize(ADock: TTBDock): TPoint;
    procedure SetBorderSize(Value: Integer);
    procedure SetCaptionRotation(Value: TDPCaptionRotation);
    procedure SetDockedHeight(Value: Integer);
    procedure SetDockedWidth(Value: Integer);
    procedure SetFloatingHeight(Value: Integer);
    procedure SetFloatingWidth(Value: Integer);
    procedure SetMinClientHeight(Value: Integer);
    procedure SetMinClientWidth(Value: Integer);
    procedure SetShowCaptionWhenDocked(Value: Boolean);
    procedure SetSnapDistance(Value: Integer);
    procedure CMColorChanged(var Message: TMessage); message CM_COLORCHANGED;
    procedure CMControlChange(var Message: TCMControlChange); message CM_CONTROLCHANGE;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure TBMGetEffectiveColor(var Message: TMessage); message TBM_GETEFFECTIVECOLOR;
    procedure TBMGetViewType(var Message: TMessage); message TBM_GETVIEWTYPE;
    procedure TBMThemeChange(var Message: TMessage); message TBM_THEMECHANGE;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
    procedure WMNCCalcSize(var Message: TWMNCCalcSize); message WM_NCCALCSIZE;
    procedure WMNCLButtonDown(var Message: TWMNCLButtonDown); message WM_NCLBUTTONDOWN;
    procedure WMSetCursor(var Message: TWMSetCursor); message WM_SETCURSOR;
    procedure WMWindowPosChanged(var Message: TWMWindowPosChanged); message WM_WINDOWPOSCHANGED;
    procedure SetSplitHeight(Value: Integer);
    procedure SetSplitWidth(Value: Integer);
  protected
    BlockSizeUpdate: Boolean;
    procedure AdjustClientRect(var Rect: TRect); override;
    procedure BeginDockedSizing(HitTest: Integer);
    procedure BeginSplitResizing(HitTest: Integer);
    function  CalcNCSizes: TPoint; override;
    function  CanAutoSize(var NewWidth, NewHeight: Integer): Boolean; override;
    function  CanDockTo(ADock: TTBDock): Boolean; override;
    function  CanSplitResize(EdgePosition: TTBDockPosition): Boolean;
    procedure ConstrainedResize(var MinWidth, MinHeight, MaxWidth, MaxHeight: Integer); override;
    function  DoArrange(CanMoveControls: Boolean; PreviousDockType: TTBDockType; NewFloating: Boolean; NewDock: TTBDock): TPoint; override;
    function  DoBeginDockedResizing(Vertical: Boolean): Boolean; virtual;
    function  DoDockedResizing(Vertical: Boolean; var NewSize: Integer): Boolean; virtual;
    function  DoEndDockedResizing(Vertical: Boolean): Boolean; virtual;
    procedure DrawNCArea(const DrawToDC: Boolean; const ADC: HDC; const Clip: HRGN); override;
    procedure GetBaseSize(var ASize: TPoint); override;
    function  GetDockedCloseButtonRect(LeftRight: Boolean): TRect; override;
    procedure GetDockPanelInfo(out DockPanelInfo: TTBXDockPanelInfo); virtual;
    function  GetFloatingWindowParentClass: TTBFloatingWindowParentClass; override;
    procedure GetMinMaxSize(var AMinClientWidth, AMinClientHeight, AMaxClientWidth, AMaxClientHeight: Integer); override;
    function  GetViewType: Integer;
    function  IsVertCaption: Boolean; virtual;
    procedure Loaded; override;
    procedure Paint; override;
    procedure SetParent(AParent: TWinControl); override;
    procedure SizeChanging(const AWidth, AHeight: Integer); override;
    procedure UpdateEffectiveColor;
    property  IsResizing: Boolean read FIsResizing;
    property  IsSplitting: Boolean read FIsSplitting;
    property CaptionRotation: TDPCaptionRotation read FCaptionRotation write SetCaptionRotation default dpcrAuto;
    property Color default clNone;
    property CloseButtonWhenDocked default True;
    property DblClickUndock default False;
    property BorderSize: Integer read FBorderSize write SetBorderSize default 0;
    property DockedWidth: Integer read FDockedWidth write SetDockedWidth default 128;
    property DockedHeight: Integer read FDockedHeight write SetDockedHeight default 128;
    property FloatingWidth: Integer read FFloatingWidth write SetFloatingWidth default 0;
    property FloatingHeight: Integer read FFloatingHeight write SetFloatingHeight default 0;
    property Height stored False;
    property HorzResizeCursor: TCursor read FHorzResizeCursor write FHorzResizeCursor default crSizeWE;
    property HorzSplitCursor: TCursor read FHorzSplitCursor write FHorzSplitCursor default crHSplit;
    { note: client size constraints should be restored before other size related properties }
    property MaxClientHeight: Integer read FMaxClientHeight write FMaxClientHeight default 0;
    property MaxClientWidth: Integer read FMaxClientWidth write FMaxClientWidth default 0;
    property MinClientHeight: Integer read FMinClientHeight write SetMinClientHeight default 32;
    property MinClientWidth: Integer read FMinClientWidth write SetMinClientWidth default 32;
    property ShowCaptionWhenDocked: Boolean read FShowCaptionWhenDocked write SetShowCaptionWhenDocked default True;
    property SplitHeight: Integer read FSplitHeight write SetSplitHeight default 0;
    property SplitWidth: Integer read FSplitWidth write SetSplitWidth default 0;
    property SupportedDocks: TDockKinds read FSupportedDocks write FSupportedDocks;
    property SmoothDockedResize: Boolean read FSmoothDockedResize write FSmoothDockedResize default True;
    property SnapDistance: Integer read FSnapDistance write SetSnapDistance default 0;
    property VertResizeCursor: TCursor read FVertResizeCursor write FVertResizeCursor default crSizeNS;
    property VertSplitCursor: TCursor read FVertSplitCursor write FVertSplitCursor default crVSplit;
    property Width stored False;
    property OnDockedResizing: TTBXDockedResizing read FOnDockedResizing write FOnDockedResizing;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function  GetFloatingBorderSize: TPoint; override;
    procedure ReadPositionData(const Data: TTBReadPositionData); override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure UpdateChildColors;
    procedure WritePositionData(const Data: TTBWritePositionData); override;
    property EffectiveColor: TColor read FEffectiveColor;
  end;

  { TTBXDockablePanel }

  TTBXDockablePanel = class(TTBXCustomDockablePanel)
  published
    { client size constraints should be restored before other size related properties }
    property MaxClientHeight;
    property MaxClientWidth;
    property MinClientHeight;
    property MinClientWidth;

    property ActivateParent;
    property Align;
    property Anchors;
    property BorderSize;
    property BorderStyle;
    property Caption;
    property CaptionRotation;
    property Color;
    property CloseButton;
    property CloseButtonWhenDocked;
    property CurrentDock;
    property DblClickUndock;
    property DefaultDock;
    property DockableTo;
    property DockedWidth;
    property DockedHeight;
    property DockMode;
    property DockPos;
    property DockRow;
    property FloatingWidth;
    property FloatingHeight;
    property FloatingMode;
    property Font;
    property Height;
    property HideWhenInactive;
    property HorzResizeCursor;
    property HorzSplitCursor;
    property LastDock;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property Resizable;
    property ShowCaption;
    property ShowCaptionWhenDocked;
    property ShowHint;
    property SplitHeight;
    property SplitWidth;
    property SupportedDocks;
    property SmoothDrag;
    property SmoothDockedResize;
    property SnapDistance;
    property TabOrder;
    property UseLastDock;
    property VertResizeCursor;
    property VertSplitCursor;
    property Visible;
    property Width;

    property OnClose;
    property OnCloseQuery;
    {$IFDEF JR_D5}
    property OnContextPopup;
    {$ENDIF}
    property OnDragDrop;
    property OnDragOver;
    property OnDockChanged;
    property OnDockChanging;
    property OnDockChangingHidden;
    property OnDockedResizing;
    {$IFDEF JR_D9}
    property OnMouseActivate;
    {$ENDIF}
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMove;
    property OnRecreated;
    property OnRecreating;
    property OnResize;
    property OnVisibleChanged;
  end;

  { TTBXPanelObject }

  TControlPaintOptions = set of (cpoDoubleBuffered);

  TTBXPanelObject = class(TCustomControl)
  private
    FDisableScroll: Boolean;
    FMouseInControl: Boolean;
    FPaintOptions: TControlPaintOptions;
    FPushed: Boolean;
    FSmartFocus: Boolean;
    FSpaceAsClick: Boolean;
    FOnMouseEnter: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;
    procedure CMParentColorChanged(var Message: TMessage); message CM_PARENTCOLORCHANGED;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure MouseTimerHandler(Sender: TObject);
    procedure RemoveMouseTimer;
    procedure SetPaintOptions(Value: TControlPaintOptions);
    procedure TBMThemeChange(var Message: TMessage); message TBM_THEMECHANGE;
    procedure WMEraseBkgnd(var Message: TMessage); message WM_ERASEBKGND;
    procedure WMKillFocus(var Message: TMessage); message WM_KILLFOCUS;
    procedure WMSetFocus(var Message: TMessage); message WM_SETFOCUS;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure DoMouseEnter; virtual;
    procedure DoMouseLeave; virtual;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    function  GetMinHeight: Integer; virtual;
    function  GetMinWidth: Integer; virtual;
    property Color default clNone;
    property MouseInControl: Boolean read FMouseInControl;
    property PaintOptions: TControlPaintOptions read FPaintOptions write SetPaintOptions;
    property ParentColor default False;
    property Pushed: Boolean read FPushed;
    property SpaceAsClick: Boolean read FSpaceAsClick write FSpaceAsClick default False;
    property SmartFocus: Boolean read FSmartFocus write FSmartFocus default False;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure MakeVisible;
    procedure MouseEntered;
    procedure MouseLeft;
  end;

  { TTBXAlignmentPanel }

  TTBXAlignmentPanel = class(TTBXPanelObject)
  private
    FMargins: TTBXControlMargins;
    procedure MarginsChangeHandler(Sender: TObject);
    procedure SetMargins(Value: TTBXControlMargins);
  protected
    procedure AdjustClientRect(var Rect: TRect); override;
    procedure Paint; override;
    function  GetMinHeight: Integer; override;
    function  GetMinWidth: Integer; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property ParentColor;
    property Align;
    property Anchors;
    property AutoSize;
    property Color;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property Margins: TTBXControlMargins read FMargins write SetMargins;
    property ParentFont;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
{$IFDEF JR_D5}
    property OnContextPopup;
{$ENDIF}
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
{$IFDEF JR_D9}
    property OnMouseActivate;
{$ENDIF}
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  { TTBXTextObject }

  TTBXTextObject = class(TTBXPanelObject)
  private
    FAlignment: TLeftRight;
    FMargins: TTBXControlMargins;
    FWrapping: TTextWrapping;
    FShowAccelChar: Boolean;
    FUpdating: Boolean;
    FShowFocusRect: Boolean;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure MarginsChangeHandler(Sender: TObject);
    procedure SetAlignment(Value: TLeftRight);
    procedure SetMargins(Value: TTBXControlMargins);
    procedure SetShowAccelChar(Value: Boolean);
    procedure SetShowFocusRect(const Value: Boolean);
    procedure SetWrapping(Value: TTextWrapping);
  protected
    procedure AdjustFont(AFont: TFont); virtual;
    procedure AdjustHeight;
    procedure CreateParams(var Params: TCreateParams); override;
    function  CanAutoSize(var NewWidth, NewHeight: Integer): Boolean; override;
    procedure DoAdjustHeight(ACanvas: TCanvas; var NewHeight: Integer); virtual;
    function  DoDrawText(ACanvas: TCanvas; var Rect: TRect; Flags: Longint): Integer; virtual;
    procedure DoMarginsChanged; virtual;
    function  GetFocusRect(const R: TRect): TRect; virtual;
    function  GetLabelText: string; virtual;
    function  GetTextAlignment: TAlignment; virtual;
    function  GetTextMargins: TRect; virtual;
    procedure Loaded; override;
    procedure Paint; override;
    property Alignment: TLeftRight read FAlignment write SetAlignment default taLeftJustify;
    property AutoSize default True;
    property PaintOptions default [cpoDoubleBuffered];
    property ShowAccelChar: Boolean read FShowAccelChar write SetShowAccelChar default True;
    property ShowFocusRect: Boolean read FShowFocusRect write SetShowFocusRect default True;
    property Margins: TTBXControlMargins read FMargins write SetMargins;
    property Wrapping: TTextWrapping read FWrapping write SetWrapping default twNone;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function  GetControlsAlignment: TAlignment; override;
  end;

  { TTBXCustomLabel }

  TTBXCustomLabel = class(TTBXTextObject)
  private
    FFocusControl: TWinControl;
    FUnderline: Boolean;
    FUnderlineColor: TColor;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure SetUnderline(Value: Boolean);
    procedure SetUnderlineColor(Value: TColor);
    procedure SetFocusControl(Value: TWinControl);
  protected
    function  GetTextMargins: TRect; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Paint; override;
    property FocusControl: TWinControl read FFocusControl write SetFocusControl;
    property Underline: Boolean read FUnderline write SetUnderline default False;
    property UnderlineColor: TColor read FUnderlineColor write SetUnderlineColor default clBtnShadow;
    property Wrapping default twWrap;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  { TTBXLabel }

  TTBXLabel = class(TTBXCustomLabel)
  published
    property Action;
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BiDiMode;
    property Caption;
    property Color;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FocusControl;
    property Font;
    property Margins;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowAccelChar;
    property ShowFocusRect;
    property ShowHint;
    property Underline;
    property UnderlineColor;
    property Visible;
    property Wrapping;
    property OnClick;
{$IFDEF JR_D5}
    property OnContextPopup;
{$ENDIF}
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
{$IFDEF JR_D9}
    property OnMouseActivate;
{$ENDIF}
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  { TTBXCustomLink }

  TTBXCustomLink = class(TTBXTextObject)
  private
    FImageChangeLink: TChangeLink;
    FImageIndex: TImageIndex;
    FImages: TCustomImageList;
    procedure ImageListChange(Sender: TObject);
    procedure SetImageIndex(Value: TImageIndex);
    procedure SetImages(Value: TCustomImageList);
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
  protected
    procedure AdjustFont(AFont: TFont); override;
    procedure DoAdjustHeight(ACanvas: TCanvas; var NewHeight: Integer); override;
    procedure DoMouseEnter; override;
    procedure DoMouseLeave; override;
    function  GetFocusRect(const R: TRect): TRect; override;
    function  GetTextAlignment: TAlignment; override;
    function  GetTextMargins: TRect; override;
    procedure Paint; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    property Cursor default crHandPoint;
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex default 0;
    property Images: TCustomImageList read FImages write SetImages;
    property SmartFocus default True;
    property TabStop default True;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function  GetControlsAlignment: TAlignment; override;
  end;

  { TTBXLink }

  TTBXLink = class(TTBXCustomLink)
  published
    property Action;
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BiDiMode;
    property Caption;
    property Color;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ImageIndex;
    property Images;
    property Margins;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowAccelChar;
    property ShowFocusRect;
    property ShowHint;
    property SmartFocus;
    property TabOrder;
    property TabStop;
    property Visible;
    property Wrapping;
    property OnClick;
{$IFDEF JR_D5}
    property OnContextPopup;
{$ENDIF}
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
{$IFDEF JR_D9}
    property OnMouseActivate;
{$ENDIF}
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  { TTBXCustomButton }
  TTBXCustomButton = class;
  TButtonLayout = (blGlyphLeft, blGlyphTop, blGlyphRight, blGlyphBottom);
  TButtonStyle = (bsNormal, bsFlat);
  TDropDownEvent = procedure(Sender: TTBXCustomButton; var AllowDropDown: Boolean) of object;

  TTBXCustomButton = class(TTBXTextObject)
  private
    FAlignment: TAlignment;
    FAllowAllUnchecked: Boolean;
    FBorderSize: Integer;
    FChecked: Boolean;
    FDropDownCombo: Boolean;
    FDropDownMenu: TPopupMenu;
    FButtonStyle: TButtonStyle;
    FGlyphSpacing: Integer;
    FGroupIndex: Integer;
    FImageChangeLink: TChangeLink;
    FImageIndex: TImageIndex;
    FImages: TCustomImageList;
    FInClick: Boolean;
    FLayout: TButtonLayout;
    FMenuVisible: Boolean;
    FModalResult: TModalResult;
    FRepeating: Boolean;
    FRepeatDelay: Integer;
    FRepeatInterval: Integer;
    FRepeatTimer: TTimer;
    FOnDropDown: TDropDownEvent;
    procedure ImageListChange(Sender: TObject);
    procedure RepeatTimerHandler(Sender: TObject);
    procedure SetAlignment(Value: TAlignment);
    procedure SetAllowAllUnchecked(Value: Boolean);
    procedure SetBorderSize(Value: Integer);
    procedure SetButtonStyle(Value: TButtonStyle);
    procedure SetChecked(Value: Boolean);
    procedure SetDropDownCombo(Value: Boolean);
    procedure SetDropDownMenu(Value: TPopupMenu);
    procedure SetGlyphSpacing(Value: Integer);
    procedure SetGroupIndex(Value: Integer);
    procedure SetImageIndex(Value: TImageIndex);
    procedure SetImages(Value: TCustomImageList);
    procedure SetLayout(Value: TButtonLayout);
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;
    procedure WMCancelMode(var Message: TWMCancelMode); message WM_CANCELMODE;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
  protected
    function  ArrowVisible: Boolean;
    procedure DoAdjustHeight(ACanvas: TCanvas; var NewHeight: Integer); override;
    function  DoDrawText(ACanvas: TCanvas; var Rect: TRect; Flags: Longint): Integer; override;
    function  DoDropDown: Boolean; virtual;
    procedure DoMouseEnter; override;
    procedure DoMouseLeave; override;
    function  GetFocusRect(const R: TRect): TRect; override;
    procedure GetItemInfo(out ItemInfo: TTBXItemInfo); virtual;
    function  GetTextAlignment: TAlignment; override;
    function  GetTextMargins: TRect; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
    function  PtInButtonPart(const Pt: TPoint): Boolean; virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure UpdateCheckedState;
    property Alignment: TAlignment read FAlignment write SetAlignment default taCenter;
    property AllowAllUnchecked: Boolean read FAllowAllUnchecked write SetAllowAllUnchecked default False;
    property BorderSize: Integer read FBorderSize write SetBorderSize default 4;
    property ButtonStyle: TButtonStyle read FButtonStyle write SetButtonStyle default bsNormal;
    property Checked: Boolean read FChecked write SetChecked default False;
    property DropDownCombo: Boolean read FDropDownCombo write SetDropDownCombo default False;
    property DropDownMenu: TPopupMenu read FDropDownMenu write SetDropDownMenu;
    property GlyphSpacing: Integer read FGlyphSpacing write SetGlyphSpacing default 4;
    property GroupIndex: Integer read FGroupIndex write SetGroupIndex default 0;
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex default 0;
    property Images: TCustomImageList read FImages write SetImages;
    property Layout: TButtonLayout read FLayout write SetLayout default blGlyphLeft;
    property ModalResult: TModalResult read FModalResult write FModalResult default 0;
    property Repeating: Boolean read FRepeating write FRepeating default False;
    property RepeatDelay: Integer read FRepeatDelay write FRepeatDelay default 400;
    property RepeatInterval: Integer read FRepeatInterval write FRepeatInterval default 100;
    property SmartFocus default True;
    property TabStop default True;
    property OnDropDown: TDropDownEvent read FOnDropDown write FOnDropDown;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Click; override;
    function  GetControlsAlignment: TAlignment; override;
  end;

  { TTBXButton }
  TTBXButton = class(TTBXCustomButton)
  published
    property Action;
    property Align;
    property Alignment;
    property GroupIndex;
    property AllowAllUnchecked;
    property Anchors;
    property AutoSize;
    property BiDiMode;
    property BorderSize;
    property ButtonStyle;
    property Caption;
    property Checked;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DropDownCombo;
    property DropDownMenu;
    property Enabled;
    property Font;
    property GlyphSpacing;
    property ImageIndex;
    property Images;
    property Layout;
    property Margins;
    property ModalResult;
    property ParentBiDiMode;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property Repeating;
    property RepeatDelay;
    property RepeatInterval;
    property ShowAccelChar;
    property ShowFocusRect;
    property ShowHint;
    property SmartFocus;
    property TabOrder;
    property TabStop;
    property Visible;
    property Wrapping;
    property OnClick;
{$IFDEF JR_D5}
    property OnContextPopup;
{$ENDIF}
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDropDown;
    property OnEndDock;
    property OnEndDrag;
{$IFDEF JR_D9}
    property OnMouseActivate;
{$ENDIF}
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  { TTBXCustomCheckBox }

  TTBXCustomCheckBox = class(TTBXTextObject)
  private
    FAllowGrayed: Boolean;
    FState: TCheckBoxState;
    FOnChange: TNotifyEvent;
    function GetChecked: Boolean;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;
    procedure CNCommand(var Message: TWMCommand); message CN_COMMAND;
    procedure SetChecked(Value: Boolean);
    procedure SetState(Value: TCheckBoxState);
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
  protected
    procedure Click; override;
    procedure DoAdjustHeight(ACanvas: TCanvas; var NewHeight: Integer); override;
    procedure DoChange; virtual;
    procedure DoMouseEnter; override;
    procedure DoMouseLeave; override;
    function  DoSetState(var NewState: TCheckBoxState): Boolean; virtual;
    function  GetGlyphSize: Integer;
    function  GetFocusRect(const R: TRect): TRect; override;
    function  GetTextAlignment: TAlignment; override;
    function  GetTextMargins: TRect; override;
    procedure Paint; override;
    procedure Toggle; virtual;
    property AllowGrayed: Boolean read FAllowGrayed write FAllowGrayed default False;
    property Checked: Boolean read GetChecked write SetChecked stored False;
    property SmartFocus default True;
    property State: TCheckBoxState read FState write SetState default cbUnchecked;
    property TabStop default True;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TTBXCheckBox = class(TTBXCustomCheckBox)
  published
    property Action;
    property Align;
    property Alignment;
    property AllowGrayed;
    property Anchors;
    property AutoSize;
    property BiDiMode;
    property Caption;
    property Checked;
    property Color;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property Margins;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowAccelChar;
    property ShowFocusRect;
    property ShowHint;
    property SmartFocus;
    property State;
    property TabOrder;
    property TabStop;
    property Visible;
    property Wrapping;
    property OnChange;
    property OnClick;
{$IFDEF JR_D5}
    property OnContextPopup;
{$ENDIF}
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
{$IFDEF JR_D9}
    property OnMouseActivate;
{$ENDIF}
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  { TTBXCustomRadioButton }

  TTBXCustomRadioButton = class(TTBXTextObject)
  private
    FChecked: Boolean;
    FGroupIndex: Integer;
    FOnChange: TNotifyEvent;
    procedure SetChecked(Value: Boolean);
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CNCommand(var Message: TWMCommand); message CN_COMMAND;
    procedure SetGroupIndex(Value: Integer);
    procedure TurnSiblingsOff;
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
  protected
    procedure Click; override;
    procedure DoAdjustHeight(ACanvas: TCanvas; var NewHeight: Integer); override;
    procedure DoChange; virtual;
    procedure DoMouseEnter; override;
    procedure DoMouseLeave; override;
    function  DoSetChecked(var Value: Boolean): Boolean; virtual;
    function  GetGlyphSize: Integer;
    function  GetFocusRect(const R: TRect): TRect; override;
    function  GetTextAlignment: TAlignment; override;
    function  GetTextMargins: TRect; override;
    procedure Paint; override;
    property Checked: Boolean read FChecked write SetChecked default False;
    property GroupIndex: Integer read FGroupIndex write SetGroupIndex default 0;
    property SmartFocus default True;
    property TabStop default True;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TTBXRadioButton = class(TTBXCustomRadioButton)
  published
    property Action;
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BiDiMode;
    property Caption;
    property Checked;
    property Color;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property GroupIndex;
    property Margins;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowAccelChar;
    property ShowFocusRect;
    property ShowHint;
    property SmartFocus;
    property TabOrder;
    property TabStop;
    property Visible;
    property Wrapping;
    property OnChange;
    property OnClick;
{$IFDEF JR_D5}
    property OnContextPopup;
{$ENDIF}
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
{$IFDEF JR_D9}
    property OnMouseActivate;
{$ENDIF}
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  { TTBXPageScroller }

  TTBXPageScrollerOrientation = (tpsoVertical, tpsoHorizontal);
  TTBXPageScrollerButtons = set of (tpsbPrev, tpsbNext);

  TTBXCustomPageScroller = class(TWinControl)
  private
    FAutoRangeCount: Integer;
    FAutoRange: Boolean;
    FAutoScroll: Boolean;
    FButtonSize: Integer;
    FMargin: Integer;
    FOrientation: TTBXPageScrollerOrientation;
    FPosition: Integer;
    FPosRange: Integer;
    FRange: Integer;
    FScrollDirection: Integer;
    FScrollCounter: Integer;
    FScrollPending: Boolean;
    FScrollTimer: TTimer;
    FUpdatingButtons: Boolean;
    FVisibleButtons: TTBXPageScrollerButtons;
    procedure CalcAutoRange;
    function  IsRangeStored: Boolean;
    procedure ScrollTimerTimer(Sender: TObject);
    procedure SetButtonSize(Value: Integer);
    procedure SetAutoRange(Value: Boolean);
    procedure SetOrientation(Value: TTBXPageScrollerOrientation);
    procedure SetPosition(Value: Integer);
    procedure SetRange(Value: Integer);
    procedure StopScrolling;
    procedure ValidatePosition(var NewPos: Integer);
    procedure CMParentColorChanged(var Message: TMessage); message CM_PARENTCOLORCHANGED;
    procedure WMMouseMove(var Message: TWMMouseMove); message WM_MOUSEMOVE;
    procedure WMNCCalcSize(var Message: TWMNCCalcSize); message WM_NCCALCSIZE;
    procedure WMEraseBkgnd(var Message: TWmEraseBkgnd); message WM_ERASEBKGND;
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
    procedure WMNCLButtonDown(var Message: TWMNCLButtonDown); message WM_NCLBUTTONDOWN;
    procedure WMNCMouseLeave(var Message: TMessage); message $2A2 {WM_NCMOUSELEAVE};
    procedure WMNCMouseMove(var Message: TWMNCMouseMove); message WM_NCMOUSEMOVE;
    procedure WMNCPaint(var Message: TMessage); message WM_NCPAINT;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
  protected
    procedure AdjustClientRect(var Rect: TRect); override;
    procedure AlignControls(AControl: TControl; var ARect: TRect); override;
    function  AutoScrollEnabled: Boolean; virtual;
    procedure BeginScrolling(HitTest: Integer);
    function  CalcClientArea: TRect;
    function  CanAutoSize(var NewWidth, NewHeight: Integer): Boolean; override;
    procedure ConstrainedResize(var MinWidth, MinHeight, MaxWidth, MaxHeight: Integer); override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure DoSetRange(Value: Integer); virtual;
    procedure DrawNCArea(const DrawToDC: Boolean; const ADC: HDC; const Clip: HRGN); virtual;
    procedure HandleScrollTimer; virtual;
    procedure Loaded; override;
    procedure RecalcNCArea;
    procedure Resizing; virtual;
    procedure UpdateButtons;
    property AutoScroll: Boolean read FAutoScroll write FAutoScroll default True;
    property ButtonSize: Integer read FButtonSize write SetButtonSize default 10;
    property DoubleBuffered default True;
    property Orientation: TTBXPageScrollerOrientation read FOrientation write SetOrientation default tpsoVertical;
    property Position: Integer read FPosition write SetPosition default 0;
    property Margin: Integer read FMargin write FMargin default 0;
    property Range: Integer read FRange write SetRange stored IsRangeStored;
  public
    constructor Create(AOwner: TComponent); override;
    procedure DisableAutoRange;
    procedure EnableAutoRange;
    procedure ScrollToCenter(ARect: TRect); overload;
    procedure ScrollToCenter(AControl: TControl); overload;
    property AutoRange: Boolean read FAutoRange write SetAutoRange default False;
  end;

  TTBXPageScroller = class(TTBXCustomPageScroller)
  public
    property Position;
  published
    property Align;
    property Anchors;
    property AutoRange;
    property AutoScroll;
    property ButtonSize;
    property Color;
    property Constraints;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DoubleBuffered;
    property Enabled;
    property Ctl3D;
    property Font;
    property Margin;
    property Orientation;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property Range;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnCanResize;
    property OnClick;
    property OnConstrainedResize;
{$IFDEF JR_D5}
    property OnContextPopup;
{$ENDIF}
    property OnDblClick;
    property OnDockDrop;
    property OnDockOver;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
{$IFDEF JR_D9}
    property OnMouseActivate;
{$ENDIF}
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

implementation

uses
  TB2Common, TBXConsts, TBXUtils, SysUtils {$IFDEF JR_D9}, Types {$ENDIF};

type
  TWinControlAccess = class(TWinControl);
  TDockAccess = class(TTBXMultiDock);
  TTBDockableWindowAccess = class(TTBCustomDockableWindow);

const
  { Constants for TTBXDockablePanel-specific registry values. Do not localize! }
  rvDockedWidth = 'DPDockedWidth';
  rvDockedHeight = 'DPDockedHeight';
  rvFloatingWidth = 'DPFloatingWidth';
  rvFloatingHeight = 'DPFloatingHeight';
  rvSplitWidth = 'DPSplitWidth';
  rvSplitHeight = 'DPSplitHeight';

  HT_TB2k_Border = 2000;
  HT_TB2k_Close = 2001;
  HT_TB2k_Caption = 2002;
  HT_TBX_SPLITRESIZELEFT = 86;
  HT_TBX_SPLITRESIZERIGHT = 87;
  HT_TBX_SPLITRESIZETOP = 88;
  HT_TBX_SPLITRESIZEBOTTOM = 89;
  DockedBorderSize = 2;
  ScrollDelay = 300;
  ScrollInterval = 75;

var
  MouseTimer: TTimer = nil;
  MouseInObject: TTBXPanelObject = nil;
  ObjectCount: Integer = 0;


procedure UpdateNCArea(Control: TWinControl; ViewType: Integer);
var
  W, H: Integer;
begin
  with Control do
  begin
    { Keep the client rect at the same position relative to screen }
    W := ClientWidth;
    H := ClientHeight;
    SetWindowPos(Handle, 0, 0, 0, 0, 0,
      SWP_FRAMECHANGED or SWP_NOACTIVATE or SWP_NOZORDER or SWP_NOREDRAW or SWP_NOMOVE or SWP_NOSIZE);
    W := W - ClientWidth;
    H := H - ClientHeight;
    if (W <> 0) or (H <> 0) then
      SetWindowPos(Handle, 0, Left - W div 2, Top - H div 2, Width + W, Height + H,
       SWP_FRAMECHANGED or SWP_NOACTIVATE or SWP_NOZORDER);
    RedrawWindow(Handle, nil, 0, RDW_FRAME or RDW_INVALIDATE or
      RDW_ERASE or RDW_UPDATENOW or RDW_ALLCHILDREN);
  end;
end;

function GetMinControlHeight(Control: TControl): Integer;
begin
  if Control.Align = alClient then
  begin
    if Control is TTBXPanelObject then Result := TTBXPanelObject(Control).GetMinHeight
    else Result := Control.Constraints.MinHeight;
  end
  else Result := Control.Height;
end;

function GetMinControlWidth(Control: TControl): Integer;
begin
  if Control.Align = alClient then
  begin
    if Control is TTBXPanelObject then Result := TTBXPanelObject(Control).GetMinWidth
    else Result := Control.Constraints.MinWidth;
  end
  else Result := Control.Width;
end;

function IsActivated(AWinControl: TWinControl): Boolean;
var
  C: TWinControl;
begin
  { Returns true if AWinControl contains a focused control }
  C := Screen.ActiveControl;
  Result := True;
  while C <> nil do
    if C = AWinControl then Exit
    else C := C.Parent;
  Result := False;
end;

procedure ApplyMargins(var R: TRect; const Margins: TTBXControlMargins); overload;
begin
  with Margins do
  begin
    Inc(R.Left, Left); Inc(R.Top, Top);
    Dec(R.Right, Right); Dec(R.Bottom, Bottom);
  end;
end;

procedure ApplyMargins(var R: TRect; const Margins: TRect); overload;
begin
  with Margins do
  begin
    Inc(R.Left, Left); Inc(R.Top, Top);
    Dec(R.Right, Right); Dec(R.Bottom, Bottom);
  end;
end;

procedure DrawFocusRect2(Canvas: TCanvas; const R: TRect);
var
  DC: HDC;
  C1, C2: TColor;
begin
  DC := Canvas.Handle;
  C1 := SetTextColor(DC, clBlack);
  C2 := SetBkColor(DC, clWhite);
  Canvas.DrawFocusRect(R);
  SetTextColor(DC, C1);
  SetBkColor(DC, C2);
end;

function GetRealAlignment(Control: TControl): TAlignment;
const
  ReverseAlignment: array [TAlignment] of TAlignment = (taRightJustify, taLeftJustify, taCenter);
begin
  Result := Control.GetControlsAlignment;
  if Control.UseRightToLeftAlignment then Result := ReverseAlignment[Result];
end;

function CompareEffectiveDockPos(Item1, Item2: Pointer): Integer;
begin
  Result := TTBCustomDockableWindow(Item1).EffectiveDockPos - TTBCustomDockableWindow(Item2).EffectiveDockPos;
end;

function CompareDockPos(Item1, Item2: Pointer): Integer;
var
  P1, P2: Integer;
begin
  P1 := TTBCustomDockableWindow(Item1).DockPos;
  P2 := TTBCustomDockableWindow(Item2).DockPos;
  if csLoading in TTBCustomDockableWindow(Item1).ComponentState then
  begin
    if P1 < 0 then P1 := MaxInt;
    if P2 < 0 then P2 := MaxInt;
  end;
  Result := P1 - P2;
end;


//----------------------------------------------------------------------------//

{ TTBXControlMargins }

procedure TTBXControlMargins.Assign(Src: TPersistent);
begin
  inherited;
  Modified;
end;

procedure TTBXControlMargins.Modified;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TTBXControlMargins.SetBottom(Value: Integer);
begin
  if FBottom <> Value then
  begin
    FBottom := Value;
    Modified;
  end;
end;

procedure TTBXControlMargins.SetLeft(Value: Integer);
begin
  if FLeft <> Value then
  begin
    FLeft := Value;
    Modified;
  end;
end;

procedure TTBXControlMargins.SetRight(Value: Integer);
begin
  if FRight  <> Value then
  begin
    FRight := Value;
    Modified;
  end;
end;

procedure TTBXControlMargins.SetTop(Value: Integer);
begin
  if FTop <> Value then
  begin
    FTop := Value;
    Modified;
  end;
end;

//----------------------------------------------------------------------------//

{ TTBXMultiDock }

function TTBXMultiDock.Accepts(ADockableWindow: TTBCustomDockableWindow): Boolean;
begin
  Result := ADockableWindow is TTBXDockablePanel;
end;

procedure TTBXMultiDock.ArrangeToolbars;
const
  DSGN_DROPZONESIZE = 16;
type
  TPosRec = record
    Panel: TTBXDockablePanel;
    MinSize, MaxSize, Size, Pos: Integer;
    CanStretch: Boolean;
  end;
var
  NewDockList: TList;
  PosData: array of TPosRec;
  LeftRight: Boolean;
  I, J, K, DragIndex, ResizeIndex: Integer;
  EmptySize, ClientW, ClientH, DockSize, TotalSize, TotalMinimumSize, TotalMaximumSize: Integer;
  T: TTBXDockablePanel;
  S: TPoint;
  CurRowSize: Integer;
  StretchPanelCount: Integer;
  Stretching: Boolean;
  AccDelta, Acc: Extended;
  Delta, IntAcc: Integer;
  MinWidth, MaxWidth, EffectiveMinWidth, EffectiveMaxWidth: Integer;
  R: TRect;

  function IndexOfDraggingToolbar(const List: TList): Integer;
  { Returns index of toolbar in List that's currently being dragged, or -1 }
  var
    I: Integer;
  begin
    for I := 0 to List.Count-1 do
      if TTBCustomDockableWindow(List[I]).DragMode then begin
        Result := I;
        Exit;
      end;
    Result := -1;
  end;

  procedure GetSizes(Panel: TTBXDockablePanel; out Size, MinSize, MaxSize: Integer);
  var
    Sz: TPoint;
    MinWidth, MinHeight, MaxWidth, MaxHeight: Integer;
  begin
    Panel.GetBaseSize(Sz);
    if LeftRight then
    begin
      Size := Panel.SplitHeight;
    end
    else
    begin
      Size := Panel.SplitWidth;
    end;
    MinWidth := 0; MaxWidth := 0; MinHeight := 0; MaxHeight := 0;
    Panel.ConstrainedResize(MinWidth, MinHeight, MaxWidth, MaxHeight);
    if not LeftRight then begin MinSize := MinWidth; MaxSize := MaxWidth end
    else begin MinSize := MinHeight; MaxSize := MaxHeight end;
    if MaxSize < MinSize then
    begin
      MaxSize := DockSize;
      if MaxSize < MinSize then MaxSize := MinSize;
    end;
    if Size < MinSize then Size := MinSize
    else if Size > MaxSize then Size := MaxSize;
  end;

  procedure GetMinMaxWidth(Panel: TTBXDockablePanel; out Min, Max: Integer);
  var
    MinWidth, MinHeight, MaxWidth, MaxHeight: Integer;
  begin
    MinWidth := 0; MaxWidth := 0; MinHeight := 0; MaxHeight := 0;
    Panel.ConstrainedResize(MinWidth, MinHeight, MaxWidth, MaxHeight);
    if LeftRight then begin Min := MinWidth; Max := MaxWidth end
    else begin Min := MinHeight; Max := MaxHeight end;
  end;

begin
  if (DisableArrangeToolbars > 0) or (csLoading in ComponentState) then
  begin
    ArrangeToolbarsNeeded := True;
    Exit;
  end;
  NewDockList := nil;
  PosData := nil;
  DisableArrangeToolbars := DisableArrangeToolbars + 1;
  try
    LeftRight := Position in [dpLeft, dpRight];

    if not HasVisibleToolbars then
    begin
      EmptySize := Ord(FixAlign);
      if csDesigning in ComponentState then EmptySize := 7;
      if not LeftRight then ChangeWidthHeight(Width, EmptySize)
      else ChangeWidthHeight(EmptySize, Height);
      Exit;
    end;

    ClientW := Width - NonClientWidth;
    if ClientW < 0 then ClientW := 0;
    ClientH := Height - NonClientHeight;
    if ClientH < 0 then ClientH := 0;
    if not LeftRight then DockSize := ClientW
    else DockSize := ClientH;

    { Leave some space for dropping other panels in design time }
    if csDesigning in ComponentState then Dec(DockSize, DSGN_DROPZONESIZE);
    if DockSize < 0 then DockSize := 0;


    for I := DockList.Count - 1 downto 0 do
    begin
      T := DockList[I];
      if csDestroying in T.ComponentState then
      begin
        DockList.Delete(I);
        DockVisibleList.Remove(T);
      end;
    end;

    { always limit to one row }
    for I := 0 to DockList.Count - 1 do
      with TTBCustomDockableWindow(DockList[I]) do DockRow := 0;

    { Copy DockList to NewDockList, and ensure it is in correct ordering
      according to DockRow/DockPos }
    NewDockList := TList.Create;
    NewDockList.Count := DockList.Count;
    for I := 0 to NewDockList.Count - 1 do NewDockList[I] := DockList[I];
    I := IndexOfDraggingToolbar(NewDockList);
    NewDockList.Sort(CompareDockPos);
    DragIndex := IndexOfDraggingToolbar(NewDockList);
    if (I >= 0) and TTBCustomDockableWindow(NewDockList[DragIndex]).DragSplitting then
    begin
      { When splitting, don't allow the toolbar being dragged to change
        positions in the dock list }
      NewDockList.Move(DragIndex, I);
      DragIndex := I;
    end;
    DockVisibleList.Sort(CompareDockPos);

    { Create a temporary array that holds new position data for the toolbars
      and get size info }
    SetLength(PosData, NewDockList.Count);
    J := 0;
    for I := 0 to NewDockList.Count - 1 do
    begin
      T := NewDockList[I];
      if ToolbarVisibleOnDock(T) then
      begin
        with PosData[J] do
        begin
          Panel := TTBXDockablePanel(T);
          Pos := Panel.DockPos;
          GetSizes(Panel, Size, MinSize, MaxSize);
        end;
        Inc(J);
      end;
    end;
    if Length(PosData) <> J then SetLength(PosData, J);

    { Update drag index... }
    if DragIndex >= 0 then
      for I := 0 to Length(PosData) - 1 do
        if NewDockList.IndexOf(PosData[I].Panel) = DragIndex then
        begin
          DragIndex := I;
          Break;
        end;

    { Count total sizes and set initial positions }
    TotalSize := 0; TotalMinimumSize := 0; TotalMaximumSize := 0;
    for I := 0 to Length(PosData) - 1 do
      with PosData[I] do
      begin
        Pos := TotalSize;
        Inc(TotalSize, Size);
        Inc(TotalMinimumSize, MinSize);
        Inc(TotalMaximumSize, MaxSize);
      end;

    if DockSize <> TotalSize then
    begin
      begin
        { Proportionally stretch and shrink toolbars }

        if TotalMinimumSize >= DockSize then
          for I := 0 to Length(PosData) - 1 do PosData[I].Size := PosData[I].MinSize
        else if TotalMaximumSize <= DockSize then
          for I := 0 to Length(PosData) - 1 do PosData[I].Size := PosData[I].MaxSize
        else
        begin
          Delta := DockSize - TotalSize;
          StretchPanelCount := 0;
          Stretching := TotalSize < DockSize; // otherwise, shrinking

          for I := 0 to Length(PosData) - 1 do
            with PosData[I] do
            begin
              if Stretching then CanStretch := Size < MaxSize
              else CanStretch := Size > MinSize;
              if CanStretch then Inc(StretchPanelCount);
            end;
          Assert(StretchPanelCount > 0);

          while Delta <> 0 do
          begin
            Assert(StretchPanelCount <> 0);
            AccDelta := Delta / StretchPanelCount;
            Acc := 0; IntAcc := 0;
            for I := 0 to Length(PosData) - 1 do
              with PosData[I] do if CanStretch then
              begin
                Acc := Acc + AccDelta;
                Inc(Size, Round(Acc) - IntAcc);
                IntAcc := Round(Acc);
              end;

            TotalSize := 0;
            for I := 0 to Length(PosData) - 1 do
              with PosData[I] do
              begin
                if CanStretch then
                  if Stretching then
                  begin
                    if Size > MaxSize then
                    begin
                      Size := MaxSize;
                      CanStretch := False;
                      Dec(StretchPanelCount);
                    end;
                  end
                  else
                  begin
                    if Size < MinSize then
                    begin
                      Size := MinSize;
                      CanStretch := False;
                      Dec(StretchPanelCount);
                    end;
                  end;
                Inc(TotalSize, Size);
              end;
            Delta := DockSize - TotalSize;
          end;
        end;

        TotalSize := 0;
        for I := 0 to Length(PosData) - 1 do
          with PosData[I] do
          begin
            Pos := TotalSize;
            Inc(TotalSize, Size);
          end;
      end
    end;

    for I := 0 to NewDockList.Count - 1 do
    begin
      for J := 0 to Length(PosData) - 1 do
        with PosData[J] do
        begin
          if Panel = NewDockList[I] then
          begin
            Panel.EffectiveDockRowAccess := 0;
            Panel.EffectiveDockPosAccess := PosData[J].Pos;
          end;
        end;
      if CommitNewPositions then
      begin
        T := NewDockList[I];
        T.DockRow := T.EffectiveDockRow;
        T.DockPos := T.EffectiveDockPos;
        DockList[I] := NewDockList[I];
      end;
    end;

    ResizeIndex := -1;
    for I := 0 to Length(PosData) - 1 do
      with PosData[I] do
        if Panel is TTBXDockablePanel and Panel.IsResizing then
        begin
          ResizeIndex := I;
          Break;
        end;

    { Calculate the size of the dock }
    if ResizeIndex < 0 then
    begin
      CurRowSize := 0;
      for I := 0 to Length(PosData) - 1 do
        with PosData[I] do
        begin
          Panel.CurrentSize := Size;
          Panel.GetBaseSize(S);
          if LeftRight then K := S.X + Panel.CalcNCSizes.X else K := S.Y + Panel.CalcNCSizes.Y;
          if (DragIndex = I) and (Length(PosData) > 1) and (LastValidRowSize > 0) then K := 0;
          if K > CurRowSize then CurRowSize := K;
        end;
    end
    else
    begin
      EffectiveMinWidth := 0;
      EffectiveMaxWidth := 0;
      for I := 0 to Length(PosData) - 1 do
      begin
        GetMinMaxWidth(PosData[I].Panel, MinWidth, MaxWidth);
        if MinWidth > EffectiveMinWidth then EffectiveMinWidth := MinWidth;
        if (MaxWidth >= MinWidth) and (MaxWidth < EffectiveMaxWidth) then EffectiveMaxWidth := MaxWidth;
      end;
      if LeftRight then CurRowSize := PosData[ResizeIndex].Panel.Width
      else CurRowSize := PosData[ResizeIndex].Panel.Height;
      if (EffectiveMaxWidth > EffectiveMinWidth) and (CurRowSize > EffectiveMaxWidth) then CurRowSize := EffectiveMaxWidth;
      if CurRowSize < EffectiveMinWidth then CurRowSize := EffectiveMinWidth;
    end;
    if CurRowSize > 0 then LastValidRowSize := CurRowSize;

    { Now actually move the toolbars }
    for I := 0 to Length(PosData) - 1 do
      with PosData[I] do
      begin
        if LeftRight then R := Bounds(0, Pos, CurRowSize, Size)
        else R := Bounds(Pos, 0, Size, CurRowSize);
        Panel.BoundsRect := R;
        { This is to fix some weird behavior in design time }
        if csDesigning in ComponentState then
          with R do MoveWindow(Panel.Handle, Left, Top, Right - Left, Bottom - Top, True);
      end;

    { Set the size of the dock }
    if not LeftRight then ChangeWidthHeight(Width, CurRowSize + NonClientHeight)
    else ChangeWidthHeight(CurRowSize + NonClientWidth, Height);

  finally
    DisableArrangeToolbars := DisableArrangeToolbars - 1;
    ArrangeToolbarsNeeded := False;
    CommitNewPositions := False;
    SetLength(PosData, 0);
    NewDockList.Free;
  end;
end;

procedure TTBXMultiDock.Paint;
var
  R: TRect;
begin
  { Draw dotted border in design mode }
  if csDesigning in ComponentState then
  begin
    R := ClientRect;
    with Canvas do
    begin
      Pen.Style := psSolid;
      Pen.Color := clBtnHighlight;
      Brush.Color := clBtnHighlight;
      Brush.Style := bsFDiagonal;
      Rectangle(R.Left, R.Top, R.Right, R.Bottom);
    end;
  end;
end;

procedure TTBXMultiDock.ResizeVisiblePanels(NewSize: Integer);
var
  I: Integer;
begin
  BeginUpdate;
  try
    for I := 0 to DockVisibleList.Count - 1 do
      if Position in [dpLeft, dpRight] then
        TTBXDockablePanel(DockVisibleList[I]).DockedWidth := NewSize
      else
        TTBXDockablePanel(DockVisibleList[I]).DockedHeight := NewSize;
  finally
    EndUpdate;
  end;
end;

procedure TTBXMultiDock.ValidateInsert(AComponent: TComponent);
begin
  if not (AComponent is TTBXDockablePanel) then
    raise EInvalidOperation.CreateResFmt(@STBXCannotInsertIntoMultiDock, [AComponent.ClassName]);
end;

//----------------------------------------------------------------------------//

{ TTBXPanelObject }

procedure TTBXPanelObject.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  if not Enabled and FMouseInControl then
  begin
    FMouseInControl := False;
    RemoveMouseTimer;
    DoMouseLeave;
    Invalidate;
    Perform(WM_CANCELMODE, 0, 0);
  end;
end;

procedure TTBXPanelObject.CMParentColorChanged(var Message: TMessage);
begin
  if Message.WParam = 0 then
  begin
    Message.WParam := 1;
    Message.LParam := GetEffectiveColor(Parent);
  end;
  inherited;
  Invalidate;
end;

constructor TTBXPanelObject.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := ControlStyle + [csAcceptsControls, csClickEvents, csDoubleClicks] - [csOpaque];
  if MouseTimer = nil then
  begin
    MouseTimer := TTimer.Create(nil);
    MouseTimer.Enabled := False;
    MouseTimer.Interval := 125;
  end;
  Inc(ObjectCount);
  ParentColor := False;
  Color := clNone;
  AddThemeNotification(Self);
end;

procedure TTBXPanelObject.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  if not (csDesigning in ComponentState) then
    with Params.WindowClass do style := style and not (CS_HREDRAW or CS_VREDRAW);
end;

destructor TTBXPanelObject.Destroy;
begin
  RemoveThemeNotification(Self);
  RemoveMouseTimer;
  Dec(ObjectCount);
  if ObjectCount = 0 then
  begin
    MouseTimer.Free;
    MouseTimer := nil;
  end;
  inherited;
end;

procedure TTBXPanelObject.DoMouseEnter;
begin
  if Assigned(FOnMouseEnter) then FOnMouseEnter(Self);
end;

procedure TTBXPanelObject.DoMouseLeave;
begin
  if Assigned(FOnMouseLeave) then FOnMouseLeave(Self);
end;

function TTBXPanelObject.GetMinHeight: Integer;
begin
  Result := Height;
end;

function TTBXPanelObject.GetMinWidth: Integer;
begin
  Result := Width;
end;

procedure TTBXPanelObject.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if SpaceAsClick and (Key = VK_SPACE) then
  begin
    FPushed := True;
    Invalidate;
  end;
end;

procedure TTBXPanelObject.KeyUp(var Key: Word; Shift: TShiftState);
begin
  if SpaceAsClick and Pushed and (Key = VK_SPACE) then
  begin
    FPushed := False;
    Click;
    Invalidate;
  end;
  inherited;
end;

procedure TTBXPanelObject.MakeVisible;

  procedure HandleScroll(SW: TControl);
  begin
    if SW is TScrollingWinControl then TScrollingWinControl(SW).ScrollInView(Self)
    else if SW is TTBXCustomPageScroller then TTBXCustomPageScroller(SW).ScrollToCenter(Self)
    else if (Parent <> nil) and (Parent <> SW) then HandleScroll(Parent);
  end;

begin
  HandleScroll(Parent);
end;

procedure TTBXPanelObject.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) and not FPushed then
  begin
    FPushed := True;
    Invalidate;
  end;
  if Enabled then MouseEntered;
  if not SmartFocus and CanFocus then SetFocus
  else if SmartFocus and CanFocus and Assigned(Parent) and IsActivated(Parent) then
  begin
    FDisableScroll := True;
    SetFocus;
    FDisableScroll := False;
  end;
  inherited;
end;

procedure TTBXPanelObject.MouseEntered;
begin
  if Enabled and not FMouseInControl then
  begin
    FMouseInControl := True;
    DoMouseEnter;
  end;
end;

procedure TTBXPanelObject.MouseLeft;
begin
  if Enabled and FMouseInControl then
  begin
    FMouseInControl := False;
    RemoveMouseTimer;
    DoMouseLeave;
    Invalidate;
  end;
end;

procedure TTBXPanelObject.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  P: TPoint;
  DragTarget: TControl;
begin
  P := ClientToScreen(Point(X, Y));
  DragTarget := FindDragTarget(P, True);
  if (MouseInObject <> Self) and (DragTarget = Self) then
  begin
    if Assigned(MouseInObject) then MouseInObject.MouseLeft;
    MouseInObject := Self;
    MouseTimer.OnTimer := MouseTimerHandler;
    MouseTimer.Enabled := True;
    MouseEntered;
  end
  else if (DragTarget <> Self) and (Mouse.Capture = Handle) and FMouseInControl then
  begin
    MouseLeft;
  end;
  inherited;
end;

procedure TTBXPanelObject.MouseTimerHandler(Sender: TObject);
var
  P: TPoint;
begin
  GetCursorPos(P);
  if FindDragTarget(P, True) <> Self then MouseLeft;
end;

procedure TTBXPanelObject.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FPushed := False;
  Invalidate;
  inherited;
end;

procedure TTBXPanelObject.RemoveMouseTimer;
begin
  if MouseInObject = Self then
  begin
    MouseTimer.Enabled := False;
    MouseInObject := nil;
  end;
end;

procedure TTBXPanelObject.SetPaintOptions(Value: TControlPaintOptions);
begin
  if Value <> FPaintOptions then
  begin
    FPaintOptions := Value;
    if cpoDoubleBuffered in Value then DoubleBuffered := True
    else DoubleBuffered := False;
    RecreateWnd;
  end;
end;

procedure TTBXPanelObject.TBMThemeChange(var Message: TMessage);
var
  R: TRect;
begin
  if (Message.wParam = TSC_AFTERVIEWCHANGE) and HandleAllocated then
  begin
    R := ClientRect;
    InvalidateRect(Handle, @R, True);
  end;
end;

procedure TTBXPanelObject.WMEraseBkgnd(var Message: TMessage);
begin
  if not DoubleBuffered or (Message.wParam = WPARAM(Message.lParam)) then
  begin
    if Color = clNone then
      DrawParentBackground(Self, TWMEraseBkgnd(Message).DC, ClientRect)
    else
      FillRectEx(TWMEraseBkgnd(Message).DC, ClientRect, Color);
  end;
  Message.Result := 1;
end;

procedure TTBXPanelObject.WMKillFocus(var Message: TMessage);
begin
  FPushed := False;
  Invalidate;
end;

procedure TTBXPanelObject.WMSetFocus(var Message: TMessage);
begin
  inherited;
  if not FDisableScroll then MakeVisible;
  Invalidate;
end;

//----------------------------------------------------------------------------//

{ TTBXCustomDockablePanel }

procedure TTBXCustomDockablePanel.AdjustClientRect(var Rect: TRect);
begin
  inherited AdjustClientRect(Rect);
  if BorderSize <> 0 then InflateRect(Rect, -BorderSize, -BorderSize);
end;

procedure TTBXCustomDockablePanel.BeginDockedSizing(HitTest: Integer);
var
  OrigPos, OldPos: TPoint;
  Msg: TMsg;
  DockRect, DragRect, OrigDragRect, OldDragRect: TRect;
  NCSizes: TPoint;
  EdgeRect, OldEdgeRect: TRect;
  ScreenDC: HDC;
  EraseEdgeRect, CommitResizing: Boolean;
  Form: TCustomForm;
  LeftRight: Boolean;

  function RectToScreen(const R: TRect): TRect;
  begin
    Result := R;
    Result.TopLeft := Parent.ClientToScreen(Result.TopLeft);
    Result.BottomRight := Parent.ClientToScreen(Result.BottomRight);
  end;

  function RectToClient(const R: TRect): TRect;
  begin
    Result := R;
    Result.TopLeft := Parent.ScreenToClient(Result.TopLeft);
    Result.BottomRight := Parent.ScreenToClient(Result.BottomRight);
  end;

  function GetEdgeRect(const R: TRect): TRect;
  begin
    Result := DockRect;
    case HitTest of
      HTLEFT: begin Result.Left := R.Left - 1; Result.Right := R.Left + 1 end;
      HTRIGHT: begin Result.Left := R.Right - 1; Result.Right := R.Right + 1 end;
      HTTOP: begin Result.Top := R.Top - 1; Result.Bottom := R.Top + 1 end;
      HTBOTTOM: begin Result.Top := R.Bottom - 1; Result.Bottom := R.Bottom + 1 end;
    end;
  end;

  procedure MouseMoved;
  var
    Pos: TPoint;
    NewWidth: Integer;
    NewHeight: Integer;
  begin
    GetCursorPos(Pos);
    if (Pos.X = OldPos.X) and (Pos.Y = OldPos.Y) then Exit;
    DragRect := OrigDragRect;
    case HitTest of
      HTLEFT:
        begin
          NewWidth := DragRect.Right - (DragRect.Left + Pos.X - OrigPos.X  - 1);
          if DoDockedResizing(False, NewWidth) then
            DragRect.Left := DragRect.Right - NewWidth;
        end;
      HTRIGHT:
        begin
          NewWidth := (DragRect.Right + Pos.X - OrigPos.X) - DragRect.Left;
          if DoDockedResizing(False, NewWidth) then
            DragRect.Right := DragRect.Left + NewWidth;
        end;
      HTTOP:
        begin
          NewHeight := DragRect.Bottom - (DragRect.Top + Pos.Y - OrigPos.Y - 1);
          if DoDockedResizing(True, NewHeight) then
            DragRect.Top := DragRect.Bottom - NewHeight;
        end;
      HTBOTTOM:
        begin
          NewHeight := (DragRect.Bottom + Pos.Y - OrigPos.Y) - DragRect.Top;
          if DoDockedResizing(True, NewHeight) then
            DragRect.Bottom := DragRect.Top + NewHeight;
        end;
    end;
    if not CompareMem(@OldDragRect, @DragRect, SizeOf(TRect)) then
    begin
      if SmoothDockedResize then
      begin
        CurrentDock.BeginUpdate;
        if HitTest in [HTLEFT, HTRIGHT] then
        begin
          BlockSizeUpdate := True;
          DockedWidth := DragRect.Right - DragRect.Left - NCSizes.X;
        end
        else
        begin
          BlockSizeUpdate := True;
          DockedHeight := DragRect.Bottom - DragRect.Top - NCSizes.Y;
        end;
        BlockSizeUpdate := False;
        CurrentDock.EndUpdate;
      end
      else
      begin
        EdgeRect := GetEdgeRect(DragRect);
        DrawDraggingOutline(ScreenDC, EdgeRect, OldEdgeRect);
        OldEdgeRect := EdgeRect;
        EraseEdgeRect := True;
      end;
      OldPos := Pos;
      OldDragRect := DragRect;
    end;
  end;

begin
  LeftRight := HitTest in [HTLEFT, HTRIGHT];
  if DoBeginDockedResizing(HitTest in [HTTOP, HTBOTTOM]) then
  try
    SetCapture(Handle);
    ScreenDC := GetDC(0);
    OrigDragRect := RectToScreen(BoundsRect);
    DockRect := RectToScreen(CurrentDock.ClientRect);
    OldDragRect := Rect(0, 0, 0, 0);
    NCSizes := CalcNCSizes;
    DragRect := OrigDragRect;
    GetCursorPos(OrigPos);
    OldPos := OrigPos;
    FIsResizing := True;

    if not SmoothDockedResize then
    begin
      EdgeRect := GetEdgeRect(DragRect);
      DrawDraggingOutline(ScreenDC, EdgeRect, Rect(0, 0, 0, 0));
      OldEdgeRect := EdgeRect;
      EraseEdgeRect := True;
    end
    else EraseEdgeRect := False;

    while GetCapture = Handle do
    begin
      case Integer(GetMessage(Msg, 0, 0, 0)) of
        -1: Break;
        0: begin
             PostQuitMessage(Msg.WParam);
             Break;
           end;
      end;
      case Msg.Message of
        WM_KEYDOWN, WM_KEYUP: if Msg.WParam = VK_ESCAPE then Break;
        WM_MOUSEMOVE: MouseMoved;
        WM_LBUTTONDOWN, WM_LBUTTONDBLCLK:Break;
        WM_LBUTTONUP: Break;
        WM_RBUTTONDOWN..WM_MBUTTONDBLCLK:;
      else
        TranslateMessage(Msg);
        DispatchMessage(Msg);
      end;
    end;
  finally
    if GetCapture = Handle then ReleaseCapture;
    CommitResizing := DoEndDockedResizing(HitTest in [HTTOP, HTBOTTOM]);
    if EraseEdgeRect then
    begin
      DrawDraggingOutline(ScreenDC, Rect(0, 0, 0, 0), OldEdgeRect);
      if CommitResizing and not IsRectEmpty(OldDragRect) then
        with OldDragRect do
        begin
          BlockSizeUpdate := True;
          if LeftRight then DockedWidth := Right - Left - NCSizes.X
          else DockedHeight := Bottom - Top - NCSizes.Y;
          BlockSizeUpdate := False;
        end;
    end
    else if not CommitResizing then
    begin
      BlockSizeUpdate := True;
      BoundsRect := RectToClient(OrigDragRect);
      BlockSizeUpdate := False;
    end;
    ReleaseDC(0, ScreenDC);
    FIsResizing := False;
    if csDesigning in ComponentState then
    begin
      Form := GetParentForm(Self);
      if (Form <> nil) and (Form.Designer <> nil) then Form.Designer.Modified;
    end;
  end;
end;

procedure TTBXCustomDockablePanel.BeginSplitResizing(HitTest: Integer);
type
  TPosRec = record
    Panel: TTBXDockablePanel;
    OrigPos, OrigSize, OrigWidth, Pos, Size, MinSize, MaxSize: Integer;
  end;
var
  Dock: TDockAccess;
  PosData: array of TPosRec;
  I: Integer;
  LeftRight, Smooth, CommitResizing: Boolean;
  DockSize, TotalSize, TotalMinSize, TotalMaxSize: Integer;
  OrigCursorPos, OldCursorPos: TPoint;
  Msg: TMsg;
  EffectiveIndex: Integer;
  EffectivePanel: TTBXCustomDockablePanel;
  PanelRect, DockRect, EdgeRect, OrigEdgeRect, OldEdgeRect: TRect;
  EdgePosition: TTBDockPosition;
  ScreenDC: HDC;
  EraseEdgeRect: Boolean;
  Form: TCustomForm;
  Delta: Integer;

  procedure GetSizes(Panel: TTBXDockablePanel; out Size, MinSize, MaxSize, W: Integer);
  var
    Sz: TPoint;
    MinWidth, MinHeight, MaxWidth, MaxHeight: Integer;
  begin
    Panel.GetBaseSize(Sz);
    if not LeftRight then
    begin
      Size := Panel.Width;
      W := Panel.Height;
    end
    else
    begin
      Size := Panel.Height;
      W := Panel.Width;
    end;
    MinWidth := 0; MaxWidth := 0; MinHeight := 0; MaxHeight := 0;
    Panel.ConstrainedResize(MinWidth, MinHeight, MaxWidth, MaxHeight);
    if not LeftRight then begin MinSize := MinWidth; MaxSize := MaxWidth; end
    else begin MinSize := MinHeight; MaxSize := MaxHeight end;
    if MaxSize < MinSize then
    begin
      MaxSize := DockSize;
      if MaxSize < MinSize then MaxSize := MinSize;
    end;
    if Size < MinSize then Size := MinSize
    else if Size > MaxSize then Size := MaxSize;
  end;

  procedure BlockSizeUpdates(DoBlock: Boolean);
  var
    I: Integer;
  begin
    for I := 0 to Length(PosData) - 1 do
      with PosData[I].Panel do BlockSizeUpdate := DoBlock;
  end;

  procedure SetSizes(RestoreOriginal: Boolean = False);
  var
    I: Integer;
    R: TRect;
  begin
    Dock.BeginUpdate;
    BlockSizeUpdates(True);
    for I := 0 to Length(PosData) - 1 do
      with PosData[I] do
      begin
        if LeftRight then
        begin
          if RestoreOriginal then R := Bounds(0, OrigPos, OrigWidth, OrigSize)
          else R := Bounds(0, Pos, OrigWidth, Size);
        end
        else
        begin
          if RestoreOriginal then R := Bounds(OrigPos, 0, OrigSize, OrigWidth)
          else R := Bounds(Pos, 0, Size, OrigWidth);
        end;
        if LeftRight then Panel.SplitHeight := Size
        else Panel.SplitWidth := Size;
        Panel.BoundsRect := R;

        { This is to fix some weird behavior in design time }
        if csDesigning in ComponentState then
          with R do MoveWindow(Panel.Handle, Left, Top, Right - Left, Bottom - Top, True);
      end;
    BlockSizeUpdates(False);
    Dock.EndUpdate;
  end;

  function GetEdgeRect(R: TRect): TRect;
  begin
    Result := R;
    case EdgePosition of
      dpRight: begin Result.Left := Result.Right - 1; Inc(Result.Right); end;
      dpBottom: begin Result.Top := Result.Bottom - 1; Inc(Result.Bottom); end;
    end;
  end;

  function RectToScreen(const R: TRect): TRect;
  begin
    Result := R;
    Result.TopLeft := Parent.ClientToScreen(Result.TopLeft);
    Result.BottomRight := Parent.ClientToScreen(Result.BottomRight);
  end;

  function RectToClient(const R: TRect): TRect;
  begin
    Result := R;
    Result.TopLeft := Parent.ScreenToClient(Result.TopLeft);
    Result.BottomRight := Parent.ScreenToClient(Result.BottomRight);
  end;

  procedure MouseMoved;
  var
    CursorPos: TPoint;
    I, P, Acc: Integer;
  begin
    GetCursorPos(CursorPos);
    if (CursorPos.X = OldCursorPos.X) and (CursorPos.Y = OldCursorPos.Y) then Exit;
    case EdgePosition of
      dpRight: Delta := CursorPos.X - OrigCursorPos.X;
      dpBottom: Delta := CursorPos.Y - OrigCursorPos.Y;
    end;
    if Delta = 0 then Exit;

    for I := 0 to Length(PosData) - 1 do
      with PosData[I] do
      begin
        Pos := OrigPos;
        Size := OrigSize;
      end;

    Acc := Delta;
    for I := EffectiveIndex downto 0 do
      with PosData[I] do
      begin
        Inc(Size, Acc); Acc := 0;
        if Size > MaxSize then
        begin
          Acc := Size - MaxSize;
          Size := MaxSize;
        end
        else if Size < MinSize then
        begin
          Acc := Size - MinSize;
          Size := MinSize;
        end;
        if Acc = 0 then Break;
      end;

    if Acc <> 0 then Dec(Delta, Acc);

    Acc := Delta;
    for I := EffectiveIndex + 1 to Length(PosData) - 1 do
      with PosData[I] do
      begin
        Dec(Size, Acc); Acc := 0;
        if Size > MaxSize then
        begin
          Acc := MaxSize - Size;
          Size := MaxSize;
        end
        else if Size < MinSize then
        begin
          Acc := MinSize - Size;
          Size := MinSize;
        end;
        if Acc = 0 then Break;
      end;

    if Acc <> 0 then
    begin
      Dec(Delta, Acc);
      for I := 0 to EffectiveIndex do with PosData[I] do Size := OrigSize;
      Acc := Delta;
      for I := EffectiveIndex downto 0 do
        with PosData[I] do
        begin
          Inc(Size, Acc); Acc := 0;
          if Size > MaxSize then
          begin
            Acc := Size - MaxSize;
            Size := MaxSize;
          end
          else if Size < MinSize then
          begin
            Acc := Size - MinSize;
            Size := MinSize;
          end;
          if Acc = 0 then Break;
        end;
    end;

    P := 0;
    for I := 0 to Length(PosData) - 1 do
      with PosData[I] do begin Pos := P; Inc(P, Size); end;

    if Smooth then SetSizes
    else
    begin
      EdgeRect := DockRect;
      if LeftRight then
      begin
        Inc(EdgeRect.Top, PosData[EffectiveIndex + 1].Pos - 1);
        EdgeRect.Bottom := EdgeRect.Top + 2;
      end
      else
      begin
        Inc(EdgeRect.Left, PosData[EffectiveIndex + 1].Pos - 1);
        EdgeRect.Right := EdgeRect.Left + 2;
      end;
      DrawDraggingOutline(ScreenDC, EdgeRect, OldEdgeRect);
      EraseEdgeRect := True;
    end;

    OldCursorPos := CursorPos;
    OldEdgeRect := EdgeRect;
  end;

begin
  if not (CurrentDock is TTBXMultiDock) then Exit;
  Dock := TDockAccess(CurrentDock);

  SetLength(PosData, Dock.DockVisibleList.Count);
  for I := 0 to Dock.DockVisibleList.Count - 1 do
    with PosData[I] do
    begin
      { only docks with TTBXDockablePanels can be resized }
      if not (TTBCustomDockableWindow(Dock.DockVisibleList[I]) is TTBXDockablePanel) then Exit;
      Panel := TTBXDockablePanel(Dock.DockVisibleList[I]);
    end;

  LeftRight := Dock.Position in [dpLeft, dpRight];
  if not LeftRight then DockSize := Dock.Width - Dock.NonClientWidth
  else DockSize := Dock.Height - Dock.NonClientHeight;
  if DockSize < 0 then DockSize := 0;

  { See if we can actually resize anything }
  TotalSize := 0; TotalMinSize := 0; TotalMaxSize := 0;
  for I := 0 to Length(PosData) - 1 do
    with PosData[I] do
    begin
      GetSizes(Panel, Size, MinSize, MaxSize, OrigWidth);
      OrigSize := Size;
      OrigPos := TotalSize;
      Pos := OrigPos;
      Inc(TotalSize, Size);
      Inc(TotalMinSize, MinSize);
      Inc(TotalMaxSize, MaxSize);
    end;
  if (TotalMinSize > DockSize) or (TotalMaxSize < DockSize) then Exit;

  { Get effective edge and panel }
  case HitTest of
    HT_TBX_SPLITRESIZETOP: EdgePosition := dpTop;
    HT_TBX_SPLITRESIZEBOTTOM: EdgePosition := dpBottom;
    HT_TBX_SPLITRESIZELEFT: EdgePosition := dpLeft;
  else
    EdgePosition := dpRight;
  end;
  Smooth := True;
  EffectivePanel := Self;
  for I := 0 to Length(PosData) - 1 do
    with PosData[I] do
    begin
      if not Panel.SmoothDockedResize then Smooth := False;
      if Panel = Self then
      begin
        EffectiveIndex := I;
        if EdgePosition in [dpLeft, dpTop] then
        begin
          Assert(I > 0);
          EffectivePanel := PosData[I - 1].Panel;
          if EdgePosition = dpLeft then EdgePosition := dpRight
          else EdgePosition := dpBottom;
          Dec(EffectiveIndex);
        end;
      end;
    end;

  try
    SetCapture(Handle);
    ScreenDC := GetDC(0);
    with EffectivePanel do PanelRect := RectToScreen(BoundsRect);
    DockRect := RectToScreen(Dock.ClientRect);
    GetCursorPos(OrigCursorPos);
    OldCursorPos := OrigCursorPos;
    OrigEdgeRect := GetEdgeRect(PanelRect);
    OldEdgeRect := Rect(0, 0, 0, 0);
    EdgeRect := OrigEdgeRect;
    FIsSplitting := True;

    if not Smooth then
    begin
      DrawDraggingOutline(ScreenDC, EdgeRect, Rect(0, 0, 0, 0));
      OldEdgeRect := EdgeRect;
      EraseEdgeRect := True;
    end
    else EraseEdgeRect := False;

    while GetCapture = Handle do
    begin
      case Integer(GetMessage(Msg, 0, 0, 0)) of
        -1: Break;
        0: begin
             PostQuitMessage(Msg.WParam);
             Break;
           end;
      end;
      case Msg.Message of
        WM_KEYDOWN, WM_KEYUP: if Msg.WParam = VK_ESCAPE then Break;
        WM_MOUSEMOVE: MouseMoved;
        WM_LBUTTONDOWN, WM_LBUTTONDBLCLK:Break;
        WM_LBUTTONUP: Break;
        WM_RBUTTONDOWN..WM_MBUTTONDBLCLK:;
      else
        TranslateMessage(Msg);
        DispatchMessage(Msg);
      end;
    end;
  finally
    if GetCapture = Handle then ReleaseCapture;
    CommitResizing := True;
    if EraseEdgeRect then
    begin
      DrawDraggingOutline(ScreenDC, Rect(0, 0, 0, 0), OldEdgeRect);
      if CommitResizing then SetSizes;
    end
    else if not CommitResizing then SetSizes(True);
    ReleaseDC(0, ScreenDC);
    FIsSplitting := False;
    if csDesigning in ComponentState then
    begin
      Form := GetParentForm(Self);
      if (Form <> nil) and (Form.Designer <> nil) then Form.Designer.Modified;
    end;
  end;
end;

function TTBXCustomDockablePanel.CalcNCSizes: TPoint;
begin
  if not Docked then
  begin
    Result.X := 0;
    Result.Y := 0;
  end
  else
  begin
    Result.X := DockedBorderSize * 2;
    Result.Y := DockedBorderSize * 2;
    if ShowCaptionWhenDocked then
      if IsVertCaption then Inc(Result.X, GetSystemMetrics(SM_CYSMCAPTION))
      else Inc(Result.Y, GetSystemMetrics(SM_CYSMCAPTION));
  end;
end;

function TTBXCustomDockablePanel.CalcSize(ADock: TTBDock): TPoint;
begin
  if Assigned(ADock) then
  begin
    if ADock.Position in [dpLeft, dpRight] then
    begin
      Result.X := FDockedWidth;
      Result.Y := ADock.ClientHeight - CalcNCSizes.Y;
    end
    else
    begin
      Result.X := ADock.ClientWidth - CalcNCSizes.X;
      Result.Y := FDockedHeight;
    end;
  end
  else
  begin
    { if floating width and height are yet undefined, copy them from docked width and height }
    if FFloatingWidth = 0 then
    begin
      if Docked and (CurrentDock.Position in [dpTop, dpBottom]) then
        FFloatingWidth := Width - CalcNCSizes.X
      else
        FFloatingWidth := FDockedWidth;
    end;

    if FFloatingHeight = 0 then
    begin
      if Docked and (CurrentDock.Position in [dpLeft, dpRight]) then
        FFloatingHeight := Height - CalcNCSizes.Y
      else
        FFloatingHeight := FDockedHeight;
    end;

    Result.X := FFloatingWidth;
    Result.Y := FFloatingHeight;
  end;
end;

function TTBXCustomDockablePanel.CanAutoSize(var NewWidth, NewHeight: Integer): Boolean;
begin
  Result := True;
end;

function TTBXCustomDockablePanel.CanDockTo(ADock: TTBDock): Boolean;
begin
  Result := inherited CanDockTo(ADock);
  if Result then
  begin
    if ADock is TTBXMultiDock then
    begin
      Result := dkMultiDock in SupportedDocks;
    end
    else
    begin
      Result := dkStandardDock in SupportedDocks;;
    end;
  end;
end;

function TTBXCustomDockablePanel.CanSplitResize(EdgePosition: TTBDockPosition): Boolean;
var
  Dock: TDockAccess;
begin
  Result := Docked and (CurrentDock is TTBXMultiDock) and HandleAllocated;
  if not Result then Exit;
  Dock := TDockAccess(CurrentDock);
  Dock.DockVisibleList.Sort(CompareEffectiveDockPos);
  if Dock.Position in [dpLeft, dpRight] then
  begin
    case EdgePosition of
      dpTop: Result := EffectiveDockPos > 0;
      dpBottom: Result := Dock.DockVisibleList.Last <> Self;
    else
      Result := False;
    end;
  end
  else
  begin
    case EdgePosition of
      dpLeft: Result := EffectiveDockPos > 0;
      dpRight: Result := Dock.DockVisibleList.Last <> Self;
    else
      Result := False;
    end;
  end;
end;

procedure TTBXCustomDockablePanel.CMColorChanged(var Message: TMessage);
begin
  UpdateEffectiveColor;
  Brush.Color := Color;
  if Docked and HandleAllocated then
  begin
    RedrawWindow(Handle, nil, 0, RDW_FRAME or RDW_INVALIDATE or
      RDW_ERASE or RDW_UPDATENOW or RDW_ALLCHILDREN);
  end;
  Invalidate;
  UpdateChildColors;
end;

procedure TTBXCustomDockablePanel.CMControlChange(var Message: TCMControlChange);
begin
  inherited;
  if Message.Inserting and (Color = clNone) then
    Message.Control.Perform(CM_PARENTCOLORCHANGED, 1, EffectiveColor);
end;

procedure TTBXCustomDockablePanel.CMTextChanged(var Message: TMessage);
begin
  inherited;
  if HandleAllocated then
  begin
    if Docked then RedrawWindow(Handle, nil, 0, RDW_FRAME or RDW_INVALIDATE)
    else RedrawWindow(TTBXFloatingWindowParent(Parent).Handle, nil, 0, RDW_FRAME or RDW_INVALIDATE);
  end;
end;

procedure TTBXCustomDockablePanel.ConstrainedResize(var MinWidth, MinHeight, MaxWidth, MaxHeight: Integer);
var
  Sz: TPoint;
begin
  Sz := CalcNCSizes;
  if MinClientWidth > 0 then MinWidth := MinClientWidth + Sz.X;
  if MinClientHeight > 0 then MinHeight := MinClientHeight + Sz.Y;
  if MaxClientWidth > 0 then MaxWidth := MaxClientWidth + Sz.X;
  if MaxClientHeight > 0 then MaxHeight := MaxClientHeight + Sz.Y;
end;

constructor TTBXCustomDockablePanel.Create(AOwner: TComponent);
begin
  inherited;
  FMinClientWidth := 32;
  FMinClientHeight := 32;
  FDockedWidth := 128;
  FDockedHeight := 128;
  FHorzResizeCursor := crSizeWE;
  FHorzSplitCursor := crHSplit;
  FVertResizeCursor := crSizeNS;
  FVertSplitCursor := crVSplit;
  CloseButtonWhenDocked := True;
  DblClickUndock := False;
  FShowCaptionWhenDocked := True;
  FSmoothDockedResize := True;
  BlockSizeUpdate := True;
  SetBounds(Left, Top, 128, 128);
  BlockSizeUpdate := False;
  FullSize := True;
  Color := clNone;
  AddThemeNotification(Self);
  SupportedDocks := [dkStandardDock, dkMultiDock];
end;

destructor TTBXCustomDockablePanel.Destroy;
begin
  RemoveThemeNotification(Self);
  inherited;
end;

function TTBXCustomDockablePanel.DoArrange(CanMoveControls: Boolean;
  PreviousDockType: TTBDockType; NewFloating: Boolean; NewDock: TTBDock): TPoint;
begin
  Result := CalcSize(NewDock);
end;

function TTBXCustomDockablePanel.DoBeginDockedResizing(Vertical: Boolean): Boolean;
var
  Sz: Integer;
begin
  Result := True;
  if Vertical then Sz := Height else Sz := Width;
  if Assigned(FOnDockedResizing) then FOnDockedResizing(Self, Vertical, Sz, rsBeginResizing, Result);
  if Result then
    if Vertical then Height := Sz else Width := Sz;
end;

function TTBXCustomDockablePanel.DoDockedResizing(Vertical: Boolean; var NewSize: Integer): Boolean;
const
  MIN_PARENT_CLIENT_SIZE = 32;
var
  NCSizes: TPoint;
  CW, CH: Integer;
  DockParent: TWinControl;
  ClientSize: TPoint;
begin
  NCSizes := CalcNCSizes;
  DockParent := Parent.Parent;
  ClientSize := GetClientSizeEx(DockParent);

  Assert(DockParent <> nil);
  if not Vertical then
  begin
    CW := ClientSize.X - MIN_PARENT_CLIENT_SIZE + Width;
    if NewSize > CW then NewSize := CW;
    CW := NewSize - NCSizes.X;
    if CW < MinClientWidth then CW := MinClientWidth
    else if (MaxClientWidth > MinClientWidth) and (CW > MaxClientWidth) then CW := MaxClientWidth;
    NewSize := CW + NCSizes.X;
  end
  else
  begin
    CH := ClientSize.Y - MIN_PARENT_CLIENT_SIZE + Height;
    if NewSize > CH then NewSize := CH;
    CH := NewSize - NCSizes.Y;
    if CH < MinClientHeight then CH := MinClientHeight
    else if (MaxClientHeight > MinClientHeight) and (CH > MaxClientHeight) then CH := MaxClientHeight;
    NewSize := CH + NCSizes.Y;
  end;
  Result := True;
  if Assigned(FOnDockedResizing) then FOnDockedResizing(Self, Vertical, NewSize, rsResizing, Result);
end;

function TTBXCustomDockablePanel.DoEndDockedResizing(Vertical: Boolean): Boolean;
var
  Sz: Integer;
begin
  Result := True;
  if Vertical then Sz := Height else Sz := Width;
  if Assigned(FOnDockedResizing) then
    FOnDockedResizing(Self, Vertical, Sz, rsEndResizing, Result);
  if Result then
    if Vertical then Height := Sz else Width := Sz;
end;

procedure TTBXCustomDockablePanel.DrawNCArea(const DrawToDC: Boolean;
  const ADC: HDC; const Clip: HRGN);
var
  WndDC, DC: HDC;
  BufDCRec: TBufDCRec;
  R, R2: TRect;
  DockPanelInfo: TTBXDockPanelInfo;
  Sz: Integer;
  ACanvas: TCanvas;
begin
  if not Docked or not HandleAllocated then Exit;

  GetWindowRect(Handle, R);
  OffsetRect(R, -R.Left, -R.Top);
  GetDockPanelInfo(DockPanelInfo);

  WndDC := 0;
  try
    if not DrawToDC then
    begin
      WndDC := GetWindowDC(Handle);
      DC := CreateBufDC(WndDC, R.Right, R.Bottom, BufDCRec);

      SelectNCUpdateRgn(Handle, WndDC, Clip);
      R2 := R;
      with DockPanelInfo.BorderSize do
        InflateRect(R2, -X, -Y);
      if DockPanelInfo.ShowCaption then
      begin
        Sz := GetSystemMetrics(SM_CYSMCAPTION);
        if DockPanelInfo.IsVertical
          then Inc(R2.Top, Sz)
          else Inc(R2.Left, Sz);
      end;
      with R2 do
        ExcludeClipRect(WndDC, Left, Top, Right, Bottom);
    end
    else DC := ADC;

    DockPanelInfo.Caption := PChar(Caption);
    ACanvas := TCanvas.Create;
    try
      ACanvas.Handle := DC;
      ACanvas.Brush.Color := EffectiveColor;
      CurrentTheme.PaintDockPanelNCArea(ACanvas, R, DockPanelInfo);
    finally
      ACanvas.Free;
    end;
    if not DrawToDC then
      with R do BitBlt(WndDC, Left, Top, Right, Bottom, DC, 0, 0, SRCCOPY);
  finally
    if not DrawToDC then
    begin
      DeleteBufDC(BufDCRec);
      ReleaseDC(Handle, WndDC);
    end;
  end;
end;

procedure TTBXCustomDockablePanel.GetBaseSize(var ASize: TPoint);
begin
  ASize := CalcSize(CurrentDock);
end;

function TTBXCustomDockablePanel.GetDockedCloseButtonRect(LeftRight: Boolean): TRect;
var
  X, Y, Z: Integer;
begin
  Z := GetSystemMetrics(SM_CYSMCAPTION) - 1;
  if not IsVertCaption then
  begin
    X := (ClientWidth + DockedBorderSize) - Z;
    Y := DockedBorderSize;
  end
  else
  begin
    X := DockedBorderSize;
    Y := ClientHeight + DockedBorderSize - Z;
  end;
  Result := Bounds(X, Y, Z, Z);
end;

procedure TTBXCustomDockablePanel.GetDockPanelInfo(out DockPanelInfo: TTBXDockPanelInfo);
begin
  FillChar(DockPanelInfo, SizeOf(DockPanelInfo), 0);
  DockPanelInfo.WindowHandle := WindowHandle;
  DockPanelInfo.ViewType := GetViewType;
  if CurrentDock <> nil then DockPanelInfo.IsVertical := not IsVertCaption;
  DockPanelInfo.AllowDrag := CurrentDock.AllowDrag;
  DockPanelInfo.BorderStyle := BorderStyle;
  CurrentTheme.GetViewBorder(DockPanelInfo.ViewType, DockPanelInfo.BorderSize);
  DockPanelInfo.ClientWidth := ClientWidth;
  DockPanelInfo.ClientHeight := ClientHeight;
  DockPanelInfo.ShowCaption := ShowCaptionWhenDocked;
  DockPanelInfo.EffectiveColor := EffectiveColor;
  if ShowCaptionWhenDocked and CloseButtonWhenDocked then
  begin
    DockPanelInfo.CloseButtonState := CDBS_VISIBLE;
    if CloseButtonDown then DockPanelInfo.CloseButtonState := DockPanelInfo.CloseButtonState or CDBS_PRESSED;
    if CloseButtonHover then DockPanelInfo.CloseButtonState := DockPanelInfo.CloseButtonState or CDBS_HOT;
  end;
end;

function TTBXCustomDockablePanel.GetFloatingBorderSize: TPoint;
begin
  CurrentTheme.GetViewBorder(GetViewType or DPVT_FLOATING, Result);
end;

function TTBXCustomDockablePanel.GetFloatingWindowParentClass: TTBFloatingWindowParentClass;
begin
  Result := TTBXFloatingWindowParent;
end;

procedure TTBXCustomDockablePanel.GetMinMaxSize(var AMinClientWidth, AMinClientHeight,
  AMaxClientWidth, AMaxClientHeight: Integer);
begin
  AMinClientWidth := FMinClientWidth;
  AMinClientHeight := FMinClientHeight;
  AMaxClientWidth := FMaxClientWidth;
  AMaxClientHeight := FMaxClientHeight;
end;

function TTBXCustomDockablePanel.GetViewType: Integer;
begin
  Result := DPVT_NORMAL;
  if Floating then Result := Result or DPVT_FLOATING;
  if Resizable then Result := Result or DPVT_RESIZABLE;
end;

function TTBXCustomDockablePanel.IsVertCaption: Boolean;
begin
  case CaptionRotation of
    dpcrAlwaysHorz: Result := False;
    dpcrAlwaysVert: Result := Docked;
  else // dpcrAuto:
    Result := Docked and (CurrentDock.Position in [dpTop, dpBottom]);
  end;
end;

procedure TTBXCustomDockablePanel.Loaded;
begin
  inherited;
  UpdateChildColors;
end;

procedure TTBXCustomDockablePanel.Paint;
begin
  if csDesigning in ComponentState then with Canvas do
  begin
    Pen.Style := psDot;
    Pen.Color := clBtnShadow;
    Brush.Style := bsClear;
    with ClientRect do Rectangle(Left, Top, Right, Bottom);
    Pen.Style := psSolid;
  end;
end;

procedure TTBXCustomDockablePanel.ReadPositionData(const Data: TTBReadPositionData);
begin
  with Data do
  begin
    FDockedWidth := ReadIntProc(Name, rvDockedWidth, FDockedWidth, ExtraData);
    FDockedHeight := ReadIntProc(Name, rvDockedHeight, FDockedHeight, ExtraData);
    FFloatingWidth := ReadIntProc(Name, rvFloatingWidth, FFloatingWidth, ExtraData);
    FFloatingHeight := ReadIntProc(Name, rvFloatingHeight, FFloatingHeight, ExtraData);
    FSplitWidth := ReadIntProc(Name, rvSplitWidth, FSplitWidth, ExtraData);
    FSplitHeight := ReadIntProc(Name, rvSplitHeight, FSplitHeight, ExtraData);
  end;
end;

procedure TTBXCustomDockablePanel.SetBorderSize(Value: Integer);
begin
  if FBorderSize <> Value then
  begin
    FBorderSize := Value;
    Realign;
  end;
end;

procedure TTBXCustomDockablePanel.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
end;

procedure TTBXCustomDockablePanel.SetCaptionRotation(Value: TDPCaptionRotation);
begin
  if FCaptionRotation <> Value then
  begin
    FCaptionRotation := Value;
    if Docked and HandleAllocated then
      SetWindowPos(Handle, 0, 0, 0, 0, 0, SWP_FRAMECHANGED or
        SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE or SWP_NOZORDER);
  end;
end;

procedure TTBXCustomDockablePanel.SetDockedHeight(Value: Integer);
begin
  if Value < MinClientHeight then Value := MinClientHeight;
  if Value <> FDockedHeight then
  begin
    FDockedHeight := Value;
    if Docked and (CurrentDock.Position in [dpTop, dpBottom]) then
    begin
      BlockSizeUpdate := True;
      Height := Value + CalcNCSizes.Y;
      BlockSizeUpdate := False;
    end;
  end;
end;

procedure TTBXCustomDockablePanel.SetDockedWidth(Value: Integer);
begin
  if Value < MinClientWidth then Value := MinClientWidth;
  if Value <> FDockedWidth then
  begin
    FDockedWidth := Value;
    if Docked and (CurrentDock.Position in [dpLeft, dpRight]) then
    begin
      BlockSizeUpdate := True;
      Width := Value + CalcNCSizes.X;
      BlockSizeUpdate := False;
    end;
  end;
end;

procedure TTBXCustomDockablePanel.SetFloatingHeight(Value: Integer);
begin
  { FloatingHeight (and floating width) can be set to 0 while panel is docked.
    This will force to restore floating dimensions from docked size }
  if Value < 0 then Value := 0;
  if not Docked and (Value < MinClientHeight) then Value := MinClientHeight;
  if Value <> FFloatingHeight then
  begin
    FFloatingHeight := Value;
    if not Docked then
    begin
      BlockSizeUpdate := True;
      Height := Value + CalcNCSizes.Y;
      BlockSizeUpdate := False;
    end;
  end;
end;

procedure TTBXCustomDockablePanel.SetFloatingWidth(Value: Integer);
begin
  { See comment for TTBXDockablePanel.SetFloatingHeight }
  if Value < 0 then Value := 0;
  if not Docked and (Value < MinClientWidth) then Value := MinClientWidth;
  if Value <> FFloatingWidth then
  begin
    FFloatingWidth := Value;
    if not Docked then
    begin
      BlockSizeUpdate := True;
      Width := Value + CalcNCSizes.X;
      BlockSizeUpdate := False;
    end;
  end;
end;

procedure TTBXCustomDockablePanel.SetMinClientHeight(Value: Integer);
begin
  if Value < 8 then Value := 8;
  FMinClientHeight := Value;
end;

procedure TTBXCustomDockablePanel.SetMinClientWidth(Value: Integer);
begin
  if Value < 8 then Value := 8;
  FMinClientWidth := Value;
end;

procedure TTBXCustomDockablePanel.SetParent(AParent: TWinControl);
begin
  inherited;
  if AParent is TTBXFloatingWindowParent then
    TTBXFloatingWindowParent(AParent).SnapDistance := SnapDistance;
end;

procedure TTBXCustomDockablePanel.SetShowCaptionWhenDocked(Value: Boolean);
begin
  if FShowCaptionWhenDocked <> Value then
  begin
    FShowCaptionWhenDocked := Value;
    if Docked then
    begin
      if HandleAllocated then
        SetWindowPos(Handle, 0, 0, 0, 0, 0, SWP_FRAMECHANGED or
          SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE or SWP_NOZORDER);
    end;
  end;
end;

procedure TTBXCustomDockablePanel.SetSnapDistance(Value: Integer);
begin
  if Value < 0 then Value := 0;
  FSnapDistance := Value;
  if (Parent <> nil) and (Parent is TTBXFloatingWindowParent) then
    TTBXFloatingWindowParent(Parent).SnapDistance := Value;
end;

procedure TTBXCustomDockablePanel.SetSplitHeight(Value: Integer);
begin
  if Value < 0 then Value := 0;
  if FSplitHeight <> Value then
  begin
    FSplitHeight := Value;
    if Docked and (CurrentDock.Position in [dpLeft, dpRight]) and
      (CurrentDock is TTBXMultiDock) then CurrentDock.ArrangeToolbars;
  end;
end;

procedure TTBXCustomDockablePanel.SetSplitWidth(Value: Integer);
begin
  if Value < 0 then Value := 0;
  if FSplitWidth <> Value then
  begin
    FSplitWidth := Value;
    if Docked and (CurrentDock.Position in [dpTop, dpBottom]) and
      (CurrentDock is TTBXMultiDock) then CurrentDock.ArrangeToolbars;
  end;
end;

procedure TTBXCustomDockablePanel.SizeChanging(const AWidth, AHeight: Integer);
begin
  if not BlockSizeUpdate then
  begin
    if Docked and (CurrentDock.Position in [dpLeft, dpRight]) then
      FDockedWidth := AWidth - CalcNCSizes.X
    else if Floating then
      FFloatingWidth := AWidth - CalcNCSizes.X;

    if Docked and (CurrentDock.Position in [dpTop, dpBottom]) then
      FDockedHeight := AHeight - CalcNCSizes.Y
    else if Floating then
      FFloatingHeight := AHeight - CalcNCSizes.Y;
  end;
end;

procedure TTBXCustomDockablePanel.TBMGetEffectiveColor(var Message: TMessage);
begin
  Message.WParam := EffectiveColor;
  Message.Result := 1;
end;

procedure TTBXCustomDockablePanel.TBMGetViewType(var Message: TMessage);
begin
  Message.Result := GetViewType;
end;

procedure TTBXCustomDockablePanel.TBMThemeChange(var Message: TMessage);
var
  M: TMessage;
begin
  case Message.WParam of
    TSC_BEFOREVIEWCHANGE: BeginUpdate;
    TSC_AFTERVIEWCHANGE:
      begin
        EndUpdate;
        UpdateEffectiveColor;

        if HandleAllocated and not (csDestroying in ComponentState) and
          (Parent is TTBXFloatingWindowParent) then
          UpdateNCArea(TTBXFloatingWindowParent(Parent), GetViewType)
        else
          UpdateNCArea(Self, GetViewType);

        Invalidate;

        M.Msg := CM_PARENTCOLORCHANGED;
        M.WParam := 1;
        M.LParam := EffectiveColor;
        M.Result := 0;
        Broadcast(M);
      end;
  end;
end;

procedure TTBXCustomDockablePanel.UpdateChildColors;
var
  M: TMessage;
begin
  M.Msg := CM_PARENTCOLORCHANGED;
  M.WParam := 1;
  M.LParam := EffectiveColor;
  M.Result := 0;
  Broadcast(M);
end;

procedure TTBXCustomDockablePanel.UpdateEffectiveColor;
begin
  if Color = clNone then FEffectiveColor := CurrentTheme.GetViewColor(GetViewType)
  else FEffectiveColor := Color;
end;

procedure TTBXCustomDockablePanel.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  FillRectEx(Message.DC, ClientRect, EffectiveColor);
  Message.Result := 1;
end;

procedure TTBXCustomDockablePanel.WMNCCalcSize(var Message: TWMNCCalcSize);
begin
  Message.Result := 0;
  if Docked then
    with Message.CalcSize_Params^ do
    begin
      InflateRect(rgrc[0], -DockedBorderSize, -DockedBorderSize);
      if ShowCaptionWhenDocked then
        if IsVertCaption then Inc(rgrc[0].Left, GetSystemMetrics(SM_CYSMCAPTION))
        else Inc(rgrc[0].Top, GetSystemMetrics(SM_CYSMCAPTION))
    end;
end;

procedure TTBXCustomDockablePanel.WMNCHitTest(var Message: TWMNCHitTest);
const
  CResizeMargin = 2;
var
  P: TPoint;
  R: TRect;
  Sz: Integer;
  IsVertical, UseDefaultHandler: Boolean;
begin
  if Docked then
  begin
    UseDefaultHandler := False;
    if csDesigning in ComponentState then with Message do
    begin
      P := SmallPointToPoint(Pos);
      GetWindowRect(Handle, R);
      if PtInRect(R, P) then
      begin
        Result := 0;
        case CurrentDock.Position of
          dpLeft: if P.X >= R.Right - CResizeMargin then Result := HTRIGHT;
          dpTop: if P.Y >= R.Bottom - CResizeMargin then Result := HTBOTTOM;
          dpRight: if P.X <= R.Left + CResizeMargin then Result := HTLEFT;
          dpBottom: if P.Y <= R.Top + CResizeMargin then Result := HTTOP;
        end;
        if Result = 0 then
        begin
          if (P.X >= R.Right - CResizeMargin) and CanSplitResize(dpRight) then Result := HT_TBX_SPLITRESIZERIGHT
          else if (P.Y >= R.Bottom - CResizeMargin) and CanSplitResize(dpBottom) then Result := HT_TBX_SPLITRESIZEBOTTOM
          else if (P.X <= R.Left + CResizeMargin) and CanSplitResize(dpLeft) then Result := HT_TBX_SPLITRESIZELEFT
          else if (P.Y <= R.Top + CResizeMargin) and CanSplitResize(dpTop) then Result := HT_TBX_SPLITRESIZETOP;
        end;
        UseDefaultHandler := Result <> 0;
      end;
      if UseDefaultHandler then DefaultHandler(Message)
      else inherited;
    end;

    with Message do
    begin
      P := SmallPointToPoint(Pos);
      GetWindowRect(Handle, R);
      if Resizable then
        case CurrentDock.Position of
          dpLeft: if P.X >= R.Right - CResizeMargin then Result := HTRIGHT;
          dpTop: if P.Y >= R.Bottom - CResizeMargin then Result := HTBOTTOM;
          dpRight: if P.X <= R.Left + CResizeMargin then Result := HTLEFT;
          dpBottom: if P.Y <= R.Top + CResizeMargin then Result := HTTOP;
        end;
      if Result = 0 then
      begin
        if (P.X >= R.Right - CResizeMargin) and CanSplitResize(dpRight) then Result := HT_TBX_SPLITRESIZERIGHT
        else if (P.Y >= R.Bottom - CResizeMargin) and CanSplitResize(dpBottom) then Result := HT_TBX_SPLITRESIZEBOTTOM
        else if (P.X <= R.Left + CResizeMargin) and CanSplitResize(dpLeft) then Result := HT_TBX_SPLITRESIZELEFT
        else if (P.Y <= R.Top + CResizeMargin) and CanSplitResize(dpTop) then Result := HT_TBX_SPLITRESIZETOP;
      end;
      if (Result <> HTCLIENT) and ((Result < HTLEFT) or (Result > HTBOTTOM)) and
        ((Result < HT_TBX_SPLITRESIZELEFT) or (Result > HT_TBX_SPLITRESIZEBOTTOM)) then
      begin
        Result := HTNOWHERE;
        InflateRect(R, -DockedBorderSize, -DockedBorderSize);

        if PtInRect(R, P) and ShowCaptionWhenDocked and not (csDesigning in ComponentState) then
        begin
          { caption area }
          IsVertical := not IsVertCaption;
          if CloseButtonWhenDocked then Sz := GetSystemMetrics(SM_CYSMCAPTION) - 1
          else Sz := 0;

          if (IsVertical and (P.X >= R.Right - Sz) and (P.Y < R.Top + Sz)) or
            (not IsVertical and (P.Y >= R.Bottom - Sz) and (P.X < R.Left + Sz)) then
            Result := HT_TB2k_Close
          else
            Result := HT_TB2k_Border;
        end;
      end;
    end;
  end
  else inherited;
end;

procedure TTBXCustomDockablePanel.WMNCLButtonDown(var Message: TWMNCLButtonDown);
begin
  if Message.HitTest in [HTLEFT..HTBOTTOM] then
    BeginDockedSizing(Message.HitTest)
  else if Message.HitTest in [HT_TBX_SPLITRESIZELEFT..HT_TBX_SPLITRESIZEBOTTOM] then
    BeginSplitResizing(Message.HitTest)
  else inherited; { setting IDC_SIZEALL already made in patched TB2 }
end;

procedure TTBXCustomDockablePanel.WMSetCursor(var Message: TWMSetCursor);
var Cur: TCursor;
begin
  if Docked and CurrentDock.AllowDrag and (Message.CursorWnd = WindowHandle) then
  begin
    Cur := Screen.Cursor;
    case Message.HitTest of
      HTLEFT, HTRIGHT:
        Cur := HorzResizeCursor;
      HTTOP, HTBOTTOM:
        Cur := VertResizeCursor;
      HT_TBX_SPLITRESIZELEFT, HT_TBX_SPLITRESIZERIGHT:
        Cur := HorzSplitCursor;
      HT_TBX_SPLITRESIZETOP, HT_TBX_SPLITRESIZEBOTTOM:
        Cur := VertSplitCursor;
      HT_TB2k_Border:
        if ShowCaptionWhenDocked then Cur := crArrow;
    end;
    if Cur <> Screen.Cursor then
    begin
      SetCursor(Screen.Cursors[Cur]);
      Message.Result := 1;
      Exit;
    end;
  end;
  inherited;
end;

procedure TTBXCustomDockablePanel.WMWindowPosChanged(var Message: TWMWindowPosChanged);
begin
  inherited;
  if (Message.WindowPos^.flags and SWP_NOSIZE) = 0 then
  begin
    Realign;
    Update;
  end;
  if (Message.WindowPos^.flags and SWP_SHOWWINDOW) <> 0 then
  begin
    UpdateEffectiveColor;
    UpdateChildColors;
  end;
end;

procedure TTBXCustomDockablePanel.WritePositionData(const Data: TTBWritePositionData);
begin
  with Data do
  begin
    WriteIntProc(Name, rvDockedWidth, FDockedWidth, ExtraData);
    WriteIntProc(Name, rvDockedHeight, FDockedHeight, ExtraData);
    WriteIntProc(Name, rvFloatingWidth, FFloatingWidth, ExtraData);
    WriteIntProc(Name, rvFloatingHeight, FFloatingHeight, ExtraData);
    WriteIntProc(Name, rvSplitWidth, FSplitWidth, ExtraData);
    WriteIntProc(Name, rvSplitHeight, FSplitHeight, ExtraData);
  end;
end;

//----------------------------------------------------------------------------//

{ TTBXTextObject }

procedure TTBXTextObject.AdjustFont(AFont: TFont);
begin
end;

procedure TTBXTextObject.AdjustHeight;
var
  NewHeight: Integer;
begin
  if HandleAllocated and not FUpdating and ([csReading, csLoading] * ComponentState = []) and AutoSize then
  begin
    FUpdating := True;
    try
      NewHeight := 0;
      DoAdjustHeight(StockCompatibleBitmap.Canvas, NewHeight);
      SetBounds(Left, Top, Width, NewHeight);
    finally
      FUpdating := False;
    end;
  end;
end;

function TTBXTextObject.CanAutoSize(var NewWidth, NewHeight: Integer): Boolean;
begin
  if not FUpdating and ([csReading, csLoading] * ComponentState = []) and AutoSize then
  begin
    FUpdating := True;
    try
      NewHeight := 0;
      DoAdjustHeight(StockCompatibleBitmap.Canvas, NewHeight);
      Result := True;
    finally
      FUpdating := False;
    end;
  end
  else Result := False;
end;

procedure TTBXTextObject.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TTBXTextObject.CMFontChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
  AdjustHeight;
end;

procedure TTBXTextObject.CMTextChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
  AdjustHeight;
end;

constructor TTBXTextObject.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := ControlStyle + [csSetCaption, csDoubleClicks];
  FMargins := TTBXControlMargins.Create;
  FMargins.OnChange := MarginsChangeHandler;
  FShowAccelChar := True;
  FShowFocusRect := True;
  PaintOptions := [cpoDoubleBuffered];
  AutoSize := True;
  Width := 100;
end;

procedure TTBXTextObject.CreateParams(var Params: TCreateParams);
begin
  inherited;
  if not (csDesigning in ComponentState) then
    with Params.WindowClass do style := style or CS_HREDRAW;
end;

destructor TTBXTextObject.Destroy;
begin
  FMargins.Free;
  inherited;
end;

procedure TTBXTextObject.DoAdjustHeight(ACanvas: TCanvas; var NewHeight: Integer);
const
  WordWraps: array [TTextWrapping] of Word = (0, DT_END_ELLIPSIS, DT_PATH_ELLIPSIS, DT_WORDBREAK);
var
  R: TRect;
  EffectiveMargins: TRect;
begin
  R := ClientRect;
  EffectiveMargins := GetTextMargins;
  with Margins do
  begin
    Inc(EffectiveMargins.Left, Left);  Inc(EffectiveMargins.Right, Right);
    Inc(EffectiveMargins.Top, Top);    Inc(EffectiveMargins.Bottom, Bottom);
  end;
  ApplyMargins(R, EffectiveMargins);
  NewHeight := DoDrawText(ACanvas, R, (DT_EXPANDTABS or DT_CALCRECT) or WordWraps[Wrapping]);
  with EffectiveMargins do Inc(NewHeight, Top + Bottom);
end;

function TTBXTextObject.DoDrawText(ACanvas: TCanvas; var Rect: TRect; Flags: Integer): Integer;
var
  Text: string;
begin
  Text := GetLabelText;
  if (Flags and DT_CALCRECT <> 0) and ((Text = '') or
    (Text[1] = '&') and (Text[2] = #0)) then Text := Text + ' ';
  Flags := DrawTextBiDiModeFlags(Flags);
  ACanvas.Font := Font;
  AdjustFont(ACanvas.Font);

  if Flags and DT_CALCRECT = DT_CALCRECT then
  begin
    Flags := Flags and not DT_VCENTER;
    Result := DrawText(ACanvas.Handle, PChar(Text), Length(Text), Rect, Flags);
  end
  else if not Enabled then
  begin
    OffsetRect(Rect, 1, 1);
    ACanvas.Font.Color := clBtnHighlight;
    DrawText(ACanvas.Handle, PChar(Text), Length(Text), Rect, Flags);
    OffsetRect(Rect, -1, -1);
    ACanvas.Font.Color := clBtnShadow;
    Result := DrawText(ACanvas.Handle, PChar(Text), Length(Text), Rect, Flags);
  end
  else
  begin
    Result := DrawText(ACanvas.Handle, PChar(Text), Length(Text), Rect, Flags);
  end;
end;

procedure TTBXTextObject.DoMarginsChanged;
begin
  Invalidate;
  AdjustHeight;
end;

function TTBXTextObject.GetControlsAlignment: TAlignment;
begin
  Result := FAlignment;
end;

function TTBXTextObject.GetFocusRect(const R: TRect): TRect;
begin
  { R is the client rectangle without the margins }
  Result := Rect(0, 0, 0, 0);
end;

function TTBXTextObject.GetLabelText: string;
begin
  Result := Caption;
end;

function TTBXTextObject.GetTextAlignment: TAlignment;
begin
  Result := Alignment;
end;

function TTBXTextObject.GetTextMargins: TRect;
const
  ZeroRect: TRect = (Left: 0; Top: 0; Right: 0; Bottom: 0);
begin
  Result := ZeroRect;
end;

procedure TTBXTextObject.Loaded;
begin
  inherited;
  AdjustHeight;
end;

procedure TTBXTextObject.MarginsChangeHandler(Sender: TObject);
begin
  DoMarginsChanged;
end;

procedure TTBXTextObject.Paint;
const
  Alignments: array [TAlignment] of Integer = (DT_LEFT, DT_RIGHT, DT_CENTER);
  WordWraps: array [TTextWrapping] of Integer = (DT_SINGLELINE,
    DT_SINGLELINE or DT_END_ELLIPSIS,
    DT_SINGLELINE or DT_PATH_ELLIPSIS, DT_WORDBREAK);
  ShowAccelChars: array [Boolean] of Integer = (DT_NOPREFIX, 0);
var
  R, R2: TRect;
  DrawStyle: Longint;
  CaptionHeight: Integer;
begin
  with Canvas do
  begin
    R := ClientRect;
    ApplyMargins(R, Margins);
    if Focused and FShowFocusRect then DrawFocusRect2(Canvas, GetFocusRect(R));
    DrawStyle := DT_EXPANDTABS or WordWraps[Wrapping] or
      Alignments[GetRealAlignment(Self)] or ShowAccelChars[ShowAccelChar];
    Brush.Style := bsClear;
    ApplyMargins(R, GetTextMargins);
    R2 := R;
    CaptionHeight := DoDrawText(Canvas, R2, DrawStyle or DT_CALCRECT);
    R.Top := (R.Top + R.Bottom - CaptionHeight) div 2;
    R.Bottom := R.Top + CaptionHeight;
    DoDrawText(Canvas, R, DrawStyle);
    Brush.Style := bsSolid;
  end;
end;

procedure TTBXTextObject.SetAlignment(Value: TLeftRight);
begin
  FAlignment := Value;
  Invalidate;
end;

procedure TTBXTextObject.SetMargins(Value: TTBXControlMargins);
begin
  FMargins.Assign(Value);
end;

procedure TTBXTextObject.SetShowAccelChar(Value: Boolean);
begin
  if FShowAccelChar <> Value then
  begin
    FShowAccelChar := Value;
    AdjustHeight;
    Invalidate;
  end;
end;

procedure TTBXTextObject.SetShowFocusRect(const Value: Boolean);
begin
  if FShowFocusRect <> Value then
  begin
    FShowFocusRect := Value;
    Invalidate;
  end;
end;

procedure TTBXTextObject.SetWrapping(Value: TTextWrapping);
begin
  FWrapping := Value;
  Invalidate;
  AdjustHeight;
end;

//----------------------------------------------------------------------------//

{ TTBXCustomLabel }

procedure TTBXCustomLabel.CMDialogChar(var Message: TCMDialogChar);
begin
  if (FFocusControl <> nil) and Enabled and ShowAccelChar and IsAccel(Message.CharCode, Caption) then
    with FFocusControl do
      if CanFocus then
      begin
        SetFocus;
        Message.Result := 1;
      end;
end;

constructor TTBXCustomLabel.Create(AOwner: TComponent);
begin
  inherited;
  Wrapping := twWrap;
  FUnderlineColor := clBtnShadow;
  TabStop := False;
end;

function TTBXCustomLabel.GetTextMargins: TRect;
const
  BottomMargin: array[Boolean] of Integer = (0, 1);
begin
  with Result do
  begin
    Left := 0;
    Top := 0;
    Right := 0;
    Result.Bottom := BottomMargin[Underline];
  end;
end;

procedure TTBXCustomLabel.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FFocusControl) then FFocusControl := nil;
end;

procedure TTBXCustomLabel.Paint;
var
  Rect: TRect;
begin
  inherited;
  if Underline then
    with Canvas do
    begin
      Rect := ClientRect;
      ApplyMargins(Rect, Margins);
      ApplyMargins(Rect, GetTextMargins);
      Pen.Color := UnderlineColor;
      MoveTo(Rect.Left, Rect.Bottom);
      LineTo(Rect.Right, Rect.Bottom);
    end;
end;

procedure TTBXCustomLabel.SetFocusControl(Value: TWinControl);
begin
  if FFocusControl <> Value then
  begin
    if FFocusControl <> nil then FFocusControl.RemoveFreeNotification(Self);
    FFocusControl := Value;
    if FFocusControl <> nil then FFocusControl.FreeNotification(Self);
  end;
end;

procedure TTBXCustomLabel.SetUnderline(Value: Boolean);
begin
  if Value <> FUnderline then
  begin
    FUnderline := Value;
    Invalidate;
    AdjustHeight;
  end;
end;

procedure TTBXCustomLabel.SetUnderlineColor(Value: TColor);
begin
  FUnderlineColor := Value;
  Invalidate;
end;

//----------------------------------------------------------------------------//

{ TTBXCustomLink }

procedure TTBXCustomLink.AdjustFont(AFont: TFont);
begin
  if MouseInControl then AFont.Style := AFont.Style + [fsUnderline];
end;

procedure TTBXCustomLink.CMDialogChar(var Message: TCMDialogChar);
begin
  with Message do
    if Enabled and ShowAccelChar and IsAccel(CharCode, GetLabelText) and CanFocus and Visible then
    begin
      Click;
      Result := 1;
    end
    else inherited;
end;

procedure TTBXCustomLink.CMDialogKey(var Message: TCMDialogKey);
begin
  with Message do
    if (CharCode = VK_RETURN) and Focused and
      (KeyDataToShiftState(Message.KeyData) = []) then
    begin
      Click;
      Result := 1;
    end
    else inherited;
end;

constructor TTBXCustomLink.Create(AOwner: TComponent);
begin
  inherited;
  FImageChangeLink := TChangeLink.Create;
  FImageChangeLink.OnChange := ImageListChange;
  SmartFocus := True;
  SpaceAsClick := True;
  TabStop := True;
  Cursor := crHandPoint;
end;

destructor TTBXCustomLink.Destroy;
begin
  FImageChangeLink.Free;
  inherited;
end;

procedure TTBXCustomLink.DoAdjustHeight(ACanvas: TCanvas; var NewHeight: Integer);
begin
  inherited DoAdjustHeight(ACanvas, NewHeight);
  if Images <> nil then
    if NewHeight < Images.Height + 4 then NewHeight := Images.Height + 4;
end;

procedure TTBXCustomLink.DoMouseEnter;
begin
  inherited;
  Invalidate;
end;

procedure TTBXCustomLink.DoMouseLeave;
begin
  inherited;
  Invalidate;
end;

function TTBXCustomLink.GetControlsAlignment: TAlignment;
begin
  Result := GetTextAlignment;
end;

function TTBXCustomLink.GetFocusRect(const R: TRect): TRect;
const
  WordWraps: array [TTextWrapping] of Integer = (DT_SINGLELINE or DT_VCENTER,
    DT_SINGLELINE or DT_VCENTER or DT_END_ELLIPSIS,
    DT_SINGLELINE or DT_VCENTER or DT_PATH_ELLIPSIS, DT_WORDBREAK);
var
  TR: TRect;
  ShowImage: Boolean;
begin
  Result := R;
  ShowImage := Assigned(Images) and (ImageIndex >= 0) and (ImageIndex < Images.Count);

  { Text Rectangle }
  TR := R;
  ApplyMargins(TR, GetTextMargins);
  DoDrawText(Canvas, TR, (DT_EXPANDTABS or DT_CALCRECT) or WordWraps[Wrapping] or DT_LEFT);

  if ShowImage then
  begin
    if GetRealAlignment(Self) = taLeftJustify then
    begin
      Result.Left := R.Left;
      Result.Right := TR.Right;
    end
    else
    begin
      Result.Left := TR.Left;
      Result.Right := R.Right;
    end;
  end
  else
  begin
    Result.Right := TR.Right;
    Result.Left := TR.Left;
  end;
  Dec(Result.Left, 2);
  Inc(Result.Right, 2);
end;

function TTBXCustomLink.GetTextAlignment: TAlignment;
begin
  Result := taLeftJustify;
end;

function TTBXCustomLink.GetTextMargins: TRect;
begin
  Result := Rect(2, 1, 2, 1);
  if Assigned(Images) then with Result do
  begin
    if GetRealAlignment(Self) = taLeftJustify then Inc(Left, Images.Width + 5)
    else Inc(Right, Images.Width + 5);
  end;
end;

procedure TTBXCustomLink.ImageListChange(Sender: TObject);
begin
  if Sender = Images then
  begin
    Invalidate;
    AdjustHeight;
  end;
end;

procedure TTBXCustomLink.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (AComponent = Images) and (Operation = opRemove) then Images := nil;
end;

procedure TTBXCustomLink.Paint;
var
  Rect, R: TRect;
begin
  inherited;
  if Assigned(Images) and (ImageIndex >= 0) and (ImageIndex < Images.Count) then
    with Canvas do
    begin
      Rect := ClientRect;
      ApplyMargins(Rect, Margins);

      if GetRealAlignment(Self) = taLeftJustify then R.Left := Rect.Left + 2
      else R.Left := Rect.Right - 2 - Images.Width;

      R.Top := (Rect.Top + Rect.Bottom - Images.Height) div 2;
      R.Right := R.Left + Images.Width;
      R.Bottom := R.Top + Images.Height;

      if Enabled then Images.Draw(Canvas, R.Left, R.Top, ImageIndex)
      else DrawTBXImage(Canvas, R, Images, ImageIndex, ISF_DISABLED);
    end;
end;

procedure TTBXCustomLink.SetImageIndex(Value: TImageIndex);
begin
  if FImageIndex <> Value then
  begin
    FImageIndex := Value;
    if Assigned(Images) then Invalidate;
  end;
end;

procedure TTBXCustomLink.SetImages(Value: TCustomImageList);
begin
  if FImages <> nil then FImages.UnRegisterChanges(FImageChangeLink);
  FImages := Value;
  if FImages <> nil then
  begin
    FImages.RegisterChanges(FImageChangeLink);
    FImages.FreeNotification(Self);
  end;
  Invalidate;
  AdjustHeight;
end;

procedure TTBXCustomLink.WMNCHitTest(var Message: TWMNCHitTest);
var
  P: TPoint;
  R: TRect;
begin
  inherited;
  if not (csDesigning in ComponentState) then
  begin
    P := ScreenToClient(SmallPointToPoint(Message.Pos));
    R := ClientRect;
    ApplyMargins(R, Margins);
    R := GetFocusRect(R);
    if not PtInRect(R, P) then Message.Result := HTTRANSPARENT;
  end;
end;

//----------------------------------------------------------------------------//

{ TTBXCustomButton }

function TTBXCustomButton.ArrowVisible: Boolean;
begin
  Result := DropDownMenu <> nil;
end;

procedure TTBXCustomButton.Click;
var
  Form: TCustomForm;
  Pt: TPoint;
  R: TRect;
  SaveAlignment: TPopupAlignment;

  procedure RemoveClicks;
  var
    RepostList: TList;
    Repost: Boolean;
    I: Integer;
    Msg: TMsg;
    P: TPoint;
  begin
    RepostList := TList.Create;
    try
      while PeekMessage(Msg, 0, WM_LBUTTONDOWN, WM_MBUTTONDBLCLK, PM_REMOVE) do
        with Msg do
        begin
          Repost := True;
          case Message of
            WM_QUIT: begin
                { Throw back any WM_QUIT messages }
                PostQuitMessage(wParam);
                Break;
              end;
            WM_LBUTTONDOWN, WM_LBUTTONDBLCLK,
            WM_RBUTTONDOWN, WM_RBUTTONDBLCLK,
            WM_MBUTTONDOWN, WM_MBUTTONDBLCLK:
              begin
                {$IFDEF WIN64}
                P := SmallPointToPoint(TSmallPoint(Int64Rec(lParam).Lo));
                {$ELSE}
                P := SmallPointToPoint(TSmallPoint(lParam));
                {$ENDIF}
                Windows.ClientToScreen(hwnd, P);
                if FindDragTarget(P, True) = Self then Repost := False;
              end;
          end;
          if Repost then
          begin
            RepostList.Add(AllocMem(SizeOf(TMsg)));
            PMsg(RepostList.Last)^ := Msg;
          end;
        end;
    finally
      for I := 0 to RepostList.Count-1 do
      begin
        with PMsg(RepostList[I])^ do PostMessage(hwnd, message, wParam, lParam);
        FreeMem(RepostList[I]);
      end;
      RepostList.Free;
    end;
  end;

begin
  if FRepeating and not FMenuVisible then inherited
  else
  try
    FInClick := True;
    if (GroupIndex <> 0) and not FMenuVisible then SetChecked(not Checked);
    MouseLeft;
    if (DropDownMenu = nil) or (DropDownCombo and not FMenuVisible) then
    begin
      if ModalResult <> 0 then
      begin
        Form := GetParentForm(Self);
        if Form <> nil then Form.ModalResult := ModalResult;
      end;
      inherited;
    end
    else
    begin
      MouseCapture := False;
      SaveAlignment := paLeft; // to avoid compiler warnings
      if DoDropDown then
      try
        Pt := Point(0, Height);
        Pt := ClientToScreen(Pt);
        SaveAlignment := DropDownMenu.Alignment;
        DropDownMenu.PopupComponent := Self;

        if DropDownMenu is TTBXPopupMenu then
        begin
          R := ClientRect;
          ApplyMargins(R, Margins);
          R.TopLeft := ClientToScreen(R.TopLeft);
          R.BottomRight := ClientToScreen(R.BottomRight);
          TTBXPopupMenu(DropDownMenu).PopupEx(R);
        end
        else DropDownMenu.Popup(Pt.X, Pt.Y);
      finally
        DropDownMenu.Alignment := SaveAlignment;
        if Pushed then FPushed := False;
        Invalidate;
        RemoveClicks;
      end
      else inherited;
    end;
  finally
    FInClick := False;
  end;
end;

procedure TTBXCustomButton.CMDialogChar(var Message: TCMDialogChar);
begin
  with Message do
    if Enabled and ShowAccelChar and IsAccel(CharCode, GetLabelText) and CanFocus and Visible then
    begin
      Click;
      Result := 1;
    end
    else inherited;
end;

procedure TTBXCustomButton.CMDialogKey(var Message: TCMDialogKey);
begin
  with Message do
    if (CharCode = VK_RETURN) and Focused and
      (KeyDataToShiftState(Message.KeyData) = []) then
    begin
      Click;
      Result := 1;
    end
    else inherited;
end;

constructor TTBXCustomButton.Create(AOwner: TComponent);
begin
  inherited;
  FAlignment := taCenter;
  FBorderSize := 4;
  FGlyphSpacing := 4;
  FImageChangeLink := TChangeLink.Create;
  FImageChangeLink.OnChange := ImageListChange;
  FRepeatDelay := 400;
  FRepeatInterval := 100;
  SmartFocus := True;
  SpaceAsClick := True;
  TabStop := True;
end;

destructor TTBXCustomButton.Destroy;
begin
  FImageChangeLink.Free;
  inherited;
end;

procedure TTBXCustomButton.DoAdjustHeight(ACanvas: TCanvas; var NewHeight: Integer);
var
  Sz: Integer;
begin
  if Length(GetLabelText) = 0 then
  begin
    if Images <> nil then NewHeight := Images.Height + BorderSize * 2
    else if BorderSize * 2 >= 16 then NewHeight := BorderSize * 2
    else NewHeight := 16;
  end
  else
  begin
    inherited DoAdjustHeight(ACanvas, NewHeight);
    if Images <> nil then
      if Layout in [blGlyphLeft, blGlyphRight] then
      begin
        Sz := Images.Height + BorderSize * 2;
        if NewHeight < Sz then NewHeight := Sz;
      end;
  end;
end;

function TTBXCustomButton.DoDrawText(ACanvas: TCanvas; var Rect: TRect; Flags: Integer): Integer;
var
  ItemInfo: TTBXItemInfo;
  Text: string;
begin
  Text := GetLabelText;
  if (Flags and DT_CALCRECT <> 0) and ((Text = '') or
    (Text[1] = '&') and (Text[2] = #0)) then Text := Text + ' ';
  Flags := DrawTextBiDiModeFlags(Flags);
  ACanvas.Font := Font;
  AdjustFont(ACanvas.Font);

  if Flags and DT_CALCRECT = DT_CALCRECT then
  begin
    Flags := Flags and not DT_VCENTER;
    Result := DrawText(ACanvas.Handle, PChar(Text), Length(Text), Rect, Flags);
  end
  else
  begin
    GetItemInfo(ItemInfo);
    ACanvas.Font.Color := clNone;
    CurrentTheme.PaintCaption(Canvas, Rect, ItemInfo, Text, Flags, False);
    Flags := Flags or DT_CALCRECT;
    Result := DrawText(ACanvas.Handle, PChar(Text), Length(Text), Rect, Flags);
  end;
end;

function TTBXCustomButton.DoDropDown: Boolean;
begin
  Result := FDropDownMenu <> nil;
  if Result and Assigned(FOnDropDown) then FOnDropDown(Self, Result);
end;

procedure TTBXCustomButton.DoMouseEnter;
begin
  inherited;
  Invalidate;
end;

procedure TTBXCustomButton.DoMouseLeave;
begin
  inherited;
  Invalidate;
end;

function TTBXCustomButton.GetControlsAlignment: TAlignment;
begin
  Result := GetTextAlignment;
end;

function TTBXCustomButton.GetFocusRect(const R: TRect): TRect;
begin
  Result := R;
  InflateRect(Result, -2, -2);
end;

procedure TTBXCustomButton.GetItemInfo(out ItemInfo: TTBXItemInfo);
const
  ViewTypes: array[TButtonStyle] of Integer =
    (VT_TOOLBAR or TVT_EMBEDDED, VT_TOOLBAR);
begin
  FillChar(ItemInfo, SizeOf(ItemInfo), 0);
  ItemInfo.ViewType := ViewTypes[ButtonStyle];
  ItemInfo.Enabled := Enabled;
  ItemInfo.ItemOptions := IO_TOOLBARSTYLE or IO_APPACTIVE;
  ItemInfo.Pushed := Pushed and (MouseInControl or FMenuVisible);
  if FMenuVisible and DropDownCombo then ItemInfo.Pushed := False;
  if FMenuVisible then ItemInfo.IsPopupParent := True;
  ItemInfo.Selected := Checked;
  ItemInfo.IsVertical := False;
  if ArrowVisible and DropDownCombo then ItemInfo.ComboPart := cpCombo;
  if MouseInControl or FMenuVisible then ItemInfo.HoverKind := hkMouseHover;
end;

function TTBXCustomButton.GetTextAlignment: TAlignment;
begin
  Result := FAlignment;
end;

function TTBXCustomButton.GetTextMargins: TRect;
var
  L, Sz: Integer;
  IsSpecialDropDown: Boolean;
begin
  Result := Rect(BorderSize, BorderSize, BorderSize, BorderSize);
  L := Length(GetLabelText);
  if (Images <> nil) and (L > 0) then Sz := GlyphSpacing
  else Sz := 0;
  if Assigned(Images) then with Result do
  case Layout of
    blGlyphLeft: Inc(Left, Images.Width + Sz);
    blGlyphTop: Inc(Top, Images.Height + Sz);
    blGlyphRight: Inc(Right, Images.Width + Sz);
    blGlyphBottom: Inc(Bottom, Images.Height + Sz);
  end;
  if ArrowVisible then
  begin
    if DropDownCombo then Inc(Result.Right, CurrentTheme.SplitBtnArrowWidth)
    else
    begin
      IsSpecialDropDown := (L > 0) and (Images <> nil) and (Layout in [blGlyphTop, blGlyphBottom]);
      if not IsSpecialDropDown then Inc(Result.Right, CurrentTheme.DropDownArrowWidth);
    end;
  end;
end;

procedure TTBXCustomButton.ImageListChange(Sender: TObject);
begin
  if Sender = Images then
  begin
    Invalidate;
    AdjustHeight;
  end;
end;

procedure TTBXCustomButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  R: TRect;
begin
  inherited;
  if Enabled and (Button = mbLeft) then
  begin
    R := ClientRect;
    ApplyMargins(R, Margins);
    FMenuVisible := not FInClick and Assigned(DropDownMenu) and
      (not DropDownCombo or (X >= R.Right - CurrentTheme.SplitBtnArrowWidth));
    try
      if FMenuVisible then
      begin
        ControlState := ControlState - [csClicked];
        if not FInClick then
        begin
          Click;
        end;
      end
      else if Repeating then
      begin
        Click;
        ControlState := ControlState - [csClicked];
        if not Assigned(FRepeatTimer) then FRepeatTimer := TTimer.Create(Self);
        FRepeatTimer.Interval := RepeatDelay;
        FRepeatTimer.OnTimer := RepeatTimerHandler;
        FRepeatTimer.Enabled := True;
      end;
    finally
      FMenuVisible := False;
    end;
  end;
end;

procedure TTBXCustomButton.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if Assigned(FRepeatTimer) and PtInButtonPart(Point(X, Y)) then FRepeatTimer.Enabled := True;
end;

procedure TTBXCustomButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if Button = mbLeft then
  begin
    FRepeatTimer.Free;
    FRepeatTimer := nil;
  end;
end;

procedure TTBXCustomButton.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then
  begin
    if AComponent = Images then Images := nil
    else if AComponent = DropDownMenu then DropDownMenu := nil;
  end;
end;

procedure TTBXCustomButton.Paint;
const
  Alignments: array [TAlignment] of Integer = (DT_LEFT, DT_RIGHT, DT_CENTER);
  WordWraps: array [TTextWrapping] of Integer = (DT_SINGLELINE,
    DT_SINGLELINE or DT_END_ELLIPSIS,
    DT_SINGLELINE or DT_PATH_ELLIPSIS, DT_WORDBREAK);
  ShowAccelChars: array [Boolean] of Integer = (DT_NOPREFIX, 0);
var
  CR, IR, TR: TRect;
  W, X: Integer;
  Text: string;
  ItemInfo: TTBXItemInfo;
  RealAlignment: TAlignment;
  CaptionHeight: Integer;
  DrawStyle: Cardinal;
  ShowArrow: Boolean;
begin
  CR := ClientRect;
  ApplyMargins(CR, Margins);

  ShowArrow := ArrowVisible;
  GetItemInfo(ItemInfo);
  if ShowArrow and DropDownCombo then
  begin
    TR := CR;
    TR.Left := TR.Right - CurrentTheme.SplitBtnArrowWidth;
    CR.Right := TR.Left;

    ItemInfo.ComboPart := cpSplitRight;
    ItemInfo.Pushed := FMenuVisible;
    CurrentTheme.PaintButton(Canvas, TR, ItemInfo);

    ItemInfo.ComboPart := cpSplitLeft;
    ItemInfo.Pushed := Pushed and not FMenuVisible;
    CurrentTheme.PaintButton(Canvas, CR, ItemInfo);
  end
  else CurrentTheme.PaintButton(Canvas, CR, ItemInfo);
  if Focused and FShowFocusRect then DrawFocusRect2(Canvas, GetFocusRect(CR));
  InflateRect(CR, -BorderSize, -BorderSize);

  if ShowArrow and not DropDownCombo then
  begin
    TR := CR;
    TR.Left := TR.Right - CurrentTheme.DropdownArrowWidth;
    CurrentTheme.PaintDropDownArrow(Canvas, TR, ItemInfo);
    CR.Right := TR.Left - CurrentTheme.DropdownArrowMargin;
  end;

  Text := GetLabelText;
  DrawStyle := 0;

  if (Length(Text) > 0) or (Images <> nil) then
  begin
    RealAlignment := GetRealAlignment(Self);

    if Length(Text) = 0 then
    begin
      IR.Top := (CR.Top + CR.Bottom - Images.Height) div 2;
      IR.Bottom := IR.Top + Images.Height;

      case RealAlignment of
        taLeftJustify: IR.Left := CR.Left;
        taRightJustify: IR.Left := CR.Right - Images.Width;
      else
        IR.Left := (CR.Left + CR.Right - Images.Width) div 2;
      end;
      IR.Right := IR.Left + Images.Width;
    end
    else
    begin
      TR := CR;
      DrawStyle := DT_EXPANDTABS or WordWraps[Wrapping] or
        Alignments[RealAlignment] or ShowAccelChars[ShowAccelChar];
      if (Images = nil) or (Layout in [blGlyphTop, blGlyphBottom]) then
      begin
        CaptionHeight := DoDrawText(Canvas, TR, DrawStyle or DT_CALCRECT);
        TR := CR;
        if Images = nil then
        begin
          TR.Top := (TR.Top + TR.Bottom - CaptionHeight) div 2;
        end
        else
        begin
          TR.Top := (CR.Top + CR.Bottom - Images.Height - GlyphSpacing - CaptionHeight) div 2;
          IR.Top := TR.Top;
          if Layout = blGlyphTop then Inc(TR.Top, Images.Height + GlyphSpacing)
          else Inc(IR.Top, CaptionHeight + GlyphSpacing);
          TR.Bottom := TR.Top + CaptionHeight;
          IR.Bottom := IR.Top + Images.Height;
          case RealAlignment of
            taLeftJustify: IR.Left := CR.Left;
            taRightJustify: IR.Left := CR.Right - Images.Width;
          else
            IR.Left := (CR.Left + CR.Right - Images.Width) div 2;
          end;
          IR.Right := IR.Left + Images.Width;
        end;
      end
      else
      begin
        IR.Left := CR.Left;
        if Layout = blGlyphLeft then Inc(TR.Left, Images.Width + GlyphSpacing)
        else Dec(TR.Right, Images.Width + GlyphSpacing);
        IR.Right := IR.Left + Images.Width;
        IR.Top := (CR.Top + CR.Bottom - Images.Height) div 2;
        IR.Bottom := IR.Top + Images.Height;
        CaptionHeight := DoDrawText(Canvas, TR, DrawStyle or DT_CALCRECT);
        TR.Top := (CR.Top + CR.Bottom - CaptionHeight) div 2;
        TR.Bottom := TR.Top + CaptionHeight;
        W := Images.Width + GlyphSpacing + TR.Right - TR.Left;
        case RealAlignment of
          taLeftJustify: X := CR.Left;
          taRightJustify: X := CR.Right - W;
        else
          X := (CR.Left + CR.Right - W) div 2;
        end;
        case Layout of
          blGlyphLeft:
            begin
              if X < CR.Left then X := CR.Left;
              IR.Left := X;
              IR.Right := X + Images.Width;
              OffsetRect(TR, IR.Right + GlyphSpacing - TR.Left, 0);
              if TR.Right > CR.Right then TR.Right := CR.Right;
              DrawStyle := DrawStyle and not DT_RIGHT and not DT_CENTER or DT_LEFT;
            end;
          blGlyphRight:
            begin
              OffsetRect(TR, X - TR.Left, 0);
              IR.Left := TR.Right + GlyphSpacing;
              IR.Right := IR.Left + Images.Width;
              DrawStyle := DrawStyle and not DT_CENTER and not DT_LEFT or DT_RIGHT;
            end;
        end;
      end;
    end;

    if Assigned(Images) and (ImageIndex >= 0) and (ImageIndex < Images.Count) then
      CurrentTheme.PaintImage(Canvas, IR, ItemInfo, Images, ImageIndex);

    if Length(Text) > 0 then
    begin
      Brush.Style := bsClear;
      DoDrawText(Canvas, TR, DrawStyle);
      Brush.Style := bsSolid;
    end;
  end;
end;

function TTBXCustomButton.PtInButtonPart(const Pt: TPoint): Boolean;
var
  R: TRect;
begin
  R := ClientRect;
  ApplyMargins(R, Margins);
  Result := PtInRect(R, Pt);
end;

procedure TTBXCustomButton.RepeatTimerHandler(Sender: TObject);
var
  P: TPoint;
begin
  FRepeatTimer.Interval := RepeatInterval;
  GetCursorPos(P);
  P := ScreenToClient(P);
  if not MouseCapture then
  begin
    FRepeatTimer.Free;
    FRepeatTimer := nil;
  end
  else if Repeating and Pushed and PtInButtonPart(P) then Click
  else FRepeatTimer.Enabled := False;
end;

procedure TTBXCustomButton.SetAlignment(Value: TAlignment);
begin
  FAlignment := Value;
  Invalidate;
end;

procedure TTBXCustomButton.SetAllowAllUnchecked(Value: Boolean);
begin
  if FAllowAllUnchecked <> Value then
  begin
    FAllowAllUnchecked := Value;
    UpdateCheckedState;
  end;
end;

procedure TTBXCustomButton.SetBorderSize(Value: Integer);
begin
  FBorderSize := Value;
  Invalidate;
  AdjustHeight;
end;

procedure TTBXCustomButton.SetButtonStyle(Value: TButtonStyle);
begin
  FButtonStyle := Value;
  Invalidate;
end;

procedure TTBXCustomButton.SetChecked(Value: Boolean);
begin
  if FGroupIndex = 0 then Value := False;
  if FChecked <> Value then
  begin
    if FChecked and not AllowAllUnchecked then Exit;
    FChecked := Value;
    Invalidate;
    if Value then UpdateCheckedState;
  end;
end;

procedure TTBXCustomButton.SetDropDownCombo(Value: Boolean);
begin
  FDropDownCombo := Value;
  Invalidate;
end;

procedure TTBXCustomButton.SetDropDownMenu(Value: TPopupMenu);
begin
  if FDropDownMenu <> Value then
  begin
    if FDropDownMenu <> nil then RemoveFreeNotification(FDropDownMenu);
    FDropDownMenu := Value;
    if FDropDownMenu <> nil then FreeNotification(FDropDownMenu);
    Invalidate;
  end;
end;

procedure TTBXCustomButton.SetGlyphSpacing(Value: Integer);
begin
  FGlyphSpacing := Value;
  Invalidate;
  AdjustHeight;
end;

procedure TTBXCustomButton.SetGroupIndex(Value: Integer);
begin
  if FGroupIndex <> Value then
  begin
    FGroupIndex := Value;
    UpdateCheckedState;
  end;
end;

procedure TTBXCustomButton.SetImageIndex(Value: TImageIndex);
begin
  if FImageIndex <> Value then
  begin
    FImageIndex := Value;
    if Assigned(Images) then Invalidate;
  end;
end;

procedure TTBXCustomButton.SetImages(Value: TCustomImageList);
begin
  if FImages <> nil then FImages.UnRegisterChanges(FImageChangeLink);
  FImages := Value;
  if FImages <> nil then
  begin
    FImages.RegisterChanges(FImageChangeLink);
    FImages.FreeNotification(Self);
  end;
  Invalidate;
  AdjustHeight;
end;

procedure TTBXCustomButton.SetLayout(Value: TButtonLayout);
begin
  FLayout := Value;
  Invalidate;
  AdjustHeight;
end;

procedure TTBXCustomButton.UpdateCheckedState;
var
  I: Integer;
  C: TControl;
begin
  if (FGroupIndex <> 0) and (Parent <> nil) then with Parent do
    for I := 0 to ControlCount - 1 do
    begin
      C := Controls[I];
      if (C <> Self) and (C is TTBXCustomButton) then
        with TTBXCustomButton(C) do
          if FGroupIndex = Self.FGroupIndex then
          begin
            if Self.Checked and FChecked then
            begin
              FChecked := False;
              Invalidate;
            end;
            FAllowAllUnchecked := Self.AllowAllUnchecked;
          end;
    end;
end;

procedure TTBXCustomButton.WMCancelMode(var Message: TWMCancelMode);
begin
  FRepeatTimer.Free;
  FRepeatTimer := nil;
  MouseLeft;
end;

procedure TTBXCustomButton.WMLButtonDblClk(var Message: TWMLButtonDblClk);
begin
  Perform(WM_LBUTTONDOWN, Message.Keys, Longint(Message.Pos));
  DblClick;
end;

//----------------------------------------------------------------------------//

procedure TTBXCustomButton.WMNCHitTest(var Message: TWMNCHitTest);
var
  P: TPoint;
  R: TRect;
begin
  inherited;
  if not (csDesigning in ComponentState) then
  begin
    P := ScreenToClient(SmallPointToPoint(Message.Pos));
    R := ClientRect;
    ApplyMargins(R, Margins);
    if not PtInRect(R, P) then Message.Result := HTTRANSPARENT;
  end;
end;

{ TTBXAlignmentPanel }

procedure TTBXAlignmentPanel.AdjustClientRect(var Rect: TRect);
begin
  inherited AdjustClientRect(Rect);
  with Margins do
  begin
    Inc(Rect.Left, Left);
    Inc(Rect.Top, Top);
    Dec(Rect.Right, Right);
    Dec(Rect.Bottom, Bottom);
  end;
end;

constructor TTBXAlignmentPanel.Create(AOwner: TComponent);
begin
  inherited;
  FMargins := TTBXControlMargins.Create;
  FMargins.OnChange := MarginsChangeHandler;
end;

destructor TTBXAlignmentPanel.Destroy;
begin
  FMargins.Free;
  inherited;
end;

function TTBXAlignmentPanel.GetMinHeight: Integer;
var
  I: Integer;
  Control: TControl;
begin
  Result := 0;
  for I := 0 to ControlCount - 1 do
  begin
    Control := Controls[I];
    if Control.Visible then
      if Control.Align in [alTop, alBottom] then Inc(Result, Control.Height)
      else if Control.Align = alClient then Inc(Result, GetMinControlHeight(Control));
  end;
  Inc(Result, Margins.Top + Margins.Bottom);
end;

function TTBXAlignmentPanel.GetMinWidth: Integer;
var
  I: Integer;
  Control: TControl;
begin
  Result := 0;
  for I := 0 to ControlCount - 1 do
  begin
    Control := Controls[I];
    if Control.Visible then
      if Control.Align in [alLeft, alRight] then Inc(Result, Control.Width)
      else if Control.Align = alClient then Inc(Result, GetMinControlWidth(Control));
  end;
  Inc(Result, Margins.Left + Margins.Right);
end;

procedure TTBXAlignmentPanel.MarginsChangeHandler(Sender: TObject);
begin
  Realign;
  Invalidate;
end;

procedure TTBXAlignmentPanel.Paint;
var
  R: TRect;
  DC: HDC;
begin
  if csDesigning in ComponentState then
  begin
    DC := Canvas.Handle;
    R := ClientRect;
    SaveDC(DC);
    InflateRect(R, -1, -1);
    with R do ExcludeClipRect(DC, Left, Top, Right, Bottom);
    InflateRect(R, 1, 1);
    DitherRect(DC, R, clBtnFace, clBtnShadow);
    RestoreDC(DC, -1);
  end;
end;

procedure TTBXAlignmentPanel.SetMargins(Value: TTBXControlMargins);
begin
  FMargins.Assign(Value);
end;

//----------------------------------------------------------------------------//

{ TTBXCustomPageScroller }

procedure TTBXCustomPageScroller.AdjustClientRect(var Rect: TRect);
begin
  if Orientation = tpsoVertical then
  begin
    if tpsbPrev in FVisibleButtons then Dec(Rect.Top, ButtonSize);
    if tpsbNext in FVisibleButtons then Inc(Rect.Bottom, ButtonSize);
    OffsetRect(Rect, 0, -Position);
    if Range > Rect.Bottom - Rect.Top then Rect.Bottom := Rect.Top + Range;
  end
  else
  begin
    if tpsbPrev in FVisibleButtons then Dec(Rect.Left, ButtonSize);
    if tpsbNext in FVisibleButtons then Inc(Rect.Right, ButtonSize);
    OffsetRect(Rect, -Position, 0);
    if Range > Rect.Right - Rect.Left then Rect.Right := Rect.Left + Range;
  end;
end;

procedure TTBXCustomPageScroller.AlignControls(AControl: TControl; var ARect: TRect);
begin
  CalcAutoRange;
  UpdateButtons;
  ARect := ClientRect;
  inherited AlignControls(AControl, ARect);
end;

function TTBXCustomPageScroller.AutoScrollEnabled: Boolean;
begin
  Result := not AutoSize and not (DockSite and UseDockManager);
end;

procedure TTBXCustomPageScroller.BeginScrolling(HitTest: Integer);
var
  Msg: TMsg;
begin
  if HitTest = HTSCROLLPREV then FScrollDirection := -1 else FScrollDirection := 1;
  try
    SetCapture(Handle);
    FScrollCounter := FScrollDirection * 8;
    FScrollPending := True;
    FScrollTimer.Enabled := True;
    DrawNCArea(False, 0, 0);
    HandleScrollTimer;
    FScrollPending := True;
    FScrollTimer.Interval := ScrollDelay;

    while GetCapture = Handle do
    begin
      case Integer(GetMessage(Msg, 0, 0, 0)) of
        -1: Break;
        0: begin
             PostQuitMessage(Msg.WParam);
             Break;
           end;
      end;
      case Msg.Message of
        WM_KEYDOWN, WM_KEYUP: if Msg.WParam = VK_ESCAPE then Break;
        WM_LBUTTONDOWN, WM_LBUTTONDBLCLK: begin
            Break;
          end;
        WM_LBUTTONUP:
          begin
            Break;
          end;
        WM_RBUTTONDOWN..WM_MBUTTONDBLCLK:;
        WM_TIMER:
          begin
            HandleScrollTimer;
          end;
      else
        TranslateMessage(Msg);
        DispatchMessage(Msg);
      end;
    end;
  finally
    StopScrolling;
    if GetCapture = Handle then ReleaseCapture;
  end;
end;

procedure TTBXCustomPageScroller.CalcAutoRange;
var
  I: Integer;
  Bias: Integer;
  NewRange, AlignMargin: Integer;
  CW, CH: Integer;
  Control: TControl;
begin
  if (FAutoRangeCount <= 0) and AutoRange then
  begin
    if AutoScrollEnabled then
    begin
      NewRange := 0;
      AlignMargin := 0;
      if Position > 0 then Bias := ButtonSize
      else Bias := 0;
      CW := ClientWidth;
      CH := ClientHeight;
      DisableAlign;
      for I := 0 to ControlCount - 1 do
      begin
        Control := Controls[I];
        if Control.Visible or (csDesigning in Control.ComponentState) and
          not (csNoDesignVisible in Control.ControlStyle) then
        begin
          if Orientation = tpsoVertical then
          begin
            if Control.Align in [alTop, alBottom, alClient] then
              Control.Width := CW;
            case Control.Align of
              alTop, alNone:
                if (Control.Align = alTop) or (Control.Anchors * [akTop, akBottom] = [akTop]) then
                  NewRange := Max(NewRange, Position + Control.Top + Control.Height + Bias);
              alBottom: Inc(AlignMargin, Control.Height);
              alClient: Inc(AlignMargin, GetMinControlHeight(Control));
            end
          end
          else
          begin
            if Control.Align in [alLeft, alRight, alClient] then
              Control.Height := CH;
            case Control.Align of
              alLeft, alNone:
                if (Control.Align = alLeft) or (Control.Anchors * [akLeft, akRight] = [akLeft]) then
                  NewRange := Max(NewRange, Position + Control.Left + Control.Width + Bias);
              alRight: Inc(AlignMargin, Control.Width);
              alClient: Inc(AlignMargin, GetMinControlWidth(Control));
            end;
          end;
        end;
      end;
      EnableAlign;
      DoSetRange(NewRange + AlignMargin + Margin);
    end
    else DoSetRange(0);
  end;
end;

function TTBXCustomPageScroller.CalcClientArea: TRect;
begin
  Result := ClientRect;
  if Orientation = tpsoVertical then
  begin
    if tpsbPrev in FVisibleButtons then Dec(Result.Top, ButtonSize);
    if tpsbNext in FVisibleButtons then Inc(Result.Bottom, ButtonSize);
  end
  else
  begin
    if tpsbPrev in FVisibleButtons then Dec(Result.Left, ButtonSize);
    if tpsbNext in FVisibleButtons then Inc(Result.Right, ButtonSize);
  end;
end;

function TTBXCustomPageScroller.CanAutoSize(var NewWidth, NewHeight: Integer): Boolean;
begin
  Result := NewHeight > FButtonSize * 3;
end;

procedure TTBXCustomPageScroller.CMParentColorChanged(var Message: TMessage);
begin
  if Message.WParam = 0 then
  begin
    Message.WParam := 1;
    Message.LParam := GetEffectiveColor(Parent);
  end;
  inherited;
end;

procedure TTBXCustomPageScroller.ConstrainedResize(var MinWidth, MinHeight, MaxWidth, MaxHeight: Integer);
begin
  // do not call inherited here
end;

constructor TTBXCustomPageScroller.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := ControlStyle + [csAcceptsControls, csClickEvents, csDoubleClicks];
  DoubleBuffered := True;
  FAutoScroll := True;
  FButtonSize := 10;
  FScrollTimer := TTimer.Create(Self);
  FScrollTimer.Enabled := False;
  FScrollTimer.Interval := 60;
  FScrollTimer.OnTimer := ScrollTimerTimer;
  Width := 64;
  Height := 64;
end;

procedure TTBXCustomPageScroller.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params.WindowClass do style := style and not (CS_HREDRAW or CS_VREDRAW);
end;

procedure TTBXCustomPageScroller.DisableAutoRange;
begin
  Inc(FAutoRangeCount);
end;

procedure TTBXCustomPageScroller.DoSetRange(Value: Integer);
begin
  FRange := Value;
  if FRange < 0 then FRange := 0;
  UpdateButtons;
end;

procedure TTBXCustomPageScroller.DrawNCArea(const DrawToDC: Boolean;
  const ADC: HDC; const Clip: HRGN);
const
  CBtns: array [TTBXPageScrollerOrientation, Boolean] of Integer =
    ((PSBT_UP, PSBT_DOWN), (PSBT_LEFT, PSBT_RIGHT));
var
  DC: HDC;
  R, CR, BR: TRect;
  ACanvas: TCanvas;
  PrevBtnSize, NextBtnSize: Integer;
begin
  if FVisibleButtons = [] then Exit;
  if not DrawToDC then DC := GetWindowDC(Handle)
  else DC := ADC;
  try
    GetWindowRect(Handle, R);
    OffsetRect(R, -R.Left, -R.Top);
    if not DrawToDC then
    begin
      SelectNCUpdateRgn(Handle, DC, Clip);
      CR := R;
      PrevBtnSize := 0;
      NextBtnSize := 0;
      if tpsbPrev in FVisibleButtons then PrevBtnSize := ButtonSize;
      if tpsbNext in FVisibleButtons then NextBtnSize := ButtonSize;
      if Orientation = tpsoVertical then
      begin
        Inc(CR.Top, PrevBtnSize);
        Dec(CR.Bottom, NextBtnSize);
      end
      else
      begin
        Inc(CR.Left, PrevBtnSize);
        Dec(CR.Right, NextBtnSize);
      end;
      with CR do ExcludeClipRect(DC, Left, Top, Right, Bottom);
    end;

    ACanvas := TCanvas.Create;
    try
      ACanvas.Handle := DC;
      ACanvas.Brush.Color := Color;
      ACanvas.FillRect(R);

      if tpsbPrev in FVisibleButtons then
      begin
        BR := R;
        if Orientation = tpsoVertical then BR.Bottom := BR.Top + ButtonSize
        else BR.Right := BR.Left + ButtonSize;
        CurrentTheme.PaintPageScrollButton(ACanvas, BR, CBtns[Orientation, False],
          FScrollDirection < 0);
      end;
      if tpsbNext in FVisibleButtons then
      begin
        BR := R;
        if Orientation = tpsoVertical then BR.Top := BR.Bottom - ButtonSize
        else BR.Left := BR.Right - ButtonSize;
        CurrentTheme.PaintPageScrollButton(ACanvas, BR, CBtns[Orientation, True],
          FScrollDirection > 0);
      end;
    finally
      ACanvas.Handle := 0;
      ACanvas.Free;
    end;
  finally
    if not DrawToDC then ReleaseDC(Handle, DC);
  end;
end;

procedure TTBXCustomPageScroller.EnableAutoRange;
begin
  if FAutoRangeCount > 0 then
  begin
    Dec(FAutoRangeCount);
    if FAutoRangeCount = 0 then CalcAutoRange;
  end;
end;

procedure TTBXCustomPageScroller.HandleScrollTimer;
var
  Pt: TPoint;
  R: TRect;
  OldPosition: Integer;
  OldDirection: Integer;
begin
  GetCursorPos(Pt);
  GetWindowRect(Handle, R);
  if not PtInRect(R, Pt) then
  begin
    StopScrolling;
  end
  else if FScrollDirection = 0 then
  begin
    FScrollTimer.Enabled := False;
    FScrollCounter := 0;
  end
  else
  begin
    OldPosition := Position;
    OldDirection := FScrollDirection;
    if ((FScrollDirection > 0) and (FScrollCounter < 0)) or
      ((FScrollDirection < 0) and (FScrollCounter > 0)) then FScrollCounter := 0;
    if FScrollDirection > 0 then Inc(FScrollCounter)
    else Dec(FScrollCounter);
    Position := Position + FScrollCounter;
    if Position = OldPosition then
    begin
      ReleaseCapture;
      FScrollTimer.Enabled := False;
      DrawNCArea(False, 0, 0);
    end
    else
    begin
      if FScrollPending or (FScrollDirection * OldDirection <= 0) or
        (FScrollDirection * OldDirection <= 0) then
        DrawNCArea(False, 0, 0);
    end;
  end;
  if FScrollPending then FScrollTimer.Interval := ScrollInterval;
  FScrollPending := False;
end;

function TTBXCustomPageScroller.IsRangeStored: Boolean;
begin
  Result := not AutoRange;
end;

procedure TTBXCustomPageScroller.Loaded;
begin
  inherited;
  UpdateButtons;
end;

procedure TTBXCustomPageScroller.RecalcNCArea;
begin
  SetWindowPos(Handle, 0, 0, 0, 0, 0,
    SWP_FRAMECHANGED or SWP_NOACTIVATE or SWP_NOZORDER or SWP_NOMOVE or SWP_NOSIZE);
end;

procedure TTBXCustomPageScroller.Resizing;
begin
  // do nothing by default
end;

procedure TTBXCustomPageScroller.ScrollTimerTimer(Sender: TObject);
begin
  HandleScrollTimer;
end;

procedure TTBXCustomPageScroller.ScrollToCenter(ARect: TRect);
var
  X, Y: Integer;
begin
  if Orientation = tpsoVertical then
  begin
    if ARect.Bottom - ARect.Top < Range then Y := (ARect.Top + ARect.Bottom) div 2
    else Y := ARect.Top;
    Position := Position + Y - Height div 2;
  end
  else
  begin
    if ARect.Right - ARect.Left < Range then X := (ARect.Left + ARect.Right) div 2
    else X := ARect.Left;
    Position := Position + X - Width div 2;
  end;
end;

procedure TTBXCustomPageScroller.ScrollToCenter(AControl: TControl);
var
  R: TRect;
begin
  R := AControl.ClientRect;
  R.TopLeft := ScreenToClient(AControl.ClientToScreen(R.TopLeft));
  R.BottomRight := ScreenToClient(AControl.ClientToScreen(R.BottomRight));
  ScrollToCenter(R);
end;

procedure TTBXCustomPageScroller.SetAutoRange(Value: Boolean);
begin
  if FAutoRange <> Value then
  begin
    FAutoRange := Value;
    if Value then CalcAutoRange else Range := 0;
  end;
end;

procedure TTBXCustomPageScroller.SetButtonSize(Value: Integer);
begin
  if FButtonSize <> Value then
  begin
    FButtonSize := Value;
    UpdateButtons;
  end;
end;

procedure TTBXCustomPageScroller.SetOrientation(Value: TTBXPageScrollerOrientation);
begin
  if Orientation <> Value then
  begin
    FOrientation := Value;
    Realign;
  end;
end;

procedure TTBXCustomPageScroller.SetPosition(Value: Integer);
var
  OldPos: Integer;
begin
  if csReading in ComponentState then FPosition := Value
  else
  begin
    ValidatePosition(Value);
    if FPosition <> Value then
    begin
      OldPos := FPosition;
      FPosition := Value;

      if OldPos > 0 then Inc(OldPos, ButtonSize);
      if Value > 0 then Inc(Value, ButtonSize);

      if Orientation = tpsoHorizontal then ScrollBy(OldPos - Value, 0)
      else ScrollBy(0, OldPos - Value);
      UpdateButtons;
    end;
  end;
end;

procedure TTBXCustomPageScroller.SetRange(Value: Integer);
begin
  FAutoRange := False;
  DoSetRange(Value);
end;

procedure TTBXCustomPageScroller.StopScrolling;
begin
  if (FScrollDirection <> 0) or (FScrollCounter <> 0) or (FScrollTimer.Enabled) then
  begin
    FScrollDirection := 0;
    FScrollCounter := 0;
    FScrollTimer.Enabled := False;
    if HandleAllocated and IsWindowVisible(Handle) then DrawNCArea(False, 0, 0);
  end;
end;

procedure TTBXCustomPageScroller.UpdateButtons;
var
  Sz: Integer;
  OldVisibleButtons: TTBXPageScrollerButtons;
  RealignNeeded: Boolean;
begin
  RealignNeeded := False;
  if not FUpdatingButtons and HandleAllocated then
  try
    FUpdatingButtons := True;
    if Orientation = tpsoHorizontal then Sz := Width
    else Sz := Height;
    OldVisibleButtons := FVisibleButtons;
    FVisibleButtons := [];

    FPosRange := Range - Sz;
    if FPosRange < 0 then FPosRange := 0;
    if FPosition > FPosRange - 1 then
    begin
      FPosition := FPosRange;
      RealignNeeded := True;
    end;

    if Sz > ButtonSize * 3 then
    begin
      if Position > 0 then Include(FVisibleButtons, tpsbPrev);
      if Range - Position > Sz then Include(FVisibleButtons, tpsbNext);
    end;
    if FVisibleButtons <> OldVisibleButtons then
    begin
      RecalcNCArea;
      RealignNeeded := True;
    end;
  finally
    FUpdatingButtons := False;
    if RealignNeeded then Realign;
  end;
end;

procedure TTBXCustomPageScroller.ValidatePosition(var NewPos: Integer);
begin
  if NewPos < 0 then NewPos := 0;
  if NewPos > FPosRange then NewPos := FPosRange;
end;

procedure TTBXCustomPageScroller.WMEraseBkgnd(var Message: TWmEraseBkgnd);
begin
  if Color = clNone then DrawParentBackground(Self, Message.DC, ClientRect)
  else FillRectEx(Message.DC, ClientRect, Color);
  Message.Result := 1;
end;

procedure TTBXCustomPageScroller.WMMouseMove(var Message: TWMMouseMove);
begin
  if AutoScroll then StopScrolling;
  inherited;
end;

procedure TTBXCustomPageScroller.WMNCCalcSize(var Message: TWMNCCalcSize);
begin
  with Message.CalcSize_Params^ do
  begin
    if Orientation = tpsoVertical then
    begin
      if tpsbPrev in FVisibleButtons then Inc(rgrc[0].Top, ButtonSize);
      if tpsbNext in FVisibleButtons then Dec(rgrc[0].Bottom, ButtonSize);
    end
    else
    begin
      if tpsbPrev in FVisibleButtons then Inc(rgrc[0].Left, ButtonSize);
      if tpsbNext in FVisibleButtons then Dec(rgrc[0].Right, ButtonSize);
    end;
    Message.Result := 0;
  end;
end;

procedure TTBXCustomPageScroller.WMNCHitTest(var Message: TWMNCHitTest);
var
  Pt: TPoint;
  R: TRect;
begin
  DefaultHandler(Message);
  with Message do if Result <> HTCLIENT then
  begin
    Pt := SmallPointToPoint(Pos);
    GetWindowRect(Handle, R);
    if PtInRect(R, Pt) then
    begin
      if (tpsbPrev in FVisibleButtons) then
      begin
        if Orientation = tpsoVertical then
        begin
          if Pt.Y < R.Top + ButtonSize then Result := HTSCROLLPREV
        end
        else
        begin
          if Pt.X < R.Left + ButtonSize then Result := HTSCROLLPREV
        end;
      end;
      if (tpsbNext in FVisibleButtons) then
      begin
        if Orientation = tpsoVertical then
        begin
          if Pt.Y >= R.Bottom - ButtonSize then Result := HTSCROLLNEXT;
        end
        else
        begin
          if Pt.X >= R.Right - ButtonSize then Result := HTSCROLLNEXT;
        end;
      end;
    end;
  end;
end;

procedure TTBXCustomPageScroller.WMNCLButtonDown(var Message: TWMNCLButtonDown);
begin
  if (Win32MajorVersion >= 5) or
     (Win32MajorVersion = 4) and (Win32MinorVersion >= 10) then
    CallTrackMouseEvent(Handle, TME_LEAVE or $10 {TME_NONCLIENT});

  if not AutoScroll and (Message.HitTest in [HTSCROLLPREV, HTSCROLLNEXT]) then
    BeginScrolling(Message.HitTest)
  else
    inherited;
end;

procedure TTBXCustomPageScroller.WMNCMouseLeave(var Message: TMessage);
begin
  if AutoScroll then StopScrolling;
  inherited;
end;

procedure TTBXCustomPageScroller.WMNCMouseMove(var Message: TWMNCMouseMove);
var
  OldScrollDirection: Integer;
begin
  if (Win32MajorVersion >= 5) or
     (Win32MajorVersion = 4) and (Win32MinorVersion >= 10) then
    CallTrackMouseEvent(Handle, TME_LEAVE or $10 {TME_NONCLIENT});

  if AutoScroll then
  begin
    OldScrollDirection := FScrollDirection;
    case Message.HitTest of
      HTSCROLLPREV: FScrollDirection := -1;
      HTSCROLLNEXT: FScrollDirection := 1;
    else
      StopScrolling;
      inherited;
      Exit;
    end;
    if OldScrollDirection <> FScrollDirection then
    begin
      FScrollCounter := 0;
      FScrollPending := True;
      FScrollTimer.Interval := ScrollDelay;
      FScrollTimer.Enabled := True;
      DrawNCArea(False, 0, 0);
    end;
  end;
end;

procedure TTBXCustomPageScroller.WMNCPaint(var Message: TMessage);
begin
  DrawNCArea(False, 0, HRGN(Message.WParam));
end;

procedure TTBXCustomPageScroller.WMSize(var Message: TWMSize);
begin
  FUpdatingButtons := True;
  try
    CalcAutoRange;
  finally
    FUpdatingButtons := False;
  end;
  Inc(FAutoRangeCount);
  inherited;
  Resizing;
  Dec(FAutoRangeCount);
end;

{ TTBXCustomCheckBox }

procedure TTBXCustomCheckBox.Click;
begin
  Toggle;
  Invalidate;
  inherited;
end;

procedure TTBXCustomCheckBox.CMDialogChar(var Message: TCMDialogChar);
begin
  with Message do
    if Enabled and ShowAccelChar and IsAccel(CharCode, GetLabelText) and CanFocus and Visible then
    begin
      Click;
      Result := 1;
    end
    else inherited;
end;

procedure TTBXCustomCheckBox.CMDialogKey(var Message: TCMDialogKey);
begin
  with Message do
    if (CharCode = VK_RETURN) and Focused and
       (KeyDataToShiftState(Message.KeyData) = []) then
    begin
      Click;
      Result := 1;
    end
    else inherited;
end;

procedure TTBXCustomCheckBox.CNCommand(var Message: TWMCommand);
begin
  if Message.NotifyCode = BN_CLICKED then Toggle;
end;

constructor TTBXCustomCheckBox.Create(AOwner: TComponent);
begin
  inherited;
  SmartFocus := True;
  SpaceAsClick := True;
  TabStop := True;
end;

procedure TTBXCustomCheckBox.DoAdjustHeight(ACanvas: TCanvas; var NewHeight: Integer);
begin
  inherited DoAdjustHeight(ACanvas, NewHeight);
  if NewHeight < GetGlyphSize + 4 then NewHeight := GetGlyphSize + 4;
end;

procedure TTBXCustomCheckBox.DoChange;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TTBXCustomCheckBox.DoMouseEnter;
begin
  inherited;
  Invalidate;
end;

procedure TTBXCustomCheckBox.DoMouseLeave;
begin
  inherited;
  Invalidate;
end;

function TTBXCustomCheckBox.DoSetState(var NewState: TCheckBoxState): Boolean;
begin
  Result := True;
end;

function TTBXCustomCheckBox.GetChecked: Boolean;
begin
  Result := State = cbChecked;
end;

function TTBXCustomCheckBox.GetFocusRect(const R: TRect): TRect;
const
  Alignments: array [TLeftRight] of Word = (DT_LEFT, DT_RIGHT);
  WordWraps: array [TTextWrapping] of Integer = (DT_SINGLELINE or DT_VCENTER,
    DT_SINGLELINE or DT_VCENTER or DT_END_ELLIPSIS,
    DT_SINGLELINE or DT_VCENTER or DT_PATH_ELLIPSIS, DT_WORDBREAK);
var
  TR: TRect;
begin
  TR := R;
  ApplyMargins(TR, GetTextMargins);
  DoDrawText(Canvas, TR, (DT_EXPANDTABS or DT_CALCRECT) or WordWraps[Wrapping] or Alignments[Alignment]);
  Result := R;
  Result.Right := TR.Right + 2;
  Result.Left := TR.Left - 2;
end;

function TTBXCustomCheckBox.GetGlyphSize: Integer;
begin
  Result := 13;
end;

function TTBXCustomCheckBox.GetTextAlignment: TAlignment;
begin
  Result := taLeftJustify;
end;

function TTBXCustomCheckBox.GetTextMargins: TRect;
begin
  Result := Rect(2, 2, 2, 2);
  with Result do
    if GetRealAlignment(Self) = taLeftJustify then Inc(Left, GetGlyphSize + 6)
    else Inc(Right, GetGlyphSize + 6);
end;

procedure TTBXCustomCheckBox.Paint;
const
  EnabledState: array [Boolean] of Integer = (PFS_DISABLED, 0);
  StateFlags: array [TCheckBoxState] of Integer = (0, PFS_CHECKED, PFS_MIXED);
  HotState: array [Boolean] of Integer = (0, PFS_HOT);
  PushedState: array [Boolean] of Integer = (0, PFS_PUSHED);
  FocusedState: array [Boolean] of Integer = (0, PFS_FOCUSED);
var
  Rect: TRect;
  Sz, Flags: Integer;
begin
  inherited;
  with Canvas do
  begin
    Rect := ClientRect;
    ApplyMargins(Rect, Margins);
    Sz := GetGlyphSize;
    if Alignment = taLeftJustify then Rect.Right := Rect.Left + GetGlyphSize
    else Rect.Left := Rect.Right - GetGlyphSize;
    Rect.Top := (Rect.Top + Rect.Bottom + 1 - Sz) div 2;
    Rect.Bottom := Rect.Top + Sz;
    Brush.Color := clBtnShadow;
    Flags := EnabledState[Enabled] or StateFlags[State];
    if Enabled then Flags := Flags or HotState[MouseInControl] or
      PushedState[Pushed and MouseInControl] or FocusedState[Focused];
    CurrentTheme.PaintFrameControl(Canvas, Rect, PFC_CHECKBOX, Flags, nil);
  end;
end;

procedure TTBXCustomCheckBox.SetChecked(Value: Boolean);
begin
  if Value then State := cbChecked else State := cbUnchecked;
end;

procedure TTBXCustomCheckBox.SetState(Value: TCheckBoxState);
begin
  if (FState <> Value) and DoSetState(Value) then
  begin
    FState := Value;
    Invalidate;
    DoChange;
  end;
end;

procedure TTBXCustomCheckBox.Toggle;
begin
  case State of
    cbUnchecked: if AllowGrayed then State := cbGrayed else State := cbChecked;
    cbChecked: State := cbUnchecked;
    cbGrayed: State := cbChecked;
  end;
end;

procedure TTBXCustomCheckBox.WMNCHitTest(var Message: TWMNCHitTest);
var
  P: TPoint;
  R: TRect;
  SL, SR: Integer;
begin
  inherited;
  if not (csDesigning in ComponentState) then
  begin
    P := ScreenToClient(SmallPointToPoint(Message.Pos));
    R := ClientRect;
    ApplyMargins(R, Margins);
    SL := R.Left; SR := R.Right;
    R := GetFocusRect(R);
    if GetRealAlignment(Self) = taLeftJustify then R.Left := SL
    else R.Right := SR;
    if not PtInRect(R, P) then Message.Result := HTTRANSPARENT;
  end;
end;

{ TTBXCustomRadioButton }

procedure TTBXCustomRadioButton.Click;
begin
  if not Checked then Checked := True;
  Invalidate;
  inherited;
end;

procedure TTBXCustomRadioButton.CMDialogChar(var Message: TCMDialogChar);
begin
  with Message do
    if Enabled and ShowAccelChar and IsAccel(CharCode, GetLabelText) and CanFocus and Visible then
    begin
      Click;
      Result := 1;
    end
    else inherited;
end;

procedure TTBXCustomRadioButton.CNCommand(var Message: TWMCommand);
begin
  if Message.NotifyCode = BN_CLICKED then Checked := not Checked;
end;

constructor TTBXCustomRadioButton.Create(AOwner: TComponent);
begin
  inherited;
  SmartFocus := True;
  SpaceAsClick := True;
  TabStop := True;
end;

procedure TTBXCustomRadioButton.DoAdjustHeight(ACanvas: TCanvas; var NewHeight: Integer);
begin
  inherited DoAdjustHeight(ACanvas, NewHeight);
  if NewHeight < GetGlyphSize + 4 then NewHeight := GetGlyphSize + 4;
end;

procedure TTBXCustomRadioButton.DoChange;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TTBXCustomRadioButton.DoMouseEnter;
begin
  inherited;
  Invalidate;
end;

procedure TTBXCustomRadioButton.DoMouseLeave;
begin
  inherited;
  Invalidate;
end;

function TTBXCustomRadioButton.DoSetChecked(var Value: Boolean): Boolean;
begin
  Result := True;
end;

function TTBXCustomRadioButton.GetFocusRect(const R: TRect): TRect;
const
  Alignments: array [TLeftRight] of Word = (DT_LEFT, DT_RIGHT);
  WordWraps: array [TTextWrapping] of Integer = (DT_SINGLELINE or DT_VCENTER,
    DT_SINGLELINE or DT_VCENTER or DT_END_ELLIPSIS,
    DT_SINGLELINE or DT_VCENTER or DT_PATH_ELLIPSIS, DT_WORDBREAK);
var
  TR: TRect;
begin
  TR := R;
  ApplyMargins(TR, GetTextMargins);
  DoDrawText(Canvas, TR, (DT_EXPANDTABS or DT_CALCRECT) or WordWraps[Wrapping] or Alignments[Alignment]);
  Result := R;
  Result.Right := TR.Right + 2;
  Result.Left := TR.Left - 2;
end;

function TTBXCustomRadioButton.GetGlyphSize: Integer;
begin
  Result := 13;
end;

function TTBXCustomRadioButton.GetTextAlignment: TAlignment;
begin
  Result := taLeftJustify;
end;

function TTBXCustomRadioButton.GetTextMargins: TRect;
begin
  Result := Rect(2, 2, 2, 2);
  with Result do
    if GetRealAlignment(Self) = taLeftJustify then Inc(Left, GetGlyphSize + 6)
    else Inc(Right, GetGlyphSize + 6);
end;

procedure TTBXCustomRadioButton.Paint;
const
  EnabledState: array [Boolean] of Integer = (PFS_DISABLED, 0);
  CheckedState: array [Boolean] of Integer = (0, PFS_CHECKED);
  HotState: array [Boolean] of Integer = (0, PFS_HOT);
  PushedState: array [Boolean] of Integer = (0, PFS_PUSHED);
  FocusedState: array [Boolean] of Integer = (0, PFS_FOCUSED);
var
  Rect: TRect;
  Sz, Flags: Integer;
begin
  inherited;
  with Canvas do
  begin
    Rect := ClientRect;
    with Margins do
    begin
      Inc(Rect.Left, Left);
      Inc(Rect.Top, Top);
      Dec(Rect.Right, Right);
      Dec(Rect.Bottom, Bottom);
    end;
    Sz := GetGlyphSize;
    if Alignment = taLeftJustify then Rect.Right := Rect.Left + GetGlyphSize
    else Rect.Left := Rect.Right - GetGlyphSize;
    Rect.Top := (Rect.Top + Rect.Bottom + 1 - Sz) div 2;
    Rect.Bottom := Rect.Top + Sz;
    Brush.Color := clBtnShadow;
    Flags := EnabledState[Enabled] or CheckedState[Checked];
    if Enabled then Flags := Flags or HotState[MouseInControl] or
      PushedState[Pushed and MouseInControl] or FocusedState[Focused];
    CurrentTheme.PaintFrameControl(Canvas, Rect, PFC_RADIOBUTTON, Flags, nil);
  end;
end;

procedure TTBXCustomRadioButton.SetChecked(Value: Boolean);
begin
  if (Value <> FChecked) and DoSetChecked(Value) then
  begin
    FChecked := Value;
    TabStop := Value;
    if Value then TurnSiblingsOff;
    Invalidate;
    DoChange;
  end;
end;

procedure TTBXCustomRadioButton.SetGroupIndex(Value: Integer);
begin
  FGroupIndex := Value;
  if Checked then TurnSiblingsOff;
end;

procedure TTBXCustomRadioButton.TurnSiblingsOff;
var
  I: Integer;
  Sibling: TControl;
begin
  if Parent <> nil then
    with Parent do
      for I := 0 to ControlCount - 1 do
      begin
        Sibling := Controls[I];
        if (Sibling <> Self) and (Sibling is TTBXCustomRadioButton) then
          with TTBXCustomRadioButton(Sibling) do
          begin
            if GroupIndex = Self.GroupIndex then SetChecked(False);
          end;
      end;
end;

procedure TTBXCustomRadioButton.WMNCHitTest(var Message: TWMNCHitTest);
var
  P: TPoint;
  R: TRect;
  SL, SR: Integer;
begin
  inherited;
  if not (csDesigning in ComponentState) then
  begin
    P := ScreenToClient(SmallPointToPoint(Message.Pos));
    R := ClientRect;
    ApplyMargins(R, Margins);
    SL := R.Left; SR := R.Right;
    R := GetFocusRect(R);
    if GetRealAlignment(Self) = taLeftJustify then R.Left := SL
    else R.Right := SR;
    if not PtInRect(R, P) then Message.Result := HTTRANSPARENT;
  end;
end;

end.
