#!/usr/bin/env ruby
# grade6 第二輪擴充：幾何 4 題、算術 4 題。
# 同樣先過 scripts/question_similarity_audit.py --candidates 再人工複查。
# logic 一題都沒有：19 個候選中，三進制砝碼撞 logic_grade8_015、100 盞燈撞
# logic_grade9_002、握手少一對撞 mixed_kangaroo56_013、三階幻方撞 logic_grade7_013、
# 倒水量 4 公升撞 logic_grade9_006/032。經典邏輯題型在 grade7-12 已被完整開採。
require 'json'

def t(zh, zhs, en, ja) = { 'zh-Hant' => zh, 'zh-Hans' => zhs, 'en' => en, 'ja' => ja }

def q(id:, subtopic:, prompt:, answer:, steps:, figure:, mode:, correct:,
      options: nil, constraints: nil, notes:)
  h = {
    'reviewStatus' => 'ok', 'topic' => id.split('_').first, 'subtopic' => subtopic,
    'difficulty' => 'foundation', 'levelStage' => 'grade6', 'challengeTier' => 'foundation',
    'prompt' => prompt, 'answer' => answer,
    'solutionSteps' => { 'zh-Hant' => steps[0], 'zh-Hans' => steps[1], 'en' => steps[2], 'ja' => steps[3] },
    'figure' => figure
  }
  h['options'] = options if options
  h['source'] = { 'type' => 'rewritten_olympiad_style', 'name' => 'MathSpring Editorial',
                  'reference' => "#{id.split('_').first}-grade6-foundation", 'notes' => notes }
  h['answerMode'] = mode
  h['correctAnswer'] = correct
  h['inputConstraints'] = constraints if constraints
  h['id'] = id
  h
end

NONE = { 'type' => 'custom', 'kind' => 'none', 'params' => {} }
def scene(p) = { 'type' => 'custom', 'kind' => 'geometry_scene',
                 'params' => p.merge('kind' => 'geometry_scene') }
def int(d) = { 'allowNegative' => false, 'maxDigits' => d }
def ans(v) = { 'type' => 'integer', 'value' => v }
def hid(n, x, y) = { 'name' => n, 'x' => x, 'y' => y, 'visible' => false }
def seg(a, b) = { 'from' => a, 'to' => b, 'style' => 'solid' }

