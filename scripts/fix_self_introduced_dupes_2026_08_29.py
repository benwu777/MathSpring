# -*- coding: utf-8 -*-
"""修正我在上一批替換中自己造出的兩個新重複。

- geometry_grade4_043 我換成「鐘面 12 大格，時針 2 到 7 轉幾度」，
  卻和我同一輪加進 grade1 的 geometry_grade1_062「鐘面 12 大格，時針 3 到 6
  走幾大格」撞到 0.61——同一個佈景，只換問的量（大格數 vs 度數），
  正是紅線 1 明列的「只換求量位置」。
- arithmetic_grade6_023 我換成「1 到 200 中 6 和 8 的公倍數有幾個」，
  撞 grade5 既有的「1 到 40 中 3 和 4 的公倍數有幾個」0.63。
"""
import json, io
def L(zh, zhs, en, ja): return {'zh-Hant': zh, 'zh-Hans': zhs, 'en': en, 'ja': ja}
P = {}
def rep(path, qid, sub, prompt, answer, st, val, dig, why):
    if path not in P: P[path] = json.load(open(path))
    q = next(x for x in P[path]['questions'] if x['id'] == qid)
    q['subtopic'] = sub; q['prompt'] = prompt; q['answer'] = answer
    q['solutionSteps'] = {'zh-Hant': st[0], 'zh-Hans': st[1], 'en': st[2], 'ja': st[3]}
    assert len({len(v) for v in q['solutionSteps'].values()}) == 1, qid
    q['correctAnswer'] = {'type': 'integer', 'value': val}
    q['inputConstraints'] = {'allowNegative': False, 'maxDigits': dig}
    q['source']['notes'] = 'Second-pass replacement 2026-08-29: ' + why
    print('%-34s %-26s 答%s' % (qid[-34:], sub, val))

rep('assets/questions/geometry/grade4_foundation.geometry.v1.json',
 'geometry_grade4_foundation_043','segments_from_points_on_line',
 L('一條直線上依序標出 5 個不同的點。以其中任意兩個點當端點，一共可以畫出幾條不同的線段？',
   '一条直线上依序标出 5 个不同的点。以其中任意两个点当端点，一共可以画出几条不同的线段？',
   'Five different points are marked in order along a straight line. Taking any two of them as the endpoints, how many different line segments can be drawn?',
   '1 本の直線上に ことなる 5 つの点を順に印します。そのうち 2 点を端として線分をひくとき、ちがう線分は何本ひけますか。'),
 L('答案是 10 條。','答案是 10 条。','The answer is 10 segments.','答えは 10 本です。'),
 [['一條線段由兩個端點決定，所以問題等於「從 5 個點中挑出 2 個」有幾種挑法。',
   '先用有順序的方式數：第一個端點有 5 種選法，第二個端點不能和第一個相同，有 4 種，共 5 × 4 = 20 種。',
   '但線段沒有方向，「先選 A 再選 B」和「先選 B 再選 A」畫出來是同一條，所以每條線段都被算了 2 次。',
   '因此線段數是 20 ÷ 2 = 10 條。（也可以直接數：以最左邊的點為左端有 4 條，第二個點為左端有 3 條，接著 2 條、1 條，4 + 3 + 2 + 1 = 10。）'],
  ['一条线段由两个端点决定，所以问题等于「从 5 个点中挑出 2 个」有几种挑法。',
   '先用有顺序的方式数：第一个端点有 5 种选法，第二个端点不能和第一个相同，有 4 种，共 5 × 4 = 20 种。',
   '但线段没有方向，「先选 A 再选 B」和「先选 B 再选 A」画出来是同一条，所以每条线段都被算了 2 次。',
   '因此线段数是 20 ÷ 2 = 10 条。（也可以直接数：以最左边的点为左端有 4 条，第二个点为左端有 3 条，接着 2 条、1 条，4 + 3 + 2 + 1 = 10。）'],
  ['A segment is determined by its two endpoints, so the question is how many ways there are to pick 2 points out of 5.',
   'Count with order first: the first endpoint can be chosen in 5 ways and the second, which must differ, in 4 ways, giving 5 × 4 = 20.',
   'But a segment has no direction, so picking A then B draws the same segment as picking B then A, meaning every segment was counted twice.',
   'The number of segments is therefore 20 ÷ 2 = 10. Counting directly gives the same: 4 segments start at the leftmost point, 3 at the next, then 2 and 1, and 4 + 3 + 2 + 1 = 10.'],
  ['線分は 2 つの端点で決まるので、問題は「5 点から 2 点を選ぶ方法は何通りか」と同じです。',
   'まず順序をつけて数えます。1 つ目の端点は 5 通り、2 つ目はそれとちがうので 4 通りで、5 × 4 = 20 通りです。',
   'しかし線分に向きはなく、A を先に選んでも B を先に選んでも同じ線分なので、各線分を 2 回ずつ数えています。',
   'したがって線分は 20 ÷ 2 = 10 本です。直接数えても、いちばん左を左端とするものが 4 本、次が 3 本、続いて 2 本、1 本で 4 + 3 + 2 + 1 = 10 本です。']],
 '10',2,'the previous replacement duplicated geometry_grade1_foundation_062, sharing the clock-face setup and differing only in the quantity asked for.')

