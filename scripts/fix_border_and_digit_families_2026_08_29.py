# -*- coding: utf-8 -*-
"""把新做的 scripts/question_template_scan.py 放寬門檻後找到的兩個家族修掉。

其中一題是我自己造出來的重複，值得記錄：
上一輪我把 arithmetic_grade2_022 換成「三角形外框，每邊 5 顆棋子，共幾顆」（答 12），
但 geometry_grade2_035 早就有「正三角形每邊排 5 顆棋子，角共用，共幾顆」（也是 12）——
數學完全相同。兩題正規化後的相似度只有 題幹 0.12 / 詳解 0.25，因為措辭差太多，
**連 question_template_scan.py 都抓不到**。這說明工具是第三道閘門而不是萬靈丹，
「同答案 + 同數學結構」這一類仍然只能靠人工複查或事後放寬門檻重掃。

另外兩個家族：
- 正方形邊框排棋子（geometry_grade2_014 / grade3_017），只換數字，換掉 g3_017。
- 數字卡排最大減最小（arithmetic_grade3_002 / grade4_063 / grade5_022），
  保留 grade5_022（五位偶數，限制條件真的不同），換掉前兩題。
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
    q['source']['notes'] = 'Replacement authored 2026-08-29 during the template scan. ' + why
    print('%-34s %-28s 答%-4s 原: %s…' % (qid[-34:], sub, val, old))

A2='assets/questions/arithmetic/grade2_foundation.arithmetic.v1.json'
A3='assets/questions/arithmetic/grade3_foundation.arithmetic.v1.json'
A4='assets/questions/arithmetic/grade4_foundation.arithmetic.v1.json'
G3='assets/questions/geometry/grade3_foundation.geometry.v1.json'

rep(A2,'arithmetic_grade2_foundation_022','queue_waiting_time',
 L('小明排隊買票，他前面還有 8 個人。每個人買票都要花 2 分鐘。從現在算起，再過幾分鐘才會輪到小明？',
   '小明排队买票，他前面还有 8 个人。每个人买票都要花 2 分钟。从现在算起，再过几分钟才会轮到小明？',
   'Ming is queuing for tickets with 8 people ahead of him. Each person takes 2 minutes to buy a ticket. How many minutes until it is Ming\'s turn?',
   '明はきっぷを買う列に並んでいて、前に 8 人います。1 人が買うのに 2 分かかります。明の番になるまで何分待ちますか。'),
 L('答案是 16 分鐘。','答案是 16 分钟。','The answer is 16 minutes.','答えは 16 分です。'),
 [['要輪到小明，前面那 8 個人必須先買完票，所以要算的是這 8 個人一共花多少時間。',
   '小明自己買票的 2 分鐘不算在內，因為題目問的是「還要等多久才輪到他」。',
   '8 個人，每個人 2 分鐘，總共是 8 × 2 = 16 分鐘。',
   '所以再過 16 分鐘就輪到小明。（如果算成 9 × 2 = 18，就是把小明自己也算進去了。）'],
  ['要轮到小明，前面那 8 个人必须先买完票，所以要算的是这 8 个人一共花多少时间。',
   '小明自己买票的 2 分钟不算在内，因为题目问的是「还要等多久才轮到他」。',
   '8 个人，每个人 2 分钟，总共是 8 × 2 = 16 分钟。',
   '所以再过 16 分钟就轮到小明。（如果算成 9 × 2 = 18，就是把小明自己也算进去了。）'],
  ['Ming\'s turn comes only after the 8 people ahead have bought their tickets, so the time to find is the total for those 8.',
   'Ming\'s own 2 minutes are not counted, because the question asks how long until his turn arrives.',
   'Eight people at 2 minutes each is 8 × 2 = 16 minutes.',
   'So his turn comes in 16 minutes. Working out 9 × 2 = 18 would wrongly include Ming himself.'],
  ['明の番になるのは前の 8 人が買い終わってからなので、その 8 人分の時間を求めます。',
   '明自身の 2 分は数えません。問われているのは「順番が来るまで」だからです。',
   '8 人がそれぞれ 2 分なので 8 × 2 = 16 分です。',
   'したがって 16 分後に明の番になります。9 × 2 = 18 とすると 明自身を数に入れてしまう誤りです。']],
 '16',2,'The previous replacement duplicated geometry_grade2_foundation_035: both counted counters round a triangle with 5 per side, answer 12, though the wording differed enough that even the normalised template scan scored them only 0.12 / 0.25.')

rep(G3,'geometry_grade3_foundation_017','square_side_doubled_area',
 L('一個正方形的邊長變成原來的 2 倍。新正方形的面積是原來那個正方形面積的幾倍？',
   '一个正方形的边长变成原来的 2 倍。新正方形的面积是原来那个正方形面积的几倍？',
   'The side of a square is made twice as long. The new square\'s area is how many times the original square\'s area?',
   '正方形の 1 辺を 2 倍にします。新しい正方形の面積は もとの正方形の面積の何倍ですか。'),
 L('答案是 4 倍。','答案是 4 倍。','The answer is 4.','答えは 4 倍です。'),
 [['正方形的面積是「邊長 × 邊長」，邊長在算式裡出現了兩次，這是關鍵。',
   '拿一個具體的數來看：原本邊長 3，面積是 3 × 3 = 9；邊長變成 6，面積是 6 × 6 = 36。36 是 9 的 4 倍。',
   '為什麼是 4 倍？因為算式裡兩個邊長都各變成 2 倍，所以面積變成 2 × 2 = 4 倍。',
   '換成別的邊長試也一樣，答案都是 4 倍。（常見的錯誤是答 2 倍——那是只看邊長，忘了面積是兩個邊長相乘。）'],
  ['正方形的面积是「边长 × 边长」，边长在算式里出现了两次，这是关键。',
   '拿一个具体的数来看：原本边长 3，面积是 3 × 3 = 9；边长变成 6，面积是 6 × 6 = 36。36 是 9 的 4 倍。',
   '为什么是 4 倍？因为算式里两个边长都各变成 2 倍，所以面积变成 2 × 2 = 4 倍。',
   '换成别的边长试也一样，答案都是 4 倍。（常见的错误是答 2 倍——那是只看边长，忘了面积是两个边长相乘。）'],
  ['A square\'s area is side times side, so the side appears twice in the calculation. That is the key.',
   'Try a concrete number: a side of 3 gives area 3 × 3 = 9, and a side of 6 gives area 6 × 6 = 36, which is 4 times 9.',
   'Why 4? Because both sides in the product are doubled, so the area becomes 2 × 2 = 4 times as large.',
   'Any other starting side gives the same answer of 4. Answering 2 is the common mistake: that looks only at the side and forgets that area multiplies two sides together.'],
  ['正方形の面積は「1 辺 × 1 辺」で、1 辺が式の中に 2 回出てくる点がかぎです。',
   '具体的な数で見ます。1 辺 3 なら面積は 3 × 3 = 9、1 辺 6 なら 6 × 6 = 36 で、36 は 9 の 4 倍です。',
   'なぜ 4 倍かというと、式の中の 2 つの 1 辺がどちらも 2 倍になるので、面積は 2 × 2 = 4 倍になるからです。',
   '別の 1 辺で試しても同じく 4 倍です。2 倍と答えるのがよくある誤りで、面積が 1 辺 2 つのかけ算であることを忘れています。']],
 '4',1,'Replaces one of a pair counting counters round a square border, differing only in the numbers.')

rep(A3,'arithmetic_grade3_foundation_002','balance_both_sides',
 L('一個數加上 27 之後，剛好等於 63 減去 9 的結果。這個數是多少？',
   '一个数加上 27 之后，刚好等于 63 减去 9 的结果。这个数是多少？',
   'Adding 27 to a number gives exactly the same result as 63 minus 9. What is the number?',
   'ある数に 27 を足すと、63 − 9 の結果とちょうど等しくなります。もとの数はいくつですか。'),
 L('答案是 27。','答案是 27。','The answer is 27.','答えは 27 です。'),
 [['等號兩邊要一樣大。右邊是可以直接算出來的，先把它算完再處理左邊。',
   '右邊：63 − 9 = 54。',
   '所以左邊也要等於 54，也就是「這個數 + 27 = 54」。',
   '要求這個數，把 27 減掉：54 − 27 = 27。驗算：27 + 27 = 54，和 63 − 9 相等，正確。'],
  ['等号两边要一样大。右边是可以直接算出来的，先把它算完再处理左边。',
   '右边：63 − 9 = 54。',
   '所以左边也要等于 54，也就是「这个数 + 27 = 54」。',
   '要求这个数，把 27 减掉：54 − 27 = 27。验算：27 + 27 = 54，和 63 − 9 相等，正确。'],
  ['Both sides of the equals sign must come to the same value. The right side can be worked out straight away, so do that first.',
   'The right side is 63 − 9 = 54.',
   'So the left side must also be 54, that is, the number plus 27 equals 54.',
   'To find the number, take away the 27: 54 − 27 = 27. Check: 27 + 27 = 54, which matches 63 − 9.'],
  ['等号の両側は同じ大きさでなければなりません。右辺はすぐ計算できるので先に求めます。',
   '右辺は 63 − 9 = 54 です。',
   'したがって左辺も 54 でなければならず、「もとの数 + 27 = 54」となります。',
   'もとの数を求めるには 27 を引いて 54 − 27 = 27 です。確かめると 27 + 27 = 54 で 63 − 9 と等しく、正しいです。']],
 '27',2,'Replaces one of three questions arranging digit cards into the largest and smallest numbers and subtracting.')

rep(A4,'arithmetic_grade4_foundation_063','number_from_quotient_remainder',
 L('一個整數除以 6，商是 7、餘數是 4。這個整數是多少？',
   '一个整数除以 6，商是 7、余数是 4。这个整数是多少？',
   'An integer divided by 6 gives a quotient of 7 and a remainder of 4. What is the integer?',
   'ある整数を 6 でわると、商が 7、あまりが 4 になります。この整数はいくつですか。'),
 L('答案是 46。','答案是 46。','The answer is 46.','答えは 46 です。'),
 [['除法有一個固定的關係：被除數 = 除數 × 商 + 餘數。這題就是把已知的三個數代進去。',
   '除數是 6、商是 7，所以先算 6 × 7 = 42。',
   '再加上餘數 4：42 + 4 = 46。',
   '驗算：46 ÷ 6 = 7 餘 4，符合題目。（餘數 4 小於除數 6，這也是合理的——餘數一定要比除數小，否則商還可以再大一點。）'],
  ['除法有一个固定的关系：被除数 = 除数 × 商 + 余数。这题就是把已知的三个数代进去。',
   '除数是 6、商是 7，所以先算 6 × 7 = 42。',
   '再加上余数 4：42 + 4 = 46。',
   '验算：46 ÷ 6 = 7 余 4，符合题目。（余数 4 小于除数 6，这也是合理的——余数一定要比除数小，否则商还可以再大一点。）'],
  ['Division obeys a fixed relation: dividend = divisor × quotient + remainder. Here the three known values are substituted in.',
   'The divisor is 6 and the quotient is 7, so first compute 6 × 7 = 42.',
   'Then add the remainder 4: 42 + 4 = 46.',
   'Check: 46 ÷ 6 is 7 remainder 4, as required. Note that the remainder 4 is smaller than the divisor 6, as it must be; otherwise the quotient could have been larger.'],
  ['わり算には決まった関係があります。わられる数 = わる数 × 商 + あまり です。ここに与えられた 3 つの値を入れます。',
   'わる数は 6、商は 7 なので、まず 6 × 7 = 42 です。',
   'そこにあまりの 4 を足して 42 + 4 = 46 です。',
   '確かめると 46 ÷ 6 = 7 あまり 4 で条件に合います。あまり 4 はわる数 6 より小さく、これは必要な条件です。そうでなければ商をもっと大きくできるからです。']],
 '46',2,'Replaces one of three questions arranging digit cards into the largest and smallest numbers and subtracting.')

for p, d in P.items():
    for q in d['questions']:
        assert len({len(v) for v in q['solutionSteps'].values()}) == 1, q['id']
        if q['answerMode'] == 'integer_input': assert 'options' not in q, q['id']
    with io.open(p,'w',encoding='utf-8') as f:
        json.dump(d,f,ensure_ascii=False,indent=2); f.write('\n')
print('\n寫回', len(P), '個 pack')
