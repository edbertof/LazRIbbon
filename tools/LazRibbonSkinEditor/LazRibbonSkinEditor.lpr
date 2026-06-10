program LazRibbonSkinEditor;

{$mode objfpc}{$H+}
{$IFDEF MSWINDOWS}{$APPTYPE GUI}{$ENDIF}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, Forms, uSkinEditorMain;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Scaled := True;
  Application.Title := 'LazRibbonSkinEditor';
  Application.Initialize;
  Application.CreateForm(TfrmLazRibbonSkinEditor, frmLazRibbonSkinEditor);
  Application.Run;
end.
