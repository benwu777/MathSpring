#!/usr/bin/env python3
"""題庫上架驗收檢查（docs/question-bank-expansion-guidelines.md 的可程式化部分）。

用法:
  python3 scripts/validate_question_packs.py            # 檢查全部
  python3 scripts/validate_question_packs.py grade1     # 只檢查某個 levelStage
"""
import json
import glob, math, re, sys
from collections import defaultdict

LANGS = ['zh-Hant', 'zh-Hans', 'en', 'ja']
# grade1-6 用四類；grade7-12 用五類奧數主題（見 question-bank-expansion-guidelines 的年級對齊表）
TOPICS = {'arithmetic', 'geometry', 'logic', 'mixed'}
TOPICS_UPPER = {'algebra', 'combinatorics', 'geometry', 'logic', 'number_theory'}
KINDS = {'none', 'geometry_scene', 'shape_diagram', 'coordinate_plane',
         'composite_grid_shape', 'circle_quadrants_point'}
ID_RE = re.compile(r'(arithmetic|geometry|logic|mixed|algebra|combinatorics|number_theory)_(grade\d+)_foundation_\d{3}$')


TAG_VOCAB_PATH = 'docs/question-bank-tags.json'


def load_tag_vocab(path=TAG_VOCAB_PATH):
    with open(path) as fh:
        return set(json.load(fh)['tags'])


def check_tags(tags, vocab):
    """回傳標籤的錯誤訊息清單；合格時回傳空清單。

    詞彙表是唯一真實來源，打錯字不得產生新標籤（見 docs/question-bank-tagging.md）。
    """
    if not isinstance(tags, list) or not tags:
        return ['缺少 tags']
    errs = []
    for t in tags:
        if t not in vocab:
            errs.append('tags 不在詞彙表內: %s' % t)
    cs = [t for t in tags if t.startswith('c:')]
    ms = [t for t in tags if t.startswith('m:')]
    if not cs:
        errs.append('tags 缺少 c: 概念標籤')
    if len(cs) > 3:
        errs.append('tags 的 c: 超過 3 個: %d' % len(cs))
    if not ms:
        errs.append('tags 缺少 m: 手法標籤')
    if len(ms) > 2:
        errs.append('tags 的 m: 超過 2 個: %d' % len(ms))
    if len(set(tags)) != len(tags):
        errs.append('tags 有重複')
    return errs


SIMPLIFIED_CHARS_PATH = 'docs/simplified-only-chars.txt'
# zh-Hant 一段話裡出現幾個簡體專用字就報錯。設 1 是因為既有 2757 題實測全都是 0，
# 沒有需要容忍的正常用例；混一個字進來就是代理寫錯了。
SIMPLIFIED_TOLERANCE = 1


def load_simplified_only_chars(path=SIMPLIFIED_CHARS_PATH):
    """讀入簡體專用字集合（# 開頭是說明，其餘的行全部是字）。

    集合由 scripts/derive_simplified_only_chars.py 從題庫自身的
    zh-Hans / zh-Hant 字頻推導，不是通用繁簡對照表；檔頭有說明。
    """
    with open(path) as fh:
        return {ch for line in fh if not line.startswith('#')
                for ch in line.strip()}


def iter_lang_text(node, lang):
    """走訪題目 JSON，吐出所有掛在指定語系鍵底下的字串（含 list 形式的 solutionSteps）。"""
    if isinstance(node, dict):
        for k, v in node.items():
            if k == lang:
                if isinstance(v, str):
                    yield v
                elif isinstance(v, list):
                    yield from (x for x in v if isinstance(x, str))
            else:
                yield from iter_lang_text(v, lang)
    elif isinstance(node, list):
        for item in node:
            yield from iter_lang_text(item, lang)


def check_simplified_in_traditional(q, simplified_chars):
    """回傳 zh-Hant 欄位混入簡體字的錯誤訊息清單；合格時回傳空清單。

    起草代理會把整段簡體同時寫進 zh-Hant 與 zh-Hans，繁體欄位等於整段是簡體。
    英文殘留掃描與四語系齊全檢查都抓不到——兩邊都是中文、都非空。
    只掃 zh-Hant；zh-Hans / en / ja 本來就該是別的文字。
    """
    errs = []
    for fld in ('prompt', 'answer', 'options', 'solutionSteps', 'hint'):
        if fld not in q:
            continue
        bad = []
        for s in iter_lang_text(q[fld], 'zh-Hant'):
            bad.extend(ch for ch in s if ch in simplified_chars)
        if len(bad) >= SIMPLIFIED_TOLERANCE:
            uniq = sorted(set(bad))
            errs.append('%s 的 zh-Hant 含簡體字: %s（共 %d 處）'
                        % (fld, ''.join(uniq), len(bad)))
    return errs


