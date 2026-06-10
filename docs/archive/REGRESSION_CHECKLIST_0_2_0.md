# LazRibbon 0.2.0 — Checklist de regressão

Execute estes testes sempre que alterar o pacote. A regra é simples: compilar não basta; é necessário testar instalação, design-time, streaming `.lfm` e execução.

## 1. Pacotes

1. Apagar a pasta `lib/`.
2. Compilar `packages/LazRibbonRuntime.lpk`.
3. Compilar `packages/LazRibbonDesign.lpk`.
4. Instalar `LazRibbonDesign.lpk`.
5. Reiniciar o Lazarus.

Resultado esperado: a IDE abre sem erro e a aba `LazRibbon` aparece.

## 2. Coexistência com LazToolbar

1. Manter `LazToolbarPackage` original instalado.
2. Criar projeto novo.
3. Inserir `TLazToolbar` e `TLazRibbon` no mesmo formulário.
4. Salvar, fechar, reabrir e compilar.

Resultado esperado: nenhum conflito de unit, classe ou `.lfm`.

## 3. Demo basic

Abrir `demos/basic/project1.lpi`.

Verificar:

- abertura do formulário no designer;
- compilação;
- execução;
- panes com gradiente correto;
- botões grandes e pequenos visíveis.

## 4. Demo skins_gallery

Abrir `demos/skins_gallery/project1.lpi`.

Verificar:

- `TLazRibbonSkinGalleryItem` herda `SkinManager` do Ribbon quando apropriado;
- troca entre skin claro e escuro;
- panes continuam coerentes;
- botões de navegação da galeria funcionam.

## 5. Demo backstage_recent_files

Abrir `demos/backstage_recent_files/project1.lpi`.

Verificar:

- botão `Arquivo` abre/fecha BackStage;
- `Esc` fecha BackStage;
- clicar em outra aba fecha BackStage;
- lista de recentes rola quando há muitos itens;
- lista salva/carrega em `.ini`;
- botões de rodapé aparecem corretamente.

## 6. Demo quick_access_toolbar

Abrir `demos/quick_access_toolbar/project1.lpi`.

Verificar:

- QAT aparece no Object Inspector como subobjeto;
- `CustomizeActionList` funciona como catálogo de ações;
- menu da QAT marca/desmarca ações;
- configuração é salva/carregada em `.ini`;
- `LinkedItem` preserva comportamento DropDown;
- item `Modo Toque/Mouse` abre menu;
- fechar o programa não gera `Access violation`.

## 7. ApplicationButton

Abrir `demos/application_button/project1.lpi`.

Verificar:

- `ApplicationButton` aparece como subobjeto;
- modo BackStage funciona;
- modo PopupMenu funciona;
- modo evento simples funciona.

## 8. Botões do canto direito

Verificar em qualquer demo com Ribbon completo:

- botão minimizar/restaurar Ribbon;
- botão ajuda;
- hints;
- estados hover/pressed.

## 9. Streaming `.lfm`

Para cada demo principal:

1. abrir no designer;
2. salvar;
3. fechar o Lazarus;
4. reabrir;
5. compilar.

Resultado esperado: nenhum erro de classe não encontrada, propriedade inválida ou resíduo `TLaz...` indevido.
