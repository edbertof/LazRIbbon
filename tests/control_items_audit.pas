unit control_items_audit;

{$mode objfpc}{$H+}

interface

procedure RunControlItemsAudit;

implementation

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, Spin, ComCtrls,
  LazRibbon_Core, LazRibbon_Tabs, LazRibbon_Groups, LazRibbon_Items,
  LazRibbon_ControlItems, LazRibbon_RibbonExtItems;

type
  TChangeObserver = class
    Count: Integer;
    LastSender: TObject;
    procedure Changed(Sender: TObject);
  end;

procedure TChangeObserver.Changed(Sender: TObject);
begin
  Inc(Count);
  LastSender := Sender;
end;

procedure RunFontNameComboAudit;
var
  Form, Restored: TForm;
  Ribbon: TLazRibbon;
  Item, LoadedItem: TLazRibbonFontNameComboBoxItem;
  Native: TComboBox;
  Observer: TChangeObserver;
  Binary, TextStream: TMemoryStream;
  Text: TStringList;
  Font1, Font2: String;
  Checks, I: Integer;
  SystemList: Boolean;

  procedure Check(Condition: Boolean; const Description: String);
  begin
    Inc(Checks);
    if not Condition then raise Exception.Create(Description);
  end;

begin
  Checks := 0;
  RegisterClasses([TLazRibbon, TLazRibbonTab, TLazRibbonPane,
    TLazRibbonFontNameComboBoxItem]);
  Form := TForm.CreateNew(nil);
  Restored := TForm.CreateNew(nil);
  Observer := TChangeObserver.Create;
  Binary := TMemoryStream.Create;
  TextStream := TMemoryStream.Create;
  Text := TStringList.Create;
  try
    Form.Name := 'FontAuditForm';
    Form.SetBounds(-20000, -20000, 600, 300);
    Ribbon := TLazRibbon.Create(Form);
    Ribbon.Name := 'FontRibbon';
    Ribbon.Parent := Form;
    Ribbon.Tabs.Add.Name := 'FontTab';
    Ribbon.Tabs[0].Panes.Add.Name := 'FontPane';
    Item := Ribbon.Tabs[0].Panes[0].Items.AddFontNameComboBox;
    Item.Name := 'FontNameItem';
    Native := TComboBox(Item.Control);
    Check(Item.Items.Count >= 2, 'Font selector automatically loads installed Windows fonts');
    SystemList := True;
    for I := 0 to Item.Items.Count - 1 do
    begin
      SystemList := SystemList and (Screen.Fonts.IndexOf(Item.Items[I]) >= 0);
      if I > 0 then
        SystemList := SystemList and (AnsiCompareText(Item.Items[I-1], Item.Items[I]) < 0);
    end;
    Check(SystemList, 'Font choices come from the system, sorted without duplicates');
    Check(Item.ShowFontPreview and Assigned(Native.OnDrawItem),
      'Font previews are available and enabled by default');
    Check(Item.DropDownCount = 12, 'Font list defaults to twelve visible rows');
    Form.Show;
    Ribbon.ForceRepaint;
    Application.ProcessMessages;
    Check(Item.ExecuteKeyTip and (Form.ActiveControl = Native),
      'Font selector accepts KeyTip keyboard focus');
    Font1 := Item.Items[0];
    Font2 := Item.Items[1];
    Item.FontName := Font1;
    Item.OnChange := @Observer.Changed;
    Item.FontName := Font2;
    Check((Observer.Count = 1) and (Observer.LastSender = Item) and (Native.Text = Font2),
      'Changing FontName selects the native font and emits one item event');
    Item.FontName := Font2;
    Item.RefreshFonts;
    Check((Observer.Count = 1) and (Item.FontName = Font2),
      'Refreshing fonts preserves selection without duplicate changes');
    Native.Text := Font1;
    { LCL programmatic Text assignment does not raise the native user-change
      event. Exercise that event boundary as a widgetset selection would. }
    Native.OnChange(Native);
    Check((Item.FontName = Font1) and (Observer.Count = 2),
      'Native text changes update FontName and forward OnChange');
    Item.OnChange := nil;
    Item.FontName := Font2;
    Item.ShowFontPreview := False;
    Item.DropDownCount := 16;
    Binary.WriteComponent(Form);
    Binary.Position := 0;
    ObjectBinaryToText(Binary, TextStream);
    TextStream.Position := 0;
    Text.LoadFromStream(TextStream);
    Check(Pos('FontName =', Text.Text) > 0, 'Forms persist the selected font by name');
    Check((Pos('ItemIndex =', Text.Text) = 0) and (Pos('Items.Strings', Text.Text) = 0),
      'Forms do not persist machine-specific font lists or indices');
    Binary.Position := 0;
    Binary.ReadComponent(Restored);
    LoadedItem := TLazRibbonFontNameComboBoxItem(Restored.FindComponent('FontNameItem'));
    Check((LoadedItem <> nil) and (LoadedItem.FontName = Font2) and
      (TComboBox(LoadedItem.Control).Text = Font2), 'Form loading restores FontName');
    Check((LoadedItem.Items.Count = Item.Items.Count) and not LoadedItem.ShowFontPreview and
      (LoadedItem.DropDownCount = 16), 'Form loading rebuilds fonts and restores preview options');
    Item.FontName := '__LazRibbon unavailable font__';
    Item.RefreshFonts;
    Check((Item.FontName = '__LazRibbon unavailable font__') and
      (Native.Text = Item.FontName) and (Item.Items.IndexOf(Item.FontName) < 0),
      'Unavailable fonts remain visible without becoming fake installed fonts');
    Item.FontName := '';
    Check((Native.Text = '') and (Native.ItemIndex = -1), 'Empty FontName clears the font selector');
    Restored.Free;
    Restored := TForm.CreateNew(nil);
    Binary.Clear;
    Binary.WriteComponent(Form);
    Binary.Position := 0;
    Binary.ReadComponent(Restored);
    LoadedItem := TLazRibbonFontNameComboBoxItem(Restored.FindComponent('FontNameItem'));
    Check(LoadedItem.FontName = '', 'An explicitly empty font selection survives form loading');
    WriteLn('Font name combo: ', Checks, ' checks, 0 failures');
  finally
    Text.Free;
    TextStream.Free;
    Binary.Free;
    Observer.Free;
    Restored.Free;
    Form.Free;
  end;