# zh-Hans 要用大陸用語（docs/plans/2026-10-02-zh-hans-terms-design.md）。
# 公里、公顷、毫升、方程式在大陸也這樣寫，不列入。
TAIWAN_TERMS_IN_HANS = {
    '公分': '厘米', '公尺': '米', '公厘': '毫米', '公斤': '千克', '公克': '克', '公升': '升',
    '机率': '概率', '座标': '坐标', '最大公因数': '最大公约数',
    '影片': '视频', '档案': '文件', '网路': '网络', '脚踏车': '自行车',
    '原子笔': '圆珠笔', '资讯': '信息', '计程车': '出租车',
    '若且唯若': '当且仅当', '递回': '递推',
    # 繁轉簡把「方程式」的「程式」轉成「程序」造成的誤轉
    '方程序': '方程',
}
# 大陸課本五年級才教「奇数／偶数」，低年級沿用「单数／双数」。
ODD_EVEN_COLLOQUIAL = {'单数': '奇数', '双数': '偶数'}
ODD_EVEN_FORMAL_FROM_GRADE = 5


def check_simplified_terms(q):
    """回傳 zh-Hans 使用台灣用語的錯誤訊息清單；合格時回傳空清單。"""
    terms = dict(TAIWAN_TERMS_IN_HANS)
    n = (q.get('levelStage') or '').replace('grade', '')
    if n.isdigit() and int(n) >= ODD_EVEN_FORMAL_FROM_GRADE:
        terms.update(ODD_EVEN_COLLOQUIAL)
    errs = []
    for fld in ('prompt', 'answer', 'options', 'solutionSteps', 'hint'):
        if fld not in q:
            continue
        text = '\n'.join(iter_lang_text(q[fld], 'zh-Hans'))
        found = [t for t in terms if t in text]
        if found:
            errs.append('%s 的 zh-Hans 用了台灣用語: %s'
                        % (fld, '、'.join('%s→%s' % (t, terms[t]) for t in found)))
    return errs


# 小數部分結尾有 ≥2 個零 = 把程式的浮點輸出直接貼上來。
# 這條剛好放行真正的近似值（6.7082、4.429、3.818182）與步長（0.0001），
# 它們的小數部分都不是以零結尾；也放行 12.50 這種正常的兩位小數。
PADDED_DECIMAL = re.compile(r'\d+\.\d*?0{2,}(?!\d)')


def check_trailing_zero_decimal(q):
    """回傳補零小數的錯誤訊息清單；合格時回傳空清單。

    2026-09-04 真機目視發現的一族：詳解的驗算步驟寫著「∠BAE = 35.00°」
    「最小值恰為 12.000000」「= 1.0000000000」，是把程式的浮點輸出直接貼上去。
    數學沒錯，只是讀起來像 debug 訊息，應該寫成「35°」「12」「1」。
    """
    errs = []
    for fld in ('prompt', 'answer', 'options', 'solutionSteps', 'hint'):
        if fld not in q:
            continue
        bad = []
        for lang in LANGS:
            for s in iter_lang_text(q[fld], lang):
                bad.extend(PADDED_DECIMAL.findall(s))
        if bad:
            uniq = sorted(set(bad))
            errs.append('%s 的小數補了無意義的尾零: %s（去掉尾零即可）'
                        % (fld, '、'.join(uniq[:5])))
    return errs


CARET_NUMERIC_POWER = re.compile(r'\S\^\d')


def check_caret_power(q):
    """回傳把數字冪次寫成 `3^15` 的錯誤訊息清單；合格時回傳空清單。

    規範明文禁止程式語法的冪次，但一直沒有閘門。

    **只擋純數字指數。** 變數指數（`2^a`、`p₁^e₁`、`a^(p−1)`）刻意放行：
    Unicode 雖有 ᵃ ᵏ ˣ 這類上標字母，字型覆蓋卻極差，換過去更可能變空方塊；
    `2^(p−1)` 還需要上標括號與上標減號，寫出來沒人讀得懂。
    數字上標 ⁰¹²³⁴⁵⁶⁷⁸⁹ 則是全庫本來就在用、字型覆蓋良好的寫法。
    """
    errs = []
    for fld in ('prompt', 'answer', 'options', 'solutionSteps', 'hint'):
        if fld not in q:
            continue
        bad = []
        for lang in LANGS:
            for s in iter_lang_text(q[fld], lang):
                for m in re.finditer(r'\S+\^\d+', s):
                    bad.append(m.group(0))
        if bad:
            uniq = sorted(set(bad))
            errs.append('%s 用了程式語法的冪次: %s（改寫成上標，如 3¹⁵）'
                        % (fld, '、'.join(uniq[:5])))
    return errs


