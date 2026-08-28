#!/usr/bin/env python3
"""去重改寫第五批之一：grade7-12 的 _031 / _032 題。

這批是先前裁示「保留，但不再新增這類」的「情境相同、問法不同」配對。
數學上兩題確實不同，只是共用鋪陳句型；現在方針改成「改寫不刪」，
就把後加的那一題換成自己的情境，推理與答案完全不動。
"""
import glob, io, json, sys

def L(zh, zhs, en, ja):
    return {'zh-Hant': zh, 'zh-Hans': zhs, 'en': en, 'ja': ja}

R = {}

R['combinatorics_grade10_foundation_031'] = dict(
    prompt=L('一座倉庫的地面畫成 4 × 4 的方格，要放進 3 台機器，每台佔一格。若兩台機器在同一橫排或同一直排上就會互相干擾，因此任兩台都不可以同排或同列。共有多少種放法？',
             '一座仓库的地面画成 4 × 4 的方格，要放进 3 台机器，每台占一格。若两台机器在同一横排或同一竖排上就会互相干扰，因此任两台都不可以同排或同列。共有多少种放法？',
             'The floor of a warehouse is marked out as a 4 × 4 grid, and 3 machines are to be placed on it, one machine per cell. Two machines in the same row or in the same column would interfere with each other, so no two may share a row or a column. In how many ways can the machines be placed?',
             '倉庫のゆかが 4 × 4 のます目にかかれていて、そこに機械を 3 台、1 ますに 1 台ずつ置きます。同じ行または同じ列に 2 台あると たがいにじゃまになるので、どの 2 台も同じ行・同じ列にあってはいけません。置き方は何通りありますか。'),
    answer=L('答案是 96 種。', '答案是 96 种。', 'The answer is 96.', '答えは 96 通りです。'),
    steps=L(['三台機器兩兩不同排，所以它們會用掉 3 個不同的橫排；從 4 個橫排中選 3 個，有 4 種選法。',
             '同樣地，它們也會用掉 3 個不同的直排；從 4 個直排中選 3 個，也有 4 種選法。',
             '選定 3 個橫排和 3 個直排之後，還要決定哪一台機器配哪一組橫排與直排。',
             '把 3 個橫排和 3 個直排一一配對，有 3 × 2 × 1 = 6 種配法。',
             '所以總共是 4 × 4 × 6 = 96 種放法。'],
            ['三台机器两两不同排，所以它们会用掉 3 个不同的横排；从 4 个横排中选 3 个，有 4 种选法。',
             '同样地，它们也会用掉 3 个不同的竖排；从 4 个竖排中选 3 个，也有 4 种选法。',
             '选定 3 个横排和 3 个竖排之后，还要决定哪一台机器配哪一组横排与竖排。',
             '把 3 个横排和 3 个竖排一一配对，有 3 × 2 × 1 = 6 种配法。',
             '所以总共是 4 × 4 × 6 = 96 种放法。'],
            ['No two machines share a row, so they occupy 3 different rows; choosing 3 rows out of 4 can be done in 4 ways.',
             'In the same way they occupy 3 different columns, and choosing 3 columns out of 4 can also be done in 4 ways.',
             'Once the 3 rows and 3 columns are fixed, it remains to decide which machine takes which row-and-column pairing.',
             'Matching the 3 rows to the 3 columns one to one can be done in 3 × 2 × 1 = 6 ways.',
             'So there are 4 × 4 × 6 = 96 placements in total.'],
            ['どの 2 台も同じ行にないので、機械は 3 つのちがう行を使います。4 つの行から 3 つ選ぶ方法は 4 通りです。',
             '同じように 3 つのちがう列を使うので、4 つの列から 3 つ選ぶ方法も 4 通りです。',
             '行と列が決まったら、どの機械がどの行と列の組み合わせに入るかを決めます。',
             '3 つの行と 3 つの列を 1 対 1 に対応させる方法は 3 × 2 × 1 = 6 通りです。',
             'したがって全部で 4 × 4 × 6 = 96 通りです。']))

