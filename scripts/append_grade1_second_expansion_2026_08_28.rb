#!/usr/bin/env ruby
# frozen_string_literal: true

# grade1 第二輪擴充（2026-08-28）：每年級再補 20 題中的 grade1 部分
#   geometry  : area_counting / reflection / translation / overlap_area
#               angles / lines_angles / perimeter_change / shape_composition
#   logic     : calendar_reasoning / column_row / minimal_case
#               balance_reasoning / set_filtering / two_step_elimination
#   arithmetic: piece_value / ceiling_division / symbol_equation
#               custom_operator / consecutive_numbers / elapsed_time

require 'json'
require 'set'

ROOT = File.expand_path('..', __dir__)
GRADE = 'grade1'
PATHS = {
  'geometry' => File.join(ROOT, "assets/questions/geometry/#{GRADE}_foundation.geometry.v1.json"),
  'logic' => File.join(ROOT, "assets/questions/logic/#{GRADE}_foundation.logic.v1.json"),
  'arithmetic' => File.join(ROOT, "assets/questions/arithmetic/#{GRADE}_foundation.arithmetic.v1.json"),
}.freeze
MANIFEST_PATH = File.join(ROOT, 'assets/questions/manifest.json')

def load_json(path) = JSON.parse(File.read(path))
def save_json(path, data) = File.write(path, JSON.pretty_generate(data) + "\n")
def figure_none = { 'type' => 'custom', 'kind' => 'none', 'params' => {} }

def base(topic:, subtopic:, prompt:, answer:, steps:, source:, figure: nil)
  { 'reviewStatus' => 'ok', 'topic' => topic, 'subtopic' => subtopic,
    'difficulty' => 'foundation', 'levelStage' => GRADE, 'challengeTier' => 'foundation',
    'prompt' => prompt, 'answer' => answer, 'solutionSteps' => steps,
    'figure' => figure || figure_none, 'source' => source }
end

def src(reference, notes)
  { 'type' => 'rewritten_olympiad_style', 'name' => 'MathSpring Editorial',
    'reference' => reference, 'notes' => notes }
end

def int_q(value:, max_digits:, **rest)
  base(**rest).merge('answerMode' => 'integer_input',
                     'correctAnswer' => { 'type' => 'integer', 'value' => value },
                     'inputConstraints' => { 'allowNegative' => false, 'maxDigits' => max_digits })
end

def mc_q(options:, correct:, **rest)
  base(**rest).merge('answerMode' => 'multiple_choice', 'options' => options,
                     'correctAnswer' => { 'type' => 'choice', 'value' => correct })
end

L_SHAPE_FIGURE = {
  'type' => 'custom', 'kind' => 'geometry_scene',
  'params' => {
    'kind' => 'geometry_scene',
    'bounds' => { 'minX' => -0.5, 'minY' => -0.5, 'maxX' => 2.5, 'maxY' => 2.5 },
    'points' => [
      { 'name' => 'p1', 'x' => 0, 'y' => 0, 'visible' => false },
      { 'name' => 'p2', 'x' => 2, 'y' => 0, 'visible' => false },
      { 'name' => 'p3', 'x' => 2, 'y' => 1, 'visible' => false },
      { 'name' => 'p4', 'x' => 1, 'y' => 1, 'visible' => false },
      { 'name' => 'p5', 'x' => 1, 'y' => 2, 'visible' => false },
      { 'name' => 'p6', 'x' => 0, 'y' => 2, 'visible' => false },
      { 'name' => 'm1', 'x' => 1, 'y' => 0, 'visible' => false },
      { 'name' => 'm2', 'x' => 0, 'y' => 1, 'visible' => false },
    ],
    'segments' => [
      { 'from' => 'p1', 'to' => 'p2', 'style' => 'solid' },
      { 'from' => 'p2', 'to' => 'p3', 'style' => 'solid' },
      { 'from' => 'p3', 'to' => 'p4', 'style' => 'solid' },
      { 'from' => 'p4', 'to' => 'p5', 'style' => 'solid' },
      { 'from' => 'p5', 'to' => 'p6', 'style' => 'solid' },
      { 'from' => 'p6', 'to' => 'p1', 'style' => 'solid' },
      { 'from' => 'm1', 'to' => 'p4', 'style' => 'construction' },
      { 'from' => 'm2', 'to' => 'p4', 'style' => 'construction' },
    ],
  },
}.freeze

