# -*- coding: utf-8 -*-
"""審核從 kangaroo56 舊題包遷移進 grade6 mixed 的 29 題。

這 29 題全部標著 reviewStatus: ok，但從未和主庫 2400 題比對過，也沒有逐題驗算。
審核結果：8 題重複、2 題本身有錯。

重複（8 題，全部換成新題）：
  017 瓶子容量        0.73 撞 mixed_grade5_004（同樣的「倒出 N 毫升後變成 X 滿」）
  018 格點路徑經檢查點  撞 combinatorics_grade8_035，連「4 右 3 上、必經 P」和答案 18 都一樣
  022 同餘最小        0.65 撞同 pack 的 mixed_grade6_003
  024 蝸牛爬牆        撞 logic_grade7_026 蝸牛爬井、logic_grade7_032 毛毛蟲爬竿（庫裡已有兩題）
  031 三數平均        0.48 撞 arithmetic_grade6_028
  033 三連續整數乘積   0.68 撞 mixed_grade5_014（三連續整數的和）
  040 座標三角形面積   撞同 pack 的 mixed_grade6_011，連子分類名和答案 12 都一樣
  042 四色襪子抽屜     撞 logic_grade9_005（同樣四色襪子）等四題抽屜題

本身有錯（2 題，就地修正）：
  019 答案錯：3、6、9、12、15… 連成串的第 12 個數字是 24 的十位「2」，不是個位「4」。
      原詳解把「兩位數區段的第 9 個位置」誤當成第 5 個兩位數的個位，差一位。
  038 題幹有歧義：沒說卡片位置是否固定。位置固定的讀法答案是 4、可任意排序是 24，
      原答案 12 兩種讀法都不是。改成明確指定位置固定。
"""
import json, io

P = 'assets/questions/mixed/grade6_foundation.mixed.v1.json'
d = json.load(open(P))
Q = {q['id']: q for q in d['questions']}
def L(zh, zhs, en, ja): return {'zh-Hant': zh, 'zh-Hans': zhs, 'en': en, 'ja': ja}
SRC_NAME = 'Original olympiad-style design'

def replace(num, subtopic, prompt, answer, steps, value, digits, why):
    q = Q['mixed_grade6_foundation_%03d' % num]
    q['subtopic'] = subtopic
    q['prompt'] = prompt
    q['answer'] = answer
    q['solutionSteps'] = {'zh-Hant': steps[0], 'zh-Hans': steps[1], 'en': steps[2], 'ja': steps[3]}
    assert len({len(v) for v in q['solutionSteps'].values()}) == 1, num
    q['answerMode'] = 'integer_input'
    q['correctAnswer'] = {'type': 'integer', 'value': value}
    q['inputConstraints'] = {'allowNegative': False, 'maxDigits': digits}
    q['source'] = {'type': 'rewritten_olympiad_style', 'name': SRC_NAME,
                   'reference': 'kangaroo56-dedup-replacement',
                   'notes': 'Replacement authored 2026-08-29 during the legacy-pack review. ' + why}
    print('替換 %03d -> %s（答 %s）' % (num, subtopic, value))

