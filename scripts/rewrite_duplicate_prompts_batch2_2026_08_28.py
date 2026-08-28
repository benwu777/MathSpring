#!/usr/bin/env python3
"""去重改寫第二批：猜位置、餘數抽屜原理、兩位數排列。

logic/position 兩群共九題，句型都是「X 藏在 1 到 n 號 Y 其中一個。它在 a 號右邊、
不在 b 號⋯」，只換了藏的東西、容器名稱與數字。改成九個彼此不同的實際情境
（排隊、樓層、月份、書架、公車站、車廂、公休日、停車位、補給站），
篩選條件與答案完全不動。
"""
import glob, io, json, sys

def L(zh, zhs, en, ja):
    return {'zh-Hant': zh, 'zh-Hans': zhs, 'en': en, 'ja': ja}

R = {}

R['logic_grade1_foundation_015'] = dict(
    prompt=L('四個小朋友從左到右排成一列，位置由左而右是第 1、2、3、4 個。小安不在第 1 個，也不在第 4 個，而且站在第 3 個位置的左邊。小安站在第幾個位置？',
             '四个小朋友从左到右排成一列，位置由左而右是第 1、2、3、4 个。小安不在第 1 个，也不在第 4 个，而且站在第 3 个位置的左边。小安站在第几个位置？',
             'Four children stand in a line, in positions 1, 2, 3 and 4 from the left. An is not in position 1 and not in position 4, and stands to the left of position 3. Which position is An in?',
             '4 人の子どもが左から一列にならび、左から 1、2、3、4 番目です。アンは 1 番目でも 4 番目でもなく、3 番目より左に立っています。アンは何番目ですか。'),
    answer=L('答案是第 2 個。', '答案是第 2 个。', 'The answer is position 2.', '答えは 2 番目です。'),
    steps=L(['先把不可能的位置劃掉：不在第 1 個，也不在第 4 個，只剩第 2、3 個。',
             '又知道小安在第 3 個位置的左邊，所以第 3 個也要劃掉，只剩第 2 個。'],
            ['先把不可能的位置划掉：不在第 1 个，也不在第 4 个，只剩第 2、3 个。',
             '又知道小安在第 3 个位置的左边，所以第 3 个也要划掉，只剩第 2 个。'],
            ['Cross out the impossible positions first: not 1 and not 4 leaves only 2 and 3.',
             'An also stands to the left of position 3, so 3 is out too, leaving only position 2.'],
            ['まず、ありえない場所を消します。1 番目でも 4 番目でもないので、残るのは 2 番目と 3 番目です。',
             'さらにアンは 3 番目より左なので 3 番目も消え、残るのは 2 番目だけです。']))

R['logic_grade3_foundation_020'] = dict(
    prompt=L('一棟大樓的 1 樓到 6 樓各有一間辦公室。某公司的辦公室在偶數樓，不在 6 樓，而且比 2 樓高。這間辦公室在幾樓？',
             '一栋大楼的 1 楼到 6 楼各有一间办公室。某公司的办公室在偶数楼，不在 6 楼，而且比 2 楼高。这间办公室在几楼？',
             'A building has one office on each of floors 1 to 6. A certain company\'s office is on an even-numbered floor, is not on floor 6, and is higher than floor 2. Which floor is the office on?',
             'あるビルの 1 階から 6 階に、それぞれ 1 つずつ事務所があります。ある会社の事務所は偶数の階にあり、6 階ではなく、2 階より上です。この事務所は何階にありますか。'),
    answer=L('答案是 4 樓。', '答案是 4 楼。', 'The answer is floor 4.', '答えは 4 階です。'),
    steps=L(['1 到 6 樓之中，偶數樓是 2、4、6 樓。',
             '不在 6 樓，所以剩下 2 樓和 4 樓。',
             '又要比 2 樓高，所以只剩 4 樓。'],
            ['1 到 6 楼之中，偶数楼是 2、4、6 楼。',
             '不在 6 楼，所以剩下 2 楼和 4 楼。',
             '又要比 2 楼高，所以只剩 4 楼。'],
            ['Among floors 1 to 6, the even ones are 2, 4 and 6.',
             'It is not floor 6, so floors 2 and 4 remain.',
             'It is also higher than floor 2, so only floor 4 is left.'],
            ['1 階から 6 階のうち、偶数の階は 2 階、4 階、6 階です。',
             '6 階ではないので、残るのは 2 階と 4 階です。',
             'さらに 2 階より上なので、残るのは 4 階だけです。']))

