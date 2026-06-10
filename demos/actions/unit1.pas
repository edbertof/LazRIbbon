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

unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ActnList,
  StdActns, StdCtrls, Menus, ComCtrls, ExtCtrls, LazRibbon_Core, LazRibbon_Buttons,
  LazRibbon_Checkboxes, LazRibbon_Groups, LazRibbon_Tabs, LazRibbon_Appearance, LazRibbon_Popup;

type

  { TForm1 }

  TForm1 = class(TForm)
    AcOpen: TAction;
    AcClassicalGUI: TAction;
    AcRibbonGUI: TAction;
    AcSave: TAction;
    AcQuit: TAction;
    AcAutoSave: TAction;
    AcSaveNow: TAction;
    AcBold: TAction;
    AcItalic: TAction;
    AcLeftJustify: TAction;
    AcCenter: TAction;
    AcRightJustify: TAction;
    AcAbout: TAction;
    AcUnderline: TAction;
    ActionList: TActionList;
    AcEditCopy: TEditCopy;
    AcEditCut: TEditCut;
    AcEditPaste: TEditPaste;
    btnToggleMenuButton: TButton;
    BtnToggleMenuButtonDropdownArrow: TButton;
    edMenuButtonCaption: TEdit;
    ImageList: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    LargeImageList: TImageList;
    MainMenu: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem21: TMenuItem;
    MenuItem22: TMenuItem;
    MenuItem23: TMenuItem;
    MenuItem24: TMenuItem;
    MenuItem25: TMenuItem;
    MenuItem26: TMenuItem;
    MenuItem27: TMenuItem;
    MenuItem28: TMenuItem;
    MenuItem29: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem30: TMenuItem;
    MenuItem31: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    Panel1: TPanel;
    ShowDialogLauncherCheckbox: TLazRibbonCheckbox;
    LazLargeButton4: TLazRibbonLargeButton;
    LazLargeButton5: TLazRibbonLargeButton;
    LazPane2: TLazRibbonPane;
    LazPane4: TLazRibbonPane;
    LazSmallButton10: TLazRibbonSmallButton;
    LazSmallButton11: TLazRibbonSmallButton;
    LazSmallButton4: TLazRibbonSmallButton;
    LazSmallButton6: TLazRibbonSmallButton;
    LazSmallButton8: TLazRibbonSmallButton;
    LazSmallButton9: TLazRibbonSmallButton;
    LazTab4: TLazRibbonTab;
    LazTab5: TLazRibbonTab;
    LazCheckbox1: TLazRibbonCheckbox;
    LazLargeButton1: TLazRibbonLargeButton;
    LazLargeButton2: TLazRibbonLargeButton;
    LazLargeButton3: TLazRibbonLargeButton;
    LazPane1: TLazRibbonPane;
    LazPane3: TLazRibbonPane;
    LazPane5: TLazRibbonPane;
    LazPane6: TLazRibbonPane;
    LazRadioButton1: TLazRibbonRadioButton;
    LazRadioButton2: TLazRibbonRadioButton;
    LazSmallButton1: TLazRibbonSmallButton;
    LazSmallButton2: TLazRibbonSmallButton;
    LazSmallButton3: TLazRibbonSmallButton;
    LazSmallButton5: TLazRibbonSmallButton;
    LazSmallButton7: TLazRibbonSmallButton;
    LazTab1: TLazRibbonTab;
    LazTab2: TLazRibbonTab;
    LazTab3: TLazRibbonTab;
    LazToolbar1: TLazRibbon;
    StyleMenu: TLazRibbonPopupMenu;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    procedure AcAboutExecute(Sender: TObject);
    procedure AcAutoSaveExecute(Sender: TObject);
    procedure AcBoldExecute(Sender: TObject);
    procedure AcCenterExecute(Sender: TObject);
    procedure AcClassicalGUIExecute(Sender: TObject);
    procedure AcEditCopyExecute(Sender: TObject);
    procedure AcEditCutExecute(Sender: TObject);
    procedure AcEditPasteExecute(Sender: TObject);
    procedure AcItalicExecute(Sender: TObject);
    procedure AcLeftJustifyExecute(Sender: TObject);
    procedure AcOpenExecute(Sender: TObject);
    procedure AcQuitExecute(Sender: TObject);
    procedure AcRibbonGUIExecute(Sender: TObject);
    procedure AcRightJustifyExecute(Sender: TObject);
    procedure AcSaveExecute(Sender: TObject);
    procedure AcSaveNowExecute(Sender: TObject);
    procedure AcUnderlineExecute(Sender: TObject);
    procedure btnToggleMenuButtonClick(Sender: TObject);
    procedure BtnToggleMenuButtonDropdownArrowClick(Sender: TObject);
    procedure edMenuButtonCaptionEditingDone(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure ShowDialogLauncherCheckboxClick(Sender: TObject);
    procedure LazPane2DialogLauncherClick(Sender: TObject);
    procedure LazPane6DialogLauncherClick(Sender: TObject);
    procedure LazToolbar1MenuButtonClick(Sender: TObject);
    procedure StyleMenuClick(Sender: TObject);
  private
    { private declarations }
    procedure LoadFromIni;
    procedure SaveToIni;
    procedure SetStyle(AStyle: TLazRibbonStyle);
    procedure SetUserInterface(Ribbon:boolean);
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

uses
  inifiles, unit2;


{ TForm1 }

procedure TForm1.AcClassicalGUIExecute(Sender: TObject);
begin
  SetUserInterface(false);
end;

procedure TForm1.AcAboutExecute(Sender: TObject);
var
  F: TAboutForm;
begin
  F := TAboutForm.Create(nil);
  try
    F.ShowModal;
  finally
    F.Free;
  end;
end;

procedure TForm1.AcAutoSaveExecute(Sender: TObject);
begin
  //  Checked is handled by "AutoCheck". Need this method to have the action enabled.
end;

procedure TForm1.AcBoldExecute(Sender: TObject);
begin
  Label1.Caption := '"Bold" clicked';
end;

procedure TForm1.AcCenterExecute(Sender: TObject);
begin
  Label1.Caption := '"Center" clicked';
end;

procedure TForm1.AcEditCopyExecute(Sender: TObject);
begin
  Label1.Caption := '"Copy" clicked';
end;

procedure TForm1.AcEditCutExecute(Sender: TObject);
begin
  Label1.Caption := '"Cut" clicked';
end;

procedure TForm1.AcEditPasteExecute(Sender: TObject);
begin
  Label1.Caption := '"Paste" clicked';
end;

procedure TForm1.AcItalicExecute(Sender: TObject);
begin
  Label1.Caption := '"Italic" clicked';
end;

procedure TForm1.AcLeftJustifyExecute(Sender: TObject);
begin
  Label1.Caption := '"Left-justify" clicked';
end;

procedure TForm1.AcOpenExecute(Sender: TObject);
begin
  Label1.Caption := '"Open" clicked';
end;

procedure TForm1.AcQuitExecute(Sender: TObject);
begin
  Close;
end;

procedure TForm1.AcRibbonGUIExecute(Sender: TObject);
begin
  SetUserInterface(true);
end;

procedure TForm1.AcRightJustifyExecute(Sender: TObject);
begin
  Label1.Caption := '"Right-justify" clicked';
end;

procedure TForm1.AcSaveExecute(Sender: TObject);
begin
  Label1.Caption := '"Save" clicked';
end;

procedure TForm1.AcSaveNowExecute(Sender: TObject);
begin
  SaveToIni;
end;

procedure TForm1.AcUnderlineExecute(Sender: TObject);
begin
  Label1.Caption := '"Underline" clicked';
end;

procedure TForm1.btnToggleMenuButtonClick(Sender: TObject);
begin
  LazToolbar1.ShowMenuButton := not LazToolbar1.ShowMenuButton;
end;

procedure TForm1.BtnToggleMenuButtonDropdownArrowClick(Sender: TObject);
begin
  if LazToolbar1.MenuButtonStyle = mbsCaption then
    LazToolbar1.MenuButtonStyle := mbsCaptionDropdown
  else
    LazToolbar1.MenuButtonStyle := mbsCaption;
end;

procedure TForm1.edMenuButtonCaptionEditingDone(Sender: TObject);
begin
  LazToolbar1.MenuButtonCaption := edMenuButtonCaption.Text;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  if CanClose then
    if MessageDlg('Do you really want to close this application?', mtConfirmation,
      [mbYes, mbNo], 0) <> mrYes
    then
      CanClose := false;
  if CanClose then
    if AcAutoSave.Checked then
      SaveToIni;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  SetUserInterface(true);
  Label1.Caption := '';
  LoadFromIni;
  edMenuButtonCaption.Text := LazToolbar1.MenuButtonCaption;
end;

procedure TForm1.ShowDialogLauncherCheckboxClick(Sender: TObject);
begin
  LazPane2.ShowDialogLauncher := ShowDialogLauncherCheckbox.Checked;
  LazPane6.ShowDialogLauncher := ShowDialogLauncherCheckbox.Checked;
end;

procedure TForm1.LazPane2DialogLauncherClick(Sender: TObject);
begin
  ShowMessage('You clicked on the ''Dialog launcher'' button of the "Format settings" pane.');
end;

procedure TForm1.LazPane6DialogLauncherClick(Sender: TObject);
begin
  ShowMessage('You clicked the ''Dialog launcher'' button of the "User interface" pane.');
end;

procedure TForm1.LazToolbar1MenuButtonClick(Sender: TObject);
begin
  ShowMessage('You clicked on Menu Button.');
end;

procedure TForm1.LoadFromIni;
var
  ini: TCustomIniFile;
begin
  ini := TMemIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
  try
    SetUserInterface(ini.ReadBool('MainForm', 'RibbonInterface', AcRibbonGUI.Checked));
    LazToolbar1.Style := TLazRibbonStyle(ini.ReadInteger('MainForm', 'RibbonStyle', 0));
    SetStyle(LazToolbar1.Style);
    ShowDialogLauncherCheckbox.Checked := ini.ReadBool('MainForm', 'ShowDialogLauncher', false);
    ShowDialogLauncherCheckboxClick(nil);
    LazToolbar1.ShowMenuButton := ini.ReadBool('MainForm', 'ShowMenuButton', false);
    LazToolbar1.MenuButtonStyle := TLazRibbonMenubuttonStyle(ini.ReadInteger('MainForm', 'MenuButtonStyle', 0));
    LazToolbar1.MenuButtonCaption := ini.ReadString('MainForm', 'MenuButtonCaption', 'Menu');
  finally
    ini.Free;
  end;
end;

procedure TForm1.StyleMenuClick(Sender: TObject);
var
  i: Integer;
begin
//  LazToolbar1.Style := TLazRibbonStyle((Sender as TMenuItem).Tag);
  for i:=0 to StyleMenu.Items.Count-1 do
    StyleMenu.Items[i].Checked := StyleMenu.Items[i] = TMenuItem(Sender);
  SetStyle(TLazRibbonStyle((Sender as TMenuItem).Tag));
end;

procedure TForm1.SetStyle(AStyle: TLazRibbonStyle);
var
  item: TMenuItem;
begin
  LazToolbar1.Style := AStyle;
  case LazToolbar1.Style of
    lazOffice2007Blue            : LazToolbar1.Color := clSkyBlue;
    lazOffice2007Silver          : LazToolbar1.Color := clWhite;
    lazOffice2007SilverTurquoise : LazToolbar1.Color := clWhite;
    lazMetroLight                : LazToolbar1.Color := clSilver;
    lazMetroDark                 : LazToolbar1.Color := $080808;
  end;
  for item in StyleMenu.Items do
    item.Checked := item.Tag = ord(LazToolbar1.Style);
end;

procedure TForm1.SaveToIni;
var
  ini: TCustomIniFile;
begin
  ini := TMemIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
  try
    ini.WriteBool('MainForm', 'RibbonInterface', AcRibbonGUI.Checked);
    ini.WriteInteger('MainForm', 'RibbonStyle', ord(LazToolbar1.Style));
    ini.WriteBool('MainForm', 'ShowDialogLauncher', ShowDialogLauncherCheckbox.Checked);
    ini.WriteBool('MainForm', 'ShowMenuButton', LazToolbar1.ShowMenuButton);
    ini.WriteInteger('MainForm', 'MenuButtonStyle', ord(LazToolbar1.MenuButtonStyle));
    ini.WriteString('MainForm', 'MenuButtonCaption', LazToolbar1.MenuButtonCaption);
  finally
    ini.Free;
  end;
end;

procedure TForm1.SetUserInterface(Ribbon: boolean);
begin
  if Ribbon then begin
    Menu := nil;
    Toolbar1.Hide;
    LazToolbar1.Show;
    AcRibbonGUI.Checked := true;
  end else begin
    LazToolbar1.Hide;
    Menu := MainMenu;
    Toolbar1.Show;
    AcClassicalGUI.Checked := true;
  end;
end;

end.

