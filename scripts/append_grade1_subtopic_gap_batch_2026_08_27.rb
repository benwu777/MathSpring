#!/usr/bin/env ruby
# frozen_string_literal: true

# grade1 subtopic 缺口補題（2026-08-27）
# 依 docs/question-bank-expansion-guidelines.md 補上 grade1 尚未覆蓋的推理骨架：
#   geometry  : rotation / border_counting / paper_folding / shape_counting(三角形計數)
#   logic     : parity_reasoning / neighbor_constraint / grouping_balance
#   arithmetic: remainders(週期) / exchange_chain(等量代換) / inclusion_exclusion(重疊計數)

require 'json'

ROOT = File.expand_path('..', __dir__)
GEOMETRY_PATH = File.join(ROOT, 'assets/questions/geometry/grade1_foundation.geometry.v1.json')
LOGIC_PATH = File.join(ROOT, 'assets/questions/logic/grade1_foundation.logic.v1.json')
ARITHMETIC_PATH = File.join(ROOT, 'assets/questions/arithmetic/grade1_foundation.arithmetic.v1.json')
MANIFEST_PATH = File.join(ROOT, 'assets/questions/manifest.json')

def load_json(path)
  JSON.parse(File.read(path))
end

def save_json(path, data)
  File.write(path, JSON.pretty_generate(data) + "\n")
end

def rewritten_source(reference, notes)
  {
    'type' => 'rewritten_olympiad_style',
    'name' => 'MathSpring Editorial',
    'reference' => reference,
    'notes' => notes,
  }
end

def figure_none
  { 'type' => 'custom', 'kind' => 'none', 'params' => {} }
end

def geometry_scene(params)
  { 'type' => 'custom', 'kind' => 'geometry_scene', 'params' => params.merge('kind' => 'geometry_scene') }
end

def base_question(id:, topic:, subtopic:, prompt:, answer:, steps:, figure:, source:)
  {
    'id' => id,
    'reviewStatus' => 'ok',
    'topic' => topic,
    'subtopic' => subtopic,
    'difficulty' => 'foundation',
    'levelStage' => 'grade1',
    'challengeTier' => 'foundation',
    'prompt' => prompt,
    'answer' => answer,
    'solutionSteps' => steps,
    'figure' => figure,
    'source' => source,
  }
end

def integer_question(max_digits:, value:, **rest)
  base_question(**rest).merge(
    'answerMode' => 'integer_input',
    'correctAnswer' => { 'type' => 'integer', 'value' => value },
    'inputConstraints' => { 'allowNegative' => false, 'maxDigits' => max_digits },
  )
end

def choice_question(options:, correct:, **rest)
  base_question(**rest).merge(
    'answerMode' => 'multiple_choice',
    'options' => options,
    'correctAnswer' => { 'type' => 'choice', 'value' => correct },
  )
end

# ---------------------------------------------------------------- geometry ---

