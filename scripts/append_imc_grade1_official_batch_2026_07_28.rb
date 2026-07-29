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
    'notes' => 'Imported from the official IMC answer sheet and lightly paraphrased for app formatting.',
  }
end

append_questions(
  File.join(ROOT, 'assets/questions/logic/grade1_foundation.logic.v1.json'),
  [
    {
      'id' => 'logic_grade1_foundation_041',
      'topic' => 'logic',
      'subtopic' => 'position',
      'difficulty' => 'foundation',
      'levelStage' => 'grade1',
      'challengeTier' => 'foundation',
      'prompt' => {
        'zh-Hant' => '快樂路一段的一側只排奇數門牌，依序是 301、303、305、307、309；另一側只排偶數門牌，依序是 300、302、304、306、308、310。已知郵局在 301 號、消防局在 305 號、全家在 309 號、7-11 在 300 號。四季百貨夾在 304 號和 310 號之間，而且在 7-11 的同一側。四季百貨是幾號？',
        'zh-Hans' => '快乐路一段的一侧只排奇数门牌，依序是 301、303、305、307、309；另一侧只排偶数门牌，依序是 300、302、304、306、308、310。已知邮局在 301 号、消防局在 305 号、全家在 309 号、7-11 在 300 号。四季百货夹在 304 号和 310 号之间，而且在 7-11 的同一侧。四季百货是几号？',
        'en' => 'On one side of Happy Road Section 1, the odd house numbers are 301, 303, 305, 307, 309. On the other side, the even numbers are 300, 302, 304, 306, 308, 310. The post office is at 301, the fire station at 305, FamilyMart at 309, and 7-Eleven at 300. A department store is on the same side as 7-Eleven and lies between 304 and 310. What is its house number?',
        'ja' => 'ハッピーロード1段では、道の片側は奇数で 301、303、305、307、309、反対側は偶数で 300、302、304、306、308、310 と並びます。郵便局は301番、消防署は305番、ファミリーマートは309番、7-Elevenは300番です。デパートは7-Elevenと同じ側にあり、304番と310番の間にあります。何番ですか。',
      },
      'answer' => {
        'zh-Hant' => '答案是 308 號。',
        'zh-Hans' => '答案是 308 号。',
        'en' => 'The answer is 308.',
        'ja' => '答えは 308 番です。',
      },
      'solutionSteps' => {
        'zh-Hant' => [
          '四季百貨和 7-11 在同一側，所以要看偶數那一排。',
          '偶數門牌依序是 300、302、304、306、308、310。',
          '在 304 和 310 之間的只有 306 和 308。',
          '依題目圖上的位置，四季百貨在較靠近 310 的位置，所以是 308 號。',
        ],
        'zh-Hans' => [
          '四季百货和 7-11 在同一侧，所以要看偶数那一排。',
          '偶数门牌依序是 300、302、304、306、308、310。',
          '在 304 和 310 之间的只有 306 和 308。',
          '依题目图上的位置，四季百货在较靠近 310 的位置，所以是 308 号。',
        ],
        'en' => [
          'The department store is on the same side as 7-Eleven, so it must be on the even-number side.',
          'The even numbers are 300, 302, 304, 306, 308, 310.',
          'Only 306 and 308 are between 304 and 310.',
          'Using the position shown in the official diagram, the department store is the spot closer to 310, so it is 308.',
        ],
        'ja' => [
          'デパートは7-Elevenと同じ側なので、偶数の並びを見ます。',
          '偶数は 300、302、304、306、308、310 です。',
          '304番と310番の間にあるのは 306番と308番です。',
          '公式図の位置関係より、デパートは310番に近いほうなので、308番です。',
        ],
      },
      'figure' => { 'type' => 'custom', 'kind' => 'none', 'params' => {} },
      'answerMode' => 'multiple_choice',
      'options' => {
        'A' => { 'zh-Hant' => '312', 'zh-Hans' => '312', 'en' => '312', 'ja' => '312' },
        'B' => { 'zh-Hant' => '308', 'zh-Hans' => '308', 'en' => '308', 'ja' => '308' },
        'C' => { 'zh-Hant' => '306', 'zh-Hans' => '306', 'en' => '306', 'ja' => '306' },
        'D' => { 'zh-Hant' => '307', 'zh-Hans' => '307', 'en' => '307', 'ja' => '307' },
      },
      'correctAnswer' => { 'type' => 'choice', 'value' => 'B' },
      'source' => official_source('選擇 1'),
    },
    {
      'id' => 'logic_grade1_foundation_042',
      'topic' => 'logic',
      'subtopic' => 'position',
      'difficulty' => 'foundation',
      'levelStage' => 'grade1',
      'challengeTier' => 'foundation',
      'prompt' => {
        'zh-Hant' => '沿用同一條街的排法：301、303、305、307、309 在同一側；300、302、304、306、308、310 在另一側。若玹玹家是 298 號，她會和哪個地點在同一側？',
        'zh-Hans' => '沿用同一条街的排法：301、303、305、307、309 在同一侧；300、302、304、306、308、310 在另一侧。若玹玹家是 298 号，她会和哪个地点在同一侧？',
        'en' => 'Using the same street pattern, 301, 303, 305, 307, 309 are on one side and 300, 302, 304, 306, 308, 310 are on the other. If Xuanxuan lives at 298, which place is on the same side as her home?',
        'ja' => '同じ通りで、301、303、305、307、309 は同じ側、300、302、304、306、308、310 は反対側にあります。もしけんけんの家が 298 番なら、どの場所と同じ側になりますか。',
      },
      'answer' => {
        'zh-Hant' => '答案是四季百貨。',
        'zh-Hans' => '答案是四季百货。',
        'en' => 'The answer is the department store.',
        'ja' => '答えはデパートです。',
      },
      'solutionSteps' => {
        'zh-Hant' => [
          '298 是偶數，所以和偶數門牌那一側在同一排。',
          '四季百貨在官方圖上位於偶數門牌那一側。',
          '所以玹玹家和四季百貨同一排。',
        ],
        'zh-Hans' => [
          '298 是偶数，所以和偶数门牌那一侧在同一排。',
          '四季百货在官方图上位于偶数门牌那一侧。',
          '所以玹玹家和四季百货同一排。',
        ],
        'en' => [
          'Since 298 is even, it lies on the even-number side of the street.',
          'The department store is on the even-number side in the official diagram.',
          'So Xuanxuan’s home is on the same side as the department store.',
        ],
        'ja' => [
          '298 は偶数なので、偶数の並ぶ側にあります。',
          'デパートは公式図で偶数の側にあります。',
          'したがって、けんけんの家はデパートと同じ側です。',
        ],
      },
      'figure' => { 'type' => 'custom', 'kind' => 'none', 'params' => {} },
      'answerMode' => 'multiple_choice',
      'options' => {
        'A' => { 'zh-Hant' => '郵局', 'zh-Hans' => '邮局', 'en' => 'Post office', 'ja' => '郵便局' },
        'B' => { 'zh-Hant' => '消防局', 'zh-Hans' => '消防局', 'en' => 'Fire station', 'ja' => '消防署' },
        'C' => { 'zh-Hant' => '四季百貨', 'zh-Hans' => '四季百货', 'en' => 'Department store', 'ja' => 'デパート' },
        'D' => { 'zh-Hant' => '全家', 'zh-Hans' => '全家', 'en' => 'FamilyMart', 'ja' => 'ファミリーマート' },
      },
      'correctAnswer' => { 'type' => 'choice', 'value' => 'C' },
      'source' => official_source('選擇 2'),
    },
    {
      'id' => 'logic_grade1_foundation_043',
      'topic' => 'logic',
      'subtopic' => 'comparison',
      'difficulty' => 'foundation',
      'levelStage' => 'grade1',
      'challengeTier' => 'foundation',
      'prompt' => {
        'zh-Hant' => '已知 A×B = C×D，而且 A 比 C 大；四個數都不是 0。那麼 B 和 D 的大小關係是什麼？',
        'zh-Hans' => '已知 A×B = C×D，而且 A 比 C 大；四个数都不是 0。那么 B 和 D 的大小关系是什么？',
        'en' => 'Suppose A×B = C×D, A is greater than C, and none of the four numbers is 0. What must be true about B and D?',
        'ja' => 'A×B = C×D で、A は C より大きく、4つの数はどれも 0 ではありません。このとき、B と D の大小関係はどうなりますか。',
      },
      'answer' => {
        'zh-Hant' => '答案是 B < D。',
        'zh-Hans' => '答案是 B < D。',
        'en' => 'The answer is B < D.',
        'ja' => '答えは B < D です。',
      },
      'solutionSteps' => {
        'zh-Hant' => [
          '兩邊乘積相同，但 A 比 C 大。',
          '要讓 A×B 和 C×D 一樣大，和較大的 A 相乘的那個數 B 就要比較小。',
          '因此 B 一定小於 D。',
        ],
        'zh-Hans' => [
          '两边乘积相同，但 A 比 C 大。',
          '要让 A×B 和 C×D 一样大，和较大的 A 相乘的那个数 B 就要比较小。',
          '因此 B 一定小于 D。',
        ],
        'en' => [
          'The products are equal, but A is larger than C.',
          'To keep A×B equal to C×D, the factor paired with the larger number A must be smaller.',
          'Therefore B must be less than D.',
        ],
        'ja' => [
          '積は同じですが、A は C より大きいです。',
          'A×B と C×D を同じにするには、大きい A と組になる B は小さくなければなりません。',
          'したがって B は D より小さいです。',
        ],
      },
      'figure' => { 'type' => 'custom', 'kind' => 'none', 'params' => {} },
      'answerMode' => 'multiple_choice',
      'options' => {
        'A' => { 'zh-Hant' => 'B = D', 'zh-Hans' => 'B = D', 'en' => 'B = D', 'ja' => 'B = D' },
        'B' => { 'zh-Hant' => 'B < D', 'zh-Hans' => 'B < D', 'en' => 'B < D', 'ja' => 'B < D' },
        'C' => { 'zh-Hant' => 'B > D', 'zh-Hans' => 'B > D', 'en' => 'B > D', 'ja' => 'B > D' },
        'D' => { 'zh-Hant' => '無法比較', 'zh-Hans' => '无法比较', 'en' => 'Cannot decide', 'ja' => '比べられない' },
      },
      'correctAnswer' => { 'type' => 'choice', 'value' => 'B' },
      'source' => official_source('選擇 4'),
    },
  ],
)

