#!/usr/bin/env ruby
# frozen_string_literal: true

# grade7 補題（2026-08-27）
# grade7-12 的 subtopic 已鋪滿標準大綱（900 題 / 896 型），因此本批採「同 subtopic 第二題」：
# 每題都在既有題型上換一個明確不同的推理轉折（多半是反方向或換工具），而非換數字。
#   algebra       : surplus_deficit(條件需先轉譯) / vehicle_wheel_system(給差不給和)
#   combinatorics : pigeonhole_min_draw(指定顏色的最壞情況) / paths_grid(可斜走→遞推)
#   geometry      : triangle_inequality_range(由範圍改為窮舉計數) / clock_hand_angle(單一時刻→整日次數)
#   logic         : sawing_cuts(一維→二維最省刀數) / snail_well_boundary(正推天數→逆推井深)
#   number_theory : remainder_cycle(算餘數→求最小指數) / trailing_zeros_product(數零→補乘數)

require 'json'
require 'set'

ROOT = File.expand_path('..', __dir__)
GRADE = 'grade7'
PATHS = {
  'algebra' => File.join(ROOT, "assets/questions/algebra/#{GRADE}_foundation.algebra.v1.json"),
  'combinatorics' => File.join(ROOT, "assets/questions/combinatorics/#{GRADE}_foundation.combinatorics.v1.json"),
  'geometry' => File.join(ROOT, "assets/questions/geometry/#{GRADE}_foundation.geometry.v1.json"),
  'logic' => File.join(ROOT, "assets/questions/logic/#{GRADE}_foundation.logic.v1.json"),
  'number_theory' => File.join(ROOT, "assets/questions/number_theory/#{GRADE}_foundation.number_theory.v1.json"),
}.freeze
MANIFEST_PATH = File.join(ROOT, 'assets/questions/manifest.json')

TOPIC_ZH = { 'algebra' => '代數', 'combinatorics' => '組合', 'geometry' => '幾何',
             'logic' => '邏輯', 'number_theory' => '數論' }.freeze

def load_json(path) = JSON.parse(File.read(path))
def save_json(path, data) = File.write(path, JSON.pretty_generate(data) + "\n")

def taxonomy(topic, subtopic_code, subtopic_zh)
  { 'topic' => TOPIC_ZH[topic], 'topicCode' => topic,
    'subtopic' => subtopic_zh, 'subtopicCode' => subtopic_code }
end

def src(reference, notes, display)
  { 'type' => 'rewritten_olympiad_style', 'name' => 'MathSpring 改寫題',
    'reference' => reference, 'notes' => notes, 'displayText' => display }
end

def figure_none = { 'type' => 'custom', 'kind' => 'none', 'params' => {} }

def int_q(topic:, subtopic:, subtopic_zh:, prompt:, answer:, steps:, value:, max_digits:, source:)
  { 'topic' => topic, 'subtopic' => subtopic, 'difficulty' => 'foundation',
    'levelStage' => GRADE, 'challengeTier' => 'foundation',
    'prompt' => prompt, 'answer' => answer, 'solutionSteps' => steps,
    'figure' => figure_none, 'answerMode' => 'integer_input',
    'correctAnswer' => { 'type' => 'integer', 'value' => value },
    'inputConstraints' => { 'allowNegative' => false, 'maxDigits' => max_digits },
    'source' => source,
    'olympiadTaxonomy' => taxonomy(topic, subtopic, subtopic_zh),
    'reviewStatus' => 'ok' }
end

