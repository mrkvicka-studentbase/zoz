#!/usr/bin/env python3
"""Návěstní atlas: vytáhne z D1.pdf návěsti (název, vzhled, význam, obrázek) do web/navesti.json.

Spuštění z kořene repozitáře:  python3 web/tools/navesti.py      (potřebuje: pip install pymupdf)
Každá návěst je v D1 odstavec „(n) Název“ tučně, pod ním kurzívou vzhled, odrážky s významem
a vpravo obrázek. Bere se jen z článků s návěstmi (viz ROZSAHY); schémata přes celou šířku
stránky se vynechávají. Při nové verzi D1 vyměň D1.pdf, spusť znovu a zkontroluj výpis."""
import base64, json, pathlib, re, sys, collections
import pymupdf

ROOT = pathlib.Path(__file__).resolve().parents[2]
PDF, OUT = ROOT / 'D1.pdf', ROOT / 'web' / 'navesti.json'
ROZSAHY = [((62, 74), 'Výhybky a výkolejky'), ((80, 99), 'Značení a doplňky hlavních návěstidel'),
    ((102, 115), 'Hlavní návěstidla'), ((116, 123), 'Předvěsti, indikátory a upozorňovadla'),
    ((138, 142), 'Přivolávací návěst'), ((144, 165), 'Návěsti speciálního určení'), ((166, 173), 'Návěsti na vozidlech'),
    ((174, 177), 'Traťová rychlost'), ((178, 182), 'Pomalá jízda'), ((183, 186), 'Varovná návěstidla'),
    ((187, 190), 'Vlakový zabezpečovač a ETCS'), ((204, 205), 'Změny parametrů dráhy'), ((213, 227), 'Posun'),
    ((247, 247), 'Posun'), ((352, 352), 'Jízda vlaku'), ((364, 364), 'Výprava vlaku'), ((395, 403), 'Elektrický provoz'),
    ((404, 412), 'Přejezdy'), ((500, 512), 'Dočasně ponechaná návěstidla')]
def kategorie(n):
    for (a, b), k in ROZSAHY:
        if a <= n <= b: return k
MAXW = 170          # širší obrázky jsou schémata, ne návěst
doc = pymupdf.open(str(PDF))
meta = {'ucinnost': ''}
m = re.search(r'účinnost od ([^\n]+)', doc[0].get_text() + doc[1].get_text())
if m: meta['ucinnost'] = m.group(1).strip()
entries, clanek, cur, pend = [], (0, ''), None, None
for pi in range(len(doc)):
    p = doc[pi]; lines = []
    for b in p.get_text('dict')['blocks']:
        if b['type'] != 0: continue
        for l in b['lines']:
            sp = [s for s in l['spans'] if s['text'].strip() and s['size'] >= 6.5]   # bez horních indexů poznámek
            if sp: lines.append((sp[0]['bbox'][1], sp))
    lines.sort(key=lambda t: t[0]); rows = []
    for y, sp in lines:   # spojit části jednoho řádku (číslo odstavce je o pár bodů níž než název)
        if rows and abs(rows[-1][0] - y) <= 4: rows[-1][1].extend(sp)
        else: rows.append([y, list(sp)])
    for r in rows: r[1].sort(key=lambda s: s['bbox'][0])
    for y, sp in rows:
        if y < 50 or y > 790: continue
        txt = ''
        for k, s_ in enumerate(sp):   # mezera mezi částmi řádku podle jejich vzdálenosti (kurzíva „Stůj“ + „ na…“)
            if k and not txt.endswith(' ') and not s_['text'].startswith(' ') and s_['bbox'][0] - sp[k - 1]['bbox'][2] > 1.2: txt += ' '
            txt += s_['text']
        txt = re.sub(r'\s+', ' ', txt).strip()
        if re.fullmatch(r'článek \d+', txt): pend = int(txt.split()[1]); continue
        if pend is not None: clanek = (pend, txt); pend = None; cur = None; continue
        num = re.match(r'^\((\d+)\)$', sp[0]['text'].strip())
        if num and len(sp) > 1 and 'Bold' in sp[1]['font']:
            bold = [s for s in sp[1:] if 'Bold' in s['font']]
            cur = {'page': pi + 1, 'y': y, 'cl': clanek, 'odst': int(num.group(1)),
                   'name': re.sub(r'\s+', ' ', ' '.join(s['text'].strip() for s in bold)).strip(), 'popis': '', 'body': [], 'imgs': []}
            entries.append(cur); continue
        if cur is None: continue
        if num: cur = None; continue
        if all('Bold' in s['font'] for s in sp) and not cur['popis'] and not cur['body'] and cur['page'] == pi + 1 and y - cur['y'] < 14:
            cur['name'] += ' ' + txt; continue
        if all('Italic' in s['font'] for s in sp) and not cur['body']:
            cur['popis'] += (' ' if cur['popis'] else '') + txt; continue
        if txt.startswith('•') or not cur['body']: cur['body'].append(txt.lstrip('•').strip())
        else: cur['body'][-1] += ('' if re.search(r'\w-$', cur['body'][-1]) else ' ') + txt
    here = [e for e in entries if e['page'] == pi + 1]
    prev = entries[-len(here) - 1] if len(entries) > len(here) else None
    for im in p.get_image_info(xrefs=True):
        x0, y0, x1, y1 = im['bbox']; cy = (y0 + y1) / 2
        if x1 - x0 < 6 or y1 - y0 < 6 or x1 - x0 > MAXW: continue
        owner = None
        for e in here:
            if e['y'] - 12 <= cy: owner = e
        # varianta návěsti přetekla na další stranu (obrázek nad prvním odstavcem stránky)
        if owner is None and prev and prev['page'] == pi and prev['imgs']: owner = prev
        if owner: owner['imgs'].append((pi, (x0, y0, x1, y1)))
