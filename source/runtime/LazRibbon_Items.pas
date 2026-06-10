unit LazRibbon_Items;

{$mode delphi}
{.$Define EnhancedRecordSupport}

(*******************************************************************************
*                                                                              *
*  File:        LazRibbon_Items.pas                                                 *
*  Description: The module contains the class of panel elements collection.    *
*  Copyright:   (c) 2009 by Spook.                                             *
*  License:     Modified LGPL (with linking exception, like Lazarus LCL)       *
*               See "license.txt" in this installation                         *
*                                                                              *
*******************************************************************************)

interface

uses
  Classes, Controls, SysUtils, Dialogs,
  LazRibbon_Appearance, LazRibbon_Dispatch, LazRibbon_BaseItem, LazRibbon_Types,
  LazRibbon_Buttons, LazRibbon_Checkboxes, LazRibbon_RibbonExtItems;

type
  TLazRibbonItems = class(TLazRibbonCollection)
  private
    FToolbarDispatch: TLazRibbonBaseToolbarDispatch;
    FAppearance: TLazRibbonToolbarAppearance;
    FImages: TImageList;
    FDisabledImages: TImageList;
    FLargeImages: TImageList;
    FDisabledLargeImages: TImageList;
    FImagesWidth: Integer;
    FLargeImagesWidth: Integer;

    // *** Getters and setters ***
    procedure SetToolbarDispatch(const Value: TLazRibbonBaseToolbarDispatch);
    function GetItems(AIndex: integer): TLazRibbonBaseItem; reintroduce;
    procedure SetAppearance(const Value: TLazRibbonToolbarAppearance);
    procedure SetImages(const Value: TImageList);
    procedure SetDisabledImages(const Value: TImageList);
    procedure SetLargeImages(const Value: TImageList);
    procedure SetDisabledLargeImages(const Value: TImageList);
    procedure SetImagesWidth(const Value: Integer);
    procedure SetLargeImagesWidth(const Value: Integer);

  public
    function AddLargeButton: TLazRibbonLargeButton;
    function AddSmallButton: TLazRibbonSmallButton;
    function AddCheckbox: TLazRibbonCheckbox;
    function AddRadioButton: TLazRibbonRadioButton;
    function AddRibbonControlHostItem: TLazRibbonControlHostItem;
    function AddRibbonGalleryItem: TLazRibbonGalleryItem;
    function AddRibbonSkinGalleryItem: TLazRibbonSkinGalleryItem;

    // *** Reaction to changes in the list ***
    procedure Notify(Item: TComponent; Operation: TOperation); override;
    procedure Update; override;

    property Items[index: integer]: TLazRibbonBaseItem read GetItems; default;
    property ToolbarDispatch: TLazRibbonBaseToolbarDispatch read FToolbarDispatch write SetToolbarDispatch;
    property Appearance: TLazRibbonToolbarAppearance read FAppearance write SetAppearance;
    property Images: TImageList read FImages write SetImages;
    property DisabledImages: TImageList read FDisabledImages write SetDisabledImages;
    property LargeImages: TImageList read FLargeImages write SetLargeImages;
    property DisabledLargeImages: TImageList read FDisabledLargeImages write SetDisabledLargeImages;
    property ImagesWidth: Integer read FImagesWidth write SetImagesWidth;
    property LargeImagesWidth: Integer read FLargeImagesWidth write SetLargeImagesWidth;
  end;

implementation

{ TLazRibbonItems }

function TLazRibbonItems.AddLargeButton: TLazRibbonLargeButton;
begin
  Result := TLazRibbonLargeButton.Create(FRootComponent);
  Result.Parent := FRootComponent;
  AddItem(Result);
end;

function TLazRibbonItems.AddSmallButton: TLazRibbonSmallButton;
begin
  Result := TLazRibbonSmallButton.Create(FRootComponent);
  Result.Parent := FRootComponent;
  AddItem(Result);
end;

function TLazRibbonItems.AddCheckbox: TLazRibbonCheckbox;
begin
  Result := TLazRibbonCheckbox.Create(FRootComponent);
  Result.Parent := FRootComponent;
  AddItem(Result);
end;

function TLazRibbonItems.AddRadioButton: TLazRibbonRadioButton;
begin
  Result := TLazRibbonRadioButton.Create(FRootComponent);
  Result.Parent := FRootComponent;
  AddItem(Result);
end;


function TLazRibbonItems.AddRibbonControlHostItem: TLazRibbonControlHostItem;
begin
  Result := TLazRibbonControlHostItem.Create(FRootComponent);
  Result.Parent := FRootComponent;
  AddItem(Result);
end;