rep('assets/questions/arithmetic/grade6_foundation.arithmetic.v1.json',
 'arithmetic_grade6_foundation_023','opposite_direction_distance',
 L('甲、乙兩人從同一個地點同時出發，往相反的方向沿直線走。甲每分鐘走 60 公尺，乙每分鐘走 80 公尺。10 分鐘後，兩人相距幾公尺？',
   '甲、乙两人从同一个地点同时出发，往相反的方向沿直线走。甲每分钟走 60 米，乙每分钟走 80 米。10 分钟后，两人相距几米？',
   'A and B set off at the same time from the same spot, walking in opposite directions along a straight line. A walks 60 metres per minute and B walks 80 metres per minute. How far apart are they after 10 minutes?',
   '甲と乙が同じ地点から同時に出発し、直線上を反対向きに歩きます。甲は 1 分に 60 m、乙は 1 分に 80 m 進みます。10 分後、2 人は何 m はなれていますか。'),
 L('答案是 1400 公尺。','答案是 1400 米。','The answer is 1400 metres.','答えは 1400 m です。'),
 [['兩人往相反方向走，所以每過一分鐘，兩人之間的距離就會拉開「甲走的」加上「乙走的」。',
   '一分鐘內距離拉開 60 + 80 = 140 公尺。',
   '走了 10 分鐘，距離就拉開 140 × 10 = 1400 公尺。',
   '也可以分開算再相加：甲走了 60 × 10 = 600 公尺，乙走了 80 × 10 = 800 公尺，兩人分別在出發點的兩側，所以相距 600 + 800 = 1400 公尺。'],
  ['两人往相反方向走，所以每过一分钟，两人之间的距离就会拉开「甲走的」加上「乙走的」。',
   '一分钟内距离拉开 60 + 80 = 140 米。',
   '走了 10 分钟，距离就拉开 140 × 10 = 1400 米。',
   '也可以分开算再相加：甲走了 60 × 10 = 600 米，乙走了 80 × 10 = 800 米，两人分别在出发点的两侧，所以相距 600 + 800 = 1400 米。'],
  ['They walk in opposite directions, so every minute the gap between them grows by the distance A walks plus the distance B walks.',
   'In one minute the gap grows by 60 + 80 = 140 metres.',
   'Over 10 minutes it grows by 140 × 10 = 1400 metres.',
   'Working separately gives the same: A covers 60 × 10 = 600 metres and B covers 80 × 10 = 800 metres, and since they are on opposite sides of the starting point they are 600 + 800 = 1400 metres apart.'],
  ['2 人は反対向きに歩くので、1 分ごとに 2 人の間の距離は 甲が進んだ分と乙が進んだ分だけ広がります。',
   '1 分で 60 + 80 = 140 m 広がります。',
   '10 分では 140 × 10 = 1400 m 広がります。',
   '別々に求めても同じです。甲は 60 × 10 = 600 m、乙は 80 × 10 = 800 m 進み、出発点をはさんで反対側にいるので 600 + 800 = 1400 m はなれています。']],
 '1400',4,'the previous replacement duplicated a grade5 question counting common multiples in a range.')

for p, d in P.items():
    with io.open(p,'w',encoding='utf-8') as f:
        json.dump(d,f,ensure_ascii=False,indent=2); f.write('\n')
print('寫回', len(P), '個 pack')
