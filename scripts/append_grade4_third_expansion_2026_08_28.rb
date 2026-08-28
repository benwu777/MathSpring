#!/usr/bin/env ruby
# grade4 補題：幾何 2 題、算術 3 題。
# 候選 15 題，通過 5 題。淘汰的都留了紀錄：
#   鋸木頭撞 logic_grade7_019、追及撞 arithmetic_grade6_037、三色旗撞
#   combinatorics_grade7_014、頁碼撞 arithmetic_grade6_009、周長 24 整數長方形撞
#   geometry_grade2_054、7 顆蘋果分 3 人撞 combinatorics_grade9_003、
#   剪最大正方形撞 geometry_grade3_044。
require 'json'

def t(zh, zhs, en, ja) = { 'zh-Hant' => zh, 'zh-Hans' => zhs, 'en' => en, 'ja' => ja }

def q(id:, subtopic:, prompt:, answer:, steps:, figure:, correct:, digits:, notes:)
  {
    'reviewStatus' => 'ok', 'topic' => id.split('_').first, 'subtopic' => subtopic,
    'difficulty' => 'foundation', 'levelStage' => 'grade4', 'challengeTier' => 'foundation',
    'prompt' => prompt, 'answer' => answer,
    'solutionSteps' => { 'zh-Hant' => steps[0], 'zh-Hans' => steps[1], 'en' => steps[2], 'ja' => steps[3] },
    'figure' => figure,
    'source' => { 'type' => 'rewritten_olympiad_style', 'name' => 'MathSpring Editorial',
                  'reference' => "#{id.split('_').first}-grade4-foundation", 'notes' => notes },
    'answerMode' => 'integer_input',
    'correctAnswer' => { 'type' => 'integer', 'value' => correct },
    'inputConstraints' => { 'allowNegative' => false, 'maxDigits' => digits },
    'id' => id
  }
end

NONE = { 'type' => 'custom', 'kind' => 'none', 'params' => {} }
def scene(p) = { 'type' => 'custom', 'kind' => 'geometry_scene', 'params' => p.merge('kind' => 'geometry_scene') }
def hid(n, x, y) = { 'name' => n, 'x' => x, 'y' => y, 'visible' => false }
def seg(a, b) = { 'from' => a, 'to' => b, 'style' => 'solid' }