# ---------- 017 ----------
replace(17, 'discount_reverse_price',
  L('一本書打 7 折之後賣 210 元。這本書的原價是多少元？',
    '一本书打 7 折之后卖 210 元。这本书的原价是多少元？',
    'A book is sold for 210 dollars after a 30 percent discount. What was its original price?',
    '本を 3 割引きにしたところ 210 円で売られています。定価は何円でしたか。'),
  L('答案是 300 元。', '答案是 300 元。', 'The answer is 300 dollars.', '答えは 300 円です。'),
  [['打 7 折的意思是，售價是原價的 10 分之 7。',
    '把原價平分成 10 份，售出的 210 元相當於其中的 7 份。',
    '所以 1 份是 210 ÷ 7 = 30 元。',
    '原價是 10 份，也就是 30 × 10 = 300 元。（驗算：300 的 10 分之 7 是 210，正確。）'],
   ['打 7 折的意思是，售价是原价的 10 分之 7。',
    '把原价平分成 10 份，售出的 210 元相当于其中的 7 份。',
    '所以 1 份是 210 ÷ 7 = 30 元。',
    '原价是 10 份，也就是 30 × 10 = 300 元。（验算：300 的 10 分之 7 是 210，正确。）'],
   ['A 30 percent discount means the selling price is seven tenths of the original price.',
    'Split the original price into 10 equal parts; the 210 dollars paid is 7 of those parts.',
    'So one part is 210 ÷ 7 = 30 dollars.',
    'The original price is 10 parts, that is 30 × 10 = 300 dollars. Check: seven tenths of 300 is 210, as required.'],
   ['3 割引きとは、売値が定価の 10 分の 7 だということです。',
    '定価を 10 等分すると、はらった 210 円はそのうちの 7 つ分にあたります。',
    'したがって 1 つ分は 210 ÷ 7 = 30 円です。',
    '定価は 10 つ分で 30 × 10 = 300 円です。確かめると 300 の 10 分の 7 は 210 で正しいです。']],
  '300', 3, '原題與 mixed_grade5_004 同為「倒出定量後容器變成某分數滿」的骨架，相似度 0.73。')

# ---------- 018 ----------
replace(18, 'meeting_time_head_on',
  L('甲、乙兩人從相距 30 公里的兩地同時出發，面對面相向而行。甲每小時走 7 公里，乙每小時走 8 公里。出發後幾小時兩人相遇？',
    '甲、乙两人从相距 30 千米的两地同时出发，面对面相向而行。甲每小时走 7 千米，乙每小时走 8 千米。出发后几小时两人相遇？',
    'A and B set off at the same time from two places 30 km apart, walking towards each other. A walks 7 km per hour and B walks 8 km per hour. After how many hours do they meet?',
    '甲と乙は 30 km はなれた 2 地点から同時に出発し、向かい合って進みます。甲は時速 7 km、乙は時速 8 km です。出発してから何時間後に出会いますか。'),
  L('答案是 2 小時。', '答案是 2 小时。', 'The answer is 2 hours.', '答えは 2 時間です。'),
  [['兩人是面對面走的，所以每過一小時，兩人之間的距離就會縮短「甲走的」加上「乙走的」。',
    '一小時內距離縮短 7 + 8 = 15 公里。',
    '一開始相距 30 公里，要問的是 30 裡面有幾個 15。',
    '30 ÷ 15 = 2，所以出發後 2 小時相遇。（不能只用其中一個人的速度去除，那會算成 30 ÷ 7 或 30 ÷ 8，忽略了另一個人也在走。）'],
   ['两人是面对面走的，所以每过一小时，两人之间的距离就会缩短「甲走的」加上「乙走的」。',
    '一小时内距离缩短 7 + 8 = 15 千米。',
    '一开始相距 30 千米，要问的是 30 里面有几个 15。',
    '30 ÷ 15 = 2，所以出发后 2 小时相遇。（不能只用其中一个人的速度去除，那会算成 30 ÷ 7 或 30 ÷ 8，忽略了另一个人也在走。）'],
   ['They walk towards each other, so every hour the gap between them shrinks by the distance A walks plus the distance B walks.',
    'In one hour the gap shrinks by 7 + 8 = 15 km.',
    'They start 30 km apart, so the question is how many 15s make 30.',
    '30 ÷ 15 = 2, so they meet 2 hours after setting off. Dividing by just one speed, giving 30 ÷ 7 or 30 ÷ 8, would ignore that the other person is walking too.'],
   ['2 人は向かい合って進むので、1 時間ごとに 2 人の間の距離は 甲が進んだ分と乙が進んだ分だけ縮まります。',
    '1 時間で 7 + 8 = 15 km 縮まります。',
    'はじめは 30 km はなれているので、30 の中に 15 がいくつあるかを考えます。',
    '30 ÷ 15 = 2 なので、出発から 2 時間後に出会います。片方の速さだけでわって 30 ÷ 7 や 30 ÷ 8 とするのは、もう 1 人も進んでいることを見落とした誤りです。']],
  '2', 1, '原題與 combinatorics_grade8_035 是同一題：同樣「向右 4、向上 3、必經一個檢查點」，答案同為 18。')

