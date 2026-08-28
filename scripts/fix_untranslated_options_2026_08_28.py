#!/usr/bin/env python3
"""補齊未翻譯的選項。

先前補四語系翻譯時只掃了 prompt / answer / solutionSteps，漏掉 options：
26 題的選擇題選項在英文與日文欄位裡原封不動放著中文，另有一題連繁中欄位
都放著英文。驗證器同步補上 options 與 solutionSteps 的檢查。
"""
import glob, io, json, sys

def O(*rows):
    """rows: (key, zh-Hant, zh-Hans, en, ja)"""
    return {k: {'zh-Hant': zh, 'zh-Hans': zhs, 'en': en, 'ja': ja}
            for k, zh, zhs, en, ja in rows}

R = {}

R['arithmetic_grade2_foundation_051'] = O(
    ('A', '0 個', '0 个', '0 fours', '0 個'), ('B', '1 個', '1 个', '1 four', '1 個'),
    ('C', '2 個', '2 个', '2 fours', '2 個'), ('D', '3 個', '3 个', '3 fours', '3 個'))
R['arithmetic_grade2_foundation_052'] = O(
    ('A', '5 組', '5 组', '5 pairs', '5 組'), ('B', '4 組', '4 组', '4 pairs', '4 組'),
    ('C', '3 組', '3 组', '3 pairs', '3 組'), ('D', '2 組', '2 组', '2 pairs', '2 組'))
R['arithmetic_grade2_foundation_053'] = O(
    ('A', '12 個', '12 个', '12', '12 個'), ('B', '13 個', '13 个', '13', '13 個'),
    ('C', '14 個', '14 个', '14', '14 個'), ('D', '15 個', '15 个', '15', '15 個'))
R['arithmetic_grade2_foundation_056'] = O(
    ('A', '135 元', '135 元', '135 dollars', '135 円'), ('B', '125 元', '125 元', '125 dollars', '125 円'),
    ('C', '115 元', '115 元', '115 dollars', '115 円'), ('D', '105 元', '105 元', '105 dollars', '105 円'))
R['arithmetic_grade2_foundation_058'] = O(
    ('A', '16 枝', '16 支', '16 ice lollies', '16 本'), ('B', '20 枝', '20 支', '20 ice lollies', '20 本'),
    ('C', '24 枝', '24 支', '24 ice lollies', '24 本'), ('D', '28 枝', '28 支', '28 ice lollies', '28 本'))
R['arithmetic_grade2_foundation_061'] = O(
    ('A', '45 元', '45 元', '45 dollars', '45 円'), ('B', '55 元', '55 元', '55 dollars', '55 円'),
    ('C', '35 元', '35 元', '35 dollars', '35 円'), ('D', '25 元', '25 元', '25 dollars', '25 円'))
R['arithmetic_grade2_foundation_062'] = O(
    ('A', '14 本', '14 本', '14 books', '14 さつ'), ('B', '15 本', '15 本', '15 books', '15 さつ'),
    ('C', '16 本', '16 本', '16 books', '16 さつ'), ('D', '17 本', '17 本', '17 books', '17 さつ'))
R['arithmetic_grade2_foundation_066'] = O(
    ('A', '3 月 6 日', '3 月 6 日', '6 March', '3 月 6 日'), ('B', '3 月 7 日', '3 月 7 日', '7 March', '3 月 7 日'),
    ('C', '3 月 8 日', '3 月 8 日', '8 March', '3 月 8 日'), ('D', '3 月 9 日', '3 月 9 日', '9 March', '3 月 9 日'))
R['arithmetic_grade2_foundation_067'] = O(
    ('A', '6 袋', '6 袋', '6 bags', '6 ふくろ'), ('B', '7 袋', '7 袋', '7 bags', '7 ふくろ'),
    ('C', '8 袋', '8 袋', '8 bags', '8 ふくろ'), ('D', '9 袋', '9 袋', '9 bags', '9 ふくろ'))
R['arithmetic_grade2_foundation_068'] = O(
    ('A', '35 顆', '35 颗', '35 sweets', '35 個'), ('B', '42 顆', '42 颗', '42 sweets', '42 個'),
    ('C', '54 顆', '54 颗', '54 sweets', '54 個'), ('D', '61 顆', '61 颗', '61 sweets', '61 個'))
