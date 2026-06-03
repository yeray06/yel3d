# Elimina base64 de los 5 HTML — reemplaza por rutas relativas
$base  = "C:\Users\yeray\Desktop\WEBS\YEL 3D\yel-3d\project"
$b64   = 'data:image/png;base64,[A-Za-z0-9+/=]+'

function Fix-Common($html) {
    # Logos (class="logo-mark") — 3 veces por archivo
    $html = $html -replace "(class=""logo-mark"" src="")$b64("")", '${1}assets/logo.png${2}'
    # OG / Twitter image meta
    $html = $html -replace "(property=""og:image"" content="")$b64("")", '${1}assets/og-image.png${2}'
    $html = $html -replace "(name=""twitter:image"" content="")$b64("")", '${1}assets/og-image.png${2}'
    return $html
}

# ── index.html ────────────────────────────────────────────────────────────────
Write-Host "index.html..." -ForegroundColor Cyan
$f = "$base\index.html"
$h = [IO.File]::ReadAllText($f, [Text.Encoding]::UTF8)
$h = Fix-Common $h
# Imágenes por clase CSS
$h = $h -replace "(class=""hero-img"" src="")$b64("")",  '${1}assets/hero.png${2}'
$h = $h -replace "(class=""about-img"" src="")$b64("")", '${1}assets/group-2.png${2}'
# Productos (featured section) — por alt text
$h = $h -replace "(src="")$b64("" alt=""Figura astronauta impresa en 3D"")",    '${1}assets/products/astronauta.png${2}'
$h = $h -replace "(src="")$b64("" alt=""Soporte de mando PS5/Xbox"")",           '${1}assets/products/soporte-mando.png${2}'
$h = $h -replace "(src="")$b64("" alt=""Expositor de Funko Pop de 3 niveles"")", '${1}assets/products/expositor-funko.png${2}'
$h = $h -replace "(src="")$b64("" alt=""Spinner tri-blade pastel"")",             '${1}assets/products/spinner.png${2}'
[IO.File]::WriteAllText($f, $h, [Text.Encoding]::UTF8)
Write-Host "  OK ($([math]::Round((Get-Item $f).Length/1KB))KB)"

# ── tienda.html ───────────────────────────────────────────────────────────────
Write-Host "tienda.html..." -ForegroundColor Cyan
$f = "$base\tienda.html"
$h = [IO.File]::ReadAllText($f, [Text.Encoding]::UTF8)
$h = Fix-Common $h
$h = $h -replace "(src="")$b64("" alt=""Figura articulada astronauta"")",           '${1}assets/products/astronauta.png${2}'
$h = $h -replace "(src="")$b64("" alt=""Torre de apilamiento para beb[eé]"")",      '${1}assets/products/torre-apilamiento.png${2}'
$h = $h -replace "(src="")$b64("" alt=""Soporte de mando PS5 / Xbox"")",             '${1}assets/products/soporte-mando.png${2}'
$h = $h -replace "(src="")$b64("" alt=""Rack para auriculares gaming"")",             '${1}assets/products/rack-auriculares.png${2}'
$h = $h -replace "(src="")$b64("" alt=""Expositor de Funko Pop de 3 niveles"")",     '${1}assets/products/expositor-funko.png${2}'
$h = $h -replace "(src="")$b64("" alt=""Vitrina para cartas trading"")",              '${1}assets/products/vitrina-cartas.png${2}'
$h = $h -replace "(src="")$b64("" alt=""Cajita coraz[oó]n personalizada con lazo"")",'${1}assets/products/cajita-corazon.png${2}'
$h = $h -replace "(src="")$b64("" alt=""Macetero geom[eé]trico facetado"")",         '${1}assets/products/macetero-geometrico.png${2}'
$h = $h -replace "(src="")$b64("" alt=""Spinner tri-blade pastel"")",                 '${1}assets/products/spinner.png${2}'
[IO.File]::WriteAllText($f, $h, [Text.Encoding]::UTF8)
Write-Host "  OK ($([math]::Round((Get-Item $f).Length/1KB))KB)"

# ── Páginas legales (solo logo + og:image) ────────────────────────────────────
foreach ($name in @("aviso-legal.html","privacidad.html","cookies.html")) {
    Write-Host "$name..." -ForegroundColor Cyan
    $f = "$base\$name"
    $h = [IO.File]::ReadAllText($f, [Text.Encoding]::UTF8)
    $h = Fix-Common $h
    [IO.File]::WriteAllText($f, $h, [Text.Encoding]::UTF8)
    Write-Host "  OK ($([math]::Round((Get-Item $f).Length/1KB))KB)"
}

Write-Host "`nBase64 eliminada de los 5 archivos." -ForegroundColor Green
