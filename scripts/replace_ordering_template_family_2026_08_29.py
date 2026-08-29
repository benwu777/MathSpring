# -*- coding: utf-8 -*-
"""替換 ordering 模板家族的 10 題。

全庫模板指紋掃描（把人名、字母、數字正規化後再比相似度，並要求「詳解也同構」）
找出 5 個真正的模板濫用家族。最大的是 ordering：12 題全部是同一個骨架——
「給 N−1 條完全決定順序的關係，把順序排出來後讀出第 k 個是誰」，
詳解一律兩步：「順序是 …」「第 k 個是 …」。彼此只換字母（甲乙丙丁 / PQRS /
MNPQR / ABCDE / LMNPQ）和問的位置，正是紅線 1 明列的「只換故事、換求量位置」。

字面閘門抓不到，因為 3-gram 對「甲乙丙丁 → PQRS」完全無感。

保留 logic_grade1_030（三人、兩個相對關係）與 logic_grade2_020（四人鏈）
各一題當作這個題型的代表，另外 logic_grade4_012 與 logic_grade6_027 本來就
有真正的分類討論，不算模板。其餘 10 題換成推理點各不相同的新題。

新題本身也過閘門，過程中淘汰了 5 個候選：
  三盒糖撞 logic_grade2_053（我同一輪加的）0.71
  抽卡偶積撞 logic_grade3_053（我同一輪加的）0.76
  倍數條件撞 logic_grade2_033，而且答案不唯一（12 和 24 都符合）
  三人循環指控（甲說乙謊、乙說丙謊、丙說甲謊）全窮舉沒有任何一致解，題型本身不成立
"""
import json, io

def L(zh, zhs, en, ja): return {'zh-Hant': zh, 'zh-Hans': zhs, 'en': en, 'ja': ja}
PACKS = {}
def pack(g):
    p = 'assets/questions/logic/grade%d_foundation.logic.v1.json' % g
    if p not in PACKS: PACKS[p] = json.load(open(p))
    return p, PACKS[p]

def replace(g, num, subtopic, prompt, answer, steps, value, digits, why):
    p, d = pack(g)
    q = next(x for x in d['questions'] if x['id'] == 'logic_grade%d_foundation_%03d' % (g, num))
    old = q['prompt']['zh-Hant'][:26]
    q.pop('options', None)                      # 原題是選擇題，新題改成填答
    q['subtopic'] = subtopic
    q['prompt'] = prompt
    q['answer'] = answer
    q['solutionSteps'] = {'zh-Hant': steps[0], 'zh-Hans': steps[1], 'en': steps[2], 'ja': steps[3]}
    assert len({len(v) for v in q['solutionSteps'].values()}) == 1
    q['answerMode'] = 'integer_input'
    q['correctAnswer'] = {'type': 'integer', 'value': value}
    q['inputConstraints'] = {'allowNegative': False, 'maxDigits': digits}
    q['source']['notes'] = ('Replacement authored 2026-08-29 during the whole-bank template scan. ' + why)
    print('g%d %03d  %-28s 答%-4s  原: %s…' % (g, num, subtopic, value, old))

replace(1, 2, 'position_double_elimination',
  L('小明、小華、小美三個人排成一列。小華排在最後面，而且小明不排在最前面。誰排在最前面？（小明記為 1、小華記為 2、小美記為 3。）',
    '小明、小华、小美三个人排成一列。小华排在最后面，而且小明不排在最前面。谁排在最前面？（小明记为 1、小华记为 2、小美记为 3。）',
    'Ming, Hua and Mei stand in a line. Hua is last, and Ming is not first. Who is first? Answer with a number: Ming is 1, Hua is 2, Mei is 3.',
    '明・華・美 の 3 人が一列に並んでいます。華はいちばん後ろで、明は先頭ではありません。先頭はだれですか。明を 1、華を 2、美を 3 として数字で答えます。'),
  L('答案是 3（小美）。', '答案是 3（小美）。', 'The answer is 3, which is Mei.', '答えは 3（美）です。'),
  [['三個人排成一列，位置只有第 1、第 2、第 3 三個，一個一個排除就能定出來。',
    '題目說小華排在最後面，所以小華是第 3 個，第 1 和第 2 就只剩小明和小美。',
    '題目又說小明不排在最前面，所以小明不能是第 1 個，只能是第 2 個。',
    '剩下第 1 個就是小美。所以排在最前面的是小美，答案填 3。'],
   ['三个人排成一列，位置只有第 1、第 2、第 3 三个，一个一个排除就能定出来。',
    '题目说小华排在最后面，所以小华是第 3 个，第 1 和第 2 就只剩小明和小美。',
    '题目又说小明不排在最前面，所以小明不能是第 1 个，只能是第 2 个。',
    '剩下第 1 个就是小美。所以排在最前面的是小美，答案填 3。'],
   ['Three children in a line fill only positions 1, 2 and 3, so ruling things out one at a time settles it.',
    'Hua is last, so Hua takes position 3, leaving positions 1 and 2 for Ming and Mei.',
    'Ming is not first, so Ming cannot take position 1 and must take position 2.',
    'That leaves position 1 for Mei, so Mei is first and the answer is 3.'],
   ['3 人が一列に並ぶと位置は 1 番目・2 番目・3 番目だけなので、順に消していけば決まります。',
    '華はいちばん後ろなので 3 番目、1 番目と 2 番目に残るのは明と美です。',
    '明は先頭ではないので 1 番目になれず、2 番目に決まります。',
    '残る 1 番目が美です。したがって先頭は美で、答えは 3 です。']],
  '3', 1, 'Replaces a pure ordering-chain template question.')

