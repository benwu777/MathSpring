# -*- coding: utf-8 -*-
"""替換其餘四個模板家族共 10 題。

number_line 跳格（5 題，g1-g4，詳解相似度 0.55）：一律「從 N 出發，先 ±a 再 ±b，停在哪」，
  詳解兩步「先跳到 …」「再 … 到 …」。保留 grade1_028 當代表，換掉其餘 4 題。
正方形角落重複計數（3 題，g1/g2/g3，詳解相似度 0.94）：除了「貼紙/珠子/棋子」和數字
  3/4/5 之外一字不差。保留 grade1_003，換掉 2 題。
page_numbering（3 題，g5/g5/g6，詳解相似度 0.82）：一律「1-9 用 9 個數字，剩下除以 2」。
  保留 grade5_005，換掉 2 題。
長方形對角線分兩三角形（3 題，g2/g3/g5，詳解相似度 0.69）：其中 grade3_046 與
  grade5_009 連「長 8 公分、寬 6 公分」都一樣。保留 grade2_044，換掉 2 題。

新題設計時我自己先掉進同一個坑：第一批 4 個 number_line 替換題全被我寫成
「起點 ±a ±b」，正是要修的骨架；梯形／平行四邊形對角線兩題也還在
「對角線分兩三角形」家族裡。都重新設計並重跑閘門，另淘汰折繩剪段（撞
grade8_010）、正方形四分（0.44）、長寬比求面積（撞 grade4_036）、
等腰求腰（撞 grade5_001）、圓方等周（撞 grade5_016）五題。
"""
import json, io

def L(zh, zhs, en, ja): return {'zh-Hant': zh, 'zh-Hans': zhs, 'en': en, 'ja': ja}
PACKS = {}
def replace(path, qid, subtopic, prompt, answer, steps, value, digits, why):
    if path not in PACKS: PACKS[path] = json.load(open(path))
    d = PACKS[path]
    q = next(x for x in d['questions'] if x['id'] == qid)
    old = q['prompt']['zh-Hant'][:24]
    q.pop('options', None)
    q['subtopic'] = subtopic
    q['prompt'] = prompt; q['answer'] = answer
    q['solutionSteps'] = {'zh-Hant': steps[0], 'zh-Hans': steps[1], 'en': steps[2], 'ja': steps[3]}
    assert len({len(v) for v in q['solutionSteps'].values()}) == 1, qid
    q['answerMode'] = 'integer_input'
    q['correctAnswer'] = {'type': 'integer', 'value': value}
    q['inputConstraints'] = {'allowNegative': False, 'maxDigits': digits}
    q['source']['notes'] = 'Replacement authored 2026-08-29 during the whole-bank template scan. ' + why
    print('%-34s %-28s 答%-3s 原: %s…' % (qid[-34:], subtopic, value, old))

A2 = 'assets/questions/arithmetic/grade2_foundation.arithmetic.v1.json'
A3 = 'assets/questions/arithmetic/grade3_foundation.arithmetic.v1.json'
A4 = 'assets/questions/arithmetic/grade4_foundation.arithmetic.v1.json'
A5 = 'assets/questions/arithmetic/grade5_foundation.arithmetic.v1.json'
A6 = 'assets/questions/arithmetic/grade6_foundation.arithmetic.v1.json'
G3 = 'assets/questions/geometry/grade3_foundation.geometry.v1.json'
G5 = 'assets/questions/geometry/grade5_foundation.geometry.v1.json'
NL = 'Replaces a number-line hop template question.'
OC = 'Replaces a square-corner double-counting template question.'
PN = 'Replaces a page-numbering digit-count template question.'
DG = 'Replaces a rectangle-diagonal-into-two-triangles template question.'

