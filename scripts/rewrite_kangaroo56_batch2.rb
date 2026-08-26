require 'json'

path = 'assets/questions/mixed/kangaroo56_foundation.mixed.v1.json'
pack = JSON.parse(File.read(path))

def i18n(zh, en, hs, ja)
  { 'zh-Hant' => zh, 'en' => en, 'zh-Hans' => hs, 'ja' => ja }
end

def replacement(prompt, answer, steps, value, subtopic)
  {
    'topic' => 'mixed', 'subtopic' => subtopic, 'difficulty' => 'foundation',
    'levelStage' => 'grade6', 'challengeTier' => 'foundation',
    'reviewStatus' => 'ok',
    'prompt' => prompt, 'answer' => answer, 'solutionSteps' => steps,
    'figure' => { 'type' => 'custom', 'kind' => 'none', 'params' => {} },
    'answerMode' => 'integer_input',
    'correctAnswer' => { 'type' => 'integer', 'value' => value.to_s },
    'inputConstraints' => { 'allowNegative' => false, 'maxDigits' => 3 },
    'source' => {
      'type' => 'rewritten_olympiad_style',
      'name' => 'Original olympiad-style design',
      'reference' => 'kangaroo56-rewrite-batch2',
      'notes' => 'Original replacement created for the legacy-pack deduplication audit.'
    }
  }
end

updates = {
  '004' => replacement(
    i18n('一個瓶子原本裝到六分之五滿。倒出 180 毫升後，瓶子變成二分之一滿。這個瓶子的容量是多少毫升？', 'A bottle is initially five-sixths full. After 180 mL is poured out, it is one-half full. What is the capacity of the bottle in mL?', '一个瓶子原本装到六分之五满。倒出 180 毫升后，瓶子变成二分之一满。这个瓶子的容量是多少毫升？', 'あるびんは最初6分の5まで入っています。180mLを注ぐと2分の1になりました。このびんの容量は何mLですか。'),
    i18n('答案是 540 毫升。', 'The answer is 540 mL.', '答案是 540 毫升。', '答えは540mLです。'),
    i18n(['倒出的量是整個容量的 5/6−1/2=1/3。', '所以容量是 180÷(1/3)=540 毫升。'], ['The poured-out amount is 5/6−1/2=1/3 of the capacity.', 'So the capacity is 180÷(1/3)=540 mL.'], ['倒出的量是整个容量的 5/6−1/2=1/3。', '所以容量是 180÷(1/3)=540 毫升。'], ['注いだ量は容量の5/6−1/2=1/3です。', 'したがって容量は180÷(1/3)=540mLです。']), 540, 'capacity_ratio'
  ),
  '005' => replacement(
    i18n('在方格交點上，從 (0,0) 走到 (4,3)，每一步只能向右或向上，而且必須經過 (2,1)。最短路線有幾條？', 'On grid points, travel from (0,0) to (4,3), moving only right or up and passing through (2,1). How many shortest paths are there?', '在方格交点上，从 (0,0) 走到 (4,3)，每一步只能向右或向上，而且必须经过 (2,1)。最短路线有几条？', '方眼の格子点で、(0,0)から(4,3)まで右または上にだけ進み、(2,1)を必ず通ります。最短経路は何通りですか。'),
    i18n('答案是 18。', 'The answer is 18.', '答案是 18。', '答えは18です。'),
    i18n(['到 (2,1) 要走 2 右、1 上，共有 3 種順序。', '從 (2,1) 到 (4,3) 要走 2 右、2 上，共有 6 種順序。', '兩段可獨立選擇，所以共有 3×6=18 條。'], ['To reach (2,1), arrange 2 right moves and 1 up move: 3 ways.', 'From (2,1) to (4,3), arrange 2 right and 2 up moves: 6 ways.', 'The choices are independent, so there are 3×6=18 paths.'], ['到 (2,1) 要走 2 右、1 上，共有 3 种顺序。', '从 (2,1) 到 (4,3) 要走 2 右、2 上，共有 6 种顺序。', '两段可独立选择，所以共有 3×6=18 条。'], ['(2,1)までは右に2回、上に1回で、順序は3通りです。', '(2,1)から(4,3)までは右に2回、上に2回で、6通りです。', '2つの区間は独立なので、3×6=18通りです。']), 18, 'constrained_lattice_paths'
  ),
  '006' => replacement(
    i18n('把 3 的正倍數依序寫成 3、6、9、12、15、18、⋯，再把它們連成一串：369121518⋯。這串數字中的第 12 個數字是什麼？', 'Write the positive multiples of 3 in order—3, 6, 9, 12, 15, 18, …—and concatenate them as 369121518…. What is the 12th digit?', '把 3 的正倍数依序写成 3、6、9、12、15、18、⋯，再把它们连成一串：369121518⋯。这串数字中的第 12 个数字是什么？', '3の正の倍数を3、6、9、12、15、18、…の順に書き、369121518…とつなげます。この数字列の12番目の数字は何ですか。'),
    i18n('答案是 4。', 'The answer is 4.', '答案是 4。', '答えは4です。'),
    i18n(['前 3 個一位數 3、6、9 共占 3 個位置。', '第 12 個位置是接下來兩位數部分的第 9 個位置，也就是第 5 個兩位數 24 的個位。', '所以第 12 個數字是 4。'], ['The first three one-digit terms, 3, 6, and 9, use 3 positions.', 'Position 12 is the 9th position in the two-digit part: the ones digit of the fifth two-digit term, 24.', 'So the 12th digit is 4.'], ['前 3 个一位数 3、6、9 共占 3 个位置。', '第 12 个位置是接下来两位数部分的第 9 个位置，也就是第 5 个两位数 24 的个位。', '所以第 12 个数字是 4。'], ['最初の1けたの項3、6、9は3つの位置を使います。', '12番目は2けた部分の9番目で、5番目の2けたの項24の一の位です。', 'よって12番目の数字は4です。']), 4, 'digit_string_indexing'
  )
}

pack['questions'].each do |question|
  key = question['id'].split('_').last
  next unless updates[key]

  question.replace({ 'id' => question['id'] }.merge(updates[key]))
end

File.write(path, JSON.pretty_generate(pack) + "\n")
