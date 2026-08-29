#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""模板重複掃描：抓「換代號、換情境」的重複，這是字面比對抓不到的那一類。

為什麼需要這支工具
------------------
scripts/question_similarity_audit.py 比的是字面 3-gram。它對下面這種完全無感：

    logic_grade3_024  P 在 Q 左邊，Q 在 R 左邊，R 在 S 左邊。誰排第三個？
    logic_grade5_017  Q 在最左邊，R 在 S 左邊，S 在 T 左邊，U 在最右邊。誰排第三個？

因為代號換了、句子長度也不同，3-gram 交集很小。2026-08-29 用本工具掃全庫，
一次找出 5 個模板家族（共 26 題）與 30 組兩題配對，總共替換了 48 題——
其中沒有任何一題是字面閘門抓到的。

判準：題幹像 + 詳解也像
----------------------
只看題幹會誤殺。「求最小的正整數 n 使得…」底下可以是完全不同的數學，
正規化後題幹幾乎一樣，但那是合法的。所以本工具要求兩個條件同時成立：

    正規化題幹相似度 >= --prompt   (預設 0.55)
    正規化詳解相似度 >= --solution (預設 0.60)

題幹像但解法不同 = 合法；題幹像且解法也像 = 只換皮。

正規化做了什麼
--------------
人名 → ＠、英文字母 → ＠、數字 → №、常見單位 → ＃，再去掉標點。
這樣「甲乙丙丁」「PQRS」「MNPQR」會被視為同一件事。

用法
----
    python3 scripts/question_template_scan.py                 # 全庫，列出所有家族
    python3 scripts/question_template_scan.py --min-size 3    # 只看 3 題以上的家族
    python3 scripts/question_template_scan.py --grade 4       # 只看含 grade4 的
    python3 scripts/question_template_scan.py --prompt 0.6 --solution 0.7
"""
import argparse
import glob
import json
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from question_similarity_audit import grams, similarity  # noqa: E402

ROOT = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
                    'assets', 'questions')

# 正規化時要抹掉的實體。人名故意列窮舉而不用通用規則——題庫裡的角色名是固定
# 那幾個，列表比正規表示式精準，也不會誤傷「小數」「甲醇」這類詞。
NAMES = ['小明', '小華', '小美', '小英', '小安', '小貝', '小可', '小吉', '小威',
         '小玉', '小圓', '小方', '阿吉', '阿寶', '爸爸', '媽媽', '姐姐', '妹妹',
         '哥哥', '弟弟', '老師', '甲', '乙', '丙', '丁', '戊', '己',
         '兔子', '狐狸', '獅子', '小狗', '小貓', '小兔', '小魚', '小鳥', '熊']
UNITS = ['平方公分', '立方公分', '平方公尺', '立方公尺', '平方厘米', '立方厘米',
         '公分', '公尺', '公斤', '公升', '毫升', '厘米', '千克',
         '元', '個', '顆', '張', '隻', '人', '天', '分鐘', '小時', '秒',
         '頁', '本', '支', '枝', '塊', '條', '根', '棵', '層', '次', '種',
         '歲', '度', '組', '班', '瓶', '盒', '箱']


def normalize(text):
    """抹掉代號與數值，只留句型骨架。"""
    out = text
    for name in sorted(NAMES, key=len, reverse=True):
        out = out.replace(name, '＠')
    for unit in sorted(UNITS, key=len, reverse=True):
        out = out.replace(unit, '＃')
    out = re.sub(r'[A-Za-z]', '＠', out)
    out = re.sub(r'[0-9０-９]+(?:\.[0-9]+)?', '№', out)
    out = re.sub(r'[，。、？！：；（）()「」『』]', '', out)
    out = re.sub(r'＠+', '＠', out)
    out = re.sub(r'№+', '№', out)
    return out


def load_bank():
    bank = {}
    for path in sorted(glob.glob(os.path.join(ROOT, '*', '*.json'))):
        if os.path.basename(path) == 'manifest.json':
            continue
        for q in json.load(open(path, encoding='utf-8'))['questions']:
            bank[q['id']] = q
    return bank


def grade_of(q):
    m = re.search(r'grade(\d+)', q.get('levelStage', ''))
    return int(m.group(1)) if m else 0


def main():
    ap = argparse.ArgumentParser(description='模板重複掃描（題幹與詳解都正規化後比對）')
    ap.add_argument('--prompt', type=float, default=0.55, help='正規化題幹相似度門檻（預設 0.55）')
    ap.add_argument('--solution', type=float, default=0.60, help='正規化詳解相似度門檻（預設 0.60）')
    ap.add_argument('--min-size', type=int, default=2, help='只列出這麼多題以上的家族（預設 2）')
    ap.add_argument('--grade', type=int, default=None, help='只列出含這個年級的家族')
    args = ap.parse_args()

    bank = load_bank()
    ids = list(bank)
    pg = {i: grams(normalize(bank[i]['prompt']['zh-Hant'])) for i in ids}
    sg = {i: grams(normalize(' '.join(bank[i]['solutionSteps']['zh-Hant']))) for i in ids}

    pairs = []
    for a in range(len(ids)):
        for b in range(a + 1, len(ids)):
            x, y = ids[a], ids[b]
            ps = similarity(pg[x], pg[y])
            if ps < args.prompt:
                continue
            ss = similarity(sg[x], sg[y])
            if ss < args.solution:
                continue
            pairs.append((ss, ps, x, y))
    pairs.sort(reverse=True)

    # 併成家族：A 撞 B、B 撞 C 時三題視為同一族，這樣才看得出「五題同模板」
    parent = {}

    def find(x):
        parent.setdefault(x, x)
        while parent[x] != x:
            parent[x] = parent[parent[x]]
            x = parent[x]
        return x

    for _, _, x, y in pairs:
        rx, ry = find(x), find(y)
        if rx != ry:
            parent[rx] = ry

    fams = {}
    for x in parent:
        fams.setdefault(find(x), []).append(x)
    groups = sorted(fams.values(), key=len, reverse=True)

    shown = 0
    for fam in groups:
        if len(fam) < args.min_size:
            continue
        grades = sorted(grade_of(bank[i]) for i in fam)
        if args.grade is not None and args.grade not in grades:
            continue
        shown += 1
        inner = [similarity(sg[a], sg[b])
                 for n, a in enumerate(fam) for b in fam[n + 1:]]
        print('── %d 題　年級 %s　家族內詳解相似度 最高 %.2f 平均 %.2f'
              % (len(fam), grades, max(inner), sum(inner) / len(inner)))
        for i in sorted(fam, key=lambda x: grade_of(bank[x])):
            q = bank[i]
            print('   g%-2d %-34s [%s] 答%s'
                  % (grade_of(q), i, q['subtopic'], q['correctAnswer']['value']))
            print('       %s' % q['prompt']['zh-Hant'][:66])
        print()

    print('配對 %d 組，聚成 %d 個家族（列出 %d 個），涉及 %d 題'
          % (len(pairs), len(groups), shown, sum(len(f) for f in groups)))
    print('門檻：正規化題幹 >= %.2f 且正規化詳解 >= %.2f' % (args.prompt, args.solution))
    return 1 if shown else 0


if __name__ == '__main__':
    sys.exit(main())
