(*******************************************************************************
*                                                                              *
*  File:        LazRibbon_Tabs.pas                                                   *
*  Description: Toolbar component tab                                          *
*  Copyright:   (c) 2009 by Spook.                                             *
*  License:     Modified LGPL (with linking exception, like Lazarus LCL)       *
*               See "license.txt" in this installation                         *
*                                                                              *
*******************************************************************************)

unit LazRibbon_Tabs;

{$mode delphi}

{$IF FPC_FullVersion >= 30200}
  {$WARN 6058 off : Call to subroutine "$1" marked as inline is not inlined}
{$IFEND}

{.$Define EnhancedRecordSupport}

interface

uses
  Graphics, Controls, Classes, SysUtils, Math,
  LazRibbon_Math,
  LazRibbon_Appearance, LazRibbon_Const, LazRibbon_Dispatch, LazRibbon_Exceptions,
  LazRibbon_Groups, LazRibbon_Types;

type
  TLazRibbonTab = class;

  TLazRibbonMouseTabElementType = (etNone, etTabArea, etPane);

  TLazRibbonMouseTabElement = record
    ElementType: TLazRibbonMouseTabElementType;
    ElementIndex: integer;
  end;

  TLazRibbonTabAppearanceDispatch = class(TLazRibbonBaseAppearanceDispatch)
  private
    FTab: TLazRibbonTab;
  public
    // *** Constructor ***
    constructor Create(ATab: TLazRibbonTab);

    // *** Implementation of methods inherited from TLazRibbonBaseTabDispatch ***
    procedure NotifyAppearanceChanged; override;
  end;

  TLazRibbonTab = class(TLazRibbonComponent)
  private
    FAppearanceDispatch: TLazRibbonTabAppearanceDispatch;
    FAppearance: TLazRibbonToolbarAppearance;
    FMouseHoverElement: TLazRibbonMouseTabElement;
    FMouseActiveElement: TLazRibbonMouseTabElement;
    FOnClick: TNotifyEvent;
    FKeyTip: string;
    FContextual: Boolean;
    FContextualGroupCaption: string;
    FContextualColor: TColor;

  protected
    FToolbarDispatch: TLazRibbonBaseToolbarDispatch;
    FCaption: string;
    FVisible: boolean;
    FOverrideAppearance: boolean;
    FCustomAppearance: TLazRibbonToolbarAppearance;
    FPanes: TLazRibbonPanes;
    FRect: T2DIntRect;
    FImages: TImageList;
    FDisabledImages: TImageList;
    FLargeImages: TImageList;
    FDisabledLargeImages: TImageList;
    FImagesWidth: Integer;
    FLargeImagesWidth: Integer;

    // *** Sets the appropriate appearance tiles ***
    procedure SetPaneAppearance; inline;

    // *** Designtime and LFM support ***
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    procedure DefineProperties(Filer: TFiler); override;
    procedure Loaded; override;

    function GetRootComponent: TComponent;
    function IsRightToLeft: Boolean;

    // *** Getters and setters ***
    procedure SetCaption(const Value: string);
    procedure SetKeyTip(const Value: string);
    procedure SetContextual(const Value: Boolean);
    procedure SetContextualGroupCaption(const Value: string);
    procedure SetContextualColor(const Value: TColor);
    procedure SetCustomAppearance(const Value: TLazRibbonToolbarAppearance);
    procedure SetOverrideAppearance(const Value: boolean);
    procedure SetVisible(const Value: boolean);
    procedure SetAppearance(const Value: TLazRibbonToolbarAppearance);
    procedure SetImages(const Value: TImageList);
    procedure SetDisabledImages(const Value: TImageList);
    procedure SetLargeImages(const Value: TImageList);
    procedure SetDisabledLargeImages(const Value: TImageList);
    procedure SetImagesWidth(const Value: Integer);
    procedure SetLargeImagesWidth(const Value: Integer);
    procedure SetRect(ARect: T2DIntRect);
    procedure SetToolbarDispatch(const Value: TLazRibbonBaseToolbarDispatch);

  public
    // *** Constructor, destructor ***
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    // *** Geometry, sheet service, drawing ***
    function AtLeastOnePaneVisible: boolean;
    procedure Draw(ABuffer: TBitmap; AClipRect: T2DIntRect);

    // *** Mouse support ***
    procedure MouseLeave;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MouseMove(Shift: TShiftState; X, Y: Integer);
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

    // *** Sheet search ***
    function FindPaneAt(x, y: integer): integer;

    // *** Dispatcher event handling ***
    procedure NotifyAppearanceChanged;

    // *** Support for elements ***
    procedure FreeingPane(APane: TLazRibbonPane);

    procedure ExecOnClick;

    property ToolbarDispatch: TLazRibbonBaseToolbarDispatch read FToolbarDispatch write SetToolbarDispatch;
    property Appearance: TLazRibbonToolbarAppearance read FAppearance write SetAppearance;
    property Panes: TLazRibbonPanes read FPanes;
    property Rect: T2DIntRect read FRect write SetRect;
    property Images: TImageList read FImages write SetImages;
    property DisabledImages: TImageList read FDisabledImages write SetDisabledImages;
    property LargeImages: TImageList read FLargeImages write SetLargeImages;
    property DisabledLargeImages: TImageList read FDisabledLargeImages write SetDisabledLargeImages;
    property ImagesWidth: Integer read FImagesWidth write SetImagesWidth;
    property LargeImagesWidth: Integer read FLargeImagesWidth write SetLargeImagesWidth;

  published
    property CustomAppearance: TLazRibbonToolbarAppearance read FCustomAppearance write SetCustomAppearance;
    property Caption: string read FCaption write SetCaption;
    property KeyTip: string read FKeyTip write SetKeyTip;
    property Contextual: Boolean read FContextual write SetContextual default False;
    property ContextualGroupCaption: string read FContextualGroupCaption write SetContextualGroupCaption;
    property ContextualColor: TColor read FContextualColor write SetContextualColor default clNone;
    property OverrideAppearance: boolean read FOverrideAppearance write SetOverrideAppearance default false;
    property Visible: boolean read FVisible write SetVisible default true;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
  end;

  TLazRibbonTabs = class(TLazRibbonCollection)
  protected
    FToolbarDispatch: TLazRibbonBaseToolbarDispatch;
    FAppearance: TLazRibbonToolbarAppearance;
    FImages: TImageList;
    FDisabledImages: TImageList;
    FLargeImages: TImageList;
    FDisabledLargeImages: TImageList;
    FImagesWidth: Integer;
    FLargeImagesWidth: Integer;
    procedure SetToolbarDispatch(const Value: TLazRibbonBaseToolbarDispatch);
    function GetItems(AIndex: integer): TLazRibbonTab; reintroduce;
    procedure SetAppearance(const Value: TLazRibbonToolbarAppearance);
    procedure SetImages(const Value: TImageList);
    procedure SetDisabledImages(const Value: TImageList);
    procedure SetLargeImages(const Value: TImageList);
    procedure SetDisabledLargeImages(const Value: TImageList);
    procedure SetImagesWidth(const Value: Integer);
    procedure SetLargeImagesWidth(const Value: Integer);
  public
    function Add: TLazRibbonTab;
    function Insert(AIndex: integer): TLazRibbonTab;
    procedure Notify(Item: TComponent; Operation: TOperation); override;
    procedure Update; override;

    property Items[index: integer]: TLazRibbonTab read GetItems; default;
    property ToolbarDispatch: TLazRibbonBaseToolbarDispatch read FToolbarDispatch write SetToolbarDispatch;
    property Appearance: TLazRibbonToolbarAppearance read FAppearance write SetAppearance;
    property Images: TImageList read FImages write SetImages;
    property DisabledImages: TImageList read FDisabledImages write SetDisabledImages;
    property LargeImages: TImageList read FLargeImages write SetLargeImages;
    property DisabledLargeImages: TImageList read FDisabledLargeImages write SetDisabledLargeImages;
    property ImagesWidth: Integer read FImagesWidth write SetImagesWidth;
    property LargeImagesWidth: Integer read FLargeImagesWidth write SetLargeImagesWidth;
  end;


