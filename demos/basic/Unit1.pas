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

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, LazRibbon_Core, StdCtrls, ExtCtrls, ActnList, Menus, LazRibbon_Tabs, LazRibbon_Groups,
  ImgList, LazRibbon_BaseItem, LazRibbon_Buttons, LazRibbon_Checkboxes, LazRibbon_Popup;

type

  { TForm2 }

  TForm2 = class(TForm)
    ActionList1: TActionList;
    Action1: TAction;
    CUsersSpookDokumenty1: TMenuItem;
    DDokumenty1: TMenuItem;
    LargeImages: TImageList;
    Images: TImageList;
    PopupMenu1: TLazRibbonPopupMenu;
    PopupMenu2: TLazRibbonPopupMenu;
    Recent11: TMenuItem;
    Recent21: TMenuItem;
    Recent31: TMenuItem;
    LazCheckbox1: TLazRibbonCheckbox;
    LazCheckbox2: TLazRibbonCheckbox;
    LazPane7: TLazRibbonPane;
    LazTab3: TLazRibbonTab;
    LazToolbar1: TLazRibbon;
    LazTab1: TLazRibbonTab;
    LazPane2: TLazRibbonPane;
    LazSmallButton2: TLazRibbonSmallButton;
    LazSmallButton3: TLazRibbonSmallButton;
    LazSmallButton4: TLazRibbonSmallButton;
    LazLargeButton4: TLazRibbonLargeButton;
    LazPane3: TLazRibbonPane;
    LazSmallButton1: TLazRibbonSmallButton;
    LazSmallButton5: TLazRibbonSmallButton;
    LazSmallButton6: TLazRibbonSmallButton;
    LazSmallButton7: TLazRibbonSmallButton;
    LazSmallButton8: TLazRibbonSmallButton;
    LazPane4: TLazRibbonPane;
    LazSmallButton10: TLazRibbonSmallButton;
    LazLargeButton5: TLazRibbonLargeButton;
    LazSmallButton9: TLazRibbonSmallButton;
    LazTab2: TLazRibbonTab;
    LazPane5: TLazRibbonPane;
    LazLargeButton6: TLazRibbonLargeButton;
    LazLargeButton7: TLazRibbonLargeButton;
    LazLargeButton8: TLazRibbonLargeButton;
    LazPane1: TLazRibbonPane;
    LazLargeButton1: TLazRibbonLargeButton;
    LazLargeButton2: TLazRibbonLargeButton;
    LazLargeButton3: TLazRibbonLargeButton;
    LazPane6: TLazRibbonPane;
    LazSmallButton11: TLazRibbonSmallButton;
    LazSmallButton12: TLazRibbonSmallButton;
    LazSmallButton13: TLazRibbonSmallButton;
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LazCheckbox1Click(Sender: TObject);
    procedure LazCheckbox2Click(Sender: TObject);
    procedure LazPane2DialogLauncherClick(Sender: TObject);
    procedure LazPane3DialogLauncherClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.lfm}

procedure TForm2.Button2Click(Sender: TObject);

var i,j,k : integer;                              
    Item : TLazRibbonSmallButton;
    Pane : TLazRibbonPane;
    Tab : TLazRibbonTab;

begin
LazToolbar1.BeginUpdate;

for i := 0 to 20 do
    Tab:=LazToolbar1.Tabs.add;

for k := 0 to 6 do
    begin
    Pane:=LazTab1.Panes.Add;
    for j := 0 to 2 do
        begin
        Item:=Pane.Items.AddSmallButton;
        Item.TableBehaviour:=tbBeginsRow;
        //Item.GroupBehaviour:=gbBeginsGroup;
        Item.ShowCaption:=false;
        Item.ImageIndex:=random(50);
        //Item.DropdownMenu:=PopupMenu1;

        for i := 0 to 4 do
            begin
            Item:=Pane.Items.AddSmallButton;
            Item.ShowCaption:=false;
            Item.ImageIndex:=random(50);
            //Item.GroupBehaviour:=gbContinuesGroup;
            //Item.DropdownMenu:=PopupMenu1;
            end;

        Item:=Pane.Items.AddSmallButton;
        Item.TableBehaviour:=tbContinuesRow;
        //Item.GroupBehaviour:=gbEndsGroup;
        Item.ShowCaption:=false;
        Item.ImageIndex:=random(50);
        //Item.DropdownMenu:=PopupMenu1;
        end;
    end;

LazToolbar1.EndUpdate;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  //
end;

procedure TForm2.FormShow(Sender: TObject);
begin
  LazCheckbox1.Checked := LazToolbar1.ShowMenuButton;
  if (LazToolbar1.MenuButtonStyle = mbsCaption) then
    LazCheckbox2.Checked := false
  else
    LazCheckbox2.Checked := true;
end;

procedure TForm2.LazCheckbox1Click(Sender: TObject);
begin
  LazToolbar1.ShowMenuButton := not LazToolbar1.ShowMenuButton;
  LazCheckbox1.Checked := LazToolbar1.ShowMenuButton;
end;

procedure TForm2.LazCheckbox2Click(Sender: TObject);
begin
  if (LazToolbar1.MenuButtonStyle = mbsCaption) then
    LazToolbar1.MenuButtonStyle := mbsCaptionDropdown
  else
    LazToolbar1.MenuButtonStyle := mbsCaption;

  if (LazToolbar1.MenuButtonStyle = mbsCaption) then
    LazCheckbox2.Checked := false
  else
    LazCheckbox2.Checked := true;
end;

procedure TForm2.LazPane2DialogLauncherClick(Sender: TObject);
begin
  ShowMessage('You clicked on ''Dialog launcher'' button of the File pane.');
end;

procedure TForm2.LazPane3DialogLauncherClick(Sender: TObject);
begin
  ShowMessage('You clicked on ''Dialog launcher'' button of the Edit pane.');
end;

end.