R['number_theory_grade12_foundation_032'] = dict(
    prompt=L('小安把 1、2、3、⋯、15 這十五個整數全部相乘，得到一個很大的數。這個數除以 17 的餘數是多少？',
             '小安把 1、2、3、⋯、15 这十五个整数全部相乘，得到一个很大的数。这个数除以 17 的余数是多少？',
             'An multiplies together all fifteen integers 1, 2, 3, …, 15 to get a very large number. What is the remainder when that number is divided by 17?',
             'アンは 1、2、3、⋯、15 の 15 個の整数をすべてかけ合わせて、とても大きな数を作りました。この数を 17 でわった余りはいくつですか。'),
    answer=L('答案是 1。', '答案是 1。', 'The answer is 1.', '答えは 1 です。'),
    steps=L(['17 是質數。由威爾遜定理，1 × 2 × ⋯ × 16 除以 17 的餘數是 16，也就是 −1。',
             '把這個乘積拆成（1 × 2 × ⋯ × 15）× 16。',
             '16 除以 17 的餘數是 −1，所以（1 × 2 × ⋯ × 15）×（−1）除以 17 的餘數是 −1。',
             '兩邊同時乘以 −1，得到 1 × 2 × ⋯ × 15 除以 17 的餘數是 1。',
             '所以答案是 1。'],
            ['17 是质数。由威尔逊定理，1 × 2 × ⋯ × 16 除以 17 的余数是 16，也就是 −1。',
             '把这个乘积拆成（1 × 2 × ⋯ × 15）× 16。',
             '16 除以 17 的余数是 −1，所以（1 × 2 × ⋯ × 15）×（−1）除以 17 的余数是 −1。',
             '两边同时乘以 −1，得到 1 × 2 × ⋯ × 15 除以 17 的余数是 1。',
             '所以答案是 1。'],
            ['17 is prime. By Wilson\'s theorem the product 1 × 2 × ⋯ × 16 leaves remainder 16 on division by 17, that is −1.',
             'Split that product as (1 × 2 × ⋯ × 15) × 16.',
             'Since 16 leaves remainder −1, the product (1 × 2 × ⋯ × 15) × (−1) leaves remainder −1 on division by 17.',
             'Multiplying both sides by −1 shows that 1 × 2 × ⋯ × 15 leaves remainder 1.',
             'So the answer is 1.'],
            ['17 は素数です。ウィルソンの定理より、1 × 2 × ⋯ × 16 を 17 でわった余りは 16、すなわち −1 です。',
             'この積を（1 × 2 × ⋯ × 15）× 16 と分けます。',
             '16 を 17 でわった余りは −1 なので、（1 × 2 × ⋯ × 15）×（−1）を 17 でわった余りは −1 です。',
             '両辺に −1 をかけると、1 × 2 × ⋯ × 15 を 17 でわった余りは 1 とわかります。',
             'したがって答えは 1 です。']))

