#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'

ROOT = File.expand_path('..', __dir__)

def load_json(path)
  JSON.parse(File.read(path))
end

def write_json(path, payload)
  File.write(path, JSON.pretty_generate(payload) + "\n")
end

def append_questions(path, new_questions)
  payload = load_json(path)
  questions = payload.fetch('questions')
  existing_ids = questions.map { |entry| entry.fetch('id') }
  new_questions.each do |question|
    raise "Duplicate question id: #{question['id']}" if existing_ids.include?(question['id'])

    questions << question
  end
  write_json(path, payload)
end

SOURCE = {
  'type' => 'rewritten_olympiad_style',
  'name' => 'MathSpring Editorial',
  'notes' => 'Original olympiad-style authored content based on official contest-type structures; not a templated numeric variation.',
}

append_questions(
  File.join(ROOT, 'assets/questions/geometry/grade1_foundation.geometry.v1.json'),
  [
    {
      'id' => 'geometry_grade1_foundation_042',
      'topic' => 'geometry',
      'subtopic' => 'shape_counting',
      'difficulty' => 'foundation',
      'levelStage' => 'grade1',
      'challengeTier' => 'foundation',
      'prompt' => {
        'zh-Hant' => '把 4 個一樣大的小正方形拼成一個 2×2 的大正方形。圖中一共有幾個正方形？',
        'zh-Hans' => '把 4 个一样大的小正方形拼成一个 2×2 的大正方形。图中一共有几个正方形？',
        'en' => 'Four equal small squares are arranged into one 2×2 large square. How many squares are there in the figure altogether?',
        'ja' => '同じ大きさの小さい正方形4つを、2×2の大きな正方形に並べます。この図の中に正方形は全部でいくつありますか。',
      },
      'answer' => {
        'zh-Hant' => '答案是 5 個。',
        'zh-Hans' => '答案是 5 个。',
        'en' => 'The answer is 5.',
        'ja' => '答えは 5 個です。',
      },
      'solutionSteps' => {
        'zh-Hant' => [
          '先數小正方形，有 4 個。',
          '再數整個外框的大正方形，還有 1 個。',
          '所以一共有 4 + 1 = 5 個正方形。',
        ],
        'zh-Hans' => [
          '先数小正方形，有 4 个。',
          '再数整个外框的大正方形，还有 1 个。',
          '所以一共有 4 + 1 = 5 个正方形。',
        ],
        'en' => [
          'First count the small squares: there are 4.',
          'Then count the whole outer large square: that adds 1 more.',
          'So there are 4 + 1 = 5 squares in total.',
        ],
        'ja' => [
          'まず小さい正方形を数えると 4 個あります。',
          '次に外側全体の大きい正方形が 1 個あります。',
          'したがって全部で 4 + 1 = 5 個です。',
        ],
      },
      'figure' => { 'type' => 'custom', 'kind' => 'none', 'params' => {} },
      'answerMode' => 'integer_input',
      'correctAnswer' => { 'type' => 'integer', 'value' => '5' },
      'inputConstraints' => { 'allowNegative' => false, 'maxDigits' => 1 },
      'source' => SOURCE.merge('reference' => 'geometry-grade1-foundation'),
    },
  ],
)

