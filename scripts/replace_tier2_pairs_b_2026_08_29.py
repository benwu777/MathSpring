# -*- coding: utf-8 -*-
"""替換 Tier 2 兩題家族（第二批 9 題）。續 replace_tier2_pairs_a。"""
import json, io
def L(zh, zhs, en, ja): return {'zh-Hant': zh, 'zh-Hans': zhs, 'en': en, 'ja': ja}
P = {}
def rep(path, qid, sub, prompt, answer, st, val, dig, why):
    if path not in P: P[path] = json.load(open(path))
    q = next(x for x in P[path]['questions'] if x['id'] == qid)
    old = q['prompt']['zh-Hant'][:22]
    q.pop('options', None)
    q['subtopic'] = sub; q['prompt'] = prompt; q['answer'] = answer
    q['solutionSteps'] = {'zh-Hant': st[0], 'zh-Hans': st[1], 'en': st[2], 'ja': st[3]}
    assert len({len(v) for v in q['solutionSteps'].values()}) == 1, qid
    q['answerMode'] = 'integer_input'
    q['correctAnswer'] = {'type': 'integer', 'value': val}
    q['inputConstraints'] = {'allowNegative': False, 'maxDigits': dig}
    q['source']['notes'] = 'Replacement authored 2026-08-29 during the whole-bank template scan. ' + why
    print('%-34s %-28s 答%-4s 原: %s…' % (qid[-34:], sub, val, old))

A5='assets/questions/arithmetic/grade5_foundation.arithmetic.v1.json'
G5='assets/questions/geometry/grade5_foundation.geometry.v1.json'
A6='assets/questions/arithmetic/grade6_foundation.arithmetic.v1.json'
G6='assets/questions/geometry/grade6_foundation.geometry.v1.json'

rep(A5,'arithmetic_grade5_foundation_011','ribbon_leftover',
 L('一條長 100 公分的緞帶，要剪成每段 12 公分。在盡量多剪的情況下，最後會剩下幾公分？',
   '一条长 100 厘米的缎带，要剪成每段 12 厘米。在尽量多剪的情况下，最后会剩下几厘米？',
   'A ribbon 100 cm long is cut into pieces 12 cm each, cutting as many pieces as possible. How many centimetres are left over?',
   '長さ 100 cm のリボンを 12 cm ずつに切ります。できるだけ多く切ったとき、何 cm 残りますか。'),
 L('答案是 4 公分。','答案是 4 厘米。','The answer is 4 cm.','答えは 4 cm です。'),
 [['要知道剩下幾公分，先算最多能剪出幾段完整的 12 公分。',
   '100 ÷ 12 = 8 餘 4，表示最多剪出 8 段。',
   '這 8 段用掉 8 × 12 = 96 公分。',
   '剩下的就是 100 − 96 = 4 公分。這 4 公分不夠再剪一段（因為不到 12 公分），所以就是最後剩下的長度。'],
  ['要知道剩下几厘米，先算最多能剪出几段完整的 12 厘米。',
   '100 ÷ 12 = 8 余 4，表示最多剪出 8 段。',
   '这 8 段用掉 8 × 12 = 96 厘米。',
   '剩下的就是 100 − 96 = 4 厘米。这 4 厘米不够再剪一段（因为不到 12 厘米），所以就是最后剩下的长度。'],
  ['To find what is left over, first work out how many whole 12 cm pieces can be cut.',
   '100 ÷ 12 = 8 remainder 4, so at most 8 pieces can be cut.',
   'Those 8 pieces use up 8 × 12 = 96 cm.',
   'What remains is 100 − 96 = 4 cm. Four centimetres is not enough for another piece, since a piece needs 12 cm, so that is the final leftover.'],
  ['残りを求めるには、まず 12 cm の切れはしが最大何本とれるかを考えます。',
   '100 ÷ 12 = 8 あまり 4 なので、最大 8 本とれます。',
   'その 8 本で 8 × 12 = 96 cm 使います。',
   '残りは 100 − 96 = 4 cm です。4 cm では 12 cm に足りず もう 1 本とれないので、これが最後に残る長さです。']],
 '4',1,'Replaces one of a pair counting common divisors of two numbers.')