R['combinatorics_grade10_foundation_032'] = dict(
    prompt=L('一首短曲由 5 個音符接連組成，每個音符的長度是 1 拍、2 拍或 3 拍，全曲總長恰好 10 拍。若音符長度的先後順序不同就算不同的曲子，這樣的短曲共有多少首？',
             '一首短曲由 5 个音符接连组成，每个音符的长度是 1 拍、2 拍或 3 拍，全曲总长恰好 10 拍。若音符长度的先后顺序不同就算不同的曲子，这样的短曲共有多少首？',
             'A short tune is made of 5 notes in a row, each note lasting 1, 2 or 3 beats, and the whole tune lasts exactly 10 beats. Tunes that differ in the order of the note lengths count as different. How many such tunes are there?',
             '短い曲は 5 つの音を続けて作られ、それぞれの音の長さは 1 拍、2 拍、3 拍のいずれかで、曲全体はちょうど 10 拍です。音の長さのならび方がちがえば別の曲と数えるとき、そのような曲は何曲ありますか。'),
    answer=L('答案是 51 首。', '答案是 51 首。', 'The answer is 51.', '答えは 51 曲です。'),
    steps=L(['5 個音符每個至少 1 拍，先各給 1 拍，用掉 5 拍，還剩 10 − 5 = 5 拍要分配。',
             '每個音符最多 3 拍，所以每個音符最多還能再加 2 拍。問題變成：把 5 拍分給 5 個音符，每個最多加 2 拍，有幾種分法。',
             '若不管上限，把 5 拍分給 5 個位置（可以是 0）有 126 種分法。',
             '扣掉「某個音符加了 3 拍以上」的情形：指定一個音符先加 3 拍，剩 2 拍自由分配有 15 種，5 個音符共 75 種；因為只剩 5 拍，不可能有兩個音符同時超過，不必再加回來。',
             '所以答案是 126 − 75 = 51 首。'],
            ['5 个音符每个至少 1 拍，先各给 1 拍，用掉 5 拍，还剩 10 − 5 = 5 拍要分配。',
             '每个音符最多 3 拍，所以每个音符最多还能再加 2 拍。问题变成：把 5 拍分给 5 个音符，每个最多加 2 拍，有几种分法。',
             '若不管上限，把 5 拍分给 5 个位置（可以是 0）有 126 种分法。',
             '扣掉「某个音符加了 3 拍以上」的情形：指定一个音符先加 3 拍，剩 2 拍自由分配有 15 种，5 个音符共 75 种；因为只剩 5 拍，不可能有两个音符同时超过，不必再加回来。',
             '所以答案是 126 − 75 = 51 首。'],
            ['Each of the 5 notes lasts at least 1 beat, so give every note 1 beat first. That uses 5 beats and leaves 10 − 5 = 5 beats to hand out.',
             'No note may exceed 3 beats, so each note can take at most 2 more. The problem becomes: hand out 5 beats among 5 notes with each taking at most 2.',
             'Ignoring the cap, handing 5 beats to 5 positions, zero allowed, can be done in 126 ways.',
             'Subtract the cases where some note takes 3 or more extra: give one chosen note 3 extra beats and share the remaining 2 freely, which is 15 ways, and there are 5 choices of note, giving 75. Only 5 spare beats exist, so two notes cannot both exceed the cap and nothing needs adding back.',
             'So the answer is 126 − 75 = 51 tunes.'],
            ['5 つの音はどれも 1 拍以上なので、まず各音に 1 拍ずつ配ります。5 拍を使い、残り 10 − 5 = 5 拍を配ります。',
             'どの音も最大 3 拍なので、追加できるのは各音 2 拍までです。つまり「5 拍を 5 つの音に、各音 2 拍までで配る方法」を数えます。',
             '上限を考えずに 5 拍を 5 か所へ（0 でもよい）配る方法は 126 通りです。',
             '「ある音が 3 拍以上追加された」場合を引きます。1 つの音にまず 3 拍を与え、残り 2 拍を自由に配るのは 15 通りで、音の選び方が 5 通りなので 75 通りです。残りは 5 拍しかないので 2 つの音が同時に上限をこえることはなく、たし戻しは不要です。',
             'したがって答えは 126 − 75 = 51 曲です。']))

