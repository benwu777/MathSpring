#!/usr/bin/env ruby
# grade5 第二輪擴充：幾何 4 題、算術 6 題。
# 每題都先過 scripts/question_similarity_audit.py --candidates 再人工複查，
# 因此 logic 一題都沒有：grade5 邏輯 45 題已佔 30 個子分類，
# 十個候選全部撞到既有題（骰子相對面、循環賽勝場、繩子對折、排隊左右、
# 取物必勝、日曆五個週六），寧可少補也不灌水。
require 'json'

def t(zh, zhs, en, ja) = { 'zh-Hant' => zh, 'zh-Hans' => zhs, 'en' => en, 'ja' => ja }

def q(id:, subtopic:, prompt:, answer:, steps:, figure:, mode:, correct:,
      options: nil, constraints: nil, notes:)
  h = {
    'reviewStatus' => 'ok', 'topic' => id.split('_').first, 'subtopic' => subtopic,
    'difficulty' => 'foundation', 'levelStage' => 'grade5', 'challengeTier' => 'foundation',
    'prompt' => prompt, 'answer' => answer,
    'solutionSteps' => { 'zh-Hant' => steps[0], 'zh-Hans' => steps[1], 'en' => steps[2], 'ja' => steps[3] },
    'figure' => figure
  }
  h['options'] = options if options
  h['source'] = { 'type' => 'rewritten_olympiad_style', 'name' => 'MathSpring Editorial',
                  'reference' => "#{id.split('_').first}-grade5-foundation", 'notes' => notes }
  h['answerMode'] = mode
  h['correctAnswer'] = correct
  h['inputConstraints'] = constraints if constraints
  h['id'] = id
  h
end

NONE = { 'type' => 'custom', 'kind' => 'none', 'params' => {} }
def scene(p) = { 'type' => 'custom', 'kind' => 'geometry_scene',
                 'params' => p.merge('kind' => 'geometry_scene') }
def int(d) = { 'allowNegative' => false, 'maxDigits' => d }
def ans(v) = { 'type' => 'integer', 'value' => v }