function TLazRibbonItems.AddRibbonGalleryItem: TLazRibbonGalleryItem;
begin
  Result := TLazRibbonGalleryItem.Create(FRootComponent);
  Result.Parent := FRootComponent;
  AddItem(Result);
end;

function TLazRibbonItems.AddRibbonSkinGalleryItem: TLazRibbonSkinGalleryItem;
begin
  Result := TLazRibbonSkinGalleryItem.Create(FRootComponent);
  Result.Parent := FRootComponent;
  AddItem(Result);
end;

function TLazRibbonItems.GetItems(AIndex: integer): TLazRibbonBaseItem;
begin
  Result := TLazRibbonBaseItem(inherited Items[AIndex]);
end;

procedure TLazRibbonItems.Notify(Item: TComponent; Operation: TOperation);
var
  i: Integer;
  baseItem: TLazRibbonBaseItem;
begin
  inherited Notify(Item, Operation);

  case Operation of
    opInsert:
      if Item is TLazRibbonBaseItem then
      begin
        // Setting the dispatcher to nil will cause that during the ownership
        // assignment, the Notify method will not be called
        TLazRibbonBaseItem(Item).ToolbarDispatch := nil;
        TLazRibbonBaseItem(Item).Appearance := FAppearance;
        TLazRibbonBaseItem(Item).Images := FImages;
        TLazRibbonBaseItem(Item).DisabledImages := FDisabledImages;
        TLazRibbonBaseItem(Item).LargeImages := FLargeImages;
        TLazRibbonBaseItem(Item).DisabledLargeImages := FDisabledLargeImages;
        TLazRibbonBaseItem(Item).ImagesWidth := FImagesWidth;
        TLazRibbonBaseItem(Item).LargeImagesWidth := FLargeImagesWidth;
        TLazRibbonBaseItem(Item).ToolbarDispatch := FToolbarDispatch;
      end;

    opRemove:
      if Item is TLazRibbonBaseItem then
      begin
        if not (csDestroying in Item.ComponentState) then
        begin
          TLazRibbonBaseItem(Item).ToolbarDispatch := nil;
          TLazRibbonBaseItem(Item).Appearance := nil;
          TLazRibbonBaseItem(Item).Images := nil;
          TLazRibbonBaseItem(Item).DisabledImages := nil;
          TLazRibbonBaseItem(Item).LargeImages := nil;
          TLazRibbonBaseItem(Item).DisabledLargeImages := nil;
        end;
      end else
        for i := 0 to Count-1 do
        begin
          baseItem := Items[i];
          baseItem.Notify(Item, Operation);
        end;
  end;
end;

procedure TLazRibbonItems.SetAppearance(const Value: TLazRibbonToolbarAppearance);
var
  i: Integer;
begin
  FAppearance := Value;
  for i := 0 to Count - 1 do
    Items[i].Appearance := Value;
end;

procedure TLazRibbonItems.SetDisabledImages(const Value: TImageList);
var
  i: Integer;
begin
  FDisabledImages := Value;
  for i := 0 to Count - 1 do
    Items[i].DisabledImages := Value;
end;

procedure TLazRibbonItems.SetDisabledLargeImages(const Value: TImageList);
var
  i: Integer;
begin
  FDisabledLargeImages := Value;
  for i := 0 to Count - 1 do
    Items[i].DisabledLargeImages := Value;
end;

procedure TLazRibbonItems.SetImages(const Value: TImageList);
var
  i: Integer;
begin
  FImages := Value;
  for i := 0 to Count - 1 do
    Items[i].Images := Value;
end;

procedure TLazRibbonItems.SetImagesWidth(const Value: Integer);
var
  i: Integer;
begin
  FImagesWidth := Value;
  for i := 0 to Count - 1 do
    Items[i].ImagesWidth := Value;
end;

procedure TLazRibbonItems.SetLargeImages(const Value: TImageList);
var
  i: Integer;
begin
  FLargeImages := Value;
  for i := 0 to Count - 1 do
    Items[i].LargeImages := Value;
end;

procedure TLazRibbonItems.SetLargeImagesWidth(const Value: Integer);
var
  i: Integer;
begin
  FLargeImagesWidth := Value;
  for i := 0 to Count - 1 do
    Items[i].LargeImagesWidth := Value;
end;

procedure TLazRibbonItems.SetToolbarDispatch(const Value: TLazRibbonBaseToolbarDispatch);
var
  i : integer;
begin
  FToolbarDispatch := Value;
  for i := 0 to Count - 1 do
    Items[i].ToolbarDispatch := Value;
end;

procedure TLazRibbonItems.Update;
begin
  inherited Update;
  if Assigned(FToolbarDispatch) then
     FToolbarDispatch.NotifyItemsChanged;
end;

end.