GEO = [
  q(id: 'geometry_grade6_foundation_051', subtopic: 'cube_volume_from_surface',
    prompt: t('一個正方體的表面積是 150 平方公分。這個正方體的體積是幾立方公分？',
              '一个正方体的表面积是 150 平方厘米。这个正方体的体积是几立方厘米？',
              'The surface area of a cube is 150 square centimetres. What is the volume of the cube in cubic centimetres?',
              'ある立方体の表面積は 150 平方 cm です。この立方体の体積は何立方 cm ですか。'),
    answer: t('答案是 125 立方公分。', '答案是 125 立方厘米。', 'The answer is 125 cubic centimetres.', '答えは 125 立方 cm です。'),
    steps: [
      ['正方體有 6 個一樣大的正方形面，所以一個面的面積是 150 ÷ 6 = 25 平方公分。',
       '一個面是正方形，面積 25 平方公分表示邊長是 5 公分，因為 5 × 5 = 25。',
       '體積 = 邊長 × 邊長 × 邊長。',
       '所以體積是 5 × 5 × 5 = 125 立方公分。'],
      ['正方体有 6 个一样大的正方形面，所以一个面的面积是 150 ÷ 6 = 25 平方厘米。',
       '一个面是正方形，面积 25 平方厘米表示边长是 5 厘米，因为 5 × 5 = 25。',
       '体积 = 边长 × 边长 × 边长。',
       '所以体积是 5 × 5 × 5 = 125 立方厘米。'],
      ['A cube has 6 identical square faces, so one face has area 150 ÷ 6 = 25 square centimetres.',
       'A square of area 25 square centimetres has side 5 centimetres, because 5 × 5 = 25.',
       'The volume is side × side × side.',
       'So the volume is 5 × 5 × 5 = 125 cubic centimetres.'],
      ['立方体には同じ大きさの正方形の面が 6 つあるので、1 つの面の面積は 150 ÷ 6 = 25 平方 cm です。',
       '面積 25 平方 cm の正方形の 1 辺は、5 × 5 = 25 より 5 cm です。',
       '体積は 1 辺 × 1 辺 × 1 辺で求められます。',
       'したがって体積は 5 × 5 × 5 = 125 立方 cm です。']],
    figure: NONE, mode: 'integer_input', correct: ans('125'), constraints: int(3),
    notes: 'Original composition in the Math Kangaroo grade 5-6 style. The intended move is going backwards from one face area to the edge and only then forwards to the volume; renderer has no solid shapes, so no figure is shipped.'),

  q(id: 'geometry_grade6_foundation_052', subtopic: 'cut_surface_increase',
    prompt: t('把一個長方體用一刀垂直切開，分成兩個小長方體。切完以後，兩塊小長方體的表面積加起來，比原來那個長方體的表面積多了 40 平方公分。這一刀的切口面積是幾平方公分？',
              '把一个长方体用一刀垂直切开，分成两个小长方体。切完以后，两块小长方体的表面积加起来，比原来那个长方体的表面积多了 40 平方厘米。这一刀的切口面积是几平方厘米？',
              'A cuboid is cut straight through by one plane cut into two smaller cuboids. After the cut, the two pieces have a combined surface area 40 square centimetres greater than the surface area of the original cuboid. What is the area of the cut cross-section in square centimetres?',
              '直方体を 1 回まっすぐに切って、2 つの小さな直方体に分けます。切ったあと、2 つの立体の表面積の合計は、もとの直方体の表面積より 40 平方 cm だけ大きくなりました。この切り口の面積は何平方 cm ですか。'),
    answer: t('答案是 20 平方公分。', '答案是 20 平方厘米。', 'The answer is 20 square centimetres.', '答えは 20 平方 cm です。'),
    steps: [
      ['原來長方體的表面在切開後並沒有消失，也沒有變大或變小。',
       '增加的部分只有切口：切開以後，兩塊各多出一個和切口一樣大的新面。',
       '所以多出來的 40 平方公分，是兩個切口面的面積和。',
       '一個切口的面積是 40 ÷ 2 = 20 平方公分。'],
      ['原来长方体的表面在切开后并没有消失，也没有变大或变小。',
       '增加的部分只有切口：切开以后，两块各多出一个和切口一样大的新面。',
       '所以多出来的 40 平方厘米，是两个切口面的面积和。',
       '一个切口的面积是 40 ÷ 2 = 20 平方厘米。'],
      ['The original outer surface does not disappear when the solid is cut, and it does not grow or shrink either.',
       'The only new area comes from the cut itself: each of the two pieces gains one new face the size of the cross-section.',
       'So the extra 40 square centimetres is the total of those two new faces.',
       'One cross-section therefore has area 40 ÷ 2 = 20 square centimetres.'],
      ['もとの直方体の表面は、切っても消えたり大きさが変わったりはしません。',
       '増えたのは切り口だけで、切ったあと 2 つの立体それぞれに切り口と同じ大きさの新しい面が 1 つずつできます。',
       'したがって増えた 40 平方 cm は、その新しい 2 つの面の合計です。',
       '切り口 1 つの面積は 40 ÷ 2 = 20 平方 cm です。']],
    figure: NONE, mode: 'integer_input', correct: ans('20'), constraints: int(2),
    notes: 'Original composition in the Math Kangaroo grade 5-6 style. The intended move is noticing that a cut adds exactly two copies of the cross-section and changes nothing else, so no dimension of the solid is ever needed; renderer has no solid shapes, so no figure is shipped.'),

  q(id: 'geometry_grade6_foundation_053', subtopic: 'open_box_volume',
    prompt: t('如圖，一張長 20 公分、寬 12 公分的長方形紙板，在四個角各剪掉一個邊長 3 公分的正方形，再把四邊往上摺，做成一個沒有蓋子的盒子。這個盒子的容積是幾立方公分？',
              '如图，一张长 20 厘米、宽 12 厘米的长方形纸板，在四个角各剪掉一个边长 3 厘米的正方形，再把四边往上折，做成一个没有盖子的盒子。这个盒子的容积是几立方厘米？',
              'As in the figure, a rectangular sheet of card 20 cm long and 12 cm wide has a square of side 3 cm cut away from each of its four corners. The four flaps are then folded up to make a box with no lid. What is the capacity of the box in cubic centimetres?',
              '図のように、たて 12 cm、よこ 20 cm の長方形の厚紙の四すみから、1 辺 3 cm の正方形を切り取り、まわりを上に折り曲げてふたのない箱を作ります。この箱の容積は何立方 cm ですか。'),
    answer: t('答案是 252 立方公分。', '答案是 252 立方厘米。', 'The answer is 252 cubic centimetres.', '答えは 252 立方 cm です。'),
    steps: [
      ['摺起來以後，被摺上去的部分高度就是剪掉的正方形邊長，也就是 3 公分。',
       '盒底的長，是原本的長扣掉左右兩個角各 3 公分：20 − 3 − 3 = 14 公分。',
       '盒底的寬，是原本的寬扣掉上下兩個角各 3 公分：12 − 3 − 3 = 6 公分。',
       '容積 = 14 × 6 × 3 = 252 立方公分。'],
      ['折起来以后，被折上去的部分高度就是剪掉的正方形边长，也就是 3 厘米。',
       '盒底的长，是原本的长扣掉左右两个角各 3 厘米：20 − 3 − 3 = 14 厘米。',
       '盒底的宽，是原本的宽扣掉上下两个角各 3 厘米：12 − 3 − 3 = 6 厘米。',
       '容积 = 14 × 6 × 3 = 252 立方厘米。'],
      ['Once the flaps are folded up, the height of the box is the side of the squares removed, that is 3 cm.',
       'The length of the base is the original length minus 3 cm at each end: 20 − 3 − 3 = 14 cm.',
       'The width of the base is the original width minus 3 cm at each end: 12 − 3 − 3 = 6 cm.',
       'The capacity is 14 × 6 × 3 = 252 cubic centimetres.'],
      ['折り曲げると、箱の高さは切り取った正方形の 1 辺、つまり 3 cm になります。',
       '底面のよこの長さは、もとのよこから両はしの 3 cm ずつを引いて 20 − 3 − 3 = 14 cm です。',
       '底面のたての長さは、もとのたてから両はしの 3 cm ずつを引いて 12 − 3 − 3 = 6 cm です。',
       '容積は 14 × 6 × 3 = 252 立方 cm です。']],
    figure: scene(
      'bounds' => { 'minX' => -0.6, 'minY' => -0.6, 'maxX' => 10.6, 'maxY' => 6.6 },
      'points' => [
        hid('A', 0, 6), hid('B', 10, 6), hid('C', 10, 0), hid('D', 0, 0),
        hid('a1', 0, 4.5), hid('a2', 1.5, 4.5), hid('a3', 1.5, 6),
        hid('b1', 8.5, 6), hid('b2', 8.5, 4.5), hid('b3', 10, 4.5),
        hid('c1', 10, 1.5), hid('c2', 8.5, 1.5), hid('c3', 8.5, 0),
        hid('d1', 1.5, 0), hid('d2', 1.5, 1.5), hid('d3', 0, 1.5)
      ],
      'segments' => [
        seg('A', 'B'), seg('B', 'C'), seg('C', 'D'), seg('D', 'A'),
        seg('a1', 'a2'), seg('a2', 'a3'),
        seg('b1', 'b2'), seg('b2', 'b3'),
        seg('c1', 'c2'), seg('c2', 'c3'),
        seg('d1', 'd2'), seg('d2', 'd3')
      ]),
    mode: 'integer_input', correct: ans('252'), constraints: int(3),
    notes: 'Original composition in the Math Kangaroo grade 5-6 style. The intended move is seeing that each dimension of the base loses the corner square twice while the fold height gains it once; the figure shows only the sheet and the corner squares described in the text.'),

  q(id: 'geometry_grade6_foundation_054', subtopic: 'equal_perimeter_comparison',
    prompt: t('一個圓的周長和一個正方形的周長剛好一樣長。這兩個圖形的面積，哪一個比較大？',
              '一个圆的周长和一个正方形的周长刚好一样长。这两个图形的面积，哪一个比较大？',
              'A circle and a square have exactly the same perimeter. Which of the two shapes has the greater area?',
              'ある円のまわりの長さと、ある正方形のまわりの長さがちょうど同じです。この 2 つの図形の面積は、どちらが大きいですか。'),
    answer: t('答案是圓的面積比較大。', '答案是圆的面积比较大。', 'The answer is that the circle has the greater area.', '答えは、円の面積のほうが大きい、です。'),
    steps: [
      ['把共同的周長當成一個固定的長度，分別算出兩個圖形的面積是這個長度的多少倍。',
       '正方形的邊長是周長的四分之一，面積是邊長的平方，也就是周長平方的 1 ÷ 16。',
       '圓的周長是 2 × 圓周率 × 半徑，所以半徑是周長除以（2 × 圓周率）；代進圓面積公式，圓面積是周長平方的 1 ÷（4 × 圓周率），大約是 1 ÷ 12.56。',
       '把兩個數比一比：1 ÷ 12.56 大於 1 ÷ 16，所以在周長相同時，圓的面積比較大。'],
      ['把共同的周长当成一个固定的长度，分别算出两个图形的面积是这个长度的多少倍。',
       '正方形的边长是周长的四分之一，面积是边长的平方，也就是周长平方的 1 ÷ 16。',
       '圆的周长是 2 × 圆周率 × 半径，所以半径是周长除以（2 × 圆周率）；代进圆面积公式，圆面积是周长平方的 1 ÷（4 × 圆周率），大约是 1 ÷ 12.56。',
       '把两个数比一比：1 ÷ 12.56 大于 1 ÷ 16，所以在周长相同时，圆的面积比较大。'],
      ['Treat the shared perimeter as one fixed length and work out what fraction of its square each area is.',
       'The side of the square is a quarter of the perimeter, and its area is the side squared, which is 1 ÷ 16 of the perimeter squared.',
       'The circumference of a circle is 2 × pi × radius, so the radius is the perimeter divided by 2 × pi; putting that into the area formula makes the circle 1 ÷ (4 × pi) of the perimeter squared, about 1 ÷ 12.56.',
       'Comparing the two fractions, 1 ÷ 12.56 is bigger than 1 ÷ 16, so for the same perimeter the circle has the greater area.'],
      ['共通のまわりの長さを 1 つの決まった長さと考え、それぞれの面積がその長さの何倍になるかを求めます。',
       '正方形の 1 辺はまわりの長さの 4 分の 1 で、面積は 1 辺を 2 回かけたものなので、まわりの長さの 2 乗の 1 ÷ 16 です。',
       '円のまわりの長さは 2 × 円周率 × 半径なので、半径はまわりの長さを 2 × 円周率 で割った値です。これを円の面積の式に入れると、まわりの長さの 2 乗の 1 ÷（4 × 円周率）、およそ 1 ÷ 12.56 になります。',
       '2 つを比べると 1 ÷ 12.56 のほうが 1 ÷ 16 より大きいので、まわりの長さが同じなら円の面積のほうが大きくなります。']],
    figure: NONE, mode: 'multiple_choice',
    options: { 'A' => t('圓的面積比較大', '圆的面积比较大', 'The circle has the greater area', '円の面積のほうが大きい'),
               'B' => t('正方形的面積比較大', '正方形的面积比较大', 'The square has the greater area', '正方形の面積のほうが大きい'),
               'C' => t('兩個面積一樣大', '两个面积一样大', 'The two areas are equal', '2 つの面積は等しい'),
               'D' => t('要看周長是多少才能決定', '要看周长是多少才能决定', 'It depends on how long the perimeter is', 'まわりの長さがいくつかによって変わる') },
    correct: { 'type' => 'choice', 'value' => 'A' },
    notes: 'Original composition in the Math Kangaroo grade 5-6 style. The intended move is normalising both areas against the same perimeter so the comparison becomes 4 x pi against 16; option D is the trap for students who expect the answer to depend on the size. No figure is shipped because drawing the two shapes would give the comparison away by eye.')
]