implementation

{ TLazRibbonTabDispatch }

constructor TLazRibbonTabAppearanceDispatch.Create(ATab: TLazRibbonTab);
begin
  inherited Create;
  FTab := ATab;
end;

procedure TLazRibbonTabAppearanceDispatch.NotifyAppearanceChanged;
begin
  if Assigned(FTab) then
    FTab.NotifyAppearanceChanged;
end;


{ TLazRibbonTab }

constructor TLazRibbonTab.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAppearanceDispatch := TLazRibbonTabAppearanceDispatch.Create(self);
  FMouseHoverElement.ElementType := etNone;
  FMouseHoverElement.ElementIndex := -1;
  FMouseActiveElement.ElementType := etNone;
  FMouseActiveElement.ElementIndex := -1;
  FCaption := 'Tab';
  FVisible := true;
  FContextual := False;
  FContextualGroupCaption := '';
  FContextualColor := clNone;
  FCustomAppearance := TLazRibbonToolbarAppearance.Create(FAppearanceDispatch);
  FPanes := TLazRibbonPanes.Create(self);
  FPanes.ToolbarDispatch := FToolbarDispatch;
  FPanes.ImagesWidth := FImagesWidth;
  FPanes.LargeImagesWidth := FLargeImagesWidth;
  {$IFDEF EnhancedRecordSupport}
  FRect := T2DIntRect.Create(0,0,0,0);
  {$ELSE}
  FRect.Create(0,0,0,0);
  {$ENDIF}
  SetPaneAppearance;
