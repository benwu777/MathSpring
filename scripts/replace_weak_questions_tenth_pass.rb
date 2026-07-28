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

def update_question(path, id)
  payload = load_json(path)
  question = payload.fetch('questions').find { |entry| entry['id'] == id }
  raise "Question not found: #{id}" unless question

  yield question
  write_json(path, payload)
end

update_question(
  File.join(ROOT, 'assets/questions/arithmetic/grade1_foundation.arithmetic.v1.json'),
  'arithmetic_grade1_foundation_040'
) do |question|
  question['subtopic'] = 'state_tracking'
  question['prompt'] = {
    'zh-Hant' => '紅盒裡有一些珠子，藍盒裡也有一些珠子。先從紅盒拿 1 顆放進藍盒後，兩盒就一樣多；而且原本兩盒一共是 10 顆。原本紅盒裡有幾顆珠子？',
    'zh-Hans' => '红盒里有一些珠子，蓝盒里也有一些珠子。先从红盒拿 1 颗放进蓝盒后，两盒就一样多；而且原本两盒一共是 10 颗。原本红盒里有几颗珠子？',
    'en' => 'There are some beads in a red box and some in a blue box. If 1 bead is moved from the red box to the blue box, the two boxes then have the same number of beads. Originally there were 10 beads in total. How many beads were originally in the red box?',
    'ja' => '赤い箱にも青い箱にもビーズが入っています。赤い箱から1個を青い箱へ移すと、2つの箱の数が同じになります。はじめに2つの箱を合わせて10個ありました。もとの赤い箱には何個ありましたか。',
  }
  question['answer'] = {
    'zh-Hant' => '答案是 6 顆。',
    'zh-Hans' => '答案是 6 颗。',
    'en' => 'The answer is 6.',
    'ja' => '答えは 6 個です。',
  }
  question['solutionSteps'] = {
    'zh-Hant' => [
      '移動 1 顆後兩盒一樣多，表示原本紅盒比藍盒多 2 顆。',
      '總共 10 顆，若兩盒一樣多會各是 5 顆。',
      '原本紅盒要比這個一樣多的情況多 1 顆，所以是 6 顆；藍盒原本是 4 顆。',
    ],
    'zh-Hans' => [
      '移动 1 颗后两盒一样多，表示原本红盒比蓝盒多 2 颗。',
      '总共 10 颗，若两盒一样多会各是 5 颗。',
      '原本红盒要比这个一样多的情况多 1 颗，所以是 6 颗；蓝盒原本是 4 颗。',
    ],
    'en' => [
      'After moving 1 bead, the boxes match, so originally the red box had 2 more beads than the blue box.',
      'If they were equal with 10 beads in total, each would have 5 beads.',
      'Originally the red box had 1 more than that equal amount, so it had 6 beads, and the blue box had 4.',
    ],
    'ja' => [
      '1個動かしたあとで同じ数になるので、もともと赤い箱は青い箱より2個多かったことになります。',
      '合計10個で同じ数なら、それぞれ5個です。',
      'もとの赤い箱はその同じ数より1個多いので6個、青い箱は4個です。',
    ],
  }
  question['correctAnswer'] = { 'type' => 'integer', 'value' => '6' }
end