replace(3, 16, 'adjacent_pair_position',
  L('甲、乙、丙、丁四個人排成一列。丙排在最後面，甲不排在第一個，而且乙緊接在甲的後面。乙排第幾個？',
    '甲、乙、丙、丁四个人排成一列。丙排在最后面，甲不排在第一个，而且乙紧接在甲的后面。乙排第几个？',
    'Four people A, B, C and D stand in a line. C is last, A is not first, and B stands immediately behind A. In which position is B?',
    '甲・乙・丙・丁 の 4 人が一列に並んでいます。丙はいちばん後ろ、甲は先頭ではなく、乙は甲のすぐ後ろにいます。乙は何番目ですか。'),
  L('答案是第 3 個。', '答案是第 3 个。', 'The answer is 3rd.', '答えは 3 番目です。'),
  [['先用最確定的條件：丙排在最後面，也就是第 4 個位置被丙佔走了。',
    '甲和乙必須相鄰而且甲在前，所以「甲乙」這一組只能落在第 1、2 位或第 2、3 位（第 3、4 位不行，因為第 4 位是丙）。',
    '題目說甲不排第一個，所以「甲在第 1 位」被排除，只剩甲在第 2 位、乙在第 3 位。',
    '驗算：丁排第 1 位，順序是丁、甲、乙、丙，四個條件都成立。所以乙排第 3 個。'],
   ['先用最确定的条件：丙排在最后面，也就是第 4 个位置被丙占走了。',
    '甲和乙必须相邻而且甲在前，所以「甲乙」这一组只能落在第 1、2 位或第 2、3 位（第 3、4 位不行，因为第 4 位是丙）。',
    '题目说甲不排第一个，所以「甲在第 1 位」被排除，只剩甲在第 2 位、乙在第 3 位。',
    '验算：丁排第 1 位，顺序是丁、甲、乙、丙，四个条件都成立。所以乙排第 3 个。'],
   ['Start with the most definite condition: C is last, so position 4 is taken by C.',
    'A and B must be adjacent with A in front, so the block "A then B" can only sit in positions 1 and 2 or positions 2 and 3; positions 3 and 4 are impossible because position 4 belongs to C.',
    'Since A is not first, the option with A in position 1 is ruled out, leaving A in position 2 and B in position 3.',
    'Check: D takes position 1, giving the order D, A, B, C, and all the conditions hold. So B is 3rd.'],
   ['いちばんはっきりした条件から使います。丙がいちばん後ろなので 4 番目は丙で決まりです。',
    '甲と乙はとなり合い甲が前なので、「甲乙」のかたまりは 1・2 番目か 2・3 番目にしか入りません。3・4 番目は 4 番目が丙なので不可能です。',
    '甲は先頭ではないので 1 番目の案は消え、甲が 2 番目・乙が 3 番目に決まります。',
    '確かめると 1 番目は丁で、順は 丁・甲・乙・丙 となり条件をすべて満たします。よって乙は 3 番目です。']],
  '3', 1, 'Replaces a pure ordering-chain template question.')