end;

destructor TLazRibbonTab.Destroy;
begin
  FPanes.Free;
  FCustomAppearance.Free;
  FAppearanceDispatch.Free;
  inherited Destroy;
end;

function TLazRibbonTab.AtLeastOnePaneVisible: boolean;
var
  i: integer;
  PaneVisible: boolean;
begin
  Result := (FPanes.Count > 0);
  if Result then
  begin
    PaneVisible := false;
    i := FPanes.Count - 1;
    while (i >= 0) and not PaneVisible do
    begin
      PaneVisible := FPanes[i].Visible;
      dec(i);
    end;
    Result := Result and PaneVisible;
  end;
end;

procedure TLazRibbonTab.SetRect(ARect: T2DIntRect);
var
  x, i: integer;
  tw: integer;
  tmpRect: T2DIntRect;
  isRTL: Boolean;
begin
  isRTL := IsRightToLeft;

  FRect := ARect;
  if (ARect.Width <= 0) or (ARect.Height <= 0) then
  begin
    for i := 0 to FPanes.Count - 1 do
      {$IFDEF EnhancedRecordSupport}
      FPanes[i].Rect := T2DIntRect.Create(-1, -1, -2, -2);
      {$ELSE}
      FPanes[i].Rect := Create2DIntRect(-1, -1, -2, -2);
      {$ENDIF}
    Exit;
  end;

  if AtLeastOnePaneVisible then
  begin
    x := IfThen(isRTL, ARect.Right, ARect.Left);
    for i := 0 to FPanes.Count - 1 do
      if FPanes[i].Visible then
      begin
        tw := FPanes[i].GetWidth;
        if isRTL then
        begin
          tmpRect.Right := x;
          tmpRect.Left := x - tw + 1;
          x := x - tw - TabPaneHSpacing;
        end else
        begin
          tmpRect.Left := x;
          tmpRect.Right := x + tw - 1;
          x := x + tw + TabPaneHSpacing;
        end;
        tmpRect.Top := ARect.Top;
        tmpRect.Bottom := ARect.bottom;
        FPanes[i].Rect := tmpRect;
      end
      else
      begin
        {$IFDEF EnhancedRecordSupport}
        FPanes[i].Rect := T2DIntRect.Create(-1,-1,-1,-1);
        {$ELSE}
        FPanes[i].Rect.Create(-1,-1,-1,-1);
        {$ENDIF}
      end;
  end;
end;

procedure TLazRibbonTab.SetToolbarDispatch(const Value: TLazRibbonBaseToolbarDispatch);
begin
  FToolbarDispatch := Value;
  FPanes.ToolbarDispatch := FToolbarDispatch;
end;

procedure TLazRibbonTab.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineProperty('Panes', FPanes.ReadNames, FPanes.WriteNames, true);
end;


procedure TLazRibbonTab.Draw(ABuffer: TBitmap; AClipRect: T2DIntRect);
var
  LocalClipRect: T2DIntRect;
  i: integer;
