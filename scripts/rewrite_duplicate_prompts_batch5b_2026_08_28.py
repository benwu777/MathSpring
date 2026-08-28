#!/usr/bin/env python3
"""去重改寫第五批之二：grade7-12 剩下的八題。

這批是純數學題，沒有故事可以換，共用的正是數學鋪陳本身。
改的是敘述框架與符號：換頂點字母、換載體（繩子→香、蝸牛→毛毛蟲）、
把抽象問句包成房號、卡片、摺扇等具體情境。推理與答案完全不動。
"""
import glob, io, json, sys

def L(zh, zhs, en, ja):
    return {'zh-Hant': zh, 'zh-Hans': zhs, 'en': en, 'ja': ja}

R = {}

R['geometry_grade12_foundation_032'] = dict(
    prompt=L('一個圓內接四邊形的四個頂點依序記為 P、Q、R、S，四邊長依序是 PQ = 3、QR = 4、RS = 5、SP = 6。兩條對角線 PR 與 QS 的長度比可以寫成最簡整數比 m : n。求 m + n 的值。',
             '一个圆内接四边形的四个顶点依序记为 P、Q、R、S，四边长依序是 PQ = 3、QR = 4、RS = 5、SP = 6。两条对角线 PR 与 QS 的长度比可以写成最简整数比 m : n。求 m + n 的值。',
             'A cyclic quadrilateral has its vertices labelled P, Q, R, S in order, with side lengths PQ = 3, QR = 4, RS = 5 and SP = 6. The ratio of the diagonals PR to QS can be written as m : n in lowest terms. Find m + n.',
             '円に内接する四角形の頂点を順に P、Q、R、S とし、辺の長さは PQ = 3、QR = 4、RS = 5、SP = 6 です。対角線 PR と QS の長さの比を、これ以上約分できない整数比 m : n で表すとき、m + n を求めなさい。'),
    answer=L('答案是 40。', '答案是 40。', 'The answer is 40.', '答えは 40 です。'),
    steps=L(['圓內接四邊形的對角線長度比有一個現成的關係式：PR : QS =（PQ × PS + RQ × RS）:（QP × QR + SP × SR）。',
             '分子代入：3 × 6 + 4 × 5 = 18 + 20 = 38。',
             '分母代入：3 × 4 + 6 × 5 = 12 + 30 = 42。',
             '所以 PR : QS = 38 : 42，兩邊同除以 2 得最簡比 19 : 21。',
             '因此 m = 19、n = 21，m + n = 40。'],
            ['圆内接四边形的对角线长度比有一个现成的关系式：PR : QS =（PQ × PS + RQ × RS）:（QP × QR + SP × SR）。',
             '分子代入：3 × 6 + 4 × 5 = 18 + 20 = 38。',
             '分母代入：3 × 4 + 6 × 5 = 12 + 30 = 42。',
             '所以 PR : QS = 38 : 42，两边同除以 2 得最简比 19 : 21。',
             '因此 m = 19、n = 21，m + n = 40。'],
            ['For a cyclic quadrilateral the diagonals satisfy the ready-made relation PR : QS = (PQ × PS + RQ × RS) : (QP × QR + SP × SR).',
             'The first part is 3 × 6 + 4 × 5 = 18 + 20 = 38.',
             'The second part is 3 × 4 + 6 × 5 = 12 + 30 = 42.',
             'So PR : QS = 38 : 42, and dividing both by 2 gives the lowest terms 19 : 21.',
             'Hence m = 19 and n = 21, so m + n = 40.'],
            ['円に内接する四角形では、対角線について PR : QS =（PQ × PS + RQ × RS）:（QP × QR + SP × SR）という関係が成り立ちます。',
             '前半は 3 × 6 + 4 × 5 = 18 + 20 = 38 です。',
             '後半は 3 × 4 + 6 × 5 = 12 + 30 = 42 です。',
             'したがって PR : QS = 38 : 42 で、両方を 2 でわると最簡の比 19 : 21 になります。',
             'よって m = 19、n = 21 なので m + n = 40 です。']))

