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
      'id' => 'geometry_grade1_foundation_044',
      'topic' => 'geometry',
      'subtopic' => 'grid_path',
      'difficulty' => 'foundation',
      'levelStage' => 'grade1',
      'challengeTier' => 'foundation',
      'prompt' => {
        'zh-Hant' => '在方格紙上，小兔要從一個長 3 格、寬 2 格的長方形左下角，沿著格線走到右上角，不能斜走。若只走最短路線，最少要走幾格？',
        'zh-Hans' => '在方格纸上，小兔要从一个长 3 格、宽 2 格的长方形左下角，沿着格线走到右上角，不能斜走。若只走最短路线，最少要走几格？',
        'en' => 'On grid paper, a rabbit goes from the bottom-left corner of a 3-by-2 rectangle to the top-right corner along grid lines, without moving diagonally. If it takes a shortest route, how many unit segments does it walk?',
        'ja' => '方眼紙で、うさぎが横3マス、縦2マスの長方形の左下の角から右上の角まで、斜めに進まず格子線に沿って進みます。最短で進むと何マス分進みますか。',
      },
      'answer' => {
        'zh-Hant' => '答案是 5 格。',
        'zh-Hans' => '答案是 5 格。',
        'en' => 'The answer is 5.',
        'ja' => '答えは 5 マス分です。',
      },
      'solutionSteps' => {
        'zh-Hant' => [
          '從左下走到右上，一定要向右走 3 格。',
          '也一定要向上走 2 格。',
          '最短路線就是把需要走的格數全部加起來：3 + 2 = 5。',
        ],
        'zh-Hans' => [
          '从左下走到右上，一定要向右走 3 格。',
          '也一定要向上走 2 格。',
          '最短路线就是把需要走的格数全部加起来：3 + 2 = 5。',
        ],
        'en' => [
          'To get from the bottom-left to the top-right, the rabbit must move 3 units right.',
          'It must also move 2 units up.',
          'So the shortest route has length 3 + 2 = 5.',
        ],
        'ja' => [
          '左下から右上へ行くには、右に 3 マス進む必要があります。',
          'また、上に 2 マス進む必要があります。',
          'したがって最短の長さは 3 + 2 = 5 です。',
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
      'id' => 'geometry_grade2_foundation_044',
      'topic' => 'geometry',
      'subtopic' => 'shape_composition',
      'difficulty' => 'foundation',
      'levelStage' => 'grade2',
      'challengeTier' => 'foundation',
      'prompt' => {
        'zh-Hant' => '兩個一樣大的直角三角形，正好可以拼成一個長 6 公分、寬 4 公分的長方形。每一個三角形的面積是多少平方公分？',
        'zh-Hans' => '两个一样大的直角三角形，正好可以拼成一个长 6 公分、宽 4 公分的长方形。每一个三角形的面积是多少平方公分？',
        'en' => 'Two congruent right triangles fit together exactly to form a rectangle 6 cm long and 4 cm wide. What is the area of each triangle?',
        'ja' => '同じ大きさの直角三角形2つをぴったり合わせると、たて6cm、横4cmの長方形になります。三角形1つの面積は何平方cmですか。',
      },
      'answer' => {
        'zh-Hant' => '答案是 12 平方公分。',
        'zh-Hans' => '答案是 12 平方公分。',
        'en' => 'The answer is 12 square centimeters.',
        'ja' => '答えは 12 平方cmです。',
      },
      'solutionSteps' => {
        'zh-Hant' => [
          '先算長方形面積：6 × 4 = 24 平方公分。',
          '這個長方形是由兩個一樣大的三角形拼成的。',
          '所以每一個三角形的面積是 24 ÷ 2 = 12 平方公分。',
        ],
        'zh-Hans' => [
          '先算长方形面积：6 × 4 = 24 平方公分。',
          '这个长方形是由两个一样大的三角形拼成的。',
          '所以每一个三角形的面积是 24 ÷ 2 = 12 平方公分。',
        ],
        'en' => [
          'First find the area of the rectangle: 6 × 4 = 24 square centimeters.',
          'The rectangle is made from two congruent triangles.',
          'So each triangle has area 24 ÷ 2 = 12 square centimeters.',
        ],
        'ja' => [
          'まず長方形の面積は 6 × 4 = 24 平方cm です。',
          'この長方形は同じ大きさの三角形2つでできています。',
          'したがって三角形1つの面積は 24 ÷ 2 = 12 平方cm です。',
        ],
      },
      'figure' => {
        'type' => 'custom',
        'kind' => 'shape_diagram',
        'params' => {
          'shape' => 'rectangle',
          'labels' => {
            'top' => '6',
            'right' => '4',
          },
        },
      },
      'answerMode' => 'integer_input',
      'correctAnswer' => { 'type' => 'integer', 'value' => '12' },
      'inputConstraints' => { 'allowNegative' => false, 'maxDigits' => 2 },
      'source' => SOURCE.merge('reference' => 'geometry-grade2-foundation'),
    },
  ],
)

