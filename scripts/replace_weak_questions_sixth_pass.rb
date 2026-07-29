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

def update_question(path, question_id)
  payload = load_json(path)
  question = payload.fetch('questions').find { |entry| entry['id'] == question_id }
  raise "Question not found: #{question_id}" unless question

  yield question
  write_json(path, payload)
end

update_question(
  File.join(ROOT, 'assets/questions/arithmetic/grade1_foundation.arithmetic.v1.json'),
  'arithmetic_grade1_foundation_040'
) do |question|
  question['prompt'] = {
    'zh-Hant' => '紅盒和藍盒裡一共有 11 顆珠子。藍盒比紅盒多 3 顆。紅盒裡有幾顆珠子？',
    'zh-Hans' => '红盒和蓝盒里一共有 11 颗珠子。蓝盒比红盒多 3 颗。红盒里有几颗珠子？',
    'en' => 'There are 11 beads in a red box and a blue box altogether. The blue box has 3 more beads than the red box. How many beads are in the red box?',
    'ja' => '赤い箱と青い箱を合わせるとビーズは11個あります。青い箱は赤い箱より3個多いです。赤い箱には何個入っていますか。',
  }
  question['answer'] = {
    'zh-Hant' => '答案是 4 顆。',
    'zh-Hans' => '答案是 4 颗。',
    'en' => 'The answer is 4.',
    'ja' => '答えは 4 個です。',
  }
  question['solutionSteps'] = {
    'zh-Hant' => [
      '如果把藍盒多出來的 3 顆先拿掉，兩盒就會一樣多。',
      '11 − 3 = 8，表示這時兩盒合起來有 8 顆。',
      '平均分成兩盒，8 ÷ 2 = 4，所以紅盒有 4 顆。',
    ],
    'zh-Hans' => [
      '如果把蓝盒多出来的 3 颗先拿掉，两盒就会一样多。',
      '11 − 3 = 8，表示这时两盒合起来有 8 颗。',
      '平均分成两盒，8 ÷ 2 = 4，所以红盒有 4 颗。',
    ],
    'en' => [
      'First remove the extra 3 beads from the blue box so that the two boxes would match.',
      'Then 11 − 3 = 8 beads remain to be shared equally between the two boxes.',
      'So the red box has 8 ÷ 2 = 4 beads.',
    ],
    'ja' => [
      'まず青い箱の多い3個を取りのぞくと、2つの箱は同じ数になります。',
      'すると 11 − 3 = 8 個が、2つの箱に同じ数ずつ入っていることになります。',
      'したがって赤い箱には 8 ÷ 2 = 4 個入っています。',
    ],
  }
  question['correctAnswer'] = { 'type' => 'integer', 'value' => '4' }
end

update_question(
  File.join(ROOT, 'assets/questions/arithmetic/grade4_foundation.arithmetic.v1.json'),
  'arithmetic_grade4_foundation_009'
) do |question|
  question['prompt'] = {
    'zh-Hant' => '數列 2, 5, 9, 14, 20, __ 中，後一個數比前一個數多的量每次都再多 1。下一個數是多少？',
    'zh-Hans' => '数列 2, 5, 9, 14, 20, __ 中，后一个数比前一个数多的量每次都再多 1。下一个数是多少？',
    'en' => 'In the sequence 2, 5, 9, 14, 20, __, the increase from one term to the next grows by 1 each time. What is the next number?',
    'ja' => '数列 2, 5, 9, 14, 20, __ では、となり合う数の差が毎回1ずつ大きくなります。次の数はいくつですか。',
  }
  question['answer'] = {
    'zh-Hant' => '答案是 27。',
    'zh-Hans' => '答案是 27。',
    'en' => 'The answer is 27.',
    'ja' => '答えは 27 です。',
  }
  question['solutionSteps'] = {
    'zh-Hant' => [
      '相鄰兩項的差依次是 3、4、5、6。',
      '所以再下一次要加 7。',
      '20 + 7 = 27。',
    ],
    'zh-Hans' => [
      '相邻两项的差依次是 3、4、5、6。',
      '所以再下一次要加 7。',
      '20 + 7 = 27。',
    ],
    'en' => [
      'The consecutive differences are 3, 4, 5, and 6.',
      'So the next increase should be 7.',
      '20 + 7 = 27.',
    ],
    'ja' => [
      'となり合う数の差は 3、4、5、6 です。',
      'したがって次は 7 増えます。',
      '20 + 7 = 27 です。',
    ],
  }
  question['correctAnswer'] = { 'type' => 'integer', 'value' => '27' }