replace(A2, 'arithmetic_grade2_foundation_020', 'half_then_more',
 L('小明有 24 張貼紙。小華的貼紙數量是小明的一半再多 3 張。小華有幾張貼紙？',
   '小明有 24 张贴纸。小华的贴纸数量是小明的一半再多 3 张。小华有几张贴纸？',
   'Ming has 24 stickers. Hua has half as many as Ming and then 3 more. How many stickers does Hua have?',
   '明はシールを 24 まい持っています。華は明の半分より 3 まい多く持っています。華は何まい持っていますか。'),
 L('答案是 15 張。', '答案是 15 张。', 'The answer is 15.', '答えは 15 まいです。'),
 [['題目描述小華的張數時用了兩個步驟：先取小明的一半，再多 3 張。要照這個順序算。',
   '先算小明的一半：24 ÷ 2 = 12 張。',
   '再加上多的 3 張：12 + 3 = 15 張。',
   '所以小華有 15 張。（不能先把 24 加 3 再除以 2，那樣會得到 13 又二分之一，順序反了。）'],
  ['题目描述小华的张数时用了两个步骤：先取小明的一半，再多 3 张。要照这个顺序算。',
   '先算小明的一半：24 ÷ 2 = 12 张。',
   '再加上多的 3 张：12 + 3 = 15 张。',
   '所以小华有 15 张。（不能先把 24 加 3 再除以 2，那样会得到 13 又二分之一，顺序反了。）'],
  ['Hua\'s total is described in two steps: first take half of Ming\'s, then add 3 more. Follow that order.',
   'Half of Ming\'s stickers is 24 ÷ 2 = 12.',
   'Then add the extra 3: 12 + 3 = 15.',
   'So Hua has 15 stickers. Adding 3 to 24 first and then halving would give 13 and a half, which reverses the order.'],
  ['華のまい数は 2 段階で説明されています。まず明の半分をとり、それから 3 まい多くします。この順に計算します。',
   '明の半分は 24 ÷ 2 = 12 まいです。',
   'そこに多い分の 3 まいを足して 12 + 3 = 15 まいです。',
   'したがって華は 15 まいです。先に 24 + 3 をしてから半分にすると 13.5 になり、順序が逆です。']],
 '15', 2, NL)

replace(A2, 'arithmetic_grade2_foundation_031', 'dice_opposite_face',
 L('一顆骰子相對的兩面，點數加起來都是 7。如果朝上那一面是 2 點，朝下那一面是幾點？',
   '一颗骰子相对的两面，点数加起来都是 7。如果朝上那一面是 2 点，朝下那一面是几点？',
   'On a dice, the numbers on opposite faces always add up to 7. If the top face shows 2, what does the bottom face show?',
   'さいころの向かい合う面の目の和はつねに 7 です。上の面が 2 のとき、下の面はいくつですか。'),
 L('答案是 5 點。', '答案是 5 点。', 'The answer is 5.', '答えは 5 です。'),
 [['骰子上朝上和朝下的兩面，正好是一組相對的面。',
   '題目說相對兩面的點數加起來是 7，所以朝上和朝下的點數合起來就是 7。',
   '朝上是 2 點，那麼朝下的點數就是 7 減掉 2。',
   '7 − 2 = 5，所以朝下那一面是 5 點。（同樣的道理，1 對 6、3 對 4。）'],
  ['骰子上朝上和朝下的两面，正好是一组相对的面。',
   '题目说相对两面的点数加起来是 7，所以朝上和朝下的点数合起来就是 7。',
   '朝上是 2 点，那么朝下的点数就是 7 减掉 2。',
   '7 − 2 = 5，所以朝下那一面是 5 点。（同样的道理，1 对 6、3 对 4。）'],
  ['The top face and the bottom face of a dice are exactly one pair of opposite faces.',
   'The problem says opposite faces add to 7, so the top and bottom numbers together make 7.',
   'The top shows 2, so the bottom shows 7 minus 2.',
   '7 − 2 = 5, so the bottom face shows 5. By the same rule, 1 pairs with 6 and 3 pairs with 4.'],
  ['さいころの上の面と下の面は、ちょうど向かい合う 1 組です。',
   '向かい合う面の目の和は 7 なので、上と下の目を足すと 7 になります。',
   '上が 2 なので、下は 7 から 2 を引いた数です。',
   '7 − 2 = 5 なので下の面は 5 です。同じ理由で 1 と 6、3 と 4 が組になります。']],
 '5', 1, NL)

