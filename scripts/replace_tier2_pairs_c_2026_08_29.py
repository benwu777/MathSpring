# -*- coding: utf-8 -*-
"""替換最後 10 題模板配對，清掉剩餘的 10 組。

最大的一組是「拼小正方形求周長」家族：geometry_grade2_022（L 形 4 個邊長 1）、
grade3_001（L 形 4 個邊長 2）、grade3_016（T 字形 5 個邊長 1）、
grade4_007（L 形 3 個邊長 3）、grade4_015（L 形 5 個邊長 1）——五題都是
「拼起來後算外圍周長」，只換小正方形的個數、邊長與擺法。保留 grade2_022
當代表，其餘四題換掉。

其他六組各換一題：三角形「第三角＝前兩角和」（g4_018 / g6_015）、
數字卡最大減最小（g2_027 / g3_009）、盒子開關輪次（g2_022 / g4_020）、
小正方形排長方形（g2_036 / g5_032）、挖角求面積同 pack（g4_002 / g4_042）、
長方形周長加長寬關係（g4_001 / g3_026）。
"""
import json, io
def L(zh, zhs, en, ja): return {'zh-Hant': zh, 'zh-Hans': zhs, 'en': en, 'ja': ja}
P = {}
def rep(path, qid, sub, prompt, answer, st, val, dig, why):
    if path not in P: P[path] = json.load(open(path))
    q = next(x for x in P[path]['questions'] if x['id'] == qid)
    old = q['prompt']['zh-Hant'][:20]
    q.pop('options', None)
    q['subtopic'] = sub; q['prompt'] = prompt; q['answer'] = answer
    q['solutionSteps'] = {'zh-Hant': st[0], 'zh-Hans': st[1], 'en': st[2], 'ja': st[3]}
    assert len({len(v) for v in q['solutionSteps'].values()}) == 1, qid
    q['answerMode'] = 'integer_input'
    q['correctAnswer'] = {'type': 'integer', 'value': val}
    q['inputConstraints'] = {'allowNegative': False, 'maxDigits': dig}
    q['source']['notes'] = 'Replacement authored 2026-08-29 during the whole-bank template scan. ' + why
    print('%-34s %-30s 答%-4s 原: %s…' % (qid[-34:], sub, val, old))

G3='assets/questions/geometry/grade3_foundation.geometry.v1.json'
G4='assets/questions/geometry/grade4_foundation.geometry.v1.json'
A3='assets/questions/arithmetic/grade3_foundation.arithmetic.v1.json'
L4='assets/questions/logic/grade4_foundation.logic.v1.json'
A5='assets/questions/arithmetic/grade5_foundation.arithmetic.v1.json'
SQ='Replaces one of five questions that all glued unit squares together and asked for the outline perimeter.'