# 正解要同時「比例上長很多」又「絕對字數多很多」才算洩漏線索。
#
# 2026-09-04 用全庫 476 道選擇題重量一次分布（前一版的門檻是用 470 道訂的）：
#   比值   p50=1.00  p90=1.00  p95=1.25  p99=1.51  max=1.75
#   字數差 p50=0     p90=0     p95=1     p99=12    max=18
# 也就是九成的題目正解根本不比最長的誘答長，兩個維度都是長尾。
#
# 只看比值不夠：15 字對 10 字也是 1.5 倍，但只差 5 個字，學生看不出來；
# 只看字數差也不夠：60 字對 50 字差 10 個字，比例上只有 1.18，屬正常起伏。
# 兩個條件都要滿足才報，實測剛好標出 3 題真的把完整推理寫進正解的題目
# （門檻取 8、10、12 標出的都是同一批，不是踩在邊緣上調出來的）。
#
# 舊版的 1.6 倍配 12 字下限現在會標出 0 題，等於閘門是空轉的。
OPTION_LENGTH_RATIO = 1.5
OPTION_LENGTH_GAP = 10


def check_option_lengths(options, correct_value):
    """回傳選項長度洩漏線索的錯誤訊息清單；合格時回傳空清單。

    正解若遠比每一個誘答都長，學生不必推理、挑最長的就會中。
    這是 2026-09-03 那批博弈選擇題實際踩到的坑：正解寫滿完整策略，
    誘答只有一句話。
    """
    if not isinstance(options, dict) or correct_value not in options:
        return []
    lens = {k: len(v['zh-Hant']) for k, v in options.items()}
    correct = lens[correct_value]
    others = [n for k, n in lens.items() if k != correct_value]
    if not others:
        return []
    longest = max(others)
    if (longest and correct / longest >= OPTION_LENGTH_RATIO
            and correct - longest >= OPTION_LENGTH_GAP):
        return ['正解 %s 長 %d 字，最長的誘答只有 %d 字（%.2f 倍、多 %d 字），'
                '挑最長的就會中；請把誘答寫得一樣具體'
                % (correct_value, correct, longest, correct / longest,
                   correct - longest)]
    return []


# 每個 kind 的 renderer 實際會讀的 params 鍵（lib/src/question_figures.dart 的 buildFigureRenderSpec
# 與各 painter）。不在名單裡的鍵會被靜默丟掉，寫了等於沒寫。
FIGURE_PARAM_KEYS = {
    'none': set(),
    'geometry_scene': {'bounds', 'points', 'segments', 'polygons', 'arcs',
                       'angleMarks', 'rightAngles', 'equalTicks'},
    'shape_diagram': {'shape', 'labels'},
    'coordinate_plane': {'minX', 'maxX', 'minY', 'maxY', 'showGrid',
                         'points', 'path', 'highlightPoint'},
    'composite_grid_shape': {'rows', 'cols', 'filledCells', 'cellLabels'},
    'circle_quadrants_point': {'regionLabels', 'pointLabel', 'shadedRegion'},
}
# ShapeDiagramPainter 的 switch 分支；其餘值會落到 default，靜默畫成 rectangle。
SHAPE_DIAGRAM_SHAPES = {'compass', 'square', 'triangle', 'trapezoid',
                        'parallelogram', 'pentagon', 'hexagon', 'circle',
                        'oval', 'rectangle'}
SHAPE_DIAGRAM_LABEL_KEYS = {'top', 'bottom', 'left', 'right', 'center'}
# CircleQuadrantsPointPainter 認得的四個區域；填別的值會靜默不上色。
CIRCLE_QUADRANTS = {'topLeft', 'topRight', 'bottomLeft', 'bottomRight'}
# circle 那一支只呼叫三次 _paintText，left / bottom 寫了也不會出現。
SHAPE_DIAGRAM_CIRCLE_LABEL_KEYS = {'top', 'right', 'center'}
# _buildFigureRenderSpec 對缺漏的 coordinate_plane 界限給的預設值。
COORD_PLANE_BOUND_DEFAULTS = {'minX': 0, 'maxX': 6, 'minY': 0, 'maxY': 6}