append_questions(
  File.join(ROOT, 'assets/questions/geometry/grade3_foundation.geometry.v1.json'),
  [
    {
      'id' => 'geometry_grade3_foundation_046',
      'topic' => 'geometry',
      'subtopic' => 'shape_cutting',
      'difficulty' => 'foundation',
      'levelStage' => 'grade3',
      'challengeTier' => 'foundation',
      'prompt' => {
        'zh-Hant' => '一個長方形長 8 公分、寬 6 公分，沿著一條對角線剪開，分成兩個一樣大的三角形。每一個三角形的面積是多少平方公分？',
        'zh-Hans' => '一个长方形长 8 公分、宽 6 公分，沿着一条对角线剪开，分成两个一样大的三角形。每一个三角形的面积是多少平方公分？',
        'en' => 'A rectangle is 8 cm by 6 cm. It is cut along a diagonal into two equal triangles. What is the area of each triangle?',
        'ja' => 'たて8cm、横6cmの長方形を対角線に沿って切ると、同じ大きさの三角形2つに分かれます。三角形1つの面積は何平方cmですか。',
      },
      'answer' => {
        'zh-Hant' => '答案是 24 平方公分。',
        'zh-Hans' => '答案是 24 平方公分。',
        'en' => 'The answer is 24 square centimeters.',
        'ja' => '答えは 24 平方cmです。',
      },
      'solutionSteps' => {
        'zh-Hant' => [
          '先算整個長方形的面積：8 × 6 = 48 平方公分。',
          '沿對角線剪開後會分成兩個一樣大的三角形。',
          '所以每一個三角形的面積是 48 ÷ 2 = 24 平方公分。',
        ],
        'zh-Hans' => [
          '先算整个长方形的面积：8 × 6 = 48 平方公分。',
          '沿对角线剪开后会分成两个一样大的三角形。',
          '所以每一个三角形的面积是 48 ÷ 2 = 24 平方公分。',
        ],
        'en' => [
          'First find the area of the whole rectangle: 8 × 6 = 48 square centimeters.',
          'Cutting along a diagonal splits it into two equal triangles.',
          'So each triangle has area 48 ÷ 2 = 24 square centimeters.',
        ],
        'ja' => [
          'まず長方形全体の面積は 8 × 6 = 48 平方cm です。',
          '対角線で切ると、同じ大きさの三角形2つに分かれます。',
          'したがって三角形1つの面積は 48 ÷ 2 = 24 平方cm です。',
        ],
      },
      'figure' => {
        'type' => 'custom',
        'kind' => 'shape_diagram',
        'params' => {
          'shape' => 'rectangle',
          'labels' => {
            'top' => '8',
            'right' => '6',
          },
        },
      },
      'answerMode' => 'integer_input',
      'correctAnswer' => { 'type' => 'integer', 'value' => '24' },
      'inputConstraints' => { 'allowNegative' => false, 'maxDigits' => 2 },
      'source' => SOURCE.merge('reference' => 'geometry-grade3-foundation'),
    },
  ],
)

