program runtime_audit;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, Classes, SysUtils, Graphics, Math, Menus, StdCtrls, Controls,
  LCLType, LMessages,
  LazRibbon_Math, LazRibbon_GraphTools, LazRibbon_Types,
  LazRibbon_Core, LazRibbon_Tabs, LazRibbon_Groups, LazRibbon_Buttons,
  LazRibbon_XMLParser, LazRibbon_XMLIni, LazRibbon_XMLTools,
  LazRibbon_SkinManager, LazRibbon_Popup, LazRibbon_ControlItems, control_items_audit;

type
  TCollectionAccess = class(TLazRibbonCollection)
  public
    procedure QueueName(const AName: String);
  end;

  TSkinObserver = class(TComponent)
  public
    Calls: Integer;
    RemoveListener: TComponent;
    RegisterListener: TSkinObserver;
    RemoveSelf: Boolean;
    procedure SkinChanged(Sender: TObject);
  end;

  TPopupObserver = class
    Opens, Closes, Selections: Integer;
    LastTag: PtrInt;
    procedure Opened(Sender: TObject);
    procedure Closed(Sender: TObject);
    procedure Selected(Sender: TObject; Entry: TLazRibbonPopupEntry);
  end;

  TColorComboObserver = class
    Changes, Applies: Integer;
    procedure Changed(Sender: TObject);
    procedure Applied(Sender: TObject);
  end;

var
  Checks, Failures: Integer;

procedure Check(ACondition: Boolean; const ADescription: String);
begin
  Inc(Checks);
  if not ACondition then
  begin
    Inc(Failures);
    WriteLn('FAIL: ', ADescription);
  end;
end;

procedure TCollectionAccess.QueueName(const AName: String);
begin
  FNames.Add(AName);
end;

procedure TSkinObserver.SkinChanged(Sender: TObject);
begin
  Inc(Calls);
  if RemoveListener <> nil then
    LazUnregisterSkinChangeHandler(RemoveListener);
  if RegisterListener <> nil then
    LazRegisterSkinChangeHandler(RegisterListener, @RegisterListener.SkinChanged);
  if RemoveSelf then
    LazUnregisterSkinChangeHandler(Self);
end;

procedure TPopupObserver.Opened(Sender: TObject);
begin
  Inc(Opens);
end;

procedure TPopupObserver.Closed(Sender: TObject);
begin
  Inc(Closes);
end;

procedure TPopupObserver.Selected(Sender: TObject; Entry: TLazRibbonPopupEntry);
begin
  Inc(Selections);
  LastTag := Entry.Tag;
end;

procedure TColorComboObserver.Changed(Sender: TObject);
begin
  Inc(Changes);
end;

procedure TColorComboObserver.Applied(Sender: TObject);
begin
  Inc(Applies);
end;

procedure TestGeometry;
var
  R, Other: T2DRect;
  P, V: T2DVector;
  IR, LT, RT, LB, RB: T2DIntRect;
begin
  R.Create(0, 0, 10, 30);
  P.Create(15, 5);
  Check(not R.Contains(P), 'Containment rejects points to the right');
  P.Create(5, 20);
  Check(R.Contains(P), 'Containment accepts tall-rectangle interior');
  Other.Create(2, 2, 8, 8);
  Check(R.IntersectsWith(Other) and Other.IntersectsWith(R),
    'Rectangle containment is a symmetric intersection');
  Other.Create(11, 0, 20, 10);
  Check(not R.IntersectsWith(Other), 'Separated rectangles do not intersect');
  P.Create(1, 0);
  V.Create(2, 0);
  Check(P.OrientationWith(V) = 0, 'Collinear vectors have zero orientation');
  V.Create(0, 1);
  Check(P.OrientationWith(V) = 1, 'Counterclockwise orientation is positive');
  V.Create(0, -1);
  Check(P.OrientationWith(V) = -1, 'Clockwise orientation is negative');
  V.Create(1, 1e-14);
  Check(P.OrientationWith(V) = 0, 'Near-collinear orientation respects tolerance');
  IR.Create(0, 0, 7, 7);
  IR.Split(LT, RT, LB, RB);
  Check((LT.Left = 0) and (LT.Top = 0) and (LT.Right = 3) and (LT.Bottom = 3), 'Top-left quadrant');
  Check((RT.Left = 4) and (RT.Top = 0) and (RT.Right = 7) and (RT.Bottom = 3), 'Top-right quadrant');
  Check((LB.Left = 0) and (LB.Top = 4) and (LB.Right = 3) and (LB.Bottom = 7), 'Bottom-left quadrant');
  Check((RB.Left = 4) and (RB.Top = 4) and (RB.Right = 7) and (RB.Bottom = 7), 'Bottom-right quadrant');
