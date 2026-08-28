#!/usr/bin/env ruby
# frozen_string_literal: true

# grade9 補題（2026-08-28）— 同 subtopic 第二題，每題換一個明確不同的推理轉折
#   algebra       : quadratic_roots_ratio(比→差，改用判別式) / geometric_series_sum(求和→由和逆推項數)
#   combinatorics : elimination_tournament_games(單淘汰→雙敗，改以敗場計數) / integer_triangle_count(全部整數邊→限直角)
#   geometry      : folded_rectangle(摺後求邊長→求摺痕長) / centroid_area_third(給總面積求局部→給局部逆推總面積)
#   logic         : josephus_survivor(求存活者→由存活者逆推人數) / jug_state_search(最少操作→可量出的最小量)
#   number_theory : last_two_digits_cycle(單項冪次→等比級數和) / count_without_digit(完全不出現→恰好出現一次)

require 'json'
require 'set'

ROOT = File.expand_path('..', __dir__)
GRADE = 'grade9'
TOPIC_ZH = { 'algebra' => '代數', 'combinatorics' => '組合', 'geometry' => '幾何',
             'logic' => '邏輯', 'number_theory' => '數論' }.freeze
PATHS = TOPIC_ZH.keys.to_h { |t| [t, File.join(ROOT, "assets/questions/#{t}/#{GRADE}_foundation.#{t}.v1.json")] }.freeze
MANIFEST_PATH = File.join(ROOT, 'assets/questions/manifest.json')

def load_json(path) = JSON.parse(File.read(path))
def save_json(path, data) = File.write(path, JSON.pretty_generate(data) + "\n")

def int_q(topic:, subtopic:, subtopic_zh:, prompt:, answer:, steps:, value:, max_digits:,
          reference:, notes:, display:, figure: nil)
  { 'topic' => topic, 'subtopic' => subtopic, 'difficulty' => 'foundation',
    'levelStage' => GRADE, 'challengeTier' => 'foundation',
    'prompt' => prompt, 'answer' => answer, 'solutionSteps' => steps,
    'figure' => figure || { 'type' => 'custom', 'kind' => 'none', 'params' => {} },
    'answerMode' => 'integer_input',
    'correctAnswer' => { 'type' => 'integer', 'value' => value },
    'inputConstraints' => { 'allowNegative' => false, 'maxDigits' => max_digits },
    'source' => { 'type' => 'rewritten_olympiad_style', 'name' => 'MathSpring 改寫題',
                  'reference' => reference, 'notes' => notes, 'displayText' => display },
    'olympiadTaxonomy' => { 'topic' => TOPIC_ZH[topic], 'topicCode' => topic,
                            'subtopic' => subtopic_zh, 'subtopicCode' => subtopic },
    'reviewStatus' => 'ok' }
end

CREASE_FIGURE = {
  'type' => 'custom', 'kind' => 'geometry_scene',
  'params' => {
    'kind' => 'geometry_scene',
    'bounds' => { 'minX' => -1.5, 'minY' => -1.5, 'maxX' => 17.5, 'maxY' => 13.5 },
    'points' => [
      { 'name' => 'A', 'x' => 0, 'y' => 0, 'pos' => 'bl' },
      { 'name' => 'B', 'x' => 16, 'y' => 0, 'pos' => 'br' },
      { 'name' => 'C', 'x' => 16, 'y' => 12, 'pos' => 'tr' },
      { 'name' => 'D', 'x' => 0, 'y' => 12, 'pos' => 'tl' },
      { 'name' => 'Q', 'x' => 12.5, 'y' => 0, 'pos' => 'b' },
      { 'name' => 'P', 'x' => 3.5, 'y' => 12, 'pos' => 't' },
    ],
    'segments' => [
      { 'from' => 'A', 'to' => 'B', 'style' => 'solid' },
      { 'from' => 'B', 'to' => 'C', 'style' => 'solid' },
      { 'from' => 'C', 'to' => 'D', 'style' => 'solid' },
      { 'from' => 'D', 'to' => 'A', 'style' => 'solid' },
      { 'from' => 'A', 'to' => 'C', 'style' => 'construction' },
      { 'from' => 'P', 'to' => 'Q', 'style' => 'solid' },
    ],
  },
}.freeze

