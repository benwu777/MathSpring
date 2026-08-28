#!/usr/bin/env python3
"""去重改寫第三批之二：面積倍率、周長不變、剪角、排程、路徑、卡片配對、等差和。"""
import glob, io, json, sys

def L(zh, zhs, en, ja):
    return {'zh-Hant': zh, 'zh-Hans': zhs, 'en': en, 'ja': ja}

R = {}

R['geometry_grade6_foundation_029'] = dict(
    prompt=L('一張長方形照片要等比例放大，長和寬都放大成原來的相同倍數。放大後照片的面積變成原來的 9 倍。長和寬各放大成原來的幾倍？',
             '一张长方形照片要等比例放大，长和宽都放大成原来的相同倍数。放大后照片的面积变成原来的 9 倍。长和宽各放大成原来的几倍？',
             'A rectangular photograph is enlarged so that its length and width are both multiplied by the same number. The enlarged photograph has 9 times the original area. By what factor were the length and the width each enlarged?',
             '長方形の写真を、たてとよこを同じ倍率で拡大します。拡大後の面積はもとの 9 倍になりました。たてとよこはそれぞれ何倍に拡大されましたか。'),
    answer=L('答案是 3 倍。', '答案是 3 倍。', 'The answer is 3 times.', '答えは 3 倍です。'),
    steps=L(['面積等於長乘寬，所以長和寬各放大 k 倍時，面積會放大 k × k 倍。',
             '題目說面積變成 9 倍，所以 k × k = 9。',
             '3 × 3 = 9，所以長和寬各放大成原來的 3 倍。'],
            ['面积等于长乘宽，所以长和宽各放大 k 倍时，面积会放大 k × k 倍。',
             '题目说面积变成 9 倍，所以 k × k = 9。',
             '3 × 3 = 9，所以长和宽各放大成原来的 3 倍。'],
            ['Area is length times width, so multiplying both by k multiplies the area by k × k.',
             'The area becomes 9 times the original, so k × k = 9.',
             'Since 3 × 3 = 9, the length and the width were each enlarged 3 times.'],
            ['面積はたて × よこなので、たてとよこをどちらも k 倍にすると面積は k × k 倍になります。',
             '面積が 9 倍になったので k × k = 9 です。',
             '3 × 3 = 9 なので、たてとよこはそれぞれ 3 倍に拡大されました。']))

R['geometry_grade6_foundation_030'] = dict(
    prompt=L('一塊長方形看板重新裁製：寬度裁掉一半，但長度拉長成原來的 2 倍。新看板的面積是原來的幾倍？',
             '一块长方形看板重新裁制：宽度裁掉一半，但长度拉长成原来的 2 倍。新看板的面积是原来的几倍？',
             'A rectangular signboard is remade: its width is cut down to half, while its length is stretched to twice the original. The new signboard has how many times the original area?',
             '長方形のかんばんを作り直します。はばは半分に切りつめ、長さはもとの 2 倍にのばします。新しいかんばんの面積はもとの何倍ですか。'),
    answer=L('答案是 1 倍。', '答案是 1 倍。', 'The answer is 1 time, that is unchanged.', '答えは 1 倍、つまり変わりません。'),
    steps=L(['面積等於長乘寬。',
             '長變成 2 倍，寬變成原來的一半，也就是乘上 2 再乘上二分之一。',
             '2 × 二分之一 = 1，所以新看板的面積和原來一樣，是原來的 1 倍。'],
            ['面积等于长乘宽。',
             '长变成 2 倍，宽变成原来的一半，也就是乘上 2 再乘上二分之一。',
             '2 × 二分之一 = 1，所以新看板的面积和原来一样，是原来的 1 倍。'],
            ['Area is length times width.',
             'The length is multiplied by 2 and the width by one half.',
             '2 × one half = 1, so the new signboard has the same area as before, that is 1 time the original.'],
            ['面積はたて × よこです。',
             '長さは 2 倍、はばは 2 分の 1 倍になります。',
             '2 × 2 分の 1 = 1 なので、新しいかんばんの面積はもとと同じ、つまり 1 倍です。']))

