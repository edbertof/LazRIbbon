[CmdletBinding()]
param(
  [string]$SourceRoot = '',
  [string]$OutputDirectory = '',
  [string]$LazarusDir = 'C:\lazarus',
  [string]$LazBuild = '',
  [int]$CaptureDelayMs = 1500,
  [switch]$SkipBuild,
  [switch]$KeepBuildArtifacts,
  [switch]$KeepPrimaryConfigPath
)

$ErrorActionPreference = 'Stop'

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
if ([string]::IsNullOrWhiteSpace($SourceRoot)) {
  $SourceRoot = Split-Path -Parent $scriptRoot
}

$sourceItem = Get-Item -LiteralPath $SourceRoot
if (-not $sourceItem.PSIsContainer) {
  Write-Error "SourceRoot must be a directory: $SourceRoot"
  exit 2
}

$root = $sourceItem.FullName
if ([string]::IsNullOrWhiteSpace($OutputDirectory)) {
  $OutputDirectory = Join-Path $root 'docs\assets\screenshots'
}
if ([string]::IsNullOrWhiteSpace($LazBuild)) {
  $LazBuild = Join-Path $LazarusDir 'lazbuild.exe'
}
if (-not (Test-Path -LiteralPath $LazBuild)) {
  Write-Error "lazbuild not found: $LazBuild"
  exit 2
}

$primaryConfigPath = Join-Path ([System.IO.Path]::GetTempPath()) ("LazRibbon_screenshot_pcp_{0}" -f (Get-Date -Format 'yyyyMMdd_HHmmss'))

$targets = @(
  'packages\LazRibbonRuntime.lpk',
  'packages\LazRibbonDesign.lpk',
  'demos\showcase\project1.lpi',
  'demos\skins_gallery\project1.lpi',
  'tools\LazRibbonSkinEditor\LazRibbonSkinEditor.lpi'
)

$screenshots = @(
  [pscustomobject]@{
    Name = 'showcase-main.png'
    Exe = 'demos\showcase\bin\project1.exe'
    WorkDir = 'demos\showcase'
    Width = 1180
    Height = 700
    Action = ''
  },
  [pscustomobject]@{
    Name = 'showcase-backstage.png'
    Exe = 'demos\showcase\bin\project1.exe'
    WorkDir = 'demos\showcase'
    Width = 1180
    Height = 700
    Action = 'OpenBackstage'
  },
  [pscustomobject]@{
    Name = 'showcase-skins.png'
    Exe = 'demos\skins_gallery\bin\project1.exe'
    WorkDir = 'demos\skins_gallery'
    Width = 980
    Height = 520
    Action = ''
  },
  [pscustomobject]@{
    Name = 'skin-editor.png'
    Exe = 'tools\LazRibbonSkinEditor\bin\LazRibbonSkinEditor.exe'
    WorkDir = 'tools\LazRibbonSkinEditor'
    Width = 1120
    Height = 740
    Action = ''
  }
)

function Invoke-LazBuildTarget {
  param([Parameter(Mandatory = $true)][string]$RelativePath)

  $fullPath = Join-Path $root $RelativePath
  if (-not (Test-Path -LiteralPath $fullPath)) {
    Write-Error "Build target not found: $RelativePath"
    exit 2
  }

  Write-Host "BUILD $RelativePath"
  & $LazBuild "--pcp=$primaryConfigPath" "--lazarusdir=$LazarusDir" --build-all $fullPath
  if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
  }
}

function Register-LocalPackages {
  New-Item -ItemType Directory -Path $primaryConfigPath -Force | Out-Null
  foreach ($relativePackage in @('packages\LazRibbonRuntime.lpk', 'packages\LazRibbonDesign.lpk')) {
    $packagePath = Join-Path $root $relativePackage
    & $LazBuild "--pcp=$primaryConfigPath" "--lazarusdir=$LazarusDir" '--add-package-link' $packagePath
    if ($LASTEXITCODE -ne 0) {
      exit $LASTEXITCODE
    }
  }
}

