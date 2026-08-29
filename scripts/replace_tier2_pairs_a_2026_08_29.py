# -*- coding: utf-8 -*-
"""替換 Tier 2 兩題家族（第一批 9 題）。

全庫掃描找出 30 組「題幹 >= 0.55 且詳解 >= 0.60」的配對。取「詳解 >= 0.70
或同 pack」這條線，需要替換 18 題。這是前 9 題。
"""
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
    print('%-34s %-26s 答%-4s 原: %s…' % (qid[-34:], sub, val, old))

L1='assets/questions/logic/grade1_foundation.logic.v1.json'
A3='assets/questions/arithmetic/grade3_foundation.arithmetic.v1.json'
A4='assets/questions/arithmetic/grade4_foundation.arithmetic.v1.json'
G4='assets/questions/geometry/grade4_foundation.geometry.v1.json'
L4='assets/questions/logic/grade4_foundation.logic.v1.json'
A5='assets/questions/arithmetic/grade5_foundation.arithmetic.v1.json'

rep(L1,'logic_grade1_foundation_018','compare_three_numbers',
 L('桌上有三張卡片，分別寫著 8、3、5。哪一張卡片上的數字最小？',
   '桌上有三张卡片，分别写着 8、3、5。哪一张卡片上的数字最小？',
   'Three cards on a table show 8, 3 and 5. Which card has the smallest number on it?',
   'つくえの上に 8、3、5 と書かれたカードが 3 まいあります。いちばん小さい数字はどれですか。'),
 L('答案是 3。','答案是 3。','The answer is 3.','答えは 3 です。'),
 [['要找最小的數，可以兩個兩個比，一路把比較小的留下來。',
   '先比 8 和 3：3 比 8 小，所以先記住 3。',
   '再把 3 和 5 比：3 還是比較小。',
   '三個數都比過了，最小的是 3。（也可以把它們由小到大排成 3、5、8，排在最前面的就是最小的。）'],
  ['要找最小的数，可以两个两个比，一路把比较小的留下来。',
   '先比 8 和 3：3 比 8 小，所以先记住 3。',
   '再把 3 和 5 比：3 还是比较小。',
   '三个数都比过了，最小的是 3。（也可以把它们由小到大排成 3、5、8，排在最前面的就是最小的。）'],
  ['To find the smallest number, compare them two at a time and keep the smaller one each time.',
   'Compare 8 and 3 first: 3 is smaller than 8, so remember 3.',
   'Now compare 3 with 5: 3 is still the smaller one.',
   'All three have been compared, so the smallest is 3. Sorting them as 3, 5, 8 puts the smallest first as well.'],
  ['いちばん小さい数を見つけるには、2 つずつくらべて小さいほうを残していきます。',
   'まず 8 と 3 をくらべます。3 のほうが小さいので 3 を覚えておきます。',
   '次に 3 と 5 をくらべます。やはり 3 のほうが小さいです。',
   '3 つとも比べ終わり、いちばん小さいのは 3 です。小さい順に 3、5、8 と並べても先頭が最小です。']],
 '3',1,'Replaces one of a same-pack pair asking "bigger than X but not the biggest".')