def _int_or_none(v):
    """renderer 的 _intFromDynamic 只認得 int 與能 parse 成 int 的字串。

    0.4 這種浮點數會 parse 失敗、fallback 成 0——點靜默跑到別的位置。
    """
    if isinstance(v, bool):
        return None
    if isinstance(v, int):
        return v
    if isinstance(v, str):
        try:
            return int(v)
        except ValueError:
            return None
    return None


def check_figure_params(figure):
    """回傳 figure.params 與 renderer 不相容的錯誤訊息清單；合格時回傳空清單。

    geometry_scene 另有 scene_checks 做幾何一致性檢查，這裡只管形狀與範圍。
    這些 kind 過去完全沒被驗證，params 寫錯時畫面只會靜默畫錯或一片空白。
    """
    kind = figure.get('kind')
    if kind not in FIGURE_PARAM_KEYS:
        return []  # kind 白名單由 main() 負責，這裡不重複報
    params = figure.get('params')
    if not isinstance(params, dict):
        return ['figure.params 必須是物件']
    errs = []

    stray = sorted(set(params) - FIGURE_PARAM_KEYS[kind])
    if stray:
        if kind == 'none':
            errs.append('kind 是 none 卻帶了 params: %s' % '、'.join(stray))
        else:
            errs.append('%s 不認得這些 params，renderer 會靜默丟掉: %s'
                        % (kind, '、'.join(stray)))

    if kind == 'shape_diagram':
        shape = params.get('shape', 'rectangle')
        if shape not in SHAPE_DIAGRAM_SHAPES:
            errs.append('shape_diagram 的 shape 不受支援，會靜默畫成 rectangle: %s' % shape)
        labels = params.get('labels') or {}
        if not isinstance(labels, dict):
            errs.append('shape_diagram 的 labels 必須是物件')
        else:
            allowed = (SHAPE_DIAGRAM_CIRCLE_LABEL_KEYS if shape == 'circle'
                       else SHAPE_DIAGRAM_LABEL_KEYS)
            bad = sorted(set(labels) - allowed)
            if bad:
                errs.append('shape=%s 畫不出這些 labels，會靜默消失: %s'
                            % (shape, '、'.join(bad)))

    elif kind == 'coordinate_plane':
        b = {}
        for key, default in COORD_PLANE_BOUND_DEFAULTS.items():
            v = _int_or_none(params.get(key, default))
            if v is None:
                errs.append('coordinate_plane 的 %s 必須是整數: %r' % (key, params.get(key)))
                v = default
            b[key] = v
        # 界限本身就顛倒時不再檢查點的範圍：那只會噴出一串衍生錯誤，
        # 蓋掉真正要修的那一行。
        bounds_ok = True
        for lo, hi in (('minX', 'maxX'), ('minY', 'maxY')):
            if b[lo] >= b[hi]:
                errs.append('coordinate_plane 的 %s(%d) 不小於 %s(%d)'
                            % (lo, b[lo], hi, b[hi]))
                bounds_ok = False

        def coords(raw, where):
            """檢查一串點的座標是整數且落在界限內，回傳可用的 (x, y) 清單。"""
            out = []
            if raw is None:
                return out
            if not isinstance(raw, list):
                errs.append('coordinate_plane 的 %s 必須是陣列' % where)
                return out
            for pt in raw:
                if not isinstance(pt, dict):
                    errs.append('coordinate_plane 的 %s 元素必須是物件: %r' % (where, pt))
                    continue
                x, y = _int_or_none(pt.get('x')), _int_or_none(pt.get('y'))
                if x is None or y is None:
                    errs.append('%s 的座標必須是整數，非整數會 fallback 成 0: %r'
                                % (where, pt))
                    continue
                if bounds_ok and not (b['minX'] <= x <= b['maxX']
                                      and b['minY'] <= y <= b['maxY']):
                    errs.append('%s 的點 (%d, %d) 超出 %d..%d × %d..%d，會畫到繪圖區外'
                                % (where, x, y, b['minX'], b['maxX'],
                                   b['minY'], b['maxY']))
                    continue
                out.append((x, y))
            return out

        pts = coords(params.get('points'), 'points')
        coords(params.get('path'), 'path')
        hp = params.get('highlightPoint')
        if hp is not None:
            if not isinstance(hp, dict):
                errs.append('coordinate_plane 的 highlightPoint 必須是物件')
            else:
                hx, hy = _int_or_none(hp.get('x')), _int_or_none(hp.get('y'))
                if (hx, hy) not in pts:
                    # highlightPoint 不會自己畫點，只把 points 裡座標相同的那一點改紅
                    errs.append('highlightPoint (%r, %r) 不等於 points 裡的任何一點，'
                                '不會有任何效果' % (hp.get('x'), hp.get('y')))

    elif kind == 'circle_quadrants_point':
        region = params.get('shadedRegion', 'topRight')
        if region not in CIRCLE_QUADRANTS:
            errs.append('circle_quadrants_point 的 shadedRegion 不受支援，'
                        '會靜默不上色: %s' % region)
        labels = params.get('regionLabels') or {}
        if not isinstance(labels, dict):
            errs.append('circle_quadrants_point 的 regionLabels 必須是物件')
        else:
            bad = sorted(set(labels) - CIRCLE_QUADRANTS)
            if bad:
                errs.append('regionLabels 的鍵只認得四個象限，其餘靜默消失: %s'
                            % '、'.join(bad))

    elif kind == 'composite_grid_shape':
        rows = _int_or_none(params.get('rows', 3))
        cols = _int_or_none(params.get('cols', 3))
        for name, v in (('rows', rows), ('cols', cols)):
            if v is None or v <= 0:
                errs.append('composite_grid_shape 的 %s 必須是正整數: %r'
                            % (name, params.get(name)))
        if rows and cols and rows > 0 and cols > 0:
            for cell in params.get('filledCells') or []:
                if (not isinstance(cell, list) or len(cell) != 2
                        or any(_int_or_none(v) is None for v in cell)):
                    errs.append('filledCells 的格子必須是 [row, col] 兩個整數: %r' % (cell,))
                    continue
                r, c = _int_or_none(cell[0]), _int_or_none(cell[1])
                if not (0 <= r < rows and 0 <= c < cols):
                    errs.append('filledCells 的 %r 超出 %d×%d 的格線，不會被畫出來'
                                % (cell, rows, cols))
            for key in params.get('cellLabels') or {}:
                parts = str(key).split(',')
                nums = [_int_or_none(x) for x in parts]
                if len(nums) != 2 or any(n is None for n in nums):
                    errs.append('cellLabels 的鍵必須是 "row,col": %r' % key)
                elif not (0 <= nums[0] < rows and 0 <= nums[1] < cols):
                    errs.append('cellLabels 的鍵 %r 超出 %d×%d 的格線' % (key, rows, cols))

    return errs