# ---------- 022 ----------
replace(22, 'ratio_difference_from_total',
  L('一個班級男生和女生的人數比是 3 比 4，全班共 42 人。女生比男生多幾人？',
    '一个班级男生和女生的人数比是 3 比 4，全班共 42 人。女生比男生多几人？',
    'In a class the ratio of boys to girls is 3 to 4, and there are 42 students altogether. How many more girls than boys are there?',
    'あるクラスの男子と女子の人数の比は 3 対 4 で、全体は 42 人です。女子は男子より何人多いですか。'),
  L('答案是多 6 人。', '答案是多 6 人。', 'The answer is 6 more.', '答えは 6 人多いです。'),
  [['比是 3 比 4，表示可以把全班分成「男生 3 份、女生 4 份」，每一份人數相同。',
    '總共是 3 + 4 = 7 份，而全班 42 人，所以 1 份是 42 ÷ 7 = 6 人。',
    '男生是 3 份共 18 人，女生是 4 份共 24 人。',
    '女生比男生多 24 − 18 = 6 人。（也可以直接看：女生比男生多 4 − 3 = 1 份，1 份就是 6 人。）'],
   ['比是 3 比 4，表示可以把全班分成「男生 3 份、女生 4 份」，每一份人数相同。',
    '总共是 3 + 4 = 7 份，而全班 42 人，所以 1 份是 42 ÷ 7 = 6 人。',
    '男生是 3 份共 18 人，女生是 4 份共 24 人。',
    '女生比男生多 24 − 18 = 6 人。（也可以直接看：女生比男生多 4 − 3 = 1 份，1 份就是 6 人。）'],
   ['A ratio of 3 to 4 means the class splits into 3 equal shares of boys and 4 equal shares of girls.',
    'That is 3 + 4 = 7 shares in all, and the class has 42 students, so one share is 42 ÷ 7 = 6 students.',
    'The boys are 3 shares, which is 18, and the girls are 4 shares, which is 24.',
    'There are 24 − 18 = 6 more girls than boys. More directly: the girls have 4 − 3 = 1 share more, and one share is 6.'],
   ['3 対 4 の比は、クラスを男子 3 つ分・女子 4 つ分の同じ大きさのまとまりに分けられるという意味です。',
    '全部で 3 + 4 = 7 つ分あり、クラスは 42 人なので、1 つ分は 42 ÷ 7 = 6 人です。',
    '男子は 3 つ分で 18 人、女子は 4 つ分で 24 人です。',
    '女子は男子より 24 − 18 = 6 人多いです。女子のほうが 4 − 3 = 1 つ分多く、1 つ分が 6 人だと考えても同じです。']],
  '6', 1, '原題與同 pack 的 mixed_grade6_003 同為「大於 N 的最小正整數、除以幾各餘幾」，相似度 0.65。')

