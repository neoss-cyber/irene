# Generates square favicons from the wide Irene logo (centered, white padding).
Add-Type -AssemblyName System.Drawing
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$srcPath = Join-Path $root "18012-logo_irene.png"
if (-not (Test-Path $srcPath)) { throw "Missing $srcPath" }

$src = [System.Drawing.Image]::FromFile($srcPath)
try {
    function New-SquareFavicon {
        param([int]$Side, [string]$OutPath)
        $bmp = New-Object System.Drawing.Bitmap($Side, $Side)
        $g = [System.Drawing.Graphics]::FromImage($bmp)
        try {
            $g.Clear([System.Drawing.Color]::FromArgb(255, 255, 255, 255))
            $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
            $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
            $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
            $margin = 0.88
            $scale = [Math]::Min($Side / $src.Width, $Side / $src.Height) * $margin
            $w = [int]($src.Width * $scale)
            $h = [int]($src.Height * $scale)
            $x = [int](($Side - $w) / 2)
            $y = [int](($Side - $h) / 2)
            $g.DrawImage($src, $x, $y, $w, $h)
            $bmp.Save($OutPath, [System.Drawing.Imaging.ImageFormat]::Png)
        } finally {
            $g.Dispose()
            $bmp.Dispose()
        }
    }

    New-SquareFavicon -Side 512 -OutPath (Join-Path $root "favicon-512.png")
    New-SquareFavicon -Side 192 -OutPath (Join-Path $root "android-chrome-192x192.png")
    New-SquareFavicon -Side 180 -OutPath (Join-Path $root "apple-touch-icon.png")
    New-SquareFavicon -Side 48  -OutPath (Join-Path $root "favicon-48x48.png")
    New-SquareFavicon -Side 32  -OutPath (Join-Path $root "favicon-32x32.png")
    New-SquareFavicon -Side 16  -OutPath (Join-Path $root "favicon-16x16.png")
    Write-Host "OK: favicon PNGs written."
} finally {
    $src.Dispose()
}
