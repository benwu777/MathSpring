#!/usr/bin/env ruby
# frozen_string_literal: true

# grade1 第二輪擴充（2026-08-28）之二：logic 6 題、arithmetic 6 題
require 'json'
require 'set'

ROOT = File.expand_path('..', __dir__)
GRADE = 'grade1'
PATHS = {
  'logic' => File.join(ROOT, "assets/questions/logic/#{GRADE}_foundation.logic.v1.json"),
  'arithmetic' => File.join(ROOT, "assets/questions/arithmetic/#{GRADE}_foundation.arithmetic.v1.json"),
}.freeze
MANIFEST_PATH = File.join(ROOT, 'assets/questions/manifest.json')

def load_json(path) = JSON.parse(File.read(path))
def save_json(path, data) = File.write(path, JSON.pretty_generate(data) + "\n")

def base(topic:, subtopic:, prompt:, answer:, steps:, reference:, notes:)
  { 'reviewStatus' => 'ok', 'topic' => topic, 'subtopic' => subtopic,
    'difficulty' => 'foundation', 'levelStage' => GRADE, 'challengeTier' => 'foundation',
    'prompt' => prompt, 'answer' => answer, 'solutionSteps' => steps,
    'figure' => { 'type' => 'custom', 'kind' => 'none', 'params' => {} },
    'source' => { 'type' => 'rewritten_olympiad_style', 'name' => 'MathSpring Editorial',
                  'reference' => reference, 'notes' => notes } }
end

def int_q(value:, max_digits:, **rest)
  base(**rest).merge('answerMode' => 'integer_input',
                     'correctAnswer' => { 'type' => 'integer', 'value' => value },
                     'inputConstraints' => { 'allowNegative' => false, 'maxDigits' => max_digits })
end

def mc_q(options:, correct:, **rest)
  base(**rest).merge('answerMode' => 'multiple_choice', 'options' => options,
                     'correctAnswer' => { 'type' => 'choice', 'value' => correct })
end