update_question(
  File.join(ROOT, 'assets/questions/arithmetic/grade2_foundation.arithmetic.v1.json'),
  'arithmetic_grade2_foundation_003'
) do |question|
  question['subtopic'] = 'digit_sum'
  question['prompt'] = {
    'zh-Hant' => '用數字 2、4、7 各一次排成所有可能的三位數。這些三位數的百位數字全部加起來是多少？',
    'zh-Hans' => '用数字 2、4、7 各一次排成所有可能的三位数。这些三位数的百位数字全部加起来是多少？',
    'en' => 'Use the digits 2, 4, and 7 exactly once to form all possible three-digit numbers. What is the sum of all the hundreds digits of these numbers?',
    'ja' => '数字 2、4、7 をそれぞれ1回ずつ使って作れる3けたの数をすべて考えます。それらの百の位の数字を全部足すといくつになりますか。',
  }
  question['answer'] = {
    'zh-Hant' => '答案是 26。',
    'zh-Hans' => '答案是 26。',
    'en' => 'The answer is 26.',
    'ja' => '答えは 26 です。',
  }
  question['solutionSteps'] = {
    'zh-Hant' => [
      '三個數字排成三位數共有 6 個。',
      '每個數字都會有 2 次出現在百位，所以百位數字總和是 2×(2 + 4 + 7)。',
      '2×13 = 26，所以答案是 26。',
    ],
    'zh-Hans' => [
      '三个数字排成三位数共有 6 个。',
      '每个数字都会有 2 次出现在百位，所以百位数字总和是 2×(2 + 4 + 7)。',
      '2×13 = 26，所以答案是 26。',
    ],
    'en' => [
      'There are 6 three-digit numbers in total.',
      'Each digit appears in the hundreds place exactly 2 times, so the total is 2×(2 + 4 + 7).',
      'That gives 2×13 = 26.',
    ],
    'ja' => [
      '3つの数字からできる3けたの数は全部で6個です。',
      'それぞれの数字は百の位にちょうど2回ずつ現れるので、合計は 2×(2 + 4 + 7) です。',
      '2×13 = 26 なので、答えは26です。',
    ],
  }
  question['correctAnswer'] = { 'type' => 'integer', 'value' => '26' }
  question['inputConstraints'] = { 'allowNegative' => false, 'maxDigits' => 2 }
end

update_question(
  File.join(ROOT, 'assets/questions/arithmetic/grade2_foundation.arithmetic.v1.json'),
  'arithmetic_grade2_foundation_004'
) do |question|
  question['subtopic'] = 'calendar_counting'
  question['prompt'] = {
    'zh-Hant' => '今天是星期二。再過 10 天是星期幾？',
    'zh-Hans' => '今天是星期二。再过 10 天是星期几？',
    'en' => 'Today is Tuesday. What day of the week will it be 10 days later?',
    'ja' => '今日は火曜日です。10日後は何曜日ですか。',
  }
  question['answer'] = {
    'zh-Hant' => '答案是星期五。',
    'zh-Hans' => '答案是星期五。',
    'en' => 'The answer is Friday.',
    'ja' => '答えは金曜日です。',
  }
  question['solutionSteps'] = {
    'zh-Hant' => [
      '一星期有 7 天，10 天就是 7 天再加 3 天。',
      '星期二往後 7 天還是星期二，再往後 3 天是星期五。',
    ],
    'zh-Hans' => [
      '一星期有 7 天，10 天就是 7 天再加 3 天。',
      '星期二往后 7 天还是星期二，再往后 3 天是星期五。',
    ],
    'en' => [
      'A week has 7 days, so 10 days is 7 days plus 3 more days.',
      'Seven days after Tuesday is still Tuesday, and 3 more days later is Friday.',
    ],
    'ja' => [
      '1週間は7日なので、10日は7日と3日に分けられます。',
      '火曜日の7日後はまた火曜日で、そこから3日後は金曜日です。',
    ],
  }
  question['answerMode'] = 'multiple_choice'
  question['options'] = {
    'A' => { 'zh-Hant' => '星期四', 'zh-Hans' => '星期四', 'en' => 'Thursday', 'ja' => '木曜日' },
    'B' => { 'zh-Hant' => '星期五', 'zh-Hans' => '星期五', 'en' => 'Friday', 'ja' => '金曜日' },
    'C' => { 'zh-Hant' => '星期六', 'zh-Hans' => '星期六', 'en' => 'Saturday', 'ja' => '土曜日' },
    'D' => { 'zh-Hant' => '星期日', 'zh-Hans' => '星期日', 'en' => 'Sunday', 'ja' => '日曜日' },
  }
  question['correctAnswer'] = { 'type' => 'choice', 'value' => 'B' }
end

