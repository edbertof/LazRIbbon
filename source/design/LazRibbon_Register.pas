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

unit LazRibbon_Register;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, PropEdits, ComponentEditors, LazarusPackageIntf;

procedure Register;
procedure RegisterLazRibbonImageIndexEditors;
procedure RegisterLazRibbonColorComboMenuEditor;

implementation
uses
  ImgList, Controls, EditBtn, Graphics, Menus, GraphPropEdits, LResources, FormEditingIntf,
  LazRibbon_Core, LazRibbon_Editor, LazRibbon_Popup, LazRibbon_Buttons, LazRibbon_Checkboxes,
  LazRibbon_Groups, LazRibbon_Tabs, LazRibbon_Appearance, LazRibbon_Backstage, LazRibbon_SkinManager,
  LazRibbon_SkinSelector, LazRibbon_SkinManagerEditor, LazRibbon_RibbonExtItems, LazRibbon_Form,
  LazRibbon_BaseItem, LazRibbon_RibbonCommands, LazRibbon_ControlItems;

type
  TLazRibbonDatePropertyEditor = class(TDatePropertyEditor)
  public
    function GetValue: string; override;
    procedure SetValue(const Value: string); override;
  end;

function TLazRibbonDatePropertyEditor.GetValue: string;
var
  Value: TDateTime;
begin
  Value := TDateTime(GetFloatValue);
  if Value = NullDate then
    Result := ''
  else
    Result := DateToStr(Value);
end;

procedure TLazRibbonDatePropertyEditor.SetValue(const Value: string);
begin
  if Trim(Value) = '' then
    SetFloatValue(NullDate)
  else
    SetFloatValue(StrToDate(Value));
end;

procedure RegisterUnitLazRibbon;
begin
  RegisterComponents('LazRibbon', [TLazRibbon, TLazRibbonPopupMenu, TLazRibbonBackstageView, TLazRibbonBackstagePage, TLazRibbonBackstageRecentList, TLazRibbonSkinManager, TLazRibbonSkinSelector]);
end;

procedure RegisterUnitLazRibbonButtons;
begin
  RegisterNoIcon([TLazRibbonLargeButton, TLazRibbonSmallButton, TLazRibbonSeparator,
    TLazRibbonControlHostItem, TLazRibbonGalleryItem, TLazRibbonSkinGalleryItem,
    TLazRibbonEditItem, TLazRibbonComboBoxItem, TLazRibbonSpinEditItem,
    TLazRibbonStaticTextItem, TLazRibbonProgressBarItem, TLazRibbonFontNameComboBoxItem,
    TLazRibbonColorComboBoxItem, TLazRibbonDateEditItem]);
end;

procedure RegisterUnitLazRibbonCheckboxes;
begin
  RegisterNoIcon([TLazRibbonCheckbox, TLazRibbonRadioButton, TLazRibbonToggleSwitch]);
end;

procedure RegisterUnitLazRibbonGroups;
begin
  RegisterNoIcon([TLazRibbonPane]);
end;

procedure RegisterUnitLazRibbonTabs;
begin
  RegisterNoIcon([TLazRibbonTab]);
end;

procedure SkipObsoleteProperties;
const
  GROUPBEHAVIOUR_NOTE = 'GroupBehaviour is not needed.';