replace(A3, 'arithmetic_grade3_foundation_025', 'circle_seats_opposite',
 L('一張圓桌旁均勻排了一圈椅子，依順時針從 1 開始連續編號。已知 5 號椅子和 12 號椅子剛好隔著桌子正對面。這張圓桌旁一共有幾張椅子？',
   '一张圆桌旁均匀排了一圈椅子，依顺时针从 1 开始连续编号。已知 5 号椅子和 12 号椅子刚好隔着桌子正对面。这张圆桌旁一共有几张椅子？',
   'Chairs are spaced evenly right round a circular table and numbered clockwise from 1. Chair 5 and chair 12 sit exactly opposite each other across the table. How many chairs are there in all?',
   '丸いテーブルのまわりに いすが等間隔に並び、時計回りに 1 から番号がついています。5 番と 12 番の いすがテーブルをはさんでちょうど向かい合っています。いすは全部で何きゃくありますか。'),
 L('答案是 14 張。', '答案是 14 张。', 'The answer is 14 chairs.', '答えは 14 きゃくです。'),
 [['椅子是均勻排一圈的，「正對面」表示從一張走到另一張，剛好走了半圈。',
   '從 5 號順時針走到 12 號，中間經過 12 − 5 = 7 個間隔。',
   '這 7 個間隔就是半圈，所以整整一圈是 7 × 2 = 14 個間隔。',
   '在一個封閉的圓圈上，椅子的張數剛好等於間隔的個數（不像直線要多加 1），所以一共有 14 張椅子。'],
  ['椅子是均匀排一圈的，「正对面」表示从一张走到另一张，刚好走了半圈。',
   '从 5 号顺时针走到 12 号，中间经过 12 − 5 = 7 个间隔。',
   '这 7 个间隔就是半圈，所以整整一圈是 7 × 2 = 14 个间隔。',
   '在一个封闭的圆圈上，椅子的张数刚好等于间隔的个数（不像直线要多加 1），所以一共有 14 张椅子。'],
  ['The chairs are evenly spaced round the circle, so being exactly opposite means going from one to the other covers exactly half the way round.',
   'Going clockwise from chair 5 to chair 12 passes 12 − 5 = 7 gaps.',
   'Those 7 gaps make half a turn, so a full turn is 7 × 2 = 14 gaps.',
   'Around a closed circle the number of chairs equals the number of gaps, unlike a straight line where one more is needed, so there are 14 chairs.'],
  ['いすは等間隔に円をなして並んでいるので、「向かい合う」とは ちょうど半周分はなれているということです。',
   '5 番から時計回りに 12 番まで進むと 12 − 5 = 7 個の間隔を通ります。',
   'この 7 個の間隔が半周なので、一周は 7 × 2 = 14 個の間隔です。',
   '閉じた円では いすの数と間隔の数が等しくなります（直線のように 1 を足す必要はありません）。よって いすは 14 きゃくです。']],
 '14', 2, NL)

replace(A4, 'arithmetic_grade4_foundation_030', 'fill_and_drain_together',
 L('一個水池，只打開進水管 6 小時可以注滿；只打開出水管，滿池的水 9 小時可以放完。如果兩根管子同時打開，從空池開始要幾小時才能注滿？',
   '一个水池，只打开进水管 6 小时可以注满；只打开出水管，满池的水 9 小时可以放完。如果两根管子同时打开，从空池开始要几小时才能注满？',
   'A pool fills in 6 hours with only the inlet pipe open, and a full pool empties in 9 hours with only the outlet pipe open. If both pipes are opened together starting from empty, how many hours does it take to fill?',
   'ある池は、給水管だけを開けると 6 時間でいっぱいになり、排水管だけを開けると満水から 9 時間で空になります。両方を同時に開けると、空の状態から何時間でいっぱいになりますか。'),
 L('答案是 18 小時。', '答案是 18 小时。', 'The answer is 18 hours.', '答えは 18 時間です。'),
 [['把整池水看成 1，先算兩根管子每小時各做多少。',
   '進水管 6 小時注滿，所以每小時注入全池的 6 分之 1；出水管 9 小時放完，所以每小時放掉 9 分之 1。',
   '兩管同時開時，水是一邊進一邊出，每小時實際增加的是 6 分之 1 減 9 分之 1。通分到 18：18 分之 3 減 18 分之 2 = 18 分之 1。',
   '每小時只增加全池的 18 分之 1，所以注滿要 18 小時。（進水比出水快，水位才會上升；如果進水比較慢就永遠注不滿。）'],
  ['把整池水看成 1，先算两根管子每小时各做多少。',
   '进水管 6 小时注满，所以每小时注入全池的 6 分之 1；出水管 9 小时放完，所以每小时放掉 9 分之 1。',
   '两管同时开时，水是一边进一边出，每小时实际增加的是 6 分之 1 减 9 分之 1。通分到 18：18 分之 3 减 18 分之 2 = 18 分之 1。',
   '每小时只增加全池的 18 分之 1，所以注满要 18 小时。（进水比出水快，水位才会上升；如果进水比较慢就永远注不满。）'],
  ['Treat the full pool as 1 and work out how much each pipe does per hour.',
   'The inlet fills in 6 hours, so it adds one sixth of the pool per hour; the outlet empties in 9 hours, so it removes one ninth per hour.',
   'With both open, water comes in and goes out at once, so the actual gain per hour is one sixth minus one ninth. Over a denominator of 18 that is three eighteenths minus two eighteenths, which is one eighteenth.',
   'Gaining one eighteenth of the pool per hour means filling takes 18 hours. The level only rises because the inlet is faster than the outlet; if it were slower the pool would never fill.'],
  ['池全体を 1 とし、2 本の管が 1 時間にどれだけ進めるかを求めます。',
   '給水管は 6 時間でいっぱいにするので 1 時間に全体の 6 分の 1、排水管は 9 時間で空にするので 1 時間に 9 分の 1 出します。',
   '両方開けると入りながら出るので、1 時間に実際にふえるのは 6 分の 1 − 9 分の 1 です。分母を 18 にそろえると 18 分の 3 − 18 分の 2 = 18 分の 1 です。',
   '1 時間に全体の 18 分の 1 しかふえないので 18 時間かかります。給水のほうが速いから水位が上がるのであって、遅ければいつまでもいっぱいになりません。']],
 '18', 2, NL)