rep(A3,'arithmetic_grade3_foundation_003','digit_occurrence_count',
 L('把 1 到 30 這些數全部寫下來。數字 2 一共出現了幾次？',
   '把 1 到 30 这些数全部写下来。数字 2 一共出现了几次？',
   'Write out all the numbers from 1 to 30. How many times does the digit 2 appear?',
   '1 から 30 までの数をすべて書き出します。数字の 2 は何回あらわれますか。'),
 L('答案是 13 次。','答案是 13 次。','The answer is 13.','答えは 13 回です。'),
 [['分成「個位是 2」和「十位是 2」兩種情形來數，才不會漏掉，但要小心兩種都算到的數。',
   '個位是 2 的數有 2、12、22，共 3 個，各貢獻 1 次。',
   '十位是 2 的數有 20 到 29，共 10 個，各貢獻 1 次。',
   '3 + 10 = 13 次。（22 這個數的個位和十位都是 2，在上面兩類裡各被算了一次，剛好對應它真的出現了 2 次，所以不必扣掉。）'],
  ['分成「个位是 2」和「十位是 2」两种情形来数，才不会漏掉，但要小心两种都算到的数。',
   '个位是 2 的数有 2、12、22，共 3 个，各贡献 1 次。',
   '十位是 2 的数有 20 到 29，共 10 个，各贡献 1 次。',
   '3 + 10 = 13 次。（22 这个数的个位和十位都是 2，在上面两类里各被算了一次，刚好对应它真的出现了 2 次，所以不必扣掉。）'],
  ['Count in two cases, digits 2 in the units place and digits 2 in the tens place, so that none is missed; just watch the numbers caught by both.',
   'Numbers with 2 in the units place are 2, 12 and 22, which is 3 numbers contributing one each.',
   'Numbers with 2 in the tens place are 20 through 29, which is 10 numbers contributing one each.',
   '3 + 10 = 13. The number 22 has a 2 in both places and was counted once in each case, which correctly reflects that it really does contain the digit twice, so nothing needs subtracting.'],
  ['一の位が 2 の場合と十の位が 2 の場合に分けて数えると もれがありません。両方に入る数だけ注意します。',
   '一の位が 2 なのは 2、12、22 の 3 個で、それぞれ 1 回ずつです。',
   '十の位が 2 なのは 20 から 29 の 10 個で、それぞれ 1 回ずつです。',
   '3 + 10 = 13 回です。22 は一の位も十の位も 2 で 両方の場合に 1 回ずつ数えられますが、実際に 2 が 2 回あるので引く必要はありません。']],
 '13',2,'Replaces one of a pair with identical prompt and solution structure (counting digits written from 1 to N).')

rep(A4,'arithmetic_grade4_foundation_010','boxes_needed_ceiling',
 L('有 50 顆蘋果，每個箱子最多只能裝 8 顆。要把全部蘋果都裝完，最少需要幾個箱子？',
   '有 50 颗苹果，每个箱子最多只能装 8 颗。要把全部苹果都装完，最少需要几个箱子？',
   'There are 50 apples, and each box holds at most 8. What is the smallest number of boxes needed to pack them all?',
   'りんごが 50 個あり、1 箱には最大 8 個まで入ります。すべて詰めるには箱が最少で何個必要ですか。'),
 L('答案是 7 個箱子。','答案是 7 个箱子。','The answer is 7 boxes.','答えは 7 箱です。'),
 [['先看 50 顆蘋果可以裝滿幾個箱子。',
   '50 ÷ 8 = 6 餘 2，表示可以裝滿 6 個箱子，但還剩下 2 顆蘋果。',
   '剩下的 2 顆也一定要裝起來，所以還要再多用 1 個箱子（雖然那個箱子沒裝滿）。',
   '6 + 1 = 7 個箱子。（這種題目算出餘數後不能直接捨掉，只要有剩就要多一個容器。）'],
  ['先看 50 颗苹果可以装满几个箱子。',
   '50 ÷ 8 = 6 余 2，表示可以装满 6 个箱子，但还剩下 2 颗苹果。',
   '剩下的 2 颗也一定要装起来，所以还要再多用 1 个箱子（虽然那个箱子没装满）。',
   '6 + 1 = 7 个箱子。（这种题目算出余数后不能直接舍掉，只要有剩就要多一个容器。）'],
  ['First see how many boxes can be filled completely by 50 apples.',
   '50 ÷ 8 = 6 remainder 2, so 6 boxes can be filled with 2 apples left over.',
   'Those 2 leftover apples still have to be packed, so one more box is needed even though it will not be full.',
   '6 + 1 = 7 boxes. In problems like this the remainder cannot simply be dropped: any leftover forces one extra container.'],
  ['まず 50 個のりんごで何箱いっぱいにできるかを見ます。',
   '50 ÷ 8 = 6 あまり 2 なので、6 箱をいっぱいにでき、2 個あまります。',
   'あまった 2 個も詰めなければならないので、いっぱいにはならなくても もう 1 箱必要です。',
   '6 + 1 = 7 箱です。この種の問題ではあまりを切りすてられず、少しでも残れば容器が 1 つふえます。']],
 '7',1,'Replaces one of a pair asking how many are left after equal sharing.')

