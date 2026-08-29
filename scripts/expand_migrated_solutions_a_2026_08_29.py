# -*- coding: utf-8 -*-
"""補強從 kangaroo56 遷移進來、審題後保留未動的 19 題詳解（第一批 014-029）。

這些題答案都驗算正確、也不重複，問題在詳解密度：繁中字數中位數只有 44 字、
多半只有 2 步，而 grade6 mixed pack 其他題是 139 字 / 3-4 步。最極端的
039 整個詳解就是「代入 n=10。3×10+2=32。」，純計算沒有任何推理說明。

補寫原則：四步、說清楚「為什麼這樣想」而不只是「算式是什麼」，
並在適當處點出常見的誤解。
"""
import json, io

P = 'assets/questions/mixed/grade6_foundation.mixed.v1.json'
d = json.load(open(P))
Q = {q['id']: q for q in d['questions']}

def steps(num, zh, zhs, en, ja):
    q = Q['mixed_grade6_foundation_%03d' % num]
    old = sum(len(s) for s in q['solutionSteps']['zh-Hant'])
    assert len(zh) == len(zhs) == len(en) == len(ja), num
    q['solutionSteps'] = {'zh-Hant': zh, 'zh-Hans': zhs, 'en': en, 'ja': ja}
    q['source']['notes'] += ' Solution steps expanded 2026-08-29 to match the pack\'s explanatory density.'
    print('%03d %-32s %3d 字 -> %3d 字，%d 步' % (num, q['subtopic'], old, sum(len(s) for s in zh), len(zh)))

steps(14,
 ['題目要排的是三位數，而且限制在 400 和 700 之間，所以先從百位下手——百位決定了這個數的大小級距。',
  '如果百位是 1，這個數最大也只有 174，小於 400，不合。如果百位是 7，這個數最小是 714，大於 700，也不合。',
  '所以百位只能是 4。剩下的 1 和 7 要放進十位和個位。',
  '兩個數字排兩個位置有 2 種放法：417 和 471。兩個都在 400 與 700 之間，所以答案是 2 個。'],
 ['题目要排的是三位数，而且限制在 400 和 700 之间，所以先从百位下手——百位决定了这个数的大小级距。',
  '如果百位是 1，这个数最大也只有 174，小于 400，不合。如果百位是 7，这个数最小是 714，大于 700，也不合。',
  '所以百位只能是 4。剩下的 1 和 7 要放进十位和个位。',
  '两个数字排两个位置有 2 种放法：417 和 471。两个都在 400 与 700 之间，所以答案是 2 个。'],
 ['The number must be a three-digit number between 400 and 700, so start with the hundreds digit, which decides the size range.',
  'If the hundreds digit were 1, the largest possible number would be 174, below 400, so that fails. If it were 7, the smallest would be 714, above 700, so that fails too.',
  'The hundreds digit must therefore be 4, leaving 1 and 7 for the tens and units places.',
  'Two digits fill two places in 2 ways, giving 417 and 471. Both lie between 400 and 700, so the answer is 2.'],
 ['3 けたの数で 400 と 700 の間という条件なので、まず大きさを決める百の位から考えます。',
  '百の位が 1 なら最大でも 174 で 400 未満、百の位が 7 なら最小でも 714 で 700 をこえるため、どちらも不適です。',
  'したがって百の位は 4 に決まり、残る 1 と 7 を十の位と一の位に入れます。',
  '2 つの数字を 2 か所に並べる方法は 2 通りで、417 と 471 です。どちらも 400 と 700 の間なので答えは 2 個です。'])

