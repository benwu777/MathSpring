#!/usr/bin/env python3
"""去重改寫第三批之一：容斥計數、條件篩選、開關切換、真話推理。

arithmetic/inclusion_exclusion 五題句型都是「1 到 N 的整數中，…的數共有幾個？」。
2026-07-28 曾裁決為 acceptable_variant，本次依使用者指示一併改寫：保留
arithmetic_grade3_001 當抽象代表，其餘四題各給一個情境。
"""
import glob, io, json, sys

def L(zh, zhs, en, ja):
    return {'zh-Hant': zh, 'zh-Hans': zhs, 'en': en, 'ja': ja}

R = {}

R['arithmetic_grade5_foundation_012'] = dict(
    prompt=L('一個社團有 100 位成員，編號 1 到 100。編號是 4 的倍數的人要負責值日，編號是 6 的倍數的人要負責招待。至少要負責其中一項工作的人共有幾位？',
             '一个社团有 100 位成员，编号 1 到 100。编号是 4 的倍数的人要负责值日，编号是 6 的倍数的人要负责招待。至少要负责其中一项工作的人共有几位？',
             'A club has 100 members numbered 1 to 100. Members whose number is a multiple of 4 are on duty, and members whose number is a multiple of 6 act as hosts. How many members have at least one of these two jobs?',
             'あるクラブには 1 番から 100 番までの会員が 100 人います。番号が 4 の倍数の人は当番を、6 の倍数の人は受付をたんとうします。少なくともどちらか一方をたんとうする人は何人ですか。'),
    answer=L('答案是 33 位。', '答案是 33 位。', 'The answer is 33.', '答えは 33 人です。'),
    steps=L(['編號是 4 的倍數的有 100 ÷ 4 = 25 位。',
             '編號是 6 的倍數的有 100 ÷ 6 = 16 位（餘數不計）。',
             '兩種工作都要做的人，編號同時是 4 和 6 的倍數，也就是 12 的倍數，有 100 ÷ 12 = 8 位，他們被重複算了一次。',
             '所以答案是 25 + 16 − 8 = 33 位。'],
            ['编号是 4 的倍数的有 100 ÷ 4 = 25 位。',
             '编号是 6 的倍数的有 100 ÷ 6 = 16 位（余数不计）。',
             '两种工作都要做的人，编号同时是 4 和 6 的倍数，也就是 12 的倍数，有 100 ÷ 12 = 8 位，他们被重复算了一次。',
             '所以答案是 25 + 16 − 8 = 33 位。'],
            ['Members whose number is a multiple of 4 number 100 ÷ 4 = 25.',
             'Members whose number is a multiple of 6 number 100 ÷ 6 = 16, ignoring the remainder.',
             'Members with both jobs have a number that is a multiple of both 4 and 6, that is a multiple of 12, and there are 100 ÷ 12 = 8 of them, counted twice so far.',
             'So the answer is 25 + 16 − 8 = 33.'],
            ['番号が 4 の倍数の人は 100 ÷ 4 = 25 人です。',
             '番号が 6 の倍数の人は 100 ÷ 6 = 16 人です（あまりは数えません）。',
             '両方をたんとうする人の番号は 4 と 6 の公倍数、つまり 12 の倍数で、100 ÷ 12 = 8 人います。この 8 人は二重に数えています。',
             'したがって答えは 25 + 16 − 8 = 33 人です。']))

