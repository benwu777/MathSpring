# -*- coding: utf-8 -*-
"""補強遷移題詳解（第二批 030-041）。續 expand_migrated_solutions_a。"""
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

steps(30,
 ['數這種題目容易漏掉大的那些，所以要按照正方形的大小分類，一種尺寸一種尺寸地數。',
  '先數 1×1 的：整個圖形就是由四個這樣的小正方形拼成的，所以有 4 個。',
  '再數 2×2 的：整個 2×2 方格本身就是一個邊長 2 的正方形，有 1 個。',
  '圖形只有 2 格寬，不可能有更大的正方形。把兩種尺寸加起來：4 + 1 = 5 個。（只答 4 是漏掉了最外面那個大的。）'],
 ['数这种题目容易漏掉大的那些，所以要按照正方形的大小分类，一种尺寸一种尺寸地数。',
  '先数 1×1 的：整个图形就是由四个这样的小正方形拼成的，所以有 4 个。',
  '再数 2×2 的：整个 2×2 方格本身就是一个边长 2 的正方形，有 1 个。',
  '图形只有 2 格宽，不可能有更大的正方形。把两种尺寸加起来：4 + 1 = 5 个。（只答 4 是漏掉了最外面那个大的。）'],
 ['It is easy to miss the larger squares in this kind of counting, so work through the sizes one at a time.',
  'Count the 1 by 1 squares first: the whole figure is made of four of them, so there are 4.',
  'Now the 2 by 2 squares: the whole grid is itself a square of side 2, so there is 1.',
  'The figure is only 2 cells wide, so no larger square is possible. Adding the two sizes gives 4 + 1 = 5. Answering 4 misses the large outer square.'],
 ['この種の数え方では大きいものを見落としがちなので、正方形の大きさごとに分けて数えます。',
  'まず 1 × 1 を数えます。図形全体がこの小さい正方形 4 つでできているので 4 個です。',
  '次に 2 × 2 を数えます。全体そのものが 1 辺 2 の正方形なので 1 個です。',
  '図形の幅は 2 マスしかないので、これより大きい正方形はありません。合わせて 4 + 1 = 5 個です。4 と答えるのは いちばん外の大きい正方形を数え落としています。'])

steps(32,
 ['按照 3 元硬幣用了幾枚來分類，一種一種檢查，這樣才不會重複也不會遺漏。',
  '先注意一件事：12 元是偶數，2 元硬幣湊出來的一定是偶數，所以 3 元硬幣湊出來的部分也必須是偶數，也就是 3 元硬幣的枚數必須是偶數。',
  '偶數且不超過 4 枚（因為 3 × 6 = 18 已超過 12）的可能是 0、2、4 枚。',
  '3 元用 0 枚時，剩 12 元要用 2 元湊，是 6 枚；用 2 枚時剩 6 元，是 3 枚；用 4 枚時剩 0 元，是 0 枚。三種都成立，所以共有 3 種。'],
 ['按照 3 元硬币用了几枚来分类，一种一种检查，这样才不会重复也不会遗漏。',
  '先注意一件事：12 元是偶数，2 元硬币凑出来的一定是偶数，所以 3 元硬币凑出来的部分也必须是偶数，也就是 3 元硬币的枚数必须是偶数。',
  '偶数且不超过 4 枚（因为 3 × 6 = 18 已超过 12）的可能是 0、2、4 枚。',
  '3 元用 0 枚时，剩 12 元要用 2 元凑，是 6 枚；用 2 枚时剩 6 元，是 3 枚；用 4 枚时剩 0 元，是 0 枚。三种都成立，所以共有 3 种。'],
 ['Organise the count by how many 3-dollar coins are used, checking one case at a time so that nothing is repeated or missed.',
  'First notice this: 12 is even and any amount made from 2-dollar coins is even, so the part made from 3-dollar coins must be even too, which means the number of 3-dollar coins must be even.',
  'Even numbers of coins that do not exceed the total, since 3 × 6 = 18 is already more than 12, are 0, 2 and 4.',
  'With no 3-dollar coins, the remaining 12 needs 6 two-dollar coins; with 2 of them, the remaining 6 needs 3; with 4 of them, nothing remains and 0 are needed. All three work, so there are 3 combinations.'],
 ['3 円玉を何枚使うかで場合分けし、1 つずつ調べます。こうすると重複ももれもありません。',
  'まず気づくべき点があります。12 円は偶数で、2 円玉で作る額は必ず偶数なので、3 円玉で作る部分も偶数、つまり 3 円玉の枚数は偶数でなければなりません。',
  '3 × 6 = 18 はすでに 12 をこえるので、偶数で可能なのは 0、2、4 枚です。',
  '3 円玉 0 枚なら残り 12 円を 2 円玉 6 枚で、2 枚なら残り 6 円を 3 枚で、4 枚なら残り 0 円で 0 枚です。3 つとも成り立つので 3 通りです。'])