rep(G5,'geometry_grade5_foundation_020','triangle_base_tripled',
 L('一個三角形的面積是 54 平方公分。如果把它的底變成原來的 3 倍，高保持不變，新三角形的面積是幾平方公分？',
   '一个三角形的面积是 54 平方厘米。如果把它的底变成原来的 3 倍，高保持不变，新三角形的面积是几平方厘米？',
   'A triangle has an area of 54 square centimetres. Its base is made 3 times as long while its height stays the same. What is the area of the new triangle?',
   '三角形の面積は 54 cm² です。高さはそのままで底辺を 3 倍にすると、新しい三角形の面積は何 cm² ですか。'),
 L('答案是 162 平方公分。','答案是 162 平方厘米。','The answer is 162 square centimetres.','答えは 162 cm² です。'),
 [['三角形的面積是「底 × 高 ÷ 2」。這一題底變了、高沒變，所以可以直接看面積會怎麼跟著變。',
   '把底變成原來的 3 倍，等於在「底 × 高 ÷ 2」這個算式裡，只有底的部分乘以 3。',
   '算式中有一個因數變成 3 倍，整個結果就跟著變成 3 倍，所以新面積是原面積的 3 倍。',
   '54 × 3 = 162 平方公分。（不需要知道原本的底和高各是多少，也算得出來。）'],
  ['三角形的面积是「底 × 高 ÷ 2」。这一题底变了、高没变，所以可以直接看面积会怎么跟着变。',
   '把底变成原来的 3 倍，等于在「底 × 高 ÷ 2」这个算式里，只有底的部分乘以 3。',
   '算式中有一个因数变成 3 倍，整个结果就跟着变成 3 倍，所以新面积是原面积的 3 倍。',
   '54 × 3 = 162 平方厘米。（不需要知道原本的底和高各是多少，也算得出来。）'],
  ['A triangle\'s area is base times height divided by 2. Here the base changes and the height does not, so look directly at how the area follows.',
   'Tripling the base means multiplying only the base part of base times height divided by 2 by 3.',
   'When one factor in the expression becomes 3 times as large, the whole result becomes 3 times as large, so the new area is 3 times the old.',
   '54 × 3 = 162 square centimetres. The individual values of the base and height are not needed.'],
  ['三角形の面積は「底辺 × 高さ ÷ 2」です。この問題では底辺だけが変わり高さは変わらないので、面積がどう変わるかを直接みます。',
   '底辺を 3 倍にするのは、「底辺 × 高さ ÷ 2」の式の中で底辺の部分だけを 3 倍にすることです。',
   '式の中の 1 つの因数が 3 倍になれば結果も 3 倍になるので、新しい面積はもとの 3 倍です。',
   '54 × 3 = 162 cm² です。もとの底辺や高さの値を知る必要はありません。']],
 '162',3,'Replaces one of a pair cutting a square along its diagonal into two triangles.')