update_question(
  File.join(ROOT, 'assets/questions/arithmetic/grade4_foundation.arithmetic.v1.json'),
  'arithmetic_grade4_foundation_010'
) do |question|
  question['subtopic'] = 'grouping'
  question['prompt'] = {
    'zh-Hant' => '學校把 38 本作業簿平均分給 4 個小組，每組先分到同樣多本後，還剩幾本？',
    'zh-Hans' => '学校把 38 本作业簿平均分给 4 个小组，每组先分到同样多本后，还剩几本？',
    'en' => 'A school shares 38 workbooks equally among 4 groups. After each group gets the same number, how many workbooks are left over?',
    'ja' => '学校で38冊のノートを4つのグループに同じ数ずつ配ります。各グループに同じ数を配ったあと、何冊余りますか。',
  }
  question['answer'] = {
    'zh-Hant' => '答案是 2 本。',
    'zh-Hans' => '答案是 2 本。',
    'en' => 'The answer is 2.',
    'ja' => '答えは 2 冊です。',
  }
  question['solutionSteps'] = {
    'zh-Hant' => [
      '4 個小組每組先分 9 本，共分掉 4×9 = 36 本。',
      '38 − 36 = 2，所以還剩 2 本。',
    ],
    'zh-Hans' => [
      '4 个小组每组先分 9 本，共分掉 4×9 = 36 本。',
      '38 − 36 = 2，所以还剩 2 本。',
    ],
    'en' => [
      'If each of the 4 groups gets 9 workbooks, then 4×9 = 36 are used.',
      'So 38 − 36 = 2 workbooks are left.',
    ],
    'ja' => [
      '4つのグループに9冊ずつ配ると、4×9 = 36冊配れます。',
      'したがって 38 − 36 = 2 冊余ります。',
    ],
  }
  question['correctAnswer'] = { 'type' => 'integer', 'value' => '2' }
end

update_question(
  File.join(ROOT, 'assets/questions/arithmetic/grade4_foundation.arithmetic.v1.json'),
  'arithmetic_grade4_foundation_018'
) do |question|
  question['subtopic'] = 'balance_transfer'
  question['prompt'] = {
    'zh-Hant' => '甲袋和乙袋共有 30 顆糖。若從甲袋拿 4 顆放到乙袋後，兩袋就一樣多。原本甲袋有幾顆糖？',
    'zh-Hans' => '甲袋和乙袋共有 30 颗糖。若从甲袋拿 4 颗放到乙袋后，两袋就一样多。原本甲袋有几颗糖？',
    'en' => 'Bag A and Bag B contain 30 candies in total. If 4 candies are moved from Bag A to Bag B, the two bags then contain the same number of candies. How many candies were originally in Bag A?',
    'ja' => '袋Aと袋Bには合わせて30個のあめが入っています。袋Aから4個を袋Bへ移すと、2つの袋の数が同じになります。もともと袋Aには何個入っていましたか。',
  }
  question['answer'] = {
    'zh-Hant' => '答案是 19 顆。',
    'zh-Hans' => '答案是 19 颗。',
    'en' => 'The answer is 19.',
    'ja' => '答えは 19 個です。',
  }
  question['solutionSteps'] = {
    'zh-Hant' => [
      '移動 4 顆後會一樣多，表示原本甲袋比乙袋多 8 顆。',
      '若兩袋一樣多，30 顆會平分成 15 顆和 15 顆。',
      '原本甲袋要比這個一樣多的情況多 4 顆，所以是 19 顆；乙袋原本是 11 顆。',
    ],
    'zh-Hans' => [
      '移动 4 颗后会一样多，表示原本甲袋比乙袋多 8 颗。',
      '若两袋一样多，30 颗会平分成 15 颗和 15 颗。',
      '原本甲袋要比这个一样多的情况多 4 颗，所以是 19 颗；乙袋原本是 11 颗。',
    ],
    'en' => [
      'Moving 4 candies makes the bags equal, so originally Bag A had 8 more candies than Bag B.',
      'If the two bags were equal, 30 candies would split into 15 and 15.',
      'Originally Bag A had 4 more than that equal amount, so it had 19 candies.',
    ],
    'ja' => [
      '4個移して同じ数になるので、もともと袋Aは袋Bより8個多かったことになります。',
      'もし同じ数なら、30個は15個ずつに分かれます。',
      'もとの袋Aはその同じ数より4個多いので、19個です。',
    ],
  }
  question['correctAnswer'] = { 'type' => 'integer', 'value' => '19' }
