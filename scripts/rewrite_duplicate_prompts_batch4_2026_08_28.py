#!/usr/bin/env python3
"""去重改寫第四批：把 0.45-0.65 區間的十組也各給一個情境。

這一區間有不少是工具按 topic+subtopic 分組造成的鬆散配對，兩題其實推理不同，
只是共用開頭句型。依使用者指示一併改寫：推理與答案完全不動，只換敘述。
"""
import glob, io, json, sys

def L(zh, zhs, en, ja):
    return {'zh-Hant': zh, 'zh-Hans': zhs, 'en': en, 'ja': ja}

R = {}

R['geometry_grade3_foundation_007'] = dict(
    prompt=L('一顆棋子放在棋盤上。它先向右移 2 格，再向上移 3 格，最後向左移 2 格。這顆棋子現在在原來位置的哪個方向？',
             '一颗棋子放在棋盘上。它先向右移 2 格，再向上移 3 格，最后向左移 2 格。这颗棋子现在在原来位置的哪个方向？',
             'A game piece sits on a board. It moves 2 squares right, then 3 squares up, then 2 squares left. In which direction from its original square is the piece now?',
             'こまが盤の上に置かれています。こまは右へ 2 ます、次に上へ 3 ます、最後に左へ 2 ます動きました。こまは今、もとのますから見てどの方向にありますか。'),
    answer=L('答案是正上方。', '答案是正上方。', 'The answer is directly above.', '答えは真上です。'),
    steps=L(['先看左右方向：向右移了 2 格，又向左移了 2 格，兩者剛好抵消。',
             '再看上下方向：只向上移了 3 格，沒有向下移。',
             '所以棋子和原來的位置在同一條直線上，位於原來位置的正上方。'],
            ['先看左右方向：向右移了 2 格，又向左移了 2 格，两者刚好抵消。',
             '再看上下方向：只向上移了 3 格，没有向下移。',
             '所以棋子和原来的位置在同一条直线上，位于原来位置的正上方。'],
            ['Look at the left-and-right moves first: 2 squares right and 2 squares left cancel each other exactly.',
             'Now the up-and-down moves: only 3 squares up, and none down.',
             'So the piece is on the same vertical line as its original square, directly above it.'],
            ['まず左右の動きを見ます。右へ 2 ます、左へ 2 ますなので、ちょうど打ち消し合います。',
             '次に上下の動きを見ます。上へ 3 ますだけで、下へは動いていません。',
             'したがってこまはもとのますと同じたての線上にあり、真上にあります。']))

R['geometry_grade2_foundation_046'] = dict(
    prompt=L('一個正方形相框掛在牆上，四個角依順時針方向分別標著 A、B、C、D。小安把相框順時針轉 90 度，連續轉了三次。轉完以後，A 在左下角。轉之前 A 在哪一個角？',
             '一个正方形相框挂在墙上，四个角依顺时针方向分别标着 A、B、C、D。小安把相框顺时针转 90 度，连续转了三次。转完以后，A 在左下角。转之前 A 在哪一个角？',
             'A square picture frame hangs on a wall with its corners labelled A, B, C and D in clockwise order. An turns the frame 90 degrees clockwise, three times in a row. Afterwards A is at the bottom-left corner. Which corner was A at before the turns?',
             '正方形の写真立てがかべにかかっていて、4 すみには時計まわりに A、B、C、D と書かれています。アンはこれを時計まわりに 90 度、続けて 3 回まわしました。まわしたあと A は左下のすみにあります。まわす前、A はどのすみにありましたか。'),
    answer=L('答案是左上角。', '答案是左上角。', 'The answer is the top-left corner.', '答えは左上のすみです。'),
    steps=L(['順時針轉 90 度三次，等於一口氣順時針轉 90 × 3 = 270 度。',
             '要找轉之前的位置，就把結果反過來轉回去：逆時針轉 270 度，也就是順時針轉 90 度。',
             '把左下角順時針轉 90 度，會到左上角。',
             '驗算：左上角順時針轉三次依序到右上角、右下角、左下角，和題目相符。'],
            ['顺时针转 90 度三次，等于一口气顺时针转 90 × 3 = 270 度。',
             '要找转之前的位置，就把结果反过来转回去：逆时针转 270 度，也就是顺时针转 90 度。',
             '把左下角顺时针转 90 度，会到左上角。',
             '验算：左上角顺时针转三次依次到右上角、右下角、左下角，和题目相符。'],
            ['Three clockwise quarter turns amount to one clockwise turn of 90 × 3 = 270 degrees.',
             'To find where A started, undo that: turn 270 degrees anticlockwise, which is the same as 90 degrees clockwise.',
             'Turning the bottom-left corner 90 degrees clockwise lands on the top-left corner.',
             'Check: starting top-left, three clockwise turns give top-right, then bottom-right, then bottom-left, which matches the question.'],
            ['時計まわりに 90 度を 3 回まわすのは、一度に 90 × 3 = 270 度まわすのと同じです。',
             'まわす前の位置を求めるには、逆にもどします。反時計まわりに 270 度、つまり時計まわりに 90 度もどします。',
             '左下のすみを時計まわりに 90 度まわすと、左上のすみになります。',
             '確かめ：左上から時計まわりに 3 回まわすと、右上、右下、左下となり、問題と合います。']))

