# -*- coding: utf-8 -*-
"""把 kangaroo56 舊題包的 29 題整合進 mixed/grade6 pack。

舊題包 assets/questions/mixed/kangaroo56_foundation.mixed.v1.json 從來沒有被
manifest 收錄，所以 app 讀不到這 29 題；但 test/question_bank_test.dart 有 9 個
區塊直接讀檔並用 mixed_kangaroo56_foundation_NNN 這組 id 斷言。

整合方式：
- 29 題全部標 levelStage grade6、topic mixed，直接接到 grade6 mixed pack 後面。
- id 改成與 pack 一致的 mixed_grade6_foundation_014 ~ _042（原本最大是 _013）。
  其他 pack 的 id 前綴都和檔名對齊，留著 kangaroo56 前綴會破壞這個慣例。
- source 保留原本的 provenance（reference 仍是 kangaroo56-rewrite-batchN），
  只在 notes 補一行說明來自舊題包。
- 刪掉舊檔，更新 manifest。
"""
import json, io, os

SRC = 'assets/questions/mixed/kangaroo56_foundation.mixed.v1.json'
DST = 'assets/questions/mixed/grade6_foundation.mixed.v1.json'

src = json.load(open(SRC))
dst = json.load(open(DST))
existing = {q['id'] for q in dst['questions']}
start = max(int(q['id'].rsplit('_', 1)[1]) for q in dst['questions'])
print('grade6 mixed 原本 %d 題，最大 id %03d' % (len(dst['questions']), start))

mapping = {}
for i, q in enumerate(src['questions'], start=start + 1):
    old = q['id']
    new = 'mixed_grade6_foundation_%03d' % i
    assert new not in existing, new
    mapping[old] = new
    q['id'] = new
    q['levelStage'] = 'grade6'
    q['topic'] = 'mixed'
    n = q['source'].get('notes', '')
    q['source']['notes'] = (n + ' ' if n else '') + \
        'Migrated 2026-08-29 from the standalone kangaroo56 legacy pack, which the manifest never listed.'
    # 詳解四語步數必須等長
    assert len({len(v) for v in q['solutionSteps'].values()}) == 1, new
    dst['questions'].append(q)

with io.open(DST, 'w', encoding='utf-8') as f:
    json.dump(dst, f, ensure_ascii=False, indent=2); f.write('\n')
os.remove(SRC)
json.dump(mapping, open('/tmp/kang_map.json', 'w'), ensure_ascii=False, indent=1)
print('已併入 %d 題，grade6 mixed 現在 %d 題' % (len(mapping), len(dst['questions'])))
print('已刪除', SRC)