begin
  RegisterPropertyToSkip(TLazRibbonCheckbox, 'GroupBehaviour', GROUPBEHAVIOUR_NOTE, '');
  RegisterPropertyToSkip(TLazRibbonRadioButton, 'GroupBehaviour', GROUPBEHAVIOUR_NOTE, '');

  { TLazRibbonSeparator is structural. It participates in layout, but it is not
    a command surface and should not advertise command/screentip properties in
    the Object Inspector. }
  RegisterPropertyToSkip(TLazRibbonSeparator, 'Action',
    'Separators are structural items and do not execute actions.', '');
  RegisterPropertyToSkip(TLazRibbonSeparator, 'Caption',
    'Separators are structural items and do not display captions.', '');
  RegisterPropertyToSkip(TLazRibbonSeparator, 'Enabled',
    'Separators are structural items. Use Visible to include or hide them.', '');
  RegisterPropertyToSkip(TLazRibbonSeparator, 'Hint',
    'Separators are structural items and do not show hints.', '');
  RegisterPropertyToSkip(TLazRibbonSeparator, 'KeyTip',
    'Separators are structural items and do not participate in KeyTips.', '');
  RegisterPropertyToSkip(TLazRibbonSeparator, 'ShowScreenTip',
    'Separators are structural items and do not show ScreenTips.', '');
  RegisterPropertyToSkip(TLazRibbonSeparator, 'ScreenTipTitle',
    'Separators are structural items and do not show ScreenTips.', '');
  RegisterPropertyToSkip(TLazRibbonSeparator, 'ScreenTipText',
    'Separators are structural items and do not show ScreenTips.', '');
  RegisterPropertyToSkip(TLazRibbonSeparator, 'ScreenTipShortcut',
    'Separators are structural items and do not show ScreenTips.', '');
  RegisterPropertyToSkip(TLazRibbonSeparator, 'ScreenTipFooter',
    'Separators are structural items and do not show ScreenTips.', '');
  RegisterPropertyToSkip(TLazRibbonSeparator, 'OnClick',
    'Separators are structural items and do not execute click handlers.', '');

  { TLazRibbonBackstagePage is a content container. The navigation column is
    composed through TLazRibbonBackstageView.Buttons, where page, command and
    separator entries share one explicit model. }
  RegisterPropertyToSkip(TLazRibbonBackstagePage, 'Action',
    'BackStage pages are content containers. Use BackstageView.Buttons for commands.', '');
  RegisterPropertyToSkip(TLazRibbonBackstagePage, 'Command',
    'BackStage pages are content containers. Use BackstageView.Buttons for commands.', '');
  RegisterPropertyToSkip(TLazRibbonBackstagePage, 'CloseBackstageOnClick',
    'BackStage pages are content containers. Use BackstageView.Buttons for command close behavior.', '');
  RegisterPropertyToSkip(TLazRibbonBackstagePage, 'ItemKind',
    'BackStage pages are content containers. Use BackstageView.Buttons to create page, command and separator navigation items.', '');
  RegisterPropertyToSkip(TLazRibbonBackstagePage, 'OnExecute',
    'BackStage pages are content containers. Use BackstageView.Buttons.OnExecute for commands.', '');

  { TLazRibbonControlHostItem hosts a real control through Control. Caption is
    only the fallback placeholder text when no control is assigned; legacy
    ControlName/ControlClassName strings are kept only for old .lfm reading and
    source compatibility. }
  RegisterPropertyToSkip(TLazRibbonControlHostItem, 'ControlName',
    'Use Control to assign the hosted control. ControlName is legacy metadata.', '');
  RegisterPropertyToSkip(TLazRibbonControlHostItem, 'ControlClassName',
    'ControlClassName is legacy metadata and is not needed in new forms.', '');

  { TLazRibbonSkinGalleryItem is a compact Ribbon item. It should expose
    ShowHints, not a manually edited Hint nor the obsolete ShowCaptions. }
  RegisterPropertyToSkip(TLazRibbonSkinGalleryItem, 'Hint',
    'Hint is generated dynamically from ShowHints and the skin under the mouse.', '');
  RegisterPropertyToSkip(TLazRibbonSkinGalleryItem, 'ShowCaptions',
    'ShowCaptions was removed. Use ShowHints to show skin names as tooltips.', '');
  RegisterPropertyToSkip(TLazRibbonSkinGalleryItem, 'SelectedSkin',
    'SelectedSkin is a built-in-skin compatibility shortcut. Use SelectedSkinName instead.', '');
  RegisterPropertyToSkip(TLazRibbonSkinGalleryItem, 'ItemWidth',
    'ItemWidth is internal for skin galleries. Use IconWidth instead.', '');
  RegisterPropertyToSkip(TLazRibbonSkinGalleryItem, 'ItemHeight',
    'ItemHeight is internal for skin galleries. Use IconHeight instead.', '');

  { RegisterPropertyToSkip protects streaming, but in some Lazarus versions it
    does not remove inherited published properties from the Object Inspector.
    Registering a nil property editor is the reliable design-time way to hide
    these inherited generic size properties only for TLazRibbonSkinGalleryItem. }
  RegisterPropertyEditor(TypeInfo(Integer), TLazRibbonSkinGalleryItem, 'ItemWidth', nil);
  RegisterPropertyEditor(TypeInfo(Integer), TLazRibbonSkinGalleryItem, 'ItemHeight', nil);

  { TLazRibbonSkinSelector also uses IconWidth/IconHeight as the public size API.
    ItemWidth/ItemHeight are legacy aliases accepted only when reading old .lfm
    files by DefineProperties in LazRibbon_SkinSelector.pas. }
  RegisterPropertyToSkip(TLazRibbonSkinSelector, 'ItemWidth',
    'ItemWidth was removed. Use IconWidth instead.', '');
  RegisterPropertyToSkip(TLazRibbonSkinSelector, 'ItemHeight',
    'ItemHeight was removed. Use IconHeight instead.', '');
  RegisterPropertyEditor(TypeInfo(Integer), TLazRibbonSkinSelector, 'ItemWidth', nil);
  RegisterPropertyEditor(TypeInfo(Integer), TLazRibbonSkinSelector, 'ItemHeight', nil);
  RegisterPropertyToSkip(TLazRibbonSkinSelector, 'SelectedSkin',
    'SelectedSkin is a built-in-skin compatibility shortcut. Use SelectedSkinName instead.', '');

  { TLazRibbonSkinManager now exposes ActiveSkinName as the single Object
    Inspector selector because it can address both built-in and external skins.
    ActiveSkin remains public only for source compatibility with built-in skins. }
  RegisterPropertyToSkip(TLazRibbonSkinManager, 'ActiveSkin',
    'ActiveSkin is a built-in-skin compatibility shortcut. Use ActiveSkinName instead.', '');

  { RibbonAppearance remains part of the internal rendering model and is still
    streamed from old forms, but new design-time work should be skin based. }
  RegisterPropertyToSkip(TLazRibbon, 'RibbonAppearance',
    'RibbonAppearance is internal rendering state. Use SkinManager and TLazRibbonSkinManager skins instead.', '');
  RegisterPropertyEditor(TypeInfo(TLazRibbonToolbarAppearance), TLazRibbon,
    'RibbonAppearance', nil);

