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
    id: 'arithmetic_grade6_foundation_062',
    topic: 'arithmetic',
    subtopic: 'inverse_proportion',
    prompt: {
      'zh-Hant' => '小軒從住家到公園，如果每分鐘走 105 公尺，80 分鐘可到達公園。若原路回程時改成每分鐘走 150 公尺，回到住家要幾分鐘？',
      'zh-Hans' => '小轩从住家到公园，如果每分钟走 105 公尺，80 分钟可到达公园。若原路回程时改成每分钟走 150 公尺，回到住家要几分钟？',
      'en' => 'Xuan walks from home to the park at 105 meters per minute and reaches it in 80 minutes. If he returns along the same route at 150 meters per minute, how many minutes does the return trip take?',
      'ja' => 'シュエンは家から公園まで毎分 105 m で歩くと 80 分かかります。同じ道を毎分 150 m で戻ると、何分かかりますか。',
    },
    answer: {
      'zh-Hant' => '答案是 56 分鐘。',
      'zh-Hans' => '答案是 56 分钟。',
      'en' => 'The answer is 56 minutes.',
      'ja' => '答えは 56 分です。',
    },
    steps: {
      'zh-Hant' => ['先求單程距離：105 × 80 = 8400 公尺。', '回程速度是每分鐘 150 公尺。', '所以回程時間是 8400 ÷ 150 = 56 分鐘。'],
      'zh-Hans' => ['先求单程距离：105 × 80 = 8400 公尺。', '回程速度是每分钟 150 公尺。', '所以回程时间是 8400 ÷ 150 = 56 分钟。'],
      'en' => ['First find the one-way distance: 105 × 80 = 8400 meters.', 'The return speed is 150 meters per minute.', 'So the return time is 8400 ÷ 150 = 56 minutes.'],
      'ja' => ['まず片道の距離は 105 × 80 = 8400 m です。', '帰りの速さは毎分 150 m です。', 'したがって帰りの時間は 8400 ÷ 150 = 56 分です。'],
    },
    options: options(a: '42', b: '50', c: '52', d: '56'),
    correct: 'D',
    problem_number: '選擇 1',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'arithmetic_grade6_foundation_063',
    topic: 'arithmetic',
    subtopic: 'system_reasoning',
    prompt: {
      'zh-Hant' => '已知 x÷y÷z = 3，x÷y − z = 10，x − y = 28，求 x + y + z。',
      'zh-Hans' => '已知 x÷y÷z = 3，x÷y − z = 10，x − y = 28，求 x + y + z。',
      'en' => 'Given x÷y÷z = 3, x÷y − z = 10, and x − y = 28, find x + y + z.',
      'ja' => 'x÷y÷z = 3、x÷y − z = 10、x − y = 28 のとき、x + y + z を求めなさい。',
    },
    answer: {
      'zh-Hant' => '答案是 37。',
      'zh-Hans' => '答案是 37。',
      'en' => 'The answer is 37.',
      'ja' => '答えは 37 です。',
    },
    steps: {
      'zh-Hant' => ['設 t = x÷y。由 t÷z = 3 可得 t = 3z。', '又由 t − z = 10，代入得 3z − z = 10，所以 z = 5。', '因此 t = 15，也就是 x÷y = 15。', '再由 x − y = 28，可知 14 個 y 等於 28，所以 y = 2，x = 30。', '最後 x + y + z = 30 + 2 + 5 = 37。'],
      'zh-Hans' => ['设 t = x÷y。由 t÷z = 3 可得 t = 3z。', '又由 t − z = 10，代入得 3z − z = 10，所以 z = 5。', '因此 t = 15，也就是 x÷y = 15。', '再由 x − y = 28，可知 14 个 y 等于 28，所以 y = 2，x = 30。', '最后 x + y + z = 30 + 2 + 5 = 37。'],
      'en' => ['Let t = x÷y. From t÷z = 3, we get t = 3z.', 'Using t − z = 10 gives 3z − z = 10, so z = 5.', 'Then t = 15, so x÷y = 15.', 'Since x − y = 28, we have 14y = 28, so y = 2 and x = 30.', 'Thus x + y + z = 37.'],
      'ja' => ['t = x÷y とおきます。t÷z = 3 より t = 3z です。', 'さらに t − z = 10 なので 3z − z = 10、よって z = 5。', 'したがって t = 15、つまり x÷y = 15 です。', 'x − y = 28 より 14y = 28、したがって y = 2、x = 30。', 'よって x + y + z = 37 です。'],
    },
    options: options(a: '37', b: '36', c: '35', d: '34'),
    correct: 'A',
    problem_number: '選擇 22',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
]