begin
  if AtLeastOnePaneVisible then
    for i := 0 to FPanes.Count - 1 do
      if FPanes[i].visible then
      begin
        if AClipRect.IntersectsWith(FPanes[i].Rect, LocalClipRect) then
          FPanes[i].Draw(ABuffer, LocalClipRect);
      end;
end;

procedure TLazRibbonTab.ExecOnClick;
begin
  if Assigned(FOnClick) then
    FOnClick(self);
end;

function TLazRibbonTab.FindPaneAt(x, y: integer): integer;
var
  i: integer;
begin
  Result := -1;
  i := FPanes.Count - 1;
  while (i >= 0) and (Result = -1) do
  begin
    if FPanes[i].Visible then
    begin
      {$IFDEF EnhancedRecordSupport}
      if FPanes[i].Rect.Contains(T2DIntVector.Create(x,y)) then
      {$ELSE}
      if FPanes[i].Rect.Contains(x,y) then
      {$ENDIF}
        Result := i;
    end;
    dec(i);
  end;
end;

procedure TLazRibbonTab.FreeingPane(APane: TLazRibbonPane);
begin
  FPanes.RemoveReference(APane);
end;

procedure TLazRibbonTab.GetChildren(Proc: TGetChildProc; Root: TComponent);
var
  i: Integer;
begin
  inherited;
  for i := 0 to FPanes.Count - 1 do
    Proc(FPanes.Items[i]);
end;

function TLazRibbonTab.GetRootComponent: TComponent;
begin
  Result := nil;
  if Collection <> nil then
    Result := Collection.RootComponent
  else
    Result := nil;
end;

function TLazRibbonTab.IsRightToLeft: Boolean;
begin
  Result := (GetRootComponent as TControl).IsRightToLeft;
end;

procedure TLazRibbonTab.Loaded;
begin
  inherited;
  if FPanes.ListState = lsNeedsProcessing then
    FPanes.ProcessNames(self.Owner);
  if (csDesigning in ComponentState) and Assigned(FToolbarDispatch) then
    FToolbarDispatch.NotifyItemsChanged;
end;

procedure TLazRibbonTab.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if FMouseActiveElement.ElementType = etPane then
  begin
    if FMouseActiveElement.ElementIndex <> -1 then
      FPanes[FMouseActiveElement.ElementIndex].MouseDown(Button, Shift, X, Y);
  end else
  if FMouseActiveElement.ElementType = etTabArea then
  begin
   // Placeholder, if there is a need to handle this event.
  end else
  if FMouseActiveElement.ElementType = etNone then
  begin
    if FMouseHoverElement.ElementType = etPane then
    begin
      if FMouseHoverElement.ElementIndex <> -1 then
      begin
        FMouseActiveElement.ElementType := etPane;
        FMouseActiveElement.ElementIndex := FMouseHoverElement.ElementIndex;
        FPanes[FMouseHoverElement.ElementIndex].MouseDown(Button, Shift, X, Y);
      end
      else
      begin
        FMouseActiveElement.ElementType := etTabArea;
        FMouseActiveElement.ElementIndex := -1;
      end;
    end else
    if FMouseHoverElement.ElementType = etTabArea then
    begin
      FMouseActiveElement.ElementType := etTabArea;
      FMouseActiveElement.ElementIndex := -1;
      // Placeholder, if there is a need to handle this event.
    end;
  end;
end;

procedure TLazRibbonTab.MouseLeave;
begin
  if FMouseActiveElement.ElementType = etNone then
  begin
    if FMouseHoverElement.ElementType = etPane then
    begin
      if FMouseHoverElement.ElementIndex <> -1 then
        FPanes[FMouseHoverElement.ElementIndex].MouseLeave;
    end else
    if FMouseHoverElement.ElementType = etTabArea then
    begin
      // Placeholder, if there is a need to handle this event.
    end;
  end;

  FMouseHoverElement.ElementType := etNone;
  FMouseHoverElement.ElementIndex := -1;
end;

procedure TLazRibbonTab.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  i: integer;
  NewMouseHoverElement: TLazRibbonMouseTabElement;