R['geometry_grade10_foundation_031'] = dict(
    prompt=L('地圖上有一塊四邊形的土地，四個角依序位在座標 A(0, 0)、B(6, 0)、C(8, k)、D(2, 7)，其中 k 是正整數。若這塊土地的面積是 38，求 k 的值。',
             '地图上有一块四边形的土地，四个角依次位在坐标 A(0, 0)、B(6, 0)、C(8, k)、D(2, 7)，其中 k 是正整数。若这块土地的面积是 38，求 k 的值。',
             'A four-sided plot of land is shown on a map with its corners in order at A(0, 0), B(6, 0), C(8, k) and D(2, 7), where k is a positive integer. If the plot has area 38, find k.',
             '地図上に四角形の土地があり、4 すみは順に A(0, 0)、B(6, 0)、C(8, k)、D(2, 7) にあります。ここで k は正の整数です。この土地の面積が 38 のとき、k を求めなさい。'),
    answer=L('答案是 5。', '答案是 5。', 'The answer is 5.', '答えは 5 です。'),
    steps=L(['把對角線 AC 畫出來，四邊形被分成三角形 ABC 與三角形 ACD 兩塊。',
             '用鞋帶公式一次算完整個四邊形：面積等於各頂點依序做「橫座標乘下一點縱座標，再減下一點橫座標乘本點縱座標」的總和，取一半的絕對值。',
             '依序代入 A、B、C、D：（0×0 − 6×0）+（6×k − 8×0）+（8×7 − 2×k）+（2×0 − 0×7）= 6k + 56 − 2k = 4k + 56。',
             '面積是這個值的一半，也就是（4k + 56）÷ 2 = 2k + 28。',
             '令 2k + 28 = 38，得 2k = 10，所以 k = 5。'],
            ['把对角线 AC 画出来，四边形被分成三角形 ABC 与三角形 ACD 两块。',
             '用鞋带公式一次算完整个四边形：面积等于各顶点依序做「横坐标乘下一点纵坐标，再减下一点横坐标乘本点纵坐标」的总和，取一半的绝对值。',
             '依序代入 A、B、C、D：（0×0 − 6×0）+（6×k − 8×0）+（8×7 − 2×k）+（2×0 − 0×7）= 6k + 56 − 2k = 4k + 56。',
             '面积是这个值的一半，也就是（4k + 56）÷ 2 = 2k + 28。',
             '令 2k + 28 = 38，得 2k = 10，所以 k = 5。'],
            ['Drawing the diagonal AC splits the quadrilateral into triangle ABC and triangle ACD.',
             'The shoelace formula handles the whole quadrilateral at once: take each vertex in turn, multiply its x by the next vertex\'s y and subtract the next vertex\'s x times its own y, add these up and halve the absolute value.',
             'Substituting A, B, C, D in order: (0×0 − 6×0) + (6×k − 8×0) + (8×7 − 2×k) + (2×0 − 0×7) = 6k + 56 − 2k = 4k + 56.',
             'The area is half of that, namely (4k + 56) ÷ 2 = 2k + 28.',
             'Setting 2k + 28 = 38 gives 2k = 10, so k = 5.'],
            ['対角線 AC を引くと、四角形は三角形 ABC と三角形 ACD に分かれます。',
             '靴ひもの公式を使えば四角形をまとめて計算できます。各頂点について「自分の x × 次の点の y − 次の点の x × 自分の y」を順に足し、その絶対値を半分にします。',
             'A、B、C、D の順に代入すると（0×0 − 6×0）+（6×k − 8×0）+（8×7 − 2×k）+（2×0 − 0×7）= 6k + 56 − 2k = 4k + 56 です。',
             '面積はこの半分で、（4k + 56）÷ 2 = 2k + 28 です。',
             '2k + 28 = 38 より 2k = 10 なので、k = 5 です。']))

R['logic_grade10_foundation_032'] = dict(
    prompt=L('一整版郵票排成 6 × 8 = 48 張，張與張之間有齒孔。每一次操作只能拿起其中一片，沿著一條齒孔線把它撕成兩片（不可以疊起來一起撕）。小安想知道：要把整版撕成 48 張獨立的郵票，撕的次數會不會因為選擇不同的順序而改變？下列敘述哪一個正確？',
             '一整版邮票排成 6 × 8 = 48 张，张与张之间有齿孔。每一次操作只能拿起其中一片，沿着一条齿孔线把它撕成两片（不可以叠起来一起撕）。小安想知道：要把整版撕成 48 张独立的邮票，撕的次数会不会因为选择不同的顺序而改变？下列叙述哪一个正确？',
             'A sheet of stamps is a 6 × 8 = 48 grid with perforations between neighbouring stamps. Each move takes one piece and tears it along a single perforation line into two pieces; pieces may not be stacked and torn together. An wonders whether the number of tears needed to separate the sheet into 48 single stamps depends on the order chosen. Which statement is correct?',
             '切手のシートは 6 × 8 = 48 まいのます目になっていて、となり合う切手のあいだにはミシン目があります。1 回の操作では 1 つの部分を取り、ミシン目 1 本にそって 2 つに切りはなします（重ねて一度に切ることはできません）。シートを 48 まいの切手にばらばらにするのに必要な回数は、順番によって変わるでしょうか。正しいものはどれですか。'),
    answer=L('答案是不論怎麼撕，都一定恰好是 47 次。', '答案是不论怎么撕，都一定恰好是 47 次。',
             'The answer is that it always takes exactly 47 tears, whatever the order.', '答えは、どんな順番でも必ずちょうど 47 回、です。'),
    steps=L(['一開始整版是 1 片。每撕一次，被拿起的那一片變成兩片，所以片數恰好增加 1。',
             '不管選哪一條齒孔、依什麼順序撕，這個「每次加 1」都不會改變。',
             '要從 1 片變成 48 片，片數必須增加 48 − 1 = 47。',
             '所以撕的次數一定是 47 次，和順序完全無關。',
             '因此正確的敘述是「不論怎麼撕，都一定恰好是 47 次」。'],
            ['一开始整版是 1 片。每撕一次，被拿起的那一片变成两片，所以片数恰好增加 1。',
             '不管选哪一条齿孔、依什么顺序撕，这个「每次加 1」都不会改变。',
             '要从 1 片变成 48 片，片数必须增加 48 − 1 = 47。',
             '所以撕的次数一定是 47 次，和顺序完全无关。',
             '因此正确的叙述是「不论怎么撕，都一定恰好是 47 次」。'],
            ['At the start the sheet is 1 piece. Every tear turns the chosen piece into two, so the number of pieces goes up by exactly 1.',
             'That increase of exactly 1 holds no matter which perforation is chosen or in what order.',
             'Going from 1 piece to 48 pieces means the count must rise by 48 − 1 = 47.',
             'So the number of tears is always 47, completely independent of the order.',
             'The correct statement is therefore that it always takes exactly 47 tears.'],
            ['はじめシートは 1 つのかたまりです。1 回切るたびに、取り上げたかたまりが 2 つになるので、かたまりの数はちょうど 1 ふえます。',
             'どのミシン目をどの順で切っても、この「1 ずつふえる」は変わりません。',
             '1 つから 48 つにするには、かたまりの数を 48 − 1 = 47 ふやす必要があります。',
             'したがって切る回数は必ず 47 回で、順番にはまったくよりません。',
             'よって正しいのは「どんな順番でも必ずちょうど 47 回」です。']))

