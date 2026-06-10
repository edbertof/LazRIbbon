unit LazRibbon_Dispatch;

{$mode delphi}

(*******************************************************************************
*                                                                              *
*  File: LazRibbon_Dispatch.pas                                                     *
*  Description: Basic classes of intermediary dispatchers between elements     *
*               of the toolbar.                                                *
*  Copyright:   (c) 2009 by Spook.                                             *
*  License:     Modified LGPL (with linking exception, like Lazarus LCL)       *
*               See "license.txt" in this installation                         *
*                                                                              *
*******************************************************************************)

interface

uses
  Classes, Controls, Graphics,
  LazRibbon_Math;

type
  { ILazRibbonSkinProvider

    Low-level bridge used by toolbar-owned items to obtain skin services
    without adding a dependency back to LazRibbon_Core.  The first 1.1.x
    step deliberately keeps the SkinManager exposed as TObject so existing
    units can migrate gradually and only units that already know
    TLazRibbonSkinManager perform the final cast. }
  ILazRibbonSkinProvider = interface
    ['{B2B5B7F9-6F42-4C5A-9D6B-70A68D0C7E14}']
    function GetSkinManagerObject: TObject;
  end;

  TLazRibbonBaseDispatch = class abstract(TObject)
  private
  protected
  public
  end;

  TLazRibbonBaseAppearanceDispatch = class abstract(TLazRibbonBaseDispatch)
  public
    procedure NotifyAppearanceChanged; virtual; abstract;
  end;

  TLazRibbonBaseToolbarDispatch = class abstract(TLazRibbonBaseAppearanceDispatch)
  public
    procedure NotifyItemsChanged; virtual; abstract;
    procedure NotifyMetricsChanged; virtual; abstract;
    procedure NotifyVisualsChanged; virtual; abstract;
    function GetTempBitmap: TBitmap; virtual; abstract;
    function ClientToScreen(Point: T2DIntPoint): T2DIntPoint; virtual; abstract;

    { Optional owner services exposed without adding unit dependencies.
      Descendant item units should query GetSkinProvider.  The object-level
      method is kept as a compatibility shim for gradual migration. }
    function GetSkinProvider: ILazRibbonSkinProvider; virtual; abstract;
    function GetSkinManagerObject: TObject; virtual; abstract;
  end;

implementation

end.