# ---- 幾何 049–052 ----
GEO = [
  q(id: 'geometry_grade5_foundation_049', subtopic: 'rectangular_prism_edges',
    prompt: t('一個長方體所有邊的長度加起來一共是 48 公分。已知它的長是 5 公分、寬是 4 公分。這個長方體的高是幾公分？',
              '一个长方体所有棱的长度加起来一共是 48 厘米。已知它的长是 5 厘米、宽是 4 厘米。这个长方体的高是几厘米？',
              'The lengths of all the edges of a cuboid add up to 48 cm. Its length is 5 cm and its width is 4 cm. How many centimetres is its height?',
              '直方体のすべての辺の長さの合計は 48 cm です。たての長さが 5 cm、よこの長さが 4 cm のとき、高さは何 cm ですか。'),
    answer: t('答案是 3 公分。', '答案是 3 厘米。', 'The answer is 3 cm.', '答えは 3 cm です。'),
    steps: [
      ['長方體有 12 條邊，長、寬、高各有 4 條。',
       '所以所有邊長的總和是 4 ×（長 + 寬 + 高）。',
       '48 ÷ 4 = 12，表示長 + 寬 + 高 = 12 公分。',
       '高 = 12 − 5 − 4 = 3 公分。'],
      ['长方体有 12 条棱，长、宽、高各有 4 条。',
       '所以所有棱长的总和是 4 ×（长 + 宽 + 高）。',
       '48 ÷ 4 = 12，表示长 + 宽 + 高 = 12 厘米。',
       '高 = 12 − 5 − 4 = 3 厘米。'],
      ['A cuboid has 12 edges: four of each of the length, the width and the height.',
       'So the total edge length equals 4 × (length + width + height).',
       '48 ÷ 4 = 12, so length + width + height = 12 cm.',
       'The height is 12 − 5 − 4 = 3 cm.'],
      ['直方体には辺が 12 本あり、たて・よこ・高さがそれぞれ 4 本ずつです。',
       'したがって辺の長さの合計は 4 ×（たて ＋ よこ ＋ 高さ）になります。',
       '48 ÷ 4 = 12 なので、たて ＋ よこ ＋ 高さ = 12 cm です。',
       '高さは 12 − 5 − 4 = 3 cm です。']],
    figure: NONE, mode: 'integer_input', correct: ans('3'), constraints: int(1),
    notes: 'Original composition in the Math Kangaroo grade 5-6 style. The intended move is to see the 12 edges as four copies of (l + w + h) and then work backwards; renderer has no solid shapes, so no figure is shipped.'),

  q(id: 'geometry_grade5_foundation_050', subtopic: 'painted_cube',
    prompt: t('用 27 個一樣大的小正方體堆成一個 3 × 3 × 3 的大正方體，再把大正方體的外表面全部塗上顏色。等顏色乾了以後把它拆開，恰好有 3 個面被塗到顏色的小正方體有幾個？',
              '用 27 个一样大的小正方体堆成一个 3 × 3 × 3 的大正方体，再把大正方体的外表面全部涂上颜色。等颜色干了以后把它拆开，恰好有 3 个面被涂到颜色的小正方体有几个？',
              'Twenty-seven identical small cubes are stacked into a 3 × 3 × 3 large cube, and the whole outer surface of the large cube is painted. After the paint dries the cube is taken apart. How many of the small cubes have exactly 3 painted faces?',
              '同じ大きさの小さな立方体 27 個を積んで 3 × 3 × 3 の大きな立方体を作り、その外側の表面をすべて色でぬります。かわいてからばらばらにしたとき、ちょうど 3 つの面がぬられている小さな立方体は何個ありますか。'),
    answer: t('答案是 8 個。', '答案是 8 个。', 'The answer is 8.', '答えは 8 個です。'),
    steps: [
      ['一個小正方體被塗到幾個面，看它原本貼在大正方體的哪個位置。',
       '在角落的小正方體有三個面露在外面，所以恰好被塗 3 面。',
       '在稜上（不是角落）的只露兩面，在面中央的只露一面，最中心的那一個完全沒露出來。',
       '大正方體有 8 個角，所以恰好塗到 3 面的小正方體有 8 個。'],
      ['一个小正方体被涂到几个面，看它原本贴在大正方体的哪个位置。',
       '在角落的小正方体有三个面露在外面，所以恰好被涂 3 面。',
       '在棱上（不是角落）的只露两面，在面中央的只露一面，最中心的那一个完全没露出来。',
       '大正方体有 8 个角，所以恰好涂到 3 面的小正方体有 8 个。'],
      ['How many faces a small cube gets painted depends on where it sits in the big cube.',
       'A small cube at a corner has three faces on the outside, so exactly 3 of its faces are painted.',
       'One along an edge but not at a corner shows only two faces, one in the middle of a face shows only one, and the very central cube shows none.',
       'The big cube has 8 corners, so exactly 8 small cubes have 3 painted faces.'],
      ['小さな立方体がいくつの面をぬられるかは、大きな立方体のどの位置にあったかで決まります。',
       'かどにある小さな立方体は 3 つの面が外に出ているので、ちょうど 3 面がぬられます。',
       'へりにあって かどではないものは 2 面だけ、面の中央にあるものは 1 面だけ、いちばん中心のものは 1 面もぬられません。',
       '大きな立方体のかどは 8 か所なので、3 面ぬられた小さな立方体は 8 個です。']],
    figure: NONE, mode: 'integer_input', correct: ans('8'), constraints: int(1),
    notes: 'Classic painted-cube classification, authored fresh for grade 5. The intended move is classifying the 27 positions by how many faces are exposed rather than counting one by one; renderer has no solid shapes, so no figure is shipped.'),

  q(id: 'geometry_grade5_foundation_051', subtopic: 'square_strip_perimeter',
    prompt: t('如圖，一個大正方形被三條平行線平均切成 4 個完全一樣的長條形。每一個長條形的周長都是 30 公分。這個大正方形的邊長是幾公分？',
              '如图，一个大正方形被三条平行线平均切成 4 个完全一样的长条形。每一个长条形的周长都是 30 厘米。这个大正方形的边长是几厘米？',
              'As in the figure, a large square is cut by three parallel lines into 4 identical strips. Each strip has perimeter 30 cm. How many centimetres is the side of the large square?',
              '図のように、大きな正方形を 3 本の平行な線で 4 つの合同な細長い長方形に切り分けます。それぞれの長方形のまわりの長さは 30 cm です。大きな正方形の 1 辺は何 cm ですか。'),
    answer: t('答案是 12 公分。', '答案是 12 厘米。', 'The answer is 12 cm.', '答えは 12 cm です。'),
    steps: [
      ['設大正方形的邊長是一個未知的長度。每個長條形的長就等於這個邊長。',
       '四條一樣寬，所以每個長條形的寬是邊長的四分之一。',
       '長條形的周長 = 2 ×（長 + 寬）= 2 ×（邊長 + 邊長的四分之一），也就是邊長的兩倍半。',
       '邊長的 2.5 倍是 30 公分，所以邊長 = 30 ÷ 2.5 = 12 公分。'],
      ['设大正方形的边长是一个未知的长度。每个长条形的长就等于这个边长。',
       '四条一样宽，所以每个长条形的宽是边长的四分之一。',
       '长条形的周长 = 2 ×（长 + 宽）= 2 ×（边长 + 边长的四分之一），也就是边长的两倍半。',
       '边长的 2.5 倍是 30 厘米，所以边长 = 30 ÷ 2.5 = 12 厘米。'],
      ['Let the side of the large square be the unknown length. Each strip is exactly that long.',
       'The four strips are equally wide, so each strip is one quarter of the side wide.',
       'The perimeter of a strip is 2 × (length + width) = 2 × (side + one quarter of the side), which is 2.5 times the side.',
       '2.5 times the side is 30 cm, so the side is 30 ÷ 2.5 = 12 cm.'],
      ['大きな正方形の 1 辺を求める長さとします。細長い長方形のたての長さはこの 1 辺と同じです。',
       '4 つの幅は等しいので、1 つの幅は 1 辺の 4 分の 1 です。',
       '細長い長方形のまわりの長さは 2 ×（1 辺 ＋ 1 辺の 4 分の 1）で、1 辺の 2.5 倍になります。',
       '1 辺の 2.5 倍が 30 cm なので、1 辺は 30 ÷ 2.5 = 12 cm です。']],
    figure: scene(
      'bounds' => { 'minX' => -0.4, 'minY' => -0.4, 'maxX' => 4.4, 'maxY' => 4.4 },
      'points' => [
        { 'name' => 'A', 'x' => 0, 'y' => 4, 'pos' => 'tl' },
        { 'name' => 'B', 'x' => 4, 'y' => 4, 'pos' => 'tr' },
        { 'name' => 'C', 'x' => 4, 'y' => 0, 'pos' => 'br' },
        { 'name' => 'D', 'x' => 0, 'y' => 0, 'pos' => 'bl' },
        { 'name' => 'P1', 'x' => 0, 'y' => 3, 'visible' => false },
        { 'name' => 'Q1', 'x' => 4, 'y' => 3, 'visible' => false },
        { 'name' => 'P2', 'x' => 0, 'y' => 2, 'visible' => false },
        { 'name' => 'Q2', 'x' => 4, 'y' => 2, 'visible' => false },
        { 'name' => 'P3', 'x' => 0, 'y' => 1, 'visible' => false },
        { 'name' => 'Q3', 'x' => 4, 'y' => 1, 'visible' => false }
      ],
      'segments' => [
        { 'from' => 'A', 'to' => 'B', 'style' => 'solid' },
        { 'from' => 'B', 'to' => 'C', 'style' => 'solid' },
        { 'from' => 'C', 'to' => 'D', 'style' => 'solid' },
        { 'from' => 'D', 'to' => 'A', 'style' => 'solid' },
        { 'from' => 'P1', 'to' => 'Q1', 'style' => 'solid' },
        { 'from' => 'P2', 'to' => 'Q2', 'style' => 'solid' },
        { 'from' => 'P3', 'to' => 'Q3', 'style' => 'solid' }
      ]),
    mode: 'integer_input', correct: ans('12'), constraints: int(2),
    notes: 'Original composition in the Math Kangaroo grade 5-6 style. The intended move is expressing the strip perimeter as a multiple of the unknown side; the figure shows only the cutting pattern described in the text and does not reveal the answer.'),

  q(id: 'geometry_grade5_foundation_052', subtopic: 'fold_overlap_shape',
    prompt: t('長方形紙片 ABCD 如圖，沿著對角線 BD 把三角形 ABD 摺過去，蓋在三角形 CBD 上面。摺好以後，兩個三角形重疊的部分是什麼形狀？',
              '长方形纸片 ABCD 如图，沿着对角线 BD 把三角形 ABD 折过去，盖在三角形 CBD 上面。折好以后，两个三角形重叠的部分是什么形状？',
              'The rectangular sheet ABCD is shown in the figure. Triangle ABD is folded over the diagonal BD so that it lands on top of triangle CBD. After the fold, what shape is the region where the two triangles overlap?',
              '図のような長方形の紙 ABCD を、対角線 BD にそって三角形 ABD を折り返し、三角形 CBD の上に重ねます。折ったあと、2 つの三角形が重なった部分はどんな形になりますか。'),
    answer: t('答案是等腰三角形。', '答案是等腰三角形。', 'The answer is an isosceles triangle.', '答えは二等辺三角形です。'),
    steps: [
      ['摺過去以後，A 落到 BD 另一邊的新位置 A′。重疊的部分是由 B、D 和「D A′ 與 BC 的交點 P」圍成的三角形 PBD。',
       '摺紙不會改變角度，所以角 BDP 和原來的角 BDA 一樣大。',
       '長方形的 AD 和 BC 平行，被 BD 截出的內錯角相等，所以角 BDA 和角 DBP 一樣大。',
       '兩式合起來得到角 BDP = 角 DBP，三角形 PBD 有兩個底角相等，所以重疊部分是等腰三角形。'],
      ['折过去以后，A 落到 BD 另一边的新位置 A′。重叠的部分是由 B、D 和「D A′ 与 BC 的交点 P」围成的三角形 PBD。',
       '折纸不会改变角度，所以角 BDP 和原来的角 BDA 一样大。',
       '长方形的 AD 和 BC 平行，被 BD 截出的内错角相等，所以角 BDA 和角 DBP 一样大。',
       '两式合起来得到角 BDP = 角 DBP，三角形 PBD 有两个底角相等，所以重叠部分是等腰三角形。'],
      ['After the fold A lands at a new position A′ on the other side of BD. The overlap is the triangle PBD, where P is the point at which DA′ meets BC.',
       'Folding does not change angles, so angle BDP equals the original angle BDA.',
       'In the rectangle AD is parallel to BC, and BD cuts them, so the alternate angles BDA and DBP are equal.',
       'Putting the two together gives angle BDP = angle DBP, so triangle PBD has two equal base angles and the overlap is an isosceles triangle.'],
      ['折り返すと A は BD の反対側の新しい位置 A′ に移ります。重なった部分は、B と D、そして DA′ と BC の交点 P がつくる三角形 PBD です。',
       '折っても角の大きさは変わらないので、角 BDP はもとの角 BDA と等しくなります。',
       '長方形では AD と BC が平行で、BD がこれらを横切るので、錯角である角 BDA と角 DBP は等しくなります。',
       '2 つを合わせると角 BDP = 角 DBP となり、三角形 PBD は 2 つの底角が等しいので、重なった部分は二等辺三角形です。']],
    figure: scene(
      'bounds' => { 'minX' => -0.5, 'minY' => -0.5, 'maxX' => 5.5, 'maxY' => 3.5 },
      'points' => [
        { 'name' => 'A', 'x' => 0, 'y' => 3, 'pos' => 'tl' },
        { 'name' => 'B', 'x' => 0, 'y' => 0, 'pos' => 'bl' },
        { 'name' => 'C', 'x' => 5, 'y' => 0, 'pos' => 'br' },
        { 'name' => 'D', 'x' => 5, 'y' => 3, 'pos' => 'tr' }
      ],
      'segments' => [
        { 'from' => 'A', 'to' => 'B', 'style' => 'solid' },
        { 'from' => 'B', 'to' => 'C', 'style' => 'solid' },
        { 'from' => 'C', 'to' => 'D', 'style' => 'solid' },
        { 'from' => 'D', 'to' => 'A', 'style' => 'solid' },
        { 'from' => 'B', 'to' => 'D', 'style' => 'construction' }
      ]),
    mode: 'multiple_choice',
    options: { 'A' => t('等腰三角形', '等腰三角形', 'An isosceles triangle', '二等辺三角形'),
               'B' => t('等邊三角形', '等边三角形', 'An equilateral triangle', '正三角形'),
               'C' => t('直角三角形', '直角三角形', 'A right triangle', '直角三角形'),
               'D' => t('長方形', '长方形', 'A rectangle', '長方形') },
    correct: { 'type' => 'choice', 'value' => 'A' },
    notes: 'Original composition in the Math Kangaroo grade 5-6 folding style. The intended move is combining the fold-invariance of angles with alternate angles on the parallel sides; the figure shows only the sheet and the crease, so the overlapping shape is not given away.')
]