end

update_question(
  File.join(ROOT, 'assets/questions/arithmetic/grade5_foundation.arithmetic.v1.json'),
  'arithmetic_grade5_foundation_027'
) do |question|
  question['subtopic'] = 'perimeter_from_area_pairs'
  question['prompt'] = {
    'zh-Hant' => '用 24 個小正方形排成長方形，長和寬都取整數且大於 1。所有可能的長方形中，周長最小是多少？',
    'zh-Hans' => '用 24 个小正方形排成长方形，长和宽都取整数且大于 1。所有可能的长方形中，周长最小是多少？',
    'en' => 'Arrange 24 unit squares into a rectangle with integer side lengths greater than 1. Among all possible rectangles, what is the smallest perimeter?',
    'ja' => '24個の正方形を、縦も横も1より大きい整数の長方形に並べます。考えられる長方形の中で、周の長さが最も小さいものはいくつですか。',
  }
  question['answer'] = {
    'zh-Hant' => '答案是 20。',
    'zh-Hans' => '答案是 20。',
    'en' => 'The answer is 20.',
    'ja' => '答えは 20 です。',
  }
  question['solutionSteps'] = {
    'zh-Hant' => [
      '24 的整數長寬組合是 2×12、3×8、4×6。',
      '它們的周長分別是 28、22、20。',
      '所以周長最小的是 4×6 這個長方形，最小周長是 20。',
    ],
    'zh-Hans' => [
      '24 的整数长宽组合是 2×12、3×8、4×6。',
      '它们的周长分别是 28、22、20。',
      '所以周长最小的是 4×6 这个长方形，最小周长是 20。',
    ],
    'en' => [
      'The integer side pairs for area 24 are 2×12, 3×8, and 4×6.',
      'Their perimeters are 28, 22, and 20 respectively.',
      'So the smallest perimeter is 20, from the 4×6 rectangle.',
    ],
    'ja' => [
      '面積24の整数の組は 2×12、3×8、4×6 です。',
      'それぞれの周の長さは 28、22、20 になります。',
      'したがって最も小さい周の長さは 4×6 のときの 20 です。',
    ],
  }
  question['correctAnswer'] = { 'type' => 'integer', 'value' => '20' }
end

update_question(
  File.join(ROOT, 'assets/questions/arithmetic/grade5_foundation.arithmetic.v1.json'),
  'arithmetic_grade5_foundation_028'
) do |question|
  question['subtopic'] = 'common_divisors'
  question['prompt'] = {
    'zh-Hant' => '24 和 60 共有幾個正公因數？',
    'zh-Hans' => '24 和 60 共有几个正公因数？',
    'en' => 'How many positive common divisors do 24 and 60 have?',
    'ja' => '24 と 60 の正の公約数は全部でいくつありますか。',
  }
  question['answer'] = {
    'zh-Hant' => '答案是 6 個。',
    'zh-Hans' => '答案是 6 个。',
    'en' => 'The answer is 6.',
    'ja' => '答えは 6 個です。',
  }
  question['solutionSteps'] = {
    'zh-Hant' => [
      '24 和 60 的最大公因數是 12。',
      '兩數的公因數，就是 12 的因數。',
      '12 的正因數有 1、2、3、4、6、12，共 6 個。',
    ],
    'zh-Hans' => [
      '24 和 60 的最大公因数是 12。',
      '两数的公因数，就是 12 的因数。',
      '12 的正因数有 1、2、3、4、6、12，共 6 个。',
    ],
    'en' => [
      'The greatest common divisor of 24 and 60 is 12.',
      'The common divisors of 24 and 60 are exactly the divisors of 12.',
      'The positive divisors of 12 are 1, 2, 3, 4, 6, and 12, so there are 6.',
    ],
    'ja' => [
      '24 と 60 の最大公約数は 12 です。',
      '2つの数の公約数は、12 の約数と同じです。',
      '12 の正の約数は 1、2、3、4、6、12 の6個です。',
    ],
  }
  question['correctAnswer'] = { 'type' => 'integer', 'value' => '6' }