ARI = [
  q(id: 'arithmetic_grade6_foundation_068', subtopic: 'surplus_deficit',
    prompt: t('把一堆糖果分給一群小朋友。如果每個人分 5 顆，糖果就少了 3 顆；如果每個人分 4 顆，糖果就會多出 6 顆。小朋友一共有幾人？',
              '把一堆糖果分给一群小朋友。如果每个人分 5 颗，糖果就少了 3 颗；如果每个人分 4 颗，糖果就会多出 6 颗。小朋友一共有几人？',
              'A pile of sweets is to be shared among a group of children. If each child gets 5 sweets, the pile is 3 sweets short; if each child gets 4 sweets, 6 sweets are left over. How many children are there?',
              'あるだけのあめを子どもたちで分けます。1 人に 5 個ずつ配るとあめが 3 個足りず、1 人に 4 個ずつ配ると 6 個あまります。子どもは全部で何人ですか。'),
    answer: t('答案是 9 人。', '答案是 9 人。', 'The answer is 9.', '答えは 9 人です。'),
    steps: [
      ['每人分 5 顆和每人分 4 顆，每個小朋友都相差 1 顆，所以總共需要的糖果相差「人數」顆。',
       '第一種分法差 3 顆才夠，第二種分法還剩 6 顆，兩種情形之間相差 3 + 6 = 9 顆。',
       '這 9 顆就等於人數，所以小朋友有 9 人。',
       '驗算：糖果共有 5 × 9 − 3 = 42 顆，而 4 × 9 + 6 = 42 顆，兩邊相同，答案是 9 人。'],
      ['每人分 5 颗和每人分 4 颗，每个小朋友都相差 1 颗，所以总共需要的糖果相差「人数」颗。',
       '第一种分法差 3 颗才够，第二种分法还剩 6 颗，两种情形之间相差 3 + 6 = 9 颗。',
       '这 9 颗就等于人数，所以小朋友有 9 人。',
       '验算：糖果共有 5 × 9 − 3 = 42 颗，而 4 × 9 + 6 = 42 颗，两边相同，答案是 9 人。'],
      ['Giving 5 each instead of 4 each means one extra sweet per child, so the two plans differ in total by exactly the number of children.',
       'The first plan falls 3 short and the second leaves 6 over, so the two situations are 3 + 6 = 9 sweets apart.',
       'Those 9 sweets equal the number of children, so there are 9 children.',
       'Checking: the pile holds 5 × 9 − 3 = 42 sweets, and 4 × 9 + 6 = 42 as well, so the answer is 9 children.'],
      ['1 人に 5 個ずつ配る場合と 4 個ずつ配る場合では 1 人あたり 1 個ちがうので、必要な合計は「子どもの人数」だけちがいます。',
       '前者は 3 個足りず、後者は 6 個あまるので、2 つの場合の差は 3 + 6 = 9 個です。',
       'この 9 個が人数にあたるので、子どもは 9 人です。',
       '確かめ：あめは 5 × 9 − 3 = 42 個で、4 × 9 + 6 = 42 個と一致するので、答えは 9 人です。']],
    figure: NONE, mode: 'integer_input', correct: ans('9'), constraints: int(1),
    notes: 'Classic surplus-and-shortage setup authored fresh for grade 6. The intended move is reading the gap between the two plans as one sweet per child, so the number of children falls out without ever finding the pile first.'),

  q(id: 'arithmetic_grade6_foundation_069', subtopic: 'coin_maximization',
    prompt: t('小安有 1 元、5 元、10 元三種硬幣，一共 20 枚，總值剛好 100 元，而且三種硬幣每一種都至少有 1 枚。他最多可能有幾枚 10 元硬幣？',
              '小安有 1 元、5 元、10 元三种硬币，一共 20 枚，总值刚好 100 元，而且三种硬币每一种都至少有 1 枚。他最多可能有几枚 10 元硬币？',
              'An has coins worth 1 dollar, 5 dollars and 10 dollars: 20 coins in all, worth exactly 100 dollars, with at least one coin of each kind. At most how many 10-dollar coins can he have?',
              'アンは 1 円、5 円、10 円の 3 種類の硬貨を合わせて 20 枚持っていて、合計はちょうど 100 円です。どの種類も 1 枚以上あります。10 円硬貨は最も多くて何枚ありえますか。'),
    answer: t('答案是 8 枚。', '答案是 8 枚。', 'The answer is 8.', '答えは 8 枚です。'),
    steps: [
      ['如果 20 枚全都是 1 元，總值只有 20 元，離 100 元還差 80 元。',
       '把一枚 1 元換成 5 元，總值多 4 元；換成 10 元，總值多 9 元。所以「4 ×（5 元的枚數）+ 9 ×（10 元的枚數）= 80」。',
       '要讓 10 元最多，就要讓 5 元盡量少；但每種至少 1 枚，所以 5 元至少 1 枚，此時 9 ×（10 元枚數）最多是 80 − 4 = 76，除以 9 還不到 9，因此 10 元最多 8 枚。',
       '檢查 10 元 8 枚：9 × 8 = 72，剩下 80 − 72 = 8 = 4 × 2，所以 5 元 2 枚、1 元 10 枚，合計 20 枚共 100 元，成立。答案是 8 枚。'],
      ['如果 20 枚全都是 1 元，总值只有 20 元，离 100 元还差 80 元。',
       '把一枚 1 元换成 5 元，总值多 4 元；换成 10 元，总值多 9 元。所以「4 ×（5 元的枚数）+ 9 ×（10 元的枚数）= 80」。',
       '要让 10 元最多，就要让 5 元尽量少；但每种至少 1 枚，所以 5 元至少 1 枚，此时 9 ×（10 元枚数）最多是 80 − 4 = 76，除以 9 还不到 9，因此 10 元最多 8 枚。',
       '检查 10 元 8 枚：9 × 8 = 72，剩下 80 − 72 = 8 = 4 × 2，所以 5 元 2 枚、1 元 10 枚，合计 20 枚共 100 元，成立。答案是 8 枚。'],
      ['If all 20 coins were 1-dollar coins the total would be only 20 dollars, which is 80 dollars short of 100.',
       'Turning a 1-dollar coin into a 5-dollar coin adds 4 dollars, and into a 10-dollar coin adds 9 dollars, so 4 × (number of 5s) + 9 × (number of 10s) = 80.',
       'To make the 10s as many as possible the 5s must be as few as possible, but there must be at least one 5, so 9 × (number of 10s) is at most 80 − 4 = 76, which is less than 9 × 9. Hence there are at most 8 ten-dollar coins.',
       'Checking 8 tens: 9 × 8 = 72, leaving 80 − 72 = 8 = 4 × 2, so 2 fives and 10 ones, which is 20 coins worth 100 dollars. The answer is 8.'],
      ['20 枚がすべて 1 円だとすると合計は 20 円で、100 円には 80 円足りません。',
       '1 円を 5 円に替えると 4 円増え、10 円に替えると 9 円増えるので、4 ×（5 円の枚数）＋ 9 ×（10 円の枚数）= 80 となります。',
       '10 円をできるだけ多くするには 5 円をできるだけ少なくしますが、どの種類も 1 枚以上なので 5 円は最低 1 枚です。すると 9 ×（10 円の枚数）は最大でも 80 − 4 = 76 で、9 × 9 に届かないため 10 円は最大 8 枚です。',
       '確かめ：10 円が 8 枚なら 9 × 8 = 72 で、残り 80 − 72 = 8 = 4 × 2 より 5 円が 2 枚、1 円が 10 枚。合わせて 20 枚 100 円になるので、答えは 8 枚です。']],
    figure: NONE, mode: 'integer_input', correct: ans('8'), constraints: int(2),
    notes: 'Original composition in the Math Kangaroo grade 5-6 style. The intended move is the all-ones baseline plus the per-swap gain, which converts two conditions into a single equation before the maximisation; the at-least-one condition is what stops the naive answer of 9.'),

  q(id: 'arithmetic_grade6_foundation_070', subtopic: 'average_speed_round_trip',
    prompt: t('小明從家裡走到學校，去的時候每分鐘走 60 公尺，回來走同一條路，每分鐘走 40 公尺。他這趟來回的平均速度是每分鐘幾公尺？',
              '小明从家里走到学校，去的时候每分钟走 60 米，回来走同一条路，每分钟走 40 米。他这趟来回的平均速度是每分钟几米？',
              'Ming walks from home to school at 60 metres per minute and walks back along the same road at 40 metres per minute. What is his average speed for the whole trip, in metres per minute?',
              'ミンは家から学校まで分速 60 m で歩き、同じ道を分速 40 m で歩いて帰りました。この往復全体の平均の速さは分速何 m ですか。'),
    answer: t('答案是每分鐘 48 公尺。', '答案是每分钟 48 米。', 'The answer is 48 metres per minute.', '答えは分速 48 m です。'),
    steps: [
      ['平均速度是「總路程 ÷ 總時間」，不是把兩個速度直接相加除以 2。',
       '單程長度題目沒有給，可以自己選一個方便的數：取 60 和 40 的公倍數 120 公尺。',
       '去程 120 ÷ 60 = 2 分鐘，回程 120 ÷ 40 = 3 分鐘，來回總時間 5 分鐘，總路程 120 + 120 = 240 公尺。',
       '所以平均速度是 240 ÷ 5 = 每分鐘 48 公尺（不是 50 公尺，因為走得慢的那一段花掉比較多時間）。'],
      ['平均速度是「总路程 ÷ 总时间」，不是把两个速度直接相加除以 2。',
       '单程长度题目没有给，可以自己选一个方便的数：取 60 和 40 的公倍数 120 米。',
       '去程 120 ÷ 60 = 2 分钟，回程 120 ÷ 40 = 3 分钟，来回总时间 5 分钟，总路程 120 + 120 = 240 米。',
       '所以平均速度是 240 ÷ 5 = 每分钟 48 米（不是 50 米，因为走得慢的那一段花掉比较多时间）。'],
      ['Average speed is total distance divided by total time, not the two speeds added and halved.',
       'The one-way distance is not given, so choose a convenient one: take 120 metres, a common multiple of 60 and 40.',
       'Going takes 120 ÷ 60 = 2 minutes and returning takes 120 ÷ 40 = 3 minutes, so the trip takes 5 minutes in total and covers 120 + 120 = 240 metres.',
       'The average speed is therefore 240 ÷ 5 = 48 metres per minute, not 50, because the slower leg uses up more of the time.'],
      ['平均の速さは「全体の道のり ÷ 全体の時間」であって、2 つの速さを足して 2 で割ったものではありません。',
       '片道の長さは与えられていないので、都合のよい数を選びます。60 と 40 の公倍数である 120 m とします。',
       '行きは 120 ÷ 60 = 2 分、帰りは 120 ÷ 40 = 3 分なので、往復の時間は 5 分、道のりは 120 + 120 = 240 m です。',
       'したがって平均の速さは 240 ÷ 5 = 分速 48 m です。50 m にならないのは、おそいほうの区間に時間が多くかかるからです。']],
    figure: NONE, mode: 'integer_input', correct: ans('48'), constraints: int(2),
    notes: 'Original composition in the Math Kangaroo grade 5-6 style. The intended move is choosing a convenient one-way distance because the answer is independent of it; averaging the two speeds to 50 is the trap.'),

  q(id: 'arithmetic_grade6_foundation_071', subtopic: 'block_sequence_position',
    prompt: t('有一列數是 1、2、2、3、3、3、4、4、4、4、5、5、5、5、5、⋯，規則是數字 n 連續出現 n 次。這一列數中，第 50 個數是多少？',
              '有一列数是 1、2、2、3、3、3、4、4、4、4、5、5、5、5、5、⋯，规则是数字 n 连续出现 n 次。这一列数中，第 50 个数是多少？',
              'A list of numbers begins 1, 2, 2, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 5, … , where each number n appears n times in a row. What is the 50th number in the list?',
              '数の列 1、2、2、3、3、3、4、4、4、4、5、5、5、5、5、⋯ は、数 n がつづけて n 回あらわれるという決まりでできています。この列の 50 番目の数は何ですか。'),
    answer: t('答案是 10。', '答案是 10。', 'The answer is 10.', '答えは 10 です。'),
    steps: [
      ['寫完數字 n 為止，一共寫了 1 + 2 + 3 + ⋯ + n 個數。',
       '把這些總數逐一算出來：寫完 8 是第 36 個，寫完 9 是第 45 個，寫完 10 是第 55 個。',
       '第 50 個落在 45 和 55 之間，也就是在「寫完 9 之後、寫完 10 之前」的那一段。',
       '那一段全部都是 10（第 46 個到第 55 個），所以第 50 個數是 10。'],
      ['写完数字 n 为止，一共写了 1 + 2 + 3 + ⋯ + n 个数。',
       '把这些总数逐一算出来：写完 8 是第 36 个，写完 9 是第 45 个，写完 10 是第 55 个。',
       '第 50 个落在 45 和 55 之间，也就是在「写完 9 之后、写完 10 之前」的那一段。',
       '那一段全部都是 10（第 46 个到第 55 个），所以第 50 个数是 10。'],
      ['By the time the number n has been written out, the list holds 1 + 2 + 3 + … + n numbers.',
       'Working those totals out: the list reaches position 36 when 8 is finished, position 45 when 9 is finished, and position 55 when 10 is finished.',
       'Position 50 lies between 45 and 55, that is, in the stretch after the 9s and before the 10s end.',
       'Every entry in that stretch, positions 46 to 55, is a 10, so the 50th number is 10.'],
      ['数 n を書き終えた時点で、列には 1 + 2 + 3 + ⋯ + n 個の数がならんでいます。',
       'この合計を順に求めると、8 を書き終えたところが 36 番目、9 を書き終えたところが 45 番目、10 を書き終えたところが 55 番目です。',
       '50 番目は 45 と 55 の間、つまり 9 が終わってから 10 が終わるまでの区間にあります。',
       'この区間（46 番目から 55 番目）はすべて 10 なので、50 番目の数は 10 です。']],
    figure: NONE, mode: 'integer_input', correct: ans('10'), constraints: int(2),
    notes: 'Original composition in the Math Kangaroo grade 5-6 style. The intended move is converting the position question into a running total of triangular numbers and then locating 50 between two of them.')
]

{ 'geometry' => GEO, 'arithmetic' => ARI }.each do |topic, items|
  path = "assets/questions/#{topic}/grade6_foundation.#{topic}.v1.json"
  pack = JSON.parse(File.read(path))
  before = pack['questions'].size
  ids = pack['questions'].map { |x| x['id'] }
  items.each do |it|
    raise "duplicate id #{it['id']}" if ids.include?(it['id'])
    ids << it['id']
    pack['questions'] << it
  end
  File.write(path, JSON.pretty_generate(pack) + "\n")
  puts "#{topic}: #{before} -> #{pack['questions'].size}"
end