rep(G3,'geometry_grade3_foundation_001','top_view_of_stack',
 L('用 5 個一樣大的小正方體堆成一個立體：底層 4 個排成 2 乘 2 的正方形，再在其中一個小正方體的正上方疊 1 個。從正上方往下看這個立體，會看到幾個小正方形？',
   '用 5 个一样大的小正方体堆成一个立体：底层 4 个排成 2 乘 2 的正方形，再在其中一个小正方体的正上方叠 1 个。从正上方往下看这个立体，会看到几个小正方形？',
   'Five identical small cubes are stacked: 4 of them form a 2 by 2 square on the bottom, and 1 more sits directly on top of one of those. Looking straight down from above, how many small squares are seen?',
   '同じ大きさの小さい立方体 5 個で立体を作ります。下の段は 4 個で 2 × 2 の正方形、そのうち 1 個の真上にもう 1 個をのせます。真上から見ると小さい正方形はいくつ見えますか。'),
 L('答案是 4 個。','答案是 4 个。','The answer is 4.','答えは 4 個です。'),
 [['從正上方往下看，看到的是每一個「位置」最上面那一格的頂面，被擋住的下面那些就看不到了。',
   '底層的 4 個小正方體排成 2 乘 2，佔了 4 個不同的位置。',
   '疊在上面的那 1 個，剛好蓋在其中一個位置的正上方，所以它遮住了底下那一個，並沒有多佔一個新位置。',
   '從上往下看到的正方形個數等於「有幾個不同的位置」，也就是 4 個。（雖然一共用了 5 個小正方體，但看到的只有 4 個。）'],
  ['从正上方往下看，看到的是每一个「位置」最上面那一格的顶面，被挡住的下面那些就看不到了。',
   '底层的 4 个小正方体排成 2 乘 2，占了 4 个不同的位置。',
   '叠在上面的那 1 个，刚好盖在其中一个位置的正上方，所以它遮住了底下那一个，并没有多占一个新位置。',
   '从上往下看到的正方形个数等于「有几个不同的位置」，也就是 4 个。（虽然一共用了 5 个小正方体，但看到的只有 4 个。）'],
  ['Looking straight down, what is seen is the top face of the highest cube at each position; anything hidden underneath cannot be seen.',
   'The 4 cubes on the bottom form a 2 by 2 square, occupying 4 different positions.',
   'The extra cube sits directly on top of one of those positions, so it hides the cube below it rather than taking up a new position.',
   'The number of squares seen from above equals the number of distinct positions, which is 4. Five cubes were used, but only 4 are visible from above.'],
  ['真上から見ると、各「位置」でいちばん上の立方体の上の面だけが見え、その下にかくれたものは見えません。',
   '下の段の 4 個は 2 × 2 に並び、4 つのちがう位置を占めています。',
   '上にのせた 1 個はそのうちの 1 か所の真上にあるので、下の 1 個をかくすだけで新しい位置はふえません。',
   '上から見える正方形の数は ちがう位置の数と同じで 4 個です。使ったのは 5 個ですが、見えるのは 4 個です。']],
 '4',1,SQ)

rep(G3,'geometry_grade3_foundation_016','line_circle_intersections',
 L('平面上有一條直線和一個圓。這條直線和這個圓最多可以有幾個交點？',
   '平面上有一条直线和一个圆。这条直线和这个圆最多可以有几个交点？',
   'A straight line and a circle lie in the same plane. What is the greatest number of points at which they can cross?',
   '同じ平面上に直線 1 本と円が 1 つあります。この 2 つが交わる点は最多でいくつですか。'),
 L('答案是 2 個。','答案是 2 个。','The answer is 2.','答えは 2 個です。'),
 [['直線和圓的位置關係只有三種，可以一種一種看。',
   '第一種：直線離圓太遠，完全沒有碰到圓，交點 0 個。',
   '第二種：直線剛好碰到圓的邊緣一下就離開（也就是切線），交點 1 個。',
   '第三種：直線穿過圓的內部，會從一邊進去、另一邊出來，交點 2 個。這是最多的情形，所以答案是 2 個。（直線是直的，穿過圓後不會再彎回來，所以不可能有第三個交點。）'],
  ['直线和圆的位置关系只有三种，可以一种一种看。',
   '第一种：直线离圆太远，完全没有碰到圆，交点 0 个。',
   '第二种：直线刚好碰到圆的边缘一下就离开（也就是切线），交点 1 个。',
   '第三种：直线穿过圆的内部，会从一边进去、另一边出来，交点 2 个。这是最多的情形，所以答案是 2 个。（直线是直的，穿过圆后不会再弯回来，所以不可能有第三个交点。）'],
  ['A line and a circle can be positioned in only three ways, so take them one at a time.',
   'First, the line passes too far away and never touches the circle at all, giving 0 crossings.',
   'Second, the line just grazes the edge of the circle and leaves again, that is a tangent, giving 1 crossing.',
   'Third, the line passes through the inside of the circle, entering on one side and leaving on the other, giving 2 crossings. That is the most possible, so the answer is 2. A straight line does not curve back, so a third crossing is impossible.'],
  ['直線と円の位置関係は 3 通りしかないので、順に見ていきます。',
   '1 つ目は、直線が円から遠くまったくふれない場合で、交点は 0 個です。',
   '2 つ目は、直線が円のふちにちょうど 1 度ふれて離れる場合、つまり接線で、交点は 1 個です。',
   '3 つ目は、直線が円の内部を通り、一方から入って反対から出る場合で、交点は 2 個です。これが最多なので答えは 2 個です。直線は曲がりもどらないので 3 個目はありえません。']],
 '2',1,SQ)