end

update_question(
  File.join(ROOT, 'assets/questions/geometry/grade1_foundation.geometry.v1.json'),
  'geometry_grade1_foundation_023'
) do |question|
  question['subtopic'] = 'grid_path'
  question['prompt'] = {
    'zh-Hant' => '在方格紙上，從左下角走到右上角，必須剛好往右走 3 格、往上走 2 格。這樣一共要走幾格？',
    'zh-Hans' => '在方格纸上，从左下角走到右上角，必须刚好往右走 3 格、往上走 2 格。这样一共要走几格？',
    'en' => 'On grid paper, you move from the lower-left corner to the upper-right corner by going exactly 3 squares right and 2 squares up. How many squares do you move in total?',
    'ja' => '方眼紙の左下から右上まで、右へ3マス、上へ2マス進みます。全部で何マス進みますか。',
  }
  question['answer'] = {
    'zh-Hant' => '答案是 5 格。',
    'zh-Hans' => '答案是 5 格。',
    'en' => 'The answer is 5.',
    'ja' => '答えは 5 マスです。',
  }
  question['solutionSteps'] = {
    'zh-Hant' => [
      '往右走 3 格，再往上走 2 格。',
      '一共是 3 + 2 = 5 格。',
    ],
    'zh-Hans' => [
      '往右走 3 格，再往上走 2 格。',
      '一共是 3 + 2 = 5 格。',
    ],
    'en' => [
      'You move 3 squares to the right and 2 squares up.',
      'So the total number of squares moved is 3 + 2 = 5.',
    ],
    'ja' => [
      '右へ3マス、上へ2マス進みます。',
      'したがって全部で 3 + 2 = 5 マスです。',
    ],
  }
  question['correctAnswer'] = { 'type' => 'integer', 'value' => '5' }
end

update_question(
  File.join(ROOT, 'assets/questions/geometry/grade5_foundation.geometry.v1.json'),
  'geometry_grade5_foundation_007'
) do |question|
  question['subtopic'] = 'triangle_partition'
  question['prompt'] = {
    'zh-Hant' => '一個底 12 公分、高 5 公分的三角形，被一條線平分成兩個面積相等的小三角形。每一個小三角形的面積是多少平方公分？',
    'zh-Hans' => '一个底 12 公分、高 5 公分的三角形，被一条线平分成两个面积相等的小三角形。每一个小三角形的面积是多少平方公分？',
    'en' => 'A triangle has base 12 cm and height 5 cm. It is divided into two smaller triangles of equal area. What is the area of each small triangle?',
    'ja' => '底辺12cm、高さ5cmの三角形があります。これを面積が等しい2つの小さい三角形に分けました。それぞれの面積は何平方cmですか。',
  }
  question['answer'] = {
    'zh-Hant' => '答案是 15 平方公分。',
    'zh-Hans' => '答案是 15 平方公分。',
    'en' => 'The answer is 15 square centimeters.',
    'ja' => '答えは 15 平方cmです。',
  }
  question['solutionSteps'] = {
    'zh-Hant' => [
      '原來大三角形的面積是 12×5÷2 = 30 平方公分。',
      '分成兩個面積相等的小三角形，所以每個是 30÷2 = 15 平方公分。',
    ],
    'zh-Hans' => [
      '原来大三角形的面积是 12×5÷2 = 30 平方公分。',
      '分成两个面积相等的小三角形，所以每个是 30÷2 = 15 平方公分。',
    ],
    'en' => [
      'The original triangle has area 12×5÷2 = 30 square centimeters.',
      'Since it is split into two equal-area triangles, each one has area 30÷2 = 15 square centimeters.',
    ],
    'ja' => [
      'もとの大きい三角形の面積は 12×5÷2 = 30 平方cmです。',
      'それを等しい面積の2つに分けたので、それぞれ 30÷2 = 15 平方cmです。',
    ],
  }
  question['correctAnswer'] = { 'type' => 'integer', 'value' => '15' }
  question['figure'] = {
    'type' => 'custom',
    'kind' => 'shape_diagram',
    'params' => {
      'shape' => 'triangle',
      'labels' => { 'bottom' => '12', 'right' => '5' },
    },
  }
