program design_audit;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, Classes, SysUtils, TypInfo, ComCtrls, Menus, PropEdits,
  ObjInspStrConsts,
  LazRibbon_Core, LazRibbon_Tabs, LazRibbon_Groups, LazRibbon_EditWindow,
  image_index_audit, LazRibbon_ControlItems, LazRibbon_Editor, LazRibbon_Register;

type
  TMenuEditorAudit = class
    Values: TStrings;
    procedure AddValue(const AValue: string);
  end;

var
  Editor: TfrmLazRibbonEditWindow;
  Ribbon: TLazRibbon;
  Tab: TLazRibbonTab;
  Pane: TLazRibbonPane;
  RootNode, PaneNode, ItemNode: TTreeNode;
  I, J, RoundIndex: Integer;

procedure TMenuEditorAudit.AddValue(const AValue: string);
begin
  Values.Add(AValue);
end;

procedure CheckColorComboMenuEditor;
var
  Host: TForm;
  Hook: TPropertyEditorHook;
  Audit: TMenuEditorAudit;
  Combo, OtherCombo: TLazRibbonColorComboBoxItem;
  CustomMenu, BuiltInMenu, OtherBuiltInMenu: TPopupMenu;
  Info: PPropInfo;
  EditorClass: TPropertyEditorClass;
  MenuEditor: TPropertyEditor;
begin
  RegisterLazRibbonColorComboMenuEditor;
  Host := TForm.CreateNew(nil);
  Hook := TPropertyEditorHook.Create(nil);
  Audit := TMenuEditorAudit.Create;
  Audit.Values := TStringList.Create;
  try
    Hook.LookupRoot := Host;
    Combo := TLazRibbonColorComboBoxItem.Create(Host);
    Combo.Name := 'ColorsButton';
    OtherCombo := TLazRibbonColorComboBoxItem.Create(Host);
    BuiltInMenu := Combo.DropdownMenu;
    OtherBuiltInMenu := OtherCombo.DropdownMenu;
    CustomMenu := TPopupMenu.Create(Host);
    CustomMenu.Name := 'BordersMenu';

    Info := GetPropInfo(Combo, 'DropdownMenu');
    EditorClass := GetEditorClass(Info, Combo);
    if EditorClass <> TLazRibbonColorComboMenuEditor then
      raise Exception.Create('Color Combo Box DropdownMenu editor is not registered.');
    MenuEditor := EditorClass.Create(Hook, 2);
    try
      MenuEditor.SetPropEntry(0, Combo, Info);
      MenuEditor.SetPropEntry(1, OtherCombo, Info);
      if MenuEditor.GetVisualValue <> RSBuiltInPalette then
        raise Exception.Create('Each internal palette should display the same default label.');

      Combo.DropdownMenu := CustomMenu;
      if MenuEditor.AllEqual then
        raise Exception.Create('A mix of built-in and custom menus should show a mixed value.');
      MenuEditor.GetValues(@Audit.AddValue);
      if (Audit.Values.IndexOf(RSBuiltInPalette) < 0) or
        (Audit.Values.IndexOf(CustomMenu.Name) < 0) or (Audit.Values.IndexOf(oisNone) < 0) or
        (Audit.Values.IndexOf(Combo.Name) >= 0) then
        raise Exception.Create('The menu list should show the built-in palette, custom menu and none.');

      MenuEditor.SetValue(RSBuiltInPalette);
      if (Combo.DropdownMenu <> BuiltInMenu) or (OtherCombo.DropdownMenu <> OtherBuiltInMenu) then
        raise Exception.Create('Selecting the built-in palette should restore each item''s own menu.');
      MenuEditor.SetValue(CustomMenu.Name);
      if (Combo.DropdownMenu <> CustomMenu) or (OtherCombo.DropdownMenu <> CustomMenu) or
        (MenuEditor.GetVisualValue <> CustomMenu.Name) then
        raise Exception.Create('Selecting a custom menu should still work.');
      MenuEditor.SetValue(oisNone);
      if (Combo.DropdownMenu <> nil) or (OtherCombo.DropdownMenu <> nil) then
        raise Exception.Create('Selecting none should still clear the assigned menu.');
      MenuEditor.SetValue(RSBuiltInPalette);
      if (Combo.DropdownMenu <> BuiltInMenu) or (OtherCombo.DropdownMenu <> OtherBuiltInMenu) or
        MenuEditor.CallStoredFunction then
        raise Exception.Create('Restoring the built-in palette should clear the stored override.');
    finally
      MenuEditor.Free;
    end;
    WriteLn('Color Combo Box menu editor: built-in, custom, and none selections passed');
  finally
    Audit.Values.Free;
    Audit.Free;
    Hook.Free;
    Host.Free;
  end;