replace(3, 19, 'two_remainder_conditions',
  L('籃子裡有一些蘋果。3 個 3 個地拿，最後剩下 2 個；5 個 5 個地拿，最後剩下 4 個。籃子裡的蘋果最少有幾個？',
    '篮子里有一些苹果。3 个 3 个地拿，最后剩下 2 个；5 个 5 个地拿，最后剩下 4 个。篮子里的苹果最少有几个？',
    'A basket holds some apples. Taking them out 3 at a time leaves 2 over; taking them out 5 at a time leaves 4 over. What is the smallest possible number of apples?',
    'かごにりんごが入っています。3 個ずつ取ると 2 個あまり、5 個ずつ取ると 4 個あまります。りんごは最少で何個ですか。'),
  L('答案是 14 個。', '答案是 14 个。', 'The answer is 14.', '答えは 14 個です。'),
  [['兩個條件都要滿足，先從限制比較強的那個開始列，再用另一個篩選。',
    '5 個 5 個地拿剩 4 個，表示這個數是 4、9、14、19、24、⋯（每次加 5）。',
    '再看第一個條件：3 個 3 個地拿剩 2 個。逐一檢查——4 除以 3 餘 1，不合；9 除以 3 餘 0，不合；14 除以 3 餘 2，符合。',
    '所以最少是 14 個。驗算：14 ÷ 3 = 4 餘 2、14 ÷ 5 = 2 餘 4，兩個條件都成立。'],
   ['两个条件都要满足，先从限制比较强的那个开始列，再用另一个筛选。',
    '5 个 5 个地拿剩 4 个，表示这个数是 4、9、14、19、24、⋯（每次加 5）。',
    '再看第一个条件：3 个 3 个地拿剩 2 个。逐一检查——4 除以 3 余 1，不合；9 除以 3 余 0，不合；14 除以 3 余 2，符合。',
    '所以最少是 14 个。验算：14 ÷ 3 = 4 余 2、14 ÷ 5 = 2 余 4，两个条件都成立。'],
   ['Both conditions must hold, so list the numbers satisfying the tighter one first and then filter with the other.',
    'Taking them 5 at a time leaving 4 means the number is 4, 9, 14, 19, 24, and so on, going up by 5 each time.',
    'Now apply the first condition, that taking them 3 at a time leaves 2. Checking in turn: 4 leaves remainder 1, no; 9 leaves remainder 0, no; 14 leaves remainder 2, yes.',
    'So the smallest is 14. Check: 14 ÷ 3 = 4 remainder 2 and 14 ÷ 5 = 2 remainder 4, so both conditions hold.'],
   ['2 つの条件を同時に満たす必要があるので、きびしいほうから候補を並べ、もう一方でふるいにかけます。',
    '5 個ずつ取って 4 あまるので、その数は 4、9、14、19、24、…… と 5 ずつふえていきます。',
    '次に 1 つ目の条件、3 個ずつ取って 2 あまるかを順に調べます。4 は 3 でわると 1 あまりで不適、9 はあまり 0 で不適、14 はあまり 2 で適します。',
    'したがって最少は 14 個です。確かめると 14 ÷ 3 = 4 あまり 2、14 ÷ 5 = 2 あまり 4 で両方成り立ちます。']],
  '14', 2, 'Replaces a pure ordering-chain template question.')

replace(3, 24, 'diagonal_pairs_only',
  L('一個正方形的四個角各站一個人。每個人只和站在對角（也就是不相鄰）那個位置的人握一次手。一共握了幾次手？',
    '一个正方形的四个角各站一个人。每个人只和站在对角（也就是不相邻）那个位置的人握一次手。一共握了几次手？',
    'One person stands at each of the four corners of a square. Each person shakes hands once only with the person diagonally opposite, not with the neighbouring corners. How many handshakes take place?',
    '正方形の 4 すみに 1 人ずつ立ちます。各人は となりのかどの人とではなく、対角にいる人とだけ 1 回あくしゅします。あくしゅは全部で何回ですか。'),
  L('答案是 2 次。', '答案是 2 次。', 'The answer is 2.', '答えは 2 回です。'),
  [['先看清楚正方形上「對角」是什麼意思：每個角只有一個對角，就是隔著正方形中心正對面的那一個。',
    '把四個角依序叫做左上、右上、右下、左下。左上的對角是右下，右上的對角是左下。',
    '所以會握手的只有「左上和右下」以及「右上和左下」這兩組，剛好對應正方形的兩條對角線。',
    '每一組握一次，所以一共握 2 次。（如果每兩人都握，會是 4 × 3 ÷ 2 = 6 次；這題限制只握對角，所以少很多。）'],
   ['先看清楚正方形上「对角」是什么意思：每个角只有一个对角，就是隔着正方形中心正对面的那一个。',
    '把四个角依序叫做左上、右上、右下、左下。左上的对角是右下，右上的对角是左下。',
    '所以会握手的只有「左上和右下」以及「右上和左下」这两组，刚好对应正方形的两条对角线。',
    '每一组握一次，所以一共握 2 次。（如果每两人都握，会是 4 × 3 ÷ 2 = 6 次；这题限制只握对角，所以少很多。）'],
   ['First be clear what diagonally opposite means on a square: each corner has exactly one opposite corner, the one straight across through the centre.',
    'Label the corners top-left, top-right, bottom-right and bottom-left. The opposite of top-left is bottom-right, and the opposite of top-right is bottom-left.',
    'So the only pairs who shake hands are top-left with bottom-right and top-right with bottom-left, which are exactly the two diagonals of the square.',
    'Each pair shakes once, giving 2 handshakes. If everyone shook with everyone it would be 4 × 3 ÷ 2 = 6; restricting to diagonals cuts it right down.'],
   ['まず正方形の「対角」の意味をはっきりさせます。どのかどにも対角はちょうど 1 つで、中心をはさんで真向かいのかどです。',
    '4 すみを左上・右上・右下・左下と呼びます。左上の対角は右下、右上の対角は左下です。',
    'したがってあくしゅするのは「左上と右下」「右上と左下」の 2 組だけで、これは正方形の 2 本の対角線にあたります。',
    '各組 1 回ずつなので合計 2 回です。全員どうしなら 4 × 3 ÷ 2 = 6 回ですが、対角だけに限ると大きく減ります。']],
  '2', 1, 'Replaces a pure ordering-chain template question.')