end

update_question(
  File.join(ROOT, 'assets/questions/arithmetic/grade4_foundation.arithmetic.v1.json'),
  'arithmetic_grade4_foundation_032'
) do |question|
  question['prompt'] = {
    'zh-Hant' => '某月的 1 號是星期三，這個月的最後一天是星期五。這個月有幾天？',
    'zh-Hans' => '某月的 1 号是星期三，这个月的最后一天是星期五。这个月有几天？',
    'en' => 'The 1st day of a month is Wednesday, and the last day of the month is Friday. How many days are in this month?',
    'ja' => 'ある月の1日は水曜日で、その月の最後の日は金曜日です。この月は何日ありますか。',
  }
  question['answer'] = {
    'zh-Hant' => '答案是 31 天。',
    'zh-Hans' => '答案是 31 天。',
    'en' => 'The answer is 31.',
    'ja' => '答えは 31 日です。',
  }
  question['solutionSteps'] = {
    'zh-Hant' => [
      '從 1 號到最後一天，星期三變成星期五，往後多了 2 天。',
      '所以「天數 − 1」除以 7 餘 2。',
      '28 天時，「天數 − 1」是 27，餘 6；29 天餘 0；30 天餘 1；31 天餘 2。',
      '因此這個月有 31 天。',
    ],
    'zh-Hans' => [
      '从 1 号到最后一天，星期三变成星期五，往后多了 2 天。',
      '所以“天数 − 1”除以 7 余 2。',
      '28 天时，“天数 − 1”是 27，余 6；29 天余 0；30 天余 1；31 天余 2。',
      '因此这个月有 31 天。',
    ],
    'en' => [
      'From the 1st to the last day, Wednesday moves forward to Friday, which is 2 days later.',
      'So (number of days − 1) leaves remainder 2 when divided by 7.',
      'Checking 28, 29, 30, and 31 days, only 31 gives a remainder of 2.',
      'Therefore the month has 31 days.',
    ],
    'ja' => [
      '1日から最後の日までで、水曜日が金曜日になるので、曜日は2日分進んでいます。',
      'つまり「日数 − 1」を7で割ると余りが2になります。',
      '28日、29日、30日、31日を試すと、余りが2になるのは31日だけです。',
      'したがってこの月は31日あります。',
    ],
  }
  question['correctAnswer'] = { 'type' => 'integer', 'value' => '31' }
  question['inputConstraints'] = { 'allowNegative' => false, 'maxDigits' => 2 }
end