rep(A6,'arithmetic_grade6_foundation_023','count_common_multiples',
 L('1 到 200 之間（含 1 和 200），同時是 6 的倍數又是 8 的倍數的整數有幾個？',
   '1 到 200 之间（含 1 和 200），同时是 6 的倍数又是 8 的倍数的整数有几个？',
   'Between 1 and 200 inclusive, how many integers are multiples of both 6 and 8?',
   '1 から 200 まで（両端をふくむ）の整数のうち、6 の倍数でもあり 8 の倍数でもあるものは何個ありますか。'),
 L('答案是 8 個。','答案是 8 个。','The answer is 8.','答えは 8 個です。'),
 [['同時是 6 的倍數又是 8 的倍數，就是 6 和 8 的公倍數，而所有公倍數都是最小公倍數的倍數。',
   '先求最小公倍數。6 = 2 × 3、8 = 2 × 2 × 2，最小公倍數要同時含 2 的三次方和 3，也就是 24。（不是 6 × 8 = 48，因為 6 和 8 有共同的因數 2。）',
   '所以要數的是 200 以內有幾個 24 的倍數。',
   '200 ÷ 24 = 8 餘 8，所以 24 的倍數有 8 個，分別是 24、48、72、96、120、144、168、192。'],
  ['同时是 6 的倍数又是 8 的倍数，就是 6 和 8 的公倍数，而所有公倍数都是最小公倍数的倍数。',
   '先求最小公倍数。6 = 2 × 3、8 = 2 × 2 × 2，最小公倍数要同时含 2 的三次方和 3，也就是 24。（不是 6 × 8 = 48，因为 6 和 8 有共同的因数 2。）',
   '所以要数的是 200 以内有几个 24 的倍数。',
   '200 ÷ 24 = 8 余 8，所以 24 的倍数有 8 个，分别是 24、48、72、96、120、144、168、192。'],
  ['Being a multiple of both 6 and 8 means being a common multiple, and every common multiple is a multiple of the least common multiple.',
   'Find that first. Since 6 = 2 × 3 and 8 = 2 × 2 × 2, the least common multiple must contain 2 three times and 3 once, giving 24. It is not 6 × 8 = 48, because 6 and 8 share the factor 2.',
   'So the task is to count the multiples of 24 up to 200.',
   '200 ÷ 24 = 8 remainder 8, so there are 8 of them: 24, 48, 72, 96, 120, 144, 168 and 192.'],
  ['6 の倍数でもあり 8 の倍数でもある数は公倍数で、公倍数はすべて最小公倍数の倍数です。',
   'まず最小公倍数を求めます。6 = 2 × 3、8 = 2 × 2 × 2 なので、最小公倍数は 2 を 3 個と 3 を 1 個ふくむ 24 です。6 と 8 は 2 を共有するので 6 × 8 = 48 ではありません。',
   'したがって 200 以下の 24 の倍数を数えます。',
   '200 ÷ 24 = 8 あまり 8 なので 8 個あり、24、48、72、96、120、144、168、192 です。']],
 '8',1,'Replaces one of a same-pack pair with an identical gcd-lcm-and-sum skeleton.')