replace(4, 14, 'four_people_four_cities',
  L('甲、乙、丙、丁四個人分別來自台北、台中、高雄、台南四個不同的城市。已知乙是高雄人；甲既不是台北人也不是台中人；丙不是台北人。丁是哪個城市的人？（台北記為 1、台中記為 2、高雄記為 3、台南記為 4。）',
    '甲、乙、丙、丁四个人分别来自台北、台中、高雄、台南四个不同的城市。已知乙是高雄人；甲既不是台北人也不是台中人；丙不是台北人。丁是哪个城市的人？（台北记为 1、台中记为 2、高雄记为 3、台南记为 4。）',
    'Four people A, B, C and D come from four different cities: Taipei, Taichung, Kaohsiung and Tainan. B is from Kaohsiung; A is from neither Taipei nor Taichung; C is not from Taipei. Which city is D from? Answer with a number: Taipei 1, Taichung 2, Kaohsiung 3, Tainan 4.',
    '甲・乙・丙・丁 の 4 人は 台北・台中・高雄・台南 という ことなる 4 つの都市の出身です。乙は高雄、甲は台北でも台中でもなく、丙は台北ではありません。丁はどの都市の出身ですか。台北を 1、台中を 2、高雄を 3、台南を 4 として数字で答えます。'),
  L('答案是 1（台北）。', '答案是 1（台北）。', 'The answer is 1, Taipei.', '答えは 1（台北）です。'),
  [['四個人配四個城市，一旦某個城市被確定，其他人的可能就會減少。從唯一沒有「不是」的條件開始。',
    '乙是高雄人，這是確定的，所以其他三個人都不可能是高雄人。',
    '再看甲：甲不是台北人、不是台中人，而高雄已經被乙拿走，所以甲只剩台南。',
    '再看丙：丙不是台北人，而台中、高雄、台南都已被排除或佔走（高雄是乙、台南是甲），所以丙是台中人。最後剩下的台北就是丁的，答案填 1。'],
   ['四个人配四个城市，一旦某个城市被确定，其他人的可能就会减少。从唯一没有「不是」的条件开始。',
    '乙是高雄人，这是确定的，所以其他三个人都不可能是高雄人。',
    '再看甲：甲不是台北人、不是台中人，而高雄已经被乙拿走，所以甲只剩台南。',
    '再看丙：丙不是台北人，而台中、高雄、台南都已被排除或占走（高雄是乙、台南是甲），所以丙是台中人。最后剩下的台北就是丁的，答案填 1。'],
   ['Four people match four cities, so fixing one city narrows the options for everyone else. Start with the only condition that does not contain a "not".',
    'B is from Kaohsiung, which is certain, so none of the other three can be from Kaohsiung.',
    'Now A: A is not from Taipei and not from Taichung, and Kaohsiung is taken by B, so only Tainan is left for A.',
    'Now C: C is not from Taipei, while Kaohsiung belongs to B and Tainan to A, so C must be from Taichung. Taipei is all that remains, and it belongs to D, so the answer is 1.'],
   ['4 人と 4 都市の対応なので、1 つ決まると他の可能性がせばまります。「〜ではない」を含まない唯一の条件から始めます。',
    '乙は高雄で確定なので、他の 3 人は高雄ではありません。',
    '次に甲です。甲は台北でも台中でもなく、高雄は乙のものなので、残るのは台南だけです。',
    '次に丙です。丙は台北ではなく、高雄は乙、台南は甲のものなので、丙は台中です。残った台北が丁のもので、答えは 1 です。']],
  '1', 1, 'Replaces a pure ordering-chain template question.')