GEOMETRY_QUESTIONS = [
  choice_question(
    id: 'geometry_grade1_foundation_045',
    topic: 'geometry',
    subtopic: 'rotation',
    prompt: {
      'zh-Hant' => '一張正方形卡片平放在桌上，四個角依順時針方向分別標著 1、2、3、4，其中 1 在左上角。把這張卡片在桌面上順時針轉半圈（也就是轉 180 度）。轉完以後，左上角的位置是哪一個數字？',
      'zh-Hans' => '一张正方形卡片平放在桌上，四个角按顺时针方向分别标着 1、2、3、4，其中 1 在左上角。把这张卡片在桌面上顺时针转半圈（也就是转 180 度）。转完以后，左上角的位置是哪一个数字？',
      'en' => 'A square card lies flat on a table. Its four corners are labelled 1, 2, 3, 4 in clockwise order, with 1 at the top-left corner. The card is turned clockwise by half a turn (that is, 180 degrees) on the table. After the turn, which number is at the top-left corner?',
      'ja' => '正方形のカードが机の上に置かれています。4 つの角には時計回りに 1、2、3、4 と書かれていて、1 は左上の角にあります。このカードを机の上で時計回りに半回転（つまり 180 度）回します。回したあと、左上の角にある数字はどれですか。',
    },
    answer: {
      'zh-Hant' => '答案是 3。',
      'zh-Hans' => '答案是 3。',
      'en' => 'The answer is 3.',
      'ja' => '答えは 3 です。',
    },
    steps: {
      'zh-Hant' => [
        '四個角依順時針方向是：左上 1、右上 2、右下 3、左下 4。',
        '轉半圈時，每一個角都會跑到和它正對面的位置。',
        '左上角和右下角正好是一組對角，所以原本在右下角的數字會跑到左上角。',
        '原本在右下角的是 3，所以轉完後左上角是 3。',
      ],
      'zh-Hans' => [
        '四个角按顺时针方向是：左上 1、右上 2、右下 3、左下 4。',
        '转半圈时，每一个角都会跑到和它正对面的位置。',
        '左上角和右下角正好是一组对角，所以原本在右下角的数字会跑到左上角。',
        '原本在右下角的是 3，所以转完后左上角是 3。',
      ],
      'en' => [
        'Going clockwise the corners are: 1 at the top-left, 2 at the top-right, 3 at the bottom-right and 4 at the bottom-left.',
        'A half turn moves every corner to the position directly opposite it.',
        'The top-left and the bottom-right corners form such an opposite pair, so the number at the bottom-right moves to the top-left.',
        'The number at the bottom-right was 3, so 3 ends up at the top-left corner.',
      ],
      'ja' => [
        '時計回りに見ると、左上が 1、右上が 2、右下が 3、左下が 4 です。',
        '半回転すると、どの角もちょうど向かい合った位置に移ります。',
        '左上の角と右下の角は向かい合う組なので、右下にあった数字が左上に移ります。',
        '右下にあったのは 3 なので、回したあとの左上は 3 です。',
      ],
    },
    options: {
      'A' => { 'zh-Hant' => '1', 'zh-Hans' => '1', 'en' => '1', 'ja' => '1' },
      'B' => { 'zh-Hant' => '2', 'zh-Hans' => '2', 'en' => '2', 'ja' => '2' },
      'C' => { 'zh-Hant' => '3', 'zh-Hans' => '3', 'en' => '3', 'ja' => '3' },
      'D' => { 'zh-Hant' => '4', 'zh-Hans' => '4', 'en' => '4', 'ja' => '4' },
    },
    correct: 'C',
    figure: geometry_scene(
      'bounds' => { 'minX' => -0.8, 'minY' => -0.8, 'maxX' => 4.8, 'maxY' => 4.8 },
      'points' => [
        { 'name' => '1', 'x' => 0, 'y' => 4, 'pos' => 'tl' },
        { 'name' => '2', 'x' => 4, 'y' => 4, 'pos' => 'tr' },
        { 'name' => '3', 'x' => 4, 'y' => 0, 'pos' => 'br' },
        { 'name' => '4', 'x' => 0, 'y' => 0, 'pos' => 'bl' },
      ],
      'segments' => [
        { 'from' => '1', 'to' => '2', 'style' => 'solid' },
        { 'from' => '2', 'to' => '3', 'style' => 'solid' },
        { 'from' => '3', 'to' => '4', 'style' => 'solid' },
        { 'from' => '4', 'to' => '1', 'style' => 'solid' },
      ],
    ),
    source: rewritten_source(
      'geometry-grade1-foundation',
      'Original composition in the Math Kangaroo grade 1-2 spatial-tracking style: the solver must follow two linked corner positions through a half turn rather than recognise a shape. Not a reproduction of any past paper.',
    ),
  ),
  integer_question(
    id: 'geometry_grade1_foundation_046',
    topic: 'geometry',
    subtopic: 'border_counting',
    prompt: {
      'zh-Hant' => '用大小一樣的小正方形緊密排成一個 5 排 5 列的大正方形，一共用了 25 個小正方形。其中緊貼著大正方形最外面邊界的小正方形有幾個？',
      'zh-Hans' => '用大小一样的小正方形紧密排成一个 5 排 5 列的大正方形，一共用了 25 个小正方形。其中紧贴着大正方形最外面边界的小正方形有几个？',
      'en' => 'Identical small squares are packed together to form a large square with 5 rows and 5 columns, using 25 small squares in total. How many of these small squares touch the outer boundary of the large square?',
      'ja' => '同じ大きさの小さい正方形をすきまなく並べて、5 行 5 列の大きな正方形を作りました。全部で 25 個の小さい正方形を使っています。このうち、大きな正方形のいちばん外側のふちに接している小さい正方形は何個ですか。',
    },
    answer: {
      'zh-Hant' => '答案是 16。',
      'zh-Hans' => '答案是 16。',
      'en' => 'The answer is 16.',
      'ja' => '答えは 16 です。',
    },
    steps: {
      'zh-Hant' => [
        '大正方形一共有 5 × 5 = 25 個小正方形。',
        '把最外面一圈拿掉後，中間剩下的是 3 排 3 列，也就是 3 × 3 = 9 個小正方形。',
        '如果直接把每邊的 5 個相加成 5 × 4 = 20，就會把四個角的小正方形各多算一次，答案會錯。',
        '所以最外面一圈有 25 − 9 = 16 個小正方形。',
      ],
      'zh-Hans' => [
        '大正方形一共有 5 × 5 = 25 个小正方形。',
        '把最外面一圈拿掉后，中间剩下的是 3 排 3 列，也就是 3 × 3 = 9 个小正方形。',
        '如果直接把每边的 5 个相加成 5 × 4 = 20，就会把四个角的小正方形各多算一次，答案会错。',
        '所以最外面一圈有 25 − 9 = 16 个小正方形。',
      ],
      'en' => [
        'The large square contains 5 × 5 = 25 small squares in total.',
        'Removing the outer ring leaves a block of 3 rows and 3 columns, that is 3 × 3 = 9 small squares.',
        'Adding 5 for each of the four sides to get 5 × 4 = 20 would count each of the four corner squares twice, which gives a wrong answer.',
        'So the outer ring contains 25 − 9 = 16 small squares.',
      ],
      'ja' => [
        '大きな正方形には全部で 5 × 5 = 25 個の小さい正方形があります。',
        'いちばん外側の 1 周を取り除くと、中に 3 行 3 列、つまり 3 × 3 = 9 個の小さい正方形が残ります。',
        '1 辺 5 個を 4 辺分たして 5 × 4 = 20 とすると、4 すみの正方形を 2 回ずつ数えてしまい、答えがまちがいます。',
        'したがっていちばん外側の 1 周は 25 − 9 = 16 個です。',
      ],
    },
    value: '16',
    max_digits: 2,
    figure: figure_none,
    source: rewritten_source(
      'geometry-grade1-foundation',
      'Original composition in the Math Kangaroo grade 1-2 border-counting style; the trap is double counting the four corner cells. Fully self-contained in text, so no figure is attached. Not a reproduction of any past paper.',
    ),
  ),
  integer_question(
    id: 'geometry_grade1_foundation_047',
    topic: 'geometry',
    subtopic: 'paper_folding',
    prompt: {
      'zh-Hant' => '一張正方形色紙，先上下對摺一次，再左右對摺一次，變成一個比較小的正方形。接著在這個小正方形上剪出一個洞，這個洞完全在紙的中間，沒有碰到任何摺線，也沒有碰到紙的邊。把色紙完全攤開後，紙上一共有幾個洞？',
      'zh-Hans' => '一张正方形色纸，先上下对折一次，再左右对折一次，变成一个比较小的正方形。接着在这个小正方形上剪出一个洞，这个洞完全在纸的中间，没有碰到任何折线，也没有碰到纸的边。把色纸完全摊开后，纸上一共有几个洞？',
      'en' => 'A square sheet of paper is folded once from top to bottom and then once from left to right, giving a smaller square. A hole is then cut in this smaller square; the hole lies completely in the middle of the paper and touches neither a fold line nor an edge. After the paper is unfolded completely, how many holes are there altogether?',
      'ja' => '正方形の色紙を、まず上下に 1 回折り、次に左右に 1 回折って、小さい正方形にしました。その小さい正方形に穴を 1 つ切り抜きます。穴は紙のまん中にあり、折り目にも紙のふちにも触れていません。色紙を完全に開いたとき、紙にはあわせて何個の穴がありますか。',
    },
    answer: {
      'zh-Hant' => '答案是 4。',
      'zh-Hans' => '答案是 4。',
      'en' => 'The answer is 4.',
      'ja' => '答えは 4 です。',
    },
    steps: {
      'zh-Hant' => [
        '上下對摺一次之後，紙變成 2 層。',
        '再左右對摺一次之後，紙變成 2 × 2 = 4 層。',
        '剪一刀會同時穿過這 4 層紙，所以每一層上都會出現一個洞。',
        '攤開後這 4 個洞都留在紙上，所以一共有 4 個洞。',
      ],
      'zh-Hans' => [
        '上下对折一次之后，纸变成 2 层。',
        '再左右对折一次之后，纸变成 2 × 2 = 4 层。',
        '剪一刀会同时穿过这 4 层纸，所以每一层上都会出现一个洞。',
        '摊开后这 4 个洞都留在纸上，所以一共有 4 个洞。',
      ],
      'en' => [
        'After folding once from top to bottom the paper is 2 layers thick.',
        'After folding again from left to right the paper is 2 × 2 = 4 layers thick.',
        'One cut goes through all 4 layers at once, so a hole appears on every layer.',
        'When the paper is unfolded all 4 holes remain, so there are 4 holes altogether.',
      ],
      'ja' => [
        '上下に 1 回折ると、紙は 2 枚重ねになります。',
        'さらに左右に 1 回折ると、紙は 2 × 2 = 4 枚重ねになります。',
        '1 回切ると 4 枚すべてを同時に切ることになり、どの層にも穴が 1 つできます。',
        '開くとその 4 個の穴がそのまま残るので、穴は全部で 4 個です。',
      ],
    },
    value: '4',
    max_digits: 1,
    figure: figure_none,
    source: rewritten_source(
      'geometry-grade1-foundation',
      'Original composition in the Math Kangaroo grade 1-2 fold-and-cut style; the solver must reason about layer doubling rather than about symmetry of a folded shape. The renderer cannot depict folding, so no figure is attached. Not a reproduction of any past paper.',
    ),
  ),
  integer_question(
    id: 'geometry_grade1_foundation_048',
    topic: 'geometry',
    subtopic: 'shape_counting',
    prompt: {
      'zh-Hant' => '大三角形 ABC 的底邊是 BC。從頂點 A 分別畫一條直線到底邊上的 D 點和 E 點，D 和 E 都在 B 與 C 之間，而且 D 比 E 靠近 B。在這樣的圖中，一共可以數出幾個三角形？',
      'zh-Hans' => '大三角形 ABC 的底边是 BC。从顶点 A 分别画一条直线到底边上的 D 点和 E 点，D 和 E 都在 B 与 C 之间，而且 D 比 E 靠近 B。在这样的图中，一共可以数出几个三角形？',
      'en' => 'In triangle ABC the base is BC. From the vertex A one line is drawn to a point D on the base and another to a point E on the base, where D and E both lie between B and C and D is closer to B than E is. How many triangles can be counted in the resulting figure altogether?',
      'ja' => '大きな三角形 ABC の底辺は BC です。頂点 A から底辺上の点 D と点 E へ、それぞれ直線を引きます。D と E はどちらも B と C の間にあり、D のほうが E より B に近いところにあります。この図の中に、三角形は全部でいくつありますか。',
    },
    answer: {
      'zh-Hant' => '答案是 6。',
      'zh-Hans' => '答案是 6。',
      'en' => 'The answer is 6.',
      'ja' => '答えは 6 です。',
    },
    steps: {
      'zh-Hant' => [
        '底邊 BC 被 D 和 E 分成 BD、DE、EC 三小段。',
        '圖中每一個三角形的頂點都是 A，底邊則是這三小段中連續的一段或連續的幾段合起來。',
        '只用一小段當底邊的有 ABD、ADE、AEC，共 3 個。',
        '用連續兩小段當底邊的有 ABE、ADC，共 2 個。',
        '三小段全部合起來當底邊的只有 ABC 這 1 個，所以一共有 3 + 2 + 1 = 6 個三角形。',
      ],
      'zh-Hans' => [
        '底边 BC 被 D 和 E 分成 BD、DE、EC 三小段。',
        '图中每一个三角形的顶点都是 A，底边则是这三小段中连续的一段或连续的几段合起来。',
        '只用一小段当底边的有 ABD、ADE、AEC，共 3 个。',
        '用连续两小段当底边的有 ABE、ADC，共 2 个。',
        '三小段全部合起来当底边的只有 ABC 这 1 个，所以一共有 3 + 2 + 1 = 6 个三角形。',
      ],
      'en' => [
        'The base BC is divided by D and E into the three small pieces BD, DE and EC.',
        'Every triangle in the figure has A as its apex, and its base is one of those pieces or several consecutive pieces joined together.',
        'Using a single piece as the base gives ABD, ADE and AEC, that is 3 triangles.',
        'Using two consecutive pieces gives ABE and ADC, that is 2 triangles.',
        'Using all three pieces gives only ABC, so there are 3 + 2 + 1 = 6 triangles in total.',
      ],
      'ja' => [
        '底辺 BC は D と E によって BD、DE、EC の 3 つの部分に分かれます。',
        'この図の三角形はすべて頂点が A で、底辺はこの 3 つの部分のうち 1 つ、または続いたいくつかを合わせたものです。',
        '1 つ分を底辺にするものは ABD、ADE、AEC の 3 個です。',
        '続いた 2 つ分を底辺にするものは ABE、ADC の 2 個です。',
        '3 つ分すべてを底辺にするものは ABC の 1 個だけなので、合計 3 + 2 + 1 = 6 個です。',
      ],
    },
    value: '6',
    max_digits: 1,
    figure: geometry_scene(
      'bounds' => { 'minX' => -0.8, 'minY' => -0.8, 'maxX' => 6.8, 'maxY' => 5.0 },
      'points' => [
        { 'name' => 'A', 'x' => 3, 'y' => 4, 'pos' => 't' },
        { 'name' => 'B', 'x' => 0, 'y' => 0, 'pos' => 'bl' },
        { 'name' => 'D', 'x' => 2, 'y' => 0, 'pos' => 'b' },
        { 'name' => 'E', 'x' => 4, 'y' => 0, 'pos' => 'b' },
        { 'name' => 'C', 'x' => 6, 'y' => 0, 'pos' => 'br' },
      ],
      'segments' => [
        { 'from' => 'A', 'to' => 'B', 'style' => 'solid' },
        { 'from' => 'B', 'to' => 'C', 'style' => 'solid' },
        { 'from' => 'C', 'to' => 'A', 'style' => 'solid' },
        { 'from' => 'A', 'to' => 'D', 'style' => 'solid' },
        { 'from' => 'A', 'to' => 'E', 'style' => 'solid' },
      ],
    ),
    source: rewritten_source(
      'geometry-grade1-foundation',
      'Original composition in the Math Kangaroo grade 1-2 figure-counting style; unlike the existing square-counting item it requires systematic enumeration of consecutive base segments. Not a reproduction of any past paper.',
    ),
  ),
].freeze

