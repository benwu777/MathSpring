#!/usr/bin/env ruby
# frozen_string_literal: true

# grade12 補題（2026-08-28）— 同 subtopic 第二題
require 'json'
require 'set'

ROOT = File.expand_path('..', __dir__)
GRADE = 'grade12'
TOPIC_ZH = { 'algebra' => '代數', 'combinatorics' => '組合', 'geometry' => '幾何',
             'logic' => '邏輯', 'number_theory' => '數論' }.freeze
PATHS = TOPIC_ZH.keys.to_h { |t| [t, File.join(ROOT, "assets/questions/#{t}/#{GRADE}_foundation.#{t}.v1.json")] }.freeze
MANIFEST_PATH = File.join(ROOT, 'assets/questions/manifest.json')

def load_json(path) = JSON.parse(File.read(path))
def save_json(path, data) = File.write(path, JSON.pretty_generate(data) + "\n")

def int_q(topic:, subtopic:, subtopic_zh:, prompt:, answer:, steps:, value:, max_digits:, reference:, notes:, display:)
  { 'topic' => topic, 'subtopic' => subtopic, 'difficulty' => 'foundation',
    'levelStage' => GRADE, 'challengeTier' => 'foundation',
    'prompt' => prompt, 'answer' => answer, 'solutionSteps' => steps,
    'figure' => { 'type' => 'custom', 'kind' => 'none', 'params' => {} },
    'answerMode' => 'integer_input',
    'correctAnswer' => { 'type' => 'integer', 'value' => value },
    'inputConstraints' => { 'allowNegative' => false, 'maxDigits' => max_digits },
    'source' => { 'type' => 'rewritten_olympiad_style', 'name' => 'MathSpring 改寫題',
                  'reference' => reference, 'notes' => notes, 'displayText' => display },
    'olympiadTaxonomy' => { 'topic' => TOPIC_ZH[topic], 'topicCode' => topic,
                            'subtopic' => subtopic_zh, 'subtopicCode' => subtopic },
    'reviewStatus' => 'ok' }
end

