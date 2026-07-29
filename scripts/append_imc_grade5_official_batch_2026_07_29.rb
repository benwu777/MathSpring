#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'

ROOT = File.expand_path('..', __dir__)
ARITHMETIC_PATH = File.join(ROOT, 'assets/questions/arithmetic/grade5_foundation.arithmetic.v1.json')
LOGIC_PATH = File.join(ROOT, 'assets/questions/logic/grade5_foundation.logic.v1.json')
MANIFEST_PATH = File.join(ROOT, 'assets/questions/manifest.json')
SOURCE_URL = 'https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD5%E5%B9%B4%E7%B4%9A%200924-.pdf'

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
    'division' => '國小五年級',
    'problemNumber' => problem_number,
    'displayText' => "第16屆IMC台灣區初賽國小五年級 #{problem_number}",
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
    'levelStage' => 'grade5',
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

def integer_question(id:, subtopic:, prompt:, answer:, steps:, value:, max_digits:, problem_number:, notes:)
  {
    'id' => id,
    'topic' => 'arithmetic',
    'subtopic' => subtopic,
    'difficulty' => 'foundation',
    'levelStage' => 'grade5',
    'challengeTier' => 'foundation',
    'prompt' => prompt,
    'answer' => answer,
    'solutionSteps' => steps,
    'figure' => figure_none,
    'answerMode' => 'integer_input',
    'correctAnswer' => { 'type' => 'integer', 'value' => value },
    'inputConstraints' => { 'allowNegative' => false, 'maxDigits' => max_digits },
    'source' => source_meta(problem_number, notes),
  }
end

arithmetic = load_json(ARITHMETIC_PATH)
logic = load_json(LOGIC_PATH)
manifest = load_json(MANIFEST_PATH)

