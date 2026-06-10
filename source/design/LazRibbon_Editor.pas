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

unit LazRibbon_Editor;

{$mode Delphi}

interface

uses Forms, Controls, Classes, ComponentEditors, PropEdits, LazarusPackageIntf, LazIdeIntf, TypInfo, Dialogs,
     SysUtils, ImgList, GraphPropEdits, Graphics,
     LazRibbon_Core, LazRibbon_Tabs, LazRibbon_Groups, LazRibbon_Buttons,
     LazRibbon_BaseItem, LazRibbon_EditWindow, LazRibbon_AppearanceEditor;

const PROPERTY_CONTENTS_NAME = 'Contents';
      PROPERTY_CONTENTS_VALUE = 'Open editor...';

 //type
 //
 // TAddContentsFilter = class(TSelectionEditor, ISelectionPropertyFilter)
 //    public
 //      procedure FilterProperties(const ASelection: IDesignerSelections; const ASelectionProperties: IInterfaceList);
 //    end;
 //
 //TLazRibbonContentsEditor = class(TBasePropertyEditor, IProperty, IPropertyKind)
 //    private
 //    protected
 //      FPropList : PInstPropList;
 //      FPropCount : integer;
 //      FDesigner : IDesigner;
 //      FToolbar : TLazRibbon;
 //
 //      procedure SetPropEntry(Index: Integer; AInstance: TPersistent;
 //         APropInfo: PPropInfo); override;
 //      procedure Initialize; override;
 //    public
 //      constructor Create(const ADesigner: IDesigner; APropCount: Integer); override;
 //      destructor Destroy; override;
 //
 //      procedure Activate;
 //      function AllEqual: Boolean;
 //      function AutoFill: Boolean;
 //      procedure Edit;
 //      function HasInstance(Instance: TPersistent): Boolean;
 //      function GetAttributes: TPropertyAttributes;
 //      function GetEditLimit: Integer;
 //      function GetEditValue(out Value: string): Boolean;
 //      function GetName: string;
 //      procedure GetProperties(Proc: TGetPropProc);
 //      function GetPropInfo: PPropInfo;
 //      function GetPropType: PTypeInfo;
 //      function GetValue: string;
 //      procedure GetValues(Proc: TGetStrProc);
 //      procedure Revert;
 //      procedure SetValue(const Value: string);
 //      function ValueAvailable: Boolean;
 //
 //      function GetKind: TTypeKind;
 //
 //      property PropCount : integer read FPropCount;
 //      property Designer : IDesigner read FDesigner;
 //      property Toolbar : TLazRibbon read FToolbar write FToolbar;
 //    end;

type TLazRibbonCaptionEditor = class(TStringProperty)
     private
     protected
     public
       procedure SetValue(const Value: string); override;
     end;

type TLazRibbonToolbarAppearanceEditor = class(TClassProperty)
     private
     protected
     public
       function GetAttributes: TPropertyAttributes; override;
       procedure Edit; override;
     end;

type TLazRibbonEditor = class(TComponentEditor)
     protected
       function GetRibbon: TLazRibbon;
       function MakeUniqueComponentName(AOwner: TComponent; const APrefix: string): string;
       procedure MarkDesignerModified;
       procedure DoOpenContentsEditor;
       procedure DoAddBasicTab;
       procedure DoAddContextualTab;
       procedure DoAddStarterLayout;
       procedure DoValidateKeyTips;
     public
       procedure Edit; override;
       procedure ExecuteVerb(Index: Integer); override;
       function GetVerb(Index: Integer): string; override;
       function GetVerbCount: Integer; override;
     end;

type TLazRibbonImageIndexPropertyEditor = class(TImageIndexPropertyEditor)
     protected
       function GetImageList: TCustomImageList; override;
     end;

var EditWindow : TfrmLazRibbonEditWindow;

implementation

{ TLazRibbonEditor }

