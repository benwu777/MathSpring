# -*- coding: utf-8 -*-
"""清掉 --same-answer 檢查抓到的七組重複。

作法是「同 id 換成全新題目」，題數不減。七組如下（保留前者、替換後者）：

  arithmetic_grade4_024 / arithmetic_grade5_015  五位數 54312。後者要求「被 6 整除」，
      但 1+2+3+4+5 = 15 恆為 3 的倍數，條件退化成「被 2 整除」，兩題實質相同。
  logic_grade5_022 / logic_grade6_020            排序模板，字面相似 0.89。
  logic_grade5_017 / logic_grade6_025            同上。
  geometry_grade1_005 / geometry_grade1_011      正方形／長方形有幾條邊，同 pack，答案同為 4。
  geometry_grade2_017 / geometry_grade5_016      剪角周長不變，答案同為 0。
  geometry_grade5_029 / geometry_grade8_025      等腰三角形 5 和 11，周長同為 27。
  arithmetic_grade3_026 / mixed_grade5_006       123456789101112⋯ 第 15 個數字，答案同為 2。

另有 arithmetic_grade5_062 / logic_grade6_047（IMC 2015 五年級卷與六年級卷各出一次
同一題）不動：兩題各自忠於自己的 sourceUrl。
"""
import glob, io, json

def L(zh, zhs, en, ja):
    return {'zh-Hant': zh, 'zh-Hans': zhs, 'en': en, 'ja': ja}