R['logic_grade5_foundation_035'] = dict(
    prompt=L('一個電子遊戲這樣算分：第 1 關得 3 分，之後每一關的分數都是前一關的 2 倍再減 1 分。第 1 關到第 5 關依序是 3、5、9、17、33 分。第 8 關可以得幾分？',
             '一个电子游戏这样算分：第 1 关得 3 分，之后每一关的分数都是前一关的 2 倍再减 1 分。第 1 关到第 5 关依次是 3、5、9、17、33 分。第 8 关可以得几分？',
             'A video game scores like this: level 1 is worth 3 points, and every later level is worth twice the previous level minus 1 point. Levels 1 to 5 are worth 3, 5, 9, 17 and 33 points. How many points is level 8 worth?',
             'あるゲームの点数は次のように決まります。1 面は 3 点で、それ以降はどの面も前の面の 2 倍から 1 点引いた点数です。1 面から 5 面までは順に 3、5、9、17、33 点です。8 面は何点ですか。'),
    answer=L('答案是 257 分。', '答案是 257 分。', 'The answer is 257 points.', '答えは 257 点です。'),
    steps=L(['第 5 關是 33 分，依規律第 6 關是 33 × 2 − 1 = 65 分。',
             '第 7 關是 65 × 2 − 1 = 129 分。',
             '第 8 關是 129 × 2 − 1 = 257 分。'],
            ['第 5 关是 33 分，依规律第 6 关是 33 × 2 − 1 = 65 分。',
             '第 7 关是 65 × 2 − 1 = 129 分。',
             '第 8 关是 129 × 2 − 1 = 257 分。'],
            ['Level 5 is 33 points, so by the rule level 6 is 33 × 2 − 1 = 65 points.',
             'Level 7 is 65 × 2 − 1 = 129 points.',
             'Level 8 is 129 × 2 − 1 = 257 points.'],
            ['5 面は 33 点なので、決まりより 6 面は 33 × 2 − 1 = 65 点です。',
             '7 面は 65 × 2 − 1 = 129 点です。',
             '8 面は 129 × 2 − 1 = 257 点です。']))

R['geometry_grade1_foundation_029'] = dict(
    prompt=L('美勞課上，小美把 1 張正方形色紙和 2 張一樣大的三角形色紙拼成一個圖案。兩張三角形各用自己的一條邊，完整貼在正方形的兩條不同的邊上，三張色紙互不重疊，貼合的邊不再算在外圍。這個圖案的外圍一共有幾條邊？',
             '美劳课上，小美把 1 张正方形色纸和 2 张一样大的三角形色纸拼成一个图案。两张三角形各用自己的一条边，完整贴在正方形的两条不同的边上，三张色纸互不重叠，贴合的边不再算在外围。这个图案的外围一共有几条边？',
             'In an art lesson Mei joins 1 square sheet and 2 identical triangular sheets into one shape. Each triangle has one of its sides glued exactly onto a different side of the square, the three sheets do not overlap, and a glued side is no longer part of the outline. How many sides does the outline of the shape have?',
             '図工の時間に、メイは 1 まいの正方形の色紙と、同じ大きさの三角形の色紙 2 まいをはり合わせて 1 つの形を作ります。2 まいの三角形はそれぞれ 1 辺を、正方形のちがう 2 つの辺にぴったりはります。3 まいは重ならず、はり合わせた辺は外がわには数えません。この形の外がわの辺は全部で何本ですか。'),
    answer=L('答案是 6 條。', '答案是 6 条。', 'The answer is 6.', '答えは 6 本です。'),
    steps=L(['正方形本來有 4 條邊，其中 2 條被三角形貼住，不再算在外圍，所以正方形還剩 2 條邊露在外面。',
             '每張三角形有 3 條邊，其中 1 條貼在正方形上，剩下 2 條露在外面，兩張就是 4 條。',
             '所以外圍一共有 2 + 4 = 6 條邊。'],
            ['正方形本来有 4 条边，其中 2 条被三角形贴住，不再算在外围，所以正方形还剩 2 条边露在外面。',
             '每张三角形有 3 条边，其中 1 条贴在正方形上，剩下 2 条露在外面，两张就是 4 条。',
             '所以外围一共有 2 + 4 = 6 条边。'],
            ['The square has 4 sides to begin with, and 2 of them are covered by the triangles and no longer count, so 2 of the square\'s sides stay on the outline.',
             'Each triangle has 3 sides, one glued to the square and 2 left showing, so the two triangles give 4 sides.',
             'The outline therefore has 2 + 4 = 6 sides.'],
            ['正方形にはもともと辺が 4 本あり、そのうち 2 本は三角形にはられて外がわに数えないので、外に出ている辺は 2 本です。',
             '三角形は 1 まいにつき辺が 3 本あり、1 本を正方形にはるので外に出ているのは 2 本ずつ、2 まいで 4 本です。',
             'したがって外がわの辺は 2 + 4 = 6 本です。']))

