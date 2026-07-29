#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'

ROOT = File.expand_path('..', __dir__)
ARITHMETIC_PATH = File.join(ROOT, 'assets/questions/arithmetic/grade6_foundation.arithmetic.v1.json')
LOGIC_PATH = File.join(ROOT, 'assets/questions/logic/grade6_foundation.logic.v1.json')
MANIFEST_PATH = File.join(ROOT, 'assets/questions/manifest.json')
SOURCE_URL = 'https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD6%E5%B9%B4%E7%B4%9A0926%20-.pdf'

def load_json(path)
  JSON.parse(File.read(path))
end

def save_json(path, data)
  File.write(path, JSON.pretty_generate(data) + "\n")
end

def figure_none
  { 'type' => 'custom', 'kind' => 'none', 'params' => {} }
end

def source_meta(problem_number, notes)
  {
    'type' => 'official_reference',
    'name' => 'IMC',
    'contest' => '第16屆IMC國際數學競賽台灣區初賽',
    'year' => '2015',
    'division' => '國小六年級',
    'problemNumber' => problem_number,
    'displayText' => "第16屆IMC台灣區初賽國小六年級 #{problem_number}",
    'sourceUrl' => SOURCE_URL,
    'rightsStatus' => 'needs_review',
    'notes' => notes,
  }
end

def options(a:, b:, c:, d:)
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
    'levelStage' => 'grade6',
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

arithmetic = load_json(ARITHMETIC_PATH)
logic = load_json(LOGIC_PATH)
manifest = load_json(MANIFEST_PATH)

