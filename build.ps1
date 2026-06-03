# YEL3D — Build script (simplified: no base64, images served as files)
$base = "C:\Users\yeray\Desktop\WEBS\YEL 3D\yel-3d\project"

# Run seo.ps1 to re-apply/update SEO meta tags
$seoScript = "$base\seo.ps1"
if (Test-Path $seoScript) {
    Write-Host "Running seo.ps1..." -ForegroundColor Cyan
    & $seoScript
} else {
    Write-Host "seo.ps1 not found — skipping SEO step" -ForegroundColor Yellow
}

# Verify required files exist
$required = @(
    "index.html","tienda.html","aviso-legal.html","privacidad.html","cookies.html",
    "sitemap.xml","robots.txt",
    "assets\logo.png","assets\hero.png","assets\group-2.png","assets\og-image.png",
    "assets\productos.js",
    "assets\products\astronauta.png","assets\products\soporte-mando.png",
    "assets\products\expositor-funko.png","assets\products\spinner.png"
)
Write-Host "`nVerifying files..." -ForegroundColor Cyan
$missing = $required | Where-Object { -not (Test-Path "$base\$_") }
if ($missing) {
    Write-Host "Missing files:" -ForegroundColor Red
    $missing | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
} else {
    Write-Host "All required files present." -ForegroundColor Green
}

Write-Host "`nBuild complete." -ForegroundColor Green
