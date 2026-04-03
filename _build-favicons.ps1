# Generates square favicons from the Irene logo: crops bottom location line, then
# composites on white and exports sizes (multiples of 48px where possible).
Add-Type -AssemblyName System.Drawing
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$srcPath = Join-Path $root "18012-logo_irene.png"
if (-not (Test-Path $srcPath)) { throw "Missing $srcPath" }

$srcFull = [System.Drawing.Image]::FromFile($srcPath)
try {
    # Drop bottom strip ("ACHARAVI - CORFU") so "Irene" + bar scale larger in the favicon.
    $cropH = [int]([Math]::Ceiling($srcFull.Height * 0.78))
    $cropRect = New-Object System.Drawing.Rectangle(0, 0, $srcFull.Width, $cropH)
    $src = $srcFull.Clone($cropRect, $srcFull.PixelFormat)
    try {
        function New-MasterSquare {
            param([int]$Side)
            $bmp = New-Object System.Drawing.Bitmap($Side, $Side)
            $g = [System.Drawing.Graphics]::FromImage($bmp)
            try {
                $g.Clear([System.Drawing.Color]::FromArgb(255, 255, 255, 255))
                $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
                $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
                $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
                $margin = 0.93
                $scale = [Math]::Min($Side / $src.Width, $Side / $src.Height) * $margin
                $w = [int]($src.Width * $scale)
                $h = [int]($src.Height * $scale)
                $x = [int](($Side - $w) / 2)
                $y = [int](($Side - $h) / 2)
                $g.DrawImage($src, $x, $y, $w, $h)
                return $bmp
            } finally {
                $g.Dispose()
            }
        }

        function Save-Resized {
            param([System.Drawing.Bitmap]$Master, [int]$Side, [string]$OutPath)
            $out = New-Object System.Drawing.Bitmap($Side, $Side)
            $g = [System.Drawing.Graphics]::FromImage($out)
            try {
                $g.Clear([System.Drawing.Color]::FromArgb(255, 255, 255, 255))
                $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
                $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
                $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
                $g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
                $g.DrawImage($Master, 0, 0, $Side, $Side)
            } finally {
                $g.Dispose()
            }
            try {
                $out.Save($OutPath, [System.Drawing.Imaging.ImageFormat]::Png)
            } finally {
                $out.Dispose()
            }
        }

        $master512 = New-MasterSquare -Side 512
        try {
            Save-Resized -Master $master512 -Side 512 -OutPath (Join-Path $root "favicon-512.png")
            Save-Resized -Master $master512 -Side 192 -OutPath (Join-Path $root "android-chrome-192x192.png")
            Save-Resized -Master $master512 -Side 180 -OutPath (Join-Path $root "apple-touch-icon.png")
            Save-Resized -Master $master512 -Side 144 -OutPath (Join-Path $root "favicon-144x144.png")
            Save-Resized -Master $master512 -Side 96  -OutPath (Join-Path $root "favicon-96x96.png")
            Save-Resized -Master $master512 -Side 48  -OutPath (Join-Path $root "favicon-48x48.png")
            Save-Resized -Master $master512 -Side 32  -OutPath (Join-Path $root "favicon-32x32.png")
            Save-Resized -Master $master512 -Side 16  -OutPath (Join-Path $root "favicon-16x16.png")
        } finally {
            $master512.Dispose()
        }
        Write-Host "OK: favicon PNGs written."
    } finally {
        $src.Dispose()
    }
} finally {
    $srcFull.Dispose()
}