R['algebra_grade9_foundation_031'] = dict(
    prompt=L('一個二次方程式可以寫成 x² − 7x + q = 0。已知它的兩個根相差 5，求 q 的值。',
             '一个二次方程式可以写成 x² − 7x + q = 0。已知它的两个根相差 5，求 q 的值。',
             'A quadratic equation can be written as x² − 7x + q = 0. Its two roots differ by 5. Find q.',
             '2 次方程式が x² − 7x + q = 0 と書けます。2 つの解の差が 5 であるとき、q を求めなさい。'),
    answer=L('答案是 6。', '答案是 6。', 'The answer is 6.', '答えは 6 です。'),
    steps=L(['由根與係數的關係，兩根之和等於 7。',
             '題目又說兩根之差是 5。',
             '和是 7、差是 5，把 7 減去 5 得 2，再除以 2 得 1，所以較小的根是 1。',
             '較大的根是 1 + 5 = 6，兩根是 1 和 6。',
             'q 等於兩根的乘積，也就是 1 × 6 = 6。'],
            ['由根与系数的关系，两根之和等于 7。',
             '题目又说两根之差是 5。',
             '和是 7、差是 5，把 7 减去 5 得 2，再除以 2 得 1，所以较小的根是 1。',
             '较大的根是 1 + 5 = 6，两根是 1 和 6。',
             'q 等于两根的乘积，也就是 1 × 6 = 6。'],
            ['By the relation between roots and coefficients, the two roots add up to 7.',
             'The question also says the roots differ by 5.',
             'From a sum of 7 and a difference of 5: subtract 5 from 7 to get 2, then halve it to get 1, so the smaller root is 1.',
             'The larger root is 1 + 5 = 6, so the roots are 1 and 6.',
             'q equals the product of the roots, that is 1 × 6 = 6.'],
            ['解と係数の関係より、2 つの解の和は 7 です。',
             '問題より、2 つの解の差は 5 です。',
             '和が 7、差が 5 なので、7 から 5 を引いて 2、それを 2 でわって 1。つまり小さいほうの解は 1 です。',
             '大きいほうの解は 1 + 5 = 6 なので、解は 1 と 6 です。',
             'q は 2 つの解の積なので、1 × 6 = 6 です。']))

R['number_theory_grade9_foundation_032'] = dict(
    prompt=L('一家旅館的房間從 1 號編到 1000 號。房號裡數字 7 恰好出現一次的房間共有幾間？',
             '一家旅馆的房间从 1 号编到 1000 号。房号里数字 7 恰好出现一次的房间共有几间？',
             'A hotel numbers its rooms from 1 to 1000. In how many of those room numbers does the digit 7 appear exactly once?',
             'あるホテルの部屋は 1 号室から 1000 号室まで番号がついています。部屋番号に数字の 7 がちょうど 1 回だけ出てくる部屋は何室ありますか。'),
    answer=L('答案是 243 間。', '答案是 243 间。', 'The answer is 243.', '答えは 243 室です。'),
    steps=L(['1000 號本身沒有 7，所以只要看 1 到 999 號。',
             '把 1 到 999 都補成三位數（例如 5 寫成 005、48 寫成 048），這樣不影響數字 7 出現的次數。',
             '要讓 7 恰好出現一次，先選 7 放在哪一位，有 3 種選法。',
             '另外兩位都不能是 7，各有 0 到 9 扣掉 7 共 9 種選擇。',
             '所以是 3 × 9 × 9 = 243 間。'],
            ['1000 号本身没有 7，所以只要看 1 到 999 号。',
             '把 1 到 999 都补成三位数（例如 5 写成 005、48 写成 048），这样不影响数字 7 出现的次数。',
             '要让 7 恰好出现一次，先选 7 放在哪一位，有 3 种选法。',
             '另外两位都不能是 7，各有 0 到 9 扣掉 7 共 9 种选择。',
             '所以是 3 × 9 × 9 = 243 间。'],
            ['Room 1000 contains no 7, so only rooms 1 to 999 matter.',
             'Write every number from 1 to 999 with three digits, padding with zeros, for example 5 as 005 and 48 as 048; this does not change how often the digit 7 appears.',
             'For 7 to appear exactly once, first choose which of the three places holds it, giving 3 choices.',
             'Neither of the other two places may be 7, so each has 9 choices out of the digits 0 to 9.',
             'That gives 3 × 9 × 9 = 243 rooms.'],
            ['1000 号室には 7 がないので、1 号室から 999 号室だけを考えます。',
             '1 から 999 までを 0 でうめて 3 けたに書きます（たとえば 5 は 005、48 は 048）。こうしても 7 の出る回数は変わりません。',
             '7 がちょうど 1 回出るには、まず 7 を置く位を選びます。3 通りです。',
             '残りの 2 つの位はどちらも 7 であってはいけないので、0 から 9 のうち 7 を除いた 9 通りずつです。',
             'したがって 3 × 9 × 9 = 243 室です。']))