# ---- 算術 068–073 ----
ARI = [
  q(id: 'arithmetic_grade5_foundation_068', subtopic: 'sequence_sum',
    prompt: t('小安第一天存 5 元，之後每一天存的錢都比前一天多 2 元。連續存 10 天後，他一共存了多少元？',
              '小安第一天存 5 元，之后每一天存的钱都比前一天多 2 元。连续存 10 天后，他一共存了多少元？',
              'On the first day An saves 5 dollars, and on every later day he saves 2 dollars more than on the day before. After saving for 10 days in a row, how many dollars has he saved altogether?',
              'アンは 1 日目に 5 円ためて、次の日からは前の日より 2 円ずつ多くためていきます。10 日間続けてためたあと、合計で何円ためたことになりますか。'),
    answer: t('答案是 140 元。', '答案是 140 元。', 'The answer is 140 dollars.', '答えは 140 円です。'),
    steps: [
      ['每天存的錢依序是 5、7、9、⋯，每次多 2 元。',
       '第 10 天存的是 5 + 2 × 9 = 23 元。',
       '把這 10 個數頭尾兩兩配對：5 + 23 = 28，7 + 21 = 28，⋯，每一對都是 28，一共可以配成 5 對。',
       '所以總共是 28 × 5 = 140 元。'],
      ['每天存的钱依次是 5、7、9、⋯，每次多 2 元。',
       '第 10 天存的是 5 + 2 × 9 = 23 元。',
       '把这 10 个数头尾两两配对：5 + 23 = 28，7 + 21 = 28，⋯，每一对都是 28，一共可以配成 5 对。',
       '所以总共是 28 × 5 = 140 元。'],
      ['The daily amounts are 5, 7, 9, … , going up by 2 each time.',
       'On the tenth day he saves 5 + 2 × 9 = 23 dollars.',
       'Pair the ten numbers from the two ends inwards: 5 + 23 = 28, 7 + 21 = 28, … Every pair adds to 28 and there are 5 such pairs.',
       'So the total is 28 × 5 = 140 dollars.'],
      ['毎日ためる金額は 5、7、9、⋯ と 2 円ずつ増えていきます。',
       '10 日目にためるのは 5 + 2 × 9 = 23 円です。',
       '10 個の数を両はしから組にすると、5 + 23 = 28、7 + 21 = 28、⋯ とどの組も 28 になり、組は 5 つできます。',
       'したがって合計は 28 × 5 = 140 円です。']],
    figure: NONE, mode: 'integer_input', correct: ans('140'), constraints: int(3),
    notes: 'Original composition in the Math Kangaroo grade 5-6 style. The intended move is the head-to-tail pairing trick rather than adding ten terms one by one.'),

  q(id: 'arithmetic_grade5_foundation_069', subtopic: 'digit_sum_divisibility',
    prompt: t('有一些兩位數，它們各位數字的和是 12，而且本身是 4 的倍數。這樣的兩位數一共有幾個？',
              '有一些两位数，它们各位数字的和是 12，而且本身是 4 的倍数。这样的两位数一共有几个？',
              'Some two-digit numbers have digits that add up to 12 and are themselves multiples of 4. How many such two-digit numbers are there?',
              '2 けたの整数のうち、各位の数字の和が 12 で、しかもその数が 4 の倍数であるものがあります。そのような 2 けたの整数は全部で何個ありますか。'),
    answer: t('答案是 2 個。', '答案是 2 个。', 'The answer is 2.', '答えは 2 個です。'),
    steps: [
      ['先找出所有各位數字和是 12 的兩位數：39、48、57、66、75、84、93。',
       '一個數是不是 4 的倍數，只要看它本身能不能被 4 整除。',
       '逐一檢查：39、57、66、75、93 都除不盡，只有 48 = 4 × 12 和 84 = 4 × 21 可以。',
       '所以符合條件的兩位數有 48 和 84，一共 2 個。'],
      ['先找出所有各位数字和是 12 的两位数：39、48、57、66、75、84、93。',
       '一个数是不是 4 的倍数，只要看它本身能不能被 4 整除。',
       '逐一检查：39、57、66、75、93 都除不尽，只有 48 = 4 × 12 和 84 = 4 × 21 可以。',
       '所以符合条件的两位数有 48 和 84，一共 2 个。'],
      ['First list every two-digit number whose digits add to 12: 39, 48, 57, 66, 75, 84, 93.',
       'To be a multiple of 4 the number itself must be divisible by 4.',
       'Checking them in turn, 39, 57, 66, 75 and 93 all leave a remainder, while 48 = 4 × 12 and 84 = 4 × 21 do not.',
       'So the numbers that work are 48 and 84, which is 2 of them.'],
      ['まず各位の数字の和が 12 になる 2 けたの整数をすべて書き出します：39、48、57、66、75、84、93。',
       '4 の倍数かどうかは、その数が 4 で割り切れるかどうかで決まります。',
       '順に調べると、39、57、66、75、93 は割り切れず、48 = 4 × 12 と 84 = 4 × 21 だけが割り切れます。',
       'したがって条件に合う 2 けたの整数は 48 と 84 の 2 個です。']],
    figure: NONE, mode: 'integer_input', correct: ans('2'), constraints: int(1),
    notes: 'Original composition in the Math Kangaroo grade 5-6 style. The intended move is generating the candidate list from the digit-sum condition first and only then filtering by divisibility.'),

  q(id: 'arithmetic_grade5_foundation_070', subtopic: 'interval_counting',
    prompt: t('一部電梯從 1 樓上到 4 樓要花 12 秒，而且每上升一層樓花的時間都一樣。照這個速度，從 2 樓上到 9 樓要花幾秒？',
              '一部电梯从 1 楼上到 4 楼要花 12 秒，而且每上升一层楼花的时间都一样。照这个速度，从 2 楼上到 9 楼要花几秒？',
              'A lift takes 12 seconds to go from floor 1 up to floor 4, and it takes the same time to rise each single floor. At that rate, how many seconds does it take to go from floor 2 up to floor 9?',
              'エレベーターは 1 階から 4 階まで上がるのに 12 秒かかり、1 階分上がるのにかかる時間はどこでも同じです。この速さで 2 階から 9 階まで上がるには何秒かかりますか。'),
    answer: t('答案是 28 秒。', '答案是 28 秒。', 'The answer is 28 seconds.', '答えは 28 秒です。'),
    steps: [
      ['從 1 樓到 4 樓不是上升 4 層，而是上升 4 − 1 = 3 層。',
       '所以每上升一層要花 12 ÷ 3 = 4 秒。',
       '從 2 樓到 9 樓要上升 9 − 2 = 7 層。',
       '所以要花 4 × 7 = 28 秒。'],
      ['从 1 楼到 4 楼不是上升 4 层，而是上升 4 − 1 = 3 层。',
       '所以每上升一层要花 12 ÷ 3 = 4 秒。',
       '从 2 楼到 9 楼要上升 9 − 2 = 7 层。',
       '所以要花 4 × 7 = 28 秒。'],
      ['Going from floor 1 to floor 4 is not 4 floors of climbing but 4 − 1 = 3 floors.',
       'So each single floor takes 12 ÷ 3 = 4 seconds.',
       'Going from floor 2 to floor 9 is 9 − 2 = 7 floors of climbing.',
       'So it takes 4 × 7 = 28 seconds.'],
      ['1 階から 4 階までは 4 階分ではなく、4 − 1 = 3 階分の上昇です。',
       'したがって 1 階分の上昇には 12 ÷ 3 = 4 秒かかります。',
       '2 階から 9 階までは 9 − 2 = 7 階分の上昇です。',
       'よってかかる時間は 4 × 7 = 28 秒です。']],
    figure: NONE, mode: 'integer_input', correct: ans('28'), constraints: int(2),
    notes: 'Original composition in the Math Kangaroo grade 5-6 style. The intended move is counting gaps rather than floors, and the second leg deliberately does not start at floor 1 so the trap cannot be dodged by habit.'),

  q(id: 'arithmetic_grade5_foundation_071', subtopic: 'price_equation',
    prompt: t('小明帶的錢剛好可以買若干支每支 8 元的筆。如果改買每支 5 元的筆，用同樣的錢可以多買 3 支，而且也剛好花完。小明帶了多少元？',
              '小明带的钱刚好可以买若干支每支 8 元的笔。如果改买每支 5 元的笔，用同样的钱可以多买 3 支，而且也刚好花完。小明带了多少元？',
              'Ming has exactly enough money to buy a whole number of pens costing 8 dollars each. If he buys pens costing 5 dollars each instead, the same money buys 3 more pens and is again spent exactly. How many dollars does Ming have?',
              'ミンの持っているお金では、1 本 8 円のペンをちょうど何本か買うことができます。1 本 5 円のペンに変えると、同じお金で 3 本多く買えて、やはりちょうど使い切ります。ミンはいくら持っていますか。'),
    answer: t('答案是 40 元。', '答案是 40 元。', 'The answer is 40 dollars.', '答えは 40 円です。'),
    steps: [
      ['設原本買了幾支 8 元的筆，那麼改買 5 元的筆時支數就是原本再加 3。',
       '兩種買法花掉的錢一樣，所以 8 ×（支數）＝ 5 ×（支數 + 3）。',
       '右邊展開是 5 ×（支數）+ 15，兩邊都減掉 5 ×（支數），得到 3 ×（支數）= 15，所以支數是 5。',
       '小明帶的錢是 8 × 5 = 40 元（驗算：40 ÷ 5 = 8 支，比 5 支多 3 支，正確）。'],
      ['设原本买了几支 8 元的笔，那么改买 5 元的笔时支数就是原本再加 3。',
       '两种买法花掉的钱一样，所以 8 ×（支数）＝ 5 ×（支数 + 3）。',
       '右边展开是 5 ×（支数）+ 15，两边都减掉 5 ×（支数），得到 3 ×（支数）= 15，所以支数是 5。',
       '小明带的钱是 8 × 5 = 40 元（验算：40 ÷ 5 = 8 支，比 5 支多 3 支，正确）。'],
      ['Let the number of 8-dollar pens be the unknown; then the number of 5-dollar pens is that number plus 3.',
       'Both ways spend the same money, so 8 × (number) = 5 × (number + 3).',
       'The right side is 5 × (number) + 15; subtracting 5 × (number) from both sides gives 3 × (number) = 15, so the number is 5.',
       'Ming has 8 × 5 = 40 dollars. Checking: 40 ÷ 5 = 8 pens, which is 3 more than 5 pens.'],
      ['8 円のペンを買う本数を求める数とすると、5 円のペンの本数はそれより 3 本多くなります。',
       'どちらの買い方でも使う金額は同じなので、8 ×（本数）＝ 5 ×（本数 ＋ 3）です。',
       '右辺は 5 ×（本数）＋ 15 なので、両辺から 5 ×（本数）を引くと 3 ×（本数）= 15 となり、本数は 5 本です。',
       'ミンの持っているお金は 8 × 5 = 40 円です（確かめ：40 ÷ 5 = 8 本で、5 本より 3 本多い）。']],
    figure: NONE, mode: 'integer_input', correct: ans('40'), constraints: int(2),
    notes: 'Original composition in the Math Kangaroo grade 5-6 style. The intended move is equating the same total spent under two unit prices, which forces a one-unknown equation rather than direct arithmetic.'),

  q(id: 'arithmetic_grade5_foundation_072', subtopic: 'square_array',
    prompt: t('一個班級的學生站成一個正方形方陣，每一排的人數都一樣多。已知最外面一圈站了 28 人。這個班級一共有幾人？',
              '一个班级的学生站成一个正方形方阵，每一排的人数都一样多。已知最外面一圈站了 28 人。这个班级一共有几人？',
              'The students of a class stand in a square array with the same number of students in every row. The outermost ring of the array contains 28 students. How many students are in the class altogether?',
              'あるクラスの生徒が、どの列も同じ人数になるように正方形の形にならびます。いちばん外側の 1 周には 28 人がならんでいます。このクラスの生徒は全部で何人ですか。'),
    answer: t('答案是 64 人。', '答案是 64 人。', 'The answer is 64.', '答えは 64 人です。'),
    steps: [
      ['最外圈由四條邊組成，但四個角落的人會被相鄰兩條邊各數一次。',
       '所以最外圈的人數是 4 ×（每邊人數）− 4，減掉的 4 就是被重複數到的四個角。',
       '4 ×（每邊人數）− 4 = 28，得到 4 ×（每邊人數）= 32，每邊有 8 人。',
       '整個方陣是 8 排、每排 8 人，所以一共有 8 × 8 = 64 人。'],
      ['最外圈由四条边组成，但四个角落的人会被相邻两条边各数一次。',
       '所以最外圈的人数是 4 ×（每边人数）− 4，减掉的 4 就是被重复数到的四个角。',
       '4 ×（每边人数）− 4 = 28，得到 4 ×（每边人数）= 32，每边有 8 人。',
       '整个方阵是 8 排、每排 8 人，所以一共有 8 × 8 = 64 人。'],
      ['The outer ring is made of four sides, but each of the four corner students is counted once by each of the two sides meeting there.',
       'So the ring holds 4 × (students per side) − 4, where the 4 subtracted is the four doubly counted corners.',
       'From 4 × (students per side) − 4 = 28 we get 4 × (students per side) = 32, so each side has 8 students.',
       'The whole array is 8 rows of 8, so the class has 8 × 8 = 64 students.'],
      ['いちばん外側の 1 周は 4 つの辺からできていますが、4 すみの生徒はとなり合う 2 つの辺で 1 回ずつ数えられてしまいます。',
       'したがって 1 周の人数は 4 ×（1 辺の人数）− 4 で、引く 4 は重ねて数えた 4 すみの分です。',
       '4 ×（1 辺の人数）− 4 = 28 より 4 ×（1 辺の人数）= 32 となり、1 辺は 8 人です。',
       '方陣全体は 8 列 × 8 人なので、クラスは全部で 8 × 8 = 64 人です。']],
    figure: NONE, mode: 'integer_input', correct: ans('64'), constraints: int(2),
    notes: 'Original composition in the Math Kangaroo grade 5-6 style. The intended move is the corner double-counting correction in the ring formula, then squaring; answering 28 ÷ 4 = 7 per side is the trap.'),

  q(id: 'arithmetic_grade5_foundation_073', subtopic: 'train_crossing',
    prompt: t('一列長 200 公尺的火車以每秒 20 公尺的速度前進，要完全通過一座長 600 公尺的橋。從車頭開上橋開始算，到車尾離開橋為止，一共要花幾秒？',
              '一列长 200 米的火车以每秒 20 米的速度前进，要完全通过一座长 600 米的桥。从车头开上桥开始算，到车尾离开桥为止，一共要花几秒？',
              'A train 200 metres long moves at 20 metres per second and has to cross a bridge 600 metres long. Counting from the moment the front of the train gets onto the bridge until the moment the back of the train leaves it, how many seconds does this take?',
              '長さ 200 m の列車が秒速 20 m で進み、長さ 600 m の橋をわたりきります。列車の先頭が橋にのった時から、最後尾が橋をはなれる時までに何秒かかりますか。'),
    answer: t('答案是 40 秒。', '答案是 40 秒。', 'The answer is 40 seconds.', '答えは 40 秒です。'),
    steps: [
      ['車尾要離開橋，車頭必須已經走過整座橋，再多走一個車身的長度。',
       '所以火車實際走的距離是橋長加車長：600 + 200 = 800 公尺。',
       '火車每秒走 20 公尺。',
       '所以花的時間是 800 ÷ 20 = 40 秒。'],
      ['车尾要离开桥，车头必须已经走过整座桥，再多走一个车身的长度。',
       '所以火车实际走的距离是桥长加车长：600 + 200 = 800 米。',
       '火车每秒走 20 米。',
       '所以花的时间是 800 ÷ 20 = 40 秒。'],
      ['For the back of the train to leave the bridge, the front must already have travelled the whole bridge and then one extra train length.',
       'So the distance actually travelled is the bridge plus the train: 600 + 200 = 800 metres.',
       'The train covers 20 metres each second.',
       'So the time taken is 800 ÷ 20 = 40 seconds.'],
      ['最後尾が橋をはなれるためには、先頭が橋全体を走りぬけた上に、さらに列車 1 台分の長さを進む必要があります。',
       'したがって実際に進む道のりは橋の長さと列車の長さの和で、600 + 200 = 800 m です。',
       '列車は 1 秒間に 20 m 進みます。',
       'よってかかる時間は 800 ÷ 20 = 40 秒です。']],
    figure: NONE, mode: 'integer_input', correct: ans('40'), constraints: int(2),
    notes: 'Original composition in the Math Kangaroo grade 5-6 style. The intended move is realising the travelled distance is bridge plus train length; using only the bridge length is the trap.')
]

{ 'geometry' => GEO, 'arithmetic' => ARI }.each do |topic, items|
  path = "assets/questions/#{topic}/grade5_foundation.#{topic}.v1.json"
  pack = JSON.parse(File.read(path))
  before = pack['questions'].size
  ids = pack['questions'].map { |x| x['id'] }
  items.each do |it|
    raise "duplicate id #{it['id']}" if ids.include?(it['id'])
    ids << it['id']
    pack['questions'] << it
  end
  File.write(path, JSON.pretty_generate(pack) + "\n")
  puts "#{topic}: #{before} -> #{pack['questions'].size}"
end
