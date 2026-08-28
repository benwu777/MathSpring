#!/usr/bin/env python3
"""去重改寫第一批：規律數列與配對計數。

依使用者裁示，近似題一律改寫應用情境而非刪除。
來源：tool/question_bank_duplicate_audit.dart 的候選群組，再用重疊係數排序。

處理的兩群：
  arithmetic/pattern + logic/pattern —— 十題共用「數列是 a、b、c、d。下一個數是多少？」
      的抽象句型。其中 arithmetic_grade3_027 與 logic_grade2_027 連數列都一樣（2、5、9、14），
      所以後者連數字一起換掉。
  arithmetic/pair_counting —— 三題共用「從 1 到 n 任選兩個不同數字，和為 k 有幾種」。

答案一律不變，只換敘述（logic_grade2_027 例外，數列換成 3、6、10、15，答案 20 → 21）。
"""
import glob, io, json, sys

def L(zh, zhs, en, ja):
    return {'zh-Hant': zh, 'zh-Hans': zhs, 'en': en, 'ja': ja}

R = {}

R['arithmetic_grade1_foundation_009'] = dict(
    prompt=L('保齡球瓶排成一個三角形。只排第 1 排時一共有 1 瓶，排到第 2 排時一共有 3 瓶，排到第 3 排時一共有 6 瓶，排到第 4 排時一共有 10 瓶。照這個規律，排到第 5 排時一共有幾瓶？',
             '保龄球瓶排成一个三角形。只排第 1 排时一共有 1 瓶，排到第 2 排时一共有 3 瓶，排到第 3 排时一共有 6 瓶，排到第 4 排时一共有 10 瓶。照这个规律，排到第 5 排时一共有几瓶？',
             'Bowling pins are set out in a triangle. With only row 1 there is 1 pin in all, up to row 2 there are 3 pins, up to row 3 there are 6 pins, and up to row 4 there are 10 pins. Following this pattern, how many pins are there in all up to row 5?',
             'ボウリングのピンを三角形にならべます。1 列目までで 1 本、2 列目までで 3 本、3 列目までで 6 本、4 列目までで 10 本になります。この決まりで、5 列目までならべると全部で何本になりますか。'),
    answer=L('答案是 15 瓶。', '答案是 15 瓶。', 'The answer is 15 pins.', '答えは 15 本です。'),
    steps=L(['每多排一排，總數增加的量分別是 2、3、4。',
             '所以排到第 5 排時，要再增加 5 瓶。',
             '10 + 5 = 15 瓶。'],
            ['每多排一排，总数增加的量分别是 2、3、4。',
             '所以排到第 5 排时，要再增加 5 瓶。',
             '10 + 5 = 15 瓶。'],
            ['Each new row adds 2, then 3, then 4 pins to the total.',
             'So reaching row 5 adds another 5 pins.',
             '10 + 5 = 15 pins.'],
            ['1 列ふえるごとに、合計は 2 本、3 本、4 本とふえています。',
             'したがって 5 列目までならべると、さらに 5 本ふえます。',
             '10 + 5 = 15 本です。']))

R['arithmetic_grade1_foundation_015'] = dict(
    prompt=L('一株小樹苗剛種下時高 2 公分，之後每過一週長高的公分數都一樣。第 1 週後量到 5 公分，第 2 週後 8 公分，第 3 週後 11 公分。第 4 週後這株小樹苗會有幾公分高？',
             '一株小树苗刚种下时高 2 厘米，之后每过一周长高的厘米数都一样。第 1 周后量到 5 厘米，第 2 周后 8 厘米，第 3 周后 11 厘米。第 4 周后这株小树苗会有几厘米高？',
             'A seedling is 2 cm tall when it is planted, and it grows the same number of centimetres every week after that. It measures 5 cm after week 1, 8 cm after week 2 and 11 cm after week 3. How many centimetres tall will it be after week 4?',
             '苗木を植えたときの高さは 2 cm で、そのあとは毎週同じだけ高くなります。1 週間後は 5 cm、2 週間後は 8 cm、3 週間後は 11 cm でした。4 週間後の高さは何 cm になりますか。'),
    answer=L('答案是 14 公分。', '答案是 14 厘米。', 'The answer is 14 cm.', '答えは 14 cm です。'),
    steps=L(['從 2 到 5、5 到 8、8 到 11，每週都長高 3 公分。',
             '11 再加 3 就是第 4 週後的高度，也就是 14 公分。'],
            ['从 2 到 5、5 到 8、8 到 11，每周都长高 3 厘米。',
             '11 再加 3 就是第 4 周后的高度，也就是 14 厘米。'],
            ['From 2 to 5, from 5 to 8 and from 8 to 11, the seedling gains 3 cm each week.',
             'Adding 3 to 11 gives the height after week 4, which is 14 cm.'],
            ['2 から 5、5 から 8、8 から 11 と、毎週 3 cm ずつ高くなっています。',
             '11 に 3 をたすと 4 週間後の高さになり、14 cm です。']))

