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

unit Unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, StdCtrls, Dialogs,
  LazRibbon_Core, LazRibbon_Tabs, LazRibbon_Groups, LazRibbon_Items,
  LazRibbon_Buttons, LazRibbon_Backstage, LazRibbon_SkinManager, LazRibbon_SkinDefinition;

type
  TForm1 = class(TForm)
    LazRibbonSkinManager1: TLazRibbonSkinManager;
    LazRibbon1: TLazRibbon;
    LazRibbonTabHome: TLazRibbonTab;
    LazRibbonPaneFile: TLazRibbonPane;
    LazRibbonLargeButtonExample: TLazRibbonLargeButton;
    LazRibbonBackstageView1: TLazRibbonBackstageView;
    LazRibbonBackstagePageInfo: TLazRibbonBackstagePage;
    LazRibbonBackstagePageNew: TLazRibbonBackstagePage;
    LazRibbonBackstagePageOpen: TLazRibbonBackstagePage;
    LazRibbonBackstagePagePrint: TLazRibbonBackstagePage;
    LabelInfoTitle: TLabel;
    LabelInfoText: TLabel;
    LabelNewTitle: TLabel;
    LabelNewText: TLabel;
    LabelOpenTitle: TLabel;
    LabelOpenText: TLabel;
    LabelPrintTitle: TLabel;
    LabelPrintText: TLabel;
    procedure BackstageCommandExecute(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

procedure TForm1.BackstageCommandExecute(Sender: TObject);
var
  CaptionText: String;
begin
  if Sender is TLazRibbonBackstageButton then
    CaptionText := TLazRibbonBackstageButton(Sender).EffectiveCaption
  else
    CaptionText := 'Comando';

  ShowMessage('Comando executado: ' + CaptionText);
end;

end.
