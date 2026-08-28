# -*- coding: utf-8 -*-
"""grade11 寫入後重掃的修正。

兩類問題：
1. logic_grade11_036（長度 8、無相鄰 1、答 55）與既有 combinatorics_grade11_024
   （長度 8、恰 3 個 1、無相鄰、答 20）是同一骨架的弱變形。工具只給 0.47，
   因為敘述用字不同——這正是「換問法同骨架」，字面比對抓不到，必須人工判。整題換掉。
2. 四組因共用開場句而相似度偏高的配對，改寫開場句（題目本身不同，不必換題）。
"""
import json, io

def load(p): return json.load(open(p))
def save(p, d):
    with io.open(p, 'w', encoding='utf-8') as f:
        json.dump(d, f, ensure_ascii=False, indent=2); f.write('\n')

def get(d, qid):
    for q in d['questions']:
        if q['id'] == qid: return q
    raise KeyError(qid)

# ---------- 1. 換掉 logic_grade11_036 ----------
P = 'assets/questions/logic/grade11_foundation.logic.v1.json'
d = load(P)
q = get(d, 'logic_grade11_foundation_036')
q['subtopic'] = 'pigeonhole_same_colour'
q['prompt'] = {
 'zh-Hant': '抽屜裡有紅色、藍色、綠色三種顏色的襪子各很多隻，形狀完全相同，摸的時候看不出顏色。最少要摸出幾隻襪子，才能保證其中一定有 4 隻是同一種顏色？',
 'zh-Hans': '抽屉里有红色、蓝色、绿色三种颜色的袜子各很多只，形状完全相同，摸的时候看不出颜色。最少要摸出几只袜子，才能保证其中一定有 4 只是同一种颜色？',
 'en': 'A drawer holds plenty of socks in three colours: red, blue and green. They are identical in shape and the colour cannot be seen while reaching in. What is the smallest number of socks that must be taken out to be certain of having 4 of the same colour?',
 'ja': 'ひきだしには赤・青・緑の 3 色のくつ下がたくさん入っています。形は同じで、手さぐりでは色がわかりません。同じ色のくつ下が 4 足そろうことを確実にするには、最少で何足取り出せばよいですか。'}
q['answer'] = {'zh-Hant': '答案是 10 隻。', 'zh-Hans': '答案是 10 只。',
               'en': 'The answer is 10.', 'ja': '答えは 10 足です。'}
q['solutionSteps'] = {
 'zh-Hant': ['這種「保證一定會發生」的題目，要想的是最壞情況——運氣最差時最多可以撐多久還沒達成目標。',
             '最壞的情況是三種顏色都盡量各摸到 3 隻卻還沒湊滿 4 隻同色，也就是紅 3 隻、藍 3 隻、綠 3 隻，共 9 隻。',
             '摸到 9 隻時確實還可能沒有 4 隻同色，所以 9 隻不夠。',
             '但再摸第 10 隻時，它一定是三種顏色之一，那個顏色就會變成 4 隻。所以答案是 10 隻。'],
 'zh-Hans': ['这种「保证一定会发生」的题目，要想的是最坏情况——运气最差时最多可以撑多久还没达成目标。',
             '最坏的情况是三种颜色都尽量各摸到 3 只却还没凑满 4 只同色，也就是红 3 只、蓝 3 只、绿 3 只，共 9 只。',
             '摸到 9 只时确实还可能没有 4 只同色，所以 9 只不够。',
             '但再摸第 10 只时，它一定是三种颜色之一，那个颜色就会变成 4 只。所以答案是 10 只。'],
 'en': ['For a question asking what guarantees an outcome, think about the worst case: how long can bad luck hold the goal off?',
        'The worst case is getting as close as possible without success, namely 3 red, 3 blue and 3 green, which is 9 socks.',
        'With 9 socks it really is still possible to have no colour appearing 4 times, so 9 is not enough.',
        'But the 10th sock must be one of the three colours, and that colour then reaches 4. So the answer is 10.'],
 'ja': ['「必ずそうなる」ことを保証する問題では、最悪の場合を考えます。運が悪いとき、どこまで目標に届かずにいられるかです。',
        '最悪なのは、赤 3 足・青 3 足・緑 3 足の合計 9 足で、まだどの色も 4 足に届いていない場合です。',
        '9 足の時点では同じ色が 4 足そろっていないこともありうるので、9 足では足りません。',
        'しかし 10 足目は必ず 3 色のどれかなので、その色が 4 足になります。したがって答えは 10 足です。']}
q['correctAnswer'] = {'type': 'integer', 'value': '10'}
q['inputConstraints'] = {'maxDigits': 2, 'allowNegative': False}
q['source']['notes'] = ('Replaces an earlier candidate about binary strings of length 8 with no adjacent 1s: '
                        'that was the same skeleton as combinatorics_grade11_foundation_024 (length 8, exactly '
                        'three non-adjacent 1s) with the count constraint dropped, which the literal similarity '
                        'gate scored at only 0.47 and did not catch.')
