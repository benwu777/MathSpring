# -*- coding: utf-8 -*-
"""grade12 寫入後重掃的修正。

三題真重複（閘門在候選階段放行，是因為我在寫入時把題幹改成更接近既有題的措辭，
分數因此從 0.4 以下升到 0.5–0.7。教訓：寫入用的最終文字必須再過一次閘門）：

- geometry_033 拋物線焦準距 y²=4x  vs geometry_grade11_019（y²=12x，同子分類名）0.72
- geometry_040 雙曲線焦距          vs geometry_grade11_017（橢圓焦距，同一問法）0.54
- number_theory_038 平方和表示     vs number_theory_grade11_034（同骨架，我昨天才加）0.44

另外 combinatorics_036 與 combinatorics_grade11_033 的 0.50 是共用開場句造成的誤判
（一個數四顆點數皆相異的排列、一個數三顆和為 10 的組成），只改開場句。
"""
import json, io

def load(p): return json.load(open(p))
def save(p, d):
    with io.open(p, 'w', encoding='utf-8') as f:
        json.dump(d, f, ensure_ascii=False, indent=2); f.write('\n')
def get(d, qid):
    return next(q for q in d['questions'] if q['id'] == qid)

G = 'assets/questions/geometry/grade12_foundation.geometry.v1.json'
NT = 'assets/questions/number_theory/grade12_foundation.number_theory.v1.json'
C = 'assets/questions/combinatorics/grade12_foundation.combinatorics.v1.json'
NOTE = ('Replaces a candidate that duplicated an existing question. The candidate cleared the pre-write '
        'similarity gate, but the wording used at write time was closer to the existing question and the '
        'post-write rescan caught it.')

# ---------- 1. geometry_033 -> 正六邊形最長對角線 ----------
d = load(G); q = get(d, 'geometry_grade12_foundation_033')
q['subtopic'] = 'hexagon_longest_diagonal'
q['prompt'] = {
 'zh-Hant': '一個正六邊形的邊長是 4 公分。它最長的那一條對角線長幾公分？',
 'zh-Hans': '一个正六边形的边长是 4 厘米。它最长的那一条对角线长几厘米？',
 'en': 'A regular hexagon has sides of length 4 cm. How long is its longest diagonal, in centimetres?',
 'ja': '正六角形の 1 辺の長さが 4 cm です。いちばん長い対角線の長さは何 cm ですか。'}
q['answer'] = {'zh-Hant': '答案是 8 公分。', 'zh-Hans': '答案是 8 厘米。',
               'en': 'The answer is 8 cm.', 'ja': '答えは 8 cm です。'}
q['solutionSteps'] = {
 'zh-Hant': ['正六邊形可以從中心拉六條線到各頂點，切成 6 個三角形。',
             '每個三角形的兩腰都是中心到頂點的距離（外接圓半徑），夾角是 360° ÷ 6 = 60°。',
             '兩腰相等而夾角 60°，所以這 6 個三角形都是正三角形，中心到頂點的距離就等於邊長 4 公分。',
             '最長的對角線是連接相對兩個頂點的那一條，它通過中心，長度是兩個半徑，也就是 4 × 2 = 8 公分。'],
 'zh-Hans': ['正六边形可以从中心拉六条线到各顶点，切成 6 个三角形。',
             '每个三角形的两腰都是中心到顶点的距离（外接圆半径），夹角是 360° ÷ 6 = 60°。',
             '两腰相等而夹角 60°，所以这 6 个三角形都是正三角形，中心到顶点的距离就等于边长 4 厘米。',
             '最长的对角线是连接相对两个顶点的那一条，它通过中心，长度是两个半径，也就是 4 × 2 = 8 厘米。'],
 'en': ['A regular hexagon can be cut into 6 triangles by drawing lines from the centre to each vertex.',
        'In each triangle the two equal sides are the distance from the centre to a vertex, and the angle between them is 360° ÷ 6 = 60°.',
        'Two equal sides with a 60° angle between them force the triangle to be equilateral, so the distance from the centre to a vertex equals the side length, 4 cm.',
        'The longest diagonal joins two opposite vertices and passes through the centre, so it is two such radii: 4 × 2 = 8 cm.'],
 'ja': ['正六角形は、中心から各頂点へ線を引くと 6 つの三角形に分けられます。',
        '各三角形の等しい 2 辺は中心から頂点までの距離で、その間の角は 360° ÷ 6 = 60° です。',
        '等しい 2 辺の間の角が 60° なら、その三角形は正三角形になります。よって中心から頂点までの距離は 1 辺と同じ 4 cm です。',
        'いちばん長い対角線は向かい合う 2 頂点を結び、中心を通るので、半径 2 つ分の 4 × 2 = 8 cm です。']}