end

update_question(
  File.join(ROOT, 'assets/questions/geometry/grade5_foundation.geometry.v1.json'),
  'geometry_grade5_foundation_014'
) do |question|
  question['subtopic'] = 'symmetry'
  question['prompt'] = {
    'zh-Hant' => '一個正方形紙片沿著對角線對折後，會得到幾條邊一樣長的三角形？',
    'zh-Hans' => '一个正方形纸片沿着对角线对折后，会得到几条边一样长的三角形？',
    'en' => 'A square sheet is folded along a diagonal. The resulting triangle has how many sides of equal length?',
    'ja' => '正方形の紙を対角線で折ると、できる三角形には同じ長さの辺が何本ありますか。',
  }
  question['answer'] = {
    'zh-Hant' => '答案是 2 條。',
    'zh-Hans' => '答案是 2 条。',
    'en' => 'The answer is 2.',
    'ja' => '答えは 2 本です。',
  }
  question['solutionSteps'] = {
    'zh-Hant' => [
      '正方形四條邊都一樣長。',
      '沿對角線對折後，形成的三角形有兩條邊就是原來正方形的邊，所以這兩條邊一樣長。',
      '因此得到的是兩條邊相等的等腰直角三角形。',
    ],
    'zh-Hans' => [
      '正方形四条边都一样长。',
      '沿对角线对折后，形成的三角形有两条边就是原来正方形的边，所以这两条边一样长。',
      '因此得到的是两条边相等的等腰直角三角形。',
    ],
    'en' => [
      'All four sides of a square are equal.',
      'After folding along a diagonal, two sides of the triangle are original sides of the square, so they are equal.',
      'So the triangle has 2 equal sides.',
    ],
    'ja' => [
      '正方形の4つの辺はすべて同じ長さです。',
      '対角線で折ると、できる三角形の2辺はもとの正方形の辺なので同じ長さです。',
      'したがって同じ長さの辺は2本あります。',
    ],
  }
  question['answerMode'] = 'multiple_choice'
  question['options'] = {
    'A' => { 'zh-Hant' => '1 條', 'zh-Hans' => '1 条', 'en' => '1', 'ja' => '1本' },
    'B' => { 'zh-Hant' => '2 條', 'zh-Hans' => '2 条', 'en' => '2', 'ja' => '2本' },
    'C' => { 'zh-Hant' => '3 條', 'zh-Hans' => '3 条', 'en' => '3', 'ja' => '3本' },
    'D' => { 'zh-Hant' => '4 條', 'zh-Hans' => '4 条', 'en' => '4', 'ja' => '4本' },
  }
  question['correctAnswer'] = { 'type' => 'choice', 'value' => 'B' }
end