def _normalize_math_punct(text):
    """把答案裡的全形／Unicode 標點換成半形，座標才比對得起來。

    詳解與答案混用 U+2212 減號、全形括號與逗號，逐字比對會漏掉。
    """
    for a, b in (('−', '-'), ('－', '-'), ('（', '('),
                 ('）', ')'), ('，', ','), ('　', ' ')):
        text = text.replace(a, b)
    return text


def check_figure_leaks(q):
    """回傳「圖把答案畫出來」的錯誤訊息清單；合格時回傳空清單。

    圖是拿來說明題目前提的，不是拿來公布答案的。實際踩過兩種：

    1. 問「終點在起點的哪個方向」，卻在圖上標出終點——等於把方向畫出來。
    2. 問「求某點的坐標」，卻把那個點畫在答案的位置（甚至還標成紅色）。
       整題變成「把圖上的點讀出來」，代數完全被跳過。

    題目自己給的點不算洩題：座標若同時出現在題幹裡，那是前提不是答案。
    """
    fig = q.get('figure') or {}
    if fig.get('kind') != 'coordinate_plane':
        return []
    points = (fig.get('params') or {}).get('points') or []
    prompt = _normalize_math_punct(q.get('prompt', {}).get('zh-Hant', ''))
    answer = _normalize_math_punct(q.get('answer', {}).get('zh-Hant', ''))
    errs = []

    labels = [pt.get('label', '') for pt in points]
    if any(l in ('終點', '终点') for l in labels) and '方向' in prompt:
        errs.append('圖上標出終點，等於把「在起點的哪個方向」的答案畫出來')

    for pt in points:
        if not isinstance(pt, dict):
            continue
        x, y = pt.get('x'), pt.get('y')
        if x is None or y is None:
            continue
        # 兩種寫法都要比：(6,4) 與 (6, 4)
        forms = ['(%s,%s)' % (x, y), '(%s, %s)' % (x, y)]
        if any(f in answer for f in forms) and not any(f in prompt for f in forms):
            errs.append('圖上把點 %s畫在 (%s, %s)，而答案就是這個座標——'
                        '整題變成把圖上的點讀出來'
                        % (('%s ' % pt['label']) if pt.get('label') else '', x, y))
    return errs


