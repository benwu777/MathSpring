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
  File.join(ROOT, 'assets/questions/arithmetic/grade1_foundation.arithmetic.v1.json'),
  [
    {
      'id' => 'arithmetic_grade1_foundation_058',
      'topic' => 'arithmetic',
      'subtopic' => 'comparison',
      'difficulty' => 'foundation',
      'levelStage' => 'grade1',
      'challengeTier' => 'foundation',
      'prompt' => {
        'zh-Hant' => '小玉說：「我跑 100 公尺要 11 秒。」小雄說：「我跑操場一圈 400 公尺要 50 秒。」不考慮其他因素，誰跑得比較快？',
        'zh-Hans' => '小玉说：“我跑 100 公尺要 11 秒。”小雄说：“我跑操场一圈 400 公尺要 50 秒。”不考虑其他因素，谁跑得比较快？',
        'en' => 'Xiaoyu says, “I run 100 meters in 11 seconds.” Xiaoxiong says, “I run one 400-meter lap in 50 seconds.” Ignoring all other factors, who runs faster?',
        'ja' => 'シャオユーは「100メートルを11秒で走れる」と言い、シャオションは「400メートルのトラック1周を50秒で走れる」と言いました。他の条件を考えないとき、どちらが速いですか。',
      },
      'answer' => {
        'zh-Hant' => '答案是小玉。',
        'zh-Hans' => '答案是小玉。',
        'en' => 'The answer is Xiaoyu.',
        'ja' => '答えはシャオユーです。',
      },
      'solutionSteps' => {
        'zh-Hant' => [
          '先把小雄的成績換成 100 公尺來看：400 公尺 50 秒，100 公尺就是 12.5 秒。',
          '小玉跑 100 公尺只要 11 秒，比 12.5 秒更少。',
          '所以跑得比較快的是小玉。',
        ],
        'zh-Hans' => [
          '先把小雄的成绩换成 100 公尺来看：400 公尺 50 秒，100 公尺就是 12.5 秒。',
          '小玉跑 100 公尺只要 11 秒，比 12.5 秒更少。',
          '所以跑得比较快的是小玉。',
        ],
        'en' => [
          'Convert Xiaoxiong’s time to 100 meters: if 400 meters takes 50 seconds, then 100 meters takes 12.5 seconds.',
          'Xiaoyu takes only 11 seconds for 100 meters, which is less than 12.5 seconds.',
          'So Xiaoyu runs faster.',
        ],
        'ja' => [
          'まずシャオションの記録を100メートルあたりに直します。400メートルが50秒なら、100メートルは12.5秒です。',
          'シャオユーは100メートルを11秒で走るので、12.5秒より速いです。',
          'したがって速いのはシャオユーです。',
        ],
      },
      'figure' => { 'type' => 'custom', 'kind' => 'none', 'params' => {} },
      'answerMode' => 'multiple_choice',
      'options' => {
        'A' => { 'zh-Hant' => '小玉', 'zh-Hans' => '小玉', 'en' => 'Xiaoyu', 'ja' => 'シャオユー' },
        'B' => { 'zh-Hant' => '小雄', 'zh-Hans' => '小雄', 'en' => 'Xiaoxiong', 'ja' => 'シャオション' },
        'C' => { 'zh-Hant' => '一樣快', 'zh-Hans' => '一样快', 'en' => 'Same speed', 'ja' => '同じ速さ' },
        'D' => { 'zh-Hant' => '無法判斷', 'zh-Hans' => '无法判断', 'en' => 'Cannot tell', 'ja' => '判断できない' },
      },
      'correctAnswer' => { 'type' => 'choice', 'value' => 'A' },
      'source' => official_source('計算 2'),
    },
    {
      'id' => 'arithmetic_grade1_foundation_059',
      'topic' => 'arithmetic',
      'subtopic' => 'pair_counting',
      'difficulty' => 'foundation',
      'levelStage' => 'grade1',
      'challengeTier' => 'foundation',
      'prompt' => {
        'zh-Hant' => '桌上有紅、橙、黃、綠、藍 5 種顏色的彩色筆。每次只能拿 2 枝，而且不分順序。請問一共有幾種不同拿法？',
        'zh-Hans' => '桌上有红、橙、黄、绿、蓝 5 种颜色的彩色笔。每次只能拿 2 枝，而且不分顺序。请问一共有几种不同拿法？',
        'en' => 'There are 5 marker colors: red, orange, yellow, green, and blue. Each time you choose 2 markers, and order does not matter. How many different choices are there?',
        'ja' => '赤、オレンジ、黄、緑、青の5色のペンがあります。毎回2本を選び、順番は区別しません。全部で何通りありますか。',
      },
      'answer' => {
        'zh-Hant' => '答案是 10 種。',
        'zh-Hans' => '答案是 10 种。',
        'en' => 'The answer is 10.',
        'ja' => '答えは 10 通りです。',
      },
      'solutionSteps' => {
        'zh-Hant' => [
          '先從紅色開始，可以和另外 4 色配成 4 種。',
          '橙色還能和黃、綠、藍配成 3 種；黃色還能和綠、藍配成 2 種；綠色還能和藍色配成 1 種。',
          '所以一共是 4 + 3 + 2 + 1 = 10 種。',
        ],
        'zh-Hans' => [
          '先从红色开始，可以和另外 4 色配成 4 种。',
          '橙色还能和黄、绿、蓝配成 3 种；黄色还能和绿、蓝配成 2 种；绿色还能和蓝色配成 1 种。',
          '所以一共是 4 + 3 + 2 + 1 = 10 种。',
        ],
        'en' => [
          'Red can pair with the other 4 colors.',
          'Orange can then pair with yellow, green, and blue: 3 more. Yellow adds 2 more, and green adds 1 more.',
          'So the total is 4 + 3 + 2 + 1 = 10.',
        ],
        'ja' => [
          '赤は残りの4色と組めるので 4 通りあります。',
          'オレンジは黄・緑・青と組めて 3 通り、黄は 2 通り、緑は 1 通りです。',
          'したがって全部で 4 + 3 + 2 + 1 = 10 通りです。',
        ],
      },
      'figure' => { 'type' => 'custom', 'kind' => 'none', 'params' => {} },
      'answerMode' => 'integer_input',
      'correctAnswer' => { 'type' => 'integer', 'value' => '10' },
      'inputConstraints' => { 'allowNegative' => false, 'maxDigits' => 2 },
      'source' => official_source('計算 3'),
    },
    {
      'id' => 'arithmetic_grade1_foundation_060',
      'topic' => 'arithmetic',
      'subtopic' => 'multi_step',
      'difficulty' => 'foundation',
      'levelStage' => 'grade1',
      'challengeTier' => 'foundation',
      'prompt' => {
        'zh-Hant' => '巧虎舞台劇票價如下：成人票 550 元，兒童票（6 歲到 12 歲）400 元，幼兒票（3 歲到 5 歲）380 元，敬老票 300 元。爸爸、媽媽帶兩個都讀國小的孩子去看；舅舅、舅媽再帶 1 位 4 歲小表妹一起去。這 7 個人一共要多少元？',
        'zh-Hans' => '巧虎舞台剧票价如下：成人票 550 元，儿童票（6 岁到 12 岁）400 元，幼儿票（3 岁到 5 岁）380 元，敬老票 300 元。爸爸、妈妈带两个都读国小的孩子去看；舅舅、舅妈再带 1 位 4 岁小表妹一起去。这 7 个人一共要多少元？',
        'en' => 'The stage show tickets cost: adult 550, child (ages 6–12) 400, preschool child (ages 3–5) 380, senior 300. A father and mother bring two children who both attend elementary school. An uncle and aunt also bring one 4-year-old cousin. How much do all 7 people pay in total?',
        'ja' => '舞台ショーの料金は、大人 550 元、子ども（6歳から12歳）400 元、幼児（3歳から5歳）380 元、シニア 300 元です。父と母は小学生2人を連れて行き、おじとおばは4歳のいとこ1人を連れて行きます。7人全員で合計いくらですか。',
      },
      'answer' => {
        'zh-Hant' => '答案是 3380 元。',
        'zh-Hans' => '答案是 3380 元。',
        'en' => 'The answer is 3380.',
        'ja' => '答えは 3380 元です。',
      },
      'solutionSteps' => {
        'zh-Hant' => [
          '4 位大人共要 4 × 550 = 2200 元。',
          '2 位國小孩子是兒童票，共要 2 × 400 = 800 元。',
          '4 歲小表妹是幼兒票，要 380 元。',
          '全部加起來是 2200 + 800 + 380 = 3380 元。',
        ],
        'zh-Hans' => [
          '4 位大人共要 4 × 550 = 2200 元。',
          '2 位国小孩子是儿童票，共要 2 × 400 = 800 元。',
          '4 岁小表妹是幼儿票，要 380 元。',
          '全部加起来是 2200 + 800 + 380 = 3380 元。',
        ],
        'en' => [
          'The 4 adults cost 4 × 550 = 2200.',
          'The 2 elementary-school children are child tickets, costing 2 × 400 = 800.',
          'The 4-year-old cousin is a preschool ticket, costing 380.',
          'So the total is 2200 + 800 + 380 = 3380.',
        ],
        'ja' => [
          '大人4人で 4 × 550 = 2200 元です。',
          '小学生2人は子ども料金なので 2 × 400 = 800 元です。',
          '4歳のいとこは幼児料金で 380 元です。',
          '合計は 2200 + 800 + 380 = 3380 元です。',
        ],
      },
      'figure' => { 'type' => 'custom', 'kind' => 'none', 'params' => {} },
      'answerMode' => 'integer_input',
      'correctAnswer' => { 'type' => 'integer', 'value' => '3380' },
      'inputConstraints' => { 'allowNegative' => false, 'maxDigits' => 4 },
      'source' => official_source('計算 5'),
    },
    {
      'id' => 'arithmetic_grade1_foundation_061',
      'topic' => 'arithmetic',
      'subtopic' => 'counting_groups',
      'difficulty' => 'foundation',
      'levelStage' => 'grade1',
      'challengeTier' => 'foundation',
      'prompt' => {
        'zh-Hant' => '先找出 10 以內比 3 大的 3 個連續奇數，再把 20 以內所有的偶數也加進來。這些數全部加起來是多少？',
        'zh-Hans' => '先找出 10 以内比 3 大的 3 个连续奇数，再把 20 以内所有的偶数也加进来。这些数全部加起来是多少？',
        'en' => 'First take the 3 consecutive odd numbers less than 10 and greater than 3. Then include all even numbers up to 20. What is the sum of all these numbers?',
        'ja' => 'まず、10 以内で 3 より大きい連続する奇数を 3 つ取ります。次に、20 以内のすべての偶数を加えます。これら全部の和はいくつですか。',
      },
      'answer' => {
        'zh-Hant' => '答案是 131。',
        'zh-Hans' => '答案是 131。',
        'en' => 'The answer is 131.',
        'ja' => '答えは 131 です。',
      },
      'solutionSteps' => {
        'zh-Hant' => [
          '10 以內比 3 大的 3 個連續奇數是 5、7、9，和是 21。',
          '20 以內所有偶數是 2、4、6、8、10、12、14、16、18、20，和是 110。',
          '全部加起來是 21 + 110 = 131。',
        ],
        'zh-Hans' => [
          '10 以内比 3 大的 3 个连续奇数是 5、7、9，和是 21。',
          '20 以内所有偶数是 2、4、6、8、10、12、14、16、18、20，和是 110。',
          '全部加起来是 21 + 110 = 131。',
        ],
        'en' => [
          'The 3 consecutive odd numbers less than 10 and greater than 3 are 5, 7, and 9, whose sum is 21.',
          'The even numbers up to 20 are 2, 4, 6, 8, 10, 12, 14, 16, 18, and 20, whose sum is 110.',
          'So the total is 21 + 110 = 131.',
        ],
        'ja' => [
          '10 以内で 3 より大きい連続する奇数 3 つは 5、7、9 で、その和は 21 です。',
          '20 以内の偶数は 2、4、6、8、10、12、14、16、18、20 で、その和は 110 です。',
          'したがって合計は 21 + 110 = 131 です。',
        ],
      },
      'figure' => { 'type' => 'custom', 'kind' => 'none', 'params' => {} },
      'answerMode' => 'integer_input',
      'correctAnswer' => { 'type' => 'integer', 'value' => '131' },
      'inputConstraints' => { 'allowNegative' => false, 'maxDigits' => 3 },
      'source' => official_source('計算 6'),
    },
  ],
)