R['arithmetic_grade4_foundation_015'] = dict(
    prompt=L('一個抽獎箱裡有編號 1 到 20 的號碼球，每個號碼各一顆。一次抽出兩顆不同的球，如果兩顆球的號碼相加是偶數就算中獎。中獎的號碼組合一共有幾種？',
             '一个抽奖箱里有编号 1 到 20 的号码球，每个号码各一颗。一次抽出两颗不同的球，如果两颗球的号码相加是偶数就算中奖。中奖的号码组合一共有几种？',
             'A raffle drum holds balls numbered 1 to 20, one ball for each number. Two different balls are drawn at once, and the draw wins if the two numbers add up to an even number. How many winning pairs of numbers are there?',
             'ちゅう選箱に 1 番から 20 番までのボールが 1 個ずつ入っています。ちがう 2 個を同時に取り出し、2 つの番号の和が偶数なら当たりです。当たりになる番号の組は全部で何通りありますか。'),
    answer=L('答案是 90 種。', '答案是 90 种。', 'The answer is 90.', '答えは 90 通りです。'),
    steps=L(['兩個數相加是偶數，只有兩種情形：兩個都是奇數，或兩個都是偶數。',
             '1 到 20 之中有 10 個奇數，也有 10 個偶數。',
             '從 10 個奇數中選兩個有 10 × 9 ÷ 2 = 45 種；從 10 個偶數中選兩個也是 45 種。',
             '所以中獎的號碼組合共有 45 + 45 = 90 種。'],
            ['两个数相加是偶数，只有两种情形：两个都是奇数，或两个都是偶数。',
             '1 到 20 之中有 10 个奇数，也有 10 个偶数。',
             '从 10 个奇数中选两个有 10 × 9 ÷ 2 = 45 种；从 10 个偶数中选两个也是 45 种。',
             '所以中奖的号码组合共有 45 + 45 = 90 种。'],
            ['Two numbers add to an even total only in two cases: both are odd, or both are even.',
             'Among 1 to 20 there are 10 odd numbers and 10 even numbers.',
             'Choosing two of the 10 odd numbers gives 10 × 9 ÷ 2 = 45 ways, and choosing two of the 10 even numbers gives another 45.',
             'So there are 45 + 45 = 90 winning pairs.'],
            ['2 つの数の和が偶数になるのは、両方とも奇数のときか、両方とも偶数のときだけです。',
             '1 から 20 のうち、奇数は 10 個、偶数も 10 個あります。',
             '10 個の奇数から 2 個選ぶのは 10 × 9 ÷ 2 = 45 通り、10 個の偶数から 2 個選ぶのも 45 通りです。',
             'したがって当たりの組は 45 + 45 = 90 通りです。']))