R['logic_grade11_foundation_031'] = dict(
    prompt=L('有兩支粗細不均的香，每一支從一端點燃燒到另一端恰好需要 60 分鐘，但因為粗細不均，燒到中點所花的時間不一定是 30 分鐘。現在只有打火機，而且規定總共最多只能點火 3 次（每次點燃某一支香的某一個端點）。在這個限制下，能夠準確量出的最短時間是幾分鐘？',
             '有两支粗细不均的香，每一支从一端点燃烧到另一端恰好需要 60 分钟，但因为粗细不均，烧到中点所花的时间不一定是 30 分钟。现在只有打火机，而且规定总共最多只能点火 3 次（每次点燃某一支香的某一个端点）。在这个限制下，能够准确量出的最短时间是几分钟？',
             'Two sticks of incense burn unevenly. Each takes exactly 60 minutes to burn from one end to the other, but because the thickness varies, reaching the midpoint need not take 30 minutes. Only a lighter is available, and at most 3 lightings may be made in total, each lighting one end of one stick. Under that restriction, what is the shortest length of time that can be measured exactly, in minutes?',
             '太さが一定でないお香が 2 本あります。どちらも一方のはしから他方のはしまで燃えるのにちょうど 60 分かかりますが、太さがちがうため中央まで燃えるのが 30 分とはかぎりません。ライターしかなく、火をつけられるのは全部で 3 回まで（1 回につきどれか 1 本の一方のはしに火をつける）とします。この条件のもとで正確にはかれる最短の時間は何分ですか。'),
    answer=L('答案是 30 分鐘。', '答案是 30 分钟。', 'The answer is 30 minutes.', '答えは 30 分です。'),
    steps=L(['一開始同時做兩件事：把第一支香的兩端都點燃（用掉 2 次），同時把第二支香的一端點燃（用掉第 3 次）。',
             '第一支從兩端一起燒，不論粗細怎麼分布，燒完的總量還是整支，所以恰好 30 分鐘後燒完。',
             '這 30 分鐘就已經量出來了，而且三次點火剛好用完。',
             '要量出比 30 分鐘更短的時間，必須在中途再點一次火，但點火次數已經用完，做不到。',
             '所以在最多點火 3 次的限制下，能準確量出的最短時間是 30 分鐘。'],
            ['一开始同时做两件事：把第一支香的两端都点燃（用掉 2 次），同时把第二支香的一端点燃（用掉第 3 次）。',
             '第一支从两端一起烧，不论粗细怎么分布，烧完的总量还是整支，所以恰好 30 分钟后烧完。',
             '这 30 分钟就已经量出来了，而且三次点火刚好用完。',
             '要量出比 30 分钟更短的时间，必须在中途再点一次火，但点火次数已经用完，做不到。',
             '所以在最多点火 3 次的限制下，能准确量出的最短时间是 30 分钟。'],
            ['Start by doing two things at once: light both ends of the first stick, using 2 lightings, and at the same moment light one end of the second stick, using the third.',
             'The first stick burns from both ends, and however the thickness is distributed the two flames still consume the whole stick, so it finishes after exactly 30 minutes.',
             'That 30-minute interval is already measured, and all three lightings have been used.',
             'Measuring anything shorter than 30 minutes would need another lighting partway through, but no lightings remain.',
             'So with at most 3 lightings the shortest time that can be measured exactly is 30 minutes.'],
            ['はじめに 2 つのことを同時に行います。1 本目の両はしに火をつけ（2 回使用）、同時に 2 本目の一方のはしにも火をつけます（3 回目）。',
             '1 本目は両はしから燃えるので、太さの分布がどうであれ 2 つの炎が 1 本分を燃やしきり、ちょうど 30 分で燃え終わります。',
             'この 30 分がすでにはかれており、火をつける 3 回はすべて使い切っています。',
             '30 分より短い時間をはかるには途中でもう一度火をつける必要がありますが、回数が残っていません。',
             'したがって 3 回までという条件のもとで正確にはかれる最短の時間は 30 分です。']))