steps(15,
 ['條件有兩個：甲要緊接在乙的左邊（兩人一定相鄰），丙要在丁的左邊（不必相鄰）。兩種限制性質不同，處理方式也不同。',
  '「甲緊接在乙左邊」表示甲乙一定黏在一起、順序固定成「甲乙」。把這兩人綁成一個整體看待。',
  '這樣要排的就變成「甲乙」這一組加上丙、丁，共 3 個單位，排法有 3! = 6 種。',
  '在這 6 種當中，丙在丁左邊和丁在丙左邊的情況一樣多，各佔一半，所以符合條件的是 6 ÷ 2 = 3 種。'],
 ['条件有两个：甲要紧接在乙的左边（两人一定相邻），丙要在丁的左边（不必相邻）。两种限制性质不同，处理方式也不同。',
  '「甲紧接在乙左边」表示甲乙一定黏在一起、顺序固定成「甲乙」。把这两人绑成一个整体看待。',
  '这样要排的就变成「甲乙」这一组加上丙、丁，共 3 个单位，排法有 3! = 6 种。',
  '在这 6 种当中，丙在丁左边和丁在丙左边的情况一样多，各占一半，所以符合条件的是 6 ÷ 2 = 3 种。'],
 ['There are two conditions: A must be immediately to the left of B, so they are adjacent, while C must be somewhere to the left of D, not necessarily adjacent. The two restrictions are different in kind and are handled differently.',
  'Immediately to the left means A and B are stuck together in the fixed order A then B, so treat the pair as a single block.',
  'The things to arrange are then that block plus C and D, which is 3 units, giving 3! = 6 orders.',
  'Among those 6, the arrangements with C left of D and those with D left of C are equally many, so exactly half qualify: 6 ÷ 2 = 3.'],
 ['条件は 2 つあります。甲は乙のすぐ左（必ずとなり合う）、丙は丁より左（となり合わなくてよい）です。性質がちがうので扱い方も変えます。',
  '「すぐ左」ということは甲と乙はくっついていて、順序も「甲乙」に固定されます。この 2 人を 1 つのかたまりとして考えます。',
  'すると並べるのは そのかたまりと丙・丁 の 3 単位となり、3! = 6 通りです。',
  'この 6 通りのうち、丙が丁より左のものと丁が丙より左のものはちょうど同数なので、条件に合うのは 6 ÷ 2 = 3 通りです。'])

steps(16,
 ['圖形的邊界包含兩個部分：外側的大輪廓，以及中央被挖掉之後留下的那個洞的輪廓。兩邊都要算。',
  '外側的大輪廓還是原本 3×3 正方形的四條邊，每邊長 3，所以有 3 × 4 = 12 條長度為 1 的小邊。',
  '中央被挖掉的那一格是 1×1 的小正方形，它的四條邊現在都變成了圖形的邊界。',
  '把兩部分加起來：12 + 4 = 16 條。（只算外側得到 12 是漏掉了洞；洞的邊也是紙的邊緣。）'],
 ['图形的边界包含两个部分：外侧的大轮廓，以及中央被挖掉之后留下的那个洞的轮廓。两边都要算。',
  '外侧的大轮廓还是原本 3×3 正方形的四条边，每边长 3，所以有 3 × 4 = 12 条长度为 1 的小边。',
  '中央被挖掉的那一格是 1×1 的小正方形，它的四条边现在都变成了图形的边界。',
  '把两部分加起来：12 + 4 = 16 条。（只算外侧得到 12 是漏掉了洞；洞的边也是纸的边缘。）'],
 ['The boundary of the figure has two parts: the outer outline, and the outline of the hole left where the middle cell was removed. Both must be counted.',
  'The outer outline is still the four sides of the original 3 by 3 square, each 3 units long, giving 3 × 4 = 12 unit edges.',
  'The removed middle cell is a 1 by 1 square, and its four sides have now become boundary of the figure as well.',
  'Adding the two parts gives 12 + 4 = 16 unit edges. Counting only the outside gives 12 and misses the hole, whose edges are also edges of the paper.'],
 ['図形の境界は 2 つの部分からなります。外側の輪郭と、中央のマスを取りのぞいてできた穴の輪郭です。どちらも数えます。',
  '外側の輪郭はもとの 3 × 3 の正方形の 4 辺のままで、1 辺の長さが 3 なので 3 × 4 = 12 本の長さ 1 の辺があります。',
  '取りのぞいた中央のマスは 1 × 1 の正方形で、その 4 辺が今は図形の境界になっています。',
  '合わせて 12 + 4 = 16 本です。外側だけ数えて 12 とするのは穴を見落としており、穴のふちも紙のふちです。'])