function Remove-GeneratedArtifacts {
  if ($KeepBuildArtifacts) {
    return
  }

  $relativeTargets = @(
    'packagefiles.xml',
    'lib',
    'demos\showcase\bin',
    'demos\showcase\lib',
    'demos\showcase\project1.res',
    'demos\skins_gallery\bin',
    'demos\skins_gallery\lib',
    'demos\skins_gallery\project1.res',
    'tools\LazRibbonSkinEditor\bin',
    'tools\LazRibbonSkinEditor\obj',
    'tools\LazRibbonSkinEditor\LazRibbonSkinEditor.res'
  )

  foreach ($relative in $relativeTargets) {
    $path = Join-Path $root $relative
    if (Test-Path -LiteralPath $path) {
      $resolved = (Resolve-Path -LiteralPath $path).Path
      if (-not $resolved.StartsWith($root, [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "Refusing to remove outside SourceRoot: $resolved"
      }
      Remove-Item -LiteralPath $resolved -Recurse -Force
    }
  }
}

function Remove-PrimaryConfigPath {
  if ($KeepPrimaryConfigPath) {
    return
  }
  if (-not (Test-Path -LiteralPath $primaryConfigPath)) {
    return
  }

  $resolved = (Resolve-Path -LiteralPath $primaryConfigPath).Path
  $tempRoot = [System.IO.Path]::GetTempPath()
  if (-not $resolved.StartsWith($tempRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
    throw "Refusing to remove primary config path outside temp: $resolved"
  }
  Remove-Item -LiteralPath $resolved -Recurse -Force
}

Add-Type -AssemblyName System.Drawing
Add-Type @'
using System;
using System.Runtime.InteropServices;

public static class LazRibbonScreenshotWin32
{
    public delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);

    [StructLayout(LayoutKind.Sequential)]
    public struct RECT
    {
        public int Left;
        public int Top;
        public int Right;
        public int Bottom;
    }

    [DllImport("user32.dll")]
    public static extern bool GetWindowRect(IntPtr hWnd, out RECT rect);

    [DllImport("dwmapi.dll")]
    public static extern int DwmGetWindowAttribute(IntPtr hWnd, int dwAttribute, out RECT rect, int size);

    [DllImport("user32.dll")]
    public static extern bool EnumWindows(EnumWindowsProc enumProc, IntPtr lParam);

    [DllImport("user32.dll")]
    public static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint processId);

    [DllImport("user32.dll")]
    public static extern bool IsWindowVisible(IntPtr hWnd);

    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int GetWindowTextLength(IntPtr hWnd);

    [DllImport("user32.dll")]
    public static extern bool SetForegroundWindow(IntPtr hWnd);

    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);

    [DllImport("user32.dll")]
    public static extern bool MoveWindow(IntPtr hWnd, int x, int y, int width, int height, bool repaint);

    [DllImport("user32.dll")]
    public static extern bool BringWindowToTop(IntPtr hWnd);

    [DllImport("user32.dll")]
    public static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int x, int y, int width, int height, uint flags);

    [DllImport("user32.dll")]
    public static extern bool SetCursorPos(int x, int y);

    [DllImport("user32.dll")]
    public static extern void mouse_event(uint flags, uint dx, uint dy, uint data, UIntPtr extraInfo);

    public static IntPtr FindMainWindowForProcess(int processId)
    {
        IntPtr best = IntPtr.Zero;
        int bestArea = 0;

        EnumWindows(delegate(IntPtr hWnd, IntPtr lParam)
        {
            uint windowProcessId;
            GetWindowThreadProcessId(hWnd, out windowProcessId);
            if (windowProcessId != processId)
                return true;
            if (!IsWindowVisible(hWnd))
                return true;
            if (GetWindowTextLength(hWnd) <= 0)
                return true;

            RECT rect;
            if (!GetBestWindowRect(hWnd, out rect))
                return true;

            int width = Math.Max(0, rect.Right - rect.Left);
            int height = Math.Max(0, rect.Bottom - rect.Top);
            int area = width * height;
            if (area > bestArea)
            {
                bestArea = area;
                best = hWnd;
            }
            return true;
        }, IntPtr.Zero);

        return best;
    }

    public static bool GetBestWindowRect(IntPtr hWnd, out RECT rect)
    {
        const int DWMWA_EXTENDED_FRAME_BOUNDS = 9;

        try
        {
            if (DwmGetWindowAttribute(hWnd, DWMWA_EXTENDED_FRAME_BOUNDS, out rect, Marshal.SizeOf(typeof(RECT))) == 0)
                return true;
        }
        catch
        {
        }

        return GetWindowRect(hWnd, out rect);
    }
}
'@

function Get-MainWindowHandle {
  param([Parameter(Mandatory = $true)][System.Diagnostics.Process]$Process)

  for ($attempt = 0; $attempt -lt 80; $attempt++) {
    $Process.Refresh()
    $handle = [LazRibbonScreenshotWin32]::FindMainWindowForProcess($Process.Id)
    if ($handle -ne [IntPtr]::Zero) {
      return $handle
    }
    if ($Process.MainWindowHandle -ne [IntPtr]::Zero) {
      return $Process.MainWindowHandle
    }
    Start-Sleep -Milliseconds 250
  }

  throw "Window was not created by process $($Process.Id)."
}

