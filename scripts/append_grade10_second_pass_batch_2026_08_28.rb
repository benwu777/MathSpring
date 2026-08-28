#!/usr/bin/env ruby
# frozen_string_literal: true

# grade10 補題（2026-08-28）— 同 subtopic 第二題
#   algebra       : log_sum_property(計算→解方程並排除定義域外的根) / arithmetic_sum_maximum(求 n→逆推公差)
#   combinatorics : non_attacking_rooks(滿排→部分排) / stairs_three_step_sizes(自由步數→固定步數)
#   geometry      : shoelace_quadrilateral(求面積→逆推座標) / sector_minus_triangle(求面積→逆推半徑)
#   logic         : locker_toggle_squares(開關狀態→切換次數) / chocolate_bar_breaks(算次數→證明與策略無關)
#   number_theory : factorial_trailing_zeros(求最小 n→數不可達的零數) / squarefree_count(小範圍列舉→補集排容)

require 'json'
require 'set'

ROOT = File.expand_path('..', __dir__)
GRADE = 'grade10'
TOPIC_ZH = { 'algebra' => '代數', 'combinatorics' => '組合', 'geometry' => '幾何',
             'logic' => '邏輯', 'number_theory' => '數論' }.freeze
PATHS = TOPIC_ZH.keys.to_h { |t| [t, File.join(ROOT, "assets/questions/#{t}/#{GRADE}_foundation.#{t}.v1.json")] }.freeze
MANIFEST_PATH = File.join(ROOT, 'assets/questions/manifest.json')

def load_json(path) = JSON.parse(File.read(path))
def save_json(path, data) = File.write(path, JSON.pretty_generate(data) + "\n")

def base_q(topic:, subtopic:, subtopic_zh:, prompt:, answer:, steps:, reference:, notes:, display:)
  { 'topic' => topic, 'subtopic' => subtopic, 'difficulty' => 'foundation',
    'levelStage' => GRADE, 'challengeTier' => 'foundation',
    'prompt' => prompt, 'answer' => answer, 'solutionSteps' => steps,
    'figure' => { 'type' => 'custom', 'kind' => 'none', 'params' => {} },
    'source' => { 'type' => 'rewritten_olympiad_style', 'name' => 'MathSpring 改寫題',
                  'reference' => reference, 'notes' => notes, 'displayText' => display },
    'olympiadTaxonomy' => { 'topic' => TOPIC_ZH[topic], 'topicCode' => topic,
                            'subtopic' => subtopic_zh, 'subtopicCode' => subtopic },
    'reviewStatus' => 'ok' }
end

def int_q(value:, max_digits:, **rest)
  base_q(**rest).merge('answerMode' => 'integer_input',
                       'correctAnswer' => { 'type' => 'integer', 'value' => value },
                       'inputConstraints' => { 'allowNegative' => false, 'maxDigits' => max_digits })
end

def mc_q(options:, correct:, **rest)
  base_q(**rest).merge('answerMode' => 'multiple_choice', 'options' => options,
                       'correctAnswer' => { 'type' => 'choice', 'value' => correct })
end