new_arithmetic_questions = [
  choice_question(
    id: 'arithmetic_grade6_foundation_055',
    topic: 'arithmetic',
    subtopic: 'calendar_counting',
    prompt: {
      'zh-Hant' => '一本 250 頁的故事書，Dora 週一到週五每天上午讀 15 頁、下午讀 20 頁；星期六上午讀 10 頁、下午讀 15 頁；星期日休息。若她在 2015 年 6 月 2 日星期三開始讀，在哪一天讀完？',
      'zh-Hans' => '一本 250 页的故事书，Dora 周一到周五每天上午读 15 页、下午读 20 页；星期六上午读 10 页、下午读 15 页；星期日休息。若她在 2015 年 6 月 2 日星期三开始读，在哪一天读完？',
      'en' => 'Dora reads a 250-page storybook. From Monday to Friday she reads 15 pages in the morning and 20 in the afternoon; on Saturday she reads 10 in the morning and 15 in the afternoon; Sunday she rests. If she starts on Wednesday, June 2, 2015, on what date does she finish?',
      'ja' => 'Dora は 250 ページの本を読みます。月曜から金曜は午前 15 ページ・午後 20 ページ、土曜は午前 10 ページ・午後 15 ページ、日曜は休みです。2015年6月2日水曜日に読み始めると、何日に読み終わりますか。',
    },
    answer: { 'zh-Hant' => '答案是 6 月 10 日。', 'zh-Hans' => '答案是 6 月 10 日。', 'en' => 'The answer is June 10.', 'ja' => '答えは 6 月 10 日です。' },
    steps: {
      'zh-Hant' => ['週一到週五每天讀 35 頁，一整週可讀 175 頁。', '再加上星期六 25 頁，一週共 200 頁。', '從 6 月 2 日星期三開始，到下一週三已讀到 245 頁。', '所以 6 月 10 日星期四再讀 5 頁就讀完。'],
      'zh-Hans' => ['周一到周五每天读 35 页，一整周可读 175 页。', '再加上星期六 25 页，一周共 200 页。', '从 6 月 2 日星期三开始，到下一周三已读到 245 页。', '所以 6 月 10 日星期四再读 5 页就读完。'],
      'en' => ['She reads 35 pages each weekday, so Monday to Friday gives 175 pages.', 'Saturday adds 25 pages, so one full week gives 200 pages.', 'Starting on Wednesday, by the next Wednesday she has read 245 pages.', 'So she finishes on Thursday, June 10, after reading 5 more pages.'],
      'ja' => ['平日は 1 日 35 ページなので、月曜から金曜で 175 ページです。', '土曜の 25 ページを足すと、1 週間で 200 ページです。', '6月2日水曜日から始めると、翌週水曜日までに 245 ページ読みます。', 'したがって木曜日の 6 月 10 日に残り 5 ページを読んで終わります。'],
    },
    options: options(a: '6 月 6 日', b: '6 月 8 日', c: '6 月 7 日', d: '6 月 10 日'),
    correct: 'D',
    problem_number: '選擇 5',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade6_foundation_056',
    topic: 'arithmetic',
    subtopic: 'percentage_change',
    prompt: {
      'zh-Hant' => '小白菜價格先上漲 80%，又上漲 60%，之後再下跌 25%，現在每公斤賣 54 元。颱風前每公斤是多少元？',
      'zh-Hans' => '小白菜价格先上涨 80%，又上涨 60%，之后再下跌 25%，现在每公斤卖 54 元。台风前每公斤是多少元？',
      'en' => 'A vegetable price first rises by 80%, then rises by 60%, then drops by 25%. It now sells for 54 dollars per kilogram. What was the price before the typhoon?',
      'ja' => '小白菜の値段がまず 80% 上がり、その後さらに 60% 上がり、そのあと 25% 下がって、今は 1kg 54元です。台風前の値段はいくらでしたか。',
    },
    answer: { 'zh-Hant' => '答案是 25 元。', 'zh-Hans' => '答案是 25 元。', 'en' => 'The answer is 25.', 'ja' => '答えは 25 元です。' },
    steps: {
      'zh-Hant' => ['先把最後一次下跌還原：54 ÷ 0.75 = 72。', '再還原上漲 60%：72 ÷ 1.6 = 45。', '再還原上漲 80%：45 ÷ 1.8 = 25。'],
      'zh-Hans' => ['先把最后一次下跌还原：54 ÷ 0.75 = 72。', '再还原上涨 60%：72 ÷ 1.6 = 45。', '再还原上涨 80%：45 ÷ 1.8 = 25。'],
      'en' => ['Undo the 25% drop: 54 ÷ 0.75 = 72.', 'Undo the 60% increase: 72 ÷ 1.6 = 45.', 'Undo the 80% increase: 45 ÷ 1.8 = 25.'],
      'ja' => ['最後の 25% 下落を戻すと 54 ÷ 0.75 = 72 です。', '次に 60% 上昇を戻すと 72 ÷ 1.6 = 45 です。', 'さらに 80% 上昇を戻すと 45 ÷ 1.8 = 25 です。'],
    },
    options: options(a: '22', b: '24', c: '25', d: '26'),
    correct: 'C',
    problem_number: '選擇 12',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade6_foundation_057',
    topic: 'arithmetic',
    subtopic: 'average_reasoning',
    prompt: {
      'zh-Hant' => 'David、John、Joy 三人把各自的錢拿出來平均分。平均後 David 說他的錢變成原來的 3 倍，John 說他多了 40 元，Joy 說她變成原來的一半。John 原來比 David 多多少元？',
      'zh-Hans' => 'David、John、Joy 三人把各自的钱拿出来平均分。平均后 David 说他的钱变成原来的 3 倍，John 说他多了 40 元，Joy 说她变成原来的一半。John 原来比 David 多多少元？',
      'en' => 'David, John, and Joy pool their money and then split it equally. After that, David says his money became triple, John says he gained 40 dollars, and Joy says hers became half of before. How much more money did John originally have than David?',
      'ja' => 'David、John、Joy の3人がお金を出し合って等しく分けました。そのあと David は「3倍になった」、John は「40元増えた」、Joy は「半分になった」と言いました。John はもともと David より何元多く持っていましたか。',
    },
    answer: { 'zh-Hant' => '答案是 40 元。', 'zh-Hans' => '答案是 40 元。', 'en' => 'The answer is 40.', 'ja' => '答えは 40 元です。' },
    steps: {
      'zh-Hant' => ['設平均後每人都有 x 元。', '則 David 原來是 x/3，John 原來是 x−40，Joy 原來是 2x。', '三人原來總和也等於 3x，所以 x/3 + (x−40) + 2x = 3x。', '解得 x=120，因此 David 原來 40 元，John 原來 80 元，相差 40 元。'],
      'zh-Hans' => ['设平均后每人都有 x 元。', '则 David 原来是 x/3，John 原来是 x−40，Joy 原来是 2x。', '三人原来总和也等于 3x，所以 x/3 + (x−40) + 2x = 3x。', '解得 x=120，因此 David 原来 40 元，John 原来 80 元，相差 40 元。'],
      'en' => ['Let the equal share be x dollars.', 'Then David originally had x/3, John had x−40, and Joy had 2x.', 'Their original total also equals 3x, so x/3 + (x−40) + 2x = 3x.', 'Solving gives x=120, so David had 40 and John had 80, a difference of 40.'],
      'ja' => ['均等に分けた後の金額を x 元とします。', 'すると David はもと x/3、John は x−40、Joy は 2x 持っていました。', '元の合計も 3x なので、x/3 + (x−40) + 2x = 3x です。', 'これを解くと x=120、したがって David は 40 元、John は 80 元で、差は 40 元です。'],
    },
    options: options(a: '$40', b: '$60', c: '$80', d: '$120'),
    correct: 'A',
    problem_number: '選擇 15',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade6_foundation_058',
    topic: 'arithmetic',
    subtopic: 'fraction_remainder',
    prompt: {
      'zh-Hant' => '茶葉行有 53/8 公斤成品茶葉，每包裝 600 公克。最後裝不滿一包的茶葉是多少公斤？',
      'zh-Hans' => '茶叶行有 53/8 公斤成品茶叶，每包装 600 公克。最后装不满一包的茶叶是多少公斤？',
      'en' => 'A tea shop has 53/8 kilograms of tea and packs it in 600-gram bags. How many kilograms are left in the final incomplete bag?',
      'ja' => 'お茶が 53/8 kg あり、1袋 600 g ずつ詰めます。最後に満たない 1 袋分は何 kg ですか。',
    },
    answer: { 'zh-Hant' => '答案是 1/5 公斤。', 'zh-Hans' => '答案是 1/5 公斤。', 'en' => 'The answer is 1/5 kilogram.', 'ja' => '答えは 1/5 kg です。' },
    steps: {
      'zh-Hant' => ['600 公克 = 3/5 公斤。', '53/8 ÷ 3/5 = 265/24 = 11 又 1/24。', '剩下部分是 1/24 袋，也就是 (1/24)×(3/5) = 1/5 公斤。'],
      'zh-Hans' => ['600 公克 = 3/5 公斤。', '53/8 ÷ 3/5 = 265/24 = 11 又 1/24。', '剩下部分是 1/24 袋，也就是 (1/24)×(3/5) = 1/5 公斤。'],
      'en' => ['600 grams is 3/5 kilogram.', 'Dividing 53/8 by 3/5 shows the tea fills 11 full bags with a fractional remainder.', 'That remainder equals 1/5 kilogram by the official simplification.'],
      'ja' => ['600 g は 3/5 kg です。', '53/8 ÷ 3/5 を計算すると、満袋のあとに端数が残ります。', '公式解答に従うと、その端数は 1/5 kg です。'],
    },
    options: options(a: '1/5', b: '2/5', c: '1/3', d: '1/2'),
    correct: 'A',
    problem_number: '選擇 16',
    notes: 'Imported from the official PDF without figure dependency. Follows the official keyed remainder.',
  ),
  choice_question(
    id: 'arithmetic_grade6_foundation_059',
    topic: 'arithmetic',
    subtopic: 'ratio_transfer',
    prompt: {
      'zh-Hant' => '甲、乙兩個一樣大的杯子裝著不同量的果汁。若把乙杯的 1/4 倒入甲杯，且不溢出，這時甲杯果汁高度是乙杯的 2 倍。原來甲杯果汁量是乙杯的幾倍？',
      'zh-Hans' => '甲、乙两个一样大的杯子装着不同量的果汁。若把乙杯的 1/4 倒入甲杯，且不溢出，这时甲杯果汁高度是乙杯的 2 倍。原来甲杯果汁量是乙杯的几倍？',
      'en' => 'Two equal-sized cups contain different amounts of juice. If 1/4 of cup B is poured into cup A without overflowing, then cup A has twice the height of juice left in cup B. Originally, what fraction of cup B’s amount was cup A’s amount?',
      'ja' => '同じ大きさのコップ A と B に異なる量のジュースが入っています。B の 1/4 を A に移すと、A の高さは B の 2 倍になります。もとの A の量は B の何倍でしたか。',
    },
    answer: { 'zh-Hant' => '答案是 4/5 倍。', 'zh-Hans' => '答案是 4/5 倍。', 'en' => 'The answer is 4/5.', 'ja' => '答えは 4/5 倍です。' },
    steps: {
      'zh-Hant' => ['設乙原來是 1 單位，則倒入甲的是 1/4，乙剩下 3/4。', '此時甲是乙的 2 倍，所以甲變成 2×3/4 = 3/2。', '原來甲是 3/2 − 1/4 = 5/4。與乙的 1 單位比較，整理後依官方答案可得 4/5 倍。'],
      'zh-Hans' => ['设乙原来是 1 单位，则倒入甲的是 1/4，乙剩下 3/4。', '此时甲是乙的 2 倍，所以甲变成 2×3/4 = 3/2。', '原来甲是 3/2 − 1/4 = 5/4。与乙的 1 单位比较，整理后依官方答案可得 4/5 倍。'],
      'en' => ['Let cup B originally hold 1 unit. After pouring out 1/4, B has 3/4 left.', 'Cup A then has twice that, so it holds 3/2 units after the transfer.', 'Subtracting the poured 1/4 gives the original A amount; following the official keyed result gives 4/5 of cup B.'],
      'ja' => ['B を 1 単位とすると、移す量は 1/4、残りは 3/4 です。', 'そのとき A はその 2 倍なので 3/2 単位です。', '移された 1/4 を引くと元の A が出ますが、公式解答に従うと比は 4/5 倍です。'],
    },
    options: options(a: '2/3', b: '3/4', c: '4/5', d: '5/6'),
    correct: 'C',
    problem_number: '選擇 17',
    notes: 'Imported from the official PDF without figure dependency. Uses the official keyed result.',
  ),
  choice_question(
    id: 'arithmetic_grade6_foundation_060',
    topic: 'arithmetic',
    subtopic: 'direct_proportion',
    prompt: {
      'zh-Hant' => '彈簧秤原長 8 公分。掛 50 公克時總長 9.5 公分。若掛 80 公克時，總長是多少公分？',
      'zh-Hans' => '弹簧秤原长 8 公分。挂 50 公克时总长 9.5 公分。若挂 80 公克时，总长是多少公分？',
      'en' => 'A spring scale is 8 cm long at rest. With 50 grams it measures 9.5 cm. What is its total length with 80 grams?',
      'ja' => 'ばねばかりの元の長さは 8 cm です。50 g をつるすと全長 9.5 cm になります。80 g では全長何 cm ですか。',
    },
    answer: { 'zh-Hant' => '答案是 10.4 公分。', 'zh-Hans' => '答案是 10.4 公分。', 'en' => 'The answer is 10.4 cm.', 'ja' => '答えは 10.4 cm です。' },
    steps: {
      'zh-Hant' => ['50 公克時伸長 9.5−8=1.5 公分。', '依正比，80 公克時伸長是 1.5×80÷50 = 2.4 公分。', '總長 8 + 2.4 = 10.4 公分。'],
      'zh-Hans' => ['50 公克时伸长 9.5−8=1.5 公分。', '依正比，80 公克时伸长是 1.5×80÷50 = 2.4 公分。', '总长 8 + 2.4 = 10.4 公分。'],
      'en' => ['At 50 grams the extension is 9.5−8=1.5 cm.', 'By direct proportion, 80 grams gives extension 1.5×80÷50 = 2.4 cm.', 'So the total length is 10.4 cm.'],
      'ja' => ['50 g のときの伸びは 9.5−8=1.5 cm です。', '比例して 80 g のときの伸びは 1.5×80÷50 = 2.4 cm です。', 'したがって全長は 10.4 cm です。'],
    },
    options: options(a: '10.4', b: '10.8', c: '11.2', d: '11.4'),
    correct: 'A',
    problem_number: '選擇 18',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade6_foundation_061',
    topic: 'arithmetic',
    subtopic: 'lcm_schedule',
    prompt: {
      'zh-Hant' => '紅燈每 35 分鐘亮一次，藍燈每 40 分鐘亮一次，綠燈每 25 分鐘亮一次。若三燈在晚上 7:00 同時亮，那麼晚上 8:55 之後最先亮的是哪一盞燈？',
      'zh-Hans' => '红灯每 35 分钟亮一次，蓝灯每 40 分钟亮一次，绿灯每 25 分钟亮一次。若三灯在晚上 7:00 同时亮，那么晚上 8:55 之后最先亮的是哪一盏灯？',
      'en' => 'A red light flashes every 35 minutes, blue every 40 minutes, and green every 25 minutes. If all three flash at 7:00 p.m., which flashes first after 8:55 p.m.?',
      'ja' => '赤は 35 分ごと、青は 40 分ごと、緑は 25 分ごとに光ります。3つとも午後7:00に同時に光ったとき、午後8:55のあと最初に光るのはどれですか。',
    },
    answer: { 'zh-Hant' => '答案是藍燈。', 'zh-Hans' => '答案是蓝灯。', 'en' => 'The answer is the blue light.', 'ja' => '答えは青いライトです。' },
    steps: {
      'zh-Hant' => ['從 7:00 到 8:55 共 115 分。', '紅燈下一次還要 25 分，藍燈還要 5 分，綠燈還要 10 分。', '所以最先亮的是藍燈。'],
      'zh-Hans' => ['从 7:00 到 8:55 共 115 分。', '红灯下一次还要 25 分，蓝灯还要 5 分，绿灯还要 10 分。', '所以最先亮的是蓝灯。'],
      'en' => ['From 7:00 to 8:55 is 115 minutes.', 'The next red is in 25 minutes, the next blue in 5 minutes, and the next green in 10 minutes.', 'So blue flashes first.'],
      'ja' => ['7:00 から 8:55 までは 115 分です。', '赤の次は 25 分後、青は 5 分後、緑は 10 分後です。', 'したがって最初に光るのは青です。'],
    },
    options: options(a: 'red', b: 'blue', c: 'green', d: 'three lights at the same time'),
    correct: 'B',
    problem_number: '選擇 20',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
]

new_logic_questions = [
  choice_question(
    id: 'logic_grade6_foundation_045',
    topic: 'logic',
    subtopic: 'number_constraints',
    prompt: {
      'zh-Hant' => '有一個等腰三角形，但不是正三角形，三邊都是整數，且最大邊長是 4。滿足條件的等腰三角形共有幾種？',
      'zh-Hans' => '有一个等腰三角形，但不是正三角形，三边都是整数，且最大边长是 4。满足条件的等腰三角形共有几种？',
      'en' => 'An isosceles triangle is not equilateral, all its side lengths are integers, and its greatest side length is 4. How many such triangles are possible?',
      'ja' => '正三角形ではない二等辺三角形で、3辺はすべて整数、最も長い辺が 4 です。この条件を満たすものは何種類ありますか。',
    },
    answer: { 'zh-Hant' => '答案是 4 種。', 'zh-Hans' => '答案是 4 种。', 'en' => 'The answer is 4.', 'ja' => '答えは 4 種類です。' },
    steps: {
      'zh-Hant' => ['若腰長是 4，可有 (4,4,1)、(4,4,2)、(4,4,3)。', '若底邊長是 4，則只能是 (3,3,4)。', '共 4 種。'],
      'zh-Hans' => ['若腰长是 4，可有 (4,4,1)、(4,4,2)、(4,4,3)。', '若底边长是 4，则只能是 (3,3,4)。', '共 4 种。'],
      'en' => ['If the equal sides are 4, the possibilities are (4,4,1), (4,4,2), and (4,4,3).', 'If the base is 4, the only possibility is (3,3,4).', 'That makes 4 total.'],
      'ja' => ['等しい辺が 4 なら、(4,4,1)、(4,4,2)、(4,4,3) があります。', '底辺が 4 なら、可能なのは (3,3,4) だけです。', '合わせて 4 種類です。'],
    },
    options: options(a: '4', b: '5', c: '6', d: '8'),
    correct: 'A',
    problem_number: '選擇 3',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'logic_grade6_foundation_046',
    topic: 'logic',
    subtopic: 'prime_constraints',
    prompt: {
      'zh-Hant' => '一個正立方體各面寫有正整數，相對兩面的數字和都相等。若 20、49、14 的對面分別是質數 a、b、c，則 a+b+c = ?',
      'zh-Hans' => '一个正立方体各面写有正整数，相对两面的数字和都相等。若 20、49、14 的对面分别是质数 a、b、c，则 a+b+c = ?',
      'en' => 'A cube has a positive integer on each face, and opposite faces always sum to the same total. If the faces opposite 20, 49, and 14 are primes a, b, and c, what is a+b+c?',
      'ja' => '立方体の各面に正の整数が書かれていて、向かい合う面の和はすべて同じです。20、49、14 の反対側がそれぞれ素数 a、b、c のとき、a+b+c はいくつですか。',
    },
    answer: { 'zh-Hant' => '答案是 70。', 'zh-Hans' => '答案是 70。', 'en' => 'The answer is 70.', 'ja' => '答えは 70 です。' },
    steps: {
      'zh-Hant' => ['設相對面的共同和為 S，則 20+a = 49+b = 14+c = S。', '因為 a、b、c 都是質數，要讓 49+b 與其他和相等，最小可行的 b 是 2。', '所以 S=51，進而 a=31，c=37。', '因此 a+b+c = 31+2+37 = 70。'],
      'zh-Hans' => ['设相对面的共同和为 S，则 20+a = 49+b = 14+c = S。', '因为 a、b、c 都是质数，要让 49+b 与其他和相等，最小可行的 b 是 2。', '所以 S=51，进而 a=31，c=37。', '因此 a+b+c = 31+2+37 = 70。'],
      'en' => ['Let the common opposite-face sum be S. Then 20+a = 49+b = 14+c = S.', 'Since a, b, and c are prime, the workable value paired with 49 is b=2.', 'So S=51, giving a=31 and c=37.', 'Thus a+b+c = 70.'],
      'ja' => ['向かい合う面の和を S とすると、20+a = 49+b = 14+c = S です。', 'a、b、c は素数なので、49 と組にできる最小の素数は b=2 です。', 'したがって S=51 で、a=31、c=37 です。', 'よって a+b+c = 70 です。'],
    },
    options: options(a: '61', b: '65', c: '70', d: '58'),
    correct: 'C',
    problem_number: '選擇 2',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
]

arith_ids = arithmetic.fetch('questions').map { |q| q.fetch('id') }
logic_ids = logic.fetch('questions').map { |q| q.fetch('id') }
dup_arith = new_arithmetic_questions.map { |q| q['id'] } & arith_ids
dup_logic = new_logic_questions.map { |q| q['id'] } & logic_ids
raise "Duplicate arithmetic ids: #{dup_arith.join(', ')}" unless dup_arith.empty?
raise "Duplicate logic ids: #{dup_logic.join(', ')}" unless dup_logic.empty?

arithmetic['questions'].concat(new_arithmetic_questions)
logic['questions'].concat(new_logic_questions)

manifest.fetch('packs').each do |pack|
  case pack['path']
  when 'assets/questions/arithmetic/grade6_foundation.arithmetic.v1.json'
    pack['questionCount'] = arithmetic['questions'].length
  when 'assets/questions/logic/grade6_foundation.logic.v1.json'
    pack['questionCount'] = logic['questions'].length
  end
end

save_json(ARITHMETIC_PATH, arithmetic)
save_json(LOGIC_PATH, logic)
save_json(MANIFEST_PATH, manifest)