R['logic_grade4_foundation_015'] = dict(
    prompt=L('小美的生日在 1 月到 6 月之間。已知她的生日比 2 月晚、比 6 月早，不是 5 月，也不是 3 月。小美的生日在幾月？',
             '小美的生日在 1 月到 6 月之间。已知她的生日比 2 月晚、比 6 月早，不是 5 月，也不是 3 月。小美的生日在几月？',
             'Mei\'s birthday falls between January and June. It is later than February and earlier than June, and it is not in May and not in March. Which month is Mei's birthday in? Give the month as a number.',
             'メイのたんじょう日は 1 月から 6 月のあいだにあります。2 月より後で 6 月より前、しかも 5 月でも 3 月でもありません。メイのたんじょう日は何月ですか。'),
    answer=L('答案是 4 月。', '答案是 4 月。', 'The answer is month 4.', '答えは 4 月です。'),
    steps=L(['比 2 月晚、比 6 月早，可能是 3、4、5 月。',
             '再把 5 月和 3 月排除，只剩 4 月。'],
            ['比 2 月晚、比 6 月早，可能是 3、4、5 月。',
             '再把 5 月和 3 月排除，只剩 4 月。'],
            ['Later than month 2 and earlier than month 6 leaves months 3, 4 and 5.',
             'Ruling out month 5 and month 3 leaves only month 4.'],
            ['2 月より後で 6 月より前なので、3 月、4 月、5 月が候補です。',
             '5 月と 3 月を除くと、残るのは 4 月だけです。']))

R['logic_grade5_foundation_018'] = dict(
    prompt=L('一本書放在書架上，書架從下到上是第 1 層到第 9 層。這本書在奇數層，比第 8 層低，不在第 1 層，也不在第 5 層，而且比第 3 層高。這本書在第幾層？',
             '一本书放在书架上，书架从下到上是第 1 层到第 9 层。这本书在奇数层，比第 8 层低，不在第 1 层，也不在第 5 层，而且比第 3 层高。这本书在第几层？',
             'A book sits on a bookcase whose shelves are numbered 1 to 9 from the bottom up. The book is on an odd-numbered shelf, lower than shelf 8, not on shelf 1 and not on shelf 5, and higher than shelf 3. Which shelf is the book on?',
             '本だなの棚は下から順に 1 段目から 9 段目まであり、そこに本が 1 さつ置かれています。その本は奇数の段にあり、8 段目より下、1 段目でも 5 段目でもなく、3 段目より上です。本は何段目にありますか。'),
    answer=L('答案是第 7 層。', '答案是第 7 层。', 'The answer is shelf 7.', '答えは 7 段目です。'),
    steps=L(['第 1 到 9 層之中，奇數層是 1、3、5、7、9 層。',
             '比第 8 層低，所以第 9 層排除，剩下 1、3、5、7 層。',
             '不在第 1 層、也不在第 5 層，剩下 3 層和 7 層。',
             '又要比第 3 層高，所以只剩第 7 層。'],
            ['第 1 到 9 层之中，奇数层是 1、3、5、7、9 层。',
             '比第 8 层低，所以第 9 层排除，剩下 1、3、5、7 层。',
             '不在第 1 层、也不在第 5 层，剩下 3 层和 7 层。',
             '又要比第 3 层高，所以只剩第 7 层。'],
            ['Among shelves 1 to 9 the odd ones are 1, 3, 5, 7 and 9.',
             'Being lower than shelf 8 rules out shelf 9, leaving 1, 3, 5 and 7.',
             'Not shelf 1 and not shelf 5 leaves shelves 3 and 7.',
             'Being higher than shelf 3 leaves only shelf 7.'],
            ['1 段目から 9 段目のうち、奇数の段は 1、3、5、7、9 です。',
             '8 段目より下なので 9 段目は消え、1、3、5、7 が残ります。',
             '1 段目でも 5 段目でもないので、3 段目と 7 段目が残ります。',
             'さらに 3 段目より上なので、残るのは 7 段目だけです。']))

