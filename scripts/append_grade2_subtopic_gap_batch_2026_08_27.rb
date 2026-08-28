#!/usr/bin/env ruby
# frozen_string_literal: true

# grade2 subtopic 缺口補題（2026-08-27）
#   geometry  : shape_counting / rotation / overlap_area / grid_path
#   logic     : pairwise_sums / minimal_case / partial_order
#   arithmetic: handshake_counting / minimization / division_remainder

require 'json'
require 'set'

ROOT = File.expand_path('..', __dir__)
PATHS = {
  geometry: File.join(ROOT, 'assets/questions/geometry/grade2_foundation.geometry.v1.json'),
  logic: File.join(ROOT, 'assets/questions/logic/grade2_foundation.logic.v1.json'),
  arithmetic: File.join(ROOT, 'assets/questions/arithmetic/grade2_foundation.arithmetic.v1.json'),
}.freeze
MANIFEST_PATH = File.join(ROOT, 'assets/questions/manifest.json')

def load_json(path) = JSON.parse(File.read(path))
def save_json(path, data) = File.write(path, JSON.pretty_generate(data) + "\n")

def next_serial(pack)
  pack['questions'].map { |q| q['id'].split('_').last.to_i }.max + 1
end

def rewritten_source(reference, notes)
  { 'type' => 'rewritten_olympiad_style', 'name' => 'MathSpring Editorial',
    'reference' => reference, 'notes' => notes }
end

def figure_none = { 'type' => 'custom', 'kind' => 'none', 'params' => {} }

def geometry_scene(params)
  { 'type' => 'custom', 'kind' => 'geometry_scene',
    'params' => params.merge('kind' => 'geometry_scene') }
end

# 隱藏輔助點：只用來拉格線，不畫圓點也不標字（見 docs/geometry-figure-spec.md）
def hidden(name, x, y) = { 'name' => name, 'x' => x, 'y' => y, 'visible' => false }
def shown(name, x, y, pos) = { 'name' => name, 'x' => x, 'y' => y, 'pos' => pos }
def seg(a, b, style = 'solid') = { 'from' => a, 'to' => b, 'style' => style }

def build(topic:, subtopic:, prompt:, answer:, steps:, figure:, source:)
  { 'reviewStatus' => 'ok', 'topic' => topic, 'subtopic' => subtopic,
    'difficulty' => 'foundation', 'levelStage' => 'grade2', 'challengeTier' => 'foundation',
    'prompt' => prompt, 'answer' => answer, 'solutionSteps' => steps,
    'figure' => figure, 'source' => source }
end

def integer_q(value:, max_digits:, **rest)
  build(**rest).merge('answerMode' => 'integer_input',
                      'correctAnswer' => { 'type' => 'integer', 'value' => value },
                      'inputConstraints' => { 'allowNegative' => false, 'maxDigits' => max_digits })
end

def choice_q(options:, correct:, **rest)
  build(**rest).merge('answerMode' => 'multiple_choice', 'options' => options,
                      'correctAnswer' => { 'type' => 'choice', 'value' => correct })
end