replace(4, 17, 'double_remainder_in_range',
  L('一個整數介於 20 和 40 之間。它加上 3 之後剛好是 4 的倍數，減去 3 之後剛好是 5 的倍數。這個整數是多少？',
    '一个整数介于 20 和 40 之间。它加上 3 之后刚好是 4 的倍数，减去 3 之后刚好是 5 的倍数。这个整数是多少？',
    'A whole number lies between 20 and 40. Adding 3 to it gives a multiple of 4, and subtracting 3 from it gives a multiple of 5. What is the number?',
    'ある整数は 20 と 40 の間にあります。3 を足すと 4 の倍数になり、3 を引くと 5 の倍数になります。この整数はいくつですか。'),
  L('答案是 33。', '答案是 33。', 'The answer is 33.', '答えは 33 です。'),
  [['兩個條件都要滿足，先用其中一個把候選數縮小，再用另一個檢查。',
    '「減去 3 之後是 5 的倍數」比較好列：5 的倍數是 20、25、30、35，加回 3 得到候選數 23、28、33、38，這些都落在 20 到 40 之間。',
    '再檢查另一個條件——加上 3 之後是不是 4 的倍數。23 + 3 = 26，不是 4 的倍數；28 + 3 = 31，不是；33 + 3 = 36 = 4 × 9，是！38 + 3 = 41，不是。',
    '所以只有 33 同時滿足兩個條件。驗算：33 + 3 = 36 是 4 的倍數，33 − 3 = 30 是 5 的倍數。'],
   ['两个条件都要满足，先用其中一个把候选数缩小，再用另一个检查。',
    '「减去 3 之后是 5 的倍数」比较好列：5 的倍数是 20、25、30、35，加回 3 得到候选数 23、28、33、38，这些都落在 20 到 40 之间。',
    '再检查另一个条件——加上 3 之后是不是 4 的倍数。23 + 3 = 26，不是 4 的倍数；28 + 3 = 31，不是；33 + 3 = 36 = 4 × 9，是！38 + 3 = 41，不是。',
    '所以只有 33 同时满足两个条件。验算：33 + 3 = 36 是 4 的倍数，33 − 3 = 30 是 5 的倍数。'],
   ['Both conditions must hold, so use one of them to shrink the candidates and the other to test them.',
    'The condition about subtracting 3 is easier to list: multiples of 5 near the range are 20, 25, 30 and 35, and adding 3 back gives the candidates 23, 28, 33 and 38, all between 20 and 40.',
    'Now test the other condition, that adding 3 gives a multiple of 4. 23 + 3 = 26, not a multiple of 4; 28 + 3 = 31, no; 33 + 3 = 36 = 4 × 9, yes; 38 + 3 = 41, no.',
    'Only 33 satisfies both. Check: 33 + 3 = 36 is a multiple of 4, and 33 − 3 = 30 is a multiple of 5.'],
   ['2 つの条件を同時に満たすので、片方で候補をしぼり、もう片方で確かめます。',
    '「3 を引くと 5 の倍数」のほうが並べやすく、5 の倍数 20、25、30、35 に 3 を戻すと候補は 23、28、33、38 で、どれも 20 と 40 の間です。',
    '次に「3 を足すと 4 の倍数」を調べます。23 + 3 = 26 は 4 の倍数ではなく、28 + 3 = 31 もちがい、33 + 3 = 36 = 4 × 9 は該当し、38 + 3 = 41 はちがいます。',
    'したがって両方を満たすのは 33 だけです。確かめると 33 + 3 = 36 は 4 の倍数、33 − 3 = 30 は 5 の倍数です。']],
  '33', 2, 'Replaces a pure ordering-chain template question.')

