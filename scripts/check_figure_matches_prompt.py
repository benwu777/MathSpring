#!/usr/bin/env python3
"""比對「題幹寫的幾何條件」與「圖上實際座標」是否一致。

驗證器只檢查 params 的形狀合不合法，看不出圖有沒有畫錯題意；相似度工具更管不到。
逐張目視又很不可靠——人會看漏，也會把正確的圖誤判成錯的。

這支從題幹抽出可機械驗證的敘述，再拿圖上的點座標去算：

  AB = CD          兩線段等長
  AB : CD = a : b  線段比
  AB ∥ CD          平行
  AB ⊥ CD          垂直
  ∠ABC = n°        角度
  X 是 YZ 的中點    中點

圖是示意圖，絕對長度不需要符合，所以長度一律比**比值**。

用法：python3 scripts/check_figure_matches_prompt.py [--kind geometry_scene]
"""
import json
import glob
import math
import re
import sys

TOL_RATIO = 0.06   # 等式／比例式／中點：示意圖也該畫準，容差 6%
# 兩個「各自獨立給定」的長度互相比對時要寬一些：示意圖常整體縮放過，
# 例如梯形題把 9 公分畫成 3 個單位、6 公分畫成 1.875 個單位，
# 結構（AB:CD、AO:OC）完全正確，只有絕對縮放差了 7%。
TOL_CROSS = 0.12
TOL_ANGLE = 2.0    # 角度誤差 2 度


def points_of(fig):
    pts = {}
    for p in (fig.get('params') or {}).get('points', []) or []:
        # geometry_scene 用 name、coordinate_plane 用 label；兩種都要讀。
        # 真的沒有名字的點無從與題幹對應，跳過。
        if not isinstance(p, dict):
            continue
        n = p.get('name') or p.get('label')
        if not n or 'x' not in p or 'y' not in p:
            continue
        pts[str(n)] = (float(p['x']), float(p['y']))
    return pts


def dist(a, b):
    return math.hypot(a[0] - b[0], a[1] - b[1])


def vec(a, b):
    return (b[0] - a[0], b[1] - a[1])


def angle_at(p, a, b):
    """∠a-p-b，回傳度數。"""
    u, v = vec(p, a), vec(p, b)
    du, dv = math.hypot(*u), math.hypot(*v)
    if du == 0 or dv == 0:
        return None
    c = max(-1, min(1, (u[0] * v[0] + u[1] * v[1]) / (du * dv)))
    return math.degrees(math.acos(c))


SEG = r'([A-Z])([A-Z])'