append_questions(
  File.join(ROOT, 'assets/questions/logic/grade1_foundation.logic.v1.json'),
  [
    {
      'id' => 'logic_grade1_foundation_044',
      'topic' => 'logic',
      'subtopic' => 'case_reasoning',
      'difficulty' => 'foundation',
      'levelStage' => 'grade1',
      'challengeTier' => 'foundation',
      'prompt' => {
        'zh-Hant' => '過年時三兄弟都拿到紅包。大哥說：「我的錢不少於 900 元，不大於 1000 元，而且是四位數。」二哥說：「我的錢是偶數，而且快要 1000 元了。」小弟說：「我的錢是奇數的三位數，而且小於 1000 元。」三兄弟的錢都接近 1000 元。誰的錢最多？',
        'zh-Hans' => '过年时三兄弟都拿到红包。大哥说：“我的钱不少于 900 元，不大于 1000 元，而且是四位数。”二哥说：“我的钱是偶数，而且快要 1000 元了。”小弟说：“我的钱是奇数的三位数，而且小于 1000 元。”三兄弟的钱都接近 1000 元。谁的钱最多？',
        'en' => 'Three brothers each received New Year money. The eldest says, “Mine is at least 900 and at most 1000, and it is a four-digit number.” The second says, “Mine is an even number and close to 1000.” The youngest says, “Mine is an odd three-digit number less than 1000.” All three amounts are close to 1000. Who has the most money?',
        'ja' => 'お正月に3兄弟がそれぞれお年玉をもらいました。長男は「ぼくの金額は 900 以上 1000 以下で、4けたの数だ」と言い、次男は「ぼくの金額は偶数で、1000 にかなり近い」と言い、三男は「ぼくの金額は 1000 未満の奇数の3けたの数だ」と言いました。3人とも金額は 1000 に近いとき、いちばん多いのはだれですか。',
      },
      'answer' => {
        'zh-Hant' => '答案是大哥。',
        'zh-Hans' => '答案是大哥。',
        'en' => 'The answer is the eldest brother.',
        'ja' => '答えは長男です。',
      },
      'solutionSteps' => {
        'zh-Hant' => [
          '大哥的錢在 900 到 1000 之間，還要是四位數，所以只能是 1000。',
          '二哥雖然接近 1000，但只知道是偶數，沒有說到 1000。',
          '小弟一定小於 1000，而且是三位數奇數。',
          '因此最大的一定是大哥。',
        ],
        'zh-Hans' => [
          '大哥的钱在 900 到 1000 之间，还要是四位数，所以只能是 1000。',
          '二哥虽然接近 1000，但只知道是偶数，没有说到 1000。',
          '小弟一定小于 1000，而且是三位数奇数。',
          '因此最大的一定是大哥。',
        ],
        'en' => [
          'The eldest brother’s amount is between 900 and 1000 and must be a four-digit number, so it can only be 1000.',
          'The second brother’s amount is even and near 1000, but it is not forced to be 1000.',
          'The youngest brother’s amount is an odd three-digit number, so it must be less than 1000.',
          'Therefore the eldest brother has the most money.',
        ],
        'ja' => [
          '長男のお金は 900 以上 1000 以下で、しかも 4 けたなので、1000 に決まります。',
          '次男は 1000 に近い偶数ですが、1000 とは限りません。',
          '三男は 1000 未満の3けたの奇数です。',
          'したがって、いちばん多いのは長男です。',
        ],
      },
      'figure' => { 'type' => 'custom', 'kind' => 'none', 'params' => {} },
      'answerMode' => 'multiple_choice',
      'options' => {
        'A' => { 'zh-Hant' => '大哥', 'zh-Hans' => '大哥', 'en' => 'Eldest', 'ja' => '長男' },
        'B' => { 'zh-Hant' => '二哥', 'zh-Hans' => '二哥', 'en' => 'Second brother', 'ja' => '次男' },
        'C' => { 'zh-Hant' => '小弟', 'zh-Hans' => '小弟', 'en' => 'Youngest', 'ja' => '三男' },
        'D' => { 'zh-Hant' => '無法判斷', 'zh-Hans' => '无法判断', 'en' => 'Cannot decide', 'ja' => '判断できない' },
      },
      'correctAnswer' => { 'type' => 'choice', 'value' => 'A' },
      'source' => official_source('計算 4'),
    },
    {
      'id' => 'logic_grade1_foundation_045',
      'topic' => 'logic',
      'subtopic' => 'pattern',
      'difficulty' => 'foundation',
      'levelStage' => 'grade1',
      'challengeTier' => 'foundation',
      'prompt' => {
        'zh-Hant' => '分類帽把所有人分成 A、B、C、D 四隊：抽到 1 號進 A 隊，2 號進 B 隊，3 號進 C 隊，4 號進 D 隊，5 號又回到 A 隊，照這個規律一直排下去。榮恩抽到 21 號。他被分到哪一隊？',
        'zh-Hans' => '分类帽把所有人分成 A、B、C、D 四队：抽到 1 号进 A 队，2 号进 B 队，3 号进 C 队，4 号进 D 队，5 号又回到 A 队，照这个规律一直排下去。荣恩抽到 21 号。他被分到哪一队？',
        'en' => 'A sorting hat assigns people to four teams A, B, C, and D: 1 goes to A, 2 to B, 3 to C, 4 to D, 5 back to A, and so on. Ron draws number 21. Which team is he assigned to?',
        'ja' => '組み分け帽子は A、B、C、D の4チームに分けます。1 番は A、2 番は B、3 番は C、4 番は D、5 番はまた A に入ります。この規則で続くとき、ロンが 21 番を引いたらどのチームになりますか。',
      },
      'answer' => {
        'zh-Hant' => '答案是 A 隊。',
        'zh-Hans' => '答案是 A 队。',
        'en' => 'The answer is Team A.',
        'ja' => '答えは A チームです。',
      },
      'solutionSteps' => {
        'zh-Hant' => [
          '每 4 個號碼會重複一次 A、B、C、D。',
          '21 除以 4 餘 1。',
          '餘 1 的號碼都分到 A 隊，所以 21 號在 A 隊。',
        ],
        'zh-Hans' => [
          '每 4 个号码会重复一次 A、B、C、D。',
          '21 除以 4 余 1。',
          '余 1 的号码都分到 A 队，所以 21 号在 A 队。',
        ],
        'en' => [
          'The pattern A, B, C, D repeats every 4 numbers.',
          'When 21 is divided by 4, the remainder is 1.',
          'Numbers with remainder 1 go to Team A, so 21 is in Team A.',
        ],
        'ja' => [
          'A、B、C、D の並びは 4 つごとにくり返します。',
          '21 を 4 で割ると余りは 1 です。',
          '余りが 1 の番号は A チームなので、21 番は A チームです。',
        ],
      },
      'figure' => { 'type' => 'custom', 'kind' => 'none', 'params' => {} },
      'answerMode' => 'multiple_choice',
      'options' => {
        'A' => { 'zh-Hant' => 'A 隊', 'zh-Hans' => 'A 队', 'en' => 'Team A', 'ja' => 'A チーム' },
        'B' => { 'zh-Hant' => 'B 隊', 'zh-Hans' => 'B 队', 'en' => 'Team B', 'ja' => 'B チーム' },
        'C' => { 'zh-Hant' => 'C 隊', 'zh-Hans' => 'C 队', 'en' => 'Team C', 'ja' => 'C チーム' },
        'D' => { 'zh-Hant' => 'D 隊', 'zh-Hans' => 'D 队', 'en' => 'Team D', 'ja' => 'D チーム' },
      },
      'correctAnswer' => { 'type' => 'choice', 'value' => 'A' },
      'source' => official_source('計算 8(1)'),
    },
    {
      'id' => 'logic_grade1_foundation_046',
      'topic' => 'logic',
      'subtopic' => 'selection',
      'difficulty' => 'foundation',
      'levelStage' => 'grade1',
      'challengeTier' => 'foundation',
      'prompt' => {
        'zh-Hant' => '沿用同一個分隊規則：A、B、C、D 每 4 個號碼循環一次。榮恩抽到 21 號，希望哈利和他同一隊。現在只剩下 24、29、40、34 四個號碼可選，哈利應該選哪一個？',
        'zh-Hans' => '沿用同一个分队规则：A、B、C、D 每 4 个号码循环一次。荣恩抽到 21 号，希望哈利和他同一队。现在只剩下 24、29、40、34 四个号码可选，哈利应该选哪一个？',
        'en' => 'Using the same team rule, A, B, C, D repeat every 4 numbers. Ron has 21 and Harry wants to be on the same team as Ron. The remaining choices are 24, 29, 40, and 34. Which number should Harry choose?',
        'ja' => '同じチーム分けの規則で、A、B、C、D は 4 つごとにくり返します。ロンは 21 番で、ハリーはロンと同じチームになりたいです。残っている番号が 24、29、40、34 のとき、ハリーはどれを選べばよいですか。',
      },
      'answer' => {
        'zh-Hant' => '答案是 29 號。',
        'zh-Hans' => '答案是 29 号。',
        'en' => 'The answer is 29.',
        'ja' => '答えは 29 番です。',
      },
      'solutionSteps' => {
        'zh-Hant' => [
          '榮恩的 21 除以 4 餘 1，所以在 A 隊。',
          '檢查剩下的號碼：24 餘 0、29 餘 1、40 餘 0、34 餘 2。',
          '只有 29 的餘數和 21 一樣都是 1。',
          '所以哈利要選 29 號。',
        ],
        'zh-Hans' => [
          '荣恩的 21 除以 4 余 1，所以在 A 队。',
          '检查剩下的号码：24 余 0、29 余 1、40 余 0、34 余 2。',
          '只有 29 的余数和 21 一样都是 1。',
          '所以哈利要选 29 号。',
        ],
        'en' => [
          'Ron’s number 21 leaves remainder 1 when divided by 4, so he is on Team A.',
          'Now check the choices: 24 leaves remainder 0, 29 leaves remainder 1, 40 leaves remainder 0, and 34 leaves remainder 2.',
          'Only 29 has the same remainder as 21.',
          'So Harry should choose 29.',
        ],
        'ja' => [
          'ロンの 21 は 4 で割ると余り 1 なので、A チームです。',
          '残りの番号を調べると、24 は余り 0、29 は余り 1、40 は余り 0、34 は余り 2 です。',
          '21 と同じ余り 1 になるのは 29 だけです。',
          'したがって、ハリーは 29 番を選びます。',
        ],
      },
      'figure' => { 'type' => 'custom', 'kind' => 'none', 'params' => {} },
      'answerMode' => 'multiple_choice',
      'options' => {
        'A' => { 'zh-Hant' => '24', 'zh-Hans' => '24', 'en' => '24', 'ja' => '24' },
        'B' => { 'zh-Hant' => '29', 'zh-Hans' => '29', 'en' => '29', 'ja' => '29' },
        'C' => { 'zh-Hant' => '40', 'zh-Hans' => '40', 'en' => '40', 'ja' => '40' },
        'D' => { 'zh-Hant' => '34', 'zh-Hans' => '34', 'en' => '34', 'ja' => '34' },
      },
      'correctAnswer' => { 'type' => 'choice', 'value' => 'B' },
      'source' => official_source('計算 8(3)'),
    },
  ],
)

puts 'Appended second official IMC 2015 grade1 preliminary batch.'
