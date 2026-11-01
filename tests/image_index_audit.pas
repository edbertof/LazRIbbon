unit image_index_audit;

{$mode objfpc}{$H+}

interface

procedure RunImageIndexAudit;

implementation

uses
  Classes, SysUtils, TypInfo, Forms, Controls, Graphics, ImgList, ActnList, PropEdits,
  LazRibbon_Core, LazRibbon_Tabs, LazRibbon_Groups, LazRibbon_Buttons,
  LazRibbon_RibbonExtItems, LazRibbon_Backstage, LazRibbon_RibbonCommands,
  LazRibbon_Register, LazRibbon_Editor;

type
  TImageEditorAccess = class(TLazRibbonImageIndexPropertyEditor);
  TCustomLargeButton = class(TLazRibbonCustomLargeButton)
  published
    property LargeImageIndex;
  end;

  TImageIndexAudit = class
    Values: TStringList;
    Checks: Integer;
    procedure AddValue(const AValue: string);
    procedure Check(AInstance: TPersistent; const AProperty: string;
      AImages: TCustomImageList);
  end;

procedure TImageIndexAudit.AddValue(const AValue: string);
begin
  Values.Add(AValue);
end;

procedure TImageIndexAudit.Check(AInstance: TPersistent;
  const AProperty: string; AImages: TCustomImageList);
var
  Info: PPropInfo;
  EditorClass: TPropertyEditorClass;
  Editor: TPropertyEditor;
  ExpectedCount, I: Integer;
  Context: string;
begin
  Context := AInstance.ClassName + '.' + AProperty;
  Info := GetPropInfo(AInstance, AProperty);
  if Info = nil then
    raise Exception.Create(Context + ': missing property');
  EditorClass := GetEditorClass(Info, AInstance);
  if EditorClass <> TLazRibbonImageIndexPropertyEditor then
    raise Exception.Create(Context + ': wrong registered editor');
  Editor := EditorClass.Create(nil, 1);
  try
    Editor.SetPropEntry(0, AInstance, Info);
    if TImageEditorAccess(Editor).GetImageList <> AImages then
      raise Exception.Create(Context + ': wrong image list');
    if not ([paValueList, paCustomDrawn] <= Editor.GetAttributes) then
      raise Exception.Create(Context + ': missing preview/dropdown attributes');
    Values.Clear;
    Editor.GetValues(@AddValue);
    ExpectedCount := 0;
    if AImages <> nil then
      ExpectedCount := AImages.Count;
    if (Values.Count <> ExpectedCount + 1) or (Values[0] <> '-1') then
      raise Exception.Create(Context + ': wrong dropdown size or missing -1');
    for I := 0 to ExpectedCount - 1 do
      if Values[I + 1] <> IntToStr(I) then
        raise Exception.Create(Context + ': missing image index');
    Inc(Checks);
  finally
    Editor.Free;
  end;
end;

function MakeImages(AOwner: TComponent; ASize, ACount: Integer): TImageList;
var
  Bitmap: TBitmap;
  I: Integer;
begin
  Result := TImageList.Create(AOwner);
  Result.Width := ASize;
  Result.Height := ASize;
  Bitmap := TBitmap.Create;
  try
    Bitmap.SetSize(ASize, ASize);
    for I := 1 to ACount do
      Result.Add(Bitmap, nil);
  finally
    Bitmap.Free;
  end;
end;

procedure RunImageIndexAudit;
var
  Host: TForm;
  Audit: TImageIndexAudit;
  Ribbon: TLazRibbon;
  Pane: TLazRibbonPane;
  Small: TLazRibbonSmallButton;
  Large: TLazRibbonLargeButton;
  CustomLarge: TCustomLargeButton;
  Gallery: TLazRibbonGalleryItem;
  ControlHost: TLazRibbonControlHostItem;
  SkinGallery: TLazRibbonSkinGalleryItem;
  View: TLazRibbonBackstageView;
  Page: TLazRibbonBackstagePage;
  NavButton: TLazRibbonBackstageButton;
  Recent: TLazRibbonBackstageRecentList;
  Quick: TLazRibbonQuickAccessItem;
  Commands: TLazRibbonCommandList;
  Command: TLazRibbonCommand;
  Actions: TActionList;
  Action: TAction;
  SmallImages, LargeImages, OtherImages: TImageList;
