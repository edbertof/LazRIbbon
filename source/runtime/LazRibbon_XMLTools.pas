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

unit LazRibbon_XMLTools;

{$mode ObjFpc}
{$H+}

interface

uses
  Graphics, SysUtils, LazRibbon_XMLParser;

type TLazRibbonXMLTools = class
     private
     protected
     public
       class procedure Save(Node : TLazRibbonXMLNode; Font : TFont); overload;
       class procedure Load(Node : TLazRibbonXMLNode; Font : TFont); overload;
     end;

implementation

{ TXMLTools }

class procedure TLazRibbonXMLTools.Load(Node: TLazRibbonXMLNode; Font: TFont);

var Subnode, Subnode2 : TLazRibbonXMLNode;

begin
if not(assigned(Node)) then
   raise exception.create('TLazRibbonXMLTools.Load: Invalid XML branch!');
if not(assigned(Font)) then
   raise exception.create('TLazRibbonXMLTools.Load: Missing font object to load!');

Subnode:=Node['Charset',false];
if assigned(Subnode) then
   Font.Charset:=TFontCharset(Subnode.TextAsInteger);

Subnode:=Node['Color',false];
if assigned(Subnode) then
   Font.Color:=Subnode.TextAsInteger;

Subnode:=Node['Name',false];
if assigned(Subnode) then
   Font.Name:=Subnode.Text;

Subnode:=Node['Orientation',false];
if assigned(Subnode) then
   Font.Orientation:=Subnode.TextAsInteger;

Subnode:=Node['Pitch',false];
if assigned(Subnode) then
   Font.Pitch:=TFontPitch(Subnode.TextAsInteger);

Subnode:=Node['Size',false];
if assigned(Subnode) then
   Font.Size:=Subnode.TextAsInteger;

Subnode:=Node['Style',false];
if assigned(Subnode) then
   begin
   Subnode2:=Subnode['Bold',false];
   if assigned(Subnode2) then
      if Subnode2.TextAsBoolean then
         Font.Style:=Font.Style + [fsBold] else
         Font.Style:=Font.Style - [fsBold];

   Subnode2:=Subnode['Italic',false];
   if assigned(Subnode2) then
      if Subnode2.TextAsBoolean then
         Font.Style:=Font.Style + [fsItalic] else
         Font.Style:=Font.Style - [fsItalic];

   Subnode2:=Subnode['Underline',false];
   if assigned(Subnode2) then
      if Subnode2.TextAsBoolean then
         Font.Style:=Font.Style + [fsUnderline] else
         Font.Style:=Font.Style - [fsUnderline];
   end;
end;

class procedure TLazRibbonXMLTools.Save(Node: TLazRibbonXMLNode; Font: TFont);

var Subnode, Subnode2 : TLazRibbonXMLNode;

begin
if not(assigned(Node)) then
   raise exception.create('TLazRibbonXMLTools.Save: Invalid XML branch!');
if not(assigned(Font)) then
   raise exception.create('TLazRibbonXMLTools.Save: Missing font object to save!');

Subnode:=Node['Charset',true];
Subnode.TextAsInteger:=Font.Charset;

Subnode:=Node['Color',true];
Subnode.TextAsInteger:=Font.Color;

Subnode:=Node['Name',true];
Subnode.Text:=Font.Name;

Subnode:=Node['Orientation',true];
Subnode.TextAsInteger:=Font.Orientation;

Subnode:=Node['Pitch',true];
Subnode.TextAsInteger:=ord(Font.Pitch);

Subnode:=Node['Size',true];
Subnode.TextAsInteger:=Font.Size;

Subnode:=Node['Style',true];
Subnode2:=Subnode['Bold',true];
Subnode2.TextAsBoolean:=fsBold in Font.Style;

Subnode2:=Subnode['Italic',true];
Subnode2.TextAsBoolean:=fsItalic in Font.Style;

Subnode2:=Subnode['Underline',true];
Subnode2.TextAsBoolean:=fsUnderline in Font.Style;
end;

end.
