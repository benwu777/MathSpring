#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'

ROOT = File.expand_path('..', __dir__)
SOURCE_URL = 'https://www.imcct.net/UserFiles/files/%E4%B8%80%E5%B9%B4%E7%B4%9A%E8%A9%A6%E9%A1%8C+%E8%A7%A3%E7%AD%94%E5%8D%B7.pdf'

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

def official_source(problem_number)
  {
    'type' => 'official_reference',
    'contest' => '第16屆IMC國際數學競賽台灣區初賽',
    'year' => '2015',
    'division' => '國小一年級',
    'problemNumber' => problem_number,
    'displayText' => "第16屆IMC國際數學競賽台灣區初賽，國小一年級，#{problem_number}",
    'sourceUrl' => SOURCE_URL,
    'rightsStatus' => 'needs_review',
    'notes' => 'Imported from the official IMC answer sheet; app answer mode adapted for objective scoring when needed.',
  }
end

append_questions(
  File.join(ROOT, 'assets/questions/logic/grade1_foundation.logic.v1.json'),
  [
    {
      'id' => 'logic_grade1_foundation_047',
      'topic' => 'logic',
      'subtopic' => 'selection',
      'difficulty' => 'foundation',
      'levelStage' => 'grade1',
      'challengeTier' => 'foundation',
      'prompt' => {
        'zh-Hant' => '分類帽把號碼依序分到 A、B、C、D 四隊：1 號到 A 隊，2 號到 B 隊，3 號到 C 隊，4 號到 D 隊，之後每 4 個號碼循環一次。已知榮恩抽到 21 號，妙麗抽到的號碼比榮恩大，而且十位數是 3；她又被分到 D 隊。妙麗的號碼可能是哪兩個？',
        'zh-Hans' => '分类帽把号码依序分到 A、B、C、D 四队：1 号到 A 队，2 号到 B 队，3 号到 C 队，4 号到 D 队，之后每 4 个号码循环一次。已知荣恩抽到 21 号，妙丽抽到的号码比荣恩大，而且十位数是 3；她又被分到 D 队。妙丽的号码可能是哪两个？',
        'en' => 'A sorting hat assigns numbers to teams A, B, C, and D in order: 1 to A, 2 to B, 3 to C, 4 to D, and then the pattern repeats every 4 numbers. Ron gets 21. Hermione’s number is larger than 21, has tens digit 3, and places her in Team D. Which two numbers could Hermione have?',
        'ja' => '組み分け帽子は、1 番を A、2 番を B、3 番を C、4 番を D に入れ、その後は 4 つごとにくり返します。ロンは 21 番を引きました。ハーマイオニーの番号は 21 より大きく、十の位が 3 で、D チームに入ります。ありえる番号はどの 2 つですか。',
      },
      'answer' => {
        'zh-Hant' => '答案是 32 號和 36 號。',
        'zh-Hans' => '答案是 32 号和 36 号。',
        'en' => 'The answer is 32 and 36.',
        'ja' => '答えは 32 番と 36 番です。',
      },
      'solutionSteps' => {
        'zh-Hant' => [
          '分到 D 隊的號碼，除以 4 會餘 0。',
          '十位數是 3，又比 21 大，所以候選是 30 到 39。',
          '在這些數裡，能被 4 整除的是 32 和 36。',
          '所以妙麗可能抽到 32 號和 36 號。',
        ],
        'zh-Hans' => [
          '分到 D 队的号码，除以 4 会余 0。',
          '十位数是 3，又比 21 大，所以候选是 30 到 39。',
          '在这些数里，能被 4 整除的是 32 和 36。',
          '所以妙丽可能抽到 32 号和 36 号。',
        ],
        'en' => [
          'Numbers in Team D are multiples of 4.',
          'Hermione’s number is between 30 and 39 and is greater than 21.',
          'Among those, the multiples of 4 are 32 and 36.',
          'So Hermione could have 32 and 36.',
        ],
        'ja' => [
          'D チームの番号は 4 で割り切れる数です。',
          '十の位が 3 で 21 より大きいので、候補は 30 から 39 です。',
          'この中で 4 で割り切れるのは 32 と 36 です。',
          'したがって、ありえる番号は 32 番と 36 番です。',
        ],
      },
      'figure' => { 'type' => 'custom', 'kind' => 'none', 'params' => {} },
      'answerMode' => 'multiple_choice',
      'options' => {
        'A' => { 'zh-Hant' => '30 和 34', 'zh-Hans' => '30 和 34', 'en' => '30 and 34', 'ja' => '30 と 34' },
        'B' => { 'zh-Hant' => '31 和 35', 'zh-Hans' => '31 和 35', 'en' => '31 and 35', 'ja' => '31 と 35' },
        'C' => { 'zh-Hant' => '32 和 36', 'zh-Hans' => '32 和 36', 'en' => '32 and 36', 'ja' => '32 と 36' },
        'D' => { 'zh-Hant' => '33 和 37', 'zh-Hans' => '33 和 37', 'en' => '33 and 37', 'ja' => '33 と 37' },
      },
      'correctAnswer' => { 'type' => 'choice', 'value' => 'C' },
      'source' => official_source('計算 8(2)'),
    },
  ],
)

