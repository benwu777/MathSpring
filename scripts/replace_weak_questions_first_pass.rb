#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require 'pathname'

ROOT = Pathname.new(__dir__).join('..').expand_path
QUESTION_FILES = Dir[ROOT.join('assets/questions/**/*.json').to_s]

def loc(zh_hant:, en:)
  {
    'zh-Hant' => zh_hant,
    'zh-Hans' => zh_hant,
    'en' => en,
    'ja' => en
  }
end

def steps(*pairs)
  {
    'zh-Hant' => pairs.map(&:first),
    'zh-Hans' => pairs.map(&:first),
    'en' => pairs.map(&:last),
    'ja' => pairs.map(&:last)
  }
end

REPLACEMENTS = {
  'arithmetic_grade1_foundation_026' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '紅盒裡的糖果比藍盒多 3 顆。如果把藍盒再放進 2 顆，兩盒就一共是 11 顆。紅盒原本有幾顆糖果？',
        en: 'The red box has 3 more candies than the blue box. If 2 more candies are put into the blue box, the two boxes together have 11 candies. How many candies were originally in the red box?'
      ),
      'answer' => loc(
        zh_hant: '答案是 6 顆。',
        en: 'The answer is 6.'
      ),
      'solutionSteps' => steps(
        ['先想像藍盒補上 2 顆後，藍盒和紅盒的差仍然是 1 顆。', 'After adding 2 candies, the blue box is still 1 candy fewer than the red box.'],
        ['把 11 顆拆成兩部分，相差 1 的兩數是 5 和 6。', 'Split 11 into two parts that differ by 1: they are 5 and 6.'],
        ['較多的那一盒是紅盒，所以紅盒原本有 6 顆。', 'The larger amount is the red box, so it originally had 6 candies.']
      ),
      'correctAnswer' => {'type' => 'integer', 'value' => '6'},
      'inputConstraints' => {'allowNegative' => false, 'maxDigits' => 1}
    )
  end,
  'arithmetic_grade1_foundation_037' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '哥哥和妹妹一共有 20 張貼紙。若妹妹送給哥哥 4 張後，兩人的貼紙就一樣多。妹妹原本有幾張貼紙？',
        en: 'A brother and a sister have 20 stickers altogether. If the sister gives 4 stickers to the brother, then they have the same number of stickers. How many stickers did the sister have at first?'
      ),
      'answer' => loc(zh_hant: '答案是 14 張。', en: 'The answer is 14.'),
      'solutionSteps' => steps(
        ['妹妹送出 4 張、哥哥多 4 張，所以兩人的差距一共縮小了 8 張。', 'When the sister gives 4 away and the brother gains 4, the difference shrinks by 8.'],
        ['送完後兩人一樣多，表示原本妹妹比哥哥多 8 張。', 'Since they become equal afterwards, the sister originally had 8 more stickers than the brother.'],
        ['總共有 20 張，把 20 分成相差 8 的兩部分，是 14 和 6，所以妹妹原本有 14 張。', 'The total is 20. The two parts that differ by 8 are 14 and 6, so the sister originally had 14 stickers.']
      ),
      'correctAnswer' => {'type' => 'integer', 'value' => '14'},
      'inputConstraints' => {'allowNegative' => false, 'maxDigits' => 2}
    )
  end,
  'arithmetic_grade2_foundation_023' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '四張卡片上分別寫著 3、8、12、15。選其中兩張，使得這兩張卡片的和是偶數，而且比另外兩張卡片的和大 2。這個偶數和是多少？',
        en: 'Four cards show 3, 8, 12, and 15. Choose two cards so that their sum is even and is 2 greater than the sum of the other two cards. What is this even sum?'
      ),
      'answer' => loc(zh_hant: '答案是 20。', en: 'The answer is 20.'),
      'solutionSteps' => steps(
        ['四張卡片的總和是 3 + 8 + 12 + 15 = 38。', 'The total of all four cards is 38.'],
        ['若選出的兩張和比另外兩張大 2，設選出的和是 x，另一邊就是 x - 2。', 'If the chosen pair is 2 greater than the other pair, let the chosen sum be x and the other sum be x - 2.'],
        ['所以 x + (x - 2) = 38，得到 2x = 40，所以 x = 20。', 'Then x + (x - 2) = 38, so 2x = 40 and x = 20.'],
        ['8 和 12 的和正好是 20，符合條件。', 'Indeed, 8 + 12 = 20, which fits the condition.']
      ),
      'correctAnswer' => {'type' => 'integer', 'value' => '20'},
      'inputConstraints' => {'allowNegative' => false, 'maxDigits' => 2}
    )
  end,
  'arithmetic_grade2_foundation_042' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '從家到公園原本有 4 條路，從公園到圖書館原本有 3 條路。現在有 1 條「家到公園」的路在維修不能用；另外，還有 1 組固定的走法（先走某一條家到公園的路，再接某一條公園到圖書館的路）也因施工不能連著走。現在從家到圖書館共有幾種走法？',
        en: 'There are originally 4 roads from home to the park and 3 roads from the park to the library. Now 1 home-to-park road is closed, and there is 1 specific two-step combination (one particular road to the park followed by one particular road to the library) that also cannot be used. How many routes are there now from home to the library?'
      ),
      'answer' => loc(zh_hant: '答案是 8 種。', en: 'The answer is 8.'),
      'solutionSteps' => steps(
        ['先扣掉維修的那 1 條，從家到公園剩下 3 條可走。', 'After removing the closed road, 3 roads remain from home to the park.'],
        ['若先不管那 1 組不能連著走的走法，總共有 3 × 3 = 9 種。', 'Ignoring the forbidden two-step combination for a moment, there are 3 × 3 = 9 routes.'],
        ['再扣掉那 1 組不能連著走的固定走法，就剩 8 種。', 'Subtract the 1 forbidden two-step combination, leaving 8 routes.']
      ),
      'correctAnswer' => {'type' => 'integer', 'value' => '8'},
      'inputConstraints' => {'allowNegative' => false, 'maxDigits' => 1}
    )
  end,
  'arithmetic_grade3_foundation_028' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '四張卡片上分別寫著 5、9、14、18。選其中兩張，使得這兩張卡片的和，和另外兩張卡片的和最接近。若有兩種選法一樣接近，答案就取這個和本身。這個和是多少？',
        en: 'Four cards show 5, 9, 14, and 18. Choose two cards so that their sum is as close as possible to the sum of the other two cards. If two choices are equally close, the answer is that common sum itself. What is the sum?'
      ),
      'answer' => loc(zh_hant: '答案是 23。', en: 'The answer is 23.'),
      'solutionSteps' => steps(
        ['四張卡片總和是 5 + 9 + 14 + 18 = 46。', 'The total of the four cards is 46.'],
        ['若兩邊和最接近，每一邊都會接近 46 ÷ 2 = 23。', 'If the two sums are as close as possible, each sum should be close to 46 ÷ 2 = 23.'],
        ['5 + 18 = 23，而且 9 + 14 = 23，剛好完全相等。', 'We have 5 + 18 = 23 and also 9 + 14 = 23, which match exactly.'],
        ['所以最接近的和就是 23。', 'So the desired sum is 23.']
      ),
      'correctAnswer' => {'type' => 'integer', 'value' => '23'},
      'inputConstraints' => {'allowNegative' => false, 'maxDigits' => 2}
    )
  end,
  'arithmetic_grade3_foundation_035' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '一個數先加上 6，再把結果平均分成 3 份，最後再加上 2，得到 10。原來的數是多少？',
        en: 'A number is first increased by 6, then the result is divided equally into 3 parts, and then 2 is added to get 10. What was the original number?'
      ),
      'answer' => loc(zh_hant: '答案是 18。', en: 'The answer is 18.'),
      'solutionSteps' => steps(
        ['最後得到 10，先把最後加上的 2 倒回去，得到 8。', 'The final result is 10, so undo the last +2 to get 8.'],
        ['8 是把前一步平均分成 3 份後的結果，所以分之前是 8 × 3 = 24。', 'The 8 came after dividing into 3 equal parts, so before that it was 8 × 3 = 24.'],
        ['再把一開始加上的 6 倒回去，24 - 6 = 18。', 'Undo the first +6: 24 - 6 = 18.'],
        ['所以原來的數是 18。', 'So the original number is 18.']
      ),
      'correctAnswer' => {'type' => 'integer', 'value' => '18'},
      'inputConstraints' => {'allowNegative' => false, 'maxDigits' => 2}
    )
  end,
  'geometry_grade3_foundation_028' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '一個等腰三角形中，每個底角都比頂角大 30°。這個三角形的頂角是多少度？',
        en: 'In an isosceles triangle, each base angle is 30° larger than the top angle. What is the top angle?'
      ),
      'answer' => loc(zh_hant: '答案是 40°。', en: 'The answer is 40°.'),
      'solutionSteps' => steps(
        ['設頂角是 x°，那兩個底角各是 x + 30°。', 'Let the top angle be x°. Then each base angle is x + 30°.'],
        ['三角形三個內角和是 180°，所以 x + (x + 30) + (x + 30) = 180。', 'The three angles of a triangle add to 180°, so x + (x + 30) + (x + 30) = 180.'],
        ['整理得 3x + 60 = 180，所以 3x = 120。', 'This simplifies to 3x + 60 = 180, so 3x = 120.'],
        ['因此 x = 40，所以頂角是 40°。', 'Therefore x = 40, so the top angle is 40°.']
      ),
      'correctAnswer' => {'type' => 'integer', 'value' => '40'},
      'inputConstraints' => {'allowNegative' => false, 'maxDigits' => 2}
    )
  end,
  'geometry_grade3_foundation_030' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '一個三角形的一個外角是 120°。另外兩個和這個外角不相鄰的內角，相差 20°。較大的那個內角是多少度？',
        en: 'One exterior angle of a triangle is 120°. The two non-adjacent interior angles differ by 20°. What is the larger of those two interior angles?'
      ),
      'answer' => loc(zh_hant: '答案是 70°。', en: 'The answer is 70°.'),
      'solutionSteps' => steps(
        ['三角形的一個外角，等於另外兩個不相鄰內角的和，所以那兩個角加起來是 120°。', 'An exterior angle of a triangle equals the sum of the two non-adjacent interior angles, so those two angles add to 120°.'],
        ['設較大的角是 x°，較小的角是 y°，則 x - y = 20。', 'Let the larger angle be x° and the smaller one be y°. Then x - y = 20.'],
        ['又因為 x + y = 120，兩式相加得到 2x = 140。', 'Also x + y = 120. Adding the two equations gives 2x = 140.'],
        ['所以 x = 70，較大的那個內角是 70°。', 'So x = 70, and the larger interior angle is 70°.']
      ),
      'correctAnswer' => {'type' => 'integer', 'value' => '70'},
      'inputConstraints' => {'allowNegative' => false, 'maxDigits' => 2}
    )
  end,
  'logic_grade4_foundation_020' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '六個盒子最初都關著。第一輪把編號是 2 的倍數的盒子切換一次；第二輪把編號是 3 的倍數的盒子切換一次；第三輪只把 6 號盒子再切換一次。最後開著幾個盒子？',
        en: 'Six boxes all start closed. In round 1, toggle every box whose number is a multiple of 2. In round 2, toggle every box whose number is a multiple of 3. In round 3, toggle only box 6 once more. How many boxes are open at the end?'
      ),
      'answer' => loc(zh_hant: '答案是 4 個。', en: 'The answer is 4.'),
      'solutionSteps' => steps(
        ['第一輪後，2、4、6 號盒子打開。', 'After round 1, boxes 2, 4, and 6 are open.'],
        ['第二輪切換 3、6 號盒子，所以 3 號打開、6 號關上。現在開著的是 2、3、4。', 'Round 2 toggles boxes 3 and 6, so 3 opens and 6 closes. Now boxes 2, 3, and 4 are open.'],
        ['第三輪再切換 6 號，6 號重新打開。', 'Round 3 toggles box 6 again, so box 6 opens again.'],
        ['最後開著的是 2、3、4、6，共 4 個。', 'The open boxes are 2, 3, 4, and 6, so there are 4 in total.']
      ),
      'correctAnswer' => {'type' => 'integer', 'value' => '4'},
      'inputConstraints' => {'allowNegative' => false, 'maxDigits' => 1}
    )
  end,
  'mixed_grade5_foundation_001' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '用數字 1、3、5、7 各一次排成兩個兩位數。若要讓這兩個兩位數的和最接近 100，這個和是多少？',
        en: 'Use the digits 1, 3, 5, and 7 exactly once to form two two-digit numbers. If their sum is as close as possible to 100, what is the sum?'
      ),
      'answer' => loc(zh_hant: '答案是 106。', en: 'The answer is 106.'),
      'solutionSteps' => steps(
        ['要讓和接近 100，十位數的總和最好接近 10。', 'To make the total close to 100, the tens digits should add up to about 10.'],
        ['若十位選 3 和 7，兩個數的十位合起來是 100；剩下個位是 1 和 5，再加上去就是 106。', 'If the tens digits are 3 and 7, they contribute 100 in total. The remaining ones digits are 1 and 5, giving 106.'],
        ['若十位選 1 和 7，總和只會是 80 加上剩下個位；若十位選 5 和 7，總和至少 120。都離 100 更遠。', 'If the tens digits are 1 and 7, the total is only 80 plus the ones digits. If they are 5 and 7, the total is at least 120. Both are farther from 100.'],
        ['所以最接近 100 的和是 106。', 'So the closest possible sum to 100 is 106.']
      ),
      'correctAnswer' => {'type' => 'integer', 'value' => '106'},
      'inputConstraints' => {'allowNegative' => false, 'maxDigits' => 3}
    )
  end
}.freeze

QUESTION_FILES.each do |path|
  next unless path.include?('/assets/questions/')

  payload = JSON.parse(File.read(path))
  next unless payload['questions']

  changed = false
  payload['questions'].map! do |question|
    replacement = REPLACEMENTS[question['id']]
    if replacement
      changed = true
      replacement.call(question)
    else
      question
    end
  end
  next unless changed

  File.write(path, JSON.pretty_generate(payload) + "\n")
  puts "updated #{File.basename(path)}"
end
