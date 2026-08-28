# -*- coding: utf-8 -*-
"""grade3 寫入後 dart 稽核抓到的重複。

logic_grade3_050「泡茶並行排程」與 logic_grade7_020 是同一題（同樣的泡茶
情境、同樣的『燒水時可以同時做別的事』），只換數字，而且我取的子分類名
剛好也叫 parallel_task_scheduling。字面閘門放行（措辭差異夠大），
dart 稽核靠同 topic + 同 subtopic 抓到。換成鋸木頭的間隔計數題。
"""
import json, io
P = 'assets/questions/logic/grade3_foundation.logic.v1.json'
d = json.load(open(P))
q = next(x for x in d['questions'] if x['id'] == 'logic_grade3_foundation_050')
q['subtopic'] = 'cuts_to_make_pieces'
q['prompt'] = {
 'zh-Hant': '一根長木頭要鋸成 5 段，每鋸一次要花 4 分鐘。把它全部鋸完一共要花幾分鐘？',
 'zh-Hans': '一根长木头要锯成 5 段，每锯一次要花 4 分钟。把它全部锯完一共要花几分钟？',
 'en': 'A long log is to be sawn into 5 pieces, and each cut takes 4 minutes. How many minutes does it take to finish sawing it up?',
 'ja': '長い丸太を 5 本に切り分けます。1 回切るのに 4 分かかります。全部切り終えるまで何分かかりますか。'}
q['answer'] = {'zh-Hant': '答案是 16 分鐘。', 'zh-Hans': '答案是 16 分钟。',
               'en': 'The answer is 16 minutes.', 'ja': '答えは 16 分です。'}
q['solutionSteps'] = {
 'zh-Hant': ['先想清楚要鋸幾次，不要直接拿段數去乘。',
             '鋸第 1 次，木頭變成 2 段；鋸第 2 次變成 3 段；鋸第 3 次變成 4 段；鋸第 4 次才變成 5 段。',
             '所以鋸的次數比段數少 1，是 5 − 1 = 4 次。',
             '每次 4 分鐘，一共 4 × 4 = 16 分鐘。（如果算成 5 × 4 = 20，就是多鋸了一次不存在的。）'],
 'zh-Hans': ['先想清楚要锯几次，不要直接拿段数去乘。',
             '锯第 1 次，木头变成 2 段；锯第 2 次变成 3 段；锯第 3 次变成 4 段；锯第 4 次才变成 5 段。',
             '所以锯的次数比段数少 1，是 5 − 1 = 4 次。',
             '每次 4 分钟，一共 4 × 4 = 16 分钟。（如果算成 5 × 4 = 20，就是多锯了一次不存在的。）'],
 'en': ['Work out how many cuts are needed first, rather than multiplying by the number of pieces.',
        'The first cut makes 2 pieces, the second makes 3, the third makes 4, and only the fourth makes 5.',
        'So the number of cuts is one fewer than the number of pieces: 5 − 1 = 4 cuts.',
        'At 4 minutes each, that is 4 × 4 = 16 minutes. Working out 5 × 4 = 20 would count one cut that never happens.'],
 'ja': ['まず何回切るかをはっきりさせます。本数をそのままかけてはいけません。',
        '1 回目で 2 本、2 回目で 3 本、3 回目で 4 本になり、4 回目でようやく 5 本になります。',
        'したがって切る回数は本数より 1 少なく、5 − 1 = 4 回です。',
        '1 回 4 分なので 4 × 4 = 16 分です。5 × 4 = 20 とすると、ありもしない 1 回を数えたことになります。']}
q['correctAnswer'] = {'type': 'integer', 'value': '16'}
q['inputConstraints'] = {'maxDigits': 2, 'allowNegative': False}
q['source']['notes'] = ('Replaces a tea-making parallel-scheduling candidate that duplicated '
                        'logic_grade7_foundation_020 with different numbers. The literal gate passed it; '
                        'tool/question_bank_duplicate_audit.dart caught it via the shared subtopic.')
with io.open(P, 'w', encoding='utf-8') as f:
    json.dump(d, f, ensure_ascii=False, indent=2); f.write('\n')
print('已替換 logic_grade3_foundation_050 -> 鋸木頭間隔計數（16）')
