"""題庫工具的測試。

一律使用真實檔案與真實函式，不 mock——這些腳本只讀本機 JSON，本機跑得起來。
執行：python3 -m unittest discover -s scripts/tests -t .
"""
import json
import os
import shutil
import subprocess
import tempfile
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


class CheckOptionLengthsTest(unittest.TestCase):
    """validate_question_packs.check_option_lengths：正解不可明顯比誘答長。

    選擇題若正解遠比每一個誘答長，學生不必推理、挑最長的就會中，
    這是選擇題最常見的作答線索洩漏。
    """

    def _opts(self, **kw):
        return {k: {'zh-Hant': v} for k, v in kw.items()}

    def test_accepts_options_of_similar_length(self):
        opts = self._opts(A='先手必勝，因為他每一步都能維持對稱的局面。',
                          B='後手必勝，因為他每一步都能把棋子推回中央。',
                          C='勝負取決於棋盤的邊長，無法一概而論。',
                          D='雙方都沒有必勝策略，最後一定平手。')
        self.assertEqual(vqp.check_option_lengths(opts, 'A'), [])

    def test_rejects_correct_option_far_longer_than_every_distractor(self):
        opts = self._opts(A='先手必勝：他先把第 1 枚硬幣放在桌面正中央，之後對手每放一枚，他就放在該枚硬幣關於桌心的對稱位置。',
                          B='後手必勝。',
                          C='無法確定。',
                          D='一定平手。')
        errs = vqp.check_option_lengths(opts, 'A')
        self.assertEqual(len(errs), 1)
        self.assertIn('正解', errs[0])

    def test_accepts_when_correct_is_longest_but_within_ratio(self):
        # 正解 26 字、最長誘答 19 字，比值 1.37 < 1.6，屬正常起伏
        opts = self._opts(A='這個三角形一定是等腰三角形，因為它的兩個底角大小相等',
                          B='這個三角形一定是直角三角形，有一個直角',
                          C='這個三角形一定是鈍角三角形',
                          D='資訊不足，無法判斷')
        self.assertEqual(vqp.check_option_lengths(opts, 'A'), [])

    def test_accepts_short_options_even_at_high_ratio(self):
        # 「12」對「3」比值 2.0，但選項這麼短時長度不帶任何線索
        opts = self._opts(A='12', B='3', C='5', D='8')
        self.assertEqual(vqp.check_option_lengths(opts, 'A'), [])

    def test_accepts_when_a_distractor_is_the_longest(self):
        opts = self._opts(A='不可能，因為另外兩個角加起來只有 90 度',
                          B='可能，這種情形在銳角三角形裡很常見，而且可以舉出實際的例子來說明',
                          C='無法判斷',
                          D='一定可能')
        self.assertEqual(vqp.check_option_lengths(opts, 'A'), [])

    def test_returns_no_error_when_options_missing(self):
        self.assertEqual(vqp.check_option_lengths(None, 'A'), [])

    def test_returns_no_error_when_correct_key_absent(self):
        opts = self._opts(A='甲', B='乙')
        self.assertEqual(vqp.check_option_lengths(opts, 'Z'), [])


class OptionLengthOnRealPacksTest(unittest.TestCase):
    """整合測試：真實題庫的 470 道選擇題都不可有長度線索洩漏。"""

    def test_no_real_question_leaks_answer_by_length(self):
        import glob
        offenders = []
        for path in sorted(glob.glob('assets/questions/*/*.json')):
            with open(path) as fh:
                pack = json.load(fh)
            for q in pack['questions']:
                if q.get('answerMode') != 'multiple_choice':
                    continue
                errs = vqp.check_option_lengths(
                    q.get('options'), q['correctAnswer']['value'])
                offenders.extend('%s: %s' % (q['id'], e) for e in errs)
        self.assertEqual(offenders, [], '\n'.join(offenders))


class ValidatorReportsOptionLengthLeakTest(unittest.TestCase):
    """整合測試：驗證器本身要把長度線索當成錯誤擋下來。

    做法是把真實題包複製到暫存目錄、只把誘答改短，再用該目錄當 cwd 跑驗證器。
    全部走真實檔案與真實子行程，沒有 mock。
    """

    def _build_tree(self, tmp, question):
        os.makedirs(os.path.join(tmp, 'assets', 'questions', 'logic'))
        os.makedirs(os.path.join(tmp, 'docs'))
        shutil.copy(os.path.join(ROOT, 'docs', 'question-bank-tags.json'),
                    os.path.join(tmp, 'docs', 'question-bank-tags.json'))
        rel = 'assets/questions/logic/grade10_foundation.logic.v1.json'
        pack = {'schemaVersion': 1, 'questions': [question]}
        with open(os.path.join(tmp, rel), 'w') as fh:
            fh.write(json.dumps(pack, ensure_ascii=False, indent=2) + '\n')
        manifest = {'version': 1, 'packs': [{
            'path': rel, 'topic': '邏輯', 'topicCode': 'logic',
            'levelStage': 'grade10', 'challengeTier': 'foundation',
            'questionCount': 1}]}
        with open(os.path.join(tmp, 'assets', 'questions', 'manifest.json'), 'w') as fh:
            fh.write(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')

    def _real_question(self, qid):
        import glob
        for path in glob.glob('assets/questions/*/*.json'):
            with open(path) as fh:
                for q in json.load(fh)['questions']:
                    if q['id'] == qid:
                        return q
        raise AssertionError('找不到題目 %s' % qid)

    def test_validator_flags_a_pack_whose_correct_option_is_far_longer(self):
        q = self._real_question('logic_grade10_foundation_044')
        for key in ('A', 'B', 'D'):
            for lang in ('zh-Hant', 'zh-Hans', 'en', 'ja'):
                q['options'][key][lang] = {'A': 'No.', 'B': 'Maybe.',
                                           'D': 'Draw.'}[key]
        with tempfile.TemporaryDirectory() as tmp:
            self._build_tree(tmp, q)
            r = subprocess.run(
                [sys.executable, os.path.join(ROOT, 'scripts',
                                              'validate_question_packs.py')],
                capture_output=True, text=True, cwd=tmp)
        self.assertNotEqual(r.returncode, 0, r.stdout)
        self.assertIn('挑最長的就會中', r.stdout)


class ValidatorOnRealPacksTest(unittest.TestCase):
    """整合測試：驗證器對真實的 50 個題庫檔要全綠。"""

    def test_real_packs_pass_validation(self):
        r = subprocess.run([sys.executable, 'scripts/validate_question_packs.py'],
                           capture_output=True, text=True, cwd=ROOT)
        self.assertEqual(r.returncode, 0, r.stdout + r.stderr)
        self.assertIn('全部通過', r.stdout)


if __name__ == '__main__':
    unittest.main()