QUESTIONS = {
  'logic' => [
    mc_q(
      topic: 'logic', subtopic: 'calendar_reasoning',
      prompt: {
        'zh-Hant' => '今天是星期三。從今天算起，再過 10 天會是星期幾？（今天不算在這 10 天裡。）',
        'zh-Hans' => '今天是星期三。从今天算起，再过 10 天会是星期几？（今天不算在这 10 天里。）',
        'en' => 'Today is Wednesday. What day of the week will it be 10 days from today? (Today itself is not one of the 10 days.)',
        'ja' => '今日は水曜日です。今日から 10 日後は何曜日ですか。（今日はその 10 日にふくめません。）',
      },
      answer: { 'zh-Hant' => '是星期六。', 'zh-Hans' => '是星期六。',
                'en' => 'It will be Saturday.', 'ja' => '土曜日です。' },
      steps: {
        'zh-Hant' => [
          '星期每 7 天重複一次，所以過了 7 天之後又會回到星期三。',
          '10 天可以拆成 7 天加 3 天。',
          '先過 7 天回到星期三，再往後數 3 天：星期四、星期五、星期六。',
          '所以 10 天後是星期六。',
        ],
        'zh-Hans' => [
          '星期每 7 天重复一次，所以过了 7 天之后又会回到星期三。',
          '10 天可以拆成 7 天加 3 天。',
          '先过 7 天回到星期三，再往后数 3 天：星期四、星期五、星期六。',
          '所以 10 天后是星期六。',
        ],
        'en' => [
          'The days of the week repeat every 7 days, so after 7 days it is Wednesday again.',
          'Ten days can be split into 7 days plus 3 days.',
          'The first 7 days bring us back to Wednesday, and counting on 3 more gives Thursday, Friday, Saturday.',
          'So 10 days from today is Saturday.',
        ],
        'ja' => [
          '曜日は 7 日ごとにくり返すので、7 日たつとまた水曜日になります。',
          '10 日は 7 日と 3 日に分けられます。',
          'はじめの 7 日で水曜日にもどり、そこから 3 日数えると木曜日、金曜日、土曜日です。',
          'したがって 10 日後は土曜日です。',
        ],
      },
      options: {
        'A' => { 'zh-Hant' => '星期四', 'zh-Hans' => '星期四', 'en' => 'Thursday', 'ja' => '木曜日' },
        'B' => { 'zh-Hant' => '星期五', 'zh-Hans' => '星期五', 'en' => 'Friday', 'ja' => '金曜日' },
        'C' => { 'zh-Hant' => '星期六', 'zh-Hans' => '星期六', 'en' => 'Saturday', 'ja' => '土曜日' },
        'D' => { 'zh-Hant' => '星期日', 'zh-Hans' => '星期日', 'en' => 'Sunday', 'ja' => '日曜日' },
      },
      correct: 'C',
      reference: 'logic-grade1-foundation',
      notes: 'Original composition in the Math Kangaroo grade 1-2 calendar style; the solver must strip off a whole week before counting the remainder rather than counting all 10 days one by one. Not a reproduction of any past paper.',
    ),
    mc_q(
      topic: 'logic', subtopic: 'column_row',
      prompt: {
        'zh-Hant' => '四個座位排成 2 排 2 列：前排有左、右兩個位子，後排也有左、右兩個位子。小安坐在前排。小美坐在小安的正後方。小樂坐在小美的右邊。請問小華坐在哪個位子？',
        'zh-Hans' => '四个座位排成 2 排 2 列：前排有左、右两个位子，后排也有左、右两个位子。小安坐在前排。小美坐在小安的正后方。小乐坐在小美的右边。请问小华坐在哪个位子？',
        'en' => 'Four seats form 2 rows of 2: the front row has a left and a right seat, and so does the back row. An sits in the front row. Mei sits directly behind An. Le sits to the right of Mei. Which seat does Hua take?',
        'ja' => '座席が 2 行 2 列に並んでいます。前列に左と右、後列にも左と右の席があります。アンさんは前列にすわります。ミイさんはアンさんの真後ろです。レさんはミイさんの右どなりです。ホアさんはどの席にすわりますか。',
      },
      answer: { 'zh-Hant' => '小華坐在前排右邊。', 'zh-Hans' => '小华坐在前排右边。',
                'en' => 'Hua sits in the front-row right seat.', 'ja' => 'ホアさんは前列の右の席です。' },
      steps: {
        'zh-Hant' => [
          '小樂坐在小美的右邊，表示小美不可能坐在最右邊的位子，否則右邊就沒有位子了。',
          '小美坐在小安的正後方，所以小美在後排。後排能讓右邊還有位子的，只有後排左邊。',
          '因此小美坐後排左邊，小樂坐後排右邊。',
          '小美在小安正後方，所以小安坐前排左邊。',
          '剩下的位子只有前排右邊，所以小華坐在前排右邊。',
        ],
        'zh-Hans' => [
          '小乐坐在小美的右边，表示小美不可能坐在最右边的位子，否则右边就没有位子了。',
          '小美坐在小安的正后方，所以小美在后排。后排能让右边还有位子的，只有后排左边。',
          '因此小美坐后排左边，小乐坐后排右边。',
          '小美在小安正后方，所以小安坐前排左边。',
          '剩下的位子只有前排右边，所以小华坐在前排右边。',
        ],
        'en' => [
          'Le sits to the right of Mei, so Mei cannot be in a rightmost seat, or there would be no seat to her right.',
          'Mei sits directly behind An, so Mei is in the back row, and the only back-row seat with a seat to its right is the back-left one.',
          'So Mei takes the back-left seat and Le the back-right seat.',
          'Since Mei is directly behind An, An sits in the front-left seat.',
          'The only seat left is the front-right one, so Hua sits there.',
        ],
        'ja' => [
          'レさんはミイさんの右どなりなので、ミイさんがいちばん右の席にすわることはできません。右に席がなくなるからです。',
          'ミイさんはアンさんの真後ろなので後列におり、右に席が残る後列の席は後列左だけです。',
          'よってミイさんは後列左、レさんは後列右です。',
          'ミイさんがアンさんの真後ろなので、アンさんは前列左です。',
          '残る席は前列右だけなので、ホアさんは前列右にすわります。',
        ],
      },
      options: {
        'A' => { 'zh-Hant' => '前排左邊', 'zh-Hans' => '前排左边', 'en' => 'Front-row left', 'ja' => '前列の左' },
        'B' => { 'zh-Hant' => '前排右邊', 'zh-Hans' => '前排右边', 'en' => 'Front-row right', 'ja' => '前列の右' },
        'C' => { 'zh-Hant' => '後排左邊', 'zh-Hans' => '后排左边', 'en' => 'Back-row left', 'ja' => '後列の左' },
        'D' => { 'zh-Hant' => '後排右邊', 'zh-Hans' => '后排右边', 'en' => 'Back-row right', 'ja' => '後列の右' },
      },
      correct: 'B',
      reference: 'logic-grade1-foundation',
      notes: 'Original composition in the Math Kangaroo grade 1-2 seating style; unlike the existing one-dimensional position items, this one needs both a row and a column to be pinned down, and the right-neighbour condition is what fixes the column. Not a reproduction of any past paper.',
    ),
    int_q(
      topic: 'logic', subtopic: 'minimal_case',
      prompt: {
        'zh-Hant' => '抽屜裡有很多隻襪子，只有紅色和藍色兩種，兩種顏色都很多。閉著眼睛從抽屜裡拿襪子，最少要拿幾隻，才能保證一定可以配出 2 雙同色的襪子？（一雙是指兩隻顏色相同的襪子，兩雙不一定要同一個顏色。）',
        'zh-Hans' => '抽屉里有很多只袜子，只有红色和蓝色两种，两种颜色都很多。闭着眼睛从抽屉里拿袜子，最少要拿几只，才能保证一定可以配出 2 双同色的袜子？（一双是指两只颜色相同的袜子，两双不一定要同一个颜色。）',
        'en' => 'A drawer holds many socks in just two colours, red and blue, with plenty of each. Socks are taken out with the eyes closed. At least how many must be taken to be sure of making 2 matching pairs? (A pair means two socks of the same colour; the two pairs need not be the same colour.)',
        'ja' => '引き出しには赤と青の 2 色の靴下がたくさん入っています。目をつぶって靴下を取り出すとき、同じ色どうしの組を 2 組必ず作れるようにするには、少なくとも何足取ればよいですか。（1 組は同じ色の靴下 2 本で、2 組の色は同じでなくてかまいません。）',
      },
      answer: { 'zh-Hant' => '答案是 5 隻。', 'zh-Hans' => '答案是 5 只。',
                'en' => 'The answer is 5 socks.', 'ja' => '答えは 5 本です。' },
      steps: {
        'zh-Hant' => [
          '要「保證」，就要看最壞的情況，也就是最不容易配成雙的拿法。',
          '拿 4 隻時，最壞的情況是紅 3 隻、藍 1 隻：紅色只能配出 1 雙（剩 1 隻落單），藍色 1 隻配不成雙，只有 1 雙，不夠。',
          '所以 4 隻不能保證。',
          '拿 5 隻時，不論怎麼分成紅、藍：紅 1 藍 4 得 0 + 2 雙、紅 2 藍 3 得 1 + 1 雙、紅 3 藍 2 得 1 + 1 雙、紅 4 藍 1 得 2 + 0 雙、紅 5 藍 0 得 2 雙。',
          '每一種情況都至少有 2 雙，所以最少要拿 5 隻。',
        ],
        'zh-Hans' => [
          '要「保证」，就要看最坏的情况，也就是最不容易配成双的拿法。',
          '拿 4 只时，最坏的情况是红 3 只、蓝 1 只：红色只能配出 1 双（剩 1 只落单），蓝色 1 只配不成双，只有 1 双，不够。',
          '所以 4 只不能保证。',
          '拿 5 只时，不论怎么分成红、蓝：红 1 蓝 4 得 0 + 2 双、红 2 蓝 3 得 1 + 1 双、红 3 蓝 2 得 1 + 1 双、红 4 蓝 1 得 2 + 0 双、红 5 蓝 0 得 2 双。',
          '每一种情况都至少有 2 双，所以最少要拿 5 只。',
        ],
        'en' => [
          'To be sure, look at the worst case, that is the draw that makes pairing hardest.',
          'With 4 socks the worst case is 3 red and 1 blue: the reds make only 1 pair with one left over, and a single blue makes none, so there is just 1 pair, which is not enough.',
          'So 4 socks cannot guarantee it.',
          'With 5 socks, however they split: 1 red and 4 blue give 0 + 2 pairs, 2 red and 3 blue give 1 + 1, 3 red and 2 blue give 1 + 1, 4 red and 1 blue give 2 + 0, and 5 red give 2.',
          'Every case gives at least 2 pairs, so at least 5 socks must be taken.',
        ],
        'ja' => [
          '「必ず」といえるようにするには、最も組を作りにくい最悪の場合を考えます。',
          '4 本のときの最悪は赤 3 本・青 1 本で、赤は 1 組しかできず 1 本あまり、青 1 本では組ができないので合計 1 組にしかならず足りません。',
          'したがって 4 本では保証できません。',
          '5 本のときは、赤 1 青 4 なら 0 + 2 組、赤 2 青 3 なら 1 + 1 組、赤 3 青 2 なら 1 + 1 組、赤 4 青 1 なら 2 + 0 組、赤 5 なら 2 組です。',
          'どの場合も 2 組以上できるので、少なくとも 5 本取ればよいことになります。',
        ],
      },
      value: '5', max_digits: 1,
      reference: 'logic-grade1-foundation',
      notes: 'Original composition in the Math Kangaroo grade 1-2 worst-case style; asking for two pairs rather than one matching pair means the worst case is an uneven split, not simply one of each colour. Not a reproduction of any past paper.',
    ),
    int_q(
      topic: 'logic', subtopic: 'balance_reasoning',
      prompt: {
        'zh-Hant' => '天平的左邊放 2 個一樣重的方塊，右邊放 6 顆一樣重的球，天平剛好平衡。如果左邊改成放 5 個同樣的方塊，右邊要放幾顆同樣的球，天平才會平衡？',
        'zh-Hans' => '天平的左边放 2 个一样重的方块，右边放 6 颗一样重的球，天平刚好平衡。如果左边改成放 5 个同样的方块，右边要放几颗同样的球，天平才会平衡？',
        'en' => 'Two identical blocks are placed on the left pan of a balance and 6 identical balls on the right pan, and the balance is level. If 5 of the same blocks are put on the left instead, how many of the same balls are needed on the right to balance it?',
        'ja' => 'てんびんの左に同じ重さの積み木を 2 個、右に同じ重さのボールを 6 個のせると、ちょうどつり合いました。左に同じ積み木を 5 個のせるとき、つり合わせるには右に同じボールを何個のせればよいですか。',
      },
      answer: { 'zh-Hant' => '答案是 15 顆。', 'zh-Hans' => '答案是 15 颗。',
                'en' => 'The answer is 15 balls.', 'ja' => '答えは 15 個です。' },
      steps: {
        'zh-Hant' => [
          '2 個方塊和 6 顆球一樣重，把兩邊都平分成 2 份。',
          '左邊每份是 1 個方塊，右邊每份是 6 ÷ 2 = 3 顆球，所以 1 個方塊和 3 顆球一樣重。',
          '5 個方塊就相當於 5 份，每份 3 顆球。',
          '所以要放 3 × 5 = 15 顆球才會平衡。',
        ],
        'zh-Hans' => [
          '2 个方块和 6 颗球一样重，把两边都平分成 2 份。',
          '左边每份是 1 个方块，右边每份是 6 ÷ 2 = 3 颗球，所以 1 个方块和 3 颗球一样重。',
          '5 个方块就相当于 5 份，每份 3 颗球。',
          '所以要放 3 × 5 = 15 颗球才会平衡。',
        ],
        'en' => [
          'Two blocks weigh the same as 6 balls, so split both sides into 2 equal parts.',
          'Each part on the left is 1 block and each part on the right is 6 ÷ 2 = 3 balls, so 1 block weighs the same as 3 balls.',
          'Five blocks are therefore 5 such parts, each worth 3 balls.',
          'So 3 × 5 = 15 balls are needed to balance them.',
        ],
        'ja' => [
          '積み木 2 個とボール 6 個が同じ重さなので、両側を 2 等分します。',
          '左は 1 つ分が積み木 1 個、右は 1 つ分がボール 6 ÷ 2 = 3 個なので、積み木 1 個とボール 3 個が同じ重さです。',
          '積み木 5 個は 5 つ分にあたり、1 つ分がボール 3 個です。',
          'したがって 3 × 5 = 15 個のボールをのせればつり合います。',
        ],
      },
      value: '15', max_digits: 2,
      reference: 'logic-grade1-foundation',
      notes: 'Original composition in the Math Kangaroo grade 1-2 balance style; a single ratio is scaled up here, which differs from the chained exchange item in the grade1 arithmetic pack where two different exchange rates are linked. Not a reproduction of any past paper.',
    ),
    int_q(
      topic: 'logic', subtopic: 'set_filtering',
      prompt: {
        'zh-Hant' => '在 1 到 20 的整數中，找出同時符合以下三個條件的數：是雙數、比 10 大、而且不是 5 的倍數。這樣的數一共有幾個？',
        'zh-Hans' => '在 1 到 20 的整数中，找出同时符合以下三个条件的数：是双数、比 10 大、而且不是 5 的倍数。这样的数一共有几个？',
        'en' => 'Among the integers from 1 to 20, find the numbers that satisfy all three conditions: even, greater than 10, and not a multiple of 5. How many such numbers are there?',
        'ja' => '1 から 20 までの整数のうち、「偶数である」「10 より大きい」「5 の倍数でない」の 3 つをすべて満たす数は何個ありますか。',
      },
      answer: { 'zh-Hant' => '答案是 4 個。', 'zh-Hans' => '答案是 4 个。',
                'en' => 'The answer is 4 numbers.', 'ja' => '答えは 4 個です。' },
      steps: {
        'zh-Hant' => [
          '先用「比 10 大」篩一次，剩下 11 到 20 這 10 個數。',
          '再用「是雙數」篩一次，剩下 12、14、16、18、20 這 5 個數。',
          '最後用「不是 5 的倍數」篩一次，20 是 5 的倍數要去掉。',
          '剩下 12、14、16、18，一共 4 個數。',
        ],
        'zh-Hans' => [
          '先用「比 10 大」筛一次，剩下 11 到 20 这 10 个数。',
          '再用「是双数」筛一次，剩下 12、14、16、18、20 这 5 个数。',
          '最后用「不是 5 的倍数」筛一次，20 是 5 的倍数要去掉。',
          '剩下 12、14、16、18，一共 4 个数。',
        ],
        'en' => [
          'Apply "greater than 10" first, leaving the ten numbers 11 to 20.',
          'Then apply "even", leaving 12, 14, 16, 18 and 20, which is five numbers.',
          'Finally apply "not a multiple of 5", which removes 20.',
          'That leaves 12, 14, 16 and 18, so there are 4 such numbers.',
        ],
        'ja' => [
          'まず「10 より大きい」でしぼると、11 から 20 までの 10 個が残ります。',
          '次に「偶数である」でしぼると、12、14、16、18、20 の 5 個になります。',
          '最後に「5 の倍数でない」でしぼると、20 が取り除かれます。',
          '残るのは 12、14、16、18 の 4 個です。',
        ],
      },
      value: '4', max_digits: 1,
      reference: 'logic-grade1-foundation',
      notes: 'Original composition in the Math Kangaroo grade 1-2 filtering style; three conditions are applied in turn and the last one removes exactly one survivor, which is the trap. Not a reproduction of any past paper.',
    ),
    int_q(
      topic: 'logic', subtopic: 'two_step_elimination',
      prompt: {
        'zh-Hant' => '甲、乙、丙、丁四個人排成一列，位置是第 1 到第 4。已知：丙排第 4；甲不排第 1，也不排第 4；乙排在甲的前面；丁排在甲的後面。請問丁排第幾？',
        'zh-Hans' => '甲、乙、丙、丁四个人排成一列，位置是第 1 到第 4。已知：丙排第 4；甲不排第 1，也不排第 4；乙排在甲的前面；丁排在甲的后面。请问丁排第几？',
        'en' => 'Four people A, B, C and D stand in a line in positions 1 to 4. C is in position 4; A is neither first nor fourth; B stands ahead of A; D stands behind A. In which position does D stand?',
        'ja' => '甲、乙、丙、丁の 4 人が 1 番目から 4 番目まで一列に並びます。丙は 4 番目、甲は 1 番目でも 4 番目でもなく、乙は甲より前、丁は甲より後ろです。丁は何番目ですか。',
      },
      answer: { 'zh-Hant' => '答案是第 3 個。', 'zh-Hans' => '答案是第 3 个。',
                'en' => 'The answer is position 3.', 'ja' => '答えは 3 番目です。' },
      steps: {
        'zh-Hant' => [
          '丙排第 4，所以甲、乙、丁只能排在第 1、2、3。',
          '甲不排第 1，所以甲只能排第 2 或第 3。',
          '丁要排在甲後面，如果甲排第 3，丁就必須排第 4，但第 4 是丙，不行。',
          '所以甲排第 2。乙要排在甲前面，只能排第 1。',
          '剩下第 3 給丁，所以丁排第 3。',
        ],
        'zh-Hans' => [
          '丙排第 4，所以甲、乙、丁只能排在第 1、2、3。',
          '甲不排第 1，所以甲只能排第 2 或第 3。',
          '丁要排在甲后面，如果甲排第 3，丁就必须排第 4，但第 4 是丙，不行。',
          '所以甲排第 2。乙要排在甲前面，只能排第 1。',
          '剩下第 3 给丁，所以丁排第 3。',
        ],
        'en' => [
          'C is fourth, so A, B and D occupy positions 1, 2 and 3.',
          'A is not first, so A is either second or third.',
          'D must stand behind A, and if A were third then D would have to be fourth, which is C, so that is impossible.',
          'Hence A is second, and B, who must be ahead of A, is first.',
          'Position 3 is left for D, so D stands third.',
        ],
        'ja' => [
          '丙が 4 番目なので、甲・乙・丁は 1、2、3 番目に並びます。',
          '甲は 1 番目ではないので、甲は 2 番目か 3 番目です。',
          '丁は甲より後ろでなければならず、甲が 3 番目だと丁は 4 番目になりますが、そこは丙なので不可能です。',
          'よって甲は 2 番目、甲より前の乙は 1 番目に決まります。',
          '残る 3 番目が丁なので、丁は 3 番目です。',
        ],
      },
      value: '3', max_digits: 1,
      reference: 'logic-grade1-foundation',
      notes: 'Original composition in the Math Kangaroo grade 1-2 line-up style; one candidate position for A is eliminated by a contradiction with an already fixed seat, which is a step beyond the existing single-round elimination items. Not a reproduction of any past paper.',
    ),
  ],
  'arithmetic' => [
    int_q(
      topic: 'arithmetic', subtopic: 'piece_value',
      prompt: {
        'zh-Hant' => '小安要付 18 元，他有很多 1 元、5 元和 10 元的硬幣。如果要用最少的硬幣數量剛好付出 18 元，最少要用幾個硬幣？',
        'zh-Hans' => '小安要付 18 元，他有很多 1 元、5 元和 10 元的硬币。如果要用最少的硬币数量刚好付出 18 元，最少要用几个硬币？',
        'en' => 'An needs to pay 18 dollars and has plenty of 1-dollar, 5-dollar and 10-dollar coins. Using as few coins as possible to make exactly 18 dollars, how many coins are needed?',
        'ja' => 'アンさんは 18 円をちょうど払います。1 円玉、5 円玉、10 円玉をたくさん持っています。できるだけ少ない枚数でちょうど 18 円を払うとき、硬貨は何枚必要ですか。',
      },
      answer: { 'zh-Hant' => '答案是 5 個。', 'zh-Hans' => '答案是 5 个。',
                'en' => 'The answer is 5 coins.', 'ja' => '答えは 5 枚です。' },
      steps: {
        'zh-Hant' => [
          '要讓硬幣個數最少，就先盡量用面額大的硬幣。',
          '先用 10 元硬幣：用 1 個就付了 10 元，還剩 18 − 10 = 8 元。用 2 個會變成 20 元，超過了。',
          '再用 5 元硬幣付剩下的 8 元：用 1 個付 5 元，還剩 8 − 5 = 3 元。用 2 個會變成 10 元，超過 8 元。',
          '最後剩下的 3 元只能用 1 元硬幣，需要 3 個。',
          '所以總共是 1 + 1 + 3 = 5 個硬幣。',
        ],
        'zh-Hans' => [
          '要让硬币个数最少，就先尽量用面额大的硬币。',
          '先用 10 元硬币：用 1 个就付了 10 元，还剩 18 − 10 = 8 元。用 2 个会变成 20 元，超过了。',
          '再用 5 元硬币付剩下的 8 元：用 1 个付 5 元，还剩 8 − 5 = 3 元。用 2 个会变成 10 元，超过 8 元。',
          '最后剩下的 3 元只能用 1 元硬币，需要 3 个。',
          '所以总共是 1 + 1 + 3 = 5 个硬币。',
        ],
        'en' => [
          'To use as few coins as possible, use the largest coins first.',
          'Start with 10-dollar coins: one of them pays 10, leaving 18 − 10 = 8, while two would make 20, which is too much.',
          'Next use 5-dollar coins on the remaining 8: one pays 5, leaving 8 − 5 = 3, while two would make 10, more than 8.',
          'The remaining 3 dollars can only be paid with 1-dollar coins, which takes 3 of them.',
          'So the total is 1 + 1 + 3 = 5 coins.',
        ],
        'ja' => [
          '枚数を最も少なくするには、大きい額の硬貨から使います。',
          'まず 10 円玉です。1 枚で 10 円を払うと残りは 18 − 10 = 8 円で、2 枚だと 20 円になり超えてしまいます。',
          '次に残り 8 円に 5 円玉を使います。1 枚で 5 円払うと残りは 8 − 5 = 3 円、2 枚だと 10 円で 8 円を超えます。',
          '最後の 3 円は 1 円玉でしか払えず、3 枚必要です。',
          'したがって合計 1 + 1 + 3 = 5 枚です。',
        ],
      },
      value: '5', max_digits: 1,
      reference: 'arithmetic-grade1-foundation',
      notes: 'Original composition in the Math Kangaroo grade 1-2 coin style; each denomination is capped by the remaining amount, so the greedy choice has to be justified at every step. Not a reproduction of any past paper.',
    ),
    int_q(
      topic: 'arithmetic', subtopic: 'ceiling_division',
      prompt: {
        'zh-Hant' => '老師要把 26 顆糖果裝進袋子裡，每個袋子最多只能裝 4 顆。如果所有糖果都要裝進袋子，最少需要幾個袋子？',
        'zh-Hans' => '老师要把 26 颗糖果装进袋子里，每个袋子最多只能装 4 颗。如果所有糖果都要装进袋子，最少需要几个袋子？',
        'en' => 'A teacher packs 26 sweets into bags, and each bag holds at most 4 sweets. If every sweet must go into a bag, what is the smallest number of bags needed?',
        'ja' => '先生はあめ 26 個をふくろに入れます。1 つのふくろには最大 4 個までしか入りません。すべてのあめをふくろに入れるには、ふくろは最も少なくて何枚必要ですか。',
      },
      answer: { 'zh-Hant' => '答案是 7 個。', 'zh-Hans' => '答案是 7 个。',
                'en' => 'The answer is 7 bags.', 'ja' => '答えは 7 枚です。' },
      steps: {
        'zh-Hant' => [
          '每個袋子最多裝 4 顆，先看 26 顆裡面有幾個 4 顆。',
          '26 ÷ 4 = 6 餘 2，所以裝滿 6 個袋子後，還剩下 2 顆糖果。',
          '剩下的 2 顆也一定要裝起來，不能留在外面，所以還需要多 1 個袋子。',
          '這最後 1 個袋子只裝 2 顆，沒有裝滿也沒關係。',
          '所以最少需要 6 + 1 = 7 個袋子。',
        ],
        'zh-Hans' => [
          '每个袋子最多装 4 颗，先看 26 颗里面有几个 4 颗。',
          '26 ÷ 4 = 6 余 2，所以装满 6 个袋子后，还剩下 2 颗糖果。',
          '剩下的 2 颗也一定要装起来，不能留在外面，所以还需要多 1 个袋子。',
          '这最后 1 个袋子只装 2 颗，没有装满也没关系。',
          '所以最少需要 6 + 1 = 7 个袋子。',
        ],
        'en' => [
          'Each bag holds at most 4, so first see how many fours fit inside 26.',
          'Since 26 ÷ 4 = 6 remainder 2, filling 6 bags leaves 2 sweets over.',
          'Those 2 sweets must also be bagged and cannot be left out, so one more bag is needed.',
          'That last bag holds only 2 sweets, and it does not matter that it is not full.',
          'So the smallest number of bags is 6 + 1 = 7.',
        ],
        'ja' => [
          '1 つのふくろには最大 4 個なので、まず 26 個の中に 4 個がいくつ入るかを見ます。',
          '26 ÷ 4 = 6 あまり 2 なので、6 枚をいっぱいにすると 2 個あまります。',
          'あまった 2 個も必ずふくろに入れなければならないので、もう 1 枚必要です。',
          'その最後の 1 枚は 2 個しか入っていませんが、いっぱいでなくてもかまいません。',
          'したがって最も少なくて 6 + 1 = 7 枚必要です。',
        ],
      },
      value: '7', max_digits: 1,
      reference: 'arithmetic-grade1-foundation',
      notes: 'Original composition in the Math Kangaroo grade 1-2 packing style; the remainder forces an extra partly filled bag, which is the point rather than the division itself. Not a reproduction of any past paper.',
    ),
    int_q(
      topic: 'arithmetic', subtopic: 'symbol_equation',
      prompt: {
        'zh-Hant' => '△ 和 ○ 各代表一個數。已知 △ + △ + △ = 12，而且 △ + ○ = 7。請問 ○ 代表的數是多少？',
        'zh-Hans' => '△ 和 ○ 各代表一个数。已知 △ + △ + △ = 12，而且 △ + ○ = 7。请问 ○ 代表的数是多少？',
        'en' => 'The symbols △ and ○ each stand for a number. It is given that △ + △ + △ = 12 and that △ + ○ = 7. What number does ○ stand for?',
        'ja' => '△ と ○ はそれぞれある数を表します。△ + △ + △ = 12 で、△ + ○ = 7 です。○ が表す数はいくつですか。',
      },
      answer: { 'zh-Hant' => '答案是 3。', 'zh-Hans' => '答案是 3。', 'en' => 'The answer is 3.', 'ja' => '答えは 3 です。' },
      steps: {
        'zh-Hant' => [
          '第一個算式裡有 3 個一樣的 △ 相加，合起來是 12。',
          '所以每一個 △ 代表的數是 12 ÷ 3 = 4。',
          '把 △ = 4 代進第二個算式，得到 4 + ○ = 7。',
          '所以 ○ = 7 − 4 = 3。',
        ],
        'zh-Hans' => [
          '第一个算式里有 3 个一样的 △ 相加，合起来是 12。',
          '所以每一个 △ 代表的数是 12 ÷ 3 = 4。',
          '把 △ = 4 代进第二个算式，得到 4 + ○ = 7。',
          '所以 ○ = 7 − 4 = 3。',
        ],
        'en' => [
          'The first equation adds three identical △ symbols to make 12.',
          'So each △ stands for 12 ÷ 3 = 4.',
          'Putting △ = 4 into the second equation gives 4 + ○ = 7.',
          'Therefore ○ = 7 − 4 = 3.',
        ],
        'ja' => [
          '1 つ目の式では同じ △ を 3 つたして 12 になっています。',
          'したがって △ が表す数は 12 ÷ 3 = 4 です。',
          '△ = 4 を 2 つ目の式に入れると 4 + ○ = 7 となります。',
          'よって ○ = 7 − 4 = 3 です。',
        ],
      },
      value: '3', max_digits: 1,
      reference: 'arithmetic-grade1-foundation',
      notes: 'Original composition in the Math Kangaroo grade 1-2 symbol-equation style; one symbol must be solved from a repeated-addition equation before it can be substituted into the second. Not a reproduction of any past paper.',
    ),
    int_q(
      topic: 'arithmetic', subtopic: 'custom_operator',
      prompt: {
        'zh-Hant' => '定義一種新的算法「★」：a ★ b 表示先把 a 和 b 相加，再加上 a 和 b 的乘積。例如 1 ★ 2 = 1 + 2 + 1 × 2 = 5。請算出 2 ★ 3 是多少。',
        'zh-Hans' => '定义一种新的算法「★」：a ★ b 表示先把 a 和 b 相加，再加上 a 和 b 的乘积。例如 1 ★ 2 = 1 + 2 + 1 × 2 = 5。请算出 2 ★ 3 是多少。',
        'en' => 'A new operation ★ is defined: a ★ b means add a and b, then add the product of a and b. For example 1 ★ 2 = 1 + 2 + 1 × 2 = 5. Work out 2 ★ 3.',
        'ja' => '新しい計算「★」を次のように決めます。a ★ b は、a と b をたし、さらに a と b の積をたしたものです。たとえば 1 ★ 2 = 1 + 2 + 1 × 2 = 5 です。2 ★ 3 を求めなさい。',
      },
      answer: { 'zh-Hant' => '答案是 11。', 'zh-Hans' => '答案是 11。', 'en' => 'The answer is 11.', 'ja' => '答えは 11 です。' },
      steps: {
        'zh-Hant' => [
          '照定義，2 ★ 3 要先把兩個數相加，再加上兩個數的乘積。',
          '兩個數相加是 2 + 3 = 5。',
          '兩個數相乘是 2 × 3 = 6。',
          '把兩個結果加起來，得到 5 + 6 = 11，所以 2 ★ 3 = 11。',
        ],
        'zh-Hans' => [
          '照定义，2 ★ 3 要先把两个数相加，再加上两个数的乘积。',
          '两个数相加是 2 + 3 = 5。',
          '两个数相乘是 2 × 3 = 6。',
          '把两个结果加起来，得到 5 + 6 = 11，所以 2 ★ 3 = 11。',
        ],
        'en' => [
          'By the definition, 2 ★ 3 means adding the two numbers and then adding their product.',
          'The sum of the two numbers is 2 + 3 = 5.',
          'The product of the two numbers is 2 × 3 = 6.',
          'Adding the two results gives 5 + 6 = 11, so 2 ★ 3 = 11.',
        ],
        'ja' => [
          '定義より、2 ★ 3 は 2 数をたし、さらに 2 数の積をたします。',
          '2 数の和は 2 + 3 = 5 です。',
          '2 数の積は 2 × 3 = 6 です。',
          '2 つの結果をたすと 5 + 6 = 11 なので、2 ★ 3 = 11 です。',
        ],
      },
      value: '11', max_digits: 2,
      reference: 'arithmetic-grade1-foundation',
      notes: 'Original composition in the Math Kangaroo grade 1-2 defined-operation style; a worked example is supplied so the learner reads the rule rather than guessing it. Not a reproduction of any past paper.',
    ),
    int_q(
      topic: 'arithmetic', subtopic: 'consecutive_numbers',
      prompt: {
        'zh-Hant' => '有三個連續的整數（例如 5、6、7 就是三個連續的整數），它們加起來是 12。這三個數之中，最大的那個數是多少？',
        'zh-Hans' => '有三个连续的整数（例如 5、6、7 就是三个连续的整数），它们加起来是 12。这三个数之中，最大的那个数是多少？',
        'en' => 'Three consecutive whole numbers (for example 5, 6 and 7) add up to 12. What is the largest of the three numbers?',
        'ja' => '連続する 3 つの整数（たとえば 5、6、7）があり、その和は 12 です。この 3 つの数のうち、いちばん大きい数はいくつですか。',
      },
      answer: { 'zh-Hant' => '答案是 5。', 'zh-Hans' => '答案是 5。', 'en' => 'The answer is 5.', 'ja' => '答えは 5 です。' },
      steps: {
        'zh-Hant' => [
          '三個連續的整數，中間那個數比最小的多 1，最大的又比中間的多 1。',
          '如果把最大的減 1、最小的加 1，三個數就都變成中間那個數，而總和不會改變。',
          '所以總和等於中間那個數的 3 倍，中間的數是 12 ÷ 3 = 4。',
          '最大的數比中間的多 1，所以是 4 + 1 = 5。（這三個數是 3、4、5。）',
        ],
        'zh-Hans' => [
          '三个连续的整数，中间那个数比最小的多 1，最大的又比中间的多 1。',
          '如果把最大的减 1、最小的加 1，三个数就都变成中间那个数，而总和不会改变。',
          '所以总和等于中间那个数的 3 倍，中间的数是 12 ÷ 3 = 4。',
          '最大的数比中间的多 1，所以是 4 + 1 = 5。（这三个数是 3、4、5。）',
        ],
        'en' => [
          'Among three consecutive whole numbers, the middle one is 1 more than the smallest and the largest is 1 more than the middle.',
          'Taking 1 from the largest and giving 1 to the smallest turns all three into the middle number without changing the total.',
          'So the total is three times the middle number, and the middle number is 12 ÷ 3 = 4.',
          'The largest is 1 more than the middle, so it is 4 + 1 = 5. (The three numbers are 3, 4 and 5.)',
        ],
        'ja' => [
          '連続する 3 つの整数では、まん中の数は最小より 1 大きく、最大はまん中より 1 大きくなっています。',
          '最大から 1 を取ってを最小に渡すと 3 つともまん中の数になり、和は変わりません。',
          'したがって和はまん中の数の 3 倍で、まん中の数は 12 ÷ 3 = 4 です。',
          '最大はまん中より 1 大きいので 4 + 1 = 5 です。（3 つの数は 3、4、5 です。）',
        ],
      },
      value: '5', max_digits: 1,
      reference: 'arithmetic-grade1-foundation',
      notes: 'Original composition in the Math Kangaroo grade 1-2 consecutive-numbers style; the balancing argument that the sum is three times the middle term is the intended tool rather than trial and error. Not a reproduction of any past paper.',
    ),
    int_q(
      topic: 'arithmetic', subtopic: 'elapsed_time',
      prompt: {
        'zh-Hant' => '小安 8 點 50 分開始寫作業，9 點 35 分寫完。中間他有休息 10 分鐘沒有寫。小安實際寫作業的時間是幾分鐘？',
        'zh-Hans' => '小安 8 点 50 分开始写作业，9 点 35 分写完。中间他有休息 10 分钟没有写。小安实际写作业的时间是几分钟？',
        'en' => 'An starts homework at 8:50 and finishes at 9:35. In between there is a 10-minute break when no work is done. For how many minutes does An actually work?',
        'ja' => 'アンさんは 8 時 50 分に宿題を始め、9 時 35 分に終えました。とちゅうで 10 分間の休けいがあり、その間は宿題をしていません。アンさんが実際に宿題をしていたのは何分間ですか。',
      },
      answer: { 'zh-Hant' => '答案是 35 分鐘。', 'zh-Hans' => '答案是 35 分钟。',
                'en' => 'The answer is 35 minutes.', 'ja' => '答えは 35 分間です。' },
      steps: {
        'zh-Hant' => [
          '先算從開始到結束一共經過多久。',
          '從 8 點 50 分到 9 點整是 10 分鐘，從 9 點整到 9 點 35 分是 35 分鐘。',
          '所以從頭到尾一共經過 10 + 35 = 45 分鐘。',
          '這 45 分鐘裡有 10 分鐘在休息，要扣掉。',
          '所以實際寫作業的時間是 45 − 10 = 35 分鐘。',
        ],
        'zh-Hans' => [
          '先算从开始到结束一共经过多久。',
          '从 8 点 50 分到 9 点整是 10 分钟，从 9 点整到 9 点 35 分是 35 分钟。',
          '所以从头到尾一共经过 10 + 35 = 45 分钟。',
          '这 45 分钟里有 10 分钟在休息，要扣掉。',
          '所以实际写作业的时间是 45 − 10 = 35 分钟。',
        ],
        'en' => [
          'First work out how long it is from the start to the finish.',
          'From 8:50 to 9:00 is 10 minutes, and from 9:00 to 9:35 is 35 minutes.',
          'So the whole stretch is 10 + 35 = 45 minutes.',
          'Of those 45 minutes, 10 were spent on a break and must be taken off.',
          'So the actual working time is 45 − 10 = 35 minutes.',
        ],
        'ja' => [
          'まず始めから終わりまでにどれだけたったかを求めます。',
          '8 時 50 分から 9 時ちょうどまでが 10 分、9 時ちょうどから 9 時 35 分までが 35 分です。',
          'したがって全体では 10 + 35 = 45 分たっています。',
          'この 45 分のうち 10 分は休けいなので、差し引きます。',
          'よって実際に宿題をしていたのは 45 − 10 = 35 分間です。',
        ],
      },
      value: '35', max_digits: 2,
      reference: 'arithmetic-grade1-foundation',
      notes: 'Original composition in the Math Kangaroo grade 1-2 elapsed-time style; the interval must be built across the hour boundary and then reduced by the break. Not a reproduction of any past paper.',
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