def checks_from_prompt(text, pts):
    """回傳 (敘述, 是否通過, 說明) 的清單。只產生「圖上點齊全」的檢查。"""
    out = []
    have = lambda *ns: all(n in pts for n in ns)

    # 1) 明確給長度的線段 → 兩兩比對比值
    #
    # 這裡有兩個必須排除的陷阱，否則會大量誤判：
    #   ∠BAE = 35°      → 尾巴的 "AE = 35" 不是線段長
    #   BD : DC = 2 : 1 → 右邊的 "DC = 2" 不是線段長
    lens = {}
    for m in re.finditer(SEG + r'\s*(?:的長度)?\s*[=＝是]\s*(\d+(?:\.\d+)?)', text):
        a, b, v = m.group(1), m.group(2), float(m.group(3))
        pre = text[max(0, m.start() - 3):m.start()]
        if '∠' in pre or '角' in pre:          # 角名的後兩個字母
            continue
        if re.search(r'[:：]\s*$', pre):        # 比例式的右項
            continue
        if have(a, b):
            lens[a + b] = v
    names = sorted(lens)
    for i in range(len(names)):
        for j in range(i + 1, len(names)):
            n1, n2 = names[i], names[j]
            want = lens[n1] / lens[n2]
            got = dist(pts[n1[0]], pts[n1[1]]) / dist(pts[n2[0]], pts[n2[1]])
            okk = abs(got - want) <= TOL_CROSS * max(want, 1e-9)
            out.append(('%s : %s = %g : %g' % (n1, n2, lens[n1], lens[n2]),
                        okk, '圖上比值 %.3f，題目要求 %.3f' % (got, want)))

    # 2) 等長。連鎖等式（BC = CD = 43）也要抓到——第一版用負向前瞻排除
    #    「後面接數字」的情形，結果 BC = CD = 43 整條被跳過，
    #    而那正好是實際踩到的一個錯圖。
    for m in re.finditer(SEG + r'\s*[=＝]\s*' + SEG, text):
        a, b, c, d = m.groups()
        pre = text[max(0, m.start() - 3):m.start()]
        if '∠' in pre or '角' in pre:
            continue
        if have(a, b, c, d):
            l1, l2 = dist(pts[a], pts[b]), dist(pts[c], pts[d])
            okk = abs(l1 - l2) <= TOL_RATIO * max(l1, l2)
            out.append(('%s%s = %s%s' % (a, b, c, d), okk,
                        '圖上 %.3f vs %.3f' % (l1, l2)))

    # 3) 線段比 XY : ZW = a : b
    for m in re.finditer(SEG + r'\s*[:：]\s*' + SEG + r'\s*[=＝]\s*(\d+)\s*[:：]\s*(\d+)', text):
        a, b, c, d, r1, r2 = m.groups()
        if have(a, b, c, d):
            want = int(r1) / int(r2)
            got = dist(pts[a], pts[b]) / max(dist(pts[c], pts[d]), 1e-9)
            okk = abs(got - want) <= TOL_RATIO * max(want, 1e-9)
            out.append(('%s%s : %s%s = %s : %s' % (a, b, c, d, r1, r2), okk,
                        '圖上 %.3f，題目 %.3f' % (got, want)))

    # 4) 平行與垂直
    for sym, name in (('∥', '平行'), ('⊥', '垂直'), ('⟂', '垂直')):
        for m in re.finditer(SEG + r'\s*' + re.escape(sym) + r'\s*' + SEG, text):
            a, b, c, d = m.groups()
            if have(a, b, c, d):
                u, v = vec(pts[a], pts[b]), vec(pts[c], pts[d])
                cross = abs(u[0] * v[1] - u[1] * v[0])
                dot = abs(u[0] * v[0] + u[1] * v[1])
                mag = math.hypot(*u) * math.hypot(*v)
                if name == '平行':
                    okk = cross <= 0.03 * mag
                    det = '外積比 %.4f' % (cross / max(mag, 1e-9))
                else:
                    okk = dot <= 0.03 * mag
                    det = '內積比 %.4f' % (dot / max(mag, 1e-9))
                out.append(('%s%s %s %s%s' % (a, b, sym, c, d), okk, det))

    # 5) 角度 ∠ABC = n°
    for m in re.finditer(r'∠\s*([A-Z])([A-Z])([A-Z])\s*[=＝是]\s*(\d+(?:\.\d+)?)\s*(?:°|度)', text):
        a, p, b, v = m.group(1), m.group(2), m.group(3), float(m.group(4))
        if have(a, p, b):
            got = angle_at(pts[p], pts[a], pts[b])
            if got is not None:
                out.append(('∠%s%s%s = %g°' % (a, p, b, v),
                            abs(got - v) <= TOL_ANGLE, '圖上 %.1f°' % got))

    # 6) 正多邊形：題目說「正方形 ABCD」「正三角形 ABC」「正六邊形 ABCDEF」，
    #    圖上就必須真的是正多邊形（邊等長、對角線該相等的相等）。
    #    我用聯絡表目視判形狀連錯三次，這種事只能交給程式。
    REG = ((r'正三角形|等邊三角形', 3), (r'正方形', 4),
           (r'正五邊形', 5), (r'正六邊形', 6), (r'正八邊形', 8))
    for pat, n in REG:
        for m in re.finditer('(?:' + pat + r')\s*(' + '[A-Z]' * n + r')(?![A-Z])', text):
            verts = list(m.group(1))
            if not have(*verts):
                continue
            sides = [dist(pts[verts[i]], pts[verts[(i + 1) % n]]) for i in range(n)]
            lo, hi = min(sides), max(sides)
            okk = hi - lo <= TOL_RATIO * hi
            out.append(('%s 是正多邊形' % m.group(0).strip(), okk,
                        '邊長 %s' % ' '.join('%.2f' % v for v in sides)))

    # 7) 題幹直接給座標 → 圖上的點必須是同一個形狀
    #
    # 圖可能整體縮放或平移（示意圖常這樣），所以比的是「點與點之間距離的比值」：
    # 旋轉、平移、等比縮放都不影響，但形狀畫錯就會被抓到。
    coords = {}
    for m in re.finditer(r'([A-Z])\s*\(\s*(-?\d+(?:\.\d+)?)\s*,\s*(-?\d+(?:\.\d+)?)\s*\)', text):
        n, x, y = m.group(1), float(m.group(2)), float(m.group(3))
        if n in pts:
            coords[n] = (x, y)
    if len(coords) >= 3:
        ns = sorted(coords)
        pairs = [(a, b) for i, a in enumerate(ns) for b in ns[i + 1:]]
        want = [dist(coords[a], coords[b]) for a, b in pairs]
        got = [dist(pts[a], pts[b]) for a, b in pairs]
        # 用最長的一段當基準做等比正規化
        i = want.index(max(want))
        if got[i] > 0:
            k = want[i] / got[i]
            worst = max(abs(g * k - w) / max(w, 1e-9)
                        for g, w in zip(got, want) if w > 0)
            out.append(('座標 %s 的形狀' % ''.join(ns), worst <= TOL_RATIO,
                        '最大偏差 %.1f%%' % (100 * worst)))

    # 8) 中點
    for m in re.finditer(r'([A-Z])\s*是\s*(?:邊\s*|線段\s*)?([A-Z])([A-Z])\s*的中點', text):
        x, a, b = m.groups()
        if have(x, a, b):
            mid = ((pts[a][0] + pts[b][0]) / 2, (pts[a][1] + pts[b][1]) / 2)
            d = dist(pts[x], mid)
            scale = max(dist(pts[a], pts[b]), 1e-9)
            out.append(('%s 是 %s%s 的中點' % (x, a, b), d <= 0.03 * scale,
                        '偏離 %.1f%%' % (100 * d / scale)))
    return out


