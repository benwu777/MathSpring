#!/usr/bin/env ruby
# frozen_string_literal: true

# grade5 subtopic 缺口補題（2026-08-27）
#   geometry  : angle_sum_polygon(正多邊形外角) / grid_path(有障礙路徑計數)
#               perimeter_change(切割周長增量) / parallel_lines(折線輔助線)
#   logic     : neighbor_constraint(圓桌) / sieve_elimination(逐步篩) / parity_reasoning(棋盤染色)
#   arithmetic: speed_catch_up / work_allocation / successive_changes

require 'json'
require 'set'

ROOT = File.expand_path('..', __dir__)
GRADE = 'grade5'
PATHS = {
  'geometry' => File.join(ROOT, "assets/questions/geometry/#{GRADE}_foundation.geometry.v1.json"),
  'logic' => File.join(ROOT, "assets/questions/logic/#{GRADE}_foundation.logic.v1.json"),
  'arithmetic' => File.join(ROOT, "assets/questions/arithmetic/#{GRADE}_foundation.arithmetic.v1.json"),
}.freeze
MANIFEST_PATH = File.join(ROOT, 'assets/questions/manifest.json')

def load_json(path) = JSON.parse(File.read(path))
def save_json(path, data) = File.write(path, JSON.pretty_generate(data) + "\n")
def src(reference, notes)
  { 'type' => 'rewritten_olympiad_style', 'name' => 'MathSpring Editorial',
    'reference' => reference, 'notes' => notes }
end
def figure_none = { 'type' => 'custom', 'kind' => 'none', 'params' => {} }
def scene(params) = { 'type' => 'custom', 'kind' => 'geometry_scene', 'params' => params.merge('kind' => 'geometry_scene') }
def hidden(name, x, y) = { 'name' => name, 'x' => x, 'y' => y, 'visible' => false }
def shown(name, x, y, pos) = { 'name' => name, 'x' => x, 'y' => y, 'pos' => pos }
def seg(a, b, style = 'solid') = { 'from' => a, 'to' => b, 'style' => style }

def base(topic:, subtopic:, prompt:, answer:, steps:, figure:, source:)
  { 'reviewStatus' => 'ok', 'topic' => topic, 'subtopic' => subtopic,
    'difficulty' => 'foundation', 'levelStage' => GRADE, 'challengeTier' => 'foundation',
    'prompt' => prompt, 'answer' => answer, 'solutionSteps' => steps,
    'figure' => figure, 'source' => source }
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