R['arithmetic_grade2_foundation_011'] = dict(
    prompt=L('小美每天往存錢筒裡放錢。第 1 天結束時筒裡有 4 元，第 2 天結束時有 7 元，第 3 天結束時有 11 元，第 4 天結束時有 16 元。照這個規律，第 5 天結束時筒裡有幾元？',
             '小美每天往存钱筒里放钱。第 1 天结束时筒里有 4 元，第 2 天结束时有 7 元，第 3 天结束时有 11 元，第 4 天结束时有 16 元。照这个规律，第 5 天结束时筒里有几元？',
             'Mei puts money into her money box every day. At the end of day 1 the box holds 4 dollars, at the end of day 2 it holds 7, at the end of day 3 it holds 11 and at the end of day 4 it holds 16. Following this pattern, how many dollars does it hold at the end of day 5?',
             'メイは毎日ちょきん箱にお金を入れます。1 日目の終わりには 4 円、2 日目の終わりには 7 円、3 日目の終わりには 11 円、4 日目の終わりには 16 円になりました。この決まりで、5 日目の終わりには何円になりますか。'),
    answer=L('答案是 22 元。', '答案是 22 元。', 'The answer is 22 dollars.', '答えは 22 円です。'),
    steps=L(['每天新增的錢依序是 3 元、4 元、5 元，一天比一天多 1 元。',
             '所以第 5 天要新增 6 元。',
             '16 + 6 = 22 元。'],
            ['每天新增的钱依次是 3 元、4 元、5 元，一天比一天多 1 元。',
             '所以第 5 天要新增 6 元。',
             '16 + 6 = 22 元。'],
            ['The amounts added each day are 3, then 4, then 5 dollars, one more each day.',
             'So on day 5 she adds 6 dollars.',
             '16 + 6 = 22 dollars.'],
            ['毎日ふえる金額は 3 円、4 円、5 円と、1 日ごとに 1 円ずつ多くなっています。',
             'したがって 5 日目は 6 円ふえます。',
             '16 + 6 = 22 円です。']))

R['arithmetic_grade2_foundation_015'] = dict(
    prompt=L('電影院的座位一排比一排多，而且每一排都比前一排多同樣多的座位。第 1 排有 6 個座位，第 2 排有 10 個，第 3 排有 14 個，第 4 排有 18 個。第 5 排有幾個座位？',
             '电影院的座位一排比一排多，而且每一排都比前一排多同样多的座位。第 1 排有 6 个座位，第 2 排有 10 个，第 3 排有 14 个，第 4 排有 18 个。第 5 排有几个座位？',
             'Each row of a cinema has more seats than the one before it, and every row adds the same number of seats. Row 1 has 6 seats, row 2 has 10, row 3 has 14 and row 4 has 18. How many seats does row 5 have?',
             '映画館の座席は後ろの列ほど多く、どの列も前の列より同じ数だけ多くなっています。1 列目は 6 席、2 列目は 10 席、3 列目は 14 席、4 列目は 18 席です。5 列目は何席ですか。'),
    answer=L('答案是 22 個座位。', '答案是 22 个座位。', 'The answer is 22 seats.', '答えは 22 席です。'),
    steps=L(['從 6 到 10、10 到 14、14 到 18，每一排都多 4 個座位。',
             '18 再加 4 就是第 5 排，也就是 22 個座位。'],
            ['从 6 到 10、10 到 14、14 到 18，每一排都多 4 个座位。',
             '18 再加 4 就是第 5 排，也就是 22 个座位。'],
            ['From 6 to 10, from 10 to 14 and from 14 to 18, each row gains 4 seats.',
             'Adding 4 to 18 gives row 5, which is 22 seats.'],
            ['6 から 10、10 から 14、14 から 18 と、どの列も 4 席ずつふえています。',
             '18 に 4 をたすと 5 列目になり、22 席です。']))