R['geometry_grade6_foundation_026'] = dict(
    prompt=L('一張長方形海報要重新印製：長印成原來的 3 倍，寬印成原來的 2 倍。新海報的面積是原來的幾倍？',
             '一张长方形海报要重新印制：长印成原来的 3 倍，宽印成原来的 2 倍。新海报的面积是原来的几倍？',
             'A rectangular poster is reprinted with its length made 3 times the original and its width made 2 times the original. The new poster has how many times the original area?',
             '長方形のポスターを刷り直します。たての長さはもとの 3 倍、よこの長さはもとの 2 倍にします。新しいポスターの面積はもとの何倍ですか。'),
    answer=L('答案是 6 倍。', '答案是 6 倍。', 'The answer is 6 times.', '答えは 6 倍です。'),
    steps=L(['面積等於長乘寬。',
             '長變成 3 倍、寬變成 2 倍，等於面積乘上 3 再乘上 2。',
             '3 × 2 = 6，所以新海報的面積是原來的 6 倍。'],
            ['面积等于长乘宽。',
             '长变成 3 倍、宽变成 2 倍，等于面积乘上 3 再乘上 2。',
             '3 × 2 = 6，所以新海报的面积是原来的 6 倍。'],
            ['Area is length times width.',
             'Multiplying the length by 3 and the width by 2 multiplies the area by 3 and then by 2.',
             '3 × 2 = 6, so the new poster has 6 times the original area.'],
            ['面積はたて × よこです。',
             'たてを 3 倍、よこを 2 倍にすると、面積は 3 倍してさらに 2 倍になります。',
             '3 × 2 = 6 なので、新しいポスターの面積はもとの 6 倍です。']))

R['arithmetic_grade2_foundation_049'] = dict(
    prompt=L('一大盤水果糖只有草莓、葡萄、檸檬三種口味，包裝完全一樣，看外表分不出來。閉著眼睛從盤子裡拿糖，最少要拿幾顆，才能保證其中一定有 2 顆是同一種口味？',
             '一大盘水果糖只有草莓、葡萄、柠檬三种口味，包装完全一样，看外表分不出来。闭着眼睛从盘子里拿糖，最少要拿几颗，才能保证其中一定有 2 颗是同一种口味？',
             'A big dish of fruit sweets contains only three flavours: strawberry, grape and lemon. The wrappers look exactly the same, so the flavour cannot be told apart. Taking sweets from the dish with your eyes closed, at least how many must you take to be sure of getting 2 of the same flavour?',
             '大きな皿にのったフルーツあめには、いちご、ぶどう、レモンの 3 種類の味しかなく、つつみ紙はまったく同じで見分けがつきません。目をつぶってあめを取るとき、同じ味が 2 個そろうことを確実にするには、少なくとも何個取ればよいですか。'),
    answer=L('答案是 4 顆。', '答案是 4 颗。', 'The answer is 4.', '答えは 4 個です。'),
    steps=L(['口味只有 3 種。',
             '如果只拿 3 顆，有可能剛好三種口味各 1 顆，還沒有 2 顆同口味。',
             '再拿第 4 顆時，不管是哪一種口味，都一定會和前面某一顆重複，所以最少要拿 4 顆。'],
            ['口味只有 3 种。',
             '如果只拿 3 颗，有可能刚好三种口味各 1 颗，还没有 2 颗同口味。',
             '再拿第 4 颗时，不管是哪一种口味，都一定会和前面某一颗重复，所以最少要拿 4 颗。'],
            ['There are only 3 flavours.',
             'Taking just 3 sweets could give one of each flavour, with no two the same.',
             'The 4th sweet must repeat one of the flavours already taken, whichever it is, so at least 4 sweets are needed.'],
            ['味は 3 種類しかありません。',
             '3 個だけ取ると、3 種類が 1 個ずつになることがあり、同じ味が 2 個そろうとはかぎりません。',
             '4 個目を取ると、どの味であってもすでに取った味と必ず重なるので、少なくとも 4 個必要です。']))

