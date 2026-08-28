# -*- coding: utf-8 -*-
"""清掉 --same-answer 檢查抓到的另外四組重複（同 id 換新題，題數不減）。

  geometry_grade4_008 / geometry_grade4_012   同 pack，只差對 y 軸或 x 軸鏡射，答案同為 A
  arithmetic_grade1_022 / arithmetic_grade2_028  天平移石頭使兩邊一樣多，答案同為 2
  logic_grade5_041 / logic_grade6_048          王趙李老師帶學生、年齡差 21，同一題
  logic_grade4_022 / logic_grade6_017          「誰排第幾個」排序模板
"""
import glob, io, json

def L(zh, zhs, en, ja):
    return {'zh-Hant': zh, 'zh-Hans': zhs, 'en': en, 'ja': ja}

R = {
'geometry_grade4_foundation_012': dict(
  subtopic='coordinate_rectangle_vertex', value='5', digits=1, drop_options=True, figure_none=True,
  prompt=L('座標平面上有一個長方形，四邊都和座標軸平行。已知它的三個頂點是 (1, 1)、(5, 1)、(5, 4)。第四個頂點的 x 座標和 y 座標相加是多少？',
           '坐标平面上有一个长方形，四边都和坐标轴平行。已知它的三个顶点是 (1, 1)、(5, 1)、(5, 4)。第四个顶点的 x 坐标和 y 坐标相加是多少？',
           'A rectangle on the coordinate plane has all four sides parallel to the axes. Three of its vertices are (1, 1), (5, 1) and (5, 4). What do the x-coordinate and y-coordinate of the fourth vertex add up to?',
           '座標平面上に、4 辺が座標軸と平行な長方形があります。頂点のうち 3 つは (1, 1)、(5, 1)、(5, 4) です。4 つ目の頂点の x 座標と y 座標を足すといくつですか。'),
  answer=L('答案是 5。', '答案是 5。', 'The answer is 5.', '答えは 5 です。'),
  steps=[['四邊和座標軸平行，表示長方形的左右兩邊各自有固定的 x 座標，上下兩邊各自有固定的 y 座標。',
          '已知的三個點用到的 x 座標是 1 和 5，用到的 y 座標是 1 和 4。',
          '每個 x 座標都必須出現兩次、每個 y 座標也是。目前 x = 1 只出現一次、y = 4 只出現一次，所以第四個頂點是 (1, 4)。',
          '兩個座標相加是 1 + 4 = 5。'],
         ['四边和坐标轴平行，表示长方形的左右两边各自有固定的 x 坐标，上下两边各自有固定的 y 坐标。',
          '已知的三个点用到的 x 坐标是 1 和 5，用到的 y 坐标是 1 和 4。',
          '每个 x 坐标都必须出现两次、每个 y 坐标也是。目前 x = 1 只出现一次、y = 4 只出现一次，所以第四个顶点是 (1, 4)。',
          '两个坐标相加是 1 + 4 = 5。'],
         ['Sides parallel to the axes mean the left and right sides each have a fixed x-coordinate, and the top and bottom each have a fixed y-coordinate.',
          'The three known points use the x-coordinates 1 and 5, and the y-coordinates 1 and 4.',
          'Each x-coordinate must appear twice and so must each y-coordinate. So far x = 1 appears once and y = 4 appears once, so the fourth vertex is (1, 4).',
          'Its coordinates add to 1 + 4 = 5.'],
         ['4 辺が座標軸と平行なので、左右の辺はそれぞれ決まった x 座標、上下の辺はそれぞれ決まった y 座標をもちます。',
          'わかっている 3 点で使われている x 座標は 1 と 5、y 座標は 1 と 4 です。',
          'どの x 座標も y 座標も 2 回ずつ現れるはずですが、今は x = 1 と y = 4 が 1 回ずつしかないので、4 つ目の頂点は (1, 4) です。',
          '座標を足すと 1 + 4 = 5 です。']],
  notes='Replaced 2026-08-28: the previous question reflected a point in the x-axis, which duplicated geometry_grade4_foundation_008 about reflecting in the y-axis, with the same answer A.'),

'arithmetic_grade2_foundation_028': dict(
  subtopic='transfer_difference', value='13', digits=2,
  prompt=L('小安的貼紙比小美多。小安送給小美 5 張以後，小安還是比小美多 3 張。原本小安比小美多幾張貼紙？',
           '小安的贴纸比小美多。小安送给小美 5 张以后，小安还是比小美多 3 张。原本小安比小美多几张贴纸？',
           'An has more stickers than Mei. After An gives Mei 5 stickers, An still has 3 more than Mei. How many more stickers did An have than Mei to begin with?',
           'アンはメイよりシールを多く持っています。アンがメイに 5 まいあげたあとも、アンのほうが 3 まい多いままでした。はじめ アンはメイより何まい多く持っていましたか。'),
  answer=L('答案是 13 張。', '答案是 13 张。', 'The answer is 13.', '答えは 13 まいです。'),
  steps=[['送出貼紙時，小安少了 5 張，小美多了 5 張。',
          '所以兩人的差距一次就縮小了 5 + 5 = 10 張，而不是只縮小 5 張。',
          '送完之後還差 3 張，表示原本的差距是 3 + 10 = 13 張。',
          '驗算：若原本小安多 13 張，送出 5 張後多 13 − 10 = 3 張，符合題意。'],
         ['送出贴纸时，小安少了 5 张，小美多了 5 张。',
          '所以两人的差距一次就缩小了 5 + 5 = 10 张，而不是只缩小 5 张。',
          '送完之后还差 3 张，表示原本的差距是 3 + 10 = 13 张。',
          '验算：若原本小安多 13 张，送出 5 张后多 13 − 10 = 3 张，符合题意。'],
         ['Giving stickers away leaves An 5 fewer and Mei 5 more.',
          'So the gap between them closes by 5 + 5 = 10 in one go, not merely by 5.',
          'Since the gap is 3 afterwards, it must have been 3 + 10 = 13 to begin with.',
          'Check: starting 13 ahead and giving 5 away leaves An 13 − 10 = 3 ahead, as required.'],
         ['シールをあげると、アンは 5 まい減り、メイは 5 まい増えます。',
          'したがって 2 人の差は一度に 5 + 5 = 10 まい縮まり、5 まいではありません。',
          'あげたあとの差が 3 まいなので、はじめの差は 3 + 10 = 13 まいです。',
          '確かめ：はじめ 13 まい多く、5 まいあげると 13 − 10 = 3 まい多くなり、条件に合います。']],
  notes='Replaced 2026-08-28: the previous balance question about moving stones duplicated arithmetic_grade1_foundation_022 with the same answer 2.'),

'logic_grade6_foundation_048': dict(
  subtopic='digital_root', value='1', digits=1, drop_options=True,
  prompt=L('取一個正整數，把它的各位數字相加得到一個新的數；如果新的數還不是一位數，就再對它重複同樣的動作，直到只剩一位數為止。從 2026 開始這樣做，最後剩下的那個一位數是多少？',
           '取一个正整数，把它的各位数字相加得到一个新的数；如果新的数还不是一位数，就再对它重复同样的动作，直到只剩一位数为止。从 2026 开始这样做，最后剩下的那个一位数是多少？',
           'Take a positive whole number and add up its digits to get a new number; if the new number still has more than one digit, repeat the process until a single digit is left. Starting from 2026, what single digit is left at the end?',
           'ある正の整数の各位の数字を足して新しい数を作り、それがまだ 1 けたでなければ同じことをくり返して、1 けたになるまで続けます。2026 から始めると、最後に残る 1 けたの数字はいくつですか。'),
  answer=L('答案是 1。', '答案是 1。', 'The answer is 1.', '答えは 1 です。'),
  steps=[['第一次：2 + 0 + 2 + 6 = 10。',
          '10 還是兩位數，所以再做一次：1 + 0 = 1。',
          '1 已經是一位數，過程結束，答案是 1。',
          '（也可以用一個快速的檢查法：這個結果和「原數除以 9 的餘數」一致，2026 = 9 × 225 + 1，餘數正是 1。）'],
         ['第一次：2 + 0 + 2 + 6 = 10。',
          '10 还是两位数，所以再做一次：1 + 0 = 1。',
          '1 已经是一位数，过程结束，答案是 1。',
          '（也可以用一个快速的检查法：这个结果和「原数除以 9 的余数」一致，2026 = 9 × 225 + 1，余数正是 1。）'],
         ['First round: 2 + 0 + 2 + 6 = 10.',
          '10 still has two digits, so repeat: 1 + 0 = 1.',
          '1 is a single digit, so the process stops and the answer is 1.',
          'A quick check: this result always matches the remainder on division by 9, and 2026 = 9 × 225 + 1, giving remainder 1.'],
         ['1 回目：2 + 0 + 2 + 6 = 10 です。',
          '10 はまだ 2 けたなので、もう一度行います。1 + 0 = 1 です。',
          '1 は 1 けたなのでここで終わり、答えは 1 です。',
          '確かめ方として、この結果はもとの数を 9 でわったあまりと一致します。2026 = 9 × 225 + 1 であまりは 1 です。']],
  notes='Replaced 2026-08-28: the previous teacher-and-student matching puzzle was essentially the same question as logic_grade5_foundation_041, with the same answer D.'),

'logic_grade6_foundation_017': dict(
  subtopic='row_column_flip_parity', value='0', digits=1, drop_options=True,
  prompt=L('一個 5 × 5 的方格棋盤上，每一格都放一枚硬幣，一開始全部正面朝上。每次操作可以選定某一整行或某一整列，把那一行（或那一列）的 5 枚硬幣全部翻面。經過若干次操作後，有沒有可能剛好只有 1 枚硬幣是反面朝上？可能請填 1，不可能請填 0。',
           '一个 5 × 5 的方格棋盘上，每一格都放一枚硬币，一开始全部正面朝上。每次操作可以选定某一整行或某一整列，把那一行（或那一列）的 5 枚硬币全部翻面。经过若干次操作后，有没有可能刚好只有 1 枚硬币是反面朝上？可能请填 1，不可能请填 0。',
           'A coin sits on every square of a 5 × 5 board, all showing heads at first. Each move picks a whole row or a whole column and turns over all 5 coins in it. After some moves, is it possible for exactly 1 coin to show tails? Enter 1 for possible and 0 for impossible.',
           '5 × 5 のますめのすべてのますに硬貨を 1 枚ずつ置き、はじめはすべて表です。1 回の操作では、ある行またはある列を選び、その 5 枚をすべて裏返します。何回か操作したあと、ちょうど 1 枚だけが裏になることはありえますか。ありえるなら 1、ありえないなら 0 と答えなさい。'),
  answer=L('答案是不可能，填 0。', '答案是不可能，填 0。', 'The answer is that it is impossible, entered as 0.', '答えは、ありえないので 0 です。'),
  steps=[['同一行翻兩次就等於沒翻，所以每一行、每一列只要記錄「翻了奇數次還是偶數次」就夠了。',
          '設有 a 行被翻了奇數次、b 列被翻了奇數次（a 和 b 都在 0 到 5 之間）。',
          '某一格會變成反面，條件是「它所在的行和列之中，恰好有一個被翻了奇數次」。',
          '所以反面的個數是 a ×（5 − b）+（5 − a）× b = 5a + 5b − 2ab。',
          '把 a、b 從 0 到 5 全部代進去，可能的個數只有 0、5、8、10、11、12、13、14、15、17、20、25，其中沒有 1，所以不可能，填 0。'],
         ['同一行翻两次就等于没翻，所以每一行、每一列只要记录「翻了奇数次还是偶数次」就够了。',
          '设有 a 行被翻了奇数次、b 列被翻了奇数次（a 和 b 都在 0 到 5 之间）。',
          '某一格会变成反面，条件是「它所在的行和列之中，恰好有一个被翻了奇数次」。',
          '所以反面的个数是 a ×（5 − b）+（5 − a）× b = 5a + 5b − 2ab。',
          '把 a、b 从 0 到 5 全部代进去，可能的个数只有 0、5、8、10、11、12、13、14、15、17、20、25，其中没有 1，所以不可能，填 0。'],
         ['Flipping the same row twice undoes itself, so all that matters for each row and column is whether it was flipped an odd or an even number of times.',
          'Say a rows and b columns were flipped an odd number of times, where a and b are between 0 and 5.',
          'A square ends up tails exactly when precisely one of its row and its column was flipped an odd number of times.',
          'So the number of tails is a × (5 − b) + (5 − a) × b = 5a + 5b − 2ab.',
          'Substituting every a and b from 0 to 5 gives only the values 0, 5, 8, 10, 11, 12, 13, 14, 15, 17, 20 and 25. The value 1 never appears, so it is impossible and the answer is 0.'],
         ['同じ行を 2 回裏返すと元にもどるので、各行・各列については「奇数回裏返したか偶数回か」だけを見れば十分です。',
          '奇数回裏返した行を a 行、列を b 列とします（a も b も 0 から 5）。',
          'あるますが裏になるのは、その行と列のうち ちょうど一方だけが奇数回裏返されたときです。',
          'したがって裏の枚数は a ×（5 − b）+（5 − a）× b = 5a + 5b − 2ab です。',
          'a、b に 0 から 5 をすべて入れると、とりうる枚数は 0、5、8、10、11、12、13、14、15、17、20、25 だけで 1 は現れません。よってありえないので 0 です。']],
  notes='Replaced 2026-08-28: the previous left-of ordering puzzle repeated the template of logic_grade4_foundation_022 with the same answer B.'),
}