end;

procedure TestColors;
var
  R, G, B: Integer;
  RGB, Back: TRGBTriple;
  HSL: THSLTriple;
begin
  for R := 0 to 5 do
    for G := 0 to 5 do
      for B := 0 to 5 do
      begin
        RGB.rgbtRed := R * 51;
        RGB.rgbtGreen := G * 51;
        RGB.rgbtBlue := B * 51;
        HSL := TColorTools.RGB2HSL(RGB);
        Back := TColorTools.HSL2RGB(HSL);
        Check((Abs(Back.rgbtRed - RGB.rgbtRed) <= 1) and
          (Abs(Back.rgbtGreen - RGB.rgbtGreen) <= 1) and
          (Abs(Back.rgbtBlue - RGB.rgbtBlue) <= 1),
          Format('RGB/HSL round trip %d,%d,%d', [R * 51, G * 51, B * 51]));
      end;
  RGB.rgbtRed := 255;
  RGB.rgbtGreen := 255;
  RGB.rgbtBlue := 255;
  HSL := TColorTools.RGB2HSL(RGB);
  Check(SameValue(HSL.L, 1) and SameValue(HSL.S, 0), 'White has full lightness and zero saturation');
end;

procedure TestCollections;
var
  Owner: TComponent;
  Collection: TCollectionAccess;
  OtherCollection: TCollectionAccess;
  Item: TLazRibbonComponent;
  Ribbon: TLazRibbon;
  Tab: TLazRibbonTab;
  Pane: TLazRibbonPane;
  Button: TLazRibbonLargeButton;
begin
  Owner := TComponent.Create(nil);
  Collection := TCollectionAccess.Create(Owner);
  try
    Item := TLazRibbonComponent.Create(Owner);
    Item.Name := 'AuditItem';
    Collection.AddItem(Item);
    Collection.AddItem(Item);
    Check(Collection.Count = 1, 'Repeated registration does not duplicate a component');
    OtherCollection := TCollectionAccess.Create(Owner);
    try
      OtherCollection.AddItem(Item);
      Check((Collection.Count = 0) and (Item.Collection = OtherCollection),
        'Moving a component detaches its previous collection');
      Collection.AddItem(Item);
    finally
      OtherCollection.Free;
    end;
    try
      Collection.AddItem(nil);
      Check(False, 'Nil collection entries must be rejected');
    except
      on E: Exception do Check(Collection.Count = 1, 'Nil entries are rejected before mutation');
    end;
    Collection.Clear;
    Check(Item.Collection = nil, 'Clear detaches collection back-pointer');
    Collection.AddItem(Item);
    Collection.Delete(0);
    Check(Item.Collection = nil, 'Delete detaches collection back-pointer');
    Collection.AddItem(Item);
    Collection.RemoveReference(Item);
    Check(Item.Collection = nil, 'RemoveReference detaches collection back-pointer');
    Collection.AddItem(Item);
    Item.Free;
    Check(Collection.Count = 0, 'Freeing an item removes it from its collection');
    Collection.Clear;
    Item := TLazRibbonComponent.Create(Owner);
    Item.Name := 'RemainingItem';
    Collection.QueueName('MissingItem');
    Collection.QueueName('RemainingItem');
    Collection.ProcessNames(Owner);
    Check((Collection.Count = 1) and (Collection[0] = Item), 'Unresolved streamed names do not create nil items');
    FreeAndNil(Collection);
    Check(Item.Collection = nil, 'Destroying a collection detaches surviving items');
  finally
    Collection.Free;
    Owner.Free;
  end;

  Ribbon := TLazRibbon.Create(nil);
  try
    Tab := Ribbon.Tabs.Add;
    Pane := Tab.Panes.Add;
    Button := Pane.Items.AddLargeButton;
    Button.Free;
    Check(Pane.Items.Count = 0, 'Freeing a runtime button removes its pane reference');
    Pane.Free;
    Check(Tab.Panes.Count = 0, 'Freeing a runtime pane removes its tab reference');
    Tab.Free;
    Check(Ribbon.Tabs.Count = 0, 'Freeing a runtime tab removes its Ribbon reference');
  finally
    Ribbon.Free;
  end;