new_logic_questions = [
  choice_question(
    id: 'logic_grade6_foundation_047',
    topic: 'logic',
    subtopic: 'pigeonhole_principle',
    prompt: {
      'zh-Hant' => '至少要有多少人，才能保證其中至少有 3 人生日相同？',
      'zh-Hans' => '至少要有多少人，才能保证其中至少有 3 人生日相同？',
      'en' => 'How many people are needed to guarantee that at least 3 of them share the same birthday?',
      'ja' => '少なくとも何人いれば、その中に同じ誕生日の人が少なくとも 3 人いることを必ず保証できますか。',
    },
    answer: {
      'zh-Hant' => '答案是 733 人。',
      'zh-Hans' => '答案是 733 人。',
      'en' => 'The answer is 733.',
      'ja' => '答えは 733 人です。',
    },
    steps: {
      'zh-Hant' => ['一年最多有 366 種生日。', '若每一種生日最多先放 2 人，最多可放 366 × 2 = 732 人，仍不保證有 3 人同生日。', '再多 1 人，就一定有某一天的生日出現第 3 人。', '所以答案是 733 人。'],
      'zh-Hans' => ['一年最多有 366 种生日。', '若每一种生日最多先放 2 人，最多可放 366 × 2 = 732 人，仍不保证有 3 人同生日。', '再多 1 人，就一定有某一天的生日出现第 3 人。', '所以答案是 733 人。'],
      'en' => ['There are at most 366 possible birthdays.', 'If each birthday is used by at most 2 people, we can place 366 × 2 = 732 people without forcing a triple match.', 'One more person guarantees some birthday appears for the third time.', 'So the answer is 733.'],
      'ja' => ['誕生日は最大 366 通りです。', '各誕生日に 2 人ずつなら 366 × 2 = 732 人までは 3 人一致を避けられます。', 'さらに 1 人増えると、どこかの誕生日が 3 人になります。', 'したがって答えは 733 人です。'],
    },
    options: options(a: '365×2+1', b: '366×2+1', c: '365×2+3', d: '366×2+3'),
    correct: 'B',
    problem_number: '選擇 21',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
  choice_question(
    id: 'logic_grade6_foundation_048',
    topic: 'logic',
    subtopic: 'matching_deduction',
    prompt: {
      'zh-Hant' => '王、趙、李三位老師各帶著小華、小明、小剛其中一位學生參加數學競賽。每位老師都比自己帶的學生大 21 歲。已知李老師與小華的年齡和是 44 歲，王老師與小華的年齡和是 42 歲，而且王老師比小明大 19 歲。下列哪一個敘述一定正確？',
      'zh-Hans' => '王、赵、李三位老师各带着小华、小明、小刚其中一位学生参加数学竞赛。每位老师都比自己带的学生大 21 岁。已知李老师与小华的年龄和是 44 岁，王老师与小华的年龄和是 42 岁，而且王老师比小明大 19 岁。下列哪一个叙述一定正确？',
      'en' => 'Teachers Wang, Zhao, and Li each bring one student among Hua, Ming, and Gang to a math contest. Each teacher is 21 years older than the student they bring. Li and Hua have a total age of 44, Wang and Hua have a total age of 42, and Wang is 19 years older than Ming. Which statement must be true?',
      'ja' => '王先生・趙先生・李先生の 3 人の先生が、それぞれ小華・小明・小剛のうち 1 人ずつを連れて数学大会に参加します。各先生は自分の担当生徒より 21 歳年上です。李先生と小華の年齢の和は 44、王先生と小華の年齢の和は 42、さらに王先生は小明より 19 歳年上です。必ず正しいものはどれですか。',
    },
    answer: {
      'zh-Hant' => '答案是小華是趙老師帶的。',
      'zh-Hans' => '答案是小华是赵老师带的。',
      'en' => 'The answer is that Hua is brought by Teacher Zhao.',
      'ja' => '答えは「小華は趙先生が連れている」です。',
    },
    steps: {
      'zh-Hant' => ['若老師和自己帶的學生相差 21 歲，則兩人年齡和必為奇數。', '李老師與小華年齡和是 44，王老師與小華年齡和是 42，都是偶數，所以小華不可能是李老師或王老師帶的。', '因此小華一定是趙老師帶的。', '再配合王老師只比小明大 19 歲，可知小明也不是王老師帶的。'],
      'zh-Hans' => ['若老师和自己带的学生相差 21 岁，则两人年龄和必为奇数。', '李老师与小华年龄和是 44，王老师与小华年龄和是 42，都是偶数，所以小华不可能是李老师或王老师带的。', '因此小华一定是赵老师带的。', '再配合王老师只比小明大 19 岁，可知小明也不是王老师带的。'],
      'en' => ['A teacher and the student they bring differ by 21 years, so their age sum must be odd.', 'Li with Hua sums to 44 and Wang with Hua sums to 42, both even, so Hua cannot be paired with Li or Wang.', 'Therefore Hua must be brought by Zhao.', 'Also Wang is only 19 years older than Ming, so Ming is not Wang’s student either.'],
      'ja' => ['先生と担当生徒の年齢差は 21 歳なので、2人の年齢の和は必ず奇数です。', '李先生と小華の和 44、王先生と小華の和 42 はどちらも偶数なので、小華はその 2 人の担当ではありません。', 'したがって小華を連れているのは趙先生です。', 'さらに王先生は小明より 19 歳上なので、小明も王先生の担当ではありません。'],
    },
    options: options(
      a: '小華是王老師帶的',
      b: '小明是趙老師帶的',
      c: '小剛是李老師帶的',
      d: '小華是趙老師帶的'
    ),
    correct: 'D',
    problem_number: '選擇 24',
    notes: 'Imported from the official PDF without figure dependency.',
  ),
]

arithmetic['questions'].concat(new_arithmetic_questions)
logic['questions'].concat(new_logic_questions)

manifest['packs'].each do |pack|
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
