unit LazRibbon_Types;

{$mode Delphi}

(*******************************************************************************
*                                                                              *
*  File:        LazRibbon_Types.pas                                                 *
*  Description: Definitions of types used during work of the toolbar           *
*  Copyright:   (c) 2009 by Spook.                                             *
*  License:     Modified LGPL (with linking exception, like Lazarus LCL)       *
*               See "license.txt" in this installation                         *
*                                                                              *
*******************************************************************************)

interface

uses
  Controls, Classes, ContNrs, SysUtils, Dialogs,
  LazRibbon_Exceptions;

type
  TLazRibbonListState = (lsNeedsProcessing, lsReady);

  TLazRibbonCollection = class(TPersistent)
  protected
    FList: TFPObjectList;
    FNames: TStringList;
    FListState: TLazRibbonListState;
    FRootComponent: TComponent;

    // *** Methods responding to changes ***
    procedure Notify({%H-}Item: TComponent; {%H-}Operation: TOperation); virtual;
    procedure Update; virtual;

    // *** Internal methods for adding and inserting elements ***
    // *** Getters and setters ***
    function GetItems(AIndex: integer): TComponent; virtual;

  public
    // *** Constructor, destructor ***
    constructor Create(ARootComponent : TComponent); reintroduce; virtual;
    destructor Destroy; override;

    // *** List operations ***
    procedure AddItem(AItem: TComponent);
    procedure InsertItem(AIndex: integer; AItem: TComponent);
    procedure Clear;
    function Count: integer;
    procedure Delete(AIndex: integer); virtual;
    function IndexOf(Item: TComponent) : integer;
    procedure Remove(Item: TComponent); virtual;
    procedure RemoveReference(Item: TComponent);
    procedure Exchange(item1, item2: integer);
    procedure Move(IndexFrom, IndexTo: integer);

    // *** Reader, writer and operation designtime and DFM/LFM
    procedure WriteNames(Writer: TWriter); virtual;
    procedure ReadNames(Reader: TReader); virtual;
    procedure ProcessNames(Owner: TComponent); virtual;

    property ListState: TLazRibbonListState read FListState;
    property Items[index: integer] : TComponent read GetItems; default;
    property RootComponent: TComponent read FRootComponent;
  end;

  TLazRibbonComponent = class(TComponent)
  protected
    FParent: TComponent;
    FCollection: TLazRibbonCollection;
  public
    destructor Destroy; override;
    // *** Parent operations ***
    function HasParent: boolean; override;
    function GetParentComponent: TComponent; override;
    procedure SetParentComponent(Value: TComponent); override;

    property Parent: TComponent read FParent write SetParentComponent;
    property Collection: TLazRibbonCollection read FCollection;
  end;


implementation

{ TLazRibbonCollection }

constructor TLazRibbonCollection.Create(ARootComponent: TComponent);
begin
  inherited Create;
  FRootComponent := ARootComponent;
  FNames := TStringList.Create;
  FList := TFPObjectList.Create(False);
  FListState := lsReady;
end;

destructor TLazRibbonCollection.Destroy;
var
  I: Integer;
