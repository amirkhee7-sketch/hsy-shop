Add-Type -AssemblyName System.Drawing

$srcPath = "C:\Users\amirk\.gemini\antigravity\scratch\hsy-shop\assets\logo_raw.jpg"
$dstPath = "C:\Users\amirk\.gemini\antigravity\scratch\hsy-shop\assets\logo.png"

$img = [System.Drawing.Image]::FromFile($srcPath)
Write-Output "Dimensions: $($img.Width)x$($img.Height)"

# The circle is in the middle horizontally, and slightly below center vertically.
# Let's find the bounding box of white/bright pixels in the center.
$bmp = New-Object System.Drawing.Bitmap($img)

$minX = $img.Width
$maxX = 0
$minY = $img.Height
$maxY = 0

for ($y = [int]($img.Height * 0.2); $y -lt [int]($img.Height * 0.8); $y += 2) {
    for ($x = 0; $x -lt $img.Width; $x += 2) {
        $pixel = $bmp.GetPixel($x, $y)
        # Check if pixel is predominantly white (the background circle)
        if ($pixel.R -gt 230 -and $pixel.G -gt 230 -and $pixel.B -gt 230) {
            if ($x -lt $minX) { $minX = $x }
            if ($x -gt $maxX) { $maxX = $x }
            if ($y -lt $minY) { $minY = $y }
            if ($y -gt $maxY) { $maxY = $y }
        }
    }
}

Write-Output "Detected Circle Bounding Box: X=[$minX, $maxX], Y=[$minY, $maxY]"
$w = $maxX - $minX
$h = $maxY - $minY
Write-Output "Size: ${w}x${h}"

# Create cropped square image with transparent background or high quality png
$size = [Math]::Max($w, $h)
$cropBmp = New-Object System.Drawing.Bitmap($size, $size)
$g = [System.Drawing.Graphics]::FromImage($cropBmp)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

$srcRect = New-Object System.Drawing.Rectangle($minX, $minY, $w, $h)
$dstRect = New-Object System.Drawing.Rectangle(0, 0, $size, $size)

$g.DrawImage($img, $dstRect, $srcRect, [System.Drawing.GraphicsUnit]::Pixel)
$cropBmp.Save($dstPath, [System.Drawing.Imaging.ImageFormat]::Png)

$g.Dispose()
$cropBmp.Dispose()
$bmp.Dispose()
$img.Dispose()

Write-Output "Cropped logo saved to $dstPath"
