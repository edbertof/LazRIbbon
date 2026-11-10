program design_audit;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, SysUtils, ComCtrls, Menus,
  LazRibbon_Core, LazRibbon_Tabs, LazRibbon_Groups, LazRibbon_EditWindow,
  image_index_audit, LazRibbon_ControlItems;

var
  Editor: TfrmLazRibbonEditWindow;
  Ribbon: TLazRibbon;
  Tab: TLazRibbonTab;
  Pane: TLazRibbonPane;
  RootNode, PaneNode, ItemNode: TTreeNode;
  I, J, RoundIndex: Integer;
  MenuCount: Integer;

procedure CheckControlMenus;
const
  Captions: array[0..6] of String = ('Edit', 'Combo box', 'Spin edit',
    'Static text', 'Progress bar', 'Control host', 'Font name combo box');
var
  Caption: String;
  First, Second: TMenuItem;
begin
  Editor.SetData(nil, nil);
  MenuCount := Editor.pmAddItem.Items.Count;
  Editor.SetData(nil, nil);
  if Editor.pmAddItem.Items.Count <> MenuCount then
    raise Exception.Create('Reopening contents duplicated the control menu entries.');
  for Caption in Captions do
  begin
    First := Editor.pmAddItem.Items.Find(Caption);
    Second := Editor.Additem1.Find(Caption);
    if (First = nil) or (Second = nil) or (First.Action = nil) or
      (First.Action <> Second.Action) or First.Enabled then
      raise Exception.Create('Missing, disconnected or incorrectly enabled menu: ' + Caption);
  end;
  WriteLn('Design control menus: 7 shared actions, no duplicate entries');
end;

begin
  try
    Application.Initialize;
    RunImageIndexAudit;
    Editor := TfrmLazRibbonEditWindow.Create(nil);
    Ribbon := TLazRibbon.Create(nil);
    try
      CheckControlMenus;
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