# ------------------------------------------------------------------- logic ---

LOGIC_QUESTIONS = [
  choice_question(
    id: 'logic_grade1_foundation_048',
    topic: 'logic',
    subtopic: 'parity_reasoning',
    prompt: {
      'zh-Hant' => '盒子裡有 9 顆糖。老師每次都從盒子裡拿出剛好 2 顆糖發給小朋友，不能多也不能少。這樣一直發下去，最後盒子裡會剩下 1 顆糖，沒辦法再發。小美說：「只要再放進 1 顆糖，就可以把糖全部發完。」小華說：「再放進 2 顆糖，也可以把糖全部發完。」誰說得對？',
      'zh-Hans' => '盒子里有 9 颗糖。老师每次都从盒子里拿出刚好 2 颗糖发给小朋友，不能多也不能少。这样一直发下去，最后盒子里会剩下 1 颗糖，没办法再发。小美说：「只要再放进 1 颗糖，就可以把糖全部发完。」小华说：「再放进 2 颗糖，也可以把糖全部发完。」谁说得对？',
      'en' => 'A box contains 9 sweets. Each time, the teacher takes exactly 2 sweets out of the box and hands them to the children, never more and never fewer. Going on like this, 1 sweet is finally left in the box and cannot be handed out. Mei says: "If we put in just 1 more sweet, all of them can be handed out." Hua says: "Putting in 2 more sweets would also let all of them be handed out." Who is right?',
      'ja' => '箱の中にあめが 9 個あります。先生は毎回、箱からちょうど 2 個ずつ取り出して子どもたちにくばります。多くても少なくてもいけません。こうしてくばっていくと、最後に 1 個だけ残ってくばれなくなります。ミイさんは「あめをあと 1 個入れれば、全部くばれるよ」と言い、ホアさんは「あと 2 個入れても、全部くばれるよ」と言いました。正しいことを言っているのはだれですか。',
    },
    answer: {
      'zh-Hant' => '只有小美說得對。',
      'zh-Hans' => '只有小美说得对。',
      'en' => 'Only Mei is right.',
      'ja' => '正しいのはミイさんだけです。',
    },
    steps: {
      'zh-Hant' => [
        '每次都拿走 2 顆，所以能夠剛好發完的糖數一定是 2 的倍數，也就是雙數。',
        '再放進 1 顆後一共有 9 + 1 = 10 顆，10 是雙數，可以剛好發完。',
        '再放進 2 顆後一共有 9 + 2 = 11 顆，11 是單數，發到最後一定還會剩下 1 顆。',
        '所以只有小美說得對。',
      ],
      'zh-Hans' => [
        '每次都拿走 2 颗，所以能够刚好发完的糖数一定是 2 的倍数，也就是双数。',
        '再放进 1 颗后一共有 9 + 1 = 10 颗，10 是双数，可以刚好发完。',
        '再放进 2 颗后一共有 9 + 2 = 11 颗，11 是单数，发到最后一定还会剩下 1 颗。',
        '所以只有小美说得对。',
      ],
      'en' => [
        'Two sweets are taken every time, so a number of sweets that can be handed out exactly must be a multiple of 2, that is, an even number.',
        'Adding 1 sweet gives 9 + 1 = 10 sweets, and 10 is even, so they can all be handed out.',
        'Adding 2 sweets gives 9 + 2 = 11 sweets, and 11 is odd, so 1 sweet is always left at the end.',
        'Therefore only Mei is right.',
      ],
      'ja' => [
        '毎回 2 個ずつ取り出すので、ちょうどくばり終えられる個数は 2 の倍数、つまり偶数でなければなりません。',
        '1 個足すと 9 + 1 = 10 個になり、10 は偶数なのでちょうどくばり終えられます。',
        '2 個足すと 9 + 2 = 11 個になり、11 は奇数なので最後に必ず 1 個残ります。',
        'したがって正しいのはミイさんだけです。',
      ],
    },
    options: {
      'A' => { 'zh-Hant' => '只有小美說得對', 'zh-Hans' => '只有小美说得对', 'en' => 'Only Mei is right', 'ja' => 'ミイさんだけが正しい' },
      'B' => { 'zh-Hant' => '只有小華說得對', 'zh-Hans' => '只有小华说得对', 'en' => 'Only Hua is right', 'ja' => 'ホアさんだけが正しい' },
      'C' => { 'zh-Hant' => '兩個人都說得對', 'zh-Hans' => '两个人都说得对', 'en' => 'Both of them are right', 'ja' => '二人とも正しい' },
      'D' => { 'zh-Hant' => '兩個人都說錯了', 'zh-Hans' => '两个人都说错了', 'en' => 'Neither of them is right', 'ja' => '二人とも正しくない' },
    },
    correct: 'A',
    figure: figure_none,
    source: rewritten_source(
      'logic-grade1-foundation',
      'Original composition in the Math Kangaroo grade 1-2 parity style; the two claims force the solver to test odd and even totals instead of computing a single remainder. Not a reproduction of any past paper.',
    ),
  ),
  integer_question(
    id: 'logic_grade1_foundation_049',
    topic: 'logic',
    subtopic: 'neighbor_constraint',
    prompt: {
      'zh-Hant' => '小安、小美、小樂三個人要站成一排照相。小安和小美不願意站在相鄰的位置。符合這個條件的排法一共有幾種？',
      'zh-Hans' => '小安、小美、小乐三个人要站成一排照相。小安和小美不愿意站在相邻的位置。符合这个条件的排法一共有几种？',
      'en' => 'An, Mei and Le are going to stand in a row for a photograph. An and Mei refuse to stand next to each other. How many arrangements satisfy this condition?',
      'ja' => 'アンさん、ミイさん、レさんの 3 人が一列に並んで写真をとります。アンさんとミイさんはとなり合って立ちたくありません。この条件に合う並び方は全部で何通りですか。',
    },
    answer: {
      'zh-Hant' => '答案是 2。',
      'zh-Hans' => '答案是 2。',
      'en' => 'The answer is 2.',
      'ja' => '答えは 2 です。',
    },
    steps: {
      'zh-Hant' => [
        '三個人站成一排，如果沒有任何限制，一共有 6 種排法。',
        '一排只有三個位置：頭、中間、尾，而中間的位置和頭、尾都相鄰。',
        '要讓小安和小美不相鄰，中間就一定要站小樂，小安和小美只能分別站在頭和尾。',
        '這時只有「小安在頭、小美在尾」和「小美在頭、小安在尾」兩種情況，所以符合條件的排法有 2 種。',
      ],
      'zh-Hans' => [
        '三个人站成一排，如果没有任何限制，一共有 6 种排法。',
        '一排只有三个位置：头、中间、尾，而中间的位置和头、尾都相邻。',
        '要让小安和小美不相邻，中间就一定要站小乐，小安和小美只能分别站在头和尾。',
        '这时只有「小安在头、小美在尾」和「小美在头、小安在尾」两种情况，所以符合条件的排法有 2 种。',
      ],
      'en' => [
        'With no restriction at all, three people can stand in a row in 6 ways.',
        'A row has only three places: front, middle and back, and the middle place is next to both the front and the back.',
        'So that An and Mei are not next to each other, Le must take the middle place, leaving An and Mei at the two ends.',
        'That leaves only "An at the front, Mei at the back" and "Mei at the front, An at the back", so there are 2 arrangements.',
      ],
      'ja' => [
        '3 人が一列に並ぶとき、条件がなければ並び方は全部で 6 通りです。',
        '列には前・まん中・後ろの 3 つの場所しかなく、まん中は前とも後ろともとなり合っています。',
        'アンさんとミイさんがとなり合わないためには、まん中にレさんが立つしかなく、アンさんとミイさんは両はしに分かれます。',
        'このとき「アンさんが前」と「ミイさんが前」の 2 通りだけなので、条件に合う並び方は 2 通りです。',
      ],
    },
    value: '2',
    max_digits: 1,
    figure: figure_none,
    source: rewritten_source(
      'logic-grade1-foundation',
      'Original composition in the Math Kangaroo grade 1-2 constrained-arrangement style; the adjacency ban forces case elimination rather than a plain count of orderings. Not a reproduction of any past paper.',
    ),
  ),
  integer_question(
    id: 'logic_grade1_foundation_050',
    topic: 'logic',
    subtopic: 'grouping_balance',
    prompt: {
      'zh-Hant' => '有 7 張卡片，上面分別寫著 1、2、3、4、5、6、7。要把這 7 張卡片分成兩堆，讓兩堆卡片上的數字和一樣大。這時其中一堆最少可以只有幾張卡片？',
      'zh-Hans' => '有 7 张卡片，上面分别写着 1、2、3、4、5、6、7。要把这 7 张卡片分成两堆，让两堆卡片上的数字和一样大。这时其中一堆最少可以只有几张卡片？',
      'en' => 'There are 7 cards, showing the numbers 1, 2, 3, 4, 5, 6 and 7. The cards are to be split into two piles so that the numbers on each pile add up to the same total. What is the smallest possible number of cards in one of the piles?',
      'ja' => '1、2、3、4、5、6、7 と書かれた 7 枚のカードがあります。この 7 枚を 2 つの山に分け、それぞれの山の数字の和が同じになるようにします。このとき、一方の山のカードは最も少なくて何枚にできますか。',
    },
    answer: {
      'zh-Hant' => '答案是 3。',
      'zh-Hans' => '答案是 3。',
      'en' => 'The answer is 3.',
      'ja' => '答えは 3 です。',
    },
    steps: {
      'zh-Hant' => [
        '這 7 個數的總和是 1 + 2 + 3 + 4 + 5 + 6 + 7 = 28。',
        '兩堆的數字和要一樣大，所以每一堆的數字和都必須是 28 ÷ 2 = 14。',
        '如果一堆只有 1 張卡片，最大也只有 7，不到 14。',
        '如果一堆只有 2 張卡片，最大是 7 + 6 = 13，還是不到 14。',
        '用 3 張卡片時 7 + 6 + 1 = 14 剛好可以，所以一堆最少要有 3 張卡片。',
      ],
      'zh-Hans' => [
        '这 7 个数的总和是 1 + 2 + 3 + 4 + 5 + 6 + 7 = 28。',
        '两堆的数字和要一样大，所以每一堆的数字和都必须是 28 ÷ 2 = 14。',
        '如果一堆只有 1 张卡片，最大也只有 7，不到 14。',
        '如果一堆只有 2 张卡片，最大是 7 + 6 = 13，还是不到 14。',
        '用 3 张卡片时 7 + 6 + 1 = 14 刚好可以，所以一堆最少要有 3 张卡片。',
      ],
      'en' => [
        'The seven numbers add up to 1 + 2 + 3 + 4 + 5 + 6 + 7 = 28.',
        'The two piles must have equal totals, so each pile has to add up to 28 ÷ 2 = 14.',
        'A pile of just 1 card reaches at most 7, which is less than 14.',
        'A pile of 2 cards reaches at most 7 + 6 = 13, still less than 14.',
        'With 3 cards, 7 + 6 + 1 = 14 works exactly, so the smallest possible pile has 3 cards.',
      ],
      'ja' => [
        '7 つの数の合計は 1 + 2 + 3 + 4 + 5 + 6 + 7 = 28 です。',
        '2 つの山の和を同じにするので、どちらの山も和は 28 ÷ 2 = 14 でなければなりません。',
        'カードが 1 枚だけの山は最大でも 7 で、14 に届きません。',
        'カードが 2 枚の山は最大でも 7 + 6 = 13 で、やはり 14 に届きません。',
        '3 枚なら 7 + 6 + 1 = 14 でちょうどよいので、少ないほうの山は最も少なくて 3 枚です。',
      ],
    },
    value: '3',
    max_digits: 1,
    figure: figure_none,
    source: rewritten_source(
      'logic-grade1-foundation',
      'Original composition in the Math Kangaroo grade 1-2 balanced-grouping style; the solver must bound the pile size from above before constructing an example, not merely split a set. Not a reproduction of any past paper.',
    ),
  ),
].freeze