R['logic_grade6_foundation_028'] = dict(
    prompt=L('園遊會有三個攤位，得分互不相同，而且都是正整數。任兩個攤位的得分相加，得到的三個和分別是 11、13、16 分。得分最高的攤位得了幾分？',
             '园游会有三个摊位，得分互不相同，而且都是正整数。任两个摊位的得分相加，得到的三个和分别是 11、13、16 分。得分最高的摊位得了几分？',
             'Three stalls at a fair are given scores that are all different positive whole numbers. Adding the scores of each pair of stalls gives the three totals 11, 13 and 16. What score did the highest-scoring stall get?',
             'もよおしの 3 つの店には、たがいにちがう正の整数の点数がつきました。2 店ずつ点数をたすと、3 つの合計は 11、13、16 点になります。いちばん点数が高い店は何点でしたか。'),
    answer=L('答案是 9 分。', '答案是 9 分。', 'The answer is 9.', '答えは 9 点です。'),
    steps=L(['三個和是把每個攤位各算了兩次，所以三個和相加等於三個攤位得分總和的 2 倍。',
             '11 + 13 + 16 = 40，所以三個攤位的得分總和是 40 ÷ 2 = 20 分。',
             '最高分的那個攤位，等於總和扣掉「另外兩個攤位的和」。',
             '另外兩個攤位的和最小時，剩下的那個才最大；三個和之中最小的是 11。',
             '所以最高分是 20 − 11 = 9 分。'],
            ['三个和是把每个摊位各算了两次，所以三个和相加等于三个摊位得分总和的 2 倍。',
             '11 + 13 + 16 = 40，所以三个摊位的得分总和是 40 ÷ 2 = 20 分。',
             '最高分的那个摊位，等于总和扣掉「另外两个摊位的和」。',
             '另外两个摊位的和最小时，剩下的那个才最大；三个和之中最小的是 11。',
             '所以最高分是 20 − 11 = 9 分。'],
            ['The three pair totals count each stall exactly twice, so adding them gives twice the sum of all three scores.',
             '11 + 13 + 16 = 40, so the three scores add up to 40 ÷ 2 = 20.',
             'The highest score equals the overall sum minus the total of the other two stalls.',
             'The remaining stall is largest when the other two add to as little as possible, and the smallest pair total is 11.',
             'So the highest score is 20 − 11 = 9.'],
            ['3 つの合計はどの店も 2 回ずつ数えているので、3 つをたすと 3 店の点数の合計の 2 倍になります。',
             '11 + 13 + 16 = 40 なので、3 店の点数の合計は 40 ÷ 2 = 20 点です。',
             'いちばん高い点数は、全体の合計から「ほかの 2 店の合計」を引いたものです。',
             'ほかの 2 店の合計が最も小さいとき残りが最も大きくなり、3 つの合計のうち最小は 11 です。',
             'したがっていちばん高い点数は 20 − 11 = 9 点です。']))

R['logic_grade2_foundation_024'] = dict(
    prompt=L('箱子裡的球數是 14、21、28 其中之一。哥哥說：「球數是 7 的倍數。」妹妹說：「球數是雙數。」兩人之中恰好有一人說錯。箱子裡有幾顆球？',
             '箱子里的球数是 14、21、28 其中之一。哥哥说：「球数是 7 的倍数。」妹妹说：「球数是双数。」两人之中恰好有一人说错。箱子里有几颗球？',
             'A box holds 14, 21 or 28 balls. The older brother says "The number of balls is a multiple of 7." The younger sister says "The number of balls is even." Exactly one of the two is wrong. How many balls are in the box?',
             '箱の中のボールの数は 14 個、21 個、28 個のいずれかです。兄は「7 の倍数だ」と言い、妹は「偶数だ」と言いました。2 人のうちちょうど 1 人がまちがっています。箱の中には何個入っていますか。'),
    answer=L('答案是 21 顆。', '答案是 21 颗。', 'The answer is 21.', '答えは 21 個です。'),
    steps=L(['14、21、28 三個數都是 7 的倍數，所以哥哥一定說對。',
             '既然恰好有一人說錯，說錯的一定是妹妹，也就是球數不是雙數。',
             '14 和 28 都是雙數，只有 21 是單數。',
             '所以箱子裡有 21 顆球。'],
            ['14、21、28 三个数都是 7 的倍数，所以哥哥一定说对。',
             '既然恰好有一人说错，说错的一定是妹妹，也就是球数不是双数。',
             '14 和 28 都是双数，只有 21 是单数。',
             '所以箱子里有 21 颗球。'],
            ['All three of 14, 21 and 28 are multiples of 7, so the brother is certainly right.',
             'Since exactly one of them is wrong, it must be the sister, so the number is not even.',
             '14 and 28 are both even, and only 21 is odd.',
             'So the box holds 21 balls.'],
            ['14、21、28 はどれも 7 の倍数なので、兄の発言は必ず正しくなります。',
             'まちがっているのがちょうど 1 人なので、まちがっているのは妹、つまり偶数ではありません。',
             '14 と 28 は偶数で、奇数は 21 だけです。',
             'したがって箱の中には 21 個入っています。']))

NOTE = ('Rewritten 2026-08-28 to clear a duplicate group found by '
        'tool/question_bank_duplicate_audit.dart. Conditions, reasoning and answer are unchanged; '
        'only the shared opening wording was replaced with its own situation.')

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