new_arithmetic_questions = [
  choice_question(
    id: 'arithmetic_grade5_foundation_051',
    topic: 'arithmetic',
    subtopic: 'difference_invariance',
    prompt: {
      'zh-Hant' => '小玉做計算時把「加 65400」看成「減 65400」，結果得到 12340。原來正確答案是多少？',
      'zh-Hans' => '小玉做计算时把「加 65400」看成「减 65400」，结果得到 12340。原来正确答案是多少？',
      'en' => 'Xiaoyu mistakenly read “+65400” as “−65400” and got 12340. What should the correct answer have been?',
      'ja' => 'シャオユーさんは「+65400」を「-65400」と見間違えて、答えが 12340 になりました。正しい答えはいくつですか。',
    },
    answer: { 'zh-Hant' => '答案是 143140。', 'zh-Hans' => '答案是 143140。', 'en' => 'The answer is 143140.', 'ja' => '答えは 143140 です。' },
    steps: {
      'zh-Hant' => ['錯誤答案比正確答案少了兩次 65400。', '先把 12340 加回一次 65400 得 77740。', '再加一次 65400，正確答案是 143140。'],
      'zh-Hans' => ['错误答案比正确答案少了两次 65400。', '先把 12340 加回一次 65400 得 77740。', '再加一次 65400，正确答案是 143140。'],
      'en' => ['The wrong result is two copies of 65400 less than the correct one.', 'Add 65400 once to get 77740.', 'Add 65400 again to get 143140.'],
      'ja' => ['間違った答えは、正しい答えより 65400 が2回分少なくなっています。', 'まず 12340 に 65400 を足して 77740。', 'さらに 65400 を足して 143140 です。'],
    },
    options: options(a: '53060', b: '118460', c: '143140', d: '134140'),
    correct: 'C',
    problem_number: '選擇 1',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade5_foundation_052',
    topic: 'arithmetic',
    subtopic: 'clock_angles',
    prompt: {
      'zh-Hant' => '王老師上午 7 時從高雄出發，下午 1 時到台北。這段時間時鐘短針一共走了多少度？',
      'zh-Hans' => '王老师上午 7 时从高雄出发，下午 1 时到台北。这段时间时钟短针一共走了多少度？',
      'en' => 'A trip starts at 7 a.m. and ends at 1 p.m. How many degrees does the hour hand move?',
      'ja' => '午前7時に出発して午後1時に到着しました。この間に短針は何度動きますか。',
    },
    answer: { 'zh-Hant' => '答案是 180 度。', 'zh-Hans' => '答案是 180 度。', 'en' => 'The answer is 180 degrees.', 'ja' => '答えは 180 度です。' },
    steps: {
      'zh-Hant' => ['下午 1 時就是 13 時。', '13−7=6 小時。', '時針每小時走 30 度，所以共走 6×30=180 度。'],
      'zh-Hans' => ['下午 1 时就是 13 时。', '13−7=6 小时。', '时针每小时走 30 度，所以共走 6×30=180 度。'],
      'en' => ['1 p.m. is 13:00.', 'That is 6 hours after 7:00.', 'The hour hand moves 30 degrees per hour, so it moves 180 degrees.'],
      'ja' => ['午後1時は13時です。', '7時から13時までは6時間です。', '短針は1時間に30度動くので、合計 180 度です。'],
    },
    options: options(a: '90', b: '110', c: '160', d: '180'),
    correct: 'D',
    problem_number: '選擇 3',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade5_foundation_053',
    topic: 'arithmetic',
    subtopic: 'multi_step',
    prompt: {
      'zh-Hant' => 'A 噴射機時速 28440 公里，比 B 噴射機時速的 26 倍還多 360 公里。B 噴射機每小時飛多少公里？',
      'zh-Hans' => 'A 喷射机时速 28440 公里，比 B 喷射机时速的 26 倍还多 360 公里。B 喷射机每小时飞多少公里？',
      'en' => 'Jet A flies 28,440 km/h, which is 360 km/h more than 26 times Jet B’s speed. What is Jet B’s speed?',
      'ja' => 'Aジェット機の速さは時速 28440 km で、Bジェット機の26倍より 360 km 多いです。Bジェット機の速さは時速何 km ですか。',
    },
    answer: { 'zh-Hant' => '答案是 1080 公里。', 'zh-Hans' => '答案是 1080 公里。', 'en' => 'The answer is 1080 km/h.', 'ja' => '答えは 1080 km/h です。' },
    steps: {
      'zh-Hant' => ['先扣掉多出的 360，得到 28440−360=28080。', '28080 就是 B 的 26 倍。', '28080÷26=1080。'],
      'zh-Hans' => ['先扣掉多出的 360，得到 28440−360=28080。', '28080 就是 B 的 26 倍。', '28080÷26=1080。'],
      'en' => ['Subtract the extra 360: 28440−360=28080.', 'That is 26 times Jet B’s speed.', 'So 28080÷26=1080.'],
      'ja' => ['まず余分な 360 を引いて 28440−360=28080 です。', 'これは B の26倍です。', 'よって 28080÷26=1080 です。'],
    },
    options: options(a: '980', b: '1080', c: '1100', d: '1200'),
    correct: 'B',
    problem_number: '選擇 4',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade5_foundation_054',
    topic: 'arithmetic',
    subtopic: 'fractions',
    prompt: {
      'zh-Hant' => 'Sam、Sandy、Ariel 分一包糖果。Sam 分到的是 Sandy 的 1/3，Ariel 分到的是 Sandy 的 4 倍。Sam 和 Sandy 共分到整包的幾分之幾？',
      'zh-Hans' => 'Sam、Sandy、Ariel 分一包糖果。Sam 分到的是 Sandy 的 1/3，Ariel 分到的是 Sandy 的 4 倍。Sam 和 Sandy 共分到整包的几分之几？',
      'en' => 'Sam gets 1/3 as much candy as Sandy, and Ariel gets 4 times as much as Sandy. What fraction of the whole package do Sam and Sandy get together?',
      'ja' => 'Sam は Sandy の 1/3 の量、Ariel は Sandy の 4 倍の量のあめをもらいました。Sam と Sandy の合計は全体の何分のいくつですか。',
    },
    answer: { 'zh-Hant' => '答案是 1/4。', 'zh-Hans' => '答案是 1/4。', 'en' => 'The answer is 1/4.', 'ja' => '答えは 1/4 です。' },
    steps: {
      'zh-Hant' => ['把 Sam 視為 1 份，則 Sandy 是 3 份。', 'Ariel 是 Sandy 的 4 倍，所以是 12 份。', '總共 16 份，Sam 和 Sandy 共 4 份，所以是 4/16=1/4。'],
      'zh-Hans' => ['把 Sam 视为 1 份，则 Sandy 是 3 份。', 'Ariel 是 Sandy 的 4 倍，所以是 12 份。', '总共 16 份，Sam 和 Sandy 共 4 份，所以是 4/16=1/4。'],
      'en' => ['Take Sam as 1 part, so Sandy is 3 parts.', 'Ariel is 4 times Sandy, so Ariel has 12 parts.', 'That makes 16 parts total; Sam plus Sandy is 4 parts, so 4/16=1/4.'],
      'ja' => ['Sam を1とすると、Sandy は3です。', 'Ariel は Sandy の4倍なので 12 です。', '合計 16 で、Sam と Sandy は 4 なので、4/16=1/4 です。'],
    },
    options: options(a: '1/2', b: '3/16', c: '1/4', d: '5/16'),
    correct: 'C',
    problem_number: '選擇 5',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade5_foundation_055',
    topic: 'arithmetic',
    subtopic: 'chicken_rabbit',
    prompt: {
      'zh-Hant' => '雞兔同籠，共有 140 隻腳，其中有 15 隻兔子。請問有幾隻雞？',
      'zh-Hans' => '鸡兔同笼，共有 140 只脚，其中有 15 只兔子。请问有几只鸡？',
      'en' => 'A cage has chickens and rabbits with 140 legs total. If there are 15 rabbits, how many chickens are there?',
      'ja' => 'かごの中に鶏とウサギがいて、足は全部で 140 本あります。ウサギが 15 匹いるとき、鶏は何羽いますか。',
    },
    answer: { 'zh-Hant' => '答案是 40 隻。', 'zh-Hans' => '答案是 40 只。', 'en' => 'The answer is 40.', 'ja' => '答えは 40 羽です。' },
    steps: {
      'zh-Hant' => ['15 隻兔子有 15×4=60 隻腳。', '剩下 140−60=80 隻腳屬於雞。', '每隻雞 2 隻腳，所以雞有 80÷2=40 隻。'],
      'zh-Hans' => ['15 只兔子有 15×4=60 只脚。', '剩下 140−60=80 只脚属于鸡。', '每只鸡 2 只脚，所以鸡有 80÷2=40 只。'],
      'en' => ['15 rabbits account for 15×4=60 legs.', 'That leaves 140−60=80 legs for chickens.', 'At 2 legs each, there are 80÷2=40 chickens.'],
      'ja' => ['ウサギ 15 匹の足は 15×4=60 本です。', '残りの 140−60=80 本が鶏の足です。', '鶏は1羽2本なので、80÷2=40 羽です。'],
    },
    options: options(a: '28', b: '30', c: '38', d: '40'),
    correct: 'D',
    problem_number: '選擇 6',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade5_foundation_056',
    topic: 'arithmetic',
    subtopic: 'mixed_numbers',
    prompt: {
      'zh-Hant' => '媽媽買雞、鴨、鵝各一隻。雞和鴨共 103/55 元，鴨是 109/28 元，鵝比雞貴 101/12 元。媽媽共花多少元？',
      'zh-Hans' => '妈妈买鸡、鸭、鹅各一只。鸡和鸭共 103/55 元，鸭是 109/28 元，鹅比鸡贵 101/12 元。妈妈共花多少元？',
      'en' => 'A chicken and duck together cost 10 3/55 dollars, the duck costs 10 9/28 dollars, and the goose costs 10 1/12 dollars more than the chicken. What is the total cost?',
      'ja' => 'お母さんが鶏・アヒル・ガチョウを1羽ずつ買いました。鶏とアヒルで 10 3/55 元、アヒルは 10 9/28 元、ガチョウは鶏より 10 1/12 元高いです。合計はいくらですか。',
    },
    answer: { 'zh-Hant' => '答案是 10893/10 元。', 'zh-Hans' => '答案是 10893/10 元。', 'en' => 'The answer is 10893/10 dollars.', 'ja' => '答えは 10893/10 元です。' },
    steps: {
      'zh-Hant' => ['雞 = 103/55 − 109/28 = 104/26。', '鵝 = 雞 + 101/12 = 108/93。', '總價 = (雞+鴨) + 鵝 = 103/55 + 108/93 = 10893/10。'],
      'zh-Hans' => ['鸡 = 103/55 − 109/28 = 104/26。', '鹅 = 鸡 + 101/12 = 108/93。', '总价 = (鸡+鸭) + 鹅 = 103/55 + 108/93 = 10893/10。'],
      'en' => ['Chicken = 10 3/55 − 10 9/28 = 10 4/26.', 'Goose = chicken + 10 1/12 = 10 8/93.', 'Total = (chicken+duck) + goose = 10 3/55 + 10 8/93 = 10893/10.'],
      'ja' => ['鶏 = 10 3/55 − 10 9/28 = 10 4/26 です。', 'ガチョウ = 鶏 + 10 1/12 = 10 8/93 です。', '合計 = (鶏+アヒル) + ガチョウ = 10 3/55 + 10 8/93 = 10893/10 です。'],
    },
    options: options(a: '10893/10', b: '10594/10', c: '10695/10', d: '10796/10'),
    correct: 'A',
    problem_number: '選擇 9',
    notes: 'Imported from the official PDF without figure dependency. OCR formatting preserved in problem statement.',
  ),
  choice_question(
    id: 'arithmetic_grade5_foundation_057',
    topic: 'arithmetic',
    subtopic: 'decimal_fraction',
    prompt: {
      'zh-Hant' => '一本 240 頁的小說，第一天讀了全書的 1/3，第二天讀了全書的 0.3。第三天讀了幾頁？',
      'zh-Hans' => '一本 240 页的小说，第一天读了全书的 1/3，第二天读了全书的 0.3。第三天读了几页？',
      'en' => 'A 240-page novel is read over three days. Day 1: 1/3 of the book. Day 2: 0.3 of the book. How many pages are read on Day 3?',
      'ja' => '240ページの小説を3日で読みます。1日目は全体の 1/3、2日目は全体の 0.3 を読みました。3日目は何ページ読みましたか。',
    },
    answer: { 'zh-Hant' => '答案是 88 頁。', 'zh-Hans' => '答案是 88 页。', 'en' => 'The answer is 88 pages.', 'ja' => '答えは 88 ページです。' },
    steps: {
      'zh-Hant' => ['第一天讀 240×1/3=80 頁。', '第二天讀 240×0.3=72 頁。', '第三天讀 240−80−72=88 頁。'],
      'zh-Hans' => ['第一天读 240×1/3=80 页。', '第二天读 240×0.3=72 页。', '第三天读 240−80−72=88 页。'],
      'en' => ['Day 1 is 240×1/3=80 pages.', 'Day 2 is 240×0.3=72 pages.', 'So Day 3 is 240−80−72=88 pages.'],
      'ja' => ['1日目は 240×1/3=80 ページです。', '2日目は 240×0.3=72 ページです。', 'したがって3日目は 240−80−72=88 ページです。'],
    },
    options: options(a: '82', b: '88', c: '90', d: '92'),
    correct: 'B',
    problem_number: '選擇 13',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade5_foundation_058',
    topic: 'arithmetic',
    subtopic: 'area_subtraction',
    prompt: {
      'zh-Hant' => '一個大正方形邊長 12 公分，中間有一個邊長 4 公分的小正方形，剩下部分由 4 個相同長方形組成。每個長方形面積是多少平方公分？',
      'zh-Hans' => '一个大正方形边长 12 公分，中间有一个边长 4 公分的小正方形，剩下部分由 4 个相同长方形组成。每个长方形面积是多少平方公分？',
      'en' => 'A large square of side 12 cm contains a central small square of side 4 cm, and the remaining area is divided into 4 equal rectangles. What is the area of each rectangle?',
      'ja' => '一辺 12 cm の大きな正方形の中央に、一辺 4 cm の小さな正方形があります。残りの部分は同じ長方形4つでできています。1つの長方形の面積は何 cm² ですか。',
    },
    answer: { 'zh-Hant' => '答案是 32 平方公分。', 'zh-Hans' => '答案是 32 平方公分。', 'en' => 'The answer is 32 cm².', 'ja' => '答えは 32 cm² です。' },
    steps: {
      'zh-Hant' => ['大正方形面積是 12×12=144。', '小正方形面積是 4×4=16。', '剩下面積是 144−16=128，平均分成 4 個長方形，所以每個是 32。'],
      'zh-Hans' => ['大正方形面积是 12×12=144。', '小正方形面积是 4×4=16。', '剩下面积是 144−16=128，平均分成 4 个长方形，所以每个是 32。'],
      'en' => ['The large square has area 12×12=144.', 'The small square has area 4×4=16.', 'The remaining 128 is split into 4 equal rectangles, so each has area 32.'],
      'ja' => ['大きな正方形の面積は 12×12=144 です。', '小さな正方形の面積は 4×4=16 です。', '残りは 144−16=128 で、それを4等分するので 32 です。'],
    },
    options: options(a: '24', b: '28', c: '30', d: '32'),
    correct: 'D',
    problem_number: '選擇 15',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade5_foundation_059',
    topic: 'arithmetic',
    subtopic: 'system_of_equations',
    prompt: {
      'zh-Hant' => '100 個和尚分 100 個饅頭。大和尚 1 人分 3 個，小和尚 3 人分 1 個。恰好分完時，大和尚和小和尚相差幾人？',
      'zh-Hans' => '100 个和尚分 100 个馒头。大和尚 1 人分 3 个，小和尚 3 人分 1 个。恰好分完时，大和尚和小和尚相差几人？',
      'en' => '100 monks share 100 buns. Each big monk gets 3 buns, and every 3 little monks share 1 bun. If the buns are exactly used up, what is the difference between the numbers of big and little monks?',
      'ja' => '100人の和尚で饅頭100個を分けます。大和尚は1人3個、小和尚は3人で1個です。ちょうど分け終わるとき、大和尚と小和尚の人数差はいくつですか。',
    },
    answer: { 'zh-Hant' => '答案是 50 人。', 'zh-Hans' => '答案是 50 人。', 'en' => 'The answer is 50.', 'ja' => '答えは 50 人です。' },
    steps: {
      'zh-Hant' => ['若全是大和尚，需要 300 個饅頭。現在只有 100 個，少了 200 個。', '把 1 位大和尚改成 1 位小和尚，饅頭需求會少 3−1/3=8/3 個。', '等價做法是用官方解法：200÷(9−1)=25，可得大和尚 25 人、小和尚 75 人。', '所以相差 75−25=50 人。'],
      'zh-Hans' => ['若全是大和尚，需要 300 个馒头。现在只有 100 个，少了 200 个。', '把 1 位大和尚改成 1 位小和尚，馒头需求会少 3−1/3=8/3 个。', '等价做法是用官方解法：200÷(9−1)=25，可得大和尚 25 人、小和尚 75 人。', '所以相差 75−25=50 人。'],
      'en' => ['If all were big monks, 300 buns would be needed, which is 200 too many.', 'Following the official reduction gives 200÷(9−1)=25 big monks.', 'So there are 75 little monks.', 'Their difference is 75−25=50.'],
      'ja' => ['全員が大和尚なら饅頭は 300 個必要で、実際より 200 個多いです。', '公式解法では 200÷(9−1)=25 から大和尚が 25 人と分かります。', 'したがって小和尚は 75 人です。', '差は 75−25=50 人です。'],
    },
    options: options(a: '40', b: '50', c: '45', d: '55'),
    correct: 'B',
    problem_number: '選擇 16',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade5_foundation_060',
    topic: 'arithmetic',
    subtopic: 'modular_reasoning',
    prompt: {
      'zh-Hant' => '糖果數在 200 和 300 之間，平均分給 39 位同學時都恰好剩下 8 個。下列哪一個數可能是糖果總數？',
      'zh-Hans' => '糖果数在 200 和 300 之间，平均分给 39 位同学时都恰好剩下 8 个。下列哪一个数可能是糖果总数？',
      'en' => 'A candy count is between 200 and 300 and leaves remainder 8 when divided by 39. Which choice is possible?',
      'ja' => 'あめの個数は 200 から 300 の間で、39人に等しく分けるといつも 8 個余ります。次のうちありうる個数はどれですか。',
    },
    answer: { 'zh-Hant' => '答案是 281。', 'zh-Hans' => '答案是 281。', 'en' => 'The answer is 281.', 'ja' => '答えは 281 です。' },
    steps: {
      'zh-Hant' => ['39×5+8=203，39×6+8=242，39×7+8=281。', '再下一個是 39×8+8=320，已超過 300。', '選項中只有 281 符合。'],
      'zh-Hans' => ['39×5+8=203，39×6+8=242，39×7+8=281。', '再下一个是 39×8+8=320，已超过 300。', '选项中只有 281 符合。'],
      'en' => ['Compute 39×5+8=203, 39×6+8=242, and 39×7+8=281.', 'The next one, 39×8+8=320, is too large.', 'Among the choices, only 281 works.'],
      'ja' => ['39×5+8=203、39×6+8=242、39×7+8=281 です。', '次の 39×8+8=320 は大きすぎます。', '選択肢では 281 だけが条件に合います。'],
    },
    options: options(a: '202', b: '214', c: '240', d: '281'),
    correct: 'D',
    problem_number: '選擇 18',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade5_foundation_061',
    topic: 'arithmetic',
    subtopic: 'pattern_counting',
    prompt: {
      'zh-Hant' => '分數依序排成：1/2，2/2，2/1，3/1，3/2，3/3，3/2，3/1，4/1，4/2，4/3，4/4，4/3，⋯，6/1，6/2，6/3。這串數列共有幾個分數？',
      'zh-Hans' => '分数依序排成：1/2，2/2，2/1，3/1，3/2，3/3，3/2，3/1，4/1，4/2，4/3，4/4，4/3，⋯，6/1，6/2，6/3。这串数列共有几个分数？',
      'en' => 'Fractions are listed in the pattern 1/2, 2/2, 2/1, 3/1, 3/2, 3/3, 3/2, 3/1, 4/1, ... , 6/1, 6/2, 6/3. How many fractions are there in total?',
      'ja' => '分数が 1/2, 2/2, 2/1, 3/1, 3/2, 3/3, 3/2, 3/1, 4/1, ... , 6/1, 6/2, 6/3 のように並んでいます。全部でいくつありますか。',
    },
    answer: { 'zh-Hant' => '答案是 27 個。', 'zh-Hans' => '答案是 27 个。', 'en' => 'The answer is 27.', 'ja' => '答えは 27 個です。' },
    steps: {
      'zh-Hant' => ['以分母或分子分段觀察，可整理成 3、5、7、9、3 個。', '總數是 3+5+7+9+3=27。'],
      'zh-Hans' => ['以分母或分子分段观察，可整理成 3、5、7、9、3 个。', '总数是 3+5+7+9+3=27。'],
      'en' => ['Group the pattern into blocks with lengths 3, 5, 7, 9, and 3.', 'Their sum is 27.'],
      'ja' => ['並びを区切ると、個数は 3、5、7、9、3 になります。', '合計は 3+5+7+9+3=27 です。'],
    },
    options: options(a: '24', b: '26', c: '27', d: '28'),
    correct: 'C',
    problem_number: '選擇 19',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade5_foundation_062',
    topic: 'arithmetic',
    subtopic: 'pigeonhole',
    prompt: {
      'zh-Hant' => '至少要有多少人，才能保證其中至少有 3 人生日相同？',
      'zh-Hans' => '至少要有多少人，才能保证其中至少有 3 人生日相同？',
      'en' => 'What is the minimum number of people needed to guarantee that at least 3 share the same birthday?',
      'ja' => '少なくとも何人いれば、同じ誕生日の人が少なくとも3人いることを必ず保証できますか。',
    },
    answer: { 'zh-Hant' => '答案是 733 人。', 'zh-Hans' => '答案是 733 人。', 'en' => 'The answer is 733.', 'ja' => '答えは 733 人です。' },
    steps: {
      'zh-Hant' => ['把一年看成 366 天。', '若每一天先放 2 人，最多可放 366×2=732 人而不會有 3 人同生日。', '再多 1 人就一定有某一天出現第 3 人，所以是 733 人。'],
      'zh-Hans' => ['把一年看成 366 天。', '若每一天先放 2 人，最多可放 366×2=732 人而不会有 3 人同生日。', '再多 1 人就一定有某一天出现第 3 人，所以是 733 人。'],
      'en' => ['Treat the year as having 366 possible birthdays.', 'You can place at most 2 people on each date, for 366×2=732 people, without forcing a triple match.', 'One more person guarantees a third person on some date, so the minimum is 733.'],
      'ja' => ['誕生日は最大 366 通りあります。', '各日に2人ずつなら 366×2=732 人まで、同じ誕生日が3人になるとは限りません。', 'もう1人増えると必ずどこかの日に3人目が入り、733 人です。'],
    },
    options: options(a: '365×2+1', b: '366×2+1', c: '365×2+3', d: '366×2+3'),
    correct: 'B',
    problem_number: '選擇 21',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  integer_question(
    id: 'arithmetic_grade5_foundation_063',
    subtopic: 'system_of_equations',
    prompt: {
      'zh-Hant' => '已知 x÷y÷z=3，x÷y−z=10，x−y=28，求 x+y+z。',
      'zh-Hans' => '已知 x÷y÷z=3，x÷y−z=10，x−y=28，求 x+y+z。',
      'en' => 'Given x÷y÷z=3, x÷y−z=10, and x−y=28, find x+y+z.',
      'ja' => 'x÷y÷z=3、x÷y−z=10、x−y=28 のとき、x+y+z を求めなさい。',
    },
    answer: { 'zh-Hant' => '答案是 37。', 'zh-Hans' => '答案是 37。', 'en' => 'The answer is 37.', 'ja' => '答えは 37 です。' },
    steps: {
      'zh-Hant' => ['令 t=x÷y。由 t÷z=3 和 t−z=10，可得 t=3z 且 t=z+10。', '所以 3z=z+10，得到 z=5，進而 t=15。', '因此 x÷y=15，且 x−y=28。由此得 y=2，x=30。', '最後 x+y+z=30+2+5=37。'],
      'zh-Hans' => ['令 t=x÷y。由 t÷z=3 和 t−z=10，可得 t=3z 且 t=z+10。', '所以 3z=z+10，得到 z=5，进而 t=15。', '因此 x÷y=15，且 x−y=28。由此得 y=2，x=30。', '最后 x+y+z=30+2+5=37。'],
      'en' => ['Let t=x÷y. From t÷z=3 and t−z=10, we have t=3z and t=z+10.', 'So 3z=z+10, giving z=5 and then t=15.', 'Now x÷y=15 and x−y=28, so y=2 and x=30.', 'Thus x+y+z=37.'],
      'ja' => ['t=x÷y とおきます。t÷z=3 と t−z=10 より、t=3z かつ t=z+10 です。', 'したがって 3z=z+10 なので z=5、そして t=15 です。', 'よって x÷y=15 かつ x−y=28 から y=2、x=30 です。', '最後に x+y+z=37 です。'],
    },
    value: '37',
    max_digits: 2,
    problem_number: '選擇 22',
    notes: 'Imported from the official PDF without figure dependency. Stored as integer-input because the answer is a single exact integer.',
  ),
  integer_question(
    id: 'arithmetic_grade5_foundation_064',
    subtopic: 'schedule_counting',
    prompt: {
      'zh-Hant' => '市公車每隔 25 分開出 1 班車，上午 6:10 開出第 1 班。第 5 班是在上午幾點幾分開出？',
      'zh-Hans' => '市公车每隔 25 分开出 1 班车，上午 6:10 开出第 1 班。第 5 班是在上午几点几分开出？',
      'en' => 'A city bus departs every 25 minutes, with the first bus at 6:10 a.m. When does the 5th bus depart?',
      'ja' => '市バスは 25 分ごとに 1 本出ます。第1便は午前 6:10 です。第5便は何時何分に出ますか。',
    },
    answer: { 'zh-Hant' => '答案是上午 7:50。', 'zh-Hans' => '答案是上午 7:50。', 'en' => 'The answer is 7:50 a.m.', 'ja' => '答えは午前 7:50 です。' },
    steps: {
      'zh-Hant' => ['第 5 班比第 1 班晚 4 個間隔。', '4×25=100 分鐘，也就是 1 小時 40 分。', '6:10 加上 1:40，得到 7:50。'],
      'zh-Hans' => ['第 5 班比第 1 班晚 4 个间隔。', '4×25=100 分钟，也就是 1 小时 40 分。', '6:10 加上 1:40，得到 7:50。'],
      'en' => ['The 5th bus is 4 intervals after the 1st.', '4×25=100 minutes, which is 1 hour 40 minutes.', '6:10 plus 1:40 gives 7:50.'],
      'ja' => ['第5便は第1便の4区間後です。', '4×25=100 分で、1時間40分です。', '6:10 に 1:40 を足して 7:50 です。'],
    },
    value: '750',
    max_digits: 4,
    problem_number: '計算 1-1',
    notes: 'Imported from the official PDF without figure dependency. Time answer encoded as 750 for the current integer-input mode.',
  ),
]

new_logic_questions = [
  choice_question(
    id: 'logic_grade5_foundation_041',
    topic: 'logic',
    subtopic: 'matching',
    prompt: {
      'zh-Hant' => '王、趙、李三位老師各帶一位學生：小華、小明、小剛。每位老師都比自己帶的學生大 21 歲。已知李老師和小華年齡和為 44，王老師和小華年齡和為 42，而且王老師比小明大 19 歲。下列哪個敘述正確？',
      'zh-Hans' => '王、赵、李三位老师各带一位学生：小华、小明、小刚。每位老师都比自己带的学生大 21 岁。已知李老师和小华年龄和为 44，王老师和小华年龄和为 42，而且王老师比小明大 19 岁。下列哪个叙述正确？',
      'en' => 'Teachers Wang, Zhao, and Li each bring one student: Xiaohua, Xiaoming, and Xiaogang. Every teacher is 21 years older than the student they bring. Teacher Li and Xiaohua have ages summing to 44, Teacher Wang and Xiaohua sum to 42, and Teacher Wang is 19 years older than Xiaoming. Which statement is correct?',
      'ja' => '王先生・趙先生・李先生はそれぞれ小華・小明・小剛のうち1人を連れてきます。どの先生も自分の生徒より21歳年上です。李先生と小華の年齢の和は44、王先生と小華の和は42、さらに王先生は小明より19歳年上です。正しい記述はどれですか。',
    },
    answer: { 'zh-Hant' => '答案是小華是趙老師帶的。', 'zh-Hans' => '答案是小华是赵老师带的。', 'en' => 'The answer is: Xiaohua is brought by Teacher Zhao.', 'ja' => '答えは「小華は趙先生が連れている」です。' },
    steps: {
      'zh-Hant' => ['若老師和自己帶的學生相差 21 歲，兩人的年齡和必定是奇數。', '但李老師與小華、王老師與小華的和分別是 44、42，都是偶數，所以小華不可能是李老師或王老師帶的。', '因此小華只能是趙老師帶的。'],
      'zh-Hans' => ['若老师和自己带的学生相差 21 岁，两人的年龄和必定是奇数。', '但李老师与小华、王老师与小华的和分别是 44、42，都是偶数，所以小华不可能是李老师或王老师带的。', '因此小华只能是赵老师带的。'],
      'en' => ['A teacher and the student they bring differ by 21 years, so their age sum must be odd.', 'But Teacher Li with Xiaohua and Teacher Wang with Xiaohua give sums 44 and 42, both even.', 'So Xiaohua cannot be with Li or Wang, and must be with Zhao.'],
      'ja' => ['先生と自分の生徒の年齢差が21歳なら、その和は必ず奇数です。', 'しかし李先生と小華、王先生と小華の和は 44 と 42 でどちらも偶数です。', 'したがって小華は李先生でも王先生でもなく、趙先生が連れていることになります。'],
    },
    options: options(a: '小華是王老師帶的', b: '小明是趙老師帶的', c: '小剛是李老師帶的', d: '小華是趙老師帶的'),
    correct: 'D',
    problem_number: '選擇 24',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'logic_grade5_foundation_042',
    topic: 'logic',
    subtopic: 'constraint_satisfaction',
    prompt: {
      'zh-Hant' => '26 顆相同玻璃彈珠分裝在 A、B、C、D、E 五個袋子裡，每袋至少 2 顆，且五袋顆數互不相同。秤重時，11 顆以上會超重。已知量測結果為：A+E 超重、B+C 超重、C+D 超重，但 A+C 未超重。求 A+C+E−B−D = ?',
      'zh-Hans' => '26 颗相同玻璃弹珠分装在 A、B、C、D、E 五个袋子里，每袋至少 2 颗，且五袋颗数互不相同。称重时，11 颗以上会超重。已知量测结果为：A+E 超重、B+C 超重、C+D 超重，但 A+C 未超重。求 A+C+E−B−D = ?',
      'en' => 'Twenty-six equal marbles are split into bags A, B, C, D, and E. Each bag has at least 2 marbles, and all five counts are distinct. A weight alarm rings for 11 marbles or more. We know A+E is overweight, B+C is overweight, C+D is overweight, but A+C is not. Find A+C+E−B−D.',
      'ja' => '同じ重さのガラス玉 26 個を A、B、C、D、E の5袋に分けます。各袋には少なくとも2個入り、5袋の個数はすべて異なります。11個以上になると警報が鳴ります。A+E、B+C、C+D では警報が鳴り、A+C では鳴りません。A+C+E−B−D を求めなさい。',
    },
    answer: { 'zh-Hant' => '答案是 12。', 'zh-Hans' => '答案是 12。', 'en' => 'The answer is 12.', 'ja' => '答えは 12 です。' },
    steps: {
      'zh-Hant' => ['由條件可得 A+E≥11、B+C≥11、C+D≥11，而 A+C<11。', '滿足每袋至少 2 顆且總數 26 的唯一結構可整理成 A=2、C=8、E=9，B、D 為 3、4。', '所以 A+C+E−B−D = 2+8+9−3−4 = 12。'],
      'zh-Hans' => ['由条件可得 A+E≥11、B+C≥11、C+D≥11，而 A+C<11。', '满足每袋至少 2 颗且总数 26 的唯一结构可整理成 A=2、C=8、E=9，B、D 为 3、4。', '所以 A+C+E−B−D = 2+8+9−3−4 = 12。'],
      'en' => ['The conditions give A+E≥11, B+C≥11, C+D≥11, but A+C<11.', 'With all counts distinct, at least 2 each, and total 26, the workable structure is A=2, C=8, E=9, with B and D being 3 and 4.', 'So A+C+E−B−D = 2+8+9−3−4 = 12.'],
      'ja' => ['条件から A+E≥11、B+C≥11、C+D≥11、そして A+C<11 です。', 'すべて異なり、各袋少なくとも2個、合計26個という条件を満たす形は A=2、C=8、E=9、B と D が 3 と 4 です。', 'したがって A+C+E−B−D = 2+8+9−3−4 = 12 です。'],
    },
    options: options(a: '10', b: '11', c: '12', d: '13'),
    correct: 'C',
    problem_number: '選擇 25',
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
  when 'assets/questions/arithmetic/grade5_foundation.arithmetic.v1.json'
    pack['questionCount'] = arithmetic['questions'].length
  when 'assets/questions/logic/grade5_foundation.logic.v1.json'
    pack['questionCount'] = logic['questions'].length
  end
end

save_json(ARITHMETIC_PATH, arithmetic)
save_json(LOGIC_PATH, logic)
save_json(MANIFEST_PATH, manifest)
