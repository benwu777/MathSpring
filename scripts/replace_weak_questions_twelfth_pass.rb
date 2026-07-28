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
  File.join(ROOT, 'assets/questions/arithmetic/grade3_foundation.arithmetic.v1.json'),
  'arithmetic_grade3_foundation_015'
) do |question|
  question['subtopic'] = 'elapsed_time'
  question['prompt'] = {
    'zh-Hant' => '一場活動上午 9:25 開始，經過 1 小時 40 分鐘後結束。活動在幾點幾分結束？',
    'zh-Hans' => '一场活动上午 9:25 开始，经过 1 小时 40 分钟后结束。活动在几点几分结束？',
    'en' => 'An event starts at 9:25 a.m. and ends 1 hour 40 minutes later. At what time does it end?',
    'ja' => 'ある活動は午前9時25分に始まり、1時間40分後に終わります。終わるのは何時何分ですか。',
  }
  question['answer'] = {
    'zh-Hant' => '答案是上午 11:05。',
    'zh-Hans' => '答案是上午 11:05。',
    'en' => 'The answer is 11:05 a.m.',
    'ja' => '答えは午前11時05分です。',
  }
  question['solutionSteps'] = {
    'zh-Hant' => ['先加 1 小時，9:25 變成 10:25。', '再加 40 分鐘，10:25 變成 11:05，所以活動在上午 11:05 結束。'],
    'zh-Hans' => ['先加 1 小时，9:25 变成 10:25。', '再加 40 分钟，10:25 变成 11:05，所以活动在上午 11:05 结束。'],
    'en' => ['First add 1 hour: 9:25 becomes 10:25.', 'Then add 40 minutes: 10:25 becomes 11:05, so the event ends at 11:05 a.m.'],
    'ja' => ['まず1時間足すと、9時25分は10時25分になります。', 'さらに40分足すと10時25分は11時05分になるので、終わりは午前11時05分です。'],
  }
  question['answerMode'] = 'multiple_choice'
  question['options'] = {
    'A' => { 'zh-Hant' => '上午 10:45', 'zh-Hans' => '上午 10:45', 'en' => '10:45 a.m.', 'ja' => '午前10時45分' },
    'B' => { 'zh-Hant' => '上午 11:05', 'zh-Hans' => '上午 11:05', 'en' => '11:05 a.m.', 'ja' => '午前11時05分' },
    'C' => { 'zh-Hant' => '上午 11:15', 'zh-Hans' => '上午 11:15', 'en' => '11:15 a.m.', 'ja' => '午前11時15分' },
    'D' => { 'zh-Hant' => '下午 12:05', 'zh-Hans' => '下午 12:05', 'en' => '12:05 p.m.', 'ja' => '午後12時05分' },
  }
  question['correctAnswer'] = { 'type' => 'choice', 'value' => 'B' }
end

update_question(
  File.join(ROOT, 'assets/questions/arithmetic/grade3_foundation.arithmetic.v1.json'),
  'arithmetic_grade3_foundation_010'
) do |question|
  question['subtopic'] = 'perimeter_from_area_pairs'
  question['prompt'] = {
    'zh-Hant' => '用 24 個小正方形排成長方形，長和寬都大於 1。若要讓周長最小，長和寬相差幾格？',
    'zh-Hans' => '用 24 个小正方形排成长方形，长和宽都大于 1。若要让周长最小，长和宽相差几格？',
    'en' => 'Arrange 24 unit squares into a rectangle with both side lengths greater than 1. If the perimeter is as small as possible, what is the difference between the side lengths?',
    'ja' => '24個の正方形を、縦も横も1より大きい長方形に並べます。周の長さが最も小さくなるとき、たてと横の差は何マスですか。',
  }
  question['answer'] = {
    'zh-Hant' => '答案是 2 格。',
    'zh-Hans' => '答案是 2 格。',
    'en' => 'The answer is 2.',
    'ja' => '答えは 2 マスです。',
  }
  question['solutionSteps'] = {
    'zh-Hant' => ['24 的長寬組合有 2×12、3×8、4×6。', '它們的周長分別是 28、22、20，所以最小周長出現在 4×6。', '這時長和寬相差 6 − 4 = 2 格。'],
    'zh-Hans' => ['24 的长宽组合有 2×12、3×8、4×6。', '它们的周长分别是 28、22、20，所以最小周长出现在 4×6。', '这时长和宽相差 6 − 4 = 2 格。'],
    'en' => ['The possible side pairs are 2×12, 3×8, and 4×6.', 'Their perimeters are 28, 22, and 20, so the smallest perimeter comes from 4×6.', 'The difference between the side lengths is 6 − 4 = 2.'],
    'ja' => ['考えられる組は 2×12、3×8、4×6 です。', '周の長さはそれぞれ 28、22、20 なので、最小なのは 4×6 です。', 'したがって辺の差は 6 − 4 = 2 マスです。'],
  }
  question['correctAnswer'] = { 'type' => 'integer', 'value' => '2' }