QUESTIONS = {
  'algebra' => [
    int_q(
      topic: 'algebra', subtopic: 'surplus_deficit', subtopic_zh: '盈虧問題',
      prompt: {
        'zh-Hant' => '把一批故事書分給班上的同學。若每人分 4 本，剩下的書剛好還能再分給另外 3 個人、每人也是 4 本；若每人分 6 本，就會不夠 10 本。求這批故事書一共有多少本。',
        'zh-Hans' => '把一批故事书分给班上的同学。若每人分 4 本，剩下的书刚好还能再分给另外 3 个人、每人也是 4 本；若每人分 6 本，就会不够 10 本。求这批故事书一共有多少本。',
        'en' => 'A batch of storybooks is shared among the students in a class. If each student gets 4 books, the books left over are exactly enough to give 4 books each to 3 further people; if each student gets 6 books, the batch falls short by 10 books. How many storybooks are there altogether?',
        'ja' => 'ある冊数の物語の本をクラスの生徒に分けます。1 人 4 冊ずつ配ると、余った本はちょうどほかの 3 人にも 4 冊ずつ配れるだけあります。1 人 6 冊ずつ配ると 10 冊足りません。物語の本は全部で何冊ありますか。',
      },
      answer: { 'zh-Hant' => '答案是 56 本。', 'zh-Hans' => '答案是 56 本。',
                'en' => 'The answer is 56 books.', 'ja' => '答えは 56 冊です。' },
      steps: {
        'zh-Hant' => [
          '第一個條件沒有直接說剩幾本，要先轉譯：剩下的書夠再分給 3 個人、每人 4 本，所以剩下 4 × 3 = 12 本。',
          '設班上有 n 位同學。由第一個條件，書的總數是 4n + 12。',
          '由第二個條件，每人 6 本會少 10 本，所以書的總數也是 6n − 10。',
          '兩式相等：4n + 12 = 6n − 10，解得 2n = 22，n = 11。',
          '把 n = 11 代回去，書的總數是 4 × 11 + 12 = 56 本。',
        ],
        'zh-Hans' => [
          '第一个条件没有直接说剩几本，要先转译：剩下的书够再分给 3 个人、每人 4 本，所以剩下 4 × 3 = 12 本。',
          '设班上有 n 位同学。由第一个条件，书的总数是 4n + 12。',
          '由第二个条件，每人 6 本会少 10 本，所以书的总数也是 6n − 10。',
          '两式相等：4n + 12 = 6n − 10，解得 2n = 22，n = 11。',
          '把 n = 11 代回去，书的总数是 4 × 11 + 12 = 56 本。',
        ],
        'en' => [
          'The first condition does not state the leftover directly and has to be translated: the leftover is enough for 3 more people at 4 books each, so it is 4 × 3 = 12 books.',
          'Let the class have n students. The first condition makes the total 4n + 12.',
          'The second condition says 6 books each falls short by 10, so the total is also 6n − 10.',
          'Equating gives 4n + 12 = 6n − 10, so 2n = 22 and n = 11.',
          'Substituting back, the total is 4 × 11 + 12 = 56 books.',
        ],
        'ja' => [
          '1 つ目の条件は余りの冊数を直接述べていないので、まず言いかえます。余りはほかの 3 人に 4 冊ずつ配れる量なので 4 × 3 = 12 冊です。',
          'クラスの生徒を n 人とすると、1 つ目の条件から本の総数は 4n + 12 です。',
          '2 つ目の条件から、1 人 6 冊では 10 冊足りないので、総数は 6n − 10 とも表せます。',
          '等しいとおくと 4n + 12 = 6n − 10 となり、2n = 22、n = 11 です。',
          'n = 11 をもどすと、本の総数は 4 × 11 + 12 = 56 冊です。',
        ],
      },
      value: '56', max_digits: 2,
      source: src('盈虧問題（條件需先轉譯的變化型）',
                  '設計依據：既有盈虧題直接給出「剩下幾本／不夠幾本」，本題把其中一個條件改成「剩下的還夠再分給 3 個人」，必須先換算成剩 12 本才能列式；屬同水準原創改寫，非抄錄特定官方題。',
                  '改寫題（盈虧・條件轉譯）'),
    ),
    int_q(
      topic: 'algebra', subtopic: 'vehicle_wheel_system', subtopic_zh: '輪子數聯立',
      prompt: {
        'zh-Hant' => '停車場裡有汽車和機車共 24 輛（汽車 4 個輪子，機車 2 個輪子）。已知所有汽車的輪子總數，比所有機車的輪子總數多 36 個。求停車場裡有幾輛汽車。',
        'zh-Hans' => '停车场里有汽车和摩托车共 24 辆（汽车 4 个轮子，摩托车 2 个轮子）。已知所有汽车的轮子总数，比所有摩托车的轮子总数多 36 个。求停车场里有几辆汽车。',
        'en' => 'A car park holds 24 vehicles in total, cars and motorcycles (a car has 4 wheels, a motorcycle has 2). The wheels on all the cars together outnumber the wheels on all the motorcycles together by 36. How many cars are in the car park?',
        'ja' => '駐車場に自動車とオートバイが合わせて 24 台あります（自動車は車輪 4 個、オートバイは 2 個）。自動車すべての車輪の合計は、オートバイすべての車輪の合計より 36 個多いことがわかっています。自動車は何台ありますか。',
      },
      answer: { 'zh-Hant' => '答案是 14 輛。', 'zh-Hans' => '答案是 14 辆。',
                'en' => 'The answer is 14 cars.', 'ja' => '答えは 14 台です。' },
      steps: {
        'zh-Hant' => [
          '設汽車有 x 輛，那麼機車就有 24 − x 輛。',
          '汽車的輪子總數是 4x，機車的輪子總數是 2 × (24 − x)。',
          '題目給的不是兩者的和，而是兩者的差，所以列式為 4x − 2 × (24 − x) = 36。',
          '化簡得 4x − 48 + 2x = 36，也就是 6x = 84，解得 x = 14。',
          '檢查：14 輛汽車有 56 個輪子，10 輛機車有 20 個輪子，56 − 20 = 36，符合，所以汽車有 14 輛。',
        ],
        'zh-Hans' => [
          '设汽车有 x 辆，那么摩托车就有 24 − x 辆。',
          '汽车的轮子总数是 4x，摩托车的轮子总数是 2 × (24 − x)。',
          '题目给的不是两者的和，而是两者的差，所以列式为 4x − 2 × (24 − x) = 36。',
          '化简得 4x − 48 + 2x = 36，也就是 6x = 84，解得 x = 14。',
          '检查：14 辆汽车有 56 个轮子，10 辆摩托车有 20 个轮子，56 − 20 = 36，符合，所以汽车有 14 辆。',
        ],
        'en' => [
          'Let there be x cars, so there are 24 − x motorcycles.',
          'The cars carry 4x wheels and the motorcycles carry 2 × (24 − x) wheels.',
          'What is given is not the sum of the two but their difference, so the equation is 4x − 2 × (24 − x) = 36.',
          'Expanding gives 4x − 48 + 2x = 36, that is 6x = 84, so x = 14.',
          'Check: 14 cars have 56 wheels and 10 motorcycles have 20 wheels, and 56 − 20 = 36, which fits. There are 14 cars.',
        ],
        'ja' => [
          '自動車を x 台とすると、オートバイは 24 − x 台です。',
          '自動車の車輪は 4x 個、オートバイの車輪は 2 × (24 − x) 個です。',
          '与えられているのは 2 つの和ではなく差なので、式は 4x − 2 × (24 − x) = 36 となります。',
          '整理すると 4x − 48 + 2x = 36、つまり 6x = 84 となり、x = 14 です。',
          '確認すると、自動車 14 台で 56 個、オートバイ 10 台で 20 個、56 − 20 = 36 で条件に合うので、自動車は 14 台です。',
        ],
      },
      value: '14', max_digits: 2,
      source: src('輪子數聯立（以差為條件的變化型）',
                  '設計依據：既有題給的是輪子總數並問對調後的結果，本題改為只給兩類輪子數之差，必須重新建立方程而非沿用總和式；屬同水準原創改寫，非抄錄特定官方題。',
                  '改寫題（輪子數・給差）'),
    ),
  ],
  'combinatorics' => [
    int_q(
      topic: 'combinatorics', subtopic: 'pigeonhole_min_draw', subtopic_zh: '鴿籠原理',
      prompt: {
        'zh-Hant' => '一個不透明的袋子裡有紅球 3 顆、藍球 5 顆、黃球 7 顆，除了顏色以外完全相同。閉著眼睛從袋中取球，最少要取出幾顆，才能保證其中一定有 2 顆是黃球？',
        'zh-Hans' => '一个不透明的袋子里有红球 3 颗、蓝球 5 颗、黄球 7 颗，除了颜色以外完全相同。闭着眼睛从袋中取球，最少要取出几颗，才能保证其中一定有 2 颗是黄球？',
        'en' => 'An opaque bag holds 3 red balls, 5 blue balls and 7 yellow balls, identical apart from colour. Balls are drawn with the eyes closed. At least how many must be drawn to be sure of having 2 yellow balls among them?',
        'ja' => '中の見えない袋に、色以外は同じ赤玉 3 個、青玉 5 個、黄玉 7 個が入っています。目をつぶって玉を取り出すとき、黄玉が必ず 2 個ふくまれるようにするには、少なくとも何個取り出せばよいですか。',
      },
      answer: { 'zh-Hant' => '答案是 10 顆。', 'zh-Hans' => '答案是 10 颗。',
                'en' => 'The answer is 10 balls.', 'ja' => '答えは 10 個です。' },
      steps: {
        'zh-Hant' => [
          '要「保證」，就要看最壞的情況：運氣最差時，黃球會最晚被取到。',
          '最壞的情況是先把所有非黃色的球都取光，也就是紅球 3 顆和藍球 5 顆，共 8 顆。',
          '這時再取 1 顆一定是黃球，但只有 1 顆黃球還不夠，總共已取 9 顆。',
          '再取 1 顆仍然只能是黃球，這時就有 2 顆黃球了。',
          '所以最少要取出 8 + 2 = 10 顆。',
        ],
        'zh-Hans' => [
          '要「保证」，就要看最坏的情况：运气最差时，黄球会最晚被取到。',
          '最坏的情况是先把所有非黄色的球都取光，也就是红球 3 颗和蓝球 5 颗，共 8 颗。',
          '这时再取 1 颗一定是黄球，但只有 1 颗黄球还不够，总共已取 9 颗。',
          '再取 1 颗仍然只能是黄球，这时就有 2 颗黄球了。',
          '所以最少要取出 8 + 2 = 10 颗。',
        ],
        'en' => [
          'To be sure, look at the worst case: with the worst luck the yellow balls come out last.',
          'The worst case is drawing every non-yellow ball first, that is 3 red and 5 blue, which is 8 balls.',
          'The next draw must then be yellow, but one yellow is not enough, and 9 balls have been drawn.',
          'One more draw can again only be yellow, giving 2 yellow balls.',
          'So at least 8 + 2 = 10 balls must be drawn.',
        ],
        'ja' => [
          '「必ず」といえるようにするには最悪の場合を考えます。運が最も悪いと、黄玉は最後まで出てきません。',
          '最悪の場合は黄色以外をすべて取り切るときで、赤 3 個と青 5 個の合計 8 個です。',
          'このあと 1 個取れば必ず黄玉ですが、黄玉 1 個ではまだ足りず、ここまでで 9 個です。',
          'さらに 1 個取ってもやはり黄玉なので、これで黄玉が 2 個になります。',
          'したがって少なくとも 8 + 2 = 10 個取り出す必要があります。',
        ],
      },
      value: '10', max_digits: 2,
      source: src('鴿籠原理（指定顏色的最壞情況）',
                  '設計依據：既有題各色數量相同、目標是「任意 3 顆同色」，本題各色數量不同且指定必須是黃球，最壞情況要先取光其他顏色，構造方式完全不同；屬同水準原創改寫，非抄錄特定官方題。',
                  '改寫題（鴿籠・指定顏色）'),
    ),
    int_q(
      topic: 'combinatorics', subtopic: 'paths_grid', subtopic_zh: '格點路徑',
      prompt: {
        'zh-Hant' => '在方格圖上，棋子要從 2×2 方格的左下角走到右上角。每一步可以向右走一格、向上走一格，或是沿著小方格的對角線向右上斜走一格。這樣的走法一共有多少種？',
        'zh-Hans' => '在方格图上，棋子要从 2×2 方格的左下角走到右上角。每一步可以向右走一格、向上走一格，或是沿着小方格的对角线向右上斜走一格。这样的走法一共有多少种？',
        'en' => 'On a 2×2 grid a piece moves from the bottom-left corner to the top-right corner. Each step may go one square to the right, one square up, or diagonally one square up and to the right along a cell diagonal. How many such routes are there altogether?',
        'ja' => '方眼の上で、こまが 2×2 のマスの左下から右上まで進みます。1 歩ごとに右へ 1 マス、上へ 1 マス、またはマスの対角線にそって右上へななめに 1 マス進むことができます。このような進み方は全部で何通りありますか。',
      },
      answer: { 'zh-Hant' => '答案是 13 種。', 'zh-Hans' => '答案是 13 种。',
                'en' => 'The answer is 13 routes.', 'ja' => '答えは 13 通りです。' },
      steps: {
        'zh-Hant' => [
          '因為多了斜走這一種走法，步數不再固定，不能直接用選位置的公式，改用逐點累加。',
          '把左下角記為 (0, 0)、右上角記為 (2, 2)，並在每個格點寫上「從起點走到該點的走法數」。',
          '起點寫 1。最下面一列和最左邊一行的每個點都只有一種走法，所以都寫 1。',
          '其餘每個點的走法數，等於它左邊、下面、左下這三個點的走法數相加。於是 (1, 1) 是 1 + 1 + 1 = 3。',
          '接著 (2, 1) 和 (1, 2) 都是 1 + 3 + 1 = 5，最後 (2, 2) 是 5 + 5 + 3 = 13，所以共有 13 種走法。',
        ],
        'zh-Hans' => [
          '因为多了斜走这一种走法，步数不再固定，不能直接用选位置的公式，改用逐点累加。',
          '把左下角记为 (0, 0)、右上角记为 (2, 2)，并在每个格点写上「从起点走到该点的走法数」。',
          '起点写 1。最下面一行和最左边一列的每个点都只有一种走法，所以都写 1。',
          '其余每个点的走法数，等于它左边、下面、左下这三个点的走法数相加。于是 (1, 1) 是 1 + 1 + 1 = 3。',
          '接着 (2, 1) 和 (1, 2) 都是 1 + 3 + 1 = 5，最后 (2, 2) 是 5 + 5 + 3 = 13，所以共有 13 种走法。',
        ],
        'en' => [
          'Because a diagonal step is allowed, the number of steps is no longer fixed, so the choose-positions formula does not apply and the count is built up point by point.',
          'Label the bottom-left corner (0, 0) and the top-right corner (2, 2), and write at each lattice point the number of routes from the start to that point.',
          'The start gets 1. Every point on the bottom row and on the left column can be reached in only one way, so each gets 1.',
          'Every other point gets the sum of the values at the points to its left, below it, and diagonally below-left. So (1, 1) gets 1 + 1 + 1 = 3.',
          'Then (2, 1) and (1, 2) each get 1 + 3 + 1 = 5, and finally (2, 2) gets 5 + 5 + 3 = 13, so there are 13 routes.',
        ],
        'ja' => [
          'ななめの進み方が加わったため歩数が一定でなくなり、位置を選ぶ公式は使えないので、点ごとに足し上げて数えます。',
          '左下を (0, 0)、右上を (2, 2) とし、各格子点に「出発点からそこまでの進み方の数」を書きこみます。',
          '出発点は 1 です。いちばん下の行といちばん左の列の点は 1 通りずつなので、すべて 1 です。',
          'ほかの点の値は、左・下・左下の 3 点の値の和になります。よって (1, 1) は 1 + 1 + 1 = 3 です。',
          '続いて (2, 1) と (1, 2) はどちらも 1 + 3 + 1 = 5、最後に (2, 2) は 5 + 5 + 3 = 13 なので、13 通りです。',
        ],
      },
      value: '13', max_digits: 2,
      source: src('格點路徑（加入斜走的遞推型）',
                  '設計依據：既有題只能向右或向上、可用組合公式直接算，本題多一種斜走使步數不固定，必須改用逐點遞推；工具與骨架都不同；屬同水準原創改寫，非抄錄特定官方題。',
                  '改寫題（格點路徑・可斜走）'),
    ),
  ],
  'geometry' => [
    int_q(
      topic: 'geometry', subtopic: 'triangle_inequality_range', subtopic_zh: '第三邊的範圍',
      prompt: {
        'zh-Hant' => '一個三角形的三邊長都是整數公分，而且周長是 12 公分。這樣的三角形一共有幾種？（三邊長度相同、只是擺放方向不同的視為同一種。）',
        'zh-Hans' => '一个三角形的三边长都是整数厘米，而且周长是 12 厘米。这样的三角形一共有几种？（三边长度相同、只是摆放方向不同的视为同一种。）',
        'en' => 'A triangle has all three side lengths in whole centimetres and a perimeter of 12 cm. How many such triangles are there? (Triangles with the same three side lengths count as one, however they are placed.)',
        'ja' => 'ある三角形の 3 辺の長さはすべて整数センチメートルで、周の長さは 12 cm です。このような三角形は全部で何種類ありますか。（3 辺の長さが同じものは、置き方がちがっても 1 種類と数えます。）',
      },
      answer: { 'zh-Hant' => '答案是 3 種。', 'zh-Hans' => '答案是 3 种。',
                'en' => 'The answer is 3 triangles.', 'ja' => '答えは 3 種類です。' },
      steps: {
        'zh-Hant' => [
          '設三邊長是 a、b、c，並規定 a ≤ b ≤ c，這樣同一組邊長就只會被數到一次。',
          '三角形要能圍成，必須滿足 a + b > c；又因為 a + b + c = 12，可得 12 − c > c，也就是 c < 6。',
          '另一方面 c 是三邊中最大的，所以 c 至少要是 12 ÷ 3 = 4。因此 c 只能是 4 或 5。',
          'c = 4 時，a + b = 8 且 a ≤ b ≤ 4，只有 (4, 4, 4)；c = 5 時，a + b = 7 且 a ≤ b ≤ 5，有 (2, 5, 5) 和 (3, 4, 5)。',
          '合起來是 (4, 4, 4)、(2, 5, 5)、(3, 4, 5)，所以這樣的三角形一共有 3 種。',
        ],
        'zh-Hans' => [
          '设三边长是 a、b、c，并规定 a ≤ b ≤ c，这样同一组边长就只会被数到一次。',
          '三角形要能围成，必须满足 a + b > c；又因为 a + b + c = 12，可得 12 − c > c，也就是 c < 6。',
          '另一方面 c 是三边中最大的，所以 c 至少要是 12 ÷ 3 = 4。因此 c 只能是 4 或 5。',
          'c = 4 时，a + b = 8 且 a ≤ b ≤ 4，只有 (4, 4, 4)；c = 5 时，a + b = 7 且 a ≤ b ≤ 5，有 (2, 5, 5) 和 (3, 4, 5)。',
          '合起来是 (4, 4, 4)、(2, 5, 5)、(3, 4, 5)，所以这样的三角形一共有 3 种。',
        ],
        'en' => [
          'Let the sides be a, b, c with a ≤ b ≤ c, so that each set of side lengths is counted once.',
          'For a triangle to exist, a + b > c; since a + b + c = 12 this gives 12 − c > c, that is c < 6.',
          'Also c is the largest side, so c is at least 12 ÷ 3 = 4. Hence c is 4 or 5.',
          'If c = 4 then a + b = 8 with a ≤ b ≤ 4, giving only (4, 4, 4). If c = 5 then a + b = 7 with a ≤ b ≤ 5, giving (2, 5, 5) and (3, 4, 5).',
          'Altogether the triangles are (4, 4, 4), (2, 5, 5) and (3, 4, 5), so there are 3 of them.',
        ],
        'ja' => [
          '3 辺を a、b、c とし、a ≤ b ≤ c と決めておくと、同じ辺の組を 1 回だけ数えられます。',
          '三角形ができるには a + b > c が必要で、a + b + c = 12 より 12 − c > c、つまり c < 6 となります。',
          '一方 c は最大の辺なので、c は少なくとも 12 ÷ 3 = 4 です。よって c は 4 か 5 です。',
          'c = 4 のとき a + b = 8 かつ a ≤ b ≤ 4 で (4, 4, 4) のみ、c = 5 のとき a + b = 7 かつ a ≤ b ≤ 5 で (2, 5, 5) と (3, 4, 5) です。',
          '合わせると (4, 4, 4)、(2, 5, 5)、(3, 4, 5) となり、три角形は 3 種類です。',
        ],
      },
      value: '3', max_digits: 1,
      source: src('三角不等式（由求範圍改為窮舉計數）',
                  '設計依據：既有題給兩邊求第三邊的最大值，本題固定周長改問符合條件的三角形個數，必須同時用三角不等式定上界、用最大邊定下界再系統列舉；屬同水準原創改寫，非抄錄特定官方題。',
                  '改寫題（三角不等式・計數）'),
    ),
    int_q(
      topic: 'geometry', subtopic: 'clock_hand_angle', subtopic_zh: '時鐘指針夾角',
      prompt: {
        'zh-Hant' => '一個正常運轉的時鐘，從某天午夜 0 時整開始，到隔天午夜 0 時整為止的一整天之內，時針與分針所夾的角恰好等於 90 度的時刻一共出現幾次？',
        'zh-Hans' => '一个正常运转的时钟，从某天午夜 0 时整开始，到隔天午夜 0 时整为止的一整天之内，时针与分针所夹的角恰好等于 90 度的时刻一共出现几次？',
        'en' => 'A clock runs normally. During one whole day, from midnight to the following midnight, how many moments are there at which the angle between the hour hand and the minute hand is exactly 90 degrees?',
        'ja' => '正しく動いている時計について、ある日の午前 0 時ちょうどから翌日の午前 0 時ちょうどまでの 1 日の間に、時針と分針のなす角がちょうど 90 度になる瞬間は何回ありますか。',
      },
      answer: { 'zh-Hant' => '答案是 44 次。', 'zh-Hans' => '答案是 44 次。',
                'en' => 'The answer is 44 times.', 'ja' => '答えは 44 回です。' },
      steps: {
        'zh-Hant' => [
          '分針每分鐘走 6 度，時針每分鐘走 0.5 度，所以分針相對於時針每分鐘多走 6 − 0.5 = 5.5 度。',
          '一整天有 24 × 60 = 1440 分鐘，這段時間分針相對時針一共多走 5.5 × 1440 = 7920 度。',
          '7920 ÷ 360 = 22，所以一整天之內，分針相對時針剛好轉了 22 整圈。',
          '在相對轉動的每一圈裡，兩針的夾角會經過一次「分針超前 90 度」和一次「分針超前 270 度」，這兩種情形的夾角都是 90 度，所以每圈出現 2 次。',
          '因此一整天共出現 22 × 2 = 44 次。',
        ],
        'zh-Hans' => [
          '分针每分钟走 6 度，时针每分钟走 0.5 度，所以分针相对于时针每分钟多走 6 − 0.5 = 5.5 度。',
          '一整天有 24 × 60 = 1440 分钟，这段时间分针相对时针一共多走 5.5 × 1440 = 7920 度。',
          '7920 ÷ 360 = 22，所以一整天之内，分针相对时针刚好转了 22 整圈。',
          '在相对转动的每一圈里，两针的夹角会经过一次「分针超前 90 度」和一次「分针超前 270 度」，这两种情形的夹角都是 90 度，所以每圈出现 2 次。',
          '因此一整天共出现 22 × 2 = 44 次。',
        ],
        'en' => [
          'The minute hand turns 6 degrees a minute and the hour hand 0.5 degrees a minute, so the minute hand gains 6 − 0.5 = 5.5 degrees a minute on the hour hand.',
          'A whole day has 24 × 60 = 1440 minutes, in which the minute hand gains 5.5 × 1440 = 7920 degrees.',
          'Since 7920 ÷ 360 = 22, the minute hand makes exactly 22 full turns relative to the hour hand during the day.',
          'In each relative turn the gain passes through 90 degrees once and through 270 degrees once, and both correspond to an angle of 90 degrees between the hands, so each turn gives 2 moments.',
          'The whole day therefore gives 22 × 2 = 44 moments.',
        ],
        'ja' => [
          '分針は 1 分に 6 度、時針は 1 分に 0.5 度動くので、分針は時針より 1 分あたり 6 − 0.5 = 5.5 度多く進みます。',
          '1 日は 24 × 60 = 1440 分あり、その間に分針は時針より 5.5 × 1440 = 7920 度多く進みます。',
          '7920 ÷ 360 = 22 なので、1 日の間に分針は時針に対してちょうど 22 回転します。',
          '相対的な 1 回転ごとに、進みの差が 90 度になる瞬間と 270 度になる瞬間が 1 回ずつあり、どちらも 2 針のなす角は 90 度なので、1 回転につき 2 回です。',
          'したがって 1 日では 22 × 2 = 44 回です。',
        ],
      },
      value: '44', max_digits: 2,
      source: src('時鐘指針夾角（單一時刻改為整日計數）',
                  '設計依據：既有題求某個指定時刻的夾角，本題改問一整天內夾角為 90 度的次數，必須改用相對角速度與圈數推理，並注意每圈有超前 90 度與 270 度兩次；屬同水準原創改寫，非抄錄特定官方題。',
                  '改寫題（時鐘・整日次數）'),
    ),
  ],
  'logic' => [
    int_q(
      topic: 'logic', subtopic: 'sawing_cuts', subtopic_zh: '鋸木頭的次數',
      prompt: {
        'zh-Hant' => '一塊長方形蛋糕要沿著直線切開，分成 6 塊大小形狀完全相同的長方形。每一刀都必須是一條貫穿整塊蛋糕的直線，而且不可以把切開後的蛋糕移動或疊起來再切。最少要切幾刀？',
        'zh-Hans' => '一块长方形蛋糕要沿着直线切开，分成 6 块大小形状完全相同的长方形。每一刀都必须是一条贯穿整块蛋糕的直线，而且不可以把切开后的蛋糕移动或叠起来再切。最少要切几刀？',
        'en' => 'A rectangular cake is to be cut along straight lines into 6 rectangular pieces of exactly the same size and shape. Every cut must be a straight line running right across the whole cake, and the pieces may not be moved or stacked before further cuts. What is the smallest number of cuts?',
        'ja' => '長方形のケーキを直線にそって切り、大きさも形もまったく同じ長方形 6 個に分けます。どの切り方もケーキ全体を貫く 1 本の直線でなければならず、切ったあとのケーキを動かしたり重ねたりして切ることはできません。最も少なくて何回切ればよいですか。',
      },
      answer: { 'zh-Hant' => '答案是 3 刀。', 'zh-Hans' => '答案是 3 刀。',
                'en' => 'The answer is 3 cuts.', 'ja' => '答えは 3 回です。' },
      steps: {
        'zh-Hant' => [
          '因為每一刀都貫穿整塊蛋糕，最後的 6 塊一定排成「橫 a 塊、直 b 塊」的長方形陣列，而且 a × b = 6。',
          '要切出橫向的 a 塊，需要 a − 1 刀；要切出直向的 b 塊，需要 b − 1 刀，總刀數是 (a − 1) + (b − 1)。',
          '6 = 1 × 6 時刀數是 0 + 5 = 5；6 = 2 × 3 時刀數是 1 + 2 = 3；6 = 3 × 2 與 6 = 6 × 1 的結果和前兩種相同。',
          '比較之後，2 × 3 的排法刀數最少。',
          '所以最少要切 3 刀（一個方向切 1 刀分成 2 排，另一個方向切 2 刀分成 3 列）。',
        ],
        'zh-Hans' => [
          '因为每一刀都贯穿整块蛋糕，最后的 6 块一定排成「横 a 块、竖 b 块」的长方形阵列，而且 a × b = 6。',
          '要切出横向的 a 块，需要 a − 1 刀；要切出竖向的 b 块，需要 b − 1 刀，总刀数是 (a − 1) + (b − 1)。',
          '6 = 1 × 6 时刀数是 0 + 5 = 5；6 = 2 × 3 时刀数是 1 + 2 = 3；6 = 3 × 2 与 6 = 6 × 1 的结果和前两种相同。',
          '比较之后，2 × 3 的排法刀数最少。',
          '所以最少要切 3 刀（一个方向切 1 刀分成 2 排，另一个方向切 2 刀分成 3 列）。',
        ],
        'en' => [
          'Since every cut crosses the whole cake, the 6 pieces must end up in a rectangular array of a pieces one way and b pieces the other, with a × b = 6.',
          'Producing a pieces in one direction needs a − 1 cuts and b pieces in the other needs b − 1 cuts, so the total is (a − 1) + (b − 1).',
          'For 6 = 1 × 6 that is 0 + 5 = 5; for 6 = 2 × 3 it is 1 + 2 = 3; the arrangements 3 × 2 and 6 × 1 repeat those totals.',
          'Comparing them, the 2 × 3 array needs the fewest cuts.',
          'So the smallest number of cuts is 3: one cut in one direction to make 2 rows, and two cuts in the other to make 3 columns.',
        ],
        'ja' => [
          'どの切り方もケーキ全体を貫くので、6 個は「一方に a 個、もう一方に b 個」の長方形の並びになり、a × b = 6 です。',
          '一方向に a 個作るには a − 1 回、もう一方向に b 個作るには b − 1 回必要なので、合計は (a − 1) + (b − 1) です。',
          '6 = 1 × 6 なら 0 + 5 = 5 回、6 = 2 × 3 なら 1 + 2 = 3 回で、3 × 2 や 6 × 1 は同じ結果になります。',
          '比べると 2 × 3 の並びが最も少なくてすみます。',
          'したがって最少は 3 回です（一方向に 1 回切って 2 段に、もう一方向に 2 回切って 3 列にします）。',
        ],
      },
      value: '3', max_digits: 1,
      source: src('切割次數（一維鋸木改為二維最省刀數）',
                  '設計依據：既有題是一維鋸木、段數減一即為刀數，本題改成二維切割且要求最少刀數，必須先枚舉 6 的因數分解再比較兩方向的刀數和；屬同水準原創改寫，非抄錄特定官方題。',
                  '改寫題（切割・二維最省）'),
    ),
    int_q(
      topic: 'logic', subtopic: 'snail_well_boundary', subtopic_zh: '邊界效應',
      prompt: {
        'zh-Hant' => '一隻蝸牛從井底開始往上爬，白天可以爬 4 公尺，夜裡會滑下 3 公尺。牠從第 1 天的白天開始爬，剛好在第 12 天的白天爬出井口。已知井的深度是整數公尺，求井深是幾公尺。',
        'zh-Hans' => '一只蜗牛从井底开始往上爬，白天可以爬 4 米，夜里会滑下 3 米。它从第 1 天的白天开始爬，刚好在第 12 天的白天爬出井口。已知井的深度是整数米，求井深是几米。',
        'en' => 'A snail climbs up from the bottom of a well, rising 4 metres each day and sliding back 3 metres each night. It starts climbing on the daytime of day 1 and gets out of the well exactly during the daytime of day 12. The depth of the well is a whole number of metres. How deep is the well?',
        'ja' => 'カタツムリが井戸の底から上へ登ります。昼は 4 m 登り、夜は 3 m すべり落ちます。1 日目の昼に登り始め、ちょうど 12 日目の昼に井戸の口から出ました。井戸の深さが整数メートルのとき、深さは何メートルですか。',
      },
      answer: { 'zh-Hant' => '答案是 15 公尺。', 'zh-Hans' => '答案是 15 米。',
                'en' => 'The answer is 15 metres.', 'ja' => '答えは 15 メートルです。' },
      steps: {
        'zh-Hant' => [
          '每過完整的一天（白天加夜裡），蝸牛淨上升 4 − 3 = 1 公尺。',
          '所以第 n 天白天結束時，蝸牛的高度是前面 n − 1 天累積的 (n − 1) 公尺，再加上當天白天爬的 4 公尺，也就是 n + 3 公尺。',
          '牠在第 12 天白天爬出，代表第 12 天白天能到達井口：井深 ≤ 12 + 3 = 15 公尺。',
          '同時第 11 天白天還沒爬出，代表井深 > 11 + 3 = 14 公尺。',
          '所以井深大於 14 且不超過 15，又是整數，因此井深是 15 公尺。',
        ],
        'zh-Hans' => [
          '每过完整的一天（白天加夜里），蜗牛净上升 4 − 3 = 1 米。',
          '所以第 n 天白天结束时，蜗牛的高度是前面 n − 1 天累积的 (n − 1) 米，再加上当天白天爬的 4 米，也就是 n + 3 米。',
          '它在第 12 天白天爬出，代表第 12 天白天能到达井口：井深 ≤ 12 + 3 = 15 米。',
          '同时第 11 天白天还没爬出，代表井深 > 11 + 3 = 14 米。',
          '所以井深大于 14 且不超过 15，又是整数，因此井深是 15 米。',
        ],
        'en' => [
          'Over one complete day and night the snail gains 4 − 3 = 1 metre.',
          'So at the end of the daytime of day n its height is the (n − 1) metres built up over the earlier days plus the 4 metres climbed that day, that is n + 3 metres.',
          'Getting out during day 12 means the well top is reachable then: the depth is at most 12 + 3 = 15 metres.',
          'At the same time it did not get out on day 11, so the depth is more than 11 + 3 = 14 metres.',
          'The depth is therefore greater than 14 and at most 15, and being a whole number it must be 15 metres.',
        ],
        'ja' => [
          '昼と夜を合わせた 1 日で、カタツムリは 4 − 3 = 1 m ずつ上がります。',
          'よって n 日目の昼が終わった時点の高さは、それまでの n − 1 日で上がった (n − 1) m にその日の昼の 4 m を加えた n + 3 m です。',
          '12 日目の昼に出たということは、その昼に井戸の口まで届くので、深さは 12 + 3 = 15 m 以下です。',
          '同時に 11 日目の昼には出ていないので、深さは 11 + 3 = 14 m より大きいことになります。',
          '深さは 14 より大きく 15 以下で、しかも整数なので、井戸の深さは 15 メートルです。',
        ],
      },
      value: '15', max_digits: 2,
      source: src('邊界效應（正推天數改為逆推井深）',
                  '設計依據：既有題給井深求第幾天爬出，本題給出爬出的天數反求井深，必須同時用「第 12 天爬得出」與「第 11 天爬不出」夾出上下界；屬同水準原創改寫，非抄錄特定官方題。',
                  '改寫題（邊界效應・逆推）'),
    ),
  ],
  'number_theory' => [
    int_q(
      topic: 'number_theory', subtopic: 'remainder_cycle', subtopic_zh: '餘數循環',
      prompt: {
        'zh-Hant' => '求最小的正整數 n，使得 3ⁿ 除以 11 的餘數等於 1。',
        'zh-Hans' => '求最小的正整数 n，使得 3ⁿ 除以 11 的余数等于 1。',
        'en' => 'Find the smallest positive integer n for which 3ⁿ leaves a remainder of 1 when divided by 11.',
        'ja' => '3ⁿ を 11 でわった余りが 1 になるような最小の正の整数 n を求めなさい。',
      },
      answer: { 'zh-Hant' => '答案是 5。', 'zh-Hans' => '答案是 5。', 'en' => 'The answer is 5.', 'ja' => '答えは 5 です。' },
      steps: {
        'zh-Hant' => [
          '不必真的算出 3ⁿ 的值，只要一路記錄除以 11 的餘數即可，因為餘數只跟前一個餘數有關。',
          '3¹ 的餘數是 3；3² 的餘數是 3 × 3 = 9；3³ 的餘數是 9 × 3 = 27，而 27 除以 11 餘 5。',
          '3⁴ 的餘數是 5 × 3 = 15，而 15 除以 11 餘 4。',
          '3⁵ 的餘數是 4 × 3 = 12，而 12 除以 11 餘 1，第一次出現餘數 1。',
          '所以最小的 n 是 5。',
        ],
        'zh-Hans' => [
          '不必真的算出 3ⁿ 的值，只要一路记录除以 11 的余数即可，因为余数只跟前一个余数有关。',
          '3¹ 的余数是 3；3² 的余数是 3 × 3 = 9；3³ 的余数是 9 × 3 = 27，而 27 除以 11 余 5。',
          '3⁴ 的余数是 5 × 3 = 15，而 15 除以 11 余 4。',
          '3⁵ 的余数是 4 × 3 = 12，而 12 除以 11 余 1，第一次出现余数 1。',
          '所以最小的 n 是 5。',
        ],
        'en' => [
          'There is no need to work out 3ⁿ itself; only the remainder on division by 11 matters, and each remainder depends solely on the previous one.',
          '3¹ leaves 3; 3² leaves 3 × 3 = 9; 3³ leaves 9 × 3 = 27, and 27 divided by 11 leaves 5.',
          '3⁴ leaves 5 × 3 = 15, and 15 divided by 11 leaves 4.',
          '3⁵ leaves 4 × 3 = 12, and 12 divided by 11 leaves 1, the first time the remainder is 1.',
          'So the smallest such n is 5.',
        ],
        'ja' => [
          '3ⁿ の値そのものを計算する必要はなく、11 でわった余りだけを順に追えば十分です。余りは 1 つ前の余りだけで決まります。',
          '3¹ の余りは 3、3² の余りは 3 × 3 = 9、3³ の余りは 9 × 3 = 27 で、27 を 11 でわると余りは 5 です。',
          '3⁴ の余りは 5 × 3 = 15 で、15 を 11 でわると余りは 4 です。',
          '3⁵ の余りは 4 × 3 = 12 で、12 を 11 でわると余りは 1 となり、ここで初めて余りが 1 になります。',
          'したがって最小の n は 5 です。',
        ],
      },
      value: '5', max_digits: 1,
      source: src('餘數循環（由算餘數改為求最小指數）',
                  '設計依據：既有題給定指數求餘數，本題反過來給定餘數求最小指數，必須逐次遞推直到餘數首次回到 1，考的是循環長度而非單次計算；屬同水準原創改寫，非抄錄特定官方題。',
                  '改寫題（餘數循環・求最小指數）'),
    ),
    int_q(
      topic: 'number_theory', subtopic: 'trailing_zeros_product', subtopic_zh: '末尾零的個數',
      prompt: {
        'zh-Hant' => '已知 N = 2³ × 5 × 7。要在 N 上再乘一個正整數 m，使得 N × m 的末尾恰好連續有 3 個 0（不多也不少）。求最小的 m。',
        'zh-Hans' => '已知 N = 2³ × 5 × 7。要在 N 上再乘一个正整数 m，使得 N × m 的末尾恰好连续有 3 个 0（不多也不少）。求最小的 m。',
        'en' => 'Let N = 2³ × 5 × 7. A positive integer m is to be multiplied by N so that N × m ends in exactly 3 consecutive zeros, no more and no fewer. Find the smallest such m.',
        'ja' => 'N = 2³ × 5 × 7 とします。正の整数 m をかけて、N × m の末尾がちょうど 3 個続けて 0 になる（多くても少なくてもいけない）ようにします。最小の m を求めなさい。',
      },
      answer: { 'zh-Hant' => '答案是 25。', 'zh-Hans' => '答案是 25。', 'en' => 'The answer is 25.', 'ja' => '答えは 25 です。' },
      steps: {
        'zh-Hant' => [
          '末尾每多一個 0，就代表這個數多含一個因數 10，而 10 = 2 × 5，所以末尾 0 的個數等於因數 2 的個數和因數 5 的個數之中比較少的那一個。',
          'N = 2³ × 5 × 7 之中，因數 2 有 3 個、因數 5 只有 1 個，所以 N 的末尾只有 1 個 0。',
          '要讓末尾恰好有 3 個 0，就必須讓 2 和 5 的個數之中較少的那個剛好是 3。',
          'N 已有 3 個因數 2，所以只要把因數 5 補到 3 個即可，也就是再乘上 5² = 25；此時 2 有 3 個、5 有 3 個，末尾正好 3 個 0。',
          '若補得比 25 少就湊不滿 3 個 5，所以最小的 m 是 25（此時 N × m = 7000，末尾確實是 3 個 0）。',
        ],
        'zh-Hans' => [
          '末尾每多一个 0，就代表这个数多含一个因数 10，而 10 = 2 × 5，所以末尾 0 的个数等于因数 2 的个数和因数 5 的个数之中比较少的那一个。',
          'N = 2³ × 5 × 7 之中，因数 2 有 3 个、因数 5 只有 1 个，所以 N 的末尾只有 1 个 0。',
          '要让末尾恰好有 3 个 0，就必须让 2 和 5 的个数之中较少的那个刚好是 3。',
          'N 已有 3 个因数 2，所以只要把因数 5 补到 3 个即可，也就是再乘上 5² = 25；此时 2 有 3 个、5 有 3 个，末尾正好 3 个 0。',
          '若补得比 25 少就凑不满 3 个 5，所以最小的 m 是 25（此时 N × m = 7000，末尾确实是 3 个 0）。',
        ],
        'en' => [
          'Each trailing zero corresponds to one factor of 10, and 10 = 2 × 5, so the number of trailing zeros equals the smaller of the number of factors 2 and the number of factors 5.',
          'In N = 2³ × 5 × 7 there are 3 factors of 2 but only 1 factor of 5, so N ends in just 1 zero.',
          'For exactly 3 trailing zeros, the smaller of those two counts must be exactly 3.',
          'N already has 3 factors of 2, so it is enough to bring the factors of 5 up to 3, that is to multiply by 5² = 25; then there are 3 twos and 3 fives, giving exactly 3 trailing zeros.',
          'Anything smaller fails to supply three factors of 5, so the smallest m is 25, and indeed N × m = 7000 ends in exactly 3 zeros.',
        ],
        'ja' => [
          '末尾の 0 が 1 個増えるごとに因数 10 が 1 個増え、10 = 2 × 5 なので、末尾の 0 の個数は因数 2 の個数と因数 5 の個数のうち少ないほうに等しくなります。',
          'N = 2³ × 5 × 7 では因数 2 が 3 個、因数 5 は 1 個しかないので、N の末尾の 0 は 1 個だけです。',
          '末尾をちょうど 3 個の 0 にするには、2 と 5 の個数のうち少ないほうがちょうど 3 になればよいことになります。',
          'N にはすでに因数 2 が 3 個あるので、因数 5 を 3 個までおぎなえばよく、5² = 25 をかければ 2 が 3 個、5 が 3 個となり末尾はちょうど 0 が 3 個です。',
          '25 より小さいと因数 5 が 3 個そろわないので、最小の m は 25 です（このとき N × m = 7000 で末尾は確かに 0 が 3 個です）。',
        ],
      },
      value: '25', max_digits: 2,
      source: src('末尾零的個數（由計數改為補乘數）',
                  '設計依據：既有題直接數某個數末尾有幾個 0，本題反過來要求補上最小的乘數湊出指定的零數，必須比較因數 2 與因數 5 的個數並補足較少的一邊；屬同水準原創改寫，非抄錄特定官方題。',
                  '改寫題（末尾零・補乘數）'),
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
  ordered = questions.map do |q|
    { 'id' => q['id'] }.merge(q.reject { |k, _| k == 'id' })
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