replace(A2, 'arithmetic_grade2_foundation_022', 'triangle_border_stones',
 L('用棋子在桌上排成一個三角形的外框：三個頂點各放 1 顆棋子，而且從每一條邊上數過去（包含兩端的頂點）都恰好是 5 顆棋子。一共用了幾顆棋子？',
   '用棋子在桌上排成一个三角形的外框：三个顶点各放 1 颗棋子，而且从每一条边上数过去（包含两端的顶点）都恰好是 5 颗棋子。一共用了几颗棋子？',
   'Counters are laid out on a table to form the outline of a triangle, with one counter at each of the three corners, and each side showing exactly 5 counters when counted including both end corners. How many counters are used altogether?',
   'こまをつくえに並べて三角形のわくを作ります。3 つのかどに 1 個ずつ置き、どの辺も 両はしのかどをふくめてちょうど 5 個に見えるようにします。こまは全部で何個使いますか。'),
 L('答案是 12 顆。', '答案是 12 颗。', 'The answer is 12 counters.', '答えは 12 個です。'),
 [['如果直接把三條邊各 5 顆加起來，會得到 5 × 3 = 15 顆。但這樣算會出問題。',
   '問題出在三個頂點上的棋子：每一個頂點都同時屬於兩條邊，所以在剛才的 15 顆裡，每個頂點都被算了 2 次。',
   '三個頂點各被多算了 1 次，一共多算了 3 顆。',
   '把多算的扣掉：15 − 3 = 12 顆。'],
  ['如果直接把三条边各 5 颗加起来，会得到 5 × 3 = 15 颗。但这样算会出问题。',
   '问题出在三个顶点上的棋子：每一个顶点都同时属于两条边，所以在刚才的 15 颗里，每个顶点都被算了 2 次。',
   '三个顶点各被多算了 1 次，一共多算了 3 颗。',
   '把多算的扣掉：15 − 3 = 12 颗。'],
  ['Adding 5 counters for each of the three sides gives 5 × 3 = 15, but that count goes wrong.',
   'The trouble is the corner counters: each corner belongs to two sides at once, so in that 15 every corner has been counted twice.',
   'Each of the three corners was counted one time too many, so 3 counters were counted in excess.',
   'Removing the excess gives 15 − 3 = 12 counters.'],
  ['3 辺それぞれ 5 個としてそのまま足すと 5 × 3 = 15 個ですが、この数え方には問題があります。',
   '問題はかどのこまです。どのかども 2 つの辺に同時に属するので、いまの 15 個ではかどを 2 回ずつ数えています。',
   '3 つのかどをそれぞれ 1 回多く数えたので、合計 3 個多く数えたことになります。',
   '多い分を引いて 15 − 3 = 12 個です。']],
 '12', 2, OC)

