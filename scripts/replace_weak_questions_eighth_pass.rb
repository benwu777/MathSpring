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
  File.join(ROOT, 'assets/questions/geometry/grade2_foundation.geometry.v1.json'),
  'geometry_grade2_foundation_022'
) do |question|
  question['prompt'] = {
    'zh-Hant' => '用 4 個邊長 1 的小正方形拼成一個 L 形圖形。這個圖形的周長是多少？',
    'zh-Hans' => '用 4 个边长 1 的小正方形拼成一个 L 形图形。这个图形的周长是多少？',
    'en' => 'Four unit squares are joined to make an L-shaped figure. What is its perimeter?',
    'ja' => '1辺1の正方形4個をつないでL字形を作ります。この図形の周の長さはいくつですか。',
  }
  question['answer'] = {
    'zh-Hant' => '答案是 10。',
    'zh-Hans' => '答案是 10。',
    'en' => 'The answer is 10.',
    'ja' => '答えは 10 です。',
  }
  question['solutionSteps'] = {
    'zh-Hant' => [
      '4 個小正方形若分開，周長總和是 4 × 4 = 16。',
      '拼成 L 形時，一共有 3 條共用邊。',
      '每一條共用邊會讓外面的周長少 2，所以周長是 16 − 3 × 2 = 10。',
    ],
    'zh-Hans' => [
      '4 个小正方形若分开，周长总和是 4 × 4 = 16。',
      '拼成 L 形时，一共有 3 条共用边。',
      '每一条共用边会让外面的周长少 2，所以周长是 16 − 3 × 2 = 10。',
    ],
    'en' => [
      'If the 4 unit squares were separate, their total perimeter would be 16.',
      'The L shape has 3 shared edges.',
      'Each shared edge removes 2 from the outside boundary, so the perimeter is 16 − 6 = 10.',
    ],
    'ja' => [
      '4個の正方形がばらばらなら、周の長さの合計は16です。',
      'L字形では辺を3本共有しています。',
      '共有する辺1本につき外側の周は2ずつ減るので、周の長さは 16 − 6 = 10 です。',
    ],
  }
  question['figure'] = { 'type' => 'custom', 'kind' => 'none', 'params' => {} }
  question['correctAnswer'] = { 'type' => 'integer', 'value' => '10' }
end

update_question(
  File.join(ROOT, 'assets/questions/geometry/grade4_foundation.geometry.v1.json'),
  'geometry_grade4_foundation_001'
) do |question|
  question['prompt'] = {
    'zh-Hant' => '一個長方形的周長是 26 公分，而且長比寬多 5 公分。這個長方形的寬是多少公分？',
    'zh-Hans' => '一个长方形的周长是 26 公分，而且长比宽多 5 公分。这个长方形的宽是多少公分？',
    'en' => 'A rectangle has perimeter 26 cm, and its length is 5 cm more than its width. What is the width of the rectangle?',
    'ja' => '長方形の周の長さは26cmで、たての長さは横の幅より5cm長いです。この長方形の幅は何cmですか。',
  }
  question['answer'] = {
    'zh-Hant' => '答案是 4 公分。',
    'zh-Hans' => '答案是 4 公分。',
    'en' => 'The answer is 4 cm.',
    'ja' => '答えは 4cm です。',
  }
  question['solutionSteps'] = {
    'zh-Hant' => [
      '周長 26 公分表示長和寬的和是 13 公分。',
      '寬如果是 4 公分，長就是 9 公分，剛好多 5 公分，而且 4 + 9 = 13。',
      '所以長方形的寬是 4 公分。',
    ],
    'zh-Hans' => [
      '周长 26 公分表示长和宽的和是 13 公分。',
      '宽如果是 4 公分，长就是 9 公分，刚好多 5 公分，而且 4 + 9 = 13。',
      '所以长方形的宽是 4 公分。',
    ],
    'en' => [
      'Perimeter 26 cm means the length and width add to 13 cm.',
      'If the width is 4 cm, the length is 9 cm, which is 5 cm more and also sums to 13.',
      'So the width is 4 cm.',
    ],
    'ja' => [
      '周の長さが26cmなので、たてと横の和は13cmです。',
      '幅を4cmとすると、たては9cmで差は5cm、しかも 4 + 9 = 13 になります。',
      'したがって幅は4cmです。',
    ],
  }
  question['correctAnswer'] = { 'type' => 'integer', 'value' => '4' }