R['arithmetic_grade2_foundation_039'] = dict(
    prompt=L('一台飲料機每天結束時記錄一次剩下的罐數，前 6 天的紀錄依序是 10、9、12、11、14、13。照這個變化規律，第 7 天記錄到的罐數是多少？',
             '一台饮料机每天结束时记录一次剩下的罐数，前 6 天的记录依次是 10、9、12、11、14、13。照这个变化规律，第 7 天记录到的罐数是多少？',
             'A drinks machine records how many cans are left at the end of each day. The records for the first six days are 10, 9, 12, 11, 14, 13. Following this pattern, what number is recorded on day 7?',
             '自動販売機は毎日の終わりに残りの本数を記録します。はじめの 6 日間の記録は順に 10、9、12、11、14、13 でした。この決まりで、7 日目に記録される本数はいくつですか。'),
    answer=L('答案是 16 罐。', '答案是 16 罐。', 'The answer is 16 cans.', '答えは 16 本です。'),
    steps=L(['觀察前後兩天的變化：10 到 9 是減 1，9 到 12 是加 3，接下來又是減 1、加 3，「減 1、加 3」交替出現。',
             '第 6 天是 13，前一步是減 1，所以第 7 天輪到加 3：13 + 3 = 16 罐。'],
            ['观察前后两天的变化：10 到 9 是减 1，9 到 12 是加 3，接下来又是减 1、加 3，「减 1、加 3」交替出现。',
             '第 6 天是 13，前一步是减 1，所以第 7 天轮到加 3：13 + 3 = 16 罐。'],
            ['Look at the change from one day to the next: 10 to 9 is minus 1, 9 to 12 is plus 3, and after that minus 1 and plus 3 keep alternating.',
             'Day 6 is 13 and the step before it was minus 1, so day 7 takes a plus 3: 13 + 3 = 16 cans.'],
            ['前の日との変化を見ると、10 から 9 は −1、9 から 12 は +3 で、そのあとも −1 と +3 が交互にくり返されています。',
             '6 日目は 13 で、その直前は −1 だったので、7 日目は +3 の番です。13 + 3 = 16 本です。']))

R['arithmetic_grade3_foundation_027'] = dict(
    prompt=L('一座體育館的觀眾席分成好幾區，區號越大排數越多。第 1 區有 2 排，第 2 區有 5 排，第 3 區有 9 排，第 4 區有 14 排。照這個規律，第 5 區有幾排？',
             '一座体育馆的观众席分成好几区，区号越大排数越多。第 1 区有 2 排，第 2 区有 5 排，第 3 区有 9 排，第 4 区有 14 排。照这个规律，第 5 区有几排？',
             'The seating in a stadium is divided into sections, and sections with larger numbers have more rows. Section 1 has 2 rows, section 2 has 5 rows, section 3 has 9 rows and section 4 has 14 rows. Following this pattern, how many rows does section 5 have?',
             '体育館の観客席はいくつかの区画に分かれていて、番号が大きい区画ほど列の数が多くなります。1 区画目は 2 列、2 区画目は 5 列、3 区画目は 9 列、4 区画目は 14 列です。この決まりで、5 区画目は何列ですか。'),
    answer=L('答案是 20 排。', '答案是 20 排。', 'The answer is 20 rows.', '答えは 20 列です。'),
    steps=L(['每一區比前一區多出的排數依序是 3、4、5，一次比一次多 1。',
             '所以第 5 區要比第 4 區多 6 排。',
             '14 + 6 = 20 排。'],
            ['每一区比前一区多出的排数依次是 3、4、5，一次比一次多 1。',
             '所以第 5 区要比第 4 区多 6 排。',
             '14 + 6 = 20 排。'],
            ['Each section has 3, then 4, then 5 more rows than the one before, one more each time.',
             'So section 5 has 6 more rows than section 4.',
             '14 + 6 = 20 rows.'],
            ['前の区画より多い列の数は 3、4、5 と、1 つずつ大きくなっています。',
             'したがって 5 区画目は 4 区画目より 6 列多くなります。',
             '14 + 6 = 20 列です。']))

