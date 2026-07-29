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

def integer_answer(value, digits:)
  {
    'correctAnswer' => {'type' => 'integer', 'value' => value.to_s},
    'inputConstraints' => {'allowNegative' => false, 'maxDigits' => digits}
  }
end

REPLACEMENTS = {
  'arithmetic_grade1_foundation_021' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '三張卡片上分別寫著 4、6、9。任選兩張相加，再從結果裡減去沒被選到的那張卡片上的數。這樣算出來的結果最大是多少？',
        en: 'Three cards show 4, 6, and 9. Choose any two cards, add them, then subtract the number on the card that was not chosen. What is the greatest result you can get?'
      ),
      'answer' => loc(zh_hant: '答案是 11。', en: 'The answer is 11.'),
      'solutionSteps' => steps(
        ['想要結果最大，就要讓加起來的兩張儘量大，減掉的那張儘量小。', 'To make the result as large as possible, add the largest two cards and subtract the smallest one.'],
        ['選 6 和 9 相加得到 15，再減去 4。', 'Choose 6 and 9 to get 15, then subtract 4.'],
        ['15 - 4 = 11，所以最大結果是 11。', '15 - 4 = 11, so the greatest result is 11.']
      )
    ).merge(integer_answer(11, digits: 2))
  end,
  'arithmetic_grade1_foundation_029' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '從家到公園有 2 條路，從公園到學校有 3 條路。小安出門時忘了作業本，所以回家時不能走和去程完全一樣的整條路線。從家出發到學校共有幾種可選的去程路線？',
        en: 'There are 2 roads from home to the park and 3 roads from the park to school. On the way home, An cannot use exactly the same full route as the trip to school. How many possible routes can An choose from home to school?'
      ),
      'answer' => loc(zh_hant: '答案是 6 種。', en: 'The answer is 6.'),
      'solutionSteps' => steps(
        ['去學校時，先選家到公園的 2 條路之一。', 'For the trip to school, first choose one of the 2 roads from home to the park.'],
        ['再選公園到學校的 3 條路之一。', 'Then choose one of the 3 roads from the park to the school.'],
        ['所以去程共有 2 × 3 = 6 種。回程限制不會減少去程本來可以選的路線數。', 'So there are 2 × 3 = 6 possible outbound routes. The return-rule does not reduce the number of outbound choices.']
      )
    ).merge(integer_answer(6, digits: 1))
  end,
  'arithmetic_grade2_foundation_026' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '一個數先減去 8，再把結果平分成 3 份，每份是 7。原來的數是多少？',
        en: 'A number is first reduced by 8. Then the result is split equally into 3 parts, each part being 7. What was the original number?'
      ),
      'answer' => loc(zh_hant: '答案是 29。', en: 'The answer is 29.'),
      'solutionSteps' => steps(
        ['每份是 7，而且一共分成 3 份，所以減去 8 之後是 7 × 3 = 21。', 'Each part is 7 and there are 3 parts, so after subtracting 8 the number became 7 × 3 = 21.'],
        ['把先前減掉的 8 加回去。', 'Add back the 8 that was subtracted first.'],
        ['21 + 8 = 29，所以原來的數是 29。', '21 + 8 = 29, so the original number is 29.']
      )
    ).merge(integer_answer(29, digits: 2))
  end,
  'arithmetic_grade2_foundation_043' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '一個數先乘以 3，再加上 5，結果比原來的數多 21。原來的數是多少？',
        en: 'A number is multiplied by 3 and then 5 is added. The final result is 21 greater than the original number. What is the original number?'
      ),
      'answer' => loc(zh_hant: '答案是 8。', en: 'The answer is 8.'),
      'solutionSteps' => steps(
        ['設原來的數是 1 份。乘以 3 後是 3 份，再加上 5。', 'Let the original number be 1 part. After multiplying by 3, it becomes 3 parts, then 5 is added.'],
        ['最後比原來多 21，表示多出的 2 份加上 5，一共是 21。', 'The final result is 21 more than the original, so the extra 2 parts plus 5 equal 21.'],
        ['21 - 5 = 16，這是 2 份，所以 1 份是 8。', '21 - 5 = 16, and this equals 2 parts, so 1 part is 8.']
      )
    ).merge(integer_answer(8, digits: 1))
  end,
  'arithmetic_grade2_foundation_048' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '一個數先乘以 4，再減去 7，得到的結果正好是原來那個數的 3 倍。原來的數是多少？',
        en: 'A number is multiplied by 4 and then 7 is subtracted. The result is exactly 3 times the original number. What was the original number?'
      ),
      'answer' => loc(zh_hant: '答案是 7。', en: 'The answer is 7.'),
      'solutionSteps' => steps(
        ['把原來的數看成 1 份，乘以 4 後是 4 份。', 'Treat the original number as 1 part. After multiplying by 4, it becomes 4 parts.'],
        ['再減去 7 之後，結果變成 3 份。', 'After subtracting 7, the result becomes 3 parts.'],
        ['表示 4 份和 3 份只差 7，所以 1 份就是 7。', 'This means the difference between 4 parts and 3 parts is 7, so 1 part is 7.']
      )
    ).merge(integer_answer(7, digits: 1))
  end,
  'arithmetic_grade2_foundation_050' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '小華原本有一些貼紙。她先送出 12 張，剩下的正好可以平均分成 4 疊，每疊 6 張。小華原本有多少張貼紙？',
        en: 'Hua had some stickers. After giving away 12 stickers, the rest can be split into 4 equal piles of 6 stickers each. How many stickers did Hua have at first?'
      ),
      'answer' => loc(zh_hant: '答案是 36 張。', en: 'The answer is 36.'),
      'solutionSteps' => steps(
        ['送完後剩下 4 疊，每疊 6 張，所以剩下 4 × 6 = 24 張。', 'After giving some away, 4 piles of 6 remain, so 4 × 6 = 24 stickers remain.'],
        ['把送出的 12 張加回去。', 'Add back the 12 stickers that were given away.'],
        ['24 + 12 = 36，所以原本有 36 張。', '24 + 12 = 36, so Hua originally had 36 stickers.']
      )
    ).merge(integer_answer(36, digits: 2))
  end,
  'arithmetic_grade3_foundation_016' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '從 A 到 B 有 2 條路，從 B 到 C 有 3 條路，從 C 到 D 有 2 條路。已知其中有 1 組固定走法（某一條 B 到 C 的路接某一條 C 到 D 的路）因施工不能連著走。從 A 到 D 共有幾種走法？',
        en: 'There are 2 roads from A to B, 3 roads from B to C, and 2 roads from C to D. One specific combination of a B-to-C road followed by a C-to-D road is forbidden. How many routes are there from A to D?'
      ),
      'answer' => loc(zh_hant: '答案是 10 種。', en: 'The answer is 10.'),
      'solutionSteps' => steps(
        ['如果沒有禁止的連走方式，總共有 2 × 3 × 2 = 12 種。', 'Without the forbidden combination, there would be 2 × 3 × 2 = 12 routes.'],
        ['那 1 組不能連著走的組合，會和 A 到 B 的 2 種選法各搭配一次，所以要扣掉 2 種。', 'That forbidden middle-end combination can be paired with each of the 2 choices from A to B, so 2 routes must be removed.'],
        ['12 - 2 = 10，所以共有 10 種走法。', '12 - 2 = 10, so there are 10 possible routes.']
      )
    ).merge(integer_answer(10, digits: 2))
  end,
  'arithmetic_grade3_foundation_029' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '一個數先乘 2，再加 5，最後得到的結果剛好是原來那個數的 3 倍少 1。原來的數是多少？',
        en: 'A number is multiplied by 2 and then 5 is added. The result is 1 less than 3 times the original number. What was the original number?'
      ),
      'answer' => loc(zh_hant: '答案是 6。', en: 'The answer is 6.'),
      'solutionSteps' => steps(
        ['若原來的數是 1 份，乘 2 再加 5 的結果，等於 3 份少 1。', 'If the original number is 1 part, then doubling it and adding 5 gives 3 parts minus 1.'],
        ['把少掉的 1 補回去，可得 2 份加 6 等於 3 份。', 'Add back the missing 1, and we get 2 parts plus 6 equals 3 parts.'],
        ['所以 1 份就是 6，原來的數是 6。', 'So 1 part is 6, and the original number is 6.']
      )
    ).merge(integer_answer(6, digits: 1))
  end,
  'arithmetic_grade3_foundation_051' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '一個數先加上 9，再乘以 4，最後比原來的數多 60。原來的數是多少？',
        en: 'A number is first increased by 9 and then multiplied by 4. The final result is 60 greater than the original number. What was the original number?'
      ),
      'answer' => loc(zh_hant: '答案是 8。', en: 'The answer is 8.'),
      'solutionSteps' => steps(
        ['先把「加 9 再乘 4」展開，等於原來的 4 倍再多 36。', 'Expanding “add 9 then multiply by 4” gives 4 times the original number plus 36.'],
        ['題目說最後只比原來多 60，所以多出的 3 倍再加 36 等於 60。', 'The final result is only 60 more than the original, so 3 extra parts plus 36 equal 60.'],
        ['60 - 36 = 24，這是 3 份，所以原來的數是 24 ÷ 3 = 8。', '60 - 36 = 24, and this is 3 parts, so the original number is 24 ÷ 3 = 8.']
      )
    ).merge(integer_answer(8, digits: 1))
  end,
  'arithmetic_grade4_foundation_029' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '從 A 到 B 有 4 條不同的路，從 B 到 C 有 3 條不同的路。若其中有 2 條指定的「先到 B 再到 C」走法不能使用，其餘都可以。從 A 到 C 共有幾種走法？',
        en: 'There are 4 roads from A to B and 3 roads from B to C. Two specific A-to-B-to-C route combinations are forbidden, and all others may be used. How many routes are there from A to C?'
      ),
      'answer' => loc(zh_hant: '答案是 10 種。', en: 'The answer is 10.'),
      'solutionSteps' => steps(
        ['若沒有禁止的走法，總共有 4 × 3 = 12 種。', 'Without any restriction, there would be 4 × 3 = 12 routes.'],
        ['現在有 2 組固定搭配不能走，所以直接扣掉 2 種。', 'Now 2 specific combinations are forbidden, so subtract 2 routes directly.'],
        ['12 - 2 = 10，所以共有 10 種。', '12 - 2 = 10, so there are 10 routes in total.']
      )
    ).merge(integer_answer(10, digits: 2))
  end,
  'arithmetic_grade4_foundation_035' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '小華原本有一些錢。她先拿出全部的四分之一，再從剩下的錢裡拿出一半，這時還剩下 90 元。小華原本有多少元？',
        en: 'Hua had some money. She first used one quarter of it, then used half of what remained, and had 90 dollars left. How much money did she have at first?'
      ),
      'answer' => loc(zh_hant: '答案是 240 元。', en: 'The answer is 240.'),
      'solutionSteps' => steps(
        ['先拿出全部的四分之一後，還剩下原來的四分之三。', 'After using one quarter, three quarters of the original amount remains.'],
        ['再從剩下的錢裡拿出一半，表示最後留下的是那四分之三的一半，也就是原來的八分之三。', 'Then using half of the remainder means the final amount is half of three quarters, which is three eighths of the original.'],
        ['原來的八分之三是 90，所以原來全部是 90 ÷ 3 × 8 = 240。', 'If three eighths equals 90, then the whole amount is 90 ÷ 3 × 8 = 240.']
      )
    ).merge(integer_answer(240, digits: 3))
  end,
  'arithmetic_grade4_foundation_037' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '小明有一些錢。先用掉全部的一半，又存入 36 元；接著再用掉這時錢數的三分之一，最後剩下 64 元。小明原本有多少元？',
        en: 'Ming had some money. He first spent half of it, then saved 36 dollars, and then spent one third of what he had at that moment. In the end he had 64 dollars left. How much did he have at first?'
      ),
      'answer' => loc(zh_hant: '答案是 120 元。', en: 'The answer is 120.'),
      'solutionSteps' => steps(
        ['最後剩下 64 元，這是「用掉三分之一後」留下的三分之二。', 'The final 64 dollars is what remains after spending one third, so it is two thirds of the amount just before that spending.'],
        ['因此用掉三分之一前有 64 ÷ 2 × 3 = 96 元。', 'So just before that spending, he had 64 ÷ 2 × 3 = 96 dollars.'],
        ['這 96 元是先花掉一半後，再存入 36 元得到的，所以花掉一半後原本剩下 96 - 36 = 60 元。', 'Those 96 dollars came from the half-left amount plus 36, so after spending half he had 96 - 36 = 60 dollars.'],
        ['既然花掉一半後剩 60 元，原本就是 120 元。', 'If 60 dollars remained after spending half, then he originally had 120 dollars.']
      )
    ).merge(integer_answer(120, digits: 3))
  end,
  'arithmetic_grade4_foundation_046' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '從甲地到乙地有 3 條不同的路，從乙地到丙地有 4 條不同的路。一定要經過乙地，而且其中有 1 條甲到乙的路只能接其中 2 條乙到丙的路。其餘搭配都可用。從甲地到丙地共有幾種不同的走法？',
        en: 'There are 3 roads from A to B and 4 roads from B to C. You must pass through B. One particular A-to-B road can be followed by only 2 of the 4 B-to-C roads, while all other combinations are allowed. How many routes are there from A to C?'
      ),
      'answer' => loc(zh_hant: '答案是 10 種。', en: 'The answer is 10.'),
      'solutionSteps' => steps(
        ['先看那 1 條受限制的甲到乙道路，它只能接 2 種後段走法。', 'First consider the 1 restricted road from A to B. It can be followed by only 2 second-leg choices.'],
        ['另外 2 條甲到乙的路都能各接 4 種後段走法，所以共有 2 × 4 = 8 種。', 'The other 2 roads from A to B can each be followed by all 4 second-leg choices, giving 2 × 4 = 8 routes.'],
        ['全部加起來是 2 + 8 = 10 種。', 'In total, that gives 2 + 8 = 10 routes.']
      )
    ).merge(integer_answer(10, digits: 2))
  end,
  'arithmetic_grade4_foundation_049' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '小華參加代幣遊戲。第一輪代幣變成原來的 2 倍；第二輪失去 18 個；第三輪代幣變成當時的 3 倍，最後有 72 個。小華一開始有幾個代幣？',
        en: 'Hua plays a token game. In round 1, the number of tokens doubles. In round 2, she loses 18 tokens. In round 3, the remaining tokens triple, and she ends with 72 tokens. How many tokens did she have at first?'
      ),
      'answer' => loc(zh_hant: '答案是 21 個。', en: 'The answer is 21.'),
      'solutionSteps' => steps(
        ['最後是 72 個，是第三輪前的 3 倍，所以第三輪前有 72 ÷ 3 = 24 個。', 'The final 72 tokens is 3 times the amount before round 3, so before round 3 there were 72 ÷ 3 = 24 tokens.'],
        ['第二輪失去 18 個，所以第一輪後應該有 24 + 18 = 42 個。', 'Since 18 tokens were lost in round 2, there must have been 24 + 18 = 42 tokens after round 1.'],
        ['第一輪是翻倍，所以一開始有 42 ÷ 2 = 21 個。', 'Round 1 doubled the tokens, so the starting amount was 42 ÷ 2 = 21.']
      )
    ).merge(integer_answer(21, digits: 2))
  end,
  'arithmetic_grade5_foundation_007' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '從 A 到 B 有 3 條路，從 B 到 C 有 4 條路，從 C 到 D 有 2 條路。若有 2 組固定的「B 到 C 再到 D」連走方式不能使用，其餘都可以。從 A 到 D 共有幾種走法？',
        en: 'There are 3 roads from A to B, 4 from B to C, and 2 from C to D. Two specific B-to-C-to-D combinations are forbidden, and all others are allowed. How many routes are there from A to D?'
      ),
      'answer' => loc(zh_hant: '答案是 18 種。', en: 'The answer is 18.'),
      'solutionSteps' => steps(
        ['若完全沒有限制，總共有 3 × 4 × 2 = 24 種。', 'Without restrictions, there would be 3 × 4 × 2 = 24 routes.'],
        ['每一組被禁止的「B 到 C 再到 D」連走方式，都可以搭配前面 3 種 A 到 B 的選法。', 'Each forbidden B-to-C-to-D combination can be paired with any of the 3 choices from A to B.'],
        ['所以要扣掉 2 × 3 = 6 種，剩下 24 - 6 = 18 種。', 'So we subtract 2 × 3 = 6 routes, leaving 24 - 6 = 18 routes.']
      )
    ).merge(integer_answer(18, digits: 2))
  end,
  'arithmetic_grade6_foundation_032' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '一個數先除以 3，再加上 8，得到的結果剛好是原來那個數的一半。原來的數是多少？',
        en: 'A number is divided by 3 and then 8 is added. The result is exactly half of the original number. What was the original number?'
      ),
      'answer' => loc(zh_hant: '答案是 48。', en: 'The answer is 48.'),
      'solutionSteps' => steps(
        ['設原來的數是 x。題意表示 x ÷ 3 + 8 = x ÷ 2。', 'Let the original number be x. The condition gives x ÷ 3 + 8 = x ÷ 2.'],
        ['把 x ÷ 3 移到右邊，可得 8 = x ÷ 2 - x ÷ 3。', 'Move x ÷ 3 to the right side to get 8 = x ÷ 2 - x ÷ 3.'],
        ['x ÷ 2 - x ÷ 3 = x ÷ 6，所以 x ÷ 6 = 8。', 'Since x ÷ 2 - x ÷ 3 = x ÷ 6, we have x ÷ 6 = 8.'],
        ['因此 x = 48。', 'Therefore x = 48.']
      )
    ).merge(integer_answer(48, digits: 2))
  end,
  'geometry_grade3_foundation_003' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '一個長方形的一個角被一條線分成兩個角，其中一個角比另一個角大 24°。較大的角是多少度？',
        en: 'A corner of a rectangle is split into two angles. One angle is 24° larger than the other. What is the larger angle?'
      ),
      'answer' => loc(zh_hant: '答案是 57°。', en: 'The answer is 57°.'),
      'solutionSteps' => steps(
        ['長方形的一個角是直角，所以兩個角加起來是 90°。', 'A corner of a rectangle is a right angle, so the two angles add to 90°.'],
        ['設較大的角是 x°，較小的是 y°，則 x + y = 90，x - y = 24。', 'Let the larger angle be x° and the smaller angle be y°. Then x + y = 90 and x - y = 24.'],
        ['兩式相加得 2x = 114，所以 x = 57。', 'Adding the two equations gives 2x = 114, so x = 57.']
      )
    ).merge(integer_answer(57, digits: 2))
  end,
  'geometry_grade3_foundation_008' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '一個面積是 24 平方公分的長方形，長和寬都是整數公分，而且長比寬多 2 公分。這個長方形的周長是多少公分？',
        en: 'A rectangle has area 24 square centimeters. Its side lengths are integers, and the length is 2 cm longer than the width. What is its perimeter?'
      ),
      'answer' => loc(zh_hant: '答案是 20 公分。', en: 'The answer is 20 cm.'),
      'solutionSteps' => steps(
        ['把 24 分解成整數因數對：1×24、2×12、3×8、4×6。', 'List the integer factor pairs of 24: 1×24, 2×12, 3×8, and 4×6.'],
        ['只有 4 和 6 相差 2，所以寬是 4，長是 6。', 'Only 4 and 6 differ by 2, so the width is 4 and the length is 6.'],
        ['周長是 (6 + 4) × 2 = 20 公分。', 'The perimeter is (6 + 4) × 2 = 20 cm.']
      )
    ).merge(integer_answer(20, digits: 2))
  end,
  'geometry_grade3_foundation_010' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '把一個正方形沿著一條和其中一邊平行的線切成兩個長方形。切開後，這兩個長方形合起來一共有幾組互相平行的邊？',
        en: 'A square is cut by a line parallel to one of its sides, making two rectangles. After the cut, how many pairs of parallel sides do the two rectangles have altogether?'
      ),
      'answer' => loc(zh_hant: '答案是 4 組。', en: 'The answer is 4 pairs.'),
      'solutionSteps' => steps(
        ['切成兩個長方形後，每個長方形也各有 2 組互相平行的邊。', 'Each rectangle also has 2 pairs of parallel sides.'],
        ['兩個長方形合起來共有 2 + 2 = 4 組。', 'Together, the two rectangles have 2 + 2 = 4 pairs.']
      )
    ).merge(integer_answer(4, digits: 1))
  end,
  'geometry_grade3_foundation_022' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '一個三角形裡有兩個角分別是 40° 和 65°。如果把第三個角再平分成兩個相等的小角，每個小角是多少度？',
        en: 'A triangle has two angles of 40° and 65°. If the third angle is split into two equal smaller angles, how large is each small angle?'
      ),
      'answer' => loc(zh_hant: '答案是 37.5°。', en: 'The answer is 37.5°.'),
      'solutionSteps' => steps(
        ['三角形三個內角和是 180°。', 'The angles in a triangle add to 180°.'],
        ['第三個角是 180 - 40 - 65 = 75°。', 'The third angle is 180 - 40 - 65 = 75°.'],
        ['把 75° 平分成兩個相等的小角，每個是 75 ÷ 2 = 37.5°。', 'Splitting 75° into two equal parts gives 75 ÷ 2 = 37.5° each.']
      ),
      'answerMode' => 'multiple_choice',
      'options' => {
        'A' => loc(zh_hant: '35°', en: '35°'),
        'B' => loc(zh_hant: '37.5°', en: '37.5°'),
        'C' => loc(zh_hant: '40°', en: '40°'),
        'D' => loc(zh_hant: '75°', en: '75°')
      },
      'correctAnswer' => {'type' => 'choice', 'value' => 'B'}
    )
  end,
  'geometry_grade3_foundation_038' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '一條直線上有 5 個點，任選其中兩點都可以連成一條線段，但長度相同的線段只算一次。若這 5 個點等距排列，會得到幾種不同長度的線段？',
        en: 'Five points lie equally spaced on a line. Any two points determine a segment, but segments of the same length are counted only once. How many different segment lengths are possible?'
      ),
      'answer' => loc(zh_hant: '答案是 4 種。', en: 'The answer is 4.'),
      'solutionSteps' => steps(
        ['相鄰兩點之間是一種長度。', 'The distance between adjacent points gives one length.'],
        ['隔一個點、隔兩個點、隔三個點，也各形成一種不同長度。', 'Skipping one point, two points, or three points also gives different lengths.'],
        ['因為共有 5 個等距點，最遠只能隔三個中間位置，所以不同長度共有 4 種。', 'With 5 equally spaced points, the possible spacings are 1, 2, 3, and 4 units, so there are 4 different lengths.']
      )
    ).merge(integer_answer(4, digits: 1))
  end,
  'logic_grade1_foundation_022' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '三盞燈一開始都關著。先把第 1 盞和第 3 盞打開，再把第 2 盞的開關按兩次。最後亮著幾盞燈？',
        en: 'Three lamps start off. Turn on lamp 1 and lamp 3, then press the switch of lamp 2 twice. How many lamps are on at the end?'
      ),
      'answer' => loc(zh_hant: '答案是 2 盞。', en: 'The answer is 2.'),
      'solutionSteps' => steps(
        ['先打開第 1 盞和第 3 盞，所以目前亮著 2 盞。', 'First, lamps 1 and 3 are turned on, so 2 lamps are on.'],
        ['第 2 盞按一次會亮，再按一次又會關。', 'Pressing lamp 2 once turns it on, and pressing it again turns it off.'],
        ['最後仍然只有第 1 盞和第 3 盞亮著，所以共有 2 盞。', 'So only lamps 1 and 3 remain on, for a total of 2 lamps.']
      )
    ).merge(integer_answer(2, digits: 1))
  end,
  'logic_grade2_foundation_022' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '4 個盒子一開始都關著。第一輪打開 1 號和 4 號；第二輪把偶數號盒子都切換一次；第三輪只把 1 號盒子再切換一次。最後開著幾個盒子？',
        en: 'Four boxes all start closed. In round 1, open boxes 1 and 4. In round 2, toggle all even-numbered boxes. In round 3, toggle only box 1 once more. How many boxes are open at the end?'
      ),
      'answer' => loc(zh_hant: '答案是 1 個。', en: 'The answer is 1.'),
      'solutionSteps' => steps(
        ['第一輪後，1 號和 4 號打開。', 'After round 1, boxes 1 and 4 are open.'],
        ['第二輪切換 2 號和 4 號，所以 2 號打開，4 號關上。', 'Round 2 toggles boxes 2 and 4, so box 2 opens and box 4 closes.'],
        ['第三輪再切換 1 號，所以 1 號關上。最後只剩 2 號開著。', 'Round 3 toggles box 1 again, so box 1 closes. Only box 2 remains open at the end.']
      )
    ).merge(integer_answer(1, digits: 1))
  end,
  'logic_grade3_foundation_022' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '5 盞燈一開始都關著。先打開 2、4、5 號燈，再把 4 號燈切換一次，最後把所有奇數號燈都切換一次。最後亮著幾盞燈？',
        en: 'Five lamps start off. Turn on lamps 2, 4, and 5. Then toggle lamp 4 once, and finally toggle all odd-numbered lamps. How many lamps are on at the end?'
      ),
      'answer' => loc(zh_hant: '答案是 3 盞。', en: 'The answer is 3.'),
      'solutionSteps' => steps(
        ['先打開 2、4、5 號，所以亮著的是 2、4、5。', 'First, lamps 2, 4, and 5 are on.'],
        ['再切換 4 號後，4 號關掉，亮著的是 2、5。', 'After toggling lamp 4, lamp 4 turns off, so lamps 2 and 5 are on.'],
        ['最後切換奇數號 1、3、5：1 和 3 會亮，5 會關。', 'Finally toggle lamps 1, 3, and 5: lamps 1 and 3 turn on, and lamp 5 turns off.'],
        ['所以最後亮著的是 1、2、3，共 3 盞。', 'So lamps 1, 2, and 3 are on at the end, making 3 lamps in total.']
      )
    ).merge(integer_answer(3, digits: 1))
  end,
  'logic_grade5_foundation_020' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '7 盞燈一開始都關著。先把 1、2、7 號燈打開；接著把所有 3 的倍數號燈切換一次；最後再把 7 號燈切換一次。最後亮著幾盞燈？',
        en: 'Seven lamps start off. Turn on lamps 1, 2, and 7. Then toggle every lamp whose number is a multiple of 3. Finally toggle lamp 7 once more. How many lamps are on at the end?'
      ),
      'answer' => loc(zh_hant: '答案是 4 盞。', en: 'The answer is 4.'),
      'solutionSteps' => steps(
        ['先打開 1、2、7 號，所以目前亮著 1、2、7。', 'First, lamps 1, 2, and 7 are on.'],
        ['再切換 3、6 號，這兩盞原本關著，所以都會亮。現在亮著 1、2、3、6、7。', 'Then toggle lamps 3 and 6. They were off, so both turn on. Now lamps 1, 2, 3, 6, and 7 are on.'],
        ['最後切換 7 號，7 號關掉。', 'Finally toggle lamp 7, so it turns off.'],
        ['因此最後亮著的是 1、2、3、6，共 4 盞。', 'So lamps 1, 2, 3, and 6 remain on, for a total of 4 lamps.']
      )
    ).merge(integer_answer(4, digits: 1))
  end,
  'logic_grade6_foundation_023' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '8 盞燈一開始都關著。先打開 2、4、8 號燈；再把所有 4 的倍數號燈切換一次；最後把 2 到 5 號燈各切換一次。最後亮著幾盞燈？',
        en: 'Eight lamps start off. Turn on lamps 2, 4, and 8. Then toggle every lamp whose number is a multiple of 4. Finally toggle lamps 2 through 5 once each. How many lamps are on at the end?'
      ),
      'answer' => loc(zh_hant: '答案是 3 盞。', en: 'The answer is 3.'),
      'solutionSteps' => steps(
        ['先打開 2、4、8 號。', 'First, lamps 2, 4, and 8 are turned on.'],
        ['切換 4 的倍數號燈，也就是 4 號和 8 號，所以這兩盞會關掉，只剩 2 號亮。', 'Toggle the multiples of 4, namely lamps 4 and 8, so they turn off. Only lamp 2 remains on.'],
        ['最後切換 2、3、4、5 號：2 號關掉，3、4、5 號打開。', 'Finally toggle lamps 2, 3, 4, and 5: lamp 2 turns off, and lamps 3, 4, and 5 turn on.'],
        ['因此最後亮著的是 3、4、5，共 3 盞。', 'Thus lamps 3, 4, and 5 are on at the end, for a total of 3 lamps.']
      )
    ).merge(integer_answer(3, digits: 1))
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