end;

procedure TestXML;
var
  Ini: TLazRibbonXMLIni;
  Parser: TLazRibbonXMLParser;
  Node, Foreign: TLazRibbonXMLNode;
  Tree: TBinaryTreeNode;
  Parameter: TLazRibbonXMLParameter;
  Font1, Font2: TFont;
  Stream: TMemoryStream;
  I, J, Index: Integer;
  Remaining: array[0..31] of Boolean;
  FileName: String;
begin
  ForceDirectories(ParamStr(2));
  FileName := IncludeTrailingPathDelimiter(ParamStr(2)) + 'audit.xml';
  Ini := TLazRibbonXMLIni.Create;
  try
    Ini.WriteString('Settings', 'Caption', 'Ribbon');
    Ini.SaveToFile(FileName);
  finally
    Ini.Free;
  end;
  Ini := TLazRibbonXMLIni.Create(FileName);
  try
    Check(Ini.ReadString('Settings', 'Caption', '') = 'Ribbon', 'Filename constructor initializes XML parser');
    Check(Ini.AutoConvert, 'Both XML-INI constructors enable conversion');
  finally
    Ini.Free;
  end;
  Parser := TLazRibbonXMLParser.Create;
  try
    Node := Parser.NodeByName['Middle', True];
    Check(Node.Parent = Parser, 'Auto-created XML nodes retain their parent');
    Parser.NodeByName['Alpha', True].Text := 'a';
    Parser.NodeByName['Zulu', True].Text := 'z';
    Node.Name := 'Omega';
    Check((Parser.NodeByName['Omega', False] = Node) and
      (Parser.NodeByName['Middle', False] = nil), 'Renaming updates the XML name index');
    Parser.Clear;
    Node := TLazRibbonXMLNode.Create('Inserted', xntNormal);
    Parser.Insert(0, Node);
    Check((Parser.Count = 1) and (Node.Parent = Parser), 'XML insertion into an empty list');
    Node := TLazRibbonXMLNode.Create('Comment', xntComment);
    Parser.Insert(Parser.Count, Node);
    Node.Name := 'RenamedComment';
    Parser.Remove(Node);
    Check(Parser.Count = 1, 'Comments can be inserted, renamed and removed');
    Foreign := TLazRibbonXMLNode.Create('Inserted', xntNormal);
    try
      Parser.Remove(Foreign);
      Check(Parser.Count = 1, 'Removing a foreign XML node preserves owned nodes');
    finally
      Foreign.Free;
    end;
    Parser.Clear;
    Parser.NodeByName['B', True].Text := 'root';
    Parser.NodeByName['A', True].Text := 'child';
    Parser.Remove(Parser.NodeByName['B', False]);
    Check(Parser.NodeByName['A', False].Text = 'child', 'Deleting a single-child XML root preserves its child');
    Parser.Clear;
    Parser.NodeByName['M', True].Text := 'root';
    Parser.NodeByName['F', True].Text := 'left';
    Parser.NodeByName['T', True].Text := 'right';
    Parser.NodeByName['P', True].Text := 'successor';
    Parser.Add(TLazRibbonXMLNode.Create('P', xntNormal));
    Parser.NodeByName['W', True].Text := 'last';
    Parser.Remove(Parser.NodeByName['M', False]);
    Check((Parser.Count = 5) and (Parser.NodeByName['P', False] <> nil) and
      (Parser.NodeByName['T', False] <> nil), 'Deleting an XML root transfers the complete duplicate-name successor bucket');
    Parser.Clear;
    for I := 0 to 31 do
    begin
      Index := (I * 13) mod 32;
      Parser.NodeByName[Format('N%.2d', [Index]), True].TextAsInteger := Index;
      Remaining[Index] := True;
    end;
    Parser.Add(TLazRibbonXMLNode.Create('N16', xntNormal));
    for I := 0 to 31 do
    begin
      Index := (I * 7) mod 32;
      Parser.Remove(Parser.NodeByName[Format('N%.2d', [Index]), False]);
      Remaining[Index] := Index = 16;
      for J := 0 to 31 do
        Check((Parser.NodeByName[Format('N%.2d', [J]), False] <> nil) = Remaining[J],
          Format('XML lookup after deletion %d, key %d', [Index, J]));
    end;
    Check(Parser.Count = 1, 'Duplicate XML names survive deletion of one occurrence');
    Tree := TBinaryTreeNode.Create;
    Foreign := TLazRibbonXMLNode.Create('Bucket', xntNormal);
    try
      Tree.Add(Foreign);
      Tree.Remove(Foreign);
      Check(Tree.Count = 0, 'Tree bucket removal includes its final entry');
    finally
      Foreign.Free;
      Tree.Free;
    end;
    Node := Parser.NodeByIndex[0];
    Parameter := TLazRibbonXMLParameter.Create('First', '1');
    Node.Parameters.Insert(0, Parameter);
    Parameter := TLazRibbonXMLParameter.Create('Last', '2');
    Node.Parameters.Insert(Node.Parameters.Count, Parameter);
    Check(Node.Parameters.Count = 2, 'XML parameters support empty insertion and append');
    try
      Node.Add(Node);
      Check(False, 'XML cycles must be rejected');
    except
      on E: Exception do Check(Node.Count = 0, 'XML cycles are rejected before mutation');
    end;
    Parser.Parse(nil);
    Check(Parser.Count = 0, 'Nil XML input clears the document safely');
    Parser.NodeByName['Stale', True].Text := 'old';
    Stream := TMemoryStream.Create;
    try
      Stream.SaveToFile(FileName);
    finally
      Stream.Free;
    end;
    Parser.LoadFromFile(FileName);
    Check(Parser.Count = 0, 'Loading an empty XML file clears old nodes');
    Font1 := TFont.Create;
    Font2 := TFont.Create;
    Stream := TMemoryStream.Create;
    try
      Parser.Clear;
      Node := Parser.NodeByName['Font', True];
      Font1.Style := [fsBold, fsItalic, fsUnderline, fsStrikeOut];
      TLazRibbonXMLTools.Save(Node, Font1);
      Parser.SaveToStream(Stream);
      Stream.Position := 0;
      Parser.LoadFromStream(Stream);
      TLazRibbonXMLTools.Load(Parser.NodeByName['Font', False], Font2);
      Check(Font2.Style = Font1.Style, 'XML font persistence preserves all styles');
    finally
      Stream.Free;
      Font2.Free;
      Font1.Free;
    end;
  finally
    Parser.Free;
  end;
