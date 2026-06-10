unit LazRibbon_Const;

{$mode delphi}

(*******************************************************************************
*                                                                              *
*  File:        LazRibbon_Const.pas                                                 *
*  Description: Constants for calculation of toolbar geometry                  *
*  Copyright:   (c) 2009 by Spook.                                             *
*  License:     Modified LGPL (with linking exception, like Lazarus LCL)       *
*               See "license.txt" in this installation                         *
*                                                                              *
*******************************************************************************)

interface

uses
  Graphics, LCLVersion;

const
  SPK_DPI_AWARE = true;

procedure LazInitLayoutConsts(FromDPI: Integer; ToDPI: Integer = 0);
function LazScaleX(Size: Integer; FromDPI: Integer; ToDPI: Integer = 0): integer;
function LazScaleY(Size: Integer; FromDPI: Integer; ToDPI: Integer = 0): integer;

const
  // ****************
  // *** Elements ***
  // ****************
  LARGEBUTTON_DROPDOWN_FIELD_SIZE = 29;
  LARGEBUTTON_GLYPH_MARGIN = 3;
  LARGEBUTTON_CAPTION_HMARGIN = 3;
  LARGEBUTTON_MIN_WIDTH = 24;
  LARGEBUTTON_RADIUS = 4;
  LARGEBUTTON_BORDER_SIZE = 2;
  LARGEBUTTON_CHEVRON_VMARGIN = 2;
  LARGEBUTTON_CAPTION_TOP_RAIL = 45;
  LARGEBUTTON_CAPTION_BOTTOM_RAIL = 58;
  LARGEBUTTON_SEPARATOR_WIDTH = 9;
  LARGEBUTTON_SEPARATOR_TOP_MARGIN = 4;
  LARGEBUTTON_SEPARATOR_BOTTOM_MARGIN = 4;

  SMALLBUTTON_GLYPH_WIDTH = 16;
  SMALLBUTTON_BORDER_WIDTH = 2;
  SMALLBUTTON_HALF_BORDER_WIDTH = 1;
  SMALLBUTTON_PADDING = 4;  // was: 2
  SMALLBUTTON_DROPDOWN_WIDTH = 11;
  SMALLBUTTON_RADIUS = 4;
  SMALLBUTTON_SEPARATOR_WIDTH = 9;
  SMALLBUTTON_SEPARATOR_TOP_MARGIN = 2;
  SMALLBUTTON_SEPARATOR_BOTTOM_MARGIN = 2;

  TOGGLESWITCH_WIDTH = 40;
  TOGGLESWITCH_HEIGHT = 20;
  TOGGLESWITCH_RADIUS = 4;

  DROPDOWN_ARROW_WIDTH = 8;
  DROPDOWN_ARROW_HEIGHT = 8;

  // ***********************
  // *** Tab page layout ***
  // ***********************
  /// <summary>Maximum area height that can be used by an element</summary>
  MAX_ELEMENT_HEIGHT = 67;

  /// <summary>Maximum row height</summary>
  PANE_ROW_HEIGHT = 22;

  /// <summary>Single row top margin</summary>
  PANE_ONE_ROW_TOPPADDING = 22;
  /// <summary>Single row bottom margin</summary>
  PANE_ONE_ROW_BOTTOMPADDING = 23;

  /// <summary>Space between rows in a double row layout</summary>
  PANE_TWO_ROWS_VSPACER = 7;
  /// <summary>Double row layout top margin</summary>
  PANE_TWO_ROWS_TOPPADDING = 8;
  /// <summary>Double row layout bottom margin</summary>
  PANE_TWO_ROWS_BOTTOMPADDING = 8;

  /// <summary>Space between rows in triple row layout</summary>
  PANE_THREE_ROWS_VSPACER = 0;
  /// <summary>Triple row layout top margin</summary>
  PANE_THREE_ROWS_TOPPADDING = 0;
  /// <summary>Triple row layout bottom margin</summary>
  PANE_THREE_ROWS_BOTTOMPADDING = 1;

  /// <summary>Pane left padding, space between left pane border and left element border</summary>
  PANE_LEFT_PADDING = 2;
  /// <summary>Pane right padding, space between right pane border and right element border</summary>
  PANE_RIGHT_PADDING = 2;
  /// <summary>Space between two columns inside the pane</summary>
  PANE_COLUMN_SPACER = 4;
  /// <summary>Space between groups on a row in pane</summary>
  PANE_GROUP_SPACER = 4;

  // *******************
  // *** Pane layout ***
  // *******************
  /// <summary>Pane caption height</summary>
  PANE_CAPTION_HEIGHT = 15;
  /// <summary>Pane corner radius</summary>
  PANE_CORNER_RADIUS = 3;
  /// <summary>Pane border size.</summary>
  /// <remarks>Do not change?</remarks>
  PANE_BORDER_SIZE = 2;
  /// <summary>Half width of pane border?</summary>
  /// <remarks>Do not change?</remarks>
  PANE_BORDER_HALF_SIZE = 1;
  /// <summary>Pane caption horizontal padding</summary>
  PANE_CAPTION_HMARGIN = 6;
  // Pane 'More options' button width
  PANE_MOREOPTIONSBUTTON_WIDTH = 15;

  // ************
  // *** Tabs ***
  // ************
  /// <summary>Tab corner radius</summary>
  TAB_CORNER_RADIUS = 4;
  /// <summary>Tab page left margin</summary>
  TAB_PANE_LEFTPADDING = 2;
  /// <summary>Tab page right margin</summary>
  TAB_PANE_RIGHTPADDING = 2;
  /// <summary>Tab page top margin</summary>
  TAB_PANE_TOPPADDING = 2;
  /// <summary>Tab page bottom margin</summary>
  TAB_PANE_BOTTOMPADDING = 1;
  /// <summary>Space between panes</summary>
  TAB_PANE_HSPACING = 3;
  /// <summary>Tab border size</summary>
  TAB_BORDER_SIZE = 1;


  // *******************
  // *** Menu button ***
  // *******************
  /// <summary>Menu button corner radius</summary>
  MENUBUTTON_CORNER_RADIUS = 4;
  /// <summary>Menu button minimum width</summary>
  MENUBUTTON_MIN_WIDTH = 32;


  // ***************
  // *** Toolbar ***
  // ***************
  /// <summary>Pane padding?</summary>
  TOOLBAR_BORDER_WIDTH = 1;
  TOOLBAR_CORNER_RADIUS = 0;  //was: 3;
  /// <summary>Tab caption height: -1 = automatic</summary>
  TOOLBAR_TAB_CAPTIONS_HEIGHT = -1;  // was: 22;
  /// <summary>Tab caption horizontal padding</summary>
  TOOLBAR_TAB_CAPTIONS_TEXT_HPADDING = 4;
  /// <summary>Min tab caption width</summary>
  TOOLBAR_MIN_TAB_CAPTION_WIDTH = 32;


  // *********************
  // *** Dropdown menu ***
  // *********************
  DROPDOWN_MENU_MARGIN = 3;
  DROPDOWN_SELECTION_RADIUS = 4;

