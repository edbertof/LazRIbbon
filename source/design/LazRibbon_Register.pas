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

implementation
uses
  ImgList, Controls, LResources, FormEditingIntf,
  LazRibbon_Core, LazRibbon_Editor, LazRibbon_Popup, LazRibbon_Buttons, LazRibbon_Checkboxes,
  LazRibbon_Groups, LazRibbon_Tabs, LazRibbon_Appearance, LazRibbon_Backstage, LazRibbon_SkinManager,
  LazRibbon_SkinSelector, LazRibbon_SkinManagerEditor, LazRibbon_RibbonExtItems, LazRibbon_Form;

procedure RegisterUnitLazRibbon;
begin
  RegisterComponents('LazRibbon', [TLazRibbon, TLazRibbonPopupMenu, TLazRibbonBackstageView, TLazRibbonBackstagePage, TLazRibbonBackstageRecentList, TLazRibbonSkinManager, TLazRibbonSkinSelector]);
end;

procedure RegisterUnitLazRibbonButtons;
begin
  RegisterNoIcon([TLazRibbonLargeButton, TLazRibbonSmallButton, TLazRibbonSeparator,
    TLazRibbonControlHostItem, TLazRibbonGalleryItem, TLazRibbonSkinGalleryItem]);
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
  RegisterPropertyToSkip(TLazRibbonCheckbox, 'Groupbehaviour', GROUPBEHAVIOUR_NOTE, '');
  RegisterPropertyToSkip(TLazRibbonRadioButton, 'GroupBehaviour', GROUPBEHAVIOUR_NOTE, '');

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
  RegisterComponentEditor(TLazRibbonSkinManager, TLazRibbonSkinManagerEditor);
  RegisterPropertyEditor(TypeInfo(string), TLazRibbonTab, 'Caption',
    TLazRibbonCaptionEditor);
  RegisterPropertyEditor(TypeInfo(string), TLazRibbonPane, 'Caption',
    TLazRibbonCaptionEditor);
  RegisterPropertyEditor(TypeInfo(string), TLazRibbonBaseButton, 'Caption',
    TLazRibbonCaptionEditor);
  RegisterPropertyEditor(TypeInfo(TCaption), TLazRibbonCustomRibbonExtItem,
    'Caption', TLazRibbonCaptionEditor);
  RegisterPropertyEditor(TypeInfo(TLazRibbonToolbarAppearance), TLazRibbon,
    'RibbonAppearance', TLazRibbonToolbarAppearanceEditor);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TLazRibbonLargeButton, '',
    TLazRibbonImageIndexPropertyEditor);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TLazRibbonSmallButton, '',
    TLazRibbonImageIndexPropertyEditor);

  //todo: register Caption Editor

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
