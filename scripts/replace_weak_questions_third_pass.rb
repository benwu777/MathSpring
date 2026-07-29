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
    'inputConstraints' => {'allowNegative' => false, 'maxDigits' => digits},
    'answerMode' => 'integer_input'
  }
end

def choice_answer(value, options:)
  {
    'answerMode' => 'multiple_choice',
    'correctAnswer' => {'type' => 'choice', 'value' => value},
    'options' => options
  }
end

REPLACEMENTS = {
  'geometry_grade5_foundation_018' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '一個三角形的三個內角中，最小角和中間角的比是 3:4，最大角比中間角大 15°。最大角是多少度？',
        en: 'In a triangle, the ratio of the smallest angle to the middle angle is 3:4, and the largest angle is 15° greater than the middle angle. What is the largest angle?'
      ),
      'answer' => loc(zh_hant: '答案是 75°。', en: 'The answer is 75°.'),
      'solutionSteps' => steps(
        ['設最小角是 3x，中間角是 4x，最大角就是 4x + 15。', 'Let the smallest angle be 3x, the middle angle be 4x, and the largest angle be 4x + 15.'],
        ['三角形內角和是 180°，所以 3x + 4x + (4x + 15) = 180。', 'The angles in a triangle add to 180°, so 3x + 4x + (4x + 15) = 180.'],
        ['整理得 11x = 165，所以 x = 15。', 'This simplifies to 11x = 165, so x = 15.'],
        ['最大角是 4x + 15 = 4 × 15 + 15 = 75°。', 'The largest angle is 4x + 15 = 4 × 15 + 15 = 75°.']
      )
    ).merge(integer_answer(75, digits: 2))
  end,
  'geometry_grade6_foundation_001' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '一個四邊形四個內角的比是 2:3:4:5。最大的角是多少度？',
        en: 'The four interior angles of a quadrilateral are in the ratio 2:3:4:5. What is the largest angle?'
      ),
      'answer' => loc(zh_hant: '答案是 125°。', en: 'The answer is 125°.'),
      'solutionSteps' => steps(
        ['四邊形內角和是 360°。', 'The interior angles of a quadrilateral add to 360°.'],
        ['比的總份數是 2 + 3 + 4 + 5 = 14 份，所以 1 份是 360 ÷ 14 = 180 ÷ 7。', 'The total number of ratio parts is 2 + 3 + 4 + 5 = 14, so 1 part is 360 ÷ 14 = 180 ÷ 7.'],
        ['最大角是 5 份，也就是 5 × 25 = 125°。', 'The largest angle is 5 parts, which equals 5 × 25 = 125°.']
      )
    ).merge(integer_answer(125, digits: 3))
  end,
  'geometry_grade6_foundation_009' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '某多邊形的內角和比五邊形的內角和多 360°。這個多邊形有幾條邊？',
        en: 'A polygon has an interior angle sum that is 360° more than that of a pentagon. How many sides does the polygon have?'
      ),
      'answer' => loc(zh_hant: '答案是 7 條邊。', en: 'The answer is 7 sides.'),
      'solutionSteps' => steps(
        ['五邊形的內角和是 (5 - 2) × 180 = 540°。', 'A pentagon has interior angle sum (5 - 2) × 180 = 540°.'],
        ['題目的多邊形內角和是 540 + 360 = 900°。', 'So the polygon in the problem has interior angle sum 540 + 360 = 900°.'],
        ['設它有 n 條邊，則 (n - 2) × 180 = 900。', 'If the polygon has n sides, then (n - 2) × 180 = 900.'],
        ['得到 n - 2 = 5，所以 n = 7。', 'This gives n - 2 = 5, so n = 7.']
      )
    ).merge(integer_answer(7, digits: 1))
  end,
  'geometry_grade6_foundation_024' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '一個正多邊形的每個外角都是 24°。這個多邊形的內角和是多少度？',
        en: 'Each exterior angle of a regular polygon is 24°. What is the sum of its interior angles?'
      ),
      'answer' => loc(zh_hant: '答案是 2340°。', en: 'The answer is 2340°.'),
      'solutionSteps' => steps(
        ['正多邊形每個外角都相等，全部外角加起來是 360°。', 'In a regular polygon, all exterior angles are equal and together sum to 360°.'],
        ['所以邊數是 360 ÷ 24 = 15。', 'So the polygon has 360 ÷ 24 = 15 sides.'],
        ['內角和是 (15 - 2) × 180 = 13 × 180 = 2340°。', 'Its interior angle sum is (15 - 2) × 180 = 13 × 180 = 2340°.']
      )
    ).merge(integer_answer(2340, digits: 4))
  end,
  'arithmetic_grade5_foundation_023' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '爸爸和小華今年年齡合起來是 42 歲。6 年後，爸爸的年齡會是小華的 2 倍。小華今年幾歲？',
        en: 'The father and Xiaohua are 42 years old in total this year. In 6 years, the father will be twice as old as Xiaohua. How old is Xiaohua now?'
      ),
      'answer' => loc(zh_hant: '答案是 12 歲。', en: 'The answer is 12.'),
      'solutionSteps' => steps(
        ['設小華今年 x 歲，爸爸今年就是 42 - x 歲。', 'Let Xiaohua be x years old now. Then the father is 42 - x years old.'],
        ['6 年後，爸爸是 42 - x + 6，小華是 x + 6。', 'In 6 years, the father will be 42 - x + 6 and Xiaohua will be x + 6.'],
        ['題目說那時爸爸是小華的 2 倍，所以 48 - x = 2(x + 6)。', 'The father will then be twice Xiaohua’s age, so 48 - x = 2(x + 6).'],
        ['整理得 48 - x = 2x + 12，故 36 = 3x，所以 x = 12。', 'This simplifies to 48 - x = 2x + 12, so 36 = 3x and x = 12.']
      )
    ).merge(integer_answer(12, digits: 2))
  end,
  'arithmetic_grade6_foundation_022' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '媽媽比小明大 24 歲。3 年後，媽媽的年齡會是小明的 3 倍。小明今年幾歲？',
        en: 'Mother is 24 years older than Xiaoming. In 3 years, her age will be 3 times Xiaoming’s age. How old is Xiaoming now?'
      ),
      'answer' => loc(zh_hant: '答案是 9 歲。', en: 'The answer is 9.'),
      'solutionSteps' => steps(
        ['設小明今年 x 歲，媽媽今年就是 x + 24 歲。', 'Let Xiaoming be x years old now. Then his mother is x + 24 years old.'],
        ['3 年後，媽媽是 x + 27 歲，小明是 x + 3 歲。', 'In 3 years, the mother will be x + 27 and Xiaoming will be x + 3.'],
        ['題目說那時媽媽是小明的 3 倍，所以 x + 27 = 3(x + 3)。', 'The mother will then be 3 times Xiaoming’s age, so x + 27 = 3(x + 3).'],
        ['整理得 x + 27 = 3x + 9，故 18 = 2x，所以 x = 9。', 'This simplifies to x + 27 = 3x + 9, so 18 = 2x and x = 9.']
      )
    ).merge(integer_answer(9, digits: 1))
  end,
  'arithmetic_grade6_foundation_026' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '今年爸爸的年齡是小明的 3 倍。10 年前，爸爸的年齡是小明的 5 倍。小明今年幾歲？',
        en: 'This year, the father is 3 times Xiaoming’s age. Ten years ago, the father was 5 times Xiaoming’s age. How old is Xiaoming now?'
      ),
      'answer' => loc(zh_hant: '答案是 20 歲。', en: 'The answer is 20.'),
      'solutionSteps' => steps(
        ['設小明今年 x 歲，爸爸今年就是 3x 歲。', 'Let Xiaoming be x years old now. Then the father is 3x years old.'],
        ['10 年前，小明是 x - 10 歲，爸爸是 3x - 10 歲。', 'Ten years ago, Xiaoming was x - 10 and the father was 3x - 10.'],
        ['題目說那時爸爸是小明的 5 倍，所以 3x - 10 = 5(x - 10)。', 'The father was then 5 times Xiaoming’s age, so 3x - 10 = 5(x - 10).'],
        ['整理得 3x - 10 = 5x - 50，故 40 = 2x，所以 x = 20。', 'This simplifies to 3x - 10 = 5x - 50, so 40 = 2x and x = 20.']
      )
    ).merge(integer_answer(20, digits: 2))
  end,
  'arithmetic_grade1_foundation_004' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '紅盒裡有 2 顆糖，藍盒裡有 8 顆糖。老師先再放 2 顆到紅盒，接著再從藍盒拿一些到紅盒，讓兩盒一樣多。要從藍盒拿幾顆？',
        en: 'The red box has 2 candies and the blue box has 8 candies. The teacher first adds 2 candies to the red box, then moves some candies from the blue box to the red box so that both boxes have the same number. How many candies are moved from the blue box?'
      ),
      'answer' => loc(zh_hant: '答案是 2 顆。', en: 'The answer is 2.'),
      'solutionSteps' => steps(
        ['先放 2 顆到紅盒後，紅盒變成 4 顆，藍盒還是 8 顆。', 'After adding 2 candies, the red box has 4 candies and the blue box still has 8.'],
        ['現在藍盒比紅盒多 4 顆。', 'Now the blue box has 4 more candies than the red box.'],
        ['每拿 1 顆從藍盒到紅盒，差距會縮小 2 顆，所以要拿 2 顆。', 'Each candy moved from the blue box to the red box reduces the difference by 2, so 2 candies must be moved.']
      )
    ).merge(integer_answer(2, digits: 1))
  end,
  'arithmetic_grade5_foundation_008' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '甲盒和乙盒共裝了 48 顆球。若從球較多的那盒拿 4 顆到另一盒後，兩盒球數的比變成 5:3。原來較多的那盒有幾顆球？',
        en: 'Box A and Box B contain 48 balls in total. If 4 balls are moved from the box with more balls to the other box, the numbers of balls become 5:3. How many balls were originally in the fuller box?'
      ),
      'answer' => loc(zh_hant: '答案是 34 顆。', en: 'The answer is 34.'),
      'solutionSteps' => steps(
        ['移動 4 顆後，兩盒的比是 5:3，總數還是 48。', 'After moving 4 balls, the ratio is 5:3 and the total is still 48.'],
        ['5 + 3 = 8 份，所以每份是 48 ÷ 8 = 6。', 'The total of the ratio parts is 8, so each part is 48 ÷ 8 = 6.'],
        ['移動後兩盒分別是 5 × 6 = 30 顆與 3 × 6 = 18 顆。', 'After the move, the boxes contain 30 balls and 18 balls.'],
        ['原來較多的那盒是把 4 顆拿出去的那盒，所以原來有 30 + 4 = 34 顆。', 'The fuller box is the one that gave away 4 balls, so it originally had 30 + 4 = 34 balls.']
      )
    ).merge(integer_answer(34, digits: 2))
  end,
  'arithmetic_grade6_foundation_008' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '甲盒和乙盒共裝了 96 顆球。若從球較多的那盒拿 6 顆到另一盒後，兩盒球數的比變成 3:1。原來較多的那盒有幾顆球？',
        en: 'Box A and Box B contain 96 balls in total. If 6 balls are moved from the box with more balls to the other box, the numbers of balls become 3:1. How many balls were originally in the fuller box?'
      ),
      'answer' => loc(zh_hant: '答案是 78 顆。', en: 'The answer is 78.'),
      'solutionSteps' => steps(
        ['移動後兩盒總數仍然是 96 顆，而且比是 3:1。', 'After the move, the total is still 96 balls and the ratio is 3:1.'],
        ['3 + 1 = 4 份，所以每份是 96 ÷ 4 = 24。', 'The ratio has 4 parts in total, so each part is 96 ÷ 4 = 24.'],
        ['移動後兩盒分別是 72 顆與 24 顆。', 'After the move, the two boxes contain 72 and 24 balls.'],
        ['原來較多的那盒拿出了 6 顆，所以原來有 72 + 6 = 78 顆。', 'The fuller box gave away 6 balls, so it originally had 72 + 6 = 78 balls.']
      )
    ).merge(integer_answer(78, digits: 2))
  end,
  'geometry_grade5_foundation_011' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '一個長方形長 9 公分、寬 6 公分。從左上角和右上角各剪下一個直角三角形，兩個三角形的底分別是 2 公分和 2 公分，高都等於 6 公分，剩下的圖形剛好是一個梯形。這個梯形的面積是多少平方公分？',
        en: 'A rectangle is 9 cm by 6 cm. A right triangle is cut from each of the top corners. The two triangles have bases 2 cm and 2 cm, and both have height 6 cm. The remaining shape is a trapezoid. What is its area?'
      ),
      'answer' => loc(zh_hant: '答案是 42 平方公分。', en: 'The answer is 42 square centimeters.'),
      'solutionSteps' => steps(
        ['原來長方形面積是 9 × 6 = 54。', 'The rectangle originally has area 9 × 6 = 54.'],
        ['每個剪掉的直角三角形面積是 2 × 6 ÷ 2 = 6。', 'Each removed right triangle has area 2 × 6 ÷ 2 = 6.'],
        ['兩個三角形共剪掉 12，所以剩下梯形面積是 54 - 12 = 42。', 'The two triangles remove 12 in total, so the trapezoid area is 54 - 12 = 42.']
      )
    ).merge(integer_answer(42, digits: 2))
  end,
  'geometry_grade5_foundation_015' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '兩個完全一樣的梯形可以拼成一個平行四邊形。若每個梯形的上底是 8 公分、下底是 14 公分、高是 5 公分，拼成的平行四邊形面積是多少平方公分？',
        en: 'Two identical trapezoids can be joined to form a parallelogram. Each trapezoid has top base 8 cm, bottom base 14 cm, and height 5 cm. What is the area of the resulting parallelogram?'
      ),
      'answer' => loc(zh_hant: '答案是 110 平方公分。', en: 'The answer is 110 square centimeters.'),
      'solutionSteps' => steps(
        ['兩個一樣的梯形拼起來，平行四邊形的底就是 8 + 14 = 22 公分。', 'When two identical trapezoids are joined, the parallelogram has base 8 + 14 = 22 cm.'],
        ['平行四邊形的高和原本梯形的高一樣，都是 5 公分。', 'The parallelogram has the same height as the trapezoid, which is 5 cm.'],
        ['所以平行四邊形面積是 22 × 5 = 110。', 'So the parallelogram area is 22 × 5 = 110.']
      )
    ).merge(integer_answer(110, digits: 3))
  end,
  'geometry_grade5_foundation_025' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '一個梯形的面積是 56 平方公分，上底與下底的和是 16 公分。若畫一個和它同高的三角形，且三角形的底等於梯形的上底與下底的和，這個三角形面積是多少平方公分？',
        en: 'A trapezoid has area 56 square centimeters, and the sum of its two bases is 16 cm. Draw a triangle with the same height and with base equal to the sum of the trapezoid’s two bases. What is the area of the triangle?'
      ),
      'answer' => loc(zh_hant: '答案是 56 平方公分。', en: 'The answer is 56 square centimeters.'),
      'solutionSteps' => steps(
        ['梯形面積公式是 (上底 + 下底) × 高 ÷ 2。', 'The area of a trapezoid is (top base + bottom base) × height ÷ 2.'],
        ['題目中的三角形底就是上底加下底，而且高相同。', 'In the new triangle, the base equals the sum of the two bases and the height is the same.'],
        ['所以三角形面積也會是 16 × 高 ÷ 2，和原梯形完全一樣。', 'So the triangle area is also 16 × height ÷ 2, exactly the same as the trapezoid area.'],
        ['因此三角形面積是 56 平方公分。', 'Therefore the triangle area is 56 square centimeters.']
      )
    ).merge(
      choice_answer(
        'A',
        options: {
          'A' => loc(zh_hant: '56', en: '56'),
          'B' => loc(zh_hant: '48', en: '48'),
          'C' => loc(zh_hant: '64', en: '64'),
          'D' => loc(zh_hant: '112', en: '112')
        }
      )
    )
  end,
  'geometry_grade5_foundation_027' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '一個梯形的面積是 45 平方公分，高是 6 公分。已知上底是下底的一半。這個梯形上下底相差多少公分？',
        en: 'A trapezoid has area 45 square centimeters and height 6 cm. The top base is half of the bottom base. What is the difference between the two bases?'
      ),
      'answer' => loc(zh_hant: '答案是 5 公分。', en: 'The answer is 5 cm.'),
      'solutionSteps' => steps(
        ['梯形面積是 (上底 + 下底) × 高 ÷ 2，所以 (上底 + 下底) × 6 ÷ 2 = 45。', 'Using the trapezoid area formula, (top base + bottom base) × 6 ÷ 2 = 45.'],
        ['得到上底 + 下底 = 15。', 'So the sum of the two bases is 15.'],
        ['若上底是下底的一半，可設上底是 5，下底是 10。', 'If the top base is half the bottom base, the bases are 5 and 10.'],
        ['因此它們相差 10 - 5 = 5 公分。', 'Therefore the difference is 10 - 5 = 5 cm.']
      )
    ).merge(integer_answer(5, digits: 1))
  end,
  'geometry_grade5_foundation_028' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '兩個梯形甲、乙的高都一樣，都是 8 公分。梯形甲的上底是 7 公分、下底是 x 公分，面積是 60 平方公分；梯形乙的上底是 x 公分、下底是 13 公分，面積是 84 平方公分。x 是多少公分？',
        en: 'Two trapezoids, A and B, both have height 8 cm. Trapezoid A has top base 7 cm, bottom base x cm, and area 60 square centimeters. Trapezoid B has top base x cm, bottom base 13 cm, and area 84 square centimeters. What is x?'
      ),
      'answer' => loc(zh_hant: '答案是 8 公分。', en: 'The answer is 8 cm.'),
      'solutionSteps' => steps(
        ['先用梯形甲： (7 + x) × 8 ÷ 2 = 60。', 'Use trapezoid A first: (7 + x) × 8 ÷ 2 = 60.'],
        ['整理得 (7 + x) × 4 = 60，所以 7 + x = 15。', 'This becomes (7 + x) × 4 = 60, so 7 + x = 15.'],
        ['因此 x = 8。', 'Hence x = 8.'],
        ['代回梯形乙檢查： (8 + 13) × 8 ÷ 2 = 84，符合題意。', 'Check with trapezoid B: (8 + 13) × 8 ÷ 2 = 84, so it fits.']
      )
    ).merge(integer_answer(8, digits: 1))
  end,
  'geometry_grade5_foundation_030' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '一個梯形的上底是 4 公分、下底是 10 公分、高是 8 公分。把它沿對角線分成兩個三角形。面積較大的那個三角形是多少平方公分？',
        en: 'A trapezoid has top base 4 cm, bottom base 10 cm, and height 8 cm. It is cut along a diagonal into two triangles. What is the area of the larger triangle?'
      ),
      'answer' => loc(zh_hant: '答案是 40 平方公分。', en: 'The answer is 40 square centimeters.'),
      'solutionSteps' => steps(
        ['梯形總面積是 (4 + 10) × 8 ÷ 2 = 56。', 'The total trapezoid area is (4 + 10) × 8 ÷ 2 = 56.'],
        ['沿對角線分成的兩個三角形，面積比等於上底 : 下底，也就是 4 : 10 = 2 : 5。', 'The two triangles formed by a diagonal have area ratio equal to top base : bottom base, namely 4 : 10 = 2 : 5.'],
        ['總共是 7 份，所以每份是 56 ÷ 7 = 8。', 'The total is 7 parts, so each part is 56 ÷ 7 = 8.'],
        ['較大的三角形是 5 份，面積是 5 × 8 = 40。', 'The larger triangle is 5 parts, so its area is 5 × 8 = 40.']
      )
    ).merge(integer_answer(40, digits: 2))
  end,
  'geometry_grade5_foundation_032' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '一個梯形的中位線長 11 公分，高是 8 公分。已知下底比上底長 6 公分。這個梯形的下底是多少公分？',
        en: 'A trapezoid has midline length 11 cm and height 8 cm. The bottom base is 6 cm longer than the top base. What is the bottom base?'
      ),
      'answer' => loc(zh_hant: '答案是 14 公分。', en: 'The answer is 14 cm.'),
      'solutionSteps' => steps(
        ['梯形的中位線等於上底與下底平均，所以 (上底 + 下底) ÷ 2 = 11。', 'The midline of a trapezoid equals the average of the two bases, so (top base + bottom base) ÷ 2 = 11.'],
        ['因此上底 + 下底 = 22。', 'Thus the sum of the bases is 22.'],
        ['又知道下底比上底長 6 公分。', 'We also know the bottom base is 6 cm longer than the top base.'],
        ['兩數和是 22，差是 6，所以較大的下底是 14 公分。', 'Two numbers with sum 22 and difference 6 have larger number 14, so the bottom base is 14 cm.']
      )
    ).merge(integer_answer(14, digits: 2))
  end,
  'geometry_grade5_foundation_036' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '兩個梯形的高都相同。梯形甲的上底和下底都比梯形乙各長 2 公分，因此梯形甲的面積比梯形乙大 12 平方公分。這兩個梯形的高是多少公分？',
        en: 'Two trapezoids have the same height. Trapezoid A has both bases 2 cm longer than those of trapezoid B, so trapezoid A has area 12 square centimeters more than trapezoid B. What is their common height?'
      ),
      'answer' => loc(zh_hant: '答案是 6 公分。', en: 'The answer is 6 cm.'),
      'solutionSteps' => steps(
        ['梯形甲比梯形乙在上底多 2、公底也多 2，所以底和一共多 4。', 'Trapezoid A has 2 cm more on each base, so the sum of its bases is 4 cm greater.'],
        ['面積差就是 4 × 高 ÷ 2 = 2 × 高。', 'The area difference is therefore 4 × height ÷ 2 = 2 × height.'],
        ['題目說面積差是 12，所以 2 × 高 = 12。', 'The problem says the area difference is 12, so 2 × height = 12.'],
        ['因此高是 6 公分。', 'Therefore the common height is 6 cm.']
      )
    ).merge(integer_answer(6, digits: 1))
  end,
  'arithmetic_grade1_foundation_002' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '一個小朋友要走上 4 階樓梯，每一步可以走 1 階或 2 階，但不能連續兩次都走 2 階。共有幾種不同走法？',
        en: 'A child wants to climb 4 steps. Each move can be 1 step or 2 steps, but two 2-step moves may not happen consecutively. How many different ways are there?'
      ),
      'answer' => loc(zh_hant: '答案是 4 種。', en: 'The answer is 4.'),
      'solutionSteps' => steps(
        ['先列出總和是 4 的走法：1+1+1+1、1+1+2、1+2+1、2+1+1、2+2。', 'List the ways to make 4: 1+1+1+1, 1+1+2, 1+2+1, 2+1+1, and 2+2.'],
        ['其中 2+2 這種有連續兩次都走 2 階，不符合規定。', 'The pattern 2+2 has two consecutive 2-step moves, so it is not allowed.'],
        ['剩下 4 種符合條件。', 'So 4 valid ways remain.']
      )
    ).merge(integer_answer(4, digits: 1))
  end,
  'arithmetic_grade2_foundation_005' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '一個小朋友要走上 6 階樓梯，每一步可以走 1 階或 2 階，而且剛好要用兩次 2 階。共有幾種不同走法？',
        en: 'A child wants to climb 6 steps. Each move can be 1 step or 2 steps, and exactly two 2-step moves must be used. How many different ways are there?'
      ),
      'answer' => loc(zh_hant: '答案是 6 種。', en: 'The answer is 6.'),
      'solutionSteps' => steps(
        ['兩次 2 階一共走了 4 階，所以還要再配兩次 1 階，總共會有 4 步。', 'Two 2-step moves cover 4 steps, so two 1-step moves are still needed. That makes 4 moves in total.'],
        ['這 4 步裡面，要挑哪 2 個位置放 2 階。', 'We need to choose which 2 of the 4 move positions are 2-step moves.'],
        ['從 4 個位置選 2 個，共有 6 種選法。', 'Choosing 2 positions from 4 gives 6 possibilities.']
      )
    ).merge(integer_answer(6, digits: 1))
  end,
  'arithmetic_grade4_foundation_008' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '一個小朋友要走上 5 階樓梯，每一步可以走 1 階或 2 階，但第一步不能走 2 階，最後一步也不能走 2 階。共有幾種不同走法？',
        en: 'A child wants to climb 5 steps. Each move can be 1 step or 2 steps, but the first move cannot be 2 steps and the last move cannot be 2 steps. How many different ways are there?'
      ),
      'answer' => loc(zh_hant: '答案是 3 種。', en: 'The answer is 3.'),
      'solutionSteps' => steps(
        ['第一步和最後一步都只能走 1 階，所以先固定成 1 _ _ 1。', 'The first and last moves must both be 1-step moves, so we fix the pattern as 1 _ _ 1.'],
        ['中間還需要補滿 3 階，每次仍可走 1 階或 2 階。', 'The middle part must still cover 3 steps, using moves of 1 or 2 steps.'],
        ['補成 3 階的方法有：1+1+1、1+2、2+1，共 3 種。', 'The ways to make 3 are 1+1+1, 1+2, and 2+1, so there are 3 possibilities.']
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
