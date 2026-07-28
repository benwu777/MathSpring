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
  'arithmetic_grade1_foundation_018'
) do |question|
  question['subtopic'] = 'rectangular_array'
  question['prompt'] = {
    'zh-Hant' => '教室把椅子排成 3 排，每排 4 張。教室裡一共有幾張椅子？',
    'zh-Hans' => '教室把椅子排成 3 排，每排 4 张。教室里一共有几张椅子？',
    'en' => 'Chairs are arranged in 3 rows with 4 chairs in each row. How many chairs are there altogether?',
    'ja' => 'いすを3列に並べ、1列に4脚ずつ置きます。いすは全部で何脚ありますか。',
  }
  question['answer'] = {
    'zh-Hant' => '答案是 12 張。',
    'zh-Hans' => '答案是 12 张。',
    'en' => 'The answer is 12.',
    'ja' => '答えは 12 脚です。',
  }
  question['solutionSteps'] = {
    'zh-Hant' => ['每排 4 張，一共 3 排，所以是 4 × 3 = 12 張。'],
    'zh-Hans' => ['每排 4 张，一共 3 排，所以是 4 × 3 = 12 张。'],
    'en' => ['There are 4 chairs in each row and 3 rows, so 4 × 3 = 12 chairs.'],
    'ja' => ['1列に4脚で3列あるので、4 × 3 = 12 脚です。'],
  }
  question['correctAnswer'] = { 'type' => 'integer', 'value' => '12' }
end

update_question(
  File.join(ROOT, 'assets/questions/arithmetic/grade2_foundation.arithmetic.v1.json'),
  'arithmetic_grade2_foundation_012'
) do |question|
  question['subtopic'] = 'skip_counting'
  question['prompt'] = {
    'zh-Hant' => '從 5 開始，每次加 4，連續寫出 4 個數。第四個數是多少？',
    'zh-Hans' => '从 5 开始，每次加 4，连续写出 4 个数。第四个数是多少？',
    'en' => 'Start from 5 and add 4 each time. Write 4 numbers in this pattern. What is the fourth number?',
    'ja' => '5 から始めて、毎回 4 ずつ足していきます。4つ目の数はいくつですか。',
  }
  question['answer'] = {
    'zh-Hant' => '答案是 17。',
    'zh-Hans' => '答案是 17。',
    'en' => 'The answer is 17.',
    'ja' => '答えは 17 です。',
  }
  question['solutionSteps'] = {
    'zh-Hant' => ['數列依次是 5、9、13、17，所以第四個數是 17。'],
    'zh-Hans' => ['数列依次是 5、9、13、17，所以第四个数是 17。'],
    'en' => ['The numbers are 5, 9, 13, and 17, so the fourth number is 17.'],
    'ja' => ['数は 5、9、13、17 と続くので、4つ目は 17 です。'],
  }
  question['correctAnswer'] = { 'type' => 'integer', 'value' => '17' }
end

update_question(
  File.join(ROOT, 'assets/questions/arithmetic/grade3_foundation.arithmetic.v1.json'),
  'arithmetic_grade3_foundation_034'
) do |question|
  question['subtopic'] = 'common_divisors'
  question['prompt'] = {
    'zh-Hant' => '18 和 24 共有幾個正公因數？',
    'zh-Hans' => '18 和 24 共有几个正公因数？',
    'en' => 'How many positive common divisors do 18 and 24 have?',
    'ja' => '18 と 24 の正の公約数は全部でいくつありますか。',
  }
  question['answer'] = {
    'zh-Hant' => '答案是 4 個。',
    'zh-Hans' => '答案是 4 个。',
    'en' => 'The answer is 4.',
    'ja' => '答えは 4 個です。',
  }
  question['solutionSteps'] = {
    'zh-Hant' => ['18 和 24 的最大公因數是 6。', '公因數就是 6 的因數：1、2、3、6，共 4 個。'],
    'zh-Hans' => ['18 和 24 的最大公因数是 6。', '公因数就是 6 的因数：1、2、3、6，共 4 个。'],
    'en' => ['The greatest common divisor of 18 and 24 is 6.', 'So their common divisors are the divisors of 6: 1, 2, 3, and 6, giving 4 in total.'],
    'ja' => ['18 と 24 の最大公約数は 6 です。', 'したがって公約数は 6 の約数、つまり 1、2、3、6 の4個です。'],
  }
  question['correctAnswer'] = { 'type' => 'integer', 'value' => '4' }
end

