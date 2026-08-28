# -*- coding: utf-8 -*-
"""grade12 第二輪修正：dart 去重稽核抓到的兩組同子分類重複。

字面相似度閘門兩題都放行（措辭差異夠大），但 tool/question_bank_duplicate_audit.dart
靠「同 topic + 同 subtopic」抓到——因為我照概念老實命名子分類，結果和既有題撞名：

- geometry_grade12_033 正六邊形邊長 4 求最長對角線（8）
    vs geometry_grade10_022 正六邊形邊長 6 求最長對角線（12）── 純換數字
- combinatorics_grade12_040 四種水果買 6 個的重複組合（84）
    vs combinatorics_grade9_035 四種口味買 3 杯的重複組合（20）── 純換數字

教訓：字面閘門和 dart 稽核抓的是不同東西，兩個都要跑。
"""
import json, io
def load(p): return json.load(open(p))
def save(p, d):
    with io.open(p, 'w', encoding='utf-8') as f:
        json.dump(d, f, ensure_ascii=False, indent=2); f.write('\n')
def get(d, qid): return next(q for q in d['questions'] if q['id'] == qid)
NOTE = ('Replaces a candidate that shared a subtopic and skeleton with an existing question and differed only '
        'in its numbers. The literal similarity gate passed it; tool/question_bank_duplicate_audit.dart caught it.')

G = 'assets/questions/geometry/grade12_foundation.geometry.v1.json'
d = load(G); q = get(d, 'geometry_grade12_foundation_033')
q['subtopic'] = 'parallelogram_law_diagonals'
q['prompt'] = {
 'zh-Hant': '一個平行四邊形的兩條鄰邊長分別是 5 和 8，其中一條對角線的長度是 7。另一條對角線長度的平方是多少？',
 'zh-Hans': '一个平行四边形的两条邻边长分别是 5 和 8，其中一条对角线的长度是 7。另一条对角线长度的平方是多少？',
 'en': 'A parallelogram has two adjacent sides of lengths 5 and 8, and one of its diagonals has length 7. What is the square of the length of the other diagonal?',
 'ja': '平行四辺形のとなり合う 2 辺の長さが 5 と 8 で、一方の対角線の長さが 7 です。もう一方の対角線の長さの 2 乗はいくつですか。'}
q['answer'] = {'zh-Hant': '答案是 129。', 'zh-Hans': '答案是 129。',
               'en': 'The answer is 129.', 'ja': '答えは 129 です。'}
q['solutionSteps'] = {
 'zh-Hant': ['平行四邊形有一個重要的性質（平行四邊形定律）：兩條對角線長度的平方和，等於四條邊長度的平方和。',
             '四條邊之中，長度 5 和長度 8 的各有兩條，所以四邊平方和是 2 × (5² + 8²) = 2 × (25 + 64) = 178。',
             '設兩條對角線是 d₁ 和 d₂，則 d₁² + d₂² = 178。',
             '已知其中一條是 7，所以 7² + d₂² = 178，也就是 49 + d₂² = 178，得 d₂² = 129。（題目只問平方，不必再開根號。）'],
 'zh-Hans': ['平行四边形有一个重要的性质（平行四边形定律）：两条对角线长度的平方和，等于四条边长度的平方和。',
             '四条边之中，长度 5 和长度 8 的各有两条，所以四边平方和是 2 × (5² + 8²) = 2 × (25 + 64) = 178。',
             '设两条对角线是 d₁ 和 d₂，则 d₁² + d₂² = 178。',
             '已知其中一条是 7，所以 7² + d₂² = 178，也就是 49 + d₂² = 178，得 d₂² = 129。（题目只问平方，不必再开根号。）'],
 'en': ['A parallelogram satisfies an important identity, the parallelogram law: the sum of the squares of the two diagonals equals the sum of the squares of the four sides.',
        'Among the four sides there are two of length 5 and two of length 8, so the sum of their squares is 2 × (5² + 8²) = 2 × (25 + 64) = 178.',
        'Writing the diagonals as d₁ and d₂ gives d₁² + d₂² = 178.',
        'One diagonal is 7, so 7² + d₂² = 178, that is 49 + d₂² = 178, giving d₂² = 129. The question asks only for the square, so no square root is needed.'],
 'ja': ['平行四辺形には大切な性質（中線定理・平行四辺形の法則）があります。2 本の対角線の長さの 2 乗の和は、4 辺の長さの 2 乗の和に等しくなります。',
        '4 辺のうち長さ 5 の辺と長さ 8 の辺が 2 本ずつあるので、2 乗の和は 2 × (5² + 8²) = 2 × (25 + 64) = 178 です。',
        '対角線を d₁、d₂ とすると d₁² + d₂² = 178 です。',
        '一方が 7 なので 7² + d₂² = 178、つまり 49 + d₂² = 178 より d₂² = 129 です。問われているのは 2 乗なので、平方根をとる必要はありません。']}
