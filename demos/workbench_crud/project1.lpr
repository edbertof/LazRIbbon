program project1;

{$mode delphi}{$H+}
{$codepage utf8}

uses
  Interfaces, Forms, Unit1;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
