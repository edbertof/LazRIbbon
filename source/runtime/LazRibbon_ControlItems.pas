unit LazRibbon_ControlItems;

{$mode delphi}{$H+}

{ LazRibbon native LCL items. Modified LGPL with linking exception;
  see LICENSE.txt. Controls are owned by their item and are recreated from
  the item's published properties, never streamed as extra form components. }

interface

uses
  Classes, SysUtils, Types, Controls, Graphics, StdCtrls, Spin, ComCtrls, Forms, LCLType,
  LazRibbon_BaseItem, LazRibbon_Types, LazRibbon_Math;

type
  TLazRibbonCustomControlItem = class abstract(TLazRibbonBaseItem)
  private
    FControl: TControl;
    FCaption: TCaption;
    FWidth: Integer;
    FLayout: TLazRibbonItemTableBehaviour;
    procedure SetWidth(AValue: Integer);
    procedure SetLayout(AValue: TLazRibbonItemTableBehaviour);
  protected
    function CreateControl: TControl; virtual; abstract;
    procedure SetCaption(const AValue: TCaption); virtual;
    procedure UpdateControl;
    procedure Loaded; override;
    procedure SetRect(const Value: T2DIntRect); override;
    procedure SetEnabled(const Value: Boolean); override;
    procedure SetVisible(const Value: Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetParentComponent(Value: TComponent); override;
    procedure MouseLeave; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Notify(Item: TComponent; Operation: TOperation); override;
    function ExecuteKeyTip: Boolean; override;
    function GetWidth: Integer; override;
    function GetSize: TLazRibbonItemSize; override;
    function GetTableBehaviour: TLazRibbonItemTableBehaviour; override;
    function GetGroupBehaviour: TLazRibbonItemGroupBehaviour; override;
    procedure Draw(ABuffer: TBitmap; ClipRect: T2DIntRect); override;
    property Control: TControl read FControl;
  published
    property Caption: TCaption read FCaption write SetCaption;
    property Width: Integer read FWidth write SetWidth default 120;
    property Layout: TLazRibbonItemTableBehaviour read FLayout write SetLayout default tbBeginsRow;
  end;

  TLazRibbonCustomInputItem = class abstract(TLazRibbonCustomControlItem)
  private
    FOnChange: TNotifyEvent;
  protected
    procedure ControlChange(Sender: TObject);
    procedure DoChange; virtual;
  published
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TLazRibbonEditItem = class(TLazRibbonCustomInputItem)
  private
    function GetText: TCaption;
    procedure SetText(const AValue: TCaption);
    function GetReadOnly: Boolean;
    procedure SetReadOnly(AValue: Boolean);
  protected
    function CreateControl: TControl; override;
  published
    property Text: TCaption read GetText write SetText;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
  end;

  TLazRibbonComboBoxItem = class(TLazRibbonCustomInputItem)
  private
    FChanging: Boolean;
    function IsTextStored: Boolean;
    function GetItems: TStrings;
    procedure SetItems(AValue: TStrings);
    function GetItemIndex: Integer;
    procedure SetItemIndex(AValue: Integer);
    function GetText: TCaption;
    procedure SetText(const AValue: TCaption);
    function GetStyle: TComboBoxStyle;
    procedure SetStyle(AValue: TComboBoxStyle);
  protected
    function CreateControl: TControl; override;
    procedure DoChange; override;
  published
    property Items: TStrings read GetItems write SetItems;
    property Style: TComboBoxStyle read GetStyle write SetStyle default csDropDownList;
    property ItemIndex: Integer read GetItemIndex write SetItemIndex default -1;
    property Text: TCaption read GetText write SetText stored IsTextStored;
  end;

  TLazRibbonSpinEditItem = class(TLazRibbonCustomInputItem)
  private
    function GetValue: Integer;
    procedure SetValue(AValue: Integer);
    function GetMinValue: Integer;
    procedure SetMinValue(AValue: Integer);
    function GetMaxValue: Integer;
    procedure SetMaxValue(AValue: Integer);
    function GetIncrement: Integer;
    procedure SetIncrement(AValue: Integer);
  protected
    function CreateControl: TControl; override;
  published
    property MinValue: Integer read GetMinValue write SetMinValue default 0;
    property MaxValue: Integer read GetMaxValue write SetMaxValue default 100;
    property Increment: Integer read GetIncrement write SetIncrement default 1;
    property Value: Integer read GetValue write SetValue default 0;
  end;

  TLazRibbonFontNameComboBoxItem = class(TLazRibbonCustomInputItem)
  private
    FFontName: TFontName;
    FShowFontPreview: Boolean;
    FUpdatingFonts: Boolean;
    function GetItems: TStrings;
    function GetDropDownCount: Integer;
    procedure SetDropDownCount(AValue: Integer);
    procedure SetFontName(const AValue: TFontName);
    procedure SetShowFontPreview(AValue: Boolean);
    procedure FontSelectionChanged(Sender: TObject);
    procedure DrawFontItem(AControl: TWinControl; AIndex: Integer;
      ARect: TRect; AState: TOwnerDrawState);
  protected
    function CreateControl: TControl; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure RefreshFonts;
    { System-derived options are not persisted in the form resource. }
    property Items: TStrings read GetItems;
  published
    property FontName: TFontName read FFontName write SetFontName;
    property ShowFontPreview: Boolean read FShowFontPreview write SetShowFontPreview default True;
    property DropDownCount: Integer read GetDropDownCount write SetDropDownCount default 12;
  end;

  TLazRibbonStaticTextItem = class(TLazRibbonCustomControlItem)
  private
    function GetAlignment: TAlignment;
    procedure SetAlignment(AValue: TAlignment);
  protected
    function CreateControl: TControl; override;
    procedure SetCaption(const AValue: TCaption); override;
  published
    property Alignment: TAlignment read GetAlignment write SetAlignment default taLeftJustify;
  end;

  TLazRibbonProgressBarItem = class(TLazRibbonCustomControlItem)
  private
    function GetMin: Integer;
    procedure SetMin(AValue: Integer);
    function GetMax: Integer;
    procedure SetMax(AValue: Integer);
    function GetPosition: Integer;
    procedure SetPosition(AValue: Integer);
  protected
    function CreateControl: TControl; override;
  published
    property Min: Integer read GetMin write SetMin default 0;
    property Max: Integer read GetMax write SetMax default 100;
    property Position: Integer read GetPosition write SetPosition default 0;
  end;

implementation

constructor TLazRibbonCustomControlItem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FWidth := 120;
  FLayout := tbBeginsRow;
  FControl := CreateControl;
  FControl.Visible := False;
  FControl.AutoSize := False;
  SetCaption(Copy(ClassName, Length('TLazRibbon') + 1, MaxInt));
end;

destructor TLazRibbonCustomControlItem.Destroy;
begin
  Destroying;
  FreeAndNil(FControl);
  inherited Destroy;
end;

procedure TLazRibbonCustomControlItem.Loaded;
begin
  inherited Loaded;
  UpdateControl;
end;

procedure TLazRibbonCustomControlItem.SetParentComponent(Value: TComponent);
begin
  inherited SetParentComponent(Value);
  UpdateControl;
end;

procedure TLazRibbonCustomControlItem.UpdateControl;
var
  Current: TComponent;
  Host: TWinControl;
  R: TRect;
begin
  if (FControl = nil) or (csDestroying in ComponentState) then Exit;
  Current := Parent;
  while (Current <> nil) and not (Current is TWinControl) do
    if Current is TLazRibbonComponent then
      Current := TLazRibbonComponent(Current).Parent
    else
      Current := Current.Owner;
  Host := TWinControl(Current);
  FControl.Parent := Host;
  R := FRect.ForWinAPI;
  Inc(R.Left, 2);
  Dec(R.Right, 2);
  FControl.Enabled := Enabled;
  FControl.Hint := EffectiveScreenTip;
  FControl.ShowHint := FControl.Hint <> '';
  if (Host = nil) or not Visible or (R.Right <= R.Left) or (R.Bottom <= R.Top) then
  begin
    FControl.Visible := False;
    Exit;
  end;
  FControl.SetBounds(R.Left, R.Top, R.Right - R.Left, R.Bottom - R.Top);
  FControl.Visible := True;
end;

procedure TLazRibbonCustomControlItem.SetRect(const Value: T2DIntRect);
begin
  inherited SetRect(Value);
  UpdateControl;
end;

procedure TLazRibbonCustomControlItem.SetEnabled(const Value: Boolean);
begin
  inherited SetEnabled(Value);
  UpdateControl;
end;

procedure TLazRibbonCustomControlItem.SetVisible(const Value: Boolean);
begin
  inherited SetVisible(Value);
  UpdateControl;
end;

procedure TLazRibbonCustomControlItem.SetCaption(const AValue: TCaption);
begin
  if FCaption = AValue then Exit;
  FCaption := AValue;
  if Assigned(FToolbarDispatch) then FToolbarDispatch.NotifyVisualsChanged;
end;

procedure TLazRibbonCustomControlItem.SetWidth(AValue: Integer);
begin
  if AValue < 24 then AValue := 24;
  if FWidth = AValue then Exit;
  FWidth := AValue;
  if Assigned(FToolbarDispatch) then FToolbarDispatch.NotifyMetricsChanged;
end;

procedure TLazRibbonCustomControlItem.SetLayout(AValue: TLazRibbonItemTableBehaviour);
begin
  if FLayout = AValue then Exit;
  FLayout := AValue;
  if Assigned(FToolbarDispatch) then FToolbarDispatch.NotifyMetricsChanged;
end;

function TLazRibbonCustomControlItem.GetWidth: Integer;
begin
  Result := FWidth;
end;

function TLazRibbonCustomControlItem.GetSize: TLazRibbonItemSize;
begin
  Result := isNormal;
end;

function TLazRibbonCustomControlItem.GetTableBehaviour: TLazRibbonItemTableBehaviour;
begin
  Result := FLayout;
end;

function TLazRibbonCustomControlItem.GetGroupBehaviour: TLazRibbonItemGroupBehaviour;
begin
  Result := gbSingleItem;
end;

procedure TLazRibbonCustomControlItem.Draw(ABuffer: TBitmap; ClipRect: T2DIntRect);
begin
  UpdateControl;
end;

function TLazRibbonCustomControlItem.ExecuteKeyTip: Boolean;
begin
  UpdateControl;
  Result := Visible and Enabled and (FControl is TWinControl) and
    TWinControl(FControl).TabStop and TWinControl(FControl).CanFocus;
  if Result then TWinControl(FControl).SetFocus;
end;

procedure TLazRibbonCustomControlItem.MouseLeave;
begin
end;

procedure TLazRibbonCustomControlItem.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then ExecuteKeyTip;
end;

procedure TLazRibbonCustomControlItem.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TLazRibbonCustomControlItem.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TLazRibbonCustomControlItem.Notify(Item: TComponent; Operation: TOperation);
begin
end;

procedure TLazRibbonCustomInputItem.ControlChange(Sender: TObject);
begin
  DoChange;
end;

procedure TLazRibbonCustomInputItem.DoChange;
begin
  if not (csLoading in ComponentState) and not (csDestroying in ComponentState) and
    Assigned(FOnChange) then FOnChange(Self);
end;

function TLazRibbonEditItem.CreateControl: TControl;
begin
  Result := TEdit.Create(Self);
  TEdit(Result).OnChange := ControlChange;
end;

function TLazRibbonEditItem.GetText: TCaption;
begin
  Result := TEdit(Control).Text;
end;

procedure TLazRibbonEditItem.SetText(const AValue: TCaption);
begin
  TEdit(Control).Text := AValue;
end;

function TLazRibbonEditItem.GetReadOnly: Boolean;
begin
  Result := TEdit(Control).ReadOnly;
end;

procedure TLazRibbonEditItem.SetReadOnly(AValue: Boolean);
begin
  TEdit(Control).ReadOnly := AValue;
end;

function TLazRibbonComboBoxItem.CreateControl: TControl;
begin
  Result := TComboBox.Create(Self);
  TComboBox(Result).Style := csDropDownList;
  TComboBox(Result).OnChange := ControlChange;
end;

procedure TLazRibbonComboBoxItem.DoChange;
begin
  if not FChanging then inherited DoChange;
end;

function TLazRibbonComboBoxItem.GetItems: TStrings;
begin
  Result := TComboBox(Control).Items;
end;

procedure TLazRibbonComboBoxItem.SetItems(AValue: TStrings);
begin
  TComboBox(Control).Items.Assign(AValue);
end;

function TLazRibbonComboBoxItem.GetItemIndex: Integer;
begin
  Result := TComboBox(Control).ItemIndex;
end;

procedure TLazRibbonComboBoxItem.SetItemIndex(AValue: Integer);
var
  Previous: Integer;
begin
  if (AValue < -1) or (AValue >= Items.Count) then
    raise ERangeError.Create('Ribbon combo item index is outside Items.');
  Previous := ItemIndex;
  if Previous = AValue then Exit;
  FChanging := True;
  try
    TComboBox(Control).ItemIndex := AValue;
  finally
    FChanging := False;
  end;
  DoChange;
end;

function TLazRibbonComboBoxItem.GetText: TCaption;
begin
  Result := TComboBox(Control).Text;
end;

function TLazRibbonComboBoxItem.IsTextStored: Boolean;
begin
  { In a selection-only combo the index is authoritative, including when two
    choices have identical captions. Reapplying Text would select the first. }
  Result := Style <> csDropDownList;
end;

procedure TLazRibbonComboBoxItem.SetText(const AValue: TCaption);
begin
  if Style = csDropDownList then
    SetItemIndex(Items.IndexOf(AValue))
  else
    TComboBox(Control).Text := AValue;
end;

function TLazRibbonComboBoxItem.GetStyle: TComboBoxStyle;
begin
  Result := TComboBox(Control).Style;
end;

procedure TLazRibbonComboBoxItem.SetStyle(AValue: TComboBoxStyle);
begin
  TComboBox(Control).Style := AValue;
end;

function TLazRibbonSpinEditItem.CreateControl: TControl;
begin
  Result := TSpinEdit.Create(Self);
  TSpinEdit(Result).MaxValue := 100;
  TSpinEdit(Result).OnChange := ControlChange;
end;

function TLazRibbonSpinEditItem.GetValue: Integer;
begin
  Result := TSpinEdit(Control).Value;
end;

procedure TLazRibbonSpinEditItem.SetValue(AValue: Integer);
begin
  TSpinEdit(Control).Value := AValue;
end;

function TLazRibbonSpinEditItem.GetMinValue: Integer;
begin
  Result := TSpinEdit(Control).MinValue;
end;

procedure TLazRibbonSpinEditItem.SetMinValue(AValue: Integer);
begin
  TSpinEdit(Control).MinValue := AValue;
end;

function TLazRibbonSpinEditItem.GetMaxValue: Integer;
begin
  Result := TSpinEdit(Control).MaxValue;
end;

procedure TLazRibbonSpinEditItem.SetMaxValue(AValue: Integer);
begin
  TSpinEdit(Control).MaxValue := AValue;
end;

function TLazRibbonSpinEditItem.GetIncrement: Integer;
begin
  Result := TSpinEdit(Control).Increment;
end;

procedure TLazRibbonSpinEditItem.SetIncrement(AValue: Integer);
begin
  if AValue < 1 then AValue := 1;
  TSpinEdit(Control).Increment := AValue;
end;

constructor TLazRibbonFontNameComboBoxItem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FShowFontPreview := True;
  RefreshFonts;
end;

function TLazRibbonFontNameComboBoxItem.CreateControl: TControl;
begin
  Result := TComboBox.Create(Self);
  with TComboBox(Result) do
  begin
    Style := csOwnerDrawEditableFixed;
    DropDownCount := 12;
    ItemHeight := 24;
    AutoComplete := True;
    OnChange := FontSelectionChanged;
    OnDrawItem := DrawFontItem;
  end;
end;

function TLazRibbonFontNameComboBoxItem.GetItems: TStrings;
begin
  Result := TComboBox(Control).Items;
end;

function TLazRibbonFontNameComboBoxItem.GetDropDownCount: Integer;
begin
  Result := TComboBox(Control).DropDownCount;
end;

procedure TLazRibbonFontNameComboBoxItem.SetDropDownCount(AValue: Integer);
begin
  if AValue < 1 then AValue := 1;
  TComboBox(Control).DropDownCount := AValue;
end;

procedure TLazRibbonFontNameComboBoxItem.SetFontName(const AValue: TFontName);
var
  Combo: TComboBox;
  NewName: TFontName;
  Index: Integer;
begin
  Combo := TComboBox(Control);
  Index := Items.IndexOf(AValue);
  if Index >= 0 then NewName := Items[Index] else NewName := AValue;
  if FFontName = NewName then Exit;
  FUpdatingFonts := True;
  try
    FFontName := NewName;
    Combo.ItemIndex := Index;
    Combo.Text := NewName;
  finally
    FUpdatingFonts := False;
  end;
  DoChange;
end;

procedure TLazRibbonFontNameComboBoxItem.SetShowFontPreview(AValue: Boolean);
begin
  if FShowFontPreview = AValue then Exit;
  FShowFontPreview := AValue;
  Control.Invalidate;
end;

procedure TLazRibbonFontNameComboBoxItem.FontSelectionChanged(Sender: TObject);
var
  NewName: TFontName;
begin
  if FUpdatingFonts then Exit;
  NewName := TComboBox(Control).Text;
  if FFontName = NewName then Exit;
  FFontName := NewName;
  DoChange;
end;

procedure TLazRibbonFontNameComboBoxItem.RefreshFonts;
var
  Names: TStringList;
  Combo: TComboBox;
begin
  Names := TStringList.Create;
  try
    Names.Sorted := True;
    Names.Duplicates := dupIgnore;
    Names.AddStrings(Screen.Fonts);
    Combo := TComboBox(Control);
    FUpdatingFonts := True;
    try
      Combo.Items.BeginUpdate;
      try
        Combo.Items.Assign(Names);
        Combo.ItemIndex := Combo.Items.IndexOf(FFontName);
        { Keep an unavailable font name visible without inventing a list entry.
          Applications can therefore move between machines with different fonts. }
        Combo.Text := FFontName;
      finally
        Combo.Items.EndUpdate;
      end;
    finally
      FUpdatingFonts := False;
    end;
  finally
    Names.Free;
  end;
end;

procedure TLazRibbonFontNameComboBoxItem.DrawFontItem(AControl: TWinControl;
  AIndex: Integer; ARect: TRect; AState: TOwnerDrawState);
var
  Combo: TComboBox;
  DrawStyle: TTextStyle;
  FontText: String;
begin
  Combo := TComboBox(AControl);
  if (AIndex >= 0) and (AIndex < Combo.Items.Count) then
    FontText := Combo.Items[AIndex]
  else
    FontText := FFontName;
  with Combo.Canvas do
  begin
    Font.Assign(Combo.Font);
    if FShowFontPreview and not (odComboBoxEdit in AState) then
      Font.Name := FontText;
    if odSelected in AState then
    begin
      Brush.Color := clHighlight;
      Font.Color := clHighlightText;
    end
    else
    begin
      Brush.Color := clWindow;
      Font.Color := clWindowText;
    end;
    FillRect(ARect);
    if not Enabled then Font.Color := clGrayText;
    DrawStyle := Default(TTextStyle);
    DrawStyle.Layout := tlCenter;
    DrawStyle.SingleLine := True;
    DrawStyle.Clipping := True;
    DrawStyle.EndEllipsis := True;
    Inc(ARect.Left, 4);
    TextRect(ARect, ARect.Left, ARect.Top, FontText, DrawStyle);
  end;
end;

function TLazRibbonStaticTextItem.CreateControl: TControl;
begin
  Result := TLabel.Create(Self);
  TLabel(Result).Layout := tlCenter;
  TLabel(Result).Transparent := True;
  TLabel(Result).ShowAccelChar := False;
end;

procedure TLazRibbonStaticTextItem.SetCaption(const AValue: TCaption);
begin
  inherited SetCaption(AValue);
  TLabel(Control).Caption := AValue;
end;

function TLazRibbonStaticTextItem.GetAlignment: TAlignment;
begin
  Result := TLabel(Control).Alignment;
end;

procedure TLazRibbonStaticTextItem.SetAlignment(AValue: TAlignment);
begin
  TLabel(Control).Alignment := AValue;
end;

function TLazRibbonProgressBarItem.CreateControl: TControl;
begin
  Result := TProgressBar.Create(Self);
  TProgressBar(Result).TabStop := False;
end;

function TLazRibbonProgressBarItem.GetMin: Integer;
begin
  Result := TProgressBar(Control).Min;
end;

procedure TLazRibbonProgressBarItem.SetMin(AValue: Integer);
begin
  TProgressBar(Control).Min := AValue;
end;

function TLazRibbonProgressBarItem.GetMax: Integer;
begin
  Result := TProgressBar(Control).Max;
end;

procedure TLazRibbonProgressBarItem.SetMax(AValue: Integer);
begin
  TProgressBar(Control).Max := AValue;
end;

function TLazRibbonProgressBarItem.GetPosition: Integer;
begin
  Result := TProgressBar(Control).Position;
end;

procedure TLazRibbonProgressBarItem.SetPosition(AValue: Integer);
begin
  TProgressBar(Control).Position := AValue;
end;

end.