replace(A3, 'arithmetic_grade3_foundation_012', 'remove_then_share',
 L('一箱汽水有 30 瓶。先喝掉 6 瓶之後，把剩下的平分給 4 個人。每個人分到幾瓶？',
   '一箱汽水有 30 瓶。先喝掉 6 瓶之后，把剩下的平分给 4 个人。每个人分到几瓶？',
   'A crate holds 30 bottles of drink. After 6 are drunk, the rest are shared equally among 4 people. How many bottles does each person get?',
   'ジュースが 1 箱に 30 本あります。6 本飲んだあと、残りを 4 人で等しく分けます。1 人何本もらえますか。'),
 L('答案是 6 瓶。', '答案是 6 瓶。', 'The answer is 6 bottles.', '答えは 6 本です。'),
 [['要分的不是原本的 30 瓶，而是喝掉之後剩下的，所以順序要先減再除。',
   '先算剩下幾瓶：30 − 6 = 24 瓶。',
   '再把這 24 瓶平分給 4 個人：24 ÷ 4 = 6 瓶。',
   '所以每個人分到 6 瓶。（如果先用 30 ÷ 4 再處理，會除不盡而且算錯，因為那 6 瓶根本不在要分的範圍裡。）'],
  ['要分的不是原本的 30 瓶，而是喝掉之后剩下的，所以顺序要先减再除。',
   '先算剩下几瓶：30 − 6 = 24 瓶。',
   '再把这 24 瓶平分给 4 个人：24 ÷ 4 = 6 瓶。',
   '所以每个人分到 6 瓶。（如果先用 30 ÷ 4 再处理，会除不尽而且算错，因为那 6 瓶根本不在要分的范围里。）'],
  ['What gets shared is not the original 30 bottles but what is left after some are drunk, so subtract first and divide second.',
   'First find what is left: 30 − 6 = 24 bottles.',
   'Then share those 24 among 4 people: 24 ÷ 4 = 6 bottles.',
   'So each person gets 6 bottles. Dividing 30 by 4 first would not come out evenly and would be wrong anyway, since those 6 bottles were never part of what is shared.'],
  ['分けるのは もとの 30 本ではなく、飲んだあとの残りなので、先に引いてからわります。',
   'まず残りを求めます。30 − 6 = 24 本です。',
   '次にこの 24 本を 4 人で分けます。24 ÷ 4 = 6 本です。',
   'したがって 1 人 6 本です。先に 30 ÷ 4 をするとわり切れず、しかもその 6 本は分ける対象ではないので誤りです。']],
 '6', 1, OC)

replace(A5, 'arithmetic_grade5_foundation_019', 'percent_less_than',
 L('甲數是 48。乙數比甲數少 25%。乙數是多少？',
   '甲数是 48。乙数比甲数少 25%。乙数是多少？',
   'A is 48. B is 25 percent less than A. What is B?',
   '甲は 48 です。乙は甲より 25 パーセント小さい数です。乙はいくつですか。'),
 L('答案是 36。', '答案是 36。', 'The answer is 36.', '答えは 36 です。'),
 [['「比甲數少 25%」的意思是，少掉的部分是甲數的 25%，也就是甲數的 4 分之 1。',
   '48 的 4 分之 1 是 48 ÷ 4 = 12，這就是少掉的量。',
   '乙數 = 甲數 − 少掉的量 = 48 − 12 = 36。',
   '也可以直接想：乙數是甲數的 100% − 25% = 75%，也就是 4 分之 3，48 × 3 ÷ 4 = 36，結果一樣。'],
  ['「比甲数少 25%」的意思是，少掉的部分是甲数的 25%，也就是甲数的 4 分之 1。',
   '48 的 4 分之 1 是 48 ÷ 4 = 12，这就是少掉的量。',
   '乙数 = 甲数 − 少掉的量 = 48 − 12 = 36。',
   '也可以直接想：乙数是甲数的 100% − 25% = 75%，也就是 4 分之 3，48 × 3 ÷ 4 = 36，结果一样。'],
  ['Being 25 percent less than A means the amount taken away is 25 percent of A, which is a quarter of A.',
   'A quarter of 48 is 48 ÷ 4 = 12, and that is the amount taken away.',
   'So B = A minus that amount = 48 − 12 = 36.',
   'Another route: B is 100 − 25 = 75 percent of A, that is three quarters, and 48 × 3 ÷ 4 = 36, the same answer.'],
  ['「甲より 25 パーセント小さい」とは、減る分が甲の 25 パーセント、つまり甲の 4 分の 1 だということです。',
   '48 の 4 分の 1 は 48 ÷ 4 = 12 で、これが減る分です。',
   'よって 乙 = 甲 − 減る分 = 48 − 12 = 36 です。',
   '別の考え方として、乙は甲の 100 − 25 = 75 パーセント、つまり 4 分の 3 なので 48 × 3 ÷ 4 = 36 と同じ答えになります。']],
 '36', 2, PN)

