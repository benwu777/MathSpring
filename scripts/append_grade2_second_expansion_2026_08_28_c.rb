#!/usr/bin/env ruby
# frozen_string_literal: true

# grade2 第二輪擴充之三：arithmetic 7
require 'json'
require 'set'

ROOT = File.expand_path('..', __dir__)
GRADE = 'grade2'
PATH = File.join(ROOT, "assets/questions/arithmetic/#{GRADE}_foundation.arithmetic.v1.json")
MANIFEST_PATH = File.join(ROOT, 'assets/questions/manifest.json')

def load_json(path) = JSON.parse(File.read(path))
def save_json(path, data) = File.write(path, JSON.pretty_generate(data) + "\n")

def int_q(subtopic:, prompt:, answer:, steps:, value:, max_digits:, notes:)
  { 'reviewStatus' => 'ok', 'topic' => 'arithmetic', 'subtopic' => subtopic,
    'difficulty' => 'foundation', 'levelStage' => GRADE, 'challengeTier' => 'foundation',
    'prompt' => prompt, 'answer' => answer, 'solutionSteps' => steps,
    'figure' => { 'type' => 'custom', 'kind' => 'none', 'params' => {} },
    'answerMode' => 'integer_input',
    'correctAnswer' => { 'type' => 'integer', 'value' => value },
    'inputConstraints' => { 'allowNegative' => false, 'maxDigits' => max_digits },
    'source' => { 'type' => 'rewritten_olympiad_style', 'name' => 'MathSpring Editorial',
                  'reference' => "arithmetic-#{GRADE}-foundation", 'notes' => notes } }
end

