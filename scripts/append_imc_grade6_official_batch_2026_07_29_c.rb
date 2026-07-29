#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'

ROOT = File.expand_path('..', __dir__)
ARITHMETIC_PATH = File.join(ROOT, 'assets/questions/arithmetic/grade6_foundation.arithmetic.v1.json')
MANIFEST_PATH = File.join(ROOT, 'assets/questions/manifest.json')
SOURCE_URL = 'https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD6%E5%B9%B4%E7%B4%9A0926%20-.pdf'

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
    'division' => '國小六年級',
    'problemNumber' => problem_number,
    'displayText' => "第16屆IMC台灣區初賽國小六年級 #{problem_number}",
    'sourceUrl' => SOURCE_URL,
    'rightsStatus' => 'needs_review',
    'notes' => notes,
  }
end

def figure_none
  { 'type' => 'custom', 'kind' => 'none', 'params' => {} }
end

arithmetic = load_json(ARITHMETIC_PATH)
manifest = load_json(MANIFEST_PATH)

question = {
  'id' => 'arithmetic_grade6_foundation_064',
  'topic' => 'arithmetic',
  'subtopic' => 'clock_reasoning',
  'difficulty' => 'foundation',
  'levelStage' => 'grade6',
  'challengeTier' => 'foundation',
  'prompt' => {
    'zh-Hant' => '小雯今天早上發現家裡時鐘沒電，停在上午 6 點 10 分。她換上電池後沒有重新校時就去上班。她的上班時間是上午 9 點；到公司時，離上班還有 10 分鐘。她一直到下午 2 點半下班後回家，一看時鐘是 12 點 20 分。已知往返家裡和公司的時間相同。請問這座時鐘總共停了幾分鐘？',
    'zh-Hans' => '小雯今天早上发现家里时钟没电，停在上午 6 点 10 分。她换上电池后没有重新校时就去上班。她的上班时间是上午 9 点；到公司时，离上班还有 10 分钟。她一直到下午 2 点半下班后回家，一看时钟是 12 点 20 分。已知往返家里和公司的时间相同。请问这座时钟总共停了几分钟？',
    'en' => 'This morning Wen found that the clock at home had stopped at 6:10 a.m. She replaced the battery but did not reset the time before leaving for work. Her work starts at 9:00 a.m., and when she arrived at the office there were still 10 minutes before work. She finished work at 2:30 p.m. and returned home, where the clock read 12:20. The travel time to and from home is the same. For how many minutes had the clock been stopped in total?',
    'ja' => '今朝、小雯は家の時計の電池が切れていて、午前6時10分で止まっているのを見つけました。電池を入れ替えたあと、時刻を合わせずに出勤しました。出勤時刻は午前9時で、会社に着いたときは始業まであと10分ありました。午後2時30分に退勤して帰宅すると、時計は12時20分を指していました。家と会社の往復時間は同じです。この時計は合計で何分止まっていましたか。',
  },
  'answer' => {
    'zh-Hant' => '答案是 145 分鐘。',
    'zh-Hans' => '答案是 145 分钟。',
    'en' => 'The answer is 145 minutes.',
    'ja' => '答えは 145 分です。',
  },
  'solutionSteps' => {
    'zh-Hant' => [
      '小雯到公司時是 8 點 50 分，下班是 2 點 30 分，所以從到公司到下班共經過 5 小時 40 分。',
      '家裡時鐘從 6 點 10 分走到 12 點 20 分，一共走了 6 小時 10 分。',
      '設單程通勤時間是 t 分鐘，則實際上從出門到回家共經過 5 小時 40 分加上 2t。',
      '因為時鐘實際運轉的時間就是出門到回家的實際經過時間，所以 5 小時 40 分 + 2t = 6 小時 10 分。',
      '兩邊相差 30 分鐘，因此 2t = 30，得到 t = 15 分鐘。',
      '所以小雯出門時是 8 點 35 分，時鐘從 6 點 10 分停到 8 點 35 分，共停了 2 小時 25 分，也就是 145 分鐘。'
    ],
    'zh-Hans' => [
      '小雯到公司时是 8 点 50 分，下班是 2 点 30 分，所以从到公司到下班共经过 5 小时 40 分。',
      '家里时钟从 6 点 10 分走到 12 点 20 分，一共走了 6 小时 10 分。',
      '设单程通勤时间是 t 分钟，则实际上从出门到回家共经过 5 小时 40 分加上 2t。',
      '因为时钟实际运转的时间就是出门到回家的实际经过时间，所以 5 小时 40 分 + 2t = 6 小时 10 分。',
      '两边相差 30 分钟，因此 2t = 30，得到 t = 15 分钟。',
      '所以小雯出门时是 8 点 35 分，时钟从 6 点 10 分停到 8 点 35 分，共停了 2 小时 25 分，也就是 145 分钟。'
    ],
    'en' => [
      'She reached the office at 8:50 a.m. and finished work at 2:30 p.m., so that part lasted 5 hours 40 minutes.',
      'The home clock moved from 6:10 to 12:20, which is 6 hours 10 minutes.',
      'Let the one-way commute be t minutes. Then the real time from leaving home to returning home is 5 hours 40 minutes plus 2t.',
      'That real elapsed time equals the time the clock was running after the battery was replaced, so 5 hours 40 minutes + 2t = 6 hours 10 minutes.',
      'The difference is 30 minutes, so 2t = 30 and t = 15.',
      'Thus she left home at 8:35 a.m. The clock had been stopped from 6:10 to 8:35, which is 145 minutes.'
    ],
    'ja' => [
      '会社に着いたのは午前8時50分、退勤は午後2時30分なので、その間は 5 時間 40 分です。',
      '家の時計は 6 時 10 分から 12 時 20 分まで進んでおり、これは 6 時間 10 分です。',
      '片道の通勤時間を t 分とすると、家を出てから帰宅するまでの実時間は 5 時間 40 分 + 2t です。',
      'これは電池交換後に時計が実際に動いた時間に等しいので、5 時間 40 分 + 2t = 6 時間 10 分です。',
      '差は 30 分なので 2t = 30、したがって t = 15 分です。',
      'よって家を出たのは 8 時 35 分で、時計は 6 時 10 分から 8 時 35 分まで止まっていました。合計 145 分です。'
    ],
  },
  'figure' => figure_none,
  'answerMode' => 'integer_input',
  'correctAnswer' => { 'type' => 'integer', 'value' => '145' },
  'inputConstraints' => {
    'allowNegative' => false,
    'maxDigits' => 3,
  },
  'source' => source_meta(
    '計算 1',
    'Imported from the official PDF without figure dependency. Prompt normalized to ask for total stopped minutes so it fits integer input mode.',
  ),
}

arithmetic['questions'] << question

manifest['packs'].each do |pack|
  next unless pack['path'] == 'assets/questions/arithmetic/grade6_foundation.arithmetic.v1.json'

  pack['questionCount'] = arithmetic['questions'].length
end

save_json(ARITHMETIC_PATH, arithmetic)
save_json(MANIFEST_PATH, manifest)