update_question(
  File.join(ROOT, 'assets/questions/arithmetic/grade5_foundation.arithmetic.v1.json'),
  'arithmetic_grade5_foundation_010'
) do |question|
  question['prompt'] = {
    'zh-Hant' => '同樣大的袋子都裝同樣多顆球。2 個袋子和外面的 6 顆球合起來共有 24 顆球。若把 1 個袋子裡的球平均分給 3 個小朋友，每人可分到幾顆？',
    'zh-Hans' => '同样大的袋子都装同样多颗球。2 个袋子和外面的 6 颗球合起来共有 24 颗球。若把 1 个袋子里的球平均分给 3 个小朋友，每人可分到几颗？',
    'en' => 'Identical bags each contain the same number of balls. Two bags together with 6 loose balls make 24 balls in all. If the balls from one bag are shared equally among 3 children, how many balls does each child get?',
    'ja' => '同じ袋には同じ数のボールが入っています。2つの袋と外にある6個のボールを合わせると全部で24個です。1つの袋の中のボールを3人の子どもに等しく分けると、1人分は何個ですか。',
  }
  question['answer'] = {
    'zh-Hant' => '答案是 3 顆。',
    'zh-Hans' => '答案是 3 颗。',
    'en' => 'The answer is 3.',
    'ja' => '答えは 3 個です。',
  }
  question['solutionSteps'] = {
    'zh-Hant' => [
      '先扣掉外面的 6 顆球，兩個袋子裡共有 24 − 6 = 18 顆球。',
      '2 個袋子一樣多，所以每個袋子裡有 18 ÷ 2 = 9 顆球。',
      '把 9 顆球平均分給 3 個小朋友，每人得到 9 ÷ 3 = 3 顆。',
    ],
    'zh-Hans' => [
      '先扣掉外面的 6 颗球，两个袋子里共有 24 − 6 = 18 颗球。',
      '2 个袋子一样多，所以每个袋子里有 18 ÷ 2 = 9 颗球。',
      '把 9 颗球平均分给 3 个小朋友，每人得到 9 ÷ 3 = 3 颗。',
    ],
    'en' => [
      'Remove the 6 loose balls first, so the two bags together hold 24 − 6 = 18 balls.',
      'Since the bags are identical, each bag contains 18 ÷ 2 = 9 balls.',
      'Sharing one bag equally among 3 children gives 9 ÷ 3 = 3 balls each.',
    ],
    'ja' => [
      'まず外にある6個を引くと、2つの袋の中には 24 − 6 = 18 個あります。',
      '袋は同じなので、1つの袋には 18 ÷ 2 = 9 個入っています。',
      'その9個を3人に等しく分けると、1人分は 9 ÷ 3 = 3 個です。',
    ],
  }
  question['correctAnswer'] = { 'type' => 'integer', 'value' => '3' }
end

update_question(
  File.join(ROOT, 'assets/questions/geometry/grade3_foundation.geometry.v1.json'),
  'geometry_grade3_foundation_016'
) do |question|
  question['prompt'] = {
    'zh-Hant' => '用 5 個邊長 1 的小正方形拼成一個 T 字形：上面一排 3 個，中間下面再接 2 個。這個圖形的周長是多少？',
    'zh-Hans' => '用 5 个边长 1 的小正方形拼成一个 T 字形：上面一排 3 个，中间下面再接 2 个。这个图形的周长是多少？',
    'en' => 'Five unit squares are joined to make a T shape: 3 across the top row, then 2 more below the middle. What is the perimeter of the shape?',
    'ja' => '1辺1の正方形5個を使ってT字形を作ります。上の列に3個、その真ん中の下にさらに2個つなげます。この図形の周の長さはいくつですか。',
  }
  question['answer'] = {
    'zh-Hant' => '答案是 12。',
    'zh-Hans' => '答案是 12。',
    'en' => 'The answer is 12.',
    'ja' => '答えは 12 です。',
  }
  question['solutionSteps'] = {
    'zh-Hant' => [
      '5 個小正方形若完全分開，周長總和是 5 × 4 = 20。',
      '拼成 T 字形時，共有 4 條共用邊，每條共用邊會讓周長少 2。',
      '所以周長是 20 − 4 × 2 = 12。',
    ],
    'zh-Hans' => [
      '5 个小正方形若完全分开，周长总和是 5 × 4 = 20。',
      '拼成 T 字形时，共有 4 条共用边，每条共用边会让周长少 2。',
      '所以周长是 20 − 4 × 2 = 12。',
    ],
    'en' => [
      'If the 5 unit squares were separate, their total perimeter would be 5 × 4 = 20.',
      'In the T shape, there are 4 shared edges, and each shared edge removes 2 from the outside perimeter.',
      'So the perimeter is 20 − 4 × 2 = 12.',
    ],
    'ja' => [
      '5個の正方形がばらばらなら、周の長さの合計は 5 × 4 = 20 です。',
      'T字形では辺を4本共有していて、共有するたびに外側の周は2ずつ減ります。',
      'したがって周の長さは 20 − 4 × 2 = 12 です。',
    ],
  }
  question['figure'] = { 'type' => 'custom', 'kind' => 'none', 'params' => {} }
end

