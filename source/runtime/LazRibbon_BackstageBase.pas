unit LazRibbon_BackstageBase;

{$mode Delphi}{$H+}

(*******************************************************************************
*                                                                              *
*  File:        LazRibbon_BackstageBase.pas                                    *
*  Description: Base class used by TLazRibbon to reference BackStage views      *
*               without depending on LazRibbon_Backstage and creating a        *
*               circular unit reference.                                       *
*  License:     Modified LGPL (with linking exception, like Lazarus LCL)       *
*                                                                              *
*******************************************************************************)

interface

uses
  Classes, Controls, LazRibbon_Dispatch;

type
  { TLazRibbonCustomBackstageView

    Abstract bridge for BackStage integration.  TLazRibbon_Core can publish a
    BackstageView property typed with this base class, while the concrete
    TLazRibbonBackstageView remains in LazRibbon_Backstage. }
  TLazRibbonCustomBackstageView = class(TCustomControl)
  public
    procedure AttachToRibbonComponent(AToolbar: TCustomControl;
      const AMenuCaption: String); virtual;
    procedure DetachFromRibbonComponent(AToolbar: TCustomControl); virtual;
    procedure SetRibbonSkinProvider(ASkinProvider: ILazRibbonSkinProvider); virtual;
    procedure SetRibbonSkinManagerObject(ASkinManager: TObject); virtual;
    function HandleRibbonTabClick(ATabIndex: Integer; const ATabCaption: String;
      AIsCurrentTab: Boolean): Boolean; virtual;
  end;

implementation

procedure TLazRibbonCustomBackstageView.AttachToRibbonComponent(
  AToolbar: TCustomControl; const AMenuCaption: String);
begin
  { Base implementation intentionally does nothing. }
end;

procedure TLazRibbonCustomBackstageView.DetachFromRibbonComponent(
  AToolbar: TCustomControl);
begin
  { Base implementation intentionally does nothing. }
end;

procedure TLazRibbonCustomBackstageView.SetRibbonSkinProvider(
  ASkinProvider: ILazRibbonSkinProvider);
begin
  { Base implementation intentionally does nothing. }
end;

procedure TLazRibbonCustomBackstageView.SetRibbonSkinManagerObject(
  ASkinManager: TObject);
begin
  { Base implementation intentionally does nothing. }
end;

function TLazRibbonCustomBackstageView.HandleRibbonTabClick(ATabIndex: Integer;
  const ATabCaption: String; AIsCurrentTab: Boolean): Boolean;
begin
  { Base implementation allows the Ribbon tab click to continue normally. }
  Result := True;
end;

end.