var
  // ****************
  // *** Elements ***
  // ****************
  LargeButtonDropdownFieldSize: Integer;
  LargeButtonGlyphMargin: Integer;
  LargeButtonCaptionHMargin: Integer;
  LargeButtonMinWidth: Integer;
  LargeButtonRadius: Integer;
  LargeButtonBorderSize: Integer;
  LargeButtonChevronVMargin: Integer;
  LargeButtonCaptionTopRail: Integer;
  LargeButtonCaptionButtomRail: Integer;
  LargeButtonSeparatorWidth: Integer;
  LargeButtonSeparatorTopMargin: Integer;
  LargeButtonSeparatorBottomMargin: Integer;

  SmallButtonGlyphWidth: Integer;
  SmallButtonBorderWidth: Integer;
  SmallButtonHalfBorderWidth: Integer;
  SmallButtonPadding: Integer;
  SmallButtonDropdownWidth: Integer;
  SmallButtonRadius: Integer;
  SmallButtonMinWidth: Integer;
  SmallButtonSeparatorWidth: Integer;
  SmallButtonSeparatorTopMargin: Integer;
  SmallButtonSeparatorBottomMargin: Integer;

  ToggleSwitchWidth: Integer;
  ToggleSwitchHeight: Integer;
  ToggleSwitchRadius: Integer;

  DropdownArrowWidth: Integer;
  DropdownArrowHeight: Integer;


  // *********************
  // *** Dropdown menu ***
  // *********************

  DropDownMenuMargin: Integer;
  DropDownSelectionRadius: Integer;


  // ***********************
  // *** Tab page layout ***
  // ***********************

  /// <summary>Maximum area height that can be used by an element</summary>
  MaxElementHeight: Integer;

  /// <summary>Maximum row height</summary>
  PaneRowHeight: Integer;
  PaneFullRowHeight: Integer;

  /// <summary>Single row top margin</summary>
  PaneOneRowTopPadding: Integer;
  /// <summary>Single row bottom margin</summary>
  PaneOneRowBottomPadding: Integer;

  /// <summary>Space between rows in a double row layout</summary>
  PaneTwoRowsVSpacer: Integer;
  /// <summary>Double row layout top margin</summary>
  PaneTwoRowsTopPadding: Integer;
  /// <summary>Double row layout bottom margin</summary>
  PaneTwoRowsBottomPadding: Integer;

  /// <summary>Space between rows in triple row layout</summary>
  PaneThreeRowsVSpacer: Integer;
  /// <summary>Triple row layout top margin</summary>
  PaneThreeRowsTopPadding: Integer;
  /// <summary>Triple row layout bottom margin</summary>
  PaneThreeRowsBottomPadding: Integer;

  PaneFullRowTopPadding: Integer;
  PaneFullRowBottomPadding: Integer;

  /// <summary>Pane left padding, space between left pane border and left element border</summary>
  PaneLeftPadding: Integer;
  /// <summary>Pane right padding, space between right pane border and right element border</summary>
  PaneRightPadding: Integer;
  /// <summary>Space between two columns inside the pane</summary>
  PaneColumnSpacer: Integer;
  /// <summary>Space between groups on a row in pane</summary>
  PaneGroupSpacer: Integer;


  // *******************
  // *** Pane layout ***
  // *******************

  /// <summary>Pane caption height</summary>
  PaneCaptionHeight: Integer;
  /// <summary>Pane corner radius</summary>
  PaneCornerRadius: Integer;
  /// <summary>Pane border size</summary>
  /// <remarks>Do not change?</remarks>
  PaneBorderSize: Integer;
  /// <summary>Half width of pane border?</summary>
  /// <remarks>Do not change?</remarks>
  PaneBorderHalfSize: Integer;
  /// <summary>Height of pane</summary>
  PaneHeight: Integer;
  /// <summary>Pane caption horizontal padding</summary>
  PaneCaptionHMargin: Integer;
  // Pane 'More options' button width
  PaneMoreOptionsButtonWidth : Integer;

  // ************
  // *** Tabs ***
  // ************

  /// <summary>Tab corner radius</summary>
  TabCornerRadius: Integer;
  /// <summary>Tab page left margin</summary>
  TabPaneLeftPadding: Integer;
  /// <summary>Tab page right margin/summary>
  TabPaneRightPadding: Integer;
  /// <summary>Tab page top margin</summary>
  TabPaneTopPadding: Integer;
  /// <summary>Tab page bottom margin</summary>
  TabPaneBottomPadding: Integer;
  /// <summary>Space between panes</summary>
  TabPaneHSpacing: Integer;
  /// <summary>Tab border size</summary>
  TabBorderSize: Integer;
  /// <summary>Tab height</summary>
  TabHeight: Integer;


  // *******************
  // *** Menu button ***
  // *******************

  /// <summary>Menu button corner radius</summary>
  MenuButtonCornerRadius: Integer;
  /// <summary>Menu button minimum width</summary>
  MenuButtonMinWidth: Integer;


