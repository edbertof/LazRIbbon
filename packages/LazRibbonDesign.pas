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

{ This file was generated for the LazRibbon design-time package. }

unit LazRibbonDesign;

{$warn 5023 off : no warning about unused units}

interface

uses
  LazRibbon_Register, LazRibbon_Editor, LazRibbon_AppearanceEditor, LazRibbon_EditWindow, LazRibbon_SkinManagerEditor, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('LazRibbon_Register', @LazRibbon_Register.Register);
end;

initialization
  RegisterPackage('LazRibbonDesign', @Register);
end.
