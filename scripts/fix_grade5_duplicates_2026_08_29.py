# -*- coding: utf-8 -*-
"""grade5 寫入後重掃抓到的兩題重複。

- geometry_grade5_053 梯形面積（上底 6、下底 10、高 4）與 geometry_grade7_026
  是同一題，連上底下底的數字都一樣，只有高不同（8 vs 4），子分類名也同為
  trapezoid_area。字面閘門放行，dart 稽核抓到。
- logic_grade5_046「2、6、12、20、30，差每次多 2」與 arithmetic_grade1_076
  「1、2、4、7、11，差每次多 1」是同一骨架，只換了增量（0.59）。
  後者是我同一輪稍早才加進 grade1 的——連續補多個年級時，新題本身就是新的碰撞源。
"""
import json, io
def load(p): return json.load(open(p))
def save(p, d):
    with io.open(p, 'w', encoding='utf-8') as f:
        json.dump(d, f, ensure_ascii=False, indent=2); f.write('\n')
def get(d, qid): return next(q for q in d['questions'] if q['id'] == qid)

G = 'assets/questions/geometry/grade5_foundation.geometry.v1.json'
d = load(G); q = get(d, 'geometry_grade5_foundation_053')
q['subtopic'] = 'triangle_height_from_area'
q['prompt'] = {
 'zh-Hant': '一個三角形的面積是 30 平方公分，底邊長 12 公分。它的高是幾公分？',
 'zh-Hans': '一个三角形的面积是 30 平方厘米，底边长 12 厘米。它的高是几厘米？',
 'en': 'A triangle has an area of 30 square centimetres and a base of 12 cm. What is its height, in centimetres?',
 'ja': '三角形の面積が 30 cm²、底辺の長さが 12 cm です。高さは何 cm ですか。'}
q['answer'] = {'zh-Hant': '答案是 5 公分。', 'zh-Hans': '答案是 5 厘米。',
               'en': 'The answer is 5 cm.', 'ja': '答えは 5 cm です。'}
q['solutionSteps'] = {
 'zh-Hant': ['三角形面積的公式是「底 × 高 ÷ 2」。這一題已知面積和底，要反過來求高。',
             '先把除以 2 還原：面積乘以 2，就等於「底 × 高」。30 × 2 = 60。',
             '所以底 × 高 = 60，而底是 12 公分。',
             '高 = 60 ÷ 12 = 5 公分。（驗算：12 × 5 ÷ 2 = 30 平方公分，正確。）'],
 'zh-Hans': ['三角形面积的公式是「底 × 高 ÷ 2」。这一题已知面积和底，要反过来求高。',
             '先把除以 2 还原：面积乘以 2，就等于「底 × 高」。30 × 2 = 60。',
             '所以底 × 高 = 60，而底是 12 厘米。',
             '高 = 60 ÷ 12 = 5 厘米。（验算：12 × 5 ÷ 2 = 30 平方厘米，正确。）'],
 'en': ['The area of a triangle is base times height divided by 2. Here the area and the base are known and the height is wanted, so the formula is run backwards.',
        'First undo the division by 2: doubling the area gives base times height. 30 × 2 = 60.',
        'So base times height is 60, and the base is 12 cm.',
        'The height is 60 ÷ 12 = 5 cm. Check: 12 × 5 ÷ 2 = 30 square centimetres, as required.'],
 'ja': ['三角形の面積は「底辺 × 高さ ÷ 2」です。この問題では面積と底辺がわかっていて高さを求めるので、公式を逆にたどります。',
        'まず ÷ 2 をもどします。面積を 2 倍すると「底辺 × 高さ」になり、30 × 2 = 60 です。',
        'したがって 底辺 × 高さ = 60 で、底辺は 12 cm です。',
        '高さは 60 ÷ 12 = 5 cm です。確かめると 12 × 5 ÷ 2 = 30 cm² で正しいです。']}
q['correctAnswer'] = {'type': 'integer', 'value': '5'}
q['inputConstraints'] = {'maxDigits': 1, 'allowNegative': False}
q['source']['notes'] = ('Replaces a trapezoid-area candidate that duplicated geometry_grade7_foundation_026 '
                        '(same parallel sides 6 and 10, only the height differed).')