QUESTIONS = {
  'geometry' => [
    int_q(
      topic: 'geometry', subtopic: 'angle_sum_polygon',
      prompt: {
        'zh-Hant' => '一個正多邊形（每條邊一樣長、每個角一樣大）的每一個內角都是 150 度。這個正多邊形有幾條邊？',
        'zh-Hans' => '一个正多边形（每条边一样长、每个角一样大）的每一个内角都是 150 度。这个正多边形有几条边？',
        'en' => 'Every interior angle of a regular polygon (all sides equal and all angles equal) measures 150 degrees. How many sides does the polygon have?',
        'ja' => 'ある正多角形（すべての辺の長さが等しく、すべての角の大きさも等しい）の内角はどれも 150 度です。この正多角形の辺は何本ですか。',
      },
      answer: { 'zh-Hant' => '答案是 12 條邊。', 'zh-Hans' => '答案是 12 条边。',
                'en' => 'The answer is 12 sides.', 'ja' => '答えは 12 本です。' },
      steps: {
        'zh-Hant' => [
          '在每個頂點，內角和外角合起來是一條直線，也就是 180 度。',
          '既然每個內角是 150 度，每個外角就是 180 − 150 = 30 度。',
          '不論邊數多少，任何多邊形的外角總和都是 360 度。',
          '所以邊數是 360 ÷ 30 = 12，這個正多邊形有 12 條邊。',
        ],
        'zh-Hans' => [
          '在每个顶点，内角和外角合起来是一条直线，也就是 180 度。',
          '既然每个内角是 150 度，每个外角就是 180 − 150 = 30 度。',
          '不论边数多少，任何多边形的外角总和都是 360 度。',
          '所以边数是 360 ÷ 30 = 12，这个正多边形有 12 条边。',
        ],
        'en' => [
          'At each vertex the interior angle and the exterior angle together form a straight line, that is 180 degrees.',
          'Since each interior angle is 150 degrees, each exterior angle is 180 − 150 = 30 degrees.',
          'For any polygon, however many sides it has, the exterior angles add up to 360 degrees.',
          'So the number of sides is 360 ÷ 30 = 12, and the regular polygon has 12 sides.',
        ],
        'ja' => [
          'どの頂点でも、内角と外角を合わせると一直線、つまり 180 度になります。',
          '内角がどれも 150 度なので、外角はどれも 180 − 150 = 30 度です。',
          '辺の数がいくつであっても、多角形の外角の和は 360 度です。',
          'したがって辺の数は 360 ÷ 30 = 12 で、この正多角形の辺は 12 本です。',
        ],
      },
      value: '12', max_digits: 2, figure: figure_none,
      source: src('geometry-grade5-foundation',
        'Original composition in the Math Kangaroo grade 5-6 polygon-angle style; the exterior-angle sum gives a shorter route than the interior-angle formula, and the renderer cannot draw a regular 12-gon so no figure is attached. Not a reproduction of any past paper.'),
    ),
    int_q(
      topic: 'geometry', subtopic: 'grid_path',
      prompt: {
        'zh-Hant' => '方格街道圖上，小安要從 A 點走到 B 點，必須向右走 3 段、向上走 3 段，每一步只能向右或向上。可是圖中標著 X 的那個路口正在施工，完全不能經過。這樣的最短路線一共有幾條？',
        'zh-Hans' => '方格街道图上，小安要从 A 点走到 B 点，必须向右走 3 段、向上走 3 段，每一步只能向右或向上。可是图中标着 X 的那个路口正在施工，完全不能经过。这样的最短路线一共有几条？',
        'en' => 'On a grid of streets, An walks from A to B, needing 3 steps to the right and 3 steps up, with every step either to the right or upwards. However the junction marked X is closed for building work and cannot be used at all. How many shortest routes are there?',
        'ja' => '碁盤の目の道を、アンさんは A から B まで進みます。右に 3 区画、上に 3 区画進む必要があり、1 歩ごとに右か上にしか進めません。ただし図で X と書かれた交差点は工事中で、まったく通れません。このような最短の道すじは全部で何通りありますか。',
      },
      answer: { 'zh-Hant' => '答案是 8 條。', 'zh-Hans' => '答案是 8 条。',
                'en' => 'The answer is 8 routes.', 'ja' => '答えは 8 通りです。' },
      steps: {
        'zh-Hant' => [
          '先不管施工，每條最短路線都是 6 步中選 3 步向右，路線數是 (6 × 5 × 4) ÷ (3 × 2 × 1) = 20 條。',
          '再算會經過 X 的路線有幾條。從 A 走到 X 要向右 1 步、向上 1 步，走法有 2 種。',
          '從 X 走到 B 要向右 2 步、向上 2 步，走法是 4 步中選 2 步向右，有 (4 × 3) ÷ (2 × 1) = 6 種。',
          '所以經過 X 的路線有 2 × 6 = 12 條。',
          '把它們從全部路線中扣掉，可以走的最短路線是 20 − 12 = 8 條。',
        ],
        'zh-Hans' => [
          '先不管施工，每条最短路线都是 6 步中选 3 步向右，路线数是 (6 × 5 × 4) ÷ (3 × 2 × 1) = 20 条。',
          '再算会经过 X 的路线有几条。从 A 走到 X 要向右 1 步、向上 1 步，走法有 2 种。',
          '从 X 走到 B 要向右 2 步、向上 2 步，走法是 4 步中选 2 步向右，有 (4 × 3) ÷ (2 × 1) = 6 种。',
          '所以经过 X 的路线有 2 × 6 = 12 条。',
          '把它们从全部路线中扣掉，可以走的最短路线是 20 − 12 = 8 条。',
        ],
        'en' => [
          'Ignoring the closure first, each shortest route chooses 3 of the 6 steps to be rightward, giving (6 × 5 × 4) ÷ (3 × 2 × 1) = 20 routes.',
          'Now count the routes that pass through X. Getting from A to X takes 1 step right and 1 step up, which can be done in 2 ways.',
          'Getting from X to B takes 2 steps right and 2 steps up, choosing 2 of 4 steps to be rightward, which is (4 × 3) ÷ (2 × 1) = 6 ways.',
          'So the routes through X number 2 × 6 = 12.',
          'Subtracting them from all routes leaves 20 − 12 = 8 usable shortest routes.',
        ],
        'ja' => [
          'まず工事を無視すると、最短の道すじは 6 歩のうち 3 歩を右に選ぶので、(6 × 5 × 4) ÷ (3 × 2 × 1) = 20 通りです。',
          '次に X を通る道すじの数を数えます。A から X までは右に 1 歩、上に 1 歩で 2 通りです。',
          'X から B までは右に 2 歩、上に 2 歩で、4 歩のうち 2 歩を右に選ぶので (4 × 3) ÷ (2 × 1) = 6 通りです。',
          'したがって X を通る道すじは 2 × 6 = 12 通りです。',
          '全体から引くと、通れる最短の道すじは 20 − 12 = 8 通りです。',
        ],
      },
      value: '8', max_digits: 1,
      figure: scene(
        'bounds' => { 'minX' => -0.5, 'minY' => -0.5, 'maxX' => 3.5, 'maxY' => 3.5 },
        'points' => [shown('A', 0, 0, 'bl'), shown('B', 3, 3, 'tr'), shown('X', 1, 1, 'tr'),
                     hidden('p30', 3, 0), hidden('p01', 0, 1), hidden('p31', 3, 1),
                     hidden('p02', 0, 2), hidden('p32', 3, 2), hidden('p03', 0, 3),
                     hidden('p10', 1, 0), hidden('p13', 1, 3), hidden('p20', 2, 0), hidden('p23', 2, 3)],
        'segments' => [seg('A', 'p30'), seg('p01', 'p31'), seg('p02', 'p32'), seg('p03', 'B'),
                       seg('A', 'p03'), seg('p10', 'p13'), seg('p20', 'p23'), seg('p30', 'B')],
      ),
      source: src('geometry-grade5-foundation',
        'Original composition in the Math Kangaroo grade 5-6 lattice-path style; a blocked junction turns a plain path count into a complementary count, which is a different argument from listing routes. Not a reproduction of any past paper.'),
    ),
    int_q(
      topic: 'geometry', subtopic: 'perimeter_change',
      prompt: {
        'zh-Hant' => '一個長方形的長是 12 公分、寬是 5 公分。沿著一條和寬邊平行的直線把它剪成兩塊，兩塊都還是長方形。這兩個小長方形的周長加起來，比原來長方形的周長多幾公分？',
        'zh-Hans' => '一个长方形的长是 12 厘米、宽是 5 厘米。沿着一条和宽边平行的直线把它剪成两块，两块都还是长方形。这两个小长方形的周长加起来，比原来长方形的周长多几厘米？',
        'en' => 'A rectangle is 12 cm long and 5 cm wide. It is cut along a straight line parallel to the width into two pieces, both of which are still rectangles. By how many centimetres does the sum of the two smaller perimeters exceed the perimeter of the original rectangle?',
        'ja' => '縦 5 cm、横 12 cm の長方形があります。短いほうの辺に平行な直線にそって切り、2 つの長方形に分けます。この 2 つの長方形の周の長さの和は、もとの長方形の周の長さより何センチメートル長いですか。',
      },
      answer: { 'zh-Hant' => '答案是 10 公分。', 'zh-Hans' => '答案是 10 厘米。',
                'en' => 'The answer is 10 centimetres.', 'ja' => '答えは 10 センチメートルです。' },
      steps: {
        'zh-Hant' => [
          '剪開之後，原來長方形的四條邊全部都還在，只是分別落到兩個小長方形上。',
          '除了原來的四條邊以外，剪出來的那一刀在兩個小長方形上各留下一條新的邊。',
          '這一刀和寬邊平行，長度就等於寬，也就是 5 公分，而且兩塊各有一條。',
          '所以周長總和比原來多 5 × 2 = 10 公分，答案和剪的位置在哪裡完全無關。',
        ],
        'zh-Hans' => [
          '剪开之后，原来长方形的四条边全部都还在，只是分别落到两个小长方形上。',
          '除了原来的四条边以外，剪出来的那一刀在两个小长方形上各留下一条新的边。',
          '这一刀和宽边平行，长度就等于宽，也就是 5 厘米，而且两块各有一条。',
          '所以周长总和比原来多 5 × 2 = 10 厘米，答案和剪的位置在哪里完全无关。',
        ],
        'en' => [
          'After the cut, all four sides of the original rectangle are still present, simply shared out between the two smaller rectangles.',
          'Besides those original sides, the cut itself leaves one new edge on each of the two pieces.',
          'The cut is parallel to the width, so its length equals the width, 5 cm, and each piece gains one such edge.',
          'The total perimeter therefore exceeds the original by 5 × 2 = 10 cm, and the answer does not depend on where the cut is made.',
        ],
        'ja' => [
          '切ったあとも、もとの長方形の 4 辺はすべて残っていて、2 つの長方形に分かれてついています。',
          'それに加えて、切り口が 2 つの長方形それぞれに新しい辺を 1 本ずつ作ります。',
          '切り口は短い辺に平行なので長さは 5 cm で、2 つの長方形に 1 本ずつあります。',
          'したがって周の長さの和はもとより 5 × 2 = 10 cm 長くなり、どこで切ったかには関係しません。',
        ],
      },
      value: '10', max_digits: 2, figure: figure_none,
      source: src('geometry-grade5-foundation',
        'Original composition in the Math Kangaroo grade 5-6 perimeter style; the increase is independent of where the cut lands, which is the structural observation being tested. Not a reproduction of any past paper.'),
    ),
    int_q(
      topic: 'geometry', subtopic: 'parallel_lines',
      prompt: {
        'zh-Hant' => '圖中的兩條直線 AU 和 CL 互相平行。B 是兩條平行線之間的一個轉折點，A、B、C 用兩條線段連起來。已知 AB 和上面那條平行線的夾角是 40 度，CB 和下面那條平行線的夾角是 30 度。角 ABC 是幾度？',
        'zh-Hans' => '图中的两条直线 AU 和 CL 互相平行。B 是两条平行线之间的一个转折点，A、B、C 用两条线段连起来。已知 AB 和上面那条平行线的夹角是 40 度，CB 和下面那条平行线的夹角是 30 度。角 ABC 是几度？',
        'en' => 'In the figure the lines AU and CL are parallel. B is a bend point between the two parallel lines, joined to A and to C by two segments. The angle between AB and the upper parallel line is 40 degrees, and the angle between CB and the lower parallel line is 30 degrees. How many degrees is the angle ABC?',
        'ja' => '図の 2 本の直線 AU と CL は平行です。B は 2 本の平行線の間にある折れ点で、A と C にそれぞれ線分で結ばれています。AB と上の平行線がつくる角は 40 度、CB と下の平行線がつくる角は 30 度です。角 ABC は何度ですか。',
      },
      answer: { 'zh-Hant' => '答案是 70 度。', 'zh-Hans' => '答案是 70 度。',
                'en' => 'The answer is 70 degrees.', 'ja' => '答えは 70 度です。' },
      steps: {
        'zh-Hant' => [
          '通過轉折點 B 畫一條輔助線，讓它和上下兩條平行線都平行。',
          '這條輔助線和 AB 所夾的角，與 AB 和上面平行線所夾的 40 度是內錯角，所以也是 40 度。',
          '同樣地，這條輔助線和 CB 所夾的角，與 CB 和下面平行線所夾的 30 度是內錯角，所以也是 30 度。',
          '角 ABC 剛好被這條輔助線分成上下兩個角，所以角 ABC = 40 + 30 = 70 度。',
        ],
        'zh-Hans' => [
          '通过转折点 B 画一条辅助线，让它和上下两条平行线都平行。',
          '这条辅助线和 AB 所夹的角，与 AB 和上面平行线所夹的 40 度是内错角，所以也是 40 度。',
          '同样地，这条辅助线和 CB 所夹的角，与 CB 和下面平行线所夹的 30 度是内错角，所以也是 30 度。',
          '角 ABC 刚好被这条辅助线分成上下两个角，所以角 ABC = 40 + 30 = 70 度。',
        ],
        'en' => [
          'Draw a helper line through the bend point B parallel to both of the given parallel lines.',
          'The angle between that helper line and AB is an alternate angle to the 40 degrees between AB and the upper line, so it is also 40 degrees.',
          'In the same way the angle between the helper line and CB is an alternate angle to the 30 degrees between CB and the lower line, so it is also 30 degrees.',
          'The helper line splits angle ABC into those two parts, so angle ABC = 40 + 30 = 70 degrees.',
        ],
        'ja' => [
          '折れ点 B を通り、上下 2 本の平行線と平行な補助線を引きます。',
          'この補助線と AB がつくる角は、AB と上の平行線がつくる 40 度と錯角の関係にあるので、やはり 40 度です。',
          '同じように、補助線と CB がつくる角は、CB と下の平行線がつくる 30 度と錯角なので 30 度です。',
          '角 ABC はこの補助線でちょうど上下 2 つに分けられるので、角 ABC = 40 + 30 = 70 度です。',
        ],
      },
      value: '70', max_digits: 2,
      figure: scene(
        'bounds' => { 'minX' => -0.5, 'minY' => -0.6, 'maxX' => 6.5, 'maxY' => 3.6 },
        'points' => [shown('A', 0, 3, 'l'), shown('U', 6, 3, 'r'),
                     shown('C', 0, 0, 'l'), shown('L', 6, 0, 'r'),
                     shown('B', 2.117971, 1.222811, 'r')],
        'segments' => [seg('A', 'U'), seg('C', 'L'), seg('A', 'B'), seg('C', 'B')],
        'angleMarks' => [{ 'at' => 'A', 'from' => 'U', 'to' => 'B', 'label' => '40°' },
                         { 'at' => 'C', 'from' => 'L', 'to' => 'B', 'label' => '30°' }],
      ),
      source: src('geometry-grade5-foundation',
        'Original composition in the Math Kangaroo grade 5-6 parallel-lines style; the intended move is adding a helper line through the bend, and the bend coordinates were solved so that the marked angles equal their labels exactly. Not a reproduction of any past paper.'),
    ),
  ],
  'logic' => [
    int_q(
      topic: 'logic', subtopic: 'neighbor_constraint',
      prompt: {
        'zh-Hant' => '5 個小朋友圍著一張圓桌坐下，每個座位坐一個人。其中小安和小美吵架了，這兩個人不可以坐在相鄰的位置。如果把整桌一起轉一下之後看起來一樣的坐法算成同一種，那麼符合條件的坐法一共有幾種？',
        'zh-Hans' => '5 个小朋友围着一张圆桌坐下，每个座位坐一个人。其中小安和小美吵架了，这两个人不可以坐在相邻的位置。如果把整桌一起转一下之后看起来一样的坐法算成同一种，那么符合条件的坐法一共有几种？',
        'en' => 'Five children sit around a round table, one child per seat. An and Mei have quarrelled and must not sit next to each other. If two seatings that look the same after turning the whole table count as one seating, how many seatings satisfy the condition?',
        'ja' => '5 人の子どもが丸いテーブルのまわりに 1 人ずつすわります。アンさんとミイさんはけんかをしたので、となり合ってすわることはできません。テーブル全体を回すと同じに見えるすわり方は 1 通りと数えるとき、条件に合うすわり方は全部で何通りありますか。',
      },
      answer: { 'zh-Hant' => '答案是 12 種。', 'zh-Hans' => '答案是 12 种。',
                'en' => 'The answer is 12 seatings.', 'ja' => '答えは 12 通りです。' },
      steps: {
        'zh-Hant' => [
          '因為轉一圈看起來一樣的算同一種，可以先讓小安固定坐在某一個位置，再排其他 4 個人。',
          '這時剩下 4 個人可以任意坐 4 個位置，一共有 4 × 3 × 2 × 1 = 24 種坐法。',
          '小安固定之後，他左右兩邊各有 1 個相鄰座位，小美坐到其中任何一個就違反規定。',
          '小美坐在這 2 個相鄰座位之一時，剩下 3 個人有 3 × 2 × 1 = 6 種坐法，所以不合規定的有 2 × 6 = 12 種。',
          '所以符合條件的坐法有 24 − 12 = 12 種。',
        ],
        'zh-Hans' => [
          '因为转一圈看起来一样的算同一种，可以先让小安固定坐在某一个位置，再排其他 4 个人。',
          '这时剩下 4 个人可以任意坐 4 个位置，一共有 4 × 3 × 2 × 1 = 24 种坐法。',
          '小安固定之后，他左右两边各有 1 个相邻座位，小美坐到其中任何一个就违反规定。',
          '小美坐在这 2 个相邻座位之一时，剩下 3 个人有 3 × 2 × 1 = 6 种坐法，所以不合规定的有 2 × 6 = 12 种。',
          '所以符合条件的坐法有 24 − 12 = 12 种。',
        ],
        'en' => [
          'Since seatings that match after turning the table count as one, fix An in a particular seat and arrange the other four children.',
          'The remaining 4 children can fill the 4 seats in 4 × 3 × 2 × 1 = 24 ways.',
          'With An fixed, there is one neighbouring seat on each side, and Mei in either of them breaks the rule.',
          'For each of those 2 seats, the other 3 children can be arranged in 3 × 2 × 1 = 6 ways, so 2 × 6 = 12 seatings break the rule.',
          'The number of valid seatings is therefore 24 − 12 = 12.',
        ],
        'ja' => [
          '回して同じに見えるすわり方を 1 通りと数えるので、アンさんの席を 1 つに固定して、残りの 4 人を並べます。',
          '残りの 4 人が 4 つの席にすわる方法は 4 × 3 × 2 × 1 = 24 通りです。',
          'アンさんを固定すると、その左右にとなりの席が 1 つずつあり、ミイさんがそのどちらかにすわると規則に反します。',
          'その 2 席それぞれについて、残り 3 人の並び方は 3 × 2 × 1 = 6 通りなので、規則に反するのは 2 × 6 = 12 通りです。',
          'したがって条件に合うすわり方は 24 − 12 = 12 通りです。',
        ],
      },
      value: '12', max_digits: 2, figure: figure_none,
      source: src('logic-grade5-foundation',
        'Original composition in the Math Kangaroo grade 5-6 circular-arrangement style; rotational equivalence must be handled by fixing one person before the adjacency ban is applied. Not a reproduction of any past paper.'),
    ),
    int_q(
      topic: 'logic', subtopic: 'sieve_elimination',
      prompt: {
        'zh-Hant' => '把 1 到 30 的整數全部寫在紙上。先把所有 2 的倍數劃掉，接著在還沒被劃掉的數之中，再把所有 3 的倍數也劃掉。最後紙上還剩下幾個數沒有被劃掉？',
        'zh-Hans' => '把 1 到 30 的整数全部写在纸上。先把所有 2 的倍数划掉，接着在还没被划掉的数之中，再把所有 3 的倍数也划掉。最后纸上还剩下几个数没有被划掉？',
        'en' => 'The integers from 1 to 30 are all written on a sheet of paper. First every multiple of 2 is crossed out, and then, among the numbers not yet crossed out, every multiple of 3 is crossed out as well. How many numbers are left uncrossed at the end?',
        'ja' => '1 から 30 までの整数をすべて紙に書きます。まず 2 の倍数をすべて消し、次に、まだ消されていない数の中から 3 の倍数をすべて消します。最後に消されずに残る数は何個ですか。',
      },
      answer: { 'zh-Hant' => '答案是 10 個。', 'zh-Hans' => '答案是 10 个。',
                'en' => 'The answer is 10 numbers.', 'ja' => '答えは 10 個です。' },
      steps: {
        'zh-Hant' => [
          '1 到 30 之中，2 的倍數有 30 ÷ 2 = 15 個，把它們劃掉後剩下 30 − 15 = 15 個奇數。',
          '第二步只在這 15 個奇數裡面找 3 的倍數，也就是同時是 3 的倍數又是奇數的數。',
          '這樣的數是 3、9、15、21、27，一共 5 個。',
          '所以最後沒有被劃掉的數有 15 − 5 = 10 個。',
        ],
        'zh-Hans' => [
          '1 到 30 之中，2 的倍数有 30 ÷ 2 = 15 个，把它们划掉后剩下 30 − 15 = 15 个奇数。',
          '第二步只在这 15 个奇数里面找 3 的倍数，也就是同时是 3 的倍数又是奇数的数。',
          '这样的数是 3、9、15、21、27，一共 5 个。',
          '所以最后没有被划掉的数有 15 − 5 = 10 个。',
        ],
        'en' => [
          'Among 1 to 30 there are 30 ÷ 2 = 15 multiples of 2, and crossing them out leaves 30 − 15 = 15 odd numbers.',
          'The second step looks for multiples of 3 only among those 15 odd numbers, that is, numbers that are both odd and multiples of 3.',
          'Those numbers are 3, 9, 15, 21 and 27, five of them in all.',
          'So the numbers left uncrossed are 15 − 5 = 10.',
        ],
        'ja' => [
          '1 から 30 の中に 2 の倍数は 30 ÷ 2 = 15 個あり、消すと 30 − 15 = 15 個の奇数が残ります。',
          '2 番目の手順では、この 15 個の奇数の中だけで 3 の倍数、つまり奇数でありかつ 3 の倍数である数をさがします。',
          'それは 3、9、15、21、27 の 5 個です。',
          'したがって最後まで消されずに残る数は 15 − 5 = 10 個です。',
        ],
      },
      value: '10', max_digits: 2, figure: figure_none,
      source: src('logic-grade5-foundation',
        'Original composition in the Math Kangaroo grade 5-6 sieving style; the second sieve acts only on the survivors of the first, so a plain inclusion-exclusion count of multiples gives the wrong answer. Not a reproduction of any past paper.'),
    ),
    mc_q(
      topic: 'logic', subtopic: 'parity_reasoning',
      prompt: {
        'zh-Hant' => '一個 8 × 8 的棋盤，格子照西洋棋的方式黑白相間著色，黑白各 32 格。現在把棋盤上位於對角線兩端的兩個角落格子剪掉（這兩格顏色相同），剩下 62 格。骨牌是 1 × 2 的長方形，每一塊剛好蓋住相鄰的兩格。用 31 塊骨牌有沒有可能把剩下的 62 格完全蓋滿，而且不重疊、不超出棋盤？',
        'zh-Hans' => '一个 8 × 8 的棋盘，格子照国际象棋的方式黑白相间着色，黑白各 32 格。现在把棋盘上位于对角线两端的两个角落格子剪掉（这两格颜色相同），剩下 62 格。骨牌是 1 × 2 的长方形，每一块刚好盖住相邻的两格。用 31 块骨牌有没有可能把剩下的 62 格完全盖满，而且不重叠、不超出棋盘？',
        'en' => 'An 8 × 8 board is coloured black and white like a chessboard, with 32 squares of each colour. The two corner squares at opposite ends of a diagonal are cut away (these two squares have the same colour), leaving 62 squares. A domino is a 1 × 2 rectangle covering exactly two neighbouring squares. Is it possible for 31 dominoes to cover the remaining 62 squares completely, without overlapping and without hanging off the board?',
        'ja' => '8 × 8 の盤面をチェス盤のように白黒に塗り分けると、白と黒が 32 マスずつになります。ここから対角線の両端にある 2 つのすみのマス（この 2 マスは同じ色です）を切り取り、62 マスが残ります。ドミノは 1 × 2 の長方形で、となり合う 2 マスをちょうどおおいます。31 枚のドミノで残りの 62 マスを、重ならず盤からはみ出さずに完全におおうことはできるでしょうか。',
      },
      answer: { 'zh-Hant' => '不可能，因為剪掉的兩格同色，剩下的黑白格數不相等。',
                'zh-Hans' => '不可能，因为剪掉的两格同色，剩下的黑白格数不相等。',
                'en' => 'It is impossible, because the two removed squares share a colour, so the remaining colours are unequal in number.',
                'ja' => 'できません。取り除いた 2 マスが同じ色なので、残りの白黒のマス数が等しくならないからです。' },
      steps: {
        'zh-Hant' => [
          '每一塊 1 × 2 骨牌無論放在哪裡，都一定同時蓋住一個黑格和一個白格。',
          '所以 31 塊骨牌一定剛好蓋住 31 個黑格和 31 個白格。',
          '原本黑白各 32 格，剪掉的兩個角落格顏色相同，假設都是黑格，那麼剩下的是 30 個黑格和 32 個白格。',
          '要蓋滿就必須黑白各 31 格，但實際上是 30 和 32，數目對不起來。',
          '所以不論怎麼擺，都不可能蓋滿，答案是不可能。',
        ],
        'zh-Hans' => [
          '每一块 1 × 2 骨牌无论放在哪里，都一定同时盖住一个黑格和一个白格。',
          '所以 31 块骨牌一定刚好盖住 31 个黑格和 31 个白格。',
          '原本黑白各 32 格，剪掉的两个角落格颜色相同，假设都是黑格，那么剩下的是 30 个黑格和 32 个白格。',
          '要盖满就必须黑白各 31 格，但实际上是 30 和 32，数目对不起来。',
          '所以不论怎么摆，都不可能盖满，答案是不可能。',
        ],
        'en' => [
          'Wherever a 1 × 2 domino is placed, it always covers exactly one black square and one white square.',
          'So 31 dominoes must cover exactly 31 black squares and 31 white squares.',
          'The board starts with 32 of each colour, and the two removed corners share a colour, say black, leaving 30 black squares and 32 white squares.',
          'A complete cover would need 31 of each colour, but the actual counts are 30 and 32, which do not match.',
          'No arrangement can work, so the answer is that it is impossible.',
        ],
        'ja' => [
          '1 × 2 のドミノはどこに置いても、必ず黒 1 マスと白 1 マスを同時におおいます。',
          'したがって 31 枚のドミノは、ちょうど黒 31 マスと白 31 マスをおおうことになります。',
          'はじめは白黒 32 マスずつで、取り除いた 2 つのすみは同じ色、たとえば黒とすると、残りは黒 30 マスと白 32 マスです。',
          '完全におおうには白黒 31 マスずつ必要ですが、実際は 30 と 32 で数が合いません。',
          'どのように並べても不可能なので、答えは「できない」です。',
        ],
      },
      options: {
        'A' => { 'zh-Hant' => '不可能，因為剩下的黑格和白格數目不相等', 'zh-Hans' => '不可能，因为剩下的黑格和白格数目不相等',
                 'en' => 'Impossible, because the remaining black and white squares are unequal in number',
                 'ja' => 'できない。残った黒と白のマス数が等しくないから' },
        'B' => { 'zh-Hant' => '可能，只要從角落開始一排一排鋪就行', 'zh-Hans' => '可能，只要从角落开始一排一排铺就行',
                 'en' => 'Possible, by tiling row by row starting from a corner',
                 'ja' => 'できる。すみから 1 列ずつしきつめればよい' },
        'C' => { 'zh-Hant' => '可能，因為 62 剛好是 31 的 2 倍', 'zh-Hans' => '可能，因为 62 刚好是 31 的 2 倍',
                 'en' => 'Possible, because 62 is exactly twice 31', 'ja' => 'できる。62 はちょうど 31 の 2 倍だから' },
        'D' => { 'zh-Hant' => '不可能，因為 62 不是 4 的倍數', 'zh-Hans' => '不可能，因为 62 不是 4 的倍数',
                 'en' => 'Impossible, because 62 is not a multiple of 4', 'ja' => 'できない。62 が 4 の倍数でないから' },
      },
      correct: 'A',
      figure: figure_none,
      source: src('logic-grade5-foundation',
        'Original composition in the classic mutilated-chessboard style used at Math Kangaroo grade 5-6 level; option C states the tempting counting argument and option D gives the right verdict with a wrong reason, so the colouring invariant itself is what is tested. Not a reproduction of any past paper.'),
    ),
  ],
  'arithmetic' => [
    int_q(
      topic: 'arithmetic', subtopic: 'speed_catch_up',
      prompt: {
        'zh-Hant' => '哥哥每分鐘走 60 公尺，妹妹每分鐘走 45 公尺。妹妹先從家裡出發，走了 5 分鐘之後哥哥才從同一個地方出發，沿著同一條路去追。哥哥出發後幾分鐘可以追上妹妹？',
        'zh-Hans' => '哥哥每分钟走 60 米，妹妹每分钟走 45 米。妹妹先从家里出发，走了 5 分钟之后哥哥才从同一个地方出发，沿着同一条路去追。哥哥出发后几分钟可以追上妹妹？',
        'en' => 'An older brother walks 60 metres a minute and his younger sister walks 45 metres a minute. The sister sets off from home first, and 5 minutes later the brother sets off from the same place along the same road to catch up. How many minutes after setting off does the brother catch her?',
        'ja' => '兄は 1 分間に 60 m、妹は 1 分間に 45 m 歩きます。妹が先に家を出発し、その 5 分後に兄が同じ場所から同じ道を追いかけて出発します。兄が出発してから何分後に妹に追いつきますか。',
      },
      answer: { 'zh-Hant' => '答案是 15 分鐘。', 'zh-Hans' => '答案是 15 分钟。',
                'en' => 'The answer is 15 minutes.', 'ja' => '答えは 15 分後です。' },
      steps: {
        'zh-Hant' => [
          '妹妹先走了 5 分鐘，這段時間她走了 45 × 5 = 225 公尺，這就是哥哥出發時兩人相差的距離。',
          '哥哥每分鐘走 60 公尺，妹妹每分鐘走 45 公尺，所以哥哥每分鐘只能追近 60 − 45 = 15 公尺。',
          '要追上就必須把 225 公尺的差距全部追完。',
          '所需時間是 225 ÷ 15 = 15 分鐘，所以哥哥出發後 15 分鐘追上妹妹。',
        ],
        'zh-Hans' => [
          '妹妹先走了 5 分钟，这段时间她走了 45 × 5 = 225 米，这就是哥哥出发时两人相差的距离。',
          '哥哥每分钟走 60 米，妹妹每分钟走 45 米，所以哥哥每分钟只能追近 60 − 45 = 15 米。',
          '要追上就必须把 225 米的差距全部追完。',
          '所需时间是 225 ÷ 15 = 15 分钟，所以哥哥出发后 15 分钟追上妹妹。',
        ],
        'en' => [
          'The sister walks alone for 5 minutes, covering 45 × 5 = 225 metres, which is the gap when the brother starts.',
          'The brother covers 60 metres a minute and the sister 45, so the gap shrinks by only 60 − 45 = 15 metres each minute.',
          'Catching up means closing the whole 225 metre gap.',
          'That takes 225 ÷ 15 = 15 minutes, so the brother catches her 15 minutes after setting off.',
        ],
        'ja' => [
          '妹は先に 5 分歩き、その間に 45 × 5 = 225 m 進みます。これが兄の出発時の差です。',
          '兄は 1 分に 60 m、妹は 45 m 進むので、差は 1 分あたり 60 − 45 = 15 m ずつしか縮まりません。',
          '追いつくには 225 m の差をすべて縮める必要があります。',
          'かかる時間は 225 ÷ 15 = 15 分なので、兄は出発してから 15 分後に追いつきます。',
        ],
      },
      value: '15', max_digits: 2, figure: figure_none,
      source: src('arithmetic-grade5-foundation',
        'Original composition in the Math Kangaroo grade 5-6 pursuit style; the head start must be converted into a distance and then closed at the difference of the speeds. Not a reproduction of any past paper.'),
    ),
    int_q(
      topic: 'arithmetic', subtopic: 'work_allocation',
      prompt: {
        'zh-Hant' => '同一件工作，甲一個人做需要 12 天才能完成，乙一個人做需要 6 天就能完成。如果兩個人一起做，而且效率都不變，需要幾天才能完成這件工作？',
        'zh-Hans' => '同一件工作，甲一个人做需要 12 天才能完成，乙一个人做需要 6 天就能完成。如果两个人一起做，而且效率都不变，需要几天才能完成这件工作？',
        'en' => 'Working alone, A needs 12 days to finish a job and B needs 6 days to finish the same job. If they work together and each keeps the same rate, how many days does the job take?',
        'ja' => '同じ仕事を、甲が 1 人ですると 12 日、乙が 1 人ですると 6 日かかります。2 人が同じ調子で一緒に働くと、この仕事は何日で終わりますか。',
      },
      answer: { 'zh-Hant' => '答案是 4 天。', 'zh-Hans' => '答案是 4 天。',
                'en' => 'The answer is 4 days.', 'ja' => '答えは 4 日です。' },
      steps: {
        'zh-Hant' => [
          '把整件工作看成 12 份，這樣兩個人的工作量都會是整數，計算比較方便。',
          '甲 12 天做完 12 份，所以甲每天做 1 份；乙 6 天做完 12 份，所以乙每天做 2 份。',
          '兩個人一起做，每天可以完成 1 + 2 = 3 份。',
          '完成全部 12 份需要 12 ÷ 3 = 4 天，所以一起做需要 4 天。',
        ],
        'zh-Hans' => [
          '把整件工作看成 12 份，这样两个人的工作量都会是整数，计算比较方便。',
          '甲 12 天做完 12 份，所以甲每天做 1 份；乙 6 天做完 12 份，所以乙每天做 2 份。',
          '两个人一起做，每天可以完成 1 + 2 = 3 份。',
          '完成全部 12 份需要 12 ÷ 3 = 4 天，所以一起做需要 4 天。',
        ],
        'en' => [
          'Treat the whole job as 12 parts, which makes both workers\' daily amounts whole numbers.',
          'A finishes 12 parts in 12 days, so A does 1 part a day; B finishes 12 parts in 6 days, so B does 2 parts a day.',
          'Working together they complete 1 + 2 = 3 parts a day.',
          'Finishing all 12 parts takes 12 ÷ 3 = 4 days, so together they need 4 days.',
        ],
        'ja' => [
          '仕事全体を 12 個分と考えると、2 人の 1 日あたりの量が整数になり計算が楽になります。',
          '甲は 12 日で 12 個分なので 1 日 1 個分、乙は 6 日で 12 個分なので 1 日 2 個分です。',
          '2 人一緒だと 1 日に 1 + 2 = 3 個分できます。',
          '12 個分を終えるには 12 ÷ 3 = 4 日かかるので、一緒に働くと 4 日で終わります。',
        ],
      },
      value: '4', max_digits: 1, figure: figure_none,
      source: src('arithmetic-grade5-foundation',
        'Original composition in the Math Kangaroo grade 5-6 shared-work style; setting the job to a convenient total keeps the reasoning in whole numbers, which is the intended technique. Not a reproduction of any past paper.'),
    ),
    int_q(
      topic: 'arithmetic', subtopic: 'successive_changes',
      prompt: {
        'zh-Hant' => '一件商品先把原價調漲 20%，過了一陣子再用調漲後的價格打八折出售。最後的售價是原價的百分之幾？',
        'zh-Hans' => '一件商品先把原价调涨 20%，过了一阵子再用调涨后的价格打八折出售。最后的售价是原价的百分之几？',
        'en' => 'The price of an item is first raised by 20%. Some time later it is sold at 80% of that raised price. The final selling price is what percentage of the original price?',
        'ja' => 'ある商品の値段をまず 20% 値上げし、しばらくして、その値上げ後の値段の 80% で売りました。最終的な売り値はもとの値段の何パーセントですか。',
      },
      answer: { 'zh-Hant' => '答案是 96%。', 'zh-Hans' => '答案是 96%。',
                'en' => 'The answer is 96%.', 'ja' => '答えは 96% です。' },
      steps: {
        'zh-Hant' => [
          '為了計算方便，把原價當成 100 元。',
          '調漲 20% 之後，價格變成 100 + 100 × 20 ÷ 100 = 120 元。',
          '打八折就是用調漲後價格的 80% 出售，所以售價是 120 × 80 ÷ 100 = 96 元。',
          '96 元和原來的 100 元相比是 96%，所以最後售價是原價的 96%，並沒有回到原價。',
        ],
        'zh-Hans' => [
          '为了计算方便，把原价当成 100 元。',
          '调涨 20% 之后，价格变成 100 + 100 × 20 ÷ 100 = 120 元。',
          '打八折就是用调涨后价格的 80% 出售，所以售价是 120 × 80 ÷ 100 = 96 元。',
          '96 元和原来的 100 元相比是 96%，所以最后售价是原价的 96%，并没有回到原价。',
        ],
        'en' => [
          'For convenience take the original price to be 100 units.',
          'After a rise of 20% the price becomes 100 + 100 × 20 ÷ 100 = 120 units.',
          'Selling at 80% of the raised price gives 120 × 80 ÷ 100 = 96 units.',
          'Compared with the original 100 units that is 96%, so the final price is 96% of the original and does not return to it.',
        ],
        'ja' => [
          '計算しやすいように、もとの値段を 100 とします。',
          '20% 値上げすると、値段は 100 + 100 × 20 ÷ 100 = 120 になります。',
          '値上げ後の 80% で売るので、売り値は 120 × 80 ÷ 100 = 96 になります。',
          'もとの 100 と比べると 96 は 96% にあたるので、最終的な売り値はもとの値段の 96% で、もとにはもどりません。',
        ],
      },
      value: '96', max_digits: 2, figure: figure_none,
      source: src('arithmetic-grade5-foundation',
        'Original composition in the Math Kangaroo grade 5-6 percentage style; the wrong intuition that a 20% rise followed by a 20% discount returns to the original price is the point of the item. Not a reproduction of any past paper.'),
    ),
  ],
}.freeze

counts = {}
QUESTIONS.each do |topic, questions|
  path = PATHS[topic]
  pack = load_json(path)
  serial = pack['questions'].map { |q| q['id'].split('_').last.to_i }.max + 1
  questions.each_with_index { |q, i| q['id'] = format('%s_%s_foundation_%03d', topic, GRADE, serial + i) }
  ids = pack['questions'].map { |q| q['id'] }.to_set
  questions.each { |q| raise "duplicate id #{q['id']}" if ids.include?(q['id']) }
  pack['questions'].concat(questions)
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