R['logic_grade6_foundation_021'] = dict(
    prompt=L('一條公車路線從第 1 站開到第 11 站。小安要下車的那一站是偶數站，在第 9 站之前，不是第 2 站，也不是第 6 站，而且比第 4 站晚。小安在第幾站下車？',
             '一条公交路线从第 1 站开到第 11 站。小安要下车的那一站是偶数站，在第 9 站之前，不是第 2 站，也不是第 6 站，而且比第 4 站晚。小安在第几站下车？',
             'A bus route runs from stop 1 to stop 11. The stop where An gets off is even-numbered, comes before stop 9, is not stop 2 and not stop 6, and comes after stop 4. At which stop does An get off?',
             'あるバス路線は 1 番目のバス停から 11 番目のバス停まで走ります。アンが降りるバス停は偶数番目で、9 番目より前、2 番目でも 6 番目でもなく、4 番目より後です。アンは何番目のバス停で降りますか。'),
    answer=L('答案是第 8 站。', '答案是第 8 站。', 'The answer is stop 8.', '答えは 8 番目のバス停です。'),
    steps=L(['第 1 到 11 站之中，偶數站是 2、4、6、8、10 站。',
             '要在第 9 站之前，所以第 10 站排除，剩下 2、4、6、8 站。',
             '不是第 2 站、也不是第 6 站，剩下第 4 站和第 8 站。',
             '又要比第 4 站晚，所以只剩第 8 站。'],
            ['第 1 到 11 站之中，偶数站是 2、4、6、8、10 站。',
             '要在第 9 站之前，所以第 10 站排除，剩下 2、4、6、8 站。',
             '不是第 2 站、也不是第 6 站，剩下第 4 站和第 8 站。',
             '又要比第 4 站晚，所以只剩第 8 站。'],
            ['Among stops 1 to 11 the even ones are 2, 4, 6, 8 and 10.',
             'Coming before stop 9 rules out stop 10, leaving 2, 4, 6 and 8.',
             'Not stop 2 and not stop 6 leaves stops 4 and 8.',
             'Coming after stop 4 leaves only stop 8.'],
            ['1 番目から 11 番目のうち、偶数番目は 2、4、6、8、10 です。',
             '9 番目より前なので 10 番目は消え、2、4、6、8 が残ります。',
             '2 番目でも 6 番目でもないので、4 番目と 8 番目が残ります。',
             'さらに 4 番目より後なので、残るのは 8 番目だけです。']))

R['logic_grade3_foundation_017'] = dict(
    prompt=L('一列火車有 5 節車廂，從車頭數起是第 1 節到第 5 節。小安的座位在第 2 節車廂後面、第 5 節車廂前面，而且不在第 4 節。小安坐在第幾節車廂？',
             '一列火车有 5 节车厢，从车头数起是第 1 节到第 5 节。小安的座位在第 2 节车厢后面、第 5 节车厢前面，而且不在第 4 节。小安坐在第几节车厢？',
             'A train has 5 carriages, numbered 1 to 5 from the front. An\'s seat is behind carriage 2 and in front of carriage 5, and it is not in carriage 4. Which carriage is An sitting in?',
             '列車には車両が 5 両あり、先頭から 1 両目から 5 両目までです。アンの席は 2 両目より後ろ、5 両目より前で、4 両目ではありません。アンは何両目にすわっていますか。'),
    answer=L('答案是第 3 節。', '答案是第 3 节。', 'The answer is carriage 3.', '答えは 3 両目です。'),
    steps=L(['在第 2 節後面、第 5 節前面，可能是第 3 節或第 4 節。',
             '再把第 4 節排除，只剩第 3 節。'],
            ['在第 2 节后面、第 5 节前面，可能是第 3 节或第 4 节。',
             '再把第 4 节排除，只剩第 3 节。'],
            ['Behind carriage 2 and in front of carriage 5 leaves carriages 3 and 4.',
             'Ruling out carriage 4 leaves only carriage 3.'],
            ['2 両目より後ろ、5 両目より前なので、3 両目か 4 両目です。',
             '4 両目を除くと、残るのは 3 両目だけです。']))

R['logic_grade4_foundation_018'] = dict(
    prompt=L('某商店在這個月的 1 號到 7 號之間只公休一天。公休日比 3 號晚、比 7 號早，不是 6 號，也不是 4 號。公休日是幾號？',
             '某商店在这个月的 1 号到 7 号之间只公休一天。公休日比 3 号晚、比 7 号早，不是 6 号，也不是 4 号。公休日是几号？',
             'A shop closes for exactly one day between the 1st and the 7th of this month. The closing day is later than the 3rd and earlier than the 7th, and it is neither the 6th nor the 4th. On which date does the shop close?',
             'ある店は今月の 1 日から 7 日のあいだに 1 日だけ休みます。休みの日は 3 日より後、7 日より前で、6 日でも 4 日でもありません。休みは何日ですか。'),
    answer=L('答案是 5 號。', '答案是 5 号。', 'The answer is the 5th.', '答えは 5 日です。'),
    steps=L(['比 3 號晚、比 7 號早，可能是 4、5、6 號。',
             '再把 6 號和 4 號排除，只剩 5 號。'],
            ['比 3 号晚、比 7 号早，可能是 4、5、6 号。',
             '再把 6 号和 4 号排除，只剩 5 号。'],
            ['Later than the 3rd and earlier than the 7th leaves the 4th, 5th and 6th.',
             'Ruling out the 6th and the 4th leaves only the 5th.'],
            ['3 日より後、7 日より前なので、4 日、5 日、6 日が候補です。',
             '6 日と 4 日を除くと、残るのは 5 日だけです。']))