end

update_question(
  File.join(ROOT, 'assets/questions/geometry/grade4_foundation.geometry.v1.json'),
  'geometry_grade4_foundation_024'
) do |question|
  question['prompt'] = {
    'zh-Hant' => '一個長方形的面積是 27 平方公分，而且長是寬的 3 倍。這個長方形的周長是多少公分？',
    'zh-Hans' => '一个长方形的面积是 27 平方公分，而且长是宽的 3 倍。这个长方形的周长是多少公分？',
    'en' => 'A rectangle has area 27 square centimeters, and its length is 3 times its width. What is its perimeter?',
    'ja' => '長方形の面積は27平方cmで、たての長さは横の幅の3倍です。この長方形の周の長さは何cmですか。',
  }
  question['answer'] = {
    'zh-Hant' => '答案是 24 公分。',
    'zh-Hans' => '答案是 24 公分。',
    'en' => 'The answer is 24 cm.',
    'ja' => '答えは 24cm です。',
  }
  question['solutionSteps'] = {
    'zh-Hant' => [
      '若寬是 1 份，長就是 3 份，所以面積等於 3 份平方。',
      '27 ÷ 3 = 9，所以寬的平方是 9，寬是 3 公分。',
      '長是 3 × 3 = 9 公分。',
      '周長是 2 × (9 + 3) = 24 公分。',
    ],
    'zh-Hans' => [
      '若宽是 1 份，长就是 3 份，所以面积等于 3 份平方。',
      '27 ÷ 3 = 9，所以宽的平方是 9，宽是 3 公分。',
      '长是 3 × 3 = 9 公分。',
      '周长是 2 × (9 + 3) = 24 公分。',
    ],
    'en' => [
      'If the width is 1 part, then the length is 3 parts, so the area is 3 times the square of the width.',
      'Since 27 ÷ 3 = 9, the width squared is 9, so the width is 3 cm.',
      'The length is 9 cm.',
      'Therefore the perimeter is 2 × (9 + 3) = 24 cm.',
    ],
    'ja' => [
      '幅を1とすると、たては3になります。',
      'したがって面積は 3 × 幅 × 幅 です。',
      '27 ÷ 3 = 9 なので、幅の2乗は9、幅は3cmです。',
      'たては9cmだから、周の長さは 2 × (9 + 3) = 24cm です。',
    ],
  }
  question['correctAnswer'] = { 'type' => 'integer', 'value' => '24' }
end