R['arithmetic_grade3_foundation_055'] = O(
    ('A', '3 月 2 日', '3 月 2 日', '2 March', '3 月 2 日'), ('B', '2 月 15 日', '2 月 15 日', '15 February', '2 月 15 日'),
    ('C', '4 月 13 日', '4 月 13 日', '13 April', '4 月 13 日'), ('D', '5 月 6 日', '5 月 6 日', '6 May', '5 月 6 日'))
R['arithmetic_grade3_foundation_058'] = O(
    ('A', '5 時 55 分', '5 时 55 分', '5:55', '5 時 55 分'), ('B', '4 時 45 分', '4 时 45 分', '4:45', '4 時 45 分'),
    ('C', '3 時 35 分', '3 时 35 分', '3:35', '3 時 35 分'), ('D', '2 時 15 分', '2 时 15 分', '2:15', '2 時 15 分'))
R['arithmetic_grade3_foundation_059'] = O(
    ('A', '180 公分', '180 厘米', '180 cm', '180 cm'), ('B', '185 公分', '185 厘米', '185 cm', '185 cm'),
    ('C', '190 公分', '190 厘米', '190 cm', '190 cm'), ('D', '195 公分', '195 厘米', '195 cm', '195 cm'))
R['arithmetic_grade3_foundation_061'] = O(
    ('A', '5 月 30 日', '5 月 30 日', '30 May', '5 月 30 日'), ('B', '5 月 29 日', '5 月 29 日', '29 May', '5 月 29 日'),
    ('C', '6 月 1 日', '6 月 1 日', '1 June', '6 月 1 日'), ('D', '5 月 28 日', '5 月 28 日', '28 May', '5 月 28 日'))
R['arithmetic_grade3_foundation_065'] = O(
    ('A', '5 顆', '5 颗', '5 apples', '5 個'), ('B', '6 顆', '6 颗', '6 apples', '6 個'),
    ('C', '7 顆', '7 颗', '7 apples', '7 個'), ('D', '8 顆', '8 颗', '8 apples', '8 個'))
R['arithmetic_grade3_foundation_068'] = O(
    ('A', '18 元', '18 元', '18 dollars', '18 円'), ('B', '20 元', '20 元', '20 dollars', '20 円'),
    ('C', '22 元', '22 元', '22 dollars', '22 円'), ('D', '16 元', '16 元', '16 dollars', '16 円'))
R['arithmetic_grade3_foundation_069'] = O(
    ('A', '78 個', '78 个', '78', '78 個'), ('B', '77 個', '77 个', '77', '77 個'),
    ('C', '76 個', '76 个', '76', '76 個'), ('D', '75 個', '75 个', '75', '75 個'))
R['arithmetic_grade4_foundation_052'] = O(
    ('A', '12 小時', '12 小时', '12 hours', '12 時間'), ('B', '13 小時', '13 小时', '13 hours', '13 時間'),
    ('C', '11 小時', '11 小时', '11 hours', '11 時間'), ('D', '17 小時', '17 小时', '17 hours', '17 時間'))
R['arithmetic_grade4_foundation_056'] = O(
    ('A', '四十億零四萬零四', '四十亿零四万零四', 'four billion forty thousand and four', '四十億四万四'),
    ('B', '四百億零四十萬零四', '四百亿零四十万零四', 'forty billion four hundred thousand and four', '四百億四十万四'),
    ('C', '四零零零零四零零零零四', '四零零零零四零零零零四', 'four zero zero zero zero four zero zero zero zero four', '四〇〇〇〇四〇〇〇〇四'),
    ('D', '四百億零四千零四', '四百亿零四千零四', 'forty billion four thousand and four', '四百億四千四'))
R['arithmetic_grade4_foundation_057'] = O(
    ('A', '45 度', '45 度', '45 degrees', '45 度'), ('B', '30 度', '30 度', '30 degrees', '30 度'),
    ('C', '40 度', '40 度', '40 degrees', '40 度'), ('D', '50 度', '50 度', '50 degrees', '50 度'))
R['arithmetic_grade4_foundation_058'] = O(
    ('A', '兩個時間相等', '两个时间相等', 'The two are equal', '2 つは同じ長さ'),
    ('B', '5 小時', '5 小时', '5 hours', '5 時間'),
    ('C', '7 小時', '7 小时', '7 hours', '7 時間'),
    ('D', '9 小時', '9 小时', '9 hours', '9 時間'))