R['logic_grade5_foundation_015'] = dict(
    prompt=L('一排停車位由左到右編號 1 到 8，其中只有一個是空的。這個空車位在 3 號右邊、8 號左邊，不是 7 號、不是 6 號，也不是 4 號。空的是幾號車位？',
             '一排停车位由左到右编号 1 到 8，其中只有一个是空的。这个空车位在 3 号右边、8 号左边，不是 7 号、不是 6 号，也不是 4 号。空的是几号车位？',
             'A row of parking spaces is numbered 1 to 8 from the left, and exactly one of them is empty. The empty space is to the right of number 3 and to the left of number 8, and it is not number 7, not number 6 and not number 4. Which space is empty?',
             '駐車スペースが左から 1 番から 8 番までならんでいて、空いているのは 1 か所だけです。その空きスペースは 3 番より右、8 番より左で、7 番でも 6 番でも 4 番でもありません。空いているのは何番ですか。'),
    answer=L('答案是 5 號車位。', '答案是 5 号车位。', 'The answer is space 5.', '答えは 5 番です。'),
    steps=L(['在 3 號右邊、8 號左邊，可能是 4、5、6、7 號。',
             '再把 7 號、6 號和 4 號排除，只剩 5 號。'],
            ['在 3 号右边、8 号左边，可能是 4、5、6、7 号。',
             '再把 7 号、6 号和 4 号排除，只剩 5 号。'],
            ['To the right of 3 and to the left of 8 leaves numbers 4, 5, 6 and 7.',
             'Ruling out 7, 6 and 4 leaves only number 5.'],
            ['3 番より右、8 番より左なので、4、5、6、7 番が候補です。',
             '7 番、6 番、4 番を除くと、残るのは 5 番だけです。']))

R['logic_grade6_foundation_018'] = dict(
    prompt=L('一場路跑沿途有 10 個補給站，依序編號 1 到 10。小安中途只停下來休息一次，那一站在第 4 站之後、第 10 站之前，不是第 9 站、不是第 8 站、不是第 7 站，也不是第 6 站。他停在第幾站？',
             '一场路跑沿途有 10 个补给站，依序编号 1 到 10。小安中途只停下来休息一次，那一站在第 4 站之后、第 10 站之前，不是第 9 站、不是第 8 站、不是第 7 站，也不是第 6 站。他停在第几站？',
             'A road race has 10 aid stations along the route, numbered 1 to 10 in order. An stops to rest exactly once, at a station after number 4 and before number 10, which is not number 9, not number 8, not number 7 and not number 6. At which station does he stop?',
             'ロードレースのコースには 1 番から 10 番までの給水所が順にあります。アンは途中で 1 回だけ休みました。その給水所は 4 番より後、10 番より前で、9 番でも 8 番でも 7 番でも 6 番でもありません。アンは何番の給水所で休みましたか。'),
    answer=L('答案是第 5 站。', '答案是第 5 站。', 'The answer is station 5.', '答えは 5 番です。'),
    steps=L(['在第 4 站之後、第 10 站之前，可能是第 5、6、7、8、9 站。',
             '不是第 9 站、也不是第 8 站，剩下第 5、6、7 站。',
             '再把第 7 站和第 6 站排除，只剩第 5 站。'],
            ['在第 4 站之后、第 10 站之前，可能是第 5、6、7、8、9 站。',
             '不是第 9 站、也不是第 8 站，剩下第 5、6、7 站。',
             '再把第 7 站和第 6 站排除，只剩第 5 站。'],
            ['After station 4 and before station 10 leaves stations 5, 6, 7, 8 and 9.',
             'Not station 9 and not station 8 leaves stations 5, 6 and 7.',
             'Ruling out station 7 and station 6 leaves only station 5.'],
            ['4 番より後、10 番より前なので、5、6、7、8、9 番が候補です。',
             '9 番でも 8 番でもないので、5、6、7 番が残ります。',
             '7 番と 6 番を除くと、残るのは 5 番だけです。']))