update_question(
  File.join(ROOT, 'assets/questions/geometry/grade3_foundation.geometry.v1.json'),
  'geometry_grade3_foundation_026'
) do |question|
  question['prompt'] = {
    'zh-Hant' => '一個長方形的周長是 28 公分，長是寬的 3 倍少 2 公分。這個長方形的面積是多少平方公分？',
    'zh-Hans' => '一个长方形的周长是 28 公分，长是宽的 3 倍少 2 公分。这个长方形的面积是多少平方公分？',
    'en' => 'A rectangle has perimeter 28 cm. Its length is 2 cm less than 3 times its width. What is its area in square centimeters?',
    'ja' => '長方形の周の長さは28cmで、たての長さは横の幅の3倍より2cm短いです。この長方形の面積は何平方cmですか。',
  }
  question['answer'] = {
    'zh-Hant' => '答案是 40 平方公分。',
    'zh-Hans' => '答案是 40 平方公分。',
    'en' => 'The answer is 40 square centimeters.',
    'ja' => '答えは 40 平方cmです。',
  }
  question['solutionSteps'] = {
    'zh-Hant' => [
      '周長 28 公分表示長和寬的和是 14 公分。',
      '設寬是 1 份，則長是 3 份少 2 公分。試寬 4 公分時，長就是 10 公分，而且 4 + 10 = 14，符合條件。',
      '所以面積是 4 × 10 = 40 平方公分。',
    ],
    'zh-Hans' => [
      '周长 28 公分表示长和宽的和是 14 公分。',
      '设宽是 1 份，则长是 3 份少 2 公分。试宽 4 公分时，长就是 10 公分，而且 4 + 10 = 14，符合条件。',
      '所以面积是 4 × 10 = 40 平方公分。',
    ],
    'en' => [
      'Perimeter 28 cm means length + width = 14 cm.',
      'Try width 4 cm. Then the length is 3 × 4 − 2 = 10 cm, and 4 + 10 = 14, so it fits.',
      'Therefore the area is 4 × 10 = 40 square centimeters.',
    ],
    'ja' => [
      '周の長さが28cmなので、たてと横の和は14cmです。',
      '横を4cmとすると、たては 3 × 4 − 2 = 10cm で、4 + 10 = 14 となり条件に合います。',
      'したがって面積は 4 × 10 = 40 平方cmです。',
    ],
  }
  question['correctAnswer'] = { 'type' => 'integer', 'value' => '40' }
  question['figure'] = {
    'type' => 'custom',
    'kind' => 'shape_diagram',
    'params' => {
      'shape' => 'rectangle',
      'labels' => {
        'top' => '長 = 3×寬 − 2',
        'right' => '周長 28',
      },
    },
  }
end

update_question(
  File.join(ROOT, 'assets/questions/geometry/grade4_foundation.geometry.v1.json'),
  'geometry_grade4_foundation_013'
) do |question|
  question['prompt'] = {
    'zh-Hant' => '一張長 12 公分、寬 8 公分的長方形紙片，四個角各剪去一個邊長 2 公分的小正方形。剩下圖形的面積是多少平方公分？',
    'zh-Hans' => '一张长 12 公分、宽 8 公分的长方形纸片，四个角各剪去一个边长 2 公分的小正方形。剩下图形的面积是多少平方公分？',
    'en' => 'A rectangle paper is 12 cm by 8 cm. A 2 cm by 2 cm square is cut from each of the four corners. What is the area of the remaining shape?',
    'ja' => '縦12cm、横8cmの長方形の紙があります。4つの角からそれぞれ1辺2cmの正方形を切り取ります。残った図形の面積は何平方cmですか。',
  }
  question['answer'] = {
    'zh-Hant' => '答案是 80 平方公分。',
    'zh-Hans' => '答案是 80 平方公分。',
    'en' => 'The answer is 80 square centimeters.',
    'ja' => '答えは 80 平方cmです。',
  }
  question['solutionSteps'] = {
    'zh-Hant' => [
      '原來長方形面積是 12 × 8 = 96 平方公分。',
      '每個角剪去的小正方形面積是 2 × 2 = 4 平方公分。',
      '四個角一共剪去 4 × 4 = 16 平方公分。',
      '剩下的面積是 96 − 16 = 80 平方公分。',
    ],
    'zh-Hans' => [
      '原来长方形面积是 12 × 8 = 96 平方公分。',
      '每个角剪去的小正方形面积是 2 × 2 = 4 平方公分。',
      '四个角一共剪去 4 × 4 = 16 平方公分。',
      '剩下的面积是 96 − 16 = 80 平方公分。',
    ],
    'en' => [
      'The original rectangle has area 12 × 8 = 96 square centimeters.',
      'Each cut-out corner square has area 2 × 2 = 4 square centimeters.',
      'Four corners remove 4 × 4 = 16 square centimeters.',
      'So the remaining area is 96 − 16 = 80 square centimeters.',
    ],
    'ja' => [
      'もとの長方形の面積は 12 × 8 = 96 平方cmです。',
      '1つの角で切り取る正方形の面積は 2 × 2 = 4 平方cmです。',
      '4つの角で合計 16 平方cmを切り取ります。',
      'したがって残りの面積は 96 − 16 = 80 平方cmです。',
    ],
  }
  question['correctAnswer'] = { 'type' => 'integer', 'value' => '80' }
  question['inputConstraints'] = { 'allowNegative' => false, 'maxDigits' => 2 }
  question['figure'] = { 'type' => 'custom', 'kind' => 'none', 'params' => {} }
