#!/usr/bin/env python3
"""Vytáhne adresné zkrácené volby (PŘ GSM-R CZ, Příloha B) a místní opatření (Příloha C)
z GSMR.pdf do web/gsmr_zv.json a vloží je do aplikace mezi značky /*GSMR_ZV*/ … /*/GSMR_ZV*/.

Spuštění z kořene repozitáře:  python3 web/tools/gsmr_zv.py
Potřebuje: pip install pdfplumber
Při nové verzi PŘ GSM-R CZ stačí vyměnit GSMR.pdf a skript spustit znovu – ale výpis
zkontroluj (počty řádků na stranách), rozložení tabulek se může změnit."""
import json, re, sys, pathlib
import pdfplumber

ROOT = pathlib.Path(__file__).resolve().parents[2]
PDF = ROOT / 'GSMR.pdf'
OUT = ROOT / 'web' / 'gsmr_zv.json'
HTML = ROOT / 'web' / 'ZOZ_trenazer_web.html'

def clean(s):
    if s is None: return None
    out = ''
    for ln in str(s).split('\n'):
        ln = ln.strip()
        if not ln: continue
        if not out: out = ln
        elif re.search(r'\w-$', out): out += ln          # „Praha-\nUhříněves“
        else: out += ' ' + ln
    return re.sub(r'\s+', ' ', out).strip()

TRAT = re.compile(r'^[\d\s+A-Z]+$')
def split_trat(g):
    lines = [l.strip() for l in (g or '').split('\n') if l.strip()]
    t = []
    while lines and TRAT.match(lines[0]) and re.search(r'\d{3}', lines[0]): t.append(lines.pop(0))
    return clean(' '.join(t)), clean('\n'.join(lines))

pdf = pdfplumber.open(str(PDF))
text_all = [(p.extract_text() or '') for p in pdf.pages]
meta = {}
m = re.search(r'účinnost od ([^\n]+)', text_all[0] + text_all[1]); meta['ucinnost'] = m.group(1).strip() if m else ''
m = re.search(r've znění změny č\.\s*(\d+)\s+účinnost od ([^\n]+)', '\n'.join(text_all[13:20]))
if m: meta['zmena'] = f'změna č. {m.group(1)} od {m.group(2).strip()}'

start = next(i for i, t in enumerate(text_all) if 'Příloha B' in t and 'Adresné zkrácené volby' in t and i > 5)
endc = next(i for i, t in enumerate(text_all) if 'Příloha C' in t and 'Místní opatření' in t and i > start)
zv = []
for pi in range(start, endc + 1):
    for tb in pdf.pages[pi].extract_tables():
        rows = [r for r in tb if any(c for c in r)]
        if not rows: continue
        h = [clean(c) or '' for c in rows[0]]
        if 'ZV' in h or 'trať dle TTP /' in h:
            if h[0] in ('oblast', 'uzel'): kind = 'ppv' if h[0] == 'oblast' else 'uzel'
            else: kind = 'trat'
            rows = rows[1:]
            if rows and not (rows[0][0] or '').strip() and (rows[0][1] or '').startswith('ŽST'): rows = rows[1:]
        elif zv: kind = zv[-1]['typ']
        else: continue
        prev = {}
        for r in rows:
            if len(r) == 7: r = [r[0], r[3], r[4], r[5], r[6]]
            if len(r) != 5: print('přeskočen řádek', pi + 1, r, file=sys.stderr); continue
            g, z, pr, ob, po = r
            if g is not None and g.strip(): prev = {'g': g}
            g = prev.get('g', '')
            ob = prev.get('ob') if ob is None else ob; prev['ob'] = ob
            po = prev.get('po') if po is None else po; prev['po'] = po
            codes = re.findall(r'\d{4}', z or '')
            if not codes: continue
            rec = {'typ': kind, 'zv': codes, 'prac': clean(pr) or '', 'obvod': clean(ob) or '', 'pozn': clean(po) or '', 'str': pi + 1}
            if kind == 'trat':
                rec['trat'], rec['usek'] = split_trat(g)
            else:
                rec['skup'] = clean(g)
            zv.append(rec)