steps(20,
 ['這一題要用的是「重疊部分被算了兩次」這個關係，所以先分別算出兩個長方形各自的面積。',
  '第一個長方形是 7 × 5 = 35，第二個是 6 × 4 = 24。',
  '把兩個面積直接相加得到 35 + 24 = 59。但重疊的那一塊同時屬於兩個長方形，在這個 59 裡面被算了兩次。',
  '題目說合起來的面積（重疊只算一次）是 47，多算出來的部分就是重疊面積：59 − 47 = 12。'],
 ['这一题要用的是「重叠部分被算了两次」这个关系，所以先分别算出两个长方形各自的面积。',
  '第一个长方形是 7 × 5 = 35，第二个是 6 × 4 = 24。',
  '把两个面积直接相加得到 35 + 24 = 59。但重叠的那一块同时属于两个长方形，在这个 59 里面被算了两次。',
  '题目说合起来的面积（重叠只算一次）是 47，多算出来的部分就是重叠面积：59 − 47 = 12。'],
 ['The key relation here is that the overlap gets counted twice, so start by finding each rectangle\'s own area.',
  'The first rectangle is 7 × 5 = 35 and the second is 6 × 4 = 24.',
  'Adding those gives 35 + 24 = 59. But the overlapping piece belongs to both rectangles and has been counted twice inside that 59.',
  'The problem says the combined area, counting the overlap once, is 47, so the excess is exactly the overlap: 59 − 47 = 12.'],
 ['この問題のかぎは「重なった部分が 2 回数えられる」という関係なので、まず 2 つの長方形の面積をそれぞれ求めます。',
  '1 つ目は 7 × 5 = 35、2 つ目は 6 × 4 = 24 です。',
  'そのまま足すと 35 + 24 = 59 ですが、重なった部分は両方の長方形に属するため、この 59 の中で 2 回数えられています。',
  '重なりを 1 回だけ数えた合計が 47 なので、多く数えた分がそのまま重なりの面積です。59 − 47 = 12 です。'])

steps(21,
 ['三個人之中恰好有一個是第一名，所以直接把三種可能一個一個試過去，看哪一種剛好只有一句真話。',
  '如果甲是第一名：甲說「我不是第一名」是假話；乙說「甲是第一名」是真話；丙說「乙說的是假話」，但乙說的是真話，所以丙這句是假話。真話剛好 1 句，符合。',
  '如果乙是第一名：甲的話是真的；乙說「甲是第一名」是假的；丙說「乙說謊」是真的。真話有 2 句，不符合。',
  '如果丙是第一名：情況和乙一樣，甲和丙的話都是真的，也是 2 句。所以只有甲是第一名這一種成立，答案是甲。'],
 ['三个人之中恰好有一个是第一名，所以直接把三种可能一个一个试过去，看哪一种刚好只有一句真话。',
  '如果甲是第一名：甲说「我不是第一名」是假话；乙说「甲是第一名」是真话；丙说「乙说的是假话」，但乙说的是真话，所以丙这句是假话。真话刚好 1 句，符合。',
  '如果乙是第一名：甲的话是真的；乙说「甲是第一名」是假的；丙说「乙说谎」是真的。真话有 2 句，不符合。',
  '如果丙是第一名：情况和乙一样，甲和丙的话都是真的，也是 2 句。所以只有甲是第一名这一种成立，答案是甲。'],
 ['Exactly one of the three is first, so simply test each of the three possibilities and see which leaves exactly one true statement.',
  'If A is first: A\'s claim "I am not first" is false; B\'s claim "A is first" is true; C\'s claim "B is lying" is false because B was telling the truth. That is exactly 1 true statement, which fits.',
  'If B is first: A\'s statement is true; B\'s claim that A is first is false; C\'s claim that B is lying is true. That is 2 true statements, which does not fit.',
  'If C is first: the situation matches B\'s case, with both A and C speaking truly, again 2 true statements. Only A being first works, so the answer is A.'],
 ['1 位はちょうど 1 人なので、3 通りを 1 つずつ試し、本当の発言がちょうど 1 つになるのはどれかを調べます。',
  '甲が 1 位のとき、甲の「1 位ではない」はうそ、乙の「甲が 1 位」は本当、丙の「乙はうそをついている」は乙が本当を言っているのでうそです。本当は 1 つでちょうど条件に合います。',
  '乙が 1 位のとき、甲の発言は本当、乙の「甲が 1 位」はうそ、丙の「乙はうそ」は本当で、本当が 2 つになり合いません。',
  '丙が 1 位のときも乙の場合と同じく甲と丙が本当で 2 つです。したがって成り立つのは甲が 1 位の場合だけで、答えは甲です。'])