R['combinatorics_grade7_foundation_031'] = dict(
    prompt=L('一個抽屜裡有 3 支紅筆、5 支藍筆、7 支黑筆，除了顏色以外完全相同。閉著眼睛從抽屜裡拿筆，最少要拿出幾支，才能保證其中一定有 2 支黑筆？',
             '一个抽屉里有 3 支红笔、5 支蓝笔、7 支黑笔，除了颜色以外完全相同。闭着眼睛从抽屉里拿笔，最少要拿出几支，才能保证其中一定有 2 支黑笔？',
             'A drawer holds 3 red pens, 5 blue pens and 7 black pens, identical apart from colour. Taking pens out with your eyes closed, at least how many must you take to be sure of getting 2 black pens?',
             'ひきだしに赤ペン 3 本、青ペン 5 本、黒ペン 7 本が入っていて、色以外はまったく同じです。目をつぶってペンを取り出すとき、黒ペンが 2 本そろうことを確実にするには、少なくとも何本取ればよいですか。'),
    answer=L('答案是 10 支。', '答案是 10 支。', 'The answer is 10.', '答えは 10 本です。'),
    steps=L(['要「保證」，就要想最壞的情況：黑筆盡量晚出現。',
             '最壞的情況是先把所有非黑的筆都拿光，也就是 3 支紅筆加 5 支藍筆，共 8 支。',
             '這時再拿 1 支一定是黑筆，但只有 1 支黑筆還不夠。',
             '所以還要再拿 1 支，才會有第 2 支黑筆。',
             '合計 3 + 5 + 1 + 1 = 10 支。'],
            ['要「保证」，就要想最坏的情况：黑笔尽量晚出现。',
             '最坏的情况是先把所有非黑的笔都拿光，也就是 3 支红笔加 5 支蓝笔，共 8 支。',
             '这时再拿 1 支一定是黑笔，但只有 1 支黑笔还不够。',
             '所以还要再拿 1 支，才会有第 2 支黑笔。',
             '合计 3 + 5 + 1 + 1 = 10 支。'],
            ['A guarantee means planning for the worst case, in which black pens appear as late as possible.',
             'The worst case is taking every non-black pen first, that is 3 red plus 5 blue, which is 8 pens.',
             'The next pen must then be black, but one black pen is not enough.',
             'So one more pen has to be taken to get a second black pen.',
             'That gives 3 + 5 + 1 + 1 = 10 pens.'],
            ['「確実に」というときは最悪の場合を考えます。黒ペンができるだけ後に出る場合です。',
             '最悪なのは黒以外をすべて先に取る場合で、赤 3 本と青 5 本の合わせて 8 本です。',
             '次の 1 本は必ず黒ですが、黒 1 本ではたりません。',
             'そこでもう 1 本取ると、2 本目の黒ペンが得られます。',
             '合わせて 3 + 5 + 1 + 1 = 10 本です。']))