R['geometry_grade6_foundation_032'] = dict(
    prompt=L('一塊長方形菜圃要改建：長邊向外延伸，增加 20%；寬邊向內縮，減少 20%。改建後菜圃的面積比原來減少了百分之幾？',
             '一块长方形菜圃要改建：长边向外延伸，增加 20%；宽边向内缩，减少 20%。改建后菜圃的面积比原来减少了百分之几？',
             'A rectangular vegetable bed is rebuilt: its long side is extended outwards by 20 percent, and its short side is pulled in by 20 percent. By what percentage is the area of the rebuilt bed smaller than the original?',
             '長方形の畑を作り直します。長いほうの辺は外へのばして 20% ふやし、短いほうの辺は内へちぢめて 20% へらします。作り直した畑の面積は、もとより何 % 小さくなりますか。'),
    answer=L('答案是減少 4%。', '答案是减少 4%。', 'The answer is 4 percent.', '答えは 4% です。'),
    steps=L(['把原來的長和寬都看成 1。長增加 20% 後變成 1.2，寬減少 20% 後變成 0.8。',
             '新面積是 1.2 × 0.8 = 0.96，原面積是 1 × 1 = 1。',
             '所以面積變成原來的 96%，減少了 100% − 96% = 4%。'],
            ['把原来的长和宽都看成 1。长增加 20% 后变成 1.2，宽减少 20% 后变成 0.8。',
             '新面积是 1.2 × 0.8 = 0.96，原面积是 1 × 1 = 1。',
             '所以面积变成原来的 96%，减少了 100% − 96% = 4%。'],
            ['Take both the original length and width as 1. After a 20 percent increase the length is 1.2, and after a 20 percent decrease the width is 0.8.',
             'The new area is 1.2 × 0.8 = 0.96, while the original area is 1 × 1 = 1.',
             'So the area becomes 96 percent of the original, a decrease of 100 − 96 = 4 percent.'],
            ['もとのたてとよこをどちらも 1 とします。20% ふえた長さは 1.2、20% へった長さは 0.8 です。',
             '新しい面積は 1.2 × 0.8 = 0.96 で、もとの面積は 1 × 1 = 1 です。',
             'したがって面積はもとの 96% になり、100% − 96% = 4% 小さくなりました。']))

R['geometry_grade5_foundation_002'] = dict(
    prompt=L('一塊邊長 10 公分的正方形磁磚，四個角各被磨掉一個邊長 1 公分的小正方形缺口。磨完以後這塊磁磚的周長是幾公分？',
             '一块边长 10 厘米的正方形磁砖，四个角各被磨掉一个边长 1 厘米的小正方形缺口。磨完以后这块磁砖的周长是几厘米？',
             'A square tile with sides of 10 cm has a small square notch of side 1 cm ground away at each of its four corners. What is the perimeter of the tile afterwards, in centimetres?',
             '1 辺 10 cm の正方形のタイルの 4 すみから、1 辺 1 cm の正方形の切りかきをけずり取ります。けずったあとのタイルのまわりの長さは何 cm ですか。'),
    answer=L('答案是 40 公分。', '答案是 40 厘米。', 'The answer is 40 cm.', '答えは 40 cm です。'),
    steps=L(['磨掉一個角時，原本邊上少了兩段各 1 公分，卻多出兩段各 1 公分的新邊，一加一減剛好抵消。',
             '四個角都是這樣，所以周長完全沒有改變。',
             '原來的周長是 4 × 10 = 40 公分，磨完之後還是 40 公分。'],
            ['磨掉一个角时，原本边上少了两段各 1 厘米，却多出两段各 1 厘米的新边，一加一减刚好抵消。',
             '四个角都是这样，所以周长完全没有改变。',
             '原来的周长是 4 × 10 = 40 厘米，磨完之后还是 40 厘米。'],
            ['Grinding one corner away removes two pieces of 1 cm from the old sides but adds two new pieces of 1 cm, so the loss and the gain cancel exactly.',
             'The same happens at all four corners, so the perimeter does not change at all.',
             'The original perimeter is 4 × 10 = 40 cm, and it is still 40 cm afterwards.'],
            ['1 すみをけずると、もとの辺から 1 cm ずつ 2 か所が減りますが、新しく 1 cm の辺が 2 本ふえるので、減った分とふえた分がちょうど打ち消し合います。',
             '4 すみとも同じなので、まわりの長さはまったく変わりません。',
             'もとのまわりの長さは 4 × 10 = 40 cm なので、けずったあとも 40 cm です。']))