end;

procedure TestSkinNotifications;
var
  Manager: TLazRibbonSkinManager;
  First, Second, Third: TSkinObserver;
begin
  Manager := TLazRibbonSkinManager.Create(nil);
  First := TSkinObserver.Create(nil);
  Second := TSkinObserver.Create(nil);
  Third := TSkinObserver.Create(nil);
  try
    Manager.AutoRefreshControls := False;
    LazRegisterSkinChangeHandler(First, @First.SkinChanged);
    LazRegisterSkinChangeHandler(Second, @Second.SkinChanged);
    Check((First.ComponentCount = 0) and (Second.ComponentCount = 0),
      'Skin subscriptions do not add components to form streaming');
    Second.RemoveListener := First;
    Second.RegisterListener := Third;
    Second.RemoveSelf := True;
    Manager.BeginUpdate;
    Manager.General.BackColor := clRed;
    Manager.EndUpdate;
    Check((Second.Calls = 1) and (First.Calls = 0), 'Skin notification tolerates callback unregistration');
    Check(Third.Calls = 0, 'New skin subscriptions wait until the next notification');
    LazRegisterSkinChangeHandler(First, @First.SkinChanged);
    FreeAndNil(First);
    Manager.General.BackColor := clBlue;
    Check(Third.Calls > 0, 'Destroyed listeners leave no stale skin callback');
  finally
    LazUnregisterSkinChangeHandler(First);
    LazUnregisterSkinChangeHandler(Second);
    LazUnregisterSkinChangeHandler(Third);
    Third.Free;
    Second.Free;
    First.Free;
    Manager.Free;
  end;