update_question(
  File.join(ROOT, 'assets/questions/geometry/grade4_foundation.geometry.v1.json'),
  'geometry_grade4_foundation_036'
) do |question|
  question['prompt'] = {
    'zh-Hant' => '一個長方形的長比寬多 4 公分，周長是 32 公分。這個長方形的面積是多少平方公分？',
    'zh-Hans' => '一个长方形的长比宽多 4 公分，周长是 32 公分。这个长方形的面积是多少平方公分？',
    'en' => 'A rectangle has length 4 cm more than its width, and its perimeter is 32 cm. What is its area?',
    'ja' => '長方形のたての長さは横の幅より4cm長く、周の長さは32cmです。この長方形の面積は何平方cmですか。',
  }
  question['answer'] = {
    'zh-Hant' => '答案是 60 平方公分。',
    'zh-Hans' => '答案是 60 平方公分。',
    'en' => 'The answer is 60 square centimeters.',
    'ja' => '答えは 60 平方cmです。',
  }
  question['solutionSteps'] = {
    'zh-Hant' => [
      '周長 32 公分表示長和寬的和是 16 公分。',
      '若寬是 6 公分，長就是 10 公分，剛好多 4 公分，而且 6 + 10 = 16。',
      '所以面積是 6 × 10 = 60 平方公分。',
    ],
    'zh-Hans' => [
      '周长 32 公分表示长和宽的和是 16 公分。',
      '若宽是 6 公分，长就是 10 公分，刚好多 4 公分，而且 6 + 10 = 16。',
      '所以面积是 6 × 10 = 60 平方公分。',
    ],
    'en' => [
      'Perimeter 32 cm means the length and width add to 16 cm.',
      'A width of 6 cm gives a length of 10 cm, which is 4 cm more and also sums to 16.',
      'So the area is 6 × 10 = 60 square centimeters.',
    ],
    'ja' => [
      '周の長さが32cmなので、たてと横の和は16cmです。',
      '幅を6cmとすると、たては10cmで差は4cm、しかも 6 + 10 = 16 です。',
      'したがって面積は 6 × 10 = 60 平方cmです。',
    ],
  }
  question['correctAnswer'] = { 'type' => 'integer', 'value' => '60' }
end

update_question(
  File.join(ROOT, 'assets/questions/logic/grade2_foundation.logic.v1.json'),
  'logic_grade2_foundation_015'
) do |question|
  question['prompt'] = {
    'zh-Hant' => '四個座位從左到右是 1、2、3、4。小明不坐 1 號，也不坐 4 號；小華坐在小明右邊，而且小華不坐 4 號位。小明坐幾號位？',
    'zh-Hans' => '四个座位从左到右是 1、2、3、4。小明不坐 1 号，也不坐 4 号；小华坐在小明右边，而且小华不坐 4 号位。小明坐几号位？',
    'en' => 'Four seats are numbered 1 to 4 from left to right. Ming does not sit in seat 1 or 4. Hua sits to the right of Ming, and Hua is not in seat 4. Which seat does Ming sit in?',
    'ja' => '4つの席が左から1、2、3、4と並んでいます。ミンさんは1番にも4番にも座りません。ホアさんはミンさんの右側に座り、ホアさんは4番にも座りません。ミンさんは何番の席に座りますか。',
  }
  question['answer'] = {
    'zh-Hant' => '答案是 2。',
    'zh-Hans' => '答案是 2。',
    'en' => 'The answer is 2.',
    'ja' => '答えは 2 です。',
  }
  question['solutionSteps'] = {
    'zh-Hant' => [
      '小明不能坐 1 號，也不能坐 4 號，所以只可能是 2 號或 3 號。',
      '如果小明坐 3 號，小華只能在右邊的 4 號，和題意不合。',
      '所以小明不能坐 3 號，只能坐 2 號。',
    ],
    'zh-Hans' => [
      '小明不能坐 1 号，也不能坐 4 号，所以只可能是 2 号或 3 号。',
      '如果小明坐 3 号，小华只能在右边的 4 号，和题意不合。',
      '所以小明不能坐 3 号，只能坐 2 号。',
    ],
    'en' => [
      'Ming cannot sit in seat 1 or 4, so he can only be in seat 2 or 3.',
      'If Ming were in seat 3, Hua would have to be in seat 4, which is not allowed.',
      'So Ming must be in seat 2.',
    ],
    'ja' => [
      'ミンさんは1番にも4番にも座れないので、2番か3番です。',
      'もしミンさんが3番なら、ホアさんは右側の4番に座るしかなく、条件に反します。',
      'したがってミンさんは2番です。',
    ],
  }
  question['correctAnswer'] = { 'type' => 'integer', 'value' => '2' }
end