R['geometry_grade4_foundation_026'] = dict(
    prompt=L('一面長方形的旗子，長是寬的 3 倍。沿著旗子四周縫上一圈緞帶，剛好用掉 40 公分。這面旗子的面積是幾平方公分？',
             '一面长方形的旗子，长是宽的 3 倍。沿着旗子四周缝上一圈缎带，刚好用掉 40 厘米。这面旗子的面积是几平方厘米？',
             'A rectangular flag is 3 times as long as it is wide. Sewing a ribbon all the way round its edge uses exactly 40 cm of ribbon. What is the area of the flag in square centimetres?',
             '長方形のはたがあり、長さははばの 3 倍です。はたのまわりに 1 周リボンをぬいつけると、ちょうど 40 cm 使いました。このはたの面積は何平方 cm ですか。'),
    answer=L('答案是 75 平方公分。', '答案是 75 平方厘米。', 'The answer is 75 square centimetres.', '答えは 75 平方 cm です。'),
    steps=L(['緞帶的長度就是旗子的周長，所以周長是 40 公分。',
             '周長等於（長 + 寬）× 2，所以長 + 寬 = 20 公分。',
             '長是寬的 3 倍，所以長 + 寬相當於 4 個寬：寬 = 20 ÷ 4 = 5 公分，長 = 15 公分。',
             '面積 = 15 × 5 = 75 平方公分。'],
            ['缎带的长度就是旗子的周长，所以周长是 40 厘米。',
             '周长等于（长 + 宽）× 2，所以长 + 宽 = 20 厘米。',
             '长是宽的 3 倍，所以长 + 宽相当于 4 个宽：宽 = 20 ÷ 4 = 5 厘米，长 = 15 厘米。',
             '面积 = 15 × 5 = 75 平方厘米。'],
            ['The ribbon measures the perimeter of the flag, so the perimeter is 40 cm.',
             'The perimeter equals (length + width) × 2, so length + width = 20 cm.',
             'The length is 3 times the width, so length + width is 4 widths: width = 20 ÷ 4 = 5 cm and length = 15 cm.',
             'The area is 15 × 5 = 75 square centimetres.'],
            ['リボンの長さははたのまわりの長さなので、まわりの長さは 40 cm です。',
             'まわりの長さは（たて ＋ よこ）× 2 なので、たて ＋ よこ = 20 cm です。',
             '長さははばの 3 倍なので、たて ＋ よこ ははば 4 つ分にあたります。はば = 20 ÷ 4 = 5 cm、長さ = 15 cm です。',
             '面積は 15 × 5 = 75 平方 cm です。']))