end

update_question(
  File.join(ROOT, 'assets/questions/geometry/grade4_foundation.geometry.v1.json'),
  'geometry_grade4_foundation_021'
) do |question|
  question['prompt'] = {
    'zh-Hant' => '一個正方形邊框上，除了四個角以外，每一邊中間都另外排 6 顆棋子；四個角上也各有 1 顆棋子。整個邊框一共有幾顆棋子？',
    'zh-Hans' => '一个正方形边框上，除了四个角以外，每一边中间都另外排 6 颗棋子；四个角上也各有 1 颗棋子。整个边框一共有几颗棋子？',
    'en' => 'On the border of a square, each side has 6 extra stones between the corners, and each of the 4 corners also has 1 stone. How many stones are there on the whole border?',
    'ja' => '正方形のわくの上で、4つの角をのぞいて各辺の途中に6個ずつ石を置きます。さらに4つの角にもそれぞれ1個ずつ石があります。わく全体では石は何個ありますか。',
  }
  question['answer'] = {
    'zh-Hant' => '答案是 28 顆。',
    'zh-Hans' => '答案是 28 颗。',
    'en' => 'The answer is 28.',
    'ja' => '答えは 28 個です。',
  }
  question['solutionSteps'] = {
    'zh-Hant' => [
      '四條邊中間一共放了 4 × 6 = 24 顆棋子。',
      '再加上四個角各 1 顆，共 4 顆。',
      '所以整個邊框共有 24 + 4 = 28 顆棋子。',
    ],
    'zh-Hans' => [
      '四条边中间一共放了 4 × 6 = 24 颗棋子。',
      '再加上四个角各 1 颗，共 4 颗。',
      '所以整个边框共有 24 + 4 = 28 颗棋子。',
    ],
    'en' => [
      'The middle parts of the 4 sides contain 4 × 6 = 24 stones.',
      'The 4 corner stones add 4 more.',
      'So the whole border has 24 + 4 = 28 stones.',
    ],
    'ja' => [
      '4本の辺の途中には 4 × 6 = 24 個の石があります。',
      'さらに4つの角に1個ずつあるので、4個増えます。',
      'したがって全部で 24 + 4 = 28 個です。',
    ],
  }
  question['correctAnswer'] = { 'type' => 'integer', 'value' => '28' }
  question['figure'] = { 'type' => 'custom', 'kind' => 'none', 'params' => {} }
end