GEOMETRY = [
  integer_q(
    topic: 'geometry', subtopic: 'shape_counting',
    prompt: {
      'zh-Hant' => '正方形 ABCD 的兩條對角線 AC 和 BD 都畫了出來，兩條對角線在正方形中間交於 O 點。在這樣的圖中，一共可以數出幾個三角形？',
      'zh-Hans' => '正方形 ABCD 的两条对角线 AC 和 BD 都画了出来，两条对角线在正方形中间交于 O 点。在这样的图中，一共可以数出几个三角形？',
      'en' => 'Both diagonals AC and BD of the square ABCD are drawn, meeting at the point O in the middle of the square. How many triangles can be counted in this figure altogether?',
      'ja' => '正方形 ABCD の 2 本の対角線 AC と BD がどちらも引かれていて、2 本は正方形のまん中の点 O で交わっています。この図の中に、三角形は全部でいくつありますか。',
    },
    answer: { 'zh-Hant' => '答案是 8。', 'zh-Hans' => '答案是 8。', 'en' => 'The answer is 8.', 'ja' => '答えは 8 です。' },
    steps: {
      'zh-Hant' => [
        '兩條對角線把正方形分成 4 個小三角形：ABO、BCO、CDO、DAO。',
        '每相鄰的兩個小三角形合起來，又會變成一個比較大的三角形。',
        '這樣的大三角形有 ABC、BCD、CDA、DAB，共 4 個。',
        '沒有其他方式可以圍出三角形，所以一共是 4 + 4 = 8 個三角形。',
      ],
      'zh-Hans' => [
        '两条对角线把正方形分成 4 个小三角形：ABO、BCO、CDO、DAO。',
        '每相邻的两个小三角形合起来，又会变成一个比较大的三角形。',
        '这样的大三角形有 ABC、BCD、CDA、DAB，共 4 个。',
        '没有其他方式可以围出三角形，所以一共是 4 + 4 = 8 个三角形。',
      ],
      'en' => [
        'The two diagonals cut the square into 4 small triangles: ABO, BCO, CDO and DAO.',
        'Any two neighbouring small triangles together form a larger triangle.',
        'These larger triangles are ABC, BCD, CDA and DAB, that is 4 of them.',
        'No other triangles can be formed, so there are 4 + 4 = 8 triangles in total.',
      ],
      'ja' => [
        '2 本の対角線は正方形を ABO、BCO、CDO、DAO の 4 つの小さい三角形に分けます。',
        'となり合う 2 つの小さい三角形を合わせると、もっと大きい三角形になります。',
        'その大きい三角形は ABC、BCD、CDA、DAB の 4 個です。',
        'これ以外に三角形はできないので、合計は 4 + 4 = 8 個です。',
      ],
    },
    value: '8', max_digits: 1,
    figure: geometry_scene(
      'bounds' => { 'minX' => -0.8, 'minY' => -0.8, 'maxX' => 4.8, 'maxY' => 4.8 },
      'points' => [shown('A', 0, 4, 'tl'), shown('B', 4, 4, 'tr'), shown('C', 4, 0, 'br'),
                   shown('D', 0, 0, 'bl'), shown('O', 2, 2, 't')],
      'segments' => [seg('A', 'B'), seg('B', 'C'), seg('C', 'D'), seg('D', 'A'),
                     seg('A', 'C'), seg('B', 'D')],
    ),
    source: rewritten_source('geometry-grade2-foundation',
      'Original composition in the Math Kangaroo grade 1-2 figure-counting style; unlike a one-dimensional segment count it requires seeing that pairs of small triangles merge into larger ones. Not a reproduction of any past paper.'),
  ),
  choice_q(
    topic: 'geometry', subtopic: 'rotation',
    prompt: {
      'zh-Hant' => '一張正方形卡片平放在桌上，四個角依順時針方向分別標著 A、B、C、D。小安把卡片在桌面上順時針轉 90 度，連續轉了三次。轉完以後，A 在左下角。轉之前 A 在哪一個角？',
      'zh-Hans' => '一张正方形卡片平放在桌上，四个角按顺时针方向分别标着 A、B、C、D。小安把卡片在桌面上顺时针转 90 度，连续转了三次。转完以后，A 在左下角。转之前 A 在哪一个角？',
      'en' => 'A square card lies flat on a table, its four corners labelled A, B, C, D in clockwise order. An turns the card 90 degrees clockwise on the table, three times in a row. After the turns, A is at the bottom-left corner. Which corner was A at before the turns?',
      'ja' => '正方形のカードが机の上に置かれ、4 つの角には時計回りに A、B、C、D と書かれています。アンさんはカードを机の上で時計回りに 90 度ずつ、続けて 3 回回しました。回し終えたあと、A は左下の角にあります。回す前、A はどの角にありましたか。',
    },
    answer: { 'zh-Hant' => '轉之前 A 在左上角。', 'zh-Hans' => '转之前 A 在左上角。',
              'en' => 'Before the turns A was at the top-left corner.', 'ja' => '回す前、A は左上の角にありました。' },
    steps: {
      'zh-Hant' => [
        '每轉一次 90 度，角的位置就依「左上 → 右上 → 右下 → 左下 → 左上」的順序前進一格。',
        '要找轉之前的位置，就把這個順序倒著走三格。',
        '從左下角倒著走一格是右下角，走兩格是右上角，走三格是左上角。',
        '所以轉之前 A 在左上角。',
      ],
      'zh-Hans' => [
        '每转一次 90 度，角的位置就按「左上 → 右上 → 右下 → 左下 → 左上」的顺序前进一格。',
        '要找转之前的位置，就把这个顺序倒着走三格。',
        '从左下角倒着走一格是右下角，走两格是右上角，走三格是左上角。',
        '所以转之前 A 在左上角。',
      ],
      'en' => [
        'Each 90 degree clockwise turn moves a corner one step along the cycle top-left → top-right → bottom-right → bottom-left → top-left.',
        'To find the position before the turns, walk three steps backwards along this cycle.',
        'One step back from the bottom-left is the bottom-right, two steps back is the top-right, and three steps back is the top-left.',
        'So A was at the top-left corner before the turns.',
      ],
      'ja' => [
        '90 度ずつ時計回りに回すたびに、角の位置は「左上 → 右上 → 右下 → 左下 → 左上」の順に 1 つ進みます。',
        '回す前の位置を求めるには、この順を逆に 3 つもどります。',
        '左下から 1 つもどると右下、2 つもどると右上、3 つもどると左上です。',
        'したがって回す前、A は左上の角にありました。',
      ],
    },
    options: {
      'A' => { 'zh-Hant' => '左上角', 'zh-Hans' => '左上角', 'en' => 'The top-left corner', 'ja' => '左上の角' },
      'B' => { 'zh-Hant' => '右上角', 'zh-Hans' => '右上角', 'en' => 'The top-right corner', 'ja' => '右上の角' },
      'C' => { 'zh-Hant' => '右下角', 'zh-Hans' => '右下角', 'en' => 'The bottom-right corner', 'ja' => '右下の角' },
      'D' => { 'zh-Hant' => '左下角', 'zh-Hans' => '左下角', 'en' => 'The bottom-left corner', 'ja' => '左下の角' },
    },
    correct: 'A',
    figure: figure_none,
    source: rewritten_source('geometry-grade2-foundation',
      'Original composition in the Math Kangaroo grade 1-2 rotation style; the solver must compose three quarter turns and then run the cycle backwards. No figure is attached because drawing the starting position would give the answer away. Not a reproduction of any past paper.'),
  ),
  integer_q(
    topic: 'geometry', subtopic: 'overlap_area',
    prompt: {
      'zh-Hant' => '兩張一樣大的正方形紙，每張邊長都是 4 公分。把它們部分疊在一起放在桌上，重疊的部分剛好是一個邊長 2 公分的正方形。這時兩張紙一共蓋住桌面多少平方公分？',
      'zh-Hans' => '两张一样大的正方形纸，每张边长都是 4 厘米。把它们部分叠在一起放在桌上，重叠的部分刚好是一个边长 2 厘米的正方形。这时两张纸一共盖住桌面多少平方厘米？',
      'en' => 'Two identical square sheets of paper each have sides of 4 cm. They are placed on a table so that they partly overlap, and the overlapping part is exactly a square with sides of 2 cm. How many square centimetres of the table do the two sheets cover altogether?',
      'ja' => '同じ大きさの正方形の紙が 2 枚あり、どちらも 1 辺 4 cm です。机の上で一部を重ねて置いたところ、重なった部分はちょうど 1 辺 2 cm の正方形になりました。このとき 2 枚の紙が机をおおっている面積は合わせて何平方センチメートルですか。',
    },
    answer: { 'zh-Hant' => '答案是 28 平方公分。', 'zh-Hans' => '答案是 28 平方厘米。',
              'en' => 'The answer is 28 square centimetres.', 'ja' => '答えは 28 平方センチメートルです。' },
    steps: {
      'zh-Hant' => [
        '每張正方形紙的面積是 4 × 4 = 16 平方公分，兩張加起來是 16 + 16 = 32 平方公分。',
        '但是重疊的部分被兩張紙各蓋了一次，在 32 裡面被算了兩次。',
        '重疊部分的面積是 2 × 2 = 4 平方公分，多算的就是這 4 平方公分。',
        '所以實際蓋住桌面的面積是 32 − 4 = 28 平方公分。',
      ],
      'zh-Hans' => [
        '每张正方形纸的面积是 4 × 4 = 16 平方厘米，两张加起来是 16 + 16 = 32 平方厘米。',
        '但是重叠的部分被两张纸各盖了一次，在 32 里面被算了两次。',
        '重叠部分的面积是 2 × 2 = 4 平方厘米，多算的就是这 4 平方厘米。',
        '所以实际盖住桌面的面积是 32 − 4 = 28 平方厘米。',
      ],
      'en' => [
        'Each sheet has area 4 × 4 = 16 square centimetres, so the two sheets together give 16 + 16 = 32.',
        'But the overlapping part is covered by both sheets, so it has been counted twice inside that 32.',
        'The overlap has area 2 × 2 = 4 square centimetres, and that is exactly the amount counted twice.',
        'So the table area actually covered is 32 − 4 = 28 square centimetres.',
      ],
      'ja' => [
        '正方形の紙 1 枚の面積は 4 × 4 = 16 平方センチメートルで、2 枚では 16 + 16 = 32 平方センチメートルです。',
        'しかし重なった部分は 2 枚とも重ねておおっているので、32 の中で 2 回数えられています。',
        '重なった部分の面積は 2 × 2 = 4 平方センチメートルで、これが余分に数えた分です。',
        'したがって実際におおっている面積は 32 − 4 = 28 平方センチメートルです。',
      ],
    },
    value: '28', max_digits: 2,
    figure: geometry_scene(
      'bounds' => { 'minX' => -0.5, 'minY' => -0.5, 'maxX' => 6.5, 'maxY' => 6.5 },
      'points' => [hidden('P1', 0, 0), hidden('P2', 4, 0), hidden('P3', 4, 4), hidden('P4', 0, 4),
                   hidden('Q1', 2, 2), hidden('Q2', 6, 2), hidden('Q3', 6, 6), hidden('Q4', 2, 6),
                   hidden('R2', 4, 2), hidden('R4', 2, 4)],
      'segments' => [seg('P1', 'P2'), seg('P2', 'P3'), seg('P3', 'P4'), seg('P4', 'P1'),
                     seg('Q1', 'Q2'), seg('Q2', 'Q3'), seg('Q3', 'Q4'), seg('Q4', 'Q1')],
      'polygons' => [{ 'vertices' => %w[Q1 R2 P3 R4], 'fill' => 'shaded' }],
    ),
    source: rewritten_source('geometry-grade2-foundation',
      'Original composition in the Math Kangaroo grade 1-2 overlapping-figures style; the solver must subtract the doubly counted overlap rather than add two areas. Not a reproduction of any past paper.'),
  ),
  integer_q(
    topic: 'geometry', subtopic: 'grid_path',
    prompt: {
      'zh-Hant' => '在方格紙上，小兔要從 A 點沿著格線走到 B 點。從 A 到 B 必須向右走 2 格、向上走 2 格，而且每一步只能向右或向上，不能向左也不能向下。這樣的最短路線一共有幾條？',
      'zh-Hans' => '在方格纸上，小兔要从 A 点沿着格线走到 B 点。从 A 到 B 必须向右走 2 格、向上走 2 格，而且每一步只能向右或向上，不能向左也不能向下。这样的最短路线一共有几条？',
      'en' => 'On grid paper a rabbit walks along the grid lines from the point A to the point B. Getting from A to B needs 2 steps to the right and 2 steps up, and every step must be either to the right or upwards, never left and never down. How many shortest routes are there altogether?',
      'ja' => '方眼紙の上で、うさぎが点 A から格子の線にそって点 B まで進みます。A から B までは右に 2 マス、上に 2 マス進む必要があり、1 歩ごとに右か上にしか進めません（左や下には進めません）。このような最短の道すじは全部で何通りありますか。',
    },
    answer: { 'zh-Hant' => '答案是 6。', 'zh-Hans' => '答案是 6。', 'en' => 'The answer is 6.', 'ja' => '答えは 6 です。' },
    steps: {
      'zh-Hant' => [
        '每一條最短路線都剛好走 4 步：2 步向右、2 步向上。',
        '所以一條路線就是決定「這 4 步之中，哪 2 步是向右」。',
        '把向右記成右、向上記成上，可以排出：右右上上、右上右上、右上上右、上右右上、上右上右、上上右右。',
        '一共列出 6 種不重複的走法，所以最短路線有 6 條。',
      ],
      'zh-Hans' => [
        '每一条最短路线都刚好走 4 步：2 步向右、2 步向上。',
        '所以一条路线就是决定「这 4 步之中，哪 2 步是向右」。',
        '把向右记成右、向上记成上，可以排出：右右上上、右上右上、右上上右、上右右上、上右上右、上上右右。',
        '一共列出 6 种不重复的走法，所以最短路线有 6 条。',
      ],
      'en' => [
        'Every shortest route takes exactly 4 steps: 2 to the right and 2 upwards.',
        'So choosing a route means deciding which 2 of those 4 steps go to the right.',
        'Writing R for right and U for up, the possibilities are RRUU, RURU, RUUR, URRU, URUR and UURR.',
        'That is 6 different routes, so there are 6 shortest routes.',
      ],
      'ja' => [
        'どの最短の道すじもちょうど 4 歩で、右に 2 歩、上に 2 歩です。',
        'つまり道すじを決めることは、4 歩のうちどの 2 歩を右にするかを決めることです。',
        '右を「右」、上を「上」と書くと、右右上上、右上右上、右上上右、上右右上、上右上右、上上右右となります。',
        'ちがう道すじが 6 通り出てくるので、最短の道すじは 6 通りです。',
      ],
    },
    value: '6', max_digits: 1,
    figure: geometry_scene(
      'bounds' => { 'minX' => -0.5, 'minY' => -0.5, 'maxX' => 2.5, 'maxY' => 2.5 },
      'points' => [shown('A', 0, 0, 'bl'), shown('B', 2, 2, 'tr'),
                   hidden('H10', 1, 0), hidden('H20', 2, 0),
                   hidden('H01', 0, 1), hidden('H11', 1, 1), hidden('H21', 2, 1),
                   hidden('H02', 0, 2), hidden('H12', 1, 2)],
      'segments' => [seg('A', 'H20'), seg('H01', 'H21'), seg('H02', 'B'),
                     seg('A', 'H02'), seg('H10', 'H12'), seg('H20', 'B')],
    ),
    source: rewritten_source('geometry-grade2-foundation',
      'Original composition in the Math Kangaroo grade 1-2 lattice-path style; the question asks for the number of shortest routes, which needs systematic enumeration rather than measuring a distance. Not a reproduction of any past paper.'),
  ),
].freeze