// ***************
  // *** Toolbar ***
  // ***************

  /// <summary>Pane padding?</summary>
  ToolbarBorderWidth: Integer;
  ToolbarCornerRadius: Integer;
  /// <summary>Tab caption height</summary>
  ToolbarTabCaptionsHeight: Integer;
  /// <summary>Tab caption horizontal padding</summary>
  ToolbarTabCaptionsTextHPadding: Integer;
  ToolbarMinTabCaptionWidth: Integer;
  /// <summary>Toolbar total height</summary>
  //ToolbarHeight: Integer;


implementation

uses
  LCLType;

procedure LazInitLayoutConsts(FromDPI: Integer; ToDPI: Integer = 0);
begin
  {
  if not SPK_DPI_AWARE then
    ToDPI := FromDPI;
  }

  {$IfDef Darwin}
    ToDPI := FromDPI; //macOS raster scales by itself
  {$EndIf}

  LargeButtonDropdownFieldSize := LazScaleX(LARGEBUTTON_DROPDOWN_FIELD_SIZE, FromDPI, ToDPI);
  LargeButtonGlyphMargin := LazScaleX(LARGEBUTTON_GLYPH_MARGIN, FromDPI, ToDPI);
  LargeButtonCaptionHMargin := LazScaleX(LARGEBUTTON_CAPTION_HMARGIN, FromDPI, ToDPI);
  LargeButtonMinWidth := LazScaleX(LARGEBUTTON_MIN_WIDTH, FromDPI, ToDPI);
  LargeButtonRadius := LARGEBUTTON_RADIUS;
  LargeButtonBorderSize := LazScaleX(LARGEBUTTON_BORDER_SIZE, FromDPI, ToDPI);
  LargeButtonChevronVMargin := LazScaleY(LARGEBUTTON_CHEVRON_VMARGIN, FromDPI, ToDPI);
  LargeButtonCaptionTopRail := LazScaleY(LARGEBUTTON_CAPTION_TOP_RAIL, FromDPI, ToDPI);
  LargeButtonCaptionButtomRail := LazScaleY(LARGEBUTTON_CAPTION_BOTTOM_RAIL, FromDPI, ToDPI);
  LargeButtonSeparatorWidth := LazScaleX(LARGEBUTTON_SEPARATOR_WIDTH, FromDPI, ToDPI);
  LargeButtonSeparatorTopMargin := LazScaleY(LARGEBUTTON_SEPARATOR_TOP_MARGIN, FromDPI, ToDPI);
  LargeButtonSeparatorBottomMargin := LazScaleY(LARGEBUTTON_SEPARATOR_BOTTOM_MARGIN, FromDPI, ToDPI);

  SmallButtonGlyphWidth := LazScaleX(SMALLBUTTON_GLYPH_WIDTH, FromDPI, ToDPI);
  SmallButtonBorderWidth := LazScaleX(SMALLBUTTON_BORDER_WIDTH, FromDPI, ToDPI);
  SmallButtonHalfBorderWidth := LazScaleX(SMALLBUTTON_HALF_BORDER_WIDTH, FromDPI, ToDPI);
  SmallButtonPadding := LazScaleX(SMALLBUTTON_PADDING, FromDPI, ToDPI);
  SmallButtonDropdownWidth := LazScaleX(SMALLBUTTON_DROPDOWN_WIDTH, FromDPI, ToDPI);
  SmallButtonRadius := SMALLBUTTON_RADIUS;
  SmallButtonMinWidth := 2 * SmallButtonPadding + SmallButtonGlyphWidth;
  SmallButtonSeparatorWidth := LazScaleX(SMALLButton_SEPARATOR_WIDTH, FromDPI, ToDPI);
  SmallButtonSeparatorTopMargin := LazScaleY(SMALLBUTTON_SEPARATOR_TOP_MARGIN, FromDPI, ToDPI);
  SmallButtonSeparatorBottomMargin := LazScaleY(SMALLBUTTON_SEPARATOR_BOTTOM_MARGIN, FromDPI, ToDPI);

  ToggleSwitchWidth := LazScaleX(TOGGLESWITCH_WIDTH, FromDPI, ToDPI);
  ToggleSwitchHeight := LazScaleY(TOGGLESWITCH_HEIGHT, FromDPI, ToDPI);
  ToggleSwitchRadius := TOGGLESWITCH_RADIUS;
  // other ToggleSwitch dimensions are taken from SmallButton

  DropdownArrowWidth := LazScaleX(DROPDOWN_ARROW_WIDTH, FromDPI, ToDPI);
  DropdownArrowHeight := LazScaleY(DROPDOWN_ARROW_HEIGHT, FromDPI, ToDPI);

  DropdownMenuMargin := LazScaleX(DROPDOWN_MENU_MARGIN, FromDPI, ToDpi);
  DropdownSelectionRadius := DROPDOWN_SELECTION_RADIUS;

  MaxElementHeight := LazScaleY(MAX_ELEMENT_HEIGHT, FromDPI, ToDPI);
  PaneRowHeight := LazScaleY(PANE_ROW_HEIGHT, FromDPI, ToDPI);
  PaneFullRowHeight := 3 * PaneRowHeight;
  PaneOneRowTopPadding := LazScaleY(PANE_ONE_ROW_TOPPADDING, FromDPI, ToDPI);
  PaneOneRowBottomPadding := LazScaleY(PANE_ONE_ROW_BOTTOMPADDING, FromDPI, ToDPI);
  PaneTwoRowsVSpacer := LazScaleY(PANE_TWO_ROWS_VSPACER, FromDPI, ToDPI);
  PaneTwoRowsTopPadding := LazScaleY(PANE_TWO_ROWS_TOPPADDING, FromDPI, ToDPI);
  PaneTwoRowsBottomPadding := LazScaleY(PANE_TWO_ROWS_BOTTOMPADDING, FromDPI, ToDPI);
  PaneThreeRowsVSpacer := LazScaleY(PANE_THREE_ROWS_VSPACER, FromDPI, ToDPI);
  PaneThreeRowsTopPadding := LazScaleY(PANE_THREE_ROWS_TOPPADDING, FromDPI, ToDPI);
  PaneThreeRowsBottomPadding := LazScaleY(PANE_THREE_ROWS_BOTTOMPADDING, FromDPI, ToDPI);
  PaneFullRowTopPadding := PaneThreeRowsTopPadding;
  PaneFullRowBottomPadding := PaneThreeRowsBottomPadding;
  PaneLeftPadding := LazScaleX(PANE_LEFT_PADDING, FromDPI, ToDPI);
  PaneRightPadding := LazScaleX(PANE_RIGHT_PADDING, FromDPI, ToDPI);
  PaneColumnSpacer := LazScaleX(PANE_COLUMN_SPACER, FromDPI, ToDPI);
  PaneGroupSpacer := LazScaleX(PANE_GROUP_SPACER, FromDPI, ToDPI);

  PaneCaptionHeight := LazScaleY(PANE_CAPTION_HEIGHT, FromDPI, ToDPI);
  PaneCornerRadius := PANE_CORNER_RADIUS;
  PaneBorderSize := LazScaleX(PANE_BORDER_SIZE, FromDPI, ToDPI);
  PaneBorderHalfSize := LazScaleX(PANE_BORDER_HALF_SIZE, FromDPI, ToDPI);
  PaneHeight := MaxElementHeight + PaneCaptionHeight + 2 * PaneBorderSize;
  PaneCaptionHMargin := LazScaleX(PANE_CAPTION_HMARGIN, FromDPI, ToDPI);
  PaneMoreOptionsButtonWidth := LazScaleX(PANE_MOREOPTIONSBUTTON_WIDTH, FromDPI, ToDPI);

  TabCornerRadius := TAB_CORNER_RADIUS;
  TabPaneLeftPadding := LazScaleX(TAB_PANE_LEFTPADDING, FromDPI, ToDPI);
  TabPaneRightPadding := LazScaleX(TAB_PANE_RIGHTPADDING, FromDPI, ToDPI);
  TabPaneTopPadding := LazScaleY(TAB_PANE_TOPPADDING, FromDPI, ToDPI);
  TabPaneBottomPadding := LazScaleY(TAB_PANE_BOTTOMPADDING, FromDPI, ToDPI);
  TabPaneHSpacing := LazScaleX(TAB_PANE_HSPACING, FromDPI, ToDPI);
  TabBorderSize := LazScaleX(TAB_BORDER_SIZE, FromDPI, ToDPI);
  TabHeight := PaneHeight + TabPaneTopPadding + TabPaneBottomPadding + TabBorderSize;

  MenuButtonCornerRadius := MENUBUTTON_CORNER_RADIUS;
  MenuButtonMinWidth := LazScaleX(MENUBUTTON_MIN_WIDTH, FromDPI, ToDPI);

  ToolbarBorderWidth := LazScaleX(TOOLBAR_BORDER_WIDTH, FromDPI, ToDPI);
  ToolbarCornerRadius := TOOLBAR_CORNER_RADIUS;
  ToolbarTabCaptionsHeight := TOOLBAR_TAB_CAPTIONS_HEIGHT;  // is -1
  ToolbarTabCaptionsTextHPadding := LazScaleX(TOOLBAR_TAB_CAPTIONS_TEXT_HPADDING, FromDPI, ToDPI);
  ToolbarMinTabCaptionWidth := LazScaleX(TOOLBAR_MIN_TAB_CAPTION_WIDTH, FromDPI, ToDPI);