update_question(
  File.join(ROOT, 'assets/questions/logic/grade5_foundation.logic.v1.json'),
  'logic_grade5_foundation_016'
) do |question|
  question['subtopic'] = 'ranking'
  question['prompt'] = {
    'zh-Hant' => '甲、乙、丙、丁參加跑步。已知乙比甲快，丙比丁快，而甲又比丁快。誰一定不是最後一名？',
    'zh-Hans' => '甲、乙、丙、丁参加跑步。已知乙比甲快，丙比丁快，而甲又比丁快。谁一定不是最后一名？',
    'en' => 'A, B, C, and D are in a race. B is faster than A, C is faster than D, and A is faster than D. Who definitely is not in last place?',
    'ja' => '甲・乙・丙・丁の4人が走ります。乙は甲より速く、丙は丁より速く、甲は丁より速いとします。必ず最下位ではないのはだれですか。',
  }
  question['answer'] = {
    'zh-Hant' => '答案是甲。',
    'zh-Hans' => '答案是甲。',
    'en' => 'The answer is A.',
    'ja' => '答えは甲です。',
  }
  question['solutionSteps'] = {
    'zh-Hant' => [
      '甲比丁快，所以甲不可能排在丁後面。',
      '既然丁至少在甲後面，甲就一定不是最後一名。',
    ],
    'zh-Hans' => [
      '甲比丁快，所以甲不可能排在丁后面。',
      '既然丁至少在甲后面，甲就一定不是最后一名。',
    ],
    'en' => [
      'A is faster than D, so A cannot finish behind D.',
      'Since D must be behind A, A definitely cannot be last.',
    ],
    'ja' => [
      '甲は丁より速いので、甲が丁より後ろになることはありません。',
      '丁が必ず甲より後ろにいるので、甲は最下位にはなりません。',
    ],
  }
  question['answerMode'] = 'multiple_choice'
  question['options'] = {
    'A' => { 'zh-Hant' => '甲', 'zh-Hans' => '甲', 'en' => 'A', 'ja' => '甲' },
    'B' => { 'zh-Hant' => '乙', 'zh-Hans' => '乙', 'en' => 'B', 'ja' => '乙' },
    'C' => { 'zh-Hant' => '丙', 'zh-Hans' => '丙', 'en' => 'C', 'ja' => '丙' },
    'D' => { 'zh-Hant' => '丁', 'zh-Hans' => '丁', 'en' => 'D', 'ja' => '丁' },
  }
  question['correctAnswer'] = { 'type' => 'choice', 'value' => 'A' }
end

update_question(
  File.join(ROOT, 'assets/questions/logic/grade4_foundation.logic.v1.json'),
  'logic_grade4_foundation_004'
) do |question|
  question['subtopic'] = 'calendar_counting'
  question['prompt'] = {
    'zh-Hant' => '某月的 1 號是星期一。這個月的第 15 天是星期幾？',
    'zh-Hans' => '某月的 1 号是星期一。这个月的第 15 天是星期几？',
    'en' => 'The 1st day of a month is Monday. What day of the week is the 15th day of the month?',
    'ja' => 'ある月の1日は月曜日です。その月の15日は何曜日ですか。',
  }
  question['answer'] = {
    'zh-Hant' => '答案是星期一。',
    'zh-Hans' => '答案是星期一。',
    'en' => 'The answer is Monday.',
    'ja' => '答えは月曜日です。',
  }
  question['solutionSteps'] = {
    'zh-Hant' => [
      '第 15 天比第 1 天多了 14 天。',
      '14 天剛好是 2 個星期，所以星期不變。',
      '因此第 15 天也是星期一。',
    ],
    'zh-Hans' => [
      '第 15 天比第 1 天多了 14 天。',
      '14 天刚好是 2 个星期，所以星期不变。',
      '因此第 15 天也是星期一。',
    ],
    'en' => [
      'The 15th day is 14 days after the 1st day.',
      'Fourteen days is exactly 2 weeks, so the weekday stays the same.',
      'Therefore the 15th day is also Monday.',
    ],
    'ja' => [
      '15日は1日から14日後です。',
      '14日はちょうど2週間なので、曜日は変わりません。',
      'したがって15日も月曜日です。',
    ],
  }
  question['answerMode'] = 'multiple_choice'
  question['options'] = {
    'A' => { 'zh-Hant' => '星期日', 'zh-Hans' => '星期日', 'en' => 'Sunday', 'ja' => '日曜日' },
    'B' => { 'zh-Hant' => '星期一', 'zh-Hans' => '星期一', 'en' => 'Monday', 'ja' => '月曜日' },
    'C' => { 'zh-Hant' => '星期二', 'zh-Hans' => '星期二', 'en' => 'Tuesday', 'ja' => '火曜日' },
    'D' => { 'zh-Hant' => '星期三', 'zh-Hans' => '星期三', 'en' => 'Wednesday', 'ja' => '水曜日' },
  }
  question['correctAnswer'] = { 'type' => 'choice', 'value' => 'B' }
end

puts 'Tenth pass replacements complete.'