replace(4, 22, 'money_chain_three_people',
  L('甲、乙、丙三人身上的錢加起來是 220 元。甲比乙多 30 元，乙比丙多 20 元。乙有多少元？',
    '甲、乙、丙三人身上的钱加起来是 220 元。甲比乙多 30 元，乙比丙多 20 元。乙有多少元？',
    'A, B and C have 220 dollars between them. A has 30 dollars more than B, and B has 20 dollars more than C. How much does B have?',
    '甲・乙・丙 の 3 人が持っているお金は合わせて 220 円です。甲は乙より 30 円多く、乙は丙より 20 円多く持っています。乙は何円持っていますか。'),
  L('答案是 70 元。', '答案是 70 元。', 'The answer is 70 dollars.', '答えは 70 円です。'),
  [['三個人的錢都是互相比出來的，選一個當基準最好算。丙最少，就用丙當基準。',
    '乙比丙多 20 元；甲比乙多 30 元，所以甲比丙多 20 + 30 = 50 元。',
    '如果先把乙多出的 20 元和甲多出的 50 元（合計 70 元）拿掉，三個人就一樣多了，剩下 220 − 70 = 150 元。',
    '這 150 元平分成三份，每份 150 ÷ 3 = 50 元，這是丙的錢。乙比丙多 20 元，所以乙有 50 + 20 = 70 元。（驗算：丙 50、乙 70、甲 100，合計 220。）'],
   ['三个人的钱都是互相比出来的，选一个当基准最好算。丙最少，就用丙当基准。',
    '乙比丙多 20 元；甲比乙多 30 元，所以甲比丙多 20 + 30 = 50 元。',
    '如果先把乙多出的 20 元和甲多出的 50 元（合计 70 元）拿掉，三个人就一样多了，剩下 220 − 70 = 150 元。',
    '这 150 元平分成三份，每份 150 ÷ 3 = 50 元，这是丙的钱。乙比丙多 20 元，所以乙有 50 + 20 = 70 元。（验算：丙 50、乙 70、甲 100，合计 220。）'],
   ['All three amounts are described by comparison, so pick one as the baseline. C has the least, so use C.',
    'B has 20 more than C, and A has 30 more than B, so A has 20 + 30 = 50 more than C.',
    'Removing B\'s extra 20 and A\'s extra 50, which is 70 dollars in total, leaves all three equal with 220 − 70 = 150 dollars.',
    'Splitting 150 into three equal parts gives 150 ÷ 3 = 50 dollars, which is C\'s amount. B has 20 more, so B has 50 + 20 = 70 dollars. Check: 50 + 70 + 100 = 220.'],
   ['3 人の金額はたがいの比較で示されているので、1 人を基準にします。丙がいちばん少ないので丙を基準にします。',
    '乙は丙より 20 円多く、甲は乙より 30 円多いので、甲は丙より 20 + 30 = 50 円多くなります。',
    '乙の多い 20 円と甲の多い 50 円、合わせて 70 円を先に取りのぞくと 3 人は同額になり、残りは 220 − 70 = 150 円です。',
    '150 円を 3 等分すると 150 ÷ 3 = 50 円で、これが丙の金額です。乙はそれより 20 円多いので 50 + 20 = 70 円です。確かめると 50 + 70 + 100 = 220 です。']],
  '70', 2, 'Replaces a pure ordering-chain template question.')