//  ToolbarHeight := ToolbarTabCaptionsHeight + TabHeight;

  // scaling radius if not square
  if LargeButtonRadius > 1 then
    LargeButtonRadius := LazScaleX(LargeButtonRadius, FromDPI, ToDPI);

  if SmallButtonRadius > 1 then
    SmallButtonRadius := LazScaleX(SmallButtonRadius, FromDPI, ToDPI);

  if ToggleSwitchRadius > 1 then
    ToggleSwitchRadius := LazScaleX(ToggleSwitchRadius, FromDPI, ToDPI);

  if DropDownSelectionRadius > 1 then
    DropDownSelectionRadius := LazScaleX(DropDownSelectionRadius, FromDPI, ToDPI);

  if PaneCornerRadius > 1 then
    PaneCornerRadius := LazScaleX(PaneCornerRadius, FromDPI, ToDPI);

  if TabCornerRadius > 1 then
    TabCornerRadius := LazScaleX(TabCornerRadius, FromDPI, ToDPI);

  if MenuButtonCornerRadius > 1 then
    MenuButtonCornerRadius := LazScaleX(MenuButtonCornerRadius, FromDPI, ToDPI);

  if ToolbarCornerRadius > 1 then
    ToolbarCornerRadius := LazScaleX(ToolbarCornerRadius, FromDPI, ToDPI);
