# LazRibbon 0.2.0

Marco de consolidação do fork independente baseado no LazToolbar. Esta versão não adiciona um grande recurso visual novo; ela organiza a base para os próximos marcos: `TLazRibbonForm`, SkinEditor e design-time avançado.

Consulte também:

- `CHANGES_0_2_0.txt`
- `REGRESSION_CHECKLIST_0_2_0.md`
- `ACTION_LINKEDITEM_MODEL_0_2_0.md`
- `ROADMAP_0_2_0.md`

---

# LazRibbon 0.1.0 — fork independente do LazToolbar

Este pacote é a primeira refatoração mecânica do pacote baseado em `LazToolbar` para um novo pacote Lazarus independente chamado **LazRibbon**.

## Objetivo desta versão

Permitir que o `LazRibbon` e o `LazToolbarPackage` original possam coexistir instalados no Lazarus 4.6, evitando colisões de nomes de units, arquivos e classes públicas principais.

## Pacotes

Instale nesta ordem:

1. `packages/LazRibbonRuntime.lpk`
2. `packages/LazRibbonDesign.lpk`

A aba de componentes registrada no IDE passa a ser `LazRibbon`.

## O que foi alterado

- Separação inicial em pacote runtime e design-time.
- Units antigas `LazToolbar`, `lazt_*`, `LazPopup`, `LazMath`, `LazGUITools`, `LazGraphTools` e `LazXML*` foram renomeadas para `LazRibbon_*`.
- Classes `TLaz*` foram renomeadas para `TLazRibbon*`; a classe principal `TLazToolbar` virou `TLazRibbon`.
- Registro de componentes movido para `LazRibbon_Register.pas`.
- Ícones `.lrs` principais foram atualizados para os novos nomes das classes.
- Demos e SkinEditor foram limpos de artefatos compilados e atualizados para o novo pacote.

## Limitação importante

Esta é uma refatoração de base. Ela ainda não foi compilada neste ambiente porque não há Lazarus/FPC instalados aqui. O próximo passo deve ser abrir o Lazarus 4.6, compilar primeiro `LazRibbonRuntime` e, só depois, `LazRibbonDesign`.

## Teste correto

O teste decisivo é manter o `LazToolbarPackage` original instalado e compilar/instalar também o `LazRibbonRuntime` + `LazRibbonDesign`. Se houver colisão de unit ou classe, ainda existe algum identificador antigo a ser eliminado.

## Preservação de autoria/licença

Como parte do código deriva do `LazToolbar`, os créditos e termos de licença originais devem ser preservados nos arquivos derivados.

## Observação sobre demos

O demo `backstage` original estava incompleto no ZIP recebido, por isso não foi incluído nesta primeira refatoração.


## Uso rápido do BackStage (0.1.21)

A partir da versão 0.1.18, o `TLazRibbon` possui a propriedade; na 0.1.21 o BackStage usa botão circular de retorno, fecha com Esc e não precisa repetir o rótulo `Arquivo` no cabeçalho:

```pascal
LazRibbon1.BackstageView := LazRibbonBackstageView1;
```

Ao atribuir essa propriedade, o Ribbon mostra o botão `Arquivo`, liga o clique ao BackStage e repassa o `SkinManager` do Ribbon quando houver. Isso substitui o padrão antigo baseado em `OnMenuButtonClick` manual para o caso mais comum.

Demos úteis:

```text
demos/popup_menu
demos/skins_gallery
demos/backstage
```


## BackStage com navegação refinada (0.1.22)

A versão 0.1.22 refinou a coluna lateral do `TLazRibbonBackstageView`:

- páginas aparecem como itens principais de navegação;
- comandos diretos têm desenho mais discreto;
- separadores podem organizar grupos de comandos;
- comandos podem ser posicionados na seção inferior usando `Section := bbsBottom`.

Uso recomendado:

```pascal
LazRibbon1.BackstageView := LazRibbonBackstageView1;
LazRibbonBackstageView1.Buttons.Add.Kind := bbkPage;
```

Para um exemplo mais completo, veja:

```text
demos/backstage/project1.lpi
```

## Correção 0.1.25

O demo `demos/backstage_recent_files` foi corrigido para usar `sbsCaramel` como skin inicial. A versão anterior fazia referência a `sbsOfficeBeige`, identificador que não existe no enum `TLazRibbonBuiltInSkin`.


## ApplicationButton (0.1.27)

A versão 0.1.27 introduziu uma API mais clara para o botão **Arquivo**, tratado agora como `ApplicationButton`:

```pascal
LazRibbon1.ApplicationButtonCaption := 'Arquivo';
LazRibbon1.ApplicationButtonVisible := True;
LazRibbon1.ApplicationButtonMode := abmBackstage;
LazRibbon1.BackstageView := LazRibbonBackstageView1;
```

Modos disponíveis:

```pascal
abmEvent      // dispara OnApplicationButtonClick
abmPopupMenu  // abre ApplicationMenu
abmBackstage  // abre/fecha BackStage vinculado
```

As propriedades antigas `MenuButtonCaption`, `ShowMenuButton`, `MenuButtonDropdownMenu`, `MenuButtonStyle` e `OnMenuButtonClick` continuam existindo por compatibilidade, mas para novos projetos prefira `ApplicationButton*`.

Novo demo:

```text
demos/application_button
```


## BackStage: fechamento ao selecionar outra aba (0.1.28)

A partir da versão 0.1.28, o `TLazRibbonBackstageView` fecha automaticamente quando o usuário seleciona outra aba real do Ribbon. Esse comportamento segue o padrão esperado do Office/DevExpress: o botão **Arquivo** abre o BackStage; clicar em uma aba como **Início** ou **Editar** fecha o BackStage e ativa a aba escolhida.

A propriedade pode ser controlada por:

```pascal
LazRibbonBackstageView1.CloseOnRibbonTabClick := True;
```

O valor padrão é `True`.