begin
  // We're looking for an object under the mouse
  i := FindPaneAt(X, Y);
  if i <> -1 then
  begin
    NewMouseHoverElement.ElementType := etPane;
    NewMouseHoverElement.ElementIndex := i;
  end else
  if (X >= FRect.left) and (Y >= FRect.top) and
     (X <= FRect.right) and (Y <= FRect.bottom) then
  begin
    NewMouseHoverElement.ElementType := etTabArea;
    NewMouseHoverElement.ElementIndex := -1;
  end else
  begin
    NewMouseHoverElement.ElementType := etNone;
    NewMouseHoverElement.ElementIndex := -1;
  end;

  if FMouseActiveElement.ElementType = etPane then
  begin
    if FMouseActiveElement.ElementIndex <> -1 then
    begin
      FPanes[FMouseActiveElement.ElementIndex].MouseMove(Shift, X, Y);
    end;
  end else
  if FMouseActiveElement.ElementType = etTabArea then
  begin
    // Placeholder, if there is a need to handle this event
  end else
  if FMouseActiveElement.ElementType = etNone then
  begin
    // If the item under the mouse changes, we inform the previous element
    // that the mouse leaves its area
    if (NewMouseHoverElement.ElementType <> FMouseHoverElement.ElementType) or
      (NewMouseHoverElement.ElementIndex <> FMouseHoverElement.ElementIndex) then
    begin
      if FMouseHoverElement.ElementType = etPane then
      begin
        if FMouseHoverElement.ElementIndex <> -1 then
          FPanes[FMouseHoverElement.ElementIndex].MouseLeave;
      end else
      if FMouseHoverElement.ElementType = etTabArea then
      begin
        // Placeholder, if there is a need to handle this event
      end;
    end;

    if NewMouseHoverElement.ElementType = etPane then
    begin
      if NewMouseHoverElement.ElementIndex <> -1 then
        FPanes[NewMouseHoverElement.ElementIndex].MouseMove(Shift, X, Y);
    end else
    if NewMouseHoverElement.ElementType = etTabArea then
    begin
      // Placeholder, if there is a need to handle this event
    end;
  end;

  FMouseHoverElement := NewMouseHoverElement;
end;

procedure TLazRibbonTab.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  ClearActive: boolean;
begin
  ClearActive := not (ssLeft in Shift) and not (ssMiddle in Shift) and not (ssRight in Shift);

  if FMouseActiveElement.ElementType = etPane then
  begin
    if FMouseActiveElement.ElementIndex <> -1 then
      FPanes[FMouseActiveElement.ElementIndex].MouseUp(Button, Shift, X, Y);
  end else
  if FMouseActiveElement.ElementType = etTabArea then
  begin
    // Placeholder, if there is a need to handle this event.
  end;
   
  if ClearActive and
    (FMouseActiveElement.ElementType <> FMouseHoverElement.ElementType) or
    (FMouseActiveElement.ElementIndex <> FMouseHoverElement.ElementIndex) then
  begin
    if FMouseActiveElement.ElementType = etPane then
    begin
      if FMouseActiveElement.ElementIndex <> -1 then
        FPanes[FMouseActiveElement.ElementIndex].MouseLeave;
    end else
    if FMouseActiveElement.ElementType = etTabArea then
    begin
      // Placeholder, if there is a need to handle this event.
    end;

    if FMouseHoverElement.ElementType = etPane then
    begin
      if FMouseHoverElement.ElementIndex <> -1 then
        FPanes[FMouseHoverElement.ElementIndex].MouseMove(Shift, X, Y);
    end else
    if FMouseHoverElement.ElementType = etTabArea then
    begin
      // Placeholder, if there is a need to handle this event.
    end;
  end;

  if ClearActive then
  begin
    FMouseActiveElement.ElementType := etNone;
    FMouseActiveElement.ElementIndex := -1;
  end;
end;

procedure TLazRibbonTab.NotifyAppearanceChanged;
begin
  if Assigned(FToolbarDispatch) then
    FToolbarDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonTab.SetCustomAppearance(const Value: TLazRibbonToolbarAppearance);
begin
  FCustomAppearance.Assign(Value);
end;

procedure TLazRibbonTab.SetDisabledImages(const Value: TImageList);
begin
  FDisabledImages := Value;
  FPanes.DisabledImages := Value;
end;

procedure TLazRibbonTab.SetDisabledLargeImages(const Value: TImageList);
begin
  FDisabledLargeImages := Value;
  FPanes.DisabledLargeImages := Value;