steps(23,
 ['題目給的三個條件都是「兩個砝碼合起來的重量」，沒有任何一個單獨砝碼的重量，所以不能直接讀出答案。',
  '注意每一個砝碼在三個式子中都恰好出現了兩次：甲出現在「甲乙」和「甲丙」，乙出現在「甲乙」和「乙丙」，丙出現在「乙丙」和「甲丙」。',
  '所以把三個式子全部加起來，等於把三個砝碼各算兩次：11 + 13 + 14 = 38，也就是 2 ×（甲 + 乙 + 丙）= 38，三個砝碼總重是 19。',
  '要求丙，就把總重扣掉不含丙的那個式子：丙 = 19 − 甲乙 = 19 − 11 = 8。'],
 ['题目给的三个条件都是「两个砝码合起来的重量」，没有任何一个单独砝码的重量，所以不能直接读出答案。',
  '注意每一个砝码在三个式子中都恰好出现了两次：甲出现在「甲乙」和「甲丙」，乙出现在「甲乙」和「乙丙」，丙出现在「乙丙」和「甲丙」。',
  '所以把三个式子全部加起来，等于把三个砝码各算两次：11 + 13 + 14 = 38，也就是 2 ×（甲 + 乙 + 丙）= 38，三个砝码总重是 19。',
  '要求丙，就把总重扣掉不含丙的那个式子：丙 = 19 − 甲乙 = 19 − 11 = 8。'],
 ['All three given facts are about the combined weight of two weights, and none gives a single weight on its own, so the answer cannot be read off directly.',
  'Notice that each weight appears in exactly two of the three equations: A in "A and B" and "A and C", B in "A and B" and "B and C", C in "B and C" and "A and C".',
  'So adding all three equations counts each weight twice: 11 + 13 + 14 = 38, that is 2 × (A + B + C) = 38, so the three weights total 19.',
  'To find C, subtract the equation that does not contain it: C = 19 − (A and B) = 19 − 11 = 8.'],
 ['与えられた 3 つの条件はどれも「おもり 2 つ分の重さ」で、1 つだけの重さは示されていないため、答えをそのまま読み取ることはできません。',
  '各おもりが 3 つの式にちょうど 2 回ずつ現れることに注目します。甲は「甲乙」と「甲丙」、乙は「甲乙」と「乙丙」、丙は「乙丙」と「甲丙」です。',
  'したがって 3 つの式をすべて足すと各おもりを 2 回ずつ数えたことになり、11 + 13 + 14 = 38、つまり 2 ×（甲 + 乙 + 丙）= 38 で、3 つの合計は 19 です。',
  '丙を求めるには、丙をふくまない式を合計から引きます。丙 = 19 − 甲乙 = 19 − 11 = 8 です。'])