//procedure TLazRibbonContentsEditor.Activate;
//begin
////
//end;
//
//function TLazRibbonContentsEditor.AllEqual: Boolean;
//begin
//result:=FPropCount = 1;
//end;
//
//function TLazRibbonContentsEditor.AutoFill: Boolean;
//begin
//result:=false;
//end;
//
//constructor TLazRibbonContentsEditor.Create(const ADesigner: IDesigner;
//  APropCount: Integer);
//begin
//  inherited Create(ADesigner, APropCount);
//  FDesigner:=ADesigner;
//  FPropCount:=APropCount;
//  FToolbar:=nil;
//  GetMem(FPropList, APropCount * SizeOf(TInstProp));
//  FillChar(FPropList^, APropCount * SizeOf(TInstProp), 0);
//end;
//
//destructor TLazRibbonContentsEditor.Destroy;
//begin
//  if FPropList <> nil then
//    FreeMem(FPropList, FPropCount * SizeOf(TInstProp));
//  inherited;
//end;
//
//procedure TLazRibbonContentsEditor.Edit;
//begin
//  EditWindow.SetData(FToolbar,self.Designer);
//  EditWindow.Show;
//end;
//
//function TLazRibbonContentsEditor.GetAttributes: TPropertyAttributes;
//begin
//result:=[paDialog, paReadOnly];
//end;
//
//function TLazRibbonContentsEditor.GetEditLimit: Integer;
//begin
//result:=0;
//end;
//
//function TLazRibbonContentsEditor.GetEditValue(out Value: string): Boolean;
//begin
//Value:=GetValue;
//result:=true;
//end;
//
//function TLazRibbonContentsEditor.GetKind: TTypeKind;
//begin
//result:=tkClass;
//end;
//
//function TLazRibbonContentsEditor.GetName: string;
//begin
//result:=PROPERTY_CONTENTS_NAME;
//end;
//
//procedure TLazRibbonContentsEditor.GetProperties(Proc: TGetPropProc);
//begin
////
//end;
//
//function TLazRibbonContentsEditor.GetPropInfo: PPropInfo;
//begin
//Result:=nil;
//end;
//
//function TLazRibbonContentsEditor.GetPropType: PTypeInfo;
//begin
//Result:=nil;
//end;
//
//function TLazRibbonContentsEditor.GetValue: string;
//begin
//result:=PROPERTY_CONTENTS_VALUE;
//end;
//
//procedure TLazRibbonContentsEditor.GetValues(Proc: TGetStrProc);
//begin
////
//end;
//
//function TLazRibbonContentsEditor.HasInstance(Instance: TPersistent): Boolean;
//begin
//  result:=EditWindow.Toolbar = Instance;
//end;
//
//procedure TLazRibbonContentsEditor.Initialize;
//begin
//  inherited;
//end;
//
//procedure TLazRibbonContentsEditor.Revert;
//begin
////
//end;
//
//procedure TLazRibbonContentsEditor.SetPropEntry(Index: Integer; AInstance: TPersistent;
//  APropInfo: PPropInfo);
//begin
//with FPropList^[Index] do
//     begin
//     Instance := AInstance;
//     PropInfo := APropInfo;
//     end;
//end;
//
//procedure TLazRibbonContentsEditor.SetValue(const Value: string);
//begin
////
//end;
//
//function TLazRibbonContentsEditor.ValueAvailable: Boolean;
//begin
//result:=true;
//end;

{ TSelectionFilter }

//procedure TAddContentsFilter.FilterProperties(
//  const ASelection: IDesignerSelections;
//  const ASelectionProperties: IInterfaceList);
//
//var ContentsEditor : TLazRibbonContentsEditor;
//    Prop : IProperty;
//    i : integer;
//    Added : boolean;
//
//begin
//if ASelection.Count<>1 then
//   exit;
//
//if ASelection[0] is TLazRibbon then
//   begin
//   ContentsEditor:=TLazRibbonContentsEditor.Create(inherited Designer, 1);
//   ContentsEditor.Toolbar:=ASelection[0] as TLazRibbon;
//
//   i:=0;
//   Added:=false;
//   while (i<ASelectionProperties.Count) and not Added do
//         begin
//         ASelectionProperties.Items[i].QueryInterface(IProperty, Prop);
//         if (assigned(Prop)) and (Prop.GetName>PROPERTY_CONTENTS_NAME) then
//            begin
//            ASelectionProperties.Insert(i, ContentsEditor);
//            Added:=true;
//            end;
//         inc(i);
//         end;
//
//   if not(Added) then
//      ASelectionProperties.Add(ContentsEditor as IProperty);
//   end;
//end;

