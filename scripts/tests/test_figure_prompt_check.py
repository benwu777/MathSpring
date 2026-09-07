"""check_figure_matches_prompt：把踩過的誤判陷阱釘住。

這支檢查器的價值全在「不要誤報」——一旦誤報多，人就會開始略過它的輸出，
那它就等於不存在。下面三條測試對應我實際踩到的三個誤判來源。
"""
import os
import sys
import unittest

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), os.pardir, os.pardir)
sys.path.insert(0, os.path.join(ROOT, 'scripts'))
os.chdir(ROOT)

import check_figure_matches_prompt as chk  # noqa: E402


def fails(text, pts):
    return [d for d, ok, _ in chk.checks_from_prompt(text, pts) if not ok]


class FigurePromptCheckTest(unittest.TestCase):
    def test_angle_name_tail_is_not_a_segment_length(self):
        """`∠BAE = 35°` 的尾巴不是「AE 長 35」。"""
        # 座標真的滿足這兩個角，這樣測的才是「有沒有誤把 AE 當成長度 35」
        import math as _m
        pts = {'A': (0, 0), 'B': (4, 0),
               'E': (3 * _m.cos(_m.radians(35)), 3 * _m.sin(_m.radians(35))),
               'C': (0, -5)}
        text = '已知 ∠BAE = 35°。'
        self.assertEqual(fails(text, pts), [])

    def test_ratio_right_hand_side_is_not_a_segment_length(self):
        """`BD : DC = 2 : 1` 的右項不是「DC 長 2」。"""
        # 兩個比例在圖上都真的成立，測的才是「有沒有誤把 DC 當成長度 2」
        A, B, C = (1.0, 6.0), (0.0, 0.0), (3.0, 0.0)
        D = (B[0] + 2 / 3 * (C[0] - B[0]), B[1] + 2 / 3 * (C[1] - B[1]))
        E = (A[0] + 3 / 4 * (C[0] - A[0]), A[1] + 3 / 4 * (C[1] - A[1]))
        pts = {'A': A, 'B': B, 'C': C, 'D': D, 'E': E}
        text = '點 D 在邊 BC 上且 BD : DC = 2 : 1，點 E 在邊 AC 上且 AE : EC = 3 : 1。'
        self.assertEqual(fails(text, pts), [])

    def test_chained_equality_is_checked(self):
        """`BC = CD = 43` 這種連鎖等式必須抓得到——第一版就是漏了它。"""
        pts = {'B': (8, 4), 'C': (10, 0), 'D': (4, 0)}
        text = '梯形中 BC = CD = 43。'
        self.assertEqual(fails(text, pts), ['BC = CD'])

    def test_schematic_scale_slack_does_not_trigger(self):
        """示意圖的絕對縮放本來就有偏差，7% 以內不該報。"""
        # AB = 9、AO = 6（比值 1.5）；圖上畫成 3.0 與 1.875（比值 1.6）
        pts = {'A': (0, 0), 'B': (3, 0), 'O': (1.875, 0)}
        text = 'AB = 9 公分，已知 AO = 6 公分。'
        self.assertEqual(fails(text, pts), [])

    def test_real_contradiction_is_reported(self):
        """真的矛盾要報：題目說垂直，圖上卻不垂直。"""
        # AD = (4,0)、BD = (-1,-3)，內積 -4 ≠ 0，確實不垂直
        pts = {'A': (0, 0), 'D': (4, 0), 'B': (5, 3)}
        text = '已知 AD ⟂ BD。'
        self.assertEqual(fails(text, pts), ['AD ⟂ BD'])

    def test_midpoint_claim_is_checked(self):
        pts = {'M': (5, 0), 'B': (0, 0), 'C': (8, 0)}
        text = '點 M 是邊 BC 的中點。'
        self.assertEqual(fails(text, pts), ['M 是 BC 的中點'])


if __name__ == '__main__':
    unittest.main()