R['arithmetic_grade3_foundation_030'] = dict(
    prompt=L('用一樣大的小方塊排成實心的正方形。邊長 1 塊時要用 1 塊，邊長 2 塊時要用 4 塊，邊長 3 塊時要用 9 塊，邊長 4 塊時要用 16 塊。邊長 5 塊時要用幾塊？',
             '用一样大的小方块排成实心的正方形。边长 1 块时要用 1 块，边长 2 块时要用 4 块，边长 3 块时要用 9 块，边长 4 块时要用 16 块。边长 5 块时要用几块？',
             'Identical small tiles are used to build solid squares. A square 1 tile across needs 1 tile, 2 across needs 4 tiles, 3 across needs 9 tiles and 4 across needs 16 tiles. How many tiles are needed for a square 5 tiles across?',
             '同じ大きさの小さなタイルをすきまなくならべて正方形を作ります。1 辺が 1 個のときは 1 個、2 個のときは 4 個、3 個のときは 9 個、4 個のときは 16 個必要です。1 辺が 5 個のときは何個必要ですか。'),
    answer=L('答案是 25 塊。', '答案是 25 块。', 'The answer is 25 tiles.', '答えは 25 個です。'),
    steps=L(['邊長 n 塊的正方形，每一排有 n 塊，一共有 n 排。',
             '所以要用的塊數是 n × n：1×1 = 1、2×2 = 4、3×3 = 9、4×4 = 16，和題目相符。',
             '邊長 5 塊時是 5 × 5 = 25 塊。'],
            ['边长 n 块的正方形，每一排有 n 块，一共有 n 排。',
             '所以要用的块数是 n × n：1×1 = 1、2×2 = 4、3×3 = 9、4×4 = 16，和题目相符。',
             '边长 5 块时是 5 × 5 = 25 块。'],
            ['A square that is n tiles across has n tiles in each row and n rows altogether.',
             'So the number of tiles is n × n: 1×1 = 1, 2×2 = 4, 3×3 = 9 and 4×4 = 16, which matches the question.',
             'For 5 tiles across it is 5 × 5 = 25 tiles.'],
            ['1 辺が n 個の正方形は、1 列に n 個ならび、それが n 列あります。',
             'したがって必要な数は n × n で、1×1 = 1、2×2 = 4、3×3 = 9、4×4 = 16 となり問題と合います。',
             '1 辺が 5 個のときは 5 × 5 = 25 個です。']))

R['logic_grade1_foundation_012'] = dict(
    prompt=L('地上畫著一排格子，從左邊開始編號 1、2、3、⋯。小安從第 1 格出發，接著跳到第 3 格，再跳到第 5 格，再跳到第 7 格。照這個跳法，下一次會跳到第幾格？',
             '地上画着一排格子，从左边开始编号 1、2、3、⋯。小安从第 1 格出发，接着跳到第 3 格，再跳到第 5 格，再跳到第 7 格。照这个跳法，下一次会跳到第几格？',
             'A row of squares is drawn on the ground, numbered 1, 2, 3, … from the left. An starts on square 1, then jumps to square 3, then to square 5, then to square 7. Following this pattern, which square does the next jump land on?',
             '地面に左から 1、2、3、⋯ と番号のついたマスが一列にかかれています。アンは 1 のマスから出発して、3 のマス、5 のマス、7 のマスへとんでいきました。この決まりで、次はどのマスにとびますか。'),
    answer=L('答案是第 9 格。', '答案是第 9 格。', 'The answer is square 9.', '答えは 9 のマスです。'),
    steps=L(['每次跳到的格子號碼都比前一次多 2。',
             '7 加 2 等於 9，所以下一次跳到第 9 格。'],
            ['每次跳到的格子号码都比前一次多 2。',
             '7 加 2 等于 9，所以下一次跳到第 9 格。'],
            ['Each landing square is numbered 2 more than the one before.',
             '7 plus 2 is 9, so the next jump lands on square 9.'],
            ['とんだマスの番号は、前より 2 ずつ大きくなっています。',
             '7 に 2 をたすと 9 なので、次は 9 のマスにとびます。']))