steps(25,
 ['題目給的是周長和面積，要反推出長和寬。先把周長換成比較好用的形式。',
  '長方形的周長是（長 + 寬）的 2 倍，所以長 + 寬 = 30 ÷ 2 = 15 公分。',
  '現在條件變成：兩個數相加是 15、相乘是 56。可以從 56 的因數對逐一試：1 和 56、2 和 28、4 和 14、7 和 8。',
  '其中相加等於 15 的只有 7 和 8。所以長方形是 8 公分乘 7 公分，較長的邊是 8 公分。'],
 ['题目给的是周长和面积，要反推出长和宽。先把周长换成比较好用的形式。',
  '长方形的周长是（长 + 宽）的 2 倍，所以长 + 宽 = 30 ÷ 2 = 15 厘米。',
  '现在条件变成：两个数相加是 15、相乘是 56。可以从 56 的因数对逐一试：1 和 56、2 和 28、4 和 14、7 和 8。',
  '其中相加等于 15 的只有 7 和 8。所以长方形是 8 厘米乘 7 厘米，较长的边是 8 厘米。'],
 ['The perimeter and the area are given and the length and width must be recovered, so first turn the perimeter into a more usable form.',
  'A rectangle\'s perimeter is twice the length plus width, so length + width = 30 ÷ 2 = 15 cm.',
  'The conditions are now that two numbers add to 15 and multiply to 56. Run through the factor pairs of 56: 1 and 56, 2 and 28, 4 and 14, 7 and 8.',
  'Only 7 and 8 add to 15, so the rectangle is 8 cm by 7 cm and the longer side is 8 cm.'],
 ['まわりの長さと面積が与えられていて、たてとよこを求めます。まず まわりの長さを使いやすい形に直します。',
  '長方形のまわりの長さは（たて + よこ）の 2 倍なので、たて + よこ = 30 ÷ 2 = 15 cm です。',
  '条件は「足すと 15、かけると 56 になる 2 数」となりました。56 の約数の組を順に試します。1 と 56、2 と 28、4 と 14、7 と 8 です。',
  '足して 15 になるのは 7 と 8 だけです。したがって長方形は 8 cm × 7 cm で、長いほうの辺は 8 cm です。'])

steps(26,
 ['先不管限制，算出六個人如果全部互相握手會握幾次，再把不能握的扣掉。',
  '每個人都要和另外 5 個人握手，六個人一共是 6 × 5 = 30；但每一次握手都被兩個當事人各算了一次，所以要除以 2。',
  '完全握手的次數是 30 ÷ 2 = 15 次。',
  '有三對朋友不能握手，也就是要從這 15 次裡扣掉 3 次：15 − 3 = 12 次。'],
 ['先不管限制，算出六个人如果全部互相握手会握几次，再把不能握的扣掉。',
  '每个人都要和另外 5 个人握手，六个人一共是 6 × 5 = 30；但每一次握手都被两个当事人各算了一次，所以要除以 2。',
  '完全握手的次数是 30 ÷ 2 = 15 次。',
  '有三对朋友不能握手，也就是要从这 15 次里扣掉 3 次：15 − 3 = 12 次。'],
 ['Ignore the restriction at first and count how many handshakes six people would make if everyone shook hands with everyone, then subtract the forbidden ones.',
  'Each person shakes hands with the other 5, giving 6 × 5 = 30; but every handshake has been counted once by each of the two people involved, so divide by 2.',
  'The unrestricted total is 30 ÷ 2 = 15 handshakes.',
  'Three pairs cannot shake hands, so remove 3 from those 15: 15 − 3 = 12 handshakes.'],
 ['まず制限を無視し、6 人全員がたがいにあくしゅしたら何回になるかを求め、それから禁止された分を引きます。',
  '各人は他の 5 人とあくしゅするので 6 × 5 = 30 ですが、1 回のあくしゅは当事者 2 人それぞれで数えられているので 2 でわります。',
  '制限なしの回数は 30 ÷ 2 = 15 回です。',
  'あくしゅできない組が 3 組あるので、15 回から 3 回引いて 15 − 3 = 12 回です。'])

