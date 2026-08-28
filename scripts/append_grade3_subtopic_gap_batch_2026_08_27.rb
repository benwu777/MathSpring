#!/usr/bin/env ruby
# frozen_string_literal: true

# grade3 subtopic 缺口補題（2026-08-27）
#   geometry  : shape_counting / half_turn / triangle_angles / scale_factor
#   logic     : parity_reasoning(不變量) / mislabeled_boxes(三盒) / multi_condition_arrangement
#   arithmetic: chicken_rabbit / divisibility / age_problem

require 'json'
require 'set'

ROOT = File.expand_path('..', __dir__)
GRADE = 'grade3'
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
      topic: 'geometry', subtopic: 'shape_counting',
      prompt: {
        'zh-Hant' => '一個長方形被格線分成 3 排 2 列，共 6 個一樣大的小正方形。在這個圖中，一共可以找出幾個長方形？（正方形也算長方形，大小不同的都要算。）',
        'zh-Hans' => '一个长方形被格线分成 3 排 2 列，共 6 个一样大的小正方形。在这个图中，一共可以找出几个长方形？（正方形也算长方形，大小不同的都要算。）',
        'en' => 'A rectangle is divided by grid lines into 3 columns and 2 rows, giving 6 identical small squares. How many rectangles can be found in this figure altogether? (Squares count as rectangles, and rectangles of every size must be counted.)',
        'ja' => '長方形が格子の線で 3 列 2 行に分けられ、同じ大きさの小さい正方形が 6 個できています。この図の中に長方形は全部でいくつありますか。（正方形も長方形として数え、大きさのちがうものもすべて数えます。）',
      },
      answer: { 'zh-Hant' => '答案是 18。', 'zh-Hans' => '答案是 18。', 'en' => 'The answer is 18.', 'ja' => '答えは 18 です。' },
      steps: {
        'zh-Hant' => [
          '每一個長方形都是由兩條直的格線和兩條橫的格線圍出來的。',
          '圖中直的格線有 4 條，從中選 2 條的方法有 4 × 3 ÷ 2 = 6 種。',
          '圖中橫的格線有 3 條，從中選 2 條的方法有 3 × 2 ÷ 2 = 3 種。',
          '每一種直線的選法都可以搭配每一種橫線的選法，所以長方形共有 6 × 3 = 18 個。',
        ],
        'zh-Hans' => [
          '每一个长方形都是由两条竖的格线和两条横的格线围出来的。',
          '图中竖的格线有 4 条，从中选 2 条的方法有 4 × 3 ÷ 2 = 6 种。',
          '图中横的格线有 3 条，从中选 2 条的方法有 3 × 2 ÷ 2 = 3 种。',
          '每一种竖线的选法都可以搭配每一种横线的选法，所以长方形共有 6 × 3 = 18 个。',
        ],
        'en' => [
          'Every rectangle is bounded by two vertical grid lines and two horizontal grid lines.',
          'There are 4 vertical grid lines, and 2 of them can be chosen in 4 × 3 ÷ 2 = 6 ways.',
          'There are 3 horizontal grid lines, and 2 of them can be chosen in 3 × 2 ÷ 2 = 3 ways.',
          'Each choice of vertical lines pairs with each choice of horizontal lines, so there are 6 × 3 = 18 rectangles.',
        ],
        'ja' => [
          'どの長方形も、たての格子線 2 本と横の格子線 2 本で囲まれています。',
          'たての格子線は 4 本あり、そこから 2 本を選ぶ方法は 4 × 3 ÷ 2 = 6 通りです。',
          '横の格子線は 3 本あり、そこから 2 本を選ぶ方法は 3 × 2 ÷ 2 = 3 通りです。',
          'たての選び方と横の選び方は自由に組み合わせられるので、長方形は 6 × 3 = 18 個です。',
        ],
      },
      value: '18', max_digits: 2,
      figure: scene(
        'bounds' => { 'minX' => -0.4, 'minY' => -0.4, 'maxX' => 3.4, 'maxY' => 2.4 },
        'points' => [hidden('a0', 0, 0), hidden('a1', 1, 0), hidden('a2', 2, 0), hidden('a3', 3, 0),
                     hidden('b0', 0, 1), hidden('b3', 3, 1),
                     hidden('c0', 0, 2), hidden('c1', 1, 2), hidden('c2', 2, 2), hidden('c3', 3, 2)],
        'segments' => [seg('a0', 'a3'), seg('b0', 'b3'), seg('c0', 'c3'),
                       seg('a0', 'c0'), seg('a1', 'c1'), seg('a2', 'c2'), seg('a3', 'c3')],
      ),
      source: src('geometry-grade3-foundation',
        'Original composition in the Math Kangaroo grade 3-4 rectangle-counting style; the intended insight is choosing two of each family of grid lines rather than counting shapes one by one. Not a reproduction of any past paper.'),
    ),
    mc_q(
      topic: 'geometry', subtopic: 'half_turn',
      prompt: {
        'zh-Hant' => '把一個圖形繞著它的中心轉半圈（180 度）以後，如果看起來和轉之前完全一樣，就說這個圖形有「半圈重合」的性質。下面四個圖形之中，哪一個有這個性質？',
        'zh-Hans' => '把一个图形绕着它的中心转半圈（180 度）以后，如果看起来和转之前完全一样，就说这个图形有「半圈重合」的性质。下面四个图形之中，哪一个有这个性质？',
        'en' => 'If a shape looks exactly the same after being turned half a turn (180 degrees) about its centre, we say it has the half-turn property. Which one of the four shapes below has this property?',
        'ja' => 'ある図形を中心のまわりに半回転（180 度）させたとき、回す前とまったく同じに見えるなら、その図形は「半回転で重なる」性質をもつといいます。次の 4 つの図形のうち、この性質をもつのはどれですか。',
      },
      answer: { 'zh-Hant' => '長方形有這個性質。', 'zh-Hans' => '长方形有这个性质。',
                'en' => 'The rectangle has this property.', 'ja' => '長方形がこの性質をもちます。' },
      steps: {
        'zh-Hant' => [
          '正三角形轉半圈後，原本朝上的尖角會朝下，看起來和原來不一樣。',
          '等腰梯形轉半圈後，原本比較短的上底會跑到下面，看起來也不一樣。',
          '三邊都不一樣長的三角形沒有任何對稱性，轉半圈後當然不一樣。',
          '長方形轉半圈後，對邊互換位置，但長邊仍對長邊、短邊仍對短邊，看起來完全一樣，所以答案是長方形。',
        ],
        'zh-Hans' => [
          '正三角形转半圈后，原本朝上的尖角会朝下，看起来和原来不一样。',
          '等腰梯形转半圈后，原本比较短的上底会跑到下面，看起来也不一样。',
          '三边都不一样长的三角形没有任何对称性，转半圈后当然不一样。',
          '长方形转半圈后，对边互换位置，但长边仍对长边、短边仍对短边，看起来完全一样，所以答案是长方形。',
        ],
        'en' => [
          'After a half turn an equilateral triangle has its upward point facing down, so it does not look the same.',
          'After a half turn an isosceles trapezium has its shorter parallel side at the bottom, so it does not look the same either.',
          'A triangle with three different side lengths has no symmetry at all, so a half turn certainly changes it.',
          'After a half turn a rectangle has its opposite sides swapped, but long sides still match long sides and short sides match short sides, so it looks exactly the same. The answer is the rectangle.',
        ],
        'ja' => [
          '正三角形を半回転させると、上を向いていたとがった角が下を向き、もとと同じには見えません。',
          '等脚台形を半回転させると、短いほうの平行な辺が下にきてしまい、やはり同じには見えません。',
          '3 辺の長さがすべてちがう三角形は対称性がないので、半回転すれば当然ちがって見えます。',
          '長方形を半回転させると向かい合う辺が入れかわりますが、長い辺は長い辺、短い辺は短い辺と重なるのでまったく同じに見えます。答えは長方形です。',
        ],
      },
      options: {
        'A' => { 'zh-Hant' => '正三角形', 'zh-Hans' => '正三角形', 'en' => 'An equilateral triangle', 'ja' => '正三角形' },
        'B' => { 'zh-Hant' => '長方形', 'zh-Hans' => '长方形', 'en' => 'A rectangle', 'ja' => '長方形' },
        'C' => { 'zh-Hant' => '等腰梯形', 'zh-Hans' => '等腰梯形', 'en' => 'An isosceles trapezium', 'ja' => '等脚台形' },
        'D' => { 'zh-Hant' => '三邊都不一樣長的三角形', 'zh-Hans' => '三边都不一样长的三角形',
                 'en' => 'A triangle with three different side lengths', 'ja' => '3 辺の長さがすべてちがう三角形' },
      },
      correct: 'B',
      figure: figure_none,
      source: src('geometry-grade3-foundation',
        'Original composition in the Math Kangaroo grade 3-4 rotational-symmetry style; the distractors are shapes with mirror symmetry but no half-turn symmetry, which is the usual wrong intuition. Drawing the four candidates would let the answer be read off the picture, so no figure is attached. Not a reproduction of any past paper.'),
    ),
    int_q(
      topic: 'geometry', subtopic: 'triangle_angles',
      prompt: {
        'zh-Hant' => '一個三角形的三個角中，有一個角是 60 度。剩下兩個角裡，比較大的那個角剛好是比較小的那個角的 2 倍。比較大的那個角是幾度？',
        'zh-Hans' => '一个三角形的三个角中，有一个角是 60 度。剩下两个角里，比较大的那个角刚好是比较小的那个角的 2 倍。比较大的那个角是几度？',
        'en' => 'One of the three angles of a triangle is 60 degrees. Of the remaining two angles, the larger one is exactly twice the smaller one. How many degrees is the larger of those two angles?',
        'ja' => 'ある三角形の 3 つの角のうち、1 つは 60 度です。残りの 2 つの角のうち、大きいほうはちょうど小さいほうの 2 倍です。大きいほうの角は何度ですか。',
      },
      answer: { 'zh-Hant' => '答案是 80 度。', 'zh-Hans' => '答案是 80 度。',
                'en' => 'The answer is 80 degrees.', 'ja' => '答えは 80 度です。' },
      steps: {
        'zh-Hant' => [
          '三角形三個角的和是 180 度。',
          '已經知道其中一個角是 60 度，所以剩下兩個角合起來是 180 − 60 = 120 度。',
          '剩下兩個角中，大的是小的 2 倍，所以把 120 度看成 1 + 2 = 3 等份。',
          '一等份是 120 ÷ 3 = 40 度，比較大的角是 2 等份，也就是 40 × 2 = 80 度。',
        ],
        'zh-Hans' => [
          '三角形三个角的和是 180 度。',
          '已经知道其中一个角是 60 度，所以剩下两个角合起来是 180 − 60 = 120 度。',
          '剩下两个角中，大的是小的 2 倍，所以把 120 度看成 1 + 2 = 3 等份。',
          '一等份是 120 ÷ 3 = 40 度，比较大的角是 2 等份，也就是 40 × 2 = 80 度。',
        ],
        'en' => [
          'The three angles of a triangle add up to 180 degrees.',
          'One angle is known to be 60 degrees, so the other two together make 180 − 60 = 120 degrees.',
          'The larger of those two is twice the smaller, so 120 degrees is split into 1 + 2 = 3 equal parts.',
          'One part is 120 ÷ 3 = 40 degrees, and the larger angle is 2 parts, that is 40 × 2 = 80 degrees.',
        ],
        'ja' => [
          '三角形の 3 つの角の和は 180 度です。',
          '1 つの角が 60 度とわかっているので、残り 2 つの角の和は 180 − 60 = 120 度です。',
          '残りのうち大きいほうは小さいほうの 2 倍なので、120 度を 1 + 2 = 3 等分と考えます。',
          '1 つ分は 120 ÷ 3 = 40 度で、大きいほうの角は 2 つ分なので 40 × 2 = 80 度です。',
        ],
      },
      value: '80', max_digits: 2, figure: figure_none,
      source: src('geometry-grade3-foundation',
        'Original composition in the Math Kangaroo grade 3-4 angle style; the angle sum must be combined with a ratio split rather than read off directly. Not a reproduction of any past paper.'),
    ),
    int_q(
      topic: 'geometry', subtopic: 'scale_factor',
      prompt: {
        'zh-Hant' => '有一個長方形。把它的長變成原來的 2 倍，寬也變成原來的 2 倍，做出一個新的長方形。新長方形的面積是原來長方形面積的幾倍？',
        'zh-Hans' => '有一个长方形。把它的长变成原来的 2 倍，宽也变成原来的 2 倍，做出一个新的长方形。新长方形的面积是原来长方形面积的几倍？',
        'en' => 'A rectangle is enlarged so that its length becomes twice the original length and its width also becomes twice the original width. The area of the new rectangle is how many times the area of the original rectangle?',
        'ja' => 'ある長方形の縦を 2 倍、横も 2 倍にして、新しい長方形を作ります。新しい長方形の面積は、もとの長方形の面積の何倍ですか。',
      },
      answer: { 'zh-Hant' => '答案是 4 倍。', 'zh-Hans' => '答案是 4 倍。',
                'en' => 'The answer is 4 times.', 'ja' => '答えは 4 倍です。' },
      steps: {
        'zh-Hant' => [
          '長方形的面積等於長乘以寬。',
          '新長方形的長是原來的 2 倍，寬也是原來的 2 倍。',
          '所以新面積等於「2 倍的長」乘以「2 倍的寬」，比原來多乘了 2 × 2。',
          '因此新長方形的面積是原來的 4 倍，不是 2 倍。',
        ],
        'zh-Hans' => [
          '长方形的面积等于长乘以宽。',
          '新长方形的长是原来的 2 倍，宽也是原来的 2 倍。',
          '所以新面积等于「2 倍的长」乘以「2 倍的宽」，比原来多乘了 2 × 2。',
          '因此新长方形的面积是原来的 4 倍，不是 2 倍。',
        ],
        'en' => [
          'The area of a rectangle is its length multiplied by its width.',
          'The new rectangle has twice the length and also twice the width.',
          'So the new area is twice the length multiplied by twice the width, which brings in an extra factor of 2 × 2.',
          'The new rectangle therefore has 4 times the original area, not 2 times.',
        ],
        'ja' => [
          '長方形の面積は縦 × 横で求められます。',
          '新しい長方形は縦がもとの 2 倍、横ももとの 2 倍です。',
          'したがって新しい面積は「2 倍の縦」×「2 倍の横」となり、もとより 2 × 2 だけ多くかけることになります。',
          'よって新しい長方形の面積はもとの 4 倍で、2 倍ではありません。',
        ],
      },
      value: '4', max_digits: 1, figure: figure_none,
      source: src('geometry-grade3-foundation',
        'Original composition in the Math Kangaroo grade 3-4 scaling style; the wrong intuition of answering 2 is the point of the item. Not a reproduction of any past paper.'),
    ),
  ],
  'logic' => [
    mc_q(
      topic: 'logic', subtopic: 'parity_reasoning',
      prompt: {
        'zh-Hant' => '桌上有 7 個杯子，一開始全部都是杯口朝上。每一次操作必須同時把其中剛好 2 個杯子翻面（朝上的變朝下，朝下的變朝上）。不論做幾次這樣的操作，有沒有可能讓 7 個杯子全部變成杯口朝下？',
        'zh-Hans' => '桌上有 7 个杯子，一开始全部都是杯口朝上。每一次操作必须同时把其中刚好 2 个杯子翻面（朝上的变朝下，朝下的变朝上）。不论做几次这样的操作，有没有可能让 7 个杯子全部变成杯口朝下？',
        'en' => 'Seven cups stand on a table, all of them mouth up at the start. Each move must turn over exactly 2 of the cups at the same time (a cup that is up becomes down, and a cup that is down becomes up). However many moves are made, is it possible to get all 7 cups mouth down?',
        'ja' => '机の上にコップが 7 個あり、はじめはすべて口が上を向いています。1 回の操作では、ちょうど 2 個のコップを同時にひっくり返さなければなりません（上向きは下向きに、下向きは上向きになります）。何回操作しても、7 個すべてを口が下向きにすることはできるでしょうか。',
      },
      answer: { 'zh-Hant' => '不可能，因為朝上的杯子數目一直保持單數。',
                'zh-Hans' => '不可能，因为朝上的杯子数目一直保持单数。',
                'en' => 'It is impossible, because the number of cups facing up always stays odd.',
                'ja' => 'できません。上を向いているコップの数がつねに奇数のままだからです。' },
      steps: {
        'zh-Hant' => [
          '一開始朝上的杯子有 7 個，7 是單數。',
          '每次翻 2 個杯子，可能是「兩個都從朝上變朝下」，朝上的數目減少 2；也可能是「兩個都從朝下變朝上」，朝上的數目增加 2；還可能是「一上一下互換」，朝上的數目不變。',
          '這三種情況都只會讓朝上的數目改變 2 或不變，所以單數永遠還是單數。',
          '全部朝下時朝上的杯子是 0 個，0 是雙數，永遠達不到，所以不可能。',
        ],
        'zh-Hans' => [
          '一开始朝上的杯子有 7 个，7 是单数。',
          '每次翻 2 个杯子，可能是「两个都从朝上变朝下」，朝上的数目减少 2；也可能是「两个都从朝下变朝上」，朝上的数目增加 2；还可能是「一上一下互换」，朝上的数目不变。',
          '这三种情况都只会让朝上的数目改变 2 或不变，所以单数永远还是单数。',
          '全部朝下时朝上的杯子是 0 个，0 是双数，永远达不到，所以不可能。',
        ],
        'en' => [
          'At the start 7 cups face up, and 7 is odd.',
          'Turning 2 cups can send two up-cups down, lowering the count by 2; or send two down-cups up, raising it by 2; or swap one of each, leaving the count unchanged.',
          'In every case the number facing up changes by 2 or not at all, so an odd count stays odd forever.',
          'All cups down means 0 cups facing up, and 0 is even, so that state can never be reached. It is impossible.',
        ],
        'ja' => [
          'はじめに上を向いているコップは 7 個で、7 は奇数です。',
          '2 個をひっくり返すとき、上向き 2 個を下向きにすれば上向きの数は 2 減り、下向き 2 個を上向きにすれば 2 増え、上下 1 個ずつなら数は変わりません。',
          'どの場合も上向きの数は 2 だけ変わるか変わらないので、奇数はずっと奇数のままです。',
          'すべて下向きのとき上向きは 0 個で、0 は偶数なので決して到達できません。よってできません。',
        ],
      },
      options: {
        'A' => { 'zh-Hant' => '不可能，因為朝上的杯子數目一直是單數', 'zh-Hans' => '不可能，因为朝上的杯子数目一直是单数',
                 'en' => 'Impossible, because the number facing up always stays odd', 'ja' => 'できない。上向きの数がつねに奇数のままだから' },
        'B' => { 'zh-Hant' => '可能，只要翻的次數夠多就行', 'zh-Hans' => '可能，只要翻的次数够多就行',
                 'en' => 'Possible, as long as enough moves are made', 'ja' => 'できる。回数を十分に多くすればよい' },
        'C' => { 'zh-Hant' => '可能，剛好翻 7 次就行', 'zh-Hans' => '可能，刚好翻 7 次就行',
                 'en' => 'Possible, by making exactly 7 moves', 'ja' => 'できる。ちょうど 7 回操作すればよい' },
        'D' => { 'zh-Hant' => '不可能，因為杯子的總數是單數', 'zh-Hans' => '不可能，因为杯子的总数是单数',
                 'en' => 'Impossible, because the total number of cups is odd', 'ja' => 'できない。コップの総数が奇数だから' },
      },
      correct: 'A',
      figure: figure_none,
      source: src('logic-grade3-foundation',
        'Original composition in the Math Kangaroo grade 3-4 invariant style; option D states the right verdict with the wrong reason, so the item tests the parity invariant itself rather than a yes/no guess. Not a reproduction of any past paper.'),
    ),
    mc_q(
      topic: 'logic', subtopic: 'mislabeled_boxes',
      prompt: {
        'zh-Hant' => '三個不透明的盒子裡，一個裝 2 顆紅球，一個裝 2 顆藍球，一個裝 1 顆紅球和 1 顆藍球。三個盒子上分別貼著「紅紅」、「藍藍」、「紅藍」三張標籤，但老師說每一張標籤都貼錯了。現在只能從其中一個盒子裡摸出 1 顆球來看顏色，就要判斷出三個盒子裡各裝什麼。應該從貼著哪一張標籤的盒子摸球？',
        'zh-Hans' => '三个不透明的盒子里，一个装 2 颗红球，一个装 2 颗蓝球，一个装 1 颗红球和 1 颗蓝球。三个盒子上分别贴着「红红」、「蓝蓝」、「红蓝」三张标签，但老师说每一张标签都贴错了。现在只能从其中一个盒子里摸出 1 颗球来看颜色，就要判断出三个盒子里各装什么。应该从贴着哪一张标签的盒子摸球？',
        'en' => 'Three opaque boxes contain, in some order, 2 red balls, 2 blue balls, and 1 red ball with 1 blue ball. The boxes carry the labels "red red", "blue blue" and "red blue", but the teacher says every label is wrong. Only one ball may be drawn from one box to see its colour, and from that the contents of all three boxes must be determined. Which labelled box should the ball be drawn from?',
        'ja' => '中の見えない箱が 3 つあり、それぞれ赤玉 2 個、青玉 2 個、赤玉 1 個と青玉 1 個のいずれかが入っています。3 つの箱には「赤赤」「青青」「赤青」のラベルがはられていますが、先生によるとどのラベルもまちがっています。1 つの箱から玉を 1 個だけ取り出して色を見て、3 つの箱の中身をすべて言い当てたいと思います。どのラベルの箱から取り出せばよいですか。',
      },
      answer: { 'zh-Hant' => '應該從貼著「紅藍」標籤的盒子摸球。',
                'zh-Hans' => '应该从贴着「红蓝」标签的盒子摸球。',
                'en' => 'The ball should be drawn from the box labelled "red blue".',
                'ja' => '「赤青」のラベルの箱から取り出せばよいです。' },
      steps: {
        'zh-Hant' => [
          '因為所有標籤都貼錯，貼著「紅藍」的盒子裡一定不是一紅一藍，只能是 2 顆紅球或 2 顆藍球。',
          '從這個盒子摸出 1 顆球，摸到什麼顏色，這盒就是那個顏色的兩顆，內容立刻確定。',
          '假設摸到紅球，這盒是「紅紅」；那麼貼著「藍藍」的盒子既不能是藍藍，也不能是已經用掉的紅紅，只能是一紅一藍。',
          '剩下貼著「紅紅」的盒子就是藍藍。若摸到藍球，同樣的推理也能把三盒都確定，所以答案是貼著「紅藍」的盒子。',
        ],
        'zh-Hans' => [
          '因为所有标签都贴错，贴着「红蓝」的盒子里一定不是一红一蓝，只能是 2 颗红球或 2 颗蓝球。',
          '从这个盒子摸出 1 颗球，摸到什么颜色，这盒就是那个颜色的两颗，内容立刻确定。',
          '假设摸到红球，这盒是「红红」；那么贴着「蓝蓝」的盒子既不能是蓝蓝，也不能是已经用掉的红红，只能是一红一蓝。',
          '剩下贴着「红红」的盒子就是蓝蓝。若摸到蓝球，同样的推理也能把三盒都确定，所以答案是贴着「红蓝」的盒子。',
        ],
        'en' => [
          'Since every label is wrong, the box labelled "red blue" cannot hold one of each, so it holds either 2 red balls or 2 blue balls.',
          'Drawing one ball from that box settles it at once: whatever colour appears, the box holds two balls of that colour.',
          'Suppose a red ball appears, so that box is the red-red box. Then the box labelled "blue blue" can be neither blue-blue nor the already used red-red, so it must be the mixed box.',
          'The remaining box, labelled "red red", is then the blue-blue box. A blue ball leads to the same kind of chain, so the box to draw from is the one labelled "red blue".',
        ],
        'ja' => [
          'どのラベルもまちがっているので、「赤青」とはられた箱の中身は赤 1 青 1 ではなく、赤 2 個か青 2 個のどちらかです。',
          'その箱から 1 個取り出せば、出た色と同じ色の玉が 2 個入っているとすぐに決まります。',
          '赤が出たとすると、その箱は赤赤です。すると「青青」とはられた箱は青青ではなく、すでに使った赤赤でもないので、赤 1 青 1 に決まります。',
          '残る「赤赤」とはられた箱は青青です。青が出た場合も同じように決まるので、取り出すべきは「赤青」とはられた箱です。',
        ],
      },
      options: {
        'A' => { 'zh-Hant' => '貼著「紅藍」標籤的盒子', 'zh-Hans' => '贴着「红蓝」标签的盒子',
                 'en' => 'The box labelled "red blue"', 'ja' => '「赤青」のラベルの箱' },
        'B' => { 'zh-Hant' => '貼著「紅紅」標籤的盒子', 'zh-Hans' => '贴着「红红」标签的盒子',
                 'en' => 'The box labelled "red red"', 'ja' => '「赤赤」のラベルの箱' },
        'C' => { 'zh-Hant' => '貼著「藍藍」標籤的盒子', 'zh-Hans' => '贴着「蓝蓝」标签的盒子',
                 'en' => 'The box labelled "blue blue"', 'ja' => '「青青」のラベルの箱' },
        'D' => { 'zh-Hant' => '任何一個盒子都可以', 'zh-Hans' => '任何一个盒子都可以',
                 'en' => 'Any one of the three boxes will do', 'ja' => 'どの箱でもよい' },
      },
      correct: 'A',
      figure: figure_none,
      source: src('logic-grade3-foundation',
        'Original composition in the Math Kangaroo grade 3-4 mislabelled-boxes style; with three boxes the mixed label is the only one that yields a forced chain, which is a different argument from the two-box version. Not a reproduction of any past paper.'),
    ),
    int_q(
      topic: 'logic', subtopic: 'multi_condition_arrangement',
      prompt: {
        'zh-Hant' => '小安、小美、小華、小明四個人排成一列。已知小華排在第 1 個；小美排在小安後面，而且小美和小安之間至少隔著一個人。小明排在第幾個？',
        'zh-Hans' => '小安、小美、小华、小明四个人排成一列。已知小华排在第 1 个；小美排在小安后面，而且小美和小安之间至少隔着一个人。小明排在第几个？',
        'en' => 'An, Mei, Hua and Ming stand in a row. Hua stands first; Mei stands somewhere behind An, and there is at least one person between Mei and An. In which position does Ming stand?',
        'ja' => 'アン、ミイ、ホア、ミンの 4 人が一列に並びます。ホアは 1 番目に並びます。ミイはアンより後ろで、しかもミイとアンの間には少なくとも 1 人います。ミンは何番目に並びますか。',
      },
      answer: { 'zh-Hant' => '答案是 3。', 'zh-Hans' => '答案是 3。', 'en' => 'The answer is 3.', 'ja' => '答えは 3 です。' },
      steps: {
        'zh-Hant' => [
          '小華排第 1 個，所以小安、小美、小明只能排在第 2、3、4 個。',
          '小美要排在小安後面，而且中間至少隔一個人，所以小安和小美的位置至少相差 2。',
          '在第 2、3、4 個位置裡，相差至少 2 而且順序正確的只有「小安第 2、小美第 4」這一種。',
          '剩下的第 3 個位置就留給小明，所以小明排在第 3 個。',
        ],
        'zh-Hans' => [
          '小华排第 1 个，所以小安、小美、小明只能排在第 2、3、4 个。',
          '小美要排在小安后面，而且中间至少隔一个人，所以小安和小美的位置至少相差 2。',
          '在第 2、3、4 个位置里，相差至少 2 而且顺序正确的只有「小安第 2、小美第 4」这一种。',
          '剩下的第 3 个位置就留给小明，所以小明排在第 3 个。',
        ],
        'en' => [
          'Hua is first, so An, Mei and Ming occupy positions 2, 3 and 4.',
          'Mei is behind An with at least one person between them, so their positions differ by at least 2.',
          'Among positions 2, 3 and 4 the only way to have a gap of at least 2 in the right order is An in position 2 and Mei in position 4.',
          'The remaining position 3 goes to Ming, so Ming stands in position 3.',
        ],
        'ja' => [
          'ホアが 1 番目なので、アン、ミイ、ミンは 2、3、4 番目に並びます。',
          'ミイはアンより後ろで、間に少なくとも 1 人いるので、2 人の位置は少なくとも 2 だけはなれています。',
          '2、3、4 番目のうち、順序が正しく差が 2 以上になるのは「アンが 2 番目、ミイが 4 番目」だけです。',
          '残った 3 番目がミンなので、ミンは 3 番目に並びます。',
        ],
      },
      value: '3', max_digits: 1, figure: figure_none,
      source: src('logic-grade3-foundation',
        'Original composition in the Math Kangaroo grade 3-4 constrained-seating style; a minimum-gap condition rather than a simple adjacency ban forces the arrangement to be unique. Not a reproduction of any past paper.'),
    ),
  ],
  'arithmetic' => [
    int_q(
      topic: 'arithmetic', subtopic: 'chicken_rabbit',
      prompt: {
        'zh-Hant' => '籠子裡有雞和兔子，一共 8 隻，牠們的腳加起來一共有 22 隻。雞有 2 隻腳，兔子有 4 隻腳。籠子裡有幾隻兔子？',
        'zh-Hans' => '笼子里有鸡和兔子，一共 8 只，它们的脚加起来一共有 22 只。鸡有 2 只脚，兔子有 4 只脚。笼子里有几只兔子？',
        'en' => 'A cage holds chickens and rabbits, 8 animals in total, and their legs come to 22 altogether. A chicken has 2 legs and a rabbit has 4 legs. How many rabbits are in the cage?',
        'ja' => 'かごの中にニワトリとウサギが合わせて 8 ひきいて、足の数は全部で 22 本です。ニワトリの足は 2 本、ウサギの足は 4 本です。かごの中にウサギは何ひきいますか。',
      },
      answer: { 'zh-Hant' => '答案是 3 隻。', 'zh-Hans' => '答案是 3 只。',
                'en' => 'The answer is 3 rabbits.', 'ja' => '答えは 3 ひきです。' },
      steps: {
        'zh-Hant' => [
          '先假設 8 隻全部都是雞，那麼腳一共只有 8 × 2 = 16 隻。',
          '但實際上有 22 隻腳，比假設多了 22 − 16 = 6 隻。',
          '把一隻雞換成一隻兔子，腳就會多 4 − 2 = 2 隻。',
          '要多出 6 隻腳，就要換 6 ÷ 2 = 3 隻，所以兔子有 3 隻。',
        ],
        'zh-Hans' => [
          '先假设 8 只全部都是鸡，那么脚一共只有 8 × 2 = 16 只。',
          '但实际上有 22 只脚，比假设多了 22 − 16 = 6 只。',
          '把一只鸡换成一只兔子，脚就会多 4 − 2 = 2 只。',
          '要多出 6 只脚，就要换 6 ÷ 2 = 3 只，所以兔子有 3 只。',
        ],
        'en' => [
          'First suppose all 8 animals were chickens; then there would be only 8 × 2 = 16 legs.',
          'There are really 22 legs, which is 22 − 16 = 6 more than that.',
          'Replacing one chicken by one rabbit adds 4 − 2 = 2 legs.',
          'To gain 6 legs, 6 ÷ 2 = 3 replacements are needed, so there are 3 rabbits.',
        ],
        'ja' => [
          'まず 8 ひきすべてがニワトリだと仮定すると、足は 8 × 2 = 16 本にしかなりません。',
          '実際には 22 本なので、仮定より 22 − 16 = 6 本多いことになります。',
          'ニワトリ 1 ぴきをウサギ 1 ぴきに置きかえるごとに、足は 4 − 2 = 2 本ふえます。',
          '6 本ふやすには 6 ÷ 2 = 3 回置きかえればよいので、ウサギは 3 ひきです。',
        ],
      },
      value: '3', max_digits: 1, figure: figure_none,
      source: src('arithmetic-grade3-foundation',
        'Original composition in the classic chicken-and-rabbit style used at Math Kangaroo grade 3-4 level; solved by the assume-and-adjust argument rather than by trial. Not a reproduction of any past paper.'),
    ),
    int_q(
      topic: 'arithmetic', subtopic: 'divisibility',
      prompt: {
        'zh-Hant' => '一個三位數寫成 4□6，其中 □ 是被遮住的一個數字。已知這個三位數可以被 3 整除。被遮住的數字最大可能是多少？',
        'zh-Hans' => '一个三位数写成 4□6，其中 □ 是被遮住的一个数字。已知这个三位数可以被 3 整除。被遮住的数字最大可能是多少？',
        'en' => 'A three-digit number is written as 4□6, where □ is a single covered digit. The number is divisible by 3. What is the largest possible value of the covered digit?',
        'ja' => 'ある 3 けたの数が 4□6 と書かれていて、□ はかくされた 1 つの数字です。この 3 けたの数は 3 でわり切れます。かくされた数字として最も大きいものはいくつですか。',
      },
      answer: { 'zh-Hant' => '答案是 8。', 'zh-Hans' => '答案是 8。', 'en' => 'The answer is 8.', 'ja' => '答えは 8 です。' },
      steps: {
        'zh-Hant' => [
          '一個數可以被 3 整除，條件是它各位數字的和可以被 3 整除。',
          '已經看得到的兩個數字是 4 和 6，它們的和是 4 + 6 = 10。',
          '所以 10 加上被遮住的數字之後，結果要能被 3 整除；符合的被遮住數字是 2、5、8。',
          '這三個之中最大的是 8，所以被遮住的數字最大是 8。',
        ],
        'zh-Hans' => [
          '一个数可以被 3 整除，条件是它各位数字的和可以被 3 整除。',
          '已经看得到的两个数字是 4 和 6，它们的和是 4 + 6 = 10。',
          '所以 10 加上被遮住的数字之后，结果要能被 3 整除；符合的被遮住数字是 2、5、8。',
          '这三个之中最大的是 8，所以被遮住的数字最大是 8。',
        ],
        'en' => [
          'A number is divisible by 3 exactly when the sum of its digits is divisible by 3.',
          'The two visible digits are 4 and 6, and they add up to 4 + 6 = 10.',
          'So 10 plus the covered digit must be divisible by 3, which happens for the digits 2, 5 and 8.',
          'The largest of these is 8, so the covered digit is at most 8.',
        ],
        'ja' => [
          'ある数が 3 でわり切れるのは、各位の数字の和が 3 でわり切れるときです。',
          '見えている数字は 4 と 6 で、和は 4 + 6 = 10 です。',
          'よって 10 にかくされた数字をたした結果が 3 でわり切れればよく、あてはまるのは 2、5、8 です。',
          'この中で最も大きいのは 8 なので、かくされた数字は最大 8 です。',
        ],
      },
      value: '8', max_digits: 1, figure: figure_none,
      source: src('arithmetic-grade3-foundation',
        'Original composition in the Math Kangaroo grade 3-4 divisibility style; the digit-sum test must be combined with a search for the largest admissible digit. Not a reproduction of any past paper.'),
    ),
    int_q(
      topic: 'arithmetic', subtopic: 'age_problem',
      prompt: {
        'zh-Hant' => '今年爸爸 35 歲，兒子 7 歲。再過幾年，爸爸的年齡剛好會是兒子年齡的 3 倍？',
        'zh-Hans' => '今年爸爸 35 岁，儿子 7 岁。再过几年，爸爸的年龄刚好会是儿子年龄的 3 倍？',
        'en' => 'This year a father is 35 years old and his son is 7 years old. In how many years will the father be exactly 3 times as old as his son?',
        'ja' => '今年、父は 35 才、息子は 7 才です。あと何年たつと、父の年れいがちょうど息子の年れいの 3 倍になりますか。',
      },
      answer: { 'zh-Hant' => '答案是 7 年後。', 'zh-Hans' => '答案是 7 年后。',
                'en' => 'The answer is in 7 years.', 'ja' => '答えは 7 年後です。' },
      steps: {
        'zh-Hant' => [
          '兩個人每年都長 1 歲，所以年齡差永遠不變，一直是 35 − 7 = 28 歲。',
          '當爸爸的年齡是兒子的 3 倍時，把兒子的年齡看成 1 份，爸爸就是 3 份。',
          '這時年齡差是 3 − 1 = 2 份，而年齡差就是 28 歲，所以 1 份是 28 ÷ 2 = 14 歲。',
          '也就是那時兒子 14 歲，比現在的 7 歲多 14 − 7 = 7 歲，所以是 7 年後。',
        ],
        'zh-Hans' => [
          '两个人每年都长 1 岁，所以年龄差永远不变，一直是 35 − 7 = 28 岁。',
          '当爸爸的年龄是儿子的 3 倍时，把儿子的年龄看成 1 份，爸爸就是 3 份。',
          '这时年龄差是 3 − 1 = 2 份，而年龄差就是 28 岁，所以 1 份是 28 ÷ 2 = 14 岁。',
          '也就是那时儿子 14 岁，比现在的 7 岁多 14 − 7 = 7 岁，所以是 7 年后。',
        ],
        'en' => [
          'Both people gain one year every year, so the age gap never changes and always equals 35 − 7 = 28 years.',
          'When the father is 3 times as old as the son, think of the son as 1 part and the father as 3 parts.',
          'The gap is then 3 − 1 = 2 parts, and that gap is 28 years, so one part is 28 ÷ 2 = 14 years.',
          'The son is therefore 14 then, which is 14 − 7 = 7 years older than now, so it happens in 7 years.',
        ],
        'ja' => [
          '2 人とも毎年 1 才ずつ年をとるので、年れいの差はいつも 35 − 7 = 28 才で変わりません。',
          '父の年れいが息子の 3 倍になるとき、息子を 1 つ分、父を 3 つ分と考えます。',
          'このとき差は 3 − 1 = 2 つ分で、それが 28 才にあたるので、1 つ分は 28 ÷ 2 = 14 才です。',
          'つまりそのとき息子は 14 才で、今の 7 才より 14 − 7 = 7 才多いので、7 年後です。',
        ],
      },
      value: '7', max_digits: 1, figure: figure_none,
      source: src('arithmetic-grade3-foundation',
        'Original composition in the Math Kangaroo grade 3-4 age style; the invariant age difference is the intended tool, not year-by-year trial. Not a reproduction of any past paper.'),
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
  puts "#{File.basename(path)} -> #{pack['questions'].length}  (#{questions.map { |q| q['id'] }.join(', ')})"
end

manifest = load_json(MANIFEST_PATH)
manifest['packs'].each do |pack|
  full = File.join(ROOT, pack['path'])
  pack['questionCount'] = counts[full] if counts.key?(full)
end
save_json(MANIFEST_PATH, manifest)