R['logic_grade6_foundation_022'] = dict(
    prompt=L('老師要把班上同學依座號除以 9 的餘數分組，餘數相同的分在同一組。最少要有幾位同學，才能保證一定有某一組裡至少有 2 個人？',
             '老师要把班上同学依座号除以 9 的余数分组，余数相同的分在同一组。最少要有几位同学，才能保证一定有某一组里至少有 2 个人？',
             'A teacher groups the students by the remainder their seat number leaves when divided by 9, putting students with the same remainder in the same group. At least how many students are needed to guarantee that some group contains at least 2 people?',
             '先生は、出席番号を 9 でわった余りによって生徒を分け、余りが同じ生徒を同じ組にします。どこかの組に少なくとも 2 人いることを確実にするには、生徒は少なくとも何人必要ですか。'),
    answer=L('答案是 10 位。', '答案是 10 位。', 'The answer is 10.', '答えは 10 人です。'),
    steps=L(['除以 9 的餘數只有 0、1、2、⋯、8 共 9 種，所以最多只能分成 9 組。',
             '如果只有 9 位同學，有可能每一組剛好各 1 人，還不能保證。',
             '再多 1 位就一定有人和別人同組，所以最少要 10 位同學。'],
            ['除以 9 的余数只有 0、1、2、⋯、8 共 9 种，所以最多只能分成 9 组。',
             '如果只有 9 位同学，有可能每一组刚好各 1 人，还不能保证。',
             '再多 1 位就一定有人和别人同组，所以最少要 10 位同学。'],
            ['Dividing by 9 leaves only the 9 possible remainders 0, 1, 2, …, 8, so there are at most 9 groups.',
             'With just 9 students it is possible for every group to hold exactly 1 person, so that is not yet a guarantee.',
             'One more student must share a group with someone, so at least 10 students are needed.'],
            ['9 でわった余りは 0、1、2、⋯、8 の 9 通りしかないので、組は多くても 9 つです。',
             '生徒が 9 人だけなら、どの組もちょうど 1 人ということがありえるので、まだ確実ではありません。',
             'もう 1 人ふえると必ずだれかと同じ組になるので、少なくとも 10 人必要です。']))

R['arithmetic_grade3_foundation_031'] = dict(
    prompt=L('一個密碼鎖上有兩個轉盤，每個轉盤上都刻著 1、2、3、4 四個數字。規定兩個轉盤上轉出的數字不可以相同。這個鎖一共可以設定出幾種不同的密碼？',
             '一个密码锁上有两个转盘，每个转盘上都刻着 1、2、3、4 四个数字。规定两个转盘上转出的数字不可以相同。这个锁一共可以设定出几种不同的密码？',
             'A combination lock has two dials, and each dial is marked with the four digits 1, 2, 3 and 4. The two dials must not show the same digit. How many different combinations can the lock be set to?',
             'ダイヤルが 2 つある番号じょうがあり、どちらのダイヤルにも 1、2、3、4 の 4 つの数字がきざまれています。2 つのダイヤルに同じ数字を出すことはできません。この錠には何通りの番号を設定できますか。'),
    answer=L('答案是 12 種。', '答案是 12 种。', 'The answer is 12.', '答えは 12 通りです。'),
    steps=L(['第一個轉盤有 1、2、3、4 共 4 種選擇。',
             '第二個轉盤不能和第一個相同，所以只剩 3 種選擇。',
             '兩個轉盤合起來是 4 × 3 = 12 種密碼。'],
            ['第一个转盘有 1、2、3、4 共 4 种选择。',
             '第二个转盘不能和第一个相同，所以只剩 3 种选择。',
             '两个转盘合起来是 4 × 3 = 12 种密码。'],
            ['The first dial has 4 choices: 1, 2, 3 or 4.',
             'The second dial cannot match the first, so only 3 choices are left.',
             'Together the dials give 4 × 3 = 12 combinations.'],
            ['1 つ目のダイヤルは 1、2、3、4 の 4 通りです。',
             '2 つ目は 1 つ目と同じにできないので、残りは 3 通りです。',
             '合わせて 4 × 3 = 12 通りの番号が作れます。']))

NOTE = ('Rewritten 2026-08-28 to clear a duplicate group found by '
        'tool/question_bank_duplicate_audit.dart. The constraints, reasoning and answer are '
        'unchanged; the shared hidden-in-numbered-container wording was reused across grades, '
        'so this one now has its own concrete situation.')

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
        lens = {k: len(v) for k, v in spec['steps'].items()}
        assert len(set(lens.values())) == 1, (q['id'], lens)
        dirty = True
        changed += 1
        print('改寫 %-40s -> %s' % (q['id'], q['correctAnswer']['value']))
    if dirty:
        io.open(path, 'w', encoding='utf-8').write(
            json.dumps(pack, ensure_ascii=False, indent=2) + '\n')
if changed != len(R):
    sys.exit('預期 %d 題，實際 %d 題' % (len(R), changed))
print('共改寫 %d 題' % changed)