R['arithmetic_grade5_foundation_047'] = dict(
    prompt=L('走廊上有 100 個置物櫃，編號 1 到 100。管理員把編號是 2 的倍數、3 的倍數或 5 的倍數的櫃子都貼上標籤。沒有被貼上標籤的櫃子共有幾個？',
             '走廊上有 100 个储物柜，编号 1 到 100。管理员把编号是 2 的倍数、3 的倍数或 5 的倍数的柜子都贴上标签。没有被贴上标签的柜子共有几个？',
             'A corridor has 100 lockers numbered 1 to 100. The caretaker puts a label on every locker whose number is a multiple of 2, of 3 or of 5. How many lockers get no label?',
             'ろうかに 1 番から 100 番までのロッカーが 100 個あります。管理人は、番号が 2 の倍数、3 の倍数、5 の倍数のいずれかであるロッカーすべてにラベルをはります。ラベルがはられないロッカーは何個ですか。'),
    answer=L('答案是 26 個。', '答案是 26 个。', 'The answer is 26.', '答えは 26 個です。'),
    steps=L(['2 的倍數有 50 個，3 的倍數有 33 個，5 的倍數有 20 個。',
             '被重複算到的：6 的倍數 16 個、10 的倍數 10 個、15 的倍數 6 個，各要扣掉一次。',
             '同時是 2、3、5 倍數的是 30 的倍數，有 3 個，扣太多次要再加回來。',
             '有貼標籤的是 50 + 33 + 20 − 16 − 10 − 6 + 3 = 74 個。',
             '所以沒貼標籤的是 100 − 74 = 26 個。'],
            ['2 的倍数有 50 个，3 的倍数有 33 个，5 的倍数有 20 个。',
             '被重复算到的：6 的倍数 16 个、10 的倍数 10 个、15 的倍数 6 个，各要扣掉一次。',
             '同时是 2、3、5 倍数的是 30 的倍数，有 3 个，扣太多次要再加回来。',
             '有贴标签的是 50 + 33 + 20 − 16 − 10 − 6 + 3 = 74 个。',
             '所以没贴标签的是 100 − 74 = 26 个。'],
            ['There are 50 multiples of 2, 33 multiples of 3 and 20 multiples of 5.',
             'Overlaps must come off once each: 16 multiples of 6, 10 multiples of 10 and 6 multiples of 15.',
             'Numbers that are multiples of 2, 3 and 5 together are the multiples of 30, and those 3 were removed once too often, so they go back in.',
             'Labelled lockers total 50 + 33 + 20 − 16 − 10 − 6 + 3 = 74.',
             'So the unlabelled lockers number 100 − 74 = 26.'],
            ['2 の倍数は 50 個、3 の倍数は 33 個、5 の倍数は 20 個あります。',
             '重なりは 1 回ずつ引きます。6 の倍数が 16 個、10 の倍数が 10 個、15 の倍数が 6 個です。',
             '2、3、5 のすべての倍数である 30 の倍数は 3 個あり、引きすぎているのでたし戻します。',
             'ラベルがはられるのは 50 + 33 + 20 − 16 − 10 − 6 + 3 = 74 個です。',
             'したがってラベルがないのは 100 − 74 = 26 個です。']))

R['arithmetic_grade6_foundation_012'] = dict(
    prompt=L('一座停車場有 100 個車位，編號 1 到 100。編號是 6 的倍數的車位裝了充電樁，編號是 8 的倍數的車位畫成了機車格。裝了充電樁或畫成機車格的車位共有幾個？',
             '一座停车场有 100 个车位，编号 1 到 100。编号是 6 的倍数的车位装了充电桩，编号是 8 的倍数的车位画成了摩托车格。装了充电桩或画成摩托车格的车位共有几个？',
             'A car park has 100 spaces numbered 1 to 100. Spaces whose number is a multiple of 6 have a charging point, and spaces whose number is a multiple of 8 are marked for motorcycles. How many spaces have a charging point or a motorcycle marking?',
             '駐車場に 1 番から 100 番までの区画が 100 個あります。番号が 6 の倍数の区画には充電設備があり、8 の倍数の区画はバイク用になっています。充電設備がある区画とバイク用の区画は合わせて何個ですか。'),
    answer=L('答案是 24 個。', '答案是 24 个。', 'The answer is 24.', '答えは 24 個です。'),
    steps=L(['6 的倍數有 100 ÷ 6 = 16 個（餘數不計）。',
             '8 的倍數有 100 ÷ 8 = 12 個。',
             '兩者都算到的是 6 和 8 的公倍數，也就是 24 的倍數，有 100 ÷ 24 = 4 個。',
             '所以答案是 16 + 12 − 4 = 24 個。'],
            ['6 的倍数有 100 ÷ 6 = 16 个（余数不计）。',
             '8 的倍数有 100 ÷ 8 = 12 个。',
             '两者都算到的是 6 和 8 的公倍数，也就是 24 的倍数，有 100 ÷ 24 = 4 个。',
             '所以答案是 16 + 12 − 4 = 24 个。'],
            ['Multiples of 6 number 100 ÷ 6 = 16, ignoring the remainder.',
             'Multiples of 8 number 100 ÷ 8 = 12.',
             'Spaces counted in both are the common multiples of 6 and 8, that is the multiples of 24, and there are 100 ÷ 24 = 4 of them.',
             'So the answer is 16 + 12 − 4 = 24.'],
            ['6 の倍数は 100 ÷ 6 = 16 個です（あまりは数えません）。',
             '8 の倍数は 100 ÷ 8 = 12 個です。',
             '両方に数えられるのは 6 と 8 の公倍数、つまり 24 の倍数で、100 ÷ 24 = 4 個あります。',
             'したがって答えは 16 + 12 − 4 = 24 個です。']))

