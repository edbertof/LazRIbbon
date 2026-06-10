# Demos no LazRibbon 0.2.0

Os demos devem ser mantidos preferencialmente com interface em `.lfm`, não construída integralmente em tempo de execução.

## Demos principais

- `demos/basic`
- `demos/popup_menu`
- `demos/skins_gallery`
- `demos/skin_selector`
- `demos/backstage`
- `demos/backstage_recent_files`
- `demos/application_button`
- `demos/quick_access_toolbar`

## Critério para novos demos

Um demo deve testar um recurso isolado. Evite um único projeto grande que teste tudo.

## Regra de design-time

Componentes visuais devem estar no `.lfm`. O `.pas` deve conter apenas eventos, Actions e inicializações necessárias, como carregar/salvar `.ini`.

## Demos prioritários para regressão

1. `quick_access_toolbar`
2. `backstage_recent_files`
3. `skins_gallery`
4. `application_button`