function Get-WindowRectangle {
  param([Parameter(Mandatory = $true)][IntPtr]$Handle)

  $rect = New-Object LazRibbonScreenshotWin32+RECT
  if (-not [LazRibbonScreenshotWin32]::GetBestWindowRect($Handle, [ref]$rect)) {
    throw "Could not read window rectangle for handle $Handle."
  }
  return $rect
}

function Show-WindowForCapture {
  param(
    [Parameter(Mandatory = $true)][IntPtr]$Handle,
    [Parameter(Mandatory = $true)][int]$Width,
    [Parameter(Mandatory = $true)][int]$Height
  )

  $hwndTopMost = [IntPtr](-1)
  $swpShowWindow = 0x0040

  [LazRibbonScreenshotWin32]::ShowWindow($Handle, 9) | Out-Null
  [LazRibbonScreenshotWin32]::SetWindowPos($Handle, $hwndTopMost, 40, 40, $Width, $Height, $swpShowWindow) | Out-Null
  [LazRibbonScreenshotWin32]::BringWindowToTop($Handle) | Out-Null
  [LazRibbonScreenshotWin32]::SetForegroundWindow($Handle) | Out-Null
}

function Click-WindowPoint {
  param(
    [Parameter(Mandatory = $true)][IntPtr]$Handle,
    [Parameter(Mandatory = $true)][int]$X,
    [Parameter(Mandatory = $true)][int]$Y
  )

  $rect = Get-WindowRectangle -Handle $Handle
  $screenX = $rect.Left + $X
  $screenY = $rect.Top + $Y
  [LazRibbonScreenshotWin32]::SetForegroundWindow($Handle) | Out-Null
  [LazRibbonScreenshotWin32]::SetCursorPos($screenX, $screenY) | Out-Null
  [LazRibbonScreenshotWin32]::mouse_event(0x0002, 0, 0, 0, [UIntPtr]::Zero)
  [LazRibbonScreenshotWin32]::mouse_event(0x0004, 0, 0, 0, [UIntPtr]::Zero)
}

function Save-WindowScreenshot {
  param(
    [Parameter(Mandatory = $true)][IntPtr]$Handle,
    [Parameter(Mandatory = $true)][string]$Path
  )

  $rect = Get-WindowRectangle -Handle $Handle
  $width = [Math]::Max(1, $rect.Right - $rect.Left)
  $height = [Math]::Max(1, $rect.Bottom - $rect.Top)
  $bitmap = New-Object System.Drawing.Bitmap($width, $height)
  $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
  try {
    $graphics.CopyFromScreen($rect.Left, $rect.Top, 0, 0, (New-Object System.Drawing.Size($width, $height)))
    $bitmap.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)
  }
  finally {
    $graphics.Dispose()
    $bitmap.Dispose()
  }
}

function Capture-ApplicationScreenshot {
  param(
    [Parameter(Mandatory = $true)][pscustomobject]$Spec
  )

  $exePath = Join-Path $root $Spec.Exe
  $workDir = Join-Path $root $Spec.WorkDir
  if (-not (Test-Path -LiteralPath $exePath)) {
    Write-Error "Screenshot executable not found: $($Spec.Exe)"
    exit 2
  }

  $process = Start-Process -FilePath $exePath -WorkingDirectory $workDir -PassThru
  try {
    $handle = Get-MainWindowHandle -Process $process
    Show-WindowForCapture -Handle $handle -Width $Spec.Width -Height $Spec.Height
    Start-Sleep -Milliseconds $CaptureDelayMs

    if ($Spec.Action -eq 'OpenBackstage') {
      Click-WindowPoint -Handle $handle -X 36 -Y 50
      Start-Sleep -Milliseconds $CaptureDelayMs
    }

    Show-WindowForCapture -Handle $handle -Width $Spec.Width -Height $Spec.Height
    Start-Sleep -Milliseconds 250

    $path = Join-Path $OutputDirectory $Spec.Name
    Save-WindowScreenshot -Handle $handle -Path $path
    Write-Host "CAPTURED $($Spec.Name)"
  }
  finally {
    if ($null -ne $process -and -not $process.HasExited) {
      $process.CloseMainWindow() | Out-Null
      if (-not $process.WaitForExit(2000)) {
        $process.Kill()
        $process.WaitForExit()
      }
    }
  }
}

try {
  New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null

  if (-not $SkipBuild) {
    Register-LocalPackages
    foreach ($target in $targets) {
      Invoke-LazBuildTarget -RelativePath $target
    }
  }

  foreach ($screenshot in $screenshots) {
    Capture-ApplicationScreenshot -Spec $screenshot
  }

  Write-Host "Release screenshots written to $OutputDirectory"
}
finally {
  Remove-GeneratedArtifacts
  Remove-PrimaryConfigPath
}