steps(27,
 ['先把「十位比個位大 5」的兩位數全部列出來，這樣的數不多，可以直接窮舉。',
  '個位從 0 開始配對：50、61、72、83、94，一共 5 個候選。',
  '接著檢查倒過來的數能不能被 9 整除。判斷 9 的倍數看數字和就好，而倒過來不會改變數字和，所以直接看原數的數字和是不是 9 的倍數。',
  '五個候選的數字和依序是 5、7、9、11、13，只有 72 的數字和 9 是 9 的倍數。驗算：72 倒過來是 27，27 ÷ 9 = 3，確實整除。答案是 72。'],
 ['先把「十位比个位大 5」的两位数全部列出来，这样的数不多，可以直接穷举。',
  '个位从 0 开始配对：50、61、72、83、94，一共 5 个候选。',
  '接着检查倒过来的数能不能被 9 整除。判断 9 的倍数看数字和就好，而倒过来不会改变数字和，所以直接看原数的数字和是不是 9 的倍数。',
  '五个候选的数字和依次是 5、7、9、11、13，只有 72 的数字和 9 是 9 的倍数。验算：72 倒过来是 27，27 ÷ 9 = 3，确实整除。答案是 72。'],
 ['First list every two-digit number whose tens digit is 5 more than its units digit; there are few enough to write them all out.',
  'Starting from a units digit of 0 gives 50, 61, 72, 83 and 94, five candidates in all.',
  'Now check which reversals are divisible by 9. Divisibility by 9 depends only on the digit sum, and reversing a number does not change its digit sum, so it is enough to test the digit sum of the original.',
  'The five digit sums are 5, 7, 9, 11 and 13, and only 72 has a digit sum of 9, a multiple of 9. Check: reversing 72 gives 27, and 27 ÷ 9 = 3. The answer is 72.'],
 ['まず「十の位が一の位より 5 大きい」2 けたの数をすべて書き出します。数が少ないので全部挙げられます。',
  '一の位を 0 から順に組にすると 50、61、72、83、94 の 5 個が候補です。',
  '次に、逆さにした数が 9 でわり切れるかを調べます。9 の倍数の判定は各位の和だけで決まり、逆さにしても和は変わらないので、もとの数の各位の和を見れば十分です。',
  '5 つの候補の各位の和は順に 5、7、9、11、13 で、9 の倍数は 72 の 9 だけです。確かめると 72 を逆さにした 27 は 27 ÷ 9 = 3 でわり切れます。答えは 72 です。'])

steps(28,
 ['題目問的是「相差幾公克」，不是各自的重量，所以不一定要把正方體和球的重量分別解出來。',
  '把兩個條件並排寫：2 個正方體 + 1 個球 = 17；1 個正方體 + 2 個球 = 16。',
  '兩式相減。左邊：正方體從 2 個變 1 個剩下 1 個，球從 1 個變 2 個少了 1 個，也就是「1 個正方體 − 1 個球」。右邊：17 − 16 = 1。',
  '所以正方體比球重 1 公克，相差就是 1 公克。（想完整解也可以：兩式相加得 3 個正方體 + 3 個球 = 33，各 11；再配合相減得正方體 6、球 5，差確實是 1。）'],
 ['题目问的是「相差几克」，不是各自的重量，所以不一定要把正方体和球的重量分别解出来。',
  '把两个条件并排写：2 个正方体 + 1 个球 = 17；1 个正方体 + 2 个球 = 16。',
  '两式相减。左边：正方体从 2 个变 1 个剩下 1 个，球从 1 个变 2 个少了 1 个，也就是「1 个正方体 − 1 个球」。右边：17 − 16 = 1。',
  '所以正方体比球重 1 克，相差就是 1 克。（想完整解也可以：两式相加得 3 个正方体 + 3 个球 = 33，各 11；再配合相减得正方体 6、球 5，差确实是 1。）'],
 ['The question asks for the difference in weight, not for each weight separately, so there is no need to solve for both.',
  'Write the two facts side by side: 2 cubes + 1 ball = 17, and 1 cube + 2 balls = 16.',
  'Subtract the second from the first. On the left, the cubes drop from 2 to 1 leaving 1 cube, and the balls go from 1 to 2 leaving minus 1 ball, so the left side is 1 cube minus 1 ball. On the right, 17 − 16 = 1.',
  'So a cube is 1 gram heavier than a ball, and the difference is 1 gram. Solving fully also works: adding the two gives 3 cubes + 3 balls = 33, so a cube and a ball together weigh 11; combined with the difference this gives a cube 6 and a ball 5, a difference of 1.'],
 ['問われているのは「重さの差」であって それぞれの重さではないので、両方を求める必要はありません。',
  '2 つの条件を並べて書きます。立方体 2 個 + 球 1 個 = 17、立方体 1 個 + 球 2 個 = 16 です。',
  '1 つ目から 2 つ目を引きます。左辺は立方体が 2 個から 1 個になって 1 個分、球が 1 個から 2 個になって −1 個分、つまり「立方体 1 個 − 球 1 個」です。右辺は 17 − 16 = 1 です。',
  'したがって立方体は球より 1 g 重く、差は 1 g です。完全に解くこともできます。2 式を足すと立方体 3 個 + 球 3 個 = 33 で 1 個ずつの和は 11、差と合わせて立方体 6、球 5 となり差はやはり 1 です。'])