rep(A6,'arithmetic_grade6_foundation_022','cost_markup_then_discount',
 L('一件商品的成本是 250 元，店家訂的售價比成本高 40%。後來店家以售價的 9 折賣出。這樣賣出後，店家賺了多少元？',
   '一件商品的成本是 250 元，店家订的售价比成本高 40%。后来店家以售价的 9 折卖出。这样卖出后，店家赚了多少元？',
   'An item costs a shop 250 dollars. The shop sets a price 40 percent above cost, then sells it at 90 percent of that price. How much profit does the shop make?',
   'ある商品の仕入れ値は 250 円で、店は仕入れ値より 40 パーセント高い値段をつけました。その後、その値段の 1 割引きで売りました。店の利益は何円ですか。'),
 L('答案是賺 65 元。','答案是赚 65 元。','The answer is 65 dollars.','答えは 65 円です。'),
 [['要算賺多少，先算實際賣出的價錢，再減掉成本。中間有兩個百分比，要照順序處理。',
   '先算訂的售價：比成本高 40%，也就是成本的 140%。250 的 10% 是 25，所以 140% 是 25 × 14 = 350 元。',
   '再算實際賣價：以售價的 9 折賣出，也就是 350 的 90%。350 的 10% 是 35，所以 90% 是 35 × 9 = 315 元。',
   '賺的錢是賣價減成本：315 − 250 = 65 元。（注意 40% 是對成本算的，9 折是對售價算的，兩個百分比的基準不同，不能相加減。）'],
  ['要算赚多少，先算实际卖出的价钱，再减掉成本。中间有两个百分比，要照顺序处理。',
   '先算订的售价：比成本高 40%，也就是成本的 140%。250 的 10% 是 25，所以 140% 是 25 × 14 = 350 元。',
   '再算实际卖价：以售价的 9 折卖出，也就是 350 的 90%。350 的 10% 是 35，所以 90% 是 35 × 9 = 315 元。',
   '赚的钱是卖价减成本：315 − 250 = 65 元。（注意 40% 是对成本算的，9 折是对售价算的，两个百分比的基准不同，不能相加减。）'],
  ['To find the profit, work out the actual selling price first and then subtract the cost. Two percentages appear, and they must be handled in order.',
   'First the marked price: 40 percent above cost is 140 percent of cost. Ten percent of 250 is 25, so 140 percent is 25 × 14 = 350 dollars.',
   'Then the actual price: selling at 90 percent of the marked price means 90 percent of 350. Ten percent of 350 is 35, so 90 percent is 35 × 9 = 315 dollars.',
   'The profit is 315 − 250 = 65 dollars. Note that the 40 percent is taken on the cost while the discount is taken on the marked price, so the two percentages have different bases and cannot simply be combined.'],
  ['利益を求めるには、実際の売値を出してから仕入れ値を引きます。割合が 2 回出てくるので順に処理します。',
   'まず つけた値段です。仕入れ値より 40 パーセント高いので仕入れ値の 140 パーセントです。250 の 10 パーセントは 25 なので、140 パーセントは 25 × 14 = 350 円です。',
   '次に実際の売値です。1 割引きは 350 の 90 パーセントです。350 の 10 パーセントは 35 なので、90 パーセントは 35 × 9 = 315 円です。',
   '利益は 315 − 250 = 65 円です。40 パーセントは仕入れ値に対して、割引は つけた値段に対しての割合で、基準がちがうためそのまま足し引きできません。']],
 '65',2,'Replaces one of a pair with an identical age-problem skeleton.')

rep(A6,'arithmetic_grade6_foundation_030','two_variable_substitution',
 L('4 個大盒和 3 個小盒一共裝了 50 顆球；1 個大盒和 1 個小盒一共裝了 15 顆球。一個大盒裝幾顆球？',
   '4 个大盒和 3 个小盒一共装了 50 颗球；1 个大盒和 1 个小盒一共装了 15 颗球。一个大盒装几颗球？',
   'Four large boxes and 3 small boxes hold 50 balls altogether; 1 large box and 1 small box hold 15 balls altogether. How many balls does one large box hold?',
   '大きい箱 4 個と小さい箱 3 個で合わせて 50 個のボールが入り、大きい箱 1 個と小さい箱 1 個で合わせて 15 個入ります。大きい箱 1 個には何個入りますか。'),
 L('答案是 5 顆。','答案是 5 颗。','The answer is 5 balls.','答えは 5 個です。'),
 [['兩個條件裡都同時有大盒和小盒，沒辦法直接讀出答案，要想辦法把小盒消掉。',
   '第二個條件說「1 大 + 1 小 = 15」。把它整個乘以 3，就得到「3 大 + 3 小 = 45」。',
   '現在兩個式子的小盒個數都是 3 個了，相減就能把小盒消掉：(4 大 + 3 小) − (3 大 + 3 小) = 50 − 45，也就是 1 大 = 5。',
   '所以一個大盒裝 5 顆球。驗算：小盒是 15 − 5 = 10 顆，4 × 5 + 3 × 10 = 20 + 30 = 50，正確。'],
  ['两个条件里都同时有大盒和小盒，没办法直接读出答案，要想办法把小盒消掉。',
   '第二个条件说「1 大 + 1 小 = 15」。把它整个乘以 3，就得到「3 大 + 3 小 = 45」。',
   '现在两个式子的小盒个数都是 3 个了，相减就能把小盒消掉：(4 大 + 3 小) − (3 大 + 3 小) = 50 − 45，也就是 1 大 = 5。',
   '所以一个大盒装 5 颗球。验算：小盒是 15 − 5 = 10 颗，4 × 5 + 3 × 10 = 20 + 30 = 50，正确。'],
  ['Both conditions mix large and small boxes, so the answer cannot be read off directly; the small boxes have to be eliminated.',
   'The second condition says 1 large plus 1 small equals 15. Multiplying it all by 3 gives 3 large plus 3 small equals 45.',
   'Now both statements have 3 small boxes, so subtracting removes them: (4 large + 3 small) − (3 large + 3 small) = 50 − 45, that is 1 large = 5.',
   'So one large box holds 5 balls. Check: a small box holds 15 − 5 = 10, and 4 × 5 + 3 × 10 = 20 + 30 = 50, as required.'],
  ['どちらの条件にも大小の箱が混ざっていて答えを直接読み取れないので、小さい箱を消す工夫をします。',
   '2 つ目の条件「大 1 + 小 1 = 15」を全体で 3 倍すると「大 3 + 小 3 = 45」になります。',
   'これで両方の式の小さい箱が 3 個ずつになり、引けば消えます。(大 4 + 小 3) − (大 3 + 小 3) = 50 − 45 より 大 1 = 5 です。',
   'したがって大きい箱 1 個には 5 個入ります。確かめると小さい箱は 15 − 5 = 10 個で、4 × 5 + 3 × 10 = 20 + 30 = 50 で正しいです。']],
 '5',1,'Replaces one of three same-skeleton calendar questions.')

