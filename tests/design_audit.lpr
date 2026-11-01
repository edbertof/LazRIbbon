program design_audit;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, SysUtils, ComCtrls,
  LazRibbon_Core, LazRibbon_Tabs, LazRibbon_Groups, LazRibbon_EditWindow,
  image_index_audit;

var
  Editor: TfrmLazRibbonEditWindow;
  Ribbon: TLazRibbon;
  Tab: TLazRibbonTab;
  Pane: TLazRibbonPane;
  RootNode, PaneNode, ItemNode: TTreeNode;
  I, J, RoundIndex: Integer;

begin
  try
    Application.Initialize;
    RunImageIndexAudit;
    Editor := TfrmLazRibbonEditWindow.Create(nil);
    Ribbon := TLazRibbon.Create(nil);
    try
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
      WriteLn('Design editor: 20 subtree deletions, 320 component removals, 0 failures');
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
