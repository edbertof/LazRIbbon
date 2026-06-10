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

unit LazRibbon_XMLIni;

{$mode ObjFpc}
{$H+}

{$DEFINE SPKXMLINI}

interface

uses LazRibbon_XMLParser, classes, sysutils;

type TLazRibbonXMLIni = class(TObject)
     private
       FParser : TLazRibbonXMLParser;
       FAutoConvert : boolean;
     protected
     public
       constructor Create; overload;
       constructor Create(filename : string); overload;
       destructor Destroy; override;
       procedure LoadFromFile(filename : string);
       procedure SaveToFile(filename : string);
       procedure SaveToStream(AStream : TStream);
       procedure LoadFromStream(AStream : TStream);
       procedure Clear;
       procedure DeleteKey(const Section, Ident: string);
       procedure EraseSection(const Section: string);
       function ReadString(const Section, Ident, Default: string): string;
       procedure WriteString(const Section, Ident, Value: string);
       function ReadBool (const Section, Ident: String; Default: Boolean): Boolean;
       function ReadDate (const Section, Ident: string; Default: TDateTime): TDateTime;
       function ReadDateTime (const Section, Ident: String; Default: TDateTime): TDateTime;
       function ReadFloat (const Section, Ident: String; Default: Double): Double;
       function ReadInteger(const Section, Ident: String; Default: Longint): Longint;
       function ReadTime (const Section, Ident: String; Default: TDateTime): TDateTime;
       function SectionExists (const Section: String): Boolean;
       procedure WriteBool(const Section, Ident: String; Value: Boolean);
       procedure WriteDate(const Section, Ident: String; Value: TDateTime);
       procedure WriteDateTime(const Section, Ident: String; Value: TDateTime);
       procedure WriteFloat(const Section, Ident: String; Value: Double);
       procedure WriteInteger(const Section, Ident: String; Value: Longint);
       procedure WriteTime(const Section, Ident: String; Value: TDateTime);
       function ValueExists(const section, ident : string) : boolean;
       procedure WriteStrings(const Section, Ident : String; Value : TStrings);
       procedure ReadStrings(const Section, Ident : String; Target : TStrings);
       procedure ReadSection (const Section: string; Strings: TStrings);
       procedure ReadSections(Strings: TStrings);
       procedure ReadSectionValues(const Section: string; Strings: TStrings);

       property AutoConvert : boolean read FAutoConvert write FAutoConvert;
     end;

implementation

{ TLazRibbonXMLIni }

constructor TLazRibbonXMLIni.create;

begin
  inherited create;
  FParser:=TLazRibbonXMLParser.create;
  FAutoConvert:=true;
end;

constructor TLazRibbonXMLIni.create(filename : string);

begin
inherited create;
self.LoadFromFile(filename);
end;

destructor TLazRibbonXMLIni.destroy;

begin
  FParser.free;
  inherited;
end;

procedure TLazRibbonXMLIni.LoadFromFile(filename : string);

begin
try
FParser.LoadFromFile(filename);
except
self.clear;
end;
end;

procedure TLazRibbonXMLIni.LoadFromStream(AStream: TStream);
begin
FParser.LoadFromStream(AStream);
end;

procedure TLazRibbonXMLIni.SaveToFile(filename : string);

begin
FParser.SaveToFile(filename);
end;

procedure TLazRibbonXMLIni.SaveToStream(AStream: TStream);
begin
FParser.SaveToStream(AStream);
end;

procedure TLazRibbonXMLIni.Clear;

begin
FParser.Clear;
end;

procedure TLazRibbonXMLIni.DeleteKey(const Section, Ident: string);

var node : TLazRibbonXMLNode;
    subnode : TLazRibbonXMLNode;

begin
node:=FParser.NodeByName[Section,false];
if node<>nil then
   begin
   subnode:=node.NodeByName[Ident,false];
   if subnode<>nil then
      begin
      node.delete(node.IndexOf(subnode));
      end;
   end;
end;

procedure TLazRibbonXMLIni.EraseSection(const Section: string);

var node : TLazRibbonXMLNode;

begin
node:=FParser.NodeByName[Section,false];
if node<>nil then
   Fparser.Delete(FParser.IndexOf(node));
end;

function TLazRibbonXMLIni.ReadString(const Section, Ident, Default: string): string;

