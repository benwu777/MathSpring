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
  'notes' => 'Original olympiad-style authored content based on official contest-type structures; reviewed for non-template variation.',
}

append_questions(
  File.join(ROOT, 'assets/questions/geometry/grade1_foundation.geometry.v1.json'),
  [
    {
      'id' => 'geometry_grade1_foundation_043',
      'topic' => 'geometry',
      'subtopic' => 'symmetry',
      'difficulty' => 'foundation',
      'levelStage' => 'grade1',
      'challengeTier' => 'foundation',
      'prompt' => {
        'zh-Hant' => '把一張正方形紙沿著一條對角線對折，會得到一個等腰直角三角形。這個三角形有幾條對稱線？',
        'zh-Hans' => '把一张正方形纸沿着一条对角线对折，会得到一个等腰直角三角形。这个三角形有几条对称线？',
        'en' => 'A square sheet is folded along one diagonal, forming an isosceles right triangle. How many lines of symmetry does this triangle have?',
        'ja' => '正方形の紙を対角線に沿って折ると、直角二等辺三角形になります。この三角形の対称の軸は何本ありますか。',
      },
      'answer' => {
        'zh-Hant' => '答案是 1 條。',
        'zh-Hans' => '答案是 1 条。',
        'en' => 'The answer is 1.',
        'ja' => '答えは 1 本です。',
      },
      'solutionSteps' => {
        'zh-Hant' => [
          '對折後得到的三角形有兩條一樣長的邊，所以它是等腰三角形。',
          '等腰直角三角形只有從直角頂點連到斜邊中點的那一條對稱線。',
          '所以這個三角形有 1 條對稱線。',
        ],
        'zh-Hans' => [
          '对折后得到的三角形有两条一样长的边，所以它是等腰三角形。',
          '等腰直角三角形只有从直角顶点连到斜边中点的那一条对称线。',
          '所以这个三角形有 1 条对称线。',
        ],
        'en' => [
          'The folded triangle has two equal sides, so it is an isosceles triangle.',
          'An isosceles right triangle has exactly one symmetry line: from the right-angle vertex to the midpoint of the hypotenuse.',
          'So the triangle has 1 line of symmetry.',
        ],
        'ja' => [
          '折ってできた三角形は、2辺の長さが等しいので二等辺三角形です。',
          '直角二等辺三角形の対称の軸は、直角の頂点から斜辺の中点へ引く 1 本だけです。',
          'したがって対称の軸は 1 本です。',
        ],
      },
      'figure' => { 'type' => 'custom', 'kind' => 'none', 'params' => {} },
      'answerMode' => 'integer_input',
      'correctAnswer' => { 'type' => 'integer', 'value' => '1' },
      'inputConstraints' => { 'allowNegative' => false, 'maxDigits' => 1 },
      'source' => SOURCE.merge('reference' => 'geometry-grade1-foundation'),
    },
  ],
)