R['logic_grade2_foundation_012'] = dict(
    prompt=L('小樂用積木疊塔，每一層放的積木數都是前一層的固定倍數。第 1 層放 3 塊，第 2 層放 6 塊，第 3 層放 12 塊，第 4 層放 24 塊。第 5 層要放幾塊？',
             '小乐用积木叠塔，每一层放的积木数都是前一层的固定倍数。第 1 层放 3 块，第 2 层放 6 块，第 3 层放 12 块，第 4 层放 24 块。第 5 层要放几块？',
             'Le builds a tower of blocks, and each level uses the same fixed multiple of the level below it. Level 1 uses 3 blocks, level 2 uses 6, level 3 uses 12 and level 4 uses 24. How many blocks does level 5 use?',
             'レはつみ木でとうを作ります。どの段も、すぐ下の段の決まった倍の数のつみ木を使います。1 段目は 3 個、2 段目は 6 個、3 段目は 12 個、4 段目は 24 個です。5 段目は何個使いますか。'),
    answer=L('答案是 48 塊。', '答案是 48 块。', 'The answer is 48 blocks.', '答えは 48 個です。'),
    steps=L(['3 到 6、6 到 12、12 到 24，每一層都是前一層的 2 倍。',
             '24 乘以 2 等於 48，所以第 5 層要放 48 塊。'],
            ['3 到 6、6 到 12、12 到 24，每一层都是前一层的 2 倍。',
             '24 乘以 2 等于 48，所以第 5 层要放 48 块。'],
            ['From 3 to 6, from 6 to 12 and from 12 to 24, each level is double the one below.',
             '24 times 2 is 48, so level 5 uses 48 blocks.'],
            ['3 から 6、6 から 12、12 から 24 と、どの段も下の段の 2 倍になっています。',
             '24 × 2 = 48 なので、5 段目は 48 個です。']))

R['logic_grade2_foundation_027'] = dict(
    prompt=L('小安每天在牆上貼貼紙，貼紙的總張數一天比一天多。第 1 天貼完是 3 張，第 2 天貼完是 6 張，第 3 天貼完是 10 張，第 4 天貼完是 15 張。照這個規律，第 5 天貼完會是幾張？',
             '小安每天在墙上贴贴纸，贴纸的总张数一天比一天多。第 1 天贴完是 3 张，第 2 天贴完是 6 张，第 3 天贴完是 10 张，第 4 天贴完是 15 张。照这个规律，第 5 天贴完会是几张？',
             'An puts stickers on the wall each day, and the total grows day by day. After day 1 there are 3 stickers, after day 2 there are 6, after day 3 there are 10 and after day 4 there are 15. Following this pattern, how many stickers are there after day 5?',
             'アンは毎日かべにシールをはり、合計のまい数は日ごとにふえていきます。1 日目の終わりは 3 まい、2 日目は 6 まい、3 日目は 10 まい、4 日目は 15 まいでした。この決まりで、5 日目の終わりは何まいですか。'),
    answer=L('答案是 21 張。', '答案是 21 张。', 'The answer is 21 stickers.', '答えは 21 まいです。'),
    steps=L(['每天新增的張數依序是 3、4、5，一天比一天多 1 張。',
             '所以第 5 天要新增 6 張。',
             '15 + 6 = 21 張。'],
            ['每天新增的张数依次是 3、4、5，一天比一天多 1 张。',
             '所以第 5 天要新增 6 张。',
             '15 + 6 = 21 张。'],
            ['The stickers added each day are 3, then 4, then 5, one more each day.',
             'So day 5 adds 6 stickers.',
             '15 + 6 = 21 stickers.'],
            ['毎日ふえるまい数は 3、4、5 と、1 日ごとに 1 まいずつ多くなっています。',
             'したがって 5 日目は 6 まいふえます。',
             '15 + 6 = 21 まいです。']),
    correct='21')

