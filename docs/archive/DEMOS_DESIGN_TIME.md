# Demos em design-time

A partir da versão 0.1.32, os demos novos/refinados deixam de montar a interface inteira em `FormCreate`.

Os principais componentes ficam no arquivo `.lfm`, permitindo inspeção e edição no Object Inspector do Lazarus:

- `demos/application_button`
- `demos/popup_menu`
- `demos/skins_gallery`
- `demos/backstage`
- `demos/backstage_recent_files`

O código Pascal desses demos fica restrito a eventos e ações, como `OnExecute`, `OnClick` e `OnItemClick`.

Essa decisão facilita ver quais propriedades foram usadas em cada exemplo e evita que o demo esconda a configuração real do componente em código de criação dinâmica.