rep(A6,'arithmetic_grade6_foundation_025','bulk_discount_unit_price',
 L('一盒餅乾原價 120 元。商店推出「一次買 3 盒，總價打 8 折」的優惠。用這個優惠買 3 盒，平均每一盒是多少元？',
   '一盒饼干原价 120 元。商店推出「一次买 3 盒，总价打 8 折」的优惠。用这个优惠买 3 盒，平均每一盒是多少元？',
   'A box of biscuits normally costs 120 dollars. The shop offers 20 percent off the total when 3 boxes are bought at once. Using that offer, what is the average price per box?',
   'クッキー 1 箱の定価は 120 円です。店では「3 箱まとめ買いで合計 2 割引き」の割引があります。この割引で 3 箱買うと、1 箱あたり平均何円ですか。'),
 L('答案是 96 元。','答案是 96 元。','The answer is 96 dollars.','答えは 96 円です。'),
 [['先算沒有優惠時 3 盒的原價：120 × 3 = 360 元。',
   '打 8 折表示只付原價的 10 分之 8。360 的 10 分之 1 是 36，所以 10 分之 8 是 36 × 8 = 288 元。',
   '平均每盒是總價除以盒數：288 ÷ 3 = 96 元。',
   '也可以更快：折扣是對總價打的，每一盒受到的折扣比例都一樣，所以直接把單價打 8 折就好——120 的 10 分之 8 是 12 × 8 = 96 元，結果相同。'],
  ['先算没有优惠时 3 盒的原价：120 × 3 = 360 元。',
   '打 8 折表示只付原价的 10 分之 8。360 的 10 分之 1 是 36，所以 10 分之 8 是 36 × 8 = 288 元。',
   '平均每盒是总价除以盒数：288 ÷ 3 = 96 元。',
   '也可以更快：折扣是对总价打的，每一盒受到的折扣比例都一样，所以直接把单价打 8 折就好——120 的 10 分之 8 是 12 × 8 = 96 元，结果相同。'],
  ['First find the full price of 3 boxes without the offer: 120 × 3 = 360 dollars.',
   'Twenty percent off means paying eight tenths of the full price. One tenth of 360 is 36, so eight tenths is 36 × 8 = 288 dollars.',
   'The average per box is the total divided by the number of boxes: 288 ÷ 3 = 96 dollars.',
   'A quicker route: the discount applies to the total, so every box is discounted in the same proportion, and the single price can be discounted directly. Eight tenths of 120 is 12 × 8 = 96 dollars, the same answer.'],
  ['まず割引なしの 3 箱の値段を求めます。120 × 3 = 360 円です。',
   '2 割引きは定価の 10 分の 8 をはらうことです。360 の 10 分の 1 は 36 なので、10 分の 8 は 36 × 8 = 288 円です。',
   '1 箱あたりは合計を箱数でわって 288 ÷ 3 = 96 円です。',
   'もっと速い方法もあります。割引は合計にかかり どの箱も同じ割合で安くなるので、1 箱の値段を直接 2 割引きすればよく、120 の 10 分の 8 は 12 × 8 = 96 円で同じです。']],
 '96',2,'Replaces one of a pair with an identical "N identical containers plus M loose items" skeleton.')