R['combinatorics_grade12_foundation_031'] = dict(
    prompt=L('售票口前排了 8 個人，其中 4 個人身上只有 50 元硬幣，另外 4 個人身上只有 100 元紙鈔。票價是 50 元，售票員一開始手上完全沒有零錢，只能用收到的 50 元硬幣找零。若某個拿 100 元的人輪到時售票員找不出零錢，就算卡住。在所有排隊順序中，會卡住的順序共有多少種？',
             '售票口前排了 8 个人，其中 4 个人身上只有 50 元硬币，另外 4 个人身上只有 100 元纸钞。票价是 50 元，售票员一开始手上完全没有零钱，只能用收到的 50 元硬币找零。若某个拿 100 元的人轮到时售票员找不出零钱，就算卡住。在所有排队顺序中，会卡住的顺序共有多少种？',
             'Eight people queue at a ticket window. Four of them carry only 50-dollar coins and the other four carry only 100-dollar notes. A ticket costs 50 dollars, and the clerk starts with no change at all and can only give change using the 50-dollar coins received. The queue gets stuck if someone paying with 100 dollars reaches the window when the clerk has no change. Of all the possible queue orders, how many get stuck?',
             '切符売り場に 8 人がならんでいます。4 人は 50 円玉しか持っておらず、残りの 4 人は 100 円札しか持っていません。切符は 50 円で、係員ははじめおつりを 1 枚も持っておらず、受け取った 50 円玉だけをおつりに使えます。100 円札の人の番になったときにおつりがないと、そこで止まってしまいます。ならび方全体のうち、止まってしまうならび方は何通りありますか。'),
    answer=L('答案是 56 種。', '答案是 56 种。', 'The answer is 56.', '答えは 56 通りです。'),
    steps=L(['先算所有排隊順序：8 個位置中選 4 個給拿 50 元的人，其餘給拿 100 元的人，共有 8 × 7 × 6 × 5 ÷（4 × 3 × 2 × 1）= 70 種。',
             '不會卡住的條件是：從隊伍前面數起的任何時刻，已經到過的 50 元人數都不少於 100 元人數。',
             '把 50 元記成左括號、100 元記成右括號，這個條件剛好就是括號能正確配對。',
             '4 對括號能正確配對的排法是第 4 個卡特蘭數，等於 14 種，也就是不會卡住的順序有 14 種。',
             '所以會卡住的順序有 70 − 14 = 56 種。'],
            ['先算所有排队顺序：8 个位置中选 4 个给拿 50 元的人，其余给拿 100 元的人，共有 8 × 7 × 6 × 5 ÷（4 × 3 × 2 × 1）= 70 种。',
             '不会卡住的条件是：从队伍前面数起的任何时刻，已经到过的 50 元人数都不少于 100 元人数。',
             '把 50 元记成左括号、100 元记成右括号，这个条件刚好就是括号能正确配对。',
             '4 对括号能正确配对的排法是第 4 个卡特兰数，等于 14 种，也就是不会卡住的顺序有 14 种。',
             '所以会卡住的顺序有 70 − 14 = 56 种。'],
            ['First count all queue orders: choose 4 of the 8 places for the people with coins and the rest for the people with notes, giving 8 × 7 × 6 × 5 ÷ (4 × 3 × 2 × 1) = 70.',
             'The queue avoids getting stuck exactly when, at every point counting from the front, the number of coin payers so far is at least the number of note payers.',
             'Writing a coin payer as an opening bracket and a note payer as a closing bracket, that condition is exactly the condition for the brackets to match correctly.',
             'The number of correctly matched arrangements of 4 pairs of brackets is the 4th Catalan number, which is 14, so 14 orders do not get stuck.',
             'Therefore 70 − 14 = 56 orders do get stuck.'],
            ['まず全部のならび方を数えます。8 か所から 50 円玉の人の位置 4 つを選び、残りを 100 円札の人とするので、8 × 7 × 6 × 5 ÷（4 × 3 × 2 × 1）= 70 通りです。',
             '止まらない条件は、先頭から数えたどの時点でも、すでに通った 50 円玉の人数が 100 円札の人数以上であることです。',
             '50 円玉を開きかっこ、100 円札を閉じかっこと書くと、この条件はかっこが正しく対応する条件そのものです。',
             '4 組のかっこが正しく対応するならび方は 4 番目のカタラン数で 14 通り、つまり止まらないならび方は 14 通りです。',
             'したがって止まってしまうのは 70 − 14 = 56 通りです。']))