rep(G3,'geometry_grade3_foundation_026','perimeter_difference_shapes',
 L('一個正方形和一個正三角形，它們的邊長都是 5 公分。正方形的周長比正三角形的周長多幾公分？',
   '一个正方形和一个正三角形，它们的边长都是 5 厘米。正方形的周长比正三角形的周长多几厘米？',
   'A square and an equilateral triangle both have sides of 5 cm. By how many centimetres is the square\'s perimeter greater than the triangle\'s?',
   '正方形と正三角形があり、どちらも 1 辺が 5 cm です。正方形のまわりの長さは 正三角形より何 cm 長いですか。'),
 L('答案是多 5 公分。','答案是多 5 厘米。','The answer is 5 cm more.','答えは 5 cm 長いです。'),
 [['兩個圖形的邊長一樣，差別只在邊的條數：正方形有 4 條邊，正三角形有 3 條邊。',
   '正方形的周長是 5 × 4 = 20 公分。',
   '正三角形的周長是 5 × 3 = 15 公分。',
   '相差 20 − 15 = 5 公分。（其實正方形就是比正三角形多一條 5 公分的邊，所以差就是一條邊的長度 5 公分。）'],
  ['两个图形的边长一样，差别只在边的条数：正方形有 4 条边，正三角形有 3 条边。',
   '正方形的周长是 5 × 4 = 20 厘米。',
   '正三角形的周长是 5 × 3 = 15 厘米。',
   '相差 20 − 15 = 5 厘米。（其实正方形就是比正三角形多一条 5 厘米的边，所以差就是一条边的长度 5 厘米。）'],
  ['Both shapes have the same side length, so the only difference is how many sides they have: 4 for the square and 3 for the triangle.',
   'The square\'s perimeter is 5 × 4 = 20 cm.',
   'The triangle\'s perimeter is 5 × 3 = 15 cm.',
   'The difference is 20 − 15 = 5 cm. In effect the square simply has one extra 5 cm side, so the difference is just one side length, 5 cm.'],
  ['2 つの図形は 1 辺の長さが同じで、ちがうのは辺の本数だけです。正方形は 4 本、正三角形は 3 本です。',
   '正方形のまわりの長さは 5 × 4 = 20 cm です。',
   '正三角形のまわりの長さは 5 × 3 = 15 cm です。',
   '差は 20 − 15 = 5 cm です。正方形は正三角形より 5 cm の辺が 1 本多いだけなので、差は 1 辺分の 5 cm になります。']],
 '5',1,'Replaces one of a pair giving a perimeter plus a length-width relation and asking for the area.')

