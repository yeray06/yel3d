# YEL3D — SEO Build Script
# Aplica mejoras SEO a los 5 HTML + crea sitemap.xml y robots.txt
$ErrorActionPreference = "Stop"
$base   = "C:\Users\yeray\Desktop\WEBS\YEL 3D\yel-3d\project"
$domain = "https://yel3d.es"   # <<< cambia por tu dominio real

# ── Helper: builds canonical + OG + Twitter block ──────────────────────────
function Meta-Block([string]$url, [string]$title, [string]$desc,
                    [string]$ogType="website", [string]$imgAlt="YEL3D",
                    [string]$robots="index, follow") {
    $img = "$domain/assets/og-image.png"
    return @"
<link rel="canonical" href="$url">
<meta name="robots" content="$robots">
<meta name="theme-color" content="#C8B4FF">
<meta name="author" content="YEL3D">
<!-- Open Graph / Facebook -->
<meta property="og:type" content="$ogType">
<meta property="og:site_name" content="YEL3D">
<meta property="og:locale" content="es_ES">
<meta property="og:title" content="$title">
<meta property="og:description" content="$desc">
<meta property="og:url" content="$url">
<meta property="og:image" content="$img">
<meta property="og:image:width" content="1200">
<meta property="og:image:height" content="630">
<meta property="og:image:alt" content="$imgAlt">
<!-- Twitter Card -->
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="$title">
<meta name="twitter:description" content="$desc">
<meta name="twitter:image" content="$img">
<link rel="sitemap" type="application/xml" href="/sitemap.xml">
"@
}

# ── Helper: replaces title + description + inserts meta block ───────────────
function Patch-Page($html, $oldTitle, $newTitle, $oldDesc, $newDesc, $metaBlock, $schemaJson="") {
    # Title
    $html = $html.Replace("<title>$oldTitle</title>", "<title>$newTitle</title>")
    # Description (replace and append the full meta block right after)
    $newDescTag = "<meta name=`"description`" content=`"$newDesc`">`n$metaBlock"
    $html = $html.Replace("<meta name=`"description`" content=`"$oldDesc`">", $newDescTag)
    # Schema JSON-LD (inject just before </body>)
    if ($schemaJson -ne "") {
        $html = $html.Replace("</body>", "$schemaJson`n</body>")
    }
    return $html
}

# ════════════════════════════════════════════════════════════════════════════
# 1. INDEX.HTML
# ════════════════════════════════════════════════════════════════════════════
Write-Host "Patching index.html..." -ForegroundColor Cyan

$indexTitle    = "YEL3D | Impresiones 3D Personalizadas en España"
$indexDesc     = "Impresiones 3D personalizadas en España. Juguetes, accesorios gaming, expositores Funko Pop, regalos únicos y decoración. Pedido por WhatsApp. Entrega en 3-5 días."
$indexMeta = Meta-Block "$domain/" $indexTitle $indexDesc "website" "YEL3D — Impresiones 3D Personalizadas en España"

$schemaLD = @'
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@graph": [
    {
      "@type": "WebSite",
      "@id": "https://yel3d.es/#website",
      "name": "YEL3D",
      "url": "https://yel3d.es",
      "description": "Impresiones 3D personalizadas en España",
      "inLanguage": "es-ES"
    },
    {
      "@type": "LocalBusiness",
      "@id": "https://yel3d.es/#business",
      "name": "YEL3D",
      "alternateName": "YEL 3D",
      "description": "Negocio de impresión 3D personalizada en España. Fabricamos juguetes articulados, accesorios gaming, expositores de colección, regalos personalizados, decoración para el hogar y fidgets. Capa a capa, con pasión.",
      "url": "https://yel3d.es",
      "logo": {
        "@type": "ImageObject",
        "url": "https://yel3d.es/assets/logo.png",
        "width": 512,
        "height": 512
      },
      "image": "https://yel3d.es/assets/logo.png",
      "telephone": "+34647893973",
      "email": "impresiones.YEL3D@gmail.com",
      "address": {
        "@type": "PostalAddress",
        "addressCountry": "ES"
      },
      "areaServed": {
        "@type": "Country",
        "name": "España"
      },
      "priceRange": "€-€€",
      "currenciesAccepted": "EUR",
      "hasOfferCatalog": {
        "@type": "OfferCatalog",
        "name": "Catálogo YEL3D",
        "url": "https://yel3d.es/tienda.html"
      },
      "sameAs": [
        "https://www.instagram.com/impresiones.yel3d",
        "https://www.tiktok.com/@yel3d",
        "https://www.facebook.com/share/1EE1cpjG7h/"
      ],
      "contactPoint": {
        "@type": "ContactPoint",
        "contactType": "customer support",
        "telephone": "+34647893973",
        "email": "impresiones.YEL3D@gmail.com",
        "areaServed": "ES",
        "availableLanguage": "Spanish"
      },
      "knowsAbout": [
        "Impresión 3D", "Fabricación aditiva", "Personalización de objetos",
        "Juguetes impresos en 3D", "Accesorios gaming", "Expositores Funko Pop",
        "Regalos personalizados", "Decoración para el hogar", "Fidgets"
      ]
    }
  ]
}
</script>
'@