R['logic_grade9_foundation_031'] = dict(
    prompt=L('一群小朋友圍成一圈玩淘汰遊戲，依順時針方向編號。從 1 號開始報數，每次報到「2」的人立刻出局，接著由下一個人重新從「1」開始報數，一直進行到只剩一個人。已知最後留下的是 1 號，而且人數介於 10 到 20 之間。這一圈原本有幾個人？',
             '一群小朋友围成一圈玩淘汰游戏，依顺时针方向编号。从 1 号开始报数，每次报到「2」的人立刻出局，接着由下一个人重新从「1」开始报数，一直进行到只剩一个人。已知最后留下的是 1 号，而且人数介于 10 到 20 之间。这一圈原本有几个人？',
             'A group of children stand in a circle playing an elimination game, numbered clockwise. Counting starts at child 1, and whoever says "2" leaves at once; the next child then starts counting again from "1", and this continues until one child remains. The last child remaining is number 1, and the group size is between 10 and 20. How many children were in the circle?',
             '子どもたちが輪になって勝ちぬきゲームをします。時計まわりに番号がついていて、1 番から数え始め、「2」と言った人はすぐに輪から出ます。次の人がまた「1」から数え直し、1 人になるまで続けます。最後に残ったのが 1 番で、人数は 10 人から 20 人のあいだであるとき、輪には何人いましたか。'),
    answer=L('答案是 16 人。', '答案是 16 人。', 'The answer is 16.', '答えは 16 人です。'),
    steps=L(['先看人數是 2 的情形：1 號先報「1」，2 號報「2」出局，剩下 1 號。所以 2 人時 1 號會留下。',
             '若人數是偶數，第一輪剛好把所有偶數號全部淘汰，而且淘汰完後又輪回 1 號開始報數。',
             '這時剩下的是原本的奇數號，人數減半，而且 1 號仍在「重新開始」的位置上。',
             '因此只要人數能一直被 2 整除到剩下 1 個人，1 號就會活到最後，也就是人數必須是 2 的次方。',
             '10 到 20 之間的 2 的次方只有 16，所以原本有 16 人。'],
            ['先看人数是 2 的情形：1 号先报「1」，2 号报「2」出局，剩下 1 号。所以 2 人时 1 号会留下。',
             '若人数是偶数，第一轮刚好把所有偶数号全部淘汰，而且淘汰完后又轮回 1 号开始报数。',
             '这时剩下的是原本的奇数号，人数减半，而且 1 号仍在「重新开始」的位置上。',
             '因此只要人数能一直被 2 整除到剩下 1 个人，1 号就会活到最后，也就是人数必须是 2 的次方。',
             '10 到 20 之间的 2 的次方只有 16，所以原本有 16 人。'],
            ['Start with 2 children: child 1 says "1", child 2 says "2" and leaves, so child 1 survives. With 2 children, number 1 wins.',
             'If the group size is even, the first round removes exactly all the even-numbered children, and after the last removal the count comes back round to child 1.',
             'What remains is the original odd-numbered children, half as many, with child 1 again in the position that starts the count.',
             'So as long as the size can be halved again and again down to a single child, number 1 survives; that means the size must be a power of 2.',
             'The only power of 2 between 10 and 20 is 16, so there were 16 children.'],
            ['まず 2 人の場合を見ます。1 番が「1」、2 番が「2」と言って出るので、1 番が残ります。2 人なら 1 番が勝ちます。',
             '人数が偶数なら、1 周目でちょうど偶数番の人が全員いなくなり、最後の 1 人が出たあと、また 1 番から数え直しになります。',
             '残るのはもとの奇数番の人で人数は半分になり、1 番はふたたび数え始める位置にいます。',
             'したがって人数を 2 でわり続けて 1 人になれば 1 番が最後まで残ります。つまり人数は 2 のべき乗でなければなりません。',
             '10 と 20 のあいだの 2 のべき乗は 16 だけなので、はじめは 16 人でした。']))