# „J ízda“, „D olním“ – rozdělené iniciály v PDF (ne jednopísmenná slova V, K, S, Z, O, U, A, I)
fix = lambda t: re.sub(r'(\w) -(?=\w)', r'\1-', re.sub(r'(^|\s)([BCDEFGHJLMNPRTWČŘŠŽ]) (?=[a-záčďéěíňóřšťúůýž]{2,})', r'\1\2', re.sub(r'\s+', ' ', t or ''))).strip()
items, seen = [], collections.Counter()
for e in entries:
    k = kategorie(e['cl'][0])
    if not k or not e['imgs']: continue
    pics = []
    for pi, (x0, y0, x1, y1) in e['imgs'][:4]:
        clip = pymupdf.Rect(x0 - 1.5, y0 - 1.5, x1 + 1.5, y1 + 1.5)
        zoom = min(3, 180 / clip.height, 220 / clip.width)       # max ~180 px na výšku (ostré i na mobilu, malý soubor)
        pix = doc[pi].get_pixmap(matrix=pymupdf.Matrix(zoom, zoom), clip=clip, alpha=False)
        png, jpg = pix.tobytes('png'), pix.tobytes('jpg', jpg_quality=78)
        pics.append(('data:image/png;base64,' + base64.b64encode(png).decode()) if len(png) <= len(jpg) * 1.15 else ('data:image/jpeg;base64,' + base64.b64encode(jpg).decode()))
    body = [fix(b) for b in e['body'] if b.strip()]
    base = f"d1-{e['cl'][0]}-{e['odst']}"; seen[base] += 1
    items.append({'id': base + (f"-{seen[base]}" if seen[base] > 1 else ''), 'nazev': fix(e['name']).rstrip(':'), 'vzhled': fix(e['popis']),
        'vyznam': body, 'kat': k, 'cl': e['cl'][0], 'clanek': e['cl'][1], 'odst': e['odst'], 'str': e['page'], 'img': pics})
data = {'zdroj': 'SŽ D1 Dopravní a návěstní předpis', 'meta': meta, 'kategorie': [k for _, k in ROZSAHY if k in {i['kat'] for i in items}], 'navesti': items}
data['kategorie'] = list(dict.fromkeys(data['kategorie']))
OUT.write_text(json.dumps(data, ensure_ascii=False, separators=(',', ':')), encoding='utf-8')
print(f"{len(items)} návěstí, {sum(len(i['img']) for i in items)} obrázků, {OUT.stat().st_size // 1024} kB → {OUT.relative_to(ROOT)}")
print(dict(collections.Counter(i['kat'] for i in items)))
