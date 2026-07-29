#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'

ROOT = File.expand_path('..', __dir__)
ARITHMETIC_PATH = File.join(ROOT, 'assets/questions/arithmetic/grade4_foundation.arithmetic.v1.json')
MANIFEST_PATH = File.join(ROOT, 'assets/questions/manifest.json')
SOURCE_URL = 'https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD4%E5%B9%B4%E7%B4%9A%200926-.pdf'

def load_json(path)
  JSON.parse(File.read(path))
end

def save_json(path, data)
  File.write(path, JSON.pretty_generate(data) + "\n")
end

def source_meta(problem_number, notes)
  {
    'type' => 'official_reference',
    'name' => 'IMC',
    'contest' => '第16屆IMC國際數學競賽台灣區初賽',
    'year' => '2015',
    'division' => '國小四年級',
    'problemNumber' => problem_number,
    'displayText' => "第16屆IMC台灣區初賽國小四年級 #{problem_number}",
    'sourceUrl' => SOURCE_URL,
    'rightsStatus' => 'needs_review',
    'notes' => notes,
  }
end

def figure_none
  { 'type' => 'custom', 'kind' => 'none', 'params' => {} }
end

def choice_options(a:, b:, c:, d:)
  {
    'A' => { 'zh-Hant' => a, 'zh-Hans' => a, 'en' => a, 'ja' => a },
    'B' => { 'zh-Hant' => b, 'zh-Hans' => b, 'en' => b, 'ja' => b },
    'C' => { 'zh-Hant' => c, 'zh-Hans' => c, 'en' => c, 'ja' => c },
    'D' => { 'zh-Hant' => d, 'zh-Hans' => d, 'en' => d, 'ja' => d },
  }
end

def choice_question(id:, subtopic:, prompt:, answer:, steps:, options:, correct:, problem_number:, notes:)
  {
    'id' => id,
    'topic' => 'arithmetic',
    'subtopic' => subtopic,
    'difficulty' => 'foundation',
    'levelStage' => 'grade4',
    'challengeTier' => 'foundation',
    'prompt' => prompt,
    'answer' => answer,
    'solutionSteps' => steps,
    'figure' => figure_none,
    'answerMode' => 'multiple_choice',
    'options' => options,
    'correctAnswer' => { 'type' => 'choice', 'value' => correct },
    'source' => source_meta(problem_number, notes),
  }
end

data = load_json(ARITHMETIC_PATH)
manifest = load_json(MANIFEST_PATH)