replace(A6, 'arithmetic_grade6_foundation_009', 'percent_to_percent',
 L('一個數的 25% 是 15。這個數的 40% 是多少？',
   '一个数的 25% 是 15。这个数的 40% 是多少？',
   '25 percent of a number is 15. What is 40 percent of that number?',
   'ある数の 25 パーセントが 15 です。その数の 40 パーセントはいくつですか。'),
 L('答案是 24。', '答案是 24。', 'The answer is 24.', '答えは 24 です。'),
 [['題目問的是同一個數的另一個百分比，所以要先把那個數本身找出來。',
   '25% 就是 4 分之 1。既然 4 分之 1 是 15，整個數就是 15 × 4 = 60。',
   '再求 60 的 40%。40% 就是 100 分之 40，也就是 10 分之 4。',
   '60 的 10 分之 1 是 6，所以 10 分之 4 是 6 × 4 = 24。（也可以用比例想：40% 是 25% 的 1.6 倍，所以答案是 15 × 1.6 = 24。）'],
  ['题目问的是同一个数的另一个百分比，所以要先把那个数本身找出来。',
   '25% 就是 4 分之 1。既然 4 分之 1 是 15，整个数就是 15 × 4 = 60。',
   '再求 60 的 40%。40% 就是 100 分之 40，也就是 10 分之 4。',
   '60 的 10 分之 1 是 6，所以 10 分之 4 是 6 × 4 = 24。（也可以用比例想：40% 是 25% 的 1.6 倍，所以答案是 15 × 1.6 = 24。）'],
  ['The question asks for a different percentage of the same number, so first find that number itself.',
   '25 percent is one quarter. Since a quarter is 15, the whole number is 15 × 4 = 60.',
   'Now find 40 percent of 60. Forty percent is 40 out of 100, that is four tenths.',
   'One tenth of 60 is 6, so four tenths is 6 × 4 = 24. Reasoning by proportion gives the same: 40 percent is 1.6 times 25 percent, so the answer is 15 × 1.6 = 24.'],
  ['問われているのは同じ数の別の割合なので、まずその数そのものを求めます。',
   '25 パーセントは 4 分の 1 です。4 分の 1 が 15 なので、もとの数は 15 × 4 = 60 です。',
   '次に 60 の 40 パーセントを求めます。40 パーセントは 100 分の 40、つまり 10 分の 4 です。',
   '60 の 10 分の 1 は 6 なので、10 分の 4 は 6 × 4 = 24 です。割合で考えても 40 パーセントは 25 パーセントの 1.6 倍なので 15 × 1.6 = 24 と同じです。']],
 '24', 2, PN)

replace(G3, 'geometry_grade3_foundation_046', 'largest_inscribed_circle',
 L('一個正方形的邊長是 7 公分。在這個正方形裡面畫一個最大的圓，這個圓的直徑是幾公分？',
   '一个正方形的边长是 7 厘米。在这个正方形里面画一个最大的圆，这个圆的直径是几厘米？',
   'A square has sides of 7 cm. The largest possible circle is drawn inside it. What is the diameter of that circle, in centimetres?',
   '1 辺 7 cm の正方形の中に、できるだけ大きい円をかきます。その円の直径は何 cm ですか。'),
 L('答案是 7 公分。', '答案是 7 厘米。', 'The answer is 7 cm.', '答えは 7 cm です。'),
 [['要畫進正方形裡的最大的圓，會同時碰到正方形的四條邊，一邊碰一個點。',
   '這個圓的圓心就在正方形的正中央，而且從圓心到上下兩邊的距離相等、到左右兩邊的距離也相等。',
   '從上邊碰到的點，直直穿過圓心到下邊碰到的點，這一段就是圓的直徑；而它同時也是正方形上下兩邊之間的距離，也就是邊長。',
   '所以直徑等於正方形的邊長，是 7 公分。（如果畫得比 7 公分大，圓就會超出正方形。）'],
  ['要画进正方形里的最大的圆，会同时碰到正方形的四条边，一边碰一个点。',
   '这个圆的圆心就在正方形的正中央，而且从圆心到上下两边的距离相等、到左右两边的距离也相等。',
   '从上边碰到的点，直直穿过圆心到下边碰到的点，这一段就是圆的直径；而它同时也是正方形上下两边之间的距离，也就是边长。',
   '所以直径等于正方形的边长，是 7 厘米。（如果画得比 7 厘米大，圆就会超出正方形。）'],
  ['The largest circle that fits inside a square touches all four sides, one point on each.',
   'Its centre sits at the very middle of the square, equally far from the top and bottom sides and equally far from the left and right sides.',
   'The line from the point it touches on the top, straight through the centre to the point it touches on the bottom, is the circle\'s diameter, and it is also the distance between the top and bottom sides, which is the side length.',
   'So the diameter equals the side of the square, 7 cm. Any larger and the circle would stick out of the square.'],
  ['正方形の中に入る最大の円は、4 つの辺すべてに 1 点ずつふれます。',
   'その中心は正方形のちょうどまん中にあり、上下の辺までの距離も、左右の辺までの距離も等しくなります。',
   '上の辺にふれる点から中心を通って下の辺にふれる点までの線分が円の直径であり、それは同時に上下の辺の間の距離、つまり 1 辺の長さです。',
   'したがって直径は正方形の 1 辺と同じ 7 cm です。これより大きいと円が正方形からはみ出します。']],
 '7', 1, DG)