save(P, d)
print('已替換 logic_grade11_foundation_036 -> 抽屜原理（襪子）')

# ---------- 2. 改寫共用開場句 ----------
def rewrite(path, qid, zh, zhs, en, ja):
    d = load(path); q = get(d, qid)
    q['prompt'] = {'zh-Hant': zh, 'zh-Hans': zhs, 'en': en, 'ja': ja}
    save(path, d)
    print('已改寫題幹', qid)

A = 'assets/questions/algebra/grade11_foundation.algebra.v1.json'
G = 'assets/questions/geometry/grade11_foundation.geometry.v1.json'

# 0.81 撞 algebra_grade10_036（共用「設 i 是虛數單位，也就是 i 的平方等於 −1。」）
rewrite(A, 'algebra_grade11_foundation_036',
 '把複數 1 + i 連續自乘，一共乘 8 次（也就是求它的 8 次方）。結果是多少？這裡 i 乘以 i 等於 −1。',
 '把复数 1 + i 连续自乘，一共乘 8 次（也就是求它的 8 次方）。结果是多少？这里 i 乘以 i 等于 −1。',
 'The complex number 1 + i is multiplied by itself repeatedly, eight factors in all, which is its 8th power. What is the result? Here i times i equals −1.',
 '複素数 1 + i を くり返しかけ合わせます。全部で 8 個かける、つまり 8 乗を求めます。結果はいくつですか。ここで i × i は −1 です。')

# 0.68 撞 algebra_grade11_033（共用「2 × 2 矩陣的第一列是…第二列是…」）
rewrite(A, 'algebra_grade11_foundation_038',
 '設 A、B 都是 2 × 2 矩陣。A 的四個元素依左上、右上、左下、右下的順序是 1、2、3、4；B 的四個元素依同樣順序是 5、6、7、8。乘積 A × B 的左上角元素是多少？',
 '设 A、B 都是 2 × 2 矩阵。A 的四个元素依左上、右上、左下、右下的顺序是 1、2、3、4；B 的四个元素依同样顺序是 5、6、7、8。乘积 A × B 的左上角元素是多少？',
 'Let A and B both be 2 × 2 matrices. Reading top-left, top-right, bottom-left, bottom-right, the entries of A are 1, 2, 3, 4 and the entries of B in the same order are 5, 6, 7, 8. What is the top-left entry of the product A × B?',
 'A と B をどちらも 2 × 2 行列とします。左上・右上・左下・右下の順に、A の成分は 1、2、3、4、B の成分は同じ順に 5、6、7、8 です。積 A × B の左上の成分はいくつですか。')

# 0.68 / 0.64 撞 geometry_grade11_034（共用「平面上有兩個向量，分量分別是…」）
rewrite(G, 'geometry_grade11_foundation_038',
 '設 u 是分量為 (2, −1) 的向量，v 是分量為 (1, k) 的向量。若 u 與 v 互相垂直，k 是多少？',
 '设 u 是分量为 (2, −1) 的向量，v 是分量为 (1, k) 的向量。若 u 与 v 互相垂直，k 是多少？',
 'Let u be the vector with components (2, −1) and let v be the vector with components (1, k). If u and v are perpendicular, what is k?',
 'u を成分 (2, −1) のベクトル、v を成分 (1, k) のベクトルとします。u と v が垂直であるとき、k はいくつですか。')

rewrite(G, 'geometry_grade11_foundation_039',
 '從原點畫出兩個箭頭：一個指到 (1, 0)，另一個指到 (1, 1)。這兩個箭頭之間的夾角是幾度？',
 '从原点画出两个箭头：一个指到 (1, 0)，另一个指到 (1, 1)。这两个箭头之间的夹角是几度？',
 'Two arrows are drawn from the origin, one to the point (1, 0) and the other to the point (1, 1). What is the angle between the two arrows, in degrees?',
 '原点から 2 本の矢印をかきます。1 本は点 (1, 0) へ、もう 1 本は点 (1, 1) へ向かいます。2 本の矢印のなす角は何度ですか。')

# 0.53 撞 algebra_grade11_040（兩題都很短，重疊係數被拉高）
rewrite(A, 'algebra_grade11_foundation_035',
 '2 要自乘幾次才會等於 32？（換句話說，以 2 為底、32 的對數是多少？）',
 '2 要自乘几次才会等于 32？（换句话说，以 2 为底、32 的对数是多少？）',
 'How many factors of 2 multiplied together give 32? In other words, what is the logarithm of 32 to base 2?',
 '2 を何個かけ合わせると 32 になりますか。言いかえると、2 を底とする 32 の対数はいくつですか。')
