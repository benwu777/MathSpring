#!/usr/bin/env ruby
# frozen_string_literal: true

# grade8 補題（2026-08-28）— 同 subtopic 第二題，每題換一個明確不同的推理轉折
#   algebra       : quadratic_from_roots(由根求係數→由整數根性質求係數極值) / boat_stream_round_trip(求時間→逆推流速)
#   combinatorics : domino_tiling_2xn(二維斐波那契→一維雙長度遞迴) / handshake_reverse(完全圖→二部圖)
#   geometry      : ladder_slide_pythagorean(給梯長求位移→給位移求梯長) / isosceles_perimeter_case(求周長→求方案數)
#   logic         : hanoi_min_moves(三柱自由→只能搬相鄰柱) / paper_folding_layers(層數→剪後段數)
#   number_theory : frobenius_number(最大不可表示→不可表示的個數) / divisor_count(求因數個數→求最小數)

require 'json'
require 'set'

ROOT = File.expand_path('..', __dir__)
GRADE = 'grade8'
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
      topic: 'algebra', subtopic: 'quadratic_from_roots', subtopic_zh: '由根反推係數',
      prompt: {
        'zh-Hant' => '已知二次方程式 x² − bx + 12 = 0 的兩個根都是正整數，其中 b 是常數。求 b 所有可能的值之中最大的一個。',
        'zh-Hans' => '已知二次方程式 x² − bx + 12 = 0 的两个根都是正整数，其中 b 是常数。求 b 所有可能的值之中最大的一个。',
        'en' => 'Both roots of the quadratic equation x² − bx + 12 = 0 are positive integers, where b is a constant. Find the largest possible value of b.',
        'ja' => '2 次方程式 x² − bx + 12 = 0 の 2 つの解がどちらも正の整数であるとします（b は定数）。b のとりうる値のうち最大のものを求めなさい。',
      },
      answer: { 'zh-Hant' => '答案是 13。', 'zh-Hans' => '答案是 13。', 'en' => 'The answer is 13.', 'ja' => '答えは 13 です。' },
      steps: {
        'zh-Hant' => [
          '設兩個根是 p 和 q。由根與係數的關係，p + q = b，而 p × q = 12。',
          '因為 p、q 都是正整數且乘積是 12，所以 (p, q) 只可能是 (1, 12)、(2, 6)、(3, 4) 這三組（順序對調不算新的）。',
          '這三組對應的和分別是 1 + 12 = 13、2 + 6 = 8、3 + 4 = 7。',
          '而 b 就等於兩根的和，所以 b 可能是 13、8 或 7。',
          '其中最大的是 13，所以答案是 13。',
        ],
        'zh-Hans' => [
          '设两个根是 p 和 q。由根与系数的关系，p + q = b，而 p × q = 12。',
          '因为 p、q 都是正整数且乘积是 12，所以 (p, q) 只可能是 (1, 12)、(2, 6)、(3, 4) 这三组（顺序对调不算新的）。',
          '这三组对应的和分别是 1 + 12 = 13、2 + 6 = 8、3 + 4 = 7。',
          '而 b 就等于两根的和，所以 b 可能是 13、8 或 7。',
          '其中最大的是 13，所以答案是 13。',
        ],
        'en' => [
          'Let the roots be p and q. By the relations between roots and coefficients, p + q = b and p × q = 12.',
          'Since p and q are positive integers with product 12, the pairs (p, q) can only be (1, 12), (2, 6) or (3, 4), swapping the order giving nothing new.',
          'The corresponding sums are 1 + 12 = 13, 2 + 6 = 8 and 3 + 4 = 7.',
          'Since b equals the sum of the roots, b can be 13, 8 or 7.',
          'The largest of these is 13, so the answer is 13.',
        ],
        'ja' => [
          '2 つの解を p、q とします。解と係数の関係より p + q = b、p × q = 12 です。',
          'p、q は正の整数で積が 12 なので、(p, q) は (1, 12)、(2, 6)、(3, 4) の 3 組だけです（順序を入れかえたものは同じとみなします）。',
          'それぞれの和は 1 + 12 = 13、2 + 6 = 8、3 + 4 = 7 です。',
          'b は 2 解の和なので、b は 13、8、7 のいずれかです。',
          'このうち最大のものは 13 なので、答えは 13 です。',
        ],
      },
      value: '13', max_digits: 2,
      reference: '由根反推係數（改為由整數根性質求係數極值）',
      notes: '設計依據：既有題直接給出兩根求係數，本題只給「兩根都是正整數」與常數項，必須先枚舉 12 的因數分解再比較各組的和取最大；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（由根反推係數・求極值）',
    ),
    int_q(
      topic: 'algebra', subtopic: 'boat_stream_round_trip', subtopic_zh: '流水行船',
      prompt: {
        'zh-Hant' => '一艘船在靜水中的速度是每小時 10 公里。它從 A 地順流而下開到 48 公里外的 B 地，再逆流開回 A 地，來回一共花了 10 小時。求河水的流速是每小時幾公里。',
        'zh-Hans' => '一艘船在静水中的速度是每小时 10 公里。它从 A 地顺流而下开到 48 公里外的 B 地，再逆流开回 A 地，来回一共花了 10 小时。求河水的流速是每小时几公里。',
        'en' => 'A boat travels at 10 kilometres an hour in still water. It goes downstream from A to B, 48 kilometres away, and then back upstream to A, taking 10 hours in all. Find the speed of the current in kilometres an hour.',
        'ja' => '静水での速さが時速 10 km の船があります。A 地点から 48 km はなれた B 地点まで川を下り、また A 地点まで川をのぼって帰ったところ、往復で合計 10 時間かかりました。川の流れの速さは時速何キロメートルですか。',
      },
      answer: { 'zh-Hant' => '答案是每小時 2 公里。', 'zh-Hans' => '答案是每小时 2 公里。',
                'en' => 'The answer is 2 kilometres an hour.', 'ja' => '答えは時速 2 キロメートルです。' },
      steps: {
        'zh-Hant' => [
          '設流速是每小時 v 公里。順流時速度是 10 + v，逆流時速度是 10 − v。',
          '順流的時間是 48 ÷ (10 + v)，逆流的時間是 48 ÷ (10 − v)，兩者相加等於 10 小時。',
          '通分後分子是 48 × (10 − v) + 48 × (10 + v) = 960，分母是 (10 + v)(10 − v) = 100 − v²。',
          '所以 960 ÷ (100 − v²) = 10，也就是 100 − v² = 96，得 v² = 4。',
          '流速為正，所以 v = 2，河水流速是每小時 2 公里。',
        ],
        'zh-Hans' => [
          '设流速是每小时 v 公里。顺流时速度是 10 + v，逆流时速度是 10 − v。',
          '顺流的时间是 48 ÷ (10 + v)，逆流的时间是 48 ÷ (10 − v)，两者相加等于 10 小时。',
          '通分后分子是 48 × (10 − v) + 48 × (10 + v) = 960，分母是 (10 + v)(10 − v) = 100 − v²。',
          '所以 960 ÷ (100 − v²) = 10，也就是 100 − v² = 96，得 v² = 4。',
          '流速为正，所以 v = 2，河水流速是每小时 2 公里。',
        ],
        'en' => [
          'Let the current be v kilometres an hour. Downstream the boat moves at 10 + v and upstream at 10 − v.',
          'The downstream time is 48 ÷ (10 + v) and the upstream time is 48 ÷ (10 − v), and together they make 10 hours.',
          'Over a common denominator the numerator is 48 × (10 − v) + 48 × (10 + v) = 960 and the denominator is (10 + v)(10 − v) = 100 − v².',
          'So 960 ÷ (100 − v²) = 10, which gives 100 − v² = 96 and hence v² = 4.',
          'A current is positive, so v = 2 and the current runs at 2 kilometres an hour.',
        ],
        'ja' => [
          '流れの速さを時速 v km とします。下るときの速さは 10 + v、のぼるときは 10 − v です。',
          '下りの時間は 48 ÷ (10 + v)、のぼりの時間は 48 ÷ (10 − v) で、その和が 10 時間です。',
          '通分すると分子は 48 × (10 − v) + 48 × (10 + v) = 960、分母は (10 + v)(10 − v) = 100 − v² です。',
          'よって 960 ÷ (100 − v²) = 10 となり、100 − v² = 96、すなわち v² = 4 です。',
          '流れの速さは正なので v = 2 となり、川の流れは時速 2 キロメートルです。',
        ],
      },
      value: '2', max_digits: 1,
      reference: '流水行船（由求時間改為逆推流速）',
      notes: '設計依據：既有題給靜水速度與流速直接求來回時間，本題給總時間反求流速，必須通分後解出二次式；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（流水行船・逆推流速）',
    ),
  ],
  'combinatorics' => [
    int_q(
      topic: 'combinatorics', subtopic: 'domino_tiling_2xn', subtopic_zh: '遞迴計數',
      prompt: {
        'zh-Hant' => '一條長 8 格的走道排成一列，要用長 2 格和長 3 格兩種地磚鋪滿，地磚不可重疊也不可超出走道，兩種地磚都可以使用任意多塊（也可以完全不用其中一種）。求一共有多少種不同的鋪法。',
        'zh-Hans' => '一条长 8 格的走道排成一列，要用长 2 格和长 3 格两种地砖铺满，地砖不可重叠也不可超出走道，两种地砖都可以使用任意多块（也可以完全不用其中一种）。求一共有多少种不同的铺法。',
        'en' => 'A corridor 8 cells long, in a single row, is to be tiled completely with tiles 2 cells long and tiles 3 cells long. Tiles may not overlap or stick out, and either kind may be used any number of times, including not at all. How many different tilings are there?',
        'ja' => '長さ 8 マスの通路が一列にあり、長さ 2 マスと長さ 3 マスの 2 種類のタイルですきまなくしきつめます。タイルは重ねたりはみ出したりできず、どちらの種類も何枚使ってもかまいません（まったく使わなくてもかまいません）。しきつめ方は全部で何通りありますか。',
      },
      answer: { 'zh-Hant' => '答案是 4 種。', 'zh-Hans' => '答案是 4 种。',
                'en' => 'The answer is 4 tilings.', 'ja' => '答えは 4 通りです。' },
      steps: {
        'zh-Hant' => [
          '設長 n 格的走道有 f(n) 種鋪法。看最左邊那一塊地磚：它不是長 2 格就是長 3 格。',
          '若最左邊放長 2 格的地磚，剩下 n − 2 格；若放長 3 格的，剩下 n − 3 格。所以 f(n) = f(n − 2) + f(n − 3)。',
          '起始值是 f(0) = 1（什麼都不放）、f(1) = 0（1 格放不下）、f(2) = 1、f(3) = 1。',
          '依序算下去：f(4) = f(2) + f(1) = 1，f(5) = f(3) + f(2) = 2，f(6) = f(4) + f(3) = 2。',
          'f(7) = f(5) + f(4) = 3，f(8) = f(6) + f(5) = 4，所以長 8 格的走道有 4 種鋪法。',
        ],
        'zh-Hans' => [
          '设长 n 格的走道有 f(n) 种铺法。看最左边那一块地砖：它不是长 2 格就是长 3 格。',
          '若最左边放长 2 格的地砖，剩下 n − 2 格；若放长 3 格的，剩下 n − 3 格。所以 f(n) = f(n − 2) + f(n − 3)。',
          '起始值是 f(0) = 1（什么都不放）、f(1) = 0（1 格放不下）、f(2) = 1、f(3) = 1。',
          '依次算下去：f(4) = f(2) + f(1) = 1，f(5) = f(3) + f(2) = 2，f(6) = f(4) + f(3) = 2。',
          'f(7) = f(5) + f(4) = 3，f(8) = f(6) + f(5) = 4，所以长 8 格的走道有 4 种铺法。',
        ],
        'en' => [
          'Let f(n) be the number of tilings of a corridor n cells long. Look at the leftmost tile: it is either 2 cells or 3 cells long.',
          'A leftmost tile of length 2 leaves n − 2 cells, and one of length 3 leaves n − 3 cells, so f(n) = f(n − 2) + f(n − 3).',
          'The starting values are f(0) = 1 (lay nothing), f(1) = 0 (one cell cannot be filled), f(2) = 1 and f(3) = 1.',
          'Working upwards: f(4) = f(2) + f(1) = 1, f(5) = f(3) + f(2) = 2, f(6) = f(4) + f(3) = 2.',
          'Then f(7) = f(5) + f(4) = 3 and f(8) = f(6) + f(5) = 4, so the corridor of 8 cells has 4 tilings.',
        ],
        'ja' => [
          '長さ n マスの通路のしきつめ方を f(n) とします。いちばん左のタイルに注目すると、長さ 2 か長さ 3 のどちらかです。',
          '左端が長さ 2 なら残りは n − 2 マス、長さ 3 なら残りは n − 3 マスなので、f(n) = f(n − 2) + f(n − 3) です。',
          '初期値は f(0) = 1（何も置かない）、f(1) = 0（1 マスには置けない）、f(2) = 1、f(3) = 1 です。',
          '順に計算すると f(4) = f(2) + f(1) = 1、f(5) = f(3) + f(2) = 2、f(6) = f(4) + f(3) = 2 です。',
          'さらに f(7) = f(5) + f(4) = 3、f(8) = f(6) + f(5) = 4 なので、長さ 8 マスでは 4 通りです。',
        ],
      },
      value: '4', max_digits: 1,
      reference: '遞迴計數（二維骨牌改為一維雙長度地磚）',
      notes: '設計依據：既有題是 2×n 骨牌鋪法、遞迴式為斐波那契型 f(n)=f(n−1)+f(n−2)，本題改成一維但有兩種長度，遞迴式變成 f(n)=f(n−2)+f(n−3)，初始值也需重新判斷；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（遞迴計數・雙長度地磚）',
    ),
    int_q(
      topic: 'combinatorics', subtopic: 'handshake_reverse', subtopic_zh: '由次數反推人數',
      prompt: {
        'zh-Hant' => '一場聚會中有男生和女生。每一位男生都和每一位女生恰好握手一次，男生之間、女生之間都不握手。已知一共握了 36 次手，而且男生比女生多 5 人。求男生有幾人。',
        'zh-Hans' => '一场聚会中有男生和女生。每一位男生都和每一位女生恰好握手一次，男生之间、女生之间都不握手。已知一共握了 36 次手，而且男生比女生多 5 人。求男生有几人。',
        'en' => 'At a party there are boys and girls. Every boy shakes hands exactly once with every girl, and no two boys and no two girls shake hands. There were 36 handshakes in total, and there are 5 more boys than girls. How many boys are there?',
        'ja' => 'あるパーティーに男子と女子がいます。どの男子もどの女子とちょうど 1 回ずつ握手し、男子どうし・女子どうしは握手しません。握手は全部で 36 回あり、男子は女子より 5 人多いことがわかっています。男子は何人ですか。',
      },
      answer: { 'zh-Hant' => '答案是 9 人。', 'zh-Hans' => '答案是 9 人。',
                'en' => 'The answer is 9 boys.', 'ja' => '答えは 9 人です。' },
      steps: {
        'zh-Hant' => [
          '設女生有 f 人，那麼男生就有 f + 5 人。',
          '因為只有男女之間握手，每一位男生都要和每一位女生握一次，所以握手次數是男生人數乘以女生人數。',
          '列式得 f × (f + 5) = 36。',
          '把 36 拆成兩個相差 5 的正整數乘積：4 × 9 = 36 而且 9 − 4 = 5，符合條件。',
          '所以女生有 4 人、男生有 4 + 5 = 9 人，男生是 9 人。',
        ],
        'zh-Hans' => [
          '设女生有 f 人，那么男生就有 f + 5 人。',
          '因为只有男女之间握手，每一位男生都要和每一位女生握一次，所以握手次数是男生人数乘以女生人数。',
          '列式得 f × (f + 5) = 36。',
          '把 36 拆成两个相差 5 的正整数乘积：4 × 9 = 36 而且 9 − 4 = 5，符合条件。',
          '所以女生有 4 人、男生有 4 + 5 = 9 人，男生是 9 人。',
        ],
        'en' => [
          'Let there be f girls, so there are f + 5 boys.',
          'Since handshakes happen only between a boy and a girl, and every such pair shakes hands once, the number of handshakes is the number of boys times the number of girls.',
          'This gives f × (f + 5) = 36.',
          'Write 36 as a product of two positive integers differing by 5: 4 × 9 = 36 and 9 − 4 = 5, which fits.',
          'So there are 4 girls and 4 + 5 = 9 boys, and the answer is 9 boys.',
        ],
        'ja' => [
          '女子を f 人とすると、男子は f + 5 人です。',
          '握手は男女の間だけで、どの男女の組もちょうど 1 回ずつなので、握手の回数は男子の人数と女子の人数の積になります。',
          'よって f × (f + 5) = 36 という式が立ちます。',
          '36 を差が 5 になる 2 つの正の整数の積に分けると、4 × 9 = 36 で 9 − 4 = 5 となり条件に合います。',
          'したがって女子は 4 人、男子は 4 + 5 = 9 人で、答えは 9 人です。',
        ],
      },
      value: '9', max_digits: 2,
      reference: '由次數反推人數（完全圖改為二部圖）',
      notes: '設計依據：既有題是每兩人都握手、次數為 C(n,2)，本題改成只有男女之間握手，次數變成兩群人數的乘積，並加上人數差的條件；計數模型與方程都不同；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（握手・二部圖）',
    ),
  ],
  'geometry' => [
    int_q(
      topic: 'geometry', subtopic: 'ladder_slide_pythagorean', subtopic_zh: '梯子滑動',
      prompt: {
        'zh-Hant' => '一把梯子靠在垂直的牆上，底端與牆腳的距離是 9 公尺。把梯子的底端沿地面再向外移動 3 公尺後，梯子的頂端沿著牆面下滑了 3 公尺。求這把梯子的長度是幾公尺。',
        'zh-Hans' => '一把梯子靠在垂直的墙上，底端与墙脚的距离是 9 米。把梯子的底端沿地面再向外移动 3 米后，梯子的顶端沿着墙面下滑了 3 米。求这把梯子的长度是几米。',
        'en' => 'A ladder leans against a vertical wall with its foot 9 metres from the base of the wall. When the foot is moved a further 3 metres away along the ground, the top of the ladder slides 3 metres down the wall. Find the length of the ladder in metres.',
        'ja' => 'はしごが垂直なかべに立てかけられていて、下端はかべのねもとから 9 m はなれています。下端を地面にそってさらに 3 m 外へ動かすと、はしごの上端はかべにそって 3 m ずり下がりました。このはしごの長さは何メートルですか。',
      },
      answer: { 'zh-Hant' => '答案是 15 公尺。', 'zh-Hans' => '答案是 15 米。',
                'en' => 'The answer is 15 metres.', 'ja' => '答えは 15 メートルです。' },
      steps: {
        'zh-Hant' => [
          '設梯長是 L 公尺。梯子、牆、地面圍成直角三角形，斜邊就是梯子。',
          '一開始底端離牆 9 公尺，所以頂端高度是 √(L² − 81)；移動後底端離牆 12 公尺，頂端高度是 √(L² − 144)。',
          '頂端下滑 3 公尺，表示 √(L² − 81) − √(L² − 144) = 3。',
          '注意到 9、12 讓人聯想到常見的直角三角形邊長：若 L = 15，則兩個高度分別是 √(225 − 81) = 12 和 √(225 − 144) = 9。',
          '12 − 9 = 3，正好符合下滑 3 公尺的條件，所以梯子長 15 公尺。',
        ],
        'zh-Hans' => [
          '设梯长是 L 米。梯子、墙、地面围成直角三角形，斜边就是梯子。',
          '一开始底端离墙 9 米，所以顶端高度是 √(L² − 81)；移动后底端离墙 12 米，顶端高度是 √(L² − 144)。',
          '顶端下滑 3 米，表示 √(L² − 81) − √(L² − 144) = 3。',
          '注意到 9、12 让人联想到常见的直角三角形边长：若 L = 15，则两个高度分别是 √(225 − 81) = 12 和 √(225 − 144) = 9。',
          '12 − 9 = 3，正好符合下滑 3 米的条件，所以梯子长 15 米。',
        ],
        'en' => [
          'Let the ladder have length L metres. The ladder, the wall and the ground form a right triangle whose hypotenuse is the ladder.',
          'At first the foot is 9 metres out, so the top is at height √(L² − 81); afterwards the foot is 12 metres out and the top is at height √(L² − 144).',
          'The top sliding down 3 metres means √(L² − 81) − √(L² − 144) = 3.',
          'The numbers 9 and 12 suggest a familiar right triangle: if L = 15 the two heights are √(225 − 81) = 12 and √(225 − 144) = 9.',
          'Since 12 − 9 = 3, this matches the 3 metre slide exactly, so the ladder is 15 metres long.',
        ],
        'ja' => [
          'はしごの長さを L m とします。はしご・かべ・地面は直角三角形をつくり、斜辺がはしごです。',
          'はじめ下端はかべから 9 m なので上端の高さは √(L² − 81)、動かしたあとは下端が 12 m で上端の高さは √(L² − 144) です。',
          '上端が 3 m ずり下がったので、√(L² − 81) − √(L² − 144) = 3 が成り立ちます。',
          '9 と 12 からよく知られた直角三角形が思いうかびます。L = 15 とすると 2 つの高さは √(225 − 81) = 12 と √(225 − 144) = 9 です。',
          '12 − 9 = 3 で条件にぴったり合うので、はしごの長さは 15 メートルです。',
        ],
      },
      value: '15', max_digits: 2,
      reference: '梯子滑動（由給梯長求位移改為給位移求梯長）',
      notes: '設計依據：既有題給定梯長與位移求另一段位移，本題把梯長設為未知，改由前後兩個位置的高度差反求梯長，必須同時列出兩個畢氏關係式；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（梯子滑動・逆推梯長）',
    ),
    int_q(
      topic: 'geometry', subtopic: 'isosceles_perimeter_case', subtopic_zh: '等腰三角形的邊長',
      prompt: {
        'zh-Hant' => '一個等腰三角形的周長是 20 公分，三邊長都是整數公分，而且其中有一邊長 6 公分。這樣的三角形一共有幾種？（三邊長度相同的視為同一種。）',
        'zh-Hans' => '一个等腰三角形的周长是 20 厘米，三边长都是整数厘米，而且其中有一边长 6 厘米。这样的三角形一共有几种？（三边长度相同的视为同一种。）',
        'en' => 'An isosceles triangle has a perimeter of 20 cm, all three side lengths whole numbers of centimetres, and one of its sides is 6 cm. How many such triangles are there? (Triangles with the same three side lengths count as one.)',
        'ja' => 'ある二等辺三角形の周の長さは 20 cm で、3 辺の長さはすべて整数センチメートル、そのうち 1 辺は 6 cm です。このような三角形は全部で何種類ありますか。（3 辺の長さが同じものは 1 種類と数えます。）',
      },
      answer: { 'zh-Hant' => '答案是 2 種。', 'zh-Hans' => '答案是 2 种。',
                'en' => 'The answer is 2 triangles.', 'ja' => '答えは 2 種類です。' },
      steps: {
        'zh-Hant' => [
          '等腰三角形有兩條邊等長，題目說有一邊是 6 公分，所以要分成兩種情況討論。',
          '情況一：6 公分是兩條相等的腰。此時兩腰共 12 公分，底邊是 20 − 12 = 8 公分，三邊為 6、6、8。檢查 6 + 6 = 12 > 8，可以圍成三角形。',
          '情況二：6 公分是底邊。此時兩腰共 20 − 6 = 14 公分，每腰 7 公分，三邊為 7、7、6。檢查 7 + 6 = 13 > 7，也可以圍成三角形。',
          '兩種情況都成立，而且 (6, 6, 8) 與 (6, 7, 7) 的三邊長不同，是不同的三角形。',
          '所以符合條件的三角形一共有 2 種。',
        ],
        'zh-Hans' => [
          '等腰三角形有两条边等长，题目说有一边是 6 厘米，所以要分成两种情况讨论。',
          '情况一：6 厘米是两条相等的腰。此时两腰共 12 厘米，底边是 20 − 12 = 8 厘米，三边为 6、6、8。检查 6 + 6 = 12 > 8，可以围成三角形。',
          '情况二：6 厘米是底边。此时两腰共 20 − 6 = 14 厘米，每腰 7 厘米，三边为 7、7、6。检查 7 + 6 = 13 > 7，也可以围成三角形。',
          '两种情况都成立，而且 (6, 6, 8) 与 (6, 7, 7) 的三边长不同，是不同的三角形。',
          '所以符合条件的三角形一共有 2 种。',
        ],
        'en' => [
          'An isosceles triangle has two equal sides, and one side is given as 6 cm, so there are two cases to consider.',
          'Case one: 6 cm is the length of the two equal sides. They total 12 cm, so the base is 20 − 12 = 8 cm, giving sides 6, 6, 8. Checking, 6 + 6 = 12 > 8, so this triangle exists.',
          'Case two: 6 cm is the base. The two equal sides total 20 − 6 = 14 cm, so each is 7 cm, giving sides 7, 7, 6. Checking, 7 + 6 = 13 > 7, so this triangle exists too.',
          'Both cases work, and (6, 6, 8) and (6, 7, 7) have different side lengths, so they are different triangles.',
          'There are therefore 2 such triangles.',
        ],
        'ja' => [
          '二等辺三角形には等しい 2 辺があり、1 辺が 6 cm と与えられているので、2 つの場合に分けて考えます。',
          '場合 1：6 cm が等しい 2 辺のとき、2 辺で 12 cm なので底辺は 20 − 12 = 8 cm となり、3 辺は 6、6、8 です。6 + 6 = 12 > 8 なので三角形になります。',
          '場合 2：6 cm が底辺のとき、等しい 2 辺の和は 20 − 6 = 14 cm で 1 辺 7 cm、3 辺は 7、7、6 です。7 + 6 = 13 > 7 なのでこれも三角形になります。',
          'どちらの場合も成り立ち、(6, 6, 8) と (6, 7, 7) は 3 辺の長さがちがうので別の三角形です。',
          'したがって条件に合う三角形は 2 種類です。',
        ],
      },
      value: '2', max_digits: 1,
      reference: '等腰三角形的邊長（由求周長改為求方案數）',
      notes: '設計依據：既有題給兩邊長直接求周長，本題固定周長改問符合條件的三角形種數，必須分「6 為腰」與「6 為底」兩種情況並各自驗證三角不等式；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（等腰・分類計數）',
    ),
  ],
  'logic' => [
    int_q(
      topic: 'logic', subtopic: 'hanoi_min_moves', subtopic_zh: '移盤最少次數',
      prompt: {
        'zh-Hant' => '有 A、B、C 三根柱子由左到右排成一列，A 柱上由下而上套著 3 個大小不同的圓盤，大的在下、小的在上。每次只能搬動一根柱子最上面的一個圓盤，任何時候都不可以把大圓盤放在小圓盤上面，而且這次多了一條規定：每次只能把圓盤搬到左右相鄰的柱子（A 和 C 之間不可以直接互搬）。要把全部 3 個圓盤搬到 C 柱，最少要搬幾次？',
        'zh-Hans' => '有 A、B、C 三根柱子由左到右排成一列，A 柱上由下而上套着 3 个大小不同的圆盘，大的在下、小的在上。每次只能搬动一根柱子最上面的一个圆盘，任何时候都不可以把大圆盘放在小圆盘上面，而且这次多了一条规定：每次只能把圆盘搬到左右相邻的柱子（A 和 C 之间不可以直接互搬）。要把全部 3 个圆盘搬到 C 柱，最少要搬几次？',
        'en' => 'Three pegs A, B and C stand in a row from left to right, and peg A holds 3 discs of different sizes, larger ones below smaller ones. Only the top disc of a peg may be moved at a time, a larger disc may never rest on a smaller one, and there is now an extra rule: a disc may only be moved to an adjacent peg, so nothing may go directly between A and C. What is the smallest number of moves needed to get all 3 discs onto peg C?',
        'ja' => 'A、B、C の 3 本の柱が左から右に並んでいて、柱 A には大きさのちがう円盤が 3 枚、大きいものが下になるように重ねてあります。1 回に動かせるのは柱のいちばん上の円盤 1 枚だけで、大きい円盤を小さい円盤の上に置くことはできません。さらに今回は「円盤はとなり合う柱にしか動かせない（A と C の間で直接動かせない）」という規則が加わります。3 枚すべてを柱 C に移すには、最少で何回動かせばよいですか。',
      },
      answer: { 'zh-Hant' => '答案是 26 次。', 'zh-Hans' => '答案是 26 次。',
                'en' => 'The answer is 26 moves.', 'ja' => '答えは 26 回です。' },
      steps: {
        'zh-Hant' => [
          '設把 n 個圓盤從一端的柱子搬到另一端的柱子，最少需要 g(n) 次。',
          '因為不能直接在 A 和 C 之間搬，最大的圓盤要從 A 搬到 C，必須先搬到 B、再從 B 搬到 C，也就是最大盤要動 2 次。',
          '在最大盤第一次移動前，上面 n − 1 個圓盤必須全部讓開到 C；最大盤搬到 B 之後，那 n − 1 個圓盤又必須全部從 C 搬回 A；最大盤再搬到 C 之後，它們還要從 A 搬到 C。',
          '所以上面 n − 1 個圓盤總共要做 3 趟端對端的搬運，於是 g(n) = 3 × g(n − 1) + 2，而 g(0) = 0。',
          '依序計算：g(1) = 2，g(2) = 3 × 2 + 2 = 8，g(3) = 3 × 8 + 2 = 26，所以最少要搬 26 次。',
        ],
        'zh-Hans' => [
          '设把 n 个圆盘从一端的柱子搬到另一端的柱子，最少需要 g(n) 次。',
          '因为不能直接在 A 和 C 之间搬，最大的圆盘要从 A 搬到 C，必须先搬到 B、再从 B 搬到 C，也就是最大盘要动 2 次。',
          '在最大盘第一次移动前，上面 n − 1 个圆盘必须全部让开到 C；最大盘搬到 B 之后，那 n − 1 个圆盘又必须全部从 C 搬回 A；最大盘再搬到 C 之后，它们还要从 A 搬到 C。',
          '所以上面 n − 1 个圆盘总共要做 3 趟端对端的搬运，于是 g(n) = 3 × g(n − 1) + 2，而 g(0) = 0。',
          '依次计算：g(1) = 2，g(2) = 3 × 2 + 2 = 8，g(3) = 3 × 8 + 2 = 26，所以最少要搬 26 次。',
        ],
        'en' => [
          'Let g(n) be the least number of moves needed to take n discs from one end peg to the other end peg.',
          'Since nothing may pass directly between A and C, the largest disc must go from A to B and then from B to C, so it moves twice.',
          'Before the largest disc first moves, the n − 1 discs above it must all be out of the way on C; after it reaches B, those n − 1 discs must all travel back from C to A; and after it reaches C, they must travel from A to C again.',
          'So the upper n − 1 discs make three end-to-end journeys, giving g(n) = 3 × g(n − 1) + 2, with g(0) = 0.',
          'Computing in turn: g(1) = 2, g(2) = 3 × 2 + 2 = 8, and g(3) = 3 × 8 + 2 = 26, so 26 moves are needed.',
        ],
        'ja' => [
          'n 枚の円盤を一方のはしの柱からもう一方のはしの柱へ移すのに必要な最少回数を g(n) とします。',
          'A と C の間は直接動かせないので、いちばん大きい円盤は A から B、B から C と 2 回動く必要があります。',
          'いちばん大きい円盤が最初に動く前に、その上の n − 1 枚はすべて C へどかしておく必要があり、大きい円盤が B に来たあとは n − 1 枚を C から A へ戻し、大きい円盤が C に来たあとにまた A から C へ移します。',
          'つまり上の n − 1 枚ははしからはしへ 3 回移動するので、g(n) = 3 × g(n − 1) + 2、g(0) = 0 となります。',
          '順に計算すると g(1) = 2、g(2) = 3 × 2 + 2 = 8、g(3) = 3 × 8 + 2 = 26 なので、最少 26 回です。',
        ],
      },
      value: '26', max_digits: 2,
      reference: '移盤最少次數（加入只能搬相鄰柱的限制）',
      notes: '設計依據：既有題是標準河內塔、遞迴式為 2ⁿ − 1，本題限制只能搬到相鄰柱，最大盤必須走兩步、上層必須來回三趟，遞迴式變成 g(n)=3g(n−1)+2；已用寬度優先搜尋窮舉狀態驗證最少次數為 26；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（河內塔・相鄰柱限制）',
    ),
    int_q(
      topic: 'logic', subtopic: 'paper_folding_layers', subtopic_zh: '對摺的層數',
      prompt: {
        'zh-Hant' => '把一條繩子對摺 3 次（每次都把整疊繩子一起對摺），然後在整疊繩子長度的正中間剪一刀，剪的位置不在任何摺疊處。把繩子完全攤開後，繩子被剪成幾段？',
        'zh-Hans' => '把一条绳子对折 3 次（每次都把整叠绳子一起对折），然后在整叠绳子长度的正中间剪一刀，剪的位置不在任何折叠处。把绳子完全摊开后，绳子被剪成几段？',
        'en' => 'A rope is folded in half 3 times, each time folding the whole bundle together, and then a single cut is made across the bundle at the middle of its length, not at any fold. When the rope is opened out completely, into how many pieces has it been cut?',
        'ja' => '1 本のひもを 3 回半分に折り（そのつど束全体をまとめて折ります）、束の長さのちょうどまん中で 1 回だけ切ります。切る位置は折り目ではありません。ひもを完全に開いたとき、ひもは何本に切れていますか。',
      },
      answer: { 'zh-Hant' => '答案是 9 段。', 'zh-Hans' => '答案是 9 段。',
                'en' => 'The answer is 9 pieces.', 'ja' => '答えは 9 本です。' },
      steps: {
        'zh-Hant' => [
          '每對摺一次，繩子的層數就變成兩倍：對摺 1 次是 2 層，2 次是 4 層，3 次是 8 層。',
          '剪一刀會同時剪過這 8 層，所以攤開後的繩子上一共出現 8 個被剪開的位置。',
          '題目說剪的位置不在摺疊處，所以這 8 個位置都是真正的斷點，不會有兩個斷點重合。',
          '一條繩子上有 k 個斷點時，會被分成 k + 1 段。',
          '所以繩子被剪成 8 + 1 = 9 段。',
        ],
        'zh-Hans' => [
          '每对折一次，绳子的层数就变成两倍：对折 1 次是 2 层，2 次是 4 层，3 次是 8 层。',
          '剪一刀会同时剪过这 8 层，所以摊开后的绳子上一共出现 8 个被剪开的位置。',
          '题目说剪的位置不在折叠处，所以这 8 个位置都是真正的断点，不会有两个断点重合。',
          '一条绳子上有 k 个断点时，会被分成 k + 1 段。',
          '所以绳子被剪成 8 + 1 = 9 段。',
        ],
        'en' => [
          'Each fold doubles the number of layers: after 1 fold there are 2 layers, after 2 folds 4 layers, and after 3 folds 8 layers.',
          'A single cut passes through all 8 layers at once, so the opened-out rope has 8 places where it was cut.',
          'The cut is not at a fold, so all 8 places are genuine break points and no two of them coincide.',
          'A rope with k break points falls into k + 1 pieces.',
          'So the rope is cut into 8 + 1 = 9 pieces.',
        ],
        'ja' => [
          '半分に折るたびに層の数は 2 倍になり、1 回で 2 層、2 回で 4 層、3 回で 8 層になります。',
          '1 回の切断で 8 層すべてを切るので、開いたひもには切れた場所が 8 か所できます。',
          '切る位置は折り目ではないので、この 8 か所はすべて本当の切れ目で、重なることはありません。',
          '1 本のひもに切れ目が k か所あると、ひもは k + 1 本に分かれます。',
          'したがってひもは 8 + 1 = 9 本に切れています。',
        ],
      },
      value: '9', max_digits: 1,
      reference: '對摺的層數（由數層數改為數剪後段數）',
      notes: '設計依據：既有題只問對摺後的層數，本題再剪一刀改問段數，除了層數的倍增外還要處理「k 個斷點分成 k + 1 段」的端點效應；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（對摺・剪後段數）',
    ),
  ],
  'number_theory' => [
    int_q(
      topic: 'number_theory', subtopic: 'frobenius_number', subtopic_zh: '無法湊出的金額',
      prompt: {
        'zh-Hant' => '郵局只賣 4 元和 7 元兩種郵票，每種都可以買任意多張（也可以一張都不買）。有些正整數金額無法用這兩種郵票剛好湊出來。求這些無法湊出的金額一共有幾個。',
        'zh-Hans' => '邮局只卖 4 元和 7 元两种邮票，每种都可以买任意多张（也可以一张都不买）。有些正整数金额无法用这两种邮票刚好凑出来。求这些无法凑出的金额一共有几个。',
        'en' => 'A post office sells only 4-dollar and 7-dollar stamps, and any number of each may be bought, including none. Some whole-dollar amounts cannot be made up exactly from these stamps. How many such amounts are there in total?',
        'ja' => '郵便局では 4 円と 7 円の 2 種類の切手だけを売っていて、どちらも何枚でも買えます（0 枚でもかまいません）。この 2 種類ではちょうど作れない正の整数の金額がいくつかあります。作れない金額は全部で何通りありますか。',
      },
      answer: { 'zh-Hant' => '答案是 9 個。', 'zh-Hans' => '答案是 9 个。',
                'en' => 'The answer is 9 amounts.', 'ja' => '答えは 9 通りです。' },
      steps: {
        'zh-Hant' => [
          '先把金額依除以 4 的餘數分成四組來看，因為加上 4 元郵票不會改變餘數。',
          '在每一組裡，只要能湊出該組最小的金額，比它大且同餘的金額都可以靠多買 4 元郵票湊出。',
          '餘數 0 那組最小可湊出的是 0；餘數 3 那組要靠一張 7 元，最小是 7；餘數 2 那組要兩張 7 元，最小是 14；餘數 1 那組要三張 7 元，最小是 21。',
          '所以每組湊不出的金額分別是：餘 0 組沒有；餘 3 組是 3；餘 2 組是 2、6、10；餘 1 組是 1、5、9、13、17。',
          '合計 0 + 1 + 3 + 5 = 9 個，所以無法湊出的金額一共有 9 個。',
        ],
        'zh-Hans' => [
          '先把金额依除以 4 的余数分成四组来看，因为加上 4 元邮票不会改变余数。',
          '在每一组里，只要能凑出该组最小的金额，比它大且同余的金额都可以靠多买 4 元邮票凑出。',
          '余数 0 那组最小可凑出的是 0；余数 3 那组要靠一张 7 元，最小是 7；余数 2 那组要两张 7 元，最小是 14；余数 1 那组要三张 7 元，最小是 21。',
          '所以每组凑不出的金额分别是：余 0 组没有；余 3 组是 3；余 2 组是 2、6、10；余 1 组是 1、5、9、13、17。',
          '合计 0 + 1 + 3 + 5 = 9 个，所以无法凑出的金额一共有 9 个。',
        ],
        'en' => [
          'Sort the amounts by their remainder on division by 4, since adding a 4-dollar stamp never changes that remainder.',
          'Within each class, once the smallest reachable amount is known, every larger amount in the same class is reachable by adding more 4-dollar stamps.',
          'For remainder 0 the smallest reachable amount is 0; for remainder 3 it takes one 7-dollar stamp, so 7; for remainder 2 it takes two, so 14; for remainder 1 it takes three, so 21.',
          'The unreachable amounts in each class are therefore: none for remainder 0; 3 for remainder 3; 2, 6, 10 for remainder 2; and 1, 5, 9, 13, 17 for remainder 1.',
          'Altogether that is 0 + 1 + 3 + 5 = 9, so 9 amounts cannot be made.',
        ],
        'ja' => [
          '4 円切手を足しても 4 でわった余りは変わらないので、金額を 4 でわった余りごとに 4 つの組に分けて考えます。',
          '各組では、その組で作れる最小の金額さえわかれば、それより大きい同じ余りの金額は 4 円切手を足して作れます。',
          '余り 0 の組で作れる最小は 0、余り 3 の組は 7 円切手 1 枚で 7、余り 2 の組は 2 枚で 14、余り 1 の組は 3 枚で 21 です。',
          'よって作れない金額は、余り 0 の組はなし、余り 3 の組は 3、余り 2 の組は 2、6、10、余り 1 の組は 1、5、9、13、17 です。',
          '合計 0 + 1 + 3 + 5 = 9 個なので、作れない金額は 9 通りです。',
        ],
      },
      value: '9', max_digits: 2,
      reference: '無法湊出的金額（由最大值改為個數）',
      notes: '設計依據：既有題求最大無法湊出的金額，本題改問無法湊出的金額共有幾個，必須依餘數分組逐組找出臨界值再累計，推理路徑與只找單一最大值不同；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（湊錢・不可表示的個數）',
    ),
    int_q(
      topic: 'number_theory', subtopic: 'divisor_count', subtopic_zh: '因數個數',
      prompt: {
        'zh-Hant' => '求最小的正整數，使得它恰好有 12 個正因數。',
        'zh-Hans' => '求最小的正整数，使得它恰好有 12 个正因数。',
        'en' => 'Find the smallest positive integer that has exactly 12 positive divisors.',
        'ja' => '正の約数がちょうど 12 個であるような最小の正の整数を求めなさい。',
      },
      answer: { 'zh-Hant' => '答案是 60。', 'zh-Hans' => '答案是 60。', 'en' => 'The answer is 60.', 'ja' => '答えは 60 です。' },
      steps: {
        'zh-Hant' => [
          '若一個數分解質因數後寫成各質數的次方相乘，則它的正因數個數等於每個次方各加 1 之後的乘積。',
          '要讓因數個數是 12，就要把 12 拆成幾個大於 1 的整數相乘：12、6 × 2、4 × 3、3 × 2 × 2。',
          '每一種拆法對應的次方組合是：一個質數的 11 次方、次方 5 與 1、次方 3 與 2、次方 2 與 1 與 1。',
          '要讓數字最小，應該把較大的次方配給較小的質數。四種情形的最小值分別是 2¹¹ = 2048、2⁵ × 3 = 96、2³ × 3² = 72、2² × 3 × 5 = 60。',
          '比較這四個數，最小的是 60，所以答案是 60。',
        ],
        'zh-Hans' => [
          '若一个数分解质因数后写成各质数的次方相乘，则它的正因数个数等于每个次方各加 1 之后的乘积。',
          '要让因数个数是 12，就要把 12 拆成几个大于 1 的整数相乘：12、6 × 2、4 × 3、3 × 2 × 2。',
          '每一种拆法对应的次方组合是：一个质数的 11 次方、次方 5 与 1、次方 3 与 2、次方 2 与 1 与 1。',
          '要让数字最小，应该把较大的次方配给较小的质数。四种情形的最小值分别是 2¹¹ = 2048、2⁵ × 3 = 96、2³ × 3² = 72、2² × 3 × 5 = 60。',
          '比较这四个数，最小的是 60，所以答案是 60。',
        ],
        'en' => [
          'If a number is written as a product of prime powers, its number of positive divisors is the product of each exponent increased by 1.',
          'For 12 divisors, write 12 as a product of integers greater than 1: 12, 6 × 2, 4 × 3, and 3 × 2 × 2.',
          'The matching exponent patterns are: one prime to the 11th power; exponents 5 and 1; exponents 3 and 2; and exponents 2, 1 and 1.',
          'To keep the number small, give the larger exponents to the smaller primes. The four smallest candidates are 2¹¹ = 2048, 2⁵ × 3 = 96, 2³ × 3² = 72 and 2² × 3 × 5 = 60.',
          'Comparing these, the smallest is 60, so the answer is 60.',
        ],
        'ja' => [
          'ある数を素因数分解して素数のべきの積で表すと、正の約数の個数は各指数に 1 を加えたものの積になります。',
          '約数を 12 個にするには、12 を 1 より大きい整数の積に分けます。12、6 × 2、4 × 3、3 × 2 × 2 です。',
          'それぞれに対応する指数の組は、ある素数の 11 乗、指数 5 と 1、指数 3 と 2、指数 2 と 1 と 1 です。',
          '数を小さくするには大きい指数を小さい素数に割りあてます。4 通りの最小値は 2¹¹ = 2048、2⁵ × 3 = 96、2³ × 3² = 72、2² × 3 × 5 = 60 です。',
          'これらを比べると最小は 60 なので、答えは 60 です。',
        ],
      },
      value: '60', max_digits: 2,
      reference: '因數個數（由求個數改為求最小數）',
      notes: '設計依據：既有題給定數字直接數因數個數，本題反過來給定因數個數求最小的數，必須先枚舉指數組合再把大指數配給小質數比較大小；屬同水準原創改寫，非抄錄特定官方題。',
      display: '改寫題（因數個數・求最小數）',
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