$html = [IO.File]::ReadAllText("$base\index.html", [Text.Encoding]::UTF8)
$html = Patch-Page $html `
    "YEL3D — Ideas que cobran vida en 3D" $indexTitle `
    "Impresiones 3D personalizadas: juguetes, accesorios gaming, expositores de colección, regalos, decoración y fidgets. Hecho con pasión." `
    $indexDesc $indexMeta $schemaLD
[IO.File]::WriteAllText("$base\index.html", $html, [Text.Encoding]::UTF8)
Write-Host "  index.html ✓" -ForegroundColor Green

# ════════════════════════════════════════════════════════════════════════════
# 2. TIENDA.HTML
# ════════════════════════════════════════════════════════════════════════════
Write-Host "Patching tienda.html..." -ForegroundColor Cyan

$tiendaTitle = "Tienda Impresiones 3D | Juguetes, Gaming, Regalos | YEL3D"
$tiendaDesc  = "Catálogo de impresiones 3D personalizadas en España. Figuras articuladas, soportes gaming, expositores Funko Pop, cajitas regalo y maceteros. Desde 5,99€. Pedido por WhatsApp."
$tiendaMeta  = Meta-Block "$domain/tienda.html" $tiendaTitle $tiendaDesc "website" "Tienda YEL3D — Impresiones 3D"

$tiendaSchema = @'
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "ItemList",
  "name": "Catálogo YEL3D — Impresiones 3D",
  "description": "Catálogo completo de piezas impresas en 3D personalizables",
  "url": "https://yel3d.es/tienda.html",
  "numberOfItems": 12,
  "itemListElement": [
    {"@type":"ListItem","position":1,"name":"Figura articulada astronauta","url":"https://yel3d.es/tienda.html#juguetes"},
    {"@type":"ListItem","position":2,"name":"Torre apilamiento bebé","url":"https://yel3d.es/tienda.html#juguetes"},
    {"@type":"ListItem","position":3,"name":"Soporte mando PS5/Xbox","url":"https://yel3d.es/tienda.html#gaming"},
    {"@type":"ListItem","position":4,"name":"Rack auriculares gaming","url":"https://yel3d.es/tienda.html#gaming"},
    {"@type":"ListItem","position":5,"name":"Expositor Funko Pop 3 niveles","url":"https://yel3d.es/tienda.html#colecciones"},
    {"@type":"ListItem","position":6,"name":"Vitrina cartas trading","url":"https://yel3d.es/tienda.html#colecciones"},
    {"@type":"ListItem","position":7,"name":"Cajita corazón personalizada","url":"https://yel3d.es/tienda.html#regalos"},
    {"@type":"ListItem","position":8,"name":"Marco fotos 3D relieve","url":"https://yel3d.es/tienda.html#regalos"},
    {"@type":"ListItem","position":9,"name":"Macetero geométrico","url":"https://yel3d.es/tienda.html#hogar"},
    {"@type":"ListItem","position":10,"name":"Organizador escritorio","url":"https://yel3d.es/tienda.html#hogar"},
    {"@type":"ListItem","position":11,"name":"Spinner tri-blade","url":"https://yel3d.es/tienda.html#fidget"},
    {"@type":"ListItem","position":12,"name":"Pop-it sensorial","url":"https://yel3d.es/tienda.html#fidget"}
  ]
}
</script>
'@

$html = [IO.File]::ReadAllText("$base\tienda.html", [Text.Encoding]::UTF8)
$html = Patch-Page $html `
    "Catálogo — YEL3D" $tiendaTitle `
    "Catálogo YEL3D: juguetes, gaming, colección, regalos, hogar y fidgets impresos en 3D y personalizables." `
    $tiendaDesc $tiendaMeta $tiendaSchema
