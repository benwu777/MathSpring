"""題庫工具的測試。

一律使用真實檔案與真實函式，不 mock——這些腳本只讀本機 JSON，本機跑得起來。
執行：python3 -m unittest discover -s scripts/tests -t .
"""
import json
import os
import subprocess
import sys
import unittest

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.insert(0, os.path.join(ROOT, 'scripts'))
os.chdir(ROOT)

import validate_question_packs as vqp
import question_similarity_audit as qsa

with open('docs/question-bank-tags.json') as _fh:
    VOCAB = set(json.load(_fh)['tags'])


class CheckTagsTest(unittest.TestCase):
    """validate_question_packs.check_tags：詞彙表白名單與數量規則。"""

    def test_accepts_valid_tag_list(self):
        self.assertEqual(vqp.check_tags(['c:area', 'm:direct'], VOCAB), [])

    def test_rejects_tag_outside_vocabulary(self):
        errs = vqp.check_tags(['c:logic_dedcution', 'm:direct'], VOCAB)
        self.assertEqual(len(errs), 1)
        self.assertIn('c:logic_dedcution', errs[0])

    def test_rejects_missing_tags(self):
        self.assertTrue(vqp.check_tags(None, VOCAB))

    def test_rejects_empty_tags(self):
        self.assertTrue(vqp.check_tags([], VOCAB))

    def test_rejects_when_no_concept_tag(self):
        errs = vqp.check_tags(['m:direct'], VOCAB)
        self.assertTrue(any('c:' in e for e in errs))

    def test_rejects_when_no_method_tag(self):
        errs = vqp.check_tags(['c:area'], VOCAB)
        self.assertTrue(any('m:' in e for e in errs))

    def test_rejects_more_than_three_concept_tags(self):
        tags = ['c:area', 'c:triangle', 'c:circle', 'c:polygon', 'm:direct']
        self.assertTrue(vqp.check_tags(tags, VOCAB))

    def test_rejects_more_than_two_method_tags(self):
        tags = ['c:area', 'm:direct', 'm:extremal', 'm:casework']
        self.assertTrue(vqp.check_tags(tags, VOCAB))

    def test_rejects_duplicate_tags(self):
        errs = vqp.check_tags(['c:area', 'c:area', 'm:direct'], VOCAB)
        self.assertTrue(any('重複' in e for e in errs))


class TagPairVerdictTest(unittest.TestCase):
    """question_similarity_audit.tag_pair_verdict：兩題概念標籤的關係。"""

    def test_disjoint_when_no_shared_concept(self):
        v = qsa.tag_pair_verdict(['c:area', 'm:direct'], ['c:modular', 'm:direct'])
        self.assertEqual(v, 'disjoint')

    def test_identical_when_concept_sets_equal(self):
        v = qsa.tag_pair_verdict(['c:area', 'c:triangle', 'm:direct'],
                                 ['c:triangle', 'c:area', 'm:extremal'])
        self.assertEqual(v, 'identical')

    def test_overlap_when_partially_shared(self):
        v = qsa.tag_pair_verdict(['c:area', 'c:triangle', 'm:direct'],
                                 ['c:area', 'c:circle', 'm:direct'])
        self.assertEqual(v, 'overlap')

    def test_method_tags_do_not_affect_verdict(self):
        v = qsa.tag_pair_verdict(['c:area', 'm:direct'], ['c:area', 'm:invariant'])
        self.assertEqual(v, 'identical')


class TagsModeIntegrationTest(unittest.TestCase):
    """--tags 模式跑真實題庫（2528 題），不 mock。"""

    def test_tags_mode_reports_the_known_isomorphic_pair(self):
        # geometry_grade6_033 與 geometry_grade8_008 是同一族的等高面積比題，
        # 概念標籤相同但字面相似度低於門檻，正是文字閘門抓不到的盲點。
        pairs = qsa.audit_tags(report=False)
        keys = {tuple(sorted((a, b))) for a, b, _ in pairs}
        self.assertIn(('geometry_grade6_foundation_033', 'geometry_grade8_foundation_008'), keys)

    def test_tags_mode_never_pairs_questions_with_no_shared_concept(self):
        for a, b, _ in qsa.audit_tags(report=False):
            self.assertNotEqual(qsa.tag_pair_verdict(qsa.tags_of(a), qsa.tags_of(b)), 'disjoint')


class ValidatorOnRealPacksTest(unittest.TestCase):
    """整合測試：驗證器對真實的 50 個題庫檔要全綠。"""

    def test_real_packs_pass_validation(self):
        r = subprocess.run([sys.executable, 'scripts/validate_question_packs.py'],
                           capture_output=True, text=True, cwd=ROOT)
        self.assertEqual(r.returncode, 0, r.stdout + r.stderr)
        self.assertIn('全部通過', r.stdout)


if __name__ == '__main__':
    unittest.main()