rep(G4,'geometry_grade4_foundation_007','acute_angles_three_triangles',
 L('桌上放著一個銳角三角形、一個直角三角形和一個鈍角三角形，各一個。這三個三角形的內角之中，是銳角的一共有幾個？',
   '桌上放着一个锐角三角形、一个直角三角形和一个钝角三角形，各一个。这三个三角形的内角之中，是锐角的一共有几个？',
   'On a table lie one acute triangle, one right triangle and one obtuse triangle. Among all their interior angles, how many are acute?',
   'つくえの上に鋭角三角形・直角三角形・鈍角三角形が 1 つずつあります。これらの内角のうち、鋭角はいくつありますか。'),
 L('答案是 7 個。','答案是 7 个。','The answer is 7.','答えは 7 個です。'),
 [['三角形的內角和是 180 度，所以一個三角形裡最多只能有一個角不是銳角（直角或鈍角），否則兩個角就會加超過 180 度。',
   '銳角三角形的定義是三個角都小於 90 度，所以它有 3 個銳角。',
   '直角三角形有一個 90 度的角，剩下兩個角加起來是 90 度、各自都小於 90 度，所以有 2 個銳角。',
   '鈍角三角形有一個大於 90 度的角，剩下兩個角加起來不到 90 度，也都是銳角，所以有 2 個。合計 3 + 2 + 2 = 7 個。'],
  ['三角形的内角和是 180 度，所以一个三角形里最多只能有一个角不是锐角（直角或钝角），否则两个角就会加超过 180 度。',
   '锐角三角形的定义是三个角都小于 90 度，所以它有 3 个锐角。',
   '直角三角形有一个 90 度的角，剩下两个角加起来是 90 度、各自都小于 90 度，所以有 2 个锐角。',
   '钝角三角形有一个大于 90 度的角，剩下两个角加起来不到 90 度，也都是锐角，所以有 2 个。合计 3 + 2 + 2 = 7 个。'],
  ['The angles of a triangle add to 180 degrees, so at most one angle in a triangle can fail to be acute; two right or obtuse angles would already exceed 180.',
   'An acute triangle is defined by having all three angles under 90 degrees, so it contributes 3 acute angles.',
   'A right triangle has one 90-degree angle, and the other two add to 90 degrees and are each under 90, so it contributes 2.',
   'An obtuse triangle has one angle over 90 degrees, and the other two add to less than 90 and are both acute, so it contributes 2. In total 3 + 2 + 2 = 7.'],
  ['三角形の内角の和は 180 度なので、1 つの三角形の中で鋭角でない角は多くても 1 つです。2 つあれば和が 180 度をこえてしまいます。',
   '鋭角三角形は 3 つの角がすべて 90 度未満と決まっているので、鋭角は 3 つです。',
   '直角三角形は 90 度の角が 1 つあり、残り 2 つの和は 90 度でどちらも 90 度未満なので、鋭角は 2 つです。',
   '鈍角三角形は 90 度をこえる角が 1 つあり、残り 2 つの和は 90 度未満でどちらも鋭角なので 2 つです。合わせて 3 + 2 + 2 = 7 個です。']],
 '7',1,SQ)

rep(G4,'geometry_grade4_foundation_015','hexagon_into_triangles',
 L('從一個正六邊形的中心，連線到它的六個頂點。這樣會把正六邊形分成幾個一模一樣的正三角形？',
   '从一个正六边形的中心，连线到它的六个顶点。这样会把正六边形分成几个一模一样的正三角形？',
   'Lines are drawn from the centre of a regular hexagon to each of its six vertices. Into how many identical equilateral triangles does this divide the hexagon?',
   '正六角形の中心から 6 つの頂点へ線を引きます。正六角形はいくつの合同な正三角形に分かれますか。'),
 L('答案是 6 個。','答案是 6 个。','The answer is 6.','答えは 6 個です。'),
 [['從中心連到六個頂點，一共畫了 6 條線。相鄰的兩條線加上它們之間的那一條邊，就圍成一個三角形。',
   '六邊形有 6 條邊，每一條邊都對應一個這樣的三角形，所以一共分成 6 個三角形。',
   '這些三角形為什麼是正三角形？中心到每個頂點的距離都相等，所以每個三角形都有兩條邊等長；而中心的那個角是 360 ÷ 6 = 60 度。',
   '兩腰等長、夾角 60 度的三角形一定是正三角形。所以正六邊形被分成 6 個一模一樣的正三角形。'],
  ['从中心连到六个顶点，一共画了 6 条线。相邻的两条线加上它们之间的那一条边，就围成一个三角形。',
   '六边形有 6 条边，每一条边都对应一个这样的三角形，所以一共分成 6 个三角形。',
   '这些三角形为什么是正三角形？中心到每个顶点的距离都相等，所以每个三角形都有两条边等长；而中心的那个角是 360 ÷ 6 = 60 度。',
   '两腰等长、夹角 60 度的三角形一定是正三角形。所以正六边形被分成 6 个一模一样的正三角形。'],
  ['Drawing from the centre to the six vertices gives 6 lines. Two neighbouring lines together with the side between them enclose one triangle.',
   'The hexagon has 6 sides, and each side gives one such triangle, so it is divided into 6 triangles.',
   'Why are they equilateral? The centre is the same distance from every vertex, so each triangle has two equal sides, and the angle at the centre is 360 ÷ 6 = 60 degrees.',
   'A triangle with two equal sides meeting at 60 degrees must be equilateral. So the hexagon splits into 6 identical equilateral triangles.'],
  ['中心から 6 つの頂点へ引くと線は 6 本になります。となり合う 2 本と その間の辺とで三角形が 1 つできます。',
   '六角形の辺は 6 本あり、各辺がこの三角形 1 つに対応するので、全体は 6 つの三角形に分かれます。',
   'なぜ正三角形になるのでしょうか。中心から各頂点までの距離はすべて等しいので、どの三角形も 2 辺が等しく、中心の角は 360 ÷ 6 = 60 度です。',
   '等しい 2 辺が 60 度ではさまれた三角形は必ず正三角形です。したがって正六角形は合同な正三角形 6 つに分かれます。']],
 '6',1,SQ)