R['logic_grade7_foundation_032'] = dict(
    prompt=L('一隻毛毛蟲要爬上一根直立的竹竿。牠白天可以往上爬 4 公尺，夜裡會滑下 3 公尺。牠從第 1 天的白天開始爬，剛好在第 12 天的白天爬到竿頂。已知竹竿的高度是整數公尺，求竹竿有幾公尺高。',
             '一只毛毛虫要爬上一根直立的竹竿。它白天可以往上爬 4 米，夜里会滑下 3 米。它从第 1 天的白天开始爬，刚好在第 12 天的白天爬到竿顶。已知竹竿的高度是整数米，求竹竿有几米高。',
             'A caterpillar climbs an upright bamboo pole. During the day it climbs 4 metres up, and at night it slips 3 metres down. It starts climbing on the morning of day 1 and reaches the top during the day on day 12. The pole is a whole number of metres tall. How tall is it?',
             'いもむしがまっすぐ立った竹ざおを登ります。昼のあいだに 4 m 登り、夜のあいだに 3 m すべり落ちます。1 日目の昼に登り始め、ちょうど 12 日目の昼に てっぺんに着きました。竹ざおの高さは整数 m です。高さは何 m ですか。'),
    answer=L('答案是 15 公尺。', '答案是 15 米。', 'The answer is 15 metres.', '答えは 15 m です。'),
    steps=L(['每過一個白天加一個夜晚，毛毛蟲淨上升 4 − 3 = 1 公尺。',
             '所以第 d 天白天結束時，牠所在的高度是（d − 1）× 1 + 4 = d + 3 公尺（前面 d − 1 個完整日夜各上升 1 公尺，最後一個白天再爬 4 公尺）。',
             '牠在第 12 天的白天爬到頂，表示第 12 天白天結束時已經到頂：12 + 3 = 15 ≥ 竿高。',
             '同時第 11 天白天結束時還沒到頂：11 + 3 = 14 < 竿高。',
             '所以竿高大於 14、不超過 15，又是整數，因此是 15 公尺。'],
            ['每过一个白天加一个夜晚，毛毛虫净上升 4 − 3 = 1 米。',
             '所以第 d 天白天结束时，它所在的高度是（d − 1）× 1 + 4 = d + 3 米（前面 d − 1 个完整日夜各上升 1 米，最后一个白天再爬 4 米）。',
             '它在第 12 天的白天爬到顶，表示第 12 天白天结束时已经到顶：12 + 3 = 15 ≥ 竿高。',
             '同时第 11 天白天结束时还没到顶：11 + 3 = 14 < 竿高。',
             '所以竿高大于 14、不超过 15，又是整数，因此是 15 米。'],
            ['Each full day and night together move the caterpillar 4 − 3 = 1 metre up.',
             'So at the end of the daytime on day d it is at (d − 1) × 1 + 4 = d + 3 metres: the first d − 1 complete cycles give 1 metre each, and the last daytime adds 4.',
             'Reaching the top during day 12 means it is at or above the top by the end of that daytime: 12 + 3 = 15 ≥ the height.',
             'It had not reached the top by the end of day 11: 11 + 3 = 14 < the height.',
             'So the height is more than 14 and at most 15, and being a whole number it is 15 metres.'],
            ['昼と夜が 1 回ずつ過ぎるごとに、いもむしは 4 − 3 = 1 m 分だけ上に進みます。',
             'したがって d 日目の昼が終わった時点の高さは（d − 1）× 1 + 4 = d + 3 m です。最初の d − 1 回の昼夜で 1 m ずつ、最後の昼で 4 m 登るからです。',
             '12 日目の昼に てっぺんに着いたので、その昼の終わりには 12 + 3 = 15 ≥ 高さ です。',
             '一方 11 日目の昼の終わりにはまだ着いていないので、11 + 3 = 14 < 高さ です。',
             'よって高さは 14 より大きく 15 以下で、整数なので 15 m です。']))