# ---------- 024 ----------
replace(24, 'efficiency_increase_percent',
  L('一項工程原本預定 20 天完成，實際上提前 4 天就完成了。實際的工作效率比原定提高了百分之幾？',
    '一项工程原本预定 20 天完成，实际上提前 4 天就完成了。实际的工作效率比原定提高了百分之几？',
    'A project was scheduled to take 20 days but was actually finished 4 days early. By what percentage was the actual work rate higher than planned?',
    'ある工事は 20 日で終わる予定でしたが、実際は 4 日早く終わりました。実際の作業効率は予定より何パーセント高かったですか。'),
  L('答案是提高了 25%。', '答案是提高了 25%。', 'The answer is 25 percent.', '答えは 25 パーセントです。'),
  [['工作效率指的是「一天做多少」，所以要先把兩種情況下每天的工作量比出來。',
    '把整項工程看成 1。原定 20 天完成，每天做 20 分之 1；實際 20 − 4 = 16 天完成，每天做 16 分之 1。',
    '實際效率是原定的幾倍？(1/16) ÷ (1/20) = 20 ÷ 16 = 1.25 倍。',
    '1.25 倍就是比原來多了 0.25，也就是提高 25%。（注意不是提前 4 天就等於提高 20%——4 ÷ 20 算的是天數減少的比例，不是效率提高的比例。）'],
   ['工作效率指的是「一天做多少」，所以要先把两种情况下每天的工作量比出来。',
    '把整项工程看成 1。原定 20 天完成，每天做 20 分之 1；实际 20 − 4 = 16 天完成，每天做 16 分之 1。',
    '实际效率是原定的几倍？(1/16) ÷ (1/20) = 20 ÷ 16 = 1.25 倍。',
    '1.25 倍就是比原来多了 0.25，也就是提高 25%。（注意不是提前 4 天就等于提高 20%——4 ÷ 20 算的是天数减少的比例，不是效率提高的比例。）'],
   ['Work rate means how much gets done per day, so compare the daily amounts in the two cases.',
    'Treat the whole project as 1. Planned: 20 days, so one twentieth per day. Actual: 20 − 4 = 16 days, so one sixteenth per day.',
    'How many times the planned rate is the actual rate? (1/16) ÷ (1/20) = 20 ÷ 16 = 1.25 times.',
    '1.25 times is 0.25 more than before, an increase of 25 percent. Note that finishing 4 days early does not mean a 20 percent increase: 4 ÷ 20 is the fraction of days saved, not the rise in rate.'],
   ['作業効率とは「1 日にどれだけ進むか」なので、2 つの場合の 1 日あたりの量をくらべます。',
    '工事全体を 1 とします。予定は 20 日なので 1 日に 20 分の 1、実際は 20 − 4 = 16 日なので 1 日に 16 分の 1 です。',
    '実際の効率は予定の何倍でしょうか。(1/16) ÷ (1/20) = 20 ÷ 16 = 1.25 倍です。',
    '1.25 倍は もとより 0.25 多い、つまり 25 パーセント高いということです。4 日早いから 20 パーセントとするのは誤りで、4 ÷ 20 は日数が減った割合であって効率が上がった割合ではありません。']],
  '25', 2, '原題與 logic_grade7_026 蝸牛爬井、logic_grade7_032 毛毛蟲爬竿是同一個經典題型，而且原答案 5 也是錯的（正確為 4）。')

# ---------- 031 ----------
replace(31, 'percent_more_than',
  L('甲數比乙數多 20%。已知乙數是 50，甲數是多少？',
    '甲数比乙数多 20%。已知乙数是 50，甲数是多少？',
    'A is 20 percent more than B. If B is 50, what is A?',
    '甲は乙より 20 パーセント大きい数です。乙が 50 のとき、甲はいくつですか。'),
  L('答案是 60。', '答案是 60。', 'The answer is 60.', '答えは 60 です。'),
  [['「甲比乙多 20%」的意思是，多出來的部分是「乙的 20%」，不是別的數的 20%。',
    '乙是 50，所以多出來的是 50 的 20%。',
    '50 的 10% 是 5，所以 20% 是 5 × 2 = 10。',
    '甲 = 乙 + 多出來的 = 50 + 10 = 60。（也可以直接算 50 × 1.2 = 60。）'],
   ['「甲比乙多 20%」的意思是，多出来的部分是「乙的 20%」，不是别的数的 20%。',
    '乙是 50，所以多出来的是 50 的 20%。',
    '50 的 10% 是 5，所以 20% 是 5 × 2 = 10。',
    '甲 = 乙 + 多出来的 = 50 + 10 = 60。（也可以直接算 50 × 1.2 = 60。）'],
   ['Saying A is 20 percent more than B means the extra amount is 20 percent of B, not of anything else.',
    'B is 50, so the extra amount is 20 percent of 50.',
    '10 percent of 50 is 5, so 20 percent is 5 × 2 = 10.',
    'A = B plus the extra = 50 + 10 = 60. Calculating 50 × 1.2 = 60 directly gives the same.'],
   ['「甲は乙より 20 パーセント大きい」とは、増えた分が乙の 20 パーセントだという意味で、ほかの数の 20 パーセントではありません。',
    '乙は 50 なので、増えた分は 50 の 20 パーセントです。',
    '50 の 10 パーセントは 5 なので、20 パーセントは 5 × 2 = 10 です。',
    '甲 = 乙 + 増えた分 = 50 + 10 = 60 です。50 × 1.2 = 60 と直接計算しても同じです。']],
  '60', 2, '原題與 arithmetic_grade6_028「四個數的平均是 26，其中三個是…，第四個是多少」同骨架，相似度 0.48。')