QUESTIONS = {
  'geometry' => [
    int_q(
      topic: 'geometry', subtopic: 'area_counting',
      prompt: {
        'zh-Hant' => '在方格紙上畫了甲、乙兩個圖形。甲蓋住 6 個完整的小方格，另外還蓋住 6 個小方格的一半；乙剛好蓋住 12 個完整的小方格。乙比甲多蓋住幾個小方格？',
        'zh-Hans' => '在方格纸上画了甲、乙两个图形。甲盖住 6 个完整的小方格，另外还盖住 6 个小方格的一半；乙刚好盖住 12 个完整的小方格。乙比甲多盖住几个小方格？',
        'en' => 'Two shapes A and B are drawn on grid paper. Shape A covers 6 whole small squares and also covers half of each of 6 further small squares; shape B covers exactly 12 whole small squares. How many more small squares does B cover than A?',
        'ja' => '方眼紙に図形アと図形イがかかれています。アは小さい正方形 6 個をまるごとおおい、さらに別の 6 個をそれぞれ半分ずつおおっています。イはちょうど 12 個をまるごとおおっています。イはアより小さい正方形いくつ分多くおおっていますか。',
      },
      answer: { 'zh-Hant' => '答案是 3 個。', 'zh-Hans' => '答案是 3 个。',
                'en' => 'The answer is 3 squares.', 'ja' => '答えは 3 個分です。' },
      steps: {
        'zh-Hant' => [
          '先算甲蓋住多少。完整的小方格有 6 個。',
          '另外 6 個小方格每個只蓋住一半，兩個半格合起來才等於 1 個完整的小方格。',
          '所以這 6 個半格等於 6 ÷ 2 = 3 個完整小方格，甲一共蓋住 6 + 3 = 9 個。',
          '乙蓋住 12 個，所以乙比甲多蓋住 12 − 9 = 3 個小方格。',
        ],
        'zh-Hans' => [
          '先算甲盖住多少。完整的小方格有 6 个。',
          '另外 6 个小方格每个只盖住一半，两个半格合起来才等于 1 个完整的小方格。',
          '所以这 6 个半格等于 6 ÷ 2 = 3 个完整小方格，甲一共盖住 6 + 3 = 9 个。',
          '乙盖住 12 个，所以乙比甲多盖住 12 − 9 = 3 个小方格。',
        ],
        'en' => [
          'First work out how much A covers. It covers 6 whole small squares.',
          'Each of the other 6 small squares is only half covered, and two halves together make one whole small square.',
          'So those 6 halves are worth 6 ÷ 2 = 3 whole small squares, and A covers 6 + 3 = 9 in all.',
          'B covers 12, so B covers 12 − 9 = 3 more small squares than A.',
        ],
        'ja' => [
          'まずアがどれだけおおっているかを求めます。まるごとおおっているのは 6 個です。',
          'ほかの 6 個は半分ずつなので、半分 2 つで小さい正方形 1 個分になります。',
          'よってその 6 個の半分は 6 ÷ 2 = 3 個分にあたり、アは合わせて 6 + 3 = 9 個分をおおっています。',
          'イは 12 個分なので、イはアより 12 − 9 = 3 個分多くおおっています。',
        ],
      },
      value: '3', max_digits: 1,
      source: src('geometry-grade1-foundation',
        'Original composition in the Math Kangaroo grade 1-2 grid-area style; half squares must be paired up before the two shapes can be compared. Not a reproduction of any past paper.'),
    ),
    int_q(
      topic: 'geometry', subtopic: 'reflection',
      prompt: {
        'zh-Hant' => '一面直立的鏡子放在方格紙上，鏡面剛好沿著一條格線。有一個小圖形放在鏡子左邊，距離鏡面 2 格。鏡子裡會出現這個圖形的像，像和鏡面的距離也是 2 格。這個圖形和它在鏡子裡的像，相距幾格？',
        'zh-Hans' => '一面直立的镜子放在方格纸上，镜面刚好沿着一条格线。有一个小图形放在镜子左边，距离镜面 2 格。镜子里会出现这个图形的像，像和镜面的距离也是 2 格。这个图形和它在镜子里的像，相距几格？',
        'en' => 'An upright mirror stands on grid paper with its surface exactly along a grid line. A small shape is placed 2 squares to the left of the mirror. Its image appears in the mirror, also 2 squares from the mirror surface. How many squares apart are the shape and its image?',
        'ja' => '方眼紙の上に鏡を立て、鏡の面はちょうど 1 本の格子線にそっています。鏡の左側、鏡から 2 マスのところに小さな図形を置きます。鏡の中にはその像が映り、像も鏡の面から 2 マスのところにあります。図形とその像は何マスはなれていますか。',
      },
      answer: { 'zh-Hant' => '答案是 4 格。', 'zh-Hans' => '答案是 4 格。',
                'en' => 'The answer is 4 squares.', 'ja' => '答えは 4 マスです。' },
      steps: {
        'zh-Hant' => [
          '鏡子裡的像和真正的圖形，分別在鏡面的兩側。',
          '圖形在鏡面左邊 2 格，像在鏡面右邊 2 格。',
          '要算兩者的距離，就是從圖形先走到鏡面，再從鏡面走到像。',
          '所以距離是 2 + 2 = 4 格。',
        ],
        'zh-Hans' => [
          '镜子里的像和真正的图形，分别在镜面的两侧。',
          '图形在镜面左边 2 格，像在镜面右边 2 格。',
          '要算两者的距离，就是从图形先走到镜面，再从镜面走到像。',
          '所以距离是 2 + 2 = 4 格。',
        ],
        'en' => [
          'The image in the mirror and the real shape lie on opposite sides of the mirror surface.',
          'The shape is 2 squares to the left of the surface and the image is 2 squares to the right of it.',
          'To find the distance between them, go from the shape to the surface and then from the surface to the image.',
          'So the distance is 2 + 2 = 4 squares.',
        ],
        'ja' => [
          '鏡に映る像と実際の図形は、鏡の面をはさんで反対側にあります。',
          '図形は鏡の面の左 2 マス、像は鏡の面の右 2 マスにあります。',
          '2 つの距離は、図形から鏡の面まで進み、さらに鏡の面から像まで進いた長さです。',
          'したがって距離は 2 + 2 = 4 マスです。',
        ],
      },
      value: '4', max_digits: 1,
      source: src('geometry-grade1-foundation',
        'Original composition in the Math Kangaroo grade 1-2 mirror style; the solver must add the two equal distances across the mirror line rather than name the reflected image. Not a reproduction of any past paper.'),
    ),
    int_q(
      topic: 'geometry', subtopic: 'translation',
      prompt: {
        'zh-Hant' => '如圖，方格紙上有一個 L 形，它由 3 個小方格組成：下面一排 2 格，左邊那格的正上方再 1 格。把整個 L 形向右移動 1 格。移動前的 L 形和移動後的 L 形合起來，一共蓋住幾個不同的小方格？',
        'zh-Hans' => '如图，方格纸上有一个 L 形，它由 3 个小方格组成：下面一排 2 格，左边那格的正上方再 1 格。把整个 L 形向右移动 1 格。移动前的 L 形和移动后的 L 形合起来，一共盖住几个不同的小方格？',
        'en' => 'The figure shows an L-shape on grid paper made of 3 small squares: two in a bottom row and one directly above the left-hand one. The whole L-shape is moved 1 square to the right. Taking the L-shape before the move together with the L-shape after the move, how many different small squares are covered altogether?',
        'ja' => '図のように、方眼紙の上に小さい正方形 3 個でできた L 字形があります。下の段に 2 個、その左の 1 個の真上にもう 1 個です。この L 字形全体を右に 1 マス動かします。動かす前の L 字形と動かしたあとの L 字形を合わせると、ちがう小さい正方形を全部でいくつおおいますか。',
      },
      answer: { 'zh-Hant' => '答案是 5 個。', 'zh-Hans' => '答案是 5 个。',
                'en' => 'The answer is 5 squares.', 'ja' => '答えは 5 個です。' },
      steps: {
        'zh-Hant' => [
          '把下排左邊那格記成第 1 格、右邊那格記成第 2 格，左上那格記成第 3 格。',
          '向右移動 1 格後，原本第 1 格的位置變成第 2 格的位置，第 2 格移到它右邊的新位置，第 3 格移到它右邊的新位置。',
          '兩個 L 形有重疊：移動後蓋住原本第 2 格的位置，這一格被算了兩次。',
          '兩個 L 形各有 3 格，合起來是 3 + 3 = 6 格，但重疊的 1 格只能算一次。',
          '所以一共蓋住 6 − 1 = 5 個不同的小方格。',
        ],
        'zh-Hans' => [
          '把下排左边那格记成第 1 格、右边那格记成第 2 格，左上那格记成第 3 格。',
          '向右移动 1 格后，原本第 1 格的位置变成第 2 格的位置，第 2 格移到它右边的新位置，第 3 格移到它右边的新位置。',
          '两个 L 形有重叠：移动后盖住原本第 2 格的位置，这一格被算了两次。',
          '两个 L 形各有 3 格，合起来是 3 + 3 = 6 格，但重叠的 1 格只能算一次。',
          '所以一共盖住 6 − 1 = 5 个不同的小方格。',
        ],
        'en' => [
          'Call the bottom-left square 1, the bottom-right square 2, and the square above square 1 square 3.',
          'After moving 1 square to the right, the place of square 1 is taken by square 2, while squares 2 and 3 move to new places on their right.',
          'The two L-shapes overlap: after the move, the original position of square 2 is covered again, so that square is counted twice.',
          'Each L-shape has 3 squares, giving 3 + 3 = 6, but the one overlapping square may only be counted once.',
          'So altogether 6 − 1 = 5 different small squares are covered.',
        ],
        'ja' => [
          '下の段の左のマスを 1、右のマスを 2、1 の真上のマスを 3 とします。',
          '右に 1 マス動かすと、もとの 1 の位置には 2 が入り、2 と 3 はそれぞれ右どなりの新しい位置に移ります。',
          '2 つの L 字形は重なります。動かしたあとにもとの 2 の位置をふたたびおおうので、そのマスは 2 回数えられています。',
          'L 字形は 1 つ 3 マスなので合わせて 3 + 3 = 6 マスですが、重なった 1 マスは 1 回だけ数えます。',
          'したがっておおうのは 6 − 1 = 5 個の異なる小さい正方形です。',
        ],
      },
      value: '5', max_digits: 1,
      figure: L_SHAPE_FIGURE,
      source: src('geometry-grade1-foundation',
        'Original composition in the Math Kangaroo grade 1-2 translation style; the shift is small enough that the two copies overlap, so the count needs the overlap removed. The figure shows only the starting position, so the answer cannot be read off. Not a reproduction of any past paper.'),
    ),
    int_q(
      topic: 'geometry', subtopic: 'overlap_area',
      prompt: {
        'zh-Hant' => '兩張一樣大的正方形紙，每張都剛好蓋住方格紙上的 9 個小方格。把它們部分疊在一起放好之後，兩張紙一共蓋住 14 個小方格。重疊的部分蓋住幾個小方格？',
        'zh-Hans' => '两张一样大的正方形纸，每张都刚好盖住方格纸上的 9 个小方格。把它们部分叠在一起放好之后，两张纸一共盖住 14 个小方格。重叠的部分盖住几个小方格？',
        'en' => 'Two identical square sheets of paper each cover exactly 9 small squares of grid paper. After they are placed so that they partly overlap, the two sheets together cover 14 small squares. How many small squares does the overlap cover?',
        'ja' => '同じ大きさの正方形の紙が 2 枚あり、どちらも方眼紙のちょうど 9 マスをおおいます。一部を重ねて置いたところ、2 枚で合わせて 14 マスをおおいました。重なった部分は何マスをおおっていますか。',
      },
      answer: { 'zh-Hant' => '答案是 4 個。', 'zh-Hans' => '答案是 4 个。',
                'en' => 'The answer is 4 squares.', 'ja' => '答えは 4 マスです。' },
      steps: {
        'zh-Hant' => [
          '如果兩張紙完全沒有重疊，蓋住的格子會是 9 + 9 = 18 個。',
          '但實際只蓋住 14 個，比 18 少了 18 − 14 = 4 個。',
          '會變少，是因為重疊的部分被兩張紙各蓋了一次，在 18 裡面被算了兩次。',
          '多算的那一次剛好就是重疊的部分，所以重疊部分蓋住 4 個小方格。',
        ],
        'zh-Hans' => [
          '如果两张纸完全没有重叠，盖住的格子会是 9 + 9 = 18 个。',
          '但实际只盖住 14 个，比 18 少了 18 − 14 = 4 个。',
          '会变少，是因为重叠的部分被两张纸各盖了一次，在 18 里面被算了两次。',
          '多算的那一次刚好就是重叠的部分，所以重叠部分盖住 4 个小方格。',
        ],
        'en' => [
          'If the two sheets did not overlap at all, they would cover 9 + 9 = 18 squares.',
          'They actually cover only 14, which is 18 − 14 = 4 fewer than that.',
          'The shortfall arises because the overlapping part is covered by both sheets and so was counted twice inside the 18.',
          'That extra count is exactly the overlap, so the overlap covers 4 small squares.',
        ],
        'ja' => [
          '2 枚がまったく重ならなければ、おおうマスは 9 + 9 = 18 マスになります。',
          '実際は 14 マスなので、18 より 18 − 14 = 4 マス少なくなっています。',
          '少なくなるのは、重なった部分が 2 枚ともにおおわれていて、18 の中で 2 回数えられているからです。',
          '余分に数えた分がちょうど重なりなので、重なった部分は 4 マスをおおっています。',
        ],
      },
      value: '4', max_digits: 1,
      source: src('geometry-grade1-foundation',
        'Original composition in the Math Kangaroo grade 1-2 overlapping-figures style; unlike the grade2 item, which adds two areas and subtracts a stated overlap, here the total is given and the overlap must be recovered from the shortfall. Not a reproduction of any past paper.'),
    ),
    int_q(
      topic: 'geometry', subtopic: 'angles',
      prompt: {
        'zh-Hant' => '一張正方形的紙，四個角都是直角。沿著一條對角線把它剪成兩個三角形。這兩個三角形加起來，一共有幾個直角？',
        'zh-Hans' => '一张正方形的纸，四个角都是直角。沿着一条对角线把它剪成两个三角形。这两个三角形加起来，一共有几个直角？',
        'en' => 'A square sheet of paper has four right angles. It is cut along one diagonal into two triangles. How many right angles do the two triangles have altogether?',
        'ja' => '正方形の紙は 4 つの角がすべて直角です。1 本の対角線にそって切り、2 つの三角形に分けます。この 2 つの三角形を合わせると、直角はいくつありますか。',
      },
      answer: { 'zh-Hant' => '答案是 2 個。', 'zh-Hans' => '答案是 2 个。',
                'en' => 'The answer is 2 right angles.', 'ja' => '答えは 2 個です。' },
      steps: {
        'zh-Hant' => [
          '正方形原本有 4 個直角，分別在四個頂點上。',
          '對角線是從一個頂點連到對面的頂點，所以它會通過其中兩個頂點。',
          '被對角線通過的那兩個直角，各自被分成兩個較小的角，不再是直角。',
          '另外兩個頂點沒有被對角線碰到，它們的直角完整保留，兩個三角形各得一個。',
          '所以兩個三角形一共有 2 個直角。',
        ],
        'zh-Hans' => [
          '正方形原本有 4 个直角，分别在四个顶点上。',
          '对角线是从一个顶点连到对面的顶点，所以它会通过其中两个顶点。',
          '被对角线通过的那两个直角，各自被分成两个较小的角，不再是直角。',
          '另外两个顶点没有被对角线碰到，它们的直角完整保留，两个三角形各得一个。',
          '所以两个三角形一共有 2 个直角。',
        ],
        'en' => [
          'The square starts with 4 right angles, one at each vertex.',
          'A diagonal joins one vertex to the opposite vertex, so it passes through two of them.',
          'Each of those two right angles is split into two smaller angles and is no longer a right angle.',
          'The other two vertices are untouched by the diagonal, so their right angles survive whole, one going to each triangle.',
          'The two triangles therefore have 2 right angles altogether.',
        ],
        'ja' => [
          '正方形にはもともと 4 つの頂点に直角が 1 つずつあります。',
          '対角線は 1 つの頂点から向かい合う頂点へ引くので、そのうち 2 つの頂点を通ります。',
          '対角線が通る 2 つの直角は、それぞれ小さい 2 つの角に分けられ、もう直角ではありません。',
          '残る 2 つの頂点は対角線に触れないので直角がそのまま残り、2 つの三角形に 1 つずつ入ります。',
          'したがって 2 つの三角形には合わせて直角が 2 個あります。',
        ],
      },
      value: '2', max_digits: 1,
      source: src('geometry-grade1-foundation',
        'Original composition in the Math Kangaroo grade 1-2 angle style; the point is that a diagonal destroys two of the four right angles rather than preserving all of them. Not a reproduction of any past paper.'),
    ),
    int_q(
      topic: 'geometry', subtopic: 'lines_angles',
      prompt: {
        'zh-Hant' => '在一張很大的紙上畫 3 條直線。如果每兩條直線都相交，而且三條線不會全部交在同一個點上，那麼這 3 條直線一共可以交出幾個交點？',
        'zh-Hans' => '在一张很大的纸上画 3 条直线。如果每两条直线都相交，而且三条线不会全部交在同一个点上，那么这 3 条直线一共可以交出几个交点？',
        'en' => 'Three straight lines are drawn on a very large sheet of paper. If every two of them cross, and the three lines do not all pass through one single point, how many crossing points are there altogether?',
        'ja' => '大きな紙に直線を 3 本引きます。どの 2 本も交わり、しかも 3 本が同じ 1 点で交わることはないとき、交点は全部でいくつできますか。',
      },
      answer: { 'zh-Hant' => '答案是 3 個。', 'zh-Hans' => '答案是 3 个。',
                'en' => 'The answer is 3 crossing points.', 'ja' => '答えは 3 個です。' },
      steps: {
        'zh-Hant' => [
          '每一個交點都是由兩條直線相交產生的，所以只要數出有幾組「兩條直線」就好。',
          '把三條線叫做甲、乙、丙。兩兩配對的組合是甲乙、甲丙、乙丙，一共 3 組。',
          '題目說每兩條都相交，所以這 3 組各產生 1 個交點。',
          '題目又說三條線不會全部交在同一點，表示這 3 個交點不會重疊成一個。',
          '所以一共有 3 個交點。',
        ],
        'zh-Hans' => [
          '每一个交点都是由两条直线相交产生的，所以只要数出有几组「两条直线」就好。',
          '把三条线叫做甲、乙、丙。两两配对的组合是甲乙、甲丙、乙丙，一共 3 组。',
          '题目说每两条都相交，所以这 3 组各产生 1 个交点。',
          '题目又说三条线不会全部交在同一点，表示这 3 个交点不会重叠成一个。',
          '所以一共有 3 个交点。',
        ],
        'en' => [
          'Every crossing point comes from two lines meeting, so it is enough to count the pairs of lines.',
          'Call the lines A, B and C. The pairs are AB, AC and BC, which is 3 pairs.',
          'Since every two lines cross, each of those 3 pairs gives one crossing point.',
          'Since the three lines do not all pass through one point, those 3 crossing points do not collapse into one.',
          'So there are 3 crossing points altogether.',
        ],
        'ja' => [
          '交点はどれも 2 本の直線が交わってできるので、直線 2 本の組が何組あるかを数えれば十分です。',
          '3 本をア、イ、ウとすると、2 本の組はアイ、アウ、イウの 3 組です。',
          'どの 2 本も交わるので、この 3 組がそれぞれ交点を 1 つずつ作ります。',
          'また 3 本が同じ 1 点で交わらないので、この 3 つの交点が 1 つに重なることはありません。',
          'したがって交点は全部で 3 個です。',
        ],
      },
      value: '3', max_digits: 1,
      source: src('geometry-grade1-foundation',
        'Original composition in the Math Kangaroo grade 1-2 lines style; the count is organised by pairs of lines, and the no-common-point condition is what stops the points merging. Drawing the lines would let the answer be counted off the picture, so no figure is attached. Not a reproduction of any past paper.'),
    ),
    int_q(
      topic: 'geometry', subtopic: 'perimeter_change',
      prompt: {
        'zh-Hant' => '有兩個一樣大的正方形，每個正方形的邊長都是 1 單位。原本兩個正方形分開放著，後來把它們的一條邊完全貼在一起，拼成一個長方形。拼好後的長方形周長，比原來兩個正方形的周長加起來少了多少單位？',
        'zh-Hans' => '有两个一样大的正方形，每个正方形的边长都是 1 单位。原本两个正方形分开放着，后来把它们的一条边完全贴在一起，拼成一个长方形。拼好后的长方形周长，比原来两个正方形的周长加起来少了多少单位？',
        'en' => 'There are two identical squares, each with sides of 1 unit. At first they are apart; then one side of each is joined completely to the other, forming a rectangle. By how many units is the perimeter of the rectangle less than the two separate square perimeters added together?',
        'ja' => '1 辺 1 単位の同じ大きさの正方形が 2 つあります。はじめは別々に置かれていましたが、辺どうしをぴったり合わせて長方形にしました。できた長方形の周の長さは、もとの 2 つの正方形の周の長さの和よりどれだけ短いですか。',
      },
      answer: { 'zh-Hant' => '答案是 2 單位。', 'zh-Hans' => '答案是 2 单位。',
                'en' => 'The answer is 2 units.', 'ja' => '答えは 2 単位です。' },
      steps: {
        'zh-Hant' => [
          '一個邊長 1 的正方形，周長是 1 × 4 = 4 單位，兩個分開放時周長加起來是 4 + 4 = 8 單位。',
          '拼成的長方形長 2、寬 1，周長是 2 + 1 + 2 + 1 = 6 單位。',
          '所以少了 8 − 6 = 2 單位。',
          '會少 2 單位，是因為貼在一起的那條邊長 1，在兩個正方形上各有一條，拼起來後都藏到裡面不再是外框的一部分。',
        ],
        'zh-Hans' => [
          '一个边长 1 的正方形，周长是 1 × 4 = 4 单位，两个分开放时周长加起来是 4 + 4 = 8 单位。',
          '拼成的长方形长 2、宽 1，周长是 2 + 1 + 2 + 1 = 6 单位。',
          '所以少了 8 − 6 = 2 单位。',
          '会少 2 单位，是因为贴在一起的那条边长 1，在两个正方形上各有一条，拼起来后都藏到里面不再是外框的一部分。',
        ],
        'en' => [
          'A square of side 1 has perimeter 1 × 4 = 4 units, so two separate squares have perimeters totalling 4 + 4 = 8 units.',
          'The rectangle formed is 2 long and 1 wide, so its perimeter is 2 + 1 + 2 + 1 = 6 units.',
          'The difference is therefore 8 − 6 = 2 units.',
          'The loss of 2 units happens because the joined side has length 1 and there is one such side on each square; after joining, both are hidden inside and no longer part of the outline.',
        ],
        'ja' => [
          '1 辺 1 の正方形の周の長さは 1 × 4 = 4 単位なので、別々に置いた 2 つでは 4 + 4 = 8 単位です。',
          'できた長方形は縦 1、横 2 なので、周の長さは 2 + 1 + 2 + 1 = 6 単位です。',
          'したがって 8 − 6 = 2 単位短くなります。',
          '2 単位減るのは、貼り合わせた長さ 1 の辺が両方の正方形に 1 本ずつあり、合わせたあとは内側にかくれて外周ではなくなるからです。',
        ],
      },
      value: '2', max_digits: 1,
      source: src('geometry-grade1-foundation',
        'Original composition in the Math Kangaroo grade 1-2 perimeter style; the loss equals twice the joined edge, which is the structural point rather than the two perimeters themselves. Not a reproduction of any past paper.'),
    ),
    int_q(
      topic: 'geometry', subtopic: 'shape_composition',
      prompt: {
        'zh-Hant' => '用一樣長的小棒排出正三角形。每邊排 2 根小棒的正三角形，一共要用 6 根小棒。如果要排出每邊 3 根小棒的正三角形，一共要用幾根小棒？',
        'zh-Hans' => '用一样长的小棒排出正三角形。每边排 2 根小棒的正三角形，一共要用 6 根小棒。如果要排出每边 3 根小棒的正三角形，一共要用几根小棒？',
        'en' => 'Equal-length sticks are laid out to form an equilateral triangle. A triangle with 2 sticks along each side uses 6 sticks in total. How many sticks are needed for a triangle with 3 sticks along each side?',
        'ja' => '同じ長さの棒を並べて正三角形を作ります。1 辺に棒を 2 本並べる正三角形には、全部で 6 本使います。1 辺に棒を 3 本並べる正三角形を作るには、全部で何本の棒が必要ですか。',
      },
      answer: { 'zh-Hant' => '答案是 9 根。', 'zh-Hans' => '答案是 9 根。',
                'en' => 'The answer is 9 sticks.', 'ja' => '答えは 9 本です。' },
      steps: {
        'zh-Hant' => [
          '正三角形有 3 條一樣長的邊。',
          '每邊排 2 根時，3 條邊各用 2 根，一共 2 × 3 = 6 根，和題目給的 6 根相符。',
          '角上的小棒不會被兩條邊共用，因為小棒是排在邊上、不是放在角的點上。',
          '所以每邊排 3 根時，3 條邊各用 3 根，一共是 3 × 3 = 9 根。',
        ],
        'zh-Hans' => [
          '正三角形有 3 条一样长的边。',
          '每边排 2 根时，3 条边各用 2 根，一共 2 × 3 = 6 根，和题目给的 6 根相符。',
          '角上的小棒不会被两条边共用，因为小棒是排在边上、不是放在角的点上。',
          '所以每边排 3 根时，3 条边各用 3 根，一共是 3 × 3 = 9 根。',
        ],
        'en' => [
          'An equilateral triangle has 3 sides of equal length.',
          'With 2 sticks along each side, the 3 sides use 2 × 3 = 6 sticks, which matches the 6 given in the problem.',
          'Sticks at the corners are not shared between two sides, because the sticks lie along the sides rather than sitting at the corner points.',
          'So with 3 sticks along each side, the 3 sides use 3 × 3 = 9 sticks in total.',
        ],
        'ja' => [
          '正三角形には同じ長さの辺が 3 本あります。',
          '1 辺に 2 本ずつ並べると 3 辺で 2 × 3 = 6 本となり、問題の 6 本と一致します。',
          '棒は辺の上に並べるもので角の点に置くものではないので、角の棒が 2 辺で共有されることはありません。',
          'したがって 1 辺に 3 本ずつなら 3 辺で 3 × 3 = 9 本必要です。',
        ],
      },
      value: '9', max_digits: 1,
      source: src('geometry-grade1-foundation',
        'Original composition in the Math Kangaroo grade 1-2 stick-building style; a worked smaller case is given so the solver can check the rule before scaling it, and the corner-sharing trap is ruled out explicitly. Not a reproduction of any past paper.'),
    ),
  ],
}.freeze

counts = {}
QUESTIONS.each do |topic, questions|
  path = PATHS[topic]
  pack = load_json(path)
  serial = pack['questions'].map { |q| q['id'].split('_').last.to_i }.max + 1
  ids = pack['questions'].map { |q| q['id'] }.to_set
  ordered = questions.each_with_index.map do |q, i|
    id = format('%s_%s_foundation_%03d', topic, GRADE, serial + i)
    raise "duplicate id #{id}" if ids.include?(id)

    { 'id' => id }.merge(q)
  end
  pack['questions'].concat(ordered)
  save_json(path, pack)
  counts[path] = pack['questions'].length
  puts "#{File.basename(path)} -> #{pack['questions'].length}"
end

manifest = load_json(MANIFEST_PATH)
manifest['packs'].each do |pack|
  full = File.join(ROOT, pack['path'])
  pack['questionCount'] = counts[full] if counts.key?(full)
end
save_json(MANIFEST_PATH, manifest)
