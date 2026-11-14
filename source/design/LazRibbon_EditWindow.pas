{*******************************************************************************
*                                                                              *
*  LazRibbon                                                                   *
*                                                                              *
*  License: Modified LGPL with linking exception, preserving original          *
*           LazToolbar/LazRibbon notices where applicable.                     *
*           See LICENSE.txt in this distribution.                              *
*                                                                              *
*  This header was normalized as part of the LazRibbon 0.3.55 project hygiene  *
*  pass. Functional code was not intentionally changed in this unit.           *
*                                                                              *
*******************************************************************************}

unit LazRibbon_EditWindow;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ComCtrls, LazRibbon_ControlItems,
  ActnList, Menus, ComponentEditors, PropEdits,
  LazRibbon_Core, LazRibbon_Tabs, LazRibbon_Groups, LazRibbon_BaseItem, LazRibbon_Buttons, LazRibbon_Types, LazRibbon_Checkboxes, LazRibbon_RibbonExtItems;

type
  TCreateItemFunc = function(Pane : TLazRibbonPane) : TLazRibbonBaseItem;

type

  { TfrmLazRibbonEditWindow }

  TfrmLazRibbonEditWindow = class(TForm)
    aAddCheckbox: TAction;
    aAddRadioButton: TAction;
    aAddSeparator: TAction;
    aAddToggleSwitch: TAction;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    AddToggleSwitchMenuItem: TMenuItem;
    AddSeparatorMenuItem: TMenuItem;
    tvStructure: TTreeView;
    ilTreeImages: TImageList;
    tbToolBar: TToolBar;
    tbAddTab: TToolButton;
    ilActionImages: TImageList;
    tbRemoveTab: TToolButton;
    ToolButton3: TToolButton;
    tbAddPane: TToolButton;
    tbRemovePane: TToolButton;
    ActionList: TActionList;
    aAddTab: TAction;
    aRemoveTab: TAction;
    aAddPane: TAction;
    aRemovePane: TAction;
    ToolButton6: TToolButton;
    aMoveUp: TAction;
    aMoveDown: TAction;
    tbMoveUp: TToolButton;
    tbMoveDown: TToolButton;
    ToolButton9: TToolButton;
    tbAddItem: TToolButton;
    tbRemoveItem: TToolButton;
    pmAddItem: TPopupMenu;
    LazLargeButton1: TMenuItem;
    aAddLargeButton: TAction;
    aRemoveItem: TAction;
    aAddSmallButton: TAction;
    LazSmallButton1: TMenuItem;
    pmStructure: TPopupMenu;
    Addtab1: TMenuItem;
    Removetab1: TMenuItem;
    N1: TMenuItem;
    Addpane1: TMenuItem;
    Removepane1: TMenuItem;
    N2: TMenuItem;
    Additem1: TMenuItem;
    LazLargeButton2: TMenuItem;
    LazSmallButton2: TMenuItem;
    Removeitem1: TMenuItem;
    N3: TMenuItem;
    Moveup1: TMenuItem;
    Movedown1: TMenuItem;
    procedure aAddSeparatorExecute(Sender: TObject);
    procedure aAddToggleSwitchExecute(Sender: TObject);
    procedure aAddSkinGalleryExecute(Sender: TObject);
    procedure ilActionImagesGetWidthForPPI(Sender: TCustomImageList;
      AImageWidth, APPI: Integer; var AResultWidth: Integer);
    procedure ilTreeImagesGetWidthForPPI(Sender: TCustomImageList; AImageWidth,
      APPI: Integer; var AResultWidth: Integer);
    procedure tvStructureChange(Sender: TObject; Node: TTreeNode);
    procedure aAddTabExecute(Sender: TObject);
    procedure aRemoveTabExecute(Sender: TObject);
    procedure aAddPaneExecute(Sender: TObject);
    procedure aRemovePaneExecute(Sender: TObject);
    procedure aMoveUpExecute(Sender: TObject);
    procedure aMoveDownExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure aAddLargeButtonExecute(Sender: TObject);
    procedure aRemoveItemExecute(Sender: TObject);
    procedure aAddSmallButtonExecute(Sender: TObject);
    procedure aAddCheckboxExecute(Sender: TObject);
    procedure aAddRadioButtonExecute(Sender: TObject);
    procedure tvStructureDeletion(Sender:TObject; Node:TTreeNode);
    procedure tvStructureEdited(Sender: TObject; Node: TTreeNode; var S: string);
    procedure tvStructureKeyDown(Sender: TObject; var Key: Word;
      {%H-}Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  protected
    FToolbar: TLazRibbon;
    FDesigner: TComponentEditorDesigner;
    FAddSkinGalleryAction: TAction;
    FControlItemActions: array[0..8] of TAction;
    FControlTreeImages: array[0..8] of Integer;
    FSkinGalleryTreeImage: Integer;

    procedure EnsureExtendedMenuItems;
    procedure AddControlItemExecute(Sender: TObject);
    procedure EnableControlItemActions(AEnabled: Boolean);
    function ItemImageIndex(ItemClass: TLazRibbonBaseItemClass): Integer;
    procedure CheckActionsAvailability;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure MarkToolbarChanged;

    procedure AddItem(ItemClass: TLazRibbonBaseItemClass);
    function GetItemCaption(Item: TLazRibbonBaseItem): string;
    procedure SetItemCaption(Item: TLazRibbonBaseItem; const Value: String);

    procedure DoRemoveTab;
    procedure DoRemovePane;
    procedure DoRemoveItem;

    function CheckValidTabNode(Node: TTreeNode): boolean;
    function CheckValidPaneNode(Node: TTreeNode): boolean;
    function CheckValidItemNode(Node: TTreeNode): boolean;

//    procedure UpdatePPI;
  public
    { Public declarations }
    function ValidateTreeData: boolean;
    procedure BuildTreeData;
    procedure RefreshNames;
    procedure SetData(AToolbar: TLazRibbon; ADesigner: TComponentEditorDesigner);

    property Toolbar: TLazRibbon read FToolbar;
  end;

var
  frmLazRibbonEditWindow: TfrmLazRibbonEditWindow;

implementation

{$R *.lfm}

resourcestring
  RSCannotMoveAboveFirstElement = 'You can not move above the top of the first element!';
  RSCannotMoveBeyondLastElement = 'You can not move beyond the last element!';
  RSDamagedTreeStructure = 'Damaged tree structure!';
  RSIncorrectFieldData = 'Incorrect data in the field!';
  RSIncorrectObjectInTree = 'Incorrect object attached to the tree!';
  RSNoObjectSelected = 'No object selected!';
  RSNoObjectSelectedToMove = 'No object selected to move!';

const
  IDX_TAB = 0;
  IDX_PANE = 1;
  IDX_LARGEBUTTON = 2;
  IDX_SMALLBUTTON = 3;
  IDX_CHECKBOX = 4;
  IDX_RADIOBUTTON = 5;
  IDX_TOGGLESWITCH = 6;
  IDX_SEPARATOR = 7;

  ControlItemClasses: array[0..8] of TLazRibbonBaseItemClass = (
    TLazRibbonEditItem, TLazRibbonComboBoxItem, TLazRibbonFontNameComboBoxItem,
    TLazRibbonColorComboBoxItem, TLazRibbonDateEditItem, TLazRibbonSpinEditItem,
    TLazRibbonStaticTextItem, TLazRibbonProgressBarItem, TLazRibbonControlHostItem);
  ControlItemCaptions: array[0..8] of String = (
    'Edit', 'Combo Box', 'Font Name Combo Box', 'Color Combo Box', 'Date Edit', 'Spin Edit',
    'Static Text', 'Progress Bar', 'Control Host');

type
  TEditorItemGlyph = (eigEdit, eigComboBox, eigFontName, eigColorCombo, eigDateEdit,
    eigSpinEdit, eigStaticText, eigProgressBar, eigControlHost, eigSkinGallery);

procedure DrawEditorItemGlyph(Bitmap: TBitmap; Kind: TEditorItemGlyph;
  AddBadge: Boolean);
const
  BorderColor = $008C6546;
  BlueColor = $00E6A65C;
  PaleBlueColor = $00FBEAD8;
  GreenColor = $0057AD5B;
var
  C: TCanvas;

  function S(Value: Integer): Integer;
  begin
    Result := (Value * Bitmap.Width + 8) div 16;
  end;

  procedure Fill(L, T, R, B: Integer; Color: TColor);
  begin
    C.Brush.Color := Color;
    C.FillRect(Rect(S(L), S(T), S(R), S(B)));
  end;

  procedure Box(L, T, R, B: Integer; Color: TColor);
  begin
    C.Pen.Color := BorderColor;
    C.Brush.Color := Color;
    C.Rectangle(S(L), S(T), S(R), S(B));
  end;

  procedure Line(X1, Y1, X2, Y2: Integer; Color: TColor);
  begin
    C.Pen.Color := Color;
    C.Line(S(X1), S(Y1), S(X2), S(Y2));
  end;

begin
  Bitmap.PixelFormat := pf24bit;
  C := Bitmap.Canvas;
  C.Brush.Color := clFuchsia;
  C.FillRect(Rect(0, 0, Bitmap.Width, Bitmap.Height));
  C.Pen.Width := S(1);
  case Kind of
    eigEdit, eigComboBox, eigSpinEdit, eigFontName, eigColorCombo:
      begin
        Box(1, 3, 15, 13, clWhite);
        if Kind = eigEdit then
        begin
          Line(4, 7, 8, 7, BorderColor);
          Line(10, 5, 10, 11, BorderColor);
          Line(9, 5, 12, 5, BorderColor);
          Line(9, 10, 12, 10, BorderColor);
        end
        else
        begin
          Fill(10, 4, 14, 12, PaleBlueColor);
          Line(10, 4, 10, 12, BorderColor);
          if Kind = eigFontName then
          begin
            Line(3, 10, 5, 5, BorderColor);
            Line(5, 5, 8, 11, BorderColor);
            Line(4, 9, 7, 9, BorderColor);
          end
          else if Kind = eigColorCombo then
            Fill(3, 5, 8, 10, clRed)
          else
            Line(3, 7, 8, 7, BorderColor);
          if Kind in [eigComboBox, eigFontName, eigColorCombo] then
          begin
            Line(11, 7, 14, 7, BorderColor);
            Fill(12, 8, 13, 9, BorderColor);
          end
          else
          begin
            Line(10, 8, 14, 8, BorderColor);
            Fill(12, 5, 13, 6, BorderColor);
            Line(11, 6, 14, 6, BorderColor);
            Line(11, 10, 14, 10, BorderColor);
            Fill(12, 11, 13, 12, BorderColor);
          end;
        end;
      end;
    eigDateEdit:
      begin
        Box(1, 3, 15, 14, clWhite);
        Fill(2, 4, 14, 7, PaleBlueColor);
        Line(4, 1, 4, 5, BorderColor);
        Line(11, 1, 11, 5, BorderColor);
        Line(1, 7, 14, 7, BorderColor);
        Fill(4, 9, 6, 11, BlueColor);
        Fill(8, 9, 10, 11, BlueColor);
      end;
    eigStaticText:
      begin
        Line(2, 12, 6, 3, BorderColor);
        Line(6, 3, 10, 12, BorderColor);
        Line(4, 9, 9, 9, BorderColor);
        Line(1, 12, 5, 12, BorderColor);
        Line(8, 12, 12, 12, BorderColor);
        Line(11, 5, 15, 5, BlueColor);
        Line(11, 8, 15, 8, BlueColor);
      end;
    eigProgressBar:
      begin
        Box(1, 4, 15, 12, clWhite);
        Fill(3, 6, 5, 10, GreenColor);
        Fill(6, 6, 8, 10, GreenColor);
        Fill(9, 6, 11, 10, GreenColor);
      end;
    eigControlHost:
      begin
        Box(1, 2, 15, 14, clWhite);
        Fill(2, 3, 14, 5, BlueColor);
        Box(4, 7, 12, 12, PaleBlueColor);
        Fill(6, 8, 10, 10, $006FC8EF);
      end;
    eigSkinGallery:
      begin
        Box(1, 2, 15, 14, clWhite);
        Fill(3, 4, 7, 7, BlueColor);
        Fill(9, 4, 13, 7, $006FC8EF);
        Fill(3, 9, 7, 12, GreenColor);
        Fill(9, 9, 13, 12, $00B67AB2);
      end;
  end;
  if AddBadge then
  begin
    C.Pen.Color := $003C853C;
    C.Brush.Color := GreenColor;
    C.Ellipse(S(8), S(8), S(16), S(16));
    Line(10, 12, 15, 12, clWhite);
    Line(12, 10, 12, 15, clWhite);
  end;
  Bitmap.TransparentColor := clFuchsia;
  Bitmap.Transparent := True;
end;

function AddEditorItemGlyph(Images: TCustomImageList; Kind: TEditorItemGlyph;
  AddBadge: Boolean): Integer;
const
  Sizes: array[0..2] of Integer = (16, 24, 32);
var
  Bitmaps: array[0..2] of TCustomBitmap;
  I: Integer;
begin
  { Render each size directly so glyphs remain sharp at 100%, 150% and 200%. }
  Images.RegisterResolutions(Sizes);
  for I := Low(Bitmaps) to High(Bitmaps) do Bitmaps[I] := nil;
  try
    for I := Low(Bitmaps) to High(Bitmaps) do
    begin
      Bitmaps[I] := TBitmap.Create;
      Bitmaps[I].SetSize(Sizes[I], Sizes[I]);
      DrawEditorItemGlyph(TBitmap(Bitmaps[I]), Kind, AddBadge);
    end;
    Result := Images.AddMultipleResolutions(Bitmaps);
  finally
    for I := Low(Bitmaps) to High(Bitmaps) do Bitmaps[I].Free;
  end;
end;

{ TfrmLazRibbonEditWindow }

procedure TfrmLazRibbonEditWindow.EnsureExtendedMenuItems;
var
  MI: TMenuItem;
  I: Integer;
begin
  if FAddSkinGalleryAction <> nil then
    Exit;

  FAddSkinGalleryAction := TAction.Create(Self);
  FAddSkinGalleryAction.Caption := 'Skin Gallery';
  FAddSkinGalleryAction.Hint := 'Add LazRibbonSkinGalleryItem';
  FAddSkinGalleryAction.OnExecute := aAddSkinGalleryExecute;
  FSkinGalleryTreeImage := AddEditorItemGlyph(ilTreeImages, eigSkinGallery, False);
  FAddSkinGalleryAction.ImageIndex := AddEditorItemGlyph(ilActionImages,
    eigSkinGallery, True);
  if ActionList <> nil then
    FAddSkinGalleryAction.ActionList := ActionList;

  MI := TMenuItem.Create(Self);
  MI.Action := FAddSkinGalleryAction;
  MI.Caption := 'Skin Gallery';
  pmAddItem.Items.Add(MI);

  MI := TMenuItem.Create(Self);
  MI.Action := FAddSkinGalleryAction;
  MI.Caption := 'Skin Gallery';
  Additem1.Add(MI);

  for I := Low(FControlItemActions) to High(FControlItemActions) do
  begin
    FControlItemActions[I] := TAction.Create(Self);
    FControlItemActions[I].Caption := ControlItemCaptions[I];
    FControlItemActions[I].Hint := 'Add ' + ControlItemClasses[I].ClassName;
    FControlItemActions[I].Tag := I;
    FControlItemActions[I].OnExecute := AddControlItemExecute;
    FControlItemActions[I].ActionList := ActionList;
    FControlTreeImages[I] := AddEditorItemGlyph(ilTreeImages, TEditorItemGlyph(I), False);
    FControlItemActions[I].ImageIndex := AddEditorItemGlyph(ilActionImages,
      TEditorItemGlyph(I), True);
    MI := TMenuItem.Create(Self);
    MI.Action := FControlItemActions[I];
    pmAddItem.Items.Add(MI);
    MI := TMenuItem.Create(Self);
    MI.Action := FControlItemActions[I];
    Additem1.Add(MI);
  end;
  EnableControlItemActions(False);
end;

procedure TfrmLazRibbonEditWindow.AddControlItemExecute(Sender: TObject);
var
  I: Integer;
begin
  I := TAction(Sender).Tag;
  if (I >= Low(ControlItemClasses)) and (I <= High(ControlItemClasses)) then
    AddItem(ControlItemClasses[I]);
end;

procedure TfrmLazRibbonEditWindow.EnableControlItemActions(AEnabled: Boolean);
var
  I: Integer;
begin
  for I := Low(FControlItemActions) to High(FControlItemActions) do
    if FControlItemActions[I] <> nil then
      FControlItemActions[I].Enabled := AEnabled;
end;

function TfrmLazRibbonEditWindow.ItemImageIndex(ItemClass: TLazRibbonBaseItemClass): Integer;
var
  I: Integer;
begin
  if ItemClass.InheritsFrom(TLazRibbonSkinGalleryItem) then
    Exit(FSkinGalleryTreeImage);
  for I := Low(ControlItemClasses) to High(ControlItemClasses) do
    if ItemClass.InheritsFrom(ControlItemClasses[I]) then
      Exit(FControlTreeImages[I]);
  if ItemClass.InheritsFrom(TLazRibbonCustomRibbonExtItem) or
    ItemClass.InheritsFrom(TLazRibbonCustomControlItem) then
    Result := IDX_SMALLBUTTON
  else if ItemClass.InheritsFrom(TLazRibbonLargeButton) then
    Result := IDX_LARGEBUTTON
  else if ItemClass.InheritsFrom(TLazRibbonSmallButton) then
    Result := IDX_SMALLBUTTON
  else if ItemClass.InheritsFrom(TLazRibbonCheckbox) then
    Result := IDX_CHECKBOX
  else if ItemClass.InheritsFrom(TLazRibbonRadioButton) then
    Result := IDX_RADIOBUTTON
  else if ItemClass.InheritsFrom(TLazRibbonToggleSwitch) then
    Result := IDX_TOGGLESWITCH
  else if ItemClass.InheritsFrom(TLazRibbonSeparator) then
    Result := IDX_SEPARATOR
  else
    raise Exception.Create('Item class ' + ItemClass.ClassName + ' not supported');
end;

procedure TfrmLazRibbonEditWindow.aAddPaneExecute(Sender: TObject);
var
  Obj: TObject;
  Node: TTreeNode;
  NewNode: TTreeNode;
  Tab: TLazRibbonTab;
  Pane: TLazRibbonPane;
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;
  if FDesigner.PropertyEditorHook = nil then
    exit;

  Node := tvStructure.Selected;
  if Node = nil then
    raise Exception.Create('TfrmLazRibbonEditWindow.aAddPaneExecute: ' + RSNoObjectSelected);
  if Node.Data = nil then
    raise Exception.Create('TfrmLazRibbonEditWindow.aAddPaneExecute: ' + RSDamagedTreeStructure);

  Obj := TObject(Node.Data);
  if Obj is TLazRibbonTab then
  begin
    Tab := TLazRibbonTab(Obj);
    Pane := TLazRibbonPane.Create(FToolbar.Owner);
    Pane.Parent := FToolbar;
    Pane.Name := FDesigner.CreateUniqueComponentName(Pane.ClassName);
    Tab.Panes.AddItem(Pane);
    NewNode := tvStructure.Items.AddChild(Node, Pane.Caption);
    NewNode.Data := Pane;
    NewNode.ImageIndex := IDX_PANE;
    NewNode.SelectedIndex := NewNode.ImageIndex;
    NewNode.Selected := true;
    CheckActionsAvailability;
  end else
  if Obj is TLazRibbonPane then
  begin
    if not(CheckValidPaneNode(Node)) then
      raise Exception.Create('TfrmLazRibbonEditWindow.aAddPaneExecute: ' + RSDamagedTreeStructure);
    Tab := TLazRibbonTab(Node.Parent.Data);
    Pane := TLazRibbonPane.Create(FToolbar.Owner);
    Pane.Parent := FToolbar;
    Pane.Name := FDesigner.CreateUniqueComponentName(Pane.ClassName);
    Tab.Panes.AddItem(Pane);
    NewNode := tvStructure.Items.AddChild(Node.Parent, Pane.Caption);
    NewNode.Data := Pane;
    NewNode.ImageIndex := IDX_PANE;
    NewNode.SelectedIndex := NewNode.ImageIndex;
    NewNode.Selected := true;
    CheckActionsAvailability;
  end else
  if Obj is TLazRibbonBaseItem then
  begin
    if not(CheckValidItemNode(Node)) then
      raise Exception.Create('TfrmLazRibbonEditWindow.aAddPaneExecute: ' + RSDamagedTreeStructure);
    Tab := TLazRibbonTab(Node.Parent.Parent.Data);
    Pane := TLazRibbonPane.Create(FToolbar.Owner);
    Pane.Parent := FToolbar;
    Pane.Name := FDesigner.CreateUniqueComponentName(Pane.ClassName);
    Tab.Panes.AddItem(Pane);
    NewNode := tvStructure.Items.AddChild(Node.Parent.Parent, Pane.Caption);
    NewNode.Data := Pane;
    NewNode.ImageIndex := IDX_PANE;
    NewNode.SelectedIndex := NewNode.ImageIndex;
    NewNode.Selected := true;
    CheckActionsAvailability;
  end else
    raise Exception.Create('TfrmLazRibbonEditWindow.aAddPaneExecute: ' + RSIncorrectObjectInTree);

  FDesigner.PropertyEditorHook.PersistentAdded(Pane,True);
  MarkToolbarChanged;
end;

procedure TfrmLazRibbonEditWindow.aAddSmallButtonExecute(Sender: TObject);
begin
  AddItem(TLazRibbonSmallButton);
end;

procedure TfrmLazRibbonEditWindow.aAddLargeButtonExecute(Sender: TObject);
begin
  AddItem(TLazRibbonLargeButton);
end;

procedure TfrmLazRibbonEditWindow.aAddCheckboxExecute(Sender: TObject);
begin
  AddItem(TLazRibbonCheckbox);
end;

procedure TfrmLazRibbonEditWindow.aAddRadioButtonExecute(Sender: TObject);
begin
  AddItem(TLazRibbonRadioButton);
end;

procedure TfrmLazRibbonEditWindow.aAddSeparatorExecute(Sender: TObject);
begin
  AddItem(TLazRibbonSeparator);
end;

procedure TfrmLazRibbonEditWindow.aAddToggleSwitchExecute(Sender: TObject);
begin
  AddItem(TLazRibbonToggleSwitch);
end;

procedure TfrmLazRibbonEditWindow.aAddSkinGalleryExecute(Sender: TObject);
begin
  AddItem(TLazRibbonSkinGalleryItem);
end;

procedure TfrmLazRibbonEditWindow.aAddTabExecute(Sender: TObject);
var
  Node: TTreeNode;
  Tab: TLazRibbonTab;
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;
  if FDesigner.PropertyEditorHook = nil then
    exit;

  Tab := TLazRibbonTab.Create(FToolbar.Owner);
  Tab.Parent := FToolbar;
  FToolbar.Tabs.AddItem(Tab);
  Tab.Name := FDesigner.CreateUniqueComponentName(Tab.ClassName);
  Node := tvStructure.Items.AddChild(nil, Tab.Caption);
  Node.Data := Tab;
  Node.ImageIndex := IDX_TAB;
  Node.SelectedIndex := Node.ImageIndex;
  Node.Selected := true;
  CheckActionsAvailability;

  FDesigner.PropertyEditorHook.PersistentAdded(Tab,True);
  MarkToolbarChanged;
end;

procedure TfrmLazRibbonEditWindow.AddItem(ItemClass: TLazRibbonBaseItemClass);
var
  Node: TTreeNode;
  Obj: TObject;
  Pane: TLazRibbonPane;
  Item: TLazRibbonBaseItem;
  NewNode: TTreeNode;
  s: string;
begin
  if (FToolbar = nil) or (FDesigner = nil) then
   exit;
  if FDesigner.PropertyEditorHook = nil then
   exit;

  Node := tvStructure.Selected;
  if Node = nil then
    raise Exception.Create('TfrmLazRibbonEditWindow.AddItem: ' + RSNoObjectSelected);
  if Node.Data = nil then
    raise Exception.Create('TfrmLazRibbonEditWindow.AddItem: ' + RSDamagedTreeStructure);

  Obj := TObject(Node.Data);
  if Obj is TLazRibbonPane then
  begin
    Pane := TLazRibbonPane(Obj);
    Item := ItemClass.Create(FToolbar.Owner);
    Item.Parent := FToolbar;
    Pane.Items.AddItem(Item);
    Item.Name := FDesigner.CreateUniqueComponentName(Item.ClassName);
    s := GetItemCaption(Item);
    NewNode := tvStructure.Items.AddChild(Node, s);
    NewNode.Data := Item;
    NewNode.Selected := true;
    CheckActionsAvailability;
  end else
  if Obj is TLazRibbonBaseItem then
  begin
    if not CheckValidItemNode(Node) then
      raise Exception.Create('TfrmLazRibbonEditWindow.AddItem: ' + RSDamagedTreeStructure);
    Pane := TLazRibbonPane(Node.Parent.Data);
    Item := ItemClass.Create(FToolbar.Owner);
    Item.Parent := FToolbar;
    Pane.Items.AddItem(Item);
    Item.Name := FDesigner.CreateUniqueComponentName(Item.ClassName);
    s := GetItemCaption(Item);
    NewNode := tvStructure.Items.AddChild(Node.Parent, s);
    NewNode.Data := Item;
    NewNode.Selected := true;
    CheckActionsAvailability;
  end else
    raise Exception.Create('TfrmLazRibbonEditWindow.AddItem: ' + RSIncorrectObjectInTree);

  NewNode.ImageIndex := ItemImageIndex(ItemClass);
  NewNode.SelectedIndex := NewNode.ImageIndex;
  FDesigner.PropertyEditorHook.PersistentAdded(Item,True);
  MarkToolbarChanged;
end;

procedure TfrmLazRibbonEditWindow.aMoveDownExecute(Sender: TObject);
var
  Node: TTreeNode;
  Tab: TLazRibbonTab;
  Pane: TLazRibbonPane;
  Obj: TObject;
  index: Integer;
  Item: TLazRibbonBaseItem;
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;

  Node := tvStructure.Selected;
  if Node = nil then
    raise Exception.Create('TfrmLazRibbonEditWindow.aMoveDownExecute: ' + RSNoObjectSelectedToMove);
  if Node.Data = nil then
    raise Exception.Create('TfrmLazRibbonEditWindow.aMoveDownExecute: ' + RSDamagedTreeStructure);

  Obj := TObject(Node.Data);
  if Obj is TLazRibbonTab then
  begin
    if not CheckValidTabNode(Node) then
      raise Exception.Create('TfrmLazRibbonEditWindow.aMoveDownExecute: ' + RSDamagedTreeStructure);

    Tab := TLazRibbonTab(Node.Data);
    index := FToolbar.Tabs.IndexOf(Tab);
    if (index = -1) then
      raise Exception.Create('TfrmLazRibbonEditWindow.aMoveDownExecute: ' + RSDamagedTreeStructure);
    if (index = FToolbar.Tabs.Count - 1) then
      raise Exception.Create('TfrmLazRibbonEditWindow.aMoveDownExecute: ' + RSCannotMoveBeyondLastElement);

    FToolbar.Tabs.Exchange(index, index+1);
    FToolbar.TabIndex := index+1;

    Node.GetNextSibling.MoveTo(Node, naInsert);
    Node.Selected := true;
    CheckActionsAvailability;
  end
  else
  if Obj is TLazRibbonPane then
  begin
    if not CheckValidPaneNode(Node) then
      raise Exception.Create('TfrmLazRibbonEditWindow.aMoveDownExecute: ' + RSDamagedTreeStructure);

    Pane := TLazRibbonPane(Node.Data);
    Tab := TLazRibbonTab(Node.Parent.Data);

    index := Tab.Panes.IndexOf(Pane);
    if (index = -1) then
      raise Exception.Create('TfrmLazRibbonEditWindow.aMoveDownExecute: ' + RSDamagedTreeStructure);
    if (index = Tab.Panes.Count - 1) then
      raise Exception.Create('TfrmLazRibbonEditWindow.aMoveDownExecute: ' + RSCannotMoveBeyondLastElement);

    Tab.Panes.Exchange(index, index+1);

    Node.GetNextSibling.MoveTo(Node, naInsert);
    Node.Selected := true;
    CheckActionsAvailability;
  end
  else
  if Obj is TLazRibbonBaseItem then
  begin
    if not CheckValidItemNode(Node) then
      raise Exception.Create('TfrmLazRibbonEditWindow.aMoveDown.Execute: ' + RSDamagedTreeStructure);

    Item := TLazRibbonBaseItem(Node.Data);
    Pane := TLazRibbonPane(Node.Parent.Data);

    index := Pane.Items.IndexOf(Item);
    if (index = -1) then
      raise Exception.Create('TfrmLazRibbonEditWindow.aMoveDownExecute: ' + RSDamagedTreeStructure);
    if (index = Pane.Items.Count - 1) then
      raise Exception.Create('TfrmLazRibbonEditWindow.aMoveDownExecute: ' + RSCannotMoveBeyondLastElement);

    Pane.Items.Exchange(index, index+1);

    Node.GetNextSibling.MoveTo(Node, naInsert);
    Node.Selected := true;
    CheckActionsAvailability;
  end
  else
    raise Exception.Create('TfrmLazRibbonEditWindow.aMoveDownExecute: ' + RSIncorrectObjectInTree);
  MarkToolbarChanged;
end;

procedure TfrmLazRibbonEditWindow.aMoveUpExecute(Sender: TObject);
var
  Node: TTreeNode;
  Tab: TLazRibbonTab;
  Pane: TLazRibbonPane;
  Obj: TObject;
  index: Integer;
  Item: TLazRibbonBaseItem;
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;

  Node := tvStructure.Selected;
  if Node = nil then
    raise Exception.Create('TfrmLazRibbonEditWindow.aMoveUpExecute: '+ RSNoObjectSelectedToMove);
  if Node.Data = nil then
    raise Exception.Create('TfrmLazRibbonEditWindow.aMoveUpExecute: ' + RSDamagedTreeStructure);

  Obj := TObject(Node.Data);
  if Obj is TLazRibbonTab then
  begin
    if not CheckValidTabNode(Node) then
      raise Exception.Create('TfrmLazRibbonEditWindow.aMoveUpExecute: ' + RSDamagedTreeStructure);

    Tab := TLazRibbonTab(Node.Data);
    index := FToolbar.Tabs.IndexOf(Tab);
    if (index = -1) then
      raise Exception.Create('TfrmLazRibbonEditWindow.aMoveUpExecute: ' + RSDamagedTreeStructure);
    if (index = 0) then
      raise Exception.Create('TfrmLazRibbonEditWindow.aMoveUpExecute: ' + RSCannotMoveAboveFirstElement);

    FToolbar.Tabs.Exchange(index, index-1);
    FToolbar.TabIndex := index-1;

    Node.MoveTo(Node.getPrevSibling, naInsert);
    Node.Selected := true;
    CheckActionsAvailability;
  end
  else
  if Obj is TLazRibbonPane then
  begin
    if not CheckValidPaneNode(Node) then
      raise Exception.Create('TfrmLazRibbonEditWindow.aMoveUpExecute: ' + RSDamagedTreeStructure);

    Pane := TLazRibbonPane(Node.Data);
    Tab := TLazRibbonTab(Node.Parent.Data);
    index := Tab.Panes.IndexOf(Pane);
    if (index = -1) then
      raise Exception.Create('TfrmLazRibbonEditWindow.aMoveUpExecute: ' + RSDamagedTreeStructure);
    if (index = 0) then
      raise Exception.Create('TfrmLazRibbonEditWindow.aMoveUpExecute: ' + RSCannotMoveAboveFirstElement);

    Tab.Panes.Exchange(index, index-1);

    Node.MoveTo(Node.GetPrevSibling, naInsert);
    Node.Selected := true;
    CheckActionsAvailability;
  end
  else
  if Obj is TLazRibbonBaseItem then
  begin
    if not CheckValidItemNode(Node) then
      raise Exception.Create('TfrmLazRibbonEditWindow.aMoveUpExecute: ' + RSDamagedTreeStructure);

    Item := TLazRibbonBaseItem(Node.Data);
    Pane := TLazRibbonPane(Node.Parent.Data);
    index := Pane.Items.IndexOf(Item);
    if (index = -1) then
      raise Exception.Create('TfrmLazRibbonEditWindow.aMoveUpExecute: ' + RSDamagedTreeStructure);
    if (index = 0) then
      raise Exception.Create('TfrmLazRibbonEditWindow.aMoveUpExecute: ' + RSCannotMoveAboveFirstElement);

    Pane.Items.Exchange(index, index-1);

    Node.MoveTo(Node.GetPrevSibling, naInsert);
    Node.Selected := true;
    CheckActionsAvailability;
  end else
    raise Exception.Create('TfrmLazRibbonEditWindow.aMoveUpExecute: ' + RSIncorrectObjectInTree);
  MarkToolbarChanged;
end;

procedure TfrmLazRibbonEditWindow.aRemoveItemExecute(Sender: TObject);
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;
  DoRemoveItem;
end;

procedure TfrmLazRibbonEditWindow.aRemovePaneExecute(Sender: TObject);

begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;
  DoRemovePane;
end;

procedure TfrmLazRibbonEditWindow.aRemoveTabExecute(Sender: TObject);
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;
  DoRemoveTab;
end;

procedure TfrmLazRibbonEditWindow.CheckActionsAvailability;
var
  Node: TTreeNode;
  Obj: TObject;
  Tab: TLazRibbonTab;
  Pane: TLazRibbonPane;
  index: integer;
  Item: TLazRibbonBaseItem;
begin
  if (FToolbar = nil) or (FDesigner = nil) then
  begin
    // Brak toolbara lub designera
    aAddTab.Enabled := false;
    aRemoveTab.Enabled := false;
    aAddPane.Enabled := false;
    aRemovePane.Enabled := false;
    aAddLargeButton.Enabled := false;
    aAddSmallButton.Enabled := false;
    aAddCheckbox.Enabled := false;
    aAddRadioButton.Enabled := false;
    aAddToggleSwitch.Enabled := false;
    if FAddSkinGalleryAction <> nil then FAddSkinGalleryAction.Enabled := false;
    EnableControlItemActions(false);
    aRemoveItem.Enabled := false;
    aAddSeparator.Enabled := false;
    aMoveUp.Enabled := false;
    aMoveDown.Enabled := false;
  end
  else
  begin
    Node := tvStructure.Selected;
    if Node = nil then
    begin
      // Pusty toolbar
      aAddTab.Enabled := true;
      aRemoveTab.Enabled := false;
      aAddPane.Enabled := false;
      aRemovePane.Enabled := false;
      aAddLargeButton.Enabled := false;
      aAddSmallButton.Enabled := false;
      aAddCheckbox.Enabled := false;
      aAddRadioButton.Enabled := false;
      aAddSeparator.Enabled := false;
      aAddToggleSwitch.Enabled := false;
      if FAddSkinGalleryAction <> nil then FAddSkinGalleryAction.Enabled := false;
      EnableControlItemActions(false);
      aRemoveItem.Enabled := false;
      aMoveUp.Enabled := false;
      aMoveDown.Enabled := false;
    end
    else
    begin
      Obj := TObject(Node.Data);
      if Obj = nil then
        raise Exception.Create('TfrmLazRibbonEditWindow.CheckActionsAvailability: ' + RSIncorrectFieldData);

      if Obj is TLazRibbonTab then
      begin
        Tab := Obj as TLazRibbonTab;

        if not CheckValidTabNode(Node) then
          raise Exception.Create('TfrmLazRibbonEditWindow.CheckActionsAvailability: ' + RSDamagedTreeStructure);

        aAddTab.Enabled := true;
        aRemoveTab.Enabled := true;
        aAddPane.Enabled := true;
        aRemovePane.Enabled := false;
        aAddLargeButton.Enabled := false;
        aAddSmallButton.Enabled := false;
        aAddCheckbox.Enabled := false;
        aAddRadioButton.Enabled := false;
        aAddToggleSwitch.Enabled := false;
        aAddSeparator.Enabled := false;
        if FAddSkinGalleryAction <> nil then FAddSkinGalleryAction.Enabled := false;
        EnableControlItemActions(false);
        aRemoveItem.Enabled := false;

        index := FToolbar.Tabs.IndexOf(Tab);
        if index = -1 then
          raise Exception.Create('TfrmLazRibbonEditWindow.CheckActionsAvailability: ' + RSDamagedTreeStructure);

        aMoveUp.Enabled := (index > 0);
        aMoveDown.enabled := (index < FToolbar.Tabs.Count-1);
      end else
      if Obj is TLazRibbonPane then
      begin
        Pane := TLazRibbonPane(Obj);
        if not(CheckValidPaneNode(Node)) then
          raise Exception.Create('TfrmLazRibbonEditWindow.CheckActionsAvailability: ' + RSDamagedTreeStructure);

        Tab := TLazRibbonTab(Node.Parent.Data);

        aAddTab.Enabled := true;
        aRemoveTab.Enabled := false;
        aAddPane.Enabled := true;
        aRemovePane.Enabled := true;
        aAddLargeButton.Enabled := true;
        aAddSmallButton.Enabled := true;
        aAddCheckbox.Enabled := true;
        aAddRadiobutton.Enabled := true;
        aAddToggleSwitch.Enabled := true;
        if FAddSkinGalleryAction <> nil then FAddSkinGalleryAction.Enabled := true;
        EnableControlItemActions(true);
        aAddSeparator.Enabled := true;
        aRemoveItem.Enabled := false;

        index := Tab.Panes.IndexOf(Pane);
        if index = -1 then
          raise Exception.Create('TfrmLazRibbonEditWindow.CheckActionsAvailability: ' + RSDamagedTreeStructure);

        aMoveUp.Enabled := (index > 0);
        aMoveDown.Enabled := (index < Tab.Panes.Count-1);
      end else
      if Obj is TLazRibbonBaseItem then
      begin
        Item := TLazRibbonBaseItem(Obj);
        if not CheckValidItemNode(Node) then
          raise Exception.Create('TfrmLazRibbonEditWindow.CheckActionsAvailability: ' + RSDamagedTreeStructure);

        Pane := TLazRibbonPane(Node.Parent.Data);

        aAddTab.Enabled := true;
        aRemoveTab.Enabled := false;
        aAddPane.Enabled := true;
        aRemovePane.Enabled := false;
        aAddLargeButton.Enabled := true;
        aAddSmallButton.Enabled := true;
        aAddCheckbox.Enabled := true;
        aAddRadioButton.Enabled := true;
        aAddToggleSwitch.Enabled := true;
        if FAddSkinGalleryAction <> nil then FAddSkinGalleryAction.Enabled := true;
        EnableControlItemActions(true);
        aAddSeparator.Enabled := true;
        aRemoveItem.Enabled := true;

        index := Pane.Items.IndexOf(Item);
        if index = -1 then
          raise Exception.Create('TfrmLazRibbonEditWindow.CheckActionsAvailability: ' + RSDamagedTreeStructure);

        aMoveUp.Enabled := (index > 0);
        aMoveDown.Enabled := (index < Pane.Items.Count - 1);
      end else
        raise Exception.Create('TfrmLazRibbonEditWindow.CheckActionsAvailability: ' + RSIncorrectObjectInTree);
    end;
  end;
end;

function TfrmLazRibbonEditWindow.CheckValidItemNode(Node: TTreeNode): boolean;
begin
  Result := false;
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;
  {$B-}
  Result:=(Node <> nil) and
          (Node.Data <> nil) and
          (TObject(Node.Data) is TLazRibbonBaseItem) and
          CheckValidPaneNode(Node.Parent);
end;

function TfrmLazRibbonEditWindow.CheckValidPaneNode(Node: TTreeNode): boolean;
begin
  Result := false;
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;
  {$B-}
  Result := (Node <> nil) and
            (Node.Data <> nil) and
            (TObject(Node.Data) is TLazRibbonPane) and
            CheckValidTabNode(Node.Parent);
end;

function TfrmLazRibbonEditWindow.CheckValidTabNode(Node: TTreeNode): boolean;
begin
  Result := false;
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;
  {$B-}
  result := (Node <> nil) and
            (Node.Data <> nil) and
            (TObject(Node.Data) is TLazRibbonTab);
end;

procedure TfrmLazRibbonEditWindow.FormActivate(Sender: TObject);
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;
//  UpdatePPI;
  if not ValidateTreeData then
    BuildTreeData;
end;

procedure TfrmLazRibbonEditWindow.FormDestroy(Sender: TObject);
begin
  if FToolbar <> nil then
    FToolbar.RemoveFreeNotification(self);
end;

procedure TfrmLazRibbonEditWindow.FormShow(Sender: TObject);
begin
  EnsureExtendedMenuItems;
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;
  BuildTreeData;
end;

function TfrmLazRibbonEditWindow.GetItemCaption(Item: TLazRibbonBaseItem): string;
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;
  if Item is TLazRibbonBaseButton then
    Result := TLazRibbonBaseButton(Item).Caption
  else if Item is TLazRibbonCustomRibbonExtItem then
    Result := TLazRibbonCustomRibbonExtItem(Item).Caption
  else if Item is TLazRibbonCustomControlItem then
    Result := TLazRibbonCustomControlItem(Item).Caption
  else
    Result := '<Unknown caption>';
end;

procedure TfrmLazRibbonEditWindow.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;

  if (AComponent = FToolbar) and (Operation = opRemove) then
  begin
    // The toolbar is currently released, whose content is displayed in the
    // editor window. Need to clean up the content - otherwise the window will
    // have references to the already removed toolbars, which will end in AVs ...
    SetData(nil, nil);
  end;
end;

procedure TfrmLazRibbonEditWindow.MarkToolbarChanged;
begin
  if FToolbar <> nil then
    FToolbar.ForceRepaint;
  if FDesigner <> nil then
    FDesigner.Modified;
end;

procedure TfrmLazRibbonEditWindow.SetItemCaption(Item: TLazRibbonBaseItem; const Value : string);
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;

  if Item is TLazRibbonBaseButton then
    TLazRibbonBaseButton(Item).Caption := Value
  else if Item is TLazRibbonCustomRibbonExtItem then
    TLazRibbonCustomRibbonExtItem(Item).Caption := Value
  else if Item is TLazRibbonCustomControlItem then
    TLazRibbonCustomControlItem(Item).Caption := Value;
end;

procedure TfrmLazRibbonEditWindow.SetData(AToolbar: TLazRibbon; ADesigner: TComponentEditorDesigner);
begin
  EnsureExtendedMenuItems;
  if FToolbar <> nil then
    FToolbar.RemoveFreeNotification(self);

  FToolbar := AToolbar;
  FDesigner := ADesigner;

  if FToolbar <> nil then
    FToolbar.FreeNotification(self);

  BuildTreeData;
end;

procedure TfrmLazRibbonEditWindow.DoRemoveItem;
var
  Item: TLazRibbonBaseItem;
  index: Integer;
  Node: TTreeNode;
  Pane: TLazRibbonPane;
  NextNode: TTreeNode;
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;

  Node := tvStructure.Selected;
  if not (CheckValidItemNode(Node)) then
    raise Exception.Create('TfrmLazRibbonEditWindow.aRemoveItemExecute: ' + RSDamagedTreeStructure);
  Item := TLazRibbonBaseItem(Node.Data);
  Pane := TLazRibbonPane(Node.Parent.Data);
  index := Pane.Items.IndexOf(Item);
  if index = -1 then
    raise Exception.Create('TfrmLazRibbonEditWindow.aRemoveItemExecute: ' + RSDamagedTreeStructure);
  if Node.getPrevSibling <> nil then
    NextNode := Node.getPrevSibling
  else if Node.GetNextSibling <> nil then
    NextNode := Node.getNextSibling
  else
    NextNode := Node.Parent;
  Pane.Items.Delete(index);
  tvStructure.Items.delete(node);
  NextNode.Selected := true;
  CheckActionsAvailability;
  MarkToolbarChanged;
end;

procedure TfrmLazRibbonEditWindow.DoRemovePane;
var
  Pane: TLazRibbonPane;
  NextNode: TTreeNode;
  index: Integer;
  Node: TTreeNode;
  Tab: TLazRibbonTab;
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;

  Node := tvStructure.Selected;
  if not (CheckValidPaneNode(Node)) then
    raise Exception.Create('TfrmLazRibbonEditWindow.aRemovePaneExecute: ' + RSDamagedTreeStructure);
  Pane := TLazRibbonPane(Node.Data);
  Tab := TLazRibbonTab(Node.Parent.Data);
  index := Tab.Panes.IndexOf(Pane);
  if index = -1 then
    raise Exception.Create('TfrmLazRibbonEditWindow.aRemovePaneExecute: ' + RSDamagedTreeStructure);
  if Node.GetPrevSibling <> nil then
    NextNode := Node.GetPrevSibling
  else if Node.GetNextSibling <> nil then
    NextNode := Node.GetNextSibling
  else
    NextNode := Node.Parent;
  Tab.Panes.Delete(index);
  tvStructure.Items.Delete(Node);
  NextNode.Selected := true;
  CheckActionsAvailability;
  MarkToolbarChanged;
end;

procedure TfrmLazRibbonEditWindow.DoRemoveTab;
var
  Node: TTreeNode;
  Tab: TLazRibbonTab;
  index: Integer;
  NextNode: TTreeNode;
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;

  Node := tvStructure.Selected;
  if not (CheckValidTabNode(Node)) then
    raise Exception.Create('TfrmLazRibbonEditWindow.aRemoveTabExecute: ' + RSDamagedTreeStructure);
  Tab := TLazRibbonTab(Node.Data);
  index := FToolbar.Tabs.IndexOf(Tab);
  if index = -1 then
    raise Exception.Create('TfrmLazRibbonEditWindow.aRemoveTabExecute: ' + RSDamagedTreeStructure);
  if Node.GetPrevSibling <> nil then
    NextNode := Node.GetPrevSibling
  else if Node.GetNextSibling <> nil then
    NextNode := Node.GetNextSibling
  else
    NextNode := nil;
  FToolbar.Tabs.Delete(index);
  tvStructure.Items.Delete(Node);
  if Assigned(NextNode) then
  begin
    // The OnChange event will trigger an update of the selected object in
    // the Object Inspector
    NextNode.Selected := true;
    CheckActionsAvailability;
  end
  else
  begin
    // There are no more objects in the list, but something has to be displayed
    // in the Object Inspector - so we will display the toolbars itself
    // (otherwise the IDE will attempt to display the object's properties in
    // the Object Inspector, which will end, say, not very nice)
    //DesignObj := PersistentToDesignObject(FToolbar);
    FDesigner.SelectOnlyThisComponent(FToolbar);
    CheckActionsAvailability;
  end;
  MarkToolbarChanged;
end;

procedure TfrmLazRibbonEditWindow.BuildTreeData;
var
  i: Integer;
  panenode: TTreeNode;
  j: Integer;
  tabnode: TTreeNode;
  k : Integer;
  itemnode: TTreeNode;
  Obj: TLazRibbonBaseItem;
  s: string;
  node: TTreeNode;
begin
  Caption:='Editing TLazRibbon contents';

  // Clear tree, but don't remove existing toolbar children from the form
  tvStructure.OnDeletion := nil;
  tvStructure.Items.Clear;
  tvStructure.OnDeletion := tvStructureDeletion;

  if (FToolbar <> nil) and (FDesigner <> nil) then
  begin
    for i := 0 to FToolbar.Tabs.Count - 1 do
    begin
      tabnode := tvStructure.Items.AddChild(nil, FToolbar.Tabs[i].Caption);
      tabnode.ImageIndex := IDX_TAB;
      tabnode.SelectedIndex := tabnode.ImageIndex;
      tabnode.Data := FToolbar.Tabs[i];
      for j := 0 to FToolbar.Tabs.Items[i].Panes.Count - 1 do
      begin
        panenode := tvStructure.Items.AddChild(tabnode, FToolbar.Tabs[i].Panes[j].Caption);
        panenode.ImageIndex := IDX_PANE;
        panenode.SelectedIndex := panenode.ImageIndex;
        panenode.Data := FToolbar.Tabs[i].Panes[j];
        for k := 0 to FToolbar.Tabs[i].Panes[j].Items.Count - 1 do
        begin
          Obj := FToolbar.Tabs[i].Panes[j].Items[k];
          s := GetItemCaption(Obj);
          itemnode := tvStructure.Items.AddChild(panenode,s);
          itemnode.ImageIndex := ItemImageIndex(TLazRibbonBaseItemClass(Obj.ClassType));
          itemnode.Selectedindex := itemnode.ImageIndex;
          itemnode.Data := Obj;
        end;
      end;
    end;
  end;

  if (tvStructure.Items.Count > 0) and (FToolbar.TabIndex > -1) then begin
    node := tvStructure.Items[0];
    while (node <> nil) do begin
      if TLazRibbonTab(node.Data) = FToolbar.Tabs[FToolbar.TabIndex] then break;
      node := node.GetNextSibling;
    end;
    if (node <> nil) then begin
      node.Selected := true;
      node.Expand(true);
    end;
  end;

  CheckActionsAvailability;
end;

procedure TfrmLazRibbonEditWindow.RefreshNames;
var
  tabnode, panenode, itemnode: TTreeNode;
  Obj: TLazRibbonBaseItem;
  s: string;

begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;

  tabnode := tvStructure.Items.GetFirstNode;
  while tabnode<>nil do
  begin
    if not CheckValidTabNode(tabnode) then
      raise Exception.Create('TfrmLazRibbonEditWindow.RefreshNames: ' + RSDamagedTreeStructure);

    tabnode.Text := TLazRibbonTab(tabnode.Data).Caption;

    panenode := tabnode.getFirstChild;
    while panenode <> nil do
    begin
      if not CheckValidPaneNode(panenode) then
        raise Exception.Create('TfrmLazRibbonEditWindow.RefreshNames: ' + RSDamagedTreeStructure);

      panenode.Text := TLazRibbonPane(panenode.Data).Caption;

      itemnode := panenode.getFirstChild;
      while itemnode <> nil do
      begin
        if not CheckValidItemNode(itemnode) then
          raise Exception.Create('TfrmLazRibbonEditWindow.RefreshNames: ' + RSDamagedTreeStructure);

        Obj := TLazRibbonBaseItem(itemnode.Data);
        s := GetItemCaption(Obj);
        itemnode.Text := s;
        itemnode := itemnode.getNextSibling;
      end;

      panenode := panenode.getNextSibling;
    end;

    tabnode := tabnode.getNextSibling;
  end;
end;

procedure TfrmLazRibbonEditWindow.tvStructureChange(Sender: TObject; Node: TTreeNode);
var
  Obj: TObject;
  Tab: TLazRibbonTab;
  Pane: TLazRibbonPane;
  Item: TLazRibbonBaseItem;
  index: integer;
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;

  if Assigned(Node) then
  begin
    Obj := TObject(Node.Data);
    if Obj = nil then
      raise Exception.Create('TfrmLazRibbonEditWindow.tvStructureChange: ' + RSIncorrectFieldData);
    if Obj is TLazRibbonTab then
    begin
      Tab := TLazRibbonTab(Obj);
      FDesigner.SelectOnlyThisComponent(Tab);
      index := FToolbar.Tabs.IndexOf(Tab);
      if index=-1 then
        raise Exception.Create('TfrmLazRibbonEditWindow.tvStructureChange: ' + RSDamagedTreeStructure);
      FToolbar.TabIndex := index;
    end else
    if Obj is TLazRibbonPane then
    begin
      Pane := TLazRibbonPane(Obj);
      FDesigner.SelectOnlyThisComponent(Pane);
      if not(CheckValidPaneNode(Node)) then
        raise Exception.Create('TfrmLazRibbonEditWindow.tvStructureChange: ' + RSDamagedTreeStructure);
      Tab := TLazRibbonTab(Node.Parent.Data);
      index := FToolbar.Tabs.IndexOf(Tab);
      if index = -1 then
        raise Exception.Create('TfrmLazRibbonEditWindow.tvStructureChange: ' + RSDamagedTreeStructure);
      FToolbar.TabIndex := index;
    end else
    if Obj is TLazRibbonBaseItem then
    begin
      Item := TLazRibbonBaseItem(Obj);
      FDesigner.SelectOnlyThisComponent(Item);
      if not CheckValidItemNode(Node) then
        raise Exception.Create('TfrmLazRibbonEditWindow.tvStructureChange: ' + RSDamagedTreeStructure);
      Tab := TLazRibbonTab(Node.Parent.Parent.Data);
      index := FToolbar.Tabs.IndexOf(Tab);
      if index = -1 then
        raise Exception.Create('TfrmLazRibbonEditWindow.tvStructureChange: ' + RSDamagedTreeStructure);
      FToolbar.TabIndex := index;
    end else
      raise Exception.Create('TfrmLazRibbonEditWindow.tvStructureChange: ' + RSIncorrectObjectInTree);
   end else
     FDesigner.SelectOnlyThisComponent(FToolbar);

  CheckActionsAvailability;
end;

procedure TfrmLazRibbonEditWindow.ilTreeImagesGetWidthForPPI(Sender: TCustomImageList;
  AImageWidth, APPI: Integer; var AResultWidth: Integer);
begin
  AResultWidth := AImageWidth * APPI div 96;
end;

procedure TfrmLazRibbonEditWindow.ilActionImagesGetWidthForPPI(Sender: TCustomImageList;
  AImageWidth, APPI: Integer; var AResultWidth: Integer);
begin
  AResultWidth := AImageWidth * APPI div 96;
end;

procedure TfrmLazRibbonEditWindow.tvStructureDeletion(Sender:TObject; Node:TTreeNode);
var
  Item: TObject;
begin
  if Node = nil then
    exit;
  // Recursively delete children and destroy their data
  while Node.GetFirstChild <> nil do
    Node.GetFirstChild.Delete;
  // Destroy node's data
  Item := TObject(Node.Data);
  Node.Data := nil;
  Item.Free;
end;

procedure TfrmLazRibbonEditWindow.tvStructureEdited(Sender: TObject; Node: TTreeNode;
  var S: string);
var
  Tab: TLazRibbonTab;
  Pane: TLazRibbonPane;
  Item: TLazRibbonBaseItem;
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;

  if Node.Data = nil then
    raise Exception.Create('TfrmLazRibbonEditWindow.tvStructureEdited: ' + RSDamagedTreeStructure);

  if TObject(Node.Data) is TLazRibbonTab then
  begin
    Tab := TLazRibbonTab(Node.Data);
    Tab.Caption := S;
    MarkToolbarChanged;
  end else
  if TObject(Node.Data) is TLazRibbonPane then
  begin
    Pane := TLazRibbonPane(Node.Data);
    Pane.Caption := S;
    MarkToolbarChanged;
  end else
  if TObject(Node.Data) is TLazRibbonBaseItem then
  begin
    Item := TLazRibbonBaseItem(Node.Data);
    SetItemCaption(Item, S);
    MarkToolbarChanged;
  end else
    raise Exception.Create('TfrmLazRibbonEditWindow.tvStructureEdited: ' + RSDamagedTreeStructure);
end;

procedure TfrmLazRibbonEditWindow.tvStructureKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;

  if Key = VK_DELETE then
  begin
    if tvStructure.Selected <> nil then
    begin
      // We check what kind of object is selected - just test the type of the object
      if TObject(tvStructure.Selected.Data) is TLazRibbonTab then
        DoRemoveTab
      else if TObject(tvStructure.Selected.Data) is TLazRibbonPane then
        DoRemovePane
      else if TObject(tvStructure.Selected.Data) is TLazRibbonBaseItem then
        DoRemoveItem
      else
        raise Exception.Create('TfrmLazRibbonEditWindow.tvStructureKeyDown: ' + RSDamagedTreeStructure);
    end;
   end;
end;

function TfrmLazRibbonEditWindow.ValidateTreeData: boolean;
var
  i: Integer;
  TabsValid: Boolean;
  TabNode: TTreeNode;
  j: Integer;
  PanesValid: Boolean;
  PaneNode: TTreeNode;
  k: Integer;
  ItemsValid: Boolean;
  ItemNode: TTreeNode;
begin
  Result := false;
  if (FToolbar = nil) or (FDesigner = nil) then
    exit;

  i := 0;
  TabsValid := true;
  TabNode := tvStructure.Items.GetFirstNode;

  while (i < FToolbar.Tabs.Count) and TabsValid do
  begin
    TabsValid := TabsValid and (TabNode <> nil);
    if TabsValid then
      TabsValid := TabsValid and (TabNode.Data = FToolbar.Tabs[i]);
    if TabsValid then
    begin
      j := 0;
      PanesValid := true;
      PaneNode := TabNode.GetFirstChild;
      while (j < FToolbar.Tabs[i].Panes.Count) and PanesValid do
      begin
        PanesValid := PanesValid and (PaneNode <> nil);
        if PanesValid then
          PanesValid := PanesValid and (PaneNode.Data = FToolbar.Tabs[i].Panes[j]);
        if PanesValid then
        begin
          k := 0;
          ItemsValid := true;
          ItemNode := PaneNode.GetFirstChild;
          while (k < FToolbar.Tabs[i].Panes[j].Items.Count) and ItemsValid do
          begin
            ItemsValid := ItemsValid and (ItemNode <> nil);
            if ItemsValid then
              ItemsValid := ItemsValid and (ItemNode.Data = FToolbar.Tabs[i].Panes[j].Items[k]);
            if ItemsValid then
            begin
              inc(k);
              ItemNode := ItemNode.GetNextSibling;
            end;
          end;

          // Important! You need to make sure that there are no extra items in the tree!
          ItemsValid := ItemsValid and (ItemNode = nil);
          PanesValid := PanesValid and ItemsValid;
        end;

        if PanesValid then
        begin
          inc(j);
          PaneNode := PaneNode.GetNextSibling;
        end;
      end;

      // Important! You need to make sure that there are no extra items in the tree!
      PanesValid := PanesValid and (PaneNode = nil);
      TabsValid := TabsValid and PanesValid;
    end;

    if TabsValid then
    begin
      inc(i);
      TabNode := TabNode.GetNextSibling;
    end;
  end;

  // Important! You need to make sure that there are no extra items in the tree!
  TabsValid := TabsValid and (TabNode = nil);
  Result := TabsValid;
end;


end.