# ---------- 033 ----------
replace(33, 'inclusion_exclusion_neither',
  L('一個班有 40 人。數學及格的有 32 人，英文及格的有 28 人，兩科都及格的有 25 人。兩科都不及格的有幾人？',
    '一个班有 40 人。数学及格的有 32 人，英文及格的有 28 人，两科都及格的有 25 人。两科都不及格的有几人？',
    'A class has 40 students. 32 passed maths, 28 passed English, and 25 passed both. How many passed neither?',
    'あるクラスは 40 人です。数学に合格したのは 32 人、英語に合格したのは 28 人、両方に合格したのは 25 人です。どちらも不合格だったのは何人ですか。'),
  L('答案是 5 人。', '答案是 5 人。', 'The answer is 5.', '答えは 5 人です。'),
  [['先算「至少有一科及格」的人數，再用全班人數扣掉，剩下的就是兩科都不及格的。',
    '如果直接把 32 和 28 加起來得到 60，那些兩科都及格的人會被算兩次。',
    '所以要扣掉重複算的一次：32 + 28 − 25 = 35 人至少有一科及格。',
    '兩科都不及格的是 40 − 35 = 5 人。'],
   ['先算「至少有一科及格」的人数，再用全班人数扣掉，剩下的就是两科都不及格的。',
    '如果直接把 32 和 28 加起来得到 60，那些两科都及格的人会被算两次。',
    '所以要扣掉重复算的一次：32 + 28 − 25 = 35 人至少有一科及格。',
    '两科都不及格的是 40 − 35 = 5 人。'],
   ['First count how many passed at least one subject, then subtract from the class size to leave those who passed neither.',
    'Adding 32 and 28 straight away to get 60 counts the students who passed both twice over.',
    'So subtract that duplicate count once: 32 + 28 − 25 = 35 students passed at least one subject.',
    'Those passing neither number 40 − 35 = 5.'],
   ['まず「少なくとも 1 科目に合格した」人数を求め、クラス全体から引くと、どちらも不合格の人数が残ります。',
    '32 と 28 をそのまま足して 60 とすると、両方に合格した人を 2 回数えてしまいます。',
    'そこで重複の 1 回分を引きます。32 + 28 − 25 = 35 人が少なくとも 1 科目に合格しています。',
    'どちらも不合格なのは 40 − 35 = 5 人です。']],
  '5', 1, '原題與 mixed_grade5_014「三個連續正整數的和是 72，最大的是多少」同骨架，相似度 0.68。')