append_questions(
  File.join(ROOT, 'assets/questions/geometry/grade4_foundation.geometry.v1.json'),
  [
    {
      'id' => 'geometry_grade4_foundation_044',
      'topic' => 'geometry',
      'subtopic' => 'symmetry',
      'difficulty' => 'foundation',
      'levelStage' => 'grade4',
      'challengeTier' => 'foundation',
      'prompt' => {
        'zh-Hant' => '一個正方形上同時畫出兩條對角線。把「正方形和這兩條對角線」看成整個圖形，這個圖形共有幾條對稱線？',
        'zh-Hans' => '一个正方形上同时画出两条对角线。把“正方形和这两条对角线”看成整个图形，这个图形共有几条对称线？',
        'en' => 'A square has both diagonals drawn. Considering the square together with these two diagonals as one figure, how many lines of symmetry does the figure have?',
        'ja' => '正方形に2本の対角線を引きます。「正方形と2本の対角線」をまとめて1つの図形と考えると、対称の軸は全部で何本ありますか。',
      },
      'answer' => {
        'zh-Hant' => '答案是 4 條。',
        'zh-Hans' => '答案是 4 条。',
        'en' => 'The answer is 4.',
        'ja' => '答えは 4 本です。',
      },
      'solutionSteps' => {
        'zh-Hant' => [
          '正方形本來就有 4 條對稱線：上下中線、左右中線、兩條對角線。',
          '畫上兩條對角線後，這 4 條對稱線都還保留。',
          '所以整個圖形共有 4 條對稱線。',
        ],
        'zh-Hans' => [
          '正方形本来就有 4 条对称线：上下中线、左右中线、两条对角线。',
          '画上两条对角线后，这 4 条对称线都还保留。',
          '所以整个图形共有 4 条对称线。',
        ],
        'en' => [
          'A square has 4 symmetry lines: the vertical midline, horizontal midline, and the two diagonals.',
          'Drawing in both diagonals does not remove any of these symmetries.',
          'So the whole figure has 4 lines of symmetry.',
        ],
        'ja' => [
          '正方形にはもともと、上下の中線・左右の中線・2本の対角線の、合計4本の対称の軸があります。',
          '2本の対角線を描いても、その4本の対称性は失われません。',
          'したがって図形全体の対称の軸は 4 本です。',
        ],
      },
      'figure' => {
        'type' => 'custom',
        'kind' => 'shape_diagram',
        'params' => {
          'shape' => 'square',
          'labels' => {},
        },
      },
      'answerMode' => 'integer_input',
      'correctAnswer' => { 'type' => 'integer', 'value' => '4' },
      'inputConstraints' => { 'allowNegative' => false, 'maxDigits' => 1 },
      'source' => SOURCE.merge('reference' => 'geometry-grade4-foundation'),
    },
  ],
)

append_questions(
  File.join(ROOT, 'assets/questions/geometry/grade5_foundation.geometry.v1.json'),
  [
    {
      'id' => 'geometry_grade5_foundation_044',
      'topic' => 'geometry',
      'subtopic' => 'reflection_x_axis',
      'difficulty' => 'foundation',
      'levelStage' => 'grade5',
      'challengeTier' => 'foundation',
      'prompt' => {
        'zh-Hant' => '座標平面上有一點 P(4,7)。把 P 對 x 軸鏡射得到點 P\'。線段 PP\' 的長度是多少？',
        'zh-Hans' => '坐标平面上有一点 P(4,7)。把 P 对 x 轴镜射得到点 P\'。线段 PP\' 的长度是多少？',
        'en' => 'On the coordinate plane, point P is at (4,7). Reflect P across the x-axis to get P\'. What is the length of segment PP\'?',
        'ja' => '座標平面上に点 P(4,7) があります。P を x 軸について対称移動して点 P\' を作ります。線分 PP\' の長さはどれだけですか。',
      },
      'answer' => {
        'zh-Hant' => '答案是 14。',
        'zh-Hans' => '答案是 14。',
        'en' => 'The answer is 14.',
        'ja' => '答えは 14 です。',
      },
      'solutionSteps' => {
        'zh-Hant' => [
          '對 x 軸鏡射時，x 座標不變，y 座標會變成相反數。',
          '所以 P\' 的座標是 (4,-7)。',
          'P 和 P\' 在同一直線上，上下相距 7 + 7 = 14。',
          '因此線段 PP\' 長 14。',
        ],
        'zh-Hans' => [
          '对 x 轴镜射时，x 坐标不变，y 坐标会变成相反数。',
          '所以 P\' 的坐标是 (4,-7)。',
          'P 和 P\' 在同一直线上，上下相距 7 + 7 = 14。',
          '因此线段 PP\' 长 14。',
        ],
        'en' => [
          'Reflecting across the x-axis keeps the x-coordinate the same and changes the y-coordinate to its opposite.',
          'So P\' is at (4,-7).',
          'The two points lie on the same vertical line and are 7 + 7 = 14 units apart.',
          'Therefore segment PP\' has length 14.',
        ],
        'ja' => [
          'x 軸について対称移動すると、x 座標はそのままで、y 座標は符号が反対になります。',
          'したがって P\' は (4,-7) です。',
          '2点は同じ縦の直線上にあり、距離は 7 + 7 = 14 です。',
          'よって線分 PP\' の長さは 14 です。',
        ],
      },
      'figure' => {
        'type' => 'custom',
        'kind' => 'coordinate_plane',
        'params' => {
          'maxX' => 6,
          'maxY' => 8,
          'showGrid' => true,
          'points' => [
            { 'x' => 4, 'y' => 7, 'label' => 'P' },
            { 'x' => 4, 'y' => -7, 'label' => "P'" },
          ],
          'path' => [
            { 'x' => 4, 'y' => 7 },
            { 'x' => 4, 'y' => -7 },
          ],
        },
      },
      'answerMode' => 'integer_input',
      'correctAnswer' => { 'type' => 'integer', 'value' => '14' },
      'inputConstraints' => { 'allowNegative' => false, 'maxDigits' => 2 },
      'source' => SOURCE.merge('reference' => 'geometry-grade5-foundation'),
    },
  ],
)