replace(5, 14, 'seat_gap_count_cases',
  L('五個座位排成一列，由左到右編號 1 到 5。小明和小華各坐一個位子，兩人的座號相差 3，而且小明坐在小華的左邊。小明的座號有幾種可能？',
    '五个座位排成一列，由左到右编号 1 到 5。小明和小华各坐一个位子，两人的座号相差 3，而且小明坐在小华的左边。小明的座号有几种可能？',
    'Five seats stand in a row numbered 1 to 5 from left to right. Ming and Hua each take a seat, their seat numbers differ by 3, and Ming sits to the left of Hua. How many possible seat numbers are there for Ming?',
    '5 つの席が左から右へ 1 から 5 の番号で並んでいます。明と華が 1 席ずつすわり、2 人の席番号の差は 3 で、明は華の左側です。明の席番号は何通り考えられますか。'),
  L('答案是 2 種。', '答案是 2 种。', 'The answer is 2.', '答えは 2 通りです。'),
  [['小明在小華左邊，表示小明的座號比小華小。座號相差 3，所以小華的座號 = 小明的座號 + 3。',
    '把小明的座號從 1 開始一個一個試，看小華的座號會不會超出 1 到 5 的範圍。',
    '小明 1 號時小華 4 號，可以；小明 2 號時小華 5 號，可以；小明 3 號時小華要 6 號，但只有 5 個座位，不行。小明 4 號、5 號更不用說。',
    '所以小明的座號只有 1 號和 2 號兩種可能，答案是 2 種。'],
   ['小明在小华左边，表示小明的座号比小华小。座号相差 3，所以小华的座号 = 小明的座号 + 3。',
    '把小明的座号从 1 开始一个一个试，看小华的座号会不会超出 1 到 5 的范围。',
    '小明 1 号时小华 4 号，可以；小明 2 号时小华 5 号，可以；小明 3 号时小华要 6 号，但只有 5 个座位，不行。小明 4 号、5 号更不用说。',
    '所以小明的座号只有 1 号和 2 号两种可能，答案是 2 种。'],
   ['Ming sits to the left of Hua, so Ming\'s number is the smaller one. Since they differ by 3, Hua\'s number is Ming\'s number plus 3.',
    'Try Ming\'s seat number starting from 1 and check whether Hua\'s number stays within 1 to 5.',
    'Ming 1 gives Hua 4, which works; Ming 2 gives Hua 5, which works; Ming 3 would need Hua at 6, but there are only 5 seats, so it fails, and Ming 4 or 5 fail even more clearly.',
    'So Ming can only be in seat 1 or seat 2, giving 2 possibilities.'],
   ['明は華の左なので、明の番号のほうが小さくなります。差が 3 なので 華の番号 = 明の番号 + 3 です。',
    '明の番号を 1 から順に試し、華の番号が 1 から 5 の範囲におさまるかを見ます。',
    '明が 1 なら華は 4 で可能、明が 2 なら華は 5 で可能、明が 3 なら華は 6 が必要ですが席は 5 つしかないので不可能です。明が 4 や 5 ならなおさらです。',
    'したがって明の席は 1 番か 2 番の 2 通りです。']],
  '2', 1, 'Replaces a pure ordering-chain template question.')

replace(5, 17, 'round_robin_win_count',
  L('甲、乙、丙三支球隊互相比賽，每兩支球隊之間都比一場，而且沒有平手。已知甲贏了 2 場，丙輸了 2 場。乙贏了幾場？',
    '甲、乙、丙三支球队互相比赛，每两支球队之间都比一场，而且没有平手。已知甲赢了 2 场，丙输了 2 场。乙赢了几场？',
    'Three teams A, B and C each play every other team once, with no draws. A won 2 games and C lost 2 games. How many games did B win?',
    '甲・乙・丙 の 3 チームが総当たりで 1 回ずつ対戦し、引き分けはありません。甲は 2 勝、丙は 2 敗でした。乙は何勝しましたか。'),
  L('答案是 1 場。', '答案是 1 场。', 'The answer is 1.', '答えは 1 勝です。'),
  [['三支球隊互相比賽，一共比 3 場：甲對乙、甲對丙、乙對丙。每支球隊各比 2 場。',
    '甲贏了 2 場，而甲總共只比 2 場，表示甲把兩場都贏了，也就是甲勝乙、甲勝丙。',
    '丙輸了 2 場，丙也只比 2 場，表示丙兩場全輸，也就是丙輸給甲、丙輸給乙。',
    '三場的結果都定了：甲勝乙、甲勝丙、乙勝丙。乙只在對丙那一場獲勝，所以乙贏了 1 場。（驗算：三隊勝場數 2 + 1 + 0 = 3，剛好等於總場數。）'],
   ['三支球队互相比赛，一共比 3 场：甲对乙、甲对丙、乙对丙。每支球队各比 2 场。',
    '甲赢了 2 场，而甲总共只比 2 场，表示甲把两场都赢了，也就是甲胜乙、甲胜丙。',
    '丙输了 2 场，丙也只比 2 场，表示丙两场全输，也就是丙输给甲、丙输给乙。',
    '三场的结果都定了：甲胜乙、甲胜丙、乙胜丙。乙只在对丙那一场获胜，所以乙赢了 1 场。（验算：三队胜场数 2 + 1 + 0 = 3，刚好等于总场数。）'],
   ['With three teams playing each other once there are 3 games in all: A against B, A against C, and B against C. Each team plays 2 games.',
    'A won 2 games and A plays only 2, so A won both: A beat B and A beat C.',
    'C lost 2 games and C also plays only 2, so C lost both: C lost to A and C lost to B.',
    'All three results are now fixed: A beat B, A beat C, and B beat C. B won only the game against C, so B won 1 game. Check: the win totals 2 + 1 + 0 = 3 match the number of games.'],
   ['3 チームの総当たりでは 甲対乙、甲対丙、乙対丙 の 3 試合があり、各チームは 2 試合ずつ行います。',
    '甲は 2 勝で、甲の試合数も 2 なので、甲は 2 試合とも勝ちました。つまり甲は乙にも丙にも勝っています。',
    '丙は 2 敗で、丙の試合数も 2 なので、丙は 2 試合とも負けました。つまり丙は甲にも乙にも負けています。',
    '3 試合の結果がすべて決まりました。甲が乙に勝ち、甲が丙に勝ち、乙が丙に勝ちます。乙が勝ったのは丙戦だけなので 1 勝です。確かめると勝ち数の合計 2 + 1 + 0 = 3 で試合数と一致します。']],
  '1', 1, 'Replaces a pure ordering-chain template question.')