update_question(
  File.join(ROOT, 'assets/questions/arithmetic/grade1_foundation.arithmetic.v1.json'),
  'arithmetic_grade1_foundation_039'
) do |question|
  question['subtopic'] = 'missing_addend'
  question['prompt'] = {
    'zh-Hant' => '樹上原本有一些小鳥，飛走了 2 隻後還剩 5 隻。原本有幾隻小鳥？',
    'zh-Hans' => '树上原本有一些小鸟，飞走了 2 只后还剩 5 只。原本有几只小鸟？',
    'en' => 'There were some birds in a tree. After 2 flew away, 5 were left. How many birds were there at first?',
    'ja' => '木に何羽かの鳥がいました。2羽飛んでいったあと、5羽残りました。はじめは何羽いましたか。',
  }
  question['answer'] = {
    'zh-Hant' => '答案是 7 隻。',
    'zh-Hans' => '答案是 7 只。',
    'en' => 'The answer is 7.',
    'ja' => '答えは 7 羽です。',
  }
  question['solutionSteps'] = {
    'zh-Hant' => ['飛走的 2 隻和剩下的 5 隻加回去，原本有 2 + 5 = 7 隻。'],
    'zh-Hans' => ['飞走的 2 只和剩下的 5 只加回去，原本有 2 + 5 = 7 只。'],
    'en' => ['Add back the 2 birds that flew away to the 5 that remained: 2 + 5 = 7.'],
    'ja' => ['飛んでいった2羽を残りの5羽に戻して考えると、2 + 5 = 7 羽です。'],
  }
  question['correctAnswer'] = { 'type' => 'integer', 'value' => '7' }
end

update_question(
  File.join(ROOT, 'assets/questions/arithmetic/grade4_foundation.arithmetic.v1.json'),
  'arithmetic_grade4_foundation_026'
) do |question|
  question['subtopic'] = 'lcm_schedule'
  question['prompt'] = {
    'zh-Hant' => '兩盞燈同時亮起後，第一盞每 6 秒亮一次，第二盞每 8 秒亮一次。再過幾秒它們會再次同時亮起？',
    'zh-Hans' => '两盏灯同时亮起后，第一盏每 6 秒亮一次，第二盏每 8 秒亮一次。再过几秒它们会再次同时亮起？',
    'en' => 'Two lights flash together now. The first flashes every 6 seconds and the second every 8 seconds. After how many seconds will they flash together again?',
    'ja' => '2つのライトが今同時に点きました。1つ目は6秒ごと、2つ目は8秒ごとに点きます。次に同時に点くのは何秒後ですか。',
  }
  question['answer'] = {
    'zh-Hant' => '答案是 24 秒。',
    'zh-Hans' => '答案是 24 秒。',
    'en' => 'The answer is 24.',
    'ja' => '答えは 24 秒です。',
  }
  question['solutionSteps'] = {
    'zh-Hant' => ['再次同時亮起的時間要同時是 6 和 8 的倍數。', '最小的共同倍數是 24，所以再過 24 秒會再次同時亮起。'],
    'zh-Hans' => ['再次同时亮起的时间要同时是 6 和 8 的倍数。', '最小的共同倍数是 24，所以再过 24 秒会再次同时亮起。'],
    'en' => ['The next common flash time must be a common multiple of 6 and 8.', 'The least common multiple is 24, so they will flash together again after 24 seconds.'],
    'ja' => ['次に同時に点く時刻は、6 と 8 の公倍数でなければなりません。', '最小公倍数は24なので、24秒後にまた同時に点きます。'],
  }
  question['correctAnswer'] = { 'type' => 'integer', 'value' => '24' }
end

update_question(
  File.join(ROOT, 'assets/questions/logic/grade5_foundation.logic.v1.json'),
  'logic_grade5_foundation_001'
) do |question|
  question['subtopic'] = 'truth_deduction'
  question['prompt'] = {
    'zh-Hant' => '甲、乙、丙三人中只有一人說真話。甲說：「答案不是 8。」乙說：「答案是 8。」丙說：「乙說錯了。」答案在 6、8、10 之中。答案是多少？',
    'zh-Hans' => '甲、乙、丙三人中只有一人说真话。甲说：「答案不是 8。」乙说：「答案是 8。」丙说：「乙说错了。」答案在 6、8、10 之中。答案是多少？',
    'en' => 'Exactly one of A, B, and C is telling the truth. A says, "The answer is not 8." B says, "The answer is 8." C says, "B is wrong." The answer is one of 6, 8, and 10. What is it?',
    'ja' => '甲・乙・丙の3人のうち、正しいことを言っているのは1人だけです。甲は「答えは8ではない」、乙は「答えは8だ」、丙は「乙はまちがっている」と言いました。答えは 6、8、10 のどれかです。答えはいくつですか。',
  }
  question['answer'] = {
    'zh-Hant' => '答案是 8。',
    'zh-Hans' => '答案是 8。',
    'en' => 'The answer is 8.',
    'ja' => '答えは 8 です。',
  }
  question['solutionSteps'] = {
    'zh-Hant' => ['如果答案不是 8，甲和丙都會說對，不符合只有一人說真話。', '所以答案只能是 8。這時乙說對，甲和丙都說錯。'],
    'zh-Hans' => ['如果答案不是 8，甲和丙都会说对，不符合只有一人说真话。', '所以答案只能是 8。这时乙说对，甲和丙都说错。'],
    'en' => ['If the answer were not 8, then both A and C would be true, which is impossible.', 'So the answer must be 8. Then only B is telling the truth.'],
    'ja' => ['もし答えが8でなければ、甲と丙の2人が正しくなってしまいます。', 'したがって答えは8しかありません。このとき正しいのは乙だけです。'],
  }
  question['correctAnswer'] = { 'type' => 'integer', 'value' => '8' }
end

puts 'Eleventh pass replacements complete.'