def absolute_coord_checks(text, pts):
    """題幹給了座標、圖上又是有格線的座標平面 → 點必須畫在同一個座標上。

    這比形狀比對嚴格：座標平面上的點是絕對位置，畫錯一格學生就會讀錯。
    """
    out = []
    for m in re.finditer(
            r'([A-Z][A-Za-z0-9]?)\s*\(\s*(-?\d+(?:\.\d+)?)\s*,\s*(-?\d+(?:\.\d+)?)\s*\)',
            text):
        n, x, y = m.group(1), float(m.group(2)), float(m.group(3))
        if n not in pts:
            continue
        gx, gy = pts[n]
        okk = abs(gx - x) < 1e-6 and abs(gy - y) < 1e-6
        out.append(('%s 應畫在 (%g, %g)' % (n, x, y), okk,
                    '圖上畫在 (%g, %g)' % (gx, gy)))
    return out


def circle_checks(text, params):
    """題幹寫「半徑分別是 a 和 b」時，圖上兩個圓的半徑比要對得上。"""
    out = []
    circles = (params or {}).get('circles') or []
    rs = sorted(float(c['r']) for c in circles if 'r' in c)
    m = re.search(r'半徑分別是\s*(\d+(?:\.\d+)?)\s*(?:和|與|、)\s*(\d+(?:\.\d+)?)', text)
    if m and len(rs) == 2:
        want = sorted((float(m.group(1)), float(m.group(2))))
        ratio_want = want[1] / want[0]
        ratio_got = rs[1] / rs[0]
        out.append(('半徑比 %g : %g' % (want[1], want[0]),
                    abs(ratio_got - ratio_want) <= TOL_RATIO * ratio_want,
                    '圖上 %.3f，題目 %.3f' % (ratio_got, ratio_want)))
    return out


def main(argv):
    kind = None
    if '--kind' in argv:
        kind = argv[argv.index('--kind') + 1]

    bad = 0
    checked = 0
    for path in sorted(glob.glob('assets/questions/*/*.json')):
        for q in json.load(open(path))['questions']:
            fig = q.get('figure') or {}
            if fig.get('kind') in (None, 'none'):
                continue
            if kind and fig.get('kind') != kind:
                continue
            pts = points_of(fig)
            res = checks_from_prompt(q['prompt']['zh-Hant'], pts)
            res += circle_checks(q['prompt']['zh-Hant'], fig.get('params'))
            if fig.get('kind') == 'coordinate_plane':
                res += absolute_coord_checks(q['prompt']['zh-Hant'], pts)
            if not res:
                continue
            checked += 1
            fails = [r for r in res if not r[1]]
            if fails:
                bad += 1
                print('%s  [%s]' % (q['id'], fig.get('kind')))
                print('   %s' % q['prompt']['zh-Hant'][:90])
                for d, _, why in fails:
                    print('   ✗ %-28s %s' % (d, why))
                print()
    print('可機械驗證的題 %d 題，其中 %d 題的圖與題幹不符' % (checked, bad))
    return 1 if bad else 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