R['arithmetic_grade6_foundation_029'] = dict(
    prompt=L('園遊會發出 100 張號碼牌，編號 1 到 100。編號是 3 的倍數可以換一杯飲料，編號是 5 的倍數可以換一份點心。兩種都換不到的號碼牌共有幾張？',
             '园游会发出 100 张号码牌，编号 1 到 100。编号是 3 的倍数可以换一杯饮料，编号是 5 的倍数可以换一份点心。两种都换不到的号码牌共有几张？',
             'A fair hands out 100 tickets numbered 1 to 100. A ticket whose number is a multiple of 3 can be exchanged for a drink, and one whose number is a multiple of 5 can be exchanged for a snack. How many tickets can be exchanged for neither?',
             'もよおしで 1 番から 100 番までの番号ふだが 100 まい配られます。番号が 3 の倍数なら飲み物と、5 の倍数ならおかしと交かんできます。どちらとも交かんできない番号ふだは何まいですか。'),
    answer=L('答案是 53 張。', '答案是 53 张。', 'The answer is 53.', '答えは 53 まいです。'),
    steps=L(['3 的倍數有 100 ÷ 3 = 33 張（餘數不計）。',
             '5 的倍數有 100 ÷ 5 = 20 張。',
             '兩種都能換的是 15 的倍數，有 100 ÷ 15 = 6 張，被重複算了一次。',
             '至少能換一種的是 33 + 20 − 6 = 47 張。',
             '所以兩種都換不到的是 100 − 47 = 53 張。'],
            ['3 的倍数有 100 ÷ 3 = 33 张（余数不计）。',
             '5 的倍数有 100 ÷ 5 = 20 张。',
             '两种都能换的是 15 的倍数，有 100 ÷ 15 = 6 张，被重复算了一次。',
             '至少能换一种的是 33 + 20 − 6 = 47 张。',
             '所以两种都换不到的是 100 − 47 = 53 张。'],
            ['Multiples of 3 number 100 ÷ 3 = 33, ignoring the remainder.',
             'Multiples of 5 number 100 ÷ 5 = 20.',
             'Tickets good for both are the multiples of 15, and those 6 have been counted twice.',
             'Tickets good for at least one thing number 33 + 20 − 6 = 47.',
             'So tickets good for neither number 100 − 47 = 53.'],
            ['3 の倍数は 100 ÷ 3 = 33 まいです（あまりは数えません）。',
             '5 の倍数は 100 ÷ 5 = 20 まいです。',
             '両方と交かんできるのは 15 の倍数で 6 まいあり、二重に数えています。',
             '少なくとも一方と交かんできるのは 33 + 20 − 6 = 47 まいです。',
             'したがってどちらとも交かんできないのは 100 − 47 = 53 まいです。']))

R['logic_grade6_foundation_024'] = dict(
    prompt=L('小明在一本書裡貼了五張書籤，分別在第 51、54、57、60、63 頁。其中只有一頁寫了筆記。這一頁的頁碼是 3 的倍數、比 52 大、比 61 小，而且不是 6 的倍數。寫了筆記的是第幾頁？',
             '小明在一本书里贴了五张书签，分别在第 51、54、57、60、63 页。其中只有一页写了笔记。这一页的页码是 3 的倍数、比 52 大、比 61 小，而且不是 6 的倍数。写了笔记的是第几页？',
             'Ming has put five bookmarks in a book, on pages 51, 54, 57, 60 and 63. Only one of those pages has a note on it. Its page number is a multiple of 3, greater than 52, less than 61 and not a multiple of 6. Which page has the note?',
             'ミンは本に 51、54、57、60、63 ページのしおりを 5 まいはさみました。そのうち 1 ページだけにメモが書かれています。そのページ番号は 3 の倍数で、52 より大きく 61 より小さく、6 の倍数ではありません。メモがあるのは何ページですか。'),
    answer=L('答案是第 57 頁。', '答案是第 57 页。', 'The answer is page 57.', '答えは 57 ページです。'),
    steps=L(['五個頁碼都是 3 的倍數，所以這個條件不能排除任何一頁。',
             '比 52 大、比 61 小，51 和 63 被排除，剩下 54、57、60。',
             '54 和 60 都是 6 的倍數，也要排除，只剩 57。'],
            ['五个页码都是 3 的倍数，所以这个条件不能排除任何一页。',
             '比 52 大、比 61 小，51 和 63 被排除，剩下 54、57、60。',
             '54 和 60 都是 6 的倍数，也要排除，只剩 57。'],
            ['All five page numbers are multiples of 3, so that condition rules nothing out.',
             'Greater than 52 and less than 61 removes 51 and 63, leaving 54, 57 and 60.',
             '54 and 60 are multiples of 6 and are removed too, leaving only 57.'],
            ['5 つのページ番号はすべて 3 の倍数なので、この条件では何もしぼれません。',
             '52 より大きく 61 より小さいという条件で 51 と 63 が消え、54、57、60 が残ります。',
             '54 と 60 は 6 の倍数なので消え、残るのは 57 だけです。']))