{ TLazRibbonEditor }

function TLazRibbonEditor.GetRibbon: TLazRibbon;
var
  Component: TComponent;
begin
  Result := nil;
  Component := Self.GetComponent;
  if Component is TLazRibbon then
    Result := TLazRibbon(Component);
end;

function TLazRibbonEditor.MakeUniqueComponentName(AOwner: TComponent; const APrefix: string): string;

  function NameExists(AComponent: TComponent; const AName: string): Boolean;
  var
    I: Integer;
  begin
    Result := False;
    if AComponent = nil then
      Exit;

    if SameText(AComponent.Name, AName) then
      Exit(True);

    for I := 0 to AComponent.ComponentCount - 1 do
      if NameExists(AComponent.Components[I], AName) then
        Exit(True);
  end;

var
  I: Integer;
begin
  I := 1;
  repeat
    Result := APrefix + IntToStr(I);
    Inc(I);
  until not NameExists(AOwner, Result);
end;

procedure TLazRibbonEditor.MarkDesignerModified;
begin
  if Designer <> nil then
    Designer.Modified;
end;

procedure TLazRibbonEditor.DoOpenContentsEditor;
var
  Ribbon: TLazRibbon;
begin
  Ribbon := GetRibbon;
  if Ribbon = nil then
    Exit;

  if EditWindow = nil then
    EditWindow := TfrmLazRibbonEditWindow.Create(nil);
  EditWindow.SetData(Ribbon, Self.GetDesigner);
  EditWindow.Show;
end;

procedure TLazRibbonEditor.DoAddBasicTab;
var
  Ribbon: TLazRibbon;
  OwnerForNames: TComponent;
  Tab: TLazRibbonTab;
  Pane: TLazRibbonPane;
  LargeButton: TLazRibbonLargeButton;
  SmallButton: TLazRibbonSmallButton;
begin
  Ribbon := GetRibbon;
  if Ribbon = nil then
    Exit;

  OwnerForNames := Ribbon;

  Tab := Ribbon.Tabs.Add;
  Tab.Name := MakeUniqueComponentName(OwnerForNames, 'LazRibbonTab');
  Tab.Caption := 'Nova aba';
  Tab.KeyTip := '';
  Tab.Visible := True;

  Pane := Tab.Panes.Add;
  Pane.Name := MakeUniqueComponentName(OwnerForNames, 'LazRibbonPane');
  Pane.Caption := 'Grupo';

  LargeButton := Pane.Items.AddLargeButton;
  LargeButton.Name := MakeUniqueComponentName(OwnerForNames, 'LazRibbonLargeButton');
  LargeButton.Caption := 'Novo';
  LargeButton.KeyTip := 'N';
  LargeButton.ScreenTipTitle := 'Novo';
  LargeButton.ScreenTipText := 'Comando criado pelo assistente de design-time.';

  SmallButton := Pane.Items.AddSmallButton;
  SmallButton.Name := MakeUniqueComponentName(OwnerForNames, 'LazRibbonSmallButton');
  SmallButton.Caption := 'Abrir';
  SmallButton.KeyTip := 'O';
  SmallButton.ShowCaption := True;
  SmallButton.ScreenTipTitle := 'Abrir';
  SmallButton.ScreenTipText := 'Segundo comando criado pelo assistente de design-time.';

  Ribbon.TabIndex := Ribbon.Tabs.Count - 1;
  Ribbon.Invalidate;
  MarkDesignerModified;
