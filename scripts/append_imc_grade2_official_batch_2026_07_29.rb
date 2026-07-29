#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'

ROOT = File.expand_path('..', __dir__)
ARITHMETIC_PATH = File.join(ROOT, 'assets/questions/arithmetic/grade2_foundation.arithmetic.v1.json')
LOGIC_PATH = File.join(ROOT, 'assets/questions/logic/grade2_foundation.logic.v1.json')
MANIFEST_PATH = File.join(ROOT, 'assets/questions/manifest.json')
SOURCE_URL = 'https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD2%E5%B9%B4%E7%B4%9A.pdf'

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
    'division' => '國小二年級',
    'problemNumber' => problem_number,
    'displayText' => "第16屆IMC台灣區初賽國小二年級 #{problem_number}",
    'sourceUrl' => SOURCE_URL,
    'rightsStatus' => 'needs_review',
    'notes' => notes,
  }
end

def figure_none
  { 'type' => 'custom', 'kind' => 'none', 'params' => {} }
end

def integer_question(id:, subtopic:, prompt:, answer:, steps:, value:, max_digits:, problem_number:, notes:)
  {
    'id' => id,
    'topic' => 'arithmetic',
    'subtopic' => subtopic,
    'difficulty' => 'foundation',
    'levelStage' => 'grade2',
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

def choice_question(id:, topic:, subtopic:, prompt:, answer:, steps:, options:, correct:, problem_number:, notes:)
  {
    'id' => id,
    'topic' => topic,
    'subtopic' => subtopic,
    'difficulty' => 'foundation',
    'levelStage' => 'grade2',
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

def number_options(a:, b:, c:, d:)
  {
    'A' => { 'zh-Hant' => a, 'zh-Hans' => a, 'en' => a, 'ja' => a },
    'B' => { 'zh-Hant' => b, 'zh-Hans' => b, 'en' => b, 'ja' => b },
    'C' => { 'zh-Hant' => c, 'zh-Hans' => c, 'en' => c, 'ja' => c },
    'D' => { 'zh-Hant' => d, 'zh-Hans' => d, 'en' => d, 'ja' => d },
  }
end

arithmetic = load_json(ARITHMETIC_PATH)
logic = load_json(LOGIC_PATH)
manifest = load_json(MANIFEST_PATH)

new_arithmetic_questions = [
  choice_question(
    id: 'arithmetic_grade2_foundation_051',
    topic: 'arithmetic',
    subtopic: 'comparison',
    prompt: {
      'zh-Hant' => '8 個 4 比 6 個 4 多了幾個 4？',
      'zh-Hans' => '8 个 4 比 6 个 4 多了几个 4？',
      'en' => 'How many more groups of 4 are there in 8 groups of 4 than in 6 groups of 4?',
      'ja' => '4が8こあるものは、4が6こあるものより、4がいくつ分多いですか。',
    },
    answer: {
      'zh-Hant' => '答案是 2 個 4。',
      'zh-Hans' => '答案是 2 个 4。',
      'en' => 'The answer is 2 groups of 4.',
      'ja' => '答えは4が2つ分です。',
    },
    steps: {
      'zh-Hant' => ['比較 8 個 4 和 6 個 4，只要算 8 − 6。', '8 − 6 = 2，所以多 2 個 4。'],
      'zh-Hans' => ['比较 8 个 4 和 6 个 4，只要算 8 − 6。', '8 − 6 = 2，所以多 2 个 4。'],
      'en' => ['Compare the number of groups: 8 − 6.', 'That gives 2, so it is 2 groups of 4 more.'],
      'ja' => ['4のまとまりの数を比べればよいので、8 − 6 を計算します。', '8 − 6 = 2 なので、4が2つ分多いです。'],
    },
    options: number_options(a: '0 個', b: '1 個', c: '2 個', d: '3 個'),
    correct: 'C',
    problem_number: '選擇 1',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade2_foundation_052',
    topic: 'arithmetic',
    subtopic: 'partition_counting',
    prompt: {
      'zh-Hant' => '被加數 + 加數 = 10，而且被加數 > 加數，符合這樣條件的算式有幾組？',
      'zh-Hans' => '被加数 + 加数 = 10，而且被加数 > 加数，符合这样条件的算式有几组？',
      'en' => 'If the first addend plus the second addend equals 10 and the first addend is greater than the second, how many such addition sentences are there?',
      'ja' => 'あるたし算で、たされる数とたす数の和が10で、前の数が後ろの数より大きいとします。そのような式はいくつありますか。',
    },
    answer: {
      'zh-Hant' => '答案是 5 組。',
      'zh-Hans' => '答案是 5 组。',
      'en' => 'The answer is 5.',
      'ja' => '答えは5組です。',
    },
    steps: {
      'zh-Hant' => ['符合條件的組合有 10+0、9+1、8+2、7+3、6+4。', '一共有 5 組。'],
      'zh-Hans' => ['符合条件的组合有 10+0、9+1、8+2、7+3、6+4。', '一共有 5 组。'],
      'en' => ['The valid pairs are 10+0, 9+1, 8+2, 7+3, and 6+4.', 'So there are 5 such addition sentences.'],
      'ja' => ['条件に合うのは 10+0、9+1、8+2、7+3、6+4 です。', 'したがって5組あります。'],
    },
    options: number_options(a: '5 組', b: '4 組', c: '3 組', d: '2 組'),
    correct: 'A',
    problem_number: '選擇 2',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade2_foundation_053',
    topic: 'arithmetic',
    subtopic: 'counting_evens',
    prompt: {
      'zh-Hant' => '從 75 數到 100，共有幾個偶數？',
      'zh-Hans' => '从 75 数到 100，共有几个偶数？',
      'en' => 'From 75 to 100 inclusive, how many even numbers are there?',
      'ja' => '75から100までの整数の中に、偶数は何個ありますか。',
    },
    answer: {
      'zh-Hant' => '答案是 13 個。',
      'zh-Hans' => '答案是 13 个。',
      'en' => 'The answer is 13.',
      'ja' => '答えは13個です。',
    },
    steps: {
      'zh-Hant' => ['75 到 100 一共有 100 − 75 + 1 = 26 個整數。', '奇數和偶數交替出現，26 個整數裡各有 13 個。'],
      'zh-Hans' => ['75 到 100 一共有 100 − 75 + 1 = 26 个整数。', '奇数和偶数交替出现，26 个整数里各有 13 个。'],
      'en' => ['There are 100 − 75 + 1 = 26 integers from 75 to 100.', 'Even and odd numbers alternate, so half of them, 13, are even.'],
      'ja' => ['75から100までの整数は 100 − 75 + 1 = 26 個あります。', '偶数と奇数は交互に並ぶので、その半分の13個が偶数です。'],
    },
    options: number_options(a: '12 個', b: '13 個', c: '14 個', d: '15 個'),
    correct: 'B',
    problem_number: '選擇 3',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade2_foundation_054',
    topic: 'arithmetic',
    subtopic: 'missing_number',
    prompt: {
      'zh-Hant' => '98 − □ = 18，則 □ + 1 = ?',
      'zh-Hans' => '98 − □ = 18，则 □ + 1 = ?',
      'en' => 'If 98 − □ = 18, what is □ + 1?',
      'ja' => '98 − □ = 18 のとき、□ + 1 はいくつですか。',
    },
    answer: {
      'zh-Hant' => '答案是 81。',
      'zh-Hans' => '答案是 81。',
      'en' => 'The answer is 81.',
      'ja' => '答えは81です。',
    },
    steps: {
      'zh-Hant' => ['先求出方格裡的數：98 − 18 = 80。', '所以 □ + 1 = 80 + 1 = 81。'],
      'zh-Hans' => ['先求出方格里的数：98 − 18 = 80。', '所以 □ + 1 = 80 + 1 = 81。'],
      'en' => ['First find the missing number: 98 − 18 = 80.', 'Then □ + 1 = 80 + 1 = 81.'],
      'ja' => ['まず□の数を求めると、98 − 18 = 80 です。', 'したがって □ + 1 = 80 + 1 = 81 です。'],
    },
    options: number_options(a: '78', b: '79', c: '80', d: '81'),
    correct: 'D',
    problem_number: '選擇 4',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade2_foundation_055',
    topic: 'arithmetic',
    subtopic: 'arithmetic_sequence',
    prompt: {
      'zh-Hant' => '120→103→□→□→52→35，空格內該填入多少？',
      'zh-Hans' => '120→103→□→□→52→35，空格内该填入多少？',
      'en' => 'In the chain 120→103→□→□→52→35, what numbers should fill the two blanks?',
      'ja' => '120→103→□→□→52→35 という並びで、2つの空欄には何が入りますか。',
    },
    answer: {
      'zh-Hant' => '答案是 86、69。',
      'zh-Hans' => '答案是 86、69。',
      'en' => 'The answer is 86 and 69.',
      'ja' => '答えは86と69です。',
    },
    steps: {
      'zh-Hant' => ['120 到 103 減少了 17，所以每一步都減 17。', '52 往前加 17 得到 69，再加 17 得到 86。'],
      'zh-Hans' => ['120 到 103 减少了 17，所以每一步都减 17。', '52 往前加 17 得到 69，再加 17 得到 86。'],
      'en' => ['The change from 120 to 103 is −17, so each step subtracts 17.', 'Working backward from 52 gives 69, then 86.'],
      'ja' => ['120から103へは17減っています。したがって毎回17ずつ減ります。', '52の前は69、その前は86です。'],
    },
    options: number_options(a: '86、69', b: '87、70', c: '88、68', d: '89、71'),
    correct: 'A',
    problem_number: '選擇 5',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade2_foundation_056',
    topic: 'arithmetic',
    subtopic: 'unit_rate',
    prompt: {
      'zh-Hant' => '弟弟買 2 枝鉛筆花了 45 元，如果要買 6 枝鉛筆要花多少元？',
      'zh-Hans' => '弟弟买 2 枝铅笔花了 45 元，如果要买 6 枝铅笔要花多少元？',
      'en' => 'Two pencils cost 45 dollars. How much do 6 pencils cost?',
      'ja' => 'えんぴつ2本で45元です。えんぴつ6本では何元かかりますか。',
    },
    answer: {
      'zh-Hant' => '答案是 135 元。',
      'zh-Hans' => '答案是 135 元。',
      'en' => 'The answer is 135.',
      'ja' => '答えは135元です。',
    },
    steps: {
      'zh-Hant' => ['6 枝是 2 枝的 3 倍。', '所以價錢也是 3 倍：45 × 3 = 135。'],
      'zh-Hans' => ['6 枝是 2 枝的 3 倍。', '所以价钱也是 3 倍：45 × 3 = 135。'],
      'en' => ['Six pencils are 3 times as many as two pencils.', 'So the cost is also 3 times: 45 × 3 = 135.'],
      'ja' => ['6本は2本の3倍です。', 'したがって値段も3倍で、45 × 3 = 135 です。'],
    },
    options: number_options(a: '135 元', b: '125 元', c: '115 元', d: '105 元'),
    correct: 'A',
    problem_number: '選擇 6',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade2_foundation_057',
    topic: 'arithmetic',
    subtopic: 'sum_check',
    prompt: {
      'zh-Hant' => '1+2+3+4+5+6+7+8+9+10−55 = ?',
      'zh-Hans' => '1+2+3+4+5+6+7+8+9+10−55 = ?',
      'en' => 'What is 1+2+3+4+5+6+7+8+9+10−55?',
      'ja' => '1+2+3+4+5+6+7+8+9+10−55 はいくつですか。',
    },
    answer: {
      'zh-Hant' => '答案是 0。',
      'zh-Hans' => '答案是 0。',
      'en' => 'The answer is 0.',
      'ja' => '答えは0です。',
    },
    steps: {
      'zh-Hant' => ['1 到 10 的和是 55。', '所以 55 − 55 = 0。'],
      'zh-Hans' => ['1 到 10 的和是 55。', '所以 55 − 55 = 0。'],
      'en' => ['The sum from 1 to 10 is 55.', 'So 55 − 55 = 0.'],
      'ja' => ['1から10までの和は55です。', 'したがって 55 − 55 = 0 です。'],
    },
    options: number_options(a: '3', b: '2', c: '0', d: '4'),
    correct: 'C',
    problem_number: '選擇 7',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade2_foundation_058',
    topic: 'arithmetic',
    subtopic: 'two_step_addition',
    prompt: {
      'zh-Hant' => '冰店上午賣出 12 枝冰棒，下午比上午多賣出 4 枝，今天共賣出多少枝冰棒？',
      'zh-Hans' => '冰店上午卖出 12 枝冰棒，下午比上午多卖出 4 枝，今天共卖出多少枝冰棒？',
      'en' => 'A shop sold 12 popsicles in the morning. In the afternoon it sold 4 more than in the morning. How many popsicles were sold in total today?',
      'ja' => 'アイス屋さんは午前にアイスバーを12本売りました。午後は午前より4本多く売りました。今日全部で何本売りましたか。',
    },
    answer: {
      'zh-Hant' => '答案是 28 枝。',
      'zh-Hans' => '答案是 28 枝。',
      'en' => 'The answer is 28.',
      'ja' => '答えは28本です。',
    },
    steps: {
      'zh-Hant' => ['下午賣出 12 + 4 = 16 枝。', '今天共賣出 12 + 16 = 28 枝。'],
      'zh-Hans' => ['下午卖出 12 + 4 = 16 枝。', '今天共卖出 12 + 16 = 28 枝。'],
      'en' => ['The afternoon amount is 12 + 4 = 16.', 'So the total is 12 + 16 = 28.'],
      'ja' => ['午後に売った本数は 12 + 4 = 16 本です。', 'したがって全部で 12 + 16 = 28 本です。'],
    },
    options: number_options(a: '16 枝', b: '20 枝', c: '24 枝', d: '28 枝'),
    correct: 'D',
    problem_number: '選擇 10',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade2_foundation_059',
    topic: 'arithmetic',
    subtopic: 'inequality',
    prompt: {
      'zh-Hant' => '174 < □ < 202，下列哪一個數字不能填入空格內？',
      'zh-Hans' => '174 < □ < 202，下列哪一个数字不能填入空格内？',
      'en' => 'If 174 < □ < 202, which number cannot go in the box?',
      'ja' => '174 < □ < 202 のとき、□に入れられない数はどれですか。',
    },
    answer: {
      'zh-Hant' => '答案是 210。',
      'zh-Hans' => '答案是 210。',
      'en' => 'The answer is 210.',
      'ja' => '答えは210です。',
    },
    steps: {
      'zh-Hant' => ['要大於 174 且小於 202。', '210 大於 202，不符合條件。'],
      'zh-Hans' => ['要大于 174 且小于 202。', '210 大于 202，不符合条件。'],
      'en' => ['The number must be greater than 174 and less than 202.', 'Since 210 is greater than 202, it does not fit.'],
      'ja' => ['174より大きく、202より小さくなければなりません。', '210は202より大きいので条件に合いません。'],
    },
    options: number_options(a: '180', b: '190', c: '200', d: '210'),
    correct: 'D',
    problem_number: '選擇 11',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade2_foundation_060',
    topic: 'arithmetic',
    subtopic: 'estimation',
    prompt: {
      'zh-Hant' => '「11 + 21 + 31」最接近下列哪一個數字？',
      'zh-Hans' => '「11 + 21 + 31」最接近下列哪一个数字？',
      'en' => 'Which of the following numbers is closest to 11 + 21 + 31?',
      'ja' => '11 + 21 + 31 にいちばん近い数はどれですか。',
    },
    answer: {
      'zh-Hant' => '答案是 60。',
      'zh-Hans' => '答案是 60。',
      'en' => 'The answer is 60.',
      'ja' => '答えは60です。',
    },
    steps: {
      'zh-Hant' => ['11 + 21 + 31 = 63。', '63 最接近 60。'],
      'zh-Hans' => ['11 + 21 + 31 = 63。', '63 最接近 60。'],
      'en' => ['11 + 21 + 31 = 63.', 'The closest choice to 63 is 60.'],
      'ja' => ['11 + 21 + 31 = 63 です。', '63にいちばん近いのは60です。'],
    },
    options: number_options(a: '50', b: '60', c: '70', d: '40'),
    correct: 'B',
    problem_number: '選擇 14',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade2_foundation_061',
    topic: 'arithmetic',
    subtopic: 'money_subtraction',
    prompt: {
      'zh-Hant' => '媽媽給你 3 個五十元硬幣，你花掉了 105 元後，還剩下多少元？',
      'zh-Hans' => '妈妈给你 3 个五十元硬币，你花掉了 105 元后，还剩下多少元？',
      'en' => 'You have three 50-dollar coins. After spending 105 dollars, how much money is left?',
      'ja' => '50元玉を3枚持っています。105元使ったあと、いくら残りますか。',
    },
    answer: {
      'zh-Hant' => '答案是 45 元。',
      'zh-Hans' => '答案是 45 元。',
      'en' => 'The answer is 45.',
      'ja' => '答えは45元です。',
    },
    steps: {
      'zh-Hant' => ['總共有 50 + 50 + 50 = 150 元。', '150 − 105 = 45 元。'],
      'zh-Hans' => ['总共有 50 + 50 + 50 = 150 元。', '150 − 105 = 45 元。'],
      'en' => ['The total is 50 + 50 + 50 = 150.', 'Then 150 − 105 = 45.'],
      'ja' => ['全部で 50 + 50 + 50 = 150 元です。', '150 − 105 = 45 元です。'],
    },
    options: number_options(a: '45 元', b: '55 元', c: '35 元', d: '25 元'),
    correct: 'A',
    problem_number: '選擇 15',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade2_foundation_062',
    topic: 'arithmetic',
    subtopic: 'sum_and_difference',
    prompt: {
      'zh-Hant' => '故事書和漫畫書共有 40 本，故事書比漫畫書多 6 本。漫畫書有多少本？',
      'zh-Hans' => '故事书和漫画书共有 40 本，故事书比漫画书多 6 本。漫画书有多少本？',
      'en' => 'There are 40 storybooks and comic books altogether. There are 6 more storybooks than comic books. How many comic books are there?',
      'ja' => '物語の本とまんがの本が合わせて40冊あります。物語の本はまんがの本より6冊多いです。まんがの本は何冊ありますか。',
    },
    answer: {
      'zh-Hant' => '答案是 17 本。',
      'zh-Hans' => '答案是 17 本。',
      'en' => 'The answer is 17.',
      'ja' => '答えは17冊です。',
    },
    steps: {
      'zh-Hant' => ['如果兩種書一樣多，就會各有 20 本。', '現在故事書多 6 本，表示漫畫書比 20 本少 3 本，所以是 17 本。'],
      'zh-Hans' => ['如果两种书一样多，就会各有 20 本。', '现在故事书多 6 本，表示漫画书比 20 本少 3 本，所以是 17 本。'],
      'en' => ['If the two amounts were equal, each would be 20.', 'A difference of 6 means the smaller group is 3 less than 20, so the comic books number 17.'],
      'ja' => ['もし同じ冊数なら、それぞれ20冊です。', '実際には差が6冊あるので、少ないほうは20冊より3冊少なく、17冊です。'],
    },
    options: number_options(a: '14 本', b: '15 本', c: '16 本', d: '17 本'),
    correct: 'D',
    problem_number: '選擇 17',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade2_foundation_063',
    topic: 'arithmetic',
    subtopic: 'capacity_comparison',
    prompt: {
      'zh-Hant' => '下面哪一個東西的容量最大？',
      'zh-Hans' => '下面哪一个东西的容量最大？',
      'en' => 'Which of the following has the greatest capacity?',
      'ja' => '次のうち、いちばん容量が大きいものはどれですか。',
    },
    answer: {
      'zh-Hant' => '答案是游泳池。',
      'zh-Hans' => '答案是游泳池。',
      'en' => 'The answer is a swimming pool.',
      'ja' => '答えはプールです。',
    },
    steps: {
      'zh-Hant' => ['比較浴缸、寶特瓶、馬桶、游泳池，容量最大的是游泳池。'],
      'zh-Hans' => ['比较浴缸、宝特瓶、马桶、游泳池，容量最大的是游泳池。'],
      'en' => ['Among a bathtub, bottle, toilet, and swimming pool, the swimming pool has the greatest capacity.'],
      'ja' => ['浴そう、ペットボトル、トイレ、プールを比べると、いちばん大きいのはプールです。'],
    },
    options: {
      'A' => { 'zh-Hant' => '浴缸', 'zh-Hans' => '浴缸', 'en' => 'Bathtub', 'ja' => '浴そう' },
      'B' => { 'zh-Hant' => '寶特瓶', 'zh-Hans' => '宝特瓶', 'en' => 'Bottle', 'ja' => 'ペットボトル' },
      'C' => { 'zh-Hant' => '馬桶', 'zh-Hans' => '马桶', 'en' => 'Toilet', 'ja' => 'トイレ' },
      'D' => { 'zh-Hant' => '游泳池', 'zh-Hans' => '游泳池', 'en' => 'Swimming pool', 'ja' => 'プール' },
    },
    correct: 'D',
    problem_number: '選擇 19',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade2_foundation_064',
    topic: 'arithmetic',
    subtopic: 'symbol_equation',
    prompt: {
      'zh-Hant' => '★ + ★ + □ = 39，★ + □ = 25，則 ★ − □ = ?',
      'zh-Hans' => '★ + ★ + □ = 39，★ + □ = 25，则 ★ − □ = ?',
      'en' => 'If ★ + ★ + □ = 39 and ★ + □ = 25, what is ★ − □?',
      'ja' => '★ + ★ + □ = 39、★ + □ = 25 のとき、★ − □ はいくつですか。',
    },
    answer: {
      'zh-Hant' => '答案是 3。',
      'zh-Hans' => '答案是 3。',
      'en' => 'The answer is 3.',
      'ja' => '答えは3です。',
    },
    steps: {
      'zh-Hant' => ['由 ★ + ★ + □ = 39 與 ★ + □ = 25，可得 ★ + 25 = 39。', '所以 ★ = 14，□ = 11，因此 ★ − □ = 3。'],
      'zh-Hans' => ['由 ★ + ★ + □ = 39 与 ★ + □ = 25，可得 ★ + 25 = 39。', '所以 ★ = 14，□ = 11，因此 ★ − □ = 3。'],
      'en' => ['Subtract ★ + □ = 25 from ★ + ★ + □ = 39 to get ★ = 14.', 'Then □ = 25 − 14 = 11, so ★ − □ = 3.'],
      'ja' => ['★ + ★ + □ = 39 から ★ + □ = 25 を引くと、★ = 14 です。', 'すると □ = 11 なので、★ − □ = 3 です。'],
    },
    options: number_options(a: '3', b: '4', c: '5', d: '6'),
    correct: 'A',
    problem_number: '選擇 20',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade2_foundation_065',
    topic: 'arithmetic',
    subtopic: 'custom_operator',
    prompt: {
      'zh-Hant' => '已知 4◇3 = 4+4+4 = 12，8◇2 = 8+8 = 16，7◇5 = 7+7+7+7+7 = 35，則 3◇8 = ?',
      'zh-Hans' => '已知 4◇3 = 4+4+4 = 12，8◇2 = 8+8 = 16，7◇5 = 7+7+7+7+7 = 35，则 3◇8 = ?',
      'en' => 'Given 4◇3 = 4+4+4 = 12, 8◇2 = 8+8 = 16, and 7◇5 = 7+7+7+7+7 = 35, what is 3◇8?',
      'ja' => '4◇3 = 4+4+4 = 12、8◇2 = 8+8 = 16、7◇5 = 7+7+7+7+7 = 35 のとき、3◇8 はいくつですか。',
    },
    answer: {
      'zh-Hant' => '答案是 24。',
      'zh-Hans' => '答案是 24。',
      'en' => 'The answer is 24.',
      'ja' => '答えは24です。',
    },
    steps: {
      'zh-Hant' => ['◇ 表示把前面的數重複加上後面數量次。', '所以 3◇8 = 3+3+3+3+3+3+3+3 = 24。'],
      'zh-Hans' => ['◇ 表示把前面的数重复加上后面数量次。', '所以 3◇8 = 3+3+3+3+3+3+3+3 = 24。'],
      'en' => ['The symbol ◇ means repeat the first number as an addition as many times as the second number says.', 'So 3◇8 = 3+3+3+3+3+3+3+3 = 24.'],
      'ja' => ['◇ は、前の数を後ろの数の回数だけ足すことを表しています。', 'したがって 3◇8 = 3+3+3+3+3+3+3+3 = 24 です。'],
    },
    options: number_options(a: '22', b: '23', c: '24', d: '25'),
    correct: 'C',
    problem_number: '選擇 21',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade2_foundation_066',
    topic: 'arithmetic',
    subtopic: 'calendar_counting',
    prompt: {
      'zh-Hant' => '牆上掛著一本日曆，再過一星期就是媽媽的生日。請問媽媽的生日是幾月幾日？',
      'zh-Hans' => '墙上挂着一本日历，再过一星期就是妈妈的生日。请问妈妈的生日是几月几日？',
      'en' => 'A calendar is hanging on the wall. One week later will be Mother\'s birthday. What is the date of Mother\'s birthday?',
      'ja' => '壁にカレンダーがかかっています。1週間後がお母さんの誕生日です。お母さんの誕生日は何月何日ですか。',
    },
    answer: {
      'zh-Hant' => '答案是 3 月 7 日。',
      'zh-Hans' => '答案是 3 月 7 日。',
      'en' => 'The answer is March 7.',
      'ja' => '答えは3月7日です。',
    },
    steps: {
      'zh-Hant' => ['官方解答的起點日期是 3 月 1 日。', '再過一星期是 7 天後，所以生日是 3 月 7 日。'],
      'zh-Hans' => ['官方解答的起点日期是 3 月 1 日。', '再过一星期是 7 天后，所以生日是 3 月 7 日。'],
      'en' => ['The official solution uses March 1 as the starting date on the calendar.', 'One week later is 7 days later, so the birthday is March 7.'],
      'ja' => ['公式解答では、カレンダーの基準日が3月1日です。', '1週間後は7日後なので、誕生日は3月7日です。'],
    },
    options: number_options(a: '3 月 6 日', b: '3 月 7 日', c: '3 月 8 日', d: '3 月 9 日'),
    correct: 'B',
    problem_number: '選擇 23',
    notes: 'Imported from the official PDF without figure dependency. The text-only intake follows the date stated in the official solution.',
  ),
  choice_question(
    id: 'arithmetic_grade2_foundation_067',
    topic: 'arithmetic',
    subtopic: 'ceiling_division',
    prompt: {
      'zh-Hant' => '將 19 顆彈珠，每 3 顆裝一袋，至少要裝幾袋才夠？',
      'zh-Hans' => '将 19 颗弹珠，每 3 颗装一袋，至少要装几袋才够？',
      'en' => 'If 19 marbles are packed with 3 marbles in each bag, what is the least number of bags needed?',
      'ja' => '19個のビー玉を1袋3個ずつ入れるとき、少なくとも何袋必要ですか。',
    },
    answer: {
      'zh-Hant' => '答案是 7 袋。',
      'zh-Hans' => '答案是 7 袋。',
      'en' => 'The answer is 7.',
      'ja' => '答えは7袋です。',
    },
    steps: {
      'zh-Hant' => ['6 袋只能裝 18 顆。', '還剩 1 顆也需要 1 袋，所以共要 7 袋。'],
      'zh-Hans' => ['6 袋只能装 18 颗。', '还剩 1 颗也需要 1 袋，所以共要 7 袋。'],
      'en' => ['Six bags hold only 18 marbles.', 'One marble remains, so one more bag is needed. Total: 7 bags.'],
      'ja' => ['6袋では18個までしか入りません。', '1個余るので、もう1袋必要です。合計7袋です。'],
    },
    options: number_options(a: '6 袋', b: '7 袋', c: '8 袋', d: '9 袋'),
    correct: 'B',
    problem_number: '選擇 24',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade2_foundation_068',
    topic: 'arithmetic',
    subtopic: 'state_tracking',
    prompt: {
      'zh-Hant' => '媽媽分糖果，哥哥拿到 15 顆糖果，妹妹拿得比哥哥多 12 顆，弟弟拿得比妹妹少 8 顆，三人共分到多少顆糖果？',
      'zh-Hans' => '妈妈分糖果，哥哥拿到 15 颗糖果，妹妹拿得比哥哥多 12 颗，弟弟拿得比妹妹少 8 颗，三人共分到多少颗糖果？',
      'en' => 'Mother shares candies. Older brother gets 15. Younger sister gets 12 more than he does. Younger brother gets 8 fewer than the younger sister. How many candies do the three children get in total?',
      'ja' => 'お母さんがあめを配ります。兄は15個、妹は兄より12個多く、弟は妹より8個少なくもらいました。3人で合わせて何個もらいましたか。',
    },
    answer: {
      'zh-Hant' => '答案是 61 顆。',
      'zh-Hans' => '答案是 61 颗。',
      'en' => 'The answer is 61.',
      'ja' => '答えは61個です。',
    },
    steps: {
      'zh-Hant' => ['妹妹拿到 15 + 12 = 27 顆。', '弟弟拿到 27 − 8 = 19 顆。', '總數是 15 + 27 + 19 = 61 顆。'],
      'zh-Hans' => ['妹妹拿到 15 + 12 = 27 颗。', '弟弟拿到 27 − 8 = 19 颗。', '总数是 15 + 27 + 19 = 61 颗。'],
      'en' => ['The sister gets 15 + 12 = 27 candies.', 'The younger brother gets 27 − 8 = 19 candies.', 'So the total is 15 + 27 + 19 = 61.'],
      'ja' => ['妹は 15 + 12 = 27 個もらいます。', '弟は 27 − 8 = 19 個もらいます。', '合計は 15 + 27 + 19 = 61 個です。'],
    },
    options: number_options(a: '35 顆', b: '42 顆', c: '54 顆', d: '61 顆'),
    correct: 'D',
    problem_number: '選擇 25',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  integer_question(
    id: 'arithmetic_grade2_foundation_069',
    subtopic: 'equation_reasoning',
    prompt: {
      'zh-Hant' => '有一組減法算式，被減數、減數及差數的和剛好是 36。求被減數是多少？',
      'zh-Hans' => '有一组减法算式，被减数、减数及差数的和刚好是 36。求被减数是多少？',
      'en' => 'In a subtraction sentence, the minuend, subtrahend, and difference add up to 36. What is the minuend?',
      'ja' => 'ある引き算で、ひかれる数、ひく数、差の和が36です。ひかれる数はいくつですか。',
    },
    answer: {
      'zh-Hant' => '答案是 18。',
      'zh-Hans' => '答案是 18。',
      'en' => 'The answer is 18.',
      'ja' => '答えは18です。',
    },
    steps: {
      'zh-Hant' => ['設被減數是 A，減數是 B，差數是 C，則 A − B = C。', '所以 A = B + C。原式 A + B + C = 36 可改寫成 (B + C) + B + C = 36，也就是 2A = 36。', '因此 A = 18。'],
      'zh-Hans' => ['设被减数是 A，减数是 B，差数是 C，则 A − B = C。', '所以 A = B + C。原式 A + B + C = 36 可改写成 (B + C) + B + C = 36，也就是 2A = 36。', '因此 A = 18。'],
      'en' => ['Let the subtraction be A − B = C.', 'Then A = B + C. So A + B + C = 36 becomes A + A = 36.', 'Therefore A = 18.'],
      'ja' => ['引き算を A − B = C とします。', 'このとき A = B + C です。したがって A + B + C = 36 は A + A = 36 になります。', 'よって A = 18 です。'],
    },
    value: '18',
    max_digits: 2,
    problem_number: '計算 3',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
]

new_logic_questions = [
  choice_question(
    id: 'logic_grade2_foundation_041',
    topic: 'logic',
    subtopic: 'calendar_reasoning',
    prompt: {
      'zh-Hant' => '有三人在聊天：阿明說「今天是 11 月 3 日，星期日」；佑佑說「後天是我的生日」；小德說「我的生日過 8 天是佑佑的生日」。請問下列哪一個選項正確表示小德的生日？',
      'zh-Hans' => '有三人在聊天：阿明说「今天是 11 月 3 日，星期日」；佑佑说「后天是我的生日」；小德说「我的生日过 8 天是佑佑的生日」。请问下列哪一个选项正确表示小德的生日？',
      'en' => 'Three children are chatting. Amin says, "Today is Sunday, November 3." Youyou says, "The day after tomorrow is my birthday." Xiaode says, "Eight days after my birthday is Youyou\'s birthday." Which option correctly gives Xiaode\'s birthday?',
      'ja' => '3人が話しています。アーミンは「今日は11月3日の日曜日だよ」と言い、ヨウヨウは「明後日が私の誕生日」と言いました。シャオドーは「私の誕生日の8日後がヨウヨウの誕生日」と言いました。シャオドーの誕生日として正しいものはどれですか。',
    },
    answer: {
      'zh-Hant' => '答案是 10 月 28 日，星期一。',
      'zh-Hans' => '答案是 10 月 28 日，星期一。',
      'en' => 'The answer is Monday, October 28.',
      'ja' => '答えは10月28日、月曜日です。',
    },
    steps: {
      'zh-Hant' => ['後天是 11 月 5 日，所以佑佑的生日是 11 月 5 日。', '小德的生日再過 8 天是 11 月 5 日，所以小德的生日是 10 月 28 日。', '從 11 月 3 日往前回推 6 天，可知 10 月 28 日是星期一。'],
      'zh-Hans' => ['后天是 11 月 5 日，所以佑佑的生日是 11 月 5 日。', '小德的生日再过 8 天是 11 月 5 日，所以小德的生日是 10 月 28 日。', '从 11 月 3 日往前回推 6 天，可知 10 月 28 日是星期一。'],
      'en' => ['The day after tomorrow from November 3 is November 5, so Youyou\'s birthday is November 5.', 'Eight days before that is October 28, so that is Xiaode\'s birthday.', 'Counting back six weekdays from Sunday, November 3 shows that October 28 is a Monday.'],
      'ja' => ['11月3日の明後日は11月5日なので、ヨウヨウの誕生日は11月5日です。', 'その8日前は10月28日なので、シャオドーの誕生日は10月28日です。', '11月3日の日曜日から6日さかのぼると、10月28日は月曜日です。'],
    },
    options: {
      'A' => { 'zh-Hant' => '10 月 27 日，星期日', 'zh-Hans' => '10 月 27 日，星期日', 'en' => 'Sunday, October 27', 'ja' => '10月27日・日曜日' },
      'B' => { 'zh-Hant' => '10 月 28 日，星期一', 'zh-Hans' => '10 月 28 日，星期一', 'en' => 'Monday, October 28', 'ja' => '10月28日・月曜日' },
      'C' => { 'zh-Hant' => '10 月 29 日，星期二', 'zh-Hans' => '10 月 29 日，星期二', 'en' => 'Tuesday, October 29', 'ja' => '10月29日・火曜日' },
      'D' => { 'zh-Hant' => '11 月 5 日，星期二', 'zh-Hans' => '11 月 5 日，星期二', 'en' => 'Tuesday, November 5', 'ja' => '11月5日・火曜日' },
    },
    correct: 'B',
    problem_number: '計算 2',
    notes: 'Imported from the official PDF without figure dependency. Adapted to multiple-choice for the current app answer mode.',
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
  when 'assets/questions/arithmetic/grade2_foundation.arithmetic.v1.json'
    pack['questionCount'] = arithmetic['questions'].length
  when 'assets/questions/logic/grade2_foundation.logic.v1.json'
    pack['questionCount'] = logic['questions'].length
  end
end

save_json(ARITHMETIC_PATH, arithmetic)
save_json(LOGIC_PATH, logic)
save_json(MANIFEST_PATH, manifest)