rep(G4,'geometry_grade4_foundation_014','fence_three_sides',
 L('一塊長方形的菜園長 12 公尺、寬 7 公尺。要沿著菜園四周圍一圈籬笆，但其中一條長邊剛好靠著牆，那一邊不用圍。需要圍幾公尺的籬笆？',
   '一块长方形的菜园长 12 米、宽 7 米。要沿着菜园四周围一圈篱笆，但其中一条长边刚好靠着墙，那一边不用围。需要围几米的篱笆？',
   'A rectangular vegetable plot is 12 m long and 7 m wide. A fence is put right round it, except that one of the long sides runs along a wall and needs no fence. How many metres of fence are needed?',
   '長方形の畑は たて 7 m、よこ 12 m です。まわりにさくを作りますが、長いほうの辺の 1 つはかべに接していてさくが不要です。さくは何 m 必要ですか。'),
 L('答案是 26 公尺。','答案是 26 米。','The answer is 26 metres.','答えは 26 m です。'),
 [['先算完整圍一圈要多少：長方形的周長是（長 + 寬）的 2 倍。',
   '(12 + 7) × 2 = 19 × 2 = 38 公尺。',
   '但有一條長邊靠牆不用圍，那一邊長 12 公尺，要從周長裡扣掉。',
   '38 − 12 = 26 公尺。（也可以直接數要圍的邊：一條長邊 12 加上兩條寬邊 7 + 7，12 + 14 = 26 公尺。）'],
  ['先算完整围一圈要多少：长方形的周长是（长 + 宽）的 2 倍。',
   '(12 + 7) × 2 = 19 × 2 = 38 米。',
   '但有一条长边靠墙不用围，那一边长 12 米，要从周长里扣掉。',
   '38 − 12 = 26 米。（也可以直接数要围的边：一条长边 12 加上两条宽边 7 + 7，12 + 14 = 26 米。）'],
  ['First find the full way round: a rectangle\'s perimeter is twice the length plus the width.',
   '(12 + 7) × 2 = 19 × 2 = 38 metres.',
   'But one long side runs along the wall and needs no fence, and that side is 12 metres, so it comes off the perimeter.',
   '38 − 12 = 26 metres. Counting the fenced sides directly gives the same: one long side of 12 plus two widths of 7, so 12 + 14 = 26 metres.'],
  ['まず一周分を求めます。長方形のまわりの長さは（たて + よこ）の 2 倍です。',
   '(12 + 7) × 2 = 19 × 2 = 38 m です。',
   'しかし長いほうの辺 1 つはかべに接していてさくが要らず、その辺は 12 m なので まわりの長さから引きます。',
   '38 − 12 = 26 m です。さくを作る辺を直接数えても、長い辺 12 と幅 7 が 2 つで 12 + 14 = 26 m と同じです。']],
 '26',2,'Replaces one of a pair giving a perimeter and one side and asking for the area.')

rep(G4,'geometry_grade4_foundation_036','area_gain_from_stretch',
 L('一個正方形的邊長是 8 公分。把它的一組對邊各往外拉長 3 公分，另一組對邊的長度不變，就變成一個長方形。這個長方形的面積比原來的正方形多幾平方公分？',
   '一个正方形的边长是 8 厘米。把它的一组对边各往外拉长 3 厘米，另一组对边的长度不变，就变成一个长方形。这个长方形的面积比原来的正方形多几平方厘米？',
   'A square has sides of 8 cm. One pair of opposite sides is stretched outwards by 3 cm while the other pair keeps its length, turning it into a rectangle. By how many square centimetres is the rectangle\'s area greater than the square\'s?',
   '1 辺 8 cm の正方形があります。向かい合う 1 組の辺を 3 cm ずつのばし、もう 1 組の辺の長さは変えずに長方形にします。長方形の面積は もとの正方形より何 cm² 大きいですか。'),
 L('答案是多 24 平方公分。','答案是多 24 平方厘米。','The answer is 24 square centimetres more.','答えは 24 cm² 大きいです。'),
 [['先算原來正方形的面積：8 × 8 = 64 平方公分。',
   '拉長之後，一邊變成 8 + 3 = 11 公分，另一邊還是 8 公分，所以新長方形的面積是 11 × 8 = 88 平方公分。',
   '多出來的面積是 88 − 64 = 24 平方公分。',
   '也可以直接看多出來的那一塊：它是一個長 3 公分、寬 8 公分的長方形，面積 3 × 8 = 24 平方公分，結果一樣。'],
  ['先算原来正方形的面积：8 × 8 = 64 平方厘米。',
   '拉长之后，一边变成 8 + 3 = 11 厘米，另一边还是 8 厘米，所以新长方形的面积是 11 × 8 = 88 平方厘米。',
   '多出来的面积是 88 − 64 = 24 平方厘米。',
   '也可以直接看多出来的那一块：它是一个长 3 厘米、宽 8 厘米的长方形，面积 3 × 8 = 24 平方厘米，结果一样。'],
  ['First the original square: its area is 8 × 8 = 64 square centimetres.',
   'After stretching, one side becomes 8 + 3 = 11 cm while the other stays 8 cm, so the new rectangle has area 11 × 8 = 88 square centimetres.',
   'The gain is 88 − 64 = 24 square centimetres.',
   'Looking straight at the added strip gives the same: it is a rectangle 3 cm by 8 cm, with area 3 × 8 = 24 square centimetres.'],
  ['まず もとの正方形の面積です。8 × 8 = 64 cm² です。',
   'のばした後は一方の辺が 8 + 3 = 11 cm、もう一方は 8 cm のままなので、長方形の面積は 11 × 8 = 88 cm² です。',
   'ふえた面積は 88 − 64 = 24 cm² です。',
   'ふえた部分を直接見ても同じで、たて 3 cm・よこ 8 cm の長方形なので 3 × 8 = 24 cm² です。']],
 '24',2,'Replaces one of a same-pack pair giving a perimeter plus a length-width relation and asking for the area.')

