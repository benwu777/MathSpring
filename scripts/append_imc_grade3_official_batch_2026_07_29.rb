#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'

ROOT = File.expand_path('..', __dir__)
ARITHMETIC_PATH = File.join(ROOT, 'assets/questions/arithmetic/grade3_foundation.arithmetic.v1.json')
LOGIC_PATH = File.join(ROOT, 'assets/questions/logic/grade3_foundation.logic.v1.json')
MANIFEST_PATH = File.join(ROOT, 'assets/questions/manifest.json')
SOURCE_URL = 'https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD3%E5%B9%B4%E7%B4%9A0830.pdf'

def load_json(path)
  JSON.parse(File.read(path))
end

def save_json(path, data)
  File.write(path, JSON.pretty_generate(data) + "\n")
end

def official_source(problem_number, notes)
  {
    'type' => 'official_reference',
    'name' => 'IMC',
    'contest' => '第16屆IMC國際數學競賽台灣區初賽',
    'year' => '2015',
    'division' => '國小三年級',
    'problemNumber' => problem_number,
    'displayText' => "第16屆IMC台灣區初賽國小三年級 #{problem_number}",
    'sourceUrl' => SOURCE_URL,
    'rightsStatus' => 'needs_review',
    'notes' => notes,
  }
end

def figure_none
  { 'type' => 'custom', 'kind' => 'none', 'params' => {} }
end

def number_options(a:, b:, c:, d:)
  {
    'A' => { 'zh-Hant' => a, 'zh-Hans' => a, 'en' => a, 'ja' => a },
    'B' => { 'zh-Hant' => b, 'zh-Hans' => b, 'en' => b, 'ja' => b },
    'C' => { 'zh-Hant' => c, 'zh-Hans' => c, 'en' => c, 'ja' => c },
    'D' => { 'zh-Hant' => d, 'zh-Hans' => d, 'en' => d, 'ja' => d },
  }
end

def choice_question(id:, topic:, subtopic:, prompt:, answer:, steps:, options:, correct:, problem_number:, notes:)
  {
    'id' => id,
    'topic' => topic,
    'subtopic' => subtopic,
    'difficulty' => 'foundation',
    'levelStage' => 'grade3',
    'challengeTier' => 'foundation',
    'prompt' => prompt,
    'answer' => answer,
    'solutionSteps' => steps,
    'figure' => figure_none,
    'answerMode' => 'multiple_choice',
    'options' => options,
    'correctAnswer' => { 'type' => 'choice', 'value' => correct },
    'source' => official_source(problem_number, notes),
  }
end

def integer_question(id:, subtopic:, prompt:, answer:, steps:, value:, max_digits:, problem_number:, notes:)
  {
    'id' => id,
    'topic' => 'arithmetic',
    'subtopic' => subtopic,
    'difficulty' => 'foundation',
    'levelStage' => 'grade3',
    'challengeTier' => 'foundation',
    'prompt' => prompt,
    'answer' => answer,
    'solutionSteps' => steps,
    'figure' => figure_none,
    'answerMode' => 'integer_input',
    'correctAnswer' => { 'type' => 'integer', 'value' => value },
    'inputConstraints' => { 'allowNegative' => false, 'maxDigits' => max_digits },
    'source' => official_source(problem_number, notes),
  }
end

arithmetic = load_json(ARITHMETIC_PATH)
logic = load_json(LOGIC_PATH)
manifest = load_json(MANIFEST_PATH)

