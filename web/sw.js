/* ZOZ Trenažér – service worker
   Umožňuje instalaci na plochu telefonu a spuštění i bez signálu.
   Verzi zvyš při každé nové verzi index.html, ať se lidem stáhne. */
const VERSION = 'zoz-v23';
const SHELL   = 'shell-' + VERSION;
const RUNTIME = 'runtime-' + VERSION;

const SHELL_FILES = [
  './',
  './index.html',
  './config.js',
  './manifest.webmanifest',
  './icon-192.png',
  './icon-512.png',
  './icon-512-maskable.png',
  './apple-touch-icon.png'
];

self.addEventListener('install', e => {
  e.waitUntil(
    caches.open(SHELL)
      // cache:'reload' = obejít HTTP cache prohlížeče, jinak by se do offline kopie mohla uložit stará verze
      .then(c => Promise.allSettled(SHELL_FILES.map(f => c.add(new Request(f, {cache: 'reload'})))))
      .then(() => self.skipWaiting())
  );
});

self.addEventListener('activate', e => {
  e.waitUntil(
    caches.keys()
      .then(ks => Promise.all(ks.filter(k => k !== SHELL && k !== RUNTIME).map(k => caches.delete(k))))
      .then(() => self.clients.claim())
  );
});

self.addEventListener('message', e => {
  if (e.data === 'skipWaiting') self.skipWaiting();
});

self.addEventListener('fetch', e => {
  const req = e.request;
  if (req.method !== 'GET') return;

  const url = new URL(req.url);

  // Supabase (přihlášení, data, statistiky) – vždy jen ze sítě, nikdy z cache
  if (url.hostname.endsWith('.supabase.co') || url.hostname.endsWith('.supabase.in')) return;

  // Navigace (otevření aplikace) – nejdřív síť, při výpadku z cache
  if (req.mode === 'navigate') {
    e.respondWith(
      // vždy čerstvé HTML ze serveru (hosting ani prohlížeč ho nesmí podstrčit z cache)
      fetch(req, {cache: 'no-store'})
        .then(res => {
          const copy = res.clone();
          caches.open(SHELL).then(c => c.put('./index.html', copy));
          return res;
        })
        .catch(() => caches.match('./index.html').then(r => r || caches.match('./')))
    );
    return;
  }

  // Nastavení – nejdřív síť, ať se změna klíče projeví hned; offline z cache
  if (url.origin === location.origin && /\/config\.js$/.test(url.pathname)) {
    e.respondWith(
      fetch(req, {cache: 'no-store'})
        .then(res => {
          const copy = res.clone();
          caches.open(SHELL).then(c => c.put(req, copy));
          return res;
        })
        .catch(() => caches.match(req))
    );
    return;
  }

  // Vlastní soubory (ikony, manifest) – nejdřív cache
  if (url.origin === location.origin) {
    e.respondWith(
      caches.match(req).then(hit => hit || fetch(req).then(res => {
        const copy = res.clone();
        caches.open(SHELL).then(c => c.put(req, copy));
        return res;
      }))
    );
    return;
  }

  // Knihovny a písma z CDN – z cache, na pozadí se obnoví
  if (/(^|\.)jsdelivr\.net$|(^|\.)gstatic\.com$|(^|\.)googleapis\.com$/.test(url.hostname)) {
    e.respondWith(
      caches.match(req).then(hit => {
        const net = fetch(req).then(res => {
          const copy = res.clone();
          caches.open(RUNTIME).then(c => c.put(req, copy));
          return res;
        }).catch(() => hit);
        return hit || net;
      })
    );
  }
});