update_question(
  File.join(ROOT, 'assets/questions/logic/grade3_foundation.logic.v1.json'),
  'logic_grade3_foundation_020'
) do |question|
  question['prompt'] = {
    'zh-Hant' => '鑰匙藏在 1 到 6 號抽屜之一。它不在奇數號抽屜，也不在 6 號抽屜，而且在 2 號抽屜右邊。鑰匙在幾號抽屜？',
    'zh-Hans' => '钥匙藏在 1 到 6 号抽屉之一。它不在奇数号抽屉，也不在 6 号抽屉，而且在 2 号抽屉右边。钥匙在几号抽屉？',
    'en' => 'A key is hidden in one of drawers 1 to 6. It is not in an odd-numbered drawer, not in drawer 6, and is to the right of drawer 2. Which drawer is it in?',
    'ja' => '鍵は1番から6番までの引き出しのどれかにあります。奇数番号の引き出しにはなく、6番にもなく、2番の右側にあります。何番の引き出しですか。',
  }
  question['answer'] = {
    'zh-Hant' => '答案是 4。',
    'zh-Hans' => '答案是 4。',
    'en' => 'The answer is 4.',
    'ja' => '答えは 4 です。',
  }
  question['solutionSteps'] = {
    'zh-Hant' => [
      '不在奇數號抽屜，表示只可能是 2、4、6。',
      '又不在 6 號，所以只剩 2、4。',
      '它在 2 號抽屜右邊，因此不能是 2，只能是 4。',
    ],
    'zh-Hans' => [
      '不在奇数号抽屉，表示只可能是 2、4、6。',
      '又不在 6 号，所以只剩 2、4。',
      '它在 2 号抽屉右边，因此不能是 2，只能是 4。',
    ],
    'en' => [
      'Not being in an odd drawer means the key can only be in 2, 4, or 6.',
      'It is also not in 6, so only 2 or 4 remain.',
      'Since it is to the right of drawer 2, it cannot be 2, so it must be 4.',
    ],
    'ja' => [
      '奇数番号ではないので、候補は2、4、6です。',
      'さらに6番ではないので、2か4が残ります。',
      '2番の右側にあるので、2番ではなく4番です。',
    ],
  }
  question['correctAnswer'] = { 'type' => 'integer', 'value' => '4' }
end

update_question(
  File.join(ROOT, 'assets/questions/logic/grade5_foundation.logic.v1.json'),
  'logic_grade5_foundation_018'
) do |question|
  question['prompt'] = {
    'zh-Hant' => '密碼藏在 1 到 9 號櫃其中一個。它是奇數號，在 8 號左邊，不在 1 號，也不在 5 號，而且比 3 號大。密碼在哪一號櫃？',
    'zh-Hans' => '密码藏在 1 到 9 号柜其中一个。它是奇数号，在 8 号左边，不在 1 号，也不在 5 号，而且比 3 号大。密码在哪一号柜？',
    'en' => 'A code is hidden in one of lockers 1 to 9. It is in an odd-numbered locker, to the left of locker 8, not in locker 1 or 5, and greater than locker 3. Which locker is it in?',
    'ja' => '暗号は1番から9番までのロッカーのどれかにあります。奇数番号で、8番の左側にあり、1番でも5番でもなく、3番より大きいです。何番のロッカーですか。',
  }
  question['answer'] = {
    'zh-Hant' => '答案是 7。',
    'zh-Hans' => '答案是 7。',
    'en' => 'The answer is 7.',
    'ja' => '答えは 7 です。',
  }
  question['solutionSteps'] = {
    'zh-Hant' => [
      '奇數號候選有 1、3、5、7、9。',
      '在 8 號左邊，所以 9 不行；又不在 1 號，也不在 5 號。',
      '還要比 3 號大，所以 3 也不行。',
      '最後只剩 7 號櫃。',
    ],
    'zh-Hans' => [
      '奇数号候选有 1、3、5、7、9。',
      '在 8 号左边，所以 9 不行；又不在 1 号，也不在 5 号。',
      '还要比 3 号大，所以 3 也不行。',
      '最后只剩 7 号柜。',
    ],
    'en' => [
      'The odd-numbered candidates are 1, 3, 5, 7, and 9.',
      'Being to the left of 8 removes 9, and 1 and 5 are also excluded.',
      'It must also be greater than 3, so 3 is excluded too.',
      'That leaves locker 7.',
    ],
    'ja' => [
      '奇数番号の候補は1、3、5、7、9です。',
      '8番の左側なので9はだめで、さらに1番と5番でもありません。',
      '3番より大きいので3番もだめです。',
      '残るのは7番だけです。',
    ],
  }
  question['correctAnswer'] = { 'type' => 'integer', 'value' => '7' }