QUESTIONS = {
  'algebra' => [
    int_q(
      topic: 'algebra', subtopic: 'log_sum_property', subtopic_zh: '對數的加法',
      prompt: {
        'zh-Hant' => '已知 log₂x + log₂(x − 6) = 4，求 x 的值。',
        'zh-Hans' => '已知 log₂x + log₂(x − 6) = 4，求 x 的值。',
        'en' => 'Given that log₂x + log₂(x − 6) = 4, find the value of x.',
        'ja' => 'log₂x + log₂(x − 6) = 4 のとき、x の値を求めなさい。',
      },
      answer: { 'zh-Hant' => '答案是 8。', 'zh-Hans' => '答案是 8。', 'en' => 'The answer is 8.', 'ja' => '答えは 8 です。' },
      steps: {
        'zh-Hant' => [
          '先確認定義域：對數的真數必須是正數，所以 x > 0 且 x − 6 > 0，也就是 x > 6。',
          '利用同底對數相加的性質，把左邊合併成 log₂[x(x − 6)] = 4。',
          '化成指數式得 x(x − 6) = 2⁴ = 16，也就是 x² − 6x − 16 = 0。',
          '因式分解得 (x − 8)(x + 2) = 0，所以 x = 8 或 x = −2。',
          'x = −2 不滿足 x > 6 的定義域限制，必須捨去，所以 x = 8。',
        ],
        'zh-Hans' => [
          '先确认定义域：对数的真数必须是正数，所以 x > 0 且 x − 6 > 0，也就是 x > 6。',
          '利用同底对数相加的性质，把左边合并成 log₂[x(x − 6)] = 4。',
          '化成指数式得 x(x − 6) = 2⁴ = 16，也就是 x² − 6x − 16 = 0。',
          '因式分解得 (x − 8)(x + 2) = 0，所以 x = 8 或 x = −2。',
          'x = −2 不满足 x > 6 的定义域限制，必须舍去，所以 x = 8。',
        ],
        'en' => [
          'First check the domain: the argument of a logarithm must be positive, so x > 0 and x − 6 > 0, that is x > 6.',
          'Using the rule for adding logarithms with the same base, the left side becomes log₂[x(x − 6)] = 4.',
          'Rewriting in exponential form gives x(x − 6) = 2⁴ = 16, that is x² − 6x − 16 = 0.',
          'Factorising gives (x − 8)(x + 2) = 0, so x = 8 or x = −2.',
          'The value x = −2 fails the domain condition x > 6 and must be rejected, so x = 8.',
        ],
        'ja' => [
          'まず定義域を確認します。対数の真数は正でなければならないので、x > 0 かつ x − 6 > 0、つまり x > 6 です。',
          '同じ底の対数の和の性質を使い、左辺を log₂[x(x − 6)] = 4 にまとめます。',
          '指数の形に直すと x(x − 6) = 2⁴ = 16、つまり x² − 6x − 16 = 0 となります。',
          '因数分解すると (x − 8)(x + 2) = 0 なので、x = 8 または x = −2 です。',
          'x = −2 は x > 6 という定義域の条件を満たさないので除き、x = 8 となります。',
        ],
      },
      value: '8', max_digits: 1,
      reference: '對數的加法（由直接計算改為解方程並檢驗定義域）',
      notes: '設計依據：既有題只要用同底對數相加的性質算出一個定值，本題把未知數放進真數，必須先確定定義域、合併後解二次方程，再捨去不合定義域的根；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（對數・解方程）',
    ),
    int_q(
      topic: 'algebra', subtopic: 'arithmetic_sum_maximum', subtopic_zh: '等差和最大',
      prompt: {
        'zh-Hant' => '一個等差數列的首項是 32，公差是負整數。已知它的前 n 項之和恰好在 n = 6 時達到最大，而且 n = 6 是唯一使和達到最大的項數。求公差的絕對值。',
        'zh-Hans' => '一个等差数列的首项是 32，公差是负整数。已知它的前 n 项之和恰好在 n = 6 时达到最大，而且 n = 6 是唯一使和达到最大的项数。求公差的绝对值。',
        'en' => 'An arithmetic sequence has first term 32 and a negative whole number as common difference. The sum of its first n terms is greatest exactly when n = 6, and n = 6 is the only value giving that greatest sum. Find the absolute value of the common difference.',
        'ja' => 'ある等差数列の初項は 32 で、公差は負の整数です。初項から第 n 項までの和が n = 6 のときちょうど最大になり、しかも最大になる n は 6 だけであるとします。公差の絶対値を求めなさい。',
      },
      answer: { 'zh-Hant' => '答案是 6。', 'zh-Hans' => '答案是 6。', 'en' => 'The answer is 6.', 'ja' => '答えは 6 です。' },
      steps: {
        'zh-Hant' => [
          '設公差是 d。因為 d 是負數，數列的項會越來越小，前 n 項和會先增加後減少。',
          '和在 n = 6 時唯一最大，表示加到第 6 項時和還在增加、加上第 7 項時和就會變小，也就是第 6 項為正、第 7 項為負。',
          '第 6 項是 32 + 5d > 0，得 d > −6.4；第 7 項是 32 + 6d < 0，得 d < −16 ÷ 3，約 −5.33。',
          '所以 d 必須同時滿足 −6.4 < d < −5.33，而 d 是整數，只有 d = −6。',
          '驗算：d = −6 時第 6 項是 32 − 30 = 2（正）、第 7 項是 32 − 36 = −4（負），符合條件，所以公差的絕對值是 6。',
        ],
        'zh-Hans' => [
          '设公差是 d。因为 d 是负数，数列的项会越来越小，前 n 项和会先增加后减少。',
          '和在 n = 6 时唯一最大，表示加到第 6 项时和还在增加、加上第 7 项时和就会变小，也就是第 6 项为正、第 7 项为负。',
          '第 6 项是 32 + 5d > 0，得 d > −6.4；第 7 项是 32 + 6d < 0，得 d < −16 ÷ 3，约 −5.33。',
          '所以 d 必须同时满足 −6.4 < d < −5.33，而 d 是整数，只有 d = −6。',
          '验算：d = −6 时第 6 项是 32 − 30 = 2（正）、第 7 项是 32 − 36 = −4（负），符合条件，所以公差的绝对值是 6。',
        ],
        'en' => [
          'Let the common difference be d. Since d is negative the terms decrease, so the sum of the first n terms rises and then falls.',
          'The sum being uniquely greatest at n = 6 means the sum still grows when the 6th term is added but falls when the 7th is added, so the 6th term is positive and the 7th is negative.',
          'The 6th term is 32 + 5d > 0, giving d > −6.4; the 7th term is 32 + 6d < 0, giving d < −16 ÷ 3, about −5.33.',
          'So d must satisfy −6.4 < d < −5.33, and being an integer it can only be d = −6.',
          'Check: with d = −6 the 6th term is 32 − 30 = 2 (positive) and the 7th is 32 − 36 = −4 (negative), which fits, so the absolute value of the common difference is 6.',
        ],
        'ja' => [
          '公差を d とします。d は負なので項はしだいに小さくなり、初項から第 n 項までの和は増えてから減ります。',
          '和が n = 6 でただ 1 つの最大になるということは、第 6 項を加えるまでは和が増え、第 7 項を加えると減るということ、つまり第 6 項が正で第 7 項が負ということです。',
          '第 6 項は 32 + 5d > 0 より d > −6.4、第 7 項は 32 + 6d < 0 より d < −16 ÷ 3（約 −5.33）です。',
          'よって d は −6.4 < d < −5.33 を満たす整数で、d = −6 しかありません。',
          '確かめると d = −6 のとき第 6 項は 32 − 30 = 2（正）、第 7 項は 32 − 36 = −4（負）で条件に合うので、公差の絶対値は 6 です。',
        ],
      },
      value: '6', max_digits: 1,
      reference: '等差和最大（由求項數改為逆推公差）',
      notes: '設計依據：既有題給首項與公差求使和最大的項數，本題反過來由「最大值出現在第 6 項且唯一」逆推公差，必須用第 6 項為正、第 7 項為負的雙不等式夾出唯一整數；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（等差和・逆推公差）',
    ),
  ],
  'combinatorics' => [
    int_q(
      topic: 'combinatorics', subtopic: 'non_attacking_rooks', subtopic_zh: '互不攻擊的城堡',
      prompt: {
        'zh-Hant' => '在 4 × 4 的棋盤上放 3 個城堡（西洋棋中的 rook，可以沿同一行或同一列攻擊任意距離）。若要求任兩個城堡都不會互相攻擊，求共有多少種放法。',
        'zh-Hans' => '在 4 × 4 的棋盘上放 3 个城堡（国际象棋中的 rook，可以沿同一行或同一列攻击任意距离）。若要求任两个城堡都不会互相攻击，求共有多少种放法。',
        'en' => 'Three rooks are placed on a 4 × 4 board (a rook attacks any distance along its row or its column). If no two rooks may attack each other, how many placements are there?',
        'ja' => '4 × 4 の盤に 3 個のルーク（同じ行または同じ列に沿ってどこまでも利く駒）を置きます。どの 2 個も互いに利きが当たらないようにするとき、置き方は何通りありますか。',
      },
      answer: { 'zh-Hant' => '答案是 96 種。', 'zh-Hans' => '答案是 96 种。',
                'en' => 'The answer is 96 placements.', 'ja' => '答えは 96 通りです。' },
      steps: {
        'zh-Hant' => [
          '兩個城堡不互相攻擊，等於它們不在同一行也不在同一列，所以 3 個城堡必須佔用 3 個不同的行和 3 個不同的列。',
          '棋盤只有 4 行，要從中選出被使用的 3 行，方法有 4 種（等於選一行不用）。',
          '同樣地，要從 4 列中選出被使用的 3 列，方法也有 4 種。',
          '選定 3 行與 3 列之後，還要決定哪一行配哪一列，也就是把 3 行與 3 列一一對應，方法有 3 × 2 × 1 = 6 種。',
          '所以總放法是 4 × 4 × 6 = 96 種。',
        ],
        'zh-Hans' => [
          '两个城堡不互相攻击，等于它们不在同一行也不在同一列，所以 3 个城堡必须占用 3 个不同的行和 3 个不同的列。',
          '棋盘只有 4 行，要从中选出被使用的 3 行，方法有 4 种（等于选一行不用）。',
          '同样地，要从 4 列中选出被使用的 3 列，方法也有 4 种。',
          '选定 3 行与 3 列之后，还要决定哪一行配哪一列，也就是把 3 行与 3 列一一对应，方法有 3 × 2 × 1 = 6 种。',
          '所以总放法是 4 × 4 × 6 = 96 种。',
        ],
        'en' => [
          'Two rooks not attacking each other means they share neither a row nor a column, so the 3 rooks must occupy 3 different rows and 3 different columns.',
          'There are only 4 rows, and choosing which 3 are used can be done in 4 ways, the same as choosing the one row left out.',
          'Likewise the 3 columns used can be chosen from the 4 columns in 4 ways.',
          'Once the 3 rows and 3 columns are fixed, it remains to decide which row goes with which column, a one-to-one matching that can be made in 3 × 2 × 1 = 6 ways.',
          'The total is therefore 4 × 4 × 6 = 96 placements.',
        ],
        'ja' => [
          '2 個のルークが互いに利かないとは、同じ行にも同じ列にもないということなので、3 個は異なる 3 つの行と異なる 3 つの列を使います。',
          '行は 4 つしかないので、使う 3 行の選び方は 4 通りです（使わない 1 行を選ぶのと同じです）。',
          '同様に、使う 3 列の選び方も 4 通りです。',
          '3 行と 3 列を決めたあと、どの行にどの列を対応させるかを決める必要があり、その 1 対 1 の対応は 3 × 2 × 1 = 6 通りです。',
          'したがって全部で 4 × 4 × 6 = 96 通りです。',
        ],
      },
      value: '96', max_digits: 2,
      reference: '互不攻擊的城堡（由滿排改為部分排）',
      notes: '設計依據：既有題在 4 × 4 上放滿 4 個城堡，答案直接是 4 的階乘；本題只放 3 個，必須先分別選出使用的行與列再做一一對應，計數結構多了兩層選取；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（城堡・部分排）',
    ),
    int_q(
      topic: 'combinatorics', subtopic: 'stairs_three_step_sizes', subtopic_zh: '三種步幅的樓梯',
      prompt: {
        'zh-Hant' => '一段樓梯共有 10 階。每一步可以往上走 1 階、2 階或 3 階，而且規定必須恰好用 5 步走完這段樓梯。若不同的步伐順序視為不同的走法，求共有多少種走法。',
        'zh-Hans' => '一段楼梯共有 10 阶。每一步可以往上走 1 阶、2 阶或 3 阶，而且规定必须恰好用 5 步走完这段楼梯。若不同的步伐顺序视为不同的走法，求共有多少种走法。',
        'en' => 'A staircase has 10 steps. Each stride may go up 1, 2 or 3 steps, and the staircase must be climbed in exactly 5 strides. Counting different orders of strides as different ways, how many ways are there?',
        'ja' => '階段は全部で 10 段あります。1 歩で 1 段、2 段、3 段のいずれかを上ることができ、ちょうど 5 歩で上りきらなければなりません。歩き方の順序がちがえば別の上り方と数えるとき、上り方は何通りありますか。',
      },
      answer: { 'zh-Hant' => '答案是 51 種。', 'zh-Hans' => '答案是 51 种。',
                'en' => 'The answer is 51 ways.', 'ja' => '答えは 51 通りです。' },
      steps: {
        'zh-Hant' => [
          '設 5 步的步幅依序是 x₁ 到 x₅，每個都是 1、2 或 3，且總和是 10。',
          '若每一步都只走 1 階，總共只有 5 階，還差 10 − 5 = 5 階，所以要把這多出來的 5 階分配到 5 步上，每一步最多再多加 2 階。',
          '設第 i 步多加 yᵢ 階，則 y₁ + ⋯ + y₅ = 5，且每個 yᵢ 都是 0、1 或 2。',
          '先不管上限，把 5 分成 5 個非負整數的方法有 C(9, 4) = 126 種；再扣掉某個 yᵢ 至少是 3 的情況：指定一個 i 有 5 種選法，剩下要分配 5 − 3 = 2，有 C(6, 4) = 15 種，合計 5 × 15 = 75 種。',
          '因為總和只有 5，不可能同時有兩個 yᵢ 大於 2，不必再加回，所以答案是 126 − 75 = 51 種。',
        ],
        'zh-Hans' => [
          '设 5 步的步幅依次是 x₁ 到 x₅，每个都是 1、2 或 3，且总和是 10。',
          '若每一步都只走 1 阶，总共只有 5 阶，还差 10 − 5 = 5 阶，所以要把这多出来的 5 阶分配到 5 步上，每一步最多再多加 2 阶。',
          '设第 i 步多加 yᵢ 阶，则 y₁ + ⋯ + y₅ = 5，且每个 yᵢ 都是 0、1 或 2。',
          '先不管上限，把 5 分成 5 个非负整数的方法有 C(9, 4) = 126 种；再扣掉某个 yᵢ 至少是 3 的情况：指定一个 i 有 5 种选法，剩下要分配 5 − 3 = 2，有 C(6, 4) = 15 种，合计 5 × 15 = 75 种。',
          '因为总和只有 5，不可能同时有两个 yᵢ 大于 2，不必再加回，所以答案是 126 − 75 = 51 种。',
        ],
        'en' => [
          'Let the five strides be x₁ through x₅, each equal to 1, 2 or 3, with total 10.',
          'If every stride were just 1 step the total would be 5, leaving 10 − 5 = 5 extra steps to distribute over the 5 strides, with each stride able to take at most 2 extra.',
          'Writing yᵢ for the extra on stride i gives y₁ + ⋯ + y₅ = 5 with each yᵢ equal to 0, 1 or 2.',
          'Ignoring the upper limit first, the number of ways to split 5 into 5 non-negative parts is C(9, 4) = 126; then subtract the cases where some yᵢ is at least 3, which is 5 choices of i times C(6, 4) = 15 ways to share out 5 − 3 = 2, giving 5 × 15 = 75.',
          'Since the total is only 5, two of the yᵢ cannot both exceed 2, so nothing needs adding back, and the answer is 126 − 75 = 51 ways.',
        ],
        'ja' => [
          '5 歩の歩幅を順に x₁ から x₅ とすると、それぞれ 1、2、3 のいずれかで、和は 10 です。',
          'すべて 1 段ずつなら合計 5 段なので、あと 10 − 5 = 5 段を 5 歩に配分することになり、1 歩につき追加できるのは最大 2 段です。',
          'i 歩目の追加を yᵢ とすると、y₁ + ⋯ + y₅ = 5 で、各 yᵢ は 0、1、2 のいずれかです。',
          'まず上限を無視すると、5 を 5 つの非負整数に分ける方法は C(9, 4) = 126 通りです。次に、ある yᵢ が 3 以上になる場合を引きます。i の選び方が 5 通り、残り 5 − 3 = 2 の配分が C(6, 4) = 15 通りで、合わせて 5 × 15 = 75 通りです。',
          '和が 5 しかないので 2 つの yᵢ が同時に 2 をこえることはなく、戻す必要はありません。よって答えは 126 − 75 = 51 通りです。',
        ],
      },
      value: '51', max_digits: 2,
      reference: '樓梯走法（由自由步數改為固定步數）',
      notes: '設計依據：既有題不限步數、用遞推逐階累加，本題規定恰好 5 步，變成有上限的整數分配問題，必須用星星與隔板再配合排容扣除超過上限的情形；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（樓梯・固定步數）',
    ),
  ],
  'geometry' => [
    int_q(
      topic: 'geometry', subtopic: 'shoelace_quadrilateral', subtopic_zh: '座標四邊形面積',
      prompt: {
        'zh-Hant' => '座標平面上的四邊形 ABCD 的四個頂點依序是 A(0, 0)、B(6, 0)、C(8, k)、D(2, 7)，其中 k 是正整數。若這個四邊形的面積是 38，求 k 的值。',
        'zh-Hans' => '座标平面上的四边形 ABCD 的四个顶点依次是 A(0, 0)、B(6, 0)、C(8, k)、D(2, 7)，其中 k 是正整数。若这个四边形的面积是 38，求 k 的值。',
        'en' => 'A quadrilateral ABCD in the coordinate plane has vertices, in order, A(0, 0), B(6, 0), C(8, k) and D(2, 7), where k is a positive integer. If the area of the quadrilateral is 38, find k.',
        'ja' => '座標平面上の四角形 ABCD の頂点は順に A(0, 0)、B(6, 0)、C(8, k)、D(2, 7) で、k は正の整数です。この四角形の面積が 38 のとき、k の値を求めなさい。',
      },
      answer: { 'zh-Hant' => '答案是 5。', 'zh-Hans' => '答案是 5。', 'en' => 'The answer is 5.', 'ja' => '答えは 5 です。' },
      steps: {
        'zh-Hant' => [
          '用座標求多邊形面積的公式：把頂點依序代入，面積等於「各項 xᵢyᵢ₊₁ 減去 xᵢ₊₁yᵢ」總和的絕對值的一半。',
          '依序計算：A 到 B 是 0 × 0 − 6 × 0 = 0；B 到 C 是 6 × k − 8 × 0 = 6k。',
          'C 到 D 是 8 × 7 − 2 × k = 56 − 2k；D 到 A 是 2 × 0 − 0 × 7 = 0。',
          '把它們加起來是 6k + 56 − 2k = 4k + 56，所以面積是 (4k + 56) ÷ 2 = 2k + 28。',
          '令 2k + 28 = 38，解得 k = 5。',
        ],
        'zh-Hans' => [
          '用座标求多边形面积的公式：把顶点依序代入，面积等于「各项 xᵢyᵢ₊₁ 减去 xᵢ₊₁yᵢ」总和的绝对值的一半。',
          '依序计算：A 到 B 是 0 × 0 − 6 × 0 = 0；B 到 C 是 6 × k − 8 × 0 = 6k。',
          'C 到 D 是 8 × 7 − 2 × k = 56 − 2k；D 到 A 是 2 × 0 − 0 × 7 = 0。',
          '把它们加起来是 6k + 56 − 2k = 4k + 56，所以面积是 (4k + 56) ÷ 2 = 2k + 28。',
          '令 2k + 28 = 38，解得 k = 5。',
        ],
        'en' => [
          'Use the coordinate formula for the area of a polygon: substituting the vertices in order, the area is half the absolute value of the sum of the terms xᵢyᵢ₊₁ − xᵢ₊₁yᵢ.',
          'Working through in order: from A to B gives 0 × 0 − 6 × 0 = 0; from B to C gives 6 × k − 8 × 0 = 6k.',
          'From C to D gives 8 × 7 − 2 × k = 56 − 2k; from D to A gives 2 × 0 − 0 × 7 = 0.',
          'Adding these gives 6k + 56 − 2k = 4k + 56, so the area is (4k + 56) ÷ 2 = 2k + 28.',
          'Setting 2k + 28 = 38 gives k = 5.',
        ],
        'ja' => [
          '座標から多角形の面積を求める公式を使います。頂点を順に代入すると、面積は各項 xᵢyᵢ₊₁ − xᵢ₊₁yᵢ の和の絶対値の半分です。',
          '順に計算すると、A から B は 0 × 0 − 6 × 0 = 0、B から C は 6 × k − 8 × 0 = 6k です。',
          'C から D は 8 × 7 − 2 × k = 56 − 2k、D から A は 2 × 0 − 0 × 7 = 0 です。',
          'これらをたすと 6k + 56 − 2k = 4k + 56 なので、面積は (4k + 56) ÷ 2 = 2k + 28 です。',
          '2k + 28 = 38 とおくと k = 5 が得られます。',
        ],
      },
      value: '5', max_digits: 1,
      reference: '座標多邊形面積（由求面積改為逆推座標）',
      notes: '設計依據：既有題四個頂點都給定、直接套公式算面積，本題把其中一個頂點的縱座標設為未知，必須把面積化成含參數的一次式再解方程；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（座標面積・逆推座標）',
    ),
    int_q(
      topic: 'geometry', subtopic: 'sector_minus_triangle', subtopic_zh: '弓形的面積',
      prompt: {
        'zh-Hant' => '扇形 OAB 的圓心角 ∠AOB 是 60°，半徑是 r 公分。連接 A 與 B 之後得到三角形 OAB，已知這個三角形的面積是 9√3 平方公分。求 r 的值。',
        'zh-Hans' => '扇形 OAB 的圆心角 ∠AOB 是 60°，半径是 r 厘米。连接 A 与 B 之后得到三角形 OAB，已知这个三角形的面积是 9√3 平方厘米。求 r 的值。',
        'en' => 'A sector OAB has central angle ∠AOB equal to 60° and radius r centimetres. Joining A to B gives triangle OAB, whose area is 9√3 square centimetres. Find r.',
        'ja' => '扇形 OAB の中心角 ∠AOB は 60°、半径は r センチメートルです。A と B を結んでできる三角形 OAB の面積が 9√3 平方センチメートルであるとき、r の値を求めなさい。',
      },
      answer: { 'zh-Hant' => '答案是 6。', 'zh-Hans' => '答案是 6。', 'en' => 'The answer is 6.', 'ja' => '答えは 6 です。' },
      steps: {
        'zh-Hant' => [
          'OA 和 OB 都是半徑，長度都是 r，所以三角形 OAB 是等腰三角形。',
          '又因為頂角 ∠AOB 是 60°，兩個底角各是 (180° − 60°) ÷ 2 = 60°，所以三角形 OAB 其實是正三角形，三邊都是 r。',
          '邊長為 r 的正三角形，面積是 (√3 ÷ 4) × r²。',
          '令 (√3 ÷ 4) × r² = 9√3，兩邊同除以 √3 得 r² ÷ 4 = 9，也就是 r² = 36。',
          '半徑為正，所以 r = 6。',
        ],
        'zh-Hans' => [
          'OA 和 OB 都是半径，长度都是 r，所以三角形 OAB 是等腰三角形。',
          '又因为顶角 ∠AOB 是 60°，两个底角各是 (180° − 60°) ÷ 2 = 60°，所以三角形 OAB 其实是正三角形，三边都是 r。',
          '边长为 r 的正三角形，面积是 (√3 ÷ 4) × r²。',
          '令 (√3 ÷ 4) × r² = 9√3，两边同除以 √3 得 r² ÷ 4 = 9，也就是 r² = 36。',
          '半径为正，所以 r = 6。',
        ],
        'en' => [
          'OA and OB are both radii of length r, so triangle OAB is isosceles.',
          'Since the apex angle ∠AOB is 60°, each base angle is (180° − 60°) ÷ 2 = 60°, so triangle OAB is in fact equilateral with all sides r.',
          'An equilateral triangle with side r has area (√3 ÷ 4) × r².',
          'Setting (√3 ÷ 4) × r² = 9√3 and dividing both sides by √3 gives r² ÷ 4 = 9, that is r² = 36.',
          'A radius is positive, so r = 6.',
        ],
        'ja' => [
          'OA と OB はどちらも半径で長さ r なので、三角形 OAB は二等辺三角形です。',
          'さらに頂角 ∠AOB が 60° なので底角はそれぞれ (180° − 60°) ÷ 2 = 60° となり、三角形 OAB は 3 辺とも r の正三角形です。',
          '1 辺 r の正三角形の面積は (√3 ÷ 4) × r² です。',
          '(√3 ÷ 4) × r² = 9√3 とおき、両辺を √3 でわると r² ÷ 4 = 9、つまり r² = 36 となります。',
          '半径は正なので r = 6 です。',
        ],
      },
      value: '6', max_digits: 1,
      reference: '扇形與三角形（由求面積改為逆推半徑）',
      notes: '設計依據：既有題給半徑與 90° 圓心角求弓形面積，本題改成 60° 並由三角形面積反求半徑，關鍵是先看出等腰加 60° 頂角其實是正三角形；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（扇形・逆推半徑）',
    ),
  ],
  'logic' => [
    int_q(
      topic: 'logic', subtopic: 'locker_toggle_squares', subtopic_zh: '櫃門的開關輪次',
      prompt: {
        'zh-Hant' => '走廊上有編號 1 到 100 的一百個櫃子，一開始全部關著。第 k 輪把所有編號是 k 的倍數的櫃子切換狀態，k 從 1 一路做到 100。全部一百輪結束後，被切換狀態恰好 3 次的櫃子共有幾個？',
        'zh-Hans' => '走廊上有编号 1 到 100 的一百个柜子，一开始全部关着。第 k 轮把所有编号是 k 的倍数的柜子切换状态，k 从 1 一路做到 100。全部一百轮结束后，被切换状态恰好 3 次的柜子共有几个？',
        'en' => 'A corridor has 100 lockers numbered 1 to 100, all closed at the start. On round k, every locker whose number is a multiple of k is toggled, with k running from 1 to 100. After all 100 rounds, how many lockers have been toggled exactly 3 times?',
        'ja' => '廊下に 1 から 100 の番号がついたロッカーが 100 個あり、はじめはすべて閉まっています。k 回目には番号が k の倍数のロッカーの状態を切りかえ、k は 1 から 100 まで進みます。100 回すべて終わったあと、状態がちょうど 3 回切りかえられたロッカーは何個ありますか。',
      },
      answer: { 'zh-Hant' => '答案是 4 個。', 'zh-Hans' => '答案是 4 个。',
                'en' => 'The answer is 4 lockers.', 'ja' => '答えは 4 個です。' },
      steps: {
        'zh-Hant' => [
          '第 n 號櫃子只有在第 k 輪且 k 是 n 的因數時才會被切換，所以它被切換的次數就等於 n 的正因數個數。',
          '因此問題變成：1 到 100 之中，恰好有 3 個正因數的數有幾個。',
          '若把 n 分解質因數，因數個數是各指數加 1 之後的乘積。要讓乘積是 3，而 3 是質數，只能是單一因子 3，也就是指數為 2。',
          '所以 n 必須是某個質數的平方。100 以內的質數平方有 2² = 4、3² = 9、5² = 25、7² = 49，而 11² = 121 已超過 100。',
          '符合的櫃子是 4、9、25、49，一共 4 個。',
        ],
        'zh-Hans' => [
          '第 n 号柜子只有在第 k 轮且 k 是 n 的因数时才会被切换，所以它被切换的次数就等于 n 的正因数个数。',
          '因此问题变成：1 到 100 之中，恰好有 3 个正因数的数有几个。',
          '若把 n 分解质因数，因数个数是各指数加 1 之后的乘积。要让乘积是 3，而 3 是质数，只能是单一因子 3，也就是指数为 2。',
          '所以 n 必须是某个质数的平方。100 以内的质数平方有 2² = 4、3² = 9、5² = 25、7² = 49，而 11² = 121 已超过 100。',
          '符合的柜子是 4、9、25、49，一共 4 个。',
        ],
        'en' => [
          'Locker n is toggled on round k exactly when k divides n, so the number of times it is toggled equals the number of positive divisors of n.',
          'The question therefore becomes: how many numbers from 1 to 100 have exactly 3 positive divisors.',
          'Writing n as a product of prime powers, the divisor count is the product of each exponent increased by 1. For that product to be 3, and 3 being prime, there can be only one factor equal to 3, so a single exponent of 2.',
          'So n must be the square of a prime. The prime squares up to 100 are 2² = 4, 3² = 9, 5² = 25 and 7² = 49, while 11² = 121 is already too large.',
          'The lockers are 4, 9, 25 and 49, so there are 4 of them.',
        ],
        'ja' => [
          '番号 n のロッカーは、k が n の約数である k 回目にだけ切りかえられるので、切りかえられる回数は n の正の約数の個数に等しくなります。',
          'したがって問題は「1 から 100 のうち正の約数がちょうど 3 個の数は何個か」に変わります。',
          'n を素因数分解すると、約数の個数は各指数に 1 を加えたものの積です。この積が 3 になるには、3 が素数なので因子が 1 つだけ、つまり指数が 2 でなければなりません。',
          'よって n は素数の平方です。100 以下の素数の平方は 2² = 4、3² = 9、5² = 25、7² = 49 で、11² = 121 は 100 をこえます。',
          '条件に合うロッカーは 4、9、25、49 の 4 個です。',
        ],
      },
      value: '4', max_digits: 1,
      reference: '櫃門切換（由最終開關狀態改為切換次數）',
      notes: '設計依據：既有題問最後開著的櫃子數，答案落在完全平方數（因數個數為奇數）；本題改問切換次數恰為 3 的櫃子，必須改用「因數個數為 3 等價於質數平方」的性質，觀察角度不同；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（櫃門・切換次數）',
    ),
    mc_q(
      topic: 'logic', subtopic: 'chocolate_bar_breaks', subtopic_zh: '巧克力的掰法',
      prompt: {
        'zh-Hant' => '一塊長方形巧克力上有格線，共分成 6 × 8 = 48 個小方塊。每一次操作只能拿起其中一塊，沿著某一條格線把它掰成兩塊（不可以疊起來一起掰）。小安想知道：要把整塊巧克力分成 48 個獨立的小方塊，掰的次數會不會因為選擇不同的掰法順序而改變？下列敘述哪一個正確？',
        'zh-Hans' => '一块长方形巧克力上有格线，共分成 6 × 8 = 48 个小方块。每一次操作只能拿起其中一块，沿着某一条格线把它掰成两块（不可以叠起来一起掰）。小安想知道：要把整块巧克力分成 48 个独立的小方块，掰的次数会不会因为选择不同的掰法顺序而改变？下列叙述哪一个正确？',
        'en' => 'A rectangular chocolate bar is scored into 6 × 8 = 48 small squares. Each move takes one piece and breaks it along a scored line into two pieces; pieces may not be stacked and broken together. An wonders whether the number of breaks needed to separate the bar into all 48 small squares depends on the order of the breaks. Which statement is correct?',
        'ja' => '長方形のチョコレートに切れ目が入っていて、6 × 8 = 48 個の小さな正方形に分かれています。1 回の操作では 1 つのかたまりを取り、切れ目にそって 2 つに割ります（重ねて一度に割ることはできません）。全体を 48 個の小さな正方形に分けるのに必要な回数は、割る順序によって変わるでしょうか。正しいものはどれですか。',
      },
      answer: { 'zh-Hant' => '不論怎麼掰，都一定恰好是 47 次。',
                'zh-Hans' => '不论怎么掰，都一定恰好是 47 次。',
                'en' => 'However the breaks are made, it is always exactly 47.',
                'ja' => 'どのように割っても必ずちょうど 47 回です。' },
      steps: {
        'zh-Hant' => [
          '觀察每一次操作對「目前總共有幾塊」的影響：拿起一塊掰成兩塊，塊數恰好增加 1，而且不論在哪裡掰、掰哪一塊都一樣。',
          '一開始整塊巧克力是 1 塊，最後要變成 48 塊。',
          '塊數每次只增加 1，所以從 1 增加到 48 必須恰好經過 48 − 1 = 47 次操作。',
          '這個推理完全沒有用到掰的位置或順序，所以次數不可能因為策略不同而改變。',
          '因此不論怎麼掰，都一定恰好是 47 次。',
        ],
        'zh-Hans' => [
          '观察每一次操作对「目前总共有几块」的影响：拿起一块掰成两块，块数恰好增加 1，而且不论在哪里掰、掰哪一块都一样。',
          '一开始整块巧克力是 1 块，最后要变成 48 块。',
          '块数每次只增加 1，所以从 1 增加到 48 必须恰好经过 48 − 1 = 47 次操作。',
          '这个推理完全没有用到掰的位置或顺序，所以次数不可能因为策略不同而改变。',
          '因此不论怎么掰，都一定恰好是 47 次。',
        ],
        'en' => [
          'Look at how each move changes the current number of pieces: taking one piece and breaking it in two increases the count by exactly 1, whatever piece is chosen and wherever the break is made.',
          'At the start there is 1 piece, and at the end there must be 48.',
          'Since the count rises by exactly 1 each time, going from 1 to 48 takes exactly 48 − 1 = 47 moves.',
          'This argument never refers to the position or the order of the breaks, so the count cannot depend on the strategy.',
          'However the breaks are made, the answer is always exactly 47.',
        ],
        'ja' => [
          '各操作が「今いくつのかたまりがあるか」をどう変えるかを見ます。1 つを取って 2 つに割るとかたまりの数はちょうど 1 増え、どのかたまりをどこで割っても同じです。',
          'はじめは 1 つ、最後は 48 個にしなければなりません。',
          '数は毎回ちょうど 1 ずつ増えるので、1 から 48 にするにはちょうど 48 − 1 = 47 回かかります。',
          'この議論では割る位置も順序もいっさい使っていないので、回数がやり方によって変わることはありません。',
          'したがってどのように割っても必ずちょうど 47 回です。',
        ],
      },
      options: {
        'A' => { 'zh-Hant' => '不論怎麼掰，都一定恰好是 47 次', 'zh-Hans' => '不论怎么掰，都一定恰好是 47 次',
                 'en' => 'However the breaks are made, it is always exactly 47',
                 'ja' => 'どのように割っても必ずちょうど 47 回' },
        'B' => { 'zh-Hant' => '最少是 47 次，但掰得不好時會更多', 'zh-Hans' => '最少是 47 次，但掰得不好时会更多',
                 'en' => 'At least 47, but a poor choice of breaks needs more',
                 'ja' => '最少 47 回だが、割り方が悪いともっと必要' },
        'C' => { 'zh-Hant' => '會因順序而不同，最少只要 12 次', 'zh-Hans' => '会因顺序而不同，最少只要 12 次',
                 'en' => 'It depends on the order, and as few as 12 breaks suffice',
                 'ja' => '順序によって変わり、最少 12 回ですむ' },
        'D' => { 'zh-Hant' => '會因順序而不同，最多是 47 次', 'zh-Hans' => '会因顺序而不同，最多是 47 次',
                 'en' => 'It depends on the order, with 47 as the maximum',
                 'ja' => '順序によって変わり、最多で 47 回' },
      },
      correct: 'A',
      reference: '巧克力的掰法（由算出次數改為證明與策略無關）',
      notes: '設計依據：既有題直接求最少掰的次數，本題改問次數是否會隨策略改變，必須指出「每掰一次塊數恰好加一」這個不變量，選項 B 與 D 都把它誤當成有最佳化空間的問題；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（掰巧克力・不變量）',
    ),
  ],
  'number_theory' => [
    int_q(
      topic: 'number_theory', subtopic: 'factorial_trailing_zeros', subtopic_zh: '階乘末尾零的個數',
      prompt: {
        'zh-Hant' => '在 1 到 100 的正整數 k 之中，有多少個 k 使得沒有任何正整數 n 能讓 n! 的末尾恰好有 k 個 0？',
        'zh-Hans' => '在 1 到 100 的正整数 k 之中，有多少个 k 使得没有任何正整数 n 能让 n! 的末尾恰好有 k 个 0？',
        'en' => 'Among the whole numbers k from 1 to 100, for how many k is there no positive integer n at all such that n! ends in exactly k zeros?',
        'ja' => '1 から 100 までの整数 k のうち、n! の末尾がちょうど k 個の 0 になるような正の整数 n がまったく存在しないような k は何個ありますか。',
      },
      answer: { 'zh-Hant' => '答案是 19 個。', 'zh-Hans' => '答案是 19 个。',
                'en' => 'The answer is 19 values.', 'ja' => '答えは 19 個です。' },
      steps: {
        'zh-Hant' => [
          'n! 末尾 0 的個數等於把 n 依序除以 5、25、125⋯ 後取整數部分再相加。',
          '當 n 每增加 1，這個個數要嘛不變，要嘛跳增；跳增的幅度等於新增的那個數含有多少個因數 5。',
          '若 n 是 25 的倍數但不是 125 的倍數，它一次帶進兩個因數 5，零的個數會一口氣跳過 1 個值，那個被跳過的值就永遠達不到。',
          '在 1 到 100 的範圍內，這樣的跳躍發生在 n = 25、50、75、100 各跳過 1 個值，n = 125 因含三個因數 5 會跳過 2 個值，依此類推逐一累計。',
          '把所有被跳過而落在 1 到 100 之間的值數出來，一共有 19 個，所以答案是 19。',
        ],
        'zh-Hans' => [
          'n! 末尾 0 的个数等于把 n 依序除以 5、25、125⋯ 后取整数部分再相加。',
          '当 n 每增加 1，这个个数要么不变，要么跳增；跳增的幅度等于新增的那个数含有多少个因数 5。',
          '若 n 是 25 的倍数但不是 125 的倍数，它一次带进两个因数 5，零的个数会一口气跳过 1 个值，那个被跳过的值就永远达不到。',
          '在 1 到 100 的范围内，这样的跳跃发生在 n = 25、50、75、100 各跳过 1 个值，n = 125 因含三个因数 5 会跳过 2 个值，依此类推逐一累计。',
          '把所有被跳过而落在 1 到 100 之间的值数出来，一共有 19 个，所以答案是 19。',
        ],
        'en' => [
          'The number of trailing zeros of n! is found by dividing n by 5, then 25, then 125, and so on, taking whole parts and adding them.',
          'As n increases by 1 this count either stays the same or jumps, and the size of the jump is the number of factors of 5 in the new value of n.',
          'If n is a multiple of 25 but not of 125, it brings in two factors of 5 at once, so the count skips over one value entirely, and that skipped value is never attainable.',
          'Within the range 1 to 100 such jumps occur at n = 25, 50, 75 and 100, each skipping one value, while n = 125 carries three factors of 5 and skips two values, and so on for higher multiples.',
          'Counting all the skipped values that fall between 1 and 100 gives 19 of them, so the answer is 19.',
        ],
        'ja' => [
          'n! の末尾の 0 の個数は、n を 5、25、125⋯ で順にわって整数部分をたすことで求められます。',
          'n が 1 増えるとこの個数は変わらないか跳ね上がり、跳ね上がる幅は新しい n がふくむ因数 5 の個数に等しくなります。',
          'n が 25 の倍数で 125 の倍数でないとき、一度に因数 5 を 2 つもたらすので 0 の個数は 1 つの値を飛ばし、その値には決して到達できません。',
          '1 から 100 の範囲では、こうした飛びが n = 25、50、75、100 で 1 つずつ起こり、n = 125 は因数 5 を 3 つふくむので 2 つ飛ばすというように、順に積み上がっていきます。',
          '1 から 100 の間で飛ばされる値をすべて数えると 19 個になるので、答えは 19 です。',
        ],
      },
      value: '19', max_digits: 2,
      reference: '階乘末尾零（由求最小 n 改為數不可達的零數）',
      notes: '設計依據：既有題給定零的個數求最小的 n，本題改問哪些零的個數根本達不到，必須觀察零數函數在 25 的倍數處會跳躍，屬於對函數值域的分析而非單點求解；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（階乘零・不可達值）',
    ),
    int_q(
      topic: 'number_theory', subtopic: 'squarefree_count', subtopic_zh: '不含平方因數的數',
      prompt: {
        'zh-Hant' => '在 1 到 100 的正整數中（含兩端），能被某個大於 1 的完全平方數整除的數共有幾個？',
        'zh-Hans' => '在 1 到 100 的正整数中（含两端），能被某个大于 1 的完全平方数整除的数共有几个？',
        'en' => 'Among the positive integers from 1 to 100 inclusive, how many are divisible by some perfect square greater than 1?',
        'ja' => '1 から 100 までの正の整数（両端をふくむ）のうち、1 より大きい平方数で割り切れるものは何個ありますか。',
      },
      answer: { 'zh-Hant' => '答案是 39 個。', 'zh-Hans' => '答案是 39 个。',
                'en' => 'The answer is 39 numbers.', 'ja' => '答えは 39 個です。' },
      steps: {
        'zh-Hant' => [
          '一個數若能被某個大於 1 的完全平方數整除，一定能被某個質數的平方整除，所以只要考慮 4、9、25、49 這些不超過 100 的質數平方。',
          '在 1 到 100 中，4 的倍數有 25 個，9 的倍數有 11 個，25 的倍數有 4 個，49 的倍數有 2 個，合計 25 + 11 + 4 + 2 = 42 個。',
          '但有些數被重複算了：同時是 4 和 9 的倍數就是 36 的倍數，有 2 個（36、72）；同時是 4 和 25 的倍數就是 100 的倍數，有 1 個（100）。',
          '其餘的兩兩組合（例如 9 與 25 的公倍數 225）都超過 100，不必考慮，三個以上同時成立的情形也沒有。',
          '依排容原理，答案是 42 − 2 − 1 = 39 個。',
        ],
        'zh-Hans' => [
          '一个数若能被某个大于 1 的完全平方数整除，一定能被某个质数的平方整除，所以只要考虑 4、9、25、49 这些不超过 100 的质数平方。',
          '在 1 到 100 中，4 的倍数有 25 个，9 的倍数有 11 个，25 的倍数有 4 个，49 的倍数有 2 个，合计 25 + 11 + 4 + 2 = 42 个。',
          '但有些数被重复算了：同时是 4 和 9 的倍数就是 36 的倍数，有 2 个（36、72）；同时是 4 和 25 的倍数就是 100 的倍数，有 1 个（100）。',
          '其余的两两组合（例如 9 与 25 的公倍数 225）都超过 100，不必考虑，三个以上同时成立的情形也没有。',
          '依排容原理，答案是 42 − 2 − 1 = 39 个。',
        ],
        'en' => [
          'A number divisible by some perfect square greater than 1 is divisible by the square of some prime, so it is enough to consider the prime squares up to 100: 4, 9, 25 and 49.',
          'From 1 to 100 there are 25 multiples of 4, 11 multiples of 9, 4 multiples of 25 and 2 multiples of 49, giving 25 + 11 + 4 + 2 = 42.',
          'Some numbers have been counted twice: those divisible by both 4 and 9 are the multiples of 36, namely 36 and 72; those divisible by both 4 and 25 are the multiples of 100, namely 100 itself.',
          'The other pairings, such as the common multiples of 9 and 25 starting at 225, all exceed 100, and no number falls into three of the classes at once.',
          'By inclusion and exclusion the answer is 42 − 2 − 1 = 39.',
        ],
        'ja' => [
          '1 より大きい平方数で割り切れる数は、必ずある素数の平方で割り切れるので、100 以下の素数の平方 4、9、25、49 だけを考えれば十分です。',
          '1 から 100 の中に 4 の倍数は 25 個、9 の倍数は 11 個、25 の倍数は 4 個、49 の倍数は 2 個あり、合計 25 + 11 + 4 + 2 = 42 個です。',
          'ただし重複があります。4 と 9 の両方で割り切れる数は 36 の倍数で 36 と 72 の 2 個、4 と 25 の両方で割り切れる数は 100 の倍数で 100 の 1 個です。',
          'ほかの組み合わせ（たとえば 9 と 25 の公倍数 225）はすべて 100 をこえ、3 つ以上に同時にあてはまる数もありません。',
          '包除原理より、答えは 42 − 2 − 1 = 39 個です。',
        ],
      },
      value: '39', max_digits: 2,
      reference: '平方因數（由小範圍列舉改為補集加排容）',
      notes: '設計依據：既有題在 30 以內直接列舉無平方因數的數，本題把範圍拉到 100 並改問其補集，直接列舉不可行，必須用質數平方的倍數再以排容扣除重疊；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（平方因數・排容）',
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