rep(G4,'geometry_grade4_foundation_043','hour_hand_turn_degrees',
 L('時鐘的鐘面平分成 12 個大格。時針從指著 2 一直走到指著 7，一共轉過了幾度？',
   '时钟的钟面平分成 12 个大格。时针从指着 2 一直走到指着 7，一共转过了几度？',
   'A clock face is divided into 12 equal big marks. The hour hand moves from pointing at 2 all the way to pointing at 7. Through how many degrees does it turn?',
   '時計の文字ばんは 12 の大きい目もりに等分されています。短針が 2 を指すところから 7 を指すところまで動くと、何度回りますか。'),
 L('答案是 150 度。','答案是 150 度。','The answer is 150 degrees.','答えは 150 度です。'),
 [['整個鐘面轉一圈是 360 度，而且被平分成 12 個大格。',
   '所以一個大格對應的角度是 360 ÷ 12 = 30 度。',
   '時針從 2 走到 7，中間經過 7 − 2 = 5 個大格。',
   '5 個大格就是 5 × 30 = 150 度。（順帶一提，這段時間剛好是 5 個小時。）'],
  ['整个钟面转一圈是 360 度，而且被平分成 12 个大格。',
   '所以一个大格对应的角度是 360 ÷ 12 = 30 度。',
   '时针从 2 走到 7，中间经过 7 − 2 = 5 个大格。',
   '5 个大格就是 5 × 30 = 150 度。（顺带一提，这段时间刚好是 5 个小时。）'],
  ['A full turn round the clock face is 360 degrees, and the face is divided into 12 equal big marks.',
   'So one big mark corresponds to 360 ÷ 12 = 30 degrees.',
   'Going from 2 to 7 the hour hand passes 7 − 2 = 5 big marks.',
   'Five big marks make 5 × 30 = 150 degrees. As a side note, that stretch of time is exactly 5 hours.'],
  ['文字ばん一周は 360 度で、12 の大きい目もりに等分されています。',
   'したがって大きい目もり 1 つ分は 360 ÷ 12 = 30 度です。',
   '短針は 2 から 7 まで 7 − 2 = 5 目もり分動きます。',
   '5 目もりは 5 × 30 = 150 度です。ちなみにこの間はちょうど 5 時間です。']],
 '150',3,'Replaces one of a pair about a 120-degree exterior angle of a triangle.')

