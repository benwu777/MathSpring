# -*- coding: utf-8 -*-
"""algebra_grade11_035 整題重寫。

原本是 log₂x = 5 求 x = 32，我為了拉開與 040 的 0.53 相似度改了題幹，
卻把問的東西從 x 換成指數，答案應該變成 5——而 pack 內 039、040 的答案已經都是 5。
改成「兩個不同底的對數相加」，答案 7，與 pack 內其他答案都不撞。
"""
import json, io
P = 'assets/questions/algebra/grade11_foundation.algebra.v1.json'
d = json.load(open(P))
q = next(x for x in d['questions'] if x['id'] == 'algebra_grade11_foundation_035')
q['subtopic'] = 'logarithm_sum_two_bases'
q['prompt'] = {
 'zh-Hant': '以 3 為底、81 的對數，加上以 2 為底、8 的對數。這兩個對數的和是多少？',
 'zh-Hans': '以 3 为底、81 的对数，加上以 2 为底、8 的对数。这两个对数的和是多少？',
 'en': 'Take the logarithm of 81 to base 3 and add the logarithm of 8 to base 2. What is the sum of these two logarithms?',
 'ja': '3 を底とする 81 の対数と、2 を底とする 8 の対数を足します。この 2 つの対数の和はいくつですか。'}
q['answer'] = {'zh-Hant': '答案是 7。', 'zh-Hans': '答案是 7。',
               'en': 'The answer is 7.', 'ja': '答えは 7 です。'}
q['solutionSteps'] = {
 'zh-Hant': ['「以 3 為底、81 的對數」問的是：3 要自乘幾次才等於 81。',
             '3 × 3 × 3 × 3 = 81，所以這個對數是 4。',
             '「以 2 為底、8 的對數」問的是：2 要自乘幾次才等於 8。2 × 2 × 2 = 8，所以是 3。',
             '兩者相加得 4 + 3 = 7。（注意底不同，不能合併成一個對數，只能各自算完再加。）'],
 'zh-Hans': ['「以 3 为底、81 的对数」问的是：3 要自乘几次才等于 81。',
             '3 × 3 × 3 × 3 = 81，所以这个对数是 4。',
             '「以 2 为底、8 的对数」问的是：2 要自乘几次才等于 8。2 × 2 × 2 = 8，所以是 3。',
             '两者相加得 4 + 3 = 7。（注意底不同，不能合并成一个对数，只能各自算完再加。）'],
 'en': ['The logarithm of 81 to base 3 asks how many factors of 3 multiply together to give 81.',
        'Since 3 × 3 × 3 × 3 = 81, that logarithm is 4.',
        'The logarithm of 8 to base 2 asks how many factors of 2 give 8. Since 2 × 2 × 2 = 8, that logarithm is 3.',
        'Adding them gives 4 + 3 = 7. Note that the bases differ, so the two logarithms cannot be combined into one; each must be evaluated separately first.'],
 'ja': ['「3 を底とする 81 の対数」は、3 を何個かけると 81 になるかを聞いています。',
        '3 × 3 × 3 × 3 = 81 なので、この対数は 4 です。',
        '「2 を底とする 8 の対数」は、2 を何個かけると 8 になるかを聞いています。2 × 2 × 2 = 8 なので 3 です。',
        '足すと 4 + 3 = 7 です。底がちがうので 1 つの対数にまとめられず、それぞれ計算してから足します。']}
q['correctAnswer'] = {'type': 'integer', 'value': '7'}
q['inputConstraints'] = {'maxDigits': 1, 'allowNegative': False}
with io.open(P, 'w', encoding='utf-8') as f:
    json.dump(d, f, ensure_ascii=False, indent=2); f.write('\n')
print('已重寫 algebra_grade11_foundation_035 -> 兩底對數相加，答案 7')