update_question(
  File.join(ROOT, 'assets/questions/geometry/grade5_foundation.geometry.v1.json'),
  'geometry_grade5_foundation_012'
) do |question|
  question['prompt'] = {
    'zh-Hant' => '在座標平面上，點 P 在第一象限，y 座標是 3。P 對 y 軸的鏡射點是 Q。已知 P 到 Q 的距離是 10。P 的 x 座標是多少？',
    'zh-Hans' => '在座标平面上，点 P 在第一象限，y 坐标是 3。P 对 y 轴的镜射点是 Q。已知 P 到 Q 的距离是 10。P 的 x 坐标是多少？',
    'en' => 'On the coordinate plane, point P is in the first quadrant and has y-coordinate 3. Its reflection across the y-axis is Q. If the distance from P to Q is 10, what is the x-coordinate of P?',
    'ja' => '座標平面上で、点Pは第1象限にあり、y座標は3です。Pをy軸について対称移動した点をQとします。PからQまでの距離が10のとき、Pのx座標はいくつですか。',
  }
  question['answer'] = {
    'zh-Hant' => '答案是 5。',
    'zh-Hans' => '答案是 5。',
    'en' => 'The answer is 5.',
    'ja' => '答えは 5 です。',
  }
  question['solutionSteps'] = {
    'zh-Hant' => [
      'P 對 y 軸鏡射後，Q 的 y 座標不變，x 座標變成相反數。',
      '所以 P 和 Q 之間的距離，就是 P 到 y 軸距離的兩倍。',
      '已知 P 到 Q 是 10，所以 P 到 y 軸是 10 ÷ 2 = 5。',
      'P 在第一象限，因此 x 座標是 5。',
    ],
    'zh-Hans' => [
      'P 对 y 轴镜射后，Q 的 y 坐标不变，x 坐标变成相反数。',
      '所以 P 和 Q 之间的距离，就是 P 到 y 轴距离的两倍。',
      '已知 P 到 Q 是 10，所以 P 到 y 轴是 10 ÷ 2 = 5。',
      'P 在第一象限，因此 x 坐标是 5。',
    ],
    'en' => [
      'Reflecting across the y-axis keeps the y-coordinate the same and flips the x-coordinate.',
      'So the distance from P to Q is twice the distance from P to the y-axis.',
      'Since P to Q is 10, the distance from P to the y-axis is 10 ÷ 2 = 5.',
      'Because P is in the first quadrant, its x-coordinate is 5.',
    ],
    'ja' => [
      'y軸について対称移動すると、y座標は同じで、x座標だけ符号が反対になります。',
      'したがってPとQの距離は、Pからy軸までの距離の2倍です。',
      'PからQまでが10なので、Pからy軸までは 10 ÷ 2 = 5 です。',
      'Pは第1象限にあるので、x座標は 5 です。',
    ],
  }
  question['correctAnswer'] = { 'type' => 'integer', 'value' => '5' }
  question['figure'] = { 'type' => 'custom', 'kind' => 'none', 'params' => {} }
end

update_question(
  File.join(ROOT, 'assets/questions/logic/grade2_foundation.logic.v1.json'),
  'logic_grade2_foundation_010'
) do |question|
  question['prompt'] = {
    'zh-Hant' => '三張卡片上分別寫著 2、3、5。小安選的數不是最大的，也不是偶數。小安選了哪個數？',
    'zh-Hans' => '三张卡片上分别写著 2、3、5。小安选的数不是最大的，也不是偶数。小安选了哪个数？',
    'en' => 'Three cards are labeled 2, 3, and 5. An chooses a number that is not the greatest and is not even. Which number does An choose?',
    'ja' => '3枚のカードに 2、3、5 と書いてあります。アンさんが選んだ数は、いちばん大きくなく、しかも偶数でもありません。アンさんが選んだのはどの数ですか。',
  }
  question['answer'] = {
    'zh-Hant' => '答案是 3。',
    'zh-Hans' => '答案是 3。',
    'en' => 'The answer is 3.',
    'ja' => '答えは 3 です。',
  }
  question['solutionSteps'] = {
    'zh-Hant' => [
      '最大的數是 5，所以不能選 5。',
      '偶數是 2，所以也不能選 2。',
      '剩下只有 3，所以小安選的是 3。',
    ],
    'zh-Hans' => [
      '最大的数是 5，所以不能选 5。',
      '偶数是 2，所以也不能选 2。',
      '剩下只有 3，所以小安选的是 3。',
    ],
    'en' => [
      'The greatest number is 5, so An does not choose 5.',
      'The even number is 2, so An does not choose 2 either.',
      'The only remaining choice is 3.',
    ],
    'ja' => [
      'いちばん大きい数は 5 なので、5 は選びません。',
      '偶数は 2 なので、2 も選びません。',
      '残るのは 3 だけなので、アンさんが選んだ数は 3 です。',
    ],
  }
  question['options'] = {
    'A' => { 'zh-Hant' => '2', 'zh-Hans' => '2', 'en' => '2', 'ja' => '2' },
    'B' => { 'zh-Hant' => '3', 'zh-Hans' => '3', 'en' => '3', 'ja' => '3' },
    'C' => { 'zh-Hant' => '5', 'zh-Hans' => '5', 'en' => '5', 'ja' => '5' },
    'D' => { 'zh-Hant' => '無法判斷', 'zh-Hans' => '无法判断', 'en' => 'Cannot be determined', 'ja' => '判断できない' },
  }
  question['correctAnswer'] = { 'type' => 'choice', 'value' => 'B' }