steps(29,
 ['三個人選三種不同顏色，所以一旦有人的顏色確定了，其他人的選擇範圍就會跟著縮小。從最確定的條件開始。',
  '題目直接說丙選藍色，這是唯一沒有「不」字的條件，先用它。藍色被丙拿走，剩下紅色和綠色分給甲和乙。',
  '再看乙：乙不選綠色，而現在乙只剩紅色和綠色可選，所以乙只能選紅色。',
  '剩下的綠色就是甲的，這也和「甲不選紅」相符，三個條件都成立。所以選紅色的是乙。'],
 ['三个人选三种不同颜色，所以一旦有人的颜色确定了，其他人的选择范围就会跟着缩小。从最确定的条件开始。',
  '题目直接说丙选蓝色，这是唯一没有「不」字的条件，先用它。蓝色被丙拿走，剩下红色和绿色分给甲和乙。',
  '再看乙：乙不选绿色，而现在乙只剩红色和绿色可选，所以乙只能选红色。',
  '剩下的绿色就是甲的，这也和「甲不选红」相符，三个条件都成立。所以选红色的是乙。'],
 ['Three people pick three different colours, so as soon as one person\'s colour is fixed the others\' options shrink. Start with the most definite condition.',
  'The problem states outright that C picks blue, the only condition without a "not", so use it first. With blue taken by C, red and green remain for A and B.',
  'Now B: B does not pick green, and green and red are the only colours left for B, so B must pick red.',
  'Green is then left for A, which also fits the condition that A does not pick red, so all three conditions hold. The one who picks red is B.'],
 ['3 人が 3 つのちがう色を選ぶので、だれかの色が決まると 他の人の選べる範囲もせまくなります。いちばんはっきりした条件から始めます。',
  '問題文は丙が青を選ぶと言い切っており、「〜ない」を含まない唯一の条件なのでこれを先に使います。青は丙のものになり、赤と緑が甲と乙に残ります。',
  '次に乙です。乙は緑を選ばず、残っているのは赤と緑だけなので、乙は赤を選ぶしかありません。',
  '残る緑は甲のもので、これは「甲は赤を選ばない」とも矛盾しません。3 つの条件がすべて成り立ち、赤を選んだのは乙です。'])

for q in d['questions']:
    assert len({len(v) for v in q['solutionSteps'].values()}) == 1, q['id']
with io.open(P, 'w', encoding='utf-8') as f:
    json.dump(d, f, ensure_ascii=False, indent=2); f.write('\n')
print('\n已寫回', P)