q['correctAnswer'] = {'type': 'integer', 'value': '8'}
q['inputConstraints'] = {'maxDigits': 1, 'allowNegative': False}
q['source']['notes'] = NOTE + ' Original candidate: distance from focus to directrix of y² = 4x.'
save(G, d); print('已替換 geometry_grade12_foundation_033 -> 正六邊形最長對角線（8）')

# ---------- 2. geometry_040 -> 相似三角形周長比 ----------
d = load(G); q = get(d, 'geometry_grade12_foundation_040')
q['subtopic'] = 'similar_triangle_perimeter_ratio'
q['prompt'] = {
 'zh-Hant': '兩個相似三角形的面積比是 9 比 16。它們的周長比寫成最簡整數比 a 比 b。求 a + b 的值。',
 'zh-Hans': '两个相似三角形的面积比是 9 比 16。它们的周长比写成最简整数比 a 比 b。求 a + b 的值。',
 'en': 'Two similar triangles have areas in the ratio 9 to 16. Their perimeters are in the ratio a to b in lowest terms, with a and b whole numbers. What is a + b?',
 'ja': '相似な 2 つの三角形の面積の比が 9 対 16 です。周の長さの比を最も簡単な整数比 a 対 b で表すとき、a + b はいくつですか。'}
q['answer'] = {'zh-Hant': '答案是 7。', 'zh-Hans': '答案是 7。',
               'en': 'The answer is 7.', 'ja': '答えは 7 です。'}
q['solutionSteps'] = {
 'zh-Hant': ['相似圖形之間，長度的比稱為相似比；面積是兩個長度相乘出來的，所以面積比等於相似比的平方。',
             '面積比是 9 比 16，所以相似比的平方是 9/16，相似比就是根號 (9/16) = 3/4。',
             '周長也是長度，和邊長按同一個比例縮放，所以周長比等於相似比，也是 3 比 4。',
             '3 和 4 互質，已是最簡整數比，所以 a = 3、b = 4，a + b = 7。（常見的錯誤是直接把 9 + 16 當答案，那是把面積比誤當成周長比。）'],
 'zh-Hans': ['相似图形之间，长度的比称为相似比；面积是两个长度相乘出来的，所以面积比等于相似比的平方。',
             '面积比是 9 比 16，所以相似比的平方是 9/16，相似比就是根号 (9/16) = 3/4。',
             '周长也是长度，和边长按同一个比例缩放，所以周长比等于相似比，也是 3 比 4。',
             '3 和 4 互质，已是最简整数比，所以 a = 3、b = 4，a + b = 7。（常见的错误是直接把 9 + 16 当答案，那是把面积比误当成周长比。）'],
 'en': ['Between similar figures the ratio of lengths is the scale factor. Area comes from multiplying two lengths, so the ratio of areas is the square of the scale factor.',
        'The areas are in ratio 9 to 16, so the square of the scale factor is 9/16 and the scale factor is the square root of 9/16, that is 3/4.',
        'A perimeter is a length and scales in the same way as the sides, so the ratio of perimeters equals the scale factor, namely 3 to 4.',
        '3 and 4 are coprime so the ratio is already in lowest terms, giving a = 3, b = 4 and a + b = 7. A common mistake is to answer 9 + 16, which treats the area ratio as if it were the perimeter ratio.'],
 'ja': ['相似な図形どうしでは、長さの比を相似比といいます。面積は長さ 2 つのかけ算なので、面積の比は相似比の 2 乗になります。',
        '面積の比が 9 対 16 なので相似比の 2 乗は 9/16、相似比は √(9/16) = 3/4 です。',
        '周の長さも長さなので辺と同じ割合で拡大縮小し、周の比は相似比と同じ 3 対 4 です。',
        '3 と 4 は互いに素で既約なので a = 3、b = 4、a + b = 7 です。9 + 16 と答えるのはよくある誤りで、面積の比を周の比と取りちがえています。']}
q['correctAnswer'] = {'type': 'integer', 'value': '7'}
q['inputConstraints'] = {'maxDigits': 1, 'allowNegative': False}
q['source']['notes'] = NOTE + ' Original candidate: distance between the foci of a hyperbola.'
save(G, d); print('已替換 geometry_grade12_foundation_040 -> 相似三角形周長比（7）')