R['logic_grade4_foundation_024'] = dict(
    prompt=L('小安、小美、小華、小樂四個人在星期一到星期四各值日一天，一天一個人。已知：小安不在星期一值日；小美的值日日剛好是小樂的後一天；小華不在星期一，也不在星期四；而且如果小安在星期二值日，小樂就會在星期四值日。小樂在星期幾值日？',
             '小安、小美、小华、小乐四个人在星期一到星期四各值日一天，一天一个人。已知：小安不在星期一值日；小美的值日日刚好是小乐的后一天；小华不在星期一，也不在星期四；而且如果小安在星期二值日，小乐就会在星期四值日。小乐在星期几值日？',
             'An, Mei, Hua and Le are each on duty for one day from Monday to Thursday, one person per day. An is not on duty on Monday. Mei\'s day is exactly the day after Le\'s. Hua is on duty neither on Monday nor on Thursday. Also, if An were on duty on Tuesday then Le would be on duty on Thursday. On which day is Le on duty?',
             'アン、メイ、ホア、レの 4 人が、月曜から木曜まで 1 日に 1 人ずつ当番をします。アンは月曜ではありません。メイの当番はレのちょうど次の日です。ホアは月曜でも木曜でもありません。また、もしアンが火曜なら、レは木曜になります。レは何曜日に当番ですか。'),
    answer=L('答案是星期一。', '答案是星期一。', 'The answer is Monday.', '答えは月曜日です。'),
    steps=L(['先看小安：如果小安在星期二，依條件小樂就要在星期四，但小美必須排在小樂的後一天，星期四後面沒有天可以排，矛盾。所以小安不在星期二，也不在星期一，只能是星期三或星期四。',
             '再看小樂：小美要排在小樂的後一天，所以小樂不能是星期四。',
             '若小樂在星期二，小美就在星期三，小華只能排星期二或星期三，兩天都被佔走，矛盾。若小樂在星期三，小美就在星期四，小華只剩星期二，小安只剩星期一，但小安不能排星期一，也矛盾。',
             '所以小樂在星期一，小美在星期二，小華在星期三，小安在星期四，全部條件都符合。'],
            ['先看小安：如果小安在星期二，依条件小乐就要在星期四，但小美必须排在小乐的后一天，星期四后面没有天可以排，矛盾。所以小安不在星期二，也不在星期一，只能是星期三或星期四。',
             '再看小乐：小美要排在小乐的后一天，所以小乐不能是星期四。',
             '若小乐在星期二，小美就在星期三，小华只能排星期二或星期三，两天都被占走，矛盾。若小乐在星期三，小美就在星期四，小华只剩星期二，小安只剩星期一，但小安不能排星期一，也矛盾。',
             '所以小乐在星期一，小美在星期二，小华在星期三，小安在星期四，全部条件都符合。'],
            ['Start with An. If An were on Tuesday then Le would be on Thursday, but Mei must come the day after Le and there is no day after Thursday, a contradiction. So An is not on Tuesday and not on Monday, leaving Wednesday or Thursday.',
             'Now Le: Mei comes the day after Le, so Le cannot be on Thursday.',
             'If Le were on Tuesday then Mei is on Wednesday, and Hua can only be on Tuesday or Wednesday, both taken, a contradiction. If Le were on Wednesday then Mei is on Thursday, Hua can only be Tuesday and An is left with Monday, which An cannot have, another contradiction.',
             'So Le is on Monday, Mei on Tuesday, Hua on Wednesday and An on Thursday, and every condition holds.'],
            ['まずアンを考えます。アンが火曜なら、条件よりレは木曜ですが、メイはレの次の日でなければならず、木曜の次の日はないので矛盾します。したがってアンは火曜でも月曜でもなく、水曜か木曜です。',
             '次にレを考えます。メイはレの次の日なので、レは木曜にはなれません。',
             'レが火曜なら、メイは水曜となり、ホアは火曜か水曜しか選べませんがどちらもうまっていて矛盾します。レが水曜なら、メイは木曜、ホアは火曜だけとなり、アンは月曜しか残りませんが、アンは月曜になれないのでこれも矛盾です。',
             'したがってレは月曜、メイは火曜、ホアは水曜、アンは木曜となり、すべての条件を満たします。']))

R['geometry_grade2_foundation_023'] = dict(
    prompt=L('小安拿一張正方形的便利貼，把左上角和右下角這兩個對角，各剪掉一小塊三角形。剪完以後的圖形最少有幾條邊？',
             '小安拿一张正方形的便利贴，把左上角和右下角这两个对角，各剪掉一小块三角形。剪完以后的图形最少有几条边？',
             'An takes a square sticky note and cuts a small triangle off each of two opposite corners, the top-left and the bottom-right. At least how many sides does the resulting shape have?',
             'アンは正方形のふせんの、左上と右下という向かい合う 2 つのかどから、それぞれ小さな三角形を切り落としました。できた図形の辺は少なくとも何本ありますか。'),
    answer=L('答案是 6 條。', '答案是 6 条。', 'The answer is 6.', '答えは 6 本です。'),
    steps=L(['正方形本來有 4 條邊。剪掉一個角時，那個角所在的兩條邊各被切短，同時多出一條新的斜邊，所以邊數增加 1。',
             '兩個對角各剪一次，而且兩個角不相鄰、切口不會碰在一起，所以邊數一共增加 2。',
             '4 + 2 = 6 條邊。'],
            ['正方形本来有 4 条边。剪掉一个角时，那个角所在的两条边各被切短，同时多出一条新的斜边，所以边数增加 1。',
             '两个对角各剪一次，而且两个角不相邻、切口不会碰在一起，所以边数一共增加 2。',
             '4 + 2 = 6 条边。'],
            ['A square starts with 4 sides. Cutting one corner shortens the two sides meeting there and adds one new slanted side, so the number of sides goes up by 1.',
             'Two opposite corners are cut, and because they are not next to each other the two cuts never meet, so the count goes up by 2 in total.',
             '4 + 2 = 6 sides.'],
            ['正方形にはもともと辺が 4 本あります。かどを 1 つ切ると、そのかどの 2 本の辺が短くなり、新しいななめの辺が 1 本ふえるので、辺の数は 1 本ふえます。',
             '向かい合う 2 つのかどを切り、2 つのかどはとなり合っていないので切り口が重なることはなく、辺の数は合わせて 2 本ふえます。',
             '4 + 2 = 6 本です。']))