# -------------------------------------------------------------- arithmetic ---

ARITHMETIC_QUESTIONS = [
  integer_question(
    id: 'arithmetic_grade1_foundation_063',
    topic: 'arithmetic',
    subtopic: 'remainders',
    prompt: {
      'zh-Hant' => '小安用紅、黃、藍三種顏色的珠子串成一條項鍊，顏色依照紅、黃、藍、紅、黃、藍……的順序一直重複下去。從第 1 顆數到第 20 顆為止，其中藍色的珠子一共有幾顆？',
      'zh-Hans' => '小安用红、黄、蓝三种颜色的珠子串成一条项链，颜色按照红、黄、蓝、红、黄、蓝……的顺序一直重复下去。从第 1 颗数到第 20 颗为止，其中蓝色的珠子一共有几颗？',
      'en' => 'An threads a necklace with red, yellow and blue beads, repeating the order red, yellow, blue, red, yellow, blue, and so on. Counting from the 1st bead up to the 20th bead, how many blue beads are there altogether?',
      'ja' => 'アンさんは赤・黄・青のビーズを、赤、黄、青、赤、黄、青……の順にくり返しつないでネックレスを作ります。1 個目から 20 個目まで数えたとき、青いビーズは全部で何個ありますか。',
    },
    answer: {
      'zh-Hant' => '答案是 6。',
      'zh-Hans' => '答案是 6。',
      'en' => 'The answer is 6.',
      'ja' => '答えは 6 です。',
    },
    steps: {
      'zh-Hant' => [
        '顏色每 3 顆重複一次，紅、黃、藍各出現 1 次，藍色是每一組裡的第 3 顆。',
        '20 ÷ 3 = 6 餘 2，所以 20 顆珠子可以分成 6 組完整的 3 顆，再多出 2 顆。',
        '6 組完整的珠子裡各有 1 顆藍色，一共是 6 顆。',
        '多出來的 2 顆依序是紅色和黃色，裡面沒有藍色，所以藍色一共有 6 顆。',
      ],
      'zh-Hans' => [
        '颜色每 3 颗重复一次，红、黄、蓝各出现 1 次，蓝色是每一组里的第 3 颗。',
        '20 ÷ 3 = 6 余 2，所以 20 颗珠子可以分成 6 组完整的 3 颗，再多出 2 颗。',
        '6 组完整的珠子里各有 1 颗蓝色，一共是 6 颗。',
        '多出来的 2 颗依次是红色和黄色，里面没有蓝色，所以蓝色一共有 6 颗。',
      ],
      'en' => [
        'The colours repeat every 3 beads, with red, yellow and blue appearing once each, and blue is the 3rd bead of every group.',
        'Since 20 ÷ 3 = 6 remainder 2, the 20 beads form 6 complete groups of 3 beads with 2 beads left over.',
        'Each of the 6 complete groups contains 1 blue bead, giving 6 blue beads.',
        'The 2 leftover beads are red and yellow, with no blue among them, so there are 6 blue beads altogether.',
      ],
      'ja' => [
        '色は 3 個ごとにくり返し、赤・黄・青が 1 回ずつ現れます。青は各組の 3 個目です。',
        '20 ÷ 3 = 6 あまり 2 なので、20 個は 3 個ずつの完全な組が 6 組と、あまり 2 個に分けられます。',
        '完全な 6 組にはそれぞれ青が 1 個ずつあり、合わせて 6 個です。',
        'あまりの 2 個は順に赤と黄で青はないので、青いビーズは全部で 6 個です。',
      ],
    },
    value: '6',
    max_digits: 2,
    figure: figure_none,
    source: rewritten_source(
      'arithmetic-grade1-foundation',
      'Original composition in the Math Kangaroo grade 1-2 cyclic-pattern style; the solver must combine the cycle length with the remainder to count occurrences, not just name the colour at one position. Not a reproduction of any past paper.',
    ),
  ),
  integer_question(
    id: 'arithmetic_grade1_foundation_064',
    topic: 'arithmetic',
    subtopic: 'exchange_chain',
    prompt: {
      'zh-Hant' => '在一家小店裡，2 顆蘋果可以換 3 根香蕉，1 根香蕉可以換 2 顆糖。小安帶了 4 顆蘋果去換，最多可以換到幾顆糖？',
      'zh-Hans' => '在一家小店里，2 颗苹果可以换 3 根香蕉，1 根香蕉可以换 2 颗糖。小安带了 4 颗苹果去换，最多可以换到几颗糖？',
      'en' => 'At a small shop, 2 apples can be exchanged for 3 bananas, and 1 banana can be exchanged for 2 sweets. An brings 4 apples to exchange. At most how many sweets can An get?',
      'ja' => 'ある店では、りんご 2 個をバナナ 3 本と交換でき、バナナ 1 本をあめ 2 個と交換できます。アンさんはりんごを 4 個持っていきました。あめは最も多くて何個もらえますか。',
    },
    answer: {
      'zh-Hant' => '答案是 12。',
      'zh-Hans' => '答案是 12。',
      'en' => 'The answer is 12.',
      'ja' => '答えは 12 です。',
    },
    steps: {
      'zh-Hant' => [
        '4 顆蘋果可以分成 2 組，每組 2 顆蘋果。',
        '每 2 顆蘋果換 3 根香蕉，所以 4 顆蘋果一共換到 3 × 2 = 6 根香蕉。',
        '每 1 根香蕉換 2 顆糖，所以 6 根香蕉一共換到 6 × 2 = 12 顆糖。',
        '所以小安最多可以換到 12 顆糖。',
      ],
      'zh-Hans' => [
        '4 颗苹果可以分成 2 组，每组 2 颗苹果。',
        '每 2 颗苹果换 3 根香蕉，所以 4 颗苹果一共换到 3 × 2 = 6 根香蕉。',
        '每 1 根香蕉换 2 颗糖，所以 6 根香蕉一共换到 6 × 2 = 12 颗糖。',
        '所以小安最多可以换到 12 颗糖。',
      ],
      'en' => [
        'The 4 apples can be split into 2 groups of 2 apples each.',
        'Every 2 apples give 3 bananas, so the 4 apples give 3 × 2 = 6 bananas.',
        'Every banana gives 2 sweets, so the 6 bananas give 6 × 2 = 12 sweets.',
        'Therefore An can get at most 12 sweets.',
      ],
      'ja' => [
        'りんご 4 個は、2 個ずつの 2 組に分けられます。',
        'りんご 2 個でバナナ 3 本なので、りんご 4 個ではバナナが 3 × 2 = 6 本になります。',
        'バナナ 1 本であめ 2 個なので、バナナ 6 本ではあめが 6 × 2 = 12 個になります。',
        'したがってアンさんがもらえるあめは最も多くて 12 個です。',
      ],
    },
    value: '12',
    max_digits: 2,
    figure: figure_none,
    source: rewritten_source(
      'arithmetic-grade1-foundation',
      'Original composition in the Math Kangaroo grade 1-2 exchange-rate style; the solver must chain two different exchange rates through an intermediate good. Not a reproduction of any past paper.',
    ),
  ),
  integer_question(
    id: 'arithmetic_grade1_foundation_065',
    topic: 'arithmetic',
    subtopic: 'inclusion_exclusion',
    prompt: {
      'zh-Hant' => '班上有 10 個小朋友，每個人至少喜歡蘋果和香蕉其中一種。喜歡蘋果的有 6 個人，喜歡香蕉的有 7 個人。兩種都喜歡的有幾個人？',
      'zh-Hans' => '班上有 10 个小朋友，每个人至少喜欢苹果和香蕉其中一种。喜欢苹果的有 6 个人，喜欢香蕉的有 7 个人。两种都喜欢的有几个人？',
      'en' => 'In a class of 10 children, every child likes at least one of apples and bananas. Exactly 6 children like apples and exactly 7 children like bananas. How many children like both?',
      'ja' => 'クラスには子どもが 10 人いて、全員がりんごとバナナの少なくとも一方が好きです。りんごが好きな子は 6 人、バナナが好きな子は 7 人です。両方とも好きな子は何人ですか。',
    },
    answer: {
      'zh-Hant' => '答案是 3。',
      'zh-Hans' => '答案是 3。',
      'en' => 'The answer is 3.',
      'ja' => '答えは 3 です。',
    },
    steps: {
      'zh-Hant' => [
        '把喜歡蘋果的人數和喜歡香蕉的人數加起來，是 6 + 7 = 13 人次。',
        '但是班上只有 10 個人，而且每個人至少喜歡其中一種，所以 10 個人都被算到了。',
        '多出來的 13 − 10 = 3 人次，是因為兩種都喜歡的人被算了兩次。',
        '所以兩種都喜歡的有 3 個人。',
      ],
      'zh-Hans' => [
        '把喜欢苹果的人数和喜欢香蕉的人数加起来，是 6 + 7 = 13 人次。',
        '但是班上只有 10 个人，而且每个人至少喜欢其中一种，所以 10 个人都被算到了。',
        '多出来的 13 − 10 = 3 人次，是因为两种都喜欢的人被算了两次。',
        '所以两种都喜欢的有 3 个人。',
      ],
      'en' => [
        'Adding the number who like apples to the number who like bananas gives 6 + 7 = 13 counts.',
        'But the class has only 10 children, and every child likes at least one fruit, so all 10 are included in that total.',
        'The extra 13 − 10 = 3 counts arise because each child who likes both fruits was counted twice.',
        'Therefore 3 children like both.',
      ],
      'ja' => [
        'りんごが好きな人数とバナナが好きな人数をたすと 6 + 7 = 13 人分になります。',
        'しかしクラスは 10 人で、全員が少なくとも一方を好きなので、10 人はすべて数に入っています。',
        'はみ出した 13 − 10 = 3 人分は、両方とも好きな子を 2 回ずつ数えたためです。',
        'したがって両方とも好きな子は 3 人です。',
      ],
    },
    value: '3',
    max_digits: 1,
    figure: figure_none,
    source: rewritten_source(
      'arithmetic-grade1-foundation',
      'Original composition in the Math Kangaroo grade 1-2 overlapping-groups style; the totals exceed the class size so the solver must reason about double counting. Not a reproduction of any past paper.',
    ),
  ),
].freeze

# ------------------------------------------------------------------ append ---

def append_questions(path, questions)
  pack = load_json(path)
  existing = pack['questions'].map { |q| q['id'] }.to_set
  questions.each do |q|
    raise "duplicate id #{q['id']}" if existing.include?(q['id'])
  end
  pack['questions'].concat(questions)
  save_json(path, pack)
  pack['questions'].length
end

require 'set'

counts = {
  GEOMETRY_PATH => append_questions(GEOMETRY_PATH, GEOMETRY_QUESTIONS),
  LOGIC_PATH => append_questions(LOGIC_PATH, LOGIC_QUESTIONS),
  ARITHMETIC_PATH => append_questions(ARITHMETIC_PATH, ARITHMETIC_QUESTIONS),
}

manifest = load_json(MANIFEST_PATH)
manifest['packs'].each do |pack|
  full = File.join(ROOT, pack['path'])
  next unless counts.key?(full)

  pack['questionCount'] = counts[full]
end
save_json(MANIFEST_PATH, manifest)

counts.each { |path, n| puts "#{File.basename(path)} -> #{n}" }
