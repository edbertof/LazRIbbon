# GUI demo subsystem — LazRibbon 1.1.60

The 1.1.60 pass makes every demo project a Windows GUI application by adding:

```xml
<Linking>
  <Options>
    <Win32>
      <GraphicApplication Value="True"/>
    </Win32>
  </Options>
</Linking>
```

or the equivalent `Options/Win32/GraphicApplication` node when a `Linking` section already exists.

This prevents Lazarus/FPC from generating a companion console window for demo executables on Windows. The extra console can confuse taskbar behavior during minimize/restore tests, especially when validating `TLazRibbonForm` custom chrome.

`TLazRibbonForm` also routes the custom minimize button through the native Windows `SC_MINIMIZE` system command. This is preferable to assigning only `WindowState := wsMinimized` because the custom title bar has removed the native caption while preserving the top-level taskbar window.
