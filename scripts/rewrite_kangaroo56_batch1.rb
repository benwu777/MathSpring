require 'json'

path = 'assets/questions/mixed/kangaroo56_foundation.mixed.v1.json'
pack = JSON.parse(File.read(path))

def replacement(prompt, answer, steps, value, subtopic)
  {
    'topic' => 'mixed', 'subtopic' => subtopic, 'difficulty' => 'foundation',
    'levelStage' => 'grade6', 'challengeTier' => 'foundation',
    'reviewStatus' => 'ok',
    'prompt' => prompt, 'answer' => answer, 'solutionSteps' => steps,
    'figure' => { 'type' => 'custom', 'kind' => 'none', 'params' => {} },
    'answerMode' => 'integer_input',
    'correctAnswer' => { 'type' => 'integer', 'value' => value.to_s },
    'inputConstraints' => { 'allowNegative' => false, 'maxDigits' => 2 },
    'source' => {
      'type' => 'rewritten_olympiad_style',
      'name' => 'Original olympiad-style design',
      'reference' => 'kangaroo56-rewrite-batch1',
      'notes' => 'Original replacement created for the legacy-pack deduplication audit.'
    }
  }
end

def i18n(zh, en, hs, ja)
  { 'zh-Hant' => zh, 'en' => en, 'zh-Hans' => hs, 'ja' => ja }
end

updates = {
  '001' => replacement(
    i18n('用數字 1、4、7 各一次排成三位數。大於 400、但小於 700 的數有幾個？', 'Use 1, 4, and 7 once each to make three-digit numbers. How many are greater than 400 but less than 700?', '用数字 1、4、7 各一次排成三位数。大于 400、但小于 700 的数有几个？', '1、4、7を1回ずつ使って3けたの数を作ります。400より大きく700より小さい数はいくつですか。'),
    i18n('答案是 4。', 'The answer is 4.', '答案是 4。', '答えは4です。'),
    i18n(['百位必須是 4。', '十位和個位由 1、7 排列，有 2 種。'], ['The hundreds digit must be 4.', 'The remaining digits 1 and 7 can be arranged in 2 ways.'], ['百位必须是 4。', '十位和个位由 1、7 排列，有 2 种。'], ['百の位は4です。', '残りの1と7は2通りに並べられます。']), 2, 'digit_arrangement'
  ),
  '002' => replacement(
    i18n('甲、乙、丙、丁四人排成一列。甲緊接在乙的左邊，丙在丁的左邊。共有幾種不同排法？', 'A, B, C, and D stand in a row. A is immediately left of B, and C is left of D. How many arrangements are possible?', '甲、乙、丙、丁四人排成一列。甲紧接在乙的左边，丙在丁的左边。共有几种不同排法？', 'A、B、C、Dの4人が一列に並びます。AはBのすぐ左、CはDの左です。並び方は何通りですか。'),
    i18n('答案是 3。', 'The answer is 3.', '答案是 3。', '答えは3です。'),
    i18n(['把甲乙看成一個相鄰的組。', '三個單位的排列中，丙必須在丁左邊，所以 3!÷2 = 3。'], ['Treat A and B as one block.', 'Among the arrangements of three units, C must be left of D, so 3!÷2 = 3.'], ['把甲乙看成一个相邻的组。', '三个单位的排列中，丙必须在丁左边，所以 3!÷2 = 3。'], ['AとBを1つのまとまりと見ます。', '3つの単位の並びでCはDの左なので、3!÷2 = 3です。']), 3, 'arrangement_counting'
  ),
  '003' => replacement(
    i18n('把 3×3 方格的正中央一格挖掉。剩下圖形的外圍共有幾條長度為 1 的小邊？', 'Remove the center cell from a 3×3 grid. How many unit-length edges are on the boundary of the remaining shape?', '把 3×3 方格的正中央一格挖掉。剩下图形的外围共有几条长度为 1 的小边？', '3×3の方眼の中央の1マスを取り除きます。残った図形の境界には長さ1の辺が何本ありますか。'),
    i18n('答案是 16。', 'The answer is 16.', '答案是 16。', '答えは16です。'),
    i18n(['原本 3×3 正方形的外圍有 12 條小邊。', '挖掉中央格後，洞的四邊也成為外圍，所以共有 12+4=16 條。'], ['The outer boundary of the 3×3 square has 12 unit edges.', 'Removing the center adds the four edges of the hole, giving 12+4=16.'], ['原本 3×3 正方形的外围有 12 条小边。', '挖掉中央格后，洞的四边也成为外围，所以共有 12+4=16 条。'], ['もとの3×3正方形の外周は12本です。', '中央を除くと穴の4辺も境界になり、12+4=16本です。']), 16, 'boundary_counting'
  )
}

pack['questions'].each do |question|
  key = question['id'].split('_').last
  next unless updates[key]

  question.replace({ 'id' => question['id'] }.merge(updates[key]))
end

File.write(path, JSON.pretty_generate(pack) + "\n")
