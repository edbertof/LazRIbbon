{*******************************************************************************
*                                                                              *
*  LazRibbon                                                                   *
*                                                                              *
*  License: Modified LGPL with linking exception, preserving original          *
*           LazToolbar/LazRibbon notices where applicable.                     *
*           See LICENSE.txt in this distribution.                              *
*                                                                              *
*******************************************************************************}

unit Unit1;

{$mode delphi}{$H+}
{$codepage utf8}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, StdCtrls, ExtCtrls, ComCtrls,
  Dialogs, ActnList,
  LazRibbon_Form, LazRibbon_Core, LazRibbon_Tabs, LazRibbon_Groups, LazRibbon_Items,
  LazRibbon_Buttons, LazRibbon_Backstage, LazRibbon_RibbonExtItems,
  LazRibbon_SkinManager, LazRibbon_SkinDefinition;

type
  TForm1 = class(TLazRibbonForm)
    ActionList1: TActionList;
    actNew: TAction;
    actOpen: TAction;
    actSave: TAction;
    actPrint: TAction;
    actExport: TAction;
    actCut: TAction;
    actCopy: TAction;
    actPaste: TAction;
    actFind: TAction;
    actReview: TAction;
    actZoomIn: TAction;
    actZoomOut: TAction;
    actHelp: TAction;
    actExit: TAction;
    LazRibbonSkinManager1: TLazRibbonSkinManager;
    LazRibbon1: TLazRibbon;
    LazRibbonTabHome: TLazRibbonTab;
    LazRibbonTabInsert: TLazRibbonTab;
    LazRibbonTabReview: TLazRibbonTab;
    LazRibbonTabView: TLazRibbonTab;
    LazRibbonTabPicture: TLazRibbonTab;
    LazRibbonTabTable: TLazRibbonTab;
    LazRibbonPaneClipboard: TLazRibbonPane;
    LazRibbonPaneDocument: TLazRibbonPane;
    LazRibbonPaneSearch: TLazRibbonPane;
    LazRibbonPaneOutput: TLazRibbonPane;
    LazRibbonPaneReview: TLazRibbonPane;
    LazRibbonPaneZoom: TLazRibbonPane;
    LazRibbonPaneSkins: TLazRibbonPane;
    LazRibbonPanePictureTools: TLazRibbonPane;
    LazRibbonPaneTableTools: TLazRibbonPane;
    LazRibbonLargeButtonPaste: TLazRibbonLargeButton;
    LazRibbonSmallButtonCut: TLazRibbonSmallButton;
    LazRibbonSmallButtonCopy: TLazRibbonSmallButton;
    LazRibbonLargeButtonNew: TLazRibbonLargeButton;
    LazRibbonLargeButtonOpen: TLazRibbonLargeButton;
    LazRibbonSmallButtonSave: TLazRibbonSmallButton;
    LazRibbonSmallButtonFind: TLazRibbonSmallButton;
    LazRibbonLargeButtonExport: TLazRibbonLargeButton;
    LazRibbonLargeButtonPrint: TLazRibbonLargeButton;
    LazRibbonSmallButtonReview: TLazRibbonSmallButton;
    LazRibbonSmallButtonHelp: TLazRibbonSmallButton;
    LazRibbonSmallButtonZoomIn: TLazRibbonSmallButton;
    LazRibbonSmallButtonZoomOut: TLazRibbonSmallButton;
    LazRibbonSkinGalleryItem1: TLazRibbonSkinGalleryItem;
    LazRibbonLargeButtonPictureExport: TLazRibbonLargeButton;
    LazRibbonSmallButtonPictureZoomIn: TLazRibbonSmallButton;
    LazRibbonSmallButtonPictureZoomOut: TLazRibbonSmallButton;
    LazRibbonLargeButtonTableExport: TLazRibbonLargeButton;
    LazRibbonSmallButtonTableFind: TLazRibbonSmallButton;
    LazRibbonSmallButtonTableReview: TLazRibbonSmallButton;
    LazRibbonBackstageView1: TLazRibbonBackstageView;
    LazRibbonBackstagePageInfo: TLazRibbonBackstagePage;
    LazRibbonBackstagePageRecent: TLazRibbonBackstagePage;
    LazRibbonBackstagePageOptions: TLazRibbonBackstagePage;
    LabelInfoTitle: TLabel;
    LabelInfoText: TLabel;
    LabelInfoDetails: TLabel;
    LabelOptionsTitle: TLabel;
    LabelOptionsText: TLabel;
    LazRibbonBackstageRecentList1: TLazRibbonBackstageRecentList;
    PanelWorkArea: TPanel;
    LabelWorkTitle: TLabel;
    LabelWorkSubtitle: TLabel;
    MemoNotes: TMemo;
    PanelSidebar: TPanel;
    LabelSidebarTitle: TLabel;
    LabelSidebarText: TLabel;
    StatusBar1: TStatusBar;
    ButtonSelectPicture: TButton;
    ButtonSelectTable: TButton;
    ButtonClearContext: TButton;
    procedure ActionExecute(Sender: TObject);
    procedure ButtonClearContextClick(Sender: TObject);
    procedure ButtonSelectPictureClick(Sender: TObject);
    procedure ButtonSelectTableClick(Sender: TObject);
    procedure BackstageCommandExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RecentItemClick(Sender: TObject; Index: Integer; const Title, Detail: String);
  private
    procedure SetStatus(const AText: String);
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