# ---------- 3. number_theory_038 -> 1 到 1000 中數字 7 的出現次數 ----------
d = load(NT); q = get(d, 'number_theory_grade12_foundation_038')
q['subtopic'] = 'digit_occurrence_count'
q['prompt'] = {
 'zh-Hant': '把 1 到 1000 這一千個整數全部寫出來，數字 7 一共會出現幾次？（例如 77 這個數裡面，7 出現了 2 次。）',
 'zh-Hans': '把 1 到 1000 这一千个整数全部写出来，数字 7 一共会出现几次？（例如 77 这个数里面，7 出现了 2 次。）',
 'en': 'All the integers from 1 to 1000 are written out. How many times does the digit 7 appear in total? For example the number 77 contains the digit 7 twice.',
 'ja': '1 から 1000 までの整数をすべて書き出します。数字の 7 は全部で何回あらわれますか。たとえば 77 という数には 7 が 2 回あらわれます。'}
q['answer'] = {'zh-Hant': '答案是 300 次。', 'zh-Hans': '答案是 300 次。',
               'en': 'The answer is 300.', 'ja': '答えは 300 回です。'}
q['solutionSteps'] = {
 'zh-Hant': ['1000 本身沒有數字 7，可以先不管它，只看 1 到 999。',
             '把 1 到 999 每個數都補成三位數（例如 7 寫成 007、53 寫成 053），這樣不會多出或少掉任何一個 7，但每個數都恰好有三個數字位。',
             '這樣一共是 000 到 999 共 1000 個三位數字串，數字位總共 3000 個。由於 0 到 9 每個數字在每一位上出現的機會完全對稱，每個數字各佔十分之一。',
             '所以數字 7 出現 3000 ÷ 10 = 300 次。'],
 'zh-Hans': ['1000 本身没有数字 7，可以先不管它，只看 1 到 999。',
             '把 1 到 999 每个数都补成三位数（例如 7 写成 007、53 写成 053），这样不会多出或少掉任何一个 7，但每个数都恰好有三个数字位。',
             '这样一共是 000 到 999 共 1000 个三位数字串，数字位总共 3000 个。由于 0 到 9 每个数字在每一位上出现的机会完全对称，每个数字各占十分之一。',
             '所以数字 7 出现 3000 ÷ 10 = 300 次。'],
 'en': ['The number 1000 contains no digit 7, so it can be set aside and only 1 to 999 considered.',
        'Pad every number from 1 to 999 out to three digits, writing 7 as 007 and 53 as 053. This adds no 7s and removes none, but now every number has exactly three digit positions.',
        'That gives the 1000 strings from 000 to 999, holding 3000 digit positions in all. Since each of the digits 0 to 9 is perfectly symmetric in how often it can occupy any position, each accounts for one tenth of them.',
        'So the digit 7 appears 3000 ÷ 10 = 300 times.'],
 'ja': ['1000 には数字の 7 がふくまれないので、いったんわきに置き、1 から 999 だけを考えます。',
        '1 から 999 のすべてを 3 けたに書きそろえます。7 は 007、53 は 053 と書きます。7 の数はふえも減りもしませんが、どの数もちょうど 3 つの位をもつようになります。',
        'こうすると 000 から 999 までの 1000 個の文字列となり、位は全部で 3000 か所です。0 から 9 のどの数字も、どの位に来るかについて完全に対称なので、それぞれが 10 分の 1 ずつを占めます。',
        'したがって数字の 7 は 3000 ÷ 10 = 300 回あらわれます。']}
q['correctAnswer'] = {'type': 'integer', 'value': '300'}
q['inputConstraints'] = {'maxDigits': 3, 'allowNegative': False}
q['source']['notes'] = NOTE + ' Original candidate: how many integers from 1 to 30 are a sum of two squares.'
save(NT, d); print('已替換 number_theory_grade12_foundation_038 -> 1 到 1000 中數字 7 的次數（300）')

# ---------- 4. combinatorics_036 改寫開場句 ----------
d = load(C); q = get(d, 'combinatorics_grade12_foundation_036')
q['prompt'] = {
 'zh-Hant': '把一顆骰子連續擲 3 次，依序記下三個點數（每次的點數是 1 到 6）。三個點數的和等於 10 的結果有幾種？',
 'zh-Hans': '把一颗骰子连续掷 3 次，依序记下三个点数（每次的点数是 1 到 6）。三个点数的和等于 10 的结果有几种？',
 'en': 'A single die is rolled three times in a row and the three numbers are recorded in order, each from 1 to 6. In how many outcomes do the three numbers add up to 10?',
 'ja': '1 個のさいころを続けて 3 回投げ、出た目を順に記録します（各回 1 から 6）。3 つの目の和が 10 になる結果は何通りですか。'}
save(C, d); print('已改寫 combinatorics_grade12_foundation_036 的開場句')