def allowed_topics(level_stage):
    n = level_stage.replace('grade', '')
    return TOPICS_UPPER if n.isdigit() and int(n) >= 7 else TOPICS


def scene_checks(q, err):
    p = q['figure']['params']
    b = p['bounds']
    pts = {d['name']: (float(d['x']), float(d['y'])) for d in p.get('points', [])}
    for n, (x, y) in pts.items():
        if not (b['minX'] <= x <= b['maxX'] and b['minY'] <= y <= b['maxY']):
            err('point %s 超出 bounds' % n)
    for a in p.get('arcs', []):
        lo, hi = int(a['from']), int(a['to'])
        for ang in range(min(lo, hi), max(lo, hi) + 1):
            x = a['cx'] + a['r'] * math.cos(math.radians(ang))
            y = a['cy'] + a['r'] * math.sin(math.radians(ang))
            if not (b['minX'] <= x <= b['maxX'] and b['minY'] <= y <= b['maxY']):
                err('arc(%s..%s) 在 %d° 處超出 bounds' % (a['from'], a['to'], ang))
                break
    for s in p.get('segments', []):
        if s['from'] not in pts or s['to'] not in pts:
            err('segment 引用不存在的點')
        if s.get('style') is not None and s['style'] not in ('solid', 'construction'):
            err('segment style 非法: %s' % s['style'])
    def missing(names, where):
        """回報引用了不存在的點；有缺就回 True，讓呼叫端跳過該筆。

        以前這裡直接 pts[name]，打錯一個字就是 KeyError，驗證器當場中止，
        後面所有題目都不會被檢查到。
        """
        bad = [n for n in names if n not in pts]
        if bad:
            err('%s 引用不存在的點: %s' % (where, '、'.join(bad)))
        return bool(bad)

    for ra in p.get('rightAngles', []):
        if missing([ra['at'], ra['from'], ra['to']], 'rightAngles'):
            continue
        # 用角度容差而非內積絕對值：內積會隨座標大小放大，固定 epsilon 會誤報
        A, B, C = pts[ra['at']], pts[ra['from']], pts[ra['to']]
        v1 = (B[0] - A[0], B[1] - A[1])
        v2 = (C[0] - A[0], C[1] - A[1])
        cos = (v1[0] * v2[0] + v1[1] * v2[1]) / (math.hypot(*v1) * math.hypot(*v2))
        ang = math.degrees(math.acos(max(-1.0, min(1.0, cos))))
        if abs(ang - 90) > 0.5:
            err('rightAngles 標直角但實際是 %.2f°' % ang)
    for et in p.get('equalTicks', []):
        if missing([n for pair in et['segments'] for n in pair], 'equalTicks'):
            continue
        # 相對容差：長度本身有捨入誤差，用比例判斷才不會誤報
        ls = [math.dist(pts[a], pts[c]) for a, c in et['segments']]
        if max(ls) > 0 and (max(ls) - min(ls)) / max(ls) > 0.01:
            err('equalTicks 標等長但實際長度為 %s' % [round(x, 4) for x in ls])
    for am in p.get('angleMarks', []):
        if missing([am['at'], am['from'], am['to']], 'angleMarks'):
            continue
        m = re.match(r'^(\d+(?:\.\d+)?)°$', am.get('label') or '')
        if not m:
            continue
        A, B, C = pts[am['at']], pts[am['from']], pts[am['to']]
        v1 = (B[0] - A[0], B[1] - A[1])
        v2 = (C[0] - A[0], C[1] - A[1])
        ang = math.degrees(math.acos(
            (v1[0] * v2[0] + v1[1] * v2[1]) / (math.hypot(*v1) * math.hypot(*v2))))
        if abs(ang - float(m.group(1))) > 0.5:
            err('angleMarks 標 %s 但實際 %.2f°' % (am['label'], ang))
    for pg in p.get('polygons', []):
        if missing(pg['vertices'], 'polygons'):
            continue
        vs = [pts[v] for v in pg['vertices']]
        area = abs(sum(vs[i][0] * vs[(i + 1) % len(vs)][1] - vs[(i + 1) % len(vs)][0] * vs[i][1]
                       for i in range(len(vs)))) / 2
        if area <= 1e-9:
            err('polygon 頂點共線（面積為 0）')


