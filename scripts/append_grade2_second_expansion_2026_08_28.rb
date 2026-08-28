#!/usr/bin/env ruby
# frozen_string_literal: true

# grade2 第二輪擴充（2026-08-28）：geometry 6 / logic 7 / arithmetic 7
# 幾何只放 6 題：grade2 幾何已有 15 種 subtopic、48 題，再多放會變成既有題的弱變形，
# 因此把名額移到仍有缺口的 logic 與 arithmetic。
require 'json'
require 'set'

ROOT = File.expand_path('..', __dir__)
GRADE = 'grade2'
PATHS = %w[geometry logic arithmetic].to_h { |t| [t, File.join(ROOT, "assets/questions/#{t}/#{GRADE}_foundation.#{t}.v1.json")] }.freeze
MANIFEST_PATH = File.join(ROOT, 'assets/questions/manifest.json')

def load_json(path) = JSON.parse(File.read(path))
def save_json(path, data) = File.write(path, JSON.pretty_generate(data) + "\n")

def base(topic:, subtopic:, prompt:, answer:, steps:, notes:)
  { 'reviewStatus' => 'ok', 'topic' => topic, 'subtopic' => subtopic,
    'difficulty' => 'foundation', 'levelStage' => GRADE, 'challengeTier' => 'foundation',
    'prompt' => prompt, 'answer' => answer, 'solutionSteps' => steps,
    'figure' => { 'type' => 'custom', 'kind' => 'none', 'params' => {} },
    'source' => { 'type' => 'rewritten_olympiad_style', 'name' => 'MathSpring Editorial',
                  'reference' => "#{topic}-#{GRADE}-foundation", 'notes' => notes } }
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
      topic: 'geometry', subtopic: 'paper_folding',
      prompt: {
        'zh-Hant' => '一條長長的紙帶，從中間對摺一次，再把摺好的整疊從中間對摺一次，這樣連續對摺 3 次。然後把紙帶完全攤開。紙帶上一共會出現幾條摺痕？',
        'zh-Hans' => '一条长长的纸带，从中间对折一次，再把折好的整叠从中间对折一次，这样连续对折 3 次。然后把纸带完全摊开。纸带上一共会出现几条折痕？',
        'en' => 'A long paper strip is folded in half, then the whole folded bundle is folded in half again, three folds in all. The strip is then opened out completely. How many crease lines appear on the strip?',
        'ja' => '長い紙テープを半分に折り、折った束をまた半分に折る、というように続けて 3 回折ります。そのあとテープを完全に開きます。テープにはあわせて何本の折り目ができますか。',
      },
      answer: { 'zh-Hant' => '答案是 7 條。', 'zh-Hans' => '答案是 7 条。',
                'en' => 'The answer is 7 creases.', 'ja' => '答えは 7 本です。' },
      steps: {
        'zh-Hant' => [
          '對摺 1 次後攤開，紙帶被分成 2 段，中間有 1 條摺痕。',
          '對摺 2 次後攤開，紙帶被分成 4 段，段與段之間有 3 條摺痕。',
          '每多對摺 1 次，段數就變成兩倍，所以對摺 3 次後紙帶被分成 8 段。',
          '被分成 8 段時，段與段之間的分界有 8 − 1 = 7 個。',
          '所以一共有 7 條摺痕。',
        ],
        'zh-Hans' => [
          '对折 1 次后摊开，纸带被分成 2 段，中间有 1 条折痕。',
          '对折 2 次后摊开，纸带被分成 4 段，段与段之间有 3 条折痕。',
          '每多对折 1 次，段数就变成两倍，所以对折 3 次后纸带被分成 8 段。',
          '被分成 8 段时，段与段之间的分界有 8 − 1 = 7 个。',
          '所以一共有 7 条折痕。',
        ],
        'en' => [
          'After 1 fold and opening out, the strip is in 2 parts with 1 crease between them.',
          'After 2 folds it is in 4 parts with 3 creases between them.',
          'Each extra fold doubles the number of parts, so after 3 folds the strip is in 8 parts.',
          'With 8 parts there are 8 − 1 = 7 boundaries between neighbouring parts.',
          'So there are 7 creases altogether.',
        ],
        'ja' => [
          '1 回折って開くと、テープは 2 つに分かれ、折り目は 1 本です。',
          '2 回折って開くと 4 つに分かれ、折り目は 3 本です。',
          '折る回数が 1 増えるごとに部分の数は 2 倍になるので、3 回折ると 8 つに分かれます。',
          '8 つに分かれると、となり合う部分の境目は 8 − 1 = 7 か所です。',
          'したがって折り目は 7 本です。',
        ],
      },
      value: '7', max_digits: 1,
      notes: 'Original composition in the Math Kangaroo grade 1-2 folding style; the count is of creases rather than layers or holes, so the answer is one less than the number of parts. Not a reproduction of any past paper.',
    ),
    int_q(
      topic: 'geometry', subtopic: 'composite_area',
      prompt: {
        'zh-Hant' => '一個長 4 單位、寬 3 單位的長方形，從它的右下角挖掉一個長 2 單位、寬 1 單位的小長方形，剩下的部分是一個 L 形。這個 L 形的面積是多少平方單位？',
        'zh-Hans' => '一个长 4 单位、宽 3 单位的长方形，从它的右下角挖掉一个长 2 单位、宽 1 单位的小长方形，剩下的部分是一个 L 形。这个 L 形的面积是多少平方单位？',
        'en' => 'A rectangle 4 units long and 3 units wide has a smaller rectangle 2 units long and 1 unit wide cut away from its bottom-right corner, leaving an L-shape. What is the area of the L-shape, in square units?',
        'ja' => '縦 3 単位、横 4 単位の長方形の右下のすみから、縦 1 単位、横 2 単位の小さい長方形を切り取ると、L 字形が残ります。この L 字形の面積は何平方単位ですか。',
      },
      answer: { 'zh-Hant' => '答案是 10 平方單位。', 'zh-Hans' => '答案是 10 平方单位。',
                'en' => 'The answer is 10 square units.', 'ja' => '答えは 10 平方単位です。' },
      steps: {
        'zh-Hant' => [
          '先算原來長方形的面積：長 4、寬 3，面積是 4 × 3 = 12 平方單位。',
          '再算被挖掉的小長方形面積：長 2、寬 1，面積是 2 × 1 = 2 平方單位。',
          'L 形就是原來的長方形扣掉被挖走的部分。',
          '所以 L 形的面積是 12 − 2 = 10 平方單位。',
        ],
        'zh-Hans' => [
          '先算原来长方形的面积：长 4、宽 3，面积是 4 × 3 = 12 平方单位。',
          '再算被挖掉的小长方形面积：长 2、宽 1，面积是 2 × 1 = 2 平方单位。',
          'L 形就是原来的长方形扣掉被挖走的部分。',
          '所以 L 形的面积是 12 − 2 = 10 平方单位。',
        ],
        'en' => [
          'First find the area of the original rectangle: 4 long by 3 wide gives 4 × 3 = 12 square units.',
          'Next find the area of the piece cut away: 2 long by 1 wide gives 2 × 1 = 2 square units.',
          'The L-shape is the original rectangle with that piece removed.',
          'So the area of the L-shape is 12 − 2 = 10 square units.',
        ],
        'ja' => [
          'まずもとの長方形の面積を求めます。縦 3、横 4 なので 4 × 3 = 12 平方単位です。',
          '次に切り取った小さい長方形の面積は、縦 1、横 2 なので 2 × 1 = 2 平方単位です。',
          'L 字形はもとの長方形から切り取った部分を除いたものです。',
          'したがって L 字形の面積は 12 − 2 = 10 平方単位です。',
        ],
      },
      value: '10', max_digits: 2,
      notes: 'Original composition in the Math Kangaroo grade 1-2 composite-area style; the area is found by subtraction from a bounding rectangle rather than by counting squares. Not a reproduction of any past paper.',
    ),
    int_q(
      topic: 'geometry', subtopic: 'angles',
      prompt: {
        'zh-Hant' => '長方形的每一個角都是直角。從長方形的一個角上畫一條直線到對邊，把這個角分成兩個角。如果其中一個角是 30 度，另一個角是幾度？',
        'zh-Hans' => '长方形的每一个角都是直角。从长方形的一个角上画一条直线到对边，把这个角分成两个角。如果其中一个角是 30 度，另一个角是几度？',
        'en' => 'Every corner of a rectangle is a right angle. A straight line is drawn from one corner to the opposite side, splitting that corner into two angles. If one of them is 30 degrees, how many degrees is the other?',
        'ja' => '長方形の角はどれも直角です。1 つの角から向かいの辺へ直線を引き、その角を 2 つの角に分けます。一方が 30 度のとき、もう一方は何度ですか。',
      },
      answer: { 'zh-Hant' => '答案是 60 度。', 'zh-Hans' => '答案是 60 度。',
                'en' => 'The answer is 60 degrees.', 'ja' => '答えは 60 度です。' },
      steps: {
        'zh-Hant' => [
          '長方形的角是直角，直角是 90 度。',
          '畫的那條直線把這個 90 度的角分成兩個角，這兩個角合起來還是 90 度。',
          '已經知道其中一個角是 30 度。',
          '所以另一個角是 90 − 30 = 60 度。',
        ],
        'zh-Hans' => [
          '长方形的角是直角，直角是 90 度。',
          '画的那条直线把这个 90 度的角分成两个角，这两个角合起来还是 90 度。',
          '已经知道其中一个角是 30 度。',
          '所以另一个角是 90 − 30 = 60 度。',
        ],
        'en' => [
          'A corner of a rectangle is a right angle, which measures 90 degrees.',
          'The line splits that 90 degree angle into two angles, and together they still make 90 degrees.',
          'One of them is known to be 30 degrees.',
          'So the other is 90 − 30 = 60 degrees.',
        ],
        'ja' => [
          '長方形の角は直角で、直角は 90 度です。',
          '引いた直線はその 90 度の角を 2 つに分けますが、2 つを合わせるとやはり 90 度です。',
          '一方が 30 度とわかっています。',
          'したがってもう一方は 90 − 30 = 60 度です。',
        ],
      },
      value: '60', max_digits: 2,
      notes: 'Original composition in the Math Kangaroo grade 1-2 angle style; the right angle is treated as a total to be split, which differs from the grade1 item where a diagonal destroys right angles. Not a reproduction of any past paper.',
    ),
    mc_q(
      topic: 'geometry', subtopic: 'translation',
      prompt: {
        'zh-Hant' => '方格紙上有一個圖形。把它先向右移動 3 格，再向下移動 2 格，最後再向左移動 3 格。最後這個圖形會在原來位置的哪個方向、相隔幾格？',
        'zh-Hans' => '方格纸上有一个图形。把它先向右移动 3 格，再向下移动 2 格，最后再向左移动 3 格。最后这个图形会在原来位置的哪个方向、相隔几格？',
        'en' => 'A shape on grid paper is moved 3 squares right, then 2 squares down, then 3 squares left. Where does it end up relative to its starting position?',
        'ja' => '方眼紙の上の図形を、右に 3 マス、次に下に 2 マス、最後に左に 3 マス動かします。最後にこの図形はもとの位置から見てどの向きに何マスのところにありますか。',
      },
      answer: { 'zh-Hant' => '在原來位置的正下方 2 格。', 'zh-Hans' => '在原来位置的正下方 2 格。',
                'en' => 'Two squares directly below the starting position.', 'ja' => 'もとの位置の真下 2 マスのところです。' },
      steps: {
        'zh-Hant' => [
          '左右方向和上下方向可以分開來看，互不影響。',
          '左右方向：先向右 3 格，最後又向左 3 格，兩者剛好抵消，左右方向沒有移動。',
          '上下方向：只有向下移動 2 格這一次。',
          '所以圖形最後在原來位置的正下方 2 格。',
        ],
        'zh-Hans' => [
          '左右方向和上下方向可以分开来看，互不影响。',
          '左右方向：先向右 3 格，最后又向左 3 格，两者刚好抵消，左右方向没有移动。',
          '上下方向：只有向下移动 2 格这一次。',
          '所以图形最后在原来位置的正下方 2 格。',
        ],
        'en' => [
          'The left-right direction and the up-down direction can be treated separately, since they do not affect each other.',
          'Left-right: 3 squares right and later 3 squares left cancel exactly, so there is no net sideways movement.',
          'Up-down: the only such move is 2 squares down.',
          'So the shape ends up 2 squares directly below where it started.',
        ],
        'ja' => [
          '左右の動きと上下の動きは互いに影響しないので、分けて考えられます。',
          '左右は、右に 3 マスのあと左に 3 マスでちょうど打ち消し合い、横方向には動いていません。',
          '上下は、下に 2 マスの 1 回だけです。',
          'したがって図形はもとの位置の真下 2 マスのところにあります。',
        ],
      },
      options: {
        'A' => { 'zh-Hant' => '正下方 2 格', 'zh-Hans' => '正下方 2 格', 'en' => 'Two squares directly below', 'ja' => '真下 2 マス' },
        'B' => { 'zh-Hant' => '正上方 2 格', 'zh-Hans' => '正上方 2 格', 'en' => 'Two squares directly above', 'ja' => '真上 2 マス' },
        'C' => { 'zh-Hant' => '右下方，向右 3 格向下 2 格', 'zh-Hans' => '右下方，向右 3 格向下 2 格',
                 'en' => 'Three squares right and two squares down', 'ja' => '右に 3 マス下に 2 マス' },
        'D' => { 'zh-Hant' => '回到原來的位置', 'zh-Hans' => '回到原来的位置',
                 'en' => 'Back at the starting position', 'ja' => 'もとの位置にもどる' },
      },
      correct: 'A',
      notes: 'Original composition in the Math Kangaroo grade 1-2 translation style; the two horizontal moves cancel, so the solver must combine the moves per direction rather than follow them one at a time. Not a reproduction of any past paper.',
    ),
    int_q(
      topic: 'geometry', subtopic: 'shape_composition',
      prompt: {
        'zh-Hant' => '用 4 個一樣大的小正方形拼圖形，每個小正方形都必須至少和另一個小正方形有一整條邊完全貼合，不可以只有角碰角。如果把翻轉或旋轉後看起來一樣的拼法算成同一種，一共可以拼出幾種不同的形狀？',
        'zh-Hans' => '用 4 个一样大的小正方形拼图形，每个小正方形都必须至少和另一个小正方形有一整条边完全贴合，不可以只有角碰角。如果把翻转或旋转后看起来一样的拼法算成同一种，一共可以拼出几种不同的形状？',
        'en' => 'Four identical small squares are joined to make a shape, where each square must share a whole edge with another square and touching only at a corner is not allowed. Counting shapes that look the same after turning or flipping as one, how many different shapes can be made?',
        'ja' => '同じ大きさの小さい正方形 4 個をつなげて図形を作ります。どの正方形も辺 1 本をぴったり共有していなければならず、角だけで接するのは認めません。回したり裏返したりして同じに見えるものは 1 種類と数えるとき、ちがう形は何種類できますか。',
      },
      answer: { 'zh-Hant' => '答案是 5 種。', 'zh-Hans' => '答案是 5 种。',
                'en' => 'The answer is 5 shapes.', 'ja' => '答えは 5 種類です。' },
      steps: {
        'zh-Hant' => [
          '有系統地想：先看四個正方形排成一直線的情形，這是第 1 種。',
          '再看三個排成一直線、第四個貼在中間那格的上方，形成 T 形，這是第 2 種；如果第四個貼在旁邊那格的上方，會形成 L 形，這是第 3 種。',
          '也可以三個排成一直線、第四個貼在另一端的上方，但那和 L 形翻轉後一樣，不能算新的。',
          '接著看兩個兩個排：兩個一組上下錯開一格，形成 S 形，這是第 4 種。',
          '最後是四個排成 2 × 2 的正方形，這是第 5 種。全部檢查完，一共有 5 種不同的形狀。',
        ],
        'zh-Hans' => [
          '有系统地想：先看四个正方形排成一直线的情形，这是第 1 种。',
          '再看三个排成一直线、第四个贴在中间那格的上方，形成 T 形，这是第 2 种；如果第四个贴在旁边那格的上方，会形成 L 形，这是第 3 种。',
          '也可以三个排成一直线、第四个贴在另一端的上方，但那和 L 形翻转后一样，不能算新的。',
          '接着看两个两个排：两个一组上下错开一格，形成 S 形，这是第 4 种。',
          '最后是四个排成 2 × 2 的正方形，这是第 5 种。全部检查完，一共有 5 种不同的形状。',
        ],
        'en' => [
          'Work through the cases systematically. First, all four squares in a straight line: that is shape 1.',
          'Next, three in a line with the fourth attached above the middle one gives a T-shape, shape 2; attaching it above a neighbouring square instead gives an L-shape, shape 3.',
          'Attaching the fourth above the other end also gives an L-shape after flipping, so it is not a new one.',
          'Then two pairs: two squares beside two squares offset by one gives an S-shape, shape 4.',
          'Finally four squares in a 2 × 2 block is shape 5. Checking all the cases gives 5 different shapes.',
        ],
        'ja' => [
          '順序よく調べます。まず 4 個を一直線に並べる場合が 1 種類目です。',
          '次に 3 個を一直線に並べ、4 個目をまん中の上につけると T 字形で 2 種類目、となりの上につけると L 字形で 3 種類目です。',
          '4 個目を反対のはしの上につけても、裏返すと L 字形と同じなので新しくは数えません。',
          '続いて 2 個ずつ並べ、1 マスずらして重ねると S 字形になり 4 種類目です。',
          '最後に 4 個を 2 × 2 に並べた正方形が 5 種類目です。すべて調べると 5 種類になります。',
        ],
      },
      value: '5', max_digits: 1,
      notes: 'Original composition in the Math Kangaroo grade 1-2 polyomino style; the solver must enumerate systematically and recognise that flips and turns do not create new shapes. Not a reproduction of any past paper.',
    ),
    int_q(
      topic: 'geometry', subtopic: 'perimeter_area',
      prompt: {
        'zh-Hant' => '一個長方形的周長是 12 單位，而且它的長和寬都是整數單位。長和寬相同、只是擺放方向不同的長方形算成同一種。這樣的長方形一共有幾種？',
        'zh-Hans' => '一个长方形的周长是 12 单位，而且它的长和宽都是整数单位。长和宽相同、只是摆放方向不同的长方形算成同一种。这样的长方形一共有几种？',
        'en' => 'A rectangle has a perimeter of 12 units and both its length and width are whole numbers of units. Rectangles with the same two side lengths count as one, however they are turned. How many such rectangles are there?',
        'ja' => 'ある長方形の周の長さは 12 単位で、縦も横も整数単位です。縦と横の長さが同じものは、向きがちがっても 1 種類と数えます。このような長方形は何種類ありますか。',
      },
      answer: { 'zh-Hant' => '答案是 3 種。', 'zh-Hans' => '答案是 3 种。',
                'en' => 'The answer is 3 rectangles.', 'ja' => '答えは 3 種類です。' },
      steps: {
        'zh-Hant' => [
          '長方形的周長是長和寬各兩條，也就是 (長 + 寬) × 2。',
          '周長是 12，所以長 + 寬 = 12 ÷ 2 = 6。',
          '長和寬都是整數，而且都要大於 0，所以把 6 拆成兩個正整數相加：1 + 5、2 + 4、3 + 3。',
          '（4 + 2 和 5 + 1 只是把長寬對調，算成同一種。）',
          '所以這樣的長方形一共有 3 種。',
        ],
        'zh-Hans' => [
          '长方形的周长是长和宽各两条，也就是 (长 + 宽) × 2。',
          '周长是 12，所以长 + 宽 = 12 ÷ 2 = 6。',
          '长和宽都是整数，而且都要大于 0，所以把 6 拆成两个正整数相加：1 + 5、2 + 4、3 + 3。',
          '（4 + 2 和 5 + 1 只是把长宽对调，算成同一种。）',
          '所以这样的长方形一共有 3 种。',
        ],
        'en' => [
          'The perimeter of a rectangle is two lengths and two widths, that is (length + width) × 2.',
          'Since the perimeter is 12, length + width = 12 ÷ 2 = 6.',
          'Both are whole numbers greater than 0, so split 6 into two positive whole numbers: 1 + 5, 2 + 4 and 3 + 3.',
          'The splits 4 + 2 and 5 + 1 just swap length and width and count as the same rectangle.',
          'So there are 3 such rectangles.',
        ],
        'ja' => [
          '長方形の周の長さは縦 2 本と横 2 本の合計、つまり（縦 + 横）× 2 です。',
          '周の長さが 12 なので、縦 + 横 = 12 ÷ 2 = 6 です。',
          '縦も横も 0 より大きい整数なので、6 を 2 つの正の整数の和に分けると 1 + 5、2 + 4、3 + 3 です。',
          '（4 + 2 や 5 + 1 は縦と横を入れかえただけで同じ長方形です。）',
          'したがってこのような長方形は 3 種類です。',
        ],
      },
      value: '3', max_digits: 1,
      notes: 'Original composition in the Math Kangaroo grade 1-2 perimeter style; here the perimeter is fixed and the shapes are counted, which differs from the existing item that maximises area for a fixed perimeter. Not a reproduction of any past paper.',
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