[IO.File]::WriteAllText("$base\tienda.html", $html, [Text.Encoding]::UTF8)
Write-Host "  tienda.html ✓" -ForegroundColor Green

# ════════════════════════════════════════════════════════════════════════════
# 3. AVISO-LEGAL.HTML
# ════════════════════════════════════════════════════════════════════════════
Write-Host "Patching aviso-legal.html..." -ForegroundColor Cyan

$avisoTitle = "Aviso Legal | YEL3D — Impresiones 3D en España"
$avisoDesc  = "Aviso legal de YEL3D: datos del titular, actividad de impresión 3D personalizada, propiedad intelectual y condiciones de uso del sitio web."
$avisoMeta  = Meta-Block "$domain/aviso-legal.html" $avisoTitle $avisoDesc "website" "Aviso Legal — YEL3D" "index, follow"

$avisoSchema = @'
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebPage",
  "name": "Aviso Legal",
  "url": "https://yel3d.es/aviso-legal.html",
  "isPartOf": {"@id": "https://yel3d.es/#website"},
  "breadcrumb": {
    "@type": "BreadcrumbList",
    "itemListElement": [
      {"@type":"ListItem","position":1,"name":"Inicio","item":"https://yel3d.es/"},
      {"@type":"ListItem","position":2,"name":"Aviso Legal","item":"https://yel3d.es/aviso-legal.html"}
    ]
  }
}
</script>
'@

$html = [IO.File]::ReadAllText("$base\aviso-legal.html", [Text.Encoding]::UTF8)
$html = Patch-Page $html `
    "Aviso Legal — YEL3D" $avisoTitle `
    "Información legal sobre YEL3D: titular, actividad, propiedad intelectual y condiciones de uso." `
    $avisoDesc $avisoMeta $avisoSchema
[IO.File]::WriteAllText("$base\aviso-legal.html", $html, [Text.Encoding]::UTF8)
Write-Host "  aviso-legal.html ✓" -ForegroundColor Green

# ════════════════════════════════════════════════════════════════════════════
# 4. PRIVACIDAD.HTML
# ════════════════════════════════════════════════════════════════════════════
Write-Host "Patching privacidad.html..." -ForegroundColor Cyan

$privTitle = "Política de Privacidad | YEL3D — Impresiones 3D en España"
$privDesc  = "Política de privacidad de YEL3D. Gestionamos tus datos para pedidos de impresión 3D. Sin formularios ni cookies de terceros. Cumplimiento RGPD."
$privMeta  = Meta-Block "$domain/privacidad.html" $privTitle $privDesc "website" "Política de Privacidad — YEL3D" "index, follow"

$privSchema = @'
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebPage",
  "name": "Política de Privacidad",
  "url": "https://yel3d.es/privacidad.html",
  "isPartOf": {"@id": "https://yel3d.es/#website"},
  "breadcrumb": {
    "@type": "BreadcrumbList",
    "itemListElement": [
      {"@type":"ListItem","position":1,"name":"Inicio","item":"https://yel3d.es/"},
      {"@type":"ListItem","position":2,"name":"Política de Privacidad","item":"https://yel3d.es/privacidad.html"}
    ]
  }
}
</script>
'@

$html = [IO.File]::ReadAllText("$base\privacidad.html", [Text.Encoding]::UTF8)
$html = Patch-Page $html `
    "Política de Privacidad — YEL3D" $privTitle `
    "Política de privacidad de YEL3D: qué datos recogemos, para qué los usamos y cómo ejercer tus derechos." `
    $privDesc $privMeta $privSchema