replace(G5, 'geometry_grade5_foundation_009', 'angle_ratio_largest',
 L('一個三角形三個內角的度數比是 1 比 2 比 3。這個三角形最大的角是幾度？',
   '一个三角形三个内角的度数比是 1 比 2 比 3。这个三角形最大的角是几度？',
   'The three interior angles of a triangle are in the ratio 1 to 2 to 3. How many degrees is the largest angle?',
   '三角形の 3 つの内角の大きさの比が 1 対 2 対 3 です。いちばん大きい角は何度ですか。'),
 L('答案是 90 度。', '答案是 90 度。', 'The answer is 90 degrees.', '答えは 90 度です。'),
 [['比是 1 比 2 比 3，可以把三個角想成「1 份、2 份、3 份」，每一份的度數相同。',
   '三個角合起來是 1 + 2 + 3 = 6 份，而三角形的內角和一定是 180 度。',
   '所以 1 份是 180 ÷ 6 = 30 度。',
   '最大的角是 3 份，也就是 30 × 3 = 90 度。（三個角依序是 30 度、60 度、90 度，剛好是一個直角三角形。）'],
  ['比是 1 比 2 比 3，可以把三个角想成「1 份、2 份、3 份」，每一份的度数相同。',
   '三个角合起来是 1 + 2 + 3 = 6 份，而三角形的内角和一定是 180 度。',
   '所以 1 份是 180 ÷ 6 = 30 度。',
   '最大的角是 3 份，也就是 30 × 3 = 90 度。（三个角依次是 30 度、60 度、90 度，刚好是一个直角三角形。）'],
  ['A ratio of 1 to 2 to 3 means the angles can be seen as 1 share, 2 shares and 3 shares, with every share the same size.',
   'Together that is 1 + 2 + 3 = 6 shares, and the interior angles of a triangle always add to 180 degrees.',
   'So one share is 180 ÷ 6 = 30 degrees.',
   'The largest angle is 3 shares, that is 30 × 3 = 90 degrees. The three angles are 30, 60 and 90 degrees, making a right-angled triangle.'],
  ['1 対 2 対 3 の比は、3 つの角を「1 つ分・2 つ分・3 つ分」と考えられ、1 つ分の大きさはどれも同じです。',
   '合わせて 1 + 2 + 3 = 6 つ分で、三角形の内角の和はつねに 180 度です。',
   'したがって 1 つ分は 180 ÷ 6 = 30 度です。',
   'いちばん大きい角は 3 つ分で 30 × 3 = 90 度です。3 つの角は 30 度・60 度・90 度で、直角三角形になります。']],
 '90', 2, DG)

for p, d in PACKS.items():
    for q in d['questions']:
        assert len({len(v) for v in q['solutionSteps'].values()}) == 1, q['id']
        if q['answerMode'] == 'integer_input': assert 'options' not in q, q['id']
    with io.open(p, 'w', encoding='utf-8') as f:
        json.dump(d, f, ensure_ascii=False, indent=2); f.write('\n')
print('\n寫回', len(PACKS), '個 pack')