append_questions(
  File.join(ROOT, 'assets/questions/geometry/grade2_foundation.geometry.v1.json'),
  [
    {
      'id' => 'geometry_grade2_foundation_043',
      'topic' => 'geometry',
      'subtopic' => 'border_counting',
      'difficulty' => 'foundation',
      'levelStage' => 'grade2',
      'challengeTier' => 'foundation',
      'prompt' => {
        'zh-Hant' => '一個 3×2 的長方形方格（橫向 3 格、直向 2 格），如果只看最外面的邊框，並在邊框上的每個格點都放 1 顆珠子，一共要放幾顆珠子？',
        'zh-Hans' => '一个 3×2 的长方形方格（横向 3 格、直向 2 格），如果只看最外面的边框，并在边框上的每个格点都放 1 颗珠子，一共要放几颗珠子？',
        'en' => 'A 3×2 rectangular grid has 3 unit squares across and 2 unit squares tall. If beads are placed at every grid point on the outer border only, how many beads are needed?',
        'ja' => '横3マス、縦2マスの長方形の方眼があります。外側のふちだけを見て、そのふち上のすべての格子点に 1 個ずつ玉を置くと、全部で何個いりますか。',
      },
      'answer' => {
        'zh-Hant' => '答案是 10 顆。',
        'zh-Hans' => '答案是 10 颗。',
        'en' => 'The answer is 10.',
        'ja' => '答えは 10 個です。',
      },
      'solutionSteps' => {
        'zh-Hant' => [
          '上邊有 4 個格點，下邊也有 4 個格點。',
          '左右兩邊各還有 1 個中間格點，兩個角已經算過，不要重複。',
          '所以一共是 4 + 4 + 1 + 1 = 10 顆珠子。',
        ],
        'zh-Hans' => [
          '上边有 4 个格点，下边也有 4 个格点。',
          '左右两边各还有 1 个中间格点，两个角已经算过，不要重复。',
          '所以一共是 4 + 4 + 1 + 1 = 10 颗珠子。',
        ],
        'en' => [
          'There are 4 grid points along the top edge and 4 along the bottom edge.',
          'The left and right edges each add 1 middle grid point, since the corner points have already been counted.',
          'So the total is 4 + 4 + 1 + 1 = 10 beads.',
        ],
        'ja' => [
          '上の辺には格子点が 4 個、下の辺にも 4 個あります。',
          '左右の辺には、角をのぞいてそれぞれ真ん中の格子点が 1 個ずつあります。',
          'したがって全部で 4 + 4 + 1 + 1 = 10 個です。',
        ],
      },
      'figure' => { 'type' => 'custom', 'kind' => 'none', 'params' => {} },
      'answerMode' => 'integer_input',
      'correctAnswer' => { 'type' => 'integer', 'value' => '10' },
      'inputConstraints' => { 'allowNegative' => false, 'maxDigits' => 2 },
      'source' => SOURCE.merge('reference' => 'geometry-grade2-foundation'),
    },
  ],
)

append_questions(
  File.join(ROOT, 'assets/questions/geometry/grade3_foundation.geometry.v1.json'),
  [
    {
      'id' => 'geometry_grade3_foundation_045',
      'topic' => 'geometry',
      'subtopic' => 'symmetry',
      'difficulty' => 'foundation',
      'levelStage' => 'grade3',
      'challengeTier' => 'foundation',
      'prompt' => {
        'zh-Hant' => '一個長方形畫上兩條對角線後，會被分成 4 個三角形。這 4 個三角形裡，面積相等的三角形共有幾個？',
        'zh-Hans' => '一个长方形画上两条对角线后，会被分成 4 个三角形。这 4 个三角形里，面积相等的三角形共有几个？',
        'en' => 'A rectangle is drawn with both diagonals. This divides it into 4 triangles. How many of these triangles have equal area?',
        'ja' => '長方形に2本の対角線を引くと、4つの三角形に分かれます。この4つの三角形のうち、面積が等しい三角形は全部でいくつありますか。',
      },
      'answer' => {
        'zh-Hant' => '答案是 4 個。',
        'zh-Hans' => '答案是 4 个。',
        'en' => 'The answer is 4.',
        'ja' => '答えは 4 つです。',
      },
      'solutionSteps' => {
        'zh-Hant' => [
          '長方形的兩條對角線會互相平分。',
          '被分出的 4 個三角形都共用同一個交點，而且底和高的配對完全對稱。',
          '所以這 4 個三角形的面積全部相等，也就是共有 4 個面積相等的三角形。',
        ],
        'zh-Hans' => [
          '长方形的两条对角线会互相平分。',
          '被分出的 4 个三角形都共用同一个交点，而且底和高的配对完全对称。',
          '所以这 4 个三角形的面积全部相等，也就是共有 4 个面积相等的三角形。',
        ],
        'en' => [
          'The diagonals of a rectangle bisect each other.',
          'The 4 triangles formed around the intersection are symmetric in base-height structure.',
          'So all 4 triangles have the same area, meaning there are 4 equal-area triangles in total.',
        ],
        'ja' => [
          '長方形の対角線はたがいに二等分します。',
          '交点のまわりにできる4つの三角形は、底辺と高さの関係が対称です。',
          'したがって4つの三角形の面積はすべて等しく、面積が等しい三角形は全部で 4 つです。',
        ],
      },
      'figure' => { 'type' => 'custom', 'kind' => 'none', 'params' => {} },
      'answerMode' => 'integer_input',
      'correctAnswer' => { 'type' => 'integer', 'value' => '4' },
      'inputConstraints' => { 'allowNegative' => false, 'maxDigits' => 1 },
      'source' => SOURCE.merge('reference' => 'geometry-grade3-foundation'),
    },
  ],
)