R['arithmetic_grade4_foundation_068'] = O(
    ('A', '甲 > 乙 > 丙', '甲 > 乙 > 丙', '4.2 L > 4 L 2 dL > 4 L 200 mL', '4.2 L > 4 L 2 dL > 4 L 200 mL'),
    ('B', '乙 > 丙 > 甲', '乙 > 丙 > 甲', '4 L 2 dL > 4 L 200 mL > 4.2 L', '4 L 2 dL > 4 L 200 mL > 4.2 L'),
    ('C', '丙 > 乙 > 甲', '丙 > 乙 > 甲', '4 L 200 mL > 4 L 2 dL > 4.2 L', '4 L 200 mL > 4 L 2 dL > 4.2 L'),
    ('D', '甲 = 乙 = 丙', '甲 = 乙 = 丙', 'All three are equal', '3 つとも等しい'))
R['arithmetic_grade6_foundation_055'] = O(
    ('A', '6 月 6 日', '6 月 6 日', '6 June', '6 月 6 日'), ('B', '6 月 8 日', '6 月 8 日', '8 June', '6 月 8 日'),
    ('C', '6 月 7 日', '6 月 7 日', '7 June', '6 月 7 日'), ('D', '6 月 10 日', '6 月 10 日', '10 June', '6 月 10 日'))
R['logic_grade5_foundation_041'] = O(
    ('A', '小華是王老師帶的', '小华是王老师带的', 'Xiaohua is brought by Teacher Wang', '小華は王先生が連れてきた'),
    ('B', '小明是趙老師帶的', '小明是赵老师带的', 'Xiaoming is brought by Teacher Zhao', '小明は趙先生が連れてきた'),
    ('C', '小剛是李老師帶的', '小刚是李老师带的', 'Xiaogang is brought by Teacher Li', '小剛は李先生が連れてきた'),
    ('D', '小華是趙老師帶的', '小华是赵老师带的', 'Xiaohua is brought by Teacher Zhao', '小華は趙先生が連れてきた'))
R['logic_grade6_foundation_048'] = O(
    ('A', '小華是王老師帶的', '小华是王老师带的', 'Hua is brought by Teacher Wang', '小華は王先生が連れてきた'),
    ('B', '小明是趙老師帶的', '小明是赵老师带的', 'Ming is brought by Teacher Zhao', '小明は趙先生が連れてきた'),
    ('C', '小剛是李老師帶的', '小刚是李老师带的', 'Gang is brought by Teacher Li', '小剛は李先生が連れてきた'),
    ('D', '小華是趙老師帶的', '小华是赵老师带的', 'Hua is brought by Teacher Zhao', '小華は趙先生が連れてきた'))
# 這一題連繁中欄位都放著英文
R['arithmetic_grade6_foundation_061'] = O(
    ('A', '紅燈', '红灯', 'The red light', '赤いライト'),
    ('B', '藍燈', '蓝灯', 'The blue light', '青いライト'),
    ('C', '綠燈', '绿灯', 'The green light', '緑のライト'),
    ('D', '三燈同時亮', '三灯同时亮', 'All three lights together', '3 つが同時に光る'))

# arithmetic_grade4_056 的英文題幹原本寫「in Chinese place-value notation」，
# 但英文選項若照中文讀法就無法閱讀；改成一般的英文讀法問句，答案 B 仍成立。
PROMPT_EN = {
    'arithmetic_grade4_foundation_056': 'How is 40000400004 read out in words?',
}

changed = 0
for path in sorted(glob.glob('assets/questions/*/*.json')):
    if path.endswith('manifest.json'):
        continue
    pack = json.load(open(path))
    dirty = False
    for q in pack['questions']:
        if q['id'] in R:
            old = q.get('options') or {}
            new = R[q['id']]
            assert set(old) == set(new), (q['id'], sorted(old), sorted(new))
            assert q['correctAnswer']['value'] in new, q['id']
            q['options'] = new
            dirty = True
            changed += 1
            print('補齊選項 %-40s 答:%s' % (q['id'], q['correctAnswer']['value']))
        if q['id'] in PROMPT_EN:
            q['prompt']['en'] = PROMPT_EN[q['id']]
            dirty = True
    if dirty:
        io.open(path, 'w', encoding='utf-8').write(
            json.dumps(pack, ensure_ascii=False, indent=2) + '\n')
if changed != len(R):
    sys.exit('預期 %d 題，實際 %d 題' % (len(R), changed))
print('共補齊 %d 題' % changed)
