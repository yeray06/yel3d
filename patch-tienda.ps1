# Patch tienda.html: empty grid + dynamic render script
$base = "C:\Users\yeray\Desktop\WEBS\YEL 3D\yel-3d\project"
$path = "$base\tienda.html"
$html = [IO.File]::ReadAllText($path, [Text.Encoding]::UTF8)

# ── 1. Clear static product articles from grid ────────────────────────────────
# Replace everything between the grid div's opening tag and its closing </div>
# Pattern: <div class="prod-grid" id="grid">...all articles...</div>
$gridPattern = '(<div class="prod-grid" id="grid">)[\s\S]*?(</div>\s*<p class="empty")'
$html = [regex]::Replace($html, $gridPattern, '$1' + "`n    " + '$2')

# ── 2. Replace old inline script with new dynamic render + filter script ──────
$oldScript = @'
<script>
(function(){
  const grid=document.getElementById('grid');
  const cards=[...grid.querySelectorAll('.prod-card')];
  const pills=[...document.querySelectorAll('#filters .pill')];
  const empty=document.getElementById('empty');

  // Build "Comprar" links -> WhatsApp with product prefilled
  cards.forEach(c=>{
    const a=c.querySelector('.buy');
    if(a){const name=a.dataset.name;
      a.href='https://wa.me/34647893973?text='+encodeURIComponent('¡Hola YEL3D! 👋 Me interesa: '+name);}
  });

  function apply(cat){
    let shown=0;
    cards.forEach(card=>{
      const match = cat==='todos' || card.dataset.cat===cat;
      if(match){
        card.classList.remove('is-hidden','popping');
        void card.offsetWidth;            // reflow to restart animation
        card.classList.add('popping');
        shown++;
      }else{
        card.classList.add('is-hidden');
      }
    });
    empty.style.display = shown===0 ? 'block' : 'none';
  }

  pills.forEach(p=>p.addEventListener('click',()=>{
    pills.forEach(x=>x.classList.remove('active'));
    p.classList.add('active');
    apply(p.dataset.filter);
  }));

  // Deep-link from category anchors (#gaming etc.) -> preselect filter
  const hash=(location.hash||'').replace('#','');
  const cats=['juguetes','gaming','colecciones','regalos','hogar','fidget'];
  if(cats.includes(hash)){
    const pill=pills.find(p=>p.dataset.filter===hash);
    if(pill){pills.forEach(x=>x.classList.remove('active'));pill.classList.add('active');apply(hash);}
  }
})();
</script>
'@

$newScript = @'
<script src="assets/productos.js"></script>
<script>
(function(){
  'use strict';
  const WA    = 'https://wa.me/34647893973?text=';
  const COLOR = {juguetes:'t-lilac',gaming:'t-blue',colecciones:'t-yellow',regalos:'t-lilac',hogar:'t-mint',fidget:'t-pink'};
  const LABEL = {juguetes:'Juguetes',gaming:'Gaming',colecciones:'Colecciones',regalos:'Regalos',hogar:'Hogar',fidget:'Fidget'};

  // Render product cards from PRODUCTOS data
  const grid = document.getElementById('grid');
  const seenCats = new Set();
  grid.innerHTML = PRODUCTOS.map(p => {
    const firstCat = !seenCats.has(p.categoria);
    if (firstCat) seenCats.add(p.categoria);
    const thumb = p.imagen
      ? '<img src="' + p.imagen + '" alt="' + (p.alt || p.nombre) + '" loading="lazy">'
      : '<div class="ph ' + p.ph + '"><span class="ph-emoji">' + p.emoji + '</span><span class="ph-tag">foto del producto</span></div>';
    const waLink = WA + encodeURIComponent('¡Hola YEL3D! 👋 Me interesa: ' + p.nombre);
    return '<article class="prod-card ' + COLOR[p.categoria] + '" data-cat="' + p.categoria + '"' +
           (firstCat ? ' id="' + p.categoria + '"' : '') + '>' +
      '<div class="prod-thumb"><span class="cat-badge">' + LABEL[p.categoria] + '</span>' + thumb + '</div>' +
      '<div class="prod-body"><h3>' + p.nombre + '</h3><p>' + p.descripcion + '</p>' +
        '<div class="prod-foot"><span class="price">' + p.precio + '€</span>' +
          '<a href="' + waLink + '" target="_blank" rel="noopener" class="btn btn-primary btn-sm">Comprar</a>' +
        '</div></div></article>';
  }).join('\n');

  // Re-bind custom cursor to new elements
  if (window.__yelBindCursor) window.__yelBindCursor();

  // Filter logic
  const cards = [...grid.querySelectorAll('.prod-card')];
  const pills = [...document.querySelectorAll('#filters .pill')];
  const empty = document.getElementById('empty');

  function apply(cat){
    let shown = 0;
    cards.forEach(card => {
      const match = cat === 'todos' || card.dataset.cat === cat;
      if (match) {
        card.classList.remove('is-hidden','popping');
        void card.offsetWidth;
        card.classList.add('popping');
        shown++;
      } else {
        card.classList.add('is-hidden');
      }
    });
    empty.style.display = shown === 0 ? 'block' : 'none';
  }

  pills.forEach(p => p.addEventListener('click', () => {
    pills.forEach(x => x.classList.remove('active'));
    p.classList.add('active');
    apply(p.dataset.filter);
  }));

  // Deep-link from hash (#gaming, #juguetes, etc.)
  const hash = (location.hash || '').replace('#','');
  const cats = ['juguetes','gaming','colecciones','regalos','hogar','fidget'];
  if (cats.includes(hash)) {
    const pill = pills.find(p => p.dataset.filter === hash);
    if (pill) { pills.forEach(x => x.classList.remove('active')); pill.classList.add('active'); apply(hash); }
  }
})();
</script>
'@

$html = $html.Replace($oldScript, $newScript)

[IO.File]::WriteAllText($path, $html, [Text.Encoding]::UTF8)
Write-Host "tienda.html patched ($([math]::Round((Get-Item $path).Length/1KB))KB)"