rep(A6,'arithmetic_grade6_foundation_018','mixture_concentration',
 L('把 300 公克含鹽 12% 的鹽水，和 200 公克含鹽 7% 的鹽水混在一起。混合後的鹽水含鹽率是百分之幾？',
   '把 300 克含盐 12% 的盐水，和 200 克含盐 7% 的盐水混在一起。混合后的盐水含盐率是百分之几？',
   '300 g of salt water that is 12 percent salt is mixed with 200 g of salt water that is 7 percent salt. What percentage of the mixture is salt?',
   '塩分 12 パーセントの食塩水 300 g と、塩分 7 パーセントの食塩水 200 g を混ぜます。混ぜた後の濃度は何パーセントですか。'),
 L('答案是 10%。','答案是 10%。','The answer is 10 percent.','答えは 10 パーセントです。'),
 [['濃度不能直接把 12% 和 7% 平均，因為兩杯的重量不一樣。正確做法是分別算出鹽的重量，再除以總重量。',
   '第一杯的鹽：300 的 12% = 300 × 0.12 = 36 公克。',
   '第二杯的鹽：200 的 7% = 200 × 0.07 = 14 公克。混合後鹽共有 36 + 14 = 50 公克。',
   '混合後總重量是 300 + 200 = 500 公克，所以含鹽率是 50 ÷ 500 = 0.1，也就是 10%。（如果直接平均 12% 和 7% 會得到 9.5%，那是把兩杯當成一樣重，不對。）'],
  ['浓度不能直接把 12% 和 7% 平均，因为两杯的重量不一样。正确做法是分别算出盐的重量，再除以总重量。',
   '第一杯的盐：300 的 12% = 300 × 0.12 = 36 克。',
   '第二杯的盐：200 的 7% = 200 × 0.07 = 14 克。混合后盐共有 36 + 14 = 50 克。',
   '混合后总重量是 300 + 200 = 500 克，所以含盐率是 50 ÷ 500 = 0.1，也就是 10%。（如果直接平均 12% 和 7% 会得到 9.5%，那是把两杯当成一样重，不对。）'],
  ['The concentration cannot be found by averaging 12 and 7 percent, because the two portions have different weights. Instead find the weight of salt in each and divide by the total weight.',
   'Salt in the first portion: 12 percent of 300 is 300 × 0.12 = 36 g.',
   'Salt in the second: 7 percent of 200 is 200 × 0.07 = 14 g. After mixing there are 36 + 14 = 50 g of salt.',
   'The mixture weighs 300 + 200 = 500 g, so the concentration is 50 ÷ 500 = 0.1, that is 10 percent. Averaging 12 and 7 to get 9.5 percent would wrongly treat the two portions as equally heavy.'],
  ['12 パーセントと 7 パーセントをそのまま平均してはいけません。2 つの重さがちがうからです。それぞれの塩の重さを求め、全体の重さでわります。',
   '1 つ目の塩は 300 の 12 パーセントで 300 × 0.12 = 36 g です。',
   '2 つ目の塩は 200 の 7 パーセントで 200 × 0.07 = 14 g です。混ぜると塩は 36 + 14 = 50 g になります。',
   '混合後の重さは 300 + 200 = 500 g なので、濃度は 50 ÷ 500 = 0.1、つまり 10 パーセントです。12 と 7 を平均して 9.5 パーセントとするのは、2 つを同じ重さとみなした誤りです。']],
 '10',2,'Replaces one of a same-pack pair with identical bus-interval numbers, differing only in the quantity asked for.')