def main():
    TAG_VOCAB = load_tag_vocab()
    SIMPLIFIED = load_simplified_only_chars()
    only = sys.argv[1] if len(sys.argv) > 1 else None
    errors = defaultdict(list)
    seen = {}
    checked = 0

    for f in sorted(glob.glob('assets/questions/*/*.json')):
        for q in json.load(open(f))['questions']:
            qid = q['id']
            if qid in seen:
                errors[qid].append('id 與 %s 重複' % seen[qid])
            seen[qid] = f
            if only and q.get('levelStage') != only:
                continue
            checked += 1
            err = lambda m, _id=qid: errors[_id].append(m)

            m = ID_RE.match(qid)
            if qid.startswith('mixed_kangaroo56_foundation_'):
                pass  # 該 pack 以競賽而非年級命名，是既有慣例
            elif not m:
                err('id 命名不符 <topicCode>_<levelStage>_foundation_<serial>')
            elif m.group(2) != q.get('levelStage'):
                err('id 的年級與 levelStage 不一致')
            # mixed pack 的每題 topic 刻意記錄該題實際領域，pack 層 topicCode 才是 mixed
            in_mixed_pack = '/mixed/' in f
            allowed = allowed_topics(q.get('levelStage', ''))
            if in_mixed_pack:
                allowed = allowed | TOPICS_UPPER | {'mixed'}
            if q.get('topic') not in allowed:
                err('topic 不在該年級允許集合: %s' % q.get('topic'))
            if q.get('difficulty') != 'foundation' or q.get('challengeTier') != 'foundation':
                err('difficulty/challengeTier 必須皆為 foundation')
            if q.get('answerMode') not in ('multiple_choice', 'integer_input'):
                err('answerMode 非法: %s' % q.get('answerMode'))
            # options 與 solutionSteps 也要驗語系。先前只驗 prompt / answer，
            # 導致 26 題的選項在 en / ja 欄位裡原封不動放著中文而沒被抓到。
            def _cjk(s):
                return any('\u4e00' <= c <= '\u9fff' or '\u3040' <= c <= '\u30ff' for c in s)

            def _prose_en(s):
                return re.search(r'\b[a-z]{3,}\b', s) is not None

            for okey, oval in (q.get('options') or {}).items():
                if not all(l in oval and oval[l].strip() for l in LANGS):
                    err('選項 %s 四語系不齊全' % okey)
                    continue
                if _cjk(oval['en']):
                    err('選項 %s 的 en 含中日文字（未翻譯）' % okey)
                if _prose_en(oval['ja']) and not _cjk(oval['ja']):
                    err('選項 %s 的 ja 是英文（未翻譯）' % okey)
                if _prose_en(oval['zh-Hant']) and not _cjk(oval['zh-Hant']):
                    err('選項 %s 的 zh-Hant 是英文（未翻譯）' % okey)
            for step in q.get('solutionSteps', {}).get('en', []):
                if _cjk(step):
                    err('solutionSteps 的 en 含中日文字（未翻譯）')
                    break
            # 圖不得洩題：圖是說明前提用的，不是拿來公布答案的
            for msg in check_figure_leaks(q):
                err(msg)
            for fld in ('prompt', 'answer'):
                if not all(l in q.get(fld, {}) and q[fld][l].strip() for l in LANGS):
                    err('%s 四語系不齊全' % fld)
                    continue
                # 欄位存在不代表翻譯過：日文欄位若與英文逐字相同，等於未翻譯
                if q[fld]['ja'].strip() == q[fld]['en'].strip():
                    err('%s 的 ja 與 en 逐字相同（未翻譯）' % fld)
                elif not any('\u3040' <= c <= '\u30ff' or '\u4e00' <= c <= '\u9fff'
                             for c in q[fld]['ja']):
                    err('%s 的 ja 不含任何日文字元' % fld)
                # 反方向：英文欄位若含中日文字，同樣代表沒翻譯
                if any('\u4e00' <= c <= '\u9fff' or '\u3040' <= c <= '\u30ff'
                       for c in q[fld]['en']):
                    err('%s 的 en 含中日文字（未翻譯）' % fld)
            lens = {l: len(q.get('solutionSteps', {}).get(l, [])) for l in LANGS}
            if len(set(lens.values())) != 1 or 0 in lens.values():
                err('solutionSteps 四語系長度不一致或為空: %s' % lens)
            if q.get('figure', {}).get('kind') not in KINDS:
                err('figure kind 不受 renderer 支援: %s' % q.get('figure', {}).get('kind'))
            if q.get('figure', {}).get('kind') == 'geometry_scene':
                scene_checks(q, err)
            for msg in check_figure_params(q.get('figure') or {}):
                err(msg)

            if q.get('answerMode') == 'multiple_choice':
                opts = q.get('options', {})
                expected = [chr(ord('A') + i) for i in range(len(opts))]
                if sorted(opts) != expected or not 3 <= len(opts) <= 5:
                    err('選項鍵必須是連續的 A、B、C… 且為 3 至 5 個（目前 %s）' % sorted(opts))
                else:
                    for k, v in opts.items():
                        if not all(l in v and v[l].strip() for l in LANGS):
                            err('選項 %s 四語系不齊全' % k)
                    if len({tuple(v.get(l, '') for l in LANGS) for v in opts.values()}) != len(opts):
                        err('選項內容有重複')
                ca = q.get('correctAnswer', {})
                if ca.get('type') != 'choice' or ca.get('value') not in opts:
                    err('correctAnswer 未指向存在的選項')
                for msg in check_option_lengths(opts, ca.get('value')):
                    err(msg)
                if 'inputConstraints' in q:
                    err('multiple_choice 不得有 inputConstraints')
            elif q.get('answerMode') == 'integer_input':
                if 'options' in q:
                    err('integer_input 不得有 options')
                ic = q.get('inputConstraints', {})
                if not isinstance(ic.get('allowNegative'), bool) or not isinstance(ic.get('maxDigits'), int):
                    err('inputConstraints 需有 allowNegative(bool) 與 maxDigits(int)')
                ca = q.get('correctAnswer', {})
                val = ca.get('value', '')
                if ca.get('type') != 'integer' or not re.fullmatch(r'-?\d+', val):
                    err('correctAnswer 非整數字串')
                else:
                    if isinstance(ic.get('maxDigits'), int) and len(val.lstrip('-')) > ic['maxDigits']:
                        err('maxDigits 放不下答案 %s' % val)
                    def norm(s):
                        return (s.replace('\u2212', '-').replace('\uff0d', '-')
                                 .replace(',', '').replace('\uff0c', ''))
                    for l in LANGS:
                        if val not in norm(q.get('answer', {}).get(l, '')):
                            err('answer[%s] 未出現答案值 %s' % (l, val))
                        steps = [norm(x) for x in q.get('solutionSteps', {}).get(l, [])]
                        if steps and not any(val in s for s in steps):
                            err('solutionSteps[%s] 完全未出現答案值 %s' % (l, val))

            for msg in check_tags(q.get('tags'), TAG_VOCAB):
                err(msg)

            for msg in check_simplified_in_traditional(q, SIMPLIFIED):
                err(msg)

            for msg in check_simplified_terms(q):
                err(msg)

            for msg in check_caret_power(q):
                err(msg)

            for msg in check_trailing_zero_decimal(q):
                err(msg)

            src = q.get('source', {})
            if src.get('type') not in ('official_reference', 'rewritten_olympiad_style'):
                err('source.type 非法: %s' % src.get('type'))
            if 'Editorial Original' in json.dumps(src, ensure_ascii=False):
                err('source 出現 MathSpring Editorial Original')

    manifest = json.load(open('assets/questions/manifest.json'))
    for p in manifest['packs']:
        n = len(json.load(open(p['path']))['questions'])
        if n != p['questionCount']:
            errors['manifest'].append('%s questionCount=%d 實際=%d' % (p['path'], p['questionCount'], n))

    if errors:
        for qid in sorted(errors):
            for msg in errors[qid]:
                print('%-42s %s' % (qid, msg))
        print('\n%d 題檢查完畢，%d 題有問題' % (checked, len(errors)))
        return 1
    print('%d 題檢查完畢，全部通過' % checked)
    return 0


if __name__ == '__main__':
    sys.exit(main())