steps(34,
 ['年齡問題要分清楚兩件事：年齡本身每年都會變，但兩個人的年齡差不會變。',
  '先算今年的年齡差：25 − 15 = 10 歲，這就是第一個問題的答案。',
  '五年後，姐姐是 25 + 5 = 30 歲，妹妹是 15 + 5 = 20 歲。兩個人都各增加了 5 歲。',
  '五年後的年齡差是 30 − 20 = 10 歲，和今年一樣。因為兩人每年都同時加一歲，多出來的部分互相抵消，所以年齡差永遠是 10。'],
 ['年龄问题要分清楚两件事：年龄本身每年都会变，但两个人的年龄差不会变。',
  '先算今年的年龄差：25 − 15 = 10 岁，这就是第一个问题的答案。',
  '五年后，姐姐是 25 + 5 = 30 岁，妹妹是 15 + 5 = 20 岁。两个人都各增加了 5 岁。',
  '五年后的年龄差是 30 − 20 = 10 岁，和今年一样。因为两人每年都同时加一岁，多出来的部分互相抵消，所以年龄差永远是 10。'],
 ['Age problems turn on one distinction: ages themselves change every year, but the difference between two people\'s ages does not.',
  'This year the difference is 25 − 15 = 10 years, which answers the first question.',
  'In five years the elder sister will be 25 + 5 = 30 and the younger will be 15 + 5 = 20, each having gained the same 5 years.',
  'The difference then is 30 − 20 = 10 years, the same as now. Because both gain a year at the same time, the increases cancel and the gap stays 10 forever.'],
 ['年齢の問題では 1 つの区別が大切です。年齢そのものは毎年変わりますが、2 人の年齢の差は変わりません。',
  '今年の差は 25 − 15 = 10 歳で、これが 1 つ目の問いの答えです。',
  '5 年後、姉は 25 + 5 = 30 歳、妹は 15 + 5 = 20 歳で、どちらも同じ 5 歳分ふえています。',
  'そのときの差は 30 − 20 = 10 歳で今年と同じです。2 人が同時に 1 歳ずつふえるので増えた分が打ち消し合い、差はずっと 10 のままです。'])

steps(35,
 ['星期是 7 天一循環，所以要算的是「經過了幾天」，再看這個天數除以 7 的餘數。',
  '從這個月的第 1 天到第 31 天，中間經過的是 31 − 1 = 30 天，不是 31 天。',
  '30 ÷ 7 = 4 餘 2，表示整整過了 4 個星期又多 2 天。整整幾個星期不會改變星期幾，所以最後一天是第一天往後推 2 天。',
  '第一天是星期二，往後 2 天是星期四。依題目的記法星期日 = 1、星期一 = 2、星期二 = 3、星期三 = 4、星期四 = 5，所以代號是 5。'],
 ['星期是 7 天一循环，所以要算的是「经过了几天」，再看这个天数除以 7 的余数。',
  '从这个月的第 1 天到第 31 天，中间经过的是 31 − 1 = 30 天，不是 31 天。',
  '30 ÷ 7 = 4 余 2，表示整整过了 4 个星期又多 2 天。整整几个星期不会改变星期几，所以最后一天是第一天往后推 2 天。',
  '第一天是星期二，往后 2 天是星期四。依题目的记法星期日 = 1、星期一 = 2、星期二 = 3、星期三 = 4、星期四 = 5，所以代号是 5。'],
 ['Days of the week repeat every 7 days, so the thing to work out is how many days pass, and then the remainder when that is divided by 7.',
  'From day 1 to day 31 of the month, the number of days that pass is 31 − 1 = 30, not 31.',
  '30 ÷ 7 = 4 remainder 2, so exactly 4 whole weeks pass plus 2 extra days. Whole weeks do not change the day of the week, so the last day is 2 days after the first.',
  'The first day is Tuesday, and 2 days later is Thursday. Using the problem\'s coding of Sunday = 1, Monday = 2, Tuesday = 3, Wednesday = 4, Thursday = 5, the code is 5.'],
 ['曜日は 7 日ごとにくり返すので、求めるのは「何日たったか」と、それを 7 でわったあまりです。',
  'その月の 1 日目から 31 日目までにたつのは 31 − 1 = 30 日で、31 日ではありません。',
  '30 ÷ 7 = 4 あまり 2 なので、ちょうど 4 週間と 2 日たったことになります。まるまる何週間かは曜日を変えないので、最終日は 1 日目の 2 日後です。',
  '1 日目が火曜なので 2 日後は木曜です。問題の記号では 日曜 = 1、月曜 = 2、火曜 = 3、水曜 = 4、木曜 = 5 なので、答えは 5 です。'])