QUESTIONS = {
  'algebra' => [
    int_q(
      topic: 'algebra', subtopic: 'am_gm_three_terms', subtopic_zh: '三項算幾不等式',
      prompt: {
        'zh-Hant' => '設 x 是正實數，k 是正整數。已知 x³ + k/x 的最小值恰好是 32，求 k 的值。',
        'zh-Hans' => '设 x 是正实数，k 是正整数。已知 x³ + k/x 的最小值恰好是 32，求 k 的值。',
        'en' => 'Let x be a positive real number and k a positive integer. The minimum value of x³ + k/x is exactly 32. Find k.',
        'ja' => 'x を正の実数、k を正の整数とします。x³ + k/x の最小値がちょうど 32 であるとき、k の値を求めなさい。',
      },
      answer: { 'zh-Hant' => '答案是 48。', 'zh-Hans' => '答案是 48。', 'en' => 'The answer is 48.', 'ja' => '答えは 48 です。' },
      steps: {
        'zh-Hant' => [
          '要用算術幾何平均不等式，必須把式子拆成幾個項，使它們的乘積不含 x。',
          '把 k/x 拆成三個相等的 k/(3x)，於是 x³ + k/x = x³ + k/(3x) + k/(3x) + k/(3x)，共四項。',
          '這四項的乘積是 x³ × k³/(27x³) = k³/27，已經與 x 無關，所以由四項算幾不等式得最小值是 4 × ⁴√(k³/27)。',
          '令 4 × ⁴√(k³/27) = 32，得 ⁴√(k³/27) = 8，兩邊四次方得 k³/27 = 4096，也就是 k³ = 110592。',
          '因為 48³ = 110592，所以 k = 48。',
        ],
        'zh-Hans' => [
          '要用算术几何平均不等式，必须把式子拆成几个项，使它们的乘积不含 x。',
          '把 k/x 拆成三个相等的 k/(3x)，于是 x³ + k/x = x³ + k/(3x) + k/(3x) + k/(3x)，共四项。',
          '这四项的乘积是 x³ × k³/(27x³) = k³/27，已经与 x 无关，所以由四项算几不等式得最小值是 4 × ⁴√(k³/27)。',
          '令 4 × ⁴√(k³/27) = 32，得 ⁴√(k³/27) = 8，两边四次方得 k³/27 = 4096，也就是 k³ = 110592。',
          '因为 48³ = 110592，所以 k = 48。',
        ],
        'en' => [
          'To use the arithmetic-geometric mean inequality, the expression must be split into terms whose product is free of x.',
          'Split k/x into three equal parts k/(3x), so that x³ + k/x = x³ + k/(3x) + k/(3x) + k/(3x), four terms in all.',
          'Their product is x³ × k³/(27x³) = k³/27, which no longer involves x, so the four-term inequality gives a minimum of 4 × ⁴√(k³/27).',
          'Setting 4 × ⁴√(k³/27) = 32 gives ⁴√(k³/27) = 8, and raising both sides to the fourth power gives k³/27 = 4096, that is k³ = 110592.',
          'Since 48³ = 110592, we get k = 48.',
        ],
        'ja' => [
          '相加相乗平均の不等式を使うには、積に x が残らないように式をいくつかの項に分ける必要があります。',
          'k/x を等しい 3 つの k/(3x) に分けると、x³ + k/x = x³ + k/(3x) + k/(3x) + k/(3x) の 4 項になります。',
          'この 4 項の積は x³ × k³/(27x³) = k³/27 で x をふくまないので、4 項の不等式より最小値は 4 × ⁴√(k³/27) です。',
          '4 × ⁴√(k³/27) = 32 とおくと ⁴√(k³/27) = 8 となり、4 乗して k³/27 = 4096、つまり k³ = 110592 です。',
          '48³ = 110592 なので k = 48 です。',
        ],
      },
      value: '48', max_digits: 2,
      reference: '算幾不等式（由求最小值改為由最小值逆推係數）',
      notes: '設計依據：既有題直接用拆項後的算幾不等式求最小值，本題把係數設為未知並給定最小值反求，必須先算出含參數的最小值表達式再解方程；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（算幾不等式・逆推係數）',
    ),
    int_q(
      topic: 'algebra', subtopic: 'recurrence_closed_form', subtopic_zh: '遞推數列閉式',
      prompt: {
        'zh-Hant' => '數列 {aₙ} 滿足 a₁ = 2，且對每個正整數 n 都有 aₙ₊₁ = 2aₙ + 1。求最小的正整數 n，使得 aₙ > 1000。',
        'zh-Hans' => '数列 {aₙ} 满足 a₁ = 2，且对每个正整数 n 都有 aₙ₊₁ = 2aₙ + 1。求最小的正整数 n，使得 aₙ > 1000。',
        'en' => 'A sequence {aₙ} satisfies a₁ = 2 and aₙ₊₁ = 2aₙ + 1 for every positive integer n. Find the smallest positive integer n for which aₙ > 1000.',
        'ja' => '数列 {aₙ} は a₁ = 2 を満たし、すべての正の整数 n について aₙ₊₁ = 2aₙ + 1 が成り立ちます。aₙ > 1000 となる最小の正の整数 n を求めなさい。',
      },
      answer: { 'zh-Hant' => '答案是 10。', 'zh-Hans' => '答案是 10。', 'en' => 'The answer is 10.', 'ja' => '答えは 10 です。' },
      steps: {
        'zh-Hant' => [
          '這個遞推式不是單純的等比，但可以用平移把它化成等比：在兩邊各加 1。',
          'aₙ₊₁ + 1 = 2aₙ + 2 = 2(aₙ + 1)，所以數列 {aₙ + 1} 是公比為 2 的等比數列。',
          '首項是 a₁ + 1 = 3，因此 aₙ + 1 = 3 × 2ⁿ⁻¹，也就是 aₙ = 3 × 2ⁿ⁻¹ − 1。',
          '要求 3 × 2ⁿ⁻¹ − 1 > 1000，即 2ⁿ⁻¹ > 1001 ÷ 3，約為 333.7。',
          '因為 2⁸ = 256 不夠、2⁹ = 512 足夠，所以 n − 1 = 9，n = 10。驗算 a₁₀ = 3 × 512 − 1 = 1535 > 1000，而 a₉ = 767 < 1000。',
        ],
        'zh-Hans' => [
          '这个递推式不是单纯的等比，但可以用平移把它化成等比：在两边各加 1。',
          'aₙ₊₁ + 1 = 2aₙ + 2 = 2(aₙ + 1)，所以数列 {aₙ + 1} 是公比为 2 的等比数列。',
          '首项是 a₁ + 1 = 3，因此 aₙ + 1 = 3 × 2ⁿ⁻¹，也就是 aₙ = 3 × 2ⁿ⁻¹ − 1。',
          '要求 3 × 2ⁿ⁻¹ − 1 > 1000，即 2ⁿ⁻¹ > 1001 ÷ 3，约为 333.7。',
          '因为 2⁸ = 256 不够、2⁹ = 512 足够，所以 n − 1 = 9，n = 10。验算 a₁₀ = 3 × 512 − 1 = 1535 > 1000，而 a₉ = 767 < 1000。',
        ],
        'en' => [
          'This recurrence is not purely geometric, but adding 1 to both sides turns it into one.',
          'aₙ₊₁ + 1 = 2aₙ + 2 = 2(aₙ + 1), so the sequence {aₙ + 1} is geometric with ratio 2.',
          'Its first term is a₁ + 1 = 3, so aₙ + 1 = 3 × 2ⁿ⁻¹, that is aₙ = 3 × 2ⁿ⁻¹ − 1.',
          'The condition 3 × 2ⁿ⁻¹ − 1 > 1000 becomes 2ⁿ⁻¹ > 1001 ÷ 3, about 333.7.',
          'Since 2⁸ = 256 is too small and 2⁹ = 512 is enough, n − 1 = 9 and n = 10. Checking, a₁₀ = 3 × 512 − 1 = 1535 > 1000 while a₉ = 767 < 1000.',
        ],
        'ja' => [
          'この漸化式はそのままでは等比ではありませんが、両辺に 1 を加えると等比に直せます。',
          'aₙ₊₁ + 1 = 2aₙ + 2 = 2(aₙ + 1) となるので、数列 {aₙ + 1} は公比 2 の等比数列です。',
          '初項は a₁ + 1 = 3 なので aₙ + 1 = 3 × 2ⁿ⁻¹、すなわち aₙ = 3 × 2ⁿ⁻¹ − 1 です。',
          '3 × 2ⁿ⁻¹ − 1 > 1000 は 2ⁿ⁻¹ > 1001 ÷ 3（約 333.7）と同じです。',
          '2⁸ = 256 では足りず 2⁹ = 512 で足りるので n − 1 = 9、n = 10 です。確かめると a₁₀ = 3 × 512 − 1 = 1535 > 1000、a₉ = 767 < 1000 です。',
        ],
      },
      value: '10', max_digits: 2,
      reference: '遞推數列（由累加型改為線性非齊次型並求最小 n）',
      notes: '設計依據：既有題的遞推是逐項累加、閉式為完全平方，直接代入求某一項；本題改成線性非齊次遞推，必須用平移化成等比才得到閉式，且問的是首次超過門檻的項數；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（遞推・非齊次求最小 n）',
    ),
  ],
  'combinatorics' => [
    int_q(
      topic: 'combinatorics', subtopic: 'catalan_bracket', subtopic_zh: '括號配對',
      prompt: {
        'zh-Hant' => '用 4 個左括號與 4 個右括號排成一列，共 8 個符號。在所有排法之中，有些能正確配對（從左邊數起的任何時刻，已出現的右括號數量都不超過左括號的數量），有些則不能。求不能正確配對的排法共有多少種。',
        'zh-Hans' => '用 4 个左括号与 4 个右括号排成一列，共 8 个符号。在所有排法之中，有些能正确配对（从左边数起的任何时刻，已出现的右括号数量都不超过左括号的数量），有些则不能。求不能正确配对的排法共有多少种。',
        'en' => 'Four left brackets and four right brackets are arranged in a row of 8 symbols. Some arrangements match up correctly, meaning that at every point counting from the left the number of right brackets so far never exceeds the number of left brackets, and some do not. How many arrangements fail to match up correctly?',
        'ja' => '左括弧 4 個と右括弧 4 個を並べて 8 個の記号の列を作ります。並べ方のうち、左から数えてどの時点でも右括弧の個数が左括弧の個数をこえない（正しく対応する）ものと、そうでないものがあります。正しく対応しない並べ方は何通りありますか。',
      },
      answer: { 'zh-Hant' => '答案是 56 種。', 'zh-Hans' => '答案是 56 种。',
                'en' => 'The answer is 56 arrangements.', 'ja' => '答えは 56 通りです。' },
      steps: {
        'zh-Hant' => [
          '先算出所有排法：8 個位置中選 4 個放左括號，其餘放右括號，共有 (8 × 7 × 6 × 5) ÷ (4 × 3 × 2 × 1) = 70 種。',
          '接著算出能正確配對的排法數。可以逐步列舉：把左括號記為 +1、右括號記為 −1，要求所有前綴和都非負。',
          '依序統計會得到 14 種正確配對的排法（這正是 4 對括號的卡特蘭數）。',
          '不能正確配對的排法就是全部排法扣掉能正確配對的排法。',
          '所以答案是 70 − 14 = 56 種。',
        ],
        'zh-Hans' => [
          '先算出所有排法：8 个位置中选 4 个放左括号，其余放右括号，共有 (8 × 7 × 6 × 5) ÷ (4 × 3 × 2 × 1) = 70 种。',
          '接着算出能正确配对的排法数。可以逐步列举：把左括号记为 +1、右括号记为 −1，要求所有前缀和都非负。',
          '依次统计会得到 14 种正确配对的排法（这正是 4 对括号的卡特兰数）。',
          '不能正确配对的排法就是全部排法扣掉能正确配对的排法。',
          '所以答案是 70 − 14 = 56 种。',
        ],
        'en' => [
          'First count all arrangements: choosing 4 of the 8 positions for the left brackets gives (8 × 7 × 6 × 5) ÷ (4 × 3 × 2 × 1) = 70.',
          'Next count the arrangements that do match up. Write +1 for a left bracket and −1 for a right one; the requirement is that every prefix sum is non-negative.',
          'Counting these systematically gives 14 correctly matching arrangements, which is the Catalan number for 4 pairs of brackets.',
          'The arrangements that fail are all arrangements minus those that match.',
          'So the answer is 70 − 14 = 56.',
        ],
        'ja' => [
          'まずすべての並べ方を数えます。8 か所から左括弧の位置 4 か所を選べばよいので (8 × 7 × 6 × 5) ÷ (4 × 3 × 2 × 1) = 70 通りです。',
          '次に正しく対応する並べ方を数えます。左括弧を +1、右括弧を −1 とすると、どの先頭部分の和も 0 以上であることが条件です。',
          '順に数えると正しく対応するものは 14 通りで、これは 4 組の括弧のカタラン数にあたります。',
          '正しく対応しない並べ方は、全体から正しく対応するものを引いたものです。',
          'したがって答えは 70 − 14 = 56 通りです。',
        ],
      },
      value: '56', max_digits: 2,
      reference: '括號配對（由數合法排法改為數不合法排法）',
      notes: '設計依據：既有題直接數能正確配對的排法（卡特蘭數），本題改問不能配對的排法數，必須先算出不受限制的總排法再取補集，多了一層計數；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（括號・補集計數）',
    ),
    int_q(
      topic: 'combinatorics', subtopic: 'spanning_trees_complete_graph', subtopic_zh: '連通四個點的樹',
      prompt: {
        'zh-Hant' => '有 4 個互相標號的點，任兩點之間都可以選擇連線或不連線。若只要求四個點全部連通（可以有迴路，線段數不限），求這樣的連線方式共有多少種。',
        'zh-Hans' => '有 4 个互相标号的点，任两点之间都可以选择连线或不连线。若只要求四个点全部连通（可以有回路，线段数不限），求这样的连线方式共有多少种。',
        'en' => 'Four labelled points are given, and each pair may either be joined by a segment or not. If the only requirement is that all four points are connected, with cycles allowed and no restriction on the number of segments, how many such configurations are there?',
        'ja' => '互いに区別できる 4 つの点があり、どの 2 点も線で結ぶか結ばないかを選べます。4 点すべてがつながっていること（閉路があってもよく、線の本数に制限はない）だけを条件とするとき、そのような結び方は何通りありますか。',
      },
      answer: { 'zh-Hant' => '答案是 38 種。', 'zh-Hans' => '答案是 38 种。',
                'en' => 'The answer is 38 configurations.', 'ja' => '答えは 38 通りです。' },
      steps: {
        'zh-Hant' => [
          '4 個點之間共有 (4 × 3) ÷ 2 = 6 條可能的線段，每條可連可不連，所以全部圖形共有 2⁶ = 64 種。',
          '直接數連通的圖不容易，改成先數不連通的圖，再從 64 扣掉。把不連通的圖依「含某個固定點（記為甲）的那一團有幾個點」分類，這樣每個圖恰好被算一次。',
          '甲自成一團（1 點）：甲不連任何線，其餘 3 點之間的 3 條線任意連，有 2³ = 8 種。',
          '甲那團有 2 點：選甲的同伴有 3 種，兩點之間必須相連（1 種），且不能連到外面；剩下 2 點之間的 1 條線任意連，有 2 種，合計 3 × 1 × 2 = 6 種。',
          '甲那團有 3 點：選同伴有 3 種，這 3 點必須自成連通圖（3 點的連通圖有 4 種：一個三角形與三條路徑），第 4 點孤立，合計 3 × 4 = 12 種。因此不連通的圖有 8 + 6 + 12 = 26 種，連通的圖有 64 − 26 = 38 種。',
        ],
        'zh-Hans' => [
          '4 个点之间共有 (4 × 3) ÷ 2 = 6 条可能的线段，每条可连可不连，所以全部图形共有 2⁶ = 64 种。',
          '直接数连通的图不容易，改成先数不连通的图，再从 64 扣掉。把不连通的图依「含某个固定点（记为甲）的那一团有几个点」分类，这样每个图恰好被算一次。',
          '甲自成一团（1 点）：甲不连任何线，其余 3 点之间的 3 条线任意连，有 2³ = 8 种。',
          '甲那团有 2 点：选甲的同伴有 3 种，两点之间必须相连（1 种），且不能连到外面；剩下 2 点之间的 1 条线任意连，有 2 种，合计 3 × 1 × 2 = 6 种。',
          '甲那团有 3 点：选同伴有 3 种，这 3 点必须自成连通图（3 点的连通图有 4 种：一个三角形与三条路径），第 4 点孤立，合计 3 × 4 = 12 种。因此不连通的图有 8 + 6 + 12 = 26 种，连通的图有 64 − 26 = 38 种。',
        ],
        'en' => [
          'There are (4 × 3) ÷ 2 = 6 possible segments among the 4 points, each present or absent, so there are 2⁶ = 64 configurations in all.',
          'Counting connected ones directly is awkward, so count the disconnected ones and subtract from 64. Classify a disconnected configuration by the size of the group containing one fixed point, call it A; this counts every configuration exactly once.',
          'A alone (group of 1): A has no segments, and the 3 segments among the other 3 points are free, giving 2³ = 8.',
          'A's group has 2 points: the partner can be chosen in 3 ways, that pair must be joined (1 way) with no segment leaving the group, and the single segment between the remaining 2 points is free, giving 3 × 1 × 2 = 6.',
          'A's group has 3 points: the two companions can be chosen in 3 ways, those 3 points must form a connected graph (there are 4 such: one triangle and three paths), and the 4th point is isolated, giving 3 × 4 = 12. So there are 8 + 6 + 12 = 26 disconnected configurations and 64 − 26 = 38 connected ones.',
        ],
        'ja' => [
          '4 点の間に引ける線は (4 × 3) ÷ 2 = 6 本あり、それぞれ引くか引かないかなので、図形は全部で 2⁶ = 64 通りです。',
          'つながっている図を直接数えるのは大変なので、つながっていない図を数えて 64 から引きます。つながっていない図を「ある固定した点（甲とする）をふくむかたまりの点の個数」で分類すると、各図はちょうど 1 回ずつ数えられます。',
          '甲が 1 点だけのかたまり：甲には線がなく、残り 3 点の間の 3 本は自由なので 2³ = 8 通りです。',
          '甲のかたまりが 2 点：相手の選び方が 3 通り、その 2 点は必ず結ばれ（1 通り）外へは線が出ず、残り 2 点の間の 1 本は自由で 2 通りなので、合わせて 3 × 1 × 2 = 6 通りです。',
          '甲のかたまりが 3 点：相手 2 点の選び方が 3 通り、その 3 点は連結でなければならず（3 点の連結グラフは三角形 1 つと道 3 つの計 4 通り）、4 点目は孤立するので 3 × 4 = 12 通りです。よってつながっていない図は 8 + 6 + 12 = 26 通り、つながっている図は 64 − 26 = 38 通りです。',
        ],
      },
      value: '38', max_digits: 2,
      reference: '四點的圖（由樹的計數改為連通圖的計數）',
      notes: '設計依據：既有題要求恰好用 3 條線且無迴路，是生成樹計數；本題放寬為只要連通、允許迴路與任意線數，必須改用總數扣除不連通情形的補集與排容，計數技巧完全不同；已用程式列舉 6 條邊的所有 64 種子集驗證連通者為 38；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（四點・連通圖計數）',
    ),
  ],
  'geometry' => [
    int_q(
      topic: 'geometry', subtopic: 'heron_area', subtopic_zh: '海龍公式',
      prompt: {
        'zh-Hant' => '一塊三角形的土地，三邊長分別是 6 公尺、25 公尺、29 公尺。求這個三角形內切圓的半徑是幾公尺。',
        'zh-Hans' => '一块三角形的土地，三边长分别是 6 米、25 米、29 米。求这个三角形内切圆的半径是几米。',
        'en' => 'A triangular plot of land has sides of 6 metres, 25 metres and 29 metres. Find the radius of its inscribed circle, in metres.',
        'ja' => '三角形の土地の 3 辺の長さは 6 m、25 m、29 m です。この三角形の内接円の半径は何メートルですか。',
      },
      answer: { 'zh-Hant' => '答案是 2 公尺。', 'zh-Hans' => '答案是 2 米。',
                'en' => 'The answer is 2 metres.', 'ja' => '答えは 2 メートルです。' },
      steps: {
        'zh-Hant' => [
          '先用海龍公式求面積。半周長是 s = (6 + 25 + 29) ÷ 2 = 30。',
          '面積是 √[30 × (30 − 6) × (30 − 25) × (30 − 29)] = √(30 × 24 × 5 × 1) = √3600 = 60 平方公尺。',
          '把內心與三個頂點連起來，三角形被分成三個小三角形，它們的高都是內切圓半徑 r，底分別是三角形的三邊。',
          '所以面積也等於 r × (6 + 25 + 29) ÷ 2 = r × s = 30r。',
          '令 30r = 60，得 r = 2，內切圓半徑是 2 公尺。',
        ],
        'zh-Hans' => [
          '先用海伦公式求面积。半周长是 s = (6 + 25 + 29) ÷ 2 = 30。',
          '面积是 √[30 × (30 − 6) × (30 − 25) × (30 − 29)] = √(30 × 24 × 5 × 1) = √3600 = 60 平方米。',
          '把内心与三个顶点连起来，三角形被分成三个小三角形，它们的高都是内切圆半径 r，底分别是三角形的三边。',
          '所以面积也等于 r × (6 + 25 + 29) ÷ 2 = r × s = 30r。',
          '令 30r = 60，得 r = 2，内切圆半径是 2 米。',
        ],
        'en' => [
          'First find the area by Heron\'s formula. The semi-perimeter is s = (6 + 25 + 29) ÷ 2 = 30.',
          'The area is √[30 × (30 − 6) × (30 − 25) × (30 − 29)] = √(30 × 24 × 5 × 1) = √3600 = 60 square metres.',
          'Joining the incentre to the three vertices splits the triangle into three smaller triangles, each of height equal to the inradius r and with the three sides as bases.',
          'So the area also equals r × (6 + 25 + 29) ÷ 2 = r × s = 30r.',
          'Setting 30r = 60 gives r = 2, so the inscribed circle has radius 2 metres.',
        ],
        'ja' => [
          'まずヘロンの公式で面積を求めます。半周は s = (6 + 25 + 29) ÷ 2 = 30 です。',
          '面積は √[30 × (30 − 6) × (30 − 25) × (30 − 29)] = √(30 × 24 × 5 × 1) = √3600 = 60 平方メートルです。',
          '内心と 3 頂点を結ぶと三角形は 3 つの小さい三角形に分かれ、どれも高さは内接円の半径 r、底辺はもとの三角形の各辺です。',
          'したがって面積は r × (6 + 25 + 29) ÷ 2 = r × s = 30r とも表せます。',
          '30r = 60 より r = 2 となり、内接円の半径は 2 メートルです。',
        ],
      },
      value: '2', max_digits: 1,
      reference: '海龍公式（由求面積改為求內切圓半徑）',
      notes: '設計依據：既有題三邊已知直接用海龍公式求面積，本題再往前一步求內切圓半徑，必須額外用上「面積等於內切圓半徑乘以半周長」這個關係；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（海龍・內切圓半徑）',
    ),
    int_q(
      topic: 'geometry', subtopic: 'ptolemy_theorem', subtopic_zh: '托勒密定理',
      prompt: {
        'zh-Hant' => '圓內接四邊形 ABCD 的四邊長依序是 AB = 3、BC = 4、CD = 5、DA = 6。已知兩條對角線的長度比 AC : BD 可以寫成 m : n，其中 m、n 是互質的正整數。求 m + n 的值。',
        'zh-Hans' => '圆内接四边形 ABCD 的四边长依序是 AB = 3、BC = 4、CD = 5、DA = 6。已知两条对角线的长度比 AC : BD 可以写成 m : n，其中 m、n 是互质的正整数。求 m + n 的值。',
        'en' => 'A cyclic quadrilateral ABCD has sides AB = 3, BC = 4, CD = 5 and DA = 6 in order. The ratio of the diagonals AC : BD can be written as m : n with m and n coprime positive integers. Find m + n.',
        'ja' => '円に内接する四角形 ABCD の辺の長さは順に AB = 3、BC = 4、CD = 5、DA = 6 です。2 本の対角線の長さの比 AC : BD が互いに素な正の整数 m、n を用いて m : n と書けるとき、m + n の値を求めなさい。',
      },
      answer: { 'zh-Hant' => '答案是 40。', 'zh-Hans' => '答案是 40。', 'en' => 'The answer is 40.', 'ja' => '答えは 40 です。' },
      steps: {
        'zh-Hant' => [
          '托勒密定理給出兩對角線的乘積，但要得到它們的比值，需要用到托勒密定理的比值形式。',
          '對圓內接四邊形 ABCD，成立 AC : BD = (AB × AD + CB × CD) : (BA × BC + DA × DC)。',
          '代入邊長，分子是 3 × 6 + 4 × 5 = 18 + 20 = 38。',
          '分母是 3 × 4 + 6 × 5 = 12 + 30 = 42。',
          '所以 AC : BD = 38 : 42 = 19 : 21，兩數互質，因此 m + n = 19 + 21 = 40。',
        ],
        'zh-Hans' => [
          '托勒密定理给出两对角线的乘积，但要得到它们的比值，需要用到托勒密定理的比值形式。',
          '对圆内接四边形 ABCD，成立 AC : BD = (AB × AD + CB × CD) : (BA × BC + DA × DC)。',
          '代入边长，分子是 3 × 6 + 4 × 5 = 18 + 20 = 38。',
          '分母是 3 × 4 + 6 × 5 = 12 + 30 = 42。',
          '所以 AC : BD = 38 : 42 = 19 : 21，两数互质，因此 m + n = 19 + 21 = 40。',
        ],
        'en' => [
          'Ptolemy\'s theorem gives the product of the diagonals, but obtaining their ratio requires the ratio form of the theorem.',
          'For a cyclic quadrilateral ABCD, AC : BD = (AB × AD + CB × CD) : (BA × BC + DA × DC).',
          'Substituting the side lengths, the first part is 3 × 6 + 4 × 5 = 18 + 20 = 38.',
          'The second part is 3 × 4 + 6 × 5 = 12 + 30 = 42.',
          'So AC : BD = 38 : 42 = 19 : 21, and these are coprime, giving m + n = 19 + 21 = 40.',
        ],
        'ja' => [
          'トレミーの定理は対角線の積を与えますが、比を求めるには定理の比の形を使う必要があります。',
          '円に内接する四角形 ABCD について、AC : BD = (AB × AD + CB × CD) : (BA × BC + DA × DC) が成り立ちます。',
          '辺の長さを代入すると、前半は 3 × 6 + 4 × 5 = 18 + 20 = 38 です。',
          '後半は 3 × 4 + 6 × 5 = 12 + 30 = 42 です。',
          'よって AC : BD = 38 : 42 = 19 : 21 となり、互いに素なので m + n = 19 + 21 = 40 です。',
        ],
      },
      value: '40', max_digits: 2,
      reference: '托勒密定理（由乘積形式改為比值形式）',
      notes: '設計依據：既有題用托勒密定理求兩對角線的乘積，本題改求兩者的比，必須改用托勒密定理的比值形式（第二托勒密定理），是不同的工具；已用座標計算驗證 AC : BD 確為 19 : 21；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（托勒密・比值形式）',
    ),
  ],
  'logic' => [
    int_q(
      topic: 'logic', subtopic: 'egg_drop_two', subtopic_zh: '兩顆蛋的測試',
      prompt: {
        'zh-Hant' => '一棟大樓有若干層，存在一個臨界樓層 F，使得從第 F 層以上（含 F 層）往下丟蛋一定會破，從 F 層以下丟則一定不破。現在手上只有 2 顆完全相同的蛋，蛋沒破可以重複使用，破了就不能再用。已知在最壞情況下最多只丟 10 次，就一定能保證找出臨界樓層 F。求這棟大樓最多可以有幾層。',
        'zh-Hans' => '一栋大楼有若干层，存在一个临界楼层 F，使得从第 F 层以上（含 F 层）往下丢蛋一定会破，从 F 层以下丢则一定不破。现在手上只有 2 颗完全相同的蛋，蛋没破可以重复使用，破了就不能再用。已知在最坏情况下最多只丢 10 次，就一定能保证找出临界楼层 F。求这栋大楼最多可以有几层。',
        'en' => 'A building has some number of floors, and there is a critical floor F such that an egg dropped from floor F or above always breaks while one dropped from below F never does. Only 2 identical eggs are available; an unbroken egg may be reused, a broken one may not. It is known that 10 drops in the worst case are always enough to determine F. At most how many floors can the building have?',
        'ja' => 'ある建物に何階かあり、ある臨界階 F が存在して、F 階以上から卵を落とすと必ず割れ、F 階より下から落とすと決して割れません。手元には同じ卵が 2 個だけあり、割れていない卵は再利用でき、割れた卵は使えません。最悪の場合でも 10 回落とせば必ず F を特定できるとわかっているとき、この建物は最大で何階まであり得ますか。',
      },
      answer: { 'zh-Hant' => '答案是 55 層。', 'zh-Hans' => '答案是 55 层。',
                'en' => 'The answer is 55 floors.', 'ja' => '答えは 55 階です。' },
      steps: {
        'zh-Hant' => [
          '第一顆蛋負責大跨距地縮小範圍，一旦破了，第二顆蛋就只能從斷點下方逐層往上試。',
          '設第一次從第 k 層丟。若破了，剩下 9 次要逐層檢查下方的 k − 1 層，所以 k − 1 ≤ 9，第一步最多從第 10 層丟。',
          '若沒破，第二次要往上跳的距離必須再少 1，也就是 9 層，因為之後只剩 8 次逐層檢查；以此類推，每次的跨距依序是 10、9、8、⋯、1。',
          '所以能覆蓋的最高樓層是這些跨距的總和：10 + 9 + 8 + ⋯ + 1。',
          '這個和是 10 × 11 ÷ 2 = 55，所以大樓最多可以有 55 層。',
        ],
        'zh-Hans' => [
          '第一颗蛋负责大跨距地缩小范围，一旦破了，第二颗蛋就只能从断点下方逐层往上试。',
          '设第一次从第 k 层丢。若破了，剩下 9 次要逐层检查下方的 k − 1 层，所以 k − 1 ≤ 9，第一步最多从第 10 层丢。',
          '若没破，第二次要往上跳的距离必须再少 1，也就是 9 层，因为之后只剩 8 次逐层检查；以此类推，每次的跨距依次是 10、9、8、⋯、1。',
          '所以能覆盖的最高楼层是这些跨距的总和：10 + 9 + 8 + ⋯ + 1。',
          '这个和是 10 × 11 ÷ 2 = 55，所以大楼最多可以有 55 层。',
        ],
        'en' => [
          'The first egg is used to cut the range down in large jumps; once it breaks, the second egg must be tried floor by floor upward from the last safe floor.',
          'Suppose the first drop is from floor k. If it breaks, the remaining 9 drops must check the k − 1 floors below one at a time, so k − 1 ≤ 9 and the first drop is from floor 10 at most.',
          'If it does not break, the next jump must be one smaller, namely 9 floors, since only 8 single-floor checks would remain afterwards, and so on, giving jumps of 10, 9, 8, …, 1.',
          'The highest floor that can be covered is therefore the total of these jumps: 10 + 9 + 8 + ⋯ + 1.',
          'That sum is 10 × 11 ÷ 2 = 55, so the building can have at most 55 floors.',
        ],
        'ja' => [
          '1 個目の卵で大きく間隔をとって範囲をせばめ、割れたら 2 個目で安全な階から 1 階ずつ上へ確かめます。',
          '最初に k 階から落とすとします。割れた場合、残り 9 回で下の k − 1 階を 1 階ずつ調べる必要があるので k − 1 ≤ 9、つまり最初は最大でも 10 階からです。',
          '割れなければ次の上げ幅は 1 つ小さい 9 階でなければなりません。その後 1 階ずつ調べる回数が 8 回しか残らないからです。以下同様に、間隔は 10、9、8、⋯、1 となります。',
          'したがってカバーできる最高階はこれらの間隔の合計 10 + 9 + 8 + ⋯ + 1 です。',
          'この和は 10 × 11 ÷ 2 = 55 なので、建物は最大で 55 階です。',
        ],
      },
      value: '55', max_digits: 2,
      reference: '兩顆蛋的測試（由給樓層數求次數改為給次數逆推樓層數）',
      notes: '設計依據：既有題給定 100 層求最壞情況的最少丟擲次數，本題反過來由允許的次數上限反求可涵蓋的最大樓層數，必須看出遞減跨距的總和恰為三角形數；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（丟蛋・逆推樓層數）',
    ),
    int_q(
      topic: 'logic', subtopic: 'euler_planar_faces', subtopic_zh: '平面圖的面數',
      prompt: {
        'zh-Hant' => '在紙上畫一個連通的平面圖（任兩條線除端點外都不交叉），它把紙面分割成 12 個區域（包含最外圍那個無界的區域）。已知圖中每個點都恰好連出 3 條線。求這個圖有幾個點。',
        'zh-Hans' => '在纸上画一个连通的平面图（任两条线除端点外都不交叉），它把纸面分割成 12 个区域（包含最外围那个无界的区域）。已知图中每个点都恰好连出 3 条线。求这个图有几个点。',
        'en' => 'A connected planar graph is drawn on paper, with no two edges crossing except at endpoints, dividing the plane into 12 regions including the unbounded outer one. Every vertex of the graph has exactly 3 edges leaving it. How many vertices does the graph have?',
        'ja' => '紙の上に連結な平面グラフ（辺は端点以外で交わらない）を描くと、紙面が外側の無限に広がる領域をふくめて 12 個の領域に分かれました。どの頂点からもちょうど 3 本の辺が出ているとき、この図の頂点は何個ありますか。',
      },
      answer: { 'zh-Hant' => '答案是 20 個。', 'zh-Hans' => '答案是 20 个。',
                'en' => 'The answer is 20 vertices.', 'ja' => '答えは 20 個です。' },
      steps: {
        'zh-Hant' => [
          '設點數是 V、線數是 E、區域數是 F。連通平面圖滿足歐拉公式 V − E + F = 2。',
          '題目說 F = 12，代入得 V − E + 12 = 2，也就是 V − E = −10。',
          '另一方面，把每個點連出的線數全部加起來會等於線數的 2 倍（每條線有兩個端點）。',
          '每個點都恰好連出 3 條線，所以 3V = 2E，也就是 E = 3V ÷ 2。',
          '代回 V − 3V ÷ 2 = −10，得 −V ÷ 2 = −10，所以 V = 20。',
        ],
        'zh-Hans' => [
          '设点数是 V、线数是 E、区域数是 F。连通平面图满足欧拉公式 V − E + F = 2。',
          '题目说 F = 12，代入得 V − E + 12 = 2，也就是 V − E = −10。',
          '另一方面，把每个点连出的线数全部加起来会等于线数的 2 倍（每条线有两个端点）。',
          '每个点都恰好连出 3 条线，所以 3V = 2E，也就是 E = 3V ÷ 2。',
          '代回 V − 3V ÷ 2 = −10，得 −V ÷ 2 = −10，所以 V = 20。',
        ],
        'en' => [
          'Let V be the number of vertices, E the number of edges and F the number of regions. A connected planar graph satisfies Euler\'s formula V − E + F = 2.',
          'Here F = 12, so V − E + 12 = 2, that is V − E = −10.',
          'Separately, adding up the number of edges at every vertex gives twice the number of edges, since each edge has two endpoints.',
          'Every vertex has exactly 3 edges, so 3V = 2E, that is E = 3V ÷ 2.',
          'Substituting back, V − 3V ÷ 2 = −10 gives −V ÷ 2 = −10, so V = 20.',
        ],
        'ja' => [
          '頂点数を V、辺数を E、領域数を F とします。連結な平面グラフではオイラーの公式 V − E + F = 2 が成り立ちます。',
          'ここで F = 12 なので V − E + 12 = 2、つまり V − E = −10 です。',
          '一方、各頂点から出る辺の数をすべてたすと辺数の 2 倍になります。どの辺にも端点が 2 つあるからです。',
          'どの頂点からもちょうど 3 本出ているので 3V = 2E、すなわち E = 3V ÷ 2 です。',
          '代入すると V − 3V ÷ 2 = −10 となり、−V ÷ 2 = −10 より V = 20 です。',
        ],
      },
      value: '20', max_digits: 2,
      reference: '歐拉公式（由給點邊求面改為給面與度數逆推點數）',
      notes: '設計依據：既有題給定點數與線數直接用歐拉公式求區域數，本題改給區域數並加上「每點度數為 3」的條件反求點數，必須把歐拉公式與握手引理聯立；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（歐拉公式・逆推點數）',
    ),
  ],
  'number_theory' => [
    int_q(
      topic: 'number_theory', subtopic: 'legendre_exponent', subtopic_zh: '階乘中的質因數次方',
      prompt: {
        'zh-Hant' => '求最小的正整數 n，使得 n! 能被 3¹⁰ 整除。（n! 表示 1 × 2 × ⋯ × n）',
        'zh-Hans' => '求最小的正整数 n，使得 n! 能被 3¹⁰ 整除。（n! 表示 1 × 2 × ⋯ × n）',
        'en' => 'Find the smallest positive integer n such that n! is divisible by 3¹⁰. (Here n! means 1 × 2 × ⋯ × n.)',
        'ja' => 'n! が 3¹⁰ でわり切れるような最小の正の整数 n を求めなさい。（n! は 1 × 2 × ⋯ × n を表します。）',
      },
      answer: { 'zh-Hant' => '答案是 24。', 'zh-Hans' => '答案是 24。', 'en' => 'The answer is 24.', 'ja' => '答えは 24 です。' },
      steps: {
        'zh-Hant' => [
          'n! 中質因數 3 的總次方數，等於 n 除以 3、除以 9、除以 27⋯ 後各取整數部分再相加。',
          '要讓 3¹⁰ 整除 n!，就要這個總次方數至少是 10。',
          '試 n = 23：23 ÷ 3 取整數是 7，23 ÷ 9 取整數是 2，23 ÷ 27 取整數是 0，合計 7 + 2 = 9，還不夠。',
          '試 n = 24：24 ÷ 3 取整數是 8，24 ÷ 9 取整數是 2，24 ÷ 27 取整數是 0，合計 8 + 2 = 10，剛好足夠。',
          '因為次方數隨 n 遞增不減，24 是第一個達標的，所以最小的 n 是 24。',
        ],
        'zh-Hans' => [
          'n! 中质因数 3 的总次方数，等于 n 除以 3、除以 9、除以 27⋯ 后各取整数部分再相加。',
          '要让 3¹⁰ 整除 n!，就要这个总次方数至少是 10。',
          '试 n = 23：23 ÷ 3 取整数是 7，23 ÷ 9 取整数是 2，23 ÷ 27 取整数是 0，合计 7 + 2 = 9，还不够。',
          '试 n = 24：24 ÷ 3 取整数是 8，24 ÷ 9 取整数是 2，24 ÷ 27 取整数是 0，合计 8 + 2 = 10，刚好足够。',
          '因为次方数随 n 递增不减，24 是第一个达标的，所以最小的 n 是 24。',
        ],
        'en' => [
          'The exponent of the prime 3 in n! is obtained by dividing n by 3, then by 9, then by 27, taking whole parts and adding them.',
          'For 3¹⁰ to divide n!, this exponent must be at least 10.',
          'Try n = 23: the whole part of 23 ÷ 3 is 7, of 23 ÷ 9 is 2 and of 23 ÷ 27 is 0, giving 7 + 2 = 9, which is not enough.',
          'Try n = 24: the whole part of 24 ÷ 3 is 8, of 24 ÷ 9 is 2 and of 24 ÷ 27 is 0, giving 8 + 2 = 10, which is just enough.',
          'Since the exponent never decreases as n grows, 24 is the first value that works, so the smallest n is 24.',
        ],
        'ja' => [
          'n! にふくまれる素因数 3 の指数は、n を 3、9、27⋯ でわって整数部分をとり、それらをたすことで求められます。',
          '3¹⁰ が n! をわり切るには、この指数が 10 以上である必要があります。',
          'n = 23 を試すと、23 ÷ 3 の整数部分は 7、23 ÷ 9 は 2、23 ÷ 27 は 0 で、合計 7 + 2 = 9 となり足りません。',
          'n = 24 を試すと、24 ÷ 3 の整数部分は 8、24 ÷ 9 は 2、24 ÷ 27 は 0 で、合計 8 + 2 = 10 となりちょうど足ります。',
          '指数は n が増えても減らないので、24 が最初に条件を満たす値であり、最小の n は 24 です。',
        ],
      },
      value: '24', max_digits: 2,
      reference: '階乘的質因數次方（由求次方數改為逆推最小的 n）',
      notes: '設計依據：既有題給定 100! 直接求質因數 3 的最高次方，本題反過來給定所需次方數求最小的 n，必須逐一試算並確認前一個值不足；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（階乘質因數・逆推 n）',
    ),
    int_q(
      topic: 'number_theory', subtopic: 'wilson_theorem', subtopic_zh: '階乘的質數餘數',
      prompt: {
        'zh-Hant' => '求 15! 除以 17 的餘數。（n! 表示 1 × 2 × ⋯ × n）',
        'zh-Hans' => '求 15! 除以 17 的余数。（n! 表示 1 × 2 × ⋯ × n）',
        'en' => 'Find the remainder when 15! is divided by 17. (Here n! means 1 × 2 × ⋯ × n.)',
        'ja' => '15! を 17 でわった余りを求めなさい。（n! は 1 × 2 × ⋯ × n を表します。）',
      },
      answer: { 'zh-Hant' => '答案是 1。', 'zh-Hans' => '答案是 1。', 'en' => 'The answer is 1.', 'ja' => '答えは 1 です。' },
      steps: {
        'zh-Hant' => [
          '17 是質數，由威爾遜定理，16! 除以 17 的餘數是 16，也就是 16! ≡ −1（mod 17）。',
          '本題要的是 15!，所以要把 16! 中的 16 分離出來：16! = 16 × 15!。',
          '在模 17 之下，16 ≡ −1，所以 16! ≡ (−1) × 15!（mod 17）。',
          '把兩式合起來得 (−1) × 15! ≡ −1（mod 17），兩邊同乘以 −1 得 15! ≡ 1（mod 17）。',
          '所以 15! 除以 17 的餘數是 1。',
        ],
        'zh-Hans' => [
          '17 是质数，由威尔逊定理，16! 除以 17 的余数是 16，也就是 16! ≡ −1（mod 17）。',
          '本题要的是 15!，所以要把 16! 中的 16 分离出来：16! = 16 × 15!。',
          '在模 17 之下，16 ≡ −1，所以 16! ≡ (−1) × 15!（mod 17）。',
          '把两式合起来得 (−1) × 15! ≡ −1（mod 17），两边同乘以 −1 得 15! ≡ 1（mod 17）。',
          '所以 15! 除以 17 的余数是 1。',
        ],
        'en' => [
          'Since 17 is prime, Wilson\'s theorem gives that 16! leaves remainder 16 on division by 17, that is 16! ≡ −1 (mod 17).',
          'The question asks about 15!, so separate the factor 16 out of 16!: we have 16! = 16 × 15!.',
          'Modulo 17 we have 16 ≡ −1, so 16! ≡ (−1) × 15! (mod 17).',
          'Combining the two facts gives (−1) × 15! ≡ −1 (mod 17), and multiplying both sides by −1 gives 15! ≡ 1 (mod 17).',
          'So the remainder when 15! is divided by 17 is 1.',
        ],
        'ja' => [
          '17 は素数なので、ウィルソンの定理より 16! を 17 でわった余りは 16、すなわち 16! ≡ −1（mod 17）です。',
          '求めたいのは 15! なので、16! から 16 を分けます。16! = 16 × 15! です。',
          '17 を法とすると 16 ≡ −1 なので、16! ≡ (−1) × 15!（mod 17）となります。',
          '2 つを合わせると (−1) × 15! ≡ −1（mod 17）となり、両辺に −1 をかけて 15! ≡ 1（mod 17）が得られます。',
          'したがって 15! を 17 でわった余りは 1 です。',
        ],
      },
      value: '1', max_digits: 1,
      reference: '威爾遜定理（由直接套用改為多退一步）',
      notes: '設計依據：既有題求 (p−1)! 的餘數，正是威爾遜定理的原形；本題求 (p−2)!，必須先把 (p−1)! 拆成 (p−1) × (p−2)! 並用 p−1 ≡ −1 才能推得，多一層轉換；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（威爾遜・退一步）',
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