rep(G4,'geometry_grade4_foundation_018','parallelogram_symmetry_axes',
 L('一個平行四邊形，它的四個角都不是直角，四條邊也不是全部一樣長。這樣的平行四邊形有幾條對稱軸？',
   '一个平行四边形，它的四个角都不是直角，四条边也不是全部一样长。这样的平行四边形有几条对称轴？',
   'A parallelogram has no right angles and its four sides are not all the same length. How many lines of symmetry does it have?',
   '平行四辺形があり、どの角も直角ではなく、4 辺の長さもすべて同じではありません。この平行四辺形の対称の軸は何本ありますか。'),
 L('答案是 0 條。','答案是 0 条。','The answer is 0.','答えは 0 本です。'),
 [['對稱軸的意思是：沿著這條線對摺後，兩邊要能完全重合。要一條一條檢查有沒有這樣的線。',
   '先試兩條對角線。沿對角線對摺後，兩個三角形的角度排列方式相反，摺過去不會重合，所以對角線不是對稱軸。',
   '再試通過對邊中點的兩條線。因為四個角都不是直角，圖形是「斜」的，沿這種線對摺後上下（或左右）也對不齊。',
   '找不到任何一條對稱軸，所以答案是 0 條。（平行四邊形有的是「旋轉對稱」——轉 180 度會和自己重合，但那不是對稱軸。長方形和菱形是特例，它們才有對稱軸。）'],
  ['对称轴的意思是：沿着这条线对折后，两边要能完全重合。要一条一条检查有没有这样的线。',
   '先试两条对角线。沿对角线对折后，两个三角形的角度排列方式相反，折过去不会重合，所以对角线不是对称轴。',
   '再试通过对边中点的两条线。因为四个角都不是直角，图形是「斜」的，沿这种线对折后上下（或左右）也对不齐。',
   '找不到任何一条对称轴，所以答案是 0 条。（平行四边形有的是「旋转对称」——转 180 度会和自己重合，但那不是对称轴。长方形和菱形是特例，它们才有对称轴。）'],
  ['A line of symmetry is one where folding along it makes the two halves match exactly, so check candidate lines one by one.',
   'Try the two diagonals first. Folding along a diagonal puts the two triangles with their angles arranged in opposite orders, so they do not match, and a diagonal is not a line of symmetry.',
   'Now try the two lines through the midpoints of opposite sides. Because none of the angles is a right angle the shape leans over, so folding along such a line does not line up either.',
   'No line of symmetry exists, so the answer is 0. A parallelogram does have rotational symmetry, matching itself after a half turn, but that is not a line of symmetry. Rectangles and rhombuses are the special cases that do have them.'],
  ['対称の軸とは、その線で折ると両側がぴったり重なる線のことなので、候補を 1 本ずつ調べます。',
   'まず 2 本の対角線です。対角線で折ると 2 つの三角形は角の並びが逆になり重ならないので、対角線は対称の軸ではありません。',
   '次に向かい合う辺の中点を通る 2 本です。どの角も直角ではないため図形はかたむいており、この線で折ってもそろいません。',
   '対称の軸は 1 本も見つからないので答えは 0 本です。平行四辺形には点対称（180 度回すと重なる）はありますが、それは対称の軸ではありません。長方形やひし形は対称の軸をもつ特別な場合です。']],
 '0',1,'Replaces one of a pair where the third angle of a triangle equals the sum of the other two.')