R['geometry_grade10_foundation_032'] = dict(
    prompt=L('一把摺扇完全張開時，扇面剛好是一個圓心角 60° 的扇形，兩根最外側的扇骨長度都是 r 公分。把兩根外側扇骨的頂端用一條直線連起來，會圍出一個三角形，這個三角形的面積是 9√3 平方公分。求 r 的值。',
             '一把折扇完全张开时，扇面刚好是一个圆心角 60° 的扇形，两根最外侧的扇骨长度都是 r 厘米。把两根外侧扇骨的顶端用一条直线连起来，会围出一个三角形，这个三角形的面积是 9√3 平方厘米。求 r 的值。',
             'When a folding fan is fully opened, its face is exactly a sector with central angle 60°, and the two outermost ribs each have length r centimetres. Joining the tips of those two ribs with a straight line encloses a triangle of area 9√3 square centimetres. Find r.',
             '扇子を完全に開くと、扇面はちょうど中心角 60° のおうぎ形になり、いちばん外側の 2 本の骨の長さはどちらも r cm です。この 2 本の骨の先を直線で結ぶと三角形ができ、その面積は 9√3 平方 cm です。r を求めなさい。'),
    answer=L('答案是 6。', '答案是 6。', 'The answer is 6.', '答えは 6 です。'),
    steps=L(['三角形的兩邊就是兩根外側扇骨，長度都是 r，夾角是 60°。',
             '兩邊夾一角的三角形面積等於（1/2）× 邊 × 邊 × 夾角的正弦值。',
             'sin 60° = √3 / 2，所以面積 =（1/2）× r × r ×（√3 / 2）=（√3 / 4）× r × r。',
             '令（√3 / 4）× r × r = 9√3，兩邊同除以 √3 再乘以 4，得到 r × r = 36。',
             '長度為正，所以 r = 6。'],
            ['三角形的两边就是两根外侧扇骨，长度都是 r，夹角是 60°。',
             '两边夹一角的三角形面积等于（1/2）× 边 × 边 × 夹角的正弦值。',
             'sin 60° = √3 / 2，所以面积 =（1/2）× r × r ×（√3 / 2）=（√3 / 4）× r × r。',
             '令（√3 / 4）× r × r = 9√3，两边同除以 √3 再乘以 4，得到 r × r = 36。',
             '长度为正，所以 r = 6。'],
            ['Two sides of the triangle are the outer ribs, both of length r, with a 60° angle between them.',
             'The area of a triangle from two sides and their included angle is (1/2) × side × side × the sine of the angle.',
             'sin 60° = √3 / 2, so the area is (1/2) × r × r × (√3 / 2) = (√3 / 4) × r × r.',
             'Setting (√3 / 4) × r × r = 9√3, dividing both sides by √3 and multiplying by 4 gives r × r = 36.',
             'A length is positive, so r = 6.'],
            ['三角形の 2 辺は外側の骨で、長さはどちらも r、そのあいだの角は 60° です。',
             '2 辺とそのあいだの角から三角形の面積は（1/2）× 辺 × 辺 × その角のサインで求められます。',
             'sin 60° = √3 / 2 なので、面積は（1/2）× r × r ×（√3 / 2）=（√3 / 4）× r × r です。',
             '（√3 / 4）× r × r = 9√3 とおき、両辺を √3 でわって 4 をかけると r × r = 36 になります。',
             '長さは正なので r = 6 です。']))

