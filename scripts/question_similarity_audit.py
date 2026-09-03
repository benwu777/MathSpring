#!/usr/bin/env python3
"""題幹相似度稽核：抓「換數字／換故事」的弱變形。

數值驗證與 schema 檢查都抓不到撞題，這是必要的第二道關卡
（見 docs/question-bank-expansion-guidelines.md 的去重規則）。

做法：把題幹去掉數字、單位與人名等表面差異後，取字元 3-gram 算 Jaccard 相似度。

用法:
  python3 scripts/question_similarity_audit.py               # 全庫兩兩比對
  python3 scripts/question_similarity_audit.py 0.45          # 自訂門檻
  python3 scripts/question_similarity_audit.py 0.45 new.txt  # 只看清單內的題（每行一個 id）
  python3 scripts/question_similarity_audit.py --candidates cand.json 0.45
  python3 scripts/question_similarity_audit.py --same-answer [門檻]
      # 同答案值 + subtopic 家族重疊 + 字面相似：抓「改寫情境之後仍是同一題」
      # 出題前先比對：cand.json 是 [{"id": "候選代號", "prompt": "題幹"}, ...]
      # 會同時比對「候選 vs 全庫」與「候選彼此」——後者最常撞
  python3 scripts/question_similarity_audit.py --tags [門檻]
      # 概念標籤完全相同 + 字面相似：抓「措辭差很大但數學同構」的題
      # 這是純文字閘門的盲點，2026-09-03 就漏放過一題
"""
import json, glob, re, sys, itertools

NOISE = re.compile(
    r'[0-9０-９]+|小[安美樂華明志雨恩芳婷陽天玉雄杰蘭梅君陶白黑平]|'
    r'[甲乙丙丁]|阿[明寶吉]|多多|妮妮|佑佑|虹虹|伶伶|玟玟|'
    r'公尺|公分|公斤|平方|單位|元|顆|個|隻|張|本|枝|塊|人|次|天|分鐘|小時|'
    r'[，。、？！：；「」（）()·⋯…]'
)

def normalize(text):
    return NOISE.sub('', text)

def grams(text, n=3):
    t = normalize(text)
    return {t[i:i + n] for i in range(max(0, len(t) - n + 1))}

def jaccard(a, b):
    if not a or not b:
        return 0.0
    return len(a & b) / len(a | b)

def overlap(a, b):
    """重疊係數：交集 / 較短的那一邊。

    Jaccard 對「同一題但一邊寫得比較囉嗦」很脆弱——聯集被長的那一邊撐大，
    分數會被稀釋。實例：arithmetic_grade4_foundation_073 與
    arithmetic_grade6_foundation_009 是同一題換數字，Jaccard 只有 0.27
    （低於 0.40 門檻而漏放），重疊係數是 0.62。
    兩個指標取大的那個當判準。
    """
    # 太短的題幹（如「兩個正方形一共有幾條邊？」）分母很小，重疊係數會虛高，
    # 這種長度下 Jaccard 本來就夠靈敏，不必再用重疊係數。
    if not a or not b or min(len(a), len(b)) < 25:
        return 0.0
    return len(a & b) / min(len(a), len(b))

def similarity(a, b):
    return max(jaccard(a, b), overlap(a, b))


def load_bank():
    """讀入全庫題目，回傳 [(id, tags, grams)]。"""
    rows = []
    for path in sorted(glob.glob('assets/questions/*/*.json')):
        with open(path) as fh:
            pack = json.load(fh)
        for q in pack['questions']:
            rows.append((q['id'], q.get('tags', []), grams(q['prompt']['zh-Hant'])))
    return rows


_TAGS_BY_ID = None


def tags_of(qid):
    global _TAGS_BY_ID
    if _TAGS_BY_ID is None:
        _TAGS_BY_ID = {r[0]: r[1] for r in load_bank()}
    return _TAGS_BY_ID[qid]


def concepts(tags):
    return frozenset(t for t in tags if t.startswith('c:'))


def tag_pair_verdict(tags_a, tags_b):
    """兩題概念標籤的關係。手法標籤（m:）不影響判定。

    disjoint  —— 沒有共同概念，數學上無關，可直接放行
    identical —— 概念完全相同，即使字面相似度低也必須人工複判
    overlap   —— 部分重疊
    """
    a, b = concepts(tags_a), concepts(tags_b)
    if not (a & b):
        return 'disjoint'
    if a == b:
        return 'identical'
    return 'overlap'


def audit_tags(threshold=0.35, report=True):
    """概念標籤完全相同、且字面相似度達門檻的配對。

    這是純文字閘門抓不到的一類：措辭差很大但數學同構。
    """
    by_concept = {}
    for qid, tags, g in load_bank():
        by_concept.setdefault(concepts(tags), []).append((qid, g))
    hits = []
    for group in by_concept.values():
        for (ia, ga), (ib, gb) in itertools.combinations(group, 2):
            sc = similarity(ga, gb)
            if sc >= threshold:
                hits.append((ia, ib, sc))
    hits.sort(key=lambda z: -z[2])
    if report:
        for ia, ib, sc in hits:
            print('%.2f  %s ↔ %s  概念標籤相同 %s'
                  % (sc, ia, ib, sorted(concepts(tags_of(ia)))))
        print('概念標籤相同且字面相似 >= %.2f 的配對：%d 組' % (threshold, len(hits)))
    return hits


