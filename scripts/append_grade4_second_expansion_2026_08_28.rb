#!/usr/bin/env ruby
# frozen_string_literal: true

# grade4 第二輪擴充（2026-08-28）：geometry 4 / logic 2 / arithmetic 2，共 8 題
# 候選 16 題，經 scripts/question_similarity_audit.py 與人工複查後淘汰 8 題：
#   撞既有題：相遇問題（撞 grade6_054）、數字出現次數（撞 grade6_036）、時鐘日差（撞 grade9_025）、
#             同餘最少（撞 kangaroo56_009，同為「最小公倍數減 1」）、五格最小周長（撞 grade4_015）、
#             圍籬笆柱子（撞 grade4_021 的邊界計數陷阱）、遞迴分割數正方形（撞 grade1_042）
#   裸題：梯形面積、三倍多 24、因數個數、買筆記本單價
require 'json'
require 'set'

ROOT = File.expand_path('..', __dir__)
GRADE = 'grade4'
PATHS = %w[geometry logic arithmetic].to_h { |t| [t, File.join(ROOT, "assets/questions/#{t}/#{GRADE}_foundation.#{t}.v1.json")] }.freeze
MANIFEST_PATH = File.join(ROOT, 'assets/questions/manifest.json')

def load_json(path) = JSON.parse(File.read(path))
def save_json(path, data) = File.write(path, JSON.pretty_generate(data) + "\n")

def int_q(topic:, subtopic:, prompt:, answer:, steps:, value:, max_digits:, notes:)
  { 'reviewStatus' => 'ok', 'topic' => topic, 'subtopic' => subtopic,
    'difficulty' => 'foundation', 'levelStage' => GRADE, 'challengeTier' => 'foundation',
    'prompt' => prompt, 'answer' => answer, 'solutionSteps' => steps,
    'figure' => { 'type' => 'custom', 'kind' => 'none', 'params' => {} },
    'answerMode' => 'integer_input',
    'correctAnswer' => { 'type' => 'integer', 'value' => value },
    'inputConstraints' => { 'allowNegative' => false, 'maxDigits' => max_digits },
    'source' => { 'type' => 'rewritten_olympiad_style', 'name' => 'MathSpring Editorial',
                  'reference' => "#{topic}-#{GRADE}-foundation", 'notes' => notes } }
end