append_questions(
  File.join(ROOT, 'assets/questions/geometry/grade6_foundation.geometry.v1.json'),
  [
    {
      'id' => 'geometry_grade6_foundation_046',
      'topic' => 'geometry',
      'subtopic' => 'half_turn',
      'difficulty' => 'foundation',
      'levelStage' => 'grade6',
      'challengeTier' => 'foundation',
      'prompt' => {
        'zh-Hant' => '在座標平面上，點 A(1,2) 以點 O(3,4) 為中心旋轉 180° 後，得到點 A\'。A\' 的座標是什麼？',
        'zh-Hans' => '在坐标平面上，点 A(1,2) 以点 O(3,4) 为中心旋转 180° 后，得到点 A\'。A\' 的坐标是什么？',
        'en' => 'On the coordinate plane, point A(1,2) is rotated 180° about O(3,4) to get A\'. What are the coordinates of A\'?',
        'ja' => '座標平面で、点 A(1,2) を点 O(3,4) を中心に 180° 回転して点 A\' を作ります。A\' の座標は何ですか。',
      },
      'answer' => {
        'zh-Hant' => '答案是 (5,6)。',
        'zh-Hans' => '答案是 (5,6)。',
        'en' => 'The answer is (5,6).',
        'ja' => '答えは (5,6) です。',
      },
      'solutionSteps' => {
        'zh-Hant' => [
          '以 O 為中心旋轉 180°，表示 O 是 AA\' 的中點。',
          'A 到 O 的位移是向右 2、向上 2。',
          '所以 O 到 A\' 也要向右 2、向上 2。',
          'A\' = (3 + 2, 4 + 2) = (5,6)。',
        ],
        'zh-Hans' => [
          '以 O 为中心旋转 180°，表示 O 是 AA\' 的中点。',
          'A 到 O 的位移是向右 2、向上 2。',
          '所以 O 到 A\' 也要向右 2、向上 2。',
          'A\' = (3 + 2, 4 + 2) = (5,6)。',
        ],
        'en' => [
          'A 180° rotation about O means that O is the midpoint of AA\'.',
          'From A to O, the movement is 2 units right and 2 units up.',
          'So from O to A\', move 2 units right and 2 units up again.',
          'Thus A\' = (3 + 2, 4 + 2) = (5,6).',
        ],
        'ja' => [
          '点 O を中心とする 180° 回転では、O は AA\' の中点になります。',
          'A から O へは、右に 2、上に 2 動きます。',
          'したがって O から A\' へも、右に 2、上に 2 動きます。',
          'よって A\' = (3 + 2, 4 + 2) = (5,6) です。',
        ],
      },
      'figure' => {
        'type' => 'custom',
        'kind' => 'coordinate_plane',
        'params' => {
          'maxX' => 7,
          'maxY' => 7,
          'showGrid' => true,
          'points' => [
            { 'x' => 1, 'y' => 2, 'label' => 'A' },
            { 'x' => 3, 'y' => 4, 'label' => 'O' },
          ],
          'path' => [
            { 'x' => 1, 'y' => 2 },
            { 'x' => 3, 'y' => 4 },
          ],
        },
      },
      'answerMode' => 'multiple_choice',
      'options' => {
        'A' => {
          'zh-Hant' => '(1,6)',
          'zh-Hans' => '(1,6)',
          'en' => '(1,6)',
          'ja' => '(1,6)',
        },
        'B' => {
          'zh-Hant' => '(5,6)',
          'zh-Hans' => '(5,6)',
          'en' => '(5,6)',
          'ja' => '(5,6)',
        },
        'C' => {
          'zh-Hant' => '(5,2)',
          'zh-Hans' => '(5,2)',
          'en' => '(5,2)',
          'ja' => '(5,2)',
        },
        'D' => {
          'zh-Hant' => '(3,4)',
          'zh-Hans' => '(3,4)',
          'en' => '(3,4)',
          'ja' => '(3,4)',
        },
      },
      'correctAnswer' => { 'type' => 'choice', 'value' => 'B' },
      'source' => SOURCE.merge('reference' => 'geometry-grade6-foundation'),
    },
  ],
)

puts 'Appended third mixed geometry batch for grades 1-6.'