QUESTIONS = {
  'algebra' => [
    int_q(
      topic: 'algebra', subtopic: 'quadratic_roots_ratio', subtopic_zh: '根的比例',
      prompt: {
        'zh-Hant' => '已知二次方程式 x² + px + q = 0 的兩個根之差是 5，且 p = −7。求 q 的值。',
        'zh-Hans' => '已知二次方程式 x² + px + q = 0 的两个根之差是 5，且 p = −7。求 q 的值。',
        'en' => 'The two roots of the quadratic equation x² + px + q = 0 differ by 5, and p = −7. Find the value of q.',
        'ja' => '2 次方程式 x² + px + q = 0 の 2 つの解の差が 5 で、p = −7 であるとします。q の値を求めなさい。',
      },
      answer: { 'zh-Hant' => '答案是 6。', 'zh-Hans' => '答案是 6。', 'en' => 'The answer is 6.', 'ja' => '答えは 6 です。' },
      steps: {
        'zh-Hant' => [
          '設兩根為 α、β。由根與係數的關係，α + β = −p = 7，α × β = q。',
          '兩根之差的平方可以用和與積表示：(α − β)² = (α + β)² − 4αβ。',
          '代入已知：5² = 7² − 4q，也就是 25 = 49 − 4q。',
          '解得 4q = 24，所以 q = 6。',
          '驗算：x² − 7x + 6 = 0 的兩根是 1 和 6，兩根之差確實是 5，所以 q = 6。',
        ],
        'zh-Hans' => [
          '设两根为 α、β。由根与系数的关系，α + β = −p = 7，α × β = q。',
          '两根之差的平方可以用和与积表示：(α − β)² = (α + β)² − 4αβ。',
          '代入已知：5² = 7² − 4q，也就是 25 = 49 − 4q。',
          '解得 4q = 24，所以 q = 6。',
          '验算：x² − 7x + 6 = 0 的两根是 1 和 6，两根之差确实是 5，所以 q = 6。',
        ],
        'en' => [
          'Let the roots be α and β. From the relations between roots and coefficients, α + β = −p = 7 and α × β = q.',
          'The square of the difference can be written using the sum and the product: (α − β)² = (α + β)² − 4αβ.',
          'Substituting the given values, 5² = 7² − 4q, that is 25 = 49 − 4q.',
          'This gives 4q = 24, so q = 6.',
          'Check: x² − 7x + 6 = 0 has roots 1 and 6, whose difference is indeed 5, so q = 6.',
        ],
        'ja' => [
          '2 つの解を α、β とします。解と係数の関係より α + β = −p = 7、α × β = q です。',
          '2 解の差の 2 乗は和と積で表せます：(α − β)² = (α + β)² − 4αβ。',
          '与えられた値を代入すると 5² = 7² − 4q、つまり 25 = 49 − 4q となります。',
          'よって 4q = 24 となり、q = 6 です。',
          '確かめると x² − 7x + 6 = 0 の解は 1 と 6 で、差はたしかに 5 なので q = 6 です。',
        ],
      },
      value: '6', max_digits: 1,
      reference: '根的關係（由比改為差，改用判別式恆等式）',
      notes: '設計依據：既有題給兩根之比並直接設根為 t 與 2t，本題改給兩根之差，必須使用 (α−β)² = (α+β)² − 4αβ 這個恆等式，工具不同；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（根的關係・給差）',
    ),
    int_q(
      topic: 'algebra', subtopic: 'geometric_series_sum', subtopic_zh: '等比級數求和',
      prompt: {
        'zh-Hant' => '一個等比數列的首項是 3、公比是 2。已知它的前 n 項之和是 765，求 n 的值。',
        'zh-Hans' => '一个等比数列的首项是 3、公比是 2。已知它的前 n 项之和是 765，求 n 的值。',
        'en' => 'A geometric sequence has first term 3 and common ratio 2. The sum of its first n terms is 765. Find n.',
        'ja' => '初項 3、公比 2 の等比数列があります。初項から第 n 項までの和が 765 であるとき、n の値を求めなさい。',
      },
      answer: { 'zh-Hant' => '答案是 8。', 'zh-Hans' => '答案是 8。', 'en' => 'The answer is 8.', 'ja' => '答えは 8 です。' },
      steps: {
        'zh-Hant' => [
          '首項是 3、公比是 2 的等比數列，前 n 項之和是 3 × (2ⁿ − 1) ÷ (2 − 1)，也就是 3 × (2ⁿ − 1)。',
          '題目說這個和等於 765，所以 3 × (2ⁿ − 1) = 765。',
          '兩邊同除以 3，得到 2ⁿ − 1 = 255，也就是 2ⁿ = 256。',
          '因為 2⁸ = 256，所以 n = 8。',
          '驗算：3 + 6 + 12 + 24 + 48 + 96 + 192 + 384 = 765，確實是 8 項，所以 n = 8。',
        ],
        'zh-Hans' => [
          '首项是 3、公比是 2 的等比数列，前 n 项之和是 3 × (2ⁿ − 1) ÷ (2 − 1)，也就是 3 × (2ⁿ − 1)。',
          '题目说这个和等于 765，所以 3 × (2ⁿ − 1) = 765。',
          '两边同除以 3，得到 2ⁿ − 1 = 255，也就是 2ⁿ = 256。',
          '因为 2⁸ = 256，所以 n = 8。',
          '验算：3 + 6 + 12 + 24 + 48 + 96 + 192 + 384 = 765，确实是 8 项，所以 n = 8。',
        ],
        'en' => [
          'For a geometric sequence with first term 3 and common ratio 2, the sum of the first n terms is 3 × (2ⁿ − 1) ÷ (2 − 1), that is 3 × (2ⁿ − 1).',
          'The problem says this sum equals 765, so 3 × (2ⁿ − 1) = 765.',
          'Dividing both sides by 3 gives 2ⁿ − 1 = 255, that is 2ⁿ = 256.',
          'Since 2⁸ = 256, we get n = 8.',
          'Check: 3 + 6 + 12 + 24 + 48 + 96 + 192 + 384 = 765, which is indeed 8 terms, so n = 8.',
        ],
        'ja' => [
          '初項 3、公比 2 の等比数列の初項から第 n 項までの和は 3 × (2ⁿ − 1) ÷ (2 − 1)、つまり 3 × (2ⁿ − 1) です。',
          'この和が 765 なので、3 × (2ⁿ − 1) = 765 となります。',
          '両辺を 3 でわると 2ⁿ − 1 = 255、すなわち 2ⁿ = 256 です。',
          '2⁸ = 256 なので n = 8 です。',
          '確かめると 3 + 6 + 12 + 24 + 48 + 96 + 192 + 384 = 765 でちょうど 8 項なので、n = 8 です。',
        ],
      },
      value: '8', max_digits: 1,
      reference: '等比級數（由求和改為由和逆推項數）',
      notes: '設計依據：既有題給項數直接套公式求和，本題給總和反求項數，必須把求和公式整理成指數方程再解；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（等比級數・逆推項數）',
    ),
  ],
  'combinatorics' => [
    int_q(
      topic: 'combinatorics', subtopic: 'elimination_tournament_games', subtopic_zh: '淘汰賽場次',
      prompt: {
        'zh-Hant' => '有 20 支隊伍參加雙敗淘汰制比賽：每支隊伍要輸滿兩場才會被淘汰出局，每一場比賽恰好產生一支輸隊，最後只剩下一支沒有被淘汰的冠軍隊伍。若冠軍隊伍從頭到尾一場都沒輸過，整個比賽總共進行了幾場？',
        'zh-Hans' => '有 20 支队伍参加双败淘汰制比赛：每支队伍要输满两场才会被淘汰出局，每一场比赛恰好产生一支输队，最后只剩下一支没有被淘汰的冠军队伍。若冠军队伍从头到尾一场都没输过，整个比赛总共进行了几场？',
        'en' => 'Twenty teams play a double-elimination tournament: a team is knocked out only after losing twice, every game produces exactly one losing team, and at the end just one team remains un-eliminated as champion. If the champion never lost a single game, how many games were played in total?',
        'ja' => '20 チームが敗者復活つき（2 敗で失格）のトーナメントに出場します。各チームは 2 敗すると失格になり、1 試合ごとにちょうど 1 チームが負け、最後に失格していないチームが 1 つだけ残って優勝します。優勝チームが最後まで 1 度も負けなかったとき、試合は全部で何試合行われましたか。',
      },
      answer: { 'zh-Hant' => '答案是 38 場。', 'zh-Hans' => '答案是 38 场。',
                'en' => 'The answer is 38 games.', 'ja' => '答えは 38 試合です。' },
      steps: {
        'zh-Hant' => [
          '不要去追蹤賽程表，改成計算「總共產生了幾敗」，因為每一場比賽恰好產生 1 敗。',
          '20 支隊伍中，除了冠軍以外的 19 支都被淘汰，而被淘汰代表剛好輸滿 2 場。',
          '所以這 19 支隊伍一共貢獻了 19 × 2 = 38 敗。',
          '題目說冠軍一場都沒輸，所以冠軍貢獻 0 敗，全場總敗數就是 38。',
          '每場比賽產生 1 敗，因此比賽場數等於總敗數，也就是 38 場。',
        ],
        'zh-Hans' => [
          '不要去追踪赛程表，改成计算「总共产生了几败」，因为每一场比赛恰好产生 1 败。',
          '20 支队伍中，除了冠军以外的 19 支都被淘汰，而被淘汰代表刚好输满 2 场。',
          '所以这 19 支队伍一共贡献了 19 × 2 = 38 败。',
          '题目说冠军一场都没输，所以冠军贡献 0 败，全场总败数就是 38。',
          '每场比赛产生 1 败，因此比赛场数等于总败数，也就是 38 场。',
        ],
        'en' => [
          'Rather than tracing the draw, count the total number of losses, since every game produces exactly one loss.',
          'Of the 20 teams, the 19 that are not the champion are all eliminated, and being eliminated means losing exactly twice.',
          'Those 19 teams therefore account for 19 × 2 = 38 losses.',
          'The champion never lost, contributing 0 losses, so the total number of losses is 38.',
          'Each game creates one loss, so the number of games equals the number of losses, namely 38.',
        ],
        'ja' => [
          '対戦表を追うのではなく、「負けが全部で何回生じたか」を数えます。1 試合につき負けはちょうど 1 回だからです。',
          '20 チームのうち優勝チーム以外の 19 チームは失格になり、失格とはちょうど 2 敗したということです。',
          'したがってこの 19 チームで 19 × 2 = 38 敗となります。',
          '優勝チームは 1 度も負けていないので 0 敗であり、全体の敗戦数は 38 です。',
          '1 試合で 1 敗が生じるので試合数は敗戦数と等しく、38 試合です。',
        ],
      },
      value: '38', max_digits: 2,
      reference: '淘汰賽場次（單淘汰改為雙敗，改以敗場計數）',
      notes: '設計依據：既有題是單淘汰、每場淘汰一隊，場數等於隊數減一；本題改為雙敗制，必須改用「總敗場數等於總場數」的雙重計數，並處理冠軍敗場數的條件；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（淘汰賽・雙敗計數）',
    ),
    int_q(
      topic: 'combinatorics', subtopic: 'integer_triangle_count', subtopic_zh: '整數三角形計數',
      prompt: {
        'zh-Hant' => '一個直角三角形的三邊長都是正整數，而且周長是 30。求這個三角形的面積是多少。',
        'zh-Hans' => '一个直角三角形的三边长都是正整数，而且周长是 30。求这个三角形的面积是多少。',
        'en' => 'A right triangle has all three side lengths equal to positive integers and a perimeter of 30. Find its area.',
        'ja' => '3 辺の長さがすべて正の整数である直角三角形があり、周の長さは 30 です。この三角形の面積を求めなさい。',
      },
      answer: { 'zh-Hant' => '答案是 30。', 'zh-Hans' => '答案是 30。', 'en' => 'The answer is 30.', 'ja' => '答えは 30 です。' },
      steps: {
        'zh-Hant' => [
          '設兩股是 a、b，斜邊是 c，則 a + b + c = 30 且 a² + b² = c²。',
          '由第一式得 c = 30 − a − b，代入第二式：a² + b² = (30 − a − b)²。',
          '展開並化簡後可得 900 − 60a − 60b + 2ab = 0，兩邊除以 2 再整理，得 (a − 30)(b − 30) = 450。',
          '因為 a、b 都小於 30，所以 30 − a 與 30 − b 都是正整數且乘積為 450，逐一檢驗可得符合三邊皆為正整數的只有 a = 5、b = 12、c = 13。',
          '所以三角形的面積是 5 × 12 ÷ 2 = 30。',
        ],
        'zh-Hans' => [
          '设两股是 a、b，斜边是 c，则 a + b + c = 30 且 a² + b² = c²。',
          '由第一式得 c = 30 − a − b，代入第二式：a² + b² = (30 − a − b)²。',
          '展开并化简后可得 900 − 60a − 60b + 2ab = 0，两边除以 2 再整理，得 (a − 30)(b − 30) = 450。',
          '因为 a、b 都小于 30，所以 30 − a 与 30 − b 都是正整数且乘积为 450，逐一检验可得符合三边皆为正整数的只有 a = 5、b = 12、c = 13。',
          '所以三角形的面积是 5 × 12 ÷ 2 = 30。',
        ],
        'en' => [
          'Let the legs be a and b and the hypotenuse c, so a + b + c = 30 and a² + b² = c².',
          'From the first equation c = 30 − a − b, and substituting into the second gives a² + b² = (30 − a − b)².',
          'Expanding and simplifying gives 900 − 60a − 60b + 2ab = 0, and after dividing by 2 and rearranging, (a − 30)(b − 30) = 450.',
          'Since a and b are both less than 30, the numbers 30 − a and 30 − b are positive integers with product 450, and checking the possibilities leaves only a = 5, b = 12, c = 13.',
          'The area of the triangle is therefore 5 × 12 ÷ 2 = 30.',
        ],
        'ja' => [
          '2 辺を a、b、斜辺を c とすると、a + b + c = 30 かつ a² + b² = c² です。',
          '1 つ目の式から c = 30 − a − b となり、これを 2 つ目に代入すると a² + b² = (30 − a − b)² です。',
          '展開して整理すると 900 − 60a − 60b + 2ab = 0 となり、2 でわって変形すると (a − 30)(b − 30) = 450 が得られます。',
          'a、b はどちらも 30 より小さいので 30 − a と 30 − b は正の整数で積が 450 となり、順に調べると 3 辺が正の整数になるのは a = 5、b = 12、c = 13 だけです。',
          'したがって三角形の面積は 5 × 12 ÷ 2 = 30 です。',
        ],
      },
      value: '30', max_digits: 2,
      reference: '整數邊三角形（加上直角限制並改求面積）',
      notes: '設計依據：既有題只用三角不等式數出所有整數邊三角形，本題加上直角條件，必須把畢氏定理與周長聯立化成因數分解式再篩選，並在解題中發現這樣的三角形是唯一的；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（整數邊・直角限制）',
    ),
  ],
  'geometry' => [
    int_q(
      topic: 'geometry', subtopic: 'folded_rectangle', subtopic_zh: '長方形摺疊',
      prompt: {
        'zh-Hant' => '如圖，長方形 ABCD 中 AB = 16、AD = 12。把這張紙摺一次，使頂點 A 恰好落在頂點 C 上，摺痕分別交 AB 於 Q、交 DC 於 P。求摺痕 PQ 的長度。',
        'zh-Hans' => '如图，长方形 ABCD 中 AB = 16、AD = 12。把这张纸折一次，使顶点 A 恰好落在顶点 C 上，折痕分别交 AB 于 Q、交 DC 于 P。求折痕 PQ 的长度。',
        'en' => 'In the figure, rectangle ABCD has AB = 16 and AD = 12. The sheet is folded once so that vertex A lands exactly on vertex C, and the crease meets AB at Q and DC at P. Find the length of the crease PQ.',
        'ja' => '図のように、長方形 ABCD で AB = 16、AD = 12 です。頂点 A がちょうど頂点 C に重なるように 1 回折ると、折り目は AB と点 Q で、DC と点 P で交わります。折り目 PQ の長さを求めなさい。',
      },
      answer: { 'zh-Hant' => '答案是 15。', 'zh-Hans' => '答案是 15。', 'en' => 'The answer is 15.', 'ja' => '答えは 15 です。' },
      steps: {
        'zh-Hant' => [
          '摺疊後 A 落在 C 上，表示摺痕上的每一點到 A 和到 C 的距離都相等，所以摺痕就是線段 AC 的垂直平分線。',
          '由畢氏定理，對角線 AC = √(16² + 12²) = √400 = 20，且摺痕通過 AC 的中點並與 AC 垂直。',
          '設摺痕交 AB 於 Q。因為 Q 在垂直平分線上，所以 QA = QC。設 QA = x，則 QB = 16 − x，而 QC² = QB² + BC²。',
          '於是 x² = (16 − x)² + 12²，展開得 x² = 256 − 32x + x² + 144，即 32x = 400，x = 12.5。',
          '同理可得 P 到 D 的距離是 3.5，於是 PQ 在水平方向相差 12.5 − 3.5 = 9、垂直方向相差 12，所以 PQ = √(9² + 12²) = √225 = 15。',
        ],
        'zh-Hans' => [
          '折叠后 A 落在 C 上，表示折痕上的每一点到 A 和到 C 的距离都相等，所以折痕就是线段 AC 的垂直平分线。',
          '由勾股定理，对角线 AC = √(16² + 12²) = √400 = 20，且折痕通过 AC 的中点并与 AC 垂直。',
          '设折痕交 AB 于 Q。因为 Q 在垂直平分线上，所以 QA = QC。设 QA = x，则 QB = 16 − x，而 QC² = QB² + BC²。',
          '于是 x² = (16 − x)² + 12²，展开得 x² = 256 − 32x + x² + 144，即 32x = 400，x = 12.5。',
          '同理可得 P 到 D 的距离是 3.5，于是 PQ 在水平方向相差 12.5 − 3.5 = 9、垂直方向相差 12，所以 PQ = √(9² + 12²) = √225 = 15。',
        ],
        'en' => [
          'Folding A onto C means every point of the crease is equidistant from A and from C, so the crease is the perpendicular bisector of the segment AC.',
          'By the Pythagorean theorem the diagonal AC = √(16² + 12²) = √400 = 20, and the crease passes through the midpoint of AC at right angles to it.',
          'Let the crease meet AB at Q. Being on the perpendicular bisector, QA = QC. Put QA = x, so QB = 16 − x, and QC² = QB² + BC².',
          'Hence x² = (16 − x)² + 12², which expands to x² = 256 − 32x + x² + 144, so 32x = 400 and x = 12.5.',
          'In the same way the distance from P to D is 3.5, so P and Q differ by 12.5 − 3.5 = 9 horizontally and 12 vertically, giving PQ = √(9² + 12²) = √225 = 15.',
        ],
        'ja' => [
          'A が C に重なるように折るということは、折り目上のどの点も A と C から等しい距離にあるということなので、折り目は線分 AC の垂直二等分線です。',
          '三平方の定理より対角線 AC = √(16² + 12²) = √400 = 20 で、折り目は AC の中点を通り AC に垂直です。',
          '折り目と AB の交点を Q とすると、Q は垂直二等分線上にあるので QA = QC です。QA = x とすると QB = 16 − x で、QC² = QB² + BC² が成り立ちます。',
          'よって x² = (16 − x)² + 12² となり、展開すると x² = 256 − 32x + x² + 144、つまり 32x = 400 で x = 12.5 です。',
          '同様に P と D の距離は 3.5 なので、P と Q は横に 12.5 − 3.5 = 9、縦に 12 だけはなれており、PQ = √(9² + 12²) = √225 = 15 です。',
        ],
      },
      value: '15', max_digits: 2,
      figure: CREASE_FIGURE,
      reference: '長方形摺疊（由摺後求邊長改為求摺痕長）',
      notes: '設計依據：既有題摺疊後求某條邊長，本題改求摺痕本身的長度，關鍵是認出摺痕即對角線的垂直平分線再用等距條件解出交點位置；圖上只畫出摺痕位置與對角線輔助線，未標任何長度，不會洩答案；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（摺疊・摺痕長）',
    ),
    int_q(
      topic: 'geometry', subtopic: 'centroid_area_third', subtopic_zh: '重心分割面積',
      prompt: {
        'zh-Hant' => '三角形 ABC 中，D 是邊 BC 的中點，E 是線段 AD 的中點。已知三角形 BEC 的面積是 18 平方公分，求三角形 ABC 的面積是幾平方公分。',
        'zh-Hans' => '三角形 ABC 中，D 是边 BC 的中点，E 是线段 AD 的中点。已知三角形 BEC 的面积是 18 平方厘米，求三角形 ABC 的面积是几平方厘米。',
        'en' => 'In triangle ABC, D is the midpoint of side BC and E is the midpoint of segment AD. The area of triangle BEC is 18 square centimetres. Find the area of triangle ABC.',
        'ja' => '三角形 ABC で、D は辺 BC の中点、E は線分 AD の中点です。三角形 BEC の面積が 18 平方センチメートルであるとき、三角形 ABC の面積は何平方センチメートルですか。',
      },
      answer: { 'zh-Hant' => '答案是 36 平方公分。', 'zh-Hans' => '答案是 36 平方厘米。',
                'en' => 'The answer is 36 square centimetres.', 'ja' => '答えは 36 平方センチメートルです。' },
      steps: {
        'zh-Hant' => [
          '三角形 BEC 和三角形 ABC 有同一條底邊 BC，所以面積比就等於兩個頂點 E 與 A 到 BC 的距離之比。',
          'D 在 BC 上，而 E 是 AD 的中點，所以 E 到 BC 的距離剛好是 A 到 BC 的距離的一半。',
          '因此三角形 BEC 的面積是三角形 ABC 面積的一半。',
          '已知三角形 BEC 的面積是 18 平方公分，所以三角形 ABC 的面積是 18 × 2 = 36 平方公分。',
        ],
        'zh-Hans' => [
          '三角形 BEC 和三角形 ABC 有同一条底边 BC，所以面积比就等于两个顶点 E 与 A 到 BC 的距离之比。',
          'D 在 BC 上，而 E 是 AD 的中点，所以 E 到 BC 的距离刚好是 A 到 BC 的距离的一半。',
          '因此三角形 BEC 的面积是三角形 ABC 面积的一半。',
          '已知三角形 BEC 的面积是 18 平方厘米，所以三角形 ABC 的面积是 18 × 2 = 36 平方厘米。',
        ],
        'en' => [
          'Triangles BEC and ABC share the base BC, so the ratio of their areas equals the ratio of the distances from E and from A to BC.',
          'D lies on BC and E is the midpoint of AD, so the distance from E to BC is exactly half the distance from A to BC.',
          'Hence the area of triangle BEC is half the area of triangle ABC.',
          'Since triangle BEC has area 18 square centimetres, triangle ABC has area 18 × 2 = 36 square centimetres.',
        ],
        'ja' => [
          '三角形 BEC と三角形 ABC は底辺 BC が共通なので、面積の比は E と A から BC までの距離の比に等しくなります。',
          'D は BC 上にあり E は AD の中点なので、E から BC までの距離は A から BC までの距離のちょうど半分です。',
          'したがって三角形 BEC の面積は三角形 ABC の面積の半分です。',
          '三角形 BEC の面積が 18 平方センチメートルなので、三角形 ABC の面積は 18 × 2 = 36 平方センチメートルです。',
        ],
      },
      value: '36', max_digits: 2,
      reference: '中線分割面積（由總面積求局部改為由局部逆推總面積）',
      notes: '設計依據：既有題給整體面積並用重心的三分之一性質求局部，本題改用「中點的中點」形成二分之一的高度比，且方向相反由局部面積逆推整體；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（中線分割・逆推總面積）',
    ),
  ],
  'logic' => [
    int_q(
      topic: 'logic', subtopic: 'josephus_survivor', subtopic_zh: '圍圈報數',
      prompt: {
        'zh-Hant' => '若干人圍成一圈依順時針編號，從 1 號開始報數，每次報到「2」的人立刻離開圈子，接著由下一個人重新從「1」開始報數，一直進行到只剩一人。已知最後剩下的是 1 號，而且人數在 10 到 20 之間。求圍成一圈的人數。',
        'zh-Hans' => '若干人围成一圈依顺时针编号，从 1 号开始报数，每次报到「2」的人立刻离开圈子，接着由下一个人重新从「1」开始报数，一直进行到只剩一人。已知最后剩下的是 1 号，而且人数在 10 到 20 之间。求围成一圈的人数。',
        'en' => 'Several people stand in a circle, numbered clockwise. Counting starts at person 1; whoever says "2" immediately leaves the circle, and the next person starts counting again from "1", continuing until one person remains. The last person remaining is number 1, and the number of people is between 10 and 20. How many people were in the circle?',
        'ja' => '何人かが輪になり時計回りに番号がついています。1 番から数え始め、「2」と言った人がすぐに輪から出て、次の人がまた「1」から数え直し、1 人になるまで続けます。最後に残ったのが 1 番で、人数が 10 人以上 20 人以下であるとき、輪になっていた人数を求めなさい。',
      },
      answer: { 'zh-Hant' => '答案是 16 人。', 'zh-Hans' => '答案是 16 人。',
                'en' => 'The answer is 16 people.', 'ja' => '答えは 16 人です。' },
      steps: {
        'zh-Hant' => [
          '先觀察小人數的情形：2 人時最後剩 1 號，4 人時最後剩 1 號，8 人時最後剩 1 號。',
          '原因是：當人數是偶數時，報數一輪之後所有偶數號都會離開，剩下的全是奇數號，而且下一輪仍然從 1 號開始報。',
          '這相當於把人數減半後重新開始同樣的過程，所以只要人數一路減半都保持是偶數，1 號就永遠不會被點到。',
          '人數一路減半都是偶數，等價於人數是 2 的次方；若中途出現奇數，1 號就會在下一輪被淘汰。',
          '10 到 20 之間唯一的 2 的次方是 16，所以人數是 16 人。',
        ],
        'zh-Hans' => [
          '先观察小人数的情形：2 人时最后剩 1 号，4 人时最后剩 1 号，8 人时最后剩 1 号。',
          '原因是：当人数是偶数时，报数一轮之后所有偶数号都会离开，剩下的全是奇数号，而且下一轮仍然从 1 号开始报。',
          '这相当于把人数减半后重新开始同样的过程，所以只要人数一路减半都保持是偶数，1 号就永远不会被点到。',
          '人数一路减半都是偶数，等价于人数是 2 的次方；若中途出现奇数，1 号就会在下一轮被淘汰。',
          '10 到 20 之间唯一的 2 的次方是 16，所以人数是 16 人。',
        ],
        'en' => [
          'Look at small cases first: with 2 people number 1 survives, with 4 people number 1 survives, and with 8 people number 1 survives.',
          'The reason is that when the count is even, one full round removes every even-numbered person, leaving only the odd numbers, and the next round again starts at number 1.',
          'That is the same process with half as many people, so as long as halving keeps giving an even count, number 1 is never the one to go.',
          'Halving always giving an even count is exactly the condition that the number of people is a power of 2; if an odd count ever appears, number 1 is eliminated in the following round.',
          'The only power of 2 between 10 and 20 is 16, so there were 16 people.',
        ],
        'ja' => [
          'まず少人数で調べます。2 人でも 4 人でも 8 人でも、最後に残るのは 1 番です。',
          '理由は、人数が偶数のとき 1 周すると偶数番の人が全員出ていき、奇数番だけが残り、次の周もやはり 1 番から数え始めるからです。',
          'これは人数を半分にして同じ手続きをくり返すことと同じなので、半分にしていくあいだずっと偶数であれば 1 番は決して当たりません。',
          '半分にしてもつねに偶数であることは、人数が 2 の累乗であることと同じです。途中で奇数になると 1 番は次の周で脱落します。',
          '10 以上 20 以下で 2 の累乗は 16 だけなので、人数は 16 人です。',
        ],
      },
      value: '16', max_digits: 2,
      reference: '圍圈報數（由求存活者改為由存活者逆推人數）',
      notes: '設計依據：既有題給定人數求最後存活的號碼，本題反過來由「1 號存活」這個條件反推人數，必須發現人數為 2 的次方時 1 號才會存活的結構性質；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（圍圈報數・逆推人數）',
    ),
    int_q(
      topic: 'logic', subtopic: 'jug_state_search', subtopic_zh: '水壺量水最少操作',
      prompt: {
        'zh-Hant' => '有一個 6 公升和一個 15 公升的水壺，兩個壺上都沒有刻度，旁邊有取用不完的水。每次操作只能是：把某個壺裝滿、把某個壺倒空，或把某個壺的水倒進另一個壺（倒到原壺空了或另一壺滿了為止）。用這兩個壺可以量出來的水量之中，最小的正整數公升數是多少？',
        'zh-Hans' => '有一个 6 升和一个 15 升的水壶，两个壶上都没有刻度，旁边有取用不完的水。每次操作只能是：把某个壶装满、把某个壶倒空，或把某个壶的水倒进另一个壶（倒到原壶空了或另一壶满了为止）。用这两个壶可以量出来的水量之中，最小的正整数升数是多少？',
        'en' => 'There is a 6-litre jug and a 15-litre jug, neither with any markings, beside an unlimited supply of water. Each operation must be one of: fill a jug, empty a jug, or pour from one jug into the other until the first is empty or the second is full. Among the amounts of water that can be measured out with these jugs, what is the smallest positive whole number of litres?',
        'ja' => '目もりのない 6 リットルと 15 リットルの水がめがあり、そばには水がいくらでもあります。1 回の操作は「どちらかをいっぱいにする」「どちらかを空にする」「一方の水をもう一方に、元が空になるか相手がいっぱいになるまで移す」のいずれかです。この 2 つの水がめではかり取れる水の量のうち、最小の正の整数リットルはいくつですか。',
      },
      answer: { 'zh-Hant' => '答案是 3 公升。', 'zh-Hans' => '答案是 3 升。',
                'en' => 'The answer is 3 litres.', 'ja' => '答えは 3 リットルです。' },
      steps: {
        'zh-Hant' => [
          '觀察每一次操作對「兩壺水量總和」的影響：裝滿是加 6 或加 15，倒空是減 6 或減 15，互相傾倒則總量不變。',
          '所以任何時刻，兩壺裡的水量都可以寫成 6 的倍數加上 15 的倍數（倍數可以是負的），也就是一定是 6 與 15 的公因數的倍數。',
          '6 與 15 的最大公因數是 3，因此能量出的水量一定是 3 的倍數，1 公升和 2 公升都不可能量出來。',
          '而 3 公升確實量得出來：把 15 公升的壺裝滿，倒進 6 公升的壺並倒空它，再倒一次並倒空，15 − 6 − 6 = 3，大壺裡就剩下 3 公升。',
          '所以能量出的最小正整數公升數是 3。',
        ],
        'zh-Hans' => [
          '观察每一次操作对「两壶水量总和」的影响：装满是加 6 或加 15，倒空是减 6 或减 15，互相倾倒则总量不变。',
          '所以任何时刻，两壶里的水量都可以写成 6 的倍数加上 15 的倍数（倍数可以是负的），也就是一定是 6 与 15 的公因数的倍数。',
          '6 与 15 的最大公因数是 3，因此能量出的水量一定是 3 的倍数，1 升和 2 升都不可能量出来。',
          '而 3 升确实量得出来：把 15 升的壶装满，倒进 6 升的壶并倒空它，再倒一次并倒空，15 − 6 − 6 = 3，大壶里就剩下 3 升。',
          '所以能量出的最小正整数升数是 3。',
        ],
        'en' => [
          'Consider how each operation changes the total amount of water in the two jugs: filling adds 6 or 15, emptying subtracts 6 or 15, and pouring between jugs leaves the total unchanged.',
          'So at any moment the water present can be written as a multiple of 6 plus a multiple of 15, where the multipliers may be negative, and hence is always a multiple of a common divisor of 6 and 15.',
          'The greatest common divisor of 6 and 15 is 3, so every measurable amount is a multiple of 3, and 1 litre and 2 litres are impossible.',
          'And 3 litres really is achievable: fill the 15-litre jug, pour into the 6-litre jug and empty it, then pour and empty once more, leaving 15 − 6 − 6 = 3 litres in the large jug.',
          'The smallest positive whole number of litres that can be measured is therefore 3.',
        ],
        'ja' => [
          '各操作が「2 つの水がめの水の合計」にどう影響するかを見ます。いっぱいにすると 6 か 15 増え、空にすると 6 か 15 減り、移しかえでは合計は変わりません。',
          'よっていつでも水の量は 6 の倍数と 15 の倍数の和（係数は負でもよい）として表され、6 と 15 の公約数の倍数になります。',
          '6 と 15 の最大公約数は 3 なので、はかり取れる量は必ず 3 の倍数であり、1 リットルや 2 リットルは不可能です。',
          '実際 3 リットルははかれます。15 リットルをいっぱいにし、6 リットルへ移して空にし、もう一度移して空にすると、15 − 6 − 6 = 3 で大きいほうに 3 リットル残ります。',
          'したがってはかり取れる最小の正の整数リットルは 3 です。',
        ],
      },
      value: '3', max_digits: 1,
      reference: '水壺量水（由最少操作次數改為可量出的最小量）',
      notes: '設計依據：既有題給定目標水量求最少操作次數，本題改問哪些水量根本量得出來，必須觀察每次操作只會讓總量改變 6 或 15，因而所有可量出的量都是最大公因數的倍數，再構造一組操作達成；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（量水・最小可量量）',
    ),
  ],
  'number_theory' => [
    int_q(
      topic: 'number_theory', subtopic: 'last_two_digits_cycle', subtopic_zh: '末兩位循環',
      prompt: {
        'zh-Hant' => '求 2¹ + 2² + 2³ + ⋯ + 2²⁰ 這個總和的末兩位數字（若末兩位是 05，請填 5）。',
        'zh-Hans' => '求 2¹ + 2² + 2³ + ⋯ + 2²⁰ 这个总和的末两位数字（若末两位是 05，请填 5）。',
        'en' => 'Find the last two digits of the sum 2¹ + 2² + 2³ + ⋯ + 2²⁰. (If the last two digits are 05, enter 5.)',
        'ja' => '2¹ + 2² + 2³ + ⋯ + 2²⁰ の和の下 2 けたを求めなさい。（下 2 けたが 05 のときは 5 と答えます。）',
      },
      answer: { 'zh-Hant' => '答案是 50。', 'zh-Hans' => '答案是 50。', 'en' => 'The answer is 50.', 'ja' => '答えは 50 です。' },
      steps: {
        'zh-Hant' => [
          '不要逐項相加，先用等比數列求和公式把整個式子收成一個封閉形式。',
          '首項是 2、公比是 2、共 20 項，所以總和是 2 × (2²⁰ − 1) ÷ (2 − 1) = 2²¹ − 2。',
          '接著只要求 2²¹ 的末兩位。先算 2¹⁰ = 1024，末兩位是 24；而 2²⁰ = (2¹⁰)²，由 24 × 24 = 576 可知末兩位是 76。',
          '再由 2²¹ = 2 × 2²⁰，從 2 × 76 = 152 可知 2²¹ 的末兩位是 52。',
          '因此總和的末兩位是 52 − 2 = 50，答案是 50。',
        ],
        'zh-Hans' => [
          '不要逐项相加，先用等比数列求和公式把整个式子收成一个封闭形式。',
          '首项是 2、公比是 2、共 20 项，所以总和是 2 × (2²⁰ − 1) ÷ (2 − 1) = 2²¹ − 2。',
          '接着只要求 2²¹ 的末两位。先算 2¹⁰ = 1024，末两位是 24；而 2²⁰ = (2¹⁰)²，由 24 × 24 = 576 可知末两位是 76。',
          '再由 2²¹ = 2 × 2²⁰，从 2 × 76 = 152 可知 2²¹ 的末两位是 52。',
          '因此总和的末两位是 52 − 2 = 50，答案是 50。',
        ],
        'en' => [
          'Rather than adding term by term, first collapse the sum with the formula for a geometric series.',
          'The first term is 2, the ratio is 2 and there are 20 terms, so the sum is 2 × (2²⁰ − 1) ÷ (2 − 1) = 2²¹ − 2.',
          'It remains to find the last two digits of 2²¹. The last two digits of powers of 2 repeat with period 20, but the repetition only begins from 2², so 2²¹ does not simply copy 2¹.',
          'Working it out, 2²¹ = 2097152, whose last two digits are 52.',
          'So the last two digits of the sum are 52 − 2 = 50, and the answer is 50.',
        ],
        'ja' => [
          '1 項ずつ足すのではなく、まず等比数列の和の公式で式をまとめます。',
          '初項 2、公比 2、項数 20 なので、和は 2 × (2²⁰ − 1) ÷ (2 − 1) = 2²¹ − 2 です。',
          'あとは 2²¹ の下 2 けたを求めればよいことになります。2 のべきの下 2 けたは周期 20 でくり返しますが、くり返しが始まるのは 2² からなので、2²¹ が 2¹ と同じになるわけではありません。',
          '実際に計算すると 2²¹ = 2097152 で、下 2 けたは 52 です。',
          'したがって和の下 2 けたは 52 − 2 = 50 となり、答えは 50 です。',
        ],
      },
      value: '50', max_digits: 2,
      reference: '末兩位（由單項冪次改為等比級數和）',
      notes: '設計依據：既有題直接求某個冪次的末兩位，本題改求一整串冪次和的末兩位，必須先用等比求和收成 2²¹ − 2 再處理末兩位，而且不能天真套用循環週期；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（末兩位・級數和）',
    ),
    int_q(
      topic: 'number_theory', subtopic: 'count_without_digit', subtopic_zh: '不含某個數字的計數',
      prompt: {
        'zh-Hant' => '在 1 到 1000 的正整數中，十進位表示裡數字 7 恰好出現一次的數共有多少個？',
        'zh-Hans' => '在 1 到 1000 的正整数中，十进位表示里数字 7 恰好出现一次的数共有多少个？',
        'en' => 'Among the positive integers from 1 to 1000, how many contain the digit 7 exactly once in their decimal representation?',
        'ja' => '1 から 1000 までの正の整数のうち、十進法で表したときに数字 7 がちょうど 1 回だけ現れるものは何個ありますか。',
      },
      answer: { 'zh-Hant' => '答案是 243 個。', 'zh-Hans' => '答案是 243 个。',
                'en' => 'The answer is 243 numbers.', 'ja' => '答えは 243 個です。' },
      steps: {
        'zh-Hant' => [
          '1000 本身不含數字 7，所以只要考慮 1 到 999。',
          '把 1 到 999 的每個數都補成三位數來看（例如 5 寫成 005、48 寫成 048），補上的 0 不會製造出新的數字 7，也不會影響 7 出現的次數。',
          '這樣問題就變成：在 000 到 999 這 1000 個三位數字串中，數字 7 恰好出現一次的有幾個。',
          '先選 7 出現在哪一位，有 3 種選法；另外兩位都不能是 7，各有 9 種選擇。',
          '所以共有 3 × 9 × 9 = 243 個。因為 000 不含 7、不影響計數，答案就是 243 個。',
        ],
        'zh-Hans' => [
          '1000 本身不含数字 7，所以只要考虑 1 到 999。',
          '把 1 到 999 的每个数都补成三位数来看（例如 5 写成 005、48 写成 048），补上的 0 不会制造出新的数字 7，也不会影响 7 出现的次数。',
          '这样问题就变成：在 000 到 999 这 1000 个三位数字串中，数字 7 恰好出现一次的有几个。',
          '先选 7 出现在哪一位，有 3 种选法；另外两位都不能是 7，各有 9 种选择。',
          '所以共有 3 × 9 × 9 = 243 个。因为 000 不含 7、不影响计数，答案就是 243 个。',
        ],
        'en' => [
          'The number 1000 contains no digit 7, so only 1 to 999 need be considered.',
          'Write every number from 1 to 999 as a three-digit string by padding with zeros (5 becomes 005, 48 becomes 048); the added zeros create no new sevens and do not change how often 7 appears.',
          'The question becomes: among the 1000 strings from 000 to 999, how many contain the digit 7 exactly once.',
          'First choose which of the three positions holds the 7, in 3 ways; each of the other two positions may be any digit except 7, giving 9 choices each.',
          'That gives 3 × 9 × 9 = 243. Since 000 contains no 7 and does not affect the count, the answer is 243.',
        ],
        'ja' => [
          '1000 には数字 7 がふくまれないので、1 から 999 だけを考えます。',
          '1 から 999 の各数を 0 でうめて 3 けたの文字列とみなします（5 は 005、48 は 048）。うめた 0 は新たな 7 を作らず、7 の出現回数も変えません。',
          'すると問題は、000 から 999 までの 1000 個の 3 けた文字列のうち、数字 7 がちょうど 1 回現れるものは何個か、ということになります。',
          'まず 7 がどの位に現れるかを選び 3 通り、残り 2 つの位はどちらも 7 以外なのでそれぞれ 9 通りです。',
          'よって 3 × 9 × 9 = 243 個です。000 には 7 がふくまれず数に影響しないので、答えは 243 個です。',
        ],
      },
      value: '243', max_digits: 3,
      reference: '數字出現次數（由完全不出現改為恰好出現一次）',
      notes: '設計依據：既有題數的是「完全不出現 7」的個數，可直接用 9 的次方；本題改為「恰好出現一次」，必須先選定 7 的位置再排除其餘位上的 7，計數結構不同；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（數字計數・恰好一次）',
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