end;

procedure TLazRibbonEditor.DoAddContextualTab;
var
  Ribbon: TLazRibbon;
  OwnerForNames: TComponent;
  Tab: TLazRibbonTab;
  Pane: TLazRibbonPane;
  LargeButton: TLazRibbonLargeButton;
begin
  Ribbon := GetRibbon;
  if Ribbon = nil then
    Exit;

  OwnerForNames := Ribbon;

  Tab := Ribbon.Tabs.Add;
  Tab.Name := MakeUniqueComponentName(OwnerForNames, 'LazRibbonContextualTab');
  Tab.Caption := 'Contexto';
  Tab.KeyTip := 'K';
  Tab.Contextual := True;
  Tab.ContextualGroupCaption := 'Ferramentas Contextuais';
  Tab.ContextualColor := TColor($00800080);
  Tab.Visible := True;

  Pane := Tab.Panes.Add;
  Pane.Name := MakeUniqueComponentName(OwnerForNames, 'LazRibbonContextualPane');
  Pane.Caption := 'Contextual';

  LargeButton := Pane.Items.AddLargeButton;
  LargeButton.Name := MakeUniqueComponentName(OwnerForNames, 'LazRibbonContextualButton');
  LargeButton.Caption := 'Ação contextual';
  LargeButton.KeyTip := 'A';
  LargeButton.ScreenTipTitle := 'Ação contextual';
  LargeButton.ScreenTipText := 'Comando criado em uma aba contextual pelo assistente de design-time.';

  Ribbon.TabIndex := Ribbon.Tabs.Count - 1;
  Ribbon.Invalidate;
  MarkDesignerModified;
end;

procedure TLazRibbonEditor.DoAddStarterLayout;
var
  Ribbon: TLazRibbon;
  OwnerForNames: TComponent;
  TabHome, TabInsert, TabView, TabImage: TLazRibbonTab;
  PaneClipboard, PaneFile, PaneInsert, PaneView, PaneImage: TLazRibbonPane;
  BtnPaste, BtnCut, BtnCopy, BtnNew, BtnOpen, BtnSave: TLazRibbonBaseButton;
  BtnTable, BtnPicture, BtnZoom, BtnPanel, BtnCrop, BtnResize: TLazRibbonBaseButton;
  QATItem: TLazRibbonQuickAccessItem;

  procedure ConfigureLargeButton(AButton: TLazRibbonBaseButton; const ACaption,
    AKeyTip, AScreenTipText: string);
  begin
    AButton.Name := MakeUniqueComponentName(OwnerForNames, 'LazRibbonLargeButton');
    AButton.Caption := ACaption;
    AButton.KeyTip := AKeyTip;
    AButton.ScreenTipTitle := ACaption;
    AButton.ScreenTipText := AScreenTipText;
  end;

  procedure ConfigureSmallButton(AButton: TLazRibbonBaseButton; const ACaption,
    AKeyTip, AScreenTipText: string);
  begin
    AButton.Name := MakeUniqueComponentName(OwnerForNames, 'LazRibbonSmallButton');
    AButton.Caption := ACaption;
    AButton.KeyTip := AKeyTip;
    AButton.ScreenTipTitle := ACaption;
    AButton.ScreenTipText := AScreenTipText;
    if AButton is TLazRibbonSmallButton then
      TLazRibbonSmallButton(AButton).ShowCaption := True;
  end;

  procedure AddQATLinkedItem(AButton: TLazRibbonBaseItem; const AKeyTip: string);
  begin
    QATItem := Ribbon.QuickAccessToolBar.Items.AddLinkedItem(AButton);
    QATItem.KeyTip := AKeyTip;
  end;