end

update_question(
  File.join(ROOT, 'assets/questions/arithmetic/grade5_foundation.arithmetic.v1.json'),
  'arithmetic_grade5_foundation_028'
) do |question|
  question['subtopic'] = 'gcd_lcm'
  question['prompt'] = {
    'zh-Hant' => '24 顆糖和 60 顆餅乾要分裝成若干完全一樣的點心包，每包糖和餅乾的數量都相同，而且兩樣都要分完。最多可以分成幾包？',
    'zh-Hans' => '24 颗糖和 60 颗饼干要分装成若干完全一样的点心包，每包糖和饼干的数量都相同，而且两样都要分完。最多可以分成几包？',
    'en' => 'Twenty-four candies and 60 cookies are to be packed into identical snack bags. Each bag must contain the same number of candies and the same number of cookies, and everything must be used. What is the greatest possible number of bags?',
    'ja' => '24個のあめと60枚のクッキーを、まったく同じおやつ袋に分けます。どの袋にもあめの数もクッキーの数も同じだけ入り、すべて使い切るものとします。作れる袋の最大の数はいくつですか。',
  }
  question['answer'] = {
    'zh-Hant' => '答案是 12 包。',
    'zh-Hans' => '答案是 12 包。',
    'en' => 'The answer is 12.',
    'ja' => '答えは 12 袋です。',
  }
  question['solutionSteps'] = {
    'zh-Hant' => ['袋數要同時整除 24 和 60，所以袋數必須是它們的公因數。', '要讓袋數最多，就找最大公因數。24 和 60 的最大公因數是 12。', '所以最多可以分成 12 包。'],
    'zh-Hans' => ['袋数要同时整除 24 和 60，所以袋数必须是它们的公因数。', '要让袋数最多，就找最大公因数。24 和 60 的最大公因数是 12。', '所以最多可以分成 12 包。'],
    'en' => ['The number of bags must divide both 24 and 60, so it must be a common divisor.', 'To maximize the number of bags, use the greatest common divisor. The GCD of 24 and 60 is 12.', 'So the greatest possible number of bags is 12.'],
    'ja' => ['袋の数は24と60の両方を割り切らなければならないので、公約数である必要があります。', '袋の数を最大にするには最大公約数を使います。24 と 60 の最大公約数は 12 です。', 'したがって最大で 12 袋作れます。'],
  }
  question['correctAnswer'] = { 'type' => 'integer', 'value' => '12' }
end

update_question(
  File.join(ROOT, 'assets/questions/arithmetic/grade3_foundation.arithmetic.v1.json'),
  'arithmetic_grade3_foundation_036'
) do |question|
  question['subtopic'] = 'work_backwards'
  question['prompt'] = {
    'zh-Hant' => '一桶水先倒出一半，再倒出 6 公升後，桶裡還剩 9 公升。原本桶裡有多少公升水？',
    'zh-Hans' => '一桶水先倒出一半，再倒出 6 公升后，桶里还剩 9 公升。原本桶里有多少公升水？',
    'en' => 'A bucket of water is first reduced by half, and then 6 more liters are poured out. There are 9 liters left. How many liters were in the bucket at first?',
    'ja' => 'バケツの水をまず半分だけ出し、そのあとさらに 6 リットル出したところ、9 リットル残りました。はじめに何リットル入っていましたか。',
  }
  question['answer'] = {
    'zh-Hant' => '答案是 30 公升。',
    'zh-Hans' => '答案是 30 公升。',
    'en' => 'The answer is 30 liters.',
    'ja' => '答えは 30 リットルです。',
  }
  question['solutionSteps'] = {
    'zh-Hant' => ['最後剩 9 公升，是倒出 6 公升之後的量，所以在那之前有 9 + 6 = 15 公升。', '這 15 公升是原來的一半，所以原本有 15 × 2 = 30 公升。'],
    'zh-Hans' => ['最后剩 9 公升，是倒出 6 公升之后的量，所以在那之前有 9 + 6 = 15 公升。', '这 15 公升是原来的一半，所以原本有 15 × 2 = 30 公升。'],
    'en' => ['The 9 liters left are after 6 liters were poured out, so just before that there were 9 + 6 = 15 liters.', 'Those 15 liters were half of the original amount, so the bucket originally held 15 × 2 = 30 liters.'],
    'ja' => ['最後の 9 リットルはさらに 6 リットル出したあとの量なので、その直前は 9 + 6 = 15 リットルでした。', 'この 15 リットルは元の半分なので、はじめは 15 × 2 = 30 リットルありました。'],
  }
  question['correctAnswer'] = { 'type' => 'integer', 'value' => '30' }