rep(G4,'geometry_grade4_foundation_042','cube_edge_walk_min',
 L('一隻螞蟻要沿著正方體的稜爬行，從一個頂點爬到與它相隔最遠的那個頂點（也就是正方體體對角線的另一端）。牠最少要爬過幾條稜？',
   '一只蚂蚁要沿着正方体的棱爬行，从一个顶点爬到与它相隔最远的那个顶点（也就是正方体体对角线的另一端）。它最少要爬过几条棱？',
   'An ant crawls along the edges of a cube from one vertex to the vertex furthest from it, at the other end of the cube\'s long diagonal. What is the smallest number of edges it must crawl along?',
   'ありが立方体の辺にそって、ある頂点から いちばん遠い頂点（対角線の反対のはし）まで進みます。最少で何本の辺を通りますか。'),
 L('答案是 3 條。','答案是 3 条。','The answer is 3 edges.','答えは 3 本です。'),
 [['把正方體想成有長、寬、高三個方向。每一條稜都只沿著其中一個方向前進。',
   '起點和最遠的那個頂點，在長、寬、高三個方向上都位在相反的一端——這正是「相隔最遠」的意思。',
   '所以螞蟻必須在三個方向上各移動一次才能到達，每個方向至少要走一條稜，因此至少要走 3 條。',
   '3 條也真的做得到：先沿長的方向走一條，再沿寬的方向走一條，最後沿高的方向走一條，剛好到達。所以最少是 3 條。'],
  ['把正方体想成有长、宽、高三个方向。每一条棱都只沿着其中一个方向前进。',
   '起点和最远的那个顶点，在长、宽、高三个方向上都位在相反的一端——这正是「相隔最远」的意思。',
   '所以蚂蚁必须在三个方向上各移动一次才能到达，每个方向至少要走一条棱，因此至少要走 3 条。',
   '3 条也真的做得到：先沿长的方向走一条，再沿宽的方向走一条，最后沿高的方向走一条，刚好到达。所以最少是 3 条。'],
  ['Think of the cube as having three directions: length, width and height. Every edge runs along exactly one of them.',
   'The starting vertex and the furthest vertex sit at opposite ends in all three directions at once; that is what being furthest apart means.',
   'So the ant has to move once in each of the three directions, needing at least one edge for each, hence at least 3 edges.',
   'Three edges is also achievable: crawl one edge along the length, one along the width and one along the height, arriving exactly. So the minimum is 3.'],
  ['立方体には たて・よこ・高さ の 3 方向があると考えます。どの辺も そのうち 1 方向にだけのびています。',
   '出発点といちばん遠い頂点は、3 方向すべてで反対のはしにあります。それが「いちばん遠い」ということです。',
   'したがってありは 3 方向それぞれで動く必要があり、1 方向につき最低 1 本の辺を通るので、少なくとも 3 本必要です。',
   '3 本で実際に到達もできます。たて方向に 1 本、よこ方向に 1 本、高さ方向に 1 本進めばちょうど着きます。よって最少は 3 本です。']],
 '3',1,'Replaces one of a same-pack pair cutting a small square out of a corner and asking for the remaining area.')

