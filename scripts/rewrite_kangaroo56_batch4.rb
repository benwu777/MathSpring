require 'json'

path = 'assets/questions/mixed/kangaroo56_foundation.mixed.v1.json'
pack = JSON.parse(File.read(path))

def t(zh, en, hs, ja)
  { 'zh-Hant' => zh, 'en' => en, 'zh-Hans' => hs, 'ja' => ja }
end

def q(subtopic, prompt, answer, steps, value)
  {
    'topic' => 'mixed', 'subtopic' => subtopic, 'difficulty' => 'foundation',
    'levelStage' => 'grade6', 'challengeTier' => 'foundation', 'reviewStatus' => 'ok',
    'prompt' => prompt, 'answer' => answer, 'solutionSteps' => steps,
    'figure' => { 'type' => 'custom', 'kind' => 'none', 'params' => {} },
    'answerMode' => 'integer_input',
    'correctAnswer' => { 'type' => 'integer', 'value' => value.to_s },
    'inputConstraints' => { 'allowNegative' => false, 'maxDigits' => 1 },
    'source' => { 'type' => 'rewritten_olympiad_style', 'name' => 'Original olympiad-style design', 'reference' => 'kangaroo56-rewrite-batch4', 'notes' => 'Original replacement created for the legacy-pack deduplication audit.' }
  }
end

updates = {
  '010' => q('weight_elimination',
    t('三個砝碼甲、乙、丙中：甲乙共重 11，乙丙共重 13，甲丙共重 14。丙重多少？', 'Three weights A, B, and C satisfy A+B=11, B+C=13, and A+C=14. What is the weight of C?', '三个砝码甲、乙、丙中：甲乙共重 11，乙丙共重 13，甲丙共重 14。丙重多少？', '3つのおもりA、B、Cで、A+B=11、B+C=13、A+C=14です。Cの重さはいくつですか。'),
    t('答案是 8。', 'The answer is 8.', '答案是 8。', '答えは8です。'),
    t(['三個等式相加，得到 2(甲+乙+丙)=38。', '所以三個砝碼總重 19。', '丙=19−11=8。'], ['Adding gives 2(A+B+C)=38.', 'Thus the total is 19.', 'C=19−11=8.'], ['三个等式相加，得到 2(甲+乙+丙)=38。', '所以三个砝码总重 19。', '丙=19−11=8。'], ['3つの式を足すと2(A+B+C)=38です。', '合計は19です。', 'C=19−11=8です。']), 8),
  '011' => q('climb_slip_progression',
    t('蝸牛白天向上爬 4 公尺，晚上滑下 1 公尺。一面牆高 13 公尺。蝸牛從地面開始，要第幾天白天首次到達牆頂？', 'A snail climbs 4 m each day and slips 1 m each night. A wall is 13 m high. On which day does it first reach the top?', '蜗牛白天向上爬 4 米，晚上滑下 1 米。一面墙高 13 米。蜗牛从地面开始，要第几天白天首次到达墙顶？', 'かたつむりは昼に4m登り、夜に1m滑ります。壁は13mです。地面から始めて、何日目の昼に初めて頂上に着きますか。'),
    t('答案是第 5 天。', 'The answer is day 5.', '答案是第 5 天。', '答えは5日目です。'),
    t(['每個完整晝夜淨增加 3 公尺。', '第 4 晚後在 12 公尺。', '第 5 天再爬 4 公尺，首次到達牆頂。'], ['Each full day-night cycle gains 3 m.', 'After night 4, it is at 12 m.', 'On day 5 it climbs another 4 m and reaches the top.'], ['每个完整昼夜净增加 3 米。', '第 4 晚后在 12 米。', '第 5 天再爬 4 米，首次到达墙顶。'], ['昼夜1組で3m進みます。', '4日目の夜の後は12mです。', '5日目にさらに4m登って頂上に着きます。']), 5),
  '012' => q('rectangle_system',
    t('一個長方形的周長是 30 公分，面積是 56 平方公分。較長的邊長是多少公分？', 'A rectangle has perimeter 30 cm and area 56 cm². What is the length of its longer side?', '一个长方形的周长是 30 公分，面积是 56 平方公分。较长的边长是多少公分？', '長方形の周の長さは30cm、面積は56cm²です。長い辺の長さは何cmですか。'),
    t('答案是 8 公分。', 'The answer is 8 cm.', '答案是 8 公分。', '答えは8cmです。'),
    t(['長和寬的和是 30÷2=15。', '相乘為 56、相加為 15 的兩數是 7 和 8。', '較長邊是 8 公分。'], ['The side lengths sum to 30÷2=15.', 'The numbers with product 56 and sum 15 are 7 and 8.', 'The longer side is 8 cm.'], ['长和宽的和是 30÷2=15。', '相乘为 56、相加为 15 的两数是 7 和 8。', '较长边是 8 公分。'], ['2辺の和は30÷2=15です。', '積が56で和が15の数は7と8です。', '長い辺は8cmです。']), 8)
}
pack['questions'].each { |question| key = question['id'].split('_').last; question.replace({ 'id' => question['id'] }.merge(updates[key])) if updates[key] }
File.write(path, JSON.pretty_generate(pack) + "\n")
