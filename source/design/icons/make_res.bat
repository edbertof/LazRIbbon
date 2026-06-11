@echo off
setlocal

if "%LAZRES%"=="" (
  set "LAZRES_EXE=lazres"
) else (
  set "LAZRES_EXE=%LAZRES%"
)

for %%I in (
  TLazRibbon
  TLazRibbonBackstagePage
  TLazRibbonBackstageRecentList
  TLazRibbonBackstageView
  TLazRibbonPopupMenu
  TLazRibbonSkinManager
  TLazRibbonSkinSelector
) do (
  "%LAZRES_EXE%" "%%I.lrs" "%%I.png" "%%I_150.png" "%%I_200.png"
  if errorlevel 1 exit /b 1
)