def audit_same_answer(threshold=0.55, subtopic_overlap=0.5):
    """同答案值 + subtopic 家族重疊 + 字面相似的配對。

    改寫情境會壓低字面相似度。如果兩題本來就是同一題，改寫等於把重複藏起來
    而不是消除它——2026-08-28 就發生過：number_theory_grade9_032 被改寫成
    旅館房號後，相似度工具再也抓不到它和 grade7_002 是同一題（答案同為 243）。
    加上「答案值相同」這個維度，就能抓到這一類。
    """
    rows = []
    for path in sorted(glob.glob('assets/questions/*/*.json')):
        if path.endswith('manifest.json'):
            continue
        for q in json.load(open(path))['questions']:
            rows.append((q['id'], q['subtopic'], q['correctAnswer']['value'],
                         q['prompt']['zh-Hant'], grams(q['prompt']['zh-Hant'])))
    by_answer = {}
    for r in rows:
        by_answer.setdefault(r[2], []).append(r)
    hits = []
    for value, group in by_answer.items():
        for a, b in itertools.combinations(group, 2):
            ta, tb = set(a[1].split('_')), set(b[1].split('_'))
            share = len(ta & tb) / min(len(ta), len(tb))
            if share < subtopic_overlap:
                continue
            s = similarity(a[4], b[4])
            if s < threshold:
                continue
            hits.append((s, share, value, a, b))
    hits.sort(reverse=True, key=lambda z: z[0])
    for s, share, value, a, b in hits:
        print('%.2f  答案=%s  subtopic 重疊 %.2f' % (s, value, share))
        print('      %s [%s]' % (a[0], a[1]))
        print('        %s' % a[3][:76])
        print('      %s [%s]' % (b[0], b[1]))
        print('        %s' % b[3][:76])
        print()
    print('同答案值配對：%d 組（門檻 字面 %.2f / subtopic %.2f）'
          % (len(hits), threshold, subtopic_overlap))
    return hits

def audit_candidates(path, threshold):
    cands = json.load(open(path))
    bank = []
    for f in sorted(glob.glob('assets/questions/*/*.json')):
        for q in json.load(open(f))['questions']:
            bank.append((q['id'], q['levelStage'], q['subtopic'],
                         q['prompt']['zh-Hant'], grams(q['prompt']['zh-Hant'])))
    prepared = [(c['id'], c['prompt'], grams(c['prompt'])) for c in cands]
    hits = 0
    for cid, cp, cg in prepared:
        worst = max(((similarity(cg, bg), bid, bl, bs, bp) for bid, bl, bs, bp, bg in bank),
                    default=(0, '', '', '', ''))
        if worst[0] >= threshold:
            hits += 1
            print('%.2f  候選 %s' % (worst[0], cid))
            print('      %s' % cp[:88])
            print('      撞既有 %s [%s/%s]' % (worst[1], worst[2], worst[3]))
            print('      %s\n' % worst[4][:88])
    for (ia, pa, ga), (ib, pb, gb) in itertools.combinations(prepared, 2):
        s = similarity(ga, gb)
        if s >= threshold:
            hits += 1
            print('%.2f  候選 %s ↔ 候選 %s（同批互撞）' % (s, ia, ib))
            print('      %s' % pa[:88])
            print('      %s\n' % pb[:88])
    print('候選 %d 題 vs 全庫 %d 題，相似度 >= %.2f 的有 %d 筆' % (len(prepared), len(bank), threshold, hits))
    return 1 if hits else 0


def main():
    if sys.argv[1:2] == ['--tags']:
        th = float(sys.argv[2]) if len(sys.argv) > 2 else 0.35
        return 1 if audit_tags(th) else 0
    if sys.argv[1:2] == ['--same-answer']:
        hits = audit_same_answer(float(sys.argv[2]) if len(sys.argv) > 2 else 0.55)
        return 1 if hits else 0
    if len(sys.argv) > 2 and sys.argv[1] == '--candidates':
        return audit_candidates(sys.argv[2], float(sys.argv[3]) if len(sys.argv) > 3 else 0.45)
    threshold = float(sys.argv[1]) if len(sys.argv) > 1 else 0.45
    focus = None
    if len(sys.argv) > 2:
        focus = {l.strip() for l in open(sys.argv[2]) if l.strip()}

    qs = []
    for f in sorted(glob.glob('assets/questions/*/*.json')):
        for q in json.load(open(f))['questions']:
            qs.append((q['id'], q['levelStage'], q['topic'], q['subtopic'],
                       q['prompt']['zh-Hant'], grams(q['prompt']['zh-Hant'])))

    hits = []
    for (ia, la, ta, sa, pa, ga), (ib, lb, tb, sb, pb, gb) in itertools.combinations(qs, 2):
        if focus and ia not in focus and ib not in focus:
            continue
        s = similarity(ga, gb)
        if s >= threshold:
            hits.append((s, ia, la, sa, pa, ib, lb, sb, pb))

    hits.sort(reverse=True)
    for s, ia, la, sa, pa, ib, lb, sb, pb in hits:
        print('%.2f  %s [%s/%s]' % (s, ia, la, sa))
        print('      %s' % pa[:88])
        print('      %s [%s/%s]' % (ib, lb, sb))
        print('      %s' % pb[:88])
        print()
    print('比對 %d 題，相似度 >= %.2f 的配對：%d 組' % (len(qs), threshold, len(hits)))
    return 1 if hits else 0

if __name__ == '__main__':
    sys.exit(main())