R['arithmetic_grade3_foundation_028'] = dict(
    prompt=L('四張摸彩券上分別寫著 5、9、14、18 點。要把四張分成兩組，每組兩張，並且讓兩組的點數和盡量接近。這時每一組的點數和是多少？',
             '四张摸彩券上分别写着 5、9、14、18 点。要把四张分成两组，每组两张，并且让两组的点数和尽量接近。这时每一组的点数和是多少？',
             'Four raffle tickets are marked 5, 9, 14 and 18 points. They are split into two groups of two tickets so that the two group totals are as close as possible. What is the total of each group?',
             '4 まいのふくびき券にはそれぞれ 5、9、14、18 点と書かれています。この 4 まいを 2 まいずつ 2 つの組に分け、2 つの組の合計ができるだけ近くなるようにします。このとき、それぞれの組の合計はいくつですか。'),
    answer=L('答案是 23 點。', '答案是 23 点。', 'The answer is 23 points.', '答えは 23 点です。'),
    steps=L(['四張的總點數是 5 + 9 + 14 + 18 = 46 點。',
             '兩組要盡量接近，最理想的情形是剛好平分，每組 46 ÷ 2 = 23 點。',
             '檢查是否做得到：5 + 18 = 23，9 + 14 = 23，剛好可以。',
             '所以每一組的點數和都是 23 點。'],
            ['四张的总点数是 5 + 9 + 14 + 18 = 46 点。',
             '两组要尽量接近，最理想的情形是刚好平分，每组 46 ÷ 2 = 23 点。',
             '检查是否做得到：5 + 18 = 23，9 + 14 = 23，刚好可以。',
             '所以每一组的点数和都是 23 点。'],
            ['The four tickets total 5 + 9 + 14 + 18 = 46 points.',
             'The closest the two groups could possibly be is an exact split, giving 46 ÷ 2 = 23 points each.',
             'Check whether that can be done: 5 + 18 = 23 and 9 + 14 = 23, so it can.',
             'Each group therefore totals 23 points.'],
            ['4 まいの合計は 5 + 9 + 14 + 18 = 46 点です。',
             '2 つの組をできるだけ近づけるとき、いちばんよいのはちょうど半分ずつで、1 組あたり 46 ÷ 2 = 23 点です。',
             '実際にできるか確かめます。5 + 18 = 23、9 + 14 = 23 なのでできます。',
             'したがってそれぞれの組の合計は 23 点です。']))

R['arithmetic_grade5_foundation_007'] = dict(
    prompt=L('小安要從家裡出發，先經過郵局，再經過圖書館，最後到公園。家到郵局有 3 條路，郵局到圖書館有 4 條路，圖書館到公園有 2 條路。但其中有 2 組「郵局到圖書館再到公園」的連走方式因為施工不能使用，其餘都可以走。小安從家裡到公園共有幾種走法？',
             '小安要从家里出发，先经过邮局，再经过图书馆，最后到公园。家到邮局有 3 条路，邮局到图书馆有 4 条路，图书馆到公园有 2 条路。但其中有 2 组「邮局到图书馆再到公园」的连走方式因为施工不能使用，其余都可以走。小安从家里到公园共有几种走法？',
             'An walks from home past the post office, then past the library, and finally to the park. There are 3 roads from home to the post office, 4 from the post office to the library and 2 from the library to the park. However, 2 particular post-office-to-library-to-park combinations are closed for roadworks, while all the others are open. In how many ways can An get from home to the park?',
             'アンは家を出て、郵便局、図書館の順に通って公園へ行きます。家から郵便局までは 3 本、郵便局から図書館までは 4 本、図書館から公園までは 2 本の道があります。ただし「郵便局から図書館、そして公園へ」というつなぎ方のうち 2 通りは工事で通れず、ほかはすべて通れます。家から公園までの行き方は何通りありますか。'),
    answer=L('答案是 18 種。', '答案是 18 种。', 'The answer is 18.', '答えは 18 通りです。'),
    steps=L(['先看後半段：郵局到圖書館再到公園，本來有 4 × 2 = 8 種連走方式。',
             '扣掉不能走的 2 種，後半段剩下 8 − 2 = 6 種。',
             '前半段家到郵局有 3 條路，和後半段可以自由搭配，所以總共是 3 × 6 = 18 種走法。'],
            ['先看后半段：邮局到图书馆再到公园，本来有 4 × 2 = 8 种连走方式。',
             '扣掉不能走的 2 种，后半段剩下 8 − 2 = 6 种。',
             '前半段家到邮局有 3 条路，和后半段可以自由搭配，所以总共是 3 × 6 = 18 种走法。'],
            ['Look at the second half first: post office to library to park normally allows 4 × 2 = 8 combinations.',
             'Removing the 2 closed ones leaves 8 − 2 = 6 for the second half.',
             'The first half, home to the post office, has 3 roads, and any of them pairs with any second half, so the total is 3 × 6 = 18 ways.'],
            ['まず後半を見ます。郵便局から図書館、そして公園へのつなぎ方は本来 4 × 2 = 8 通りです。',
             '通れない 2 通りを除くと、後半は 8 − 2 = 6 通りです。',
             '前半の家から郵便局までは 3 本あり、後半とは自由に組み合わせられるので、合計は 3 × 6 = 18 通りです。']))