# ---------- 040 ----------
replace(40, 'volume_transfer_depth',
  L('一個長方體水箱長 6 公分、寬 5 公分、高 4 公分，裡面裝水到一半的高度。把水全部倒進一個底面積 15 平方公分的圓柱形容器，水深會是幾公分？',
    '一个长方体水箱长 6 厘米、宽 5 厘米、高 4 厘米，里面装水到一半的高度。把水全部倒进一个底面积 15 平方厘米的圆柱形容器，水深会是几厘米？',
    'A rectangular tank is 6 cm long, 5 cm wide and 4 cm high, filled with water to half its height. All the water is poured into a cylindrical container whose base area is 15 square centimetres. How deep is the water then?',
    '直方体の水そうは たて 6 cm、横 5 cm、高さ 4 cm で、高さの半分まで水が入っています。この水をすべて、底面積 15 cm² の円柱の容器に移すと、水の深さは何 cm になりますか。'),
  L('答案是 4 公分。', '答案是 4 厘米。', 'The answer is 4 cm.', '答えは 4 cm です。'),
  [['倒來倒去，水的體積不會改變，所以先把水的體積算出來。',
    '水裝到一半高度，也就是水深 4 ÷ 2 = 2 公分，水的體積是 6 × 5 × 2 = 60 立方公分。',
    '倒進圓柱後，體積仍是 60 立方公分，而體積等於「底面積 × 水深」。',
    '所以 15 × 水深 = 60，水深 = 60 ÷ 15 = 4 公分。（注意容器換了形狀，但水量沒變，這是解這類題的關鍵。）'],
   ['倒来倒去，水的体积不会改变，所以先把水的体积算出来。',
    '水装到一半高度，也就是水深 4 ÷ 2 = 2 厘米，水的体积是 6 × 5 × 2 = 60 立方厘米。',
    '倒进圆柱后，体积仍是 60 立方厘米，而体积等于「底面积 × 水深」。',
    '所以 15 × 水深 = 60，水深 = 60 ÷ 15 = 4 厘米。（注意容器换了形状，但水量没变，这是解这类题的关键。）'],
   ['Pouring water from one container to another does not change its volume, so start by finding that volume.',
    'The water fills half the height, so it is 4 ÷ 2 = 2 cm deep, and its volume is 6 × 5 × 2 = 60 cubic centimetres.',
    'After pouring, the volume is still 60 cubic centimetres, and volume equals base area times depth.',
    'So 15 times the depth is 60, giving a depth of 60 ÷ 15 = 4 cm. The container changed shape but the amount of water did not, which is the key to this kind of question.'],
   ['入れかえても水の体積は変わらないので、まず水の体積を求めます。',
    '水は高さの半分まで入っているので深さは 4 ÷ 2 = 2 cm、体積は 6 × 5 × 2 = 60 cm³ です。',
    '円柱に移しても体積は 60 cm³ のままで、体積は「底面積 × 深さ」に等しくなります。',
    'したがって 15 × 深さ = 60 で、深さは 60 ÷ 15 = 4 cm です。容器の形は変わっても水の量は変わらない、これがこの種の問題のかぎです。']],
  '4', 1, '原題與同 pack 的 mixed_grade6_011 同為座標三角形面積，連子分類名與答案 12 都相同。')

# ---------- 042 ----------
replace(42, 'concentration_after_dilution',
  L('一杯鹽水重 200 公克，其中鹽佔 10%。再倒入 50 公克的清水之後，這杯鹽水的含鹽率變成百分之幾？',
    '一杯盐水重 200 克，其中盐占 10%。再倒入 50 克的清水之后，这杯盐水的含盐率变成百分之几？',
    'A glass of salt water weighs 200 g and is 10 percent salt. After 50 g of fresh water is added, what percentage of the mixture is salt?',
    '食塩水が 200 g あり、そのうち 10 パーセントが塩です。水を 50 g 加えると、食塩水の濃度は何パーセントになりますか。'),
  L('答案是 8%。', '答案是 8%。', 'The answer is 8 percent.', '答えは 8 パーセントです。'),
  [['加水的時候，鹽的重量完全沒有變，變的只有整杯的總重量。這是這題的關鍵。',
    '先算鹽有多少：200 公克的 10% 是 20 公克。',
    '再算加水後的總重量：200 + 50 = 250 公克。鹽仍然是 20 公克。',
    '含鹽率 = 20 ÷ 250 = 0.08，也就是 8%。（不能把 10% 直接減掉什麼，濃度要重新用鹽除以新的總重量算。）'],
   ['加水的时候，盐的重量完全没有变，变的只有整杯的总重量。这是这题的关键。',
    '先算盐有多少：200 克的 10% 是 20 克。',
    '再算加水后的总重量：200 + 50 = 250 克。盐仍然是 20 克。',
    '含盐率 = 20 ÷ 250 = 0.08，也就是 8%。（不能把 10% 直接减掉什么，浓度要重新用盐除以新的总重量算。）'],
   ['Adding water leaves the amount of salt completely unchanged; only the total weight changes. That is the key to this question.',
    'First find the salt: 10 percent of 200 g is 20 g.',
    'Then the new total weight: 200 + 50 = 250 g, with the salt still 20 g.',
    'The concentration is 20 ÷ 250 = 0.08, that is 8 percent. Subtracting something from 10 percent will not work; the concentration must be recalculated as salt divided by the new total.'],
   ['水を加えても塩の重さはまったく変わらず、変わるのは全体の重さだけです。これがこの問題のかぎです。',
    'まず塩の量を求めます。200 g の 10 パーセントは 20 g です。',
    '次に水を加えた後の全体の重さは 200 + 50 = 250 g で、塩は 20 g のままです。',
    '濃度は 20 ÷ 250 = 0.08、つまり 8 パーセントです。10 パーセントから何かを引くのではなく、塩を新しい全体の重さでわり直します。']],
  '8', 1, '原題與 logic_grade9_005（同樣紅藍綠黃四色襪子）等四題抽屜原理題重複。')