end

update_question(
  File.join(ROOT, 'assets/questions/logic/grade6_foundation.logic.v1.json'),
  'logic_grade6_foundation_021'
) do |question|
  question['prompt'] = {
    'zh-Hant' => '密碼藏在 1 到 11 號抽屜其中一個。它是偶數號，在 9 號左邊，不在 2 號，也不在 6 號，而且比 4 號大。密碼在哪一號抽屜？',
    'zh-Hans' => '密码藏在 1 到 11 号抽屉其中一个。它是偶数号，在 9 号左边，不在 2 号，也不在 6 号，而且比 4 号大。密码在哪一号抽屉？',
    'en' => 'A code is hidden in one of drawers 1 to 11. It is in an even-numbered drawer, to the left of drawer 9, not in drawer 2 or 6, and greater than drawer 4. Which drawer is it in?',
    'ja' => '暗号は1番から11番までの引き出しのどれかにあります。偶数番号で、9番の左側にあり、2番でも6番でもなく、4番より大きいです。何番の引き出しですか。',
  }
  question['answer'] = {
    'zh-Hant' => '答案是 8。',
    'zh-Hans' => '答案是 8。',
    'en' => 'The answer is 8.',
    'ja' => '答えは 8 です。',
  }
  question['solutionSteps'] = {
    'zh-Hant' => [
      '偶數號候選有 2、4、6、8、10。',
      '在 9 號左邊，所以 10 不行；又不在 2 號，也不在 6 號。',
      '還要比 4 號大，所以 4 也不行。',
      '最後只剩 8 號抽屜。',
    ],
    'zh-Hans' => [
      '偶数号候选有 2、4、6、8、10。',
      '在 9 号左边，所以 10 不行；又不在 2 号，也不在 6 号。',
      '还要比 4 号大，所以 4 也不行。',
      '最后只剩 8 号抽屉。',
    ],
    'en' => [
      'The even-numbered candidates are 2, 4, 6, 8, and 10.',
      'Being to the left of 9 removes 10, and 2 and 6 are also excluded.',
      'It must also be greater than 4, so 4 is excluded.',
      'That leaves drawer 8.',
    ],
    'ja' => [
      '偶数番号の候補は2、4、6、8、10です。',
      '9番の左側なので10はだめで、さらに2番と6番でもありません。',
      '4番より大きいので4番もだめです。',
      '残るのは8番だけです。',
    ],
  }
  question['correctAnswer'] = { 'type' => 'integer', 'value' => '8' }
end