save(G, d); print('已替換 geometry_grade5_foundation_053 -> 三角形已知面積求高（5）')

LG = 'assets/questions/logic/grade5_foundation.logic.v1.json'
d = load(LG); q = get(d, 'logic_grade5_foundation_046')
q['subtopic'] = 'three_piles_from_total'
q['prompt'] = {
 'zh-Hant': '有三堆球。第一堆比第二堆多 5 顆，第三堆比第二堆少 3 顆，三堆一共有 32 顆。第二堆有幾顆？',
 'zh-Hans': '有三堆球。第一堆比第二堆多 5 颗，第三堆比第二堆少 3 颗，三堆一共有 32 颗。第二堆有几颗？',
 'en': 'There are three piles of balls. The first pile has 5 more than the second, and the third has 3 fewer than the second. The three piles hold 32 balls in total. How many are in the second pile?',
 'ja': 'ボールの山が 3 つあります。1 つ目の山は 2 つ目より 5 個多く、3 つ目の山は 2 つ目より 3 個少なく、3 つの山を合わせると 32 個です。2 つ目の山は何個ですか。'}
q['answer'] = {'zh-Hant': '答案是 10 顆。', 'zh-Hans': '答案是 10 颗。',
               'en': 'The answer is 10.', 'ja': '答えは 10 個です。'}
q['solutionSteps'] = {
 'zh-Hant': ['另外兩堆都是拿第二堆來比較的，所以用第二堆當基準最好算。',
             '第一堆是「第二堆再多 5 顆」，第三堆是「第二堆再少 3 顆」。',
             '把三堆加起來，等於三個第二堆，再加上 5 又減掉 3，也就是三個第二堆再加 2。',
             '三個第二堆加 2 等於 32，所以三個第二堆是 32 − 2 = 30，第二堆是 30 ÷ 3 = 10 顆。（驗算：15 + 10 + 7 = 32。）'],
 'zh-Hans': ['另外两堆都是拿第二堆来比较的，所以用第二堆当基准最好算。',
             '第一堆是「第二堆再多 5 颗」，第三堆是「第二堆再少 3 颗」。',
             '把三堆加起来，等于三个第二堆，再加上 5 又减掉 3，也就是三个第二堆再加 2。',
             '三个第二堆加 2 等于 32，所以三个第二堆是 32 − 2 = 30，第二堆是 30 ÷ 3 = 10 颗。（验算：15 + 10 + 7 = 32。）'],
 'en': ['Both of the other piles are described by comparison with the second pile, so the second pile is the natural baseline.',
        'The first pile is the second plus 5, and the third pile is the second minus 3.',
        'Adding all three gives three copies of the second pile, plus 5 and minus 3, which is three copies plus 2.',
        'Three copies plus 2 equals 32, so three copies make 32 − 2 = 30, and the second pile is 30 ÷ 3 = 10. Check: 15 + 10 + 7 = 32.'],
 'ja': ['ほかの 2 つの山はどちらも 2 つ目の山と比べて説明されているので、2 つ目を基準にすると考えやすくなります。',
        '1 つ目は「2 つ目より 5 個多い」、3 つ目は「2 つ目より 3 個少ない」です。',
        '3 つを足すと、2 つ目の山 3 つ分に 5 を足して 3 を引いたもの、つまり 3 つ分に 2 を足したものになります。',
        '3 つ分 + 2 = 32 なので 3 つ分は 32 − 2 = 30、2 つ目の山は 30 ÷ 3 = 10 個です。確かめると 15 + 10 + 7 = 32 です。']}
q['correctAnswer'] = {'type': 'integer', 'value': '10'}
q['inputConstraints'] = {'maxDigits': 2, 'allowNegative': False}
q['source']['notes'] = ('Replaces a second-difference sequence candidate that shared its skeleton with '
                        'arithmetic_grade1_foundation_076, added earlier the same day, differing only in the increment.')
save(LG, d); print('已替換 logic_grade5_foundation_046 -> 三堆球求中間堆（10）')