# Příloha C – místní opatření: bloky podle nadpisů, uvnitř odrážky / číslované kroky
lines = '\n'.join(text_all[endc:]).split('\n')
HEAD = re.compile(r'^([A-Z]\)\s+)?(Místní opatření|Uložení|Opatření místního|Používání ZV)')
ITEM = re.compile(r'^(•|-\s|\d{1,2}\.\s|Poznámka|Kontakty|výpravčí (ŽST|na trati)|ve směru jízdy|V uvedeném úseku)')
def oblast_nm(s):
    s = re.sub(r'^C\.?\s?\d\.?\s+', '', s).lower()
    s = s[0].upper() + s[1:]
    return re.sub(r'\b(čechy|morava|moravy|slezsko)\b', lambda m: m.group(1).capitalize(), s)
blocks, oblast, cur, inhead = [], '', None, False
for ln in lines:
    s = ln.strip()
    if not s or s.startswith('PŘ GSM-R CZ') or s.startswith('ve znění změny') or re.fullmatch(r'\d{1,2}', s) or s in ('Příloha C', 'Místní opatření pro provoz sítě GSM-R CZ'): continue
    if re.match(r'^C\.?\s?\d\.?\s+OBVOD', s): oblast = oblast_nm(s); cur = None; continue
    if HEAD.match(s):
        cur = {'oblast': oblast, 'nadpis': re.sub(r'^[A-Z]\)\s+', '', s), 'body': []}; blocks.append(cur); inhead = not s.endswith(':')
        cur['nadpis'] = cur['nadpis'].rstrip(':'); continue
    if cur is None: continue
    if inhead and not ITEM.match(s):
        cur['nadpis'] += ' ' + s.rstrip(':'); inhead = not s.endswith(':'); continue
    inhead = False
    if ITEM.match(s) or not cur['body']: cur['body'].append(s.lstrip('•').strip())
    else: cur['body'][-1] += ('' if re.search(r'\w-$', cur['body'][-1]) else ' ') + s
for b in blocks: b['body'] = [re.sub(r'\s+', ' ', x).strip() for x in b['body']]
# obecné volby (SŽ Z11, tab. K.1)
obecne = [
    {'zv': 'ZV1 · 1200', 'kdo': 'provozní dispečer'},
    {'zv': 'ZV2 · 1300', 'kdo': 'výpravčí / traťový dispečer (dílčí 13xx podle Přílohy B)'},
    {'zv': 'ZV3 · 1400', 'kdo': 'elektrodispečer'},
    {'zv': 'SKP 200', 'kdo': 'všichni strojvedoucí v oblasti (skupinové volání)'},
]
data = {'zdroj': 'PŘ GSM-R CZ – Příloha B (adresné zkrácené volby) a Příloha C (místní opatření)', 'meta': meta,
        'obecne': obecne, 'obecne_zdroj': 'SŽ Z11, příloha K, tab. K.1', 'zv': zv, 'opatreni': blocks}
OUT.write_text(json.dumps(data, ensure_ascii=False, indent=1), encoding='utf-8')
print(f'{len(zv)} zkrácených voleb, {len(blocks)} místních opatření → {OUT.relative_to(ROOT)}')
from collections import Counter
print('po stranách:', dict(Counter(r['str'] for r in zv)), '| typy:', dict(Counter(r['typ'] for r in zv)))
if HTML.exists():
    h = HTML.read_text(encoding='utf-8')
    new = '/*GSMR_ZV*/' + json.dumps(data, ensure_ascii=False, separators=(',', ':')) + '/*/GSMR_ZV*/'
    h2, n = re.subn(r'/\*GSMR_ZV\*/.*?/\*/GSMR_ZV\*/', lambda _: new, h, flags=re.S)
    if n: HTML.write_text(h2, encoding='utf-8'); print('vloženo do', HTML.relative_to(ROOT))
    else: print('v HTML chybí značka /*GSMR_ZV*/ – data nevložena', file=sys.stderr)