update_question(
  File.join(ROOT, 'assets/questions/logic/grade2_foundation.logic.v1.json'),
  'logic_grade2_foundation_013'
) do |question|
  question['prompt'] = {
    'zh-Hant' => '幾個圖形是三角形、正方形、五邊形、六邊形。答案的邊數比 4 多，但不是邊數最多的圖形。這個圖形有幾條邊？',
    'zh-Hans' => '几个图形是三角形、正方形、五边形、六边形。答案的边数比 4 多，但不是边数最多的图形。这个图形有几条边？',
    'en' => 'The choices are triangle, square, pentagon, and hexagon. The answer has more than 4 sides, but it is not the figure with the most sides. How many sides does it have?',
    'ja' => '候補は三角形、正方形、五角形、六角形です。答えの辺の数は4より多いですが、いちばん多くはありません。その図形の辺の数はいくつですか。',
  }
  question['answer'] = {
    'zh-Hant' => '答案是 5 條邊。',
    'zh-Hans' => '答案是 5 条边。',
    'en' => 'The answer is 5 sides.',
    'ja' => '答えは 5 本の辺です。',
  }
  question['solutionSteps'] = {
    'zh-Hant' => [
      '邊數比 4 多的只有五邊形和六邊形。',
      '題目又說不是邊數最多的圖形，所以不能是六邊形。',
      '因此答案是五邊形。',
    ],
    'zh-Hans' => [
      '边数比 4 多的只有五边形和六边形。',
      '题目又说不是边数最多的图形，所以不能是六边形。',
      '因此答案是五边形。',
    ],
    'en' => [
      'Only the pentagon and hexagon have more than 4 sides.',
      'But the answer is not the figure with the most sides, so it cannot be the hexagon.',
      'Therefore the answer is the pentagon.',
    ],
    'ja' => [
      '4より多い辺をもつのは五角形と六角形だけです。',
      'しかし、辺の数がいちばん多い図形ではないので、六角形ではありません。',
      'したがって答えは五角形です。',
    ],
  }
  question['correctAnswer'] = { 'type' => 'integer', 'value' => '5' }
end

update_question(
  File.join(ROOT, 'assets/questions/logic/grade5_foundation.logic.v1.json'),
  'logic_grade5_foundation_021'
) do |question|
  question['prompt'] = {
    'zh-Hant' => '候選數有 30、32、34、36、38。答案不是 4 的倍數，比 31 大，小於 36，而且個位數字比十位數字大。答案是多少？',
    'zh-Hans' => '候选数有 30、32、34、36、38。答案不是 4 的倍数，比 31 大，小于 36，而且个位数字比十位数字大。答案是多少？',
    'en' => 'The candidate numbers are 30, 32, 34, 36, and 38. The answer is not a multiple of 4, is greater than 31, less than 36, and has a ones digit larger than its tens digit. What is the answer?',
    'ja' => '候補の数は30、32、34、36、38です。答えは4の倍数ではなく、31より大きく、36より小さく、1の位の数字が10の位の数字より大きいです。答えはいくつですか。',
  }
  question['answer'] = {
    'zh-Hant' => '答案是 34。',
    'zh-Hans' => '答案是 34。',
    'en' => 'The answer is 34.',
    'ja' => '答えは 34 です。',
  }
  question['solutionSteps'] = {
    'zh-Hant' => [
      '比 31 大的候選有 32、34、36、38。',
      '小於 36 的只剩 32、34。',
      '其中不是 4 的倍數的是 34。',
      '34 的個位數字 4 也比十位數字 3 大，所以答案是 34。',
    ],
    'zh-Hans' => [
      '比 31 大的候选有 32、34、36、38。',
      '小于 36 的只剩 32、34。',
      '其中不是 4 的倍数的是 34。',
      '34 的个位数字 4 也比十位数字 3 大，所以答案是 34。',
    ],
    'en' => [
      'The numbers greater than 31 are 32, 34, 36, and 38.',
      'Those less than 36 are 32 and 34.',
      'Among them, only 34 is not divisible by 4.',
      'Its ones digit 4 is also larger than its tens digit 3, so the answer is 34.',
    ],
    'ja' => [
      '31より大きい候補は32、34、36、38です。',
      '36より小さいのは32と34です。',
      'このうち4の倍数でないのは34だけです。',
      'しかも1の位の4は10の位の3より大きいので、答えは34です。',
    ],
  }
  question['correctAnswer'] = { 'type' => 'integer', 'value' => '34' }
end