class RegularPolygonTest(unittest.TestCase):
    def test_square_drawn_as_rectangle_is_reported(self):
        pts = {'A': (0, 0), 'B': (6, 0), 'C': (6, 4), 'D': (0, 4)}
        self.assertEqual(fails('正方形 ABCD 的邊長是 6。', pts), ['正方形 ABCD 是正多邊形'])

    def test_real_square_passes(self):
        pts = {'A': (0, 0), 'B': (6, 0), 'C': (6, 6), 'D': (0, 6)}
        self.assertEqual(fails('正方形 ABCD 的邊長是 6。', pts), [])

    def test_equilateral_triangle_is_checked(self):
        import math as _m
        pts = {'A': (0, 0), 'B': (4, 0), 'C': (2, 4 * _m.sqrt(3) / 2)}
        self.assertEqual(fails('正三角形 ABC 的邊長是 4。', pts), [])


class ExplicitCoordinateTest(unittest.TestCase):
    """題幹直接給座標時，圖上的點必須是同一個形狀。

    圖可能整體縮放或平移，所以比的是「點與點之間距離的比值」，
    這樣旋轉、平移、縮放都不影響，但形狀畫錯就會被抓到。
    """

    TEXT = '四邊形 ABCD 的四個頂點依序是 A(0, 0)、B(6, 0)、C(8, 5)、D(2, 7)。'

    def test_matching_shape_passes(self):
        pts = {'A': (0, 0), 'B': (6, 0), 'C': (8, 5), 'D': (2, 7)}
        self.assertEqual(fails(self.TEXT, pts), [])

    def test_uniformly_scaled_shape_passes(self):
        pts = {k: (v[0] * 3, v[1] * 3) for k, v in
               {'A': (0, 0), 'B': (6, 0), 'C': (8, 5), 'D': (2, 7)}.items()}
        self.assertEqual(fails(self.TEXT, pts), [])

    def test_wrong_shape_is_reported(self):
        pts = {'A': (0, 0), 'B': (6, 0), 'C': (8, 5), 'D': (2, 2)}   # D 畫錯
        self.assertTrue(fails(self.TEXT, pts))


class CircleRadiusTest(unittest.TestCase):
    def test_radius_ratio_is_checked(self):
        text = '兩個圓外切於一點，半徑分別是 4 和 9。'
        good = {'circles': [{'cx': 0, 'cy': 0, 'r': 4}, {'cx': 13, 'cy': 0, 'r': 9}]}
        bad = {'circles': [{'cx': 0, 'cy': 0, 'r': 4}, {'cx': 9, 'cy': 0, 'r': 5}]}
        self.assertEqual(
            [d for d, ok, _ in chk.circle_checks(text, good) if not ok], [])
        self.assertTrue(
            [d for d, ok, _ in chk.circle_checks(text, bad) if not ok])


class CoordinatePlaneTest(unittest.TestCase):
    """coordinate_plane 有格線、座標是絕對值，所以要比「相等」而不只是形狀。"""

    def test_label_key_is_read_as_a_point_name(self):
        fig = {'kind': 'coordinate_plane',
               'params': {'points': [{'x': 1, 'y': 1, 'label': 'A'},
                                     {'x': 6, 'y': 2, 'label': 'B'}]}}
        self.assertEqual(chk.points_of(fig), {'A': (1.0, 1.0), 'B': (6.0, 2.0)})

    def test_plotted_point_must_match_stated_coordinate(self):
        text = '三角形的三個頂點是 A(1,1)、B(6,2)、C(2,6)。'
        good = {'A': (1, 1), 'B': (6, 2), 'C': (2, 6)}
        bad = {'A': (1, 1), 'B': (6, 2), 'C': (3, 6)}
        self.assertEqual(
            [d for d, ok, _ in chk.absolute_coord_checks(text, good) if not ok], [])
        self.assertEqual(
            [d for d, ok, _ in chk.absolute_coord_checks(text, bad) if not ok],
            ['C 應畫在 (2, 6)'])   # 描述寫的是題目要求的座標，不是圖上畫錯的那個