end;

procedure RunControlItemsAudit;
var
  Form, Restored: TForm;
  Ribbon: TLazRibbon;
  Tab: TLazRibbonTab;
  Pane: TLazRibbonPane;
  Edit: TLazRibbonEditItem;
  Combo: TLazRibbonComboBoxItem;
  SpinEdit: TLazRibbonSpinEditItem;
  StaticText: TLazRibbonStaticTextItem;
  Progress: TLazRibbonProgressBarItem;
  Host: TLazRibbonControlHostItem;
  ExternalEdit: TEdit;
  Observer: TChangeObserver;
  Stream, TextStream: TMemoryStream;
  Text: TStringList;
  Checks, I, Previous: Integer;

  procedure Check(Condition: Boolean; const Description: String);
  begin
    Inc(Checks);
    if not Condition then raise Exception.Create(Description);
  end;

  procedure Layout;
  begin
    Ribbon.ForceRepaint;
    Application.ProcessMessages;
  end;

begin
  Checks := 0;
  RegisterClasses([TLazRibbon, TLazRibbonTab, TLazRibbonPane,
    TLazRibbonEditItem, TLazRibbonComboBoxItem, TLazRibbonSpinEditItem,
    TLazRibbonStaticTextItem, TLazRibbonProgressBarItem]);
  Form := TForm.CreateNew(nil);
  Restored := TForm.CreateNew(nil);
  Observer := TChangeObserver.Create;
  Stream := TMemoryStream.Create;
  TextStream := TMemoryStream.Create;
  Text := TStringList.Create;
  try
    Form.Name := 'ControlAuditForm';
    Form.SetBounds(-20000, -20000, 1100, 400);
    Ribbon := TLazRibbon.Create(Form);
    Ribbon.Name := 'ControlRibbon';
    Ribbon.Parent := Form;
    Tab := Ribbon.Tabs.Add;
    Tab.Name := 'ControlTab';
    Pane := Tab.Panes.Add;
    Pane.Name := 'ControlPane';
    Edit := Pane.Items.AddEdit;
    Edit.Name := 'SearchItem';
    Edit.Text := 'Search text';
    Edit.ReadOnly := True;
    Edit.Width := 180;
    Combo := Pane.Items.AddComboBox;
    Combo.Name := 'FontItem';
    Combo.Items.AddStrings(['Arial', 'Courier New', 'Arial']);
    Combo.ItemIndex := 2;
    SpinEdit := Pane.Items.AddSpinEdit;
    SpinEdit.Name := 'SizeItem';
    SpinEdit.MinValue := -20;
    SpinEdit.MaxValue := 250;
    SpinEdit.Increment := 5;
    SpinEdit.Value := 150;
    StaticText := Pane.Items.AddStaticText;
    StaticText.Name := 'StatusItem';
    StaticText.Caption := 'Ready & waiting';
    StaticText.Alignment := taRightJustify;
    Progress := Pane.Items.AddProgressBar;
    Progress.Name := 'ProgressItem';
    Progress.Max := 400;
    Progress.Position := 123;
    Ribbon.Tabs.Add.Caption := 'Other';
    Ribbon.TabIndex := 0;
    Form.Show;
    Layout;
    Check(Ribbon.ControlCount = 5, 'Each native item creates exactly one Ribbon child');
    for I := 0 to Pane.Items.Count - 1 do
    begin
      Check(TLazRibbonCustomControlItem(Pane.Items[I]).Control.Parent = Ribbon,
        'Native controls use Ribbon client coordinates');
      Check(TLazRibbonCustomControlItem(Pane.Items[I]).Control.Visible,
        'Active tab native controls are visible');
      Check(TLazRibbonCustomControlItem(Pane.Items[I]).Control.Height > 10,
        'Normal Ribbon rows leave room for native controls');
    end;
    Check(TLabel(StaticText.Control).Caption = StaticText.Caption,
      'Static captions reach the native label');
    Check(Edit.ExecuteKeyTip and (Form.ActiveControl = Edit.Control),
      'Edit KeyTip gives the native editor keyboard focus');
    Check(not Progress.ExecuteKeyTip and not StaticText.ExecuteKeyTip,
      'Display-only controls do not claim keyboard focus');
    Edit.Enabled := False;
    Check(not Edit.Control.Enabled and not Edit.ExecuteKeyTip,
      'Disabled editors cannot receive KeyTips');
    Edit.Enabled := True;
    Edit.Visible := False;
    Layout;
    Check(not Edit.Control.Visible, 'Hidden items hide native controls');
    Edit.Visible := True;
    Ribbon.TabIndex := 1;
    Layout;
    Check(not Edit.Control.Visible and not Combo.Control.Visible,
      'Inactive tabs hide native controls');
    Ribbon.TabIndex := 0;
    Ribbon.RibbonMinimized := True;
    Layout;
    Check(not SpinEdit.Control.Visible, 'Minimized Ribbon hides native controls');
    Ribbon.RibbonMinimized := False;
    Layout;
    Check(SpinEdit.Control.Visible, 'Expanding Ribbon restores native controls');
    Pane.Visible := False;
    Layout;
    Check(not Progress.Control.Visible, 'Hidden panes hide native controls');
    Pane.Visible := True;
    Layout;

    Edit.OnChange := @Observer.Changed;
    TEdit(Edit.Control).Text := 'Changed';
    Check((Observer.Count = 1) and (Observer.LastSender = Edit),
      'Native edit changes report the Ribbon item as Sender');
    Edit.OnChange := nil;
    Combo.OnChange := @Observer.Changed;
    Combo.ItemIndex := 1;
    Check((Observer.Count = 2) and (Observer.LastSender = Combo),
      'Programmatic combo selection emits one item change');
    Combo.ItemIndex := 1;
    Check(Observer.Count = 2, 'Repeated combo selection emits no duplicate change');
    Combo.OnChange := nil;
    Combo.ItemIndex := 2;
    SpinEdit.OnChange := @Observer.Changed;
    SpinEdit.Value := 175;
    Check((Observer.Count = 3) and (Observer.LastSender = SpinEdit),
      'Spin value changes report the Ribbon item as Sender');
    SpinEdit.OnChange := nil;

    Stream.WriteComponent(Form);
    Stream.Position := 0;
    ObjectBinaryToText(Stream, TextStream);
    TextStream.Position := 0;
    Text.LoadFromStream(TextStream);
    Check((Pos(': TEdit', Text.Text) = 0) and
      (Pos(': TComboBox', Text.Text) = 0) and (Pos(': TSpinEdit', Text.Text) = 0) and
      (Pos(': TLabel', Text.Text) = 0) and (Pos(': TProgressBar', Text.Text) = 0),
      'Internal native controls are absent from form streaming');
    Stream.Position := 0;
    Stream.ReadComponent(Restored);
    Check(TLazRibbonEditItem(Restored.FindComponent('SearchItem')).Text = 'Changed',
      'Edit text survives form streaming');
    Check(TLazRibbonEditItem(Restored.FindComponent('SearchItem')).ReadOnly,
      'Edit ReadOnly survives form streaming');
    Check(TLazRibbonComboBoxItem(Restored.FindComponent('FontItem')).ItemIndex = 2,
      'Duplicate combo captions preserve the exact selection');
    Check(TLazRibbonComboBoxItem(Restored.FindComponent('FontItem')).Items.Count = 3,
      'Combo options survive form streaming');
    Check((TLazRibbonSpinEditItem(Restored.FindComponent('SizeItem')).Value = 175) and
      (TLazRibbonSpinEditItem(Restored.FindComponent('SizeItem')).MinValue = -20) and
      (TLazRibbonSpinEditItem(Restored.FindComponent('SizeItem')).MaxValue = 250),
      'Spin range and value survive form streaming');
    Check((TLazRibbonStaticTextItem(Restored.FindComponent('StatusItem')).Caption = 'Ready & waiting') and
      (TLazRibbonStaticTextItem(Restored.FindComponent('StatusItem')).Alignment = taRightJustify),
      'Static caption and alignment survive form streaming');
    Check(TLazRibbonProgressBarItem(Restored.FindComponent('ProgressItem')).Position = 123,
      'Progress position survives form streaming');
    Check(TLazRibbon(Restored.FindComponent('ControlRibbon')).Tabs[0].Panes[0].Items.Count = 5,
      'Native item collection survives form streaming');

    Pane.Items.Remove(Edit);
    Check(not Edit.Control.Visible, 'Removing an item hides its still-owned control');
    Pane.Items.AddItem(Edit);
    Layout;
    Check(Edit.Control.Visible, 'Reinserting an item restores its native control');
    Previous := Ribbon.ControlCount;
    Edit.Free;
    Check((Pane.Items.Count = 4) and (Ribbon.ControlCount = Previous - 1),
      'Freeing an item releases its native control and collection entry');

    Host := Pane.Items.AddRibbonControlHostItem;
    ExternalEdit := TEdit.Create(Form);
    Host.Control := ExternalEdit;
    Layout;
    Check(ExternalEdit.Parent = Ribbon, 'Generic host accepts an external LCL editor');
    Pane.Items.Remove(Host);
    Check(not ExternalEdit.Visible, 'Removing a generic host hides its external control');
    Host.Free;
    Check(ExternalEdit.Owner = Form, 'Generic hosts leave external control ownership intact');
    Host := Pane.Items.AddRibbonControlHostItem;
    Host.Control := ExternalEdit;
    Layout;
    Host.Free;
    Check(not ExternalEdit.Visible, 'Freeing a generic host hides its external control');
    WriteLn('Native Ribbon items: ', Checks, ' checks, 0 failures');
  finally
    Text.Free;
    TextStream.Free;
    Stream.Free;
    Observer.Free;
    Restored.Free;
    Form.Free;
  end;
  RunFontNameComboAudit;
end;

end.