append_questions(
  File.join(ROOT, 'assets/questions/geometry/grade2_foundation.geometry.v1.json'),
  [
    {
      'id' => 'geometry_grade2_foundation_042',
      'topic' => 'geometry',
      'subtopic' => 'reflection',
      'difficulty' => 'foundation',
      'levelStage' => 'grade2',
      'challengeTier' => 'foundation',
      'prompt' => {
        'zh-Hant' => '一個長方形長 8 公分、寬 4 公分。沿著長方形中間、和長邊平行的線對折後，得到的新長方形周長是多少公分？',
        'zh-Hans' => '一个长方形长 8 公分、宽 4 公分。沿着长方形中间、和长边平行的线对折后，得到的新长方形周长是多少公分？',
        'en' => 'A rectangle is 8 cm long and 4 cm wide. It is folded along the middle line parallel to the longer sides. What is the perimeter of the new rectangle?',
        'ja' => '長方形のたては8cm、横は4cmです。長い辺と平行な真ん中の線で折ると、新しい長方形の周の長さは何cmですか。',
      },
      'answer' => {
        'zh-Hant' => '答案是 20 公分。',
        'zh-Hans' => '答案是 20 公分。',
        'en' => 'The answer is 20 cm.',
        'ja' => '答えは 20cm です。',
      },
      'solutionSteps' => {
        'zh-Hant' => [
          '對折後，長 8 公分不變，寬 4 公分變成一半，也就是 2 公分。',
          '新長方形的周長是 2×(8 + 2) = 20 公分。',
        ],
        'zh-Hans' => [
          '对折后，长 8 公分不变，宽 4 公分变成一半，也就是 2 公分。',
          '新长方形的周长是 2×(8 + 2) = 20 公分。',
        ],
        'en' => [
          'After folding, the length 8 cm stays the same, while the width 4 cm is halved to 2 cm.',
          'So the new perimeter is 2×(8 + 2) = 20 cm.',
        ],
        'ja' => [
          '折ったあと、長さ8cmはそのままで、幅4cmは半分の2cmになります。',
          'したがって新しい周の長さは 2×(8 + 2) = 20cm です。',
        ],
      },
      'figure' => { 'type' => 'custom', 'kind' => 'none', 'params' => {} },
      'answerMode' => 'integer_input',
      'correctAnswer' => { 'type' => 'integer', 'value' => '20' },
      'inputConstraints' => { 'allowNegative' => false, 'maxDigits' => 2 },
      'source' => SOURCE.merge('reference' => 'geometry-grade2-foundation'),
    },
  ],
)

append_questions(
  File.join(ROOT, 'assets/questions/geometry/grade3_foundation.geometry.v1.json'),
  [
    {
      'id' => 'geometry_grade3_foundation_044',
      'topic' => 'geometry',
      'subtopic' => 'perimeter_invariance',
      'difficulty' => 'foundation',
      'levelStage' => 'grade3',
      'challengeTier' => 'foundation',
      'prompt' => {
        'zh-Hant' => '一個長 6 公分、寬 4 公分的長方形，從其中一個角剪去一個邊長 2 公分的小正方形。剩下圖形的周長是多少公分？',
        'zh-Hans' => '一个长 6 公分、宽 4 公分的长方形，从其中一个角剪去一个边长 2 公分的小正方形。剩下图形的周长是多少公分？',
        'en' => 'A rectangle is 6 cm by 4 cm. A small square of side 2 cm is cut off from one corner. What is the perimeter of the remaining shape?',
        'ja' => 'たて6cm、横4cmの長方形の1つの角から、1辺2cmの小さな正方形を切り取ります。残った図形の周の長さは何cmですか。',
      },
      'answer' => {
        'zh-Hant' => '答案是 20 公分。',
        'zh-Hans' => '答案是 20 公分。',
        'en' => 'The answer is 20 cm.',
        'ja' => '答えは 20cm です。',
      },
      'solutionSteps' => {
        'zh-Hant' => [
          '原來長方形的周長是 2×(6 + 4) = 20 公分。',
          '剪去角落時，外面少了兩段各 2 公分，但同時又新增兩段各 2 公分，所以周長不變。',
          '因此剩下圖形的周長還是 20 公分。',
        ],
        'zh-Hans' => [
          '原来长方形的周长是 2×(6 + 4) = 20 公分。',
          '剪去角落时，外面少了两段各 2 公分，但同时又新增两段各 2 公分，所以周长不变。',
          '因此剩下图形的周长还是 20 公分。',
        ],
        'en' => [
          'The original rectangle has perimeter 2×(6 + 4) = 20 cm.',
          'Cutting off the corner removes two outer segments of 2 cm each, but it also creates two new segments of 2 cm each, so the perimeter stays the same.',
          'Therefore the remaining shape still has perimeter 20 cm.',
        ],
        'ja' => [
          'もとの長方形の周の長さは 2×(6 + 4) = 20cm です。',
          '角を切り取ると、外側の2cmの辺が2本なくなりますが、代わりに新しい2cmの辺が2本できます。',
          'そのため周の長さは変わらず、残った図形の周の長さも 20cm です。',
        ],
      },
      'figure' => { 'type' => 'custom', 'kind' => 'none', 'params' => {} },
      'answerMode' => 'integer_input',
      'correctAnswer' => { 'type' => 'integer', 'value' => '20' },
      'inputConstraints' => { 'allowNegative' => false, 'maxDigits' => 2 },
      'source' => SOURCE.merge('reference' => 'geometry-grade3-foundation'),
    },
  ],
)