end;

procedure RegisterLazRibbonImageIndexEditors;
begin
  { Restrict registrations by property name: several Ribbon properties use
    plain Integer rather than the distinct TImageIndex type. Register on the
    base item as well so custom button descendants inherit the editor. }
  RegisterPropertyEditor(TypeInfo(TImageIndex), TLazRibbonBaseItem, 'ImageIndex',
    TLazRibbonImageIndexPropertyEditor);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TLazRibbonBaseItem, 'LargeImageIndex',
    TLazRibbonImageIndexPropertyEditor);
  RegisterPropertyEditor(TypeInfo(Integer), TLazRibbonBaseItem, 'ImageIndex',
    TLazRibbonImageIndexPropertyEditor);
  RegisterPropertyEditor(TypeInfo(Integer), TLazRibbonBaseItem, 'LargeImageIndex',
    TLazRibbonImageIndexPropertyEditor);
  RegisterPropertyEditor(TypeInfo(Integer), TLazRibbonApplicationButton, 'ImageIndex',
    TLazRibbonImageIndexPropertyEditor);
  RegisterPropertyEditor(TypeInfo(Integer), TLazRibbonQuickAccessItem, 'ImageIndex',
    TLazRibbonImageIndexPropertyEditor);
  RegisterPropertyEditor(TypeInfo(Integer), TLazRibbonBackstageButton, 'ImageIndex',
    TLazRibbonImageIndexPropertyEditor);
  RegisterPropertyEditor(TypeInfo(Integer), TLazRibbonBackstageButton, 'LargeImageIndex',
    TLazRibbonImageIndexPropertyEditor);
  RegisterPropertyEditor(TypeInfo(Integer), TLazRibbonBackstagePage, 'ImageIndex',
    TLazRibbonImageIndexPropertyEditor);
  RegisterPropertyEditor(TypeInfo(Integer), TLazRibbonBackstageRecentList, 'ImageIndex',
    TLazRibbonImageIndexPropertyEditor);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TLazRibbonCommand, 'ImageIndex',
    TLazRibbonImageIndexPropertyEditor);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TLazRibbonPopupEntry, 'ImageIndex',
    TLazRibbonImageIndexPropertyEditor);