R['algebra_grade8_foundation_032'] = dict(
    prompt=L('一艘郵輪在靜水中的速度是每小時 10 公里。它沿著一條河，從上游碼頭順流開到 48 公里外的下游碼頭，再逆流開回上游碼頭，來回一共花了 10 小時。這條河的流速是每小時幾公里？',
             '一艘邮轮在静水中的速度是每小时 10 公里。它沿着一条河，从上游码头顺流开到 48 公里外的下游码头，再逆流开回上游码头，来回一共花了 10 小时。这条河的流速是每小时几公里？',
             'A cruise boat travels at 10 kilometres per hour in still water. It sails down a river from the upstream pier to the downstream pier 48 kilometres away, then back upstream, and the round trip takes 10 hours in all. What is the speed of the current, in kilometres per hour?',
             '客船の静水での速さは時速 10 km です。この船は川を上流の港から 48 km 下流の港まで下り、また上流の港までもどりました。往復で合わせて 10 時間かかりました。川の流れの速さは時速何 km ですか。'),
    answer=L('答案是每小時 2 公里。', '答案是每小时 2 公里。', 'The answer is 2 kilometres per hour.', '答えは時速 2 km です。'),
    steps=L(['設流速是每小時 v 公里。順流時的速度是 10 + v，逆流時是 10 − v。',
             '順流花的時間是 48 ÷（10 + v）小時，逆流是 48 ÷（10 − v）小時，兩者相加是 10 小時。',
             '兩式通分整理：48（10 − v）+ 48（10 + v）= 10（10 + v）（10 − v），左邊是 960。',
             '右邊是 10（100 − v × v），所以 960 = 1000 − 10 × v × v，得到 v × v = 4。',
             '流速為正，所以 v = 2，也就是每小時 2 公里。'],
            ['设流速是每小时 v 公里。顺流时的速度是 10 + v，逆流时是 10 − v。',
             '顺流花的时间是 48 ÷（10 + v）小时，逆流是 48 ÷（10 − v）小时，两者相加是 10 小时。',
             '两式通分整理：48（10 − v）+ 48（10 + v）= 10（10 + v）（10 − v），左边是 960。',
             '右边是 10（100 − v × v），所以 960 = 1000 − 10 × v × v，得到 v × v = 4。',
             '流速为正，所以 v = 2，也就是每小时 2 公里。'],
            ['Let the current be v kilometres per hour. Going downstream the boat travels at 10 + v and upstream at 10 − v.',
             'The downstream leg takes 48 ÷ (10 + v) hours and the upstream leg 48 ÷ (10 − v) hours, and together they make 10 hours.',
             'Clearing the denominators gives 48(10 − v) + 48(10 + v) = 10(10 + v)(10 − v), and the left side is 960.',
             'The right side is 10(100 − v × v), so 960 = 1000 − 10 × v × v, giving v × v = 4.',
             'A current is positive, so v = 2, that is 2 kilometres per hour.'],
            ['流れの速さを時速 v km とします。下るときの速さは 10 + v、上るときは 10 − v です。',
             '下りにかかる時間は 48 ÷（10 + v）時間、上りは 48 ÷（10 − v）時間で、合わせて 10 時間です。',
             '分母をはらうと 48（10 − v）+ 48（10 + v）= 10（10 + v）（10 − v）となり、左辺は 960 です。',
             '右辺は 10（100 − v × v）なので、960 = 1000 − 10 × v × v より v × v = 4 です。',
             '流れの速さは正なので v = 2、つまり時速 2 km です。']))