end;

procedure TestStreaming;
var
  Original, Restored: TForm;
  Ribbon, LoadedRibbon: TLazRibbon;
  Manager: TLazRibbonSkinManager;
  Tab: TLazRibbonTab;
  Pane: TLazRibbonPane;
  Button: TLazRibbonLargeButton;
  Stream: TMemoryStream;
begin
  RegisterClasses([TLazRibbon, TLazRibbonSkinManager, TLazRibbonTab,
    TLazRibbonPane, TLazRibbonLargeButton]);
  Original := TForm.CreateNew(nil);
  Restored := TForm.CreateNew(nil);
  Stream := TMemoryStream.Create;
  try
    Original.Name := 'AuditForm';
    Manager := TLazRibbonSkinManager.Create(Original);
    Manager.Name := 'AuditSkinManager';
    Ribbon := TLazRibbon.Create(Original);
    Ribbon.Name := 'AuditRibbon';
    Ribbon.Parent := Original;
    Ribbon.SkinManager := Manager;
    Tab := Ribbon.Tabs.Add;
    Tab.Name := 'AuditTab';
    Tab.Caption := 'Home';
    Pane := Tab.Panes.Add;
    Pane.Name := 'AuditPane';
    Button := Pane.Items.AddLargeButton;
    Button.Name := 'AuditButton';
    Button.Caption := 'Save';
    Stream.WriteComponent(Original);
    Stream.Position := 0;
    Stream.ReadComponent(Restored);
    LoadedRibbon := TLazRibbon(Restored.FindComponent('AuditRibbon'));
    Check((LoadedRibbon <> nil) and (LoadedRibbon.Tabs.Count = 1),
      'Ribbon tabs survive component streaming');
    Check((LoadedRibbon.Tabs[0].Panes.Count = 1) and
      (LoadedRibbon.Tabs[0].Panes[0].Items.Count = 1),
      'Pane and item collections survive component streaming');
    Check(LoadedRibbon.Tabs[0].Panes[0].Items[0].Collection =
      LoadedRibbon.Tabs[0].Panes[0].Items, 'Streaming rebuilds collection back-pointers');
    Check(LoadedRibbon.SkinManager = Restored.FindComponent('AuditSkinManager'),
      'Streaming restores skin-manager links without internal observer components');
  finally
    Stream.Free;
    Restored.Free;
    Original.Free;
  end;
end;

procedure TestPopupGallery;
var
  Host, Restored, Window: TForm;
  Menu, LoadedMenu: TLazRibbonPopupMenu;
  Ribbon: TLazRibbon;
  Pane: TLazRibbonPane;
  Button: TLazRibbonLargeButton;
  Entry: TLazRibbonPopupEntry;
  Observer: TPopupObserver;
  Stream: TMemoryStream;
  I, FirstWindowCount: Integer;
  ScrollBar: TScrollBar;

  function GalleryWindow: TForm;
  var
    FormIndex: Integer;
  begin
    for FormIndex := 0 to Screen.FormCount - 1 do
    begin
      Result := Screen.Forms[FormIndex];
      if (Result <> Host) and (Result <> Restored) and Result.Visible then Exit;
    end;
    raise Exception.Create('No visible gallery window');
  end;

