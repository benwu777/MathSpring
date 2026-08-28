#!/usr/bin/env ruby
# frozen_string_literal: true

# grade3 第二輪擴充之二：logic 2 / arithmetic 5
require 'json'
require 'set'

ROOT = File.expand_path('..', __dir__)
GRADE = 'grade3'
PATHS = %w[logic arithmetic].to_h { |t| [t, File.join(ROOT, "assets/questions/#{t}/#{GRADE}_foundation.#{t}.v1.json")] }.freeze
MANIFEST_PATH = File.join(ROOT, 'assets/questions/manifest.json')

def load_json(path) = JSON.parse(File.read(path))
def save_json(path, data) = File.write(path, JSON.pretty_generate(data) + "\n")

def int_q(topic:, subtopic:, prompt:, answer:, steps:, value:, max_digits:, notes:)
  { 'reviewStatus' => 'ok', 'topic' => topic, 'subtopic' => subtopic,
    'difficulty' => 'foundation', 'levelStage' => GRADE, 'challengeTier' => 'foundation',
    'prompt' => prompt, 'answer' => answer, 'solutionSteps' => steps,
    'figure' => { 'type' => 'custom', 'kind' => 'none', 'params' => {} },
    'answerMode' => 'integer_input',
    'correctAnswer' => { 'type' => 'integer', 'value' => value },
    'inputConstraints' => { 'allowNegative' => false, 'maxDigits' => max_digits },
    'source' => { 'type' => 'rewritten_olympiad_style', 'name' => 'MathSpring Editorial',
                  'reference' => "#{topic}-#{GRADE}-foundation", 'notes' => notes } }
end