R['arithmetic_grade1_foundation_013'] = dict(
    prompt=L('桌上有 6 張卡片，分別寫著 1、2、3、4、5、6。小安要拿走兩張，讓這兩張卡片上的數字加起來剛好是 7。他有幾種不同的拿法？',
             '桌上有 6 张卡片，分别写着 1、2、3、4、5、6。小安要拿走两张，让这两张卡片上的数字加起来刚好是 7。他有几种不同的拿法？',
             'Six cards on the table show 1, 2, 3, 4, 5 and 6. An wants to take away two cards whose numbers add up to exactly 7. In how many different ways can he do this?',
             'つくえの上に 1、2、3、4、5、6 と書かれた 6 まいのカードがあります。アンは、書かれた数の和がちょうど 7 になるように 2 まい取ります。取り方は何通りありますか。'),
    answer=L('答案是 3 種。', '答案是 3 种。', 'The answer is 3.', '答えは 3 通りです。'),
    steps=L(['從最小的卡片開始配：1 要配 6，2 要配 5，3 要配 4。',
             '再往下 4 要配 3，但那和「3 配 4」是同一種拿法，不能重複算。',
             '所以一共有 3 種拿法。'],
            ['从最小的卡片开始配：1 要配 6，2 要配 5，3 要配 4。',
             '再往下 4 要配 3，但那和「3 配 4」是同一种拿法，不能重复算。',
             '所以一共有 3 种拿法。'],
            ['Start from the smallest card: 1 pairs with 6, 2 pairs with 5 and 3 pairs with 4.',
             'Going on, 4 would pair with 3, but that is the same pair as 3 with 4 and must not be counted twice.',
             'So there are 3 ways in all.'],
            ['小さいカードから組にします。1 は 6 と、2 は 5 と、3 は 4 と組になります。',
             '次の 4 は 3 と組になりますが、これは「3 と 4」と同じ組なので二重に数えてはいけません。',
             'したがって取り方は全部で 3 通りです。']))

R['arithmetic_grade2_foundation_013'] = dict(
    prompt=L('9 位小朋友身上分別別著 1 到 9 的號碼牌，每人一個號碼。老師要把其中一些人兩兩配成一組，規定同一組兩人的號碼加起來要是 10，而且每個人最多只能參加一組。最多可以配成幾組？',
             '9 位小朋友身上分别别着 1 到 9 的号码牌，每人一个号码。老师要把其中一些人两两配成一组，规定同一组两人的号码加起来要是 10，而且每个人最多只能参加一组。最多可以配成几组？',
             'Nine children wear number badges 1 to 9, one number each. The teacher pairs some of them up so that the two numbers in a pair add up to 10, and nobody may be in more than one pair. At most how many pairs can be formed?',
             '9 人の子どもが 1 から 9 までの番号ふだを 1 つずつつけています。先生は、2 人の番号の和が 10 になるように何組か組をつくります。1 人が入れる組は多くても 1 つです。組は最も多くていくつできますか。'),
    answer=L('答案是 4 組。', '答案是 4 组。', 'The answer is 4 pairs.', '答えは 4 組です。'),
    steps=L(['把號碼從小到大配對：1 配 9、2 配 8、3 配 7、4 配 6。',
             '5 號沒有辦法配對，因為 5 + 5 = 10 需要兩個 5，但號碼牌只有一個 5。',
             '所以最多可以配成 4 組。'],
            ['把号码从小到大配对：1 配 9、2 配 8、3 配 7、4 配 6。',
             '5 号没有办法配对，因为 5 + 5 = 10 需要两个 5，但号码牌只有一个 5。',
             '所以最多可以配成 4 组。'],
            ['Pair the numbers from the smallest upwards: 1 with 9, 2 with 8, 3 with 7 and 4 with 6.',
             'Number 5 cannot be paired, because 5 + 5 = 10 would need two badges showing 5 and there is only one.',
             'So at most 4 pairs can be formed.'],
            ['小さい番号から組にします。1 と 9、2 と 8、3 と 7、4 と 6 です。',
             '5 番は組にできません。5 + 5 = 10 には 5 のふだが 2 まい必要ですが、1 まいしかないからです。',
             'したがって組は最も多くて 4 組です。']))

NOTE = ('Rewritten 2026-08-28 to clear a duplicate group found by '
        'tool/question_bank_duplicate_audit.dart. The underlying reasoning and answer are '
        'unchanged; the abstract sequence-or-selection wording was shared word-for-word with '
        'sibling questions in other grades, so this one is now set in its own concrete situation.')

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
        if 'correct' in spec:
            q['correctAnswer'] = dict(q['correctAnswer'], value=spec['correct'])
        q['source'] = dict(q['source'], notes=NOTE)
        lens = {k: len(v) for k, v in spec['steps'].items()}
        assert len(set(lens.values())) == 1, (q['id'], lens)
        dirty = True
        changed += 1
        print('改寫 %-42s -> %s' % (q['id'], q['correctAnswer']['value']))
    if dirty:
        io.open(path, 'w', encoding='utf-8').write(
            json.dumps(pack, ensure_ascii=False, indent=2) + '\n')

if changed != len(R):
    sys.exit('預期改寫 %d 題，實際 %d 題' % (len(R), changed))
print('共改寫 %d 題' % changed)