[IO.File]::WriteAllText("$base\privacidad.html", $html, [Text.Encoding]::UTF8)
Write-Host "  privacidad.html ✓" -ForegroundColor Green

# ════════════════════════════════════════════════════════════════════════════
# 5. COOKIES.HTML
# ════════════════════════════════════════════════════════════════════════════
Write-Host "Patching cookies.html..." -ForegroundColor Cyan

$cookTitle = "Política de Cookies | YEL3D — Impresiones 3D en España"
$cookDesc  = "Política de cookies de YEL3D. Solo usamos cookies técnicas propias, sin publicidad ni rastreo. Sin banner necesario. Información completa sobre las cookies del sitio."
$cookMeta  = Meta-Block "$domain/cookies.html" $cookTitle $cookDesc "website" "Política de Cookies — YEL3D" "index, follow"

$cookSchema = @'
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebPage",
  "name": "Política de Cookies",
  "url": "https://yel3d.es/cookies.html",
  "isPartOf": {"@id": "https://yel3d.es/#website"},
  "breadcrumb": {
    "@type": "BreadcrumbList",
    "itemListElement": [
      {"@type":"ListItem","position":1,"name":"Inicio","item":"https://yel3d.es/"},
      {"@type":"ListItem","position":2,"name":"Política de Cookies","item":"https://yel3d.es/cookies.html"}
    ]
  }
}
</script>
'@

$html = [IO.File]::ReadAllText("$base\cookies.html", [Text.Encoding]::UTF8)
$html = Patch-Page $html `
    "Política de Cookies — YEL3D" $cookTitle `
    "Política de cookies de YEL3D: solo usamos cookies técnicas propias, sin publicidad ni rastreo." `
    $cookDesc $cookMeta $cookSchema
[IO.File]::WriteAllText("$base\cookies.html", $html, [Text.Encoding]::UTF8)
Write-Host "  cookies.html ✓" -ForegroundColor Green

# ════════════════════════════════════════════════════════════════════════════
# 6. SITEMAP.XML
# ════════════════════════════════════════════════════════════════════════════
Write-Host "Creating sitemap.xml..." -ForegroundColor Cyan

$today = (Get-Date -Format "yyyy-MM-dd")
$sitemap = @"
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">

  <url>
    <loc>https://yel3d.es/</loc>
    <lastmod>$today</lastmod>
    <changefreq>monthly</changefreq>
    <priority>1.0</priority>
  </url>

  <url>
    <loc>https://yel3d.es/tienda.html</loc>
    <lastmod>$today</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.9</priority>
  </url>

  <url>
    <loc>https://yel3d.es/aviso-legal.html</loc>
    <lastmod>$today</lastmod>
    <changefreq>yearly</changefreq>
    <priority>0.2</priority>
  </url>

  <url>
    <loc>https://yel3d.es/privacidad.html</loc>
    <lastmod>$today</lastmod>
    <changefreq>yearly</changefreq>
    <priority>0.2</priority>
  </url>

  <url>
    <loc>https://yel3d.es/cookies.html</loc>
    <lastmod>$today</lastmod>
    <changefreq>yearly</changefreq>
    <priority>0.2</priority>
  </url>

</urlset>
"@

[IO.File]::WriteAllText("$base\sitemap.xml", $sitemap, [Text.Encoding]::UTF8)
Write-Host "  sitemap.xml ✓" -ForegroundColor Green

# ════════════════════════════════════════════════════════════════════════════
# 7. ROBOTS.TXT
# ════════════════════════════════════════════════════════════════════════════
Write-Host "Creating robots.txt..." -ForegroundColor Cyan

$robots = @"
User-agent: *
Allow: /

Disallow: /build.ps1
Disallow: /seo.ps1

Sitemap: https://yel3d.es/sitemap.xml
"@

[IO.File]::WriteAllText("$base\robots.txt", $robots, [Text.Encoding]::UTF8)
Write-Host "  robots.txt ✓" -ForegroundColor Green

Write-Host "`nSEO build completado." -ForegroundColor Cyan