# ---------- 019 就地修正：答案錯 ----------
q = Q['mixed_grade6_foundation_019']
assert q['correctAnswer']['value'] == '4'
q['correctAnswer']['value'] = '2'
q['answer'] = L('答案是 2。', '答案是 2。', 'The answer is 2.', '答えは 2 です。')
q['solutionSteps'] = {
 'zh-Hant': ['先看一位數的部分：3、6、9 三個數各佔 1 個位置，用掉第 1 到第 3 個位置。',
             '接下來都是兩位數，每個佔 2 個位置。第 12 個位置是兩位數區段的第 12 − 3 = 9 個位置。',
             '兩位數區段中，第 1 個兩位數 12 佔第 1、2 位，第 2 個 15 佔第 3、4 位，依此類推，第 5 個兩位數 24 佔第 9、10 位。',
             '第 9 位是 24 的十位數字，所以第 12 個數字是 2。（把串寫出來核對：3、6、9、1、2、1、5、1、8、2、1、2，第 12 個確實是 2。）'],
 'zh-Hans': ['先看一位数的部分：3、6、9 三个数各占 1 个位置，用掉第 1 到第 3 个位置。',
             '接下来都是两位数，每个占 2 个位置。第 12 个位置是两位数区段的第 12 − 3 = 9 个位置。',
             '两位数区段中，第 1 个两位数 12 占第 1、2 位，第 2 个 15 占第 3、4 位，依此类推，第 5 个两位数 24 占第 9、10 位。',
             '第 9 位是 24 的十位数字，所以第 12 个数字是 2。（把串写出来核对：3、6、9、1、2、1、5、1、8、2、1、2，第 12 个确实是 2。）'],
 'en': ['Start with the single-digit part: 3, 6 and 9 take one position each, using positions 1 to 3.',
        'Everything after that is a two-digit number taking 2 positions each. Position 12 is position 12 − 3 = 9 within the two-digit section.',
        'In that section the 1st two-digit number, 12, occupies positions 1 and 2, the 2nd, 15, occupies 3 and 4, and so on, so the 5th, which is 24, occupies positions 9 and 10.',
        'Position 9 is the tens digit of 24, so the 12th digit is 2. Writing the string out confirms it: 3, 6, 9, 1, 2, 1, 5, 1, 8, 2, 1, 2.'],
 'ja': ['まず 1 けたの部分です。3、6、9 がそれぞれ 1 か所を使い、1 番目から 3 番目までを占めます。',
        'その後はすべて 2 けたの数で、1 つが 2 か所を使います。12 番目は 2 けた部分の 12 − 3 = 9 番目にあたります。',
        '2 けた部分では 1 つ目の 12 が 1、2 番目、2 つ目の 15 が 3、4 番目 …… と続き、5 つ目の 24 が 9、10 番目を占めます。',
        '9 番目は 24 の十の位なので、12 番目の数字は 2 です。文字列を書き出すと 3、6、9、1、2、1、5、1、8、2、1、2 で確かに 2 です。']}
