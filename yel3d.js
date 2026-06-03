/* ============================================================
   YEL3D — interactions
   ============================================================ */
(function(){
  "use strict";
  const reduce = window.matchMedia('(prefers-reduced-motion:reduce)').matches;
  const fine   = window.matchMedia('(hover:hover) and (pointer:fine)').matches;

  /* ---------- NAV scroll state ---------- */
  const nav = document.querySelector('.nav');
  const onScroll = ()=>{ if(nav) nav.classList.toggle('scrolled', window.scrollY>14); };
  onScroll(); window.addEventListener('scroll', onScroll, {passive:true});

  /* ---------- Mobile drawer ---------- */
  const drawer = document.getElementById('drawer');
  const scrim  = document.getElementById('scrim');
  const openBtn= document.getElementById('hamburger');
  const closeBtn=document.getElementById('drawerClose');
  const setDrawer=(open)=>{
    if(!drawer) return;
    drawer.classList.toggle('open',open);
    scrim.classList.toggle('open',open);
    document.body.style.overflow = open?'hidden':'';
  };
  openBtn && openBtn.addEventListener('click',()=>setDrawer(true));
  closeBtn&& closeBtn.addEventListener('click',()=>setDrawer(false));
  scrim   && scrim.addEventListener('click',()=>setDrawer(false));
  drawer  && drawer.querySelectorAll('a').forEach(a=>a.addEventListener('click',()=>setDrawer(false)));

  /* ---------- Scroll reveal (stagger children) ---------- */
  const io = new IntersectionObserver((entries)=>{
    entries.forEach(e=>{
      if(e.isIntersecting){ e.target.classList.add('in'); io.unobserve(e.target); }
    });
  },{threshold:0.12, rootMargin:'0px 0px -8% 0px'});

  document.querySelectorAll('[data-reveal-group]').forEach(group=>{
    [...group.children].forEach((child,i)=>{
      child.classList.add('reveal');
      child.style.transitionDelay = Math.min(i*0.09,0.7)+'s';
      io.observe(child);
    });
  });
  document.querySelectorAll('.reveal:not([data-reveal-group] > *)').forEach(el=>io.observe(el));

  /* ---------- Custom cursor (lerp) ---------- */
  if(fine && !reduce){
    document.body.classList.add('cursor-on');
    const ring=document.createElement('div'); ring.className='cursor';
    const dot =document.createElement('div'); dot.className='cursor-dot';
    document.body.append(ring,dot);
    let mx=innerWidth/2,my=innerHeight/2,rx=mx,ry=my;
    addEventListener('mousemove',e=>{mx=e.clientX;my=e.clientY;dot.style.transform=`translate(${mx}px,${my}px) translate(-50%,-50%)`;});
    (function loop(){
      rx+=(mx-rx)*0.15; ry+=(my-ry)*0.15;
      ring.style.transform=`translate(${rx}px,${ry}px) translate(-50%,-50%)`;
      requestAnimationFrame(loop);
    })();
    const grow=()=>ring.classList.add('grow'), shrink=()=>ring.classList.remove('grow');
    const bind=()=>document.querySelectorAll('a,button,.card,.cat-card,.prod-card,.soc,.pill').forEach(el=>{
      el.addEventListener('mouseenter',grow); el.addEventListener('mouseleave',shrink);
    });
    bind(); window.__yelBindCursor=bind;
  }

  /* ---------- Hero particle field ---------- */
  const field=document.getElementById('particles');
  if(field && !reduce){
    const glyphs=['⭐','💜','💛','💗','🌸','✨','🔷','🟣','💎','🩷'];
    const N=20;
    for(let i=0;i<N;i++){
      const s=document.createElement('span');
      s.className='particle';
      s.textContent=glyphs[Math.floor(Math.random()*glyphs.length)];
      const size=14+Math.random()*26;
      s.style.left=Math.random()*100+'%';
      s.style.top=Math.random()*100+'%';
      s.style.fontSize=size+'px';
      s.style.opacity=(0.35+Math.random()*0.5).toFixed(2);
      const dur=(4+Math.random()*5).toFixed(2);
      s.style.animationDuration=dur+'s';
      s.style.animationDelay=(-Math.random()*dur)+'s';
      s.style.setProperty('--drift',(Math.random()*40-20).toFixed(0)+'px');
      s.style.setProperty('--rot',(Math.random()*60-30).toFixed(0)+'deg');
      field.appendChild(s);
    }
  }
})();