QUESTIONS = {
  'geometry' => [
    int_q(
      topic: 'geometry', subtopic: 'scale_factor',
      prompt: {
        'zh-Hant' => '把一個正方形四條邊的中點依序連起來，會在裡面得到一個新的正方形。原來那個正方形的面積，是新正方形面積的幾倍？',
        'zh-Hans' => '把一个正方形四条边的中点依序连起来，会在里面得到一个新的正方形。原来那个正方形的面积，是新正方形面积的几倍？',
        'en' => 'Joining the midpoints of the four sides of a square in order produces a new square inside it. The area of the original square is how many times the area of the new square?',
        'ja' => '正方形の 4 辺の中点を順に結ぶと、内側に新しい正方形ができます。もとの正方形の面積は、新しい正方形の面積の何倍ですか。',
      },
      answer: { 'zh-Hant' => '答案是 2 倍。', 'zh-Hans' => '答案是 2 倍。',
                'en' => 'The answer is 2 times.', 'ja' => '答えは 2 倍です。' },
      steps: {
        'zh-Hant' => [
          '把四條邊的中點連起來以後，原來的正方形被分成中間的新正方形，加上四個角落的小三角形。',
          '這四個小三角形都是一樣大的直角三角形，兩條直角邊都等於原正方形邊長的一半。',
          '把四個角落的小三角形兩兩拼起來，剛好可以拼成兩個和新正方形一樣大的正方形。',
          '所以原正方形等於新正方形，再加上相當於一個新正方形的四個小三角形，也就是兩個新正方形。',
          '因此原正方形的面積是新正方形的 2 倍。',
        ],
        'zh-Hans' => [
          '把四条边的中点连起来以后，原来的正方形被分成中间的新正方形，加上四个角落的小三角形。',
          '这四个小三角形都是一样大的直角三角形，两条直角边都等于原正方形边长的一半。',
          '把四个角落的小三角形两两拼起来，刚好可以拼成两个和新正方形一样大的正方形。',
          '所以原正方形等于新正方形，再加上相当于一个新正方形的四个小三角形，也就是两个新正方形。',
          '因此原正方形的面积是新正方形的 2 倍。',
        ],
        'en' => [
          'Once the midpoints are joined, the original square is split into the new square in the middle plus four small triangles at the corners.',
          'Those four triangles are congruent right triangles whose two shorter sides are each half the side of the original square.',
          'Fitting the four corner triangles together in pairs produces exactly two squares the size of the new square.',
          'So the original square equals the new square plus corner triangles worth one more new square, that is two new squares.',
          'The original square therefore has 2 times the area of the new square.',
        ],
        'ja' => [
          '4 辺の中点を結ぶと、もとの正方形は中央の新しい正方形と、4 すみの小さい三角形に分かれます。',
          'この 4 つの三角形はすべて合同な直角三角形で、直角をはさむ 2 辺はもとの正方形の 1 辺の半分です。',
          '4 すみの三角形を 2 つずつ組み合わせると、新しい正方形と同じ大きさの正方形がちょうど 2 つできます。',
          'つまりもとの正方形は、新しい正方形に、新しい正方形 1 つ分にあたる 4 つの三角形を加えたもので、新しい正方形 2 つ分です。',
          'したがってもとの正方形の面積は新しい正方形の 2 倍です。',
        ],
      },
      value: '2', max_digits: 1,
      notes: 'Original composition in the Math Kangaroo grade 3-4 dissection style; the ratio is found by rearranging the corner triangles rather than by computing either area. Not a reproduction of any past paper.',
    ),
    int_q(
      topic: 'geometry', subtopic: 'rotation',
      prompt: {
        'zh-Hant' => '把一個正方形放在桌上，繞著它的中心慢慢旋轉。至少要旋轉幾度，這個正方形才會第一次和它原來的位置完全重合？',
        'zh-Hans' => '把一个正方形放在桌上，绕着它的中心慢慢旋转。至少要旋转几度，这个正方形才会第一次和它原来的位置完全重合？',
        'en' => 'A square lies on a table and is slowly rotated about its centre. Through at least how many degrees must it turn before it first coincides exactly with its original position?',
        'ja' => '正方形を机の上に置き、中心のまわりにゆっくり回します。もとの位置とはじめてぴったり重なるまでに、少なくとも何度回せばよいですか。',
      },
      answer: { 'zh-Hant' => '答案是 90 度。', 'zh-Hans' => '答案是 90 度。',
                'en' => 'The answer is 90 degrees.', 'ja' => '答えは 90 度です。' },
      steps: {
        'zh-Hant' => [
          '正方形的四個頂點到中心的距離都一樣，四條邊也都一樣長，所以四個頂點在旋轉時的地位完全相同。',
          '要和原來的位置完全重合，就必須讓每一個頂點都轉到「原本某個頂點所在的位置」。',
          '轉一整圈是 360 度，中間會經過 4 個這樣的位置，因為正方形有 4 個頂點。',
          '所以每轉 360 ÷ 4 = 90 度，正方形就會和原來的位置重合一次。',
          '第一次重合就是轉 90 度的時候。',
        ],
        'zh-Hans' => [
          '正方形的四个顶点到中心的距离都一样，四条边也都一样长，所以四个顶点在旋转时的地位完全相同。',
          '要和原来的位置完全重合，就必须让每一个顶点都转到「原本某个顶点所在的位置」。',
          '转一整圈是 360 度，中间会经过 4 个这样的位置，因为正方形有 4 个顶点。',
          '所以每转 360 ÷ 4 = 90 度，正方形就会和原来的位置重合一次。',
          '第一次重合就是转 90 度的时候。',
        ],
        'en' => [
          'All four vertices of a square are the same distance from the centre and all four sides are equal, so the vertices play identical roles under rotation.',
          'To coincide with the original position, every vertex must land where some vertex originally was.',
          'A full turn is 360 degrees and passes through 4 such positions, because the square has 4 vertices.',
          'So every 360 ÷ 4 = 90 degrees the square coincides with its original position once.',
          'The first coincidence therefore happens after a turn of 90 degrees.',
        ],
        'ja' => [
          '正方形の 4 頂点は中心から等距離にあり、4 辺の長さも等しいので、回転において 4 頂点の役割はまったく同じです。',
          'もとの位置と重なるためには、どの頂点ももともとどれかの頂点があった位置に来なければなりません。',
          '1 周は 360 度で、正方形の頂点は 4 つなので、その途中にそのような位置が 4 か所あります。',
          'したがって 360 ÷ 4 = 90 度回すごとに、正方形はもとの位置と 1 回重なります。',
          'はじめて重なるのは 90 度回したときです。',
        ],
      },
      value: '90', max_digits: 2,
      notes: 'Original composition in the Math Kangaroo grade 3-4 rotational-symmetry style; the order of symmetry is derived from the number of vertices rather than tested against pictures. Not a reproduction of any past paper.',
    ),
    int_q(
      topic: 'geometry', subtopic: 'rectangle_area',
      prompt: {
        'zh-Hant' => '一個正方形的邊長增加 2 公分之後，面積比原來增加了 20 平方公分。求原來這個正方形的邊長是幾公分。',
        'zh-Hans' => '一个正方形的边长增加 2 厘米之后，面积比原来增加了 20 平方厘米。求原来这个正方形的边长是几厘米。',
        'en' => 'When the side of a square is increased by 2 cm, its area increases by 20 square centimetres. Find the original side length.',
        'ja' => 'ある正方形の 1 辺を 2 cm 長くしたところ、面積はもとより 20 平方センチメートル増えました。もとの正方形の 1 辺の長さは何センチメートルですか。',
      },
      answer: { 'zh-Hant' => '答案是 4 公分。', 'zh-Hans' => '答案是 4 厘米。',
                'en' => 'The answer is 4 centimetres.', 'ja' => '答えは 4 センチメートルです。' },
      steps: {
        'zh-Hant' => [
          '把原來的正方形畫在新正方形的左下角，新增加的部分是一個「L 形」的框。',
          '這個 L 形可以拆成三塊：右邊一條寬 2、長等於原邊長的長方形，上面一條寬 2、長等於原邊長的長方形，以及右上角一個 2 × 2 的小正方形。',
          '所以增加的面積是「原邊長 × 2」兩塊，加上 2 × 2 = 4，也就是 原邊長 × 4 + 4。',
          '題目說增加了 20，所以 原邊長 × 4 + 4 = 20，得到 原邊長 × 4 = 16。',
          '因此原來的邊長是 16 ÷ 4 = 4 公分。',
        ],
        'zh-Hans' => [
          '把原来的正方形画在新正方形的左下角，新增加的部分是一个「L 形」的框。',
          '这个 L 形可以拆成三块：右边一条宽 2、长等于原边长的长方形，上面一条宽 2、长等于原边长的长方形，以及右上角一个 2 × 2 的小正方形。',
          '所以增加的面积是「原边长 × 2」两块，加上 2 × 2 = 4，也就是 原边长 × 4 + 4。',
          '题目说增加了 20，所以 原边长 × 4 + 4 = 20，得到 原边长 × 4 = 16。',
          '因此原来的边长是 16 ÷ 4 = 4 厘米。',
        ],
        'en' => [
          'Draw the original square in the bottom-left corner of the enlarged one; the added part is an L-shaped border.',
          'That L-shape splits into three pieces: a strip of width 2 along the right whose length is the original side, a similar strip along the top, and a 2 × 2 square in the top-right corner.',
          'So the added area is two strips of "original side × 2" plus 2 × 2 = 4, that is original side × 4 + 4.',
          'The increase is 20, so original side × 4 + 4 = 20, giving original side × 4 = 16.',
          'The original side is therefore 16 ÷ 4 = 4 centimetres.',
        ],
        'ja' => [
          'もとの正方形を大きい正方形の左下に置くと、増えた部分は L 字形のふちになります。',
          'この L 字形は 3 つに分けられます。右側の幅 2・長さがもとの 1 辺の長方形、上側の同じ長方形、そして右上の 2 × 2 の正方形です。',
          'よって増えた面積は「もとの 1 辺 × 2」が 2 つ分と 2 × 2 = 4 で、もとの 1 辺 × 4 + 4 です。',
          '増加が 20 なので、もとの 1 辺 × 4 + 4 = 20 となり、もとの 1 辺 × 4 = 16 です。',
          'したがってもとの 1 辺は 16 ÷ 4 = 4 センチメートルです。',
        ],
      },
      value: '4', max_digits: 1,
      notes: 'Original composition in the Math Kangaroo grade 3-4 area style; the increment is decomposed into two strips and a corner square, which turns the problem into a linear equation without needing algebra of squares. Not a reproduction of any past paper.',
    ),
    int_q(
      topic: 'geometry', subtopic: 'composite_area',
      prompt: {
        'zh-Hant' => '一個長方形被一條橫線和一條直線分成 4 個小長方形。已知左上、右上、左下這三塊的面積分別是 6、9、12 平方公分。求右下那一塊的面積是幾平方公分。',
        'zh-Hans' => '一个长方形被一条横线和一条竖线分成 4 个小长方形。已知左上、右上、左下这三块的面积分别是 6、9、12 平方厘米。求右下那一块的面积是几平方厘米。',
        'en' => 'A rectangle is divided by one horizontal and one vertical line into 4 smaller rectangles. The top-left, top-right and bottom-left pieces have areas 6, 9 and 12 square centimetres. Find the area of the bottom-right piece.',
        'ja' => '長方形を横線 1 本と縦線 1 本で 4 つの小さい長方形に分けます。左上、右上、左下の面積がそれぞれ 6、9、12 平方センチメートルのとき、右下の面積は何平方センチメートルですか。',
      },
      answer: { 'zh-Hant' => '答案是 18 平方公分。', 'zh-Hans' => '答案是 18 平方厘米。',
                'en' => 'The answer is 18 square centimetres.', 'ja' => '答えは 18 平方センチメートルです。' },
      steps: {
        'zh-Hant' => [
          '設左邊那一行的寬是 a、右邊那一行的寬是 b，上面那一列的高是 c、下面那一列的高是 d。',
          '四塊的面積分別是：左上 = a × c = 6，右上 = b × c = 9，左下 = a × d = 12，右下 = b × d。',
          '注意左上乘右下等於 a × c × b × d，而右上乘左下也等於 b × c × a × d，兩者其實是同一個乘積。',
          '所以「左上 × 右下 = 右上 × 左下」，也就是 6 × 右下 = 9 × 12 = 108。',
          '因此右下的面積是 108 ÷ 6 = 18 平方公分。（例如 a = 2、b = 3、c = 3、d = 6 就剛好符合。）',
        ],
        'zh-Hans' => [
          '设左边那一列的宽是 a、右边那一列的宽是 b，上面那一行的高是 c、下面那一行的高是 d。',
          '四块的面积分别是：左上 = a × c = 6，右上 = b × c = 9，左下 = a × d = 12，右下 = b × d。',
          '注意左上乘右下等于 a × c × b × d，而右上乘左下也等于 b × c × a × d，两者其实是同一个乘积。',
          '所以「左上 × 右下 = 右上 × 左下」，也就是 6 × 右下 = 9 × 12 = 108。',
          '因此右下的面积是 108 ÷ 6 = 18 平方厘米。（例如 a = 2、b = 3、c = 3、d = 6 就刚好符合。）',
        ],
        'en' => [
          'Let the left column have width a and the right column width b, and let the top row have height c and the bottom row height d.',
          'The four areas are top-left = a × c = 6, top-right = b × c = 9, bottom-left = a × d = 12 and bottom-right = b × d.',
          'Notice that top-left times bottom-right equals a × c × b × d, and top-right times bottom-left equals b × c × a × d, which is the same product.',
          'So top-left × bottom-right = top-right × bottom-left, that is 6 × bottom-right = 9 × 12 = 108.',
          'The bottom-right area is therefore 108 ÷ 6 = 18 square centimetres. (For instance a = 2, b = 3, c = 3, d = 6 fits exactly.)',
        ],
        'ja' => [
          '左の列の幅を a、右の列の幅を b、上の行の高さを c、下の行の高さを d とします。',
          '4 つの面積は、左上 = a × c = 6、右上 = b × c = 9、左下 = a × d = 12、右下 = b × d です。',
          '左上 × 右下 は a × c × b × d、右上 × 左下 も b × c × a × d で、実は同じ積になります。',
          'よって「左上 × 右下 = 右上 × 左下」となり、6 × 右下 = 9 × 12 = 108 です。',
          'したがって右下の面積は 108 ÷ 6 = 18 平方センチメートルです。（たとえば a = 2、b = 3、c = 3、d = 6 がちょうどあてはまります。）',
        ],
      },
      value: '18', max_digits: 2,
      notes: 'Original composition in the Math Kangaroo grade 3-4 area style; the key observation is that the two diagonal products of the four pieces are equal, so no side length ever has to be found. Not a reproduction of any past paper.',
    ),
  ],
  'logic' => [
    int_q(
      topic: 'logic', subtopic: 'arrangement',
      prompt: {
        'zh-Hant' => '甲、乙、丙、丁、戊五個人排成一列照相。規定甲必須站在乙的左邊，但兩人不一定要相鄰。符合這個條件的排法一共有幾種？',
        'zh-Hans' => '甲、乙、丙、丁、戊五个人排成一列照相。规定甲必须站在乙的左边，但两人不一定要相邻。符合这个条件的排法一共有几种？',
        'en' => 'Five people A, B, C, D and E stand in a row for a photograph, with A required to stand somewhere to the left of B, not necessarily next to B. How many arrangements satisfy this?',
        'ja' => '甲、乙、丙、丁、戊の 5 人が一列に並んで写真をとります。甲は乙より左に立たなければなりませんが、となり合う必要はありません。条件に合う並び方は何通りありますか。',
      },
      answer: { 'zh-Hant' => '答案是 60 種。', 'zh-Hans' => '答案是 60 种。',
                'en' => 'The answer is 60 arrangements.', 'ja' => '答えは 60 通りです。' },
      steps: {
        'zh-Hant' => [
          '先不管限制，5 個人排成一列的排法有 5 × 4 × 3 × 2 × 1 = 120 種。',
          '在這 120 種裡面，甲和乙的左右關係只有兩種：甲在乙左邊，或甲在乙右邊。',
          '把任何一種排法中的甲和乙互相對調，就會從其中一種變成另一種，而且是一對一對應。',
          '所以這兩種情況的排法數量一樣多，各佔一半。',
          '因此符合條件的排法有 120 ÷ 2 = 60 種。',
        ],
        'zh-Hans' => [
          '先不管限制，5 个人排成一列的排法有 5 × 4 × 3 × 2 × 1 = 120 种。',
          '在这 120 种里面，甲和乙的左右关系只有两种：甲在乙左边，或甲在乙右边。',
          '把任何一种排法中的甲和乙互相对调，就会从其中一种变成另一种，而且是一对一对应。',
          '所以这两种情况的排法数量一样多，各占一半。',
          '因此符合条件的排法有 120 ÷ 2 = 60 种。',
        ],
        'en' => [
          'Ignoring the restriction, five people can be arranged in a row in 5 × 4 × 3 × 2 × 1 = 120 ways.',
          'Among those 120, A is either to the left of B or to the right of B, and there is no other possibility.',
          'Swapping A and B in any arrangement turns one case into the other, and this pairs the arrangements up one to one.',
          'So the two cases contain equally many arrangements, half each.',
          'The number satisfying the condition is therefore 120 ÷ 2 = 60.',
        ],
        'ja' => [
          '条件を無視すると、5 人を一列に並べる方法は 5 × 4 × 3 × 2 × 1 = 120 通りです。',
          'この 120 通りでは、甲が乙より左か右かのどちらかしかありません。',
          'どの並び方でも甲と乙を入れかえると一方の場合からもう一方に移り、1 対 1 に対応します。',
          'したがって 2 つの場合の数は等しく、それぞれ半分ずつです。',
          'よって条件に合う並び方は 120 ÷ 2 = 60 通りです。',
        ],
      },
      value: '60', max_digits: 2,
      notes: 'Original composition in the Math Kangaroo grade 3-4 arrangement style; the count is halved by a symmetry argument rather than by fixing positions, which no other item in the bank uses. Not a reproduction of any past paper.',
    ),
    int_q(
      topic: 'logic', subtopic: 'grouping_balance',
      prompt: {
        'zh-Hant' => '把 1、2、3、4、5、6、7、8 這八個數分成兩組，使兩組各自的數字和相等，而且規定 8 一定要分在第一組。這樣的分法一共有幾種？（兩組的內容決定分法，第一組是哪一組已由 8 的位置決定。）',
        'zh-Hans' => '把 1、2、3、4、5、6、7、8 这八个数分成两组，使两组各自的数字和相等，而且规定 8 一定要分在第一组。这样的分法一共有几种？（两组的内容决定分法，第一组是哪一组已由 8 的位置决定。）',
        'en' => 'The eight numbers 1 to 8 are split into two groups with equal sums, with 8 required to be in the first group. How many such splits are there? (The split is determined by the contents of the groups, and which group is first is fixed by where 8 goes.)',
        'ja' => '1 から 8 までの 8 つの数を 2 つの組に分け、それぞれの組の数の和を等しくします。ただし 8 は必ず第 1 の組に入れます。このような分け方は何通りありますか。（どちらが第 1 の組かは 8 の位置で決まります。）',
      },
      answer: { 'zh-Hant' => '答案是 7 種。', 'zh-Hans' => '答案是 7 种。',
                'en' => 'The answer is 7 splits.', 'ja' => '答えは 7 通りです。' },
      steps: {
        'zh-Hant' => [
          '八個數的總和是 1 + 2 + ⋯ + 8 = 36，兩組的和要相等，所以每一組的和都是 36 ÷ 2 = 18。',
          '8 already 在第一組，所以第一組還要從 1 到 7 之中挑出一些數，讓它們的和是 18 − 8 = 10。',
          '問題變成：從 1 到 7 中選出若干個數，使它們的和是 10，有幾種選法。',
          '依選出的個數分類：選 2 個的有 3 + 7、4 + 6，共 2 種；選 3 個的有 1 + 2 + 7、1 + 3 + 6、1 + 4 + 5、2 + 3 + 5，共 4 種；選 4 個的有 1 + 2 + 3 + 4，共 1 種。',
          '選 1 個湊不出 10，選 5 個以上最小的和已超過 10。所以合計 2 + 4 + 1 = 7 種。',
        ],
        'zh-Hans' => [
          '八个数的总和是 1 + 2 + ⋯ + 8 = 36，两组的和要相等，所以每一组的和都是 36 ÷ 2 = 18。',
          '8 已经在第一组，所以第一组还要从 1 到 7 之中挑出一些数，让它们的和是 18 − 8 = 10。',
          '问题变成：从 1 到 7 中选出若干个数，使它们的和是 10，有几种选法。',
          '依选出的个数分类：选 2 个的有 3 + 7、4 + 6，共 2 种；选 3 个的有 1 + 2 + 7、1 + 3 + 6、1 + 4 + 5、2 + 3 + 5，共 4 种；选 4 个的有 1 + 2 + 3 + 4，共 1 种。',
          '选 1 个凑不出 10，选 5 个以上最小的和已超过 10。所以合计 2 + 4 + 1 = 7 种。',
        ],
        'en' => [
          'The eight numbers total 1 + 2 + ⋯ + 8 = 36, and equal sums mean each group totals 36 ÷ 2 = 18.',
          'Since 8 is already in the first group, the rest of that group must be chosen from 1 to 7 with sum 18 − 8 = 10.',
          'The question becomes: how many ways are there to choose numbers from 1 to 7 with sum 10.',
          'Sorting by how many are chosen: two numbers give 3 + 7 and 4 + 6, which is 2 ways; three numbers give 1 + 2 + 7, 1 + 3 + 6, 1 + 4 + 5 and 2 + 3 + 5, which is 4 ways; four numbers give 1 + 2 + 3 + 4, which is 1 way.',
          'A single number cannot reach 10, and five or more numbers already exceed 10 at their smallest. So the total is 2 + 4 + 1 = 7.',
        ],
        'ja' => [
          '8 つの数の合計は 1 + 2 + ⋯ + 8 = 36 で、和を等しくするので各組の和は 36 ÷ 2 = 18 です。',
          '8 はすでに第 1 の組にあるので、残りは 1 から 7 の中から和が 18 − 8 = 10 になるように選びます。',
          'つまり問題は、1 から 7 の中から和が 10 になる選び方が何通りあるか、ということです。',
          '選ぶ個数で分けると、2 個は 3 + 7 と 4 + 6 の 2 通り、3 個は 1 + 2 + 7、1 + 3 + 6、1 + 4 + 5、2 + 3 + 5 の 4 通り、4 個は 1 + 2 + 3 + 4 の 1 通りです。',
          '1 個では 10 に届かず、5 個以上では最小でも 10 をこえます。よって合計 2 + 4 + 1 = 7 通りです。',
        ],
      },
      value: '7', max_digits: 1,
      notes: 'Original composition in the Math Kangaroo grade 3-4 partition style; fixing where 8 goes removes the double counting of the two groups, and the remaining search is organised by how many numbers are chosen. Not a reproduction of any past paper.',
    ),
  ],
  'arithmetic' => [
    int_q(
      topic: 'arithmetic', subtopic: 'unit_rate',
      prompt: {
        'zh-Hant' => '一列火車長 200 公尺，以每秒 20 公尺的速度通過一座長 300 公尺的橋。從車頭剛上橋開始算起，到車尾完全離開橋為止，一共需要幾秒？',
        'zh-Hans' => '一列火车长 200 米，以每秒 20 米的速度通过一座长 300 米的桥。从车头刚上桥开始算起，到车尾完全离开桥为止，一共需要几秒？',
        'en' => 'A train 200 metres long crosses a bridge 300 metres long at 20 metres per second. Counting from the moment the front of the train reaches the bridge until the rear of the train leaves it, how many seconds does this take?',
        'ja' => '長さ 200 m の列車が、長さ 300 m の橋を秒速 20 m で通過します。先頭が橋にさしかかった瞬間から、最後尾が橋を completely 渡りきるまでに何秒かかりますか。',
      },
      answer: { 'zh-Hant' => '答案是 25 秒。', 'zh-Hans' => '答案是 25 秒。',
                'en' => 'The answer is 25 seconds.', 'ja' => '答えは 25 秒です。' },
      steps: {
        'zh-Hant' => [
          '關鍵是想清楚火車實際走了多遠，不能只算橋長。',
          '車頭剛上橋時，車尾還在橋前面 200 公尺處；車尾完全離開橋時，車尾剛好在橋的另一端。',
          '所以車尾一共前進了「橋長加上車長」的距離，也就是 300 + 200 = 500 公尺。',
          '火車每秒走 20 公尺，走完 500 公尺需要 500 ÷ 20 = 25 秒。',
        ],
        'zh-Hans' => [
          '关键是想清楚火车实际走了多远，不能只算桥长。',
          '车头刚上桥时，车尾还在桥前面 200 米处；车尾完全离开桥时，车尾刚好在桥的另一端。',
          '所以车尾一共前进了「桥长加上车长」的距离，也就是 300 + 200 = 500 米。',
          '火车每秒走 20 米，走完 500 米需要 500 ÷ 20 = 25 秒。',
        ],
        'en' => [
          'The key is to work out how far the train really travels, which is not just the length of the bridge.',
          'When the front reaches the bridge the rear is still 200 metres before it, and when the rear leaves the bridge it is exactly at the far end.',
          'So the rear travels the length of the bridge plus the length of the train, that is 300 + 200 = 500 metres.',
          'At 20 metres per second, covering 500 metres takes 500 ÷ 20 = 25 seconds.',
        ],
        'ja' => [
          'かぎになるのは列車が実際に進む距離で、橋の長さだけではありません。',
          '先頭が橋にさしかかったとき最後尾は橋の手前 200 m にあり、最後尾が橋を渡りきったときは橋の反対のはしにあります。',
          'したがって最後尾は「橋の長さ＋列車の長さ」、つまり 300 + 200 = 500 m 進みます。',
          '秒速 20 m なので、500 m には 500 ÷ 20 = 25 秒かかります。',
        ],
      },
      value: '25', max_digits: 2,
      notes: 'Original composition in the classic train-crossing style used at Math Kangaroo grade 3-4 level; the distance travelled is the bridge plus the train, which is the whole point of the item. Not a reproduction of any past paper.',
    ),
    int_q(
      topic: 'arithmetic', subtopic: 'digit_place_value',
      prompt: {
        'zh-Hant' => '有一些兩位數，它們的十位數字和個位數字加起來剛好是 10。這樣的兩位數一共有幾個？',
        'zh-Hans' => '有一些两位数，它们的十位数字和个位数字加起来刚好是 10。这样的两位数一共有几个？',
        'en' => 'Some two-digit numbers have a tens digit and a units digit that add up to exactly 10. How many such two-digit numbers are there?',
        'ja' => '2 けたの数のうち、十の位の数字と一の位の数字をたすとちょうど 10 になるものがあります。そのような 2 けたの数は何個ありますか。',
      },
      answer: { 'zh-Hant' => '答案是 9 個。', 'zh-Hans' => '答案是 9 个。',
                'en' => 'The answer is 9 numbers.', 'ja' => '答えは 9 個です。' },
      steps: {
        'zh-Hant' => [
          '兩位數的十位數字不能是 0，所以十位可以是 1 到 9。',
          '十位決定之後，個位就被固定成 10 減去十位。',
          '要檢查個位是不是合法的數字（0 到 9）：十位是 1 時個位是 9，十位是 9 時個位是 1，都在範圍內。',
          '十位從 1 一路到 9，個位分別是 9、8、7、6、5、4、3、2、1，全部都合法。',
          '所以這樣的兩位數是 19、28、37、46、55、64、73、82、91，一共 9 個。',
        ],
        'zh-Hans' => [
          '两位数的十位数字不能是 0，所以十位可以是 1 到 9。',
          '十位决定之后，个位就被固定成 10 减去十位。',
          '要检查个位是不是合法的数字（0 到 9）：十位是 1 时个位是 9，十位是 9 时个位是 1，都在范围内。',
          '十位从 1 一路到 9，个位分别是 9、8、7、6、5、4、3、2、1，全部都合法。',
          '所以这样的两位数是 19、28、37、46、55、64、73、82、91，一共 9 个。',
        ],
        'en' => [
          'The tens digit of a two-digit number cannot be 0, so it runs from 1 to 9.',
          'Once the tens digit is chosen, the units digit is forced to be 10 minus it.',
          'It remains to check that the units digit is a legal digit from 0 to 9: a tens digit of 1 gives units 9, and a tens digit of 9 gives units 1, both in range.',
          'As the tens digit runs from 1 to 9, the units digits are 9, 8, 7, 6, 5, 4, 3, 2 and 1, all legal.',
          'So the numbers are 19, 28, 37, 46, 55, 64, 73, 82 and 91, which is 9 numbers.',
        ],
        'ja' => [
          '2 けたの数の十の位は 0 にできないので、1 から 9 までです。',
          '十の位が決まると、一の位は 10 から十の位を引いた数に決まります。',
          'その一の位が 0 から 9 の正しい数字かを確かめます。十の位が 1 なら一の位は 9、十の位が 9 なら一の位は 1 で、どちらも範囲内です。',
          '十の位が 1 から 9 と変わると、一の位は 9、8、7、6、5、4、3、2、1 となり、すべて正しい数字です。',
          'したがって該当する数は 19、28、37、46、55、64、73、82、91 の 9 個です。',
        ],
      },
      value: '9', max_digits: 1,
      notes: 'Original composition in the Math Kangaroo grade 3-4 place-value style; the count follows from one digit determining the other, with a range check that no case is lost. Not a reproduction of any past paper.',
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
