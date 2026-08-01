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
  Grids, Dialogs, ActnList, Menus,
  LazRibbon_Form, LazRibbon_Core, LazRibbon_Tabs, LazRibbon_Groups,
  LazRibbon_Items, LazRibbon_Buttons, LazRibbon_Backstage,
  LazRibbon_RibbonExtItems, LazRibbon_SkinManager, LazRibbon_SkinDefinition,
  LazRibbon_Popup;

type
  TForm1 = class(TLazRibbonForm)
    ActionList1: TActionList;
    actNewCustomer: TAction;
    actEditCustomer: TAction;
    actSaveCustomer: TAction;
    actDeleteCustomer: TAction;
    actRefresh: TAction;
    actFind: TAction;
    actClearFilter: TAction;
    actExport: TAction;
    actPrint: TAction;
    actCloseMonth: TAction;
    actOptions: TAction;
    actHelp: TAction;
    actExit: TAction;
    LazRibbonSkinManager1: TLazRibbonSkinManager;
    LazRibbon1: TLazRibbon;
    TabHome: TLazRibbonTab;
    TabData: TLazRibbonTab;
    TabView: TLazRibbonTab;
    TabCustomerTools: TLazRibbonTab;
    PaneRecords: TLazRibbonPane;
    PaneSearch: TLazRibbonPane;
    PaneWorkflow: TLazRibbonPane;
    PaneOutput: TLazRibbonPane;
    PaneView: TLazRibbonPane;
    PaneCustomer: TLazRibbonPane;
    BtnNewCustomer: TLazRibbonLargeButton;
    BtnSaveCustomer: TLazRibbonLargeButton;
    BtnEditCustomer: TLazRibbonSmallButton;
    BtnDeleteCustomer: TLazRibbonSmallButton;
    BtnFind: TLazRibbonLargeButton;
    BtnClearFilter: TLazRibbonSmallButton;
    BtnRefresh: TLazRibbonSmallButton;
    BtnExport: TLazRibbonLargeButton;
    BtnPrint: TLazRibbonLargeButton;
    BtnCloseMonth: TLazRibbonSmallButton;
    BtnOptions: TLazRibbonSmallButton;
    BtnHelp: TLazRibbonSmallButton;
    SkinGallery: TLazRibbonSkinGalleryItem;
    BtnCustomerEdit: TLazRibbonSmallButton;
    BtnCustomerDelete: TLazRibbonSmallButton;
    BtnCustomerPrint: TLazRibbonLargeButton;
    BackstageView: TLazRibbonBackstageView;
    BackstagePageInfo: TLazRibbonBackstagePage;
    BackstagePageRecent: TLazRibbonBackstagePage;
    BackstagePageOptions: TLazRibbonBackstagePage;
    RecentList: TLazRibbonBackstageRecentList;
    LabelBackstageInfoTitle: TLabel;
    LabelBackstageInfoText: TLabel;
    LabelBackstageOptionsTitle: TLabel;
    LabelBackstageOptionsText: TLabel;
    PopupGrid: TLazRibbonPopupMenu;
    MenuNewCustomer: TMenuItem;
    MenuEditCustomer: TMenuItem;
    MenuDeleteCustomer: TMenuItem;
    MenuSeparator1: TMenuItem;
    MenuExport: TMenuItem;
    PanelClient: TPanel;
    PanelHeader: TPanel;
    LabelTitle: TLabel;
    LabelSubtitle: TLabel;
    EditSearch: TEdit;
    ButtonSearch: TButton;
    Splitter1: TSplitter;
    GridCustomers: TStringGrid;
    PanelEditor: TPanel;
    LabelEditorTitle: TLabel;
    LabelCode: TLabel;
    LabelName: TLabel;
    LabelCity: TLabel;
    LabelStatus: TLabel;
    LabelLimit: TLabel;
    EditCode: TEdit;
    EditName: TEdit;
    EditCity: TEdit;
    ComboStatus: TComboBox;
    EditLimit: TEdit;
    MemoNotes: TMemo;
    ButtonSave: TButton;
    ButtonNew: TButton;
    ButtonDelete: TButton;
    StatusBar1: TStatusBar;
    procedure ActionExecute(Sender: TObject);
    procedure BackstageRecentClick(Sender: TObject; Index: Integer; const Title,
      Detail: String);
    procedure ButtonSearchClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GridCustomersSelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
    procedure PaneDialogLauncherClick(Sender: TObject);
  private
    FEditingNew: Boolean;
    FNextCode: Integer;
    procedure AddCustomer(const AName, ACity, AStatus, ALimit, ANotes: String);
    procedure ClearEditor;
    procedure LoadCustomerRow(ARow: Integer);
    procedure LoadSelectedCustomer;
    procedure RefreshCustomerGrid(const AFilter: String = '');
    procedure SaveEditorToGrid;
    procedure SetStatus(const AText: String);
    function SelectedCustomerRow: Integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