begin
  Ribbon := GetRibbon;
  if Ribbon = nil then
    Exit;

  OwnerForNames := Ribbon;
  Ribbon.BeginUpdate;
  try
    Ribbon.ApplicationButton.Visible := True;
    Ribbon.ApplicationButton.Caption := 'Arquivo';
    Ribbon.ApplicationButton.KeyTip := 'A';
    Ribbon.ApplicationButton.ScreenTipTitle := 'Arquivo';
    Ribbon.ApplicationButton.ScreenTipText := 'Abre comandos globais da aplicação, como abrir, salvar, imprimir e opções.';
    Ribbon.ShowKeyTips := True;
    Ribbon.ShowCollapseButton := True;
    Ribbon.ShowHelpButton := True;

    Ribbon.QuickAccessToolBar.Visible := True;
    Ribbon.QuickAccessToolBar.Position := qapTitleBar;
    Ribbon.QuickAccessToolBar.ShowCustomizeButton := True;
    Ribbon.QuickAccessToolBar.ButtonFrameStyle := qfsHotOnly;

    TabHome := Ribbon.Tabs.Add;
    TabHome.Name := MakeUniqueComponentName(OwnerForNames, 'LazRibbonTab');
    TabHome.Caption := 'Início';
    TabHome.KeyTip := 'I';
    TabHome.Visible := True;

    PaneClipboard := TabHome.Panes.Add;
    PaneClipboard.Name := MakeUniqueComponentName(OwnerForNames, 'LazRibbonPane');
    PaneClipboard.Caption := 'Área de Transferência';

    BtnPaste := PaneClipboard.Items.AddLargeButton;
    ConfigureLargeButton(BtnPaste, 'Colar', 'V', 'Cola o conteúdo da área de transferência.');
    BtnCut := PaneClipboard.Items.AddSmallButton;
    ConfigureSmallButton(BtnCut, 'Recortar', 'X', 'Remove a seleção e envia para a área de transferência.');
    BtnCopy := PaneClipboard.Items.AddSmallButton;
    ConfigureSmallButton(BtnCopy, 'Copiar', 'C', 'Copia a seleção para a área de transferência.');

    PaneFile := TabHome.Panes.Add;
    PaneFile.Name := MakeUniqueComponentName(OwnerForNames, 'LazRibbonPane');
    PaneFile.Caption := 'Documento';

    BtnNew := PaneFile.Items.AddLargeButton;
    ConfigureLargeButton(BtnNew, 'Novo', 'N', 'Cria um novo documento ou registro.');
    BtnOpen := PaneFile.Items.AddSmallButton;
    ConfigureSmallButton(BtnOpen, 'Abrir', 'O', 'Abre um documento ou registro existente.');
    BtnSave := PaneFile.Items.AddSmallButton;
    ConfigureSmallButton(BtnSave, 'Salvar', 'S', 'Salva o documento ou registro atual.');

    TabInsert := Ribbon.Tabs.Add;
    TabInsert.Name := MakeUniqueComponentName(OwnerForNames, 'LazRibbonTab');
    TabInsert.Caption := 'Inserir';
    TabInsert.KeyTip := 'T';
    TabInsert.Visible := True;

    PaneInsert := TabInsert.Panes.Add;
    PaneInsert.Name := MakeUniqueComponentName(OwnerForNames, 'LazRibbonPane');
    PaneInsert.Caption := 'Elementos';

    BtnTable := PaneInsert.Items.AddLargeButton;
    ConfigureLargeButton(BtnTable, 'Tabela', 'B', 'Insere ou seleciona uma tabela.');
    BtnPicture := PaneInsert.Items.AddLargeButton;
    ConfigureLargeButton(BtnPicture, 'Imagem', 'P', 'Insere ou seleciona uma imagem.');

    TabView := Ribbon.Tabs.Add;
    TabView.Name := MakeUniqueComponentName(OwnerForNames, 'LazRibbonTab');
    TabView.Caption := 'Exibir';
    TabView.KeyTip := 'E';
    TabView.Visible := True;

    PaneView := TabView.Panes.Add;
    PaneView.Name := MakeUniqueComponentName(OwnerForNames, 'LazRibbonPane');
    PaneView.Caption := 'Janela';

    BtnZoom := PaneView.Items.AddLargeButton;
    ConfigureLargeButton(BtnZoom, 'Zoom', 'Z', 'Ajusta a ampliação da área de trabalho.');
    BtnPanel := PaneView.Items.AddSmallButton;
    ConfigureSmallButton(BtnPanel, 'Painel', 'P', 'Mostra ou oculta painéis auxiliares.');

    TabImage := Ribbon.Tabs.Add;
    TabImage.Name := MakeUniqueComponentName(OwnerForNames, 'LazRibbonContextualTab');
    TabImage.Caption := 'Imagem';
    TabImage.KeyTip := 'M';
    TabImage.Contextual := True;
    TabImage.ContextualGroupCaption := 'Ferramentas de Imagem';
    TabImage.ContextualColor := TColor($00800080);
    TabImage.Visible := True;

    PaneImage := TabImage.Panes.Add;
    PaneImage.Name := MakeUniqueComponentName(OwnerForNames, 'LazRibbonContextualPane');
    PaneImage.Caption := 'Ajustar';

    BtnCrop := PaneImage.Items.AddLargeButton;
    ConfigureLargeButton(BtnCrop, 'Recortar', 'R', 'Recorta a imagem selecionada.');
    BtnResize := PaneImage.Items.AddSmallButton;
    ConfigureSmallButton(BtnResize, 'Redimensionar', 'D', 'Altera o tamanho da imagem selecionada.');

    AddQATLinkedItem(BtnNew, '1');
    AddQATLinkedItem(BtnOpen, '2');
    AddQATLinkedItem(BtnSave, '3');

    Ribbon.TabIndex := TabHome.Collection.IndexOf(TabHome);
  finally
    Ribbon.EndUpdate;
  end;

  Ribbon.Invalidate;
  MarkDesignerModified;
