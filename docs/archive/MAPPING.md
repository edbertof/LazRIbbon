# Mapeamento inicial LazToolbar -> LazRibbon

- Unit `RegisterLazToolbar` -> `LazRibbon_Register`
- Unit `LazGUITools` -> `LazRibbon_GUITools`
- Unit `LazGraphTools` -> `LazRibbon_GraphTools`
- Unit `LazMath` -> `LazRibbon_Math`
- Unit `LazPopup` -> `LazRibbon_Popup`
- Unit `LazToolbar` -> `LazRibbon_Core`
- Unit `LazToolbarEditor` -> `LazRibbon_Editor`
- Unit `LazToolbarPackage` -> `LazRibbonRuntime`
- Unit `LazXMLIni` -> `LazRibbon_XMLIni`
- Unit `LazXMLParser` -> `LazRibbon_XMLParser`
- Unit `LazXMLTools` -> `LazRibbon_XMLTools`
- Unit `lazt_Appearance` -> `LazRibbon_Appearance`
- Unit `lazt_Backstage` -> `LazRibbon_Backstage`
- Unit `lazt_BaseItem` -> `LazRibbon_BaseItem`
- Unit `lazt_Buttons` -> `LazRibbon_Buttons`
- Unit `lazt_Checkboxes` -> `LazRibbon_Checkboxes`
- Unit `lazt_Const` -> `LazRibbon_Const`
- Unit `lazt_Dispatch` -> `LazRibbon_Dispatch`
- Unit `lazt_Exceptions` -> `LazRibbon_Exceptions`
- Unit `lazt_Items` -> `LazRibbon_Items`
- Unit `lazt_Pane` -> `LazRibbon_Groups`
- Unit `lazt_RibbonCommands` -> `LazRibbon_RibbonCommands`
- Unit `lazt_RibbonExtItems` -> `LazRibbon_RibbonExtItems`
- Unit `lazt_SkinDefinition` -> `LazRibbon_SkinDefinition`
- Unit `lazt_SkinManager` -> `LazRibbon_SkinManager`
- Unit `lazt_SkinSelector` -> `LazRibbon_SkinSelector`
- Unit `lazt_SkinSelectorItem` -> `LazRibbon_SkinSelectorItem`
- Unit `lazt_Tab` -> `LazRibbon_Tabs`
- Unit `lazt_Tools` -> `LazRibbon_Tools`
- Unit `lazt_Types` -> `LazRibbon_Types`
- Unit `lazte_AppearanceEditor` -> `LazRibbon_AppearanceEditor`
- Unit `lazte_EditWindow` -> `LazRibbon_EditWindow`
- Unit `lazte_SkinManagerEditor` -> `LazRibbon_SkinManagerEditor`

- Classe principal `TLazToolbar` -> `TLazRibbon`
- Demais classes `TLaz*` -> `TLazRibbon*`

## Classes públicas ajustadas

- `TLazRibbonSkinGalleryItem` -> `TLazRibbonSkinGalleryItem`
- `TLazRibbonGalleryItem` -> `TLazRibbonGalleryItem`
- `TLazRibbonControlHostItem` -> `TLazRibbonControlHostItem`
- `TLazRibbonCommand` -> `TLazRibbonCommand`