end;

procedure TLazRibbonTab.SetImages(const Value: TImageList);
begin
  FImages := Value;
  FPanes.Images := Value;
end;

procedure TLazRibbonTab.SetImagesWidth(const Value: Integer);
begin
  FImagesWidth := Value;
  FPanes.ImagesWidth := Value;
end;

procedure TLazRibbonTab.SetLargeImages(const Value: TImageList);
begin
  FLargeImages := Value;
  FPanes.LargeImages := Value;
end;

procedure TLazRibbonTab.SetLargeImagesWidth(const Value: Integer);
begin
  FLargeImagesWidth := Value;
  FPanes.LargeImagesWidth := Value;
end;

procedure TLazRibbonTab.SetAppearance(const Value: TLazRibbonToolbarAppearance);
begin
  FAppearance := Value;
  SetPaneAppearance;
  if FToolbarDispatch <> nil then
    FToolbarDispatch.NotifyMetricsChanged;
end;

procedure TLazRibbonTab.SetCaption(const Value: string);
begin
  FCaption := Value;
  if Assigned(FToolbarDispatch) then
    FToolbarDispatch.NotifyMetricsChanged;
end;


procedure TLazRibbonTab.SetKeyTip(const Value: string);
begin
  if FKeyTip = Value then Exit;
  FKeyTip := Value;
  if Assigned(FToolbarDispatch) then
    FToolbarDispatch.NotifyVisualsChanged;
end;

procedure TLazRibbonTab.SetContextual(const Value: Boolean);
begin
  if FContextual = Value then Exit;
  FContextual := Value;
  if Assigned(FToolbarDispatch) then
    FToolbarDispatch.NotifyVisualsChanged;
end;

procedure TLazRibbonTab.SetContextualGroupCaption(const Value: string);
begin
  if FContextualGroupCaption = Value then Exit;
  FContextualGroupCaption := Value;
  if Assigned(FToolbarDispatch) then
    FToolbarDispatch.NotifyVisualsChanged;
end;

procedure TLazRibbonTab.SetContextualColor(const Value: TColor);
begin
  if FContextualColor = Value then Exit;
  FContextualColor := Value;
  if Assigned(FToolbarDispatch) then
    FToolbarDispatch.NotifyVisualsChanged;
end;

procedure TLazRibbonTab.SetOverrideAppearance(const Value: boolean);
begin
  FOverrideAppearance := Value;
  SetPaneAppearance;
  if FToolbarDispatch <> nil then
    FToolbarDispatch.NotifyMetricsChanged;
end;

procedure TLazRibbonTab.SetPaneAppearance;
begin
  if FOverrideAppearance then
    FPanes.Appearance := FCustomAppearance
  else
    FPanes.Appearance := FAppearance;
  // The method plays the role of a macro - therefore it does not
  // notify the dispatcher about the change.
end;

procedure TLazRibbonTab.SetVisible(const Value: boolean);
begin
  FVisible := Value;
  if FToolbarDispatch <> nil then
    FToolbarDispatch.NotifyItemsChanged;
end;


{ TLazRibbonTabs }

function TLazRibbonTabs.Add: TLazRibbonTab;
begin
  Result := TLazRibbonTab.create(FRootComponent);
  Result.Parent := FRootComponent;
  AddItem(Result);
end;

function TLazRibbonTabs.GetItems(AIndex: integer): TLazRibbonTab;
begin
  Result := TLazRibbonTab(inherited Items[AIndex]);
end;

function TLazRibbonTabs.Insert(AIndex: integer): TLazRibbonTab;
var
  lOwner, lParent: TComponent;
  i: Integer;
begin
  if (AIndex < 0) or (AIndex >= self.Count) then
    raise InternalException.Create('TLazRibbonTabs.Insert: Invalid index!');

  if FRootComponent<>nil then
  begin
    lOwner := FRootComponent.Owner;
    lParent := FRootComponent;
  end
  else
  begin
    lOwner := nil;
    lParent := nil;
  end;

  Result := TLazRibbonTab.Create(lOwner);
  Result.Parent := lParent;

  if FRootComponent<>nil then
  begin
    i := 0;
    while FRootComponent.Owner.FindComponent('LazRibbonTab'+IntToStr(i)) <> nil do
      inc(i);

    Result.Name := 'LazRibbonTab' + IntToStr(i);
  end;
  InsertItem(AIndex, Result);