GEO = [
  q(id: 'geometry_grade4_foundation_053', subtopic: 'pinwheel_square',
    prompt: t('如圖，用 4 個完全一樣的長方形，每個長 6 公分、寬 2 公分，像風車一樣圍成一個大正方形，中間剛好留下一個正方形的洞（圖中的陰影部分）。這個大正方形的邊長是幾公分？',
              '如图，用 4 个完全一样的长方形，每个长 6 厘米、宽 2 厘米，像风车一样围成一个大正方形，中间刚好留下一个正方形的洞（图中的阴影部分）。这个大正方形的边长是几厘米？',
              'As in the figure, four identical rectangles, each 6 cm long and 2 cm wide, are arranged like a pinwheel to enclose a large square, leaving a square hole in the middle (the shaded part). How many centimetres is the side of the large square?',
              '図のように、たて 2 cm、よこ 6 cm の合同な長方形 4 つを風車のようにならべて大きな正方形を作ると、まん中に正方形の穴（図のかげの部分）ができます。この大きな正方形の 1 辺は何 cm ですか。'),
    answer: t('答案是 8 公分。', '答案是 8 厘米。', 'The answer is 8 cm.', '答えは 8 cm です。'),
    steps: [
      ['看大正方形的任何一條邊：它剛好被分成兩段。',
       '一段是某個長方形的長邊 6 公分，另一段是旁邊那個長方形的寬 2 公分。',
       '所以大正方形的邊長是 6 + 2 = 8 公分。',
       '驗算：大正方形面積 8 × 8 = 64，四個長方形面積 4 × 6 × 2 = 48，中間的洞是 64 − 48 = 16，剛好是邊長 4 的正方形，和圖相符。'],
      ['看大正方形的任何一条边：它刚好被分成两段。',
       '一段是某个长方形的长边 6 厘米，另一段是旁边那个长方形的宽 2 厘米。',
       '所以大正方形的边长是 6 + 2 = 8 厘米。',
       '验算：大正方形面积 8 × 8 = 64，四个长方形面积 4 × 6 × 2 = 48，中间的洞是 64 − 48 = 16，刚好是边长 4 的正方形，和图相符。'],
      ['Look at any side of the large square: it is split into exactly two parts.',
       'One part is the long side of one rectangle, 6 cm, and the other is the width of the neighbouring rectangle, 2 cm.',
       'So the side of the large square is 6 + 2 = 8 cm.',
       'Checking: the large square has area 8 × 8 = 64, the four rectangles have area 4 × 6 × 2 = 48, so the hole is 64 − 48 = 16, a square of side 4, which matches the figure.'],
      ['大きな正方形のどの辺を見ても、その辺はちょうど 2 つの部分に分かれています。',
       '一方は長方形の長いほうの辺 6 cm、もう一方はとなりの長方形の幅 2 cm です。',
       'したがって大きな正方形の 1 辺は 6 + 2 = 8 cm です。',
       '確かめ：大きな正方形の面積は 8 × 8 = 64、長方形 4 つの面積は 4 × 6 × 2 = 48 なので、穴は 64 − 48 = 16 で 1 辺 4 の正方形となり、図と合います。']],
    figure: scene(
      'bounds' => { 'minX' => -0.5, 'minY' => -0.5, 'maxX' => 8.5, 'maxY' => 8.5 },
      'points' => [
        hid('A', 0, 0), hid('B', 8, 0), hid('C', 8, 8), hid('D', 0, 8),
        hid('P1', 0, 6), hid('P2', 6, 6), hid('P3', 6, 8), hid('P4', 6, 2),
        hid('P5', 8, 2), hid('P6', 2, 2), hid('P7', 2, 0), hid('P8', 2, 6)
      ],
      'segments' => [
        seg('A', 'B'), seg('B', 'C'), seg('C', 'D'), seg('D', 'A'),
        seg('P1', 'P2'), seg('P3', 'P4'), seg('P5', 'P6'), seg('P7', 'P8')
      ],
      'polygons' => [{ 'vertices' => %w[P6 P4 P2 P8], 'fill' => 'shaded' }]),
    correct: '8', digits: 1,
    notes: 'Original composition in the Math Kangaroo grade 3-4 style. The intended move is reading one side of the large square as long-side plus short-side of two different rectangles, so no equation is needed; the figure shows the pinwheel arrangement, which the wording alone cannot pin down.'),

  q(id: 'geometry_grade4_foundation_054', subtopic: 'square_counting',
    prompt: t('如圖是一個 4 × 4 的方格圖，格線把它分成 16 個一樣大的小正方形。在這張圖上，一共可以找到幾個正方形？大小不同或位置不同都算成不同的正方形。',
              '如图是一个 4 × 4 的方格图，格线把它分成 16 个一样大的小正方形。在这张图上，一共可以找到几个正方形？大小不同或位置不同都算成不同的正方形。',
              'The figure shows a 4 × 4 grid divided by its lines into 16 identical small squares. How many squares in total can be found in this figure? Squares of different sizes or in different positions count as different squares.',
              '図は 4 × 4 のます目で、線によって同じ大きさの小さな正方形 16 個に分けられています。この図の中に正方形は全部で何個見つかりますか。大きさがちがうもの、位置がちがうものはそれぞれ別に数えます。'),
    answer: t('答案是 30 個。', '答案是 30 个。', 'The answer is 30.', '答えは 30 個です。'),
    steps: [
      ['不要亂數，要按照正方形的大小分成幾類來數。',
       '邊長 1 格的：橫的有 4 個位置、直的有 4 個位置，共 4 × 4 = 16 個。',
       '邊長 2 格的：左上角只能放在 3 × 3 = 9 個位置；邊長 3 格的有 2 × 2 = 4 個；邊長 4 格的只有 1 個。',
       '全部加起來：16 + 9 + 4 + 1 = 30 個。'],
      ['不要乱数，要按照正方形的大小分成几类来数。',
       '边长 1 格的：横的有 4 个位置、竖的有 4 个位置，共 4 × 4 = 16 个。',
       '边长 2 格的：左上角只能放在 3 × 3 = 9 个位置；边长 3 格的有 2 × 2 = 4 个；边长 4 格的只有 1 个。',
       '全部加起来：16 + 9 + 4 + 1 = 30 个。'],
      ['Do not count at random: sort the squares by their size and count each size separately.',
       'Squares 1 cell wide: 4 positions across and 4 down, giving 4 × 4 = 16.',
       'Squares 2 cells wide: the top-left corner can go in 3 × 3 = 9 places; squares 3 cells wide give 2 × 2 = 4; the 4-cell square gives 1.',
       'Adding them up: 16 + 9 + 4 + 1 = 30.'],
      ['やみくもに数えず、正方形の大きさごとに分けて数えます。',
       '1 ますぶんの正方形：横に 4 か所、たてに 4 か所で 4 × 4 = 16 個です。',
       '2 ますぶんは左上のかどの置き方が 3 × 3 = 9 通り、3 ますぶんは 2 × 2 = 4 個、4 ますぶんは 1 個です。',
       'すべて合わせて 16 + 9 + 4 + 1 = 30 個です。']],
    figure: scene(
      'bounds' => { 'minX' => -0.4, 'minY' => -0.4, 'maxX' => 4.4, 'maxY' => 4.4 },
      'points' => [
        hid('A', 0, 0), hid('B', 4, 0), hid('C', 4, 4), hid('D', 0, 4),
        hid('h1a', 0, 1), hid('h1b', 4, 1), hid('h2a', 0, 2), hid('h2b', 4, 2),
        hid('h3a', 0, 3), hid('h3b', 4, 3),
        hid('v1a', 1, 0), hid('v1b', 1, 4), hid('v2a', 2, 0), hid('v2b', 2, 4),
        hid('v3a', 3, 0), hid('v3b', 3, 4)
      ],
      'segments' => [
        seg('A', 'B'), seg('B', 'C'), seg('C', 'D'), seg('D', 'A'),
        seg('h1a', 'h1b'), seg('h2a', 'h2b'), seg('h3a', 'h3b'),
        seg('v1a', 'v1b'), seg('v2a', 'v2b'), seg('v3a', 'v3b')
      ]),
    correct: '30', digits: 2,
    notes: 'Original composition in the Math Kangaroo grade 3-4 style. The intended move is classifying by side length and counting placements for each, which is a different technique from counting rectangles by choosing pairs of grid lines; the figure only draws the grid described in the text.')
]