end;


procedure TLazRibbonEditor.DoValidateKeyTips;
var
  Ribbon: TLazRibbon;
  RootKeys, ScopeKeys, Issues: TStringList;
  I, J, K: Integer;
  Tab: TLazRibbonTab;
  Pane: TLazRibbonPane;
  Item: TLazRibbonBaseItem;
  QATItem: TLazRibbonQuickAccessItem;

  function NormalizeKeyTip(const AValue: string): string;
  begin
    Result := UpperCase(Trim(StringReplace(AValue, '&', '', [rfReplaceAll])));
  end;

  function DisplayNameForComponent(AComponent: TComponent; const AFallback: string): string;
  begin
    if (AComponent <> nil) and (AComponent.Name <> '') then
      Result := AComponent.Name
    else
      Result := AFallback;
  end;

  function DisplayNameForItem(AItem: TLazRibbonBaseItem): string;
  begin
    Result := '';
    if AItem is TLazRibbonBaseButton then
      Result := TLazRibbonBaseButton(AItem).Caption;

    if Result = '' then
      Result := DisplayNameForComponent(AItem, AItem.ClassName)
    else if AItem.Name <> '' then
      Result := Result + ' [' + AItem.Name + ']';
  end;

  procedure AddKey(AList: TStringList; const AKey, ADescription: string;
    const AScope: string);
  var
    Key, ExistingKey: string;
    ExistingIndex, PrefixIndex: Integer;
  begin
    Key := NormalizeKeyTip(AKey);
    if Key = '' then
      Exit;

    ExistingIndex := AList.IndexOfName(Key);
    if ExistingIndex >= 0 then
      Issues.Add('Collision in ' + AScope + ': "' + Key + '" is used by ' +
        AList.ValueFromIndex[ExistingIndex] + ' and ' + ADescription + '.')
    else
    begin
      { Multi-character KeyTips are accepted incrementally. Therefore a key such
        as "B" and another key such as "BA" in the same overlay scope are
        ambiguous: the first keystroke would already match the shorter key. }
      for PrefixIndex := 0 to AList.Count - 1 do
      begin
        ExistingKey := AList.Names[PrefixIndex];
        if (ExistingKey <> '') and
           ((System.Copy(Key, 1, Length(ExistingKey)) = ExistingKey) or
            (System.Copy(ExistingKey, 1, Length(Key)) = Key)) then
          Issues.Add('Prefix ambiguity in ' + AScope + ': "' + Key +
            '" (' + ADescription + ') conflicts with "' + ExistingKey +
            '" (' + AList.ValueFromIndex[PrefixIndex] + ').');
      end;

      AList.Values[Key] := ADescription;
    end;
  end;

  procedure AddMissing(const ADescription, AScope: string);
  begin
    Issues.Add('Missing KeyTip in ' + AScope + ': ' + ADescription + '.');
  end;

  procedure AddRootKey(const AKey, ADescription: string);
  begin
    AddKey(RootKeys, AKey, ADescription, 'root overlay');
  end;

  procedure AddItemKey(ATab: TLazRibbonTab; AItem: TLazRibbonBaseItem;
    AScopeKeys: TStringList);
  var
    ScopeName: string;
  begin
    if (AItem = nil) or not AItem.Visible then
      Exit;

    ScopeName := 'tab "' + ATab.Caption + '"';
    if NormalizeKeyTip(AItem.KeyTip) = '' then
      AddMissing(DisplayNameForItem(AItem), ScopeName)
    else
      AddKey(AScopeKeys, AItem.KeyTip, DisplayNameForItem(AItem), ScopeName);
  end;