append_questions(
  File.join(ROOT, 'assets/questions/geometry/grade4_foundation.geometry.v1.json'),
  [
    {
      'id' => 'geometry_grade4_foundation_043',
      'topic' => 'geometry',
      'subtopic' => 'triangle_angles',
      'difficulty' => 'foundation',
      'levelStage' => 'grade4',
      'challengeTier' => 'foundation',
      'prompt' => {
        'zh-Hant' => '一個三角形的一個外角是 120°。和這個外角不相鄰的其中一個內角是 35°。另一個不相鄰的內角是多少度？',
        'zh-Hans' => '一个三角形的一个外角是 120°。和这个外角不相邻的其中一个内角是 35°。另一个不相邻的内角是多少度？',
        'en' => 'One exterior angle of a triangle is 120°. One of the two non-adjacent interior angles is 35°. What is the other non-adjacent interior angle?',
        'ja' => 'ある三角形の外角の1つが 120° です。この外角ととなり合わない内角の1つが 35° です。もう1つのとなり合わない内角は何度ですか。',
      },
      'answer' => {
        'zh-Hant' => '答案是 85°。',
        'zh-Hans' => '答案是 85°。',
        'en' => 'The answer is 85°.',
        'ja' => '答えは 85° です。',
      },
      'solutionSteps' => {
        'zh-Hant' => [
          '三角形的一個外角，等於另外兩個不相鄰內角的和。',
          '所以另一個不相鄰內角是 120° − 35° = 85°。',
        ],
        'zh-Hans' => [
          '三角形的一个外角，等于另外两个不相邻内角的和。',
          '所以另一个不相邻内角是 120° − 35° = 85°。',
        ],
        'en' => [
          'An exterior angle of a triangle equals the sum of the two non-adjacent interior angles.',
          'So the other non-adjacent angle is 120° − 35° = 85°.',
        ],
        'ja' => [
          '三角形の外角は、となり合わない2つの内角の和に等しいです。',
          'したがって、もう1つの内角は 120° − 35° = 85° です。',
        ],
      },
      'figure' => { 'type' => 'custom', 'kind' => 'none', 'params' => {} },
      'answerMode' => 'integer_input',
      'correctAnswer' => { 'type' => 'integer', 'value' => '85' },
      'inputConstraints' => { 'allowNegative' => false, 'maxDigits' => 2 },
      'source' => SOURCE.merge('reference' => 'geometry-grade4-foundation'),
    },
  ],
)

append_questions(
  File.join(ROOT, 'assets/questions/geometry/grade5_foundation.geometry.v1.json'),
  [
    {
      'id' => 'geometry_grade5_foundation_043',
      'topic' => 'geometry',
      'subtopic' => 'isosceles_properties',
      'difficulty' => 'foundation',
      'levelStage' => 'grade5',
      'challengeTier' => 'foundation',
      'prompt' => {
        'zh-Hant' => '等腰三角形 ABC 中，AB = AC。點 M 是底邊 BC 的中點。已知 AB = 13 公分，BC = 10 公分。三角形 ABM 和三角形 ACM 的周長相差多少公分？',
        'zh-Hans' => '等腰三角形 ABC 中，AB = AC。点 M 是底边 BC 的中点。已知 AB = 13 公分，BC = 10 公分。三角形 ABM 和三角形 ACM 的周长相差多少公分？',
        'en' => 'In isosceles triangle ABC, AB = AC. Point M is the midpoint of base BC. Given AB = 13 cm and BC = 10 cm, how many centimeters do the perimeters of triangles ABM and ACM differ by?',
        'ja' => '二等辺三角形 ABC で、AB = AC です。点 M は底辺 BC の中点です。AB = 13cm、BC = 10cm のとき、三角形 ABM と三角形 ACM の周の長さの差は何cmですか。',
      },
      'answer' => {
        'zh-Hant' => '答案是 0 公分。',
        'zh-Hans' => '答案是 0 公分。',
        'en' => 'The answer is 0 cm.',
        'ja' => '答えは 0cm です。',
      },
      'solutionSteps' => {
        'zh-Hant' => [
          '因為 AB = AC，所以兩個三角形各有一條相等的邊。',
          'M 是 BC 的中點，所以 BM = CM = 5 公分。',
          '而且兩個三角形都共用 AM。',
          '三邊一一對應都相等，所以兩個周長相等，相差 0 公分。',
        ],
        'zh-Hans' => [
          '因为 AB = AC，所以两个三角形各有一条相等的边。',
          'M 是 BC 的中点，所以 BM = CM = 5 公分。',
          '而且两个三角形都共用 AM。',
          '三边一一对应都相等，所以两个周长相等，相差 0 公分。',
        ],
        'en' => [
          'Because AB = AC, the two smaller triangles each have one equal side.',
          'Since M is the midpoint of BC, BM = CM = 5 cm.',
          'The two triangles also share side AM.',
          'All three corresponding sides match, so their perimeters are equal and the difference is 0 cm.',
        ],
        'ja' => [
          'AB = AC なので、2つの小三角形にはそれぞれ等しい辺があります。',
          'M は BC の中点なので、BM = CM = 5cm です。',
          'さらに 2つの三角形は AM を共通に持っています。',
          '対応する3辺がすべて等しいので、周の長さも等しく、差は 0cm です。',
        ],
      },
      'figure' => {
        'type' => 'custom',
        'kind' => 'shape_diagram',
        'params' => {
          'shape' => 'triangle',
          'labels' => {
            'left' => '13',
            'right' => '13',
            'bottom' => '10',
          },
        },
      },
      'answerMode' => 'integer_input',
      'correctAnswer' => { 'type' => 'integer', 'value' => '0' },
      'inputConstraints' => { 'allowNegative' => false, 'maxDigits' => 1 },
      'source' => SOURCE.merge('reference' => 'geometry-grade5-foundation'),
    },
  ],
)