for path in sorted(glob.glob('assets/questions/*/*.json')):
    if path.endswith('manifest.json'):
        continue
    pack = json.load(open(path))
    dirty = False
    for q in pack['questions']:
        s = R.get(q['id'])
        if not s:
            continue
        q['subtopic'] = s['subtopic']
        q['prompt'] = s['prompt']
        q['answer'] = s['answer']
        q['solutionSteps'] = dict(zip(['zh-Hant', 'zh-Hans', 'en', 'ja'], s['steps']))
        if s.get('drop_options'):
            q.pop('options', None)
        if s.get('figure_none'):
            q['figure'] = {'type': 'custom', 'kind': 'none', 'params': {}}
        q['answerMode'] = 'integer_input'
        q['correctAnswer'] = {'type': 'integer', 'value': s['value']}
        q['inputConstraints'] = {'allowNegative': False, 'maxDigits': s['digits']}
        q['source'] = dict(q['source'], notes=s['notes'])
        assert len({len(v) for v in q['solutionSteps'].values()}) == 1, q['id']
        dirty = True
        print('替換 %-40s -> %s' % (q['id'], s['value']))
    if dirty:
        io.open(path, 'w', encoding='utf-8').write(
            json.dumps(pack, ensure_ascii=False, indent=2) + '\n')