var node, subnode : TLazRibbonXMLNode;

begin
node:=FParser.NodeByName[Section,false];
if node=nil then result:=Default else
   begin
   subnode:=node.NodeByName[Ident,false];
   if subnode=nil then result:=Default else
      begin
      if subnode.Parameters.ParamByName['type',false]<>nil then
         begin
         if uppercase(subnode.Parameters.ParamByName['type',false].Value)='STRING' then
            result:=subnode.text else
            begin
            if FAutoConvert then
               try
               result:=subnode.text;
               except
               result:=Default;
               end else raise exception.create('Invalid object type!');
            end;
         end else result:=subnode.Text;
      end;
   end;
end;

procedure TLazRibbonXMLIni.WriteString(const Section, Ident, Value: string);

begin
self.DeleteKey(Section,Ident);
FParser.NodeByName[Section,true].NodeByName[Ident,true].Parameters.ParamByName['type',true].value:='string';
FParser.NodeByName[Section,true].NodeByName[Ident,true].Text:=Value;
end;

function TLazRibbonXMLIni.ReadBool (const Section, Ident: String; Default: Boolean): Boolean;

var node, subnode : TLazRibbonXMLNode;

begin
node:=FParser.NodeByName[Section,false];
if node=nil then result:=Default else
   begin
   subnode:=node.NodeByName[Ident,false];
   if subnode=nil then result:=Default else
      begin
      if subnode.Parameters.ParamByName['type',false]<>nil then
         begin
         if uppercase(subnode.Parameters.ParamByName['type',false].Value)='BOOLEAN' then
            begin
            if (uppercase(subnode.text)='TRUE') or (subnode.text='1') then result:=true else result:=false;
            end else
                begin
                if FAutoConvert then
                   try
                   if (uppercase(subnode.text)='TRUE') or (subnode.text='1') then result:=true else result:=false;
                   except
                   result:=Default;
                   end else raise exception.create('Invalid object type!');
                end;
         end else
             try
             if (uppercase(subnode.text)='TRUE') or (subnode.text='1') then result:=true else result:=false;
             except
             result:=Default;
             end;
      end;
   end;
end;

function TLazRibbonXMLIni.ReadDate (const Section, Ident: string; Default: TDateTime): TDateTime;

var node, subnode : TLazRibbonXMLNode;

begin
node:=FParser.NodeByName[Section,false];
if node=nil then result:=Default else
   begin
   subnode:=node.NodeByName[Ident,false];
   if subnode=nil then result:=Default else
      begin
      if subnode.Parameters.ParamByName['type',false]<>nil then
         begin
         if uppercase(subnode.Parameters.ParamByName['type',false].Value)='DATE' then
            begin
            try
            result:=StrToDate(subnode.text);
            except
            result:=Default;
            end;
            end else
                begin
                if FAutoConvert then
                   try
                   result:=StrToDate(subnode.text);
                   except
                   result:=Default;
                   end else raise exception.create('Invalid object type!');
                end;
         end else
             try
             result:=StrToDate(subnode.text);
             except
             result:=Default;
             end;
      end;
   end;
end;

function TLazRibbonXMLIni.ReadDateTime (const Section, Ident: String; Default: TDateTime): TDateTime;

var node, subnode : TLazRibbonXMLNode;

begin
node:=FParser.NodeByName[Section,false];
if node=nil then result:=Default else
   begin
   subnode:=node.NodeByName[Ident,false];
   if subnode=nil then result:=Default else
      begin
      if subnode.Parameters.ParamByName['type',false]<>nil then
         begin
         if uppercase(subnode.Parameters.ParamByName['type',false].Value)='DATETIME' then
            begin
            try
            result:=StrToDateTime(subnode.text);
            except
            result:=Default;
            end;
            end else
                begin
                if FAutoConvert then
                   try
                   result:=StrToDateTime(subnode.text);
                   except
                   result:=Default;
                   end else raise exception.create('Invalid object type!');
                end;
         end else
             try
             result:=StrToDateTime(subnode.text);
             except
             result:=Default;
             end;
      end;
   end;
end;

function TLazRibbonXMLIni.ReadFloat (const Section, Ident: String; Default: Double): Double;

var node, subnode : TLazRibbonXMLNode;