append_questions(
  File.join(ROOT, 'assets/questions/geometry/grade6_foundation.geometry.v1.json'),
  [
    {
      'id' => 'geometry_grade6_foundation_045',
      'topic' => 'geometry',
      'subtopic' => 'parallel_lines',
      'difficulty' => 'foundation',
      'levelStage' => 'grade6',
      'challengeTier' => 'foundation',
      'prompt' => {
        'zh-Hant' => '兩條平行線被一條截線所截，位於截線同一側的兩個內角相差 26°。較小的那個角是多少度？',
        'zh-Hans' => '两条平行线被一条截线所截，位于截线同一侧的两个内角相差 26°。较小的那个角是多少度？',
        'en' => 'Two parallel lines are cut by a transversal. The two same-side interior angles differ by 26°. What is the smaller angle?',
        'ja' => '2本の平行線を1本の直線が横切っています。同じ側にある内角2つの差が 26° です。小さいほうの角は何度ですか。',
      },
      'answer' => {
        'zh-Hant' => '答案是 77°。',
        'zh-Hans' => '答案是 77°。',
        'en' => 'The answer is 77°.',
        'ja' => '答えは 77° です。',
      },
      'solutionSteps' => {
        'zh-Hant' => [
          '同側內角的和是 180°。',
          '設較小的角是 x°，則較大的角是 x + 26°。',
          '所以 x + (x + 26) = 180。',
          '得到 2x = 154，所以 x = 77。',
        ],
        'zh-Hans' => [
          '同侧内角的和是 180°。',
          '设较小的角是 x°，则较大的角是 x + 26°。',
          '所以 x + (x + 26) = 180。',
          '得到 2x = 154，所以 x = 77。',
        ],
        'en' => [
          'Same-side interior angles sum to 180°.',
          'Let the smaller angle be x°, so the larger one is x + 26°.',
          'Then x + (x + 26) = 180.',
          'So 2x = 154 and x = 77.',
        ],
        'ja' => [
          '同じ側の内角の和は 180° です。',
          '小さい角を x° とすると、大きい角は x + 26° です。',
          'したがって x + (x + 26) = 180 です。',
          'よって 2x = 154、x = 77 です。',
        ],
      },
      'figure' => { 'type' => 'custom', 'kind' => 'none', 'params' => {} },
      'answerMode' => 'integer_input',
      'correctAnswer' => { 'type' => 'integer', 'value' => '77' },
      'inputConstraints' => { 'allowNegative' => false, 'maxDigits' => 2 },
      'source' => SOURCE.merge('reference' => 'geometry-grade6-foundation'),
    },
  ],
)

puts 'Appended second mixed geometry batch for grades 1-6.'