ARI = [
  q(id: 'arithmetic_grade4_foundation_077', subtopic: 'digit_condition_counting',
    prompt: t('把 1 到 100 的整數都寫下來。這些數當中，至少有一個數字是 7 的數，一共有幾個？',
              '把 1 到 100 的整数都写下来。这些数当中，至少有一个数字是 7 的数，一共有几个？',
              'Write down all the whole numbers from 1 to 100. How many of them have at least one digit equal to 7?',
              '1 から 100 までの整数をすべて書き出します。そのうち、数字に 7 が少なくとも 1 つふくまれる数は何個ありますか。'),
    answer: t('答案是 19 個。', '答案是 19 个。', 'The answer is 19.', '答えは 19 個です。'),
    steps: [
      ['分成兩種情形數：個位是 7 的，和十位是 7 的。',
       '個位是 7 的有 7、17、27、37、47、57、67、77、87、97，共 10 個。',
       '十位是 7 的有 70 到 79，也是 10 個。',
       '但 77 兩邊都數到了，要扣掉一次：10 + 10 − 1 = 19 個。'],
      ['分成两种情形数：个位是 7 的，和十位是 7 的。',
       '个位是 7 的有 7、17、27、37、47、57、67、77、87、97，共 10 个。',
       '十位是 7 的有 70 到 79，也是 10 个。',
       '但 77 两边都数到了，要扣掉一次：10 + 10 − 1 = 19 个。'],
      ['Split into two cases: numbers whose units digit is 7, and numbers whose tens digit is 7.',
       'Units digit 7 gives 7, 17, 27, 37, 47, 57, 67, 77, 87, 97, which is 10 numbers.',
       'Tens digit 7 gives 70 to 79, which is another 10 numbers.',
       'But 77 has been counted in both lists, so subtract it once: 10 + 10 − 1 = 19.'],
      ['一の位が 7 の数と、十の位が 7 の数の 2 つに分けて数えます。',
       '一の位が 7 の数は 7、17、27、37、47、57、67、77、87、97 の 10 個です。',
       '十の位が 7 の数は 70 から 79 までで、こちらも 10 個です。',
       'ただし 77 は両方で数えているので 1 回引いて、10 + 10 − 1 = 19 個です。']],
    figure: NONE, correct: '19', digits: 2,
    notes: 'Original composition in the Math Kangaroo grade 3-4 style. The intended move is counting by digit position and then removing the double-counted 77; answering 20 is the trap. Distinct from the page-numbering family, which counts digit occurrences rather than numbers.'),

  q(id: 'arithmetic_grade4_foundation_078', subtopic: 'arrangements_with_zero',
    prompt: t('用 0、1、2、3 這四個數字，每個數字都恰好用一次，可以排出幾個不同的四位數？四位數的最高位不能是 0。',
              '用 0、1、2、3 这四个数字，每个数字都恰好用一次，可以排出几个不同的四位数？四位数的最高位不能是 0。',
              'Using each of the digits 0, 1, 2 and 3 exactly once, how many different four-digit numbers can be formed? The leading digit of a four-digit number cannot be 0.',
              '0、1、2、3 の 4 つの数字をそれぞれちょうど 1 回ずつ使って、4 けたの整数は何個作れますか。ただし 4 けたの整数の一番上の位を 0 にすることはできません。'),
    answer: t('答案是 18 個。', '答案是 18 个。', 'The answer is 18.', '答えは 18 個です。'),
    steps: [
      ['先決定最高位（千位），因為它有限制：不能是 0，所以只能是 1、2、3 這 3 種選擇。',
       '千位定下來以後，剩下三個數字（含 0）要填百位、十位、個位。',
       '百位有 3 種選擇，十位剩 2 種，個位剩 1 種，所以是 3 × 2 × 1 = 6 種。',
       '把兩步相乘：3 × 6 = 18 個。（若忘記排除 0 開頭，會多算成 24 個。）'],
      ['先决定最高位（千位），因为它有限制：不能是 0，所以只能是 1、2、3 这 3 种选择。',
       '千位定下来以后，剩下三个数字（含 0）要填百位、十位、个位。',
       '百位有 3 种选择，十位剩 2 种，个位剩 1 种，所以是 3 × 2 × 1 = 6 种。',
       '把两步相乘：3 × 6 = 18 个。（若忘记排除 0 开头，会多算成 24 个。）'],
      ['Decide the leading digit first, because it is the one with a restriction: it cannot be 0, so there are 3 choices, namely 1, 2 or 3.',
       'Once the leading digit is fixed, the remaining three digits, including 0, fill the hundreds, tens and units places.',
       'There are 3 choices for the hundreds, then 2 for the tens and 1 for the units, giving 3 × 2 × 1 = 6 ways.',
       'Multiplying the two steps: 3 × 6 = 18. Forgetting to exclude a leading 0 would give 24 instead.'],
      ['まず一番上の位を決めます。ここだけ 0 が使えないという制限があるので、選び方は 1、2、3 の 3 通りです。',
       '一番上の位が決まると、0 をふくむ残りの 3 つの数字で百の位、十の位、一の位をうめます。',
       '百の位は 3 通り、十の位は 2 通り、一の位は 1 通りなので 3 × 2 × 1 = 6 通りです。',
       '2 つを かけて 3 × 6 = 18 個です。0 が先頭になる場合を除き忘れると 24 個としてしまいます。']],
    figure: NONE, correct: '18', digits: 2,
    notes: 'Original composition in the Math Kangaroo grade 3-4 style. The intended move is handling the restricted position first; the presence of 0 is what makes this more than a plain factorial count.'),

  q(id: 'arithmetic_grade4_foundation_079', subtopic: 'closed_path_planting',
    prompt: t('一個正方形花圃的邊長是 10 公尺。沿著花圃的四周每隔 2 公尺種一棵樹，四個角上都要種。一共要種幾棵樹？',
              '一个正方形花圃的边长是 10 米。沿着花圃的四周每隔 2 米种一棵树，四个角上都要种。一共要种几棵树？',
              'A square flower bed has sides of 10 metres. Trees are planted around its edge every 2 metres, with a tree at each of the four corners. How many trees are planted altogether?',
              '1 辺 10 m の正方形の花だんがあります。そのまわりにそって 2 m おきに木を植え、4 すみにも木を植えます。木は全部で何本植えますか。'),
    answer: t('答案是 20 棵。', '答案是 20 棵。', 'The answer is 20.', '答えは 20 本です。'),
    steps: [
      ['沿著四周走一圈的總長度是 10 × 4 = 40 公尺。',
       '每隔 2 公尺種一棵，所以一圈被分成 40 ÷ 2 = 20 段。',
       '直線種樹時樹的棵數要比段數多 1，但這裡走的是一圈封閉的路線：從起點走一圈會回到起點，起點和終點是同一棵樹。',
       '所以棵數剛好等於段數，一共種 20 棵（不是 21 棵）。'],
      ['沿着四周走一圈的总长度是 10 × 4 = 40 米。',
       '每隔 2 米种一棵，所以一圈被分成 40 ÷ 2 = 20 段。',
       '直线种树时树的棵数要比段数多 1，但这里走的是一圈封闭的路线：从起点走一圈会回到起点，起点和终点是同一棵树。',
       '所以棵数刚好等于段数，一共种 20 棵（不是 21 棵）。'],
      ['Walking right round the edge covers 10 × 4 = 40 metres.',
       'A tree every 2 metres cuts that trip into 40 ÷ 2 = 20 gaps.',
       'Along a straight line there would be one more tree than gaps, but this path is a closed loop: walking all the way round returns to the start, so the first and last tree are the same one.',
       'So the number of trees equals the number of gaps: 20 trees, not 21.'],
      ['まわりを 1 周すると、その長さは 10 × 4 = 40 m です。',
       '2 m おきに植えるので、1 周は 40 ÷ 2 = 20 個の区間に分かれます。',
       'まっすぐな線に沿って植えるときは木の数が区間の数より 1 本多くなりますが、ここは 1 周してもとの場所にもどる閉じた道なので、最初の木と最後の木は同じ 1 本です。',
       'したがって木の数は区間の数と等しく、20 本です（21 本ではありません）。']],
    figure: NONE, correct: '20', digits: 2,
    notes: 'Original composition in the Math Kangaroo grade 3-4 style. The intended move is recognising that the closed loop removes the usual plus-one of interval counting; answering 21 is the trap.')
]

{ 'geometry' => GEO, 'arithmetic' => ARI }.each do |topic, items|
  path = "assets/questions/#{topic}/grade4_foundation.#{topic}.v1.json"
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
