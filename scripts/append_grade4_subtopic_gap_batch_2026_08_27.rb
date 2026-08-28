#!/usr/bin/env ruby
# frozen_string_literal: true

# grade4 subtopic 缺口補題（2026-08-27）
#   geometry  : shape_cutting(直線分割最多區域) / angle_sum_polygon(逆推邊數)
#               paper_folding(缺口跨摺線) / isosceles(唯一性排除)
#   logic     : truth_and_lie(至少/至多) / cyclic_counting(繞圈淘汰) / minimal_number(重疊下界)
#   arithmetic: average_reasoning / page_numbering(逆推頁數) / lcm_schedule

require 'json'
require 'set'

ROOT = File.expand_path('..', __dir__)
GRADE = 'grade4'
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
      topic: 'geometry', subtopic: 'shape_cutting',
      prompt: {
        'zh-Hant' => '一張正方形的紙上畫 3 條直線，每條直線都要從紙的一邊畫到另一邊，把紙分成好幾塊。如果直線的位置可以自由選擇，這張紙最多可以被分成幾塊？',
        'zh-Hans' => '一张正方形的纸上画 3 条直线，每条直线都要从纸的一边画到另一边，把纸分成好几块。如果直线的位置可以自由选择，这张纸最多可以被分成几块？',
        'en' => 'Three straight lines are drawn on a square sheet of paper, each line running from one edge of the sheet to another and cutting the sheet into pieces. If the lines may be placed freely, into at most how many pieces can the sheet be divided?',
        'ja' => '正方形の紙に直線を 3 本引きます。どの直線も紙のふちからふちまで引き、紙をいくつかの部分に分けます。直線の位置を自由に決めてよいとき、紙は最も多くていくつの部分に分けられますか。',
      },
      answer: { 'zh-Hant' => '答案是 7 塊。', 'zh-Hans' => '答案是 7 块。',
                'en' => 'The answer is 7 pieces.', 'ja' => '答えは 7 個です。' },
      steps: {
        'zh-Hant' => [
          '沒有畫線時，紙是完整的 1 塊。',
          '畫第 1 條線，一定把 1 塊切成 2 塊，增加 1 塊。',
          '畫第 2 條線時，若讓它和第 1 條線相交，它會被交點分成 2 段，每一段各切開一塊，所以增加 2 塊，變成 4 塊。',
          '畫第 3 條線時，若讓它和前兩條線都相交、而且三線不共點，它會被 2 個交點分成 3 段，增加 3 塊。',
          '所以最多是 1 + 1 + 2 + 3 = 7 塊。',
        ],
        'zh-Hans' => [
          '没有画线时，纸是完整的 1 块。',
          '画第 1 条线，一定把 1 块切成 2 块，增加 1 块。',
          '画第 2 条线时，若让它和第 1 条线相交，它会被交点分成 2 段，每一段各切开一块，所以增加 2 块，变成 4 块。',
          '画第 3 条线时，若让它和前两条线都相交、而且三线不共点，它会被 2 个交点分成 3 段，增加 3 块。',
          '所以最多是 1 + 1 + 2 + 3 = 7 块。',
        ],
        'en' => [
          'With no lines drawn the sheet is a single piece.',
          'The first line always cuts that piece into 2, adding 1 piece.',
          'If the second line crosses the first, the crossing point splits it into 2 parts, each cutting one region open, so it adds 2 pieces, giving 4.',
          'If the third line crosses both earlier lines and the three lines do not all meet at one point, two crossing points split it into 3 parts, so it adds 3 pieces.',
          'The maximum is therefore 1 + 1 + 2 + 3 = 7 pieces.',
        ],
        'ja' => [
          '線を引かないとき、紙は 1 個のままです。',
          '1 本目の線は必ず 1 個を 2 個に分けるので、1 個ふえます。',
          '2 本目を 1 本目と交わるように引くと、交点で 2 つの部分に分かれ、それぞれが領域を切るので 2 個ふえて 4 個になります。',
          '3 本目を前の 2 本の両方と交わり、しかも 3 本が 1 点で交わらないように引くと、2 つの交点で 3 つの部分に分かれ、3 個ふえます。',
          'したがって最も多いときは 1 + 1 + 2 + 3 = 7 個です。',
        ],
      },
      value: '7', max_digits: 1, figure: figure_none,
      source: src('geometry-grade4-foundation',
        'Original composition in the Math Kangaroo grade 3-4 maximal-regions style; the solver must reason about how many new regions each additional line can create, not count a fixed picture. A figure would fix one particular arrangement and undercut the maximisation, so none is attached. Not a reproduction of any past paper.'),
    ),
    int_q(
      topic: 'geometry', subtopic: 'angle_sum_polygon',
      prompt: {
        'zh-Hant' => '一個多邊形所有內角加起來一共是 720 度。這個多邊形有幾條邊？',
        'zh-Hans' => '一个多边形所有内角加起来一共是 720 度。这个多边形有几条边？',
        'en' => 'All the interior angles of a polygon add up to 720 degrees. How many sides does the polygon have?',
        'ja' => 'ある多角形の内角をすべてたすと 720 度になります。この多角形の辺は何本ですか。',
      },
      answer: { 'zh-Hant' => '答案是 6 條邊。', 'zh-Hans' => '答案是 6 条边。',
                'en' => 'The answer is 6 sides.', 'ja' => '答えは 6 本です。' },
      steps: {
        'zh-Hant' => [
          '從多邊形的一個頂點拉對角線，可以把它分成好幾個三角形。',
          '如果多邊形有 n 條邊，這樣會分出 n − 2 個三角形，每個三角形的內角和是 180 度。',
          '所以內角總和是 (n − 2) × 180 度，題目說這個總和是 720 度。',
          '由 720 ÷ 180 = 4 可知 n − 2 = 4，所以 n = 6，這個多邊形有 6 條邊。',
        ],
        'zh-Hans' => [
          '从多边形的一个顶点拉对角线，可以把它分成好几个三角形。',
          '如果多边形有 n 条边，这样会分出 n − 2 个三角形，每个三角形的内角和是 180 度。',
          '所以内角总和是 (n − 2) × 180 度，题目说这个总和是 720 度。',
          '由 720 ÷ 180 = 4 可知 n − 2 = 4，所以 n = 6，这个多边形有 6 条边。',
        ],
        'en' => [
          'Drawing all diagonals from one vertex splits a polygon into triangles.',
          'A polygon with n sides is split into n − 2 triangles, and each triangle has an angle sum of 180 degrees.',
          'So the interior angles add up to (n − 2) × 180 degrees, and the problem says that total is 720 degrees.',
          'Since 720 ÷ 180 = 4, we get n − 2 = 4, so n = 6 and the polygon has 6 sides.',
        ],
        'ja' => [
          '多角形の 1 つの頂点から対角線を引くと、いくつかの三角形に分けられます。',
          '辺が n 本の多角形は n − 2 個の三角形に分かれ、三角形 1 個の内角の和は 180 度です。',
          'したがって内角の総和は (n − 2) × 180 度で、問題ではそれが 720 度です。',
          '720 ÷ 180 = 4 より n − 2 = 4 なので n = 6 となり、辺は 6 本です。',
        ],
      },
      value: '6', max_digits: 1, figure: figure_none,
      source: src('geometry-grade4-foundation',
        'Original composition in the Math Kangaroo grade 3-4 polygon-angle style; the angle-sum relation is used backwards to recover the number of sides. Not a reproduction of any past paper.'),
    ),
    int_q(
      topic: 'geometry', subtopic: 'paper_folding',
      prompt: {
        'zh-Hant' => '一張正方形色紙，先上下對摺，再左右對摺，摺成一個小正方形。這個小正方形有兩條邊是摺線摺出來的邊，另外兩條邊是原本紙的邊。小安在「左右對摺」摺出來的那條邊的正中間，剪掉一個小小的半圓形缺口，缺口只跨在這條摺邊上，沒有碰到小正方形的其他邊。把色紙完全攤開後，紙上一共有幾個洞？',
        'zh-Hans' => '一张正方形色纸，先上下对折，再左右对折，折成一个小正方形。这个小正方形有两条边是折线折出来的边，另外两条边是原本纸的边。小安在「左右对折」折出来的那条边的正中间，剪掉一个小小的半圆形缺口，缺口只跨在这条折边上，没有碰到小正方形的其他边。把色纸完全摊开后，纸上一共有几个洞？',
        'en' => 'A square sheet of paper is folded top to bottom and then left to right, making a small square. Two sides of that small square are folded edges and the other two are original edges of the paper. A small semicircular notch is cut at the middle of the folded edge created by the left-to-right fold; the notch lies only on that folded edge and touches no other side of the small square. After the paper is unfolded completely, how many holes are there altogether?',
        'ja' => '正方形の色紙を上下に折り、次に左右に折って小さい正方形にします。この小さい正方形の 2 辺は折ってできた辺で、残りの 2 辺はもとの紙のふちです。「左右に折って」できた折り目の辺のまん中に、小さな半円形の切りこみを入れます。切りこみはこの折り目の辺だけにかかり、ほかの辺には触れていません。色紙を完全に開いたとき、紙にはあわせて何個の穴がありますか。',
      },
      answer: { 'zh-Hant' => '答案是 2 個。', 'zh-Hans' => '答案是 2 个。',
                'en' => 'The answer is 2 holes.', 'ja' => '答えは 2 個です。' },
      steps: {
        'zh-Hant' => [
          '上下對摺一次變成 2 層，再左右對摺一次變成 2 × 2 = 4 層，所以剪刀一次剪過 4 層紙。',
          '缺口是剪在摺邊上的半個洞，不是完整的洞。',
          '先把「左右對摺」攤開：原本相對的兩個半缺口會沿著摺線合在一起，變成一個完整的洞；此時紙是 2 層，各有 1 個完整的洞。',
          '再把「上下對摺」攤開：因為缺口沒有碰到這條摺線，這 2 個洞不會合併，而是分別留在摺線的上下兩側。',
          '所以攤開後紙上一共有 2 個洞。',
        ],
        'zh-Hans' => [
          '上下对折一次变成 2 层，再左右对折一次变成 2 × 2 = 4 层，所以剪刀一次剪过 4 层纸。',
          '缺口是剪在折边上的半个洞，不是完整的洞。',
          '先把「左右对折」摊开：原本相对的两个半缺口会沿着折线合在一起，变成一个完整的洞；此时纸是 2 层，各有 1 个完整的洞。',
          '再把「上下对折」摊开：因为缺口没有碰到这条折线，这 2 个洞不会合并，而是分别留在折线的上下两侧。',
          '所以摊开后纸上一共有 2 个洞。',
        ],
        'en' => [
          'Folding top to bottom gives 2 layers, and folding left to right gives 2 × 2 = 4 layers, so the scissors cut through 4 layers at once.',
          'The notch is half a hole cut into a folded edge, not a complete hole.',
          'Undo the left-to-right fold first: each facing pair of half notches joins along the crease into one complete hole, leaving 2 layers with 1 complete hole each.',
          'Now undo the top-to-bottom fold: the notch never touched this crease, so the 2 holes do not join and stay on opposite sides of it.',
          'The unfolded sheet therefore has 2 holes altogether.',
        ],
        'ja' => [
          '上下に折ると 2 枚重ね、さらに左右に折ると 2 × 2 = 4 枚重ねになるので、はさみは一度に 4 枚を切ります。',
          '切りこみは折り目の辺に入れた半分の穴で、完全な穴ではありません。',
          'まず左右の折りを開くと、向かい合う半分の切りこみどうしが折り目にそってつながり、完全な穴 1 個になります。このとき紙は 2 枚重ねで、それぞれに完全な穴が 1 個ずつあります。',
          '次に上下の折りを開くと、切りこみはこの折り目に触れていないので 2 個の穴はつながらず、折り目の上下に 1 個ずつ残ります。',
          'したがって開いた紙には穴が全部で 2 個あります。',
        ],
      },
      value: '2', max_digits: 1, figure: figure_none,
      source: src('geometry-grade4-foundation',
        'Original composition in the Math Kangaroo grade 3-4 fold-and-cut style; unlike a fully interior hole, a notch on a crease merges with its mirror image when unfolded, so layer count alone gives the wrong answer. The renderer cannot depict folding, so no figure is attached. Not a reproduction of any past paper.'),
    ),
    int_q(
      topic: 'geometry', subtopic: 'isosceles',
      prompt: {
        'zh-Hant' => '一個等腰三角形的三個內角之中，有一個角是 100 度。另外兩個角之中，比較大的那個角是幾度？',
        'zh-Hans' => '一个等腰三角形的三个内角之中，有一个角是 100 度。另外两个角之中，比较大的那个角是几度？',
        'en' => 'One of the three interior angles of an isosceles triangle is 100 degrees. Of the other two angles, how many degrees is the larger one?',
        'ja' => 'ある二等辺三角形の 3 つの内角のうち、1 つは 100 度です。残りの 2 つの角のうち、大きいほうは何度ですか。',
      },
      answer: { 'zh-Hant' => '答案是 40 度。', 'zh-Hans' => '答案是 40 度。',
                'en' => 'The answer is 40 degrees.', 'ja' => '答えは 40 度です。' },
      steps: {
        'zh-Hant' => [
          '等腰三角形有兩個角一樣大，這 100 度的角有可能是那兩個相等的角之一，也有可能是剩下的那個角。',
          '如果 100 度是兩個相等的角之一，那麼光是這兩個角就有 100 + 100 = 200 度，已經超過 180 度，不可能。',
          '所以 100 度一定是剩下的那個角，兩個相等的角合起來是 180 − 100 = 80 度。',
          '兩個相等的角各是 80 ÷ 2 = 40 度，它們一樣大，所以另外兩個角之中比較大的是 40 度。',
        ],
        'zh-Hans' => [
          '等腰三角形有两个角一样大，这 100 度的角有可能是那两个相等的角之一，也有可能是剩下的那个角。',
          '如果 100 度是两个相等的角之一，那么光是这两个角就有 100 + 100 = 200 度，已经超过 180 度，不可能。',
          '所以 100 度一定是剩下的那个角，两个相等的角合起来是 180 − 100 = 80 度。',
          '两个相等的角各是 80 ÷ 2 = 40 度，它们一样大，所以另外两个角之中比较大的是 40 度。',
        ],
        'en' => [
          'An isosceles triangle has two equal angles, and the 100 degree angle could in principle be one of those two or the remaining one.',
          'If 100 degrees were one of the two equal angles, those two alone would give 100 + 100 = 200 degrees, already more than 180, which is impossible.',
          'So the 100 degree angle must be the remaining one, and the two equal angles together make 180 − 100 = 80 degrees.',
          'Each equal angle is 80 ÷ 2 = 40 degrees, and since they are equal, the larger of the other two angles is 40 degrees.',
        ],
        'ja' => [
          '二等辺三角形には等しい角が 2 つあり、100 度の角はその 2 つのうちの 1 つかもしれないし、残りの角かもしれません。',
          'もし 100 度が等しい 2 つの角の 1 つなら、その 2 つだけで 100 + 100 = 200 度となり、180 度をこえるので不可能です。',
          'よって 100 度は残りの角に決まり、等しい 2 つの角の和は 180 − 100 = 80 度です。',
          '等しい角はそれぞれ 80 ÷ 2 = 40 度で、2 つとも同じ大きさなので、残り 2 つのうち大きいほうは 40 度です。',
        ],
      },
      value: '40', max_digits: 2, figure: figure_none,
      source: src('geometry-grade4-foundation',
        'Original composition in the Math Kangaroo grade 3-4 isosceles style; the case where the given angle is a base angle must be ruled out by contradiction before computing. Not a reproduction of any past paper.'),
    ),
  ],
  'logic' => [
    int_q(
      topic: 'logic', subtopic: 'truth_and_lie',
      prompt: {
        'zh-Hant' => '甲、乙、丙三個人，每個人不是永遠說真話，就是永遠說謊話。甲說：「我們三個人裡至少有一個人說謊。」乙說：「我們三個人裡最多只有一個人說謊。」丙說：「乙在說謊。」這三個人裡說謊的有幾個人？',
        'zh-Hans' => '甲、乙、丙三个人，每个人不是永远说真话，就是永远说谎话。甲说：「我们三个人里至少有一个人说谎。」乙说：「我们三个人里最多只有一个人说谎。」丙说：「乙在说谎。」这三个人里说谎的有几个人？',
        'en' => 'Each of three people, A, B and C, either always tells the truth or always lies. A says: "At least one of the three of us is a liar." B says: "At most one of the three of us is a liar." C says: "B is lying." How many of the three are liars?',
        'ja' => '甲、乙、丙の 3 人は、それぞれつねに本当のことを言うか、つねにうそをつくかのどちらかです。甲は「私たち 3 人のうち少なくとも 1 人はうそつきだ」と言い、乙は「私たち 3 人のうちうそつきは多くても 1 人だ」と言い、丙は「乙はうそをついている」と言いました。3 人のうちうそつきは何人ですか。',
      },
      answer: { 'zh-Hant' => '答案是 1 個人。', 'zh-Hans' => '答案是 1 个人。',
                'en' => 'The answer is 1 person.', 'ja' => '答えは 1 人です。' },
      steps: {
        'zh-Hant' => [
          '先看甲。如果甲說謊，那麼「至少有一個人說謊」就是假的，代表三個人都說真話，但這樣甲又是說真話的，前後矛盾。所以甲一定說真話，而且真的至少有一個人說謊。',
          '再看乙和丙。丙說「乙在說謊」，所以乙和丙一定一個說真話、一個說謊，兩人之中恰好有一個說謊的。',
          '加上已經確定說真話的甲，三個人裡說謊的恰好是 1 個人。',
          '檢查一下：說謊的有 1 個人，乙說的「最多只有一個人說謊」是真的，所以乙說真話、丙說謊，正好符合，所以說謊的有 1 個人。',
        ],
        'zh-Hans' => [
          '先看甲。如果甲说谎，那么「至少有一个人说谎」就是假的，代表三个人都说真话，但这样甲又是说真话的，前后矛盾。所以甲一定说真话，而且真的至少有一个人说谎。',
          '再看乙和丙。丙说「乙在说谎」，所以乙和丙一定一个说真话、一个说谎，两人之中恰好有一个说谎的。',
          '加上已经确定说真话的甲，三个人里说谎的恰好是 1 个人。',
          '检查一下：说谎的有 1 个人，乙说的「最多只有一个人说谎」是真的，所以乙说真话、丙说谎，正好符合，所以说谎的有 1 个人。',
        ],
        'en' => [
          'Start with A. If A were lying, then "at least one of us is a liar" would be false, meaning all three tell the truth, which would make A truthful after all, a contradiction. So A tells the truth and there really is at least one liar.',
          'Now look at B and C. C says "B is lying", so exactly one of B and C tells the truth and the other lies; among those two there is exactly one liar.',
          'Adding A, who has been shown to be truthful, the three people contain exactly 1 liar.',
          'Check: with 1 liar, B\'s statement "at most one of us is a liar" is true, so B is truthful and C is the liar, which fits. The number of liars is 1.',
        ],
        'ja' => [
          'まず甲を考えます。甲がうそつきなら「少なくとも 1 人はうそつきだ」が偽となり、3 人とも正直者になりますが、それでは甲が正直者となり矛盾します。よって甲は正直者で、実際にうそつきは少なくとも 1 人います。',
          '次に乙と丙です。丙は「乙はうそをついている」と言っているので、乙と丙のうち一方が正直者、もう一方がうそつきで、この 2 人の中にうそつきはちょうど 1 人です。',
          '正直者と確定した甲を加えると、3 人のうちうそつきはちょうど 1 人になります。',
          '確かめると、うそつきが 1 人のとき乙の「うそつきは多くても 1 人」は真なので乙は正直者、丙がうそつきとなり条件に合います。よってうそつきは 1 人です。',
        ],
      },
      value: '1', max_digits: 1, figure: figure_none,
      source: src('logic-grade4-foundation',
        'Original composition in the Math Kangaroo grade 3-4 knights-and-liars style; combining an at-least claim with an at-most claim pins the count down to a single consistent assignment, verified by exhausting all eight truth patterns. Not a reproduction of any past paper.'),
    ),
    int_q(
      topic: 'logic', subtopic: 'cyclic_counting',
      prompt: {
        'zh-Hant' => '10 個小朋友圍成一圈，依順時針方向編號 1 到 10。從 1 號開始按順時針方向報數：報到「3」的人就要離開圈子，接著由下一個人重新從「1」開始報數。這樣一直進行到圈子裡只剩下一個人為止。最後留下來的是幾號？',
        'zh-Hans' => '10 个小朋友围成一圈，按顺时针方向编号 1 到 10。从 1 号开始按顺时针方向报数：报到「3」的人就要离开圈子，接着由下一个人重新从「1」开始报数。这样一直进行到圈子里只剩下一个人为止。最后留下来的是几号？',
        'en' => 'Ten children stand in a circle, numbered 1 to 10 clockwise. Counting starts at child 1 and goes clockwise: whoever says "3" leaves the circle, and the next child starts counting again from "1". This continues until only one child is left. Which number is the last child remaining?',
        'ja' => '10 人の子どもが輪になり、時計回りに 1 から 10 の番号がついています。1 番から時計回りに数を唱え、「3」と言った人が輪から出ます。そのあとは次の人がまた「1」から数え直します。これを輪に 1 人だけ残るまで続けます。最後に残るのは何番の子どもですか。',
      },
      answer: { 'zh-Hant' => '答案是 4 號。', 'zh-Hans' => '答案是 4 号。',
                'en' => 'The answer is number 4.', 'ja' => '答えは 4 番です。' },
      steps: {
        'zh-Hant' => [
          '照規則依序把離開的人記下來：第一輪從 1 號報數，3 號、6 號、9 號依序離開。',
          '9 號離開後從 10 號接著報，10 號、1 號、2 號中報到 3 的是 2 號，接著 5 號、8 號也依序離開。',
          '這時圈子裡剩下 1、4、7、10 四個人，從 10 號之後接著報數，離開的是 1 號。',
          '剩下 4、7、10 三人繼續，離開的是 7 號；剩下 4、10 兩人，再離開的是 10 號。',
          '最後圈子裡只剩下 4 號，所以留下來的是 4 號。',
        ],
        'zh-Hans' => [
          '照规则依次把离开的人记下来：第一轮从 1 号报数，3 号、6 号、9 号依次离开。',
          '9 号离开后从 10 号接着报，10 号、1 号、2 号中报到 3 的是 2 号，接着 5 号、8 号也依次离开。',
          '这时圈子里剩下 1、4、7、10 四个人，从 10 号之后接着报数，离开的是 1 号。',
          '剩下 4、7、10 三人继续，离开的是 7 号；剩下 4、10 两人，再离开的是 10 号。',
          '最后圈子里只剩下 4 号，所以留下来的是 4 号。',
        ],
        'en' => [
          'Follow the rule and record who leaves: counting from child 1, the children 3, 6 and 9 leave in turn.',
          'After 9 leaves, counting resumes at 10, so among 10, 1 and 2 it is child 2 who says "3" and leaves; then 5 and 8 leave in the same way.',
          'The circle now holds 1, 4, 7 and 10, and counting continues after 10, so child 1 leaves next.',
          'With 4, 7 and 10 left, child 7 leaves; with 4 and 10 left, child 10 leaves.',
          'Only child 4 remains in the circle, so the last child is number 4.',
        ],
        'ja' => [
          '規則どおりに出る人を順に書き出します。1 番から数え始めると、3 番、6 番、9 番が順に出ます。',
          '9 番が出たあとは 10 番から数え直し、10 番、1 番、2 番のうち「3」と言う 2 番が出ます。続いて 5 番、8 番も同じように出ます。',
          'ここで輪に残るのは 1、4、7、10 の 4 人で、10 番の次から数え、1 番が出ます。',
          '4、7、10 の 3 人になると 7 番が出て、4 と 10 の 2 人になると 10 番が出ます。',
          '輪には 4 番だけが残るので、最後に残るのは 4 番です。',
        ],
      },
      value: '4', max_digits: 2, figure: figure_none,
      source: src('logic-grade4-foundation',
        'Original composition in the Math Kangaroo grade 3-4 counting-out style; the solver must track the circle carefully because the count restarts from the child after the one who left. Not a reproduction of any past paper.'),
    ),
    int_q(
      topic: 'logic', subtopic: 'minimal_number',
      prompt: {
        'zh-Hant' => '一個班有 30 位學生，每個人至少參加美術社和音樂社其中一個社團。參加美術社的有 20 人，參加音樂社的有 18 人。兩個社團都參加的人數，最少可能是幾人？',
        'zh-Hans' => '一个班有 30 位学生，每个人至少参加美术社和音乐社其中一个社团。参加美术社的有 20 人，参加音乐社的有 18 人。两个社团都参加的人数，最少可能是几人？',
        'en' => 'A class of 30 students all join at least one of the art club and the music club. The art club has 20 members and the music club has 18 members. At most how few students can belong to both clubs?',
        'ja' => '30 人のクラスで、全員が美術部と音楽部の少なくとも一方に入っています。美術部は 20 人、音楽部は 18 人です。両方に入っている人数は、最も少なくて何人ですか。',
      },
      answer: { 'zh-Hant' => '答案是 8 人。', 'zh-Hans' => '答案是 8 人。',
                'en' => 'The answer is 8 students.', 'ja' => '答えは 8 人です。' },
      steps: {
        'zh-Hant' => [
          '把兩個社團的人數相加是 20 + 18 = 38 人次。',
          '每個學生至少參加一個社團，所以 30 位學生在這 38 人次裡至少各被算了 1 次。',
          '多出來的 38 − 30 = 8 人次，只可能來自被算了兩次的人，也就是兩個社團都參加的人。',
          '所以兩個社團都參加的人數就是 8 人，最少也不可能比 8 更少。',
        ],
        'zh-Hans' => [
          '把两个社团的人数相加是 20 + 18 = 38 人次。',
          '每个学生至少参加一个社团，所以 30 位学生在这 38 人次里至少各被算了 1 次。',
          '多出来的 38 − 30 = 8 人次，只可能来自被算了两次的人，也就是两个社团都参加的人。',
          '所以两个社团都参加的人数就是 8 人，最少也不可能比 8 更少。',
        ],
        'en' => [
          'Adding the two club sizes gives 20 + 18 = 38 memberships.',
          'Every student joins at least one club, so each of the 30 students is counted at least once inside those 38.',
          'The extra 38 − 30 = 8 memberships can only come from students counted twice, that is, students in both clubs.',
          'So exactly 8 students are in both clubs, and the number cannot be smaller than 8.',
        ],
        'ja' => [
          '2 つの部の人数をたすと 20 + 18 = 38 人分になります。',
          '全員が少なくとも一方に入っているので、30 人はこの 38 人分の中で少なくとも 1 回ずつ数えられています。',
          'はみ出した 38 − 30 = 8 人分は、2 回数えられた人、つまり両方に入っている人からしか出てきません。',
          'したがって両方に入っているのは 8 人で、これより少なくなることはありません。',
        ],
      },
      value: '8', max_digits: 2, figure: figure_none,
      source: src('logic-grade4-foundation',
        'Original composition in the Math Kangaroo grade 3-4 overlapping-sets style; the question asks for a bound rather than an exact overlap, so the solver must argue why the count cannot be smaller. Not a reproduction of any past paper.'),
    ),
  ],
  'arithmetic' => [
    int_q(
      topic: 'arithmetic', subtopic: 'average_reasoning',
      prompt: {
        'zh-Hant' => '有 5 個數，它們的平均是 12。如果把其中一個數拿掉，剩下 4 個數的平均變成 10。被拿掉的那個數是多少？',
        'zh-Hans' => '有 5 个数，它们的平均是 12。如果把其中一个数拿掉，剩下 4 个数的平均变成 10。被拿掉的那个数是多少？',
        'en' => 'Five numbers have an average of 12. When one of them is removed, the remaining four numbers have an average of 10. What is the number that was removed?',
        'ja' => '5 つの数の平均は 12 です。そのうち 1 つを取り除くと、残り 4 つの数の平均は 10 になります。取り除いた数はいくつですか。',
      },
      answer: { 'zh-Hant' => '答案是 20。', 'zh-Hans' => '答案是 20。', 'en' => 'The answer is 20.', 'ja' => '答えは 20 です。' },
      steps: {
        'zh-Hant' => [
          '平均是 12 的 5 個數，總和是 12 × 5 = 60。',
          '拿掉一個數之後，剩下 4 個數的平均是 10，總和是 10 × 4 = 40。',
          '總和從 60 變成 40，減少的部分就是被拿掉的那個數。',
          '所以被拿掉的數是 60 − 40 = 20。',
        ],
        'zh-Hans' => [
          '平均是 12 的 5 个数，总和是 12 × 5 = 60。',
          '拿掉一个数之后，剩下 4 个数的平均是 10，总和是 10 × 4 = 40。',
          '总和从 60 变成 40，减少的部分就是被拿掉的那个数。',
          '所以被拿掉的数是 60 − 40 = 20。',
        ],
        'en' => [
          'Five numbers with average 12 have total 12 × 5 = 60.',
          'After one is removed, the remaining four have average 10, so their total is 10 × 4 = 40.',
          'The total drops from 60 to 40, and the drop is exactly the number that was removed.',
          'So the removed number is 60 − 40 = 20.',
        ],
        'ja' => [
          '平均が 12 の 5 つの数の合計は 12 × 5 = 60 です。',
          '1 つ取り除いたあと、残り 4 つの平均は 10 なので合計は 10 × 4 = 40 です。',
          '合計が 60 から 40 に減っており、減った分がちょうど取り除いた数です。',
          'したがって取り除いた数は 60 − 40 = 20 です。',
        ],
      },
      value: '20', max_digits: 2, figure: figure_none,
      source: src('arithmetic-grade4-foundation',
        'Original composition in the Math Kangaroo grade 3-4 average style; averages must be converted to totals before the missing value can be recovered. Not a reproduction of any past paper.'),
    ),
    int_q(
      topic: 'arithmetic', subtopic: 'page_numbering',
      prompt: {
        'zh-Hant' => '一本書的頁碼從第 1 頁開始一頁一頁往下編。把所有頁碼上的數字全部數一數，一共用了 33 個數字。這本書一共有幾頁？',
        'zh-Hans' => '一本书的页码从第 1 页开始一页一页往下编。把所有页码上的数字全部数一数，一共用了 33 个数字。这本书一共有几页？',
        'en' => 'The pages of a book are numbered one by one starting from page 1. Counting all the digits used in all the page numbers gives 33 digits in total. How many pages does the book have?',
        'ja' => 'ある本のページ番号は 1 ページから順につけられています。すべてのページ番号に使われている数字を数えると、全部で 33 個でした。この本は全部で何ページありますか。',
      },
      answer: { 'zh-Hant' => '答案是 21 頁。', 'zh-Hans' => '答案是 21 页。',
                'en' => 'The answer is 21 pages.', 'ja' => '答えは 21 ページです。' },
      steps: {
        'zh-Hant' => [
          '第 1 頁到第 9 頁的頁碼都是一位數，一共用了 9 個數字。',
          '33 個數字扣掉這 9 個，還剩下 33 − 9 = 24 個數字。',
          '從第 10 頁開始的頁碼都是兩位數，每一頁用 2 個數字，所以 24 個數字可以編 24 ÷ 2 = 12 頁。',
          '這 12 頁是第 10 頁到第 21 頁，所以這本書一共有 21 頁。',
        ],
        'zh-Hans' => [
          '第 1 页到第 9 页的页码都是一位数，一共用了 9 个数字。',
          '33 个数字扣掉这 9 个，还剩下 33 − 9 = 24 个数字。',
          '从第 10 页开始的页码都是两位数，每一页用 2 个数字，所以 24 个数字可以编 24 ÷ 2 = 12 页。',
          '这 12 页是第 10 页到第 21 页，所以这本书一共有 21 页。',
        ],
        'en' => [
          'Pages 1 to 9 have one-digit numbers and use 9 digits altogether.',
          'Subtracting those from the total leaves 33 − 9 = 24 digits.',
          'From page 10 onwards every page number has two digits, so 24 digits number 24 ÷ 2 = 12 pages.',
          'Those 12 pages are pages 10 to 21, so the book has 21 pages.',
        ],
        'ja' => [
          '1 ページから 9 ページまでのページ番号は 1 けたで、数字を合計 9 個使います。',
          '33 個からその 9 個を引くと、残りは 33 − 9 = 24 個です。',
          '10 ページからのページ番号は 2 けたで 1 ページにつき数字 2 個なので、24 個では 24 ÷ 2 = 12 ページ分になります。',
          'その 12 ページは 10 ページから 21 ページなので、この本は全部で 21 ページです。',
        ],
      },
      value: '21', max_digits: 2, figure: figure_none,
      source: src('arithmetic-grade4-foundation',
        'Original composition in the Math Kangaroo grade 3-4 page-numbering style; the digit total is given and the page count must be recovered by splitting off the one-digit block first. Not a reproduction of any past paper.'),
    ),
    int_q(
      topic: 'arithmetic', subtopic: 'lcm_schedule',
      prompt: {
        'zh-Hant' => '圖書館裡，甲每 3 天去一次，乙每 4 天去一次，丙每 6 天去一次。今天三個人剛好都在圖書館。從明天開始算起的 30 天之內，三個人還會有幾天同時在圖書館？',
        'zh-Hans' => '图书馆里，甲每 3 天去一次，乙每 4 天去一次，丙每 6 天去一次。今天三个人刚好都在图书馆。从明天开始算起的 30 天之内，三个人还会有几天同时在图书馆？',
        'en' => 'At a library, A goes every 3 days, B goes every 4 days and C goes every 6 days. Today all three happen to be at the library. Within the 30 days starting from tomorrow, on how many days will all three be at the library together again?',
        'ja' => '図書館に、甲は 3 日ごと、乙は 4 日ごと、丙は 6 日ごとに行きます。今日はちょうど 3 人とも図書館にいます。明日から数えて 30 日以内に、3 人がそろって図書館にいる日は何日ありますか。',
      },
      answer: { 'zh-Hant' => '答案是 2 天。', 'zh-Hans' => '答案是 2 天。',
                'en' => 'The answer is 2 days.', 'ja' => '答えは 2 日です。' },
      steps: {
        'zh-Hant' => [
          '三個人同時到館的日子，一定同時是 3、4、6 的倍數天之後。',
          '3、4、6 的最小公倍數是 12，所以每隔 12 天三個人才會再同時到館一次。',
          '從明天算起的 30 天之內，符合的是第 12 天和第 24 天。',
          '第 36 天已經超過 30 天，所以三個人同時在圖書館的日子有 2 天。',
        ],
        'zh-Hans' => [
          '三个人同时到馆的日子，一定同时是 3、4、6 的倍数天之后。',
          '3、4、6 的最小公倍数是 12，所以每隔 12 天三个人才会再同时到馆一次。',
          '从明天算起的 30 天之内，符合的是第 12 天和第 24 天。',
          '第 36 天已经超过 30 天，所以三个人同时在图书馆的日子有 2 天。',
        ],
        'en' => [
          'A day when all three visit must be a whole number of 3-day, 4-day and 6-day gaps after today.',
          'The least common multiple of 3, 4 and 6 is 12, so all three meet again only every 12 days.',
          'Within the 30 days starting tomorrow, that happens on day 12 and on day 24.',
          'Day 36 is already beyond 30 days, so there are 2 such days.',
        ],
        'ja' => [
          '3 人がそろう日は、今日から 3 日ごと・4 日ごと・6 日ごとのいずれの区切りにも重なる日です。',
          '3 と 4 と 6 の最小公倍数は 12 なので、3 人がそろうのは 12 日ごとです。',
          '明日から数えて 30 日以内では、12 日目と 24 日目があてはまります。',
          '36 日目は 30 日をこえるので、3 人がそろう日は 2 日です。',
        ],
      },
      value: '2', max_digits: 1, figure: figure_none,
      source: src('arithmetic-grade4-foundation',
        'Original composition in the Math Kangaroo grade 3-4 common-multiple style; three cycles must be combined and then counted inside a bounded window. Not a reproduction of any past paper.'),
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