q['correctAnswer'] = {'type': 'integer', 'value': '129'}
q['inputConstraints'] = {'maxDigits': 3, 'allowNegative': False}
q['source']['notes'] = NOTE + ' Original candidate: longest diagonal of a regular hexagon.'
save(G, d); print('已替換 geometry_grade12_foundation_033 -> 平行四邊形定律（129）')

C = 'assets/questions/combinatorics/grade12_foundation.combinatorics.v1.json'
d = load(C); q = get(d, 'combinatorics_grade12_foundation_040')
q['subtopic'] = 'split_into_two_unlabelled_groups'
q['prompt'] = {
 'zh-Hant': '8 支球隊要分成兩組，每組 4 支。兩組之間沒有先後順序，也沒有名稱的區別，只在意誰和誰被分在同一組。分法一共有幾種？',
 'zh-Hans': '8 支球队要分成两组，每组 4 支。两组之间没有先后顺序，也没有名称的区别，只在意谁和谁被分在同一组。分法一共有几种？',
 'en': 'Eight teams are split into two groups of four. The groups have no order and no names; all that matters is who ends up with whom. How many ways are there?',
 'ja': '8 チームを 4 チームずつ 2 つのグループに分けます。グループに順序も名前もなく、だれとだれが同じグループになるかだけを見ます。分け方は何通りですか。'}
q['answer'] = {'zh-Hant': '答案是 35 種。', 'zh-Hans': '答案是 35 种。',
               'en': 'The answer is 35.', 'ja': '答えは 35 通りです。'}
q['solutionSteps'] = {
 'zh-Hant': ['先假設兩組有區別（例如叫 A 組和 B 組）。這時只要決定 A 組是哪 4 支隊伍，B 組就自動確定了。',
             '從 8 支隊伍中選 4 支的方法數是 8 選 4 = (8 × 7 × 6 × 5) ÷ (4 × 3 × 2 × 1) = 1680 ÷ 24 = 70 種。',
             '但題目說兩組沒有區別。同一種分法會被算兩次——一次是某 4 支在 A 組，另一次是同樣那 4 支在 B 組，兩者其實是同一種分法。',
             '所以要除以 2：70 ÷ 2 = 35 種。'],
 'zh-Hans': ['先假设两组有区别（例如叫 A 组和 B 组）。这时只要决定 A 组是哪 4 支队伍，B 组就自动确定了。',
             '从 8 支队伍中选 4 支的方法数是 8 选 4 = (8 × 7 × 6 × 5) ÷ (4 × 3 × 2 × 1) = 1680 ÷ 24 = 70 种。',
             '但题目说两组没有区别。同一种分法会被算两次——一次是某 4 支在 A 组，另一次是同样那 4 支在 B 组，两者其实是同一种分法。',
             '所以要除以 2：70 ÷ 2 = 35 种。'],
 'en': ['First pretend the groups are distinguishable, say group A and group B. Then it is enough to decide which 4 teams go in group A, since group B is whatever is left.',
        'The number of ways to choose 4 teams from 8 is 8 choose 4 = (8 × 7 × 6 × 5) ÷ (4 × 3 × 2 × 1) = 1680 ÷ 24 = 70.',
        'But the problem says the groups are not distinguishable. Each split gets counted twice: once with a particular four in group A, and once with the same four in group B, which is really the same split.',
        'So divide by 2: 70 ÷ 2 = 35.'],
 'ja': ['まず 2 つのグループを区別できるものとし、A 組と B 組と呼びます。すると A 組に入る 4 チームを決めれば、残りが自動的に B 組になります。',
        '8 チームから 4 チームを選ぶ方法は 8 個から 4 個 = (8 × 7 × 6 × 5) ÷ (4 × 3 × 2 × 1) = 1680 ÷ 24 = 70 通りです。',
        'しかし問題ではグループを区別しません。同じ分け方が 2 回数えられています。ある 4 チームが A 組の場合と、同じ 4 チームが B 組の場合で、実際には同じ分け方だからです。',
        'したがって 2 でわり、70 ÷ 2 = 35 通りです。']}
q['correctAnswer'] = {'type': 'integer', 'value': '35'}
q['inputConstraints'] = {'maxDigits': 2, 'allowNegative': False}
q['source']['notes'] = NOTE + ' Original candidate: buying 6 pieces from 4 kinds of fruit with repetition.'
save(C, d); print('已替換 combinatorics_grade12_foundation_040 -> 分成兩組（35）')