rep(G6,'geometry_grade6_foundation_016','remainder_after_largest_square',
 L('一個長方形的長是 9 公分、寬是 6 公分。從它裡面剪下一個邊長盡量大的正方形之後，剩下那一塊的面積是幾平方公分？',
   '一个长方形的长是 9 厘米、宽是 6 厘米。从它里面剪下一个边长尽量大的正方形之后，剩下那一块的面积是几平方厘米？',
   'A rectangle is 9 cm long and 6 cm wide. The largest possible square is cut from it. What is the area of the piece left over, in square centimetres?',
   'たて 6 cm、よこ 9 cm の長方形から、できるだけ大きい正方形を切り取ります。残った部分の面積は何 cm² ですか。'),
 L('答案是 18 平方公分。','答案是 18 平方厘米。','The answer is 18 square centimetres.','答えは 18 cm² です。'),
 [['能剪下的最大正方形，邊長受限於長方形比較短的那一邊——邊長不能超過寬，否則正方形會超出紙外。',
   '寬是 6 公分，所以最大的正方形邊長就是 6 公分，面積是 6 × 6 = 36 平方公分。',
   '原本長方形的面積是 9 × 6 = 54 平方公分。',
   '剩下的面積是 54 − 36 = 18 平方公分。（剩下的那一塊是一個長 3 公分、寬 6 公分的長方形，3 × 6 = 18，結果相同。）'],
  ['能剪下的最大正方形，边长受限于长方形比较短的那一边——边长不能超过宽，否则正方形会超出纸外。',
   '宽是 6 厘米，所以最大的正方形边长就是 6 厘米，面积是 6 × 6 = 36 平方厘米。',
   '原本长方形的面积是 9 × 6 = 54 平方厘米。',
   '剩下的面积是 54 − 36 = 18 平方厘米。（剩下的那一块是一个长 3 厘米、宽 6 厘米的长方形，3 × 6 = 18，结果相同。）'],
  ['The largest square that can be cut out is limited by the shorter side of the rectangle: its side cannot exceed the width, or the square would stick out.',
   'The width is 6 cm, so the largest square has sides of 6 cm and area 6 × 6 = 36 square centimetres.',
   'The whole rectangle has area 9 × 6 = 54 square centimetres.',
   'The leftover area is 54 − 36 = 18 square centimetres. The leftover piece is itself a rectangle 3 cm by 6 cm, and 3 × 6 = 18 gives the same answer.'],
  ['切り取れる最大の正方形は、長方形の短いほうの辺に制限されます。1 辺が幅をこえると紙からはみ出すからです。',
   '幅は 6 cm なので最大の正方形は 1 辺 6 cm、面積は 6 × 6 = 36 cm² です。',
   'もとの長方形の面積は 9 × 6 = 54 cm² です。',
   '残りの面積は 54 − 36 = 18 cm² です。残った部分は たて 6 cm・よこ 3 cm の長方形で、3 × 6 = 18 と同じ結果になります。']],
 '18',2,'Replaces one of a same-pack pair of triangle-angle-relation questions.')