rep(A3,'arithmetic_grade3_foundation_009','four_times_less_than',
 L('一個數的 4 倍，比 60 還少 8。這個數是多少？',
   '一个数的 4 倍，比 60 还少 8。这个数是多少？',
   'Four times a number is 8 less than 60. What is the number?',
   'ある数の 4 倍は 60 より 8 小さいです。もとの数はいくつですか。'),
 L('答案是 13。','答案是 13。','The answer is 13.','答えは 13 です。'),
 [['先看懂「比 60 還少 8」是什麼意思：這個數的 4 倍，等於 60 減掉 8。',
   '60 − 8 = 52，所以這個數的 4 倍是 52。',
   '既然 4 倍是 52，那這個數就是 52 ÷ 4 = 13。',
   '驗算：13 × 4 = 52，而 52 比 60 少 8，正確。（注意不要算成 60 ÷ 4 再減 8，那樣會得到 7，順序錯了。）'],
  ['先看懂「比 60 还少 8」是什么意思：这个数的 4 倍，等于 60 减掉 8。',
   '60 − 8 = 52，所以这个数的 4 倍是 52。',
   '既然 4 倍是 52，那这个数就是 52 ÷ 4 = 13。',
   '验算：13 × 4 = 52，而 52 比 60 少 8，正确。（注意不要算成 60 ÷ 4 再减 8，那样会得到 7，顺序错了。）'],
  ['First read what "8 less than 60" means: four times the number equals 60 minus 8.',
   '60 − 8 = 52, so four times the number is 52.',
   'Since four times it is 52, the number itself is 52 ÷ 4 = 13.',
   'Check: 13 × 4 = 52, and 52 is indeed 8 less than 60. Do not compute 60 ÷ 4 and then subtract 8, which would give 7 by applying the steps in the wrong order.'],
  ['まず「60 より 8 小さい」の意味をとらえます。もとの数の 4 倍が 60 − 8 に等しいということです。',
   '60 − 8 = 52 なので、もとの数の 4 倍は 52 です。',
   '4 倍が 52 なら、もとの数は 52 ÷ 4 = 13 です。',
   '確かめると 13 × 4 = 52 で、52 は 60 より 8 小さく正しいです。60 ÷ 4 をしてから 8 を引くと 7 になり、順序を取りちがえた誤りです。']],
 '13',2,'Replaces one of a pair arranging digit cards into the largest and smallest numbers and subtracting.')

rep(L4,'logic_grade4_foundation_020','rank_scores_by_chain',
 L('甲、乙、丙、丁四個人的分數各不相同，剛好分別是 60、70、80、90 分。已知丙是最低分；甲不是最高分；乙比甲高；丁又比乙高。甲得幾分？',
   '甲、乙、丙、丁四个人的分数各不相同，刚好分别是 60、70、80、90 分。已知丙是最低分；甲不是最高分；乙比甲高；丁又比乙高。甲得几分？',
   'Four people A, B, C and D have four different scores: 60, 70, 80 and 90. C has the lowest score, A does not have the highest, B scores higher than A, and D scores higher than B. What is A\'s score?',
   '甲・乙・丙・丁 の 4 人の点数はすべてちがい、60、70、80、90 点のいずれかです。丙が最低点、甲は最高点ではなく、乙は甲より高く、丁は乙より高いです。甲は何点ですか。'),
 L('答案是 70 分。','答案是 70 分。','The answer is 70.','答えは 70 点です。'),
 [['先用最確定的條件：丙是最低分，所以丙得 60 分，剩下 70、80、90 分給甲、乙、丁。',
   '再看剩下三人之間的關係：乙比甲高，丁比乙高，把它們串起來就是丁 > 乙 > 甲。',
   '三個人的分數由高到低排好之後，只有一種對應方式：丁最高得 90，乙居中得 80，甲最低得 70。',
   '檢查「甲不是最高分」：甲得 70，確實不是最高，所有條件都成立。所以甲得 70 分。'],
  ['先用最确定的条件：丙是最低分，所以丙得 60 分，剩下 70、80、90 分给甲、乙、丁。',
   '再看剩下三人之间的关系：乙比甲高，丁比乙高，把它们串起来就是丁 > 乙 > 甲。',
   '三个人的分数由高到低排好之后，只有一种对应方式：丁最高得 90，乙居中得 80，甲最低得 70。',
   '检查「甲不是最高分」：甲得 70，确实不是最高，所有条件都成立。所以甲得 70 分。'],
  ['Start with the most definite condition: C has the lowest score, so C has 60, leaving 70, 80 and 90 for A, B and D.',
   'Now chain the relations among the other three: B is higher than A and D is higher than B, so D > B > A.',
   'Once those three are placed in order there is only one way to match them: D takes the highest at 90, B the middle at 80 and A the lowest at 70.',
   'Check that A is not the highest: A has 70, which is indeed not the highest, so every condition holds. A scored 70.'],
  ['いちばんはっきりした条件から使います。丙が最低なので丙は 60 点、残る 70、80、90 点が甲・乙・丁のものです。',
   '次に残り 3 人の関係をつなぎます。乙は甲より高く、丁は乙より高いので 丁 > 乙 > 甲 です。',
   '3 人を高い順に並べると対応は 1 通りしかありません。丁が最高の 90、乙がまん中の 80、甲が最低の 70 です。',
   '「甲は最高点ではない」も確かめます。甲は 70 点で最高ではなく、すべての条件が成り立ちます。よって甲は 70 点です。']],
 '70',2,'Replaces one of a pair toggling numbered boxes over several rounds.')