replace(5, 22, 'circle_skip_pass_return',
  L('5 個人圍成一圈站好。球從甲開始傳，每一次都往同一個方向傳，而且每次都跳過一個人、傳給下一個的下一個人。傳了幾次之後，球第一次回到甲手上？',
    '5 个人围成一圈站好。球从甲开始传，每一次都往同一个方向传，而且每次都跳过一个人、传给下一个的下一个人。传了几次之后，球第一次回到甲手上？',
    'Five people stand in a circle. A ball starts with A and is always passed in the same direction, each pass skipping one person and going to the person after next. After how many passes does the ball first come back to A?',
    '5 人が輪になって立ちます。ボールは甲から始まり、毎回同じ向きに、1 人とばして その次の人へわたされます。何回わたした後にボールははじめて甲にもどりますか。'),
  L('答案是 5 次。', '答案是 5 次。', 'The answer is 5.', '答えは 5 回です。'),
  [['把 5 個人依傳球方向編號 0（甲）、1、2、3、4。每傳一次，球的位置就往前 2 個號碼；數到 4 之後會繞回 0。',
    '從 0 開始一次一次追：第 1 次到 2，第 2 次到 4，第 3 次到 4 + 2 = 6，繞一圈後是 1。',
    '第 4 次到 1 + 2 = 3，第 5 次到 3 + 2 = 5，繞一圈後回到 0，也就是回到甲手上。',
    '前四次都沒有回到 0，所以第一次回到甲手上是第 5 次。（因為每次跳 2，而 2 和 5 沒有公因數，球會經過每一個人各一次才回到起點。）'],
   ['把 5 个人依传球方向编号 0（甲）、1、2、3、4。每传一次，球的位置就往前 2 个号码；数到 4 之后会绕回 0。',
    '从 0 开始一次一次追：第 1 次到 2，第 2 次到 4，第 3 次到 4 + 2 = 6，绕一圈后是 1。',
    '第 4 次到 1 + 2 = 3，第 5 次到 3 + 2 = 5，绕一圈后回到 0，也就是回到甲手上。',
    '前四次都没有回到 0，所以第一次回到甲手上是第 5 次。（因为每次跳 2，而 2 和 5 没有公因数，球会经过每一个人各一次才回到起点。）'],
   ['Number the five people 0 for A, then 1, 2, 3 and 4 in the direction of passing. Each pass moves the ball forward 2 numbers, wrapping from 4 back to 0.',
    'Follow it pass by pass from 0: the 1st pass reaches 2, the 2nd reaches 4, and the 3rd reaches 4 + 2 = 6, which wraps around to 1.',
    'The 4th pass reaches 1 + 2 = 3, and the 5th reaches 3 + 2 = 5, which wraps around to 0, back in A\'s hands.',
    'None of the first four passes returned to 0, so the ball first comes back on the 5th pass. Since each step is 2 and 2 shares no factor with 5, the ball visits every person exactly once before returning.'],
   ['5 人をわたす向きに 0（甲）、1、2、3、4 と番号づけます。1 回わたすごとに位置は 2 進み、4 の次は 0 にもどります。',
    '0 から順に追います。1 回目は 2、2 回目は 4、3 回目は 4 + 2 = 6 で一周して 1 です。',
    '4 回目は 1 + 2 = 3、5 回目は 3 + 2 = 5 で一周して 0、つまり甲にもどります。',
    '4 回目までは 0 にもどっていないので、はじめてもどるのは 5 回目です。1 回に 2 進み、2 と 5 に共通の約数がないので、ボールは全員を 1 回ずつ通ってから戻ります。']],
  '5', 1, 'Replaces a pure ordering-chain template question.')

for p, d in PACKS.items():
    for q in d['questions']:
        assert len({len(v) for v in q['solutionSteps'].values()}) == 1, q['id']
        if q['answerMode'] == 'integer_input': assert 'options' not in q, q['id']
    with io.open(p, 'w', encoding='utf-8') as f:
        json.dump(d, f, ensure_ascii=False, indent=2); f.write('\n')
    print('寫回', p)