begin
  Ribbon := GetRibbon;
  if Ribbon = nil then
    Exit;

  RootKeys := TStringList.Create;
  ScopeKeys := TStringList.Create;
  Issues := TStringList.Create;
  try
    RootKeys.NameValueSeparator := '=';
    ScopeKeys.NameValueSeparator := '=';
    RootKeys.CaseSensitive := False;
    ScopeKeys.CaseSensitive := False;

    if Ribbon.ApplicationButton.Visible then
    begin
      if NormalizeKeyTip(Ribbon.ApplicationButton.KeyTip) = '' then
        AddMissing('Application Button', 'root overlay')
      else
        AddRootKey(Ribbon.ApplicationButton.KeyTip, 'Application Button');
    end;

    for I := 0 to Ribbon.Tabs.Count - 1 do
    begin
      Tab := Ribbon.Tabs[I];
      if (Tab <> nil) and Tab.Visible then
      begin
        if NormalizeKeyTip(Tab.KeyTip) = '' then
          AddMissing('tab "' + Tab.Caption + '"', 'root overlay')
        else
          AddRootKey(Tab.KeyTip, 'tab "' + Tab.Caption + '"');
      end;
    end;

    if (Ribbon.QuickAccessToolBar <> nil) and Ribbon.QuickAccessToolBar.Visible then
      for I := 0 to Ribbon.QuickAccessToolBar.Items.Count - 1 do
      begin
        QATItem := Ribbon.QuickAccessToolBar.Items[I];
        if (QATItem <> nil) and QATItem.Visible then
        begin
          if NormalizeKeyTip(QATItem.KeyTip) <> '' then
            AddRootKey(QATItem.KeyTip, 'QAT item ' + IntToStr(I + 1) +
              ' (' + QATItem.EffectiveCaption + ')')
          else
            AddRootKey(IntToStr(I + 1), 'QAT item ' + IntToStr(I + 1) +
              ' (' + QATItem.EffectiveCaption + ')');
        end;
      end;

    for I := 0 to Ribbon.Tabs.Count - 1 do
    begin
      Tab := Ribbon.Tabs[I];
      if (Tab = nil) or not Tab.Visible then
        Continue;

      { Command KeyTips are a second-stage overlay after a tab KeyTip is pressed.
        Therefore command KeyTips are validated against other commands in the
        same tab, not against root-level Application/QAT/tab KeyTips. }
      ScopeKeys.Clear;
      ScopeKeys.NameValueSeparator := '=';
      ScopeKeys.CaseSensitive := False;

      for J := 0 to Tab.Panes.Count - 1 do
      begin
        Pane := Tab.Panes[J];
        if (Pane = nil) or not Pane.Visible then
          Continue;

        for K := 0 to Pane.Items.Count - 1 do
        begin
          Item := Pane.Items[K];
          AddItemKey(Tab, Item, ScopeKeys);
        end;
      end;
    end;

    if Issues.Count = 0 then
      ShowMessage('KeyTip validation finished: no collisions or missing visible KeyTips were found.')
    else
      ShowMessage('KeyTip validation found ' + IntToStr(Issues.Count) +
        ' issue(s):' + LineEnding + LineEnding + Issues.Text);
  finally
    Issues.Free;
    ScopeKeys.Free;
    RootKeys.Free;
  end;