begin
node:=FParser.NodeByName[Section,false];
if node=nil then result:=Default else
   begin
   subnode:=node.NodeByName[Ident,false];
   if subnode=nil then result:=Default else
      begin
      if subnode.Parameters.ParamByName['type',false]<>nil then
         begin
         if uppercase(subnode.Parameters.ParamByName['type',false].Value)='FLOAT' then
            begin
            try
            result:=StrToFloat(subnode.text);
            except
            result:=Default;
            end;
            end else
                begin
                if FAutoConvert then
                   try
                   result:=StrToFloat(subnode.text);
                   except
                   result:=Default;
                   end else raise exception.create('Invalid object type!');
                end;
         end else
             try
             result:=StrToFloat(subnode.text);
             except
             result:=Default;
             end;
      end;
   end;
end;

function TLazRibbonXMLIni.ReadInteger(const Section, Ident: String; Default: Longint): Longint;

var node, subnode : TLazRibbonXMLNode;

begin
node:=FParser.NodeByName[Section,false];
if node=nil then result:=Default else
   begin
   subnode:=node.NodeByName[Ident,false];
   if subnode=nil then result:=Default else
      begin
      if subnode.Parameters.ParamByName['type',false]<>nil then
         begin
         if uppercase(subnode.Parameters.ParamByName['type',false].Value)='FLOAT' then
            begin
            try
            result:=StrToInt(subnode.text);
            except
            result:=Default;
            end;
            end else
                begin
                if FAutoConvert then
                   try
                   result:=StrToInt(subnode.text);
                   except
                   result:=Default;
                   end else raise exception.create('Invalid object type!');
                end;
         end else
             try
             result:=StrToInt(subnode.text);
             except
             result:=Default;
             end;
      end;
   end;
end;

function TLazRibbonXMLIni.ReadTime (const Section, Ident: String; Default: TDateTime): TDateTime;

var node, subnode : TLazRibbonXMLNode;

begin
node:=FParser.NodeByName[Section,false];
if node=nil then result:=Default else
   begin
   subnode:=node.NodeByName[Ident,false];
   if subnode=nil then result:=Default else
      begin
      if subnode.Parameters.ParamByName['type',false]<>nil then
         begin
         if uppercase(subnode.Parameters.ParamByName['type',false].Value)='TIME' then
            begin
            try
            result:=StrToTime(subnode.text);
            except
            result:=Default;
            end;
            end else
                begin
                if FAutoConvert then
                   try
                   result:=StrToTime(subnode.text);
                   except
                   result:=Default;
                   end else raise exception.create('Invalid object type!');
                end;
         end else
             try
             result:=StrToTime(subnode.text);
             except
             result:=Default;
             end;
      end;
   end;
end;

function TLazRibbonXMLIni.SectionExists (const Section: String): Boolean;

begin
result:=FParser.NodeByName[Section,false]<>nil;
end;

procedure TLazRibbonXMLIni.WriteBool(const Section, Ident: String; Value: Boolean);

begin
self.DeleteKey(Section,Ident);
FParser.NodeByName[Section,true].NodeByName[Ident,true].Parameters.ParamByName['type',true].Value:='boolean';
if Value then FParser.NodeByName[Section,true].NodeByName[Ident,true].Text:='true' else
   FParser.NodeByName[Section,true].NodeByName[Ident,true].text:='false';
end;

procedure TLazRibbonXMLIni.WriteDate(const Section, Ident: String; Value: TDateTime);

begin
self.DeleteKey(Section,Ident);
FParser.NodeByName[Section,true].NodeByName[Ident,true].Parameters.ParamByName['type',true].Value:='date';
FParser.NodeByName[Section,true].NodeByName[Ident,true].Text:=DateToStr(Value);
end;

procedure TLazRibbonXMLIni.WriteDateTime(const Section, Ident: String; Value: TDateTime);

begin
self.DeleteKey(Section,Ident);
FParser.NodeByName[Section,true].NodeByName[Ident,true].Parameters.ParamByName['type',true].Value:='datetime';
FParser.NodeByName[Section,true].NodeByName[Ident,true].Text:=DateTimeToStr(Value);
end;

procedure TLazRibbonXMLIni.WriteFloat(const Section, Ident: String; Value: Double);