append_questions(
  File.join(ROOT, 'assets/questions/geometry/grade4_foundation.geometry.v1.json'),
  [
    {
      'id' => 'geometry_grade4_foundation_042',
      'topic' => 'geometry',
      'subtopic' => 'composite_area',
      'difficulty' => 'foundation',
      'levelStage' => 'grade4',
      'challengeTier' => 'foundation',
      'prompt' => {
        'zh-Hant' => '兩個邊長都是 4 公分的正方形，緊緊拼成一個 8×4 的長方形。再從其中一個角剪去一個邊長 2 公分的小正方形。剩下圖形的面積是多少平方公分？',
        'zh-Hans' => '两个边长都是 4 公分的正方形，紧紧拼成一个 8×4 的长方形。再从其中一个角剪去一个边长 2 公分的小正方形。剩下图形的面积是多少平方公分？',
        'en' => 'Two squares of side 4 cm are joined to make an 8×4 rectangle. Then a small square of side 2 cm is cut off from one corner. What is the area of the remaining shape?',
        'ja' => '1辺4cmの正方形2つをぴったり並べて、8×4の長方形を作ります。その1つの角から、1辺2cmの小さな正方形を切り取ります。残った図形の面積は何平方cmですか。',
      },
      'answer' => {
        'zh-Hant' => '答案是 28 平方公分。',
        'zh-Hans' => '答案是 28 平方公分。',
        'en' => 'The answer is 28 square centimeters.',
        'ja' => '答えは 28 平方cmです。',
      },
      'solutionSteps' => {
        'zh-Hant' => [
          '先算整個大長方形的面積：8×4 = 32 平方公分。',
          '被剪掉的小正方形面積是 2×2 = 4 平方公分。',
          '所以剩下圖形的面積是 32 − 4 = 28 平方公分。',
        ],
        'zh-Hans' => [
          '先算整个大长方形的面积：8×4 = 32 平方公分。',
          '被剪掉的小正方形面积是 2×2 = 4 平方公分。',
          '所以剩下图形的面积是 32 − 4 = 28 平方公分。',
        ],
        'en' => [
          'First find the area of the large rectangle: 8×4 = 32 square centimeters.',
          'The cut-out square has area 2×2 = 4 square centimeters.',
          'So the remaining area is 32 − 4 = 28 square centimeters.',
        ],
        'ja' => [
          'まず大きい長方形の面積は 8×4 = 32 平方cm です。',
          '切り取った小さい正方形の面積は 2×2 = 4 平方cm です。',
          'したがって残った面積は 32 − 4 = 28 平方cm です。',
        ],
      },
      'figure' => { 'type' => 'custom', 'kind' => 'none', 'params' => {} },
      'answerMode' => 'integer_input',
      'correctAnswer' => { 'type' => 'integer', 'value' => '28' },
      'inputConstraints' => { 'allowNegative' => false, 'maxDigits' => 2 },
      'source' => SOURCE.merge('reference' => 'geometry-grade4-foundation'),
    },
  ],
)

append_questions(
  File.join(ROOT, 'assets/questions/geometry/grade5_foundation.geometry.v1.json'),
  [
    {
      'id' => 'geometry_grade5_foundation_042',
      'topic' => 'geometry',
      'subtopic' => 'triangle_partition',
      'difficulty' => 'foundation',
      'levelStage' => 'grade5',
      'challengeTier' => 'foundation',
      'prompt' => {
        'zh-Hant' => '一個三角形的底是 16 公分，高是 10 公分。把頂點連到底邊的中點，三角形被分成兩部分。每一部分的面積是多少平方公分？',
        'zh-Hans' => '一个三角形的底是 16 公分，高是 10 公分。把顶点连到底边的中点，三角形被分成两部分。每一部分的面积是多少平方公分？',
        'en' => 'A triangle has base 16 cm and height 10 cm. The top vertex is joined to the midpoint of the base, splitting the triangle into two parts. What is the area of each part?',
        'ja' => '三角形の底辺は16cm、高さは10cmです。頂点と底辺の中点を結んで、三角形を2つに分けます。それぞれの部分の面積は何平方cmですか。',
      },
      'answer' => {
        'zh-Hant' => '答案是 40 平方公分。',
        'zh-Hans' => '答案是 40 平方公分。',
        'en' => 'The answer is 40 square centimeters.',
        'ja' => '答えは 40 平方cmです。',
      },
      'solutionSteps' => {
        'zh-Hant' => [
          '原來大三角形的面積是 16×10÷2 = 80 平方公分。',
          '底邊中點把底邊分成兩段一樣長，所以分出的兩個小三角形底相等、高也相同，因此面積相等。',
          '所以每一部分的面積是 80÷2 = 40 平方公分。',
        ],
        'zh-Hans' => [
          '原来大三角形的面积是 16×10÷2 = 80 平方公分。',
          '底边中点把底边分成两段一样长，所以分出的两个小三角形底相等、高也相同，因此面积相等。',
          '所以每一部分的面积是 80÷2 = 40 平方公分。',
        ],
        'en' => [
          'The whole triangle has area 16×10÷2 = 80 square centimeters.',
          'The midpoint splits the base into two equal parts, and the two smaller triangles share the same height, so their areas are equal.',
          'Thus each part has area 80÷2 = 40 square centimeters.',
        ],
        'ja' => [
          'もとの大きい三角形の面積は 16×10÷2 = 80 平方cm です。',
          '底辺の中点で底辺が等しく分かれ、2つの小さい三角形は高さも同じなので、面積は等しくなります。',
          'したがって、それぞれの面積は 80÷2 = 40 平方cm です。',
        ],
      },
      'figure' => {
        'type' => 'custom',
        'kind' => 'shape_diagram',
        'params' => { 'shape' => 'triangle', 'labels' => { 'bottom' => '16', 'right' => '10' } },
      },
      'answerMode' => 'integer_input',
      'correctAnswer' => { 'type' => 'integer', 'value' => '40' },
      'inputConstraints' => { 'allowNegative' => false, 'maxDigits' => 2 },
      'source' => SOURCE.merge('reference' => 'geometry-grade5-foundation'),
    },
  ],
)