procedure TForm1.SetStatus(const AText: String);
begin
  StatusBar1.SimpleText := AText;
end;

function TForm1.SelectedCustomerRow: Integer;
begin
  Result := GridCustomers.Row;
  if Result < 1 then
    Result := -1;
end;

procedure TForm1.ClearEditor;
begin
  EditCode.Clear;
  EditName.Clear;
  EditCity.Clear;
  ComboStatus.ItemIndex := 0;
  EditLimit.Text := '0,00';
  MemoNotes.Clear;
end;

procedure TForm1.AddCustomer(const AName, ACity, AStatus, ALimit, ANotes: String);
var
  Row: Integer;
begin
  Row := GridCustomers.RowCount;
  GridCustomers.RowCount := Row + 1;
  GridCustomers.Cells[0, Row] := Format('C%.4d', [FNextCode]);
  GridCustomers.Cells[1, Row] := AName;
  GridCustomers.Cells[2, Row] := ACity;
  GridCustomers.Cells[3, Row] := AStatus;
  GridCustomers.Cells[4, Row] := ALimit;
  GridCustomers.Cells[5, Row] := ANotes;
  Inc(FNextCode);
end;

procedure TForm1.RefreshCustomerGrid(const AFilter: String);
var
  I: Integer;
  FilterStatus: String;
begin
  GridCustomers.BeginUpdate;
  try
    for I := 1 to GridCustomers.RowCount - 1 do
      GridCustomers.RowHeights[I] := GridCustomers.DefaultRowHeight;

    if Trim(AFilter) <> '' then
      for I := 1 to GridCustomers.RowCount - 1 do
        if (Pos(AnsiUpperCase(AFilter), AnsiUpperCase(GridCustomers.Cells[1, I])) = 0) and
           (Pos(AnsiUpperCase(AFilter), AnsiUpperCase(GridCustomers.Cells[2, I])) = 0) and
           (Pos(AnsiUpperCase(AFilter), AnsiUpperCase(GridCustomers.Cells[3, I])) = 0) then
          GridCustomers.RowHeights[I] := 0;
  finally
    GridCustomers.EndUpdate;
  end;

  if Trim(AFilter) = '' then
    FilterStatus := 'nenhum'
  else
    FilterStatus := AFilter;
  SetStatus('Grade atualizada. Filtro: ' + FilterStatus);
end;

procedure TForm1.LoadCustomerRow(ARow: Integer);
begin
  if ARow < 1 then
  begin
    ClearEditor;
    Exit;
  end;

  FEditingNew := False;
  EditCode.Text := GridCustomers.Cells[0, ARow];
  EditName.Text := GridCustomers.Cells[1, ARow];
  EditCity.Text := GridCustomers.Cells[2, ARow];
  ComboStatus.Text := GridCustomers.Cells[3, ARow];
  EditLimit.Text := GridCustomers.Cells[4, ARow];
  MemoNotes.Text := GridCustomers.Cells[5, ARow];
  LazRibbon1.ShowContextualTabs('Cliente selecionado', True);
  SetStatus('Cliente selecionado: ' + EditName.Text);
end;

procedure TForm1.LoadSelectedCustomer;
begin
  LoadCustomerRow(SelectedCustomerRow);
end;

procedure TForm1.SaveEditorToGrid;
var
  Row: Integer;