new_arithmetic_questions = [
  choice_question(
    id: 'arithmetic_grade3_foundation_054',
    topic: 'arithmetic',
    subtopic: 'symbol_equation',
    prompt: {
      'zh-Hant' => '★ + ★ = ◎，且 ★×◎ = 98。請問 ◎ − ★ = ?',
      'zh-Hans' => '★ + ★ = ◎，且 ★×◎ = 98。请问 ◎ − ★ = ?',
      'en' => 'If ★ + ★ = ◎ and ★×◎ = 98, what is ◎ − ★?',
      'ja' => '★ + ★ = ◎ で、★×◎ = 98 のとき、◎ − ★ はいくつですか。',
    },
    answer: {
      'zh-Hant' => '答案是 7。',
      'zh-Hans' => '答案是 7。',
      'en' => 'The answer is 7.',
      'ja' => '答えは 7 です。',
    },
    steps: {
      'zh-Hant' => ['因為 ◎ = 2×★，所以 ★×2×★ = 98。', '可得 ★ = 7，◎ = 14。', '因此 ◎ − ★ = 14 − 7 = 7。'],
      'zh-Hans' => ['因为 ◎ = 2×★，所以 ★×2×★ = 98。', '可得 ★ = 7，◎ = 14。', '因此 ◎ − ★ = 14 − 7 = 7。'],
      'en' => ['Since ◎ = 2×★, we get ★×2×★ = 98.', 'So ★ = 7 and ◎ = 14.', 'Therefore ◎ − ★ = 14 − 7 = 7.'],
      'ja' => ['◎ = 2×★ なので、★×2×★ = 98 です。', 'ここから ★ = 7、◎ = 14 と分かります。', 'したがって ◎ − ★ = 14 − 7 = 7 です。'],
    },
    options: number_options(a: '6', b: '7', c: '8', d: '9'),
    correct: 'B',
    problem_number: '選擇 1',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade3_foundation_055',
    topic: 'arithmetic',
    subtopic: 'calendar_counting',
    prompt: {
      'zh-Hant' => '小萍 2019 年去參加 3 天 2 夜露營活動，回家後，她將這三天的日曆撕下來，並把這 3 天日曆上的日數相加，和數剛好等於 31。請問她是幾月幾日回家的？',
      'zh-Hans' => '小萍 2019 年去参加 3 天 2 夜露营活动，回家后，她将这三天的日历撕下来，并把这 3 天日历上的日数相加，和数刚好等于 31。请问她是几月几日回家的？',
      'en' => 'In 2019, Xiaoping went on a 3-day, 2-night camp. After returning home, she added the dates on the three calendar pages for those days and got 31. On what date did she return home?',
      'ja' => '2019年、シャオピンさんは2泊3日のキャンプに行きました。帰宅後、その3日分のカレンダーの日付を足すと31になりました。帰ってきたのは何月何日ですか。',
    },
    answer: {
      'zh-Hant' => '答案是 3 月 2 日。',
      'zh-Hans' => '答案是 3 月 2 日。',
      'en' => 'The answer is March 2.',
      'ja' => '答えは 3月2日 です。',
    },
    steps: {
      'zh-Hant' => ['連續三天如果都在同一個月，和會是連續三數之和，不會等於 31。', '要考慮跨月，符合條件的是 28、1、2。', '2019 年是平年，2 月有 28 天，所以回家日期是 3 月 2 日。'],
      'zh-Hans' => ['连续三天如果都在同一个月，和会是连续三数之和，不会等于 31。', '要考虑跨月，符合条件的是 28、1、2。', '2019 年是平年，2 月有 28 天，所以回家日期是 3 月 2 日。'],
      'en' => ['If the three days stayed in one month, the sum would be the sum of three consecutive integers and would not be 31.', 'So the dates must cross a month boundary. The fitting set is 28, 1, and 2.', 'Since 2019 is not a leap year, February has 28 days, so she returned on March 2.'],
      'ja' => ['同じ月の連続する3日なら、和は連続する3整数の和になり、31にはなりません。', 'したがって月またぎを考えます。条件に合うのは 28、1、2 です。', '2019年はうるう年ではないので2月は28日まであり、帰宅日は3月2日です。'],
    },
    options: number_options(a: '3 月 2 日', b: '2 月 15 日', c: '4 月 13 日', d: '5 月 6 日'),
    correct: 'A',
    problem_number: '選擇 2',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade3_foundation_056',
    topic: 'arithmetic',
    subtopic: 'equation_reasoning',
    prompt: {
      'zh-Hant' => 'A 和 B 都是 1 到 9 的數字，且滿足 (A+B)÷B = 4。請問 A×B 不可能是哪一個？',
      'zh-Hans' => 'A 和 B 都是 1 到 9 的数字，且满足 (A+B)÷B = 4。请问 A×B 不可能是哪一个？',
      'en' => 'A and B are digits from 1 to 9 and satisfy (A+B)÷B = 4. Which value cannot be A×B?',
      'ja' => 'A と B は 1 から 9 までの数字で、(A+B)÷B = 4 を満たします。A×B にならないものはどれですか。',
    },
    answer: {
      'zh-Hant' => '答案是 36。',
      'zh-Hans' => '答案是 36。',
      'en' => 'The answer is 36.',
      'ja' => '答えは 36 です。',
    },
    steps: {
      'zh-Hant' => ['由 (A+B)÷B = 4 可得 A + B = 4B，所以 A = 3B。', '因為 A 仍要是 1 到 9 的數字，所以 (A,B) 只可能是 (3,1)、(6,2)、(9,3)。', '因此 A×B 只會是 3、12、27，不可能是 36。'],
      'zh-Hans' => ['由 (A+B)÷B = 4 可得 A + B = 4B，所以 A = 3B。', '因为 A 仍要是 1 到 9 的数字，所以 (A,B) 只可能是 (3,1)、(6,2)、(9,3)。', '因此 A×B 只会是 3、12、27，不可能是 36。'],
      'en' => ['From (A+B)÷B = 4, we get A + B = 4B, so A = 3B.', 'Since A must still be a digit, the only pairs are (3,1), (6,2), and (9,3).', 'So A×B can be 3, 12, or 27, but not 36.'],
      'ja' => ['(A+B)÷B = 4 から A + B = 4B、つまり A = 3B です。', 'A も1から9の数字なので、(A,B) は (3,1)、(6,2)、(9,3) だけです。', 'したがって A×B は 3、12、27 のみで、36 にはなりません。'],
    },
    options: number_options(a: '3', b: '12', c: '27', d: '36'),
    correct: 'D',
    problem_number: '選擇 4',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade3_foundation_057',
    topic: 'arithmetic',
    subtopic: 'money_savings',
    prompt: {
      'zh-Hant' => '一支冰淇淋賣 35 元，一瓶可樂比一支冰淇淋少 12 元。促銷期間兩種商品合賣 50 元。如果在促銷期間購買這兩種商品，可以省下多少元？',
      'zh-Hans' => '一支冰淇淋卖 35 元，一瓶可乐比一支冰淇淋少 12 元。促销期间两种商品合卖 50 元。如果在促销期间购买这两种商品，可以省下多少元？',
      'en' => 'An ice cream costs 35 dollars. A bottle of cola costs 12 dollars less than the ice cream. During a sale, the two together cost 50 dollars. How much is saved?',
      'ja' => 'アイスクリームは35元、コーラはそれより12元安いです。セールではこの2つで50元です。何元節約できますか。',
    },
    answer: {
      'zh-Hant' => '答案是 8 元。',
      'zh-Hans' => '答案是 8 元。',
      'en' => 'The answer is 8.',
      'ja' => '答えは 8 元です。',
    },
    steps: {
      'zh-Hant' => ['可樂原價是 35 − 12 = 23 元。', '兩樣原價合計 35 + 23 = 58 元。', '促銷價是 50 元，所以省下 58 − 50 = 8 元。'],
      'zh-Hans' => ['可乐原价是 35 − 12 = 23 元。', '两样原价合计 35 + 23 = 58 元。', '促销价是 50 元，所以省下 58 − 50 = 8 元。'],
      'en' => ['The cola costs 35 − 12 = 23.', 'The regular total is 35 + 23 = 58.', 'So the saving is 58 − 50 = 8.'],
      'ja' => ['コーラの元の値段は 35 − 12 = 23 元です。', 'もとの合計は 35 + 23 = 58 元です。', 'したがって節約できるのは 58 − 50 = 8 元です。'],
    },
    options: number_options(a: '$3', b: '$5', c: '$8', d: '$10'),
    correct: 'C',
    problem_number: '選擇 5',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade3_foundation_058',
    topic: 'arithmetic',
    subtopic: 'time_reasoning',
    prompt: {
      'zh-Hant' => '時鐘上分針指著數字 A，時針在數字 B 和數字 C 之間，且 A = B + C。下列哪一個時間不可能發生？',
      'zh-Hans' => '时钟上分针指着数字 A，时针在数字 B 和数字 C 之间，且 A = B + C。下列哪一个时间不可能发生？',
      'en' => 'On a clock, the minute hand points to A, the hour hand lies between B and C, and A = B + C. Which time is impossible?',
      'ja' => '時計で、分針が A を指し、時針が B と C の間にあり、A = B + C を満たします。次のうち起こりえない時刻はどれですか。',
    },
    answer: {
      'zh-Hant' => '答案是 2 時 15 分。',
      'zh-Hans' => '答案是 2 时 15 分。',
      'en' => 'The answer is 2:15.',
      'ja' => '答えは 2時15分 です。',
    },
    steps: {
      'zh-Hant' => ['5:55 時，A=11，B 和 C 是 5、6，符合 11=5+6。', '4:45 時，A=9，符合 9=4+5；3:35 時，A=7，符合 7=3+4。', '2:15 時，A=3，但時針其實在 2 和 3 之間，應對應 2:25 才會有 5=2+3，所以 2:15 不可能。'],
      'zh-Hans' => ['5:55 时，A=11，B 和 C 是 5、6，符合 11=5+6。', '4:45 时，A=9，符合 9=4+5；3:35 时，A=7，符合 7=3+4。', '2:15 时，A=3，但时针其实在 2 和 3 之间，应对应 2:25 才会有 5=2+3，所以 2:15 不可能。'],
      'en' => ['At 5:55, A=11 and the hour hand is between 5 and 6, so 11=5+6 works.', 'At 4:45 and 3:35, the same check works.', 'For 2:15, A=3 but the hour-hand neighbors are 2 and 3, whose sum is 5, so it does not fit.'],
      'ja' => ['5時55分では A=11、時針は5と6の間なので 11=5+6 で成り立ちます。', '4時45分と3時35分も同様に成り立ちます。', '2時15分では A=3 ですが、時針は2と3の間で 2+3=5 なので条件に合いません。'],
    },
    options: number_options(a: '5 時 55 分', b: '4 時 45 分', c: '3 時 35 分', d: '2 時 15 分'),
    correct: 'D',
    problem_number: '選擇 6',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade3_foundation_059',
    topic: 'arithmetic',
    subtopic: 'measurement_conversion',
    prompt: {
      'zh-Hant' => '爸爸用 4 公尺的繩子測量柱子的周圍長。繞了柱子 2 圈後，繩子還多出 30 公分。請問柱子的周圍長是多少公分？',
      'zh-Hans' => '爸爸用 4 公尺的绳子测量柱子的周围长。绕了柱子 2 圈后，绳子还多出 30 公分。请问柱子的周围长是多少公分？',
      'en' => 'A father uses a 4-meter rope to measure a pillar\'s circumference. After wrapping it around the pillar twice, 30 cm is left over. What is the pillar\'s circumference in centimeters?',
      'ja' => 'お父さんは4メートルのひもで柱の周りの長さを測りました。柱を2周すると30センチ余りました。柱の周りの長さは何センチですか。',
    },
    answer: {
      'zh-Hant' => '答案是 185 公分。',
      'zh-Hans' => '答案是 185 公分。',
      'en' => 'The answer is 185 cm.',
      'ja' => '答えは 185 cm です。',
    },
    steps: {
      'zh-Hant' => ['4 公尺 = 400 公分。', '繞兩圈後還剩 30 公分，表示兩圈共長 400 − 30 = 370 公分。', '一圈是 370 ÷ 2 = 185 公分。'],
      'zh-Hans' => ['4 公尺 = 400 公分。', '绕两圈后还剩 30 公分，表示两圈共长 400 − 30 = 370 公分。', '一圈是 370 ÷ 2 = 185 公分。'],
      'en' => ['4 meters is 400 cm.', 'Two wraps use 400 − 30 = 370 cm of rope.', 'So one wrap is 370 ÷ 2 = 185 cm.'],
      'ja' => ['4メートルは 400 cm です。', '2周して 30 cm 余るので、2周分は 400 − 30 = 370 cm です。', '1周分は 370 ÷ 2 = 185 cm です。'],
    },
    options: number_options(a: '180 公分', b: '185 公分', c: '190 公分', d: '195 公分'),
    correct: 'B',
    problem_number: '選擇 9',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade3_foundation_060',
    topic: 'arithmetic',
    subtopic: 'difference_invariance',
    prompt: {
      'zh-Hant' => '兩個數的差是 199。把較小的數加上 50，再把較大的數減去 50，新的差是多少？',
      'zh-Hans' => '两个数的差是 199。把较小的数加上 50，再把较大的数减去 50，新的差是多少？',
      'en' => 'The difference between two numbers is 199. Add 50 to the smaller number and subtract 50 from the greater number. What is the new difference?',
      'ja' => '2つの数の差は199です。小さい数に50を足し、大きい数から50を引くと、新しい差はいくつですか。',
    },
    answer: {
      'zh-Hant' => '答案是 99。',
      'zh-Hans' => '答案是 99。',
      'en' => 'The answer is 99.',
      'ja' => '答えは 99 です。',
    },
    steps: {
      'zh-Hant' => ['較小的數加 50，兩數差會少 50。', '較大的數再減 50，兩數差又再少 50。', '所以新差是 199 − 50 − 50 = 99。'],
      'zh-Hans' => ['较小的数加 50，两数差会少 50。', '较大的数再减 50，两数差又再少 50。', '所以新差是 199 − 50 − 50 = 99。'],
      'en' => ['Adding 50 to the smaller number reduces the difference by 50.', 'Subtracting 50 from the larger number reduces it by another 50.', 'So the new difference is 199 − 50 − 50 = 99.'],
      'ja' => ['小さい数に50を足すと差は50小さくなります。', 'さらに大きい数から50を引くと、差はもう50小さくなります。', 'したがって新しい差は 199 − 50 − 50 = 99 です。'],
    },
    options: number_options(a: '299', b: '199', c: '99', d: '9'),
    correct: 'C',
    problem_number: '選擇 10',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade3_foundation_061',
    topic: 'arithmetic',
    subtopic: 'calendar_counting',
    prompt: {
      'zh-Hant' => '元元今年 3 月 7 日到新加坡出差，預計 12 週後回台灣。她回到台灣的日期是幾月幾日？',
      'zh-Hans' => '元元今年 3 月 7 日到新加坡出差，预计 12 周后回台湾。她回到台湾的日期是几月几日？',
      'en' => 'Yuanyuan leaves for Singapore on March 7 this year and plans to return to Taiwan 12 weeks later. On what date does she return?',
      'ja' => 'ユエンユエンさんは今年の3月7日にシンガポールへ行き、12週間後に台湾へ戻る予定です。帰国日は何月何日ですか。',
    },
    answer: {
      'zh-Hant' => '答案是 5 月 30 日。',
      'zh-Hans' => '答案是 5 月 30 日。',
      'en' => 'The answer is May 30.',
      'ja' => '答えは 5月30日 です。',
    },
    steps: {
      'zh-Hant' => ['12 週 = 12×7 = 84 天。', '3 月 7 日到 3 月底還有 24 天。', '84 − 24 = 60，再扣掉 4 月的 30 天後，還剩 30 天，所以日期是 5 月 30 日。'],
      'zh-Hans' => ['12 周 = 12×7 = 84 天。', '3 月 7 日到 3 月底还有 24 天。', '84 − 24 = 60，再扣掉 4 月的 30 天后，还剩 30 天，所以日期是 5 月 30 日。'],
      'en' => ['12 weeks equals 84 days.', 'There are 24 days from March 7 to the end of March.', 'After removing those 24 days and all 30 days of April, 30 days remain, so the return date is May 30.'],
      'ja' => ['12週間は 84日 です。', '3月7日から3月末までは24日あります。', '84日から24日と4月の30日を引くと30日残るので、帰国日は5月30日です。'],
    },
    options: number_options(a: '5 月 30 日', b: '5 月 29 日', c: '6 月 1 日', d: '5 月 28 日'),
    correct: 'A',
    problem_number: '選擇 11',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade3_foundation_062',
    topic: 'arithmetic',
    subtopic: 'optimization',
    prompt: {
      'zh-Hant' => '6×A + B = 100，A 和 B 都是大於 0 的整數。A+B 的最小值是多少？',
      'zh-Hans' => '6×A + B = 100，A 和 B 都是大于 0 的整数。A+B 的最小值是多少？',
      'en' => 'If 6×A + B = 100 and A and B are positive integers, what is the minimum value of A+B?',
      'ja' => '6×A + B = 100 で、A と B はどちらも正の整数です。A+B の最小値はいくつですか。',
    },
    answer: {
      'zh-Hant' => '答案是 20。',
      'zh-Hans' => '答案是 20。',
      'en' => 'The answer is 20.',
      'ja' => '答えは 20 です。',
    },
    steps: {
      'zh-Hant' => ['要讓 A+B 最小，就讓 6×A 盡量接近 100，讓 B 盡量小。', '100 附近最大的 6 的倍數是 96 = 6×16。', '這時 B = 4，所以 A+B = 16+4 = 20。'],
      'zh-Hans' => ['要让 A+B 最小，就让 6×A 尽量接近 100，让 B 尽量小。', '100 附近最大的 6 的倍数是 96 = 6×16。', '这时 B = 4，所以 A+B = 16+4 = 20。'],
      'en' => ['To minimize A+B, make 6×A as close to 100 as possible so B is small.', 'The largest multiple of 6 below 100 is 96 = 6×16.', 'Then B = 4, so A+B = 16+4 = 20.'],
      'ja' => ['A+B を最小にするには、6×A を100にできるだけ近づけて B を小さくします。', '100以下で最大の6の倍数は 96 = 6×16 です。', 'このとき B = 4 なので、A+B = 16+4 = 20 です。'],
    },
    options: number_options(a: '18', b: '20', c: '22', d: '24'),
    correct: 'B',
    problem_number: '選擇 12',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade3_foundation_063',
    topic: 'arithmetic',
    subtopic: 'digit_sum_counting',
    prompt: {
      'zh-Hant' => '三位數的各位數字和是 24，符合條件的三位數共有幾個？',
      'zh-Hans' => '三位数的各位数字和是 24，符合条件的三位数共有几个？',
      'en' => 'How many three-digit numbers have a digit sum of 24?',
      'ja' => '各けたの数字の和が24になる3けたの数は全部でいくつありますか。',
    },
    answer: {
      'zh-Hant' => '答案是 10 個。',
      'zh-Hans' => '答案是 10 个。',
      'en' => 'The answer is 10.',
      'ja' => '答えは 10 個です。',
    },
    steps: {
      'zh-Hant' => ['可能的數字組合只有 (9,9,6)、(9,8,7)、(8,8,8)。', '前兩組要考慮排列，分別有 3 個和 6 個；(8,8,8) 只有 1 個。', '所以總共有 3 + 6 + 1 = 10 個。'],
      'zh-Hans' => ['可能的数字组合只有 (9,9,6)、(9,8,7)、(8,8,8)。', '前两组要考虑排列，分别有 3 个和 6 个；(8,8,8) 只有 1 个。', '所以总共有 3 + 6 + 1 = 10 个。'],
      'en' => ['The only digit multisets are (9,9,6), (9,8,7), and (8,8,8).', 'These give 3, 6, and 1 arrangements respectively.', 'So the total is 3 + 6 + 1 = 10.'],
      'ja' => ['ありうる数字の組は (9,9,6)、(9,8,7)、(8,8,8) だけです。', '並べ方はそれぞれ 3通り、6通り、1通りです。', 'したがって合計は 3 + 6 + 1 = 10 通りです。'],
    },
    options: number_options(a: '8', b: '9', c: '10', d: '11'),
    correct: 'C',
    problem_number: '選擇 15',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade3_foundation_064',
    topic: 'arithmetic',
    subtopic: 'place_value',
    prompt: {
      'zh-Hant' => '6 個千、28 個百、29 個十和 30 個一，合起來是多少？',
      'zh-Hans' => '6 个千、28 个百、29 个十和 30 个一，合起来是多少？',
      'en' => 'What number is made from 6 thousands, 28 hundreds, 29 tens, and 30 ones?',
      'ja' => '6個の千、28個の百、29個の十、30個の一を合わせるといくつですか。',
    },
    answer: {
      'zh-Hant' => '答案是 9120。',
      'zh-Hans' => '答案是 9120。',
      'en' => 'The answer is 9120.',
      'ja' => '答えは 9120 です。',
    },
    steps: {
      'zh-Hant' => ['6 個千是 6000。', '28 個百是 2800，29 個十是 290，30 個一是 30。', '全部相加：6000 + 2800 + 290 + 30 = 9120。'],
      'zh-Hans' => ['6 个千是 6000。', '28 个百是 2800，29 个十是 290，30 个一是 30。', '全部相加：6000 + 2800 + 290 + 30 = 9120。'],
      'en' => ['6 thousands is 6000.', '28 hundreds is 2800, 29 tens is 290, and 30 ones is 30.', 'Adding them gives 6000 + 2800 + 290 + 30 = 9120.'],
      'ja' => ['6個の千は 6000 です。', '28個の百は 2800、29個の十は 290、30個の一は 30 です。', '全部足すと 6000 + 2800 + 290 + 30 = 9120 です。'],
    },
    options: number_options(a: '8920', b: '9020', c: '9120', d: '9220'),
    correct: 'C',
    problem_number: '選擇 16',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade3_foundation_065',
    topic: 'arithmetic',
    subtopic: 'remainder_to_fill',
    prompt: {
      'zh-Hant' => '倉庫有 425 顆蘋果，每 12 顆裝成一箱，最後一箱還差多少顆蘋果才能裝滿？',
      'zh-Hans' => '仓库有 425 颗苹果，每 12 颗装成一箱，最后一箱还差多少颗苹果才能装满？',
      'en' => 'A warehouse has 425 apples. They are packed 12 per box. How many more apples are needed to fill the last box?',
      'ja' => '倉庫にりんごが425個あります。1箱に12個ずつ入れます。最後の箱をいっぱいにするには、あと何個必要ですか。',
    },
    answer: {
      'zh-Hant' => '答案是 7 顆。',
      'zh-Hans' => '答案是 7 颗。',
      'en' => 'The answer is 7.',
      'ja' => '答えは 7 個です。',
    },
    steps: {
      'zh-Hant' => ['12×35 = 420，所以裝滿 35 箱後還剩 5 顆。', '一箱要 12 顆，還差 12 − 5 = 7 顆。'],
      'zh-Hans' => ['12×35 = 420，所以装满 35 箱后还剩 5 颗。', '一箱要 12 颗，还差 12 − 5 = 7 颗。'],
      'en' => ['12×35 = 420, so 5 apples remain after filling full boxes.', 'Since a box needs 12 apples, the last box needs 12 − 5 = 7 more apples.'],
      'ja' => ['12×35 = 420 なので、満箱にしたあと 5 個余ります。', '1箱は12個必要なので、最後の箱には 12 − 5 = 7 個足りません。'],
    },
    options: number_options(a: '5 顆', b: '6 顆', c: '7 顆', d: '8 顆'),
    correct: 'C',
    problem_number: '選擇 17',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade3_foundation_066',
    topic: 'arithmetic',
    subtopic: 'division_with_remainder',
    prompt: {
      'zh-Hant' => 'A、B、C 是正整數，且 A÷7 = B …… C，並且 A+B+C = 10。請問 A×C = ?',
      'zh-Hans' => 'A、B、C 是正整数，且 A÷7 = B …… C，并且 A+B+C = 10。请问 A×C = ?',
      'en' => 'A, B, and C are positive integers. If A÷7 = B remainder C and A+B+C = 10, what is A×C?',
      'ja' => 'A、B、C は正の整数です。A÷7 = B あまり C で、A+B+C = 10 のとき、A×C はいくつですか。',
    },
    answer: {
      'zh-Hant' => '答案是 8。',
      'zh-Hans' => '答案是 8。',
      'en' => 'The answer is 8.',
      'ja' => '答えは 8 です。',
    },
    steps: {
      'zh-Hant' => ['A = 7B + C，而且餘數 C 至少是 1。', '代入 A+B+C = 10，可得 8B + 2C = 10，也就是 4B + C = 5。', '正整數解只有 B=1、C=1，所以 A=8，因此 A×C = 8×1 = 8。'],
      'zh-Hans' => ['A = 7B + C，而且余数 C 至少是 1。', '代入 A+B+C = 10，可得 8B + 2C = 10，也就是 4B + C = 5。', '正整数解只有 B=1、C=1，所以 A=8，因此 A×C = 8×1 = 8。'],
      'en' => ['We have A = 7B + C, and the remainder C is at least 1.', 'Substituting into A+B+C = 10 gives 8B + 2C = 10, or 4B + C = 5.', 'The only positive integer solution is B=1 and C=1, so A=8 and A×C = 8.'],
      'ja' => ['A = 7B + C で、あまり C は少なくとも1です。', 'これを A+B+C = 10 に代入すると 8B + 2C = 10、つまり 4B + C = 5 です。', '正の整数解は B=1、C=1 だけなので、A=8、したがって A×C = 8 です。'],
    },
    options: number_options(a: '5', b: '6', c: '7', d: '8'),
    correct: 'D',
    problem_number: '選擇 18',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade3_foundation_067',
    topic: 'arithmetic',
    subtopic: 'arithmetic_sequence',
    prompt: {
      'zh-Hant' => '659→665→◆→□，求 ◆×2 + □ = ?',
      'zh-Hans' => '659→665→◆→□，求 ◆×2 + □ = ?',
      'en' => 'In the sequence 659→665→◆→□, what is ◆×2 + □?',
      'ja' => '659→665→◆→□ という並びで、◆×2 + □ はいくつですか。',
    },
    answer: {
      'zh-Hant' => '答案是 2019。',
      'zh-Hans' => '答案是 2019。',
      'en' => 'The answer is 2019.',
      'ja' => '答えは 2019 です。',
    },
    steps: {
      'zh-Hant' => ['659 到 665 增加 6，所以後面每一步也加 6。', '因此 ◆ = 671，□ = 677。', '所以 ◆×2 + □ = 671×2 + 677 = 2019。'],
      'zh-Hans' => ['659 到 665 增加 6，所以后面每一步也加 6。', '因此 ◆ = 671，□ = 677。', '所以 ◆×2 + □ = 671×2 + 677 = 2019。'],
      'en' => ['The increase from 659 to 665 is 6, so each next step adds 6.', 'Thus ◆ = 671 and □ = 677.', 'Then ◆×2 + □ = 671×2 + 677 = 2019.'],
      'ja' => ['659から665へは6増えています。したがって以後も6ずつ増えます。', 'だから ◆ = 671、□ = 677 です。', 'よって ◆×2 + □ = 671×2 + 677 = 2019 です。'],
    },
    options: number_options(a: '2018', b: '2019', c: '2020', d: '2021'),
    correct: 'B',
    problem_number: '選擇 19',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade3_foundation_068',
    topic: 'arithmetic',
    subtopic: 'discount_rate',
    prompt: {
      'zh-Hant' => '快樂綠茶店促銷：買綠茶 5 杯就送 1 杯。張叔叔拿到 15 杯綠茶，共花 260 元。請問一杯綠茶原價多少元？',
      'zh-Hans' => '快乐绿茶店促销：买绿茶 5 杯就送 1 杯。张叔叔拿到 15 杯绿茶，共花 260 元。请问一杯绿茶原价多少元？',
      'en' => 'A tea shop offers one free green tea for every 5 bought. Uncle Zhang receives 15 cups in total and pays 260 dollars. What is the original price of one cup?',
      'ja' => 'お茶屋さんでは、緑茶を5杯買うと1杯無料でもらえます。張おじさんは合計15杯受け取り、260元払いました。1杯の定価はいくらですか。',
    },
    answer: {
      'zh-Hant' => '答案是 20 元。',
      'zh-Hans' => '答案是 20 元。',
      'en' => 'The answer is 20.',
      'ja' => '答えは 20 元です。',
    },
    steps: {
      'zh-Hant' => ['15 杯中，每 5 杯送 1 杯，所以有 2 杯是送的。', '實際付費杯數是 15 − 2 = 13 杯。', '260 ÷ 13 = 20，所以原價是 20 元。'],
      'zh-Hans' => ['15 杯中，每 5 杯送 1 杯，所以有 2 杯是送的。', '实际付费杯数是 15 − 2 = 13 杯。', '260 ÷ 13 = 20，所以原价是 20 元。'],
      'en' => ['Among 15 cups, 2 are free under the promotion.', 'So he paid for 15 − 2 = 13 cups.', '260 ÷ 13 = 20, so the original price is 20.'],
      'ja' => ['15杯のうち、特典でもらった無料分は2杯です。', 'したがって支払ったのは 15 − 2 = 13 杯分です。', '260 ÷ 13 = 20 なので、定価は20元です。'],
    },
    options: number_options(a: '18 元', b: '20 元', c: '22 元', d: '16 元'),
    correct: 'B',
    problem_number: '選擇 21',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade3_foundation_069',
    topic: 'arithmetic',
    subtopic: 'integer_counting',
    prompt: {
      'zh-Hant' => '從 103 數到 179，共有多少個整數？',
      'zh-Hans' => '从 103 数到 179，共有多少个整数？',
      'en' => 'How many integers are there from 103 to 179 inclusive?',
      'ja' => '103から179までの整数は全部で何個ありますか。',
    },
    answer: {
      'zh-Hant' => '答案是 77 個。',
      'zh-Hans' => '答案是 77 个。',
      'en' => 'The answer is 77.',
      'ja' => '答えは 77 個です。',
    },
    steps: {
      'zh-Hant' => ['含頭含尾的整數個數要用終點減起點再加 1。', '179 − 103 + 1 = 77。'],
      'zh-Hans' => ['含头含尾的整数个数要用终点减起点再加 1。', '179 − 103 + 1 = 77。'],
      'en' => ['For an inclusive count, subtract the first number from the last and add 1.', 'So 179 − 103 + 1 = 77.'],
      'ja' => ['はじめと終わりを含む個数は、終わり − はじめ + 1 で求めます。', '179 − 103 + 1 = 77 です。'],
    },
    options: number_options(a: '78 個', b: '77 個', c: '76 個', d: '75 個'),
    correct: 'B',
    problem_number: '選擇 22',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade3_foundation_070',
    topic: 'arithmetic',
    subtopic: 'order_of_operations',
    prompt: {
      'zh-Hant' => '13×15 + (144−6)×4 = ?',
      'zh-Hans' => '13×15 + (144−6)×4 = ?',
      'en' => 'What is 13×15 + (144−6)×4?',
      'ja' => '13×15 + (144−6)×4 はいくつですか。',
    },
    answer: {
      'zh-Hant' => '答案是 747。',
      'zh-Hans' => '答案是 747。',
      'en' => 'The answer is 747.',
      'ja' => '答えは 747 です。',
    },
    steps: {
      'zh-Hant' => ['13×15 = 195。', '(144−6)×4 = 138×4 = 552。', '195 + 552 = 747。'],
      'zh-Hans' => ['13×15 = 195。', '(144−6)×4 = 138×4 = 552。', '195 + 552 = 747。'],
      'en' => ['13×15 = 195.', '(144−6)×4 = 138×4 = 552.', 'Then 195 + 552 = 747.'],
      'ja' => ['13×15 = 195 です。', '(144−6)×4 = 138×4 = 552 です。', 'したがって 195 + 552 = 747 です。'],
    },
    options: number_options(a: '747', b: '757', c: '767', d: '777'),
    correct: 'A',
    problem_number: '選擇 24',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade3_foundation_071',
    topic: 'arithmetic',
    subtopic: 'symbol_equation',
    prompt: {
      'zh-Hant' => '△+△+△+△ = 18，請問 △+△+△+△+△+△ = ?',
      'zh-Hans' => '△+△+△+△ = 18，请问 △+△+△+△+△+△ = ?',
      'en' => 'If △+△+△+△ = 18, what is △+△+△+△+△+△?',
      'ja' => '△+△+△+△ = 18 のとき、△+△+△+△+△+△ はいくつですか。',
    },
    answer: {
      'zh-Hant' => '答案是 27。',
      'zh-Hans' => '答案是 27。',
      'en' => 'The answer is 27.',
      'ja' => '答えは 27 です。',
    },
    steps: {
      'zh-Hant' => ['4 個 △ 是 18，所以 2 個 △ 是 9。', '6 個 △ 是 2 個 △ 的 3 倍，所以是 9×3 = 27。'],
      'zh-Hans' => ['4 个 △ 是 18，所以 2 个 △ 是 9。', '6 个 △ 是 2 个 △ 的 3 倍，所以是 9×3 = 27。'],
      'en' => ['Four triangles total 18, so two triangles total 9.', 'Six triangles are three times two triangles, so 9×3 = 27.'],
      'ja' => ['△が4つで18なので、△が2つで9です。', '△が6つはその3倍なので、9×3 = 27 です。'],
    },
    options: number_options(a: '24', b: '28', c: '30', d: '27'),
    correct: 'D',
    problem_number: '選擇 25',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  integer_question(
    id: 'arithmetic_grade3_foundation_072',
    subtopic: 'algebraic_reasoning',
    prompt: {
      'zh-Hant' => '在農場裡，山羊比鴨子多 15 隻，全部動物的腳一共有 180 隻。請問農場裡共有多少隻動物？',
      'zh-Hans' => '在农场里，山羊比鸭子多 15 只，全部动物的脚一共有 180 只。请问农场里共有多少只动物？',
      'en' => 'On a farm, there are 15 more goats than ducks, and the animals have 180 legs in total. How many animals are there altogether?',
      'ja' => '農場では、ヤギはアヒルより15匹多く、動物の足は全部で180本あります。動物は全部で何匹いますか。',
    },
    answer: {
      'zh-Hant' => '答案是 55 隻。',
      'zh-Hans' => '答案是 55 只。',
      'en' => 'The answer is 55.',
      'ja' => '答えは 55 匹です。',
    },
    steps: {
      'zh-Hant' => ['先把比鴨子多出的 15 隻山羊單獨看，這 15 隻共有 15×4 = 60 隻腳。', '剩下的腳數是 180 − 60 = 120。', '其餘部分可以看成 20 組「1 隻山羊 + 1 隻鴨子」，每組有 4+2 = 6 隻腳，所以共有 120 ÷ 6 = 20 組。', '因此鴨子有 20 隻，山羊有 35 隻，總共 55 隻。'],
      'zh-Hans' => ['先把比鸭子多出的 15 只山羊单独看，这 15 只有 15×4 = 60 只脚。', '剩下的脚数是 180 − 60 = 120。', '其余部分可以看成 20 组「1 只山羊 + 1 只鸭子」，每组有 4+2 = 6 只脚，所以共有 120 ÷ 6 = 20 组。', '因此鸭子有 20 只，山羊有 35 只，总共 55 只。'],
      'en' => ['Separate the extra 15 goats first. They account for 15×4 = 60 legs.', 'That leaves 180 − 60 = 120 legs.', 'The remaining animals can be paired as 1 goat and 1 duck, with 4+2 = 6 legs per pair, so there are 120 ÷ 6 = 20 pairs.', 'So there are 20 ducks and 35 goats, for a total of 55 animals.'],
      'ja' => ['まず、アヒルより多い15匹のヤギを別に考えると、足は 15×4 = 60 本です。', '残りの足は 180 − 60 = 120 本です。', '残りは「ヤギ1匹とアヒル1匹」の組で考えられ、1組は 4+2 = 6 本なので、120 ÷ 6 = 20 組あります。', 'したがってアヒルは20匹、ヤギは35匹で、合計55匹です。'],
    },
    value: '55',
    max_digits: 2,
    problem_number: '計算 3',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
]

new_logic_questions = [
  choice_question(
    id: 'logic_grade3_foundation_043',
    topic: 'logic',
    subtopic: 'ordering',
    prompt: {
      'zh-Hant' => 'A、B、C 都是正整數，且 A+40 = B−32 = C×2。請問 A、B、C 的大小順序為何？',
      'zh-Hans' => 'A、B、C 都是正整数，且 A+40 = B−32 = C×2。请问 A、B、C 的大小顺序为何？',
      'en' => 'A, B, and C are positive integers and satisfy A+40 = B−32 = C×2. What is the order of B, A, and C from greatest to least?',
      'ja' => 'A、B、C は正の整数で、A+40 = B−32 = C×2 を満たします。A、B、C を大きい順に並べるとどうなりますか。',
    },
    answer: {
      'zh-Hant' => '答案是 B > A > C。',
      'zh-Hans' => '答案是 B > A > C。',
      'en' => 'The answer is B > A > C.',
      'ja' => '答えは B > A > C です。',
    },
    steps: {
      'zh-Hant' => ['設共同的值為 100，則 A = 60，B = 132，C = 50。', '因此大小順序是 B > A > C。'],
      'zh-Hans' => ['设共同的值为 100，则 A = 60，B = 132，C = 50。', '因此大小顺序是 B > A > C。'],
      'en' => ['Take the common value as 100. Then A = 60, B = 132, and C = 50.', 'So the order is B > A > C.'],
      'ja' => ['共通の値を100とすると、A = 60、B = 132、C = 50 です。', 'したがって順序は B > A > C です。'],
    },
    options: {
      'A' => { 'zh-Hant' => 'B > C > A', 'zh-Hans' => 'B > C > A', 'en' => 'B > C > A', 'ja' => 'B > C > A' },
      'B' => { 'zh-Hant' => 'A > C > B', 'zh-Hans' => 'A > C > B', 'en' => 'A > C > B', 'ja' => 'A > C > B' },
      'C' => { 'zh-Hant' => 'B > A > C', 'zh-Hans' => 'B > A > C', 'en' => 'B > A > C', 'ja' => 'B > A > C' },
      'D' => { 'zh-Hant' => 'C > A > B', 'zh-Hans' => 'C > A > B', 'en' => 'C > A > B', 'ja' => 'C > A > B' },
    },
    correct: 'C',
    problem_number: '選擇 23',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
]

existing_arithmetic_ids = arithmetic.fetch('questions').map { |question| question.fetch('id') }
existing_logic_ids = logic.fetch('questions').map { |question| question.fetch('id') }

duplicate_arithmetic_ids = new_arithmetic_questions.map { |question| question['id'] } & existing_arithmetic_ids
duplicate_logic_ids = new_logic_questions.map { |question| question['id'] } & existing_logic_ids

raise "Duplicate arithmetic ids: #{duplicate_arithmetic_ids.join(', ')}" unless duplicate_arithmetic_ids.empty?
raise "Duplicate logic ids: #{duplicate_logic_ids.join(', ')}" unless duplicate_logic_ids.empty?

arithmetic['questions'].concat(new_arithmetic_questions)
logic['questions'].concat(new_logic_questions)

manifest.fetch('packs').each do |pack|
  case pack['path']
  when 'assets/questions/arithmetic/grade3_foundation.arithmetic.v1.json'
    pack['questionCount'] = arithmetic['questions'].length
  when 'assets/questions/logic/grade3_foundation.logic.v1.json'
    pack['questionCount'] = logic['questions'].length
  end
end

save_json(ARITHMETIC_PATH, arithmetic)
save_json(LOGIC_PATH, logic)
save_json(MANIFEST_PATH, manifest)