R['geometry_grade3_foundation_027'] = dict(
    prompt=L('一扇窗戶完全打開時，窗扇和牆面剛好夾出一個直角。小美把窗戶停在中途，這時窗扇把原本的直角分成兩個角，其中一個角比另一個角大 10 度。較大的那個角是幾度？',
             '一扇窗户完全打开时，窗扇和墙面刚好夹出一个直角。小美把窗户停在中途，这时窗扇把原本的直角分成两个角，其中一个角比另一个角大 10 度。较大的那个角是几度？',
             'When a window is fully open, the pane and the wall make exactly a right angle. Mei stops the window part way, so the pane splits that right angle into two angles, one of which is 10 degrees larger than the other. How many degrees is the larger angle?',
             '窓を全部開けると、窓のとびらとかべはちょうど直角になります。メイが窓をとちゅうで止めると、とびらはこの直角を 2 つの角に分けます。一方の角はもう一方より 10 度大きくなりました。大きいほうの角は何度ですか。'),
    answer=L('答案是 50 度。', '答案是 50 度。', 'The answer is 50 degrees.', '答えは 50 度です。'),
    steps=L(['兩個角合起來是原本的直角，也就是 90 度。',
             '先把多出的 10 度拿掉：90 − 10 = 80 度，這 80 度平分成兩份，每份 40 度。',
             '較大的那個角要把 10 度加回來，所以是 40 + 10 = 50 度。'],
            ['两个角合起来是原本的直角，也就是 90 度。',
             '先把多出的 10 度拿掉：90 − 10 = 80 度，这 80 度平分成两份，每份 40 度。',
             '较大的那个角要把 10 度加回来，所以是 40 + 10 = 50 度。'],
            ['The two angles together make the original right angle, that is 90 degrees.',
             'Set the extra 10 degrees aside: 90 − 10 = 80 degrees, and splitting that equally gives 40 degrees each.',
             'The larger angle gets the 10 degrees back, so it is 40 + 10 = 50 degrees.'],
            ['2 つの角を合わせると、もとの直角、つまり 90 度になります。',
             '大きいほうの 10 度をいったん取り除くと 90 − 10 = 80 度で、これを半分ずつに分けると 40 度ずつです。',
             '大きいほうの角には 10 度をもどすので、40 + 10 = 50 度です。']))

R['geometry_grade3_foundation_012'] = dict(
    prompt=L('一台掃地機器人在方格地板上工作。它從起點先往上走 4 格，再往右走 3 格，最後往下走 4 格。現在它在起點的哪個方向？',
             '一台扫地机器人在方格地板上工作。它从起点先往上走 4 格，再往右走 3 格，最后往下走 4 格。现在它在起点的哪个方向？',
             'A robot vacuum works on a floor marked out in squares. From its starting point it moves 4 squares up, then 3 squares right, then 4 squares down. In which direction from the starting point is it now?',
             'そうじロボットがます目のゆかの上を動きます。スタート地点から上へ 4 ます、次に右へ 3 ます、最後に下へ 4 ます進みました。今、ロボットはスタート地点から見てどの方向にいますか。'),
    answer=L('答案是正右方。', '答案是正右方。', 'The answer is directly to the right.', '答えは真右です。'),
    steps=L(['先看上下方向：往上走了 4 格，又往下走了 4 格，兩者剛好抵消。',
             '再看左右方向：只往右走了 3 格，沒有往左走。',
             '所以機器人和起點在同一條水平線上，位於起點的正右方。'],
            ['先看上下方向：往上走了 4 格，又往下走了 4 格，两者刚好抵消。',
             '再看左右方向：只往右走了 3 格，没有往左走。',
             '所以机器人和起点在同一条水平线上，位于起点的正右方。'],
            ['Look at the up-and-down moves first: 4 squares up and 4 squares down cancel each other exactly.',
             'Now the left-and-right moves: only 3 squares to the right, and none to the left.',
             'So the robot is on the same horizontal line as the start, directly to its right.'],
            ['まず上下の動きを見ます。上へ 4 ます、下へ 4 ますなので、ちょうど打ち消し合います。',
             '次に左右の動きを見ます。右へ 3 ますだけで、左へは動いていません。',
             'したがってロボットはスタート地点と同じ横の線上にあり、真右にいます。']))

