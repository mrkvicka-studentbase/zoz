#!/usr/bin/env python3
"""Sestaví web/zoz.html (artifact, bez skeletonu) a web/ZOZ_trenazer.html (samostatný soubor)."""
import json, glob, base64, os, datetime, re
ROOT = os.path.dirname(os.path.abspath(__file__))
qs = {}
for f in sorted(glob.glob(f'{ROOT}/answers/batch_*.json')):
    for q in json.load(open(f, encoding='utf-8')):
        qs[q['n']] = q
data = [qs[k] for k in sorted(qs)]
# validace
for q in data:
    for key in ('n','otazka','tema','predpis','zdroje','odpoved','plne_zneni','distraktory','jistota'):
        assert key in q, (q.get('n'), key)
    assert len(q['distraktory']) == 2, q['n']
    q.setdefault('obrazky', []); q.setdefault('poznamka', '')
imgs = {}
for q in data:
    for p in q['obrazky']:
        wp = f"{ROOT}/web/{p.replace('.png','.webp')}"
        if os.path.exists(wp):
            imgs[p] = 'data:image/webp;base64,' + base64.b64encode(open(wp,'rb').read()).decode()
build = datetime.date.today().strftime('%d.%m.%Y')
tpl = open(f'{ROOT}/web/template.html', encoding='utf-8').read()
html = tpl.replace('__DATA__', json.dumps(data, ensure_ascii=False)).replace('__IMG__', json.dumps(imgs)).replace('__BUILD__', build)
open(f'{ROOT}/web/zoz.html','w',encoding='utf-8').write(html)
full = ('<!doctype html><html lang="cs"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover">'
        '<style>:root{padding-top:env(safe-area-inset-top,0px);padding-bottom:env(safe-area-inset-bottom,0px)}[hidden]{display:none!important}</style>'
        + html.split('<title>',1)[0] + '<title>' + html.split('<title>',1)[1].split('</title>',1)[0] + '</title></head><body>' + html.split('</title>',1)[1] + '</body></html>')
open(f'{ROOT}/web/ZOZ_trenazer.html','w',encoding='utf-8').write(full)
print(f'{len(data)} otázek, {len(imgs)} obrázků, {len(html)/1e6:.2f} MB')