R['arithmetic_grade3_foundation_019'] = dict(
    prompt=L('一疊書由下往上疊起來，最下面那本厚 4 公釐，往上每一本都比它下面那本厚 5 公釐，一共疊了 5 本。這疊書的總厚度是幾公釐？',
             '一叠书由下往上叠起来，最下面那本厚 4 毫米，往上每一本都比它下面那本厚 5 毫米，一共叠了 5 本。这叠书的总厚度是几毫米？',
             'Five books are stacked one on top of another. The bottom book is 4 mm thick, and each book above is 5 mm thicker than the one below it. What is the total thickness of the stack in millimetres?',
             '本を下から 5 さつ積み上げます。いちばん下の本の厚さは 4 mm で、上の本はそれぞれすぐ下の本より 5 mm 厚くなっています。この 5 さつを合わせた厚さは何 mm ですか。'),
    answer=L('答案是 70 公釐。', '答案是 70 毫米。', 'The answer is 70 mm.', '答えは 70 mm です。'),
    steps=L(['五本書由下往上的厚度依序是 4、9、14、19、24 公釐。',
             '把最下面和最上面配成一對：4 + 24 = 28；第二本和第四本也配成一對：9 + 19 = 28。',
             '中間剩下第三本 14 公釐。',
             '所以總厚度是 28 + 28 + 14 = 70 公釐。'],
            ['五本书由下往上的厚度依次是 4、9、14、19、24 毫米。',
             '把最下面和最上面配成一对：4 + 24 = 28；第二本和第四本也配成一对：9 + 19 = 28。',
             '中间剩下第三本 14 毫米。',
             '所以总厚度是 28 + 28 + 14 = 70 毫米。'],
            ['From the bottom up the thicknesses are 4, 9, 14, 19 and 24 mm.',
             'Pair the bottom with the top: 4 + 24 = 28. Pair the second with the fourth: 9 + 19 = 28.',
             'The third book, 14 mm, is left in the middle.',
             'So the total is 28 + 28 + 14 = 70 mm.'],
            ['下から順に本の厚さは 4、9、14、19、24 mm です。',
             'いちばん下といちばん上を組にすると 4 + 24 = 28、2 さつ目と 4 さつ目を組にすると 9 + 19 = 28 です。',
             'まん中の 3 さつ目 14 mm が残ります。',
             'したがって合計は 28 + 28 + 14 = 70 mm です。']))

NOTE = ('Rewritten 2026-08-28 to clear a duplicate group found by '
        'tool/question_bank_duplicate_audit.dart. Conditions, reasoning and answer are unchanged; '
        'the wording was shared with sibling questions in other grades, so this one now has its '
        'own concrete situation.')

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
        print('改寫 %-40s -> %s' % (q['id'], q['correctAnswer']['value']))
    if dirty:
        io.open(path, 'w', encoding='utf-8').write(
            json.dumps(pack, ensure_ascii=False, indent=2) + '\n')
if changed != len(R):
    sys.exit('預期 %d 題，實際 %d 題' % (len(R), changed))
print('共改寫 %d 題' % changed)