end;

function LazScaleX(Size: Integer; FromDPI: Integer; ToDPI: Integer): integer;
begin
  if ToDPI = 0 then
    ToDPI := ScreenInfo.PixelsPerInchX;

  if (not SPK_DPI_AWARE) or (ToDPI = FromDPI) then
    Result := Size
  else
    begin
      if (ToDPI/FromDPI <= 1.5) and (Size = 1) then
        Result := 1 //maintaining 1px on 150% scale for crispness
      else
        Result := MulDiv(Size, ToDPI, FromDPI);
    end;

end;

function LazScaleY(Size: Integer; FromDPI: Integer; ToDPI: Integer): integer;
begin
  if ToDPI = 0 then
    ToDPI := ScreenInfo.PixelsPerInchY;

  if (not SPK_DPI_AWARE) or (ToDPI = FromDPI) then
    Result := Size
  else
    begin
      if (ToDPI/FromDPI <= 1.5) and (Size = 1) then
        Result := 1 //maintaining 1px on 150% scale for crispness
      else
        Result := MulDiv(Size, ToDPI, FromDPI);
    end;

end;


initialization

{$IFDEF DEBUG}
// Sprawdzanie poprawnoœci

// £uk du¿ego przycisku
Assert(LARGEBUTTON_RADIUS * 2 <= LARGEBUTTON_DROPDOWN_FIELD_SIZE);

// Tafla, wersja z jednym wierszem
Assert(PANE_ROW_HEIGHT +
       PANE_ONE_ROW_TOPPADDING +
       PANE_ONE_ROW_BOTTOMPADDING <= MAX_ELEMENT_HEIGHT);

// Tafla, wersja z dwoma wierszami
Assert(2*PANE_ROW_HEIGHT +
       PANE_TWO_ROWS_TOPPADDING +
       PANE_TWO_ROWS_VSPACER +
       PANE_TWO_ROWS_BOTTOMPADDING <= MAX_ELEMENT_HEIGHT);

// Tafla, wersja z trzema wierszami
Assert(3*PANE_ROW_HEIGHT +
       PANE_THREE_ROWS_TOPPADDING +
       2*PANE_THREE_ROWS_VSPACER +
       PANE_THREE_ROWS_BOTTOMPADDING <= MAX_ELEMENT_HEIGHT);
{$ENDIF}

end.