R['number_theory_grade10_foundation_032'] = dict(
    prompt=L('有編號 1 到 100 的一百張卡片。若某張卡片的號碼能被 4、9、16、25、⋯ 這些大於 1 的完全平方數其中任何一個整除，就在卡片上蓋一個章。要蓋章的卡片共有幾張？',
             '有编号 1 到 100 的一百张卡片。若某张卡片的号码能被 4、9、16、25、⋯ 这些大于 1 的完全平方数其中任何一个整除，就在卡片上盖一个章。要盖章的卡片共有几张？',
             'There are one hundred cards numbered 1 to 100. A card is stamped if its number is divisible by any of the perfect squares greater than 1, that is by 4, 9, 16, 25, and so on. How many cards get stamped?',
             '1 番から 100 番までのカードが 100 まいあります。カードの番号が 4、9、16、25、⋯ のような 1 より大きい平方数のどれかで割り切れるとき、そのカードにはんこを押します。はんこを押すカードは何まいありますか。'),
    answer=L('答案是 39 張。', '答案是 39 张。', 'The answer is 39.', '答えは 39 まいです。'),
    steps=L(['一個數若能被某個大於 1 的完全平方數整除，就一定能被某個質數的平方整除，所以只要檢查 4、9、25、49（100 以內只有這些質數平方會有倍數）。',
             '4 的倍數有 25 張，9 的倍數有 11 張，25 的倍數有 4 張，49 的倍數有 2 張。',
             '有些卡片被重複算到：同時是 4 和 9 的倍數就是 36 的倍數，有 2 張；同時是 4 和 25 的倍數就是 100 的倍數，有 1 張。',
             '其餘的組合（例如 4 和 49、9 和 25）最小公倍數都超過 100，不會有卡片。',
             '所以蓋章的卡片是 25 + 11 + 4 + 2 − 2 − 1 = 39 張。'],
            ['一个数若能被某个大于 1 的完全平方数整除，就一定能被某个质数的平方整除，所以只要检查 4、9、25、49（100 以内只有这些质数平方会有倍数）。',
             '4 的倍数有 25 张，9 的倍数有 11 张，25 的倍数有 4 张，49 的倍数有 2 张。',
             '有些卡片被重复算到：同时是 4 和 9 的倍数就是 36 的倍数，有 2 张；同时是 4 和 25 的倍数就是 100 的倍数，有 1 张。',
             '其余的组合（例如 4 和 49、9 和 25）最小公倍数都超过 100，不会有卡片。',
             '所以盖章的卡片是 25 + 11 + 4 + 2 − 2 − 1 = 39 张。'],
            ['If a number is divisible by some perfect square greater than 1, it is divisible by the square of some prime, so only 4, 9, 25 and 49 need checking, since no larger prime square has a multiple within 100.',
             'Multiples of 4 give 25 cards, multiples of 9 give 11, multiples of 25 give 4 and multiples of 49 give 2.',
             'Some cards are counted twice: a multiple of both 4 and 9 is a multiple of 36, which happens 2 times, and a multiple of both 4 and 25 is a multiple of 100, which happens once.',
             'Every other combination, such as 4 with 49 or 9 with 25, has a least common multiple above 100 and so contributes nothing.',
             'The stamped cards therefore number 25 + 11 + 4 + 2 − 2 − 1 = 39.'],
            ['1 より大きい平方数で割り切れる数は、必ずどれかの素数の 2 乗で割り切れます。100 以下で倍数をもつ素数の 2 乗は 4、9、25、49 だけなので、これらを調べれば十分です。',
             '4 の倍数は 25 まい、9 の倍数は 11 まい、25 の倍数は 4 まい、49 の倍数は 2 まいです。',
             '重ねて数えているカードがあります。4 と 9 の両方の倍数は 36 の倍数で 2 まい、4 と 25 の両方の倍数は 100 の倍数で 1 まいです。',
             'ほかの組み合わせ（4 と 49、9 と 25 など）は最小公倍数が 100 をこえるのでありません。',
             'したがってはんこを押すカードは 25 + 11 + 4 + 2 − 2 − 1 = 39 まいです。']))

NOTE = ('Rewritten 2026-08-28. This was one of the grade 7-12 same-setting pairs the user had '
        'decided to keep; with the policy now being rewrite rather than delete, the shared setup '
        'wording was re-framed. The mathematics, reasoning and answer are unchanged.')

changed = 0
for path in sorted(glob.glob('assets/questions/*/*.json')):
    if path.endswith('manifest.json'):
        continue
    pack = json.load(open(path))
    dirty = False
    for q in pack['questions']:
        spec = R.get(q['id'])
        if not spec:
            continue
        q['prompt'] = spec['prompt']
        q['answer'] = spec['answer']
        q['solutionSteps'] = spec['steps']
        q['source'] = dict(q['source'], notes=NOTE)
        assert len({len(v) for v in spec['steps'].values()}) == 1, q['id']
        dirty = True
        changed += 1
        print('改寫 %-42s -> %s' % (q['id'], q['correctAnswer']['value']))
    if dirty:
        io.open(path, 'w', encoding='utf-8').write(
            json.dumps(pack, ensure_ascii=False, indent=2) + '\n')
if changed != len(R):
    sys.exit('預期 %d 題，實際 %d 題' % (len(R), changed))
print('共改寫 %d 題' % changed)