R = {
'arithmetic_grade5_foundation_015': dict(
  subtopic='common_multiple_range', value='37', digits=2,
  prompt=L('一個三位數同時是 6 的倍數，也是 8 的倍數。這樣的三位數一共有幾個？',
           '一个三位数同时是 6 的倍数，也是 8 的倍数。这样的三位数一共有几个？',
           'A three-digit number is a multiple of both 6 and 8. How many such three-digit numbers are there?',
           '3 けたの整数で、6 の倍数でもあり 8 の倍数でもあるものは何個ありますか。'),
  answer=L('答案是 37 個。', '答案是 37 个。', 'The answer is 37.', '答えは 37 個です。'),
  steps=[['同時是 6 和 8 的倍數，就是 6 和 8 的公倍數，也就是最小公倍數 24 的倍數。',
          '最小的三位數 24 的倍數是 24 × 5 = 120；最大的是 24 × 41 = 984（24 × 42 = 1008 已經是四位數）。',
          '所以倍數的編號從 5 排到 41。',
          '個數是 41 − 5 + 1 = 37 個。'],
         ['同时是 6 和 8 的倍数，就是 6 和 8 的公倍数，也就是最小公倍数 24 的倍数。',
          '最小的三位数 24 的倍数是 24 × 5 = 120；最大的是 24 × 41 = 984（24 × 42 = 1008 已经是四位数）。',
          '所以倍数的编号从 5 排到 41。',
          '个数是 41 − 5 + 1 = 37 个。'],
         ['Being a multiple of both 6 and 8 means being a common multiple, that is a multiple of their least common multiple 24.',
          'The smallest three-digit multiple of 24 is 24 × 5 = 120, and the largest is 24 × 41 = 984, since 24 × 42 = 1008 has four digits.',
          'So the multipliers run from 5 up to 41.',
          'That gives 41 − 5 + 1 = 37 numbers.'],
         ['6 の倍数でも 8 の倍数でもあるということは公倍数、つまり最小公倍数 24 の倍数です。',
          '3 けたで最小の 24 の倍数は 24 × 5 = 120、最大は 24 × 41 = 984 です。24 × 42 = 1008 は 4 けたになります。',
          'したがって かける数は 5 から 41 までです。',
          '個数は 41 − 5 + 1 = 37 個です。']],
  notes='Replaced 2026-08-28: the previous question asked for the largest five-digit arrangement of 1-5 divisible by 6, but since 1+2+3+4+5 = 15 is always a multiple of 3 the condition collapses to divisibility by 2, making it identical to arithmetic_grade4_foundation_024 with the same answer 54312.'),

'logic_grade6_foundation_020': dict(
  subtopic='cyclic_dominance', value='3', digits=1, drop_options=True,
  prompt=L('甲、乙、丙三人玩剪刀石頭布，三人出的手勢剛好互不相同。已知甲贏了乙，乙贏了丙。那麼贏了甲的是誰？甲請填 1、乙請填 2、丙請填 3。',
           '甲、乙、丙三人玩剪刀石头布，三人出的手势刚好互不相同。已知甲赢了乙，乙赢了丙。那么赢了甲的是谁？甲请填 1、乙请填 2、丙请填 3。',
           'Three people play rock-paper-scissors and happen to show three different signs. The first beats the second, and the second beats the third. Who beats the first? Enter 1 for the first person, 2 for the second and 3 for the third.',
           '3 人がじゃんけんをして、3 人の手はすべてちがっていました。1 人目は 2 人目に勝ち、2 人目は 3 人目に勝ちました。1 人目に勝ったのはだれですか。1 人目なら 1、2 人目なら 2、3 人目なら 3 と答えなさい。'),
  answer=L('答案是丙，填 3。', '答案是丙，填 3。', 'The answer is the third person, entered as 3.', '答えは 3 人目で、3 です。'),
  steps=[['剪刀石頭布的三種手勢構成一個循環：石頭贏剪刀、剪刀贏布、布贏石頭，沒有哪一種是無敵的。',
          '三人手勢互不相同，表示三種手勢剛好各出現一次。',
          '甲贏乙、乙贏丙，所以甲、乙、丙依序是這個循環上的三個位置。',
          '循環必須繞回起點，因此剩下的那一場一定是丙贏甲（例如甲出石頭、乙出剪刀、丙出布）。丙記為 3，所以答案是 3。'],
         ['剪刀石头布的三种手势构成一个循环：石头赢剪刀、剪刀赢布、布赢石头，没有哪一种是无敌的。',
          '三人手势互不相同，表示三种手势刚好各出现一次。',
          '甲赢乙、乙赢丙，所以甲、乙、丙依序是这个循环上的三个位置。',
          '循环必须绕回起点，因此剩下的那一场一定是丙赢甲（例如甲出石头、乙出剪刀、丙出布）。丙记为 3，所以答案是 3。'],
         ['The three signs form a cycle: rock beats scissors, scissors beats paper and paper beats rock, so none of them is unbeatable.',
          'The three players show three different signs, so each sign appears exactly once.',
          'The first beats the second and the second beats the third, so the three players sit at three consecutive places on that cycle.',
          'A cycle must close back on itself, so the remaining match must be the third person beating the first, for example rock, scissors and paper in that order. The third person is entered as 3, so the answer is 3.'],
         ['じゃんけんの 3 つの手は循環しています。グーはチョキに、チョキはパーに、パーはグーに勝ち、無敵の手はありません。',
          '3 人の手はすべてちがうので、3 つの手がちょうど 1 回ずつ出ています。',
          '1 人目が 2 人目に、2 人目が 3 人目に勝つので、3 人はこの循環上の連続した 3 か所にあたります。',
          '循環はもとにもどるので、残りの勝負は必ず 3 人目が 1 人目に勝ちます。たとえばグー、チョキ、パーの順です。3 人目は 3 と答えるので、答えは 3 です。']],
  notes='Replaced 2026-08-28: the previous left-of ordering puzzle was 0.89 similar to logic_grade5_foundation_022 and shared its answer.'),

'logic_grade6_foundation_025': dict(
  subtopic='digit_sum_invariant', value='30', digits=2, drop_options=True,
  prompt=L('小安抄朋友的電話號碼時抄錯了：他把某個 7 位數號碼中相鄰的兩個數字對調了位置，其他數字都沒抄錯。已知正確號碼的各位數字和是 30。小安抄下來的號碼，各位數字和是多少？',
           '小安抄朋友的电话号码时抄错了：他把某个 7 位数号码中相邻的两个数字对调了位置，其他数字都没抄错。已知正确号码的各位数字和是 30。小安抄下来的号码，各位数字和是多少？',
           'An copies a friend\'s phone number wrongly: he swaps two neighbouring digits of the 7-digit number and copies everything else correctly. The digits of the correct number add up to 30. What do the digits of An\'s copy add up to?',
           'アンは友だちの電話番号を書き写すとき、7 けたの番号のうち となり合う 2 つの数字を入れかえてしまい、ほかは正しく写しました。正しい番号の各位の数字の和は 30 です。アンが写した番号の各位の数字の和はいくつですか。'),
  answer=L('答案是 30。', '答案是 30。', 'The answer is 30.', '答えは 30 です。'),
  steps=[['各位數字和只看「用到哪些數字、各用幾次」，和數字排在哪一位完全無關。',
          '對調兩個數字的位置，並沒有換掉任何一個數字，只是換了它們的位置。',
          '因此所有數字組成的集合完全沒變，數字和也不會變。',
          '所以小安抄下來的號碼，各位數字和仍然是 30。'],
         ['各位数字和只看「用到哪些数字、各用几次」，和数字排在哪一位完全无关。',
          '对调两个数字的位置，并没有换掉任何一个数字，只是换了它们的位置。',
          '因此所有数字组成的集合完全没变，数字和也不会变。',
          '所以小安抄下来的号码，各位数字和仍然是 30。'],
         ['A digit sum depends only on which digits appear and how often, never on the positions they sit in.',
          'Swapping two digits does not replace any digit; it only moves them.',
          'So the collection of digits is completely unchanged, and so is their total.',
          'The digits of An\'s copy therefore still add up to 30.'],
         ['各位の数字の和は「どの数字が何回使われているか」だけで決まり、どの位にあるかには関係しません。',
          '2 つの数字を入れかえても、数字そのものは何も変わらず、位置が入れかわるだけです。',
          'したがって数字の集まりはまったく変わらず、和も変わりません。',
          'よってアンが写した番号の各位の和も 30 のままです。']],
  notes='Replaced 2026-08-28: the previous left-of ordering puzzle repeated the template of logic_grade5_foundation_017 with the same answer.'),

'geometry_grade1_foundation_011': dict(
  subtopic='shape_cutting', value='8', digits=1,
  prompt=L('小安把一張正方形的紙，沿著一條直線剪開，剛好剪成兩個長方形。這兩個長方形的邊加起來一共有幾條？',
           '小安把一张正方形的纸，沿着一条直线剪开，刚好剪成两个长方形。这两个长方形的边加起来一共有几条？',
           'An cuts a square sheet of paper along a straight line so that it becomes exactly two rectangles. How many sides do the two rectangles have altogether?',
           'アンは正方形の紙をまっすぐ 1 回切って、ちょうど 2 つの長方形に分けました。この 2 つの長方形の辺は合わせて何本ですか。'),
  answer=L('答案是 8 條。', '答案是 8 条。', 'The answer is 8.', '答えは 8 本です。'),
  steps=[['剪開以後得到兩個長方形，要分開來數，不是看合起來的外框。',
          '每一個長方形都有 4 條邊。',
          '兩個長方形合計 4 + 4 = 8 條邊。（剪開的那一刀變成了兩個長方形各自的一條邊，所以邊數比原來的正方形多了。）'],
         ['剪开以后得到两个长方形，要分开来数，不是看合起来的外框。',
          '每一个长方形都有 4 条边。',
          '两个长方形合计 4 + 4 = 8 条边。（剪开的那一刀变成了两个长方形各自的一条边，所以边数比原来的正方形多了。）'],
         ['After the cut there are two separate rectangles, and each is counted on its own rather than as one outline.',
          'Every rectangle has 4 sides.',
          'The two together have 4 + 4 = 8 sides. The cut itself becomes one side of each rectangle, which is why there are more sides than the original square had.'],
         ['切ったあとは長方形が 2 つあり、外わくとしてではなく 1 つずつ数えます。',
          '長方形はどれも辺が 4 本あります。',
          '2 つ合わせて 4 + 4 = 8 本です。切った線がそれぞれの長方形の辺 1 本になるので、もとの正方形より辺が増えます。']],
  notes='Replaced 2026-08-28: the previous question asked how many sides a rectangle has, which duplicated geometry_grade1_foundation_005 about a square, with the same answer 4.'),

'geometry_grade5_foundation_016': dict(
  subtopic='equal_perimeter_square', value='6', digits=1,
  prompt=L('一個正方形的周長和一個長方形的周長剛好相等。已知這個長方形的長是 8 公分、寬是 4 公分。這個正方形的邊長是幾公分？',
           '一个正方形的周长和一个长方形的周长刚好相等。已知这个长方形的长是 8 厘米、宽是 4 厘米。这个正方形的边长是几厘米？',
           'A square and a rectangle have exactly the same perimeter. The rectangle is 8 cm long and 4 cm wide. What is the side length of the square, in centimetres?',
           'ある正方形とある長方形のまわりの長さがちょうど等しくなっています。長方形はたて 4 cm、よこ 8 cm です。正方形の 1 辺は何 cm ですか。'),
  answer=L('答案是 6 公分。', '答案是 6 厘米。', 'The answer is 6 cm.', '答えは 6 cm です。'),
  steps=[['先算長方形的周長：2 ×（8 + 4）= 24 公分。',
          '正方形的周長也是 24 公分，而正方形四邊一樣長。',
          '所以邊長是 24 ÷ 4 = 6 公分。（順帶一提，兩者周長相同時面積並不相同：長方形是 32，正方形是 36。）'],
         ['先算长方形的周长：2 ×（8 + 4）= 24 厘米。',
          '正方形的周长也是 24 厘米，而正方形四边一样长。',
          '所以边长是 24 ÷ 4 = 6 厘米。（顺带一提，两者周长相同时面积并不相同：长方形是 32，正方形是 36。）'],
         ['First find the rectangle\'s perimeter: 2 × (8 + 4) = 24 cm.',
          'The square has the same perimeter of 24 cm, and all four of its sides are equal.',
          'So each side is 24 ÷ 4 = 6 cm. Note in passing that equal perimeters do not mean equal areas: the rectangle covers 32 and the square 36.'],
         ['まず長方形のまわりの長さを求めます。2 ×（8 + 4）= 24 cm です。',
          '正方形のまわりの長さも 24 cm で、4 辺はすべて同じ長さです。',
          'したがって 1 辺は 24 ÷ 4 = 6 cm です。なお まわりの長さが同じでも面積は同じではなく、長方形は 32、正方形は 36 です。']],
  notes='Replaced 2026-08-28: the previous cut-the-corners question duplicated geometry_grade2_foundation_017 with the same answer 0.'),

'geometry_grade5_foundation_029': dict(
  subtopic='isosceles_angle_ratio', value='90', digits=2, figure_none=True,
  prompt=L('一個等腰三角形的頂角度數，剛好是一個底角度數的 2 倍。這個三角形的頂角是幾度？',
           '一个等腰三角形的顶角度数，刚好是一个底角度数的 2 倍。这个三角形的顶角是几度？',
           'In an isosceles triangle the apex angle is exactly twice one of the base angles. How many degrees is the apex angle?',
           '二等辺三角形の頂角の大きさが、底角 1 つの大きさのちょうど 2 倍になっています。頂角は何度ですか。'),
  answer=L('答案是 90 度。', '答案是 90 度。', 'The answer is 90 degrees.', '答えは 90 度です。'),
  steps=[['等腰三角形的兩個底角一樣大，把一個底角看成 1 份。',
          '頂角是底角的 2 倍，也就是 2 份。三個角合起來是 1 + 1 + 2 = 4 份。',
          '三角形內角和是 180 度，所以 1 份是 180 ÷ 4 = 45 度。',
          '頂角是 2 份，也就是 45 × 2 = 90 度。（這個三角形其實是等腰直角三角形。）'],
         ['等腰三角形的两个底角一样大，把一个底角看成 1 份。',
          '顶角是底角的 2 倍，也就是 2 份。三个角合起来是 1 + 1 + 2 = 4 份。',
          '三角形内角和是 180 度，所以 1 份是 180 ÷ 4 = 45 度。',
          '顶角是 2 份，也就是 45 × 2 = 90 度。（这个三角形其实是等腰直角三角形。）'],
         ['The two base angles of an isosceles triangle are equal, so treat one base angle as 1 part.',
          'The apex angle is twice a base angle, that is 2 parts, and the three angles together make 1 + 1 + 2 = 4 parts.',
          'The angles of a triangle add to 180 degrees, so one part is 180 ÷ 4 = 45 degrees.',
          'The apex angle is 2 parts, that is 45 × 2 = 90 degrees, so the triangle is a right isosceles triangle.'],
         ['二等辺三角形の 2 つの底角は等しいので、底角 1 つを 1 つ分と考えます。',
          '頂角は底角の 2 倍なので 2 つ分で、3 つの角を合わせると 1 + 1 + 2 = 4 つ分です。',
          '三角形の内角の和は 180 度なので、1 つ分は 180 ÷ 4 = 45 度です。',
          '頂角は 2 つ分で 45 × 2 = 90 度です。つまり直角二等辺三角形になります。']],
  notes='Replaced 2026-08-28: the previous question about an isosceles triangle with sides 5 and 11 duplicated geometry_grade8_foundation_025 with the same answer 27. The old shape_diagram figure was removed because the new question is about angles.'),

'mixed_grade5_foundation_006': dict(
  subtopic='factor_triple_min_surface', value='52', digits=2,
  prompt=L('小安用 24 個邊長 1 公分的小正方體，堆成一個實心的長方體，24 個全部用完。這個長方體的表面積最小可能是幾平方公分？',
           '小安用 24 个边长 1 厘米的小正方体，堆成一个实心的长方体，24 个全部用完。这个长方体的表面积最小可能是几平方厘米？',
           'An uses all 24 unit cubes, each 1 cm on a side, to build a solid cuboid. What is the smallest possible surface area of that cuboid, in square centimetres?',
           'アンは 1 辺 1 cm の小さな立方体 24 個をすべて使って、中身のつまった直方体を作ります。この直方体の表面積は最小で何平方 cm ですか。'),
  answer=L('答案是 52 平方公分。', '答案是 52 平方厘米。', 'The answer is 52 square centimetres.', '答えは 52 平方 cm です。'),
  steps=[['長方體的長、寬、高都是整數，而且三者相乘要等於 24，所以要先把 24 拆成三個正整數的乘積。',
          '所有拆法（不計順序）是 1×1×24、1×2×12、1×3×8、1×4×6、2×2×6、2×3×4。',
          '表面積是 2 ×（長×寬 + 寬×高 + 高×長）。逐一算出來是 98、76、70、68、56、52。',
          '三邊越接近正方體，表面積越小，最小的是 2×3×4，表面積 2 ×（6 + 12 + 8）= 52 平方公分。'],
         ['长方体的长、宽、高都是整数，而且三者相乘要等于 24，所以要先把 24 拆成三个正整数的乘积。',
          '所有拆法（不计顺序）是 1×1×24、1×2×12、1×3×8、1×4×6、2×2×6、2×3×4。',
          '表面积是 2 ×（长×宽 + 宽×高 + 高×长）。逐一算出来是 98、76、70、68、56、52。',
          '三边越接近正方体，表面积越小，最小的是 2×3×4，表面积 2 ×（6 + 12 + 8）= 52 平方厘米。'],
         ['The length, width and height are whole numbers whose product is 24, so first split 24 into three positive factors.',
          'Ignoring order, the splits are 1×1×24, 1×2×12, 1×3×8, 1×4×6, 2×2×6 and 2×3×4.',
          'The surface area is 2 × (length×width + width×height + height×length), which gives 98, 76, 70, 68, 56 and 52 in turn.',
          'The closer the three edges are to each other, the smaller the surface area, and the smallest is 2×3×4 with 2 × (6 + 12 + 8) = 52 square centimetres.'],
         ['直方体のたて・よこ・高さは整数で、かけると 24 になるので、まず 24 を 3 つの正の整数の積に分けます。',
          '順序を区別しない分け方は 1×1×24、1×2×12、1×3×8、1×4×6、2×2×6、2×3×4 です。',
          '表面積は 2 ×（たて×よこ ＋ よこ×高さ ＋ 高さ×たて）で、順に 98、76、70、68、56、52 になります。',
          '3 辺が近いほど表面積は小さくなり、最小は 2×3×4 で 2 ×（6 + 12 + 8）= 52 平方 cm です。']],
  notes='Replaced 2026-08-28: the previous question about the 15th digit of 123456789101112... duplicated arithmetic_grade3_foundation_026 with the same answer 2. The new question keeps the mixed topic by combining factorisation with surface area.'),
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
        if s.get('drop_options'):
            q.pop('options', None)
        if s.get('figure_none'):
            q['figure'] = {'type': 'custom', 'kind': 'none', 'params': {}}
        q['answerMode'] = 'integer_input'
        q['correctAnswer'] = {'type': 'integer', 'value': s['value']}
        q['inputConstraints'] = {'allowNegative': False, 'maxDigits': s['digits']}
        q['source'] = dict(q['source'], notes=s['notes'])
        assert len({len(v) for v in q['solutionSteps'].values()}) == 1, q['id']
        dirty = True
        print('替換 %-40s -> %s' % (q['id'], s['value']))
    if dirty:
        io.open(path, 'w', encoding='utf-8').write(
            json.dumps(pack, ensure_ascii=False, indent=2) + '\n')