end

update_question(
  File.join(ROOT, 'assets/questions/arithmetic/grade4_foundation.arithmetic.v1.json'),
  'arithmetic_grade4_foundation_026'
) do |question|
  question['subtopic'] = 'clock_arithmetic'
  question['prompt'] = {
    'zh-Hant' => '現在鐘面上的時針正指向 3。再過 26 小時後，時針會指向幾？',
    'zh-Hans' => '现在钟面上的时针正指向 3。再过 26 小时后，时针会指向几？',
    'en' => 'The hour hand on a clock is pointing at 3 now. After 26 hours, what number will the hour hand point to?',
    'ja' => '今、時計の短針は 3 を指しています。26 時間後、短針は何を指していますか。',
  }
  question['answer'] = {
    'zh-Hant' => '答案是 5。',
    'zh-Hans' => '答案是 5。',
    'en' => 'The answer is 5.',
    'ja' => '答えは 5 です。',
  }
  question['solutionSteps'] = {
    'zh-Hant' => ['鐘面每 12 小時循環一次。26 小時就是 24 小時再加 2 小時。', '24 小時後仍然指向 3，再過 2 小時會指向 5。'],
    'zh-Hans' => ['钟面每 12 小时循环一次。26 小时就是 24 小时再加 2 小时。', '24 小时后仍然指向 3，再过 2 小时会指向 5。'],
    'en' => ['A clock repeats every 12 hours. Twenty-six hours is 24 hours plus 2 hours.', 'After 24 hours the hand is back at 3, and 2 more hours later it points to 5.'],
    'ja' => ['時計は 12 時間で1周します。26時間は 24 時間と 2 時間に分けられます。', '24時間後にはまた 3 を指し、さらに2時間後なので 5 を指します。'],
  }
  question['correctAnswer'] = { 'type' => 'integer', 'value' => '5' }
end

update_question(
  File.join(ROOT, 'assets/questions/logic/grade6_foundation.logic.v1.json'),
  'logic_grade6_foundation_015'
) do |question|
  question['subtopic'] = 'ranking'
  question['prompt'] = {
    'zh-Hant' => '甲、乙、丙、丁、戊五人賽跑。已知乙比甲快，丁比丙快，甲比丙快，而且戊不是第一名也不是最後一名。誰一定不是最後一名？',
    'zh-Hans' => '甲、乙、丙、丁、戊五人赛跑。已知乙比甲快，丁比丙快，甲比丙快，而且戊不是第一名也不是最后一名。谁一定不是最后一名？',
    'en' => 'A, B, C, D, and E run a race. B is faster than A, D is faster than C, A is faster than C, and E is neither first nor last. Who definitely is not in last place?',
    'ja' => '甲・乙・丙・丁・戊の5人がかけっこをします。乙は甲より速く、丁は丙より速く、甲は丙より速く、さらに戊は1位でも最下位でもありません。必ず最下位ではないのはだれですか。',
  }
  question['answer'] = {
    'zh-Hant' => '答案是甲。',
    'zh-Hans' => '答案是甲。',
    'en' => 'The answer is A.',
    'ja' => '答えは甲です。',
  }
  question['solutionSteps'] = {
    'zh-Hant' => ['甲比丙快，所以甲一定排在丙前面。', '既然丙至少在甲後面，甲就不可能是最後一名。'],
    'zh-Hans' => ['甲比丙快，所以甲一定排在丙前面。', '既然丙至少在甲后面，甲就不可能是最后一名。'],
    'en' => ['A is faster than C, so A must finish ahead of C.', 'Since C is definitely behind A, A cannot be in last place.'],
    'ja' => ['甲は丙より速いので、必ず甲は丙より前になります。', '丙が必ず甲の後ろにいる以上、甲が最下位になることはありません。'],
  }
  question['answerMode'] = 'multiple_choice'
  question['options'] = {
    'A' => { 'zh-Hant' => '甲', 'zh-Hans' => '甲', 'en' => 'A', 'ja' => '甲' },
    'B' => { 'zh-Hant' => '丙', 'zh-Hans' => '丙', 'en' => 'C', 'ja' => '丙' },
    'C' => { 'zh-Hant' => '丁', 'zh-Hans' => '丁', 'en' => 'D', 'ja' => '丁' },
    'D' => { 'zh-Hant' => '戊', 'zh-Hans' => '戊', 'en' => 'E', 'ja' => '戊' },
  }
  question['correctAnswer'] = { 'type' => 'choice', 'value' => 'A' }
end

puts 'Twelfth pass replacements complete.'