end

update_question(
  File.join(ROOT, 'assets/questions/logic/grade6_foundation.logic.v1.json'),
  'logic_grade6_foundation_011'
) do |question|
  question['prompt'] = {
    'zh-Hant' => '某班學生都至少參加游泳隊或籃球隊。只參加游泳隊的人數比只參加籃球隊多 6 人，兩隊都參加的有 8 人，已知參加游泳隊的共有 22 人。只參加籃球隊的有幾人？',
    'zh-Hans' => '某班学生都至少参加游泳队或篮球队。只参加游泳队的人数比只参加篮球队多 6 人，两队都参加的有 8 人，已知参加游泳队的共有 22 人。只参加篮球队的有几人？',
    'en' => 'Every student in a class joins at least one of the swimming team or the basketball team. The number who join only swimming is 6 more than the number who join only basketball. Eight students join both teams, and 22 students join the swimming team in total. How many students join only the basketball team?',
    'ja' => 'あるクラスの生徒は全員、水泳チームかバスケットボールチームの少なくとも一方に入っています。水泳チームだけに入っている人数は、バスケットボールチームだけに入っている人数より6人多いです。両方に入っている生徒は8人で、水泳チームに入っている生徒は全部で22人です。バスケットボールチームだけに入っている生徒は何人ですか。',
  }
  question['answer'] = {
    'zh-Hant' => '答案是 8 人。',
    'zh-Hans' => '答案是 8 人。',
    'en' => 'The answer is 8.',
    'ja' => '答えは 8 人です。',
  }
  question['solutionSteps'] = {
    'zh-Hant' => [
      '設只參加籃球隊的有 x 人，則只參加游泳隊的有 x + 6 人。',
      '參加游泳隊的總人數 = 只參加游泳隊 + 兩隊都參加 = (x + 6) + 8。',
      '已知這個總數是 22，所以 (x + 6) + 8 = 22。',
      '解得 x = 8，所以只參加籃球隊的有 8 人。',
    ],
    'zh-Hans' => [
      '设只参加篮球队的有 x 人，则只参加游泳队的有 x + 6 人。',
      '参加游泳队的总人数 = 只参加游泳队 + 两队都参加 = (x + 6) + 8。',
      '已知这个总数是 22，所以 (x + 6) + 8 = 22。',
      '解得 x = 8，所以只参加篮球队的有 8 人。',
    ],
    'en' => [
      'Let x be the number of students who join only basketball. Then only swimming has x + 6 students.',
      'The total number in swimming is (only swimming) + (both teams) = (x + 6) + 8.',
      'This total is 22, so (x + 6) + 8 = 22.',
      'Solving gives x = 8, so 8 students join only basketball.',
    ],
    'ja' => [
      'バスケットボールだけに入っている人数を x 人とすると、水泳だけに入っている人数は x + 6 人です。',
      '水泳チームに入っている人数の合計は「水泳だけ」+「両方」なので、(x + 6) + 8 です。',
      'これが22人なので、(x + 6) + 8 = 22 となります。',
      'これを解くと x = 8 なので、バスケットボールだけに入っているのは8人です。',
    ],
  }
  question['correctAnswer'] = { 'type' => 'integer', 'value' => '8' }
end
