#!/usr/bin/env ruby
# frozen_string_literal: true

# grade3 第二輪擴充（2026-08-28）：geometry 6 / logic 2 / arithmetic 5，共 13 題
# 依 2026-08-28 的裁示，數量讓步給品質：候選先過 scripts/question_similarity_audit.py，
# 相似度 >= 0.45 或情境雷同者一律淘汰，因此本輪只留下 13 題而非 20 題。
require 'json'
require 'set'

ROOT = File.expand_path('..', __dir__)
GRADE = 'grade3'
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
      topic: 'geometry', subtopic: 'shapes_properties',
      prompt: {
        'zh-Hant' => '一個正方體有 12 條邊，每一條邊都一樣長。如果把這 12 條邊的長度全部加起來剛好是 36 公分，求正方體一條邊的長度是幾公分。',
        'zh-Hans' => '一个正方体有 12 条边，每一条边都一样长。如果把这 12 条边的长度全部加起来刚好是 36 厘米，求正方体一条边的长度是几厘米。',
        'en' => 'A cube has 12 edges, all of the same length. If the lengths of all 12 edges add up to exactly 36 cm, how long is one edge?',
        'ja' => '立方体には辺が 12 本あり、どれも同じ長さです。12 本の辺の長さを全部たすとちょうど 36 cm になるとき、1 辺の長さは何センチメートルですか。',
      },
      answer: { 'zh-Hant' => '答案是 3 公分。', 'zh-Hans' => '答案是 3 厘米。',
                'en' => 'The answer is 3 centimetres.', 'ja' => '答えは 3 センチメートルです。' },
      steps: {
        'zh-Hant' => [
          '正方體是立體圖形，它有 12 條邊，而且每一條邊都一樣長。',
          '把 12 條一樣長的邊加起來，就等於一條邊的長度乘以 12。',
          '題目說總長是 36 公分，所以一條邊的長度乘以 12 等於 36。',
          '因此一條邊的長度是 36 ÷ 12 = 3 公分。',
        ],
        'zh-Hans' => [
          '正方体是立体图形，它有 12 条边，而且每一条边都一样长。',
          '把 12 条一样长的边加起来，就等于一条边的长度乘以 12。',
          '题目说总长是 36 厘米，所以一条边的长度乘以 12 等于 36。',
          '因此一条边的长度是 36 ÷ 12 = 3 厘米。',
        ],
        'en' => [
          'A cube is a solid shape with 12 edges, and all of them are the same length.',
          'Adding 12 equal edges is the same as multiplying one edge length by 12.',
          'The total is given as 36 cm, so one edge length times 12 equals 36.',
          'Therefore one edge is 36 ÷ 12 = 3 centimetres long.',
        ],
        'ja' => [
          '立方体は立体で、辺が 12 本あり、どれも同じ長さです。',
          '同じ長さの辺 12 本をたすことは、1 辺の長さを 12 倍することと同じです。',
          '合計が 36 cm なので、1 辺の長さ × 12 = 36 となります。',
          'したがって 1 辺の長さは 36 ÷ 12 = 3 センチメートルです。',
        ],
      },
      value: '3', max_digits: 1,
      notes: 'Original composition in the Math Kangaroo grade 3-4 solid-shape style; the grade1-6 packs had no solid-figure items, and the edge count of a cube is used in reverse to recover a length. Not a reproduction of any past paper.',
    ),
    int_q(
      topic: 'geometry', subtopic: 'composite_area',
      prompt: {
        'zh-Hant' => '一個正方體的表面是由 6 個一樣大的正方形組成的。如果其中一個面的面積是 9 平方公分，求這個正方體所有表面的面積合起來是幾平方公分。',
        'zh-Hans' => '一个正方体的表面是由 6 个一样大的正方形组成的。如果其中一个面的面积是 9 平方厘米，求这个正方体所有表面的面积合起来是几平方厘米。',
        'en' => 'The surface of a cube is made of 6 identical squares. If one face has an area of 9 square centimetres, what is the total area of all the faces?',
        'ja' => '立方体の表面は同じ大きさの正方形 6 つでできています。1 つの面の面積が 9 平方センチメートルのとき、すべての面の面積の合計は何平方センチメートルですか。',
      },
      answer: { 'zh-Hant' => '答案是 54 平方公分。', 'zh-Hans' => '答案是 54 平方厘米。',
                'en' => 'The answer is 54 square centimetres.', 'ja' => '答えは 54 平方センチメートルです。' },
      steps: {
        'zh-Hant' => [
          '正方體有 6 個面，而且這 6 個面都是一樣大的正方形。',
          '既然每個面都一樣大，只要知道其中一個面的面積，就知道每一個面都是這個面積。',
          '一個面是 9 平方公分，6 個面就是 9 × 6。',
          '所以所有表面的面積合起來是 9 × 6 = 54 平方公分。',
        ],
        'zh-Hans' => [
          '正方体有 6 个面，而且这 6 个面都是一样大的正方形。',
          '既然每个面都一样大，只要知道其中一个面的面积，就知道每一个面都是这个面积。',
          '一个面是 9 平方厘米，6 个面就是 9 × 6。',
          '所以所有表面的面积合起来是 9 × 6 = 54 平方厘米。',
        ],
        'en' => [
          'A cube has 6 faces, and all 6 are identical squares.',
          'Since the faces are identical, knowing one face area tells us every face has that same area.',
          'One face is 9 square centimetres, so 6 faces come to 9 × 6.',
          'The total surface area is therefore 9 × 6 = 54 square centimetres.',
        ],
        'ja' => [
          '立方体には面が 6 つあり、どれも同じ大きさの正方形です。',
          '面がすべて同じ大きさなので、1 つの面の面積がわかればすべての面の面積がわかります。',
          '1 つの面が 9 平方センチメートルなので、6 つの面では 9 × 6 です。',
          'したがって表面積の合計は 9 × 6 = 54 平方センチメートルです。',
        ],
      },
      value: '54', max_digits: 2,
      notes: 'Original composition in the Math Kangaroo grade 3-4 solid-shape style; the face count of a cube is combined with a single face area, which no other grade1-6 item does. Not a reproduction of any past paper.',
    ),
    int_q(
      topic: 'geometry', subtopic: 'area_counting',
      prompt: {
        'zh-Hant' => '一間長 6 公尺、寬 4 公尺的長方形房間，要用邊長 2 公尺的正方形地磚鋪滿，地磚不可以裁切也不可以重疊。一共需要幾塊地磚？',
        'zh-Hans' => '一间长 6 米、宽 4 米的长方形房间，要用边长 2 米的正方形地砖铺满，地砖不可以裁切也不可以重叠。一共需要几块地砖？',
        'en' => 'A rectangular room 6 metres long and 4 metres wide is to be tiled completely with square tiles of side 2 metres, with no cutting and no overlapping. How many tiles are needed?',
        'ja' => '縦 4 m、横 6 m の長方形の部屋に、1 辺 2 m の正方形のタイルをすきまなくしきつめます。タイルは切ったり重ねたりできません。タイルは何枚必要ですか。',
      },
      answer: { 'zh-Hant' => '答案是 6 塊。', 'zh-Hans' => '答案是 6 块。',
                'en' => 'The answer is 6 tiles.', 'ja' => '答えは 6 枚です。' },
      steps: {
        'zh-Hant' => [
          '沿著長邊看：房間長 6 公尺，每塊地磚長 2 公尺，所以一排可以放 6 ÷ 2 = 3 塊。',
          '沿著寬邊看：房間寬 4 公尺，每塊地磚寬 2 公尺，所以可以放 4 ÷ 2 = 2 排。',
          '兩個方向都剛好整除，表示地磚不用裁切就能鋪滿。',
          '所以一共需要 3 × 2 = 6 塊地磚。',
        ],
        'zh-Hans' => [
          '沿着长边看：房间长 6 米，每块地砖长 2 米，所以一排可以放 6 ÷ 2 = 3 块。',
          '沿着宽边看：房间宽 4 米，每块地砖宽 2 米，所以可以放 4 ÷ 2 = 2 排。',
          '两个方向都刚好整除，表示地砖不用裁切就能铺满。',
          '所以一共需要 3 × 2 = 6 块地砖。',
        ],
        'en' => [
          'Along the length: the room is 6 metres and each tile is 2 metres, so one row holds 6 ÷ 2 = 3 tiles.',
          'Along the width: the room is 4 metres and each tile is 2 metres, so there are 4 ÷ 2 = 2 rows.',
          'Both directions divide exactly, which is why no tile needs cutting.',
          'So 3 × 2 = 6 tiles are needed altogether.',
        ],
        'ja' => [
          '横を見ると、部屋は 6 m でタイルは 2 m なので、1 列に 6 ÷ 2 = 3 枚並びます。',
          '縦を見ると、部屋は 4 m でタイルは 2 m なので、4 ÷ 2 = 2 列できます。',
          'どちらの方向もちょうどわり切れるので、タイルを切らずにしきつめられます。',
          'したがって必要なタイルは 3 × 2 = 6 枚です。',
        ],
      },
      value: '6', max_digits: 2,
      notes: 'Original composition in the Math Kangaroo grade 3-4 tiling style; the tile side must divide both room dimensions, so the count is a product of two divisions rather than an area division. Not a reproduction of any past paper.',
    ),
    int_q(
      topic: 'geometry', subtopic: 'angles',
      prompt: {
        'zh-Hant' => '時鐘的分針從指著 12 開始走，一直走到指著 4 為止。在這段時間裡，分針一共轉了幾度？',
        'zh-Hans' => '时钟的分针从指着 12 开始走，一直走到指着 4 为止。在这段时间里，分针一共转了几度？',
        'en' => 'The minute hand of a clock starts pointing at 12 and moves until it points at 4. Through how many degrees has the minute hand turned?',
        'ja' => '時計の長針が 12 をさしているところから動きはじめ、4 をさすところまで進みます。この間に長針は何度回りましたか。',
      },
      answer: { 'zh-Hant' => '答案是 120 度。', 'zh-Hans' => '答案是 120 度。',
                'en' => 'The answer is 120 degrees.', 'ja' => '答えは 120 度です。' },
      steps: {
        'zh-Hant' => [
          '分針轉一整圈是 360 度，鐘面上一整圈被平分成 12 個大格（從 12 到 1、1 到 2⋯）。',
          '所以每一個大格對應的角度是 360 ÷ 12 = 30 度。',
          '從 12 走到 4，一共經過 4 個大格。',
          '所以分針轉了 30 × 4 = 120 度。',
        ],
        'zh-Hans' => [
          '分针转一整圈是 360 度，钟面上一整圈被平分成 12 个大格（从 12 到 1、1 到 2⋯）。',
          '所以每一个大格对应的角度是 360 ÷ 12 = 30 度。',
          '从 12 走到 4，一共经过 4 个大格。',
          '所以分针转了 30 × 4 = 120 度。',
        ],
        'en' => [
          'A full turn of the minute hand is 360 degrees, and the clock face is divided into 12 equal big divisions, from 12 to 1, from 1 to 2, and so on.',
          'So each big division corresponds to 360 ÷ 12 = 30 degrees.',
          'Going from 12 to 4 passes 4 of those big divisions.',
          'The minute hand therefore turns 30 × 4 = 120 degrees.',
        ],
        'ja' => [
          '長針が 1 周すると 360 度で、時計の文字盤は 12 等分されています（12 から 1、1 から 2 など）。',
          'したがって 1 目もりぶんは 360 ÷ 12 = 30 度です。',
          '12 から 4 までは 4 目もりぶん進みます。',
          'よって長針は 30 × 4 = 120 度回りました。',
        ],
      },
      value: '120', max_digits: 3,
      notes: 'Original composition in the Math Kangaroo grade 3-4 angle style; this measures the turn of a single hand using the twelve equal divisions, unlike the upper-grade items about the angle between two hands. Not a reproduction of any past paper.',
    ),
    int_q(
      topic: 'geometry', subtopic: 'isosceles',
      prompt: {
        'zh-Hant' => '一個等腰三角形的其中一個內角是 40 度。這個三角形三個角之中最大的那個角，最多可能是幾度？',
        'zh-Hans' => '一个等腰三角形的其中一个内角是 40 度。这个三角形三个角之中最大的那个角，最多可能是几度？',
        'en' => 'One interior angle of an isosceles triangle is 40 degrees. At most how many degrees can the largest of the three angles be?',
        'ja' => 'ある二等辺三角形の内角の 1 つは 40 度です。3 つの角のうち最も大きい角は、最大で何度になりますか。',
      },
      answer: { 'zh-Hant' => '答案是 100 度。', 'zh-Hans' => '答案是 100 度。',
                'en' => 'The answer is 100 degrees.', 'ja' => '答えは 100 度です。' },
      steps: {
        'zh-Hant' => [
          '等腰三角形有兩個角一樣大，這 40 度可能是那兩個相等的角之一，也可能是剩下的那一個角，要分成兩種情況。',
          '情況一：40 度是兩個相等的角。那麼兩個相等的角共 80 度，剩下的角是 180 − 80 = 100 度，三個角是 40、40、100，最大的是 100 度。',
          '情況二：40 度是剩下的那一個角。那麼兩個相等的角合起來是 180 − 40 = 140 度，各是 70 度，三個角是 40、70、70，最大的是 70 度。',
          '兩種情況都成立，最大角分別是 100 度和 70 度。',
          '題目問最大可能是幾度，所以答案是 100 度。',
        ],
        'zh-Hans' => [
          '等腰三角形有两个角一样大，这 40 度可能是那两个相等的角之一，也可能是剩下的那一个角，要分成两种情况。',
          '情况一：40 度是两个相等的角。那么两个相等的角共 80 度，剩下的角是 180 − 80 = 100 度，三个角是 40、40、100，最大的是 100 度。',
          '情况二：40 度是剩下的那一个角。那么两个相等的角合起来是 180 − 40 = 140 度，各是 70 度，三个角是 40、70、70，最大的是 70 度。',
          '两种情况都成立，最大角分别是 100 度和 70 度。',
          '题目问最大可能是几度，所以答案是 100 度。',
        ],
        'en' => [
          'An isosceles triangle has two equal angles, and the 40 degree angle could be one of those two or the remaining one, so there are two cases.',
          'Case one: 40 degrees is one of the equal pair. The pair then totals 80 degrees and the remaining angle is 180 − 80 = 100 degrees, giving angles 40, 40 and 100, the largest being 100.',
          'Case two: 40 degrees is the remaining angle. The equal pair then totals 180 − 40 = 140 degrees, so each is 70, giving angles 40, 70 and 70, the largest being 70.',
          'Both cases are possible, with largest angles of 100 and 70 degrees.',
          'The question asks for the greatest possible value, so the answer is 100 degrees.',
        ],
        'ja' => [
          '二等辺三角形には等しい角が 2 つあり、40 度はその 2 つのうちの 1 つかもしれないし、残りの角かもしれないので、2 つの場合に分けます。',
          '場合 1：40 度が等しい 2 角のとき、その 2 角で 80 度、残りの角は 180 − 80 = 100 度となり、3 角は 40、40、100 で最大は 100 度です。',
          '場合 2：40 度が残りの角のとき、等しい 2 角の和は 180 − 40 = 140 度で、それぞれ 70 度、3 角は 40、70、70 で最大は 70 度です。',
          'どちらの場合もありえて、最大角はそれぞれ 100 度と 70 度です。',
          '問題は最大でいくつかを聞いているので、答えは 100 度です。',
        ],
      },
      value: '100', max_digits: 3,
      notes: 'Original composition in the Math Kangaroo grade 3-4 isosceles style; both cases are admissible here and the question asks for the maximum, unlike the grade4 item where one case is ruled out by contradiction. Not a reproduction of any past paper.',
    ),
    int_q(
      topic: 'geometry', subtopic: 'triangle_angles',
      prompt: {
        'zh-Hant' => '一個三角形的三個內角度數的比是 1 比 2 比 3。求這個三角形最大的那個角是幾度。',
        'zh-Hans' => '一个三角形的三个内角度数的比是 1 比 2 比 3。求这个三角形最大的那个角是几度。',
        'en' => 'The three interior angles of a triangle are in the ratio 1 : 2 : 3. How many degrees is the largest angle?',
        'ja' => 'ある三角形の 3 つの内角の大きさの比は 1 : 2 : 3 です。最も大きい角は何度ですか。',
      },
      answer: { 'zh-Hant' => '答案是 90 度。', 'zh-Hans' => '答案是 90 度。',
                'en' => 'The answer is 90 degrees.', 'ja' => '答えは 90 度です。' },
      steps: {
        'zh-Hant' => [
          '三個角的比是 1 比 2 比 3，可以把三個角看成 1 份、2 份、3 份。',
          '三個角合起來就是 1 + 2 + 3 = 6 份。',
          '三角形的內角和是 180 度，所以 6 份等於 180 度，一份是 180 ÷ 6 = 30 度。',
          '最大的角是 3 份，所以是 30 × 3 = 90 度。',
        ],
        'zh-Hans' => [
          '三个角的比是 1 比 2 比 3，可以把三个角看成 1 份、2 份、3 份。',
          '三个角合起来就是 1 + 2 + 3 = 6 份。',
          '三角形的内角和是 180 度，所以 6 份等于 180 度，一份是 180 ÷ 6 = 30 度。',
          '最大的角是 3 份，所以是 30 × 3 = 90 度。',
        ],
        'en' => [
          'The ratio 1 : 2 : 3 means the three angles can be seen as 1 part, 2 parts and 3 parts.',
          'Together they make 1 + 2 + 3 = 6 parts.',
          'The angles of a triangle add to 180 degrees, so 6 parts equal 180 degrees and one part is 180 ÷ 6 = 30 degrees.',
          'The largest angle is 3 parts, so it is 30 × 3 = 90 degrees.',
        ],
        'ja' => [
          '比が 1 : 2 : 3 なので、3 つの角をそれぞれ 1 つ分、2 つ分、3 つ分と考えます。',
          '合わせると 1 + 2 + 3 = 6 つ分です。',
          '三角形の内角の和は 180 度なので 6 つ分が 180 度、1 つ分は 180 ÷ 6 = 30 度です。',
          '最も大きい角は 3 つ分なので 30 × 3 = 90 度です。',
        ],
      },
      value: '90', max_digits: 2,
      notes: 'Original composition in the Math Kangaroo grade 3-4 angle style; the angle sum is split by a ratio rather than being used to find a missing third angle. Not a reproduction of any past paper.',
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