questions = [
  choice_question(
    id: 'arithmetic_grade4_foundation_051',
    subtopic: 'powers',
    prompt: {
      'zh-Hant' => '定義 5^3 = 5×5×5，7^2 = 7×7，求 14^2 + 6^4 = ?',
      'zh-Hans' => '定义 5^3 = 5×5×5，7^2 = 7×7，求 14^2 + 6^4 = ?',
      'en' => 'Given 5^3 = 5×5×5 and 7^2 = 7×7, what is 14^2 + 6^4?',
      'ja' => '5^3 = 5×5×5、7^2 = 7×7 とするとき、14^2 + 6^4 はいくつですか。',
    },
    answer: { 'zh-Hant' => '答案是 1492。', 'zh-Hans' => '答案是 1492。', 'en' => 'The answer is 1492.', 'ja' => '答えは 1492 です。' },
    steps: {
      'zh-Hant' => ['14^2 = 196。', '6^4 = 1296。', '1296 + 196 = 1492。'],
      'zh-Hans' => ['14^2 = 196。', '6^4 = 1296。', '1296 + 196 = 1492。'],
      'en' => ['14^2 = 196.', '6^4 = 1296.', 'Adding gives 1492.'],
      'ja' => ['14^2 = 196 です。', '6^4 = 1296 です。', '足すと 1492 です。'],
    },
    options: choice_options(a: '1482', b: '1472', c: '1492', d: '1462'),
    correct: 'C',
    problem_number: '選擇 1',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade4_foundation_052',
    subtopic: 'elapsed_time',
    prompt: {
      'zh-Hant' => '爸爸晚上 8 時出門工作，隔天早上 9 時回家。他一共工作了多久？',
      'zh-Hans' => '爸爸晚上 8 时出门工作，隔天早上 9 时回家。他一共工作了多久？',
      'en' => 'Dad left for work at 8 p.m. and returned at 9 a.m. the next day. How long did he work?',
      'ja' => 'お父さんは夜8時に仕事へ出かけ、翌朝9時に帰宅しました。何時間働きましたか。',
    },
    answer: { 'zh-Hant' => '答案是 13 小時。', 'zh-Hans' => '答案是 13 小时。', 'en' => 'The answer is 13 hours.', 'ja' => '答えは 13 時間です。' },
    steps: {
      'zh-Hant' => ['晚上 8 時到午夜 12 時是 4 小時。', '再加上隔天早上 9 小時，共 13 小時。'],
      'zh-Hans' => ['晚上 8 时到午夜 12 时是 4 小时。', '再加上隔天早上 9 小时，共 13 小时。'],
      'en' => ['From 8 p.m. to midnight is 4 hours.', 'Add 9 more hours to 9 a.m., giving 13 hours.'],
      'ja' => ['夜8時から深夜12時までで4時間です。', 'さらに朝9時までの9時間を足して、合計13時間です。'],
    },
    options: choice_options(a: '12 小時', b: '13 小時', c: '11 小時', d: '17 小時'),
    correct: 'B',
    problem_number: '選擇 2',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade4_foundation_053',
    subtopic: 'equation_reasoning',
    prompt: {
      'zh-Hant' => '12.8 + ★ - 0.4 = 15.2 - ★，求 ★ = ?',
      'zh-Hans' => '12.8 + ★ - 0.4 = 15.2 - ★，求 ★ = ?',
      'en' => 'Solve 12.8 + ★ - 0.4 = 15.2 - ★.',
      'ja' => '12.8 + ★ - 0.4 = 15.2 - ★ のとき、★はいくつですか。',
    },
    answer: { 'zh-Hant' => '答案是 1.4。', 'zh-Hans' => '答案是 1.4。', 'en' => 'The answer is 1.4.', 'ja' => '答えは 1.4 です。' },
    steps: {
      'zh-Hant' => ['左邊化簡成 12.4 + ★。', '所以 12.4 + ★ = 15.2 - ★，得到 2★ = 2.8。', '因此 ★ = 1.4。'],
      'zh-Hans' => ['左边化简成 12.4 + ★。', '所以 12.4 + ★ = 15.2 - ★，得到 2★ = 2.8。', '因此 ★ = 1.4。'],
      'en' => ['The left side becomes 12.4 + ★.', 'Then 12.4 + ★ = 15.2 - ★, so 2★ = 2.8.', 'Thus ★ = 1.4.'],
      'ja' => ['左辺は 12.4 + ★ になります。', 'したがって 12.4 + ★ = 15.2 - ★ なので、2★ = 2.8 です。', 'よって ★ = 1.4 です。'],
    },
    options: choice_options(a: '1.4', b: '2.1', c: '2.8', d: '1.8'),
    correct: 'A',
    problem_number: '選擇 3',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade4_foundation_054',
    subtopic: 'custom_division',
    prompt: {
      'zh-Hant' => '2019 ÷ 6□ = □2……□，空格內都是相同的數字。那麼 2019 ÷ □□ 的餘數是多少？',
      'zh-Hans' => '2019 ÷ 6□ = □2……□，空格内都是相同的数字。那么 2019 ÷ □□ 的余数是多少？',
      'en' => 'If 2019 ÷ 6□ = □2 remainder □, with all boxes the same digit, what is the remainder of 2019 ÷ □□?',
      'ja' => '2019 ÷ 6□ = □2 あまり □ で、すべての□が同じ数字です。では 2019 ÷ □□ のあまりはいくつですか。',
    },
    answer: { 'zh-Hant' => '答案是 6。', 'zh-Hans' => '答案是 6。', 'en' => 'The answer is 6.', 'ja' => '答えは 6 です。' },
    steps: {
      'zh-Hant' => ['6□ 要接近 63，所以 □ = 3。', '因此 2019 = 63×32 + 3。', '改成除以 33，可得 2019 = 33×61 + 6，所以餘數是 6。'],
      'zh-Hans' => ['6□ 要接近 63，所以 □ = 3。', '因此 2019 = 63×32 + 3。', '改成除以 33，可得 2019 = 33×61 + 6，所以余数是 6。'],
      'en' => ['The divisor 6□ must be 63, so □ = 3.', 'Then 2019 = 63×32 + 3.', 'Dividing by 33 gives 2019 = 33×61 + 6, so the remainder is 6.'],
      'ja' => ['6□ は 63 と考えられるので、□ = 3 です。', 'すると 2019 = 63×32 + 3 です。', '33で割ると 2019 = 33×61 + 6 なので、あまりは 6 です。'],
    },
    options: choice_options(a: '13', b: '9', c: '11', d: '6'),
    correct: 'D',
    problem_number: '選擇 4',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade4_foundation_055',
    subtopic: 'fraction_subtraction',
    prompt: {
      'zh-Hant' => '桌上原有 3/5 個披薩，John 吃了一些後，還剩下 3/10 個披薩。John 吃了多少個披薩？',
      'zh-Hans' => '桌上原有 3/5 个披萨，John 吃了一些后，还剩下 3/10 个披萨。John 吃了多少个披萨？',
      'en' => 'There was 3/5 of a pizza. After John ate some, 3/10 remained. How much did John eat?',
      'ja' => 'はじめにピザが 3/5 あり、John が食べたあと 3/10 残りました。John はどれだけ食べましたか。',
    },
    answer: { 'zh-Hant' => '答案是 3/10。', 'zh-Hans' => '答案是 3/10。', 'en' => 'The answer is 3/10.', 'ja' => '答えは 3/10 です。' },
    steps: {
      'zh-Hant' => ['3/5 = 6/10。', '6/10 - 3/10 = 3/10。'],
      'zh-Hans' => ['3/5 = 6/10。', '6/10 - 3/10 = 3/10。'],
      'en' => ['Convert 3/5 to 6/10.', 'Then 6/10 - 3/10 = 3/10.'],
      'ja' => ['3/5 を 6/10 に直します。', '6/10 - 3/10 = 3/10 です。'],
    },
    options: choice_options(a: '2/10', b: '3/10', c: '4/10', d: '5/10'),
    correct: 'B',
    problem_number: '選擇 5',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade4_foundation_056',
    subtopic: 'place_value_reading',
    prompt: {
      'zh-Hant' => '數字「40000400004」應讀作什麼？',
      'zh-Hans' => '数字「40000400004」应读作什么？',
      'en' => 'How is 40000400004 read in Chinese place-value notation?',
      'ja' => '数 40000400004 はどのように読みますか。',
    },
    answer: { 'zh-Hant' => '答案是四百億零四十萬零四。', 'zh-Hans' => '答案是四百亿零四十万零四。', 'en' => 'The answer is 40 billion 40 ten-thousands and 4.', 'ja' => '答えは「四百億零四十萬零四」です。' },
    steps: {
      'zh-Hant' => ['寫成分節形式是 400,0040,0004。', '依照中文位值讀作四百億零四十萬零四。'],
      'zh-Hans' => ['写成分节形式是 400,0040,0004。', '依照中文位值读作四百亿零四十万零四。'],
      'en' => ['Group the digits as 400,0040,0004.', 'This reads as four hundred hundred-millions, zero forty ten-thousands, and four.'],
      'ja' => ['3桁ごとではなく中文の位取りで区切ると 400,0040,0004 です。', 'したがって読み方は「四百億零四十萬零四」です。'],
    },
    options: choice_options(a: '四十億零四萬零四', b: '四百億零四十萬零四', c: '四零零零零四零零零零四', d: '四百億零四千零四'),
    correct: 'B',
    problem_number: '選擇 7',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade4_foundation_057',
    subtopic: 'clock_angles',
    prompt: {
      'zh-Hant' => '現在時間是 7 時 15 分，再過 15 分鐘後，時針與分針的最小夾角是多少度？',
      'zh-Hans' => '现在时间是 7 时 15 分，再过 15 分钟后，时针与分针的最小夹角是多少度？',
      'en' => 'It is now 7:15. After 15 more minutes, what is the smaller angle between the hour hand and minute hand?',
      'ja' => '今は7時15分です。15分後、短針と長針の小さいほうの角は何度ですか。',
    },
    answer: { 'zh-Hant' => '答案是 45 度。', 'zh-Hans' => '答案是 45 度。', 'en' => 'The answer is 45 degrees.', 'ja' => '答えは 45 度です。' },
    steps: {
      'zh-Hant' => ['15 分後是 7:30。', '此時分針在 6，時針在 7 和 8 的中間。', '6 到 7 是 30 度，再加上半格 15 度，所以是 45 度。'],
      'zh-Hans' => ['15 分后是 7:30。', '此时分针在 6，时针在 7 和 8 的中间。', '6 到 7 是 30 度，再加上半格 15 度，所以是 45 度。'],
      'en' => ['Fifteen minutes later it is 7:30.', 'The minute hand is at 6 and the hour hand is halfway between 7 and 8.', 'That makes 30 + 15 = 45 degrees.'],
      'ja' => ['15分後は 7:30 です。', '長針は6、短針は7と8のちょうど間にあります。', '30度と15度を合わせて 45度 です。'],
    },
    options: choice_options(a: '45 度', b: '30 度', c: '40 度', d: '50 度'),
    correct: 'A',
    problem_number: '選擇 9',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade4_foundation_058',
    subtopic: 'time_conversion',
    prompt: {
      'zh-Hant' => '2.5 日與 2 日 5 時相差多少時間？',
      'zh-Hans' => '2.5 日与 2 日 5 时相差多少时间？',
      'en' => 'What is the difference between 2.5 days and 2 days 5 hours?',
      'ja' => '2.5日と2日5時間の差は何時間ですか。',
    },
    answer: { 'zh-Hant' => '答案是 7 小時。', 'zh-Hans' => '答案是 7 小时。', 'en' => 'The answer is 7 hours.', 'ja' => '答えは 7 時間です。' },
    steps: {
      'zh-Hant' => ['0.5 日 = 12 小時，所以 2.5 日 = 2 日 12 小時。', '12 - 5 = 7，所以相差 7 小時。'],
      'zh-Hans' => ['0.5 日 = 12 小时，所以 2.5 日 = 2 日 12 小时。', '12 - 5 = 7，所以相差 7 小时。'],
      'en' => ['0.5 day equals 12 hours, so 2.5 days is 2 days 12 hours.', 'The difference from 2 days 5 hours is 7 hours.'],
      'ja' => ['0.5日は12時間なので、2.5日は2日12時間です。', '2日5時間との差は 7時間 です。'],
    },
    options: choice_options(a: '兩個時間相等', b: '5 小時', c: '7 小時', d: '9 小時'),
    correct: 'C',
    problem_number: '選擇 11',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade4_foundation_059',
    subtopic: 'symbol_equation',
    prompt: {
      'zh-Hant' => '★+★+★=◎，且 ★×◎=147，求 ◎−★ = ?',
      'zh-Hans' => '★+★+★=◎，且 ★×◎=147，求 ◎−★ = ?',
      'en' => 'If ★+★+★=◎ and ★×◎=147, what is ◎−★?',
      'ja' => '★+★+★=◎ で、★×◎=147 のとき、◎−★ はいくつですか。',
    },
    answer: { 'zh-Hant' => '答案是 14。', 'zh-Hans' => '答案是 14。', 'en' => 'The answer is 14.', 'ja' => '答えは 14 です。' },
    steps: {
      'zh-Hant' => ['因為 ◎ = 3★，所以 3★² = 147。', '可得 ★² = 49，所以 ★ = 7。', '因此 ◎ = 21，21 - 7 = 14。'],
      'zh-Hans' => ['因为 ◎ = 3★，所以 3★² = 147。', '可得 ★² = 49，所以 ★ = 7。', '因此 ◎ = 21，21 - 7 = 14。'],
      'en' => ['Since ◎ = 3★, we get 3★² = 147.', 'So ★² = 49 and ★ = 7.', 'Then ◎ = 21, so ◎−★ = 14.'],
      'ja' => ['◎ = 3★ なので、3★² = 147 です。', 'したがって ★² = 49、★ = 7 です。', '◎ = 21 なので、◎−★ = 14 です。'],
    },
    options: choice_options(a: '13', b: '14', c: '15', d: '16'),
    correct: 'B',
    problem_number: '選擇 12',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade4_foundation_060',
    subtopic: 'equation_reasoning',
    prompt: {
      'zh-Hant' => 'A、B 都是 1 到 9 的數字，且 (A+2B)÷B = 7，則 A×B = ?',
      'zh-Hans' => 'A、B 都是 1 到 9 的数字，且 (A+2B)÷B = 7，则 A×B = ?',
      'en' => 'A and B are digits from 1 to 9. If (A+2B)÷B = 7, what is A×B?',
      'ja' => 'A、B は 1 から 9 までの数字で、(A+2B)÷B = 7 のとき、A×B はいくつですか。',
    },
    answer: { 'zh-Hant' => '答案是 5。', 'zh-Hans' => '答案是 5。', 'en' => 'The answer is 5.', 'ja' => '答えは 5 です。' },
    steps: {
      'zh-Hant' => ['由 (A+2B)÷B = 7 得 A + 2B = 7B。', '所以 A = 5B。因 A 仍是數字，只能是 B=1、A=5。', '因此 A×B = 5。'],
      'zh-Hans' => ['由 (A+2B)÷B = 7 得 A + 2B = 7B。', '所以 A = 5B。因 A 仍是数字，只能是 B=1、A=5。', '因此 A×B = 5。'],
      'en' => ['From (A+2B)÷B = 7, we get A + 2B = 7B.', 'So A = 5B. Since A is still a digit, the only possibility is B=1 and A=5.', 'Thus A×B = 5.'],
      'ja' => ['(A+2B)÷B = 7 より A + 2B = 7B です。', 'したがって A = 5B。A も数字なので、B=1、A=5 しかありません。', 'よって A×B = 5 です。'],
    },
    options: choice_options(a: '5', b: '6', c: '8', d: '10'),
    correct: 'A',
    problem_number: '選擇 13',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade4_foundation_061',
    subtopic: 'optimization',
    prompt: {
      'zh-Hant' => '16×A + B×C = 320，A、B、C 都是大於 0 的整數，且 B、C 不相同。A+B+C 的最小值是多少？',
      'zh-Hans' => '16×A + B×C = 320，A、B、C 都是大于 0 的整数，且 B、C 不相同。A+B+C 的最小值是多少？',
      'en' => 'If 16×A + B×C = 320, where A, B, and C are positive integers and B and C are different, what is the minimum of A+B+C?',
      'ja' => '16×A + B×C = 320 で、A、B、C は正の整数、B と C は異なるとき、A+B+C の最小値はいくつですか。',
    },
    answer: { 'zh-Hant' => '答案是 29。', 'zh-Hans' => '答案是 29。', 'en' => 'The answer is 29.', 'ja' => '答えは 29 です。' },
    steps: {
      'zh-Hant' => ['讓 16×A 盡量接近 320，可取 A=19，得到 16×19=304。', '剩下 16，可拆成 2×8，且 2 和 8 不同。', '所以 A+B+C = 19+2+8 = 29。'],
      'zh-Hans' => ['让 16×A 尽量接近 320，可取 A=19，得到 16×19=304。', '剩下 16，可拆成 2×8，且 2 和 8 不同。', '所以 A+B+C = 19+2+8 = 29。'],
      'en' => ['Choose A=19 so that 16×A is as close to 320 as possible: 304.', 'The remaining 16 can be written as 2×8, with different factors.', 'So A+B+C = 19+2+8 = 29.'],
      'ja' => ['16×A を320にできるだけ近づけると A=19 で 304 です。', '残りの 16 は 2×8 と分けられ、2と8は異なります。', 'したがって A+B+C = 19+2+8 = 29 です。'],
    },
    options: choice_options(a: '27', b: '29', c: '28', d: '30'),
    correct: 'B',
    problem_number: '選擇 14',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade4_foundation_062',
    subtopic: 'digit_sum_counting',
    prompt: {
      'zh-Hant' => '四位數的數字和是 34，符合條件的四位數共有幾個？',
      'zh-Hans' => '四位数的数字和是 34，符合条件的四位数共有几个？',
      'en' => 'How many four-digit numbers have a digit sum of 34?',
      'ja' => '各けたの和が34になる4けたの数は全部でいくつありますか。',
    },
    answer: { 'zh-Hant' => '答案是 10 個。', 'zh-Hans' => '答案是 10 个。', 'en' => 'The answer is 10.', 'ja' => '答えは 10 個です。' },
    steps: {
      'zh-Hant' => ['可能的數字組合只有 (9,9,9,7) 和 (9,9,8,8)。', '前者有 4 種排列，後者有 6 種排列。', '共 10 種。'],
      'zh-Hans' => ['可能的数字组合只有 (9,9,9,7) 和 (9,9,8,8)。', '前者有 4 种排列，后者有 6 种排列。', '共 10 种。'],
      'en' => ['The only digit multisets are (9,9,9,7) and (9,9,8,8).', 'These give 4 and 6 arrangements respectively.', 'So there are 10 in total.'],
      'ja' => ['ありうる数字の組は (9,9,9,7) と (9,9,8,8) だけです。', '並べ方はそれぞれ 4 通りと 6 通りです。', '合わせて 10 通りです。'],
    },
    options: choice_options(a: '8', b: '9', c: '10', d: '11'),
    correct: 'C',
    problem_number: '選擇 15',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade4_foundation_063',
    subtopic: 'arithmetic_sequence',
    prompt: {
      'zh-Hant' => '40759 → 40665 → ◆ → □，求 ◆×2−□ = ?',
      'zh-Hans' => '40759 → 40665 → ◆ → □，求 ◆×2−□ = ?',
      'en' => 'In the sequence 40759 → 40665 → ◆ → □, what is ◆×2−□?',
      'ja' => '40759 → 40665 → ◆ → □ のとき、◆×2−□ はいくつですか。',
    },
    answer: { 'zh-Hant' => '答案是 40665。', 'zh-Hans' => '答案是 40665。', 'en' => 'The answer is 40665.', 'ja' => '答えは 40665 です。' },
    steps: {
      'zh-Hant' => ['每次減少 94。', '所以 ◆=40571，□=40477。', '40571×2−40477 = 40665。'],
      'zh-Hans' => ['每次减少 94。', '所以 ◆=40571，□=40477。', '40571×2−40477 = 40665。'],
      'en' => ['Each step decreases by 94.', 'So ◆=40571 and □=40477.', 'Then 40571×2−40477 = 40665.'],
      'ja' => ['毎回 94 ずつ減ります。', 'したがって ◆=40571、□=40477 です。', '40571×2−40477 = 40665 です。'],
    },
    options: choice_options(a: '40665', b: '40744', c: '40653', d: '40477'),
    correct: 'A',
    problem_number: '選擇 16',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade4_foundation_064',
    subtopic: 'rectangle_area',
    prompt: {
      'zh-Hant' => '一個長方形，長邊剪去 8 公分後面積減少 64 平方公分；短邊剪去 5 公分後面積減少 50 平方公分。原來的面積是多少平方公分？',
      'zh-Hans' => '一个长方形，长边剪去 8 公分后面积减少 64 平方公分；短边剪去 5 公分后面积减少 50 平方公分。原来的面积是多少平方公分？',
      'en' => 'Cutting 8 cm off the long side of a rectangle reduces its area by 64 cm². Cutting 5 cm off the short side reduces its area by 50 cm². What was the original area?',
      'ja' => '長方形の長辺を 8 cm 切ると面積が 64 cm² 減り、短辺を 5 cm 切ると面積が 50 cm² 減ります。もとの面積はいくつですか。',
    },
    answer: { 'zh-Hant' => '答案是 144 平方公分。', 'zh-Hans' => '答案是 144 平方公分。', 'en' => 'The answer is 144 cm².', 'ja' => '答えは 144 cm² です。' },
    steps: {
      'zh-Hant' => ['64÷8 = 8，所以原來短邊是 8 公分。', '50÷5 = 10，所以原來長邊是 10+8 = 18 公分。', '面積是 18×8 = 144。'],
      'zh-Hans' => ['64÷8 = 8，所以原来短边是 8 公分。', '50÷5 = 10，所以原来长边是 10+8 = 18 公分。', '面积是 18×8 = 144。'],
      'en' => ['64÷8 = 8, so the original short side was 8 cm.', '50÷5 = 10, so the original long side was 10+8 = 18 cm.', 'The original area was 18×8 = 144.'],
      'ja' => ['64÷8 = 8 なので、もとの短辺は 8 cm です。', '50÷5 = 10 なので、もとの長辺は 10+8 = 18 cm です。', 'したがって面積は 18×8 = 144 です。'],
    },
    options: choice_options(a: '120', b: '124', c: '144', d: '148'),
    correct: 'C',
    problem_number: '選擇 17',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade4_foundation_065',
    subtopic: 'algebraic_reasoning',
    prompt: {
      'zh-Hant' => '甲、乙、丙共有 2019 元，甲比乙的 4 倍多 67 元，乙比丙的 4 倍多 67 元。甲和丙相差多少元？',
      'zh-Hans' => '甲、乙、丙共有 2019 元，甲比乙的 4 倍多 67 元，乙比丙的 4 倍多 67 元。甲和丙相差多少元？',
      'en' => 'A, B, and C have 2019 dollars in total. A has 67 more than 4 times B, and B has 67 more than 4 times C. What is the difference between A and C?',
      'ja' => '甲・乙・丙の合計は 2019 元で、甲は乙の4倍より67元多く、乙は丙の4倍より67元多いです。甲と丙の差はいくつですか。',
    },
    answer: { 'zh-Hant' => '答案是 1490 元。', 'zh-Hans' => '答案是 1490 元。', 'en' => 'The answer is 1490.', 'ja' => '答えは 1490 元です。' },
    steps: {
      'zh-Hant' => ['設丙為 x，則乙=4x+67，甲=16x+335。', '總和是 21x+402=2019，所以 x=77。', '甲=1567，丙=77，因此相差 1490。'],
      'zh-Hans' => ['设丙为 x，则乙=4x+67，甲=16x+335。', '总和是 21x+402=2019，所以 x=77。', '甲=1567，丙=77，因此相差 1490。'],
      'en' => ['Let C=x. Then B=4x+67 and A=16x+335.', 'Their sum gives 21x+402=2019, so x=77.', 'Thus A=1567 and C=77, and the difference is 1490.'],
      'ja' => ['丙を x とすると、乙=4x+67、甲=16x+335 です。', '合計より 21x+402=2019 なので x=77 です。', '甲=1567、丙=77 だから差は 1490 です。'],
    },
    options: choice_options(a: '1594', b: '1296', c: '1379', d: '1490'),
    correct: 'D',
    problem_number: '選擇 18',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade4_foundation_066',
    subtopic: 'work_allocation',
    prompt: {
      'zh-Hant' => '工人每天可做 6 件上衣或 8 件褲子。1 件上衣加 1 件褲子算 1 套服裝。現在有 84 名工人，每天最多可生產多少套？',
      'zh-Hans' => '工人每天可做 6 件上衣或 8 件裤子。1 件上衣加 1 件裤子算 1 套服装。现在有 84 名工人，每天最多可生产多少套？',
      'en' => 'A worker can make 6 shirts or 8 pants a day. One shirt and one pair of pants make one set. With 84 workers, what is the maximum number of sets made per day?',
      'ja' => '工員は1日に上着6枚またはズボン8本を作れます。上着1枚とズボン1本で1セットです。84人いるとき、1日に最大何セット作れますか。',
    },
    answer: { 'zh-Hant' => '答案是 288 套。', 'zh-Hans' => '答案是 288 套。', 'en' => 'The answer is 288 sets.', 'ja' => '答えは 288 セットです。' },
    steps: {
      'zh-Hant' => ['全做上衣相當於 84×6 = 504 件上衣的工作量。', '1 套需要 6+8 = 14 個工作量單位。', '504÷14 = 36，所以最多可做 36×8 = 288 套。'],
      'zh-Hans' => ['全做上衣相当于 84×6 = 504 件上衣的工作量。', '1 套需要 6+8 = 14 个工作量单位。', '504÷14 = 36，所以最多可做 36×8 = 288 套。'],
      'en' => ['All 84 workers making shirts gives 84×6 = 504 shirt-units of work.', 'One full set needs 6+8 = 14 such work units.', '504÷14 = 36, so the maximum is 36×8 = 288 sets.'],
      'ja' => ['全員が上着を作るとすると、仕事量は 84×6 = 504 です。', '1セット分には 6+8 = 14 の仕事量が必要です。', '504÷14 = 36 なので、最大は 36×8 = 288 セットです。'],
    },
    options: choice_options(a: '240', b: '256', c: '272', d: '288'),
    correct: 'D',
    problem_number: '選擇 19',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade4_foundation_067',
    subtopic: 'decimal_fraction_conversion',
    prompt: {
      'zh-Hant' => '98.72 = 90 + 8 + 7/10 + 1/□。缺少的數是多少？',
      'zh-Hans' => '98.72 = 90 + 8 + 7/10 + 1/□。缺少的数是多少？',
      'en' => '98.72 = 90 + 8 + 7/10 + 1/□. What number fills the box?',
      'ja' => '98.72 = 90 + 8 + 7/10 + 1/□ のとき、□は何ですか。',
    },
    answer: { 'zh-Hant' => '答案是 50。', 'zh-Hans' => '答案是 50。', 'en' => 'The answer is 50.', 'ja' => '答えは 50 です。' },
    steps: {
      'zh-Hant' => ['98.72 - 90 - 8.7 = 0.02。', '0.02 = 2/100 = 1/50。', '所以 □ = 50。'],
      'zh-Hans' => ['98.72 - 90 - 8.7 = 0.02。', '0.02 = 2/100 = 1/50。', '所以 □ = 50。'],
      'en' => ['98.72 - 90 - 8.7 = 0.02.', 'And 0.02 = 1/50.', 'So the box is 50.'],
      'ja' => ['98.72 - 90 - 8.7 = 0.02 です。', '0.02 は 1/50 です。', 'したがって □ = 50 です。'],
    },
    options: choice_options(a: '10', b: '30', c: '50', d: '100'),
    correct: 'C',
    problem_number: '選擇 20',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade4_foundation_068',
    subtopic: 'measurement_conversion',
    prompt: {
      'zh-Hant' => '甲=4.2 公升，乙=4 公升 2 分公升，丙=4 公升 200 毫公升。三者大小關係為何？',
      'zh-Hans' => '甲=4.2 公升，乙=4 公升 2 分公升，丙=4 公升 200 毫公升。三者大小关系为何？',
      'en' => 'Compare 4.2 L, 4 L 2 deciliters, and 4 L 200 milliliters.',
      'ja' => '4.2リットル、4リットル2デシリットル、4リットル200ミリリットルを比べるとどうなりますか。',
    },
    answer: { 'zh-Hant' => '答案是三者相等。', 'zh-Hans' => '答案是三者相等。', 'en' => 'All three are equal.', 'ja' => '3つとも等しいです。' },
    steps: {
      'zh-Hant' => ['4.2 公升 = 4200 毫公升。', '4 公升 2 分公升 = 4 公升 200 毫公升 = 4200 毫公升。', '所以甲=乙=丙。'],
      'zh-Hans' => ['4.2 公升 = 4200 毫公升。', '4 公升 2 分公升 = 4 公升 200 毫公升 = 4200 毫公升。', '所以甲=乙=丙。'],
      'en' => ['4.2 L = 4200 mL.', '4 L 2 dL = 4 L 200 mL = 4200 mL.', 'So all three are equal.'],
      'ja' => ['4.2 L は 4200 mL です。', '4 L 2 dL も 4 L 200 mL も 4200 mL です。', 'したがって3つとも等しいです。'],
    },
    options: choice_options(a: '甲>乙>丙', b: '乙>丙>甲', c: '丙>乙>甲', d: '甲=乙=丙'),
    correct: 'D',
    problem_number: '選擇 21',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade4_foundation_069',
    subtopic: 'linear_equation',
    prompt: {
      'zh-Hant' => '671×◆=■，且 2×◆+■=2019。求 ■−◆ = ?',
      'zh-Hans' => '671×◆=■，且 2×◆+■=2019。求 ■−◆ = ?',
      'en' => 'If 671×◆=■ and 2×◆+■=2019, what is ■−◆?',
      'ja' => '671×◆=■ かつ 2×◆+■=2019 のとき、■−◆ はいくつですか。',
    },
    answer: { 'zh-Hant' => '答案是 2010。', 'zh-Hans' => '答案是 2010。', 'en' => 'The answer is 2010.', 'ja' => '答えは 2010 です。' },
    steps: {
      'zh-Hant' => ['代入得 2×◆ + 671×◆ = 2019。', '673×◆ = 2019，所以 ◆ = 3。', '■ = 671×3 = 2013，因此 ■−◆ = 2010。'],
      'zh-Hans' => ['代入得 2×◆ + 671×◆ = 2019。', '673×◆ = 2019，所以 ◆ = 3。', '■ = 671×3 = 2013，因此 ■−◆ = 2010。'],
      'en' => ['Substitute to get 2×◆ + 671×◆ = 2019.', 'So 673×◆ = 2019 and ◆ = 3.', 'Then ■ = 2013, so ■−◆ = 2010.'],
      'ja' => ['代入すると 2×◆ + 671×◆ = 2019 です。', '673×◆ = 2019 なので ◆ = 3 です。', '■ = 2013 より、■−◆ = 2010 です。'],
    },
    options: choice_options(a: '2010', b: '2011', c: '2012', d: '2013'),
    correct: 'A',
    problem_number: '選擇 23',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade4_foundation_070',
    subtopic: 'angle_types',
    prompt: {
      'zh-Hant' => '1 個平角 + 1 個周角 − 1 個直角 = 45° × □，求 □ = ?',
      'zh-Hans' => '1 个平角 + 1 个周角 − 1 个直角 = 45° × □，求 □ = ?',
      'en' => 'If one straight angle plus one full angle minus one right angle equals 45°×□, what is □?',
      'ja' => '平角1つ + 周角1つ − 直角1つ = 45°×□ のとき、□はいくつですか。',
    },
    answer: { 'zh-Hant' => '答案是 10。', 'zh-Hans' => '答案是 10。', 'en' => 'The answer is 10.', 'ja' => '答えは 10 です。' },
    steps: {
      'zh-Hant' => ['平角是 180°，周角是 360°，直角是 90°。', '180 + 360 − 90 = 450。', '450 ÷ 45 = 10。'],
      'zh-Hans' => ['平角是 180°，周角是 360°，直角是 90°。', '180 + 360 − 90 = 450。', '450 ÷ 45 = 10。'],
      'en' => ['A straight angle is 180°, a full angle is 360°, and a right angle is 90°.', 'So 180 + 360 − 90 = 450.', 'Then 450 ÷ 45 = 10.'],
      'ja' => ['平角は180°、周角は360°、直角は90°です。', 'したがって 180 + 360 − 90 = 450 です。', '450 ÷ 45 = 10 です。'],
    },
    options: choice_options(a: '13', b: '11', c: '14', d: '10'),
    correct: 'D',
    problem_number: '選擇 24',
    notes: 'Imported from the official PDF without figure dependency. The official key line appears inconsistent in the OCR, but the worked solution gives 10.',
  ),
  choice_question(
    id: 'arithmetic_grade4_foundation_071',
    subtopic: 'custom_operator',
    prompt: {
      'zh-Hant' => '定義 4ρ5 = 4×5−5 = 15，7ρ3 = 7×3−3 = 18。若 45ρA = 220，則 A+7 = ?',
      'zh-Hans' => '定义 4ρ5 = 4×5−5 = 15，7ρ3 = 7×3−3 = 18。若 45ρA = 220，则 A+7 = ?',
      'en' => 'Define 4ρ5 = 4×5−5 = 15 and 7ρ3 = 7×3−3 = 18. If 45ρA = 220, what is A+7?',
      'ja' => '4ρ5 = 4×5−5 = 15、7ρ3 = 7×3−3 = 18 と定義します。45ρA = 220 のとき、A+7 はいくつですか。',
    },
    answer: { 'zh-Hant' => '答案是 12。', 'zh-Hans' => '答案是 12。', 'en' => 'The answer is 12.', 'ja' => '答えは 12 です。' },
    steps: {
      'zh-Hant' => ['依規則可得 45×A−A = 220。', '所以 44A = 220，A = 5。', '因此 A+7 = 12。'],
      'zh-Hans' => ['依规则可得 45×A−A = 220。', '所以 44A = 220，A = 5。', '因此 A+7 = 12。'],
      'en' => ['By the rule, 45×A−A = 220.', 'So 44A = 220 and A = 5.', 'Thus A+7 = 12.'],
      'ja' => ['規則より 45×A−A = 220 です。', 'したがって 44A = 220、A = 5 です。', 'よって A+7 = 12 です。'],
    },
    options: choice_options(a: '11', b: '12', c: '13', d: '14'),
    correct: 'B',
    problem_number: '選擇 25',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
]

existing_ids = data.fetch('questions').map { |question| question.fetch('id') }
duplicates = questions.map { |question| question['id'] } & existing_ids
raise "Duplicate ids: #{duplicates.join(', ')}" unless duplicates.empty?

data['questions'].concat(questions)

manifest.fetch('packs').each do |pack|
  next unless pack['path'] == 'assets/questions/arithmetic/grade4_foundation.arithmetic.v1.json'

  pack['questionCount'] = data['questions'].length
end

save_json(ARITHMETIC_PATH, data)
save_json(MANIFEST_PATH, manifest)