begin
  { Components can outlive their non-owning collection. Do not call virtual
    update hooks while the host's destructor is releasing its subobjects. }
  if FList <> nil then
    for I := 0 to FList.Count - 1 do
      if (TObject(FList[I]) is TLazRibbonComponent) and
        (TLazRibbonComponent(FList[I]).FCollection = Self) then
        TLazRibbonComponent(FList[I]).FCollection := nil;
  FNames.Free;
  FList.Free;
  inherited;
end;

procedure TLazRibbonCollection.AddItem(AItem: TComponent);
begin
  if AItem = nil then
    raise InternalException.Create('TLazRibbonCollection.AddItem: Missing item!');
  if FList.IndexOf(AItem) >= 0 then Exit;
  if (AItem is TLazRibbonComponent) and
    (TLazRibbonComponent(AItem).FCollection <> nil) then
    TLazRibbonComponent(AItem).FCollection.RemoveReference(AItem);
  // Ta metoda mo¿e byæ wywo³ywana bez przetworzenia nazw (w szczególnoœci, metoda
  // przetwarzaj¹ca nazwy korzysta z AddItem)

  // This method can be recalling untreated names (in particular, the method
  // that processes the name uses the AddItem)

  Notify(AItem, opInsert);
  FList.Add(AItem);

  if AItem is TLazRibbonComponent then
    TLazRibbonComponent(AItem).FCollection := self;

  Update;
end;

procedure TLazRibbonCollection.Clear;
var
  Index: Integer;
begin
  while FList.Count > 0 do
  begin
    Index := FList.Count - 1;
    Notify(TComponent(FList[Index]), opRemove);
    FList.Delete(Index);
  end;
  Update;
end;

function TLazRibbonCollection.Count: integer;
begin
  Result := FList.Count;
end;

procedure TLazRibbonCollection.Delete(AIndex: integer);
begin
  if (AIndex < 0) or (AIndex >= FList.count) then
    raise InternalException.Create('TLazRibbonCollection.Delete: Illegal index!');

  Notify(TComponent(FList[AIndex]), opRemove);
  FList.Delete(AIndex);
  Update;
end;

procedure TLazRibbonCollection.Exchange(item1, item2: integer);
begin
  FList.Exchange(item1, item2);
  Update;
end;

function TLazRibbonCollection.GetItems(AIndex: integer): TComponent;
begin
  if (AIndex < 0) or (AIndex >= FList.Count) then
    raise InternalException.Create('TLazRibbonCollection.GetItems: Illegal index!');

  Result := TComponent(FList[AIndex]);
end;

function TLazRibbonCollection.IndexOf(Item: TComponent): integer;
begin
  result := FList.IndexOf(Item);
end;

procedure TLazRibbonCollection.InsertItem(AIndex: integer; AItem: TComponent);
begin
  if (AIndex < 0) or (AIndex > FList.Count) then
    raise InternalException.Create('TLazRibbonCollection.InsertItem: Illegal index!');
  if AItem = nil then
    raise InternalException.Create('TLazRibbonCollection.InsertItem: Missing item!');
  if FList.IndexOf(AItem) >= 0 then Exit;
  if (AItem is TLazRibbonComponent) and
    (TLazRibbonComponent(AItem).FCollection <> nil) then
    TLazRibbonComponent(AItem).FCollection.RemoveReference(AItem);

  Notify(AItem, opInsert);
  FList.Insert(AIndex, AItem);
  if AItem is TLazRibbonComponent then
    TLazRibbonComponent(AItem).FCollection := self;
  Update;
end;

procedure TLazRibbonCollection.Move(IndexFrom, IndexTo: integer);
begin
  if (indexFrom < 0) or (indexFrom >= FList.Count) or
     (indexTo < 0) or (indexTo >= FList.Count)
  then
    raise InternalException.Create('TLazRibbonCollection.Move: Illegal index!');

  FList.Move(IndexFrom, IndexTo);
  Update;
end;

procedure TLazRibbonCollection.Notify(Item: TComponent; Operation: TOperation);
begin
  if (Operation = opRemove) and (Item is TLazRibbonComponent) and
    (TLazRibbonComponent(Item).FCollection = Self) then
    TLazRibbonComponent(Item).FCollection := nil;
end;

procedure TLazRibbonCollection.ProcessNames(Owner: TComponent);
var
  s: string;
  Item: TComponent;
begin
  Clear;
  if Owner <> nil then
    for s in FNames do
    begin
      Item := Owner.FindComponent(s);
      if Item <> nil then AddItem(Item);
    end;
  FNames.Clear;
  FListState := lsReady;
end;

procedure TLazRibbonCollection.ReadNames(Reader: TReader);
begin
  Reader.ReadListBegin;
  FNames.Clear;
  while not(Reader.EndOfList) do
    FNames.Add(Reader.ReadString);
  Reader.ReadListEnd;
  FListState := lsNeedsProcessing;
end;

procedure TLazRibbonCollection.Remove(Item: TComponent);
var
  i: integer;
begin
  i := FList.IndexOf(Item);
  if i >= 0 then
    Delete(i);
end;

procedure TLazRibbonCollection.RemoveReference(Item: TComponent);
var
  Index: Integer;
begin
  Index := FList.IndexOf(Item);
  if Index >= 0 then
  begin
    Notify(Item, opRemove);
    FList.Extract(Item);
    Update;
  end;
end;

procedure TLazRibbonCollection.Update;
begin
  //
end;

procedure TLazRibbonCollection.WriteNames(Writer: TWriter);
var
  i: Integer;
begin
  Writer.WriteListBegin;
  for i := 0 to FList.Count - 1 do
    Writer.WriteString(TComponent(FList[i]).Name);
  Writer.WriteListEnd;
end;


{ TLazRibbonComponent }

destructor TLazRibbonComponent.Destroy;
begin
  Destroying;
  if FCollection <> nil then
    FCollection.RemoveReference(Self);
  inherited Destroy;
end;

function TLazRibbonComponent.GetParentComponent: TComponent;
begin
  Result := FParent;
end;

function TLazRibbonComponent.HasParent: boolean;
begin
  Result := (FParent <> nil);
end;

procedure TLazRibbonComponent.SetParentComponent(Value: TComponent);
begin
  FParent := Value;
end;

end.
