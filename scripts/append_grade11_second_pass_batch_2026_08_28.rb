#!/usr/bin/env ruby
# frozen_string_literal: true

# grade11 補題（2026-08-28）— 同 subtopic 第二題
require 'json'
require 'set'

ROOT = File.expand_path('..', __dir__)
GRADE = 'grade11'
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
      topic: 'algebra', subtopic: 'infinite_geometric_series', subtopic_zh: '無窮等比級數',
      prompt: {
        'zh-Hant' => '一個無窮等比級數的首項是 6、公比是 1/2。把它的第 1 項、第 3 項、第 5 項、⋯（也就是所有奇數項）取出來，這些項本身也構成一個無窮等比級數。求這個新級數的和。',
        'zh-Hans' => '一个无穷等比级数的首项是 6、公比是 1/2。把它的第 1 项、第 3 项、第 5 项、⋯（也就是所有奇数项）取出来，这些项本身也构成一个无穷等比级数。求这个新级数的和。',
        'en' => 'An infinite geometric series has first term 6 and common ratio 1/2. Taking its 1st, 3rd, 5th, … terms, that is all the odd-numbered terms, gives another infinite geometric series. Find the sum of this new series.',
        'ja' => '初項 6、公比 1/2 の無限等比級数があります。その第 1 項、第 3 項、第 5 項、⋯（つまり奇数番目の項）だけを取り出すと、それ自体も無限等比級数になります。この新しい級数の和を求めなさい。',
      },
      answer: { 'zh-Hant' => '答案是 8。', 'zh-Hans' => '答案是 8。', 'en' => 'The answer is 8.', 'ja' => '答えは 8 です。' },
      steps: {
        'zh-Hant' => [
          '原級數的第 1 項是 6，第 3 項是 6 × (1/2)²，第 5 項是 6 × (1/2)⁴，每次指數增加 2。',
          '所以取出來的奇數項本身也是等比級數，首項仍是 6，但公比變成原公比的平方，也就是 (1/2)² = 1/4。',
          '公比 1/4 的絕對值小於 1，可以用無窮等比級數的和公式：首項除以 1 減公比。',
          '所以新級數的和是 6 ÷ (1 − 1/4) = 6 ÷ (3/4) = 8。',
        ],
        'zh-Hans' => [
          '原级数的第 1 项是 6，第 3 项是 6 × (1/2)²，第 5 项是 6 × (1/2)⁴，每次指数增加 2。',
          '所以取出来的奇数项本身也是等比级数，首项仍是 6，但公比变成原公比的平方，也就是 (1/2)² = 1/4。',
          '公比 1/4 的绝对值小于 1，可以用无穷等比级数的和公式：首项除以 1 减公比。',
          '所以新级数的和是 6 ÷ (1 − 1/4) = 6 ÷ (3/4) = 8。',
        ],
        'en' => [
          'The 1st term of the original series is 6, the 3rd is 6 × (1/2)² and the 5th is 6 × (1/2)⁴, the exponent rising by 2 each time.',
          'So the odd-numbered terms themselves form a geometric series with the same first term 6, but with ratio equal to the square of the original ratio, namely (1/2)² = 1/4.',
          'Since |1/4| < 1, the sum formula for an infinite geometric series applies: first term divided by 1 minus the ratio.',
          'The new series therefore sums to 6 ÷ (1 − 1/4) = 6 ÷ (3/4) = 8.',
        ],
        'ja' => [
          'もとの級数の第 1 項は 6、第 3 項は 6 × (1/2)²、第 5 項は 6 × (1/2)⁴ で、指数が 2 ずつ増えます。',
          'したがって取り出した奇数番目の項も等比級数をなし、初項は 6 のまま、公比はもとの公比の 2 乗、つまり (1/2)² = 1/4 になります。',
          '公比 1/4 は絶対値が 1 より小さいので、無限等比級数の和の公式（初項 ÷ (1 − 公比)）が使えます。',
          'よって新しい級数の和は 6 ÷ (1 − 1/4) = 6 ÷ (3/4) = 8 です。',
        ],
      },
      value: '8', max_digits: 1,
      reference: '無窮等比級數（由兩級數聯立求首項改為抽取子級數求和）',
      notes: '設計依據：既有題用原級數與平方級數的兩個和聯立反求首項，本題改為從原級數抽出奇數項組成子級數，關鍵觀察是子級數的公比等於原公比的平方；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（無窮等比・子級數）',
    ),
    int_q(
      topic: 'algebra', subtopic: 'complex_power_cycle', subtopic_zh: '複數冪次循環',
      prompt: {
        'zh-Hant' => '設 i 是虛數單位。求最小的正整數 n，使得 (1 + i)ⁿ 是一個實數。',
        'zh-Hans' => '设 i 是虚数单位。求最小的正整数 n，使得 (1 + i)ⁿ 是一个实数。',
        'en' => 'Let i be the imaginary unit. Find the smallest positive integer n for which (1 + i)ⁿ is a real number.',
        'ja' => 'i を虚数単位とします。(1 + i)ⁿ が実数となるような最小の正の整数 n を求めなさい。',
      },
      answer: { 'zh-Hant' => '答案是 4。', 'zh-Hans' => '答案是 4。', 'en' => 'The answer is 4.', 'ja' => '答えは 4 です。' },
      steps: {
        'zh-Hant' => [
          '把 1 + i 寫成極式：它的絕對值是 √2，輻角是 45°，所以 1 + i = √2 (cos45° + i sin45°)。',
          '由棣美弗定理，(1 + i)ⁿ 的輻角是 45° × n，絕對值是 (√2)ⁿ。',
          '一個複數是實數，等價於它的輻角是 180° 的整數倍（包含 0°）。',
          '所以要求 45n 是 180 的倍數，也就是 n 是 4 的倍數。',
          '最小的正整數是 n = 4。驗算：(1 + i)⁴ = ((1 + i)²)² = (2i)² = −4，確實是實數。',
        ],
        'zh-Hans' => [
          '把 1 + i 写成极式：它的绝对值是 √2，辐角是 45°，所以 1 + i = √2 (cos45° + i sin45°)。',
          '由棣美弗定理，(1 + i)ⁿ 的辐角是 45° × n，绝对值是 (√2)ⁿ。',
          '一个复数是实数，等价于它的辐角是 180° 的整数倍（包含 0°）。',
          '所以要求 45n 是 180 的倍数，也就是 n 是 4 的倍数。',
          '最小的正整数是 n = 4。验算：(1 + i)⁴ = ((1 + i)²)² = (2i)² = −4，确实是实数。',
        ],
        'en' => [
          'Write 1 + i in polar form: its modulus is √2 and its argument is 45°, so 1 + i = √2 (cos45° + i sin45°).',
          'By de Moivre\'s theorem, (1 + i)ⁿ has argument 45° × n and modulus (√2)ⁿ.',
          'A complex number is real exactly when its argument is an integer multiple of 180°, including 0°.',
          'So 45n must be a multiple of 180, that is, n must be a multiple of 4.',
          'The smallest positive integer is n = 4. Check: (1 + i)⁴ = ((1 + i)²)² = (2i)² = −4, which is indeed real.',
        ],
        'ja' => [
          '1 + i を極形式で表すと、絶対値は √2、偏角は 45° なので 1 + i = √2 (cos45° + i sin45°) です。',
          'ド・モアブルの定理より、(1 + i)ⁿ の偏角は 45° × n、絶対値は (√2)ⁿ です。',
          '複素数が実数であることは、偏角が 180° の整数倍（0° をふくむ）であることと同値です。',
          'よって 45n が 180 の倍数、つまり n が 4 の倍数であればよいことになります。',
          '最小の正の整数は n = 4 です。確かめると (1 + i)⁴ = ((1 + i)²)² = (2i)² = −4 でたしかに実数です。',
        ],
      },
      value: '4', max_digits: 1,
      reference: '複數冪次（由求特定冪次的值改為求最小指數）',
      notes: '設計依據：既有題把商化簡成 i 的冪再用四次循環求值，本題改為由「結果須為實數」這個條件反求最小指數，必須用極式與輻角條件；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（複數・最小指數）',
    ),
  ],
  'combinatorics' => [
    int_q(
      topic: 'combinatorics', subtopic: 'derangement_small', subtopic_zh: '錯排',
      prompt: {
        'zh-Hant' => '5 封不同的信要放進 5 個已經寫好不同姓名的信封，每個信封放一封。若要求恰好有 2 封信放進了正確的信封（其餘 3 封都放錯），求放法共有多少種。',
        'zh-Hans' => '5 封不同的信要放进 5 个已经写好不同姓名的信封，每个信封放一封。若要求恰好有 2 封信放进了正确的信封（其余 3 封都放错），求放法共有多少种。',
        'en' => 'Five different letters are to be put into five envelopes already addressed to five different people, one letter per envelope. If exactly 2 letters are to end up in their correct envelopes and the other 3 all in wrong ones, how many arrangements are there?',
        'ja' => '5 通の異なる手紙を、5 人ぶんの宛名が書かれた 5 つの封筒に 1 通ずつ入れます。ちょうど 2 通だけが正しい封筒に入り、残り 3 通はすべてまちがった封筒に入るようにする入れ方は何通りありますか。',
      },
      answer: { 'zh-Hant' => '答案是 20 種。', 'zh-Hans' => '答案是 20 种。',
                'en' => 'The answer is 20 arrangements.', 'ja' => '答えは 20 通りです。' },
      steps: {
        'zh-Hant' => [
          '先決定哪 2 封信放對，從 5 封中選 2 封的方法有 (5 × 4) ÷ 2 = 10 種。',
          '剩下的 3 封信必須全部放錯，也就是這 3 封信對應的 3 個信封要做一個錯排。',
          '3 個元素的錯排數是 2：把三封信記為 1、2、3，可行的放法只有 (2, 3, 1) 與 (3, 1, 2)。',
          '因為選哪 2 封放對與剩下 3 封怎麼錯排是互相獨立的，兩者相乘。',
          '所以總數是 10 × 2 = 20 種。',
        ],
        'zh-Hans' => [
          '先决定哪 2 封信放对，从 5 封中选 2 封的方法有 (5 × 4) ÷ 2 = 10 种。',
          '剩下的 3 封信必须全部放错，也就是这 3 封信对应的 3 个信封要做一个错排。',
          '3 个元素的错排数是 2：把三封信记为 1、2、3，可行的放法只有 (2, 3, 1) 与 (3, 1, 2)。',
          '因为选哪 2 封放对与剩下 3 封怎么错排是互相独立的，两者相乘。',
          '所以总数是 10 × 2 = 20 种。',
        ],
        'en' => [
          'First choose which 2 letters are correct, which can be done in (5 × 4) ÷ 2 = 10 ways.',
          'The remaining 3 letters must all be wrong, so those 3 letters and their 3 envelopes form a derangement.',
          'The number of derangements of 3 objects is 2: labelling the letters 1, 2, 3, the only possibilities are (2, 3, 1) and (3, 1, 2).',
          'The choice of which 2 are correct and the derangement of the other 3 are independent, so the counts multiply.',
          'The total is therefore 10 × 2 = 20 arrangements.',
        ],
        'ja' => [
          'まず正しく入る 2 通を選びます。5 通から 2 通を選ぶ方法は (5 × 4) ÷ 2 = 10 通りです。',
          '残りの 3 通はすべてまちがった封筒に入らなければならず、その 3 通と 3 つの封筒は完全順列（錯乱順列）になります。',
          '3 個の完全順列の数は 2 通りです。3 通を 1、2、3 とすると (2, 3, 1) と (3, 1, 2) だけです。',
          'どの 2 通を正しくするかと、残り 3 通の入れ方は独立なので、積をとります。',
          'したがって全部で 10 × 2 = 20 通りです。',
        ],
      },
      value: '20', max_digits: 2,
      reference: '錯排（由全錯排改為恰好 k 個固定點）',
      notes: '設計依據：既有題要求所有信件都放錯、直接是錯排數，本題要求恰好 2 封放對，必須先選出固定點再對其餘做錯排，是兩段式計數；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（錯排・恰好兩個固定點）',
    ),
    int_q(
      topic: 'combinatorics', subtopic: 'cube_face_coloring', subtopic_zh: '正方體的著色',
      prompt: {
        'zh-Hant' => '用紅、藍兩種顏色為一個正方體的 6 個面著色，每一面塗一種顏色，並且要求紅色恰好用在 3 個面上。若經由旋轉可以互相重合的兩種著色視為同一種（正方體可以任意旋轉，但不可以翻成鏡像），求本質上不同的著色方式共有多少種。',
        'zh-Hans' => '用红、蓝两种颜色为一个正方体的 6 个面着色，每一面涂一种颜色，并且要求红色恰好用在 3 个面上。若经由旋转可以互相重合的两种着色视为同一种（正方体可以任意旋转，但不可以翻成镜像），求本质上不同的着色方式共有多少种。',
        'en' => 'The 6 faces of a cube are each painted red or blue, with exactly 3 faces red. Two colourings that can be rotated into each other count as the same (the cube may be rotated freely but not reflected). How many essentially different colourings are there?',
        'ja' => '立方体の 6 つの面を赤か青でぬり分け、赤をちょうど 3 面に使います。回転して重ね合わせられるぬり方は同じとみなすとき（立方体は自由に回転できますが、鏡に映した形にはできません）、本質的に異なるぬり方は何通りありますか。',
      },
      answer: { 'zh-Hant' => '答案是 2 種。', 'zh-Hans' => '答案是 2 种。',
                'en' => 'The answer is 2 colourings.', 'ja' => '答えは 2 通りです。' },
      steps: {
        'zh-Hant' => [
          '因為紅色恰好 3 面、藍色恰好 3 面，只要看那 3 個紅面彼此的相對位置就能分類。',
          '正方體的面兩兩之間只有兩種關係：相對（在正方體的兩端）或相鄰（共用一條稜）。',
          '3 個紅面之中若含有一組相對面，那麼第三個紅面必定與這兩面都相鄰，三面形成一條「環帶」。',
          '3 個紅面之中若沒有任何一組相對面，則三面兩兩相鄰，會共同交會於同一個頂點，形成一個「角」。',
          '這兩種情形內部都可以靠旋轉互相重合，而彼此之間無法重合，所以本質上不同的著色方式有 2 種。',
        ],
        'zh-Hans' => [
          '因为红色恰好 3 面、蓝色恰好 3 面，只要看那 3 个红面彼此的相对位置就能分类。',
          '正方体的面两两之间只有两种关系：相对（在正方体的两端）或相邻（共用一条棱）。',
          '3 个红面之中若含有一组相对面，那么第三个红面必定与这两面都相邻，三面形成一条「环带」。',
          '3 个红面之中若没有任何一组相对面，则三面两两相邻，会共同交会于同一个顶点，形成一个「角」。',
          '这两种情形内部都可以靠旋转互相重合，而彼此之间无法重合，所以本质上不同的着色方式有 2 种。',
        ],
        'en' => [
          'Since exactly 3 faces are red and 3 are blue, the colouring is determined by how the 3 red faces sit relative to one another.',
          'Any two faces of a cube are either opposite, at the two ends of the cube, or adjacent, sharing an edge.',
          'If the 3 red faces include a pair of opposite faces, the third red face must be adjacent to both, and the three form a band around the cube.',
          'If the 3 red faces contain no opposite pair, they are pairwise adjacent and all meet at one vertex, forming a corner.',
          'Within each case any two colourings can be rotated onto one another, while the two cases cannot, so there are 2 essentially different colourings.',
        ],
        'ja' => [
          '赤がちょうど 3 面、青がちょうど 3 面なので、赤い 3 面どうしの位置関係だけで分類できます。',
          '立方体の 2 つの面の関係は、向かい合う（対面）か、辺を共有してとなり合うかの 2 通りだけです。',
          '赤い 3 面に対面の組がふくまれる場合、3 枚目の赤い面はその両方ととなり合い、3 面は帯状に並びます。',
          '赤い 3 面に対面の組がない場合、3 面はどの 2 つもとなり合い、1 つの頂点に集まって「かど」の形になります。',
          'それぞれの場合の中では回転で重ね合わせられ、2 つの場合どうしは重ね合わせられないので、本質的に異なるぬり方は 2 通りです。',
        ],
      },
      value: '2', max_digits: 1,
      reference: '正方體著色（由自由著色計數改為固定用色數的位置分析）',
      notes: '設計依據：既有題數的是所有紅藍著色在旋轉下的等價類總數，需要對每種紅面數逐一處理；本題固定紅色恰好 3 面，改成直接分析三個紅面的相對位置（成帶或成角），推理方式不同；已用 24 個旋轉的置換群窮舉軌道驗證答案為 2；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（正方體著色・固定用色數）',
    ),
  ],
  'geometry' => [
    int_q(
      topic: 'geometry', subtopic: 'law_of_cosines_angle', subtopic_zh: '餘弦定理求角',
      prompt: {
        'zh-Hant' => '在三角形 ABC 中，三邊長分別是 AB = 3、BC = 7、CA = 8。已知這個三角形的面積可以寫成 a√3 的形式（a 是正整數），求 a 的值。',
        'zh-Hans' => '在三角形 ABC 中，三边长分别是 AB = 3、BC = 7、CA = 8。已知这个三角形的面积可以写成 a√3 的形式（a 是正整数），求 a 的值。',
        'en' => 'In triangle ABC the sides are AB = 3, BC = 7 and CA = 8. The area of this triangle can be written in the form a√3 with a a positive integer. Find a.',
        'ja' => '三角形 ABC の 3 辺の長さは AB = 3、BC = 7、CA = 8 です。この三角形の面積は a√3（a は正の整数）の形に書けます。a の値を求めなさい。',
      },
      answer: { 'zh-Hant' => '答案是 6。', 'zh-Hans' => '答案是 6。', 'en' => 'The answer is 6.', 'ja' => '答えは 6 です。' },
      steps: {
        'zh-Hant' => [
          '三邊長都已知，可以直接用海龍公式求面積：先算半周長 s = (3 + 7 + 8) ÷ 2 = 9。',
          '面積等於 √[s(s − a)(s − b)(s − c)]，代入得 √[9 × (9 − 3) × (9 − 7) × (9 − 8)]。',
          '括號內是 9 × 6 × 2 × 1 = 108，所以面積是 √108。',
          '把 108 拆成 36 × 3，得到 √108 = √36 × √3 = 6√3。',
          '所以面積是 6√3，a = 6。',
        ],
        'zh-Hans' => [
          '三边长都已知，可以直接用海伦公式求面积：先算半周长 s = (3 + 7 + 8) ÷ 2 = 9。',
          '面积等于 √[s(s − a)(s − b)(s − c)]，代入得 √[9 × (9 − 3) × (9 − 7) × (9 − 8)]。',
          '括号内是 9 × 6 × 2 × 1 = 108，所以面积是 √108。',
          '把 108 拆成 36 × 3，得到 √108 = √36 × √3 = 6√3。',
          '所以面积是 6√3，a = 6。',
        ],
        'en' => [
          'All three sides are known, so Heron\'s formula applies directly: first the semi-perimeter s = (3 + 7 + 8) ÷ 2 = 9.',
          'The area is √[s(s − a)(s − b)(s − c)], which here is √[9 × (9 − 3) × (9 − 7) × (9 − 8)].',
          'Inside the root that is 9 × 6 × 2 × 1 = 108, so the area is √108.',
          'Writing 108 as 36 × 3 gives √108 = √36 × √3 = 6√3.',
          'The area is therefore 6√3, so a = 6.',
        ],
        'ja' => [
          '3 辺がすべてわかっているのでヘロンの公式が使えます。まず半周 s = (3 + 7 + 8) ÷ 2 = 9 です。',
          '面積は √[s(s − a)(s − b)(s − c)] なので、代入すると √[9 × (9 − 3) × (9 − 7) × (9 − 8)] です。',
          '根号の中は 9 × 6 × 2 × 1 = 108 なので、面積は √108 です。',
          '108 を 36 × 3 と分けると √108 = √36 × √3 = 6√3 となります。',
          'よって面積は 6√3 で、a = 6 です。',
        ],
      },
      value: '6', max_digits: 1,
      reference: '三邊長已知的三角形（由求角改為求面積）',
      notes: '設計依據：既有題用餘弦定理由三邊求出某個角的度數，本題改求面積，可以完全繞過餘弦定理改用海龍公式，工具不同；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（三邊已知・求面積）',
    ),
    int_q(
      topic: 'geometry', subtopic: 'frustum_volume', subtopic_zh: '圓錐台的體積',
      prompt: {
        'zh-Hant' => '一個圓錐被一個平行於底面的平面截開，截面的半徑恰好是原底面半徑的一半。這個平面把圓錐分成上方的小圓錐和下方的圓錐台兩部分。求圓錐台的體積是小圓錐體積的幾倍。',
        'zh-Hans' => '一个圆锥被一个平行于底面的平面截开，截面的半径恰好是原底面半径的一半。这个平面把圆锥分成上方的小圆锥和下方的圆锥台两部分。求圆锥台的体积是小圆锥体积的几倍。',
        'en' => 'A cone is cut by a plane parallel to its base, the cross-section having exactly half the radius of the base. The plane divides the cone into a small cone on top and a frustum below. The volume of the frustum is how many times the volume of the small cone?',
        'ja' => '円錐を底面に平行な平面で切ったところ、切り口の半径はもとの底面の半径のちょうど半分でした。この平面は円錐を上の小さい円錐と下の円錐台に分けます。円錐台の体積は小さい円錐の体積の何倍ですか。',
      },
      answer: { 'zh-Hant' => '答案是 7 倍。', 'zh-Hans' => '答案是 7 倍。',
                'en' => 'The answer is 7 times.', 'ja' => '答えは 7 倍です。' },
      steps: {
        'zh-Hant' => [
          '截面平行於底面，所以上方的小圓錐與原來的整個圓錐是相似的立體。',
          '截面半徑是底面半徑的一半，表示相似比是 1 : 2。',
          '相似立體的體積比等於相似比的立方，所以小圓錐與整個圓錐的體積比是 1³ : 2³ = 1 : 8。',
          '圓錐台是整個圓錐扣掉小圓錐，所以體積比是 (8 − 1) : 1 = 7 : 1。',
          '因此圓錐台的體積是小圓錐體積的 7 倍。',
        ],
        'zh-Hans' => [
          '截面平行于底面，所以上方的小圆锥与原来的整个圆锥是相似的立体。',
          '截面半径是底面半径的一半，表示相似比是 1 : 2。',
          '相似立体的体积比等于相似比的立方，所以小圆锥与整个圆锥的体积比是 1³ : 2³ = 1 : 8。',
          '圆锥台是整个圆锥扣掉小圆锥，所以体积比是 (8 − 1) : 1 = 7 : 1。',
          '因此圆锥台的体积是小圆锥体积的 7 倍。',
        ],
        'en' => [
          'The cut is parallel to the base, so the small cone on top is similar to the whole original cone.',
          'The cross-section has half the radius of the base, so the ratio of similarity is 1 : 2.',
          'Volumes of similar solids are in the ratio of the cube of the similarity ratio, so the small cone and the whole cone are in the ratio 1³ : 2³ = 1 : 8.',
          'The frustum is the whole cone with the small cone removed, so the ratio is (8 − 1) : 1 = 7 : 1.',
          'The frustum therefore has 7 times the volume of the small cone.',
        ],
        'ja' => [
          '切り口は底面に平行なので、上の小さい円錐はもとの円錐全体と相似です。',
          '切り口の半径は底面の半径の半分なので、相似比は 1 : 2 です。',
          '相似な立体の体積比は相似比の 3 乗に等しいので、小さい円錐と円錐全体の体積比は 1³ : 2³ = 1 : 8 です。',
          '円錐台は円錐全体から小さい円錐を除いたものなので、体積比は (8 − 1) : 1 = 7 : 1 です。',
          'したがって円錐台の体積は小さい円錐の体積の 7 倍です。',
        ],
      },
      value: '7', max_digits: 1,
      reference: '圓錐台（由代公式求體積改為相似比推理）',
      notes: '設計依據：既有題給上下底半徑與高、直接套圓錐台體積公式，本題不給任何長度，改用相似立體體積比為相似比立方的性質求倍數關係，完全不需要公式；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（圓錐台・相似體積比）',
    ),
  ],
  'logic' => [
    int_q(
      topic: 'logic', subtopic: 'rope_burning_time', subtopic_zh: '燒繩計時',
      prompt: {
        'zh-Hant' => '有兩條材質不均勻的繩子，每一條從一端點燃燒到另一端恰好需要 60 分鐘，但因為粗細不均，燒到中點所花的時間不一定是 30 分鐘。現在只有打火機，而且規定總共最多只能點火 3 次（每次點燃某一條繩子的某一個端點）。在這個限制下，能夠準確量出的最短時間是幾分鐘？',
        'zh-Hans' => '有两条材质不均匀的绳子，每一条从一端点燃烧到另一端恰好需要 60 分钟，但因为粗细不均，烧到中点所花的时间不一定是 30 分钟。现在只有打火机，而且规定总共最多只能点火 3 次（每次点燃某一条绳子的某一个端点）。在这个限制下，能够准确量出的最短时间是几分钟？',
        'en' => 'Two ropes of uneven thickness each take exactly 60 minutes to burn from one end to the other, but because of the unevenness the halfway point is not necessarily reached in 30 minutes. Only a lighter is available, and at most 3 lightings are allowed in total, each lighting one end of one rope. Under this restriction, what is the shortest time that can be measured exactly, in minutes?',
        'ja' => '太さが均一でないひもが 2 本あり、どちらも一方のはしから他方のはしまで燃えるのにちょうど 60 分かかりますが、太さが一定でないため中間点までが 30 分とはかぎりません。手元にはライターだけがあり、火をつけられるのは合計 3 回まで（1 回につきどちらかのひものはしを 1 か所）とします。この条件のもとで正確にはかれる最短の時間は何分ですか。',
      },
      answer: { 'zh-Hant' => '答案是 30 分鐘。', 'zh-Hans' => '答案是 30 分钟。',
                'en' => 'The answer is 30 minutes.', 'ja' => '答えは 30 分です。' },
      steps: {
        'zh-Hant' => [
          '同時點燃同一條繩子的兩端，兩個火苗會在某處相遇，此時整條繩子恰好燒完，用掉的時間一定是 60 ÷ 2 = 30 分鐘，這用掉 2 次點火。',
          '要量出比 30 更短的時間，標準做法是：先同時點燃第一條的兩端與第二條的一端（共 3 次點火），第一條在 30 分鐘後燒完，此時第二條還剩下相當於 30 分鐘的量。',
          '接著必須在那一刻點燃第二條的另一端，才能讓剩下的部分在 15 分鐘內燒完——但這是第 4 次點火，已經超過限制。',
          '在只能點火 3 次的情況下，任何做法都無法在某條繩子燒到一半後再加點一端，因此拿不到 15 分鐘這類更短的時間。',
          '所以能準確量出的最短時間就是同時點燃一條繩子兩端所得的 30 分鐘。',
        ],
        'zh-Hans' => [
          '同时点燃同一条绳子的两端，两个火苗会在某处相遇，此时整条绳子恰好烧完，用掉的时间一定是 60 ÷ 2 = 30 分钟，这用掉 2 次点火。',
          '要量出比 30 更短的时间，标准做法是：先同时点燃第一条的两端与第二条的一端（共 3 次点火），第一条在 30 分钟后烧完，此时第二条还剩下相当于 30 分钟的量。',
          '接着必须在那一刻点燃第二条的另一端，才能让剩下的部分在 15 分钟内烧完——但这是第 4 次点火，已经超过限制。',
          '在只能点火 3 次的情况下，任何做法都无法在某条绳子烧到一半后再加点一端，因此拿不到 15 分钟这类更短的时间。',
          '所以能准确量出的最短时间就是同时点燃一条绳子两端所得的 30 分钟。',
        ],
        'en' => [
          'Lighting both ends of one rope at once makes the two flames meet somewhere, finishing the rope in exactly 60 ÷ 2 = 30 minutes, and this uses 2 lightings.',
          'The standard way to get less than 30 is to light both ends of the first rope and one end of the second at the same moment, which is 3 lightings; the first rope finishes after 30 minutes and the second still has 30 minutes\' worth left.',
          'At that moment the other end of the second rope must be lit so that the remainder burns away in 15 minutes, but that would be a 4th lighting, which the restriction forbids.',
          'With only 3 lightings available, no plan can add a new flame after a rope has partly burned, so shorter times such as 15 minutes are out of reach.',
          'The shortest time that can be measured exactly is therefore the 30 minutes obtained by lighting both ends of one rope.',
        ],
        'ja' => [
          '1 本のひもの両はしに同時に火をつけると 2 つの炎がどこかで出会い、その時点でひもはちょうど燃えつきます。かかる時間は必ず 60 ÷ 2 = 30 分で、点火は 2 回です。',
          '30 分より短い時間をはかる定石は、1 本目の両はしと 2 本目の片はしに同時に火をつける（点火 3 回）方法で、1 本目は 30 分後に燃えつき、2 本目には 30 分ぶんが残ります。',
          'その瞬間に 2 本目のもう一方のはしに火をつければ残りは 15 分で燃えつきますが、それは 4 回目の点火となり制限をこえます。',
          '点火が 3 回までだと、ひもが途中まで燃えたあとに新たに火をつけることができないので、15 分のような短い時間は得られません。',
          'したがって正確にはかれる最短の時間は、1 本の両はしに火をつけて得られる 30 分です。',
        ],
      },
      value: '30', max_digits: 2,
      reference: '燒繩計時（加入點火次數上限）',
      notes: '設計依據：既有題不限點火次數、答案是經典的 15 分鐘；本題限制最多點火 3 次，必須先看出 15 分鐘的標準做法需要 4 次點火，再論證 3 次以內拿不到更短的時間，推理重心從構造轉為不可能性論證；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（燒繩・限制點火次數）',
    ),
    int_q(
      topic: 'logic', subtopic: 'handshake_double_counting', subtopic_zh: '每人握三次手',
      prompt: {
        'zh-Hant' => '一場聚會中，每個人不是恰好握了 3 次手，就是恰好握了 4 次手（同兩人之間至多握一次）。已知全場總共發生了 17 次握手，而且握 3 次手的人比握 4 次手的人多 2 人。求這場聚會一共有幾個人。',
        'zh-Hans' => '一场聚会中，每个人不是恰好握了 3 次手，就是恰好握了 4 次手（同两人之间至多握一次）。已知全场总共发生了 17 次握手，而且握 3 次手的人比握 4 次手的人多 2 人。求这场聚会一共有几个人。',
        'en' => 'At a party every person shook hands either exactly 3 times or exactly 4 times, and no pair shook hands more than once. There were 17 handshakes in total, and there were 2 more people who shook hands 3 times than people who shook hands 4 times. How many people were at the party?',
        'ja' => 'あるパーティーで、どの人もちょうど 3 回か、ちょうど 4 回だけ握手をしました（同じ 2 人が 2 回以上握手することはありません）。握手は全部で 17 回あり、3 回握手した人は 4 回握手した人より 2 人多いことがわかっています。パーティーには何人いましたか。',
      },
      answer: { 'zh-Hant' => '答案是 10 人。', 'zh-Hans' => '答案是 10 人。',
                'en' => 'The answer is 10 people.', 'ja' => '答えは 10 人です。' },
      steps: {
        'zh-Hant' => [
          '每一次握手都牽涉兩個人，所以把全場每個人的握手次數加起來，會恰好等於握手次數的 2 倍。',
          '總握手次數是 17，所以所有人的握手次數總和是 17 × 2 = 34。',
          '設握 4 次手的人有 b 人，則握 3 次手的人有 b + 2 人，次數總和是 3 × (b + 2) + 4 × b = 7b + 6。',
          '令 7b + 6 = 34，解得 7b = 28，b = 4，所以握 3 次的有 6 人、握 4 次的有 4 人。',
          '總人數是 6 + 4 = 10 人。',
        ],
        'zh-Hans' => [
          '每一次握手都牵涉两个人，所以把全场每个人的握手次数加起来，会恰好等于握手次数的 2 倍。',
          '总握手次数是 17，所以所有人的握手次数总和是 17 × 2 = 34。',
          '设握 4 次手的人有 b 人，则握 3 次手的人有 b + 2 人，次数总和是 3 × (b + 2) + 4 × b = 7b + 6。',
          '令 7b + 6 = 34，解得 7b = 28，b = 4，所以握 3 次的有 6 人、握 4 次的有 4 人。',
          '总人数是 6 + 4 = 10 人。',
        ],
        'en' => [
          'Every handshake involves two people, so adding up how many times each person shook hands gives exactly twice the number of handshakes.',
          'With 17 handshakes, the total over all people is 17 × 2 = 34.',
          'Let b be the number of people who shook hands 4 times, so b + 2 people shook hands 3 times, and the total is 3 × (b + 2) + 4 × b = 7b + 6.',
          'Setting 7b + 6 = 34 gives 7b = 28 and b = 4, so 6 people shook hands 3 times and 4 people shook hands 4 times.',
          'The number of people is 6 + 4 = 10.',
        ],
        'ja' => [
          '握手は必ず 2 人でするので、全員の握手回数をたすと握手の回数のちょうど 2 倍になります。',
          '握手は 17 回なので、全員の回数の合計は 17 × 2 = 34 です。',
          '4 回握手した人を b 人とすると 3 回握手した人は b + 2 人で、合計は 3 × (b + 2) + 4 × b = 7b + 6 です。',
          '7b + 6 = 34 とおくと 7b = 28、b = 4 となり、3 回の人が 6 人、4 回の人が 4 人です。',
          'したがって人数は 6 + 4 = 10 人です。',
        ],
      },
      value: '10', max_digits: 2,
      reference: '握手雙重計數（由人人同度數改為兩種度數混合）',
      notes: '設計依據：既有題所有人握手次數相同，直接用總度數除以 2；本題有兩種不同的握手次數並加上人數差的條件，必須把握手引理與聯立方程結合；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（握手・混合度數）',
    ),
  ],
  'number_theory' => [
    int_q(
      topic: 'number_theory', subtopic: 'decimal_period_length', subtopic_zh: '循環小數週期',
      prompt: {
        'zh-Hant' => '求最小的質數 p（p 不等於 2 也不等於 5），使得 1/p 化成十進位小數後，循環節的長度恰好是 3。',
        'zh-Hans' => '求最小的质数 p（p 不等于 2 也不等于 5），使得 1/p 化成十进位小数后，循环节的长度恰好是 3。',
        'en' => 'Find the smallest prime p, with p not equal to 2 or 5, such that the decimal expansion of 1/p has a repeating block of length exactly 3.',
        'ja' => '1/p を十進小数にしたとき、循環節の長さがちょうど 3 になるような最小の素数 p（p は 2 でも 5 でもない）を求めなさい。',
      },
      answer: { 'zh-Hant' => '答案是 37。', 'zh-Hans' => '答案是 37。', 'en' => 'The answer is 37.', 'ja' => '答えは 37 です。' },
      steps: {
        'zh-Hant' => [
          '1/p 的循環節長度是使 10ᵏ 除以 p 餘 1 的最小正整數 k。',
          '循環節長度恰好是 3，表示 10³ − 1 = 999 能被 p 整除，但 10¹ − 1 = 9 不能被 p 整除。',
          '把 999 分解質因數得 999 = 3³ × 37，所以可能的質數 p 只有 3 和 37。',
          'p = 3 時 9 也能被 3 整除，代表循環節長度其實是 1（1/3 = 0.333⋯），不符合。',
          'p = 37 時 9 不能被 37 整除，循環節長度確實是 3（1/37 = 0.027027⋯），所以最小的質數是 37。',
        ],
        'zh-Hans' => [
          '1/p 的循环节长度是使 10ᵏ 除以 p 余 1 的最小正整数 k。',
          '循环节长度恰好是 3，表示 10³ − 1 = 999 能被 p 整除，但 10¹ − 1 = 9 不能被 p 整除。',
          '把 999 分解质因数得 999 = 3³ × 37，所以可能的质数 p 只有 3 和 37。',
          'p = 3 时 9 也能被 3 整除，代表循环节长度其实是 1（1/3 = 0.333⋯），不符合。',
          'p = 37 时 9 不能被 37 整除，循环节长度确实是 3（1/37 = 0.027027⋯），所以最小的质数是 37。',
        ],
        'en' => [
          'The length of the repeating block of 1/p is the smallest positive integer k for which 10ᵏ leaves remainder 1 on division by p.',
          'A block of length exactly 3 means p divides 10³ − 1 = 999 but does not divide 10¹ − 1 = 9.',
          'Factorising gives 999 = 3³ × 37, so the only candidate primes are 3 and 37.',
          'For p = 3, 9 is also divisible by 3, so the block length is really 1, since 1/3 = 0.333…, and 3 fails.',
          'For p = 37, 9 is not divisible by 37 and the block length is indeed 3, since 1/37 = 0.027027…, so the smallest prime is 37.',
        ],
        'ja' => [
          '1/p の循環節の長さは、10ᵏ を p でわった余りが 1 になる最小の正の整数 k です。',
          '循環節の長さがちょうど 3 ということは、p が 10³ − 1 = 999 をわり切り、10¹ − 1 = 9 はわり切らないということです。',
          '999 を素因数分解すると 999 = 3³ × 37 なので、候補となる素数は 3 と 37 だけです。',
          'p = 3 のときは 9 も 3 でわり切れるので循環節の長さは実際には 1（1/3 = 0.333⋯）となり、条件に合いません。',
          'p = 37 のときは 9 は 37 でわり切れず、循環節の長さはたしかに 3（1/37 = 0.027027⋯）なので、最小の素数は 37 です。',
        ],
      },
      value: '37', max_digits: 2,
      reference: '循環小數週期（由給分母求週期改為由週期逆推分母）',
      notes: '設計依據：既有題給定分母直接求循環節長度，本題反過來由週期長度反求最小的質數分母，必須用「週期為 k 等價於 p 整除 10ᵏ − 1 且不整除更小的 10ʲ − 1」再分解 999 並排除 p = 3；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（循環節・逆推分母）',
    ),
    int_q(
      topic: 'number_theory', subtopic: 'fermat_little_theorem', subtopic_zh: '費馬小定理',
      prompt: {
        'zh-Hant' => '已知 2027 是質數。求 2²⁰²⁷ 除以 2027 的餘數。',
        'zh-Hans' => '已知 2027 是质数。求 2²⁰²⁷ 除以 2027 的余数。',
        'en' => 'Given that 2027 is prime, find the remainder when 2²⁰²⁷ is divided by 2027.',
        'ja' => '2027 が素数であることを用いて、2²⁰²⁷ を 2027 でわった余りを求めなさい。',
      },
      answer: { 'zh-Hant' => '答案是 2。', 'zh-Hans' => '答案是 2。', 'en' => 'The answer is 2.', 'ja' => '答えは 2 です。' },
      steps: {
        'zh-Hant' => [
          '注意到指數 2027 剛好等於模數 2027 本身，而不是 2027 − 1，這是本題的關鍵。',
          '由費馬小定理，若 p 是質數且 a 不是 p 的倍數，則 a^(p−1) 除以 p 的餘數是 1。',
          '這裡 p = 2027、a = 2，且 2 不是 2027 的倍數，所以 2²⁰²⁶ 除以 2027 的餘數是 1。',
          '把指數拆開：2²⁰²⁷ = 2²⁰²⁶ × 2，所以餘數是 1 × 2 = 2。',
          '因此 2²⁰²⁷ 除以 2027 的餘數是 2。',
        ],
        'zh-Hans' => [
          '注意到指数 2027 刚好等于模数 2027 本身，而不是 2027 − 1，这是本题的关键。',
          '由费马小定理，若 p 是质数且 a 不是 p 的倍数，则 a^(p−1) 除以 p 的余数是 1。',
          '这里 p = 2027、a = 2，且 2 不是 2027 的倍数，所以 2²⁰²⁶ 除以 2027 的余数是 1。',
          '把指数拆开：2²⁰²⁷ = 2²⁰²⁶ × 2，所以余数是 1 × 2 = 2。',
          '因此 2²⁰²⁷ 除以 2027 的余数是 2。',
        ],
        'en' => [
          'Notice that the exponent 2027 equals the modulus 2027 itself rather than 2027 − 1, which is the key point here.',
          'By Fermat\'s little theorem, if p is prime and a is not a multiple of p, then a^(p−1) leaves remainder 1 on division by p.',
          'Here p = 2027 and a = 2, and 2 is not a multiple of 2027, so 2²⁰²⁶ leaves remainder 1 on division by 2027.',
          'Splitting the exponent, 2²⁰²⁷ = 2²⁰²⁶ × 2, so the remainder is 1 × 2 = 2.',
          'The remainder when 2²⁰²⁷ is divided by 2027 is therefore 2.',
        ],
        'ja' => [
          '指数 2027 が法の 2027 そのものであり、2027 − 1 ではないことに注意します。ここが本問のかぎです。',
          'フェルマーの小定理より、p が素数で a が p の倍数でないとき、a^(p−1) を p でわった余りは 1 です。',
          'ここでは p = 2027、a = 2 で、2 は 2027 の倍数ではないので、2²⁰²⁶ を 2027 でわった余りは 1 です。',
          '指数を分けると 2²⁰²⁷ = 2²⁰²⁶ × 2 なので、余りは 1 × 2 = 2 です。',
          'したがって 2²⁰²⁷ を 2027 でわった余りは 2 です。',
        ],
      },
      value: '2', max_digits: 1,
      reference: '費馬小定理（由化簡大指數改為辨認 a^p ≡ a 的形式）',
      notes: '設計依據：既有題把大指數對 p − 1 取餘後化簡求值；本題的指數剛好等於模數本身，必須先看出要拆成 a^(p−1) × a 才能套用定理，是對定理另一種形式的辨認；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（費馬小定理・指數等於模數）',
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