R['logic_grade12_foundation_031'] = dict(
    prompt=L('工廠要測試一款新手機從幾樓摔下才會壞。已知存在一個臨界樓層 F，從第 F 層以上（含 F 層）摔下一定會壞，從 F 層以下摔下則一定不壞。現在手上只有 2 支完全相同的測試機，沒壞的可以重複使用，壞了就不能再用。已知在最壞情況下最多只要測 10 次，就一定能確定臨界樓層 F。這棟測試樓最多可以有幾層？',
             '工厂要测试一款新手机从几楼摔下才会坏。已知存在一个临界楼层 F，从第 F 层以上（含 F 层）摔下一定会坏，从 F 层以下摔下则一定不坏。现在手上只有 2 支完全相同的测试机，没坏的可以重复使用，坏了就不能再用。已知在最坏情况下最多只要测 10 次，就一定能确定临界楼层 F。这栋测试楼最多可以有几层？',
             'A factory tests from which floor a new phone breaks when dropped. There is a critical floor F such that a drop from floor F or above always breaks the phone, and a drop from below F never does. Only 2 identical test phones are available; an unbroken one can be reused, a broken one cannot. It is known that 10 drops always suffice in the worst case to determine F. At most how many floors can the test building have?',
             '工場では、新しい機種を何階から落とすとこわれるかを調べます。ある臨界階 F があり、F 階以上から落とすと必ずこわれ、F 階より下から落とすと必ずこわれません。同じテスト機は 2 台だけあり、こわれていなければ再び使えますが、こわれたら使えません。最悪の場合でも 10 回落とせば必ず F を決められることがわかっています。このテスト用の建物は最大で何階建てにできますか。'),
    answer=L('答案是 55 層。', '答案是 55 层。', 'The answer is 55.', '答えは 55 階です。'),
    steps=L(['第一支測試機要從某一層開始往下摔，摔壞之後只能用第二支從下方逐層往上試，不能跳層。',
             '所以第一支的第一次選在第 a 層，若壞了，第二支最多還要逐層試 a − 1 次，加起來已用掉 a 次，故第一次最多能選第 10 層。',
             '若第一次沒壞，剩下 9 次機會，下一次往上跳 9 層；再沒壞就跳 8 層，如此遞減。',
             '因此能覆蓋的樓層數最多是 10 + 9 + 8 + ⋯ + 1。',
             '這個和是 10 × 11 ÷ 2 = 55，所以最多可以有 55 層。'],
            ['第一支测试机要从某一层开始往下摔，摔坏之后只能用第二支从下方逐层往上试，不能跳层。',
             '所以第一支的第一次选在第 a 层，若坏了，第二支最多还要逐层试 a − 1 次，加起来已用掉 a 次，故第一次最多能选第 10 层。',
             '若第一次没坏，剩下 9 次机会，下一次往上跳 9 层；再没坏就跳 8 层，如此递减。',
             '因此能覆盖的楼层数最多是 10 + 9 + 8 + ⋯ + 1。',
             '这个和是 10 × 11 ÷ 2 = 55，所以最多可以有 55 层。'],
            ['The first phone is dropped from some floor, and once it breaks the second phone must be tried floor by floor from below, with no skipping.',
             'So if the first drop is from floor a and it breaks, the second phone needs up to a − 1 further drops, using a drops in all, which means the first drop can be no higher than floor 10.',
             'If the first drop does not break the phone, 9 chances remain, so the next drop goes 9 floors higher; if that survives, the next goes 8 floors higher, and so on.',
             'The number of floors that can be covered is therefore at most 10 + 9 + 8 + ⋯ + 1.',
             'That sum is 10 × 11 ÷ 2 = 55, so the building can have at most 55 floors.'],
            ['1 台目はある階から落とし、こわれたら 2 台目で下から 1 階ずつ試すしかなく、階をとばせません。',
             'したがって 1 回目を a 階にすると、こわれた場合 2 台目で最大 a − 1 回必要となり、合計 a 回使うので、1 回目は最大でも 10 階です。',
             '1 回目でこわれなければ残りは 9 回なので、次は 9 階上へ。またこわれなければ 8 階上へ、と 1 ずつ減らしていきます。',
             'よってカバーできる階数は最大で 10 + 9 + 8 + ⋯ + 1 です。',
             'この和は 10 × 11 ÷ 2 = 55 なので、建物は最大 55 階です。']))

NOTE = ('Rewritten 2026-08-28. This question was one of the grade 7-12 same-setting pairs the user '
        'had decided to keep; with the policy now being rewrite rather than delete, its shared '
        'setup wording was replaced with its own situation. The mathematics, reasoning and answer '
        'are unchanged.')

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
        print('改寫 %-42s -> %s' % (q['id'], q['correctAnswer']['value']))
    if dirty:
        io.open(path, 'w', encoding='utf-8').write(
            json.dumps(pack, ensure_ascii=False, indent=2) + '\n')
if changed != len(R):
    sys.exit('預期 %d 題，實際 %d 題' % (len(R), changed))
print('共改寫 %d 題' % changed)