steps(36,
 ['摺紙打洞的關鍵是：摺好之後打一個洞，會同時穿過所有疊在一起的紙層，每一層都會留下一個洞。',
  '所以要算的其實是「摺完之後有幾層紙」。一開始是 1 層。',
  '沿第一條中線對摺一次，紙變成 2 層；再沿另一條互相垂直的中線對摺一次，每一層又各被摺成兩層，變成 2 × 2 = 4 層。',
  '打一個洞會穿過這 4 層，攤開後每層各有一個洞，所以一共有 4 個洞。（它們會對稱地分布在正方形的四個象限中。）'],
 ['折纸打洞的关键是：折好之后打一个洞，会同时穿过所有叠在一起的纸层，每一层都会留下一个洞。',
  '所以要算的其实是「折完之后有几层纸」。一开始是 1 层。',
  '沿第一条中线对折一次，纸变成 2 层；再沿另一条互相垂直的中线对折一次，每一层又各被折成两层，变成 2 × 2 = 4 层。',
  '打一个洞会穿过这 4 层，摊开后每层各有一个洞，所以一共有 4 个洞。（它们会对称地分布在正方形的四个象限中。）'],
 ['The key to folding-and-punching problems is that one punch goes through every layer stacked underneath, leaving a hole in each of them.',
  'So what really has to be counted is the number of layers after folding. It starts at 1.',
  'Folding along the first centre line makes 2 layers; folding again along the perpendicular centre line splits each of those in two, giving 2 × 2 = 4 layers.',
  'One punch passes through all 4 layers, so opening the paper out reveals 4 holes, arranged symmetrically one in each quarter of the square.'],
 ['紙を折って穴をあける問題のかぎは、1 回の穴あけが重なったすべての層をつらぬき、どの層にも穴が残るという点です。',
  'したがって実際に数えるべきは「折り終わったあと何層あるか」です。はじめは 1 層です。',
  '1 本目の中央線で折ると 2 層になり、それと垂直なもう 1 本の中央線で折ると各層がさらに 2 つに分かれて 2 × 2 = 4 層になります。',
  '1 回の穴あけがこの 4 層をつらぬくので、開くと穴は 4 個あり、正方形の 4 つの部分に対称に並びます。'])

steps(37,
 ['兩位數有 90 個，一個一個數太慢，改成按十位數字分類，每一類算出個位有幾種選擇。',
  '如果十位是 d，個位必須比 d 小，可以是 0、1、⋯、d − 1，一共 d 種選擇。',
  '十位不能是 0，所以 d 從 1 數到 9，對應的個位選擇數依序是 1、2、3、⋯、9。',
  '把它們全部加起來：1 + 2 + ⋯ + 9。用頭尾配對來算，(1 + 9) + (2 + 8) + (3 + 7) + (4 + 6) = 40，再加中間的 5，總共 45 個。'],
 ['两位数有 90 个，一个一个数太慢，改成按十位数字分类，每一类算出个位有几种选择。',
  '如果十位是 d，个位必须比 d 小，可以是 0、1、⋯、d − 1，一共 d 种选择。',
  '十位不能是 0，所以 d 从 1 数到 9，对应的个位选择数依次是 1、2、3、⋯、9。',
  '把它们全部加起来：1 + 2 + ⋯ + 9。用头尾配对来算，(1 + 9) + (2 + 8) + (3 + 7) + (4 + 6) = 40，再加中间的 5，总共 45 个。'],
 ['There are 90 two-digit numbers, too many to check one by one, so group them by their tens digit and count the choices for the units digit in each group.',
  'If the tens digit is d, the units digit must be smaller, so it can be 0, 1, and so on up to d − 1, giving d choices.',
  'The tens digit cannot be 0, so d runs from 1 to 9 and the numbers of choices run 1, 2, 3, and so on up to 9.',
  'Adding them all: 1 + 2 + … + 9. Pairing the ends gives (1 + 9) + (2 + 8) + (3 + 7) + (4 + 6) = 40, plus the middle 5, for a total of 45.'],
 ['2 けたの数は 90 個あり 1 つずつ数えるのは大変なので、十の位ごとに分け、それぞれ一の位の選び方を数えます。',
  '十の位が d なら、一の位はそれより小さくなければならず 0、1、……、d − 1 の d 通りです。',
  '十の位は 0 になれないので d は 1 から 9 まで動き、選び方の数は順に 1、2、3、……、9 です。',
  'すべて足すと 1 + 2 + … + 9 です。両はしを組にすると (1 + 9) + (2 + 8) + (3 + 7) + (4 + 6) = 40、これに真ん中の 5 を足して合計 45 個です。'])