rep(L4,'logic_grade4_foundation_006','periodic_visits_in_month',
 L('三月有 31 天。小明從 3 月 1 日開始去圖書館，之後每隔 4 天再去一次（也就是 3 月 1 日、5 日、9 日……）。整個三月他一共去了幾次？',
   '三月有 31 天。小明从 3 月 1 日开始去图书馆，之后每隔 4 天再去一次（也就是 3 月 1 日、5 日、9 日……）。整个三月他一共去了几次？',
   'March has 31 days. Ming goes to the library on 1 March and then every 4 days after that, so on 1 March, 5 March, 9 March and so on. How many visits does he make during March?',
   '3 月は 31 日あります。明は 3 月 1 日に図書館へ行き、その後は 4 日おきに行きます（3 月 1 日、5 日、9 日 ……）。3 月中に何回行きますか。'),
 L('答案是 8 次。','答案是 8 次。','The answer is 8 visits.','答えは 8 回です。'),
 [['去圖書館的日期從 1 號開始，每次加 4，所以是 1、5、9、13、17、21、25、29。',
   '下一個會是 29 + 4 = 33 號，但三月只有 31 天，所以到 29 號就結束了。',
   '把日期數一數：1、5、9、13、17、21、25、29，一共 8 個。',
   '所以整個三月他去了 8 次。（也可以算：從 1 號到 29 號中間相差 28 天，28 ÷ 4 = 7 個間隔，次數比間隔多 1，是 8 次。）'],
  ['去图书馆的日期从 1 号开始，每次加 4，所以是 1、5、9、13、17、21、25、29。',
   '下一个会是 29 + 4 = 33 号，但三月只有 31 天，所以到 29 号就结束了。',
   '把日期数一数：1、5、9、13、17、21、25、29，一共 8 个。',
   '所以整个三月他去了 8 次。（也可以算：从 1 号到 29 号中间相差 28 天，28 ÷ 4 = 7 个间隔，次数比间隔多 1，是 8 次。）'],
  ['The visit dates start at 1 and go up by 4 each time: 1, 5, 9, 13, 17, 21, 25, 29.',
   'The next would be 29 + 4 = 33, but March has only 31 days, so the list stops at 29.',
   'Counting the dates 1, 5, 9, 13, 17, 21, 25 and 29 gives 8 of them.',
   'So he goes 8 times in March. Working it out another way: from the 1st to the 29th is 28 days, 28 ÷ 4 = 7 gaps, and the number of visits is one more than the number of gaps, which is 8.'],
  ['行く日は 1 日から始まり 4 ずつふえるので 1、5、9、13、17、21、25、29 日です。',
   '次は 29 + 4 = 33 日ですが、3 月は 31 日までなので 29 日で終わりです。',
   '日付を数えると 1、5、9、13、17、21、25、29 の 8 個です。',
   'したがって 3 月には 8 回行きます。別の求め方として、1 日から 29 日まで 28 日、28 ÷ 4 = 7 個の間隔で、回数は間隔より 1 多い 8 回です。']],
 '8',1,'Replaces one of a pair picking a number from four candidates by two divisibility conditions.')

rep(A5,'arithmetic_grade5_foundation_031','reverse_two_operations',
 L('一個數乘以 3 之後再減去 8，結果等於 25。這個數是多少？',
   '一个数乘以 3 之后再减去 8，结果等于 25。这个数是多少？',
   'A number is multiplied by 3 and then 8 is subtracted, giving 25. What is the number?',
   'ある数に 3 をかけてから 8 を引くと 25 になります。もとの数はいくつですか。'),
 L('答案是 11。','答案是 11。','The answer is 11.','答えは 11 です。'),
 [['原本的做法是「先乘 3，再減 8」。要倒推回去，就要把每一步反過來，而且順序也要反過來。',
   '最後一步是減 8，倒推時先把它加回來：25 + 8 = 33。',
   '前一步是乘以 3，倒推時要除以 3：33 ÷ 3 = 11。',
   '所以這個數是 11。驗算：11 × 3 = 33，33 − 8 = 25，正確。（如果先除 3 再加 8 會得到 25 ÷ 3 不整除，那是順序沒有反過來。）'],
  ['原本的做法是「先乘 3，再减 8」。要倒推回去，就要把每一步反过来，而且顺序也要反过来。',
   '最后一步是减 8，倒推时先把它加回来：25 + 8 = 33。',
   '前一步是乘以 3，倒推时要除以 3：33 ÷ 3 = 11。',
   '所以这个数是 11。验算：11 × 3 = 33，33 − 8 = 25，正确。（如果先除 3 再加 8 会得到 25 ÷ 3 不整除，那是顺序没有反过来。）'],
  ['The original process is multiply by 3, then subtract 8. To work backwards, reverse each step and also reverse the order of the steps.',
   'The last step was subtracting 8, so undo it first by adding it back: 25 + 8 = 33.',
   'The step before was multiplying by 3, so undo it by dividing: 33 ÷ 3 = 11.',
   'The number is 11. Check: 11 × 3 = 33 and 33 − 8 = 25. Dividing by 3 first would give 25 ÷ 3, which does not come out evenly, because the order was not reversed.'],
  ['もとの手順は「3 をかけてから 8 を引く」です。さかのぼるには各操作を逆にし、順序も逆にします。',
   '最後の操作は 8 を引くことなので、まず足しもどします。25 + 8 = 33 です。',
   'その前は 3 をかけることなので、わりもどします。33 ÷ 3 = 11 です。',
   'よってもとの数は 11 です。確かめると 11 × 3 = 33、33 − 8 = 25 で正しいです。先に 3 でわると 25 ÷ 3 でわり切れず、順序を逆にしていない誤りです。']],
 '11',2,'Replaces one of three same-skeleton calendar questions.')