LOGIC = [
  integer_q(
    topic: 'logic', subtopic: 'pairwise_sums',
    prompt: {
      'zh-Hant' => '有三個數，把它們兩兩相加（每兩個數加一次，一共加三次），得到的三個和分別是 7、9、10。這三個數之中最大的是多少？',
      'zh-Hans' => '有三个数，把它们两两相加（每两个数加一次，一共加三次），得到的三个和分别是 7、9、10。这三个数之中最大的是多少？',
      'en' => 'Three numbers are added in pairs, each pair once, giving three sums altogether: 7, 9 and 10. What is the largest of the three numbers?',
      'ja' => '3 つの数があります。2 つずつの組をそれぞれ 1 回ずつたすと、和は 7、9、10 の 3 つになりました。この 3 つの数のうち、いちばん大きい数はいくつですか。',
    },
    answer: { 'zh-Hant' => '答案是 6。', 'zh-Hans' => '答案是 6。', 'en' => 'The answer is 6.', 'ja' => '答えは 6 です。' },
    steps: {
      'zh-Hant' => [
        '把三個和全部加起來是 7 + 9 + 10 = 26。',
        '在這個總和裡，每一個數都剛好被加了兩次，所以三個數的和是 26 ÷ 2 = 13。',
        '最大的數不在最小的那個和裡面，所以用 13 減掉最小的和 7，得到 13 − 7 = 6。',
        '所以三個數之中最大的是 6。',
      ],
      'zh-Hans' => [
        '把三个和全部加起来是 7 + 9 + 10 = 26。',
        '在这个总和里，每一个数都刚好被加了两次，所以三个数的和是 26 ÷ 2 = 13。',
        '最大的数不在最小的那个和里面，所以用 13 减掉最小的和 7，得到 13 − 7 = 6。',
        '所以三个数之中最大的是 6。',
      ],
      'en' => [
        'Adding the three sums gives 7 + 9 + 10 = 26.',
        'In that total every one of the numbers has been added exactly twice, so the three numbers add up to 26 ÷ 2 = 13.',
        'The largest number is the one missing from the smallest sum, so subtract that sum: 13 − 7 = 6.',
        'Therefore the largest of the three numbers is 6.',
      ],
      'ja' => [
        '3 つの和をすべてたすと 7 + 9 + 10 = 26 です。',
        'この合計では、どの数もちょうど 2 回ずつたされているので、3 つの数の和は 26 ÷ 2 = 13 です。',
        'いちばん大きい数は、いちばん小さい和に入っていない数なので、13 − 7 = 6 となります。',
        'したがって 3 つの数のうちいちばん大きいのは 6 です。',
      ],
    },
    value: '6', max_digits: 1, figure: figure_none,
    source: rewritten_source('logic-grade2-foundation',
      'Original composition in the Math Kangaroo grade 1-2 pairwise-sum style; the key move is noticing that summing all pair sums counts every number twice. Not a reproduction of any past paper.'),
  ),
  integer_q(
    topic: 'logic', subtopic: 'minimal_case',
    prompt: {
      'zh-Hant' => '有 10 張卡片，上面分別寫著 1 到 10。小安閉著眼睛從中拿卡片。他最少要拿幾張，才能保證拿到的卡片裡一定有兩張的數字和是 11？',
      'zh-Hans' => '有 10 张卡片，上面分别写着 1 到 10。小安闭着眼睛从中拿卡片。他最少要拿几张，才能保证拿到的卡片里一定有两张的数字和是 11？',
      'en' => 'There are 10 cards showing the numbers 1 to 10. An picks cards with his eyes closed. At least how many cards must he pick to be sure that among the cards picked there are two whose numbers add up to 11?',
      'ja' => '1 から 10 までの数が書かれたカードが 10 枚あります。アンさんは目をつぶってカードを取ります。取ったカードの中に、数の和が 11 になる 2 枚が必ずふくまれるようにするには、少なくとも何枚取ればよいですか。',
    },
    answer: { 'zh-Hant' => '答案是 6。', 'zh-Hans' => '答案是 6。', 'en' => 'The answer is 6.', 'ja' => '答えは 6 です。' },
    steps: {
      'zh-Hant' => [
        '先把和是 11 的兩個數配成一組：1 和 10、2 和 9、3 和 8、4 和 7、5 和 6，剛好 5 組。',
        '每一組裡只要拿到兩張，就會出現和是 11 的一對。',
        '如果每一組都只拿 1 張，最多可以拿 5 張而還沒有出現和是 11 的一對。',
        '再多拿 1 張時，這張一定會和某一組裡已經拿到的那張配成一對。',
        '所以最少要拿 5 + 1 = 6 張。',
      ],
      'zh-Hans' => [
        '先把和是 11 的两个数配成一组：1 和 10、2 和 9、3 和 8、4 和 7、5 和 6，刚好 5 组。',
        '每一组里只要拿到两张，就会出现和是 11 的一对。',
        '如果每一组都只拿 1 张，最多可以拿 5 张而还没有出现和是 11 的一对。',
        '再多拿 1 张时，这张一定会和某一组里已经拿到的那张配成一对。',
        '所以最少要拿 5 + 1 = 6 张。',
      ],
      'en' => [
        'First pair up the numbers that add to 11: 1 with 10, 2 with 9, 3 with 8, 4 with 7 and 5 with 6, giving exactly 5 pairs.',
        'Taking both cards of any one pair produces two numbers adding to 11.',
        'Picking just one card from each pair gives at most 5 cards with no such pair yet.',
        'Picking one more card forces it to match a card already taken from one of the pairs.',
        'So at least 5 + 1 = 6 cards must be picked.',
      ],
      'ja' => [
        'まず和が 11 になる 2 数を組にします。1 と 10、2 と 9、3 と 8、4 と 7、5 と 6 で、ちょうど 5 組です。',
        'どれか 1 組から 2 枚とれば、和が 11 になる 2 枚がそろいます。',
        '各組から 1 枚ずつしか取らなければ、5 枚まではまだ和が 11 の組ができません。',
        'もう 1 枚取ると、その 1 枚は必ずどれかの組ですでに取った 1 枚と対になります。',
        'したがって少なくとも 5 + 1 = 6 枚取る必要があります。',
      ],
    },
    value: '6', max_digits: 1, figure: figure_none,
    source: rewritten_source('logic-grade2-foundation',
      'Original composition in the Math Kangaroo grade 1-2 worst-case style; the pigeonholes here are complementary pairs rather than colours, so the solver must build the pairing first. Not a reproduction of any past paper.'),
  ),
  integer_q(
    topic: 'logic', subtopic: 'partial_order',
    prompt: {
      'zh-Hant' => '小安、小美、小華、小明四個人賽跑，成績沒有並列。已知小安比小美快，小華比小明快，小明也比小美快。小美是第幾名？',
      'zh-Hans' => '小安、小美、小华、小明四个人赛跑，成绩没有并列。已知小安比小美快，小华比小明快，小明也比小美快。小美是第几名？',
      'en' => 'An, Mei, Hua and Ming run a race and no two of them finish together. An is faster than Mei, Hua is faster than Ming, and Ming is also faster than Mei. In which place does Mei finish?',
      'ja' => 'アン、ミイ、ホア、ミンの 4 人がかけっこをし、同じ順位の人はいません。アンはミイより速く、ホアはミンより速く、ミンもミイより速いことがわかっています。ミイは何位ですか。',
    },
    answer: { 'zh-Hant' => '答案是 4。', 'zh-Hans' => '答案是 4。', 'en' => 'The answer is 4.', 'ja' => '答えは 4 です。' },
    steps: {
      'zh-Hant' => [
        '由「小安比小美快」和「小明比小美快」，可以知道小安、小明都排在小美前面。',
        '再由「小華比小明快」，而小明又比小美快，所以小華也排在小美前面。',
        '這樣一來，小安、小華、小明三個人都比小美快。',
        '四個人裡有三個人比小美快，所以小美是第 4 名。',
      ],
      'zh-Hans' => [
        '由「小安比小美快」和「小明比小美快」，可以知道小安、小明都排在小美前面。',
        '再由「小华比小明快」，而小明又比小美快，所以小华也排在小美前面。',
        '这样一来，小安、小华、小明三个人都比小美快。',
        '四个人里有三个人比小美快，所以小美是第 4 名。',
      ],
      'en' => [
        'From "An is faster than Mei" and "Ming is faster than Mei", both An and Ming finish ahead of Mei.',
        'From "Hua is faster than Ming", and Ming is already ahead of Mei, so Hua finishes ahead of Mei as well.',
        'That means all three of An, Hua and Ming are faster than Mei.',
        'Three of the four runners finish ahead of Mei, so Mei finishes in place 4.',
      ],
      'ja' => [
        '「アンはミイより速い」「ミンはミイより速い」から、アンとミンはミイより前です。',
        '「ホアはミンより速い」で、ミンはミイより前なので、ホアもミイより前になります。',
        'つまりアン、ホア、ミンの 3 人ともミイより速いことになります。',
        '4 人のうち 3 人がミイより前なので、ミイは 4 位です。',
      ],
    },
    value: '4', max_digits: 1, figure: figure_none,
    source: rewritten_source('logic-grade2-foundation',
      'Original composition in the Math Kangaroo grade 1-2 ordering style; the three given comparisons form two chains that must be merged, and only one runner position is actually determined. Not a reproduction of any past paper.'),
  ),
].freeze