append_questions(
  File.join(ROOT, 'assets/questions/geometry/grade6_foundation.geometry.v1.json'),
  [
    {
      'id' => 'geometry_grade6_foundation_044',
      'topic' => 'geometry',
      'subtopic' => 'scale_factor',
      'difficulty' => 'foundation',
      'levelStage' => 'grade6',
      'challengeTier' => 'foundation',
      'prompt' => {
        'zh-Hant' => '一個長方形放大後，長和寬都變成原來的 2 倍，結果周長比原來多了 36 公分。原來長方形的周長是多少公分？',
        'zh-Hans' => '一个长方形放大后，长和宽都变成原来的 2 倍，结果周长比原来多了 36 公分。原来长方形的周长是多少公分？',
        'en' => 'A rectangle is enlarged so that both its length and width become 2 times the originals. Its perimeter is then 36 cm more than before. What was the original perimeter?',
        'ja' => '長方形を拡大して、たてと横の長さがどちらも元の 2 倍になりました。その結果、周の長さは元より36cm長くなりました。元の長方形の周の長さは何cmですか。',
      },
      'answer' => {
        'zh-Hant' => '答案是 36 公分。',
        'zh-Hans' => '答案是 36 公分。',
        'en' => 'The answer is 36 cm.',
        'ja' => '答えは 36cm です。',
      },
      'solutionSteps' => {
        'zh-Hant' => [
          '長和寬都放大 2 倍後，周長也會放大 2 倍。',
          '因此「新的周長 − 原來的周長」剛好等於原來的周長本身。',
          '題目說多了 36 公分，所以原來的周長就是 36 公分。',
        ],
        'zh-Hans' => [
          '长和宽都放大 2 倍后，周长也会放大 2 倍。',
          '因此“新的周长 − 原来的周长”刚好等于原来的周长本身。',
          '题目说多了 36 公分，所以原来的周长就是 36 公分。',
        ],
        'en' => [
          'If both the length and width are doubled, then the perimeter is also doubled.',
          'So the increase in perimeter is exactly equal to the original perimeter.',
          'Since the increase is 36 cm, the original perimeter must also be 36 cm.',
        ],
        'ja' => [
          'たてと横をどちらも2倍にすると、周の長さも2倍になります。',
          'したがって、増えた分はちょうど元の周の長さと同じです。',
          '増えた分が36cmなので、元の周の長さも 36cm です。',
        ],
      },
      'figure' => { 'type' => 'custom', 'kind' => 'none', 'params' => {} },
      'answerMode' => 'integer_input',
      'correctAnswer' => { 'type' => 'integer', 'value' => '36' },
      'inputConstraints' => { 'allowNegative' => false, 'maxDigits' => 2 },
      'source' => SOURCE.merge('reference' => 'geometry-grade6-foundation'),
    },
  ],
)

puts 'Appended mixed geometry batch for grades 1-6.'