R['logic_grade5_foundation_020'] = dict(
    prompt=L('教室裡有 7 台電風扇，編號 1 到 7，一開始全部關著。工友先打開 1、2、7 號；接著把所有編號是 3 的倍數的電風扇開關各按一次；最後再按一次 7 號的開關。最後開著的電風扇有幾台？',
             '教室里有 7 台电风扇，编号 1 到 7，一开始全部关着。工友先打开 1、2、7 号；接着把所有编号是 3 的倍数的电风扇开关各按一次；最后再按一次 7 号的开关。最后开着的电风扇有几台？',
             'A classroom has 7 fans numbered 1 to 7, all switched off to begin with. The caretaker first switches on fans 1, 2 and 7, then presses the switch once on every fan whose number is a multiple of 3, and finally presses the switch on fan 7 once more. How many fans are running at the end?',
             '教室に 1 番から 7 番までの扇風機が 7 台あり、はじめはすべて止まっています。用務員はまず 1 番、2 番、7 番をつけ、次に番号が 3 の倍数の扇風機のスイッチを 1 回ずつおし、最後に 7 番のスイッチをもう 1 回おしました。最後に動いている扇風機は何台ですか。'),
    answer=L('答案是 4 台。', '答案是 4 台。', 'The answer is 4.', '答えは 4 台です。'),
    steps=L(['第一步之後開著的是 1、2、7 號。',
             '3 的倍數是 3 號和 6 號，兩台原本都關著，按一次就變成開著。現在開著的是 1、2、3、6、7 號。',
             '最後再按 7 號一次，7 號從開變成關。',
             '剩下開著的是 1、2、3、6 號，共 4 台。'],
            ['第一步之后开着的是 1、2、7 号。',
             '3 的倍数是 3 号和 6 号，两台原本都关着，按一次就变成开着。现在开着的是 1、2、3、6、7 号。',
             '最后再按 7 号一次，7 号从开变成关。',
             '剩下开着的是 1、2、3、6 号，共 4 台。'],
            ['After the first step fans 1, 2 and 7 are running.',
             'The multiples of 3 are fans 3 and 6, both off before, so one press turns them on. Running now: 1, 2, 3, 6 and 7.',
             'The last press is on fan 7, which turns it from on to off.',
             'Fans 1, 2, 3 and 6 are left running, which is 4 fans.'],
            ['最初の操作のあと、動いているのは 1 番、2 番、7 番です。',
             '3 の倍数は 3 番と 6 番で、どちらも止まっていたので 1 回おすと動き出します。動いているのは 1、2、3、6、7 番です。',
             '最後に 7 番をもう 1 回おすと、7 番は動いている状態から止まります。',
             '残って動いているのは 1、2、3、6 番の 4 台です。']))