append_questions(
  File.join(ROOT, 'assets/questions/arithmetic/grade1_foundation.arithmetic.v1.json'),
  [
    {
      'id' => 'arithmetic_grade1_foundation_062',
      'topic' => 'arithmetic',
      'subtopic' => 'multi_step',
      'difficulty' => 'foundation',
      'levelStage' => 'grade1',
      'challengeTier' => 'foundation',
      'prompt' => {
        'zh-Hant' => '媽媽的零錢包裡有 1 元、5 元、10 元、50 元四種硬幣，總共 253 元。已知 50 元硬幣有 2 個，5 元硬幣有 9 個，而且 1 元硬幣和 10 元硬幣的個數都和 5 元硬幣的個數相差 1。1 元硬幣有幾個？10 元硬幣有幾個？',
        'zh-Hans' => '妈妈的零钱包里有 1 元、5 元、10 元、50 元四种硬币，总共 253 元。已知 50 元硬币有 2 个，5 元硬币有 9 个，而且 1 元硬币和 10 元硬币的个数都和 5 元硬币的个数相差 1。1 元硬币有几个？10 元硬币有几个？',
        'en' => 'A purse contains 1-dollar, 5-dollar, 10-dollar, and 50-dollar coins totaling 253 dollars. There are 2 fifty-dollar coins and 9 five-dollar coins. The numbers of 1-dollar coins and 10-dollar coins each differ from the number of 5-dollar coins by 1. How many 1-dollar coins are there, and how many 10-dollar coins are there?',
        'ja' => 'お母さんの小銭入れには、1元、5元、10元、50元の4種類の硬貨があり、合計は 253 元です。50元硬貨は 2 枚、5元硬貨は 9 枚あります。1元硬貨と10元硬貨の枚数は、どちらも5元硬貨の枚数と 1 枚差です。1元硬貨は何枚、10元硬貨は何枚ありますか。',
      },
      'answer' => {
        'zh-Hant' => '答案是 1 元有 8 個，10 元有 10 個。',
        'zh-Hans' => '答案是 1 元有 8 个，10 元有 10 个。',
        'en' => 'The answer is 8 one-dollar coins and 10 ten-dollar coins.',
        'ja' => '答えは 1元硬貨が 8 枚、10元硬貨が 10 枚です。',
      },
      'solutionSteps' => {
        'zh-Hant' => [
          '50 元有 2 個，共 100 元；5 元有 9 個，共 45 元。',
          '所以 1 元和 10 元硬幣合起來總共是 253 - 100 - 45 = 108 元。',
          '因為 5 元硬幣有 9 個，所以 1 元和 10 元硬幣的個數各是 8 或 10。',
          '若 10 元有 10 個，就是 100 元，剩下 8 元剛好表示 1 元有 8 個。',
          '所以 1 元有 8 個，10 元有 10 個。',
        ],
        'zh-Hans' => [
          '50 元有 2 个，共 100 元；5 元有 9 个，共 45 元。',
          '所以 1 元和 10 元硬币合起来总共是 253 - 100 - 45 = 108 元。',
          '因为 5 元硬币有 9 个，所以 1 元和 10 元硬币的个数各是 8 或 10。',
          '若 10 元有 10 个，就是 100 元，剩下 8 元刚好表示 1 元有 8 个。',
          '所以 1 元有 8 个，10 元有 10 个。',
        ],
        'en' => [
          'The two 50-dollar coins make 100, and the nine 5-dollar coins make 45.',
          'So the 1-dollar and 10-dollar coins together total 253 - 100 - 45 = 108.',
          'Since the number of 5-dollar coins is 9, the counts of 1-dollar and 10-dollar coins must each be either 8 or 10.',
          'If there are 10 ten-dollar coins, that contributes 100, leaving 8 for the one-dollar coins.',
          'So there are 8 one-dollar coins and 10 ten-dollar coins.',
        ],
        'ja' => [
          '50元硬貨 2 枚で 100 元、5元硬貨 9 枚で 45 元です。',
          'したがって、1元硬貨と10元硬貨の合計は 253 - 100 - 45 = 108 元です。',
          '5元硬貨は 9 枚なので、1元硬貨と10元硬貨の枚数はそれぞれ 8 枚または 10 枚です。',
          '10元硬貨が 10 枚なら 100 元になり、残りの 8 元は 1元硬貨 8 枚です。',
          'よって、1元硬貨は 8 枚、10元硬貨は 10 枚です。',
        ],
      },
      'figure' => { 'type' => 'custom', 'kind' => 'none', 'params' => {} },
      'answerMode' => 'multiple_choice',
      'options' => {
        'A' => { 'zh-Hant' => '1 元 10 個，10 元 8 個', 'zh-Hans' => '1 元 10 个，10 元 8 个', 'en' => '1-dollar: 10, 10-dollar: 8', 'ja' => '1元 10 枚、10元 8 枚' },
        'B' => { 'zh-Hant' => '1 元 8 個，10 元 10 個', 'zh-Hans' => '1 元 8 个，10 元 10 个', 'en' => '1-dollar: 8, 10-dollar: 10', 'ja' => '1元 8 枚、10元 10 枚' },
        'C' => { 'zh-Hant' => '1 元 9 個，10 元 9 個', 'zh-Hans' => '1 元 9 个，10 元 9 个', 'en' => '1-dollar: 9, 10-dollar: 9', 'ja' => '1元 9 枚、10元 9 枚' },
        'D' => { 'zh-Hant' => '無法判斷', 'zh-Hans' => '无法判断', 'en' => 'Cannot determine', 'ja' => '判断できない' },
      },
      'correctAnswer' => { 'type' => 'choice', 'value' => 'B' },
      'source' => official_source('挑戰 3'),
    },
  ],
)

puts 'Appended third official IMC 2015 grade1 preliminary batch.'