steps(39,
 ['題目描述的是一個「規則」：不管輸入什麼數，都先把它乘以 3，再加上 2。',
  '這裡的 3n 是「3 乘以 n」的簡寫，所以輸入 10 時，先算 3 × 10 = 30。',
  '接著再加上 2：30 + 2 = 32。',
  '要注意運算順序是先乘後加，不能先把 10 加 2 再乘 3——那樣會得到 (10 + 2) × 3 = 36，是錯的。答案是 32。'],
 ['题目描述的是一个「规则」：不管输入什么数，都先把它乘以 3，再加上 2。',
  '这里的 3n 是「3 乘以 n」的简写，所以输入 10 时，先算 3 × 10 = 30。',
  '接着再加上 2：30 + 2 = 32。',
  '要注意运算顺序是先乘后加，不能先把 10 加 2 再乘 3——那样会得到 (10 + 2) × 3 = 36，是错的。答案是 32。'],
 ['The problem describes a rule: whatever number goes in, it is first multiplied by 3 and then 2 is added.',
  'Here 3n is shorthand for 3 times n, so with an input of 10 the first step is 3 × 10 = 30.',
  'Then add the 2: 30 + 2 = 32.',
  'The order matters, multiplication before addition. Adding 2 to 10 first and then multiplying by 3 would give (10 + 2) × 3 = 36, which is wrong. The answer is 32.'],
 ['問題が述べているのは「決まり」です。どんな数を入れても、まず 3 をかけ、そのあと 2 を足します。',
  'ここで 3n は「3 × n」の略なので、10 を入れるとまず 3 × 10 = 30 です。',
  '次に 2 を足して 30 + 2 = 32 です。',
  '計算の順序は かけ算が先で足し算が後です。先に 10 + 2 をしてから 3 をかけると (10 + 2) × 3 = 36 となり誤りです。答えは 32 です。'])

steps(41,
 ['要讓一個兩位數盡量大，十位數字的影響遠比個位大——十位每多 1，整個數就多 10；個位每多 1，只多 1。',
  '所以策略是先把十位取到最大，再看個位能不能配合。',
  '十位最大是 9。這時個位必須是 13 − 9 = 4，而 4 是合法的個位數字，所以 94 成立。',
  '如果十位取 8，個位就要是 5，得到 85，比 94 小。十位再小只會更小。所以最大的數是 94。'],
 ['要让一个两位数尽量大，十位数字的影响远比个位大——十位每多 1，整个数就多 10；个位每多 1，只多 1。',
  '所以策略是先把十位取到最大，再看个位能不能配合。',
  '十位最大是 9。这时个位必须是 13 − 9 = 4，而 4 是合法的个位数字，所以 94 成立。',
  '如果十位取 8，个位就要是 5，得到 85，比 94 小。十位再小只会更小。所以最大的数是 94。'],
 ['To make a two-digit number as large as possible, the tens digit matters far more than the units digit: each extra unit in the tens place adds 10, while each extra unit in the units place adds only 1.',
  'So the strategy is to push the tens digit as high as possible and then see whether the units digit can accommodate it.',
  'The largest possible tens digit is 9, which forces the units digit to be 13 − 9 = 4. Since 4 is a valid digit, 94 works.',
  'A tens digit of 8 would need a units digit of 5, giving 85, which is smaller than 94, and smaller tens digits give smaller numbers still. So the largest is 94.'],
 ['2 けたの数をできるだけ大きくするには、十の位のほうが一の位よりずっと大きく効きます。十の位が 1 ふえると 10 ふえますが、一の位が 1 ふえても 1 しかふえません。',
  'そこで十の位をできるだけ大きくし、それに一の位が合わせられるかを見ます。',
  '十の位の最大は 9 で、このとき一の位は 13 − 9 = 4 でなければなりません。4 は正しい数字なので 94 が成り立ちます。',
  '十の位を 8 にすると一の位は 5 で 85 となり 94 より小さく、十の位をさらに小さくすればもっと小さくなります。したがって最大は 94 です。'])

for q in d['questions']:
    assert len({len(v) for v in q['solutionSteps'].values()}) == 1, q['id']
with io.open(P, 'w', encoding='utf-8') as f:
    json.dump(d, f, ensure_ascii=False, indent=2); f.write('\n')
print('\n已寫回', P)