append_questions(
  File.join(ROOT, 'assets/questions/arithmetic/grade1_foundation.arithmetic.v1.json'),
  [
    {
      'id' => 'arithmetic_grade1_foundation_051',
      'topic' => 'arithmetic',
      'subtopic' => 'sum_difference',
      'difficulty' => 'foundation',
      'levelStage' => 'grade1',
      'challengeTier' => 'foundation',
      'prompt' => {
        'zh-Hant' => '5 個連續偶數的和是 90。這 5 個偶數中，最大和最小相差多少？',
        'zh-Hans' => '5 个连续偶数的和是 90。这 5 个偶数中，最大和最小相差多少？',
        'en' => 'The sum of 5 consecutive even numbers is 90. What is the difference between the greatest and the smallest of the five numbers?',
        'ja' => '5つの連続する偶数の和が 90 です。この5つの偶数のうち、いちばん大きい数といちばん小さい数の差はいくつですか。',
      },
      'answer' => {
        'zh-Hant' => '答案是 8。',
        'zh-Hans' => '答案是 8。',
        'en' => 'The answer is 8.',
        'ja' => '答えは 8 です。',
      },
      'solutionSteps' => {
        'zh-Hant' => [
          '連續偶數每次都差 2。',
          '5 個連續偶數從最小到最大一共跨了 4 次差距。',
          '所以相差是 2 × 4 = 8。',
        ],
        'zh-Hans' => [
          '连续偶数每次都差 2。',
          '5 个连续偶数从最小到最大一共跨了 4 次差距。',
          '所以相差是 2 × 4 = 8。',
        ],
        'en' => [
          'Consecutive even numbers differ by 2 each time.',
          'From the smallest to the greatest among 5 numbers, there are 4 gaps.',
          'So the difference is 2 × 4 = 8.',
        ],
        'ja' => [
          '連続する偶数は 2 ずつ増えます。',
          '5つの数では、最小から最大までに差が 4 回あります。',
          'したがって差は 2 × 4 = 8 です。',
        ],
      },
      'figure' => { 'type' => 'custom', 'kind' => 'none', 'params' => {} },
      'answerMode' => 'multiple_choice',
      'options' => {
        'A' => { 'zh-Hant' => '8', 'zh-Hans' => '8', 'en' => '8', 'ja' => '8' },
        'B' => { 'zh-Hant' => '10', 'zh-Hans' => '10', 'en' => '10', 'ja' => '10' },
        'C' => { 'zh-Hant' => '6', 'zh-Hans' => '6', 'en' => '6', 'ja' => '6' },
        'D' => { 'zh-Hant' => '4', 'zh-Hans' => '4', 'en' => '4', 'ja' => '4' },
      },
      'correctAnswer' => { 'type' => 'choice', 'value' => 'A' },
      'source' => official_source('選擇 3'),
    },
    {
      'id' => 'arithmetic_grade1_foundation_052',
      'topic' => 'arithmetic',
      'subtopic' => 'pattern',
      'difficulty' => 'foundation',
      'levelStage' => 'grade1',
      'challengeTier' => 'foundation',
      'prompt' => {
        'zh-Hant' => '依規律排成一列：1，4，8，11，22，25，50，53，□，△。請問 □ 和 △ 應該是哪兩個數？',
        'zh-Hans' => '依规律排成一列：1，4，8，11，22，25，50，53，□，△。请问 □ 和 △ 应该是哪两个数？',
        'en' => 'The numbers follow a pattern: 1, 4, 8, 11, 22, 25, 50, 53, □, △. What should □ and △ be?',
        'ja' => '1、4、8、11、22、25、50、53、□、△ と規則的に並んでいます。□ と △ にはどの数が入りますか。',
      },
      'answer' => {
        'zh-Hant' => '答案是 106 和 109。',
        'zh-Hans' => '答案是 106 和 109。',
        'en' => 'The answer is 106 and 109.',
        'ja' => '答えは 106 と 109 です。',
      },
      'solutionSteps' => {
        'zh-Hant' => [
          '從 1 到 4 是 +3，從 4 到 8 是 ×2。',
          '接著又是 +3、×2、+3、×2 這樣重複。',
          '50 到 53 是 +3，所以 53 之後要 ×2 得到 106，再 +3 得到 109。',
        ],
        'zh-Hans' => [
          '从 1 到 4 是 +3，从 4 到 8 是 ×2。',
          '接著又是 +3、×2、+3、×2 这样重复。',
          '50 到 53 是 +3，所以 53 之后要 ×2 得到 106，再 +3 得到 109。',
        ],
        'en' => [
          'The pattern alternates between +3 and ×2.',
          'For example, 1 to 4 is +3, then 4 to 8 is ×2.',
          'Since 50 to 53 is +3, the next step is ×2 to get 106, and then +3 to get 109.',
        ],
        'ja' => [
          '規則は +3 と ×2 が交互にくり返されています。',
          'たとえば、1 から 4 は +3、4 から 8 は ×2 です。',
          '50 から 53 は +3 なので、その次は ×2 で 106、さらに +3 で 109 です。',
        ],
      },
      'figure' => { 'type' => 'custom', 'kind' => 'none', 'params' => {} },
      'answerMode' => 'multiple_choice',
      'options' => {
        'A' => { 'zh-Hant' => '106，103', 'zh-Hans' => '106，103', 'en' => '106, 103', 'ja' => '106, 103' },
        'B' => { 'zh-Hant' => '106，105', 'zh-Hans' => '106，105', 'en' => '106, 105', 'ja' => '106, 105' },
        'C' => { 'zh-Hant' => '106，107', 'zh-Hans' => '106，107', 'en' => '106, 107', 'ja' => '106, 107' },
        'D' => { 'zh-Hant' => '106，109', 'zh-Hans' => '106，109', 'en' => '106, 109', 'ja' => '106, 109' },
      },
      'correctAnswer' => { 'type' => 'choice', 'value' => 'D' },
      'source' => official_source('選擇 5'),
    },
    {
      'id' => 'arithmetic_grade1_foundation_053',
      'topic' => 'arithmetic',
      'subtopic' => 'pattern',
      'difficulty' => 'foundation',
      'levelStage' => 'grade1',
      'challengeTier' => 'foundation',
      'prompt' => {
        'zh-Hant' => '同一個數列：1，4，8，11，22，25，50，53，106，109，……。從第幾個數開始，會第一次出現百位數是 2 的三位數？',
        'zh-Hans' => '同一个数列：1，4，8，11，22，25，50，53，106，109，……。从第几个数开始，会第一次出现百位数是 2 的三位数？',
        'en' => 'Consider the same sequence: 1, 4, 8, 11, 22, 25, 50, 53, 106, 109, .... At which term does a three-digit number with hundreds digit 2 appear for the first time?',
        'ja' => '同じ数列 1、4、8、11、22、25、50、53、106、109、…… について、百の位が 2 の3けたの数が初めて出るのは第何項ですか。',
      },
      'answer' => {
        'zh-Hant' => '答案是第 11 個。',
        'zh-Hans' => '答案是第 11 个。',
        'en' => 'The answer is the 11th term.',
        'ja' => '答えは 11 番目です。',
      },
      'solutionSteps' => {
        'zh-Hant' => [
          '前 10 個數依序到 109 為止，百位數都還不是 2。',
          '下一步是把 109 乘 2，得到 218。',
          '218 是第一個百位數是 2 的三位數，所以答案是第 11 個。',
        ],
        'zh-Hans' => [
          '前 10 个数依序到 109 为止，百位数都还不是 2。',
          '下一步是把 109 乘 2，得到 218。',
          '218 是第一个百位数是 2 的三位数，所以答案是第 11 个。',
        ],
        'en' => [
          'The first 10 terms go only up to 109, whose hundreds digit is 1.',
          'The next step doubles 109 to get 218.',
          'Since 218 is the first three-digit number with hundreds digit 2, it appears at the 11th term.',
        ],
        'ja' => [
          '最初の10個は 109 までで、百の位はまだ 2 ではありません。',
          '次は 109 を 2 倍して 218 になります。',
          '218 が百の位が 2 の最初の3けたの数なので、答えは 11 番目です。',
        ],
      },
      'figure' => { 'type' => 'custom', 'kind' => 'none', 'params' => {} },
      'answerMode' => 'multiple_choice',
      'options' => {
        'A' => { 'zh-Hant' => '9', 'zh-Hans' => '9', 'en' => '9', 'ja' => '9' },
        'B' => { 'zh-Hant' => '10', 'zh-Hans' => '10', 'en' => '10', 'ja' => '10' },
        'C' => { 'zh-Hant' => '11', 'zh-Hans' => '11', 'en' => '11', 'ja' => '11' },
        'D' => { 'zh-Hant' => '12', 'zh-Hans' => '12', 'en' => '12', 'ja' => '12' },
      },
      'correctAnswer' => { 'type' => 'choice', 'value' => 'C' },
      'source' => official_source('選擇 6'),
    },
    {
      'id' => 'arithmetic_grade1_foundation_054',
      'topic' => 'arithmetic',
      'subtopic' => 'calendar_rule',
      'difficulty' => 'foundation',
      'levelStage' => 'grade1',
      'challengeTier' => 'foundation',
      'prompt' => {
        'zh-Hant' => '已知西元 2012 年是閏年，而且題目只用「每 4 年一閏」這個規則來判斷。下面哪一年也會是閏年？',
        'zh-Hans' => '已知西元 2012 年是闰年，而且题目只用“每 4 年一闰”这个规则来判断。下面哪一年也会是闰年？',
        'en' => 'Suppose we use only the rule “every 4 years is a leap year,” and 2012 is known to be a leap year. Which year below would also be a leap year?',
        'ja' => '2012年がうるう年で、「4年ごとにうるう年」という規則だけを使って考えます。次のうち、どの年もうるう年になりますか。',
      },
      'answer' => {
        'zh-Hant' => '答案是 2048 年。',
        'zh-Hans' => '答案是 2048 年。',
        'en' => 'The answer is 2048.',
        'ja' => '答えは 2048 年です。',
      },
      'solutionSteps' => {
        'zh-Hant' => [
          '依題目規則，只要年份能被 4 整除，就算閏年。',
          '2048 ÷ 4 沒有餘數。',
          '其他選項不能被 4 整除，所以答案是 2048 年。',
        ],
        'zh-Hans' => [
          '依题目规则，只要年份能被 4 整除，就算闰年。',
          '2048 ÷ 4 没有余数。',
          '其他选项不能被 4 整除，所以答案是 2048 年。',
        ],
        'en' => [
          'By the rule in the problem, a leap year must be divisible by 4.',
          '2048 is divisible by 4.',
          'The other choices are not, so the answer is 2048.',
        ],
        'ja' => [
          'この問題の規則では、4 で割り切れる年がうるう年です。',
          '2048 は 4 で割り切れます。',
          '他の選択肢は割り切れないので、答えは 2048 年です。',
        ],
      },
      'figure' => { 'type' => 'custom', 'kind' => 'none', 'params' => {} },
      'answerMode' => 'multiple_choice',
      'options' => {
        'A' => { 'zh-Hant' => '2048', 'zh-Hans' => '2048', 'en' => '2048', 'ja' => '2048' },
        'B' => { 'zh-Hant' => '2077', 'zh-Hans' => '2077', 'en' => '2077', 'ja' => '2077' },
        'C' => { 'zh-Hant' => '2081', 'zh-Hans' => '2081', 'en' => '2081', 'ja' => '2081' },
        'D' => { 'zh-Hant' => '2045', 'zh-Hans' => '2045', 'en' => '2045', 'ja' => '2045' },
      },
      'correctAnswer' => { 'type' => 'choice', 'value' => 'A' },
      'source' => official_source('選擇 7'),
    },
    {
      'id' => 'arithmetic_grade1_foundation_055',
      'topic' => 'arithmetic',
      'subtopic' => 'common_multiple',
      'difficulty' => 'foundation',
      'levelStage' => 'grade1',
      'challengeTier' => 'foundation',
      'prompt' => {
        'zh-Hant' => '虹虹依序說 5、10、15……；伶伶依序說 7、14、21……；玟玟依序說 3、6、9、12……。三個人第一次會同時說到哪一個數？',
        'zh-Hans' => '虹虹依序说 5、10、15……；伶伶依序说 7、14、21……；玟玟依序说 3、6、9、12……。三个人第一次会同时说到哪一个数？',
        'en' => 'Honghong says 5, 10, 15, ...; Lingling says 7, 14, 21, ...; and Wenwen says 3, 6, 9, 12, .... What is the first number all three of them will say?',
        'ja' => 'こうこうは 5、10、15、……、れいれいは 7、14、21、……、うぇんうぇんは 3、6、9、12、…… と言います。3人が初めて同時に言う数は何ですか。',
      },
      'answer' => {
        'zh-Hant' => '答案是 105。',
        'zh-Hans' => '答案是 105。',
        'en' => 'The answer is 105.',
        'ja' => '答えは 105 です。',
      },
      'solutionSteps' => {
        'zh-Hant' => [
          '要同時說到，這個數必須同時是 5、7、3 的倍數。',
          '先看 5 和 7 的最小公倍數是 35。',
          '35 不是 3 的倍數，再往下一個共同倍數看：70 也不是。',
          '105 同時是 3、5、7 的倍數，所以第一個是 105。',
        ],
        'zh-Hans' => [
          '要同时说到，这个数必须同时是 5、7、3 的倍数。',
          '先看 5 和 7 的最小公倍数是 35。',
          '35 不是 3 的倍数，再往下一个共同倍数看：70 也不是。',
          '105 同时是 3、5、7 的倍数，所以第一个是 105。',
        ],
        'en' => [
          'The number must be a common multiple of 5, 7, and 3.',
          'The least common multiple of 5 and 7 is 35.',
          '35 is not a multiple of 3, and 70 is not either.',
          '105 is a multiple of 3, 5, and 7, so it is the first one.',
        ],
        'ja' => [
          '同時に言うには、その数が 5、7、3 の共通の倍数である必要があります。',
          'まず 5 と 7 の最小公倍数は 35 です。',
          '35 は 3 の倍数ではなく、70 も違います。',
          '105 は 3、5、7 すべての倍数なので、最初の数は 105 です。',
        ],
      },
      'figure' => { 'type' => 'custom', 'kind' => 'none', 'params' => {} },
      'answerMode' => 'multiple_choice',
      'options' => {
        'A' => { 'zh-Hant' => '15', 'zh-Hans' => '15', 'en' => '15', 'ja' => '15' },
        'B' => { 'zh-Hant' => '21', 'zh-Hans' => '21', 'en' => '21', 'ja' => '21' },
        'C' => { 'zh-Hant' => '35', 'zh-Hans' => '35', 'en' => '35', 'ja' => '35' },
        'D' => { 'zh-Hant' => '105', 'zh-Hans' => '105', 'en' => '105', 'ja' => '105' },
      },
      'correctAnswer' => { 'type' => 'choice', 'value' => 'D' },
      'source' => official_source('選擇 8'),
    },
    {
      'id' => 'arithmetic_grade1_foundation_056',
      'topic' => 'arithmetic',
      'subtopic' => 'clock_counting',
      'difficulty' => 'foundation',
      'levelStage' => 'grade1',
      'challengeTier' => 'foundation',
      'prompt' => {
        'zh-Hant' => '有一座古董鐘，只要分針指到 6 就敲 1 下。一天共有 24 小時，請問這座鐘一整天會因為分針指到 6 而敲幾下？',
        'zh-Hans' => '有一座古董钟，只要分针指到 6 就敲 1 下。一天共有 24 小时，请问这座钟一整天会因为分针指到 6 而敲几下？',
        'en' => 'An old clock strikes once whenever the minute hand points to 6. Over a full 24-hour day, how many times does it strike for this reason?',
        'ja' => '古い時計は、分針が 6 を指すたびに 1 回鳴ります。24 時間で、この理由だけで全部で何回鳴りますか。',
      },
      'answer' => {
        'zh-Hant' => '答案是 24 下。',
        'zh-Hans' => '答案是 24 下。',
        'en' => 'The answer is 24.',
        'ja' => '答えは 24 回です。',
      },
      'solutionSteps' => {
        'zh-Hant' => [
          '分針每小時會有一次指到 6，也就是每小時敲 1 下。',
          '一天有 24 小時。',
          '所以一整天共敲 24 下。',
        ],
        'zh-Hans' => [
          '分针每小时会有一次指到 6，也就是每小时敲 1 下。',
          '一天有 24 小时。',
          '所以一整天共敲 24 下。',
        ],
        'en' => [
          'The minute hand points to 6 once every hour.',
          'There are 24 hours in a day.',
          'So the clock strikes 24 times in one full day.',
        ],
        'ja' => [
          '分針が 6 を指すのは 1 時間に 1 回です。',
          '1 日は 24 時間あります。',
          'したがって 1 日で 24 回鳴ります。',
        ],
      },
      'figure' => { 'type' => 'custom', 'kind' => 'none', 'params' => {} },
      'answerMode' => 'multiple_choice',
      'options' => {
        'A' => { 'zh-Hant' => '18', 'zh-Hans' => '18', 'en' => '18', 'ja' => '18' },
        'B' => { 'zh-Hant' => '12', 'zh-Hans' => '12', 'en' => '12', 'ja' => '12' },
        'C' => { 'zh-Hant' => '24', 'zh-Hans' => '24', 'en' => '24', 'ja' => '24' },
        'D' => { 'zh-Hant' => '36', 'zh-Hans' => '36', 'en' => '36', 'ja' => '36' },
      },
      'correctAnswer' => { 'type' => 'choice', 'value' => 'C' },
      'source' => official_source('選擇 9'),
    },
    {
      'id' => 'arithmetic_grade1_foundation_057',
      'topic' => 'arithmetic',
      'subtopic' => 'clock_counting',
      'difficulty' => 'foundation',
      'levelStage' => 'grade1',
      'challengeTier' => 'foundation',
      'prompt' => {
        'zh-Hant' => '同一座鐘除了分針指到 6 會敲 1 下之外，還會在奇數整點時敲和鐘點相同的下數：1 點敲 1 下、3 點敲 3 下、5 點敲 5 下、7 點敲 7 下、9 點敲 9 下、11 點敲 11 下。24 小時內把這些整點敲鐘和分針敲鐘都算進去，總共會敲幾下？',
        'zh-Hans' => '同一座钟除了分针指到 6 会敲 1 下之外，还会在奇数整点时敲和钟点相同的下数：1 点敲 1 下、3 点敲 3 下、5 点敲 5 下、7 点敲 7 下、9 点敲 9 下、11 点敲 11 下。24 小时内把这些整点敲钟和分针敲钟都算进去，总共会敲几下？',
        'en' => 'The same clock also strikes on odd hours: 1 time at 1 o’clock, 3 times at 3 o’clock, 5 times at 5 o’clock, 7 times at 7 o’clock, 9 times at 9 o’clock, and 11 times at 11 o’clock. Over 24 hours, if you count both these odd-hour strikes and the strikes when the minute hand points to 6, how many total strikes are there?',
        'ja' => '同じ時計は、分針が 6 を指すと 1 回鳴るほか、奇数の時刻にも 1 時に1回、3時に3回、5時に5回、7時に7回、9時に9回、11時に11回鳴ります。24時間で、これらの時報と分針による鳴る回数を全部合わせると何回ですか。',
      },
      'answer' => {
        'zh-Hant' => '答案是 96 下。',
        'zh-Hans' => '答案是 96 下。',
        'en' => 'The answer is 96.',
        'ja' => '答えは 96 回です。',
      },
      'solutionSteps' => {
        'zh-Hant' => [
          '分針指到 6 的敲鐘，一天共有 24 下。',
          '奇數整點在 12 小時內共敲 1+3+5+7+9+11 = 36 下。',
          '24 小時要經過兩輪 12 小時，所以整點奇數敲鐘共有 36 × 2 = 72 下。',
          '全部合起來是 24 + 72 = 96 下。',
        ],
        'zh-Hans' => [
          '分针指到 6 的敲钟，一天共有 24 下。',
          '奇数整点在 12 小时内共敲 1+3+5+7+9+11 = 36 下。',
          '24 小时要经过两轮 12 小时，所以整点奇数敲钟共有 36 × 2 = 72 下。',
          '全部合起来是 24 + 72 = 96 下。',
        ],
        'en' => [
          'The minute-hand strikes contribute 24 strikes in a day.',
          'In one 12-hour cycle, the odd-hour strikes total 1+3+5+7+9+11 = 36.',
          'A 24-hour day contains two 12-hour cycles, so the odd-hour strikes total 72.',
          'Together, the total is 24 + 72 = 96.',
        ],
        'ja' => [
          '分針が 6 を指すときの鳴る回数は 1 日で 24 回です。',
          '12 時間で奇数時の時報は 1+3+5+7+9+11 = 36 回です。',
          '24 時間ではこれが 2 回あるので、時報は 72 回です。',
          '合わせて 24 + 72 = 96 回です。',
        ],
      },
      'figure' => { 'type' => 'custom', 'kind' => 'none', 'params' => {} },
      'answerMode' => 'multiple_choice',
      'options' => {
        'A' => { 'zh-Hant' => '90', 'zh-Hans' => '90', 'en' => '90', 'ja' => '90' },
        'B' => { 'zh-Hant' => '96', 'zh-Hans' => '96', 'en' => '96', 'ja' => '96' },
        'C' => { 'zh-Hant' => '108', 'zh-Hans' => '108', 'en' => '108', 'ja' => '108' },
        'D' => { 'zh-Hant' => '84', 'zh-Hans' => '84', 'en' => '84', 'ja' => '84' },
      },
      'correctAnswer' => { 'type' => 'choice', 'value' => 'B' },
      'source' => official_source('選擇 10'),
    },
  ],
)

puts 'Appended first official IMC 2015 grade1 preliminary batch.'