q['source']['notes'] += (' Answer corrected 2026-08-29 from 4 to 2: the original solution mistook the 9th slot of '
                         'the two-digit section for the units digit of 24 when it is the tens digit.')
print('修正 019 答案 4 -> 2（原詳解位置差一位）')

# ---------- 038 就地修正：題幹歧義 ----------
q = Q['mixed_grade6_foundation_038']
assert q['correctAnswer']['value'] == '12'
q['prompt'] = L(
 '三張卡片由左到右擺成一排，位置固定不動。第一張卡片的兩面是 1 和 2，第二張是 3 和 4，第三張是 5 和 6。每張卡片各翻出一面，由左到右讀成一個三位數。個位是偶數的翻法有幾種？',
 '三张卡片由左到右摆成一排，位置固定不动。第一张卡片的两面是 1 和 2，第二张是 3 和 4，第三张是 5 和 6。每张卡片各翻出一面，由左到右读成一个三位数。个位是偶数的翻法有几种？',
 'Three cards are laid in a row from left to right and stay in place. The first card has 1 and 2 on its two faces, the second has 3 and 4, and the third has 5 and 6. Each card is turned to show one face, and the three faces read left to right form a three-digit number. In how many ways can this be done so that the units digit is even?',
 '3 まいのカードを左から右に並べ、位置は動かしません。1 まい目の裏表は 1 と 2、2 まい目は 3 と 4、3 まい目は 5 と 6 です。各カードを 1 面ずつ表にし、左から読んで 3 けたの数をつくります。一の位が偶数になる出し方は何通りですか。')
q['answer'] = L('答案是 4 種。', '答案是 4 种。', 'The answer is 4.', '答えは 4 通りです。')
q['correctAnswer']['value'] = '4'
q['inputConstraints'] = {'allowNegative': False, 'maxDigits': 1}
q['solutionSteps'] = {
 'zh-Hant': ['個位是由第三張卡片決定的，因為卡片位置固定不動。',
             '第三張卡片的兩面是 5 和 6，其中只有 6 是偶數，所以第三張一定要翻出 6，只有 1 種選擇。',
             '第一張和第二張沒有限制，各有 2 種翻法。',
             '所以總數是 2 × 2 × 1 = 4 種，分別組成 136、146、236、246。'],
 'zh-Hans': ['个位是由第三张卡片决定的，因为卡片位置固定不动。',
             '第三张卡片的两面是 5 和 6，其中只有 6 是偶数，所以第三张一定要翻出 6，只有 1 种选择。',
             '第一张和第二张没有限制，各有 2 种翻法。',
             '所以总数是 2 × 2 × 1 = 4 种，分别组成 136、146、236、246。'],
 'en': ['The units digit comes from the third card, because the cards stay in place.',
        'The third card shows either 5 or 6, and only 6 is even, so the third card must show 6; that is just 1 choice.',
        'The first and second cards are unrestricted, with 2 ways each.',
        'So the total is 2 × 2 × 1 = 4 ways, giving the numbers 136, 146, 236 and 246.'],
 'ja': ['カードの位置は動かないので、一の位は 3 まい目のカードで決まります。',
        '3 まい目は 5 か 6 で、偶数は 6 だけなので、3 まい目は必ず 6 を出します。1 通りだけです。',
        '1 まい目と 2 まい目に制限はなく、それぞれ 2 通りです。',
        'したがって合計は 2 × 2 × 1 = 4 通りで、できる数は 136、146、236、246 です。']}
q['source']['notes'] += (' Prompt disambiguated and answer corrected 2026-08-29 from 12 to 4: the original did not '
                         'say whether the cards could be reordered, and 12 matched neither reading (4 if fixed, 24 if reorderable).')
print('修正 038 題幹歧義，答案 12 -> 4（位置固定的讀法）')

for q in d['questions']:
    assert len({len(v) for v in q['solutionSteps'].values()}) == 1, q['id']
with io.open(P, 'w', encoding='utf-8') as f:
    json.dump(d, f, ensure_ascii=False, indent=2); f.write('\n')
print('\n寫回', P, '共', len(d['questions']), '題')
