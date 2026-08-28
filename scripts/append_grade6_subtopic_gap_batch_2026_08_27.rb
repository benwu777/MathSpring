#!/usr/bin/env ruby
# frozen_string_literal: true

# grade6 subtopic 缺口補題（2026-08-27）
#   geometry  : angle_chase(五角星尖角和) / shape_counting(3×3 數正方形)
#               isosceles(三角不等式排除) / border_counting(逆推邊長與面積)
#   logic     : case_reasoning(位值分類) / one_true_one_false / arrangement(綁定法)
#   arithmetic: sequence_sum / maximization / pair_counting(同餘分類)

require 'json'
require 'set'

ROOT = File.expand_path('..', __dir__)
GRADE = 'grade6'
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

QUESTIONS = {
  'geometry' => [
    int_q(
      topic: 'geometry', subtopic: 'angle_chase',
      prompt: {
        'zh-Hant' => '把一個正五邊形的五個頂點 A、B、C、D、E 每隔一個連起來，會畫出一個五角星。這個五角星有五個向外突出的尖角。這五個尖角的度數加起來一共是多少度？',
        'zh-Hans' => '把一个正五边形的五个顶点 A、B、C、D、E 每隔一个连起来，会画出一个五角星。这个五角星有五个向外突出的尖角。这五个尖角的度数加起来一共是多少度？',
        'en' => 'Joining every second vertex of a regular pentagon A, B, C, D, E produces a five-pointed star. The star has five points sticking outwards. What is the sum of the angles at those five points, in degrees?',
        'ja' => '正五角形の 5 つの頂点 A、B、C、D、E を 1 つおきに結ぶと、五角星（星形）ができます。この星には外側にとがった角が 5 つあります。この 5 つのとがった角の大きさの和は何度ですか。',
      },
      answer: { 'zh-Hant' => '答案是 180 度。', 'zh-Hans' => '答案是 180 度。',
                'en' => 'The answer is 180 degrees.', 'ja' => '答えは 180 度です。' },
      steps: {
        'zh-Hant' => [
          '五角星的每一個尖角，都是某一個三角形突出在外面的頂角。',
          '把五個尖角所在的三角形一起看，會發現五角星中間圍出一個小正五邊形。',
          '利用三角形外角的性質，每一個尖角都等於小五邊形某一個外角減去另一個外角所剩下的部分；把五個尖角全部加起來，剛好等於小五邊形所有外角和的一半。',
          '任何多邊形的外角和都是 360 度，所以五個尖角的和是 360 ÷ 2 = 180 度。',
          '用正五角星檢查也一樣：每個尖角是 36 度，五個合起來是 36 × 5 = 180 度。',
        ],
        'zh-Hans' => [
          '五角星的每一个尖角，都是某一个三角形突出在外面的顶角。',
          '把五个尖角所在的三角形一起看，会发现五角星中间围出一个小正五边形。',
          '利用三角形外角的性质，每一个尖角都等于小五边形某一个外角减去另一个外角所剩下的部分；把五个尖角全部加起来，刚好等于小五边形所有外角和的一半。',
          '任何多边形的外角和都是 360 度，所以五个尖角的和是 360 ÷ 2 = 180 度。',
          '用正五角星检查也一样：每个尖角是 36 度，五个合起来是 36 × 5 = 180 度。',
        ],
        'en' => [
          'Each point of the star is the outward vertex of one of five triangles.',
          'Looking at those five triangles together shows that a small regular pentagon is enclosed in the middle of the star.',
          'By the exterior-angle property of a triangle, each star point equals what is left of one exterior angle of the small pentagon after another is taken away; adding all five points gives exactly half of the total of the small pentagon\'s exterior angles.',
          'The exterior angles of any polygon add up to 360 degrees, so the five points sum to 360 ÷ 2 = 180 degrees.',
          'Checking with the regular star agrees: each point is 36 degrees, and 36 × 5 = 180 degrees.',
        ],
        'ja' => [
          '星の 5 つのとがった角は、それぞれある三角形の外側に出た頂角です。',
          'その 5 つの三角形をまとめて見ると、星のまん中に小さな正五角形が囲まれていることがわかります。',
          '三角形の外角の性質を使うと、どのとがった角も小さな五角形の外角どうしの差にあたり、5 つすべてをたすと小さな五角形の外角の総和のちょうど半分になります。',
          '多角形の外角の和はつねに 360 度なので、5 つのとがった角の和は 360 ÷ 2 = 180 度です。',
          '正五角星で確かめても同じで、1 つのとがった角は 36 度、5 つで 36 × 5 = 180 度です。',
        ],
      },
      value: '180', max_digits: 3,
      figure: scene(
        'bounds' => { 'minX' => -0.8, 'minY' => -0.8, 'maxX' => 6.8, 'maxY' => 6.8 },
        'points' => [
          { 'name' => 'A', 'x' => 3.0, 'y' => 6.0, 'pos' => 't' },
          { 'name' => 'B', 'x' => 0.146830, 'y' => 3.927051, 'pos' => 'tl' },
          { 'name' => 'C', 'x' => 1.236644, 'y' => 0.572949, 'pos' => 'bl' },
          { 'name' => 'D', 'x' => 4.763356, 'y' => 0.572949, 'pos' => 'br' },
          { 'name' => 'E', 'x' => 5.853170, 'y' => 3.927051, 'pos' => 'tr' },
        ],
        'segments' => [seg('A', 'C'), seg('C', 'E'), seg('E', 'B'), seg('B', 'D'), seg('D', 'A')],
      ),
      source: src('geometry-grade6-foundation',
        'Original composition in the Math Kangaroo grade 5-6 angle-chasing style; the star-point sum is derived from the exterior-angle property rather than measured, and the figure shows the configuration without marking any angle. Not a reproduction of any past paper.'),
    ),
    int_q(
      topic: 'geometry', subtopic: 'shape_counting',
      prompt: {
        'zh-Hant' => '一個大正方形被格線分成 3 排 3 列，共 9 個一樣大的小正方形。在這個圖中，一共可以找出幾個正方形？（各種大小的正方形都要算進去。）',
        'zh-Hans' => '一个大正方形被格线分成 3 排 3 列，共 9 个一样大的小正方形。在这个图中，一共可以找出几个正方形？（各种大小的正方形都要算进去。）',
        'en' => 'A large square is divided by grid lines into 3 rows and 3 columns, giving 9 identical small squares. How many squares can be found in this figure altogether? (Squares of every size must be counted.)',
        'ja' => '大きな正方形が格子の線で 3 行 3 列に分けられ、同じ大きさの小さい正方形が 9 個できています。この図の中に正方形は全部でいくつありますか。（どの大きさの正方形も数えます。）',
      },
      answer: { 'zh-Hant' => '答案是 14 個。', 'zh-Hans' => '答案是 14 个。',
                'en' => 'The answer is 14 squares.', 'ja' => '答えは 14 個です。' },
      steps: {
        'zh-Hant' => [
          '正方形有 1 × 1、2 × 2、3 × 3 三種大小，要分別數。',
          '1 × 1 的小正方形就是格子本身，一共有 3 × 3 = 9 個。',
          '2 × 2 的正方形，它的左上角只能放在 2 × 2 = 4 個位置，所以有 4 個。',
          '3 × 3 的正方形就是整個大正方形，只有 1 個。',
          '所以總數是 9 + 4 + 1 = 14 個。',
        ],
        'zh-Hans' => [
          '正方形有 1 × 1、2 × 2、3 × 3 三种大小，要分别数。',
          '1 × 1 的小正方形就是格子本身，一共有 3 × 3 = 9 个。',
          '2 × 2 的正方形，它的左上角只能放在 2 × 2 = 4 个位置，所以有 4 个。',
          '3 × 3 的正方形就是整个大正方形，只有 1 个。',
          '所以总数是 9 + 4 + 1 = 14 个。',
        ],
        'en' => [
          'Squares come in three sizes here, 1 × 1, 2 × 2 and 3 × 3, and each size is counted separately.',
          'The 1 × 1 squares are the cells themselves, and there are 3 × 3 = 9 of them.',
          'A 2 × 2 square has its top-left corner in one of 2 × 2 = 4 positions, so there are 4 of them.',
          'The 3 × 3 square is the whole large square, so there is just 1.',
          'The total is therefore 9 + 4 + 1 = 14 squares.',
        ],
        'ja' => [
          'この図の正方形には 1 × 1、2 × 2、3 × 3 の 3 つの大きさがあり、大きさごとに数えます。',
          '1 × 1 の正方形はマスそのもので、3 × 3 = 9 個あります。',
          '2 × 2 の正方形は左上の角を 2 × 2 = 4 か所のどこかに置けるので、4 個あります。',
          '3 × 3 の正方形は大きな正方形そのもので 1 個です。',
          'したがって合計は 9 + 4 + 1 = 14 個です。',
        ],
      },
      value: '14', max_digits: 2,
      figure: scene(
        'bounds' => { 'minX' => -0.4, 'minY' => -0.4, 'maxX' => 3.4, 'maxY' => 3.4 },
        'points' => [hidden('r0a', 0, 0), hidden('r0b', 3, 0), hidden('r1a', 0, 1), hidden('r1b', 3, 1),
                     hidden('r2a', 0, 2), hidden('r2b', 3, 2), hidden('r3a', 0, 3), hidden('r3b', 3, 3),
                     hidden('c1a', 1, 0), hidden('c1b', 1, 3), hidden('c2a', 2, 0), hidden('c2b', 2, 3)],
        'segments' => [seg('r0a', 'r0b'), seg('r1a', 'r1b'), seg('r2a', 'r2b'), seg('r3a', 'r3b'),
                       seg('r0a', 'r3a'), seg('c1a', 'c1b'), seg('c2a', 'c2b'), seg('r0b', 'r3b')],
      ),
      source: src('geometry-grade6-foundation',
        'Original composition in the Math Kangaroo grade 5-6 figure-counting style; counting by square size is a different organising idea from choosing pairs of grid lines for rectangles. Not a reproduction of any past paper.'),
    ),
    int_q(
      topic: 'geometry', subtopic: 'isosceles',
      prompt: {
        'zh-Hant' => '一個等腰三角形的邊長只有 3 公分和 7 公分兩種長度。這個三角形的周長是幾公分？',
        'zh-Hans' => '一个等腰三角形的边长只有 3 厘米和 7 厘米两种长度。这个三角形的周长是几厘米？',
        'en' => 'The sides of an isosceles triangle have only two different lengths, 3 cm and 7 cm. What is the perimeter of the triangle, in centimetres?',
        'ja' => 'ある二等辺三角形の辺の長さは 3 cm と 7 cm の 2 種類だけです。この三角形の周の長さは何センチメートルですか。',
      },
      answer: { 'zh-Hant' => '答案是 17 公分。', 'zh-Hans' => '答案是 17 厘米。',
                'en' => 'The answer is 17 centimetres.', 'ja' => '答えは 17 センチメートルです。' },
      steps: {
        'zh-Hant' => [
          '等腰三角形有兩條邊一樣長，所以三邊只可能是 3、3、7 或 7、7、3。',
          '三角形要能圍得起來，任意兩邊的和必須大於第三邊。',
          '如果是 3、3、7，兩條短邊的和是 3 + 3 = 6，比 7 還小，這三條邊根本圍不成三角形。',
          '所以只能是 7、7、3，檢查一下 7 + 3 = 10 大於 7，確實可以圍成三角形。',
          '因此周長是 7 + 7 + 3 = 17 公分。',
        ],
        'zh-Hans' => [
          '等腰三角形有两条边一样长，所以三边只可能是 3、3、7 或 7、7、3。',
          '三角形要能围得起来，任意两边的和必须大于第三边。',
          '如果是 3、3、7，两条短边的和是 3 + 3 = 6，比 7 还小，这三条边根本围不成三角形。',
          '所以只能是 7、7、3，检查一下 7 + 3 = 10 大于 7，确实可以围成三角形。',
          '因此周长是 7 + 7 + 3 = 17 厘米。',
        ],
        'en' => [
          'An isosceles triangle has two equal sides, so the three sides are either 3, 3, 7 or 7, 7, 3.',
          'For a triangle to close up, the sum of any two sides must be greater than the third.',
          'For 3, 3, 7 the two short sides give 3 + 3 = 6, which is less than 7, so those lengths cannot form a triangle at all.',
          'So the sides must be 7, 7, 3, and checking gives 7 + 3 = 10, greater than 7, so this triangle does exist.',
          'The perimeter is therefore 7 + 7 + 3 = 17 centimetres.',
        ],
        'ja' => [
          '二等辺三角形は 2 辺が等しいので、3 辺は 3、3、7 か 7、7、3 のどちらかです。',
          '三角形ができるためには、どの 2 辺の和も残りの 1 辺より大きくなければなりません。',
          '3、3、7 の場合、短い 2 辺の和は 3 + 3 = 6 で 7 より小さく、三角形を作れません。',
          'したがって 7、7、3 に決まり、7 + 3 = 10 は 7 より大きいので三角形は確かにできます。',
          'よって周の長さは 7 + 7 + 3 = 17 センチメートルです。',
        ],
      },
      value: '17', max_digits: 2, figure: figure_none,
      source: src('geometry-grade6-foundation',
        'Original composition in the Math Kangaroo grade 5-6 triangle-inequality style; one of the two isosceles cases must be eliminated before the perimeter can be computed. Not a reproduction of any past paper.'),
    ),
    int_q(
      topic: 'geometry', subtopic: 'border_counting',
      prompt: {
        'zh-Hant' => '用邊長 1 公尺的方磚鋪成一個長方形廣場。只沿著廣場最外面一圈鋪紅磚，一共用了 20 塊紅磚。已知這個長方形的長比寬多 2 公尺。整個廣場的面積是多少平方公尺？',
        'zh-Hans' => '用边长 1 米的方砖铺成一个长方形广场。只沿着广场最外面一圈铺红砖，一共用了 20 块红砖。已知这个长方形的长比宽多 2 米。整个广场的面积是多少平方米？',
        'en' => 'A rectangular square is paved with tiles of side 1 metre. Only the outermost ring of tiles is red, and exactly 20 red tiles are used. The length of the rectangle is 2 metres more than its width. What is the area of the whole square, in square metres?',
        'ja' => '1 辺 1 m の四角いタイルで長方形の広場をしきつめます。いちばん外側の 1 周だけを赤いタイルにしたところ、赤いタイルはちょうど 20 枚使いました。この長方形は縦より横が 2 m 長いことがわかっています。広場全体の面積は何平方メートルですか。',
      },
      answer: { 'zh-Hant' => '答案是 35 平方公尺。', 'zh-Hans' => '答案是 35 平方米。',
                'en' => 'The answer is 35 square metres.', 'ja' => '答えは 35 平方メートルです。' },
      steps: {
        'zh-Hant' => [
          '設長方形是長 m 塊、寬 n 塊。最外一圈的磚數是上下兩排各 m 塊、左右兩排各 n 塊，但四個角各被算了兩次。',
          '所以外圈磚數是 2 × m + 2 × n − 4，題目說它等於 20，於是 m + n = 12。',
          '又已知長比寬多 2，也就是 m = n + 2。',
          '把它代進去得到 (n + 2) + n = 12，所以 n = 5、m = 7。',
          '整個廣場的面積是 7 × 5 = 35 平方公尺。',
        ],
        'zh-Hans' => [
          '设长方形是长 m 块、宽 n 块。最外一圈的砖数是上下两排各 m 块、左右两排各 n 块，但四个角各被算了两次。',
          '所以外圈砖数是 2 × m + 2 × n − 4，题目说它等于 20，于是 m + n = 12。',
          '又已知长比宽多 2，也就是 m = n + 2。',
          '把它代进去得到 (n + 2) + n = 12，所以 n = 5、m = 7。',
          '整个广场的面积是 7 × 5 = 35 平方米。',
        ],
        'en' => [
          'Let the rectangle be m tiles long and n tiles wide. The outer ring has m tiles along the top and bottom and n along each side, but the four corners are counted twice.',
          'So the ring holds 2 × m + 2 × n − 4 tiles, which the problem says is 20, giving m + n = 12.',
          'The length exceeds the width by 2, that is m = n + 2.',
          'Substituting gives (n + 2) + n = 12, so n = 5 and m = 7.',
          'The area of the whole square is 7 × 5 = 35 square metres.',
        ],
        'ja' => [
          '長方形を横 m 枚、縦 n 枚とします。外側 1 周のタイルは上下に m 枚ずつ、左右に n 枚ずつですが、4 すみは 2 回ずつ数えられます。',
          'したがって 1 周のタイル数は 2 × m + 2 × n − 4 で、これが 20 なので m + n = 12 です。',
          'また横は縦より 2 長いので m = n + 2 です。',
          '代入すると (n + 2) + n = 12 となり、n = 5、m = 7 です。',
          '広場全体の面積は 7 × 5 = 35 平方メートルです。',
        ],
      },
      value: '35', max_digits: 2, figure: figure_none,
      source: src('geometry-grade6-foundation',
        'Original composition in the Math Kangaroo grade 5-6 border style; the ring count is given and the side lengths must be recovered, which reverses the usual direction of the corner-overlap formula. Not a reproduction of any past paper.'),
    ),
  ],
  'logic' => [
    int_q(
      topic: 'logic', subtopic: 'case_reasoning',
      prompt: {
        'zh-Hant' => '有一個兩位數，把它的十位數字和個位數字交換位置後，會得到一個新的兩位數。已知新的兩位數比原來的兩位數大 27。符合條件的兩位數一共有幾個？',
        'zh-Hans' => '有一个两位数，把它的十位数字和个位数字交换位置后，会得到一个新的两位数。已知新的两位数比原来的两位数大 27。符合条件的两位数一共有几个？',
        'en' => 'Swapping the tens digit and the units digit of a two-digit number produces a new two-digit number. The new number is 27 greater than the original. How many two-digit numbers satisfy this condition?',
        'ja' => 'ある 2 けたの数の十の位と一の位を入れかえると、新しい 2 けたの数ができます。新しい数はもとの数より 27 大きいことがわかっています。条件に合う 2 けたの数は全部で何個ありますか。',
      },
      answer: { 'zh-Hant' => '答案是 6 個。', 'zh-Hans' => '答案是 6 个。',
                'en' => 'The answer is 6 numbers.', 'ja' => '答えは 6 個です。' },
      steps: {
        'zh-Hant' => [
          '設原來的兩位數十位數字是 a、個位數字是 b，原數就是 10a + b，交換後是 10b + a。',
          '兩者相差 (10b + a) − (10a + b) = 9b − 9a = 9 × (b − a)。',
          '題目說這個差是 27，所以 9 × (b − a) = 27，得到 b − a = 3。',
          '十位數字 a 不能是 0，而且 b = a + 3 必須還是一個數字，所以 a 只能是 1 到 6。',
          '對應的兩位數是 14、25、36、47、58、69，一共 6 個。',
        ],
        'zh-Hans' => [
          '设原来的两位数十位数字是 a、个位数字是 b，原数就是 10a + b，交换后是 10b + a。',
          '两者相差 (10b + a) − (10a + b) = 9b − 9a = 9 × (b − a)。',
          '题目说这个差是 27，所以 9 × (b − a) = 27，得到 b − a = 3。',
          '十位数字 a 不能是 0，而且 b = a + 3 必须还是一个数字，所以 a 只能是 1 到 6。',
          '对应的两位数是 14、25、36、47、58、69，一共 6 个。',
        ],
        'en' => [
          'Let the tens digit be a and the units digit be b, so the number is 10a + b and the swapped number is 10b + a.',
          'Their difference is (10b + a) − (10a + b) = 9b − 9a = 9 × (b − a).',
          'The problem says this difference is 27, so 9 × (b − a) = 27 and therefore b − a = 3.',
          'The tens digit a cannot be 0, and b = a + 3 must still be a single digit, so a runs only from 1 to 6.',
          'The numbers are 14, 25, 36, 47, 58 and 69, that is 6 of them.',
        ],
        'ja' => [
          'もとの 2 けたの数の十の位を a、一の位を b とすると、もとの数は 10a + b、入れかえた数は 10b + a です。',
          '差は (10b + a) − (10a + b) = 9b − 9a = 9 × (b − a) となります。',
          'この差が 27 なので 9 × (b − a) = 27 より b − a = 3 です。',
          '十の位 a は 0 にできず、b = a + 3 も 1 けたでなければならないので、a は 1 から 6 までです。',
          'あてはまる数は 14、25、36、47、58、69 の 6 個です。',
        ],
      },
      value: '6', max_digits: 1, figure: figure_none,
      source: src('logic-grade6-foundation',
        'Original composition in the Math Kangaroo grade 5-6 place-value style; the difference collapses to a digit condition, and the count then depends on ruling out digits that fall outside range. Not a reproduction of any past paper.'),
    ),
    int_q(
      topic: 'logic', subtopic: 'one_true_one_false',
      prompt: {
        'zh-Hant' => '有一個兩位數，它是 36、42、55、63 其中之一。甲說了兩句話：「它是 3 的倍數」、「它大於 50」。乙也說了兩句話：「它是偶數」、「它小於 40」。已知甲說的兩句話中恰好有一句是真的，乙說的兩句話中也恰好有一句是真的。這個兩位數是多少？',
        'zh-Hans' => '有一个两位数，它是 36、42、55、63 其中之一。甲说了两句话：「它是 3 的倍数」、「它大于 50」。乙也说了两句话：「它是偶数」、「它小于 40」。已知甲说的两句话中恰好有一句是真的，乙说的两句话中也恰好有一句是真的。这个两位数是多少？',
        'en' => 'A two-digit number is one of 36, 42, 55 and 63. A makes two statements: "it is a multiple of 3" and "it is greater than 50". B also makes two statements: "it is even" and "it is less than 40". Exactly one of A\'s statements is true, and exactly one of B\'s statements is true. What is the number?',
        'ja' => 'ある 2 けたの数は 36、42、55、63 のいずれかです。甲は「それは 3 の倍数だ」「それは 50 より大きい」の 2 つを言いました。乙は「それは偶数だ」「それは 40 より小さい」の 2 つを言いました。甲の 2 つのうちちょうど 1 つが真、乙の 2 つのうちもちょうど 1 つが真です。この 2 けたの数はいくつですか。',
      },
      answer: { 'zh-Hant' => '答案是 42。', 'zh-Hans' => '答案是 42。', 'en' => 'The answer is 42.', 'ja' => '答えは 42 です。' },
      steps: {
        'zh-Hant' => [
          '把四個候選數一個一個檢查。36 是 3 的倍數（真）但不大於 50（假），甲恰好一真符合；可是 36 是偶數（真）又小於 40（真），乙兩句都真，不符合。',
          '55 不是 3 的倍數（假）但大於 50（真），甲符合；可是 55 不是偶數（假）也不小於 40（假），乙兩句都假，不符合。',
          '63 是 3 的倍數（真）又大於 50（真），甲兩句都真，一開始就不符合。',
          '42 是 3 的倍數（真）但不大於 50（假），甲恰好一真；42 是偶數（真）但不小於 40（假），乙也恰好一真。',
          '只有 42 同時滿足兩個人的條件，所以這個兩位數是 42。',
        ],
        'zh-Hans' => [
          '把四个候选数一个一个检查。36 是 3 的倍数（真）但不大于 50（假），甲恰好一真符合；可是 36 是偶数（真）又小于 40（真），乙两句都真，不符合。',
          '55 不是 3 的倍数（假）但大于 50（真），甲符合；可是 55 不是偶数（假）也不小于 40（假），乙两句都假，不符合。',
          '63 是 3 的倍数（真）又大于 50（真），甲两句都真，一开始就不符合。',
          '42 是 3 的倍数（真）但不大于 50（假），甲恰好一真；42 是偶数（真）但不小于 40（假），乙也恰好一真。',
          '只有 42 同时满足两个人的条件，所以这个两位数是 42。',
        ],
        'en' => [
          'Check the four candidates one by one. 36 is a multiple of 3 (true) but not greater than 50 (false), so A has exactly one true; however 36 is even (true) and less than 40 (true), so both of B\'s statements are true and 36 fails.',
          '55 is not a multiple of 3 (false) but is greater than 50 (true), so A is fine; but 55 is not even (false) and not less than 40 (false), so both of B\'s statements are false and 55 fails.',
          '63 is a multiple of 3 (true) and greater than 50 (true), so both of A\'s statements are true and 63 fails immediately.',
          '42 is a multiple of 3 (true) but not greater than 50 (false), so A has exactly one true; 42 is even (true) but not less than 40 (false), so B also has exactly one true.',
          'Only 42 meets both conditions, so the number is 42.',
        ],
        'ja' => [
          '4 つの候補を 1 つずつ調べます。36 は 3 の倍数（真）ですが 50 より大きくない（偽）ので甲はちょうど 1 つ真です。しかし 36 は偶数（真）かつ 40 より小さい（真）で、乙は 2 つとも真になり不適です。',
          '55 は 3 の倍数でない（偽）が 50 より大きい（真）なので甲は条件に合います。しかし 55 は偶数でなく（偽）40 より小さくもない（偽）ので、乙は 2 つとも偽で不適です。',
          '63 は 3 の倍数（真）かつ 50 より大きい（真）なので、甲が 2 つとも真になり最初から不適です。',
          '42 は 3 の倍数（真）ですが 50 より大きくない（偽）ので甲はちょうど 1 つ真、42 は偶数（真）ですが 40 より小さくない（偽）ので乙もちょうど 1 つ真です。',
          '両方の条件を満たすのは 42 だけなので、この数は 42 です。',
        ],
      },
      value: '42', max_digits: 2, figure: figure_none,
      source: src('logic-grade6-foundation',
        'Original composition in the Math Kangaroo grade 5-6 half-true style; two independent exactly-one-true constraints must both be applied, and each candidate fails for a different reason. Not a reproduction of any past paper.'),
    ),
    int_q(
      topic: 'logic', subtopic: 'arrangement',
      prompt: {
        'zh-Hant' => '用 1、2、3、4、5 這五個數字各一次，排成一個沒有重複數字的五位數。如果要求數字 1 和數字 2 一定要排在相鄰的位置，這樣的五位數一共有幾個？',
        'zh-Hans' => '用 1、2、3、4、5 这五个数字各一次，排成一个没有重复数字的五位数。如果要求数字 1 和数字 2 一定要排在相邻的位置，这样的五位数一共有几个？',
        'en' => 'The digits 1, 2, 3, 4 and 5 are each used once to form a five-digit number with no repeated digits. If the digits 1 and 2 must stand next to each other, how many such five-digit numbers are there?',
        'ja' => '1、2、3、4、5 の 5 つの数字を 1 回ずつ使って、数字の重ならない 5 けたの数を作ります。数字の 1 と 2 がとなり合っていなければならないとき、そのような 5 けたの数は全部で何個ありますか。',
      },
      answer: { 'zh-Hant' => '答案是 48 個。', 'zh-Hans' => '答案是 48 个。',
                'en' => 'The answer is 48 numbers.', 'ja' => '答えは 48 個です。' },
      steps: {
        'zh-Hant' => [
          '因為 1 和 2 一定相鄰，可以把它們綁在一起，當成一個整體來排。',
          '這樣要排的就變成「12 這一組」、3、4、5 共 4 個東西，排法有 4 × 3 × 2 × 1 = 24 種。',
          '但綁在一起的那一組內部還有順序，可以是 1 在前也可以是 2 在前，有 2 種。',
          '所以總數是 24 × 2 = 48 個。',
          '因為 1 到 5 都不是 0，任何排法開頭都合法，不需要再扣掉任何情況，答案就是 48 個。',
        ],
        'zh-Hans' => [
          '因为 1 和 2 一定相邻，可以把它们绑在一起，当成一个整体来排。',
          '这样要排的就变成「12 这一组」、3、4、5 共 4 个东西，排法有 4 × 3 × 2 × 1 = 24 种。',
          '但绑在一起的那一组内部还有顺序，可以是 1 在前也可以是 2 在前，有 2 种。',
          '所以总数是 24 × 2 = 48 个。',
          '因为 1 到 5 都不是 0，任何排法开头都合法，不需要再扣掉任何情况，答案就是 48 个。',
        ],
        'en' => [
          'Since 1 and 2 must be adjacent, tie them together and treat the pair as a single block.',
          'Then four things are being arranged: the block, 3, 4 and 5, which can be ordered in 4 × 3 × 2 × 1 = 24 ways.',
          'Inside the block there is still an order, either 1 before 2 or 2 before 1, giving 2 possibilities.',
          'So the total is 24 × 2 = 48.',
          'None of the digits 1 to 5 is 0, so every arrangement is a valid five-digit number and nothing has to be subtracted. The answer is 48.',
        ],
        'ja' => [
          '1 と 2 は必ずとなり合うので、2 つをひとまとめのかたまりとして扱います。',
          'すると並べるものは「1 と 2 のかたまり」、3、4、5 の 4 つになり、並べ方は 4 × 3 × 2 × 1 = 24 通りです。',
          'かたまりの中にも順序があり、1 が先か 2 が先かの 2 通りがあります。',
          'したがって合計は 24 × 2 = 48 個です。',
          '1 から 5 に 0 はないので、どの並べ方も 5 けたの数として正しく、引くべき場合はありません。答えは 48 個です。',
        ],
      },
      value: '48', max_digits: 2, figure: figure_none,
      source: src('logic-grade6-foundation',
        'Original composition in the Math Kangaroo grade 5-6 arrangement style; the block method for a required adjacency is a different technique from counting the complement of a forbidden adjacency. Not a reproduction of any past paper.'),
    ),
  ],
  'arithmetic' => [
    int_q(
      topic: 'arithmetic', subtopic: 'sequence_sum',
      prompt: {
        'zh-Hant' => '把 1 到 99 之間所有的奇數，也就是 1、3、5、……、99，全部加起來。這個總和是多少？',
        'zh-Hans' => '把 1 到 99 之间所有的奇数，也就是 1、3、5、……、99，全部加起来。这个总和是多少？',
        'en' => 'All the odd numbers from 1 to 99, that is 1, 3, 5, ..., 99, are added together. What is the total?',
        'ja' => '1 から 99 までのすべての奇数、つまり 1、3、5、……、99 をすべてたします。その合計はいくつですか。',
      },
      answer: { 'zh-Hant' => '答案是 2500。', 'zh-Hans' => '答案是 2500。',
                'en' => 'The answer is 2500.', 'ja' => '答えは 2500 です。' },
      steps: {
        'zh-Hant' => [
          '從 1 到 99 的奇數是 1、3、5、……、99，每次多 2，一共有 (99 − 1) ÷ 2 + 1 = 50 個。',
          '把頭尾兩兩配對：1 和 99、3 和 97、5 和 95……，每一對的和都是 100。',
          '50 個數剛好可以配成 50 ÷ 2 = 25 對。',
          '所以總和是 100 × 25 = 2500。',
        ],
        'zh-Hans' => [
          '从 1 到 99 的奇数是 1、3、5、……、99，每次多 2，一共有 (99 − 1) ÷ 2 + 1 = 50 个。',
          '把头尾两两配对：1 和 99、3 和 97、5 和 95……，每一对的和都是 100。',
          '50 个数刚好可以配成 50 ÷ 2 = 25 对。',
          '所以总和是 100 × 25 = 2500。',
        ],
        'en' => [
          'The odd numbers from 1 to 99 are 1, 3, 5, ..., 99, rising by 2 each time, and there are (99 − 1) ÷ 2 + 1 = 50 of them.',
          'Pair them from the outside in: 1 with 99, 3 with 97, 5 with 95, and so on, each pair adding to 100.',
          'The 50 numbers form exactly 50 ÷ 2 = 25 such pairs.',
          'So the total is 100 × 25 = 2500.',
        ],
        'ja' => [
          '1 から 99 までの奇数は 1、3、5、……、99 で、2 ずつ増え、個数は (99 − 1) ÷ 2 + 1 = 50 個です。',
          '両はしから組にすると、1 と 99、3 と 97、5 と 95……となり、どの組も和は 100 です。',
          '50 個はちょうど 50 ÷ 2 = 25 組にできます。',
          'したがって合計は 100 × 25 = 2500 です。',
        ],
      },
      value: '2500', max_digits: 4, figure: figure_none,
      source: src('arithmetic-grade6-foundation',
        'Original composition in the Math Kangaroo grade 5-6 series style; the pairing trick and a correct term count are both needed. Not a reproduction of any past paper.'),
    ),
    int_q(
      topic: 'arithmetic', subtopic: 'maximization',
      prompt: {
        'zh-Hant' => '用 1、2、3、4、5 這五個數字各一次，排成一個三位數和一個兩位數，再把這兩個數相乘。這個乘積最大可以是多少？',
        'zh-Hans' => '用 1、2、3、4、5 这五个数字各一次，排成一个三位数和一个两位数，再把这两个数相乘。这个乘积最大可以是多少？',
        'en' => 'The digits 1, 2, 3, 4 and 5 are each used once to form a three-digit number and a two-digit number, which are then multiplied. What is the largest possible product?',
        'ja' => '1、2、3、4、5 の 5 つの数字を 1 回ずつ使って 3 けたの数と 2 けたの数を作り、その 2 つをかけます。積は最も大きくていくつになりますか。',
      },
      answer: { 'zh-Hant' => '答案是 22412。', 'zh-Hans' => '答案是 22412。',
                'en' => 'The answer is 22412.', 'ja' => '答えは 22412 です。' },
      steps: {
        'zh-Hant' => [
          '乘積要大，最重要的是把大的數字放在影響最大的位置，也就是三位數的百位和兩位數的十位。',
          '所以百位和十位應該放 5 和 4，剩下的 1、2、3 分配到其他位置。',
          '把 5 放在兩位數的十位、4 放在三位數的百位時，剩下 1、2、3 的最好安排是 431 × 52 = 22412。',
          '反過來把 5 放在三位數的百位時，最好的情形是 531 × 42 = 22302，比 22412 小。',
          '再檢查其他分配方式都不會更大，所以最大的乘積是 22412。',
        ],
        'zh-Hans' => [
          '乘积要大，最重要的是把大的数字放在影响最大的位置，也就是三位数的百位和两位数的十位。',
          '所以百位和十位应该放 5 和 4，剩下的 1、2、3 分配到其他位置。',
          '把 5 放在两位数的十位、4 放在三位数的百位时，剩下 1、2、3 的最好安排是 431 × 52 = 22412。',
          '反过来把 5 放在三位数的百位时，最好的情形是 531 × 42 = 22302，比 22412 小。',
          '再检查其他分配方式都不会更大，所以最大的乘积是 22412。',
        ],
        'en' => [
          'To make the product large, the biggest digits should sit where they carry most weight: the hundreds place of the three-digit number and the tens place of the two-digit number.',
          'So 5 and 4 belong in those two places, and 1, 2, 3 fill the rest.',
          'Putting 5 in the tens place of the two-digit number and 4 in the hundreds place gives the best arrangement 431 × 52 = 22412.',
          'Putting 5 in the hundreds place instead gives at best 531 × 42 = 22302, which is smaller.',
          'Checking the remaining allocations gives nothing larger, so the greatest product is 22412.',
        ],
        'ja' => [
          '積を大きくするには、大きい数字を効きめの大きい位、つまり 3 けたの数の百の位と 2 けたの数の十の位に置くことが大切です。',
          'したがって 5 と 4 をその 2 か所に置き、残りの 1、2、3 をほかの位に入れます。',
          '5 を 2 けたの数の十の位、4 を 3 けたの数の百の位に置くと、残りの最適な並べ方は 431 × 52 = 22412 です。',
          '逆に 5 を 3 けたの数の百の位に置くと、最良でも 531 × 42 = 22302 で 22412 より小さくなります。',
          'ほかの入れ方を調べてもこれより大きくならないので、最大の積は 22412 です。',
        ],
      },
      value: '22412', max_digits: 5, figure: figure_none,
      source: src('arithmetic-grade6-foundation',
        'Original composition in the Math Kangaroo grade 5-6 optimisation style; place-value weighting narrows the search and the two leading candidates must then be compared directly. The maximum was confirmed by exhausting all 120 digit arrangements. Not a reproduction of any past paper.'),
    ),
    int_q(
      topic: 'arithmetic', subtopic: 'pair_counting',
      prompt: {
        'zh-Hant' => '從 1 到 20 這 20 個整數中，任意選出兩個不同的數。如果要求選出的兩個數相加後剛好是 3 的倍數，這樣的選法一共有幾種？',
        'zh-Hans' => '从 1 到 20 这 20 个整数中，任意选出两个不同的数。如果要求选出的两个数相加后刚好是 3 的倍数，这样的选法一共有几种？',
        'en' => 'Two different numbers are chosen from the 20 integers 1 to 20. If their sum must be a multiple of 3, how many such choices are there?',
        'ja' => '1 から 20 までの 20 個の整数から、異なる 2 つを選びます。選んだ 2 数の和がちょうど 3 の倍数になるような選び方は全部で何通りありますか。',
      },
      answer: { 'zh-Hant' => '答案是 64 種。', 'zh-Hans' => '答案是 64 种。',
                'en' => 'The answer is 64 choices.', 'ja' => '答えは 64 通りです。' },
      steps: {
        'zh-Hant' => [
          '把 1 到 20 依「除以 3 的餘數」分成三組：餘 0 的有 3、6、……、18 共 6 個；餘 1 的有 1、4、……、19 共 7 個；餘 2 的有 2、5、……、20 共 7 個。',
          '兩個數的和要是 3 的倍數，只有兩種情形：兩個數都是餘 0，或者一個餘 1、一個餘 2。',
          '兩個都取餘 0 的取法有 (6 × 5) ÷ 2 = 15 種。',
          '一個餘 1、一個餘 2 的取法有 7 × 7 = 49 種。',
          '所以總共有 15 + 49 = 64 種選法。',
        ],
        'zh-Hans' => [
          '把 1 到 20 依「除以 3 的余数」分成三组：余 0 的有 3、6、……、18 共 6 个；余 1 的有 1、4、……、19 共 7 个；余 2 的有 2、5、……、20 共 7 个。',
          '两个数的和要是 3 的倍数，只有两种情形：两个数都是余 0，或者一个余 1、一个余 2。',
          '两个都取余 0 的取法有 (6 × 5) ÷ 2 = 15 种。',
          '一个余 1、一个余 2 的取法有 7 × 7 = 49 种。',
          '所以总共有 15 + 49 = 64 种选法。',
        ],
        'en' => [
          'Sort 1 to 20 by remainder on division by 3: remainder 0 gives 3, 6, ..., 18, which is 6 numbers; remainder 1 gives 1, 4, ..., 19, which is 7; remainder 2 gives 2, 5, ..., 20, which is 7.',
          'A sum is a multiple of 3 only in two cases: both numbers have remainder 0, or one has remainder 1 and the other remainder 2.',
          'Choosing two from the remainder-0 group can be done in (6 × 5) ÷ 2 = 15 ways.',
          'Choosing one from each of the other two groups can be done in 7 × 7 = 49 ways.',
          'So there are 15 + 49 = 64 choices in all.',
        ],
        'ja' => [
          '1 から 20 を 3 でわったあまりで分けます。あまり 0 は 3、6、……、18 の 6 個、あまり 1 は 1、4、……、19 の 7 個、あまり 2 は 2、5、……、20 の 7 個です。',
          '和が 3 の倍数になるのは、2 数ともあまり 0 の場合か、一方があまり 1 でもう一方があまり 2 の場合だけです。',
          'あまり 0 から 2 つ選ぶ方法は (6 × 5) ÷ 2 = 15 通りです。',
          'あまり 1 とあまり 2 から 1 つずつ選ぶ方法は 7 × 7 = 49 通りです。',
          'したがって全部で 15 + 49 = 64 通りです。',
        ],
      },
      value: '64', max_digits: 2, figure: figure_none,
      source: src('arithmetic-grade6-foundation',
        'Original composition in the Math Kangaroo grade 5-6 counting style; classifying by residue turns the condition into two disjoint cases, which is the intended structural move. Not a reproduction of any past paper.'),
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