procedure TForm1.SetStatus(const AText: String);
begin
  StatusBar1.SimpleText := AText;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  LazRibbon1.SkinManager := LazRibbonSkinManager1;
  LazRibbon1.BackstageView := LazRibbonBackstageView1;
  LazRibbon1.ApplicationButton.BackstageView := LazRibbonBackstageView1;
  LazRibbonBackstageView1.LinkedToolbar := LazRibbon1;
  LazRibbonBackstageView1.SkinManager := LazRibbonSkinManager1;
  LazRibbonBackstageRecentList1.SkinManager := LazRibbonSkinManager1;
  LazRibbonSkinGalleryItem1.SkinManager := LazRibbonSkinManager1;

  LazRibbon1.HideAllContextualTabs;
  SetStatus('Pronto. Use os botões da área de trabalho para mostrar/ocultar os grupos contextuais.');
end;

procedure TForm1.ButtonSelectPictureClick(Sender: TObject);
begin
  LazRibbon1.ShowContextualTabs('Ferramentas de Imagem', True);
  SetStatus('Contexto ativo: imagem selecionada. Aba contextual Imagem exibida.');
end;

procedure TForm1.ButtonSelectTableClick(Sender: TObject);
begin
  LazRibbon1.ShowContextualTabs('Ferramentas de Tabela', True);
  SetStatus('Contexto ativo: tabela selecionada. Aba contextual Tabela exibida.');
end;

procedure TForm1.ButtonClearContextClick(Sender: TObject);
begin
  LazRibbon1.HideAllContextualTabs;
  SetStatus('Contexto limpo. Abas contextuais ocultadas.');
end;

procedure TForm1.ActionExecute(Sender: TObject);
var
  CaptionText: String;
begin
  if Sender is TAction then
    CaptionText := TAction(Sender).Caption
  else
    CaptionText := 'Comando';

  if Sender = actExit then
    Close
  else
  begin
    SetStatus('Comando executado: ' + CaptionText);
    ShowMessage('Comando executado: ' + CaptionText);
  end;
end;

procedure TForm1.BackstageCommandExecute(Sender: TObject);
var
  CaptionText: String;
begin
  if Sender is TLazRibbonBackstageButton then
    CaptionText := TLazRibbonBackstageButton(Sender).EffectiveCaption
  else
    CaptionText := 'Comando BackStage';

  SetStatus('BackStage: ' + CaptionText);
  ShowMessage('BackStage: ' + CaptionText);
end;

procedure TForm1.RecentItemClick(Sender: TObject; Index: Integer; const Title, Detail: String);
begin
  SetStatus('Recente selecionado: ' + Title);
  ShowMessage('Abrir recente: ' + Title + LineEnding + Detail);
end;

end.