QUESTIONS = {
  'logic' => [
    int_q(
      topic: 'logic', subtopic: 'balance_reasoning',
      prompt: {
        'zh-Hant' => '同一種水果每個都一樣重。天平第一次：左邊放 1 個蘋果和 1 個梨，右邊放 3 個橘子，剛好平衡。天平第二次：左邊放 1 個蘋果，右邊放 1 個梨和 1 個橘子，也剛好平衡。請問 1 個蘋果和幾個橘子一樣重？',
        'zh-Hans' => '同一种水果每个都一样重。天平第一次：左边放 1 个苹果和 1 个梨，右边放 3 个橘子，刚好平衡。天平第二次：左边放 1 个苹果，右边放 1 个梨和 1 个橘子，也刚好平衡。请问 1 个苹果和几个橘子一样重？',
        'en' => 'All fruits of the same kind weigh the same. First weighing: 1 apple and 1 pear on the left balance 3 oranges on the right. Second weighing: 1 apple on the left balances 1 pear and 1 orange on the right. How many oranges weigh the same as 1 apple?',
        'ja' => '同じ種類のくだものはどれも同じ重さです。1 回目：左に りんご 1 個となし 1 個、右にみかん 3 個でつり合いました。2 回目：左にりんご 1 個、右になし 1 個とみかん 1 個でつり合いました。りんご 1 個はみかん何個と同じ重さですか。',
      },
      answer: { 'zh-Hant' => '答案是 2 個橘子。', 'zh-Hans' => '答案是 2 个橘子。',
                'en' => 'The answer is 2 oranges.', 'ja' => '答えはみかん 2 個です。' },
      steps: {
        'zh-Hant' => [
          '第二次告訴我們：1 個蘋果的重量等於 1 個梨加 1 個橘子。',
          '把這個關係代進第一次：第一次左邊是 1 個蘋果加 1 個梨，也就是（1 個梨加 1 個橘子）再加 1 個梨。',
          '所以第一次的左邊其實是 2 個梨加 1 個橘子，而它和 3 個橘子一樣重。',
          '兩邊同時拿掉 1 個橘子，得到 2 個梨和 2 個橘子一樣重，所以 1 個梨等於 1 個橘子。',
          '再回到第二次：1 個蘋果等於 1 個梨加 1 個橘子，也就是 1 個橘子加 1 個橘子，等於 2 個橘子。',
        ],
        'zh-Hans' => [
          '第二次告诉我们：1 个苹果的重量等于 1 个梨加 1 个橘子。',
          '把这个关系代进第一次：第一次左边是 1 个苹果加 1 个梨，也就是（1 个梨加 1 个橘子）再加 1 个梨。',
          '所以第一次的左边其实是 2 个梨加 1 个橘子，而它和 3 个橘子一样重。',
          '两边同时拿掉 1 个橘子，得到 2 个梨和 2 个橘子一样重，所以 1 个梨等于 1 个橘子。',
          '再回到第二次：1 个苹果等于 1 个梨加 1 个橘子，也就是 1 个橘子加 1 个橘子，等于 2 个橘子。',
        ],
        'en' => [
          'The second weighing tells us that 1 apple weighs the same as 1 pear plus 1 orange.',
          'Substitute that into the first weighing: its left side is 1 apple plus 1 pear, which is (1 pear plus 1 orange) plus 1 pear.',
          'So the left side is really 2 pears plus 1 orange, and it balances 3 oranges.',
          'Removing 1 orange from each side leaves 2 pears balancing 2 oranges, so 1 pear weighs the same as 1 orange.',
          'Back in the second weighing, 1 apple equals 1 pear plus 1 orange, which is 1 orange plus 1 orange, that is 2 oranges.',
        ],
        'ja' => [
          '2 回目から、りんご 1 個はなし 1 個とみかん 1 個の重さに等しいとわかります。',
          'これを 1 回目に代入します。1 回目の左はりんご 1 個となし 1 個なので、（なし 1 個とみかん 1 個）にさらになし 1 個を加えたものです。',
          'つまり左は実際にはなし 2 個とみかん 1 個で、これがみかん 3 個とつり合っています。',
          '両側からみかんを 1 個ずつ取り除くと、なし 2 個とみかん 2 個がつり合うので、なし 1 個はみかん 1 個と同じ重さです。',
          '2 回目にもどると、りんご 1 個はなし 1 個とみかん 1 個、つまりみかん 1 個とみかん 1 個で、みかん 2 個です。',
        ],
      },
      value: '2', max_digits: 1,
      notes: 'Original composition in the Math Kangaroo grade 3-4 balance style; two weighings must be combined by substitution and cancellation, unlike the single-ratio scaling item in the grade1 pack. Not a reproduction of any past paper.',
    ),
    int_q(
      topic: 'logic', subtopic: 'arrangement',
      prompt: {
        'zh-Hant' => '一組密碼是三位數，三個位上的數字都取自 1、2、3、4、5 這五個數字，而且不可以重複。已知百位的數字比十位的大，十位的數字又比個位的大。符合條件的密碼一共有幾組？',
        'zh-Hans' => '一组密码是三位数，三个位上的数字都取自 1、2、3、4、5 这五个数字，而且不可以重复。已知百位的数字比十位的大，十位的数字又比个位的大。符合条件的密码一共有几组？',
        'en' => 'A password is a three-digit number whose digits all come from 1, 2, 3, 4 and 5 with no repeats. The hundreds digit is greater than the tens digit, and the tens digit is greater than the units digit. How many such passwords are there?',
        'ja' => 'ある暗証番号は 3 けたの数で、各位の数字は 1、2、3、4、5 から選び、同じ数字は使いません。百の位は十の位より大きく、十の位は一の位より大きいことがわかっています。条件に合う暗証番号は何通りありますか。',
      },
      answer: { 'zh-Hant' => '答案是 10 組。', 'zh-Hans' => '答案是 10 组。',
                'en' => 'The answer is 10 passwords.', 'ja' => '答えは 10 通りです。' },
      steps: {
        'zh-Hant' => [
          '題目要求三個數字由大到小排列，所以只要選出是哪三個數字，排法就唯一確定了。',
          '例如選出 1、3、5，就一定排成 531，不會有第二種排法。',
          '因此問題變成：從 1、2、3、4、5 這 5 個數字中選出 3 個，有幾種選法。',
          '一一列出：135、145、125、235、245、215、345、325、315、435 這樣容易漏，改成按最大的數字分類。',
          '最大是 3 的有 321 一種；最大是 4 的有 421、431、432 三種；最大是 5 的有 521、531、532、541、542、543 六種。合計 1 + 3 + 6 = 10 組。',
        ],
        'zh-Hans' => [
          '题目要求三个数字由大到小排列，所以只要选出是哪三个数字，排法就唯一确定了。',
          '例如选出 1、3、5，就一定排成 531，不会有第二种排法。',
          '因此问题变成：从 1、2、3、4、5 这 5 个数字中选出 3 个，有几种选法。',
          '一一列出容易漏，改成按最大的数字分类。',
          '最大是 3 的有 321 一种；最大是 4 的有 421、431、432 三种；最大是 5 的有 521、531、532、541、542、543 六种。合计 1 + 3 + 6 = 10 组。',
        ],
        'en' => [
          'The digits must appear in decreasing order, so once the three digits are chosen the arrangement is fixed.',
          'For instance, choosing 1, 3 and 5 forces the password 531, with no second possibility.',
          'The question therefore becomes: how many ways are there to choose 3 digits from 1, 2, 3, 4 and 5.',
          'Listing them at random risks missing some, so sort them by the largest digit.',
          'With largest 3 there is 321; with largest 4 there are 421, 431 and 432; with largest 5 there are 521, 531, 532, 541, 542 and 543. That is 1 + 3 + 6 = 10 passwords.',
        ],
        'ja' => [
          '数字は大きい順に並べる必要があるので、どの 3 つを選ぶかが決まれば並べ方は 1 通りに決まります。',
          'たとえば 1、3、5 を選べば必ず 531 になり、ほかの並べ方はありません。',
          'したがって問題は、1、2、3、4、5 から 3 つ選ぶ方法が何通りあるか、ということになります。',
          '手あたりしだいに書き出すと見落とすので、いちばん大きい数字で分類します。',
          '最大が 3 なら 321 の 1 通り、最大が 4 なら 421、431、432 の 3 通り、最大が 5 なら 521、531、532、541、542、543 の 6 通りで、合計 1 + 3 + 6 = 10 通りです。',
        ],
      },
      value: '10', max_digits: 2,
      notes: 'Original composition in the Math Kangaroo grade 3-4 counting style; the ordering condition collapses arrangements to selections, and the enumeration is organised by the largest digit to avoid omissions. Not a reproduction of any past paper.',
    ),
  ],
  'arithmetic' => [
    int_q(
      topic: 'arithmetic', subtopic: 'average_reasoning',
      prompt: {
        'zh-Hant' => '小安三次數學考試的平均分數是 85 分。已知前兩次分別考了 82 分和 90 分，求第三次考了幾分。',
        'zh-Hans' => '小安三次数学考试的平均分数是 85 分。已知前两次分别考了 82 分和 90 分，求第三次考了几分。',
        'en' => 'An\'s three maths tests have an average score of 85. The first two scores were 82 and 90. What was the third score?',
        'ja' => 'アンさんの数学のテスト 3 回の平均点は 85 点です。はじめの 2 回は 82 点と 90 点でした。3 回目は何点でしたか。',
      },
      answer: { 'zh-Hant' => '答案是 83 分。', 'zh-Hans' => '答案是 83 分。',
                'en' => 'The answer is 83.', 'ja' => '答えは 83 点です。' },
      steps: {
        'zh-Hant' => [
          '平均分數是把總分平分給每一次考試，所以總分等於平均分數乘以次數。',
          '三次的總分是 85 × 3 = 255 分。',
          '前兩次的分數合計是 82 + 90 = 172 分。',
          '第三次的分數就是總分扣掉前兩次，也就是 255 − 172 = 83 分。',
        ],
        'zh-Hans' => [
          '平均分数是把总分平分给每一次考试，所以总分等于平均分数乘以次数。',
          '三次的总分是 85 × 3 = 255 分。',
          '前两次的分数合计是 82 + 90 = 172 分。',
          '第三次的分数就是总分扣掉前两次，也就是 255 − 172 = 83 分。',
        ],
        'en' => [
          'An average shares the total equally among the tests, so the total equals the average times the number of tests.',
          'The total over three tests is 85 × 3 = 255.',
          'The first two scores add to 82 + 90 = 172.',
          'The third score is the total minus the first two, that is 255 − 172 = 83.',
        ],
        'ja' => [
          '平均は合計を回数で等しく分けたものなので、合計は平均 × 回数です。',
          '3 回の合計は 85 × 3 = 255 点です。',
          'はじめの 2 回の合計は 82 + 90 = 172 点です。',
          '3 回目は合計から 2 回分を引いた 255 − 172 = 83 点です。',
        ],
      },
      value: '83', max_digits: 2,
      notes: 'Original composition in the Math Kangaroo grade 3-4 average style; the average must be converted to a total before the missing value can be recovered. Not a reproduction of any past paper.',
    ),
    int_q(
      topic: 'arithmetic', subtopic: 'ratio',
      prompt: {
        'zh-Hant' => '一個袋子裡紅球和藍球的個數比是 3 比 5。已知紅球有 12 個，求藍球有幾個。',
        'zh-Hans' => '一个袋子里红球和蓝球的个数比是 3 比 5。已知红球有 12 个，求蓝球有几个。',
        'en' => 'In a bag, the number of red balls to the number of blue balls is in the ratio 3 to 5. There are 12 red balls. How many blue balls are there?',
        'ja' => 'ふくろの中の赤玉と青玉の個数の比は 3 : 5 です。赤玉が 12 個のとき、青玉は何個ですか。',
      },
      answer: { 'zh-Hant' => '答案是 20 個。', 'zh-Hans' => '答案是 20 个。',
                'en' => 'The answer is 20 blue balls.', 'ja' => '答えは 20 個です。' },
      steps: {
        'zh-Hant' => [
          '比是 3 比 5，表示可以把紅球看成 3 份、藍球看成 5 份，每一份的個數都一樣。',
          '紅球是 3 份，一共 12 個，所以一份是 12 ÷ 3 = 4 個。',
          '藍球是 5 份，每份 4 個。',
          '所以藍球有 4 × 5 = 20 個。',
        ],
        'zh-Hans' => [
          '比是 3 比 5，表示可以把红球看成 3 份、蓝球看成 5 份，每一份的个数都一样。',
          '红球是 3 份，一共 12 个，所以一份是 12 ÷ 3 = 4 个。',
          '蓝球是 5 份，每份 4 个。',
          '所以蓝球有 4 × 5 = 20 个。',
        ],
        'en' => [
          'A ratio of 3 to 5 means the reds can be seen as 3 equal parts and the blues as 5 parts of the same size.',
          'The 3 red parts come to 12 balls, so one part is 12 ÷ 3 = 4 balls.',
          'The blues are 5 parts, each of 4 balls.',
          'So there are 4 × 5 = 20 blue balls.',
        ],
        'ja' => [
          '比が 3 : 5 なので、赤玉を 3 つ分、青玉を 5 つ分と考えられ、1 つ分の個数は同じです。',
          '赤玉は 3 つ分で 12 個なので、1 つ分は 12 ÷ 3 = 4 個です。',
          '青玉は 5 つ分で、1 つ分は 4 個です。',
          'したがって青玉は 4 × 5 = 20 個です。',
        ],
      },
      value: '20', max_digits: 2,
      notes: 'Original composition in the Math Kangaroo grade 3-4 ratio style; the ratio is turned into equal parts and one part is found before scaling up. Not a reproduction of any past paper.',
    ),
    int_q(
      topic: 'arithmetic', subtopic: 'unit_rate',
      prompt: {
        'zh-Hant' => '小安走路每分鐘走 60 公尺，騎腳踏車每分鐘走 200 公尺。同一段路，他走路要花 20 分鐘。如果改成騎腳踏車，要花幾分鐘？',
        'zh-Hans' => '小安走路每分钟走 60 米，骑自行车每分钟走 200 米。同一段路，他走路要花 20 分钟。如果改成骑自行车，要花几分钟？',
        'en' => 'An walks 60 metres a minute and cycles 200 metres a minute. Walking a certain route takes 20 minutes. How many minutes does the same route take by bicycle?',
        'ja' => 'アンさんは歩くと 1 分間に 60 m、自転車では 1 分間に 200 m 進みます。ある道を歩くと 20 分かかります。同じ道を自転車で行くと何分かかりますか。',
      },
      answer: { 'zh-Hant' => '答案是 6 分鐘。', 'zh-Hans' => '答案是 6 分钟。',
                'en' => 'The answer is 6 minutes.', 'ja' => '答えは 6 分です。' },
      steps: {
        'zh-Hant' => [
          '兩種方式走的是同一段路，所以距離是一樣的，先把距離算出來。',
          '走路每分鐘 60 公尺、走了 20 分鐘，所以這段路長 60 × 20 = 1200 公尺。',
          '騎腳踏車每分鐘走 200 公尺，要走完 1200 公尺。',
          '所需時間是 1200 ÷ 200 = 6 分鐘。',
        ],
        'zh-Hans' => [
          '两种方式走的是同一段路，所以距离是一样的，先把距离算出来。',
          '走路每分钟 60 米、走了 20 分钟，所以这段路长 60 × 20 = 1200 米。',
          '骑自行车每分钟走 200 米，要走完 1200 米。',
          '所需时间是 1200 ÷ 200 = 6 分钟。',
        ],
        'en' => [
          'Both ways cover the same route, so the distance is the same and can be worked out first.',
          'Walking at 60 metres a minute for 20 minutes gives a distance of 60 × 20 = 1200 metres.',
          'By bicycle the speed is 200 metres a minute over that same 1200 metres.',
          'The time needed is 1200 ÷ 200 = 6 minutes.',
        ],
        'ja' => [
          'どちらも同じ道なので距離は同じです。まず距離を求めます。',
          '歩きは 1 分 60 m で 20 分なので、道のりは 60 × 20 = 1200 m です。',
          '自転車は 1 分 200 m で、この 1200 m を進みます。',
          'かかる時間は 1200 ÷ 200 = 6 分です。',
        ],
      },
      value: '6', max_digits: 1,
      notes: 'Original composition in the Math Kangaroo grade 3-4 rate style; the shared distance is the bridge between the two speeds, so it must be computed before the second time can be found. Not a reproduction of any past paper.',
    ),
    int_q(
      topic: 'arithmetic', subtopic: 'fractions',
      prompt: {
        'zh-Hant' => '一本書有 120 頁。小安第一天看了全書的四分之一，第二天看了剩下頁數的三分之一。這本書還剩下幾頁沒看？',
        'zh-Hans' => '一本书有 120 页。小安第一天看了全书的四分之一，第二天看了剩下页数的三分之一。这本书还剩下几页没看？',
        'en' => 'A book has 120 pages. An reads a quarter of the whole book on the first day, and on the second day reads a third of what is left. How many pages remain unread?',
        'ja' => 'ある本は 120 ページです。アンさんは 1 日目に全体の 4 分の 1 を読み、2 日目に残りのページ数の 3 分の 1 を読みました。まだ読んでいないページは何ページですか。',
      },
      answer: { 'zh-Hant' => '答案是 60 頁。', 'zh-Hans' => '答案是 60 页。',
                'en' => 'The answer is 60 pages.', 'ja' => '答えは 60 ページです。' },
      steps: {
        'zh-Hant' => [
          '第一天看的是「全書」的四分之一，也就是 120 ÷ 4 = 30 頁。',
          '看完第一天後，還剩下 120 − 30 = 90 頁。',
          '第二天看的是「剩下頁數」的三分之一，不是全書的三分之一，這是最容易弄錯的地方。',
          '第二天看了 90 ÷ 3 = 30 頁。',
          '所以還剩下 90 − 30 = 60 頁沒看。',
        ],
        'zh-Hans' => [
          '第一天看的是「全书」的四分之一，也就是 120 ÷ 4 = 30 页。',
          '看完第一天后，还剩下 120 − 30 = 90 页。',
          '第二天看的是「剩下页数」的三分之一，不是全书的三分之一，这是最容易弄错的地方。',
          '第二天看了 90 ÷ 3 = 30 页。',
          '所以还剩下 90 − 30 = 60 页没看。',
        ],
        'en' => [
          'On the first day a quarter of the whole book is read, which is 120 ÷ 4 = 30 pages.',
          'That leaves 120 − 30 = 90 pages.',
          'On the second day a third of what is left is read, not a third of the whole book, and this is the easiest point to get wrong.',
          'The second day accounts for 90 ÷ 3 = 30 pages.',
          'So 90 − 30 = 60 pages remain unread.',
        ],
        'ja' => [
          '1 日目に読んだのは「全体」の 4 分の 1 で、120 ÷ 4 = 30 ページです。',
          '1 日目のあと、残りは 120 − 30 = 90 ページです。',
          '2 日目に読むのは「残り」の 3 分の 1 であって全体の 3 分の 1 ではありません。ここがまちがえやすいところです。',
          '2 日目に読んだのは 90 ÷ 3 = 30 ページです。',
          'したがってまだ読んでいないのは 90 − 30 = 60 ページです。',
        ],
      },
      value: '60', max_digits: 2,
      notes: 'Original composition in the Math Kangaroo grade 3-4 fraction style; the second fraction is taken of the remainder rather than of the whole, which is the intended trap. Not a reproduction of any past paper.',
    ),
    int_q(
      topic: 'arithmetic', subtopic: 'division_remainder',
      prompt: {
        'zh-Hant' => '有一個整數除以 7 之後，得到的商和餘數剛好一樣大。符合這個條件的整數之中，最大的是多少？',
        'zh-Hans' => '有一个整数除以 7 之后，得到的商和余数刚好一样大。符合这个条件的整数之中，最大的是多少？',
        'en' => 'When a certain whole number is divided by 7, the quotient and the remainder turn out to be equal. What is the largest whole number with this property?',
        'ja' => 'ある整数を 7 でわると、商とあまりがちょうど同じ大きさになりました。この条件に合う整数のうち、最大のものはいくつですか。',
      },
      answer: { 'zh-Hant' => '答案是 48。', 'zh-Hans' => '答案是 48。', 'en' => 'The answer is 48.', 'ja' => '答えは 48 です。' },
      steps: {
        'zh-Hant' => [
          '除以 7 的時候，被除數等於 7 乘以商，再加上餘數。',
          '題目說商和餘數一樣大，把它們都記成同一個數，那麼被除數就是 7 × 這個數 再加上 這個數，也就是這個數的 8 倍。',
          '餘數一定要比除數小，所以這個數必須小於 7，最大只能是 6。',
          '這個數是 6 時，被除數是 8 × 6 = 48。',
          '檢查：48 ÷ 7 = 6 餘 6，商和餘數都是 6，符合條件，所以最大是 48。',
        ],
        'zh-Hans' => [
          '除以 7 的时候，被除数等于 7 乘以商，再加上余数。',
          '题目说商和余数一样大，把它们都记成同一个数，那么被除数就是 7 × 这个数 再加上 这个数，也就是这个数的 8 倍。',
          '余数一定要比除数小，所以这个数必须小于 7，最大只能是 6。',
          '这个数是 6 时，被除数是 8 × 6 = 48。',
          '检查：48 ÷ 7 = 6 余 6，商和余数都是 6，符合条件，所以最大是 48。',
        ],
        'en' => [
          'When dividing by 7, the original number equals 7 times the quotient plus the remainder.',
          'The quotient and remainder are equal, so calling that common value one number, the original is 7 times it plus itself, that is 8 times it.',
          'A remainder must be smaller than the divisor, so that value must be less than 7, and the largest possibility is 6.',
          'With the value 6, the original number is 8 × 6 = 48.',
          'Checking, 48 ÷ 7 = 6 remainder 6, so the quotient and remainder are both 6 and the largest such number is 48.',
        ],
        'ja' => [
          '7 でわるとき、もとの数は 7 × 商 + あまり で表されます。',
          '商とあまりが等しいので、その共通の値を 1 つの数とすると、もとの数は 7 倍にその数を加えたもの、つまりその数の 8 倍です。',
          'あまりはわる数より小さくなければならないので、その数は 7 未満、最大で 6 です。',
          'その数が 6 のとき、もとの数は 8 × 6 = 48 です。',
          '確かめると 48 ÷ 7 = 6 あまり 6 で商もあまりも 6 なので、最大は 48 です。',
        ],
      },
      value: '48', max_digits: 2,
      notes: 'Original composition in the Math Kangaroo grade 3-4 division style; the constraint that a remainder is smaller than the divisor is what bounds the answer, rather than the division itself. Not a reproduction of any past paper.',
    ),
  ],
}.freeze

counts = {}
QUESTIONS.each do |topic, questions|
  path = PATHS[topic]
  pack = load_json(path)
  serial = pack['questions'].map { |q| q['id'].split('_').last.to_i }.max + 1
  ids = pack['questions'].map { |q| q['id'] }.to_set
  ordered = questions.each_with_index.map do |q, i|
    id = format('%s_%s_foundation_%03d', topic, GRADE, serial + i)
    raise "duplicate id #{id}" if ids.include?(id)

    { 'id' => id }.merge(q)
  end
  pack['questions'].concat(ordered)
  save_json(path, pack)
  counts[path] = pack['questions'].length
  puts "#{File.basename(path)} -> #{pack['questions'].length}"
end

manifest = load_json(MANIFEST_PATH)
manifest['packs'].each do |pack|
  full = File.join(ROOT, pack['path'])
  pack['questionCount'] = counts[full] if counts.key?(full)
end
save_json(MANIFEST_PATH, manifest)