begin
  Row := SelectedCustomerRow;
  if FEditingNew or (Row < 0) then
  begin
    AddCustomer(EditName.Text, EditCity.Text, ComboStatus.Text, EditLimit.Text,
      MemoNotes.Text);
    GridCustomers.Row := GridCustomers.RowCount - 1;
    FEditingNew := False;
  end
  else
  begin
    GridCustomers.Cells[1, Row] := EditName.Text;
    GridCustomers.Cells[2, Row] := EditCity.Text;
    GridCustomers.Cells[3, Row] := ComboStatus.Text;
    GridCustomers.Cells[4, Row] := EditLimit.Text;
    GridCustomers.Cells[5, Row] := MemoNotes.Text;
  end;

  LoadSelectedCustomer;
  SetStatus('Registro salvo: ' + EditName.Text);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Ribbon := LazRibbon1;
  SkinManager := LazRibbonSkinManager1;
  LazRibbon1.SkinManager := LazRibbonSkinManager1;
  LazRibbon1.BackstageView := BackstageView;
  BackstageView.LinkedToolbar := LazRibbon1;
  BackstageView.SkinManager := LazRibbonSkinManager1;
  RecentList.SkinManager := LazRibbonSkinManager1;
  SkinGallery.SkinManager := LazRibbonSkinManager1;

  GridCustomers.Cells[0, 0] := 'Codigo';
  GridCustomers.Cells[1, 0] := 'Cliente';
  GridCustomers.Cells[2, 0] := 'Cidade';
  GridCustomers.Cells[3, 0] := 'Status';
  GridCustomers.Cells[4, 0] := 'Limite';
  GridCustomers.Cells[5, 0] := 'Observacoes';
  GridCustomers.ColWidths[0] := 74;
  GridCustomers.ColWidths[1] := 190;
  GridCustomers.ColWidths[2] := 120;
  GridCustomers.ColWidths[3] := 100;
  GridCustomers.ColWidths[4] := 84;
  GridCustomers.ColWidths[5] := 260;

  FNextCode := 1;
  AddCustomer('Alfa Comercio Ltda.', 'Curitiba', 'Ativo', '15.000,00',
    'Cliente com contrato anual e atendimento prioritario.');
  AddCustomer('Beta Solucoes', 'Sao Paulo', 'Prospect', '8.500,00',
    'Aguardando retorno da proposta comercial.');
  AddCustomer('Clara Martins ME', 'Campinas', 'Ativo', '4.200,00',
    'Solicitou condicoes especiais para pagamento trimestral.');
  AddCustomer('Delta Servicos', 'Rio de Janeiro', 'Pendente', '11.000,00',
    'Cadastro fiscal precisa ser revisado antes de novo pedido.');
  AddCustomer('Escola Horizonte', 'Belo Horizonte', 'Ativo', '6.700,00',
    'Usa o modulo educacional no ambiente de homologacao.');

  ComboStatus.Items.Text := 'Ativo' + LineEnding + 'Prospect' + LineEnding +
    'Pendente' + LineEnding + 'Inativo';
  ComboStatus.ItemIndex := 0;
  GridCustomers.Row := 1;
  LoadSelectedCustomer;
end;

procedure TForm1.GridCustomersSelectCell(Sender: TObject; aCol, aRow: Integer;
  var CanSelect: Boolean);
begin
  CanSelect := True;
  if aRow > 0 then
    LoadCustomerRow(aRow);
end;

procedure TForm1.ButtonSearchClick(Sender: TObject);
begin
  RefreshCustomerGrid(EditSearch.Text);
end;

procedure TForm1.PaneDialogLauncherClick(Sender: TObject);
begin
  ShowMessage('Dialog Launcher do pane Registros.' + LineEnding +
    'Em uma aplicacao real, este ponto abriria a configuracao detalhada do cadastro.');
end;

procedure TForm1.BackstageRecentClick(Sender: TObject; Index: Integer;
  const Title, Detail: String);
begin
  SetStatus('BackStage recente: ' + Title);
  ShowMessage('Abrir base recente:' + LineEnding + Title + LineEnding + Detail);
end;

procedure TForm1.ActionExecute(Sender: TObject);
var
  Row: Integer;
begin
  if Sender = actExit then
  begin
    Close;
    Exit;
  end;

  if Sender = actNewCustomer then
  begin
    FEditingNew := True;
    ClearEditor;
    LazRibbon1.HideAllContextualTabs;
    EditName.SetFocus;
    SetStatus('Novo registro iniciado.');
    Exit;
  end;

  if Sender = actSaveCustomer then
  begin
    if Trim(EditName.Text) = '' then
    begin
      ShowMessage('Informe o nome do cliente antes de salvar.');
      Exit;
    end;
    SaveEditorToGrid;
    Exit;
  end;

  if Sender = actDeleteCustomer then
  begin
    Row := SelectedCustomerRow;
    if Row > 0 then
    begin
      GridCustomers.DeleteRow(Row);
      if GridCustomers.RowCount > 1 then
        GridCustomers.Row := 1;
      LoadSelectedCustomer;
      SetStatus('Registro excluido.');
    end;
    Exit;
  end;

  if Sender = actFind then
  begin
    RefreshCustomerGrid(EditSearch.Text);
    Exit;
  end;

  if Sender = actClearFilter then
  begin
    EditSearch.Clear;
    RefreshCustomerGrid('');
    Exit;
  end;

  if Sender = actRefresh then
  begin
    RefreshCustomerGrid(EditSearch.Text);
    Exit;
  end;

  if Sender = actEditCustomer then
  begin
    EditName.SetFocus;
    SetStatus('Edicao do registro atual.');
    Exit;
  end;

  if Sender = actHelp then
  begin
    ShowMessage('Demo Workbench CRUD: use a grade, o painel de edicao, o BackStage e a galeria de skins para testar a composicao dos componentes LazRibbon.');
    Exit;
  end;

  if Sender is TAction then
  begin
    SetStatus('Comando executado: ' + TAction(Sender).Caption);
    ShowMessage('Comando executado: ' + TAction(Sender).Caption);
  end;
end;

end.
