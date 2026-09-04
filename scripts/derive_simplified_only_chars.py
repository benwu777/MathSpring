#!/usr/bin/env python3
"""從題庫自身推導「簡體專用字」集合，輸出 docs/simplified-only-chars.txt。

做法不查外部字表，只比較題庫既有的 zh-Hans 與 zh-Hant 兩欄的字頻：
一個漢字若在 zh-Hans 出現夠多次、卻在 zh-Hant 從未出現過，就是簡體專用字。
「從未出現」這一條是關鍵——共用字（一、二、面積…）兩邊都有，自然被排除。

門檻設 5 次是為了濾掉偶發的錯字：只出現一兩次的字有可能本來就是既有題的漏網之魚，
把它收進集合會讓檢查自我循環（用髒資料去驗髒資料）。

用法：
  python3 scripts/derive_simplified_only_chars.py           # 覆寫 docs/simplified-only-chars.txt
  python3 scripts/derive_simplified_only_chars.py --print   # 只印出來不寫檔
"""
import glob
import json
import os
import sys
from collections import Counter

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from validate_question_packs import iter_lang_text  # noqa: E402  走訪邏輯只留一份

MIN_HANS_COUNT = 5
OUT_PATH = 'docs/simplified-only-chars.txt'


def count_chars(questions, lang):
    c = Counter()
    for q in questions:
        for s in iter_lang_text(q, lang):
            c.update(ch for ch in s if '一' <= ch <= '鿿')
    return c


def load_questions(pattern='assets/questions/*/*.json'):
    out = []
    for path in sorted(glob.glob(pattern)):
        with open(path) as fh:
            out.extend(json.load(fh)['questions'])
    return out


def derive(questions, min_hans_count=MIN_HANS_COUNT):
    hans = count_chars(questions, 'zh-Hans')
    hant = count_chars(questions, 'zh-Hant')
    return sorted(ch for ch, n in hans.items()
                  if n >= min_hans_count and hant[ch] == 0)


def main():
    questions = load_questions()
    chars = derive(questions)
    body = ''.join(chars)
    if '--print' in sys.argv:
        print(body)
        return 0
    header = (
        '# 簡體專用字集合（validate_question_packs.py 用來擋「簡體字寫進 zh-Hant」）\n'
        '# 由 scripts/derive_simplified_only_chars.py 從題庫自身推導：\n'
        '# 在所有題目的 zh-Hans 欄位出現 >= %d 次、且在 zh-Hant 欄位從未出現的漢字。\n'
        '# 不是通用的繁簡對照表，只涵蓋這個題庫實際用得到的字。\n'
        '# 題庫成長後重跑此腳本即可更新；下一行是字集本身，一行到底、無分隔符號。\n'
        % MIN_HANS_COUNT)
    with open(OUT_PATH, 'w') as fh:
        fh.write(header + body + '\n')
    print('%d 個簡體專用字 -> %s' % (len(chars), OUT_PATH))
    return 0


if __name__ == '__main__':
    sys.exit(main())