QUESTIONS = [
  int_q(
    subtopic: 'remainders',
    prompt: {
      'zh-Hant' => '有一個兩位數，它除以 4 之後餘 3。符合這個條件的兩位數之中，最小的是多少？',
      'zh-Hans' => '有一个两位数，它除以 4 之后余 3。符合这个条件的两位数之中，最小的是多少？',
      'en' => 'A two-digit number leaves remainder 3 when divided by 4. What is the smallest two-digit number with this property?',
      'ja' => 'ある 2 けたの数を 4 でわると 3 あまります。この条件に合う 2 けたの数のうち、いちばん小さいものはいくつですか。',
    },
    answer: { 'zh-Hant' => '答案是 11。', 'zh-Hans' => '答案是 11。', 'en' => 'The answer is 11.', 'ja' => '答えは 11 です。' },
    steps: {
      'zh-Hant' => [
        '除以 4 餘 3 的數，就是 4 的倍數再加上 3。',
        '兩位數是從 10 開始的，所以要找不小於 10 的這種數。',
        '4 的倍數依序是 0、4、8、12⋯，各加上 3 之後是 3、7、11、15⋯。',
        '其中 3 和 7 都還是一位數，第一個兩位數是 11。',
        '檢查一下：11 ÷ 4 = 2 餘 3，符合條件，所以答案是 11。',
      ],
      'zh-Hans' => [
        '除以 4 余 3 的数，就是 4 的倍数再加上 3。',
        '两位数是从 10 开始的，所以要找不小于 10 的这种数。',
        '4 的倍数依次是 0、4、8、12⋯，各加上 3 之后是 3、7、11、15⋯。',
        '其中 3 和 7 都还是一位数，第一个两位数是 11。',
        '检查一下：11 ÷ 4 = 2 余 3，符合条件，所以答案是 11。',
      ],
      'en' => [
        'A number leaving remainder 3 on division by 4 is a multiple of 4 with 3 added.',
        'Two-digit numbers start at 10, so we want the first such number that is at least 10.',
        'The multiples of 4 are 0, 4, 8, 12, …, and adding 3 gives 3, 7, 11, 15, ….',
        'Of these, 3 and 7 are still one-digit numbers, so the first two-digit one is 11.',
        'Checking, 11 ÷ 4 = 2 remainder 3, which fits, so the answer is 11.',
      ],
      'ja' => [
        '4 でわると 3 あまる数は、4 の倍数に 3 をたした数です。',
        '2 けたの数は 10 から始まるので、10 以上でそのような数をさがします。',
        '4 の倍数は 0、4、8、12⋯ で、それぞれに 3 をたすと 3、7、11、15⋯ となります。',
        'このうち 3 と 7 はまだ 1 けたなので、最初の 2 けたの数は 11 です。',
        '確かめると 11 ÷ 4 = 2 あまり 3 で条件に合うので、答えは 11 です。',
      ],
    },
    value: '11', max_digits: 2,
    notes: 'Original composition in the Math Kangaroo grade 1-2 remainder style; the family of numbers is generated first and then filtered by the two-digit condition, rather than counting occurrences in a cycle. Not a reproduction of any past paper.',
  ),
  int_q(
    subtopic: 'piece_value',
    prompt: {
      'zh-Hant' => '商店裡只收 2 元和 5 元兩種硬幣，每種都可以用任意多個（也可以完全不用其中一種）。要剛好付出 20 元，一共有幾種不同的付法？（只看用了幾個 2 元、幾個 5 元，不管先後順序。）',
      'zh-Hans' => '商店里只收 2 元和 5 元两种硬币，每种都可以用任意多个（也可以完全不用其中一种）。要刚好付出 20 元，一共有几种不同的付法？（只看用了几个 2 元、几个 5 元，不管先后顺序。）',
      'en' => 'A shop takes only 2-dollar and 5-dollar coins, and any number of each may be used, including none. In how many different ways can exactly 20 dollars be paid? (Only the numbers of each coin matter, not the order.)',
      'ja' => 'ある店では 2 円玉と 5 円玉だけが使え、どちらも何枚でもかまいません（0 枚でもかまいません）。ちょうど 20 円を払う方法は何通りありますか。（それぞれ何枚使うかだけを見て、順序は考えません。）',
    },
    answer: { 'zh-Hant' => '答案是 3 種。', 'zh-Hans' => '答案是 3 种。',
              'en' => 'The answer is 3 ways.', 'ja' => '答えは 3 通りです。' },
    steps: {
      'zh-Hant' => [
        '依照使用 5 元硬幣的個數來分類，這樣不會重複也不會遺漏。',
        '用 0 個 5 元時，剩下 20 元要全部用 2 元付，需要 20 ÷ 2 = 10 個，可以。',
        '用 1 個 5 元時，剩下 15 元，但 15 是單數，不能用 2 元硬幣剛好付完，不行。',
        '用 2 個 5 元時，剩下 10 元，需要 5 個 2 元，可以；用 3 個 5 元時剩下 5 元是單數，不行；用 4 個 5 元時剛好 20 元，2 元用 0 個，可以。',
        '所以可行的付法是 5 元用 0 個、2 個或 4 個，一共 3 種。',
      ],
      'zh-Hans' => [
        '依照使用 5 元硬币的个数来分类，这样不会重复也不会遗漏。',
        '用 0 个 5 元时，剩下 20 元要全部用 2 元付，需要 20 ÷ 2 = 10 个，可以。',
        '用 1 个 5 元时，剩下 15 元，但 15 是单数，不能用 2 元硬币刚好付完，不行。',
        '用 2 个 5 元时，剩下 10 元，需要 5 个 2 元，可以；用 3 个 5 元时剩下 5 元是单数，不行；用 4 个 5 元时刚好 20 元，2 元用 0 个，可以。',
        '所以可行的付法是 5 元用 0 个、2 个或 4 个，一共 3 种。',
      ],
      'en' => [
        'Sort the possibilities by how many 5-dollar coins are used, which avoids both repeats and omissions.',
        'With no 5-dollar coins, the whole 20 must come from 2-dollar coins, needing 20 ÷ 2 = 10 of them, which works.',
        'With one 5-dollar coin, 15 remains, but 15 is odd and cannot be paid exactly with 2-dollar coins, so this fails.',
        'With two 5-dollar coins, 10 remains and needs 5 two-dollar coins, which works; with three, 5 remains and is odd, which fails; with four, the 20 is exactly covered and no 2-dollar coins are needed, which works.',
        'So the workable choices use 0, 2 or 4 five-dollar coins, giving 3 ways.',
      ],
      'ja' => [
        '5 円玉を何枚使うかで場合分けすると、重複も見落としもありません。',
        '5 円玉 0 枚のときは 20 円をすべて 2 円玉で払い、20 ÷ 2 = 10 枚必要で、これは可能です。',
        '5 円玉 1 枚のときは残り 15 円ですが、15 は奇数なので 2 円玉ではちょうど払えず不可能です。',
        '5 円玉 2 枚なら残り 10 円で 2 円玉 5 枚、可能です。3 枚なら残り 5 円で奇数なので不可能、4 枚ならちょうど 20 円で 2 円玉は 0 枚、可能です。',
        'よって 5 円玉を 0 枚、2 枚、4 枚使う 3 通りです。',
      ],
    },
    value: '3', max_digits: 1,
    notes: 'Original composition in the Math Kangaroo grade 1-2 coin style; here the number of ways is counted rather than a minimum, and the parity of the remaining amount rules out half the cases. Not a reproduction of any past paper.',
  ),
  int_q(
    subtopic: 'parity_counting',
    prompt: {
      'zh-Hant' => '在 1 到 20 的整數中，把每個數各位數字加起來（例如 13 的數字和是 1 + 3 = 4）。這些數之中，數字和是雙數的有幾個？',
      'zh-Hans' => '在 1 到 20 的整数中，把每个数各位数字加起来（例如 13 的数字和是 1 + 3 = 4）。这些数之中，数字和是双数的有几个？',
      'en' => 'For each integer from 1 to 20, add up its digits (for example, the digit sum of 13 is 1 + 3 = 4). How many of these numbers have an even digit sum?',
      'ja' => '1 から 20 までの整数について、各位の数字をたします（たとえば 13 の数字の和は 1 + 3 = 4）。このうち数字の和が偶数になる数は何個ありますか。',
    },
    answer: { 'zh-Hant' => '答案是 10 個。', 'zh-Hans' => '答案是 10 个。',
              'en' => 'The answer is 10 numbers.', 'ja' => '答えは 10 個です。' },
    steps: {
      'zh-Hant' => [
        '先看 1 到 9：這些數只有一位，數字和就是自己，是雙數的有 2、4、6、8，共 4 個。',
        '再看 10 到 19：十位都是 1，所以數字和是 1 加上個位。要讓和是雙數，個位就要是單數。',
        '個位是單數的有 11、13、15、17、19，共 5 個。',
        '最後看 20：數字和是 2 + 0 = 2，是雙數，再加 1 個。',
        '所以一共有 4 + 5 + 1 = 10 個。',
      ],
      'zh-Hans' => [
        '先看 1 到 9：这些数只有一位，数字和就是自己，是双数的有 2、4、6、8，共 4 个。',
        '再看 10 到 19：十位都是 1，所以数字和是 1 加上个位。要让和是双数，个位就要是单数。',
        '个位是单数的有 11、13、15、17、19，共 5 个。',
        '最后看 20：数字和是 2 + 0 = 2，是双数，再加 1 个。',
        '所以一共有 4 + 5 + 1 = 10 个。',
      ],
      'en' => [
        'Take 1 to 9 first: these are single digits, so the digit sum is the number itself, and the even ones are 2, 4, 6 and 8, which is 4 numbers.',
        'Now 10 to 19: the tens digit is always 1, so the digit sum is 1 plus the units digit, and for an even total the units digit must be odd.',
        'The numbers with an odd units digit are 11, 13, 15, 17 and 19, which is 5 numbers.',
        'Finally 20 has digit sum 2 + 0 = 2, which is even, adding one more.',
        'So there are 4 + 5 + 1 = 10 numbers in all.',
      ],
      'ja' => [
        'まず 1 から 9 です。1 けたなので数字の和は自分自身で、偶数になるのは 2、4、6、8 の 4 個です。',
        '次に 10 から 19 です。十の位はすべて 1 なので数字の和は 1 に一の位をたしたもので、和を偶数にするには一の位が奇数でなければなりません。',
        '一の位が奇数なのは 11、13、15、17、19 の 5 個です。',
        '最後に 20 は数字の和が 2 + 0 = 2 で偶数なので、もう 1 個加わります。',
        'したがって合計 4 + 5 + 1 = 10 個です。',
      ],
    },
    value: '10', max_digits: 2,
    notes: 'Original composition in the Math Kangaroo grade 1-2 digit-sum style; the range is split into blocks where the tens digit is constant, turning the condition on the sum into a condition on the units digit. Not a reproduction of any past paper.',
  ),
  int_q(
    subtopic: 'maximization',
    prompt: {
      'zh-Hant' => '用 1、2、3、4 這四個數字各一次，排成兩個兩位數，再把這兩個兩位數相乘。這個乘積最大可以是多少？',
      'zh-Hans' => '用 1、2、3、4 这四个数字各一次，排成两个两位数，再把这两个两位数相乘。这个乘积最大可以是多少？',
      'en' => 'The digits 1, 2, 3 and 4 are each used once to form two two-digit numbers, which are then multiplied. What is the largest possible product?',
      'ja' => '1、2、3、4 の 4 つの数字を 1 回ずつ使って 2 けたの数を 2 つ作り、その 2 つをかけます。積は最も大きくていくつになりますか。',
    },
    answer: { 'zh-Hant' => '答案是 1312。', 'zh-Hans' => '答案是 1312。',
              'en' => 'The answer is 1312.', 'ja' => '答えは 1312 です。' },
    steps: {
      'zh-Hant' => [
        '兩位數的十位比個位重要得多，所以要把最大的兩個數字 4 和 3 放在十位。',
        '這樣兩個數會是 4□ 和 3□，剩下的 1 和 2 放在個位。',
        '有兩種放法：41 × 32 和 42 × 31。',
        '41 × 32 = 1312，42 × 31 = 1302。',
        '比較之後，1312 比較大，所以乘積最大是 1312。',
      ],
      'zh-Hans' => [
        '两位数的十位比个位重要得多，所以要把最大的两个数字 4 和 3 放在十位。',
        '这样两个数会是 4□ 和 3□，剩下的 1 和 2 放在个位。',
        '有两种放法：41 × 32 和 42 × 31。',
        '41 × 32 = 1312，42 × 31 = 1302。',
        '比较之后，1312 比较大，所以乘积最大是 1312。',
      ],
      'en' => [
        'In a two-digit number the tens digit matters far more than the units digit, so the two largest digits 4 and 3 should go in the tens places.',
        'The numbers are then 4□ and 3□, with the remaining 1 and 2 in the units places.',
        'That leaves two possibilities: 41 × 32 and 42 × 31.',
        'Working them out, 41 × 32 = 1312 and 42 × 31 = 1302.',
        'Comparing them, 1312 is larger, so the greatest product is 1312.',
      ],
      'ja' => [
        '2 けたの数では十の位のほうが一の位よりずっと大きく効くので、大きい数字 4 と 3 を十の位に置きます。',
        'すると 2 つの数は 4□ と 3□ になり、残った 1 と 2 が一の位に入ります。',
        '置き方は 41 × 32 と 42 × 31 の 2 通りです。',
        '計算すると 41 × 32 = 1312、42 × 31 = 1302 です。',
        '比べると 1312 のほうが大きいので、最大の積は 1312 です。',
      ],
    },
    value: '1312', max_digits: 4,
    notes: 'Original composition in the Math Kangaroo grade 1-2 digit-placement style; place value narrows the search to two candidates which must then be compared directly, and this maximises a product rather than minimising a sum. Not a reproduction of any past paper.',
  ),
  int_q(
    subtopic: 'gcd_lcm',
    prompt: {
      'zh-Hant' => '文具店裡，鉛筆一盒裝 6 枝，橡皮擦一盒裝 8 個，兩種都只能整盒買。老師想買到鉛筆和橡皮擦的數量一樣多。在數量大於 0 的情況下，最少要各買到幾個（鉛筆和橡皮擦各是幾個）？',
      'zh-Hans' => '文具店里，铅笔一盒装 6 枝，橡皮擦一盒装 8 个，两种都只能整盒买。老师想买到铅笔和橡皮擦的数量一样多。在数量大于 0 的情况下，最少要各买到几个（铅笔和橡皮擦各是几个）？',
      'en' => 'At a stationery shop pencils come in boxes of 6 and erasers in boxes of 8, and both can only be bought by the whole box. A teacher wants to end up with the same number of pencils as erasers. What is the smallest number greater than 0 of each?',
      'ja' => '文具店では、えんぴつは 1 箱 6 本、消しゴムは 1 箱 8 個で、どちらも箱単位でしか買えません。先生はえんぴつと消しゴムの数を同じにしたいと考えています。0 より大きい範囲で、それぞれ最も少なくて何個ずつになりますか。',
    },
    answer: { 'zh-Hant' => '答案是各 24 個。', 'zh-Hans' => '答案是各 24 个。',
              'en' => 'The answer is 24 of each.', 'ja' => '答えはそれぞれ 24 個です。' },
    steps: {
      'zh-Hant' => [
        '只能整盒買，所以鉛筆的數量一定是 6 的倍數，橡皮擦的數量一定是 8 的倍數。',
        '要讓兩種數量一樣多，這個數量必須同時是 6 的倍數，也是 8 的倍數。',
        '6 的倍數是 6、12、18、24、30⋯；8 的倍數是 8、16、24、32⋯。',
        '兩邊都出現而且大於 0 的最小數是 24。',
        '這時鉛筆買 24 ÷ 6 = 4 盒，橡皮擦買 24 ÷ 8 = 3 盒，數量都是 24 個。',
      ],
      'zh-Hans' => [
        '只能整盒买，所以铅笔的数量一定是 6 的倍数，橡皮擦的数量一定是 8 的倍数。',
        '要让两种数量一样多，这个数量必须同时是 6 的倍数，也是 8 的倍数。',
        '6 的倍数是 6、12、18、24、30⋯；8 的倍数是 8、16、24、32⋯。',
        '两边都出现而且大于 0 的最小数是 24。',
        '这时铅笔买 24 ÷ 6 = 4 盒，橡皮擦买 24 ÷ 8 = 3 盒，数量都是 24 个。',
      ],
      'en' => [
        'Since only whole boxes can be bought, the number of pencils must be a multiple of 6 and the number of erasers a multiple of 8.',
        'For the two amounts to be equal, that amount must be a multiple of 6 and of 8 at the same time.',
        'The multiples of 6 are 6, 12, 18, 24, 30, … and the multiples of 8 are 8, 16, 24, 32, ….',
        'The smallest number greater than 0 appearing in both lists is 24.',
        'That means 24 ÷ 6 = 4 boxes of pencils and 24 ÷ 8 = 3 boxes of erasers, giving 24 of each.',
      ],
      'ja' => [
        '箱単位でしか買えないので、えんぴつの数は 6 の倍数、消しゴムの数は 8 の倍数になります。',
        '2 つの数を同じにするには、その数が 6 の倍数でも 8 の倍数でもなければなりません。',
        '6 の倍数は 6、12、18、24、30⋯、8 の倍数は 8、16、24、32⋯ です。',
        '両方に現れる 0 より大きい最小の数は 24 です。',
        'このときえんぴつは 24 ÷ 6 = 4 箱、消しゴムは 24 ÷ 8 = 3 箱で、どちらも 24 個です。',
      ],
    },
    value: '24', max_digits: 2,
    notes: 'Original composition in the Math Kangaroo grade 1-2 common-multiple style; the box sizes force each total onto its own multiple list and the answer is the first shared entry. Not a reproduction of any past paper.',
  ),
  int_q(
    subtopic: 'digit_arrangement_sum',
    prompt: {
      'zh-Hant' => '用 1、2、3 這三個數字各一次，可以排出 6 個不同的三位數。把這 6 個三位數全部加起來，總和是多少？',
      'zh-Hans' => '用 1、2、3 这三个数字各一次，可以排出 6 个不同的三位数。把这 6 个三位数全部加起来，总和是多少？',
      'en' => 'Using the digits 1, 2 and 3 each once, six different three-digit numbers can be formed. What is the total when all six are added together?',
      'ja' => '1、2、3 の 3 つの数字を 1 回ずつ使うと、ちがう 3 けたの数が 6 個できます。この 6 個をすべてたすと合計はいくつですか。',
    },
    answer: { 'zh-Hant' => '答案是 1332。', 'zh-Hans' => '答案是 1332。',
              'en' => 'The answer is 1332.', 'ja' => '答えは 1332 です。' },
    steps: {
      'zh-Hant' => [
        '不要一個一個加，先想每個數字在每個位置各出現幾次。',
        '一共有 6 個數，把 1 放在百位的有 2 個（123 和 132），把 2 放在百位的也有 2 個，把 3 放在百位的也有 2 個。',
        '十位和個位也是一樣，每個數字各出現 2 次。',
        '所以百位上的數字總和是 2 × (1 + 2 + 3) = 12，十位和個位也都是 12。',
        '總和就是 12 × 100 + 12 × 10 + 12 × 1 = 1200 + 120 + 12 = 1332。',
      ],
      'zh-Hans' => [
        '不要一个一个加，先想每个数字在每个位置各出现几次。',
        '一共有 6 个数，把 1 放在百位的有 2 个（123 和 132），把 2 放在百位的也有 2 个，把 3 放在百位的也有 2 个。',
        '十位和个位也是一样，每个数字各出现 2 次。',
        '所以百位上的数字总和是 2 × (1 + 2 + 3) = 12，十位和个位也都是 12。',
        '总和就是 12 × 100 + 12 × 10 + 12 × 1 = 1200 + 120 + 12 = 1332。',
      ],
      'en' => [
        'Rather than adding one number at a time, work out how often each digit appears in each place.',
        'There are 6 numbers in all; 1 appears in the hundreds place in 2 of them (123 and 132), and the same is true for 2 and for 3.',
        'The tens and units places behave in the same way, with each digit appearing twice.',
        'So the digits in the hundreds place total 2 × (1 + 2 + 3) = 12, and the same holds for the tens and the units.',
        'The grand total is therefore 12 × 100 + 12 × 10 + 12 × 1 = 1200 + 120 + 12 = 1332.',
      ],
      'ja' => [
        '1 つずつたすのではなく、各数字が各位に何回現れるかを考えます。',
        '数は全部で 6 個あり、百の位が 1 のものは 123 と 132 の 2 個、2 のものも 2 個、3 のものも 2 個です。',
        '十の位と一の位も同じで、どの数字も 2 回ずつ現れます。',
        'したがって百の位の数字の合計は 2 × (1 + 2 + 3) = 12 で、十の位も一の位も 12 です。',
        '合計は 12 × 100 + 12 × 10 + 12 × 1 = 1200 + 120 + 12 = 1332 です。',
      ],
    },
    value: '1332', max_digits: 4,
    notes: 'Original composition in the Math Kangaroo grade 1-2 place-value style; counting how often each digit lands in each column avoids adding six numbers one by one. Not a reproduction of any past paper.',
  ),
  int_q(
    subtopic: 'money_savings',
    prompt: {
      'zh-Hant' => '小安每個星期存 15 元，現在已經存了 45 元。他想買一個 120 元的玩具。如果他每星期都存 15 元，還要再存幾個星期才夠買？',
      'zh-Hans' => '小安每个星期存 15 元，现在已经存了 45 元。他想买一个 120 元的玩具。如果他每星期都存 15 元，还要再存几个星期才够买？',
      'en' => 'An saves 15 dollars every week and has already saved 45 dollars. A toy costs 120 dollars. Saving 15 dollars each week from now on, how many more weeks are needed before there is enough?',
      'ja' => 'アンさんは毎週 15 円ずつ貯金していて、いまは 45 円たまっています。120 円のおもちゃを買いたいと思っています。これからも毎週 15 円ずつ貯めるとき、あと何週間で買えるようになりますか。',
    },
    answer: { 'zh-Hant' => '答案是 5 個星期。', 'zh-Hans' => '答案是 5 个星期。',
              'en' => 'The answer is 5 weeks.', 'ja' => '答えは 5 週間です。' },
    steps: {
      'zh-Hant' => [
        '先算還差多少錢：玩具 120 元，已經存了 45 元，還差 120 − 45 = 75 元。',
        '注意不能直接用 120 除以 15，因為已經存的 45 元不必再存一次。',
        '每星期存 15 元，要存滿 75 元需要 75 ÷ 15 = 5 個星期。',
        '所以還要再存 5 個星期。',
      ],
      'zh-Hans' => [
        '先算还差多少钱：玩具 120 元，已经存了 45 元，还差 120 − 45 = 75 元。',
        '注意不能直接用 120 除以 15，因为已经存的 45 元不必再存一次。',
        '每星期存 15 元，要存满 75 元需要 75 ÷ 15 = 5 个星期。',
        '所以还要再存 5 个星期。',
      ],
      'en' => [
        'First find how much is still missing: the toy costs 120 and 45 is already saved, so 120 − 45 = 75 dollars are still needed.',
        'Note that dividing 120 by 15 directly would be wrong, because the 45 already saved does not have to be saved again.',
        'Saving 15 dollars a week, reaching 75 dollars takes 75 ÷ 15 = 5 weeks.',
        'So 5 more weeks of saving are needed.',
      ],
      'ja' => [
        'まず不足額を求めます。おもちゃは 120 円で 45 円たまっているので、あと 120 − 45 = 75 円必要です。',
        '120 を 15 でわってはいけません。すでに貯めた 45 円をもう一度貯める必要はないからです。',
        '毎週 15 円ずつなので、75 円たまるまでに 75 ÷ 15 = 5 週間かかります。',
        'したがってあと 5 週間です。',
      ],
    },
    value: '5', max_digits: 1,
    notes: 'Original composition in the Math Kangaroo grade 1-2 saving style; the trap is dividing the full price instead of the remaining amount. Not a reproduction of any past paper.',
  ),
].freeze

pack = load_json(PATH)
serial = pack['questions'].map { |q| q['id'].split('_').last.to_i }.max + 1
ids = pack['questions'].map { |q| q['id'] }.to_set
ordered = QUESTIONS.each_with_index.map do |q, i|
  id = format('arithmetic_%s_foundation_%03d', GRADE, serial + i)
  raise "duplicate id #{id}" if ids.include?(id)

  { 'id' => id }.merge(q)
end
pack['questions'].concat(ordered)
save_json(PATH, pack)
puts "#{File.basename(PATH)} -> #{pack['questions'].length}"

manifest = load_json(MANIFEST_PATH)
manifest['packs'].each do |p|
  p['questionCount'] = pack['questions'].length if File.join(ROOT, p['path']) == PATH
end
save_json(MANIFEST_PATH, manifest)