rep(A5,'arithmetic_grade5_foundation_032','doubling_chain_share',
 L('把 112 元分給甲、乙、丙三個人。甲分到的錢是乙的 2 倍，乙分到的錢是丙的 2 倍。丙分到多少元？',
   '把 112 元分给甲、乙、丙三个人。甲分到的钱是乙的 2 倍，乙分到的钱是丙的 2 倍。丙分到多少元？',
   '112 dollars is shared among A, B and C. A gets twice as much as B, and B gets twice as much as C. How much does C get?',
   '112 円を甲・乙・丙 の 3 人に分けます。甲は乙の 2 倍、乙は丙の 2 倍を受け取ります。丙は何円もらいますか。'),
 L('答案是 16 元。','答案是 16 元。','The answer is 16 dollars.','答えは 16 円です。'),
 [['三個人的錢是一層一層乘上去的，所以用最少的那個（丙）當一份來看最方便。',
   '丙是 1 份。乙是丙的 2 倍，所以是 2 份。甲是乙的 2 倍，所以是 2 × 2 = 4 份。',
   '三個人加起來是 1 + 2 + 4 = 7 份，而總共是 112 元。',
   '所以 1 份是 112 ÷ 7 = 16 元，這就是丙分到的錢。（驗算：丙 16、乙 32、甲 64，加起來 112 元。）'],
  ['三个人的钱是一层一层乘上去的，所以用最少的那个（丙）当一份来看最方便。',
   '丙是 1 份。乙是丙的 2 倍，所以是 2 份。甲是乙的 2 倍，所以是 2 × 2 = 4 份。',
   '三个人加起来是 1 + 2 + 4 = 7 份，而总共是 112 元。',
   '所以 1 份是 112 ÷ 7 = 16 元，这就是丙分到的钱。（验算：丙 16、乙 32、甲 64，加起来 112 元。）'],
  ['The amounts multiply up in stages, so it is easiest to treat the smallest share, C\'s, as one unit.',
   'C is 1 unit. B is twice C, so 2 units. A is twice B, so 2 × 2 = 4 units.',
   'Altogether that is 1 + 2 + 4 = 7 units, and the total is 112 dollars.',
   'So one unit is 112 ÷ 7 = 16 dollars, which is what C receives. Check: 16 + 32 + 64 = 112 dollars.'],
  ['3 人の金額は段階的に 2 倍ずつになっているので、いちばん少ない丙を 1 つ分と考えると簡単です。',
   '丙は 1 つ分、乙は丙の 2 倍で 2 つ分、甲は乙の 2 倍で 2 × 2 = 4 つ分です。',
   '合わせて 1 + 2 + 4 = 7 つ分で、総額は 112 円です。',
   'したがって 1 つ分は 112 ÷ 7 = 16 円で、これが丙の分です。確かめると 16 + 32 + 64 = 112 円です。']],
 '16',2,'Replaces one of a pair arranging unit squares into rectangles with both sides above 1.')

for p, d in P.items():
    for q in d['questions']:
        assert len({len(v) for v in q['solutionSteps'].values()}) == 1, q['id']
        if q['answerMode'] == 'integer_input': assert 'options' not in q, q['id']
    with io.open(p,'w',encoding='utf-8') as f:
        json.dump(d,f,ensure_ascii=False,indent=2); f.write('\n')
print('\n寫回', len(P), '個 pack')
