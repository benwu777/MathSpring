# -*- coding: utf-8 -*-
"""修兩題：

1. number_theory_grade7_039 原本是「1! + ⋯ + 10! 的個位數字」，與
   number_theory_grade9_023（1! + ⋯ + 100!）是同一題只換上限，改成數字和求最少位數。

2. number_theory_grade9_032 與 number_theory_grade7_002 其實是同一題
   （1 到 1000 中數字 7 恰好出現一次，答案都是 243）。先前把 grade9 改寫成
   旅館房號的情境，反而讓相似度工具抓不到這組真正的重複——這是「改寫不刪」
   政策的副作用。改成「至少出現兩次」，與 grade7_002 和 grade9_024 都不同。
"""
import glob, io, json

def L(zh, zhs, en, ja):
    return {'zh-Hant': zh, 'zh-Hans': zhs, 'en': en, 'ja': ja}

R = {
'number_theory_grade7_foundation_039': dict(
  subtopic='digit_sum_minimum_length',
  prompt=L('一個正整數的各位數字加起來剛好是 2025。這個正整數最少是幾位數？',
           '一个正整数的各位数字加起来刚好是 2025。这个正整数最少是几位数？',
           'The digits of a positive integer add up to exactly 2025. What is the least possible number of digits it can have?',
           'ある正の整数の各位の数字の和がちょうど 2025 です。この整数は最も少なくて何けたですか。'),
  answer=L('答案是 225 位。', '答案是 225 位。', 'The answer is 225.', '答えは 225 けたです。'),
  steps=[['每一位數字最大只能是 9，所以 n 位數的數字和最多是 9n。',
          '要讓數字和達到 2025，必須 9n ≥ 2025，也就是 n ≥ 2025 ÷ 9 = 225。',
          '225 位確實做得到：225 個 9 排在一起，數字和正好是 9 × 225 = 2025。',
          '所以最少是 225 位。'],
         ['每一位数字最大只能是 9，所以 n 位数的数字和最多是 9n。',
          '要让数字和达到 2025，必须 9n ≥ 2025，也就是 n ≥ 2025 ÷ 9 = 225。',
          '225 位确实做得到：225 个 9 排在一起，数字和正好是 9 × 225 = 2025。',
          '所以最少是 225 位。'],
         ['Each digit is at most 9, so an n-digit number has digit sum at most 9n.',
          'To reach a digit sum of 2025 we need 9n ≥ 2025, that is n ≥ 2025 ÷ 9 = 225.',
          '225 digits is actually achievable: 225 nines in a row have digit sum exactly 9 × 225 = 2025.',
          'So the least possible number of digits is 225.'],
         ['どの位の数字も最大 9 なので、n けたの数の各位の和は最大でも 9n です。',
          '和を 2025 にするには 9n ≥ 2025、つまり n ≥ 2025 ÷ 9 = 225 が必要です。',
          '225 けたは実際に作れます。9 を 225 個ならべると各位の和はちょうど 9 × 225 = 2025 です。',
          'したがって最も少なくて 225 けたです。']],
  value='225', digits=3,
  notes='Replaced 2026-08-28: the previous factorial-sum-units question duplicated number_theory_grade9_foundation_023 with a different upper limit.'),

'number_theory_grade9_foundation_032': dict(
  subtopic='count_with_repeated_digit',
  prompt=L('在 1 到 1000 的正整數中，十進位表示裡數字 7 至少出現兩次的數共有多少個？',
           '在 1 到 1000 的正整数中，十进位表示里数字 7 至少出现两次的数共有多少个？',
           'Among the positive integers from 1 to 1000, how many contain the digit 7 at least twice in their decimal representation?',
           '1 から 1000 までの正の整数のうち、10 進法で数字の 7 が 2 回以上あらわれるものは何個ありますか。'),
  answer=L('答案是 28 個。', '答案是 28 个。', 'The answer is 28.', '答えは 28 個です。'),
  steps=[['1000 沒有數字 7，所以只看 1 到 999，並且把每個數都補成三位（例如 7 寫成 007），這不會改變 7 出現的次數。',
          '「至少兩次」分成兩種情形：恰好兩個 7，和三個都是 7。',
          '恰好兩個 7：先選哪兩位放 7，有 3 種選法；剩下那一位不能是 7，有 9 種選擇，共 3 × 9 = 27 個。',
          '三個都是 7 的只有 777 這一個。',
          '合計 27 + 1 = 28 個。'],
         ['1000 没有数字 7，所以只看 1 到 999，并且把每个数都补成三位（例如 7 写成 007），这不会改变 7 出现的次数。',
          '「至少两次」分成两种情形：恰好两个 7，和三个都是 7。',
          '恰好两个 7：先选哪两位放 7，有 3 种选法；剩下那一位不能是 7，有 9 种选择，共 3 × 9 = 27 个。',
          '三个都是 7 的只有 777 这一个。',
          '合计 27 + 1 = 28 个。'],
         ['1000 contains no 7, so only 1 to 999 matter; write each with three digits, padding with zeros as in 007, which does not change how often 7 appears.',
          '"At least twice" splits into two cases: exactly two sevens, and all three digits seven.',
          'Exactly two sevens: choose which two places hold them in 3 ways, and the remaining place is any digit except 7, giving 9 choices, so 3 × 9 = 27.',
          'All three sevens gives only the number 777.',
          'The total is 27 + 1 = 28.'],
         ['1000 に 7 はないので 1 から 999 だけを考え、007 のように 0 でうめて 3 けたにします。これで 7 の出る回数は変わりません。',
          '「2 回以上」は、ちょうど 2 個の場合と 3 個すべての場合に分かれます。',
          'ちょうど 2 個：7 を置く 2 つの位の選び方が 3 通り、残りの位は 7 以外の 9 通りなので 3 × 9 = 27 個です。',
          '3 個すべて 7 なのは 777 の 1 個だけです。',
          '合計は 27 + 1 = 28 個です。']],
  value='28', digits=2,
  notes='Replaced 2026-08-28: the previous wording asked for exactly one 7 among 1 to 1000, which is the same question as number_theory_grade7_foundation_002 with the same answer 243. Rewriting it into a hotel-room setting had hidden that overlap from the similarity gate rather than removing it.'),
}

for path in sorted(glob.glob('assets/questions/*/*.json')):
    if path.endswith('manifest.json'):
        continue
    pack = json.load(open(path))
    dirty = False
    for q in pack['questions']:
        s = R.get(q['id'])
        if not s:
            continue
        q['subtopic'] = s['subtopic']
        q['prompt'] = s['prompt']
        q['answer'] = s['answer']
        q['solutionSteps'] = {k: v for k, v in zip(
            ['zh-Hant', 'zh-Hans', 'en', 'ja'], s['steps'])}
        q['correctAnswer'] = {'type': 'integer', 'value': s['value']}
        q['inputConstraints'] = {'allowNegative': False, 'maxDigits': s['digits']}
        q['source'] = dict(q['source'], notes=s['notes'])
        assert len({len(v) for v in q['solutionSteps'].values()}) == 1, q['id']
        dirty = True
        print('修正 %-42s -> %s' % (q['id'], s['value']))
    if dirty:
        io.open(path, 'w', encoding='utf-8').write(
            json.dumps(pack, ensure_ascii=False, indent=2) + '\n')