begin
self.DeleteKey(Section,Ident);
FParser.NodeByName[Section,true].NodeByName[Ident,true].Parameters.ParamByName['type',true].Value:='float';
FParser.NodeByName[Section,true].NodeByName[Ident,true].Text:=FloatToStr(Value);
end;

procedure TLazRibbonXMLIni.WriteInteger(const Section, Ident: String; Value: Longint);

begin
self.DeleteKey(Section,Ident);
FParser.NodeByName[Section,true].NodeByName[Ident,true].Parameters.ParamByName['type',true].Value:='integer';
FParser.NodeByName[Section,true].NodeByName[Ident,true].Text:=IntToStr(Value);
end;

procedure TLazRibbonXMLIni.WriteTime(const Section, Ident: String; Value: TDateTime);

begin
self.DeleteKey(Section,Ident);
FParser.NodeByName[Section,true].NodeByName[Ident,true].Parameters.ParamByName['type',true].Value:='time';
FParser.NodeByName[Section,true].NodeByName[Ident,true].Text:=TimeToStr(Value);
end;

function TLazRibbonXMLIni.ValueExists(const section, ident : string) : boolean;

begin
result:=FParser.NodeByName[section,false]<>nil;
if result then
   result:=result and (FParser.NodeByName[section,false].NodeByName[ident,false]<>nil);
end;

procedure TLazRibbonXMLIni.WriteStrings(const Section, Ident : String; Value : TStrings);

var node,subnode : TLazRibbonXMLNode;
    i : integer;

begin
self.DeleteKey(Section,Ident);
node:=FParser.NodeByName[Section,true];
subnode:=node.NodeByName[ident,true];
subnode.Parameters.ParamByName['type',true].value:='strings';
subnode.parameters.parambyname['count',true].value:=IntToStr(Value.count);
for i:=0 to value.count-1 do
    begin
    subnode.NodeByName['line'+IntToStr(i),true].text:=Value[i];
    end;
end;

procedure TLazRibbonXMLIni.ReadStrings(const Section, Ident : String; Target : TStrings);

var node, subnode, line : TLazRibbonXMLNode;
    i,count : integer;

begin
target.clear;

node:=FParser.NodeByName[Section,false];
if node=nil then exit;

subnode:=node.NodeByName[ident,false];
if subnode=nil then exit;

if subnode.Parameters.ParamByName['type',false]=nil then exit;
if uppercase(subnode.Parameters.ParamByName['type',false].value)<>'STRINGS' then exit;

if subnode.parameters.parambyname['count',false]=nil then exit;

try
count:=StrToInt(subnode.parameters.parambyname['count',false].Value);
except
exit
end;

for i:=0 to count-1 do
    begin
    line:=subnode.NodeByName['line'+IntToStr(i),false];
    if line=nil then
       begin
       target.Clear;
       exit;
       end;
    target.Add(line.Text);
    end;
end;

procedure TLazRibbonXMLIni.ReadSection(const Section: string; Strings: TStrings);

var i : integer;
    node : TLazRibbonXMLNode;

begin
if FParser.NodeByName[Section,false]=nil then exit;
node:=FParser.NodeByName[Section,false];
if node.Count=0 then exit;
for i:=0 to node.Count-1 do
    Strings.Add(node.NodeByIndex[i].Name);
end;

procedure TLazRibbonXMLIni.ReadSections(Strings: TStrings);

var i : integer;

begin
if FParser.count=0 then exit;
for i:=0 to FParser.count-1 do
    Strings.add(FParser.NodeByIndex[i].Name);
end;

procedure TLazRibbonXMLIni.ReadSectionValues(const Section: string; Strings: TStrings);

var i : integer;
    node : TLazRibbonXMLNode;

begin
if FParser.NodeByName[Section,false]=nil then exit;
node:=FParser.NodeByName[Section,false];
if node.Count=0 then exit;
for i:=0 to node.count-1 do
    begin
    {$I-}
    if (node.NodeByIndex[i].Parameters.ParamByName['type',false]<>nil) and
       (uppercase(node.NodeByIndex[i].Parameters.ParamByName['type',false].Value)='STRINGS') then
       Strings.add('[TStrings]')
       else
       Strings.add(node.NodeByIndex[i].Text);
    end;
end;

end.
