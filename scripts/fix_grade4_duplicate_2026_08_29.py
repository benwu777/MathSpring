# -*- coding: utf-8 -*-
"""grade4 寫入後重掃的修正。

geometry_grade4_057「12 個小正方形拼長方形有幾種」（3）是
geometry_grade2_036「同樣 12 個，但長寬都要大於 1」（2）拿掉限制後的版本。
候選階段閘門給 0.42 以下，寫入後重掃給 0.42——又是「拿掉一個限制」這個
字面比對很難抓的模式。整題換成長方體稜長總和。
"""
import json, io
P = 'assets/questions/geometry/grade4_foundation.geometry.v1.json'
d = json.load(open(P))
q = next(x for x in d['questions'] if x['id'] == 'geometry_grade4_foundation_057')
q['subtopic'] = 'cuboid_total_edge_length'
q['prompt'] = {
 'zh-Hant': '一個長方體的長是 5 公分、寬是 4 公分、高是 3 公分。把它 12 條稜的長度全部加起來，總共是幾公分？',
 'zh-Hans': '一个长方体的长是 5 厘米、宽是 4 厘米、高是 3 厘米。把它 12 条棱的长度全部加起来，总共是几厘米？',
 'en': 'A cuboid is 5 cm long, 4 cm wide and 3 cm high. Adding the lengths of all 12 of its edges together gives what total, in centimetres?',
 'ja': '直方体のたてが 5 cm、横が 4 cm、高さが 3 cm です。12 本の辺の長さをすべて足すと何 cm になりますか。'}
q['answer'] = {'zh-Hant': '答案是 48 公分。', 'zh-Hans': '答案是 48 厘米。',
               'en': 'The answer is 48 cm.', 'ja': '答えは 48 cm です。'}
q['solutionSteps'] = {
 'zh-Hant': ['長方體有 12 條稜，但長度只有三種：和「長」一樣的、和「寬」一樣的、和「高」一樣的。',
             '每一種各有 4 條——例如長度等於「長」的稜，在上面有 2 條、下面有 2 條。',
             '所以總長是 4 × 長 + 4 × 寬 + 4 × 高，可以把 4 提出來寫成 4 × (長 + 寬 + 高)。',
             '代入數字：4 × (5 + 4 + 3) = 4 × 12 = 48 公分。'],
 'zh-Hans': ['长方体有 12 条棱，但长度只有三种：和「长」一样的、和「宽」一样的、和「高」一样的。',
             '每一种各有 4 条——例如长度等于「长」的棱，在上面有 2 条、下面有 2 条。',
             '所以总长是 4 × 长 + 4 × 宽 + 4 × 高，可以把 4 提出来写成 4 × (长 + 宽 + 高)。',
             '代入数字：4 × (5 + 4 + 3) = 4 × 12 = 48 厘米。'],
 'en': ['A cuboid has 12 edges, but only three different lengths among them: those equal to the length, those equal to the width and those equal to the height.',
        'There are 4 of each kind. For example, the edges equal to the length come 2 along the top and 2 along the bottom.',
        'So the total is 4 × length + 4 × width + 4 × height, which can be written as 4 × (length + width + height).',
        'Substituting the numbers: 4 × (5 + 4 + 3) = 4 × 12 = 48 cm.'],
 'ja': ['直方体には辺が 12 本ありますが、長さは 3 種類しかありません。たてと同じもの、横と同じもの、高さと同じものです。',
        'どの種類も 4 本ずつあります。たとえばたてと同じ長さの辺は、上に 2 本、下に 2 本あります。',
        'したがって合計は 4 × たて + 4 × 横 + 4 × 高さ で、4 でくくって 4 × (たて + 横 + 高さ) と書けます。',
        '数を代入すると 4 × (5 + 4 + 3) = 4 × 12 = 48 cm です。']}
q['correctAnswer'] = {'type': 'integer', 'value': '48'}
q['inputConstraints'] = {'maxDigits': 2, 'allowNegative': False}
q['source']['notes'] = ('Replaces a candidate that was geometry_grade2_foundation_036 with one constraint removed '
                        '(12 unit squares into a rectangle, with and without requiring both sides above 1). '
                        'The literal gate scored it under the threshold; the post-write rescan caught it.')
with io.open(P, 'w', encoding='utf-8') as f:
    json.dump(d, f, ensure_ascii=False, indent=2); f.write('\n')
print('已替換 geometry_grade4_foundation_057 -> 長方體稜長總和（48）')