begin
  RegisterLazRibbonImageIndexEditors;
  Host := TForm.CreateNew(nil);
  Audit := TImageIndexAudit.Create;
  Audit.Values := TStringList.Create;
  try
    SmallImages := MakeImages(Host, 16, 2);
    LargeImages := MakeImages(Host, 32, 4);
    OtherImages := MakeImages(Host, 24, 3);
    Ribbon := TLazRibbon.Create(Host);
    Ribbon.Images := SmallImages;
    Ribbon.LargeImages := LargeImages;
    Pane := Ribbon.Tabs.Add.Panes.Add;
    Small := Pane.Items.AddSmallButton;
    Large := Pane.Items.AddLargeButton;
    CustomLarge := TCustomLargeButton.Create(Host);
    Pane.Items.AddItem(CustomLarge);
    Gallery := Pane.Items.AddRibbonGalleryItem;
    ControlHost := Pane.Items.AddRibbonControlHostItem;
    SkinGallery := Pane.Items.AddRibbonSkinGalleryItem;
    Audit.Check(Small, 'ImageIndex', SmallImages);
    Audit.Check(Large, 'LargeImageIndex', LargeImages);
    Audit.Check(CustomLarge, 'LargeImageIndex', LargeImages);
    Audit.Check(Gallery, 'ImageIndex', SmallImages);
    Audit.Check(Gallery, 'LargeImageIndex', LargeImages);
    Audit.Check(ControlHost, 'ImageIndex', SmallImages);
    Audit.Check(ControlHost, 'LargeImageIndex', LargeImages);
    Audit.Check(SkinGallery, 'ImageIndex', SmallImages);
    Audit.Check(SkinGallery, 'LargeImageIndex', LargeImages);
    Audit.Check(Ribbon.ApplicationButton, 'ImageIndex', SmallImages);
    Quick := Ribbon.QuickAccessToolBar.Items.Add;
    Audit.Check(Quick, 'ImageIndex', SmallImages);
    Ribbon.QuickAccessToolBar.Images := OtherImages;
    Audit.Check(Quick, 'ImageIndex', OtherImages);

    View := TLazRibbonBackstageView.Create(Host);
    View.Parent := Host;
    View.Images := OtherImages;
    View.LargeImages := LargeImages;
    Page := View.AddPage('Images');
    NavButton := View.Buttons.AddPage(Page);
    Audit.Check(NavButton, 'ImageIndex', OtherImages);
    Audit.Check(NavButton, 'LargeImageIndex', LargeImages);
    Audit.Check(Page, 'ImageIndex', OtherImages);
    Recent := TLazRibbonBackstageRecentList.Create(Host);
    Recent.Parent := Page;
    Recent.Images := SmallImages;
    Audit.Check(Recent, 'ImageIndex', SmallImages);
    Recent.Images := nil;
    Audit.Check(Recent, 'ImageIndex', nil);

    Commands := TLazRibbonCommandList.Create(Host);
    Commands.Images := OtherImages;
    Command := Commands.AddCommand('TestCommand', 'Test');
    Audit.Check(Command, 'ImageIndex', OtherImages);

    Actions := TActionList.Create(Host);
    Actions.Images := OtherImages;
    Action := TAction.Create(Host);
    Action.ActionList := Actions;
    Action.ImageIndex := 0;
    Small.Action := Action;
    Large.Action := Action;
    CustomLarge.Action := Action;
    Audit.Check(Small, 'ImageIndex', SmallImages);
    Audit.Check(Large, 'LargeImageIndex', LargeImages);
    Ribbon.Images := nil;
    Ribbon.LargeImages := nil;
    Audit.Check(Small, 'ImageIndex', OtherImages);
    Audit.Check(Large, 'LargeImageIndex', OtherImages);
    Audit.Check(CustomLarge, 'LargeImageIndex', OtherImages);
    Audit.Check(Gallery, 'ImageIndex', nil);
    Audit.Check(Gallery, 'LargeImageIndex', nil);
    Actions.Images := nil;
    Audit.Check(Small, 'ImageIndex', nil);
    Audit.Check(Large, 'LargeImageIndex', nil);
    View.Images := nil;
    View.LargeImages := nil;
    Audit.Check(NavButton, 'ImageIndex', nil);
    Audit.Check(NavButton, 'LargeImageIndex', nil);
    Audit.Check(Page, 'ImageIndex', nil);
    Audit.Check(Ribbon.ApplicationButton, 'ImageIndex', nil);
    Ribbon.QuickAccessToolBar.Images := nil;
    Audit.Check(Quick, 'ImageIndex', nil);
    Commands.Images := nil;
    Audit.Check(Command, 'ImageIndex', nil);
    WriteLn('Image-index editors: ', Audit.Checks, ' checks, 0 failures');
  finally
    Host.Free;
    Audit.Values.Free;
    Audit.Free;
  end;
end;

end.