end;

procedure TLazRibbonTabs.Notify(Item: TComponent; Operation: TOperation);
var
  i: Integer;
  tab: TLazRibbonTab;
begin
  inherited Notify(Item, Operation);

  case Operation of
    opInsert:
      if Item is TLazRibbonTab then
      begin
        // Setting the dispatcher to nil will cause that during the
        // ownership assignment, the Notify method will not be called
        TLazRibbonTab(Item).ToolbarDispatch := nil;
        TLazRibbonTab(Item).Appearance := self.FAppearance;
        TLazRibbonTab(Item).Images := self.FImages;
        TLazRibbonTab(Item).DisabledImages := self.FDisabledImages;
        TLazRibbonTab(Item).LargeImages := self.FLargeImages;
        TLazRibbonTab(Item).DisabledLargeImages := self.FDisabledLargeImages;
        TLazRibbonTab(Item).ImagesWidth := self.FImagesWidth;
        TLazRibbonTab(Item).LargeImagesWidth := self.FLargeImagesWidth;
        TLazRibbonTab(Item).ToolbarDispatch := self.FToolbarDispatch;
      end;
    opRemove:
      if (Item is TLazRibbonTab) then
      begin
        if not(csDestroying in Item.ComponentState) then
        begin
          TLazRibbonTab(Item).ToolbarDispatch := nil;
          TLazRibbonTab(Item).Appearance := nil;
          TLazRibbonTab(Item).Images := nil;
          TLazRibbonTab(Item).DisabledImages := nil;
          TLazRibbonTab(Item).LargeImages := nil;
          TLazRibbonTab(Item).DisabledLargeImages := nil;
        end;
      end else
        for i := 0 to Count-1 do
        begin
          tab := Items[i];
          tab.Panes.Notify(Item, Operation);
        end;
  end;
end;

procedure TLazRibbonTabs.SetAppearance(const Value: TLazRibbonToolbarAppearance);
var
  i: Integer;
begin
  FAppearance := Value;
  for i := 0 to self.Count - 1 do
    self.Items[i].Appearance := FAppearance;
end;

procedure TLazRibbonTabs.SetDisabledImages(const Value: TImageList);
var
  i: Integer;
begin
  FDisabledImages := Value;
  for i := 0 to self.Count - 1 do
    Items[i].DisabledImages := Value;
end;

procedure TLazRibbonTabs.SetDisabledLargeImages(const Value: TImageList);
var
  i: Integer;
begin
  FDisabledLargeImages := Value;
  for i := 0 to self.count - 1 do
    Items[i].DisabledLargeImages := Value;
end;

procedure TLazRibbonTabs.SetImages(const Value: TImageList);
var
  i: Integer;
begin
  FImages := Value;
  for i := 0 to self.Count - 1 do
    Items[i].Images := Value;
end;

procedure TLazRibbonTabs.SetImagesWidth(const Value: Integer);
var
  i: Integer;
begin
  FImagesWidth := Value;
  for i := 0 to Count - 1 do
    Items[i].ImagesWidth := Value;
end;

procedure TLazRibbonTabs.SetLargeImages(const Value: TImageList);
var
  i: Integer;
begin
  FLargeImages := Value;
  for i := 0 to self.Count - 1 do
    Items[i].LargeImages := Value;
end;

procedure TLazRibbonTabs.SetLargeImagesWidth(const Value: Integer);
var
  i: Integer;
begin
  FLargeImagesWidth := Value;
  for i := 0 to Count - 1 do
    Items[i].LargeImagesWidth := Value;
end;

procedure TLazRibbonTabs.SetToolbarDispatch(const Value: TLazRibbonBaseToolbarDispatch);
var
  i: integer;
begin
  FToolbarDispatch := Value;
  for i := 0 to self.Count - 1 do
    self.Items[i].ToolbarDispatch := FToolbarDispatch;
end;

procedure TLazRibbonTabs.Update;
begin
  inherited Update;

  if Assigned(FToolbarDispatch) then
    FToolbarDispatch.NotifyItemsChanged;
end;


end.
