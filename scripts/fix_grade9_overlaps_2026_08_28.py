# -*- coding: utf-8 -*-
"""grade9 寫入後重掃抓到三題重複，同 id 換新題。

  algebra_grade9_036       合作工作求單獨天數，撞 algebra_grade7_011（同題換數字，0.69）
  combinatorics_grade9_037 售票口找零，撞本 session 稍早改寫的 combinatorics_grade12_031（0.61）
  geometry_grade9_033      圓內接四邊形對角互補，是 geometry_grade8_013 的裸版（0.72）
"""
import glob, io, json

def L(zh, zhs, en, ja):
    return {'zh-Hant': zh, 'zh-Hans': zhs, 'en': en, 'ja': ja}

R = {
'algebra_grade9_foundation_036': dict(
  subtopic='sum_square_sum_product', value='84', digits=2,
  prompt=L('兩個數的和是 20，它們的平方和是 232。這兩個數的乘積是多少？',
           '两个数的和是 20，它们的平方和是 232。这两个数的乘积是多少？',
           'Two numbers add up to 20 and their squares add up to 232. What is their product?',
           '2 つの数の和は 20、2 乗の和は 232 です。この 2 数の積はいくつですか。'),
  answer=L('答案是 84。', '答案是 84。', 'The answer is 84.', '答えは 84 です。'),
  steps=[['把和平方：(a + b)² = a² + 2ab + b²，也就是「平方和加上 2 倍的乘積」。',
          '和是 20，所以 (a + b)² = 400。',
          '平方和是 232，因此 2 倍的乘積是 400 − 232 = 168。',
          '乘積是 168 ÷ 2 = 84。（不必真的把兩個數解出來。）'],
         ['把和平方：(a + b)² = a² + 2ab + b²，也就是「平方和加上 2 倍的乘积」。',
          '和是 20，所以 (a + b)² = 400。',
          '平方和是 232，因此 2 倍的乘积是 400 − 232 = 168。',
          '乘积是 168 ÷ 2 = 84。（不必真的把两个数解出来。）'],
         ['Square the sum: (a + b)² = a² + 2ab + b², that is the sum of the squares plus twice the product.',
          'The sum is 20, so (a + b)² = 400.',
          'The sum of the squares is 232, so twice the product is 400 − 232 = 168.',
          'The product is 168 ÷ 2 = 84, and the two numbers never have to be found.'],
         ['和を 2 乗します。(a + b)² = a² + 2ab + b² で、これは「2 乗の和 ＋ 積の 2 倍」です。',
          '和は 20 なので (a + b)² = 400 です。',
          '2 乗の和が 232 なので、積の 2 倍は 400 − 232 = 168 です。',
          '積は 168 ÷ 2 = 84 です。2 数そのものを求める必要はありません。']],
  notes='Replaced 2026-08-28: the previous work-rate question was the same as algebra_grade7_foundation_011 with different numbers.'),

'combinatorics_grade9_foundation_037': dict(
  subtopic='circular_adjacent_pair', value='1440', digits=4,
  prompt=L('8 個人圍著一張圓桌就座，其中甲和乙兩人必須坐在相鄰的位置。若把整體旋轉後看起來相同的坐法算成同一種，共有幾種不同的坐法？',
           '8 个人围着一张圆桌就座，其中甲和乙两人必须坐在相邻的位置。若把整体旋转后看起来相同的坐法算成同一种，共有几种不同的坐法？',
           'Eight people sit round a circular table, and two particular people must sit next to each other. Seatings that look the same after rotating the whole table count as one. How many different seatings are there?',
           '8 人が円卓に座り、そのうち 2 人は となり合わなければなりません。全体を回転させて同じに見える座り方は 1 通りと数えるとき、座り方は何通りありますか。'),
  answer=L('答案是 1440 種。', '答案是 1440 种。', 'The answer is 1440.', '答えは 1440 通りです。'),
  steps=[['甲和乙必須相鄰，先把這兩人綁成一個整體看待。',
          '這樣圓桌上就變成 7 個單位在排。圓桌排列中，旋轉相同視為同一種，所以 n 個單位的坐法是 (n − 1) 種階乘：(7 − 1)! = 6 × 5 × 4 × 3 × 2 × 1 = 720。',
          '但綁在一起的甲乙內部還可以左右對調，有 2 種。',
          '所以總數是 720 × 2 = 1440 種。'],
         ['甲和乙必须相邻，先把这两人绑成一个整体看待。',
          '这样圆桌上就变成 7 个单位在排。圆桌排列中，旋转相同视为同一种，所以 n 个单位的坐法是 (n − 1) 的阶乘：(7 − 1)! = 6 × 5 × 4 × 3 × 2 × 1 = 720。',
          '但绑在一起的甲乙内部还可以左右对调，有 2 种。',
          '所以总数是 720 × 2 = 1440 种。'],
         ['Since the two must be adjacent, tie them together and treat the pair as a single unit.',
          'The table then seats 7 units. For a round table, rotations count as the same, so n units can be seated in (n − 1) factorial ways: (7 − 1)! = 6 × 5 × 4 × 3 × 2 × 1 = 720.',
          'Within the tied pair the two can still swap places, giving 2 possibilities.',
          'So the total is 720 × 2 = 1440.'],
         ['2 人は となり合う必要があるので、まず 2 人をひとまとまりとして考えます。',
          'すると円卓には 7 つのまとまりが座ります。円卓では回転して同じものを 1 通りと数えるので、n 個のまとまりの座り方は (n − 1) の階乗、(7 − 1)! = 6 × 5 × 4 × 3 × 2 × 1 = 720 通りです。',
          'まとめた 2 人は内部で左右を入れかえられるので 2 通りあります。',
          'したがって全部で 720 × 2 = 1440 通りです。']],
  notes='Replaced 2026-08-28: the previous ticket-queue question was the same as combinatorics_grade12_foundation_031 with 3 and 3 instead of 4 and 4.'),

'geometry_grade9_foundation_033': dict(
  subtopic='cone_net_semicircle', value='6', digits=1,
  prompt=L('一個圓錐的側面展開後剛好是一個半圓。已知底面圓的半徑是 3 公分，這個圓錐的母線長是幾公分？',
           '一个圆锥的侧面展开后刚好是一个半圆。已知底面圆的半径是 3 厘米，这个圆锥的母线长是几厘米？',
           'The curved surface of a cone unrolls into exactly a semicircle. The base circle has radius 3 cm. How long is the slant height of the cone, in centimetres?',
           '円すいの側面を開くと ちょうど半円になります。底面の円の半径が 3 cm のとき、円すいの母線の長さは何 cm ですか。'),
  answer=L('答案是 6 公分。', '答案是 6 厘米。', 'The answer is 6 cm.', '答えは 6 cm です。'),
  steps=[['把側面展開成扇形時，扇形的半徑就是圓錐的母線，扇形的弧長就是底面圓的周長。',
          '底面半徑 3，所以底面周長是 2 × π × 3 = 6π 公分，這就是弧長。',
          '展開後是半圓，半圓的弧長是整個圓周的一半，也就是 π × 母線。',
          '所以 π × 母線 = 6π，母線 = 6 公分。'],
         ['把侧面展开成扇形时，扇形的半径就是圆锥的母线，扇形的弧长就是底面圆的周长。',
          '底面半径 3，所以底面周长是 2 × π × 3 = 6π 厘米，这就是弧长。',
          '展开后是半圆，半圆的弧长是整个圆周的一半，也就是 π × 母线。',
          '所以 π × 母线 = 6π，母线 = 6 厘米。'],
         ['When the curved surface is unrolled into a sector, the sector\'s radius is the slant height and the sector\'s arc is the circumference of the base.',
          'The base radius is 3, so the base circumference is 2 × π × 3 = 6π cm, which is the arc length.',
          'The unrolled shape is a semicircle, whose arc is half a full circle, that is π times the slant height.',
          'So π × slant height = 6π, giving a slant height of 6 cm.'],
         ['側面を開いておうぎ形にすると、おうぎ形の半径は母線、弧の長さは底面の円周になります。',
          '底面の半径は 3 なので、底面の円周は 2 × π × 3 = 6π cm で、これが弧の長さです。',
          '開いた形は半円で、その弧の長さは円 1 周の半分、つまり π × 母線 です。',
          'したがって π × 母線 = 6π より、母線は 6 cm です。']],
  notes='Replaced 2026-08-28: the previous cyclic-quadrilateral question was the bare version of geometry_grade8_foundation_013.'),
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
        q['solutionSteps'] = dict(zip(['zh-Hant', 'zh-Hans', 'en', 'ja'], s['steps']))
        q['correctAnswer'] = {'type': 'integer', 'value': s['value']}
        q['inputConstraints'] = {'allowNegative': False, 'maxDigits': s['digits']}
        q['source'] = dict(q['source'], notes=s['notes'])
        assert len({len(v) for v in q['solutionSteps'].values()}) == 1, q['id']
        dirty = True
        print('替換 %-42s -> %s' % (q['id'], s['value']))
    if dirty:
        io.open(path, 'w', encoding='utf-8').write(
            json.dumps(pack, ensure_ascii=False, indent=2) + '\n')
