# Controles de entrada no Ribbon

O editor **Contents editor...** oferece os itens abaixo em **Add item**, tanto
na barra de ferramentas quanto no menu de contexto. As propriedades dos itens são
editáveis no Object Inspector e persistem no `.lfm`.

| Menu | Classe | Propriedades específicas |
| --- | --- | --- |
| Edit | `TLazRibbonEditItem` | `Text`, `ReadOnly`, `OnChange` |
| Combo Box | `TLazRibbonComboBoxItem` | `Items`, `ItemIndex`, `Text`, `Style`, `OnChange` |
| Font Name Combo Box | `TLazRibbonFontNameComboBoxItem` | `FontName`, `ShowFontPreview`, `DropDownCount`, `OnChange` |
| Color Combo Box | `TLazRibbonColorComboBoxItem` | `SelectedColor`, `OnChange`, `OnApply` |
| Date Edit | `TLazRibbonDateEditItem` | `Date`, `ReadOnly`, `OnChange` |
| Spin Edit | `TLazRibbonSpinEditItem` | `MinValue`, `MaxValue`, `Increment`, `Value`, `OnChange` |
| Static Text | `TLazRibbonStaticTextItem` | `Caption`, `Alignment` |
| Progress Bar | `TLazRibbonProgressBarItem` | `Min`, `Max`, `Position` |
| Control Host | `TLazRibbonControlHostItem` | `Control` e propriedades do item estendido |

## Instalação e criação visual

1. Compile `packages/LazRibbonRuntime.lpk`.
2. Compile o pacote instalado `packages/LazRibbonDesign.lpk` e reconstrua/reinicie
   o Lazarus para carregar o novo editor.
3. Abra **Contents editor...** em um `TLazRibbon` e selecione um grupo (`Pane`).
4. Escolha o tipo em **Add item** e configure suas propriedades no Object Inspector.
5. Para os itens de entrada, conecte `OnChange` ao comportamento da aplicação.

Nos itens nativos, `Width` define a largura solicitada e `Layout` define
a posição na tabela do grupo. O padrão `tbBeginsRow` permite empilhar até três
itens em uma coluna; use `tbBeginsColumn` para iniciar outra coluna e
`tbContinuesRow` para continuar a mesma linha.

`Caption` identifica o item na árvore do editor. Nos itens de entrada, o conteúdo
visível vem de `Text`, `Items`, `FontName` ou `Value`; use **Static Text** para um rótulo
visível. `Hint` e as propriedades `ScreenTip*` configuram dicas do controle.

## Criação por código

Adicione `LazRibbon_ControlItems` ao `uses`. Partindo de um `TLazRibbonPane`:

```pascal
with Pane.Items.AddEdit do
begin
  Caption := 'Pesquisar';
  Width := 180;
  Text := '';
  KeyTip := 'P';
  OnChange := @PesquisarAlterado;
end;

with Pane.Items.AddFontNameComboBox do
begin
  Caption := 'Fonte';
  Width := 180;
  FontName := 'Arial';
  OnChange := @FonteAlterada;
end;

with Pane.Items.AddSpinEdit do
begin
  Caption := 'Tamanho';
  MinValue := 8;
  MaxValue := 72;
  Value := 12;
  OnChange := @TamanhoAlterado;
end;
```

Os eventos recebem o item Ribbon em `Sender`, por exemplo:

```pascal
procedure TForm1.FonteAlterada(Sender: TObject);
begin
  Memo1.Font.Name := TLazRibbonFontNameComboBoxItem(Sender).FontName;
end;
```

No item genérico **Combo Box**, `Style = csDropDownList` é o padrão da lista e restringe a seleção a `Items`.
Use `csDropDown` para permitir digitação livre. `ItemIndex = -1` limpa a seleção;
os outros índices devem existir em `Items`.

Use `Pane.Items.AddProgressBar` para criar uma barra de progresso por código.
Defina o intervalo com `Min` e `Max` e atualize o valor com `Position`.

## Seleção de datas

Adicione **Date Edit** pelo editor ou use `Pane.Items.AddDateEdit`. A barra
mostra a data no formato regional. O botão do calendário, **F4** ou
**Alt+Seta para baixo** abre o calendário e **Delete** limpa o campo.
O campo começa vazio. Consulte `HasDate` antes de ler `Date` e use `Clear`
para limpar o valor por código. `ReadOnly` impede alterações pelo usuário.

## Fontes instaladas no Windows

**Font Name Combo Box** preenche sua lista automaticamente com as fontes
disponíveis por `Forms.Screen.Fonts`, em ordem alfabética e sem duplicatas.
Não é preciso editar `Items`. A propriedade `FontName` também oferece uma
lista de fontes no Object Inspector.
O item começa sem seleção; atribua `FontName` para escolher a fonte inicial.

`ShowFontPreview = True` mostra cada nome na própria fonte na lista aberta.
Use `False` para apresentar todos os nomes com a fonte normal da interface.
`DropDownCount` define quantas linhas ficam visíveis (12 por padrão).
O campo permite digitar um nome e usa o autocompletar nativo da LCL.

O `.lfm` grava `FontName`, e a lista é recriada ao carregar o formulário.
Isso evita selecionar outra fonte caso a ordem das fontes varie entre
computadores. Um nome indisponível continua visível no campo, sem ser incluído
na lista como fonte instalada; a aplicação decide como tratar essa situação.
`RefreshFonts` repopula as opções usando a lista de fontes fornecida pela LCL
e preserva a seleção. Para fontes instaladas depois de iniciar a aplicação,
reinicie-a para renovar também o cache de fontes da LCL.

## Hospedar outros controles

**Control Host** expõe o hospedeiro genérico que já existia no runtime. Coloque
um controle LCL no formulário e atribua-o à propriedade `Control` do item.
Configure valores e eventos no próprio controle. Isso permite, por exemplo,
hospedar um seletor de cores ou um editor de data compatível com a LCL.

O hospedeiro controla posição, tamanho, visibilidade e estado habilitado do
controle externo; a propriedade `Control` mantém a referência e o formulário
continua sendo seu proprietário. Para controles altos, use `DisplayMode = rimLarge`.

Nos itens nativos, `Control` é uma referência pública somente para leitura
ao controle interno, para configurações avançadas. O item é seu proprietário;
não o libere nem altere seu `Parent`. Ele não aparece como componente adicional
no `.lfm`.

## Aparência, teclado e exemplo

Os editores usam a aparência nativa do widgetset LCL; não há dependência do
DevExpress. Eles ocupam linhas normais do Ribbon. `KeyTip` transfere o foco para
Edit, Combo Box, Font Name Combo Box, Date Edit e Spin Edit. No Color Combo Box, o `KeyTip`
abre a paleta. Rótulos e barras de progresso não recebem foco.
Trocar de aba, ocultar o grupo ou recolher o Ribbon oculta os controles internos.

Abra `demos/runtime/project1.lpi` e selecione **Input controls**. O exemplo inclui
seleção de fonte e tamanho para a grade, busca de células, seleção de data e progresso atualizado
pelo botão **Advance**.

Consulte a [referência do Color Combo Box](LAZRIBBON_COMPONENT_REFERENCE.md#tlazribboncolorcomboboxitem)
para configurar a paleta de cores.