rep(G6,'geometry_grade6_foundation_017','parallelogram_fourth_vertex',
 L('座標平面上有一個平行四邊形，其中三個頂點是 (0, 0)、(5, 0)、(2, 4)。若第四個頂點也在第一象限，這個頂點的兩個座標加起來是多少？',
   '坐标平面上有一个平行四边形，其中三个顶点是 (0, 0)、(5, 0)、(2, 4)。若第四个顶点也在第一象限，这个顶点的两个坐标加起来是多少？',
   'A parallelogram in the coordinate plane has three of its vertices at (0, 0), (5, 0) and (2, 4). If the fourth vertex also lies in the first quadrant, what is the sum of its two coordinates?',
   '座標平面上の平行四辺形の 3 つの頂点が (0, 0)、(5, 0)、(2, 4) です。4 つ目の頂点も第 1 象限にあるとき、その頂点の 2 つの座標の和はいくつですか。'),
 L('答案是 11。','答案是 11。','The answer is 11.','答えは 11 です。'),
 [['平行四邊形的對邊互相平行且等長，所以從一個頂點到另一個頂點的「移動量」，在對邊上會完全一樣。',
   '從 (0, 0) 到 (5, 0)，是往右移 5、上下不動。那麼從 (2, 4) 出發做同樣的移動，就會到達第四個頂點。',
   '(2 + 5, 4 + 0) = (7, 4)。這個點的 x 和 y 都是正的，確實落在第一象限，符合題目條件。',
   '兩個座標加起來是 7 + 4 = 11。（另外兩種接法會得到 (−3, 4) 和 (3, −4)，都不在第一象限，所以答案唯一。）'],
  ['平行四边形的对边互相平行且等长，所以从一个顶点到另一个顶点的「移动量」，在对边上会完全一样。',
   '从 (0, 0) 到 (5, 0)，是往右移 5、上下不动。那么从 (2, 4) 出发做同样的移动，就会到达第四个顶点。',
   '(2 + 5, 4 + 0) = (7, 4)。这个点的 x 和 y 都是正的，确实落在第一象限，符合题目条件。',
   '两个坐标加起来是 7 + 4 = 11。（另外两种接法会得到 (−3, 4) 和 (3, −4)，都不在第一象限，所以答案唯一。）'],
  ['Opposite sides of a parallelogram are parallel and equal in length, so the step from one vertex to another is repeated exactly along the opposite side.',
   'Going from (0, 0) to (5, 0) means moving 5 to the right with no vertical change. Making the same move starting from (2, 4) lands on the fourth vertex.',
   '(2 + 5, 4 + 0) = (7, 4). Both coordinates are positive, so this point really is in the first quadrant, as the problem requires.',
   'The sum of its coordinates is 7 + 4 = 11. The two other ways of closing the shape give (−3, 4) and (3, −4), neither in the first quadrant, so the answer is unique.'],
  ['平行四辺形の向かい合う辺は平行で長さも等しいので、ある頂点から別の頂点への「移動」は 向かい合う辺でもまったく同じになります。',
   '(0, 0) から (5, 0) への移動は 右へ 5、上下は 0 です。(2, 4) から同じ移動をすると 4 つ目の頂点に着きます。',
   '(2 + 5, 4 + 0) = (7, 4) です。x も y も正なので確かに第 1 象限にあり、条件に合います。',
   '座標の和は 7 + 4 = 11 です。他の 2 通りのつなぎ方では (−3, 4) と (3, −4) になり どちらも第 1 象限ではないので、答えは 1 つに決まります。']],
 '11',2,'Replaces one of a same-pack pair computing the area of a coordinate rectangle.')

for p, d in P.items():
    for q in d['questions']:
        assert len({len(v) for v in q['solutionSteps'].values()}) == 1, q['id']
        if q['answerMode'] == 'integer_input': assert 'options' not in q, q['id']
    with io.open(p,'w',encoding='utf-8') as f:
        json.dump(d,f,ensure_ascii=False,indent=2); f.write('\n')
print('\n寫回', len(P), '個 pack')