end;

procedure CheckItemMenus;
const
  Captions: array[0..15] of String = ('Large Button', 'Small Button', 'Checkbox',
    'Radio Button', 'Toggle Switch', 'Separator', 'Skin Gallery', 'Edit',
    'Combo Box', 'Font Name Combo Box', 'Color Combo Box', 'Date Edit', 'Spin Edit',
    'Static Text', 'Progress Bar', 'Control Host');
var
  Index: Integer;
  First, Second: TMenuItem;
begin
  Editor.SetData(nil, nil);
  Editor.SetData(nil, nil);
  if (Editor.pmAddItem.Items.Count <> Length(Captions)) or
    (Editor.Additem1.Count <> Length(Captions)) then
    raise Exception.Create('Unexpected number of entries in the item menus.');
  for Index := Low(Captions) to High(Captions) do
  begin
    First := Editor.pmAddItem.Items[Index];
    Second := Editor.Additem1.Items[Index];
    if (First.Caption <> Captions[Index]) or (Second.Caption <> Captions[Index]) or
      (First.Action = nil) or (First.Action <> Second.Action) or
      First.Enabled or Second.Enabled then
      raise Exception.Create('Unexpected menu entry or action for ' + Captions[Index]);
  end;
  WriteLn('Design item menus: ', Length(Captions), ' shared actions in the expected order');
end;

begin
  try
    Application.Initialize;
    RunImageIndexAudit;
    CheckColorComboMenuEditor;
    Editor := TfrmLazRibbonEditWindow.Create(nil);
    Ribbon := TLazRibbon.Create(nil);
    try
      CheckItemMenus;
      for RoundIndex := 1 to 20 do
      begin
        Tab := Ribbon.Tabs.Add;
        RootNode := Editor.tvStructure.Items.AddChild(nil, 'Tab');
        RootNode.Data := Tab;
        for I := 1 to 3 do
        begin
          Pane := Tab.Panes.Add;
          PaneNode := Editor.tvStructure.Items.AddChild(RootNode, 'Pane');
          PaneNode.Data := Pane;
          for J := 1 to 4 do
          begin
            ItemNode := Editor.tvStructure.Items.AddChild(PaneNode, 'Button');
            ItemNode.Data := Pane.Items.AddLargeButton;
          end;
        end;
        RootNode.Delete;
        if (Ribbon.Tabs.Count <> 0) or (Editor.tvStructure.Items.Count <> 0) then
          raise Exception.Create('Deleting an editor subtree left stale nodes or components.');
      end;
      Tab := Ribbon.Tabs.Add;
      RootNode := Editor.tvStructure.Items.AddChild(nil, 'Controls');
      RootNode.Data := Tab;
      Pane := Tab.Panes.Add;
      PaneNode := Editor.tvStructure.Items.AddChild(RootNode, 'Inputs');
      PaneNode.Data := Pane;
      Pane.Items.AddEdit;
      Pane.Items.AddComboBox;
      Pane.Items.AddSpinEdit;
      Pane.Items.AddStaticText;
      Pane.Items.AddProgressBar;
      Pane.Items.AddFontNameComboBox;
      Pane.Items.AddColorComboBox;
      Pane.Items.AddDateEdit;
      for I := 0 to Pane.Items.Count - 1 do
      begin
        ItemNode := Editor.tvStructure.Items.AddChild(PaneNode, 'Control');
        ItemNode.Data := Pane.Items[I];
      end;
      RootNode.Delete;
      if (Ribbon.Tabs.Count <> 0) or (Ribbon.ControlCount <> 0) then
        raise Exception.Create('Deleting native item subtree left controls or components.');
      WriteLn('Design editor: 20 button subtrees and 1 native control subtree, 0 failures');
    finally
      Editor.Free;
      Ribbon.Free;
    end;
  except
    on E: Exception do
    begin
      WriteLn('FAIL: ', E.ClassName, ': ', E.Message);
      Halt(1);
    end;
  end;
end.