R['logic_grade6_foundation_023'] = dict(
    prompt=L('一面電子看板有 8 個方格，編號 1 到 8，一開始全部是暗的。先讓 2、4、8 號方格亮起來；再把所有編號是 4 的倍數的方格切換一次（亮的變暗、暗的變亮）；最後把 2 號到 5 號方格各切換一次。最後亮著的方格有幾個？',
             '一面电子看板有 8 个方格，编号 1 到 8，一开始全部是暗的。先让 2、4、8 号方格亮起来；再把所有编号是 4 的倍数的方格切换一次（亮的变暗、暗的变亮）；最后把 2 号到 5 号方格各切换一次。最后亮着的方格有几个？',
             'An electronic display has 8 cells numbered 1 to 8, all dark at the start. First cells 2, 4 and 8 are lit. Then every cell whose number is a multiple of 4 is toggled once, so lit becomes dark and dark becomes lit. Finally cells 2 to 5 are each toggled once. How many cells are lit at the end?',
             '電光けいじばんに 1 番から 8 番までのマスが 8 個あり、はじめはすべて消えています。まず 2 番、4 番、8 番をつけます。次に番号が 4 の倍数のマスを 1 回ずつ切りかえます（ついていれば消え、消えていればつきます）。最後に 2 番から 5 番までを 1 回ずつ切りかえます。最後についているマスは何個ですか。'),
    answer=L('答案是 3 個。', '答案是 3 个。', 'The answer is 3.', '答えは 3 個です。'),
    steps=L(['第一步之後亮著的是 2、4、8 號。',
             '4 的倍數是 4 號和 8 號，兩個原本都亮著，切換後都變暗。現在只剩 2 號亮著。',
             '最後把 2、3、4、5 號各切換一次：2 號由亮變暗，3、4、5 號由暗變亮。',
             '所以最後亮著的是 3、4、5 號，共 3 個。'],
            ['第一步之后亮着的是 2、4、8 号。',
             '4 的倍数是 4 号和 8 号，两个原本都亮着，切换后都变暗。现在只剩 2 号亮着。',
             '最后把 2、3、4、5 号各切换一次：2 号由亮变暗，3、4、5 号由暗变亮。',
             '所以最后亮着的是 3、4、5 号，共 3 个。'],
            ['After the first step cells 2, 4 and 8 are lit.',
             'The multiples of 4 are cells 4 and 8, both lit, so toggling makes them dark. Only cell 2 is still lit.',
             'Finally cells 2, 3, 4 and 5 are toggled once each: cell 2 goes dark, and cells 3, 4 and 5 light up.',
             'So the lit cells at the end are 3, 4 and 5, which is 3 cells.'],
            ['最初の操作のあと、ついているのは 2 番、4 番、8 番です。',
             '4 の倍数は 4 番と 8 番で、どちらもついていたので切りかえると消えます。ついているのは 2 番だけです。',
             '最後に 2、3、4、5 番を 1 回ずつ切りかえると、2 番は消え、3、4、5 番がつきます。',
             'したがって最後についているのは 3、4、5 番の 3 個です。']))

R['logic_grade6_foundation_016'] = dict(
    prompt=L('一箱水果的顆數是 18、24、30 其中之一。甲說：「不是 18 顆。」乙說：「是 24 顆。」丙說：「乙說錯了。」已知三人之中只有一人說對。這箱水果有幾顆？',
             '一箱水果的颗数是 18、24、30 其中之一。甲说：「不是 18 颗。」乙说：「是 24 颗。」丙说：「乙说错了。」已知三人之中只有一人说对。这箱水果有几颗？',
             'A box holds 18, 24 or 30 pieces of fruit. The first person says "It is not 18." The second says "It is 24." The third says "The second person is wrong." Exactly one of the three is right. How many pieces of fruit are in the box?',
             'くだものが入った箱の中身は 18 個、24 個、30 個のいずれかです。1 人目は「18 個ではない」、2 人目は「24 個だ」、3 人目は「2 人目はまちがっている」と言いました。3 人のうち正しいのはちょうど 1 人です。箱の中には何個入っていますか。'),
    answer=L('答案是 18 顆。', '答案是 18 颗。', 'The answer is 18.', '答えは 18 個です。'),
    steps=L(['先注意乙和丙的話剛好相反，所以兩人之中必定恰好有一人說對。',
             '既然只有一人說對，那個人一定在乙、丙之中，因此甲一定說錯，也就是「不是 18 顆」是錯的。',
             '所以這箱水果是 18 顆。驗算：甲錯、乙錯、丙對，恰好一人說對，符合條件。'],
            ['先注意乙和丙的话刚好相反，所以两人之中必定恰好有一人说对。',
             '既然只有一人说对，那个人一定在乙、丙之中，因此甲一定说错，也就是「不是 18 颗」是错的。',
             '所以这箱水果是 18 颗。验算：甲错、乙错、丙对，恰好一人说对，符合条件。'],
            ['Notice first that the second and third statements are exact opposites, so exactly one of those two must be right.',
             'Since only one person in all is right, that person must be the second or the third, so the first person is wrong and "It is not 18" is false.',
             'The box therefore holds 18. Checking: the first is wrong, the second is wrong and the third is right, exactly one correct.'],
            ['まず、2 人目と 3 人目の発言はちょうど反対なので、この 2 人のうち正しいのはちょうど 1 人です。',
             '正しい人は全体で 1 人だけなので、その 1 人は 2 人目か 3 人目であり、1 人目はまちがっています。つまり「18 個ではない」がまちがいです。',
             'したがって箱の中は 18 個です。確かめ：1 人目はまちがい、2 人目もまちがい、3 人目が正しく、正しいのはちょうど 1 人です。']))

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