ARITHMETIC = [
  integer_q(
    topic: 'arithmetic', subtopic: 'handshake_counting',
    prompt: {
      'zh-Hant' => '有 5 個小朋友參加聚會，每兩個人都互相握手一次，而且同樣的兩個人不會握第二次。他們一共握了幾次手？',
      'zh-Hans' => '有 5 个小朋友参加聚会，每两个人都互相握手一次，而且同样的两个人不会握第二次。他们一共握了几次手？',
      'en' => 'Five children come to a party and every two of them shake hands exactly once, with no pair shaking hands a second time. How many handshakes are there altogether?',
      'ja' => '5 人の子どもがパーティーに集まり、どの 2 人もちょうど 1 回ずつ握手をします。同じ 2 人が 2 回握手することはありません。握手は全部で何回ありますか。',
    },
    answer: { 'zh-Hant' => '答案是 10。', 'zh-Hans' => '答案是 10。', 'en' => 'The answer is 10.', 'ja' => '答えは 10 です。' },
    steps: {
      'zh-Hant' => [
        '每個小朋友都要和另外 4 個人握手，所以每人握 4 次。',
        '5 個人各握 4 次，合起來是 5 × 4 = 20 次。',
        '但是一次握手是兩個人一起完成的，在 20 次裡每一次都被兩個人各算了一次。',
        '所以實際握手次數是 20 ÷ 2 = 10 次。',
      ],
      'zh-Hans' => [
        '每个小朋友都要和另外 4 个人握手，所以每人握 4 次。',
        '5 个人各握 4 次，合起来是 5 × 4 = 20 次。',
        '但是一次握手是两个人一起完成的，在 20 次里每一次都被两个人各算了一次。',
        '所以实际握手次数是 20 ÷ 2 = 10 次。',
      ],
      'en' => [
        'Each child shakes hands with the other 4 children, so each child takes part in 4 handshakes.',
        'For 5 children that gives 5 × 4 = 20 counts.',
        'But a handshake involves two children, so each handshake was counted once by each of them inside that 20.',
        'So the actual number of handshakes is 20 ÷ 2 = 10.',
      ],
      'ja' => [
        'どの子もほかの 4 人と握手するので、1 人あたり 4 回です。',
        '5 人がそれぞれ 4 回なので、合わせると 5 × 4 = 20 回分になります。',
        'しかし握手は 2 人でするものなので、20 回分では 1 回の握手が 2 人によって 2 回数えられています。',
        'したがって実際の握手の回数は 20 ÷ 2 = 10 回です。',
      ],
    },
    value: '10', max_digits: 2, figure: figure_none,
    source: rewritten_source('arithmetic-grade2-foundation',
      'Original composition in the Math Kangaroo grade 1-2 handshake style; the trap is stopping at 5 × 4 without halving for double counting. Not a reproduction of any past paper.'),
  ),
  integer_q(
    topic: 'arithmetic', subtopic: 'minimization',
    prompt: {
      'zh-Hant' => '有 1、2、3、4 四張數字卡，每張都要用到，而且每張只能用一次。把它們排成兩個兩位數，再把這兩個兩位數相加。這個和最小可以是多少？',
      'zh-Hans' => '有 1、2、3、4 四张数字卡，每张都要用到，而且每张只能用一次。把它们排成两个两位数，再把这两个两位数相加。这个和最小可以是多少？',
      'en' => 'Four number cards show 1, 2, 3 and 4. Every card must be used, and each card exactly once. The cards are arranged to form two two-digit numbers, which are then added. What is the smallest possible sum?',
      'ja' => '1、2、3、4 と書かれた 4 枚の数字カードがあります。すべてのカードを 1 回ずつ使って 2 けたの数を 2 つ作り、その 2 つをたします。この和は最も小さくていくつになりますか。',
    },
    answer: { 'zh-Hant' => '答案是 37。', 'zh-Hans' => '答案是 37。', 'en' => 'The answer is 37.', 'ja' => '答えは 37 です。' },
    steps: {
      'zh-Hant' => [
        '兩個兩位數相加時，放在十位的數字每個都要算 10 倍，放在個位的數字只算 1 倍。',
        '所以要讓和最小，就要把小的兩張 1 和 2 放在十位，大的兩張 3 和 4 放在個位。',
        '這時十位提供 (1 + 2) × 10 = 30，個位提供 3 + 4 = 7。',
        '不論 3 和 4 怎麼分配（13 + 24 或 14 + 23），和都是 30 + 7 = 37，所以最小的和是 37。',
      ],
      'zh-Hans' => [
        '两个两位数相加时，放在十位的数字每个都要算 10 倍，放在个位的数字只算 1 倍。',
        '所以要让和最小，就要把小的两张 1 和 2 放在十位，大的两张 3 和 4 放在个位。',
        '这时十位提供 (1 + 2) × 10 = 30，个位提供 3 + 4 = 7。',
        '不论 3 和 4 怎么分配（13 + 24 或 14 + 23），和都是 30 + 7 = 37，所以最小的和是 37。',
      ],
      'en' => [
        'When two two-digit numbers are added, a digit in the tens place counts ten times while a digit in the units place counts once.',
        'To make the sum as small as possible, the two smaller cards 1 and 2 should go in the tens places and the larger cards 3 and 4 in the units places.',
        'Then the tens places contribute (1 + 2) × 10 = 30 and the units places contribute 3 + 4 = 7.',
        'However 3 and 4 are shared out (13 + 24 or 14 + 23), the sum is 30 + 7 = 37, so the smallest sum is 37.',
      ],
      'ja' => [
        '2 けたの数を 2 つたすとき、十の位の数字は 10 倍、一の位の数字は 1 倍で効きます。',
        'そこで和を最も小さくするには、小さい 1 と 2 を十の位に、大きい 3 と 4 を一の位に置きます。',
        'このとき十の位からは (1 + 2) × 10 = 30、一の位からは 3 + 4 = 7 になります。',
        '3 と 4 の分け方（13 + 24 でも 14 + 23 でも）によらず和は 30 + 7 = 37 なので、最小の和は 37 です。',
      ],
    },
    value: '37', max_digits: 2, figure: figure_none,
    source: rewritten_source('arithmetic-grade2-foundation',
      'Original composition in the Math Kangaroo grade 1-2 digit-placement style; the solver must reason about place value weights instead of trying arrangements at random. Not a reproduction of any past paper.'),
  ),
  integer_q(
    topic: 'arithmetic', subtopic: 'division_remainder',
    prompt: {
      'zh-Hant' => '有一個數比 0 大、比 30 小。這個數除以 5 會餘 3，除以 3 會餘 1。符合條件的數之中，最小的是多少？',
      'zh-Hans' => '有一个数比 0 大、比 30 小。这个数除以 5 会余 3，除以 3 会余 1。符合条件的数之中，最小的是多少？',
      'en' => 'A number is greater than 0 and less than 30. When it is divided by 5 the remainder is 3, and when it is divided by 3 the remainder is 1. What is the smallest number that satisfies both conditions?',
      'ja' => '0 より大きく 30 より小さい数があります。この数を 5 でわると 3 あまり、3 でわると 1 あまります。条件に合う数のうち、いちばん小さいものはいくつですか。',
    },
    answer: { 'zh-Hant' => '答案是 13。', 'zh-Hans' => '答案是 13。', 'en' => 'The answer is 13.', 'ja' => '答えは 13 です。' },
    steps: {
      'zh-Hant' => [
        '除以 5 餘 3 的數，是在 5 的倍數上再加 3，所以由小到大是 3、8、13、18、23、28。',
        '接著在這些數裡面，找出除以 3 會餘 1 的數。',
        '3 除以 3 餘 0，8 除以 3 餘 2，都不符合；13 除以 3 得 4 餘 1，符合條件。',
        '13 是這串數中第一個符合的，所以最小的數是 13。',
      ],
      'zh-Hans' => [
        '除以 5 余 3 的数，是在 5 的倍数上再加 3，所以由小到大是 3、8、13、18、23、28。',
        '接着在这些数里面，找出除以 3 会余 1 的数。',
        '3 除以 3 余 0，8 除以 3 余 2，都不符合；13 除以 3 得 4 余 1，符合条件。',
        '13 是这串数中第一个符合的，所以最小的数是 13。',
      ],
      'en' => [
        'Numbers leaving remainder 3 when divided by 5 are multiples of 5 plus 3, so in order they are 3, 8, 13, 18, 23 and 28.',
        'Among these, look for the ones that leave remainder 1 when divided by 3.',
        '3 leaves remainder 0 and 8 leaves remainder 2, so neither works; 13 gives 4 remainder 1, which does work.',
        '13 is the first number in the list that works, so the smallest such number is 13.',
      ],
      'ja' => [
        '5 でわると 3 あまる数は、5 の倍数に 3 をたした数なので、小さい順に 3、8、13、18、23、28 です。',
        'この中から、3 でわると 1 あまる数をさがします。',
        '3 は 3 でわると 0 あまり、8 は 2 あまるので合いません。13 は 3 でわると 4 で 1 あまり、条件に合います。',
        '13 がこの並びで最初に条件に合う数なので、いちばん小さい数は 13 です。',
      ],
    },
    value: '13', max_digits: 2, figure: figure_none,
    source: rewritten_source('arithmetic-grade2-foundation',
      'Original composition in the Math Kangaroo grade 1-2 remainder style; two remainder conditions must be intersected by listing one family and filtering it. Not a reproduction of any past paper.'),
  ),
].freeze

BATCH = { geometry: GEOMETRY, logic: LOGIC, arithmetic: ARITHMETIC }.freeze

counts = {}
BATCH.each do |topic, questions|
  path = PATHS[topic]
  pack = load_json(path)
  serial = next_serial(pack)
  questions.each_with_index do |q, i|
    q['id'] = format('%s_grade2_foundation_%03d', topic, serial + i)
  end
  ids = pack['questions'].map { |q| q['id'] }.to_set
  questions.each { |q| raise "duplicate id #{q['id']}" if ids.include?(q['id']) }
  pack['questions'].concat(questions)
  save_json(path, pack)
  counts[path] = pack['questions'].length
  puts "#{File.basename(path)} -> #{pack['questions'].length}  (#{questions.map { |q| q['id'] }.join(', ')})"
end

manifest = load_json(MANIFEST_PATH)
manifest['packs'].each do |pack|
  full = File.join(ROOT, pack['path'])
  pack['questionCount'] = counts[full] if counts.key?(full)
end
save_json(MANIFEST_PATH, manifest)