end;

procedure RegisterLazRibbonColorComboMenuEditor;
begin
  RegisterPropertyEditor(TypeInfo(TPopupMenu), TLazRibbonColorComboBoxItem,
    'DropdownMenu', TLazRibbonColorComboMenuEditor);
end;

procedure Register;
begin
  { Do not call RegisterUnit for units that belong to LazRibbonRuntime.
    Lazarus requires RegisterUnit names to be units included in this design-time
    package .lpk. Runtime units are available through the package dependency,
    but they are not files of LazRibbonDesign itself. Register directly here. }
  RegisterUnitLazRibbon;
  RegisterUnitLazRibbonButtons;
  RegisterUnitLazRibbonCheckboxes;
  RegisterUnitLazRibbonGroups;
  RegisterUnitLazRibbonTabs;
  { TLazRibbonForm creates TLazRibbonTitleBar internally in its constructor.
    When TLazRibbonForm is registered as a designer base class, the Lazarus
    form designer must also know the internal title-bar class; otherwise it may
    stop loading inherited/custom-form descendants with: "Unable to find the
    component class TLazRibbonTitleBar".  The class is registered only for
    streaming/designer support; it is not placed on the component palette. }
  Classes.RegisterClass(TLazRibbonTitleBar);
  Classes.RegisterClass(TLazRibbonForm);
  { Make TLazRibbonForm a real designer base class. Without this, Lazarus can
    open unit1.lfm as text instead of showing the visual designer for forms
    declared as class(TLazRibbonForm). }
  FormEditingHook.RegisterDesignerBaseClass(TLazRibbonForm);

  RegisterComponentEditor(TLazRibbon, TLazRibbonEditor);
  RegisterComponentEditor(TLazRibbonBackstageView, TLazRibbonBackstageViewEditor);
  RegisterComponentEditor(TLazRibbonSkinManager, TLazRibbonSkinManagerEditor);
  RegisterPropertyEditor(TypeInfo(string), TLazRibbonTab, 'Caption',
    TLazRibbonCaptionEditor);
  RegisterPropertyEditor(TypeInfo(string), TLazRibbonPane, 'Caption',
    TLazRibbonCaptionEditor);
  RegisterPropertyEditor(TypeInfo(string), TLazRibbonBaseButton, 'Caption',
    TLazRibbonCaptionEditor);
  RegisterPropertyEditor(TypeInfo(TCaption), TLazRibbonCustomRibbonExtItem,
    'Caption', TLazRibbonCaptionEditor);
  RegisterPropertyEditor(TypeInfo(TCaption), TLazRibbonCustomControlItem,
    'Caption', TLazRibbonCaptionEditor);
  RegisterPropertyEditor(TypeInfo(TFontName), TLazRibbonFontNameComboBoxItem,
    'FontName', TFontNamePropertyEditor);
  RegisterLazRibbonImageIndexEditors;
  RegisterLazRibbonColorComboMenuEditor;
  RegisterPropertyEditor(TypeInfo(TDateTime), TLazRibbonDateEditItem, 'Date',
    TLazRibbonDatePropertyEditor);
  SkipObsoleteProperties;
end;

initialization
  {$I icons/TLazRibbon.lrs}
  {$I icons/TLazRibbonPopupMenu.lrs}
  {$I icons/TLazRibbonBackstageView.lrs}
  {$I icons/TLazRibbonBackstagePage.lrs}
  {$I icons/TLazRibbonBackstageRecentList.lrs}
  {$I icons/TLazRibbonSkinManager.lrs}
  {$I icons/TLazRibbonSkinSelector.lrs}

end.