begin
  RegisterClasses([TLazRibbonPopupMenu, TLazRibbon, TLazRibbonTab,
    TLazRibbonPane, TLazRibbonLargeButton]);
  Host := TForm.CreateNew(nil);
  Restored := TForm.CreateNew(nil);
  Stream := TMemoryStream.Create;
  Observer := TPopupObserver.Create;
  try
    Host.Name := 'PopupAuditForm';
    Host.SetBounds(100, 100, 500, 300);
    Ribbon := TLazRibbon.Create(Host);
    Ribbon.Name := 'AuditRibbon';
    Ribbon.Parent := Host;
    Pane := Ribbon.Tabs.Add.Panes.Add;
    Pane.Collection.RootComponent.Name := 'AuditTab';
    Pane.Name := 'AuditPane';
    Button := Pane.Items.AddLargeButton;
    Button.Name := 'AuditDropdown';
    Button.ButtonKind := bkDropdown;
    Menu := TLazRibbonPopupMenu.Create(Host);
    Menu.Name := 'AuditMenu';
    Button.DropdownMenu := Menu;
    Check(not Menu.Gallery.Enabled, 'Classic menus remain the default');
    Menu.Gallery.Enabled := True;
    Menu.Gallery.Columns := 2;
    Menu.Gallery.ItemWidth := 100;
    Menu.Gallery.ItemHeight := 40;
    Menu.Gallery.MaxHeight := 100;

    Entry := Menu.Gallery.Items.Add;
    Entry.Kind := pekHeading;
    Entry.Caption := 'Choices';
    Entry := Menu.Gallery.Items.Add;
    Entry.Caption := 'Disabled';
    Entry.Enabled := False;
    Entry := Menu.Gallery.Items.Add;
    Entry.Caption := 'Choice';
    Entry.Description := 'Description';
    Entry.Color := clBlue;
    Entry.Tag := 12;
    for I := 1 to 8 do
      Menu.Gallery.Items.Add.Caption := 'Choice ' + IntToStr(I);
    Entry := Menu.Gallery.Items.Add;
    Entry.Kind := pekCommand;
    Entry.Caption := 'More';
    Entry.Tag := 23;

    Stream.WriteComponent(Host);
    Stream.Position := 0;
    Stream.ReadComponent(Restored);
    LoadedMenu := TLazRibbonPopupMenu(Restored.FindComponent('AuditMenu'));
    Check((LoadedMenu <> nil) and LoadedMenu.Gallery.Enabled and
      (LoadedMenu.Gallery.Columns = 2) and (LoadedMenu.Gallery.Items.Count = 12),
      'Gallery options and collection survive form streaming');
    Check((LoadedMenu.Gallery.Items[0].Kind = pekHeading) and
      not LoadedMenu.Gallery.Items[1].Enabled and
      (LoadedMenu.Gallery.Items[2].Description = 'Description') and
      (LoadedMenu.Gallery.Items[2].Color = clBlue),
      'Gallery entry types, text, state and swatch survive form streaming');
    Check(TLazRibbonLargeButton(Restored.FindComponent('AuditDropdown')).DropdownMenu = LoadedMenu,
      'Dropdown menu link resolves after form streaming');

    Menu.OnPopup := @Observer.Opened;
    Menu.OnClose := @Observer.Closed;
    Menu.OnGallerySelect := @Observer.Selected;
    Host.Show;
    Application.ProcessMessages;
    FirstWindowCount := Screen.FormCount;
    Check(Button.ExecuteKeyTip, 'Ribbon dropdown opens through its KeyTip path');
    Application.ProcessMessages;
    Check((ActivePopupMenu = Menu) and (Screen.FormCount = FirstWindowCount + 1),
      'Gallery opens one popup window');
    Window := GalleryWindow;
    Window.Perform(CN_KEYDOWN, VK_DOWN, 0);
    Window.Perform(CN_KEYDOWN, VK_RETURN, 0);
    Check((Observer.Selections = 1) and (Observer.LastTag = 12) and
      (Menu.Gallery.SelectedIndex = 2), 'Keyboard skips heading and disabled choice');
    Check((Observer.Opens = 1) and (Observer.Closes = 1) and (ActivePopupMenu = nil),
      'Selecting closes the popup and fires each lifecycle event once');
    Application.ProcessMessages;

    Menu.PopUp(150, 180);
    Window := GalleryWindow;
    ScrollBar := TScrollBar(Window.Controls[0]);
    Window.Perform(CN_KEYDOWN, VK_END, 0);
    Check(ScrollBar.Position > 0, 'Keyboard navigation scrolls the last row into view');
    Window.Perform(CN_KEYDOWN, VK_RETURN, 0);
    Check((Observer.Selections = 2) and (Observer.LastTag = 23) and
      (Menu.Gallery.SelectedIndex = 2), 'Command at end is reachable and preserves selection');
    Application.ProcessMessages;

    Menu.PopUp(150, 180);
    Window := GalleryWindow;
    Window.Perform(CN_KEYDOWN, VK_ESCAPE, 0);
    Check((Observer.Selections = 2) and (Observer.Closes = 3) and (ActivePopupMenu = nil),
      'Escape closes without a selection event');
    Application.ProcessMessages;

    Menu.PopUp(150, 180);
    Menu.Free;
    Application.ProcessMessages;
    Check((ActivePopupMenu = nil) and (Screen.FormCount = FirstWindowCount) and
      (Button.DropdownMenu = nil), 'Destroying the menu releases its window and button link');
  finally
    Stream.Free;
    Restored.Free;
    Host.Free;
    Observer.Free;
  end;
