require 'json'

path = 'assets/questions/mixed/kangaroo56_foundation.mixed.v1.json'
pack = JSON.parse(File.read(path))

def i18n(zh, en, hs, ja)
  { 'zh-Hant' => zh, 'en' => en, 'zh-Hans' => hs, 'ja' => ja }
end

def base(subtopic, prompt, answer, steps)
  {
    'topic' => 'mixed', 'subtopic' => subtopic, 'difficulty' => 'foundation',
    'levelStage' => 'grade6', 'challengeTier' => 'foundation',
    'reviewStatus' => 'ok',
    'prompt' => prompt, 'answer' => answer, 'solutionSteps' => steps,
    'figure' => { 'type' => 'custom', 'kind' => 'none', 'params' => {} },
    'source' => {
      'type' => 'rewritten_olympiad_style',
      'name' => 'Original olympiad-style design',
      'reference' => 'kangaroo56-rewrite-batch3',
      'notes' => 'Original replacement created for the legacy-pack deduplication audit.'
    }
  }
end

updates = {
  '007' => base(
    'inclusion_exclusion_area',
    i18n('一個長 7、寬 5 的長方形和一個長 6、寬 4 的長方形部分重疊。兩個長方形合起來的面積是 47。重疊部分的面積是多少？', 'A 7-by-5 rectangle and a 6-by-4 rectangle overlap. Their combined area is 47. What is the area of the overlap?', '一个长 7、宽 5 的长方形和一个长 6、宽 4 的长方形部分重叠。两个长方形合起来的面积是 47。重叠部分的面积是多少？', '縦7、横5の長方形と、縦6、横4の長方形が一部重なっています。2つを合わせた面積は47です。重なった部分の面積はいくつですか。'),
    i18n('答案是 12。', 'The answer is 12.', '答案是 12。', '答えは12です。'),
    i18n(['兩個長方形面積分別是 7×5=35 和 6×4=24。', '若沒有重疊，總和是 59。', '重疊部分被算了兩次，所以重疊面積是 59−47=12。'], ['The rectangle areas are 7×5=35 and 6×4=24.', 'Their sum without correcting overlap is 59.', 'The overlap was counted twice, so it is 59−47=12.'], ['两个长方形面积分别是 7×5=35 和 6×4=24。', '若没有重叠，总和是 59。', '重叠部分被算了两次，所以重叠面积是 59−47=12。'], ['長方形の面積はそれぞれ7×5=35、6×4=24です。', '重なりを直さない合計は59です。', '重なり部分は2回数えているので、59−47=12です。'])
  ).merge(
    'answerMode' => 'integer_input',
    'correctAnswer' => { 'type' => 'integer', 'value' => '12' },
    'inputConstraints' => { 'allowNegative' => false, 'maxDigits' => 2 }
  ),
  '008' => base(
    'nested_truth_statements',
    i18n('甲、乙、丙三人比跳遠，只有一人是第一名。甲說：「我不是第一名。」乙說：「甲是第一名。」丙說：「乙說的是假話。」已知恰好只有一句話是真的，誰是第一名？', 'A, B, and C compete in long jump, and exactly one is first. A says, “I am not first.” B says, “A is first.” C says, “B is lying.” Exactly one statement is true. Who is first?', '甲、乙、丙三人比跳远，只有一人是第一名。甲说：“我不是第一名。”乙说：“甲是第一名。”丙说：“乙说的是假话。”已知恰好只有一句话是真的，谁是第一名？', 'A、B、Cの3人が走り幅跳びをし、1位は1人だけです。Aは「私は1位ではない」、Bは「Aが1位だ」、Cは「Bはうそを言っている」と言いました。真実はちょうど1つです。1位は誰ですか。'),
    i18n('答案是甲。', 'The answer is A.', '答案是甲。', '答えはAです。'),
    i18n(['若甲是第一名，甲的話是假、乙的話是真、丙的話是假，剛好一真。', '若乙或丙是第一名，甲和丙的話都是真，會有兩句真話。', '所以第一名是甲。'], ['If A is first, A is false, B is true, and C is false: exactly one truth.', 'If B or C is first, both A and C are true, giving two truths.', 'Therefore A is first.'], ['若甲是第一名，甲的话是假、乙的话是真、丙的话是假，刚好一真。', '若乙或丙是第一名，甲和丙的话都是真，会有两句真话。', '所以第一名是甲。'], ['Aが1位なら、Aは偽、Bは真、Cは偽で、真実は1つです。', 'BまたはCが1位なら、AとCがともに真になり、真実が2つになります。', 'よって1位はAです。'])
  ).merge(
    'answerMode' => 'multiple_choice',
    'options' => {
      'A' => i18n('甲', 'A', '甲', 'A'),
      'B' => i18n('乙', 'B', '乙', 'B'),
      'C' => i18n('丙', 'C', '丙', 'C')
    },
    'correctAnswer' => { 'type' => 'choice', 'value' => 'A' }
  ),
  '009' => base(
    'simultaneous_remainders',
    i18n('大於 10 的最小正整數，除以 3、4、5 時分別餘 2、3、4，是多少？', 'What is the smallest positive integer greater than 10 that leaves remainders 2, 3, and 4 when divided by 3, 4, and 5 respectively?', '大于 10 的最小正整数，除以 3、4、5 时分别余 2、3、4，是多少？', '10より大きい最小の正の整数で、3、4、5で割るとそれぞれ2、3、4余る数はいくつですか。'),
    i18n('答案是 59。', 'The answer is 59.', '答案是 59。', '答えは59です。'),
    i18n(['這個數比 3、4、5 的共同倍數少 1。', '3、4、5 的最小公倍數是 60。', '所以最小符合的正整數是 60−1=59。'], ['The number is 1 less than a common multiple of 3, 4, and 5.', 'Their least common multiple is 60.', 'So the smallest matching positive integer is 60−1=59.'], ['这个数比 3、4、5 的共同倍数少 1。', '3、4、5 的最小公倍数是 60。', '所以最小符合的正整数是 60−1=59。'], ['この数は3、4、5の公倍数より1小さい数です。', '3、4、5の最小公倍数は60です。', 'よって最小の条件に合う正の整数は60−1=59です。'])
  ).merge(
    'answerMode' => 'integer_input',
    'correctAnswer' => { 'type' => 'integer', 'value' => '59' },
    'inputConstraints' => { 'allowNegative' => false, 'maxDigits' => 2 }
  )
}

pack['questions'].each do |question|
  key = question['id'].split('_').last
  next unless updates[key]

  question.replace({ 'id' => question['id'] }.merge(updates[key]))
end

File.write(path, JSON.pretty_generate(pack) + "\n")