end;

procedure TLazRibbonEditor.Edit;
begin
  DoOpenContentsEditor;
end;

procedure TLazRibbonEditor.ExecuteVerb(Index: Integer);
begin
  case Index of
    0: DoOpenContentsEditor;
    2: DoAddBasicTab;
    3: DoAddContextualTab;
    4: DoAddStarterLayout;
    6: DoValidateKeyTips;
  end;
end;

function TLazRibbonEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Contents editor...';
    1: Result := '-';
    2: Result := 'Add basic tab';
    3: Result := 'Add contextual tab';
    4: Result := 'Add starter Ribbon layout';
    5: Result := '-';
    6: Result := 'Validate KeyTips';
  else
    Result := '';
  end;
end;

function TLazRibbonEditor.GetVerbCount: Integer;
begin
  Result := 7;
end;

{ TLazRibbonCaptionEditor }

procedure TLazRibbonCaptionEditor.SetValue(const Value: string);
begin
  inherited;
  EditWindow.RefreshNames;
end;

{ TLazRibbonImageIndexPropertyEditor }

function TLazRibbonImageIndexPropertyEditor.GetImagelist: TCustomImageList;
var
  Instance: TPersistent;
begin
  Result := nil;
  Instance := GetComponent(0);
  if (Instance is TLazRibbonLargeButton) then
    Result := TLazRibbonLargeButton(Instance).Images
  else if (Instance is TLazRibbonSmallButton) then
    Result := TLazRibbonSmallButton(Instance).Images;
end;

{ TLazRibbonToolbarAppearanceEditor }

procedure TLazRibbonToolbarAppearanceEditor.Edit;
var
  Obj: TObject;
  Toolbar: TLazRibbon;
  Tab: TLazRibbonTab;
  AppearanceEditor: TfrmLazRibbonAppearanceEditWindow;
begin
  Obj:=GetComponent(0);
  if Obj is TLazRibbon then
  begin
    Toolbar := TLazRibbon(Obj);

    AppearanceEditor:=TfrmLazRibbonAppearanceEditWindow.Create(nil);
    try
      AppearanceEditor.Appearance.Assign(Toolbar.Appearance);
      if AppearanceEditor.ShowModal = mrOK then
      begin
        Toolbar.Appearance.Assign(AppearanceEditor.Appearance);
        Modified;
      end;
    finally
      AppearanceEditor.Free;
    end;

  end else
    if Obj is TLazRibbonTab then
    begin
      Tab:=TLazRibbonTab(Obj);

      AppearanceEditor:=TfrmLazRibbonAppearanceEditWindow.Create(nil);
      try
        AppearanceEditor.Appearance.Assign(Tab.CustomAppearance);
        if AppearanceEditor.ShowModal = mrOK then
        begin
          Tab.CustomAppearance.Assign(AppearanceEditor.Appearance);
          Modified;
        end;
      finally
        AppearanceEditor.Free;
      end;

    end;
end;

function TLazRibbonToolbarAppearanceEditor.GetAttributes: TPropertyAttributes;
begin
  result:=inherited GetAttributes + [paDialog] - [paMultiSelect];
end;

initialization
  //EditWindow:=TfrmLazRibbonEditWindow.create(nil);

finalization
  EditWindow.Free;

end.