end;

procedure TestColorCombo;
var
  Host, Restored: TForm;
  Ribbon: TLazRibbon;
  Tab: TLazRibbonTab;
  Pane: TLazRibbonPane;
  Combo, LoadedCombo: TLazRibbonColorComboBoxItem;
  Menu: TLazRibbonPopupMenu;
  Popup: TCustomForm;
  Swatch: TLazRibbonColorSwatch;
  Events: TColorComboObserver;
  Stream: TMemoryStream;
  X, Y: Integer;

  procedure SendKey(Key: Word);
  var
    I: Integer;
  begin
    for I := 0 to Screen.CustomFormCount - 1 do
    begin
      Popup := Screen.CustomForms[I];
      if (Popup <> Host) and (Popup <> Restored) and Popup.Visible then
      begin
        Popup.Perform(CN_KEYDOWN, Key, 0);
        Exit;
      end;
    end;
    raise Exception.Create('No visible color palette window');
  end;

begin
  RegisterClasses([TLazRibbon, TLazRibbonTab, TLazRibbonPane, TLazRibbonColorComboBoxItem]);
  Host := TForm.CreateNew(nil);
  Restored := TForm.CreateNew(nil);
  Stream := TMemoryStream.Create;
  Events := TColorComboObserver.Create;
  try
    Host.Name := 'ColorAuditForm';
    Ribbon := TLazRibbon.Create(Host);
    Ribbon.Name := 'ColorAuditRibbon';
    Ribbon.Parent := Host;
    Ribbon.Align := alTop;
    Tab := Ribbon.Tabs.Add;
    Tab.Name := 'ColorAuditTab';
    Pane := Tab.Panes.Add;
    Pane.Name := 'ColorAuditPane';
    Combo := Pane.Items.AddColorComboBox;
    Combo.Name := 'ColorAuditCombo';
    Combo.Options := [coHighContrast, coAutomatic, coThemeColors, coGradients];
    Combo.ContrastBackground := clWhite;
    Combo.MinimumContrast := 7;
    Combo.AutomaticColor := clNavy;
    Combo.PaletteCaptions.Automatic := 'Automatic color';
    Combo.SelectedColor := clMaroon;
    Combo.GradientColor := clRed;
    Swatch := Combo.ThemeColors.Add;
    Swatch.Caption := 'White';
    Swatch.Color := clWhite;
    Swatch := Combo.ThemeColors.Add;
    Swatch.Caption := 'Black';
    Swatch.Color := clBlack;

    Stream.WriteComponent(Host);
    Stream.Position := 0;
    Stream.ReadComponent(Restored);
    LoadedCombo := TLazRibbonColorComboBoxItem(Restored.FindComponent(Combo.Name));
    Check((LoadedCombo <> nil) and (LoadedCombo.SelectedColor = clMaroon) and
      (LoadedCombo.GradientColor = clRed) and (LoadedCombo.Options = Combo.Options),
      'Color selection, gradient and options round-trip through form streaming');
    Check((LoadedCombo.ThemeColors.Count = 2) and
      (LoadedCombo.ThemeColors[0].Caption = 'White') and (LoadedCombo.MinimumContrast = 7) and
      (LoadedCombo.PaletteCaptions.Automatic = 'Automatic color'),
      'Custom swatches, captions and contrast setting round-trip through form streaming');
    Check((LoadedCombo.DropdownMenu is TLazRibbonPopupMenu) and
      (LoadedCombo.DropdownMenu.Owner = LoadedCombo) and (LoadedCombo.ComponentCount = 1),
      'A loaded color combo owns exactly one internal popup');

    Combo.OnChange := @Events.Changed;
    Combo.OnApply := @Events.Applied;
    Host.SetBounds(100, 100, 500, 300);
    Host.Show;
    Application.ProcessMessages;
    Check(Combo.ExecuteKeyTip, 'Color combo KeyTip opens its palette');
    Menu := TLazRibbonPopupMenu(Combo.DropdownMenu);
    Check((ActivePopupMenu = Menu) and Menu.Gallery.Items[3].Enabled and
      (Menu.Gallery.Items[1].Caption = 'Automatic color'),
      'The popup uses custom captions and swatches');
    SendKey(VK_HOME);
    SendKey(VK_SPACE);
    Check(Combo.HighContrastOnly and (ActivePopupMenu = Menu) and
      not Menu.Gallery.Items[3].Enabled and Menu.Gallery.Items[4].Enabled,
      'The filter toggles in place and uses the configured contrast background and threshold');
    SendKey(VK_DOWN);
    SendKey(VK_RETURN);
    Check((Combo.SelectedColor = clDefault) and (Combo.EffectiveColor = clNavy) and
      (Combo.GradientColor = clNone) and (Events.Changes = 1),
      'Automatic resolves to AutomaticColor and clears the previous gradient');
    Application.ProcessMessages;

    Combo.ExecuteKeyTip;
    SendKey(VK_END);
    SendKey(VK_RETURN);
    Check((ActivePopupMenu = Menu) and (Menu.Gallery.Items[1].GradientColor <> clNone),
      'Gradient action opens a gallery of gradient swatches');
    SendKey(VK_HOME);
    SendKey(VK_RETURN);
    Check((Combo.SelectedColor = clNavy) and (Combo.GradientColor <> clNone) and
      (Events.Changes = 2), 'Selecting a gradient commits both stops in one change event');
    Application.ProcessMessages;

    X := Combo.Rect.Left + 3;
    Y := (Combo.Rect.Top + Combo.Rect.Bottom) div 2;
    Combo.MouseMove([], X, Y);
    Combo.MouseDown(mbLeft, [ssLeft], X, Y);
    Combo.MouseUp(mbLeft, [], X, Y);
    Check((Events.Applies = 1) and (Events.Changes = 2),
      'The main button reapplies the current selection without changing it');
    Combo.ExecuteKeyTip;
    Combo.Visible := False;
    Check(ActivePopupMenu = nil, 'Hiding the color combo dismisses its popup');
    Application.ProcessMessages;
  finally
    Stream.Free;
    Restored.Free;
    Host.Free;
    Events.Free;
  end;
end;

begin
  try
    Application.Initialize;
    case ParamStr(1) of
      'geometry': TestGeometry;
      'colors': TestColors;
      'collections': TestCollections;
      'xml': TestXML;
      'skins': TestSkinNotifications;
      'streaming': TestStreaming;
      'popup':
        begin
          TestPopupGallery;
          TestColorCombo;
        end;
      'controls': RunControlItemsAudit;
    else
      raise Exception.Create('Specify geometry, colors, collections, xml, skins, streaming, popup or controls.');
    end;
  except
    on E: Exception do
    begin
      Inc(Failures);
      WriteLn('FAIL: ', E.ClassName, ': ', E.Message);
    end;
  end;
  WriteLn(ParamStr(1), ': ', Checks, ' checks, ', Failures, ' failures');
  if Failures <> 0 then Halt(1);
end.