rep(A5,'arithmetic_grade5_foundation_003','common_denominator_largest',
 L('把 3 分之 2、5 分之 3、4 分之 3 這三個分數通分成同分母（取三個分母的最小公倍數當共同分母）之後比較大小。最大的那個分數，通分之後的分子是多少？',
   '把 3 分之 2、5 分之 3、4 分之 3 这三个分数通分成同分母（取三个分母的最小公倍数当共同分母）之后比较大小。最大的那个分数，通分之后的分子是多少？',
   'The fractions 2 over 3, 3 over 5 and 3 over 4 are rewritten over a common denominator, taking the least common multiple of the three denominators. After that, what is the numerator of the largest fraction?',
   '3 分の 2、5 分の 3、4 分の 3 を、3 つの分母の最小公倍数を共通の分母として通分し、大きさをくらべます。いちばん大きい分数の、通分後の分子はいくつですか。'),
 L('答案是 45。','答案是 45。','The answer is 45.','答えは 45 です。'),
 [['分母不同的分數不能直接比大小，要先通分成同一個分母。共同分母取 3、5、4 的最小公倍數。',
   '3、5、4 兩兩互質或無共同因數，最小公倍數是 3 × 5 × 4 = 60。',
   '把三個分數都換成分母 60：3 分之 2 = 60 分之 40（分子分母同乘 20），5 分之 3 = 60 分之 36（同乘 12），4 分之 3 = 60 分之 45（同乘 15）。',
   '分母相同時，分子越大分數就越大。40、36、45 之中最大的是 45，所以最大的分數是 60 分之 45，分子是 45。'],
  ['分母不同的分数不能直接比大小，要先通分成同一个分母。共同分母取 3、5、4 的最小公倍数。',
   '3、5、4 两两互质或无共同因数，最小公倍数是 3 × 5 × 4 = 60。',
   '把三个分数都换成分母 60：3 分之 2 = 60 分之 40（分子分母同乘 20），5 分之 3 = 60 分之 36（同乘 12），4 分之 3 = 60 分之 45（同乘 15）。',
   '分母相同时，分子越大分数就越大。40、36、45 之中最大的是 45，所以最大的分数是 60 分之 45，分子是 45。'],
  ['Fractions with different denominators cannot be compared directly, so rewrite them over one common denominator, taking the least common multiple of 3, 5 and 4.',
   'Since 3, 5 and 4 share no common factors between them, the least common multiple is 3 × 5 × 4 = 60.',
   'Rewrite each fraction over 60: 2 over 3 becomes 40 over 60 by multiplying top and bottom by 20, 3 over 5 becomes 36 over 60 by multiplying by 12, and 3 over 4 becomes 45 over 60 by multiplying by 15.',
   'With equal denominators, the larger numerator means the larger fraction. Among 40, 36 and 45 the largest is 45, so the largest fraction is 45 over 60 and its numerator is 45.'],
  ['分母がちがう分数はそのままくらべられないので、共通の分母に通分します。共通分母は 3、5、4 の最小公倍数をとります。',
   '3、5、4 はたがいに共通の約数をもたないので、最小公倍数は 3 × 5 × 4 = 60 です。',
   '分母を 60 にそろえます。3 分の 2 は分子分母を 20 倍して 60 分の 40、5 分の 3 は 12 倍して 60 分の 36、4 分の 3 は 15 倍して 60 分の 45 です。',
   '分母が同じなら分子が大きいほど分数も大きくなります。40、36、45 のうち最大は 45 なので、いちばん大きい分数は 60 分の 45 で分子は 45 です。']],
 '45',2,'Replaces one of a pair arranging digit cards into all two-digit numbers and summing them.')

for p, d in P.items():
    for q in d['questions']:
        assert len({len(v) for v in q['solutionSteps'].values()}) == 1, q['id']
        if q['answerMode'] == 'integer_input': assert 'options' not in q, q['id']
    with io.open(p,'w',encoding='utf-8') as f:
        json.dump(d,f,ensure_ascii=False,indent=2); f.write('\n')
print('\n寫回', len(P), '個 pack')
