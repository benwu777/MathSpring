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
import derive_simplified_only_chars as dsoc

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
        # 正解 26 字、最長誘答 19 字，比值 1.37 < 1.5，屬正常起伏
        opts = self._opts(A='這個三角形一定是等腰三角形，因為它的兩個底角大小相等',
                          B='這個三角形一定是直角三角形，有一個直角',
                          C='這個三角形一定是鈍角三角形',
                          D='資訊不足，無法判斷')
        self.assertEqual(vqp.check_option_lengths(opts, 'A'), [])

    def test_accepts_short_options_even_at_high_ratio(self):
        # 「12」對「3」比值 2.0，但選項這麼短時長度不帶任何線索
        opts = self._opts(A='12', B='3', C='5', D='8')
        self.assertEqual(vqp.check_option_lengths(opts, 'A'), [])

    def test_accepts_high_ratio_when_the_absolute_gap_is_small(self):
        # 真實案例 logic_grade1_foundation_040：正解 15 字、最長誘答 10 字，
        # 比值剛好 1.5，但只差 5 個字，不構成「挑最長的就會中」。
        opts = self._opts(A='第一張，最左邊那一張',
                          B='第二張，中間那一張',
                          C='第三張，最右邊那一張',
                          D='無法確定，可能是第一張或第三張')
        self.assertEqual(vqp.check_option_lengths(opts, 'D'), [])

    def test_accepts_large_absolute_gap_when_the_ratio_is_small(self):
        # 選項本來就長的題目，差 10 個字只是正常起伏（比值 1.18）
        opts = self._opts(A='甲' * 66, B='乙' * 56, C='丙' * 54, D='丁' * 50)
        self.assertEqual(vqp.check_option_lengths(opts, 'A'), [])

    def test_rejects_when_both_the_ratio_and_the_absolute_gap_are_large(self):
        # 真實案例 geometry_grade1_foundation_033：正解 33 字、最長誘答 21 字
        opts = self._opts(A='一定對稱，因為鏡像圖形跟原本的圖形，沿著黏合的那條線本來就互相對稱',
                          B='不一定對稱，要看原本的三角形是不是正三角形',
                          C='一定不對稱，因為兩個三角形不可能完全貼合',
                          D='沒辦法判斷，要先量出三角形每個角的度數')
        errs = vqp.check_option_lengths(opts, 'A')
        self.assertEqual(len(errs), 1)
        self.assertIn('33', errs[0])
        self.assertIn('21', errs[0])

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


class SceneChecksUndefinedPointTest(unittest.TestCase):
    """validate_question_packs.scene_checks：引用不存在的點要報錯，不可讓驗證器整個炸掉。

    只有 segments 有做名稱檢查，rightAngles / equalTicks / angleMarks / polygons
    都是直接 pts[name]，打錯一個字就是 KeyError——驗證器當場中止，
    後面所有題目都不會被檢查。開放起草代理畫圖之後這會變成常態錯誤。
    """

    def _scene(self, **extra):
        params = {
            'bounds': {'minX': 0, 'minY': 0, 'maxX': 4, 'maxY': 3},
            'points': [{'name': 'A', 'x': 0, 'y': 0},
                       {'name': 'B', 'x': 4, 'y': 0},
                       {'name': 'C', 'x': 0, 'y': 3}],
            'segments': [{'from': 'A', 'to': 'B'}, {'from': 'B', 'to': 'C'},
                         {'from': 'C', 'to': 'A'}],
        }
        params.update(extra)
        return {'figure': {'type': 'custom', 'kind': 'geometry_scene',
                           'params': params}}

    def _run(self, scene):
        msgs = []
        vqp.scene_checks(scene, msgs.append)
        return msgs

    def test_valid_scene_reports_nothing(self):
        scene = self._scene(
            rightAngles=[{'at': 'A', 'from': 'B', 'to': 'C'}],
            polygons=[{'vertices': ['A', 'B', 'C']}],
            equalTicks=[{'segments': [['A', 'B'], ['A', 'B']]}],
            angleMarks=[{'at': 'A', 'from': 'B', 'to': 'C', 'label': '90°'}])
        self.assertEqual(self._run(scene), [])

    def test_right_angle_referencing_undefined_point_is_reported(self):
        scene = self._scene(rightAngles=[{'at': 'A', 'from': 'B', 'to': 'Z'}])
        msgs = self._run(scene)
        self.assertEqual(len(msgs), 1)
        self.assertIn('Z', msgs[0])

    def test_equal_ticks_referencing_undefined_point_is_reported(self):
        scene = self._scene(equalTicks=[{'segments': [['A', 'B'], ['A', 'Z']]}])
        msgs = self._run(scene)
        self.assertEqual(len(msgs), 1)
        self.assertIn('Z', msgs[0])

    def test_angle_mark_referencing_undefined_point_is_reported(self):
        scene = self._scene(
            angleMarks=[{'at': 'Z', 'from': 'B', 'to': 'C', 'label': '90°'}])
        msgs = self._run(scene)
        self.assertEqual(len(msgs), 1)
        self.assertIn('Z', msgs[0])

    def test_polygon_referencing_undefined_point_is_reported(self):
        scene = self._scene(polygons=[{'vertices': ['A', 'B', 'Z']}])
        msgs = self._run(scene)
        self.assertEqual(len(msgs), 1)
        self.assertIn('Z', msgs[0])


class ValidatorReportsOptionLengthLeakTest(unittest.TestCase):
    """整合測試：驗證器本身要把長度線索當成錯誤擋下來。

    做法是把真實題包複製到暫存目錄、只把誘答改短，再用該目錄當 cwd 跑驗證器。
    全部走真實檔案與真實子行程，沒有 mock。
    """

    def _build_tree(self, tmp, question):
        os.makedirs(os.path.join(tmp, 'assets', 'questions', 'logic'))
        os.makedirs(os.path.join(tmp, 'docs'))
        for name in ('question-bank-tags.json', 'simplified-only-chars.txt'):
            shutil.copy(os.path.join(ROOT, 'docs', name),
                        os.path.join(tmp, 'docs', name))
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


class SimplifiedOnlyCharsTest(unittest.TestCase):
    """validate_question_packs：zh-Hant 欄位混入簡體字要被抓到。

    這是 2026-09-03 第三輪起草代理踩到的失敗模式：代理把整段簡體文字
    同時寫進 zh-Hant 與 zh-Hans，繁體欄位整段是簡體。既有閘門
    （英文殘留掃描、四語系齊全檢查）完全抓不到——兩邊都是中文、都非空。
    """

    def setUp(self):
        self.chars = vqp.load_simplified_only_chars()

    def _q(self, **fields):
        q = {'prompt': {'zh-Hant': '長方形的面積是多少？',
                        'zh-Hans': '长方形的面积是多少？',
                        'en': 'What is the area?', 'ja': '面積は？'}}
        q.update(fields)
        return q

    def test_char_set_excludes_chars_shared_by_both_scripts(self):
        for ch in '面一二三十的是':
            self.assertNotIn(ch, self.chars)

    def test_char_set_contains_known_simplified_only_chars(self):
        for ch in '个长宽积数学题':
            self.assertIn(ch, self.chars)

    def test_clean_traditional_text_reports_nothing(self):
        self.assertEqual(vqp.check_simplified_in_traditional(self._q(), self.chars), [])

    def test_simplified_prompt_written_into_traditional_field_is_reported(self):
        q = self._q(prompt={'zh-Hant': '长方形的面积是多少？',
                            'zh-Hans': '长方形的面积是多少？',
                            'en': 'What is the area?', 'ja': '面積は？'})
        msgs = vqp.check_simplified_in_traditional(q, self.chars)
        self.assertEqual(len(msgs), 1)
        self.assertIn('prompt', msgs[0])
        self.assertIn('长', msgs[0])

    def test_simplified_in_solution_steps_is_reported(self):
        q = self._q(solutionSteps={'zh-Hant': ['先算长边。'], 'zh-Hans': ['先算长边。'],
                                   'en': ['First the side.'], 'ja': ['まず辺。']})
        msgs = vqp.check_simplified_in_traditional(q, self.chars)
        self.assertEqual(len(msgs), 1)
        self.assertIn('solutionSteps', msgs[0])

    def test_simplified_in_options_is_reported(self):
        q = self._q(options={'A': {'zh-Hant': '个位数', 'zh-Hans': '个位数',
                                   'en': 'units digit', 'ja': '一の位'}})
        msgs = vqp.check_simplified_in_traditional(q, self.chars)
        self.assertEqual(len(msgs), 1)
        self.assertIn('options', msgs[0])

    def test_only_the_traditional_field_is_inspected(self):
        """zh-Hans / en / ja 本來就該是簡體或外文，不可誤報。"""
        q = self._q(answer={'zh-Hant': '答案是 4 公分。', 'zh-Hans': '答案是 4 公分。',
                            'en': 'The answer is 4 cm.', 'ja': '答えは4cmです。'})
        self.assertEqual(vqp.check_simplified_in_traditional(q, self.chars), [])


class SimplifiedCharsOnRealPacksTest(unittest.TestCase):
    """整合測試：真實題庫每一題的 zh-Hant 都不可含簡體專用字。"""

    def test_no_real_question_has_simplified_in_traditional(self):
        import glob
        chars = vqp.load_simplified_only_chars()
        offenders = []
        for path in sorted(glob.glob('assets/questions/*/*.json')):
            with open(path) as fh:
                pack = json.load(fh)
            for q in pack['questions']:
                offenders.extend('%s: %s' % (q['id'], e)
                                 for e in vqp.check_simplified_in_traditional(q, chars))
        self.assertEqual(offenders, [], '\n'.join(offenders))


class DeriveSimplifiedOnlyCharsTest(unittest.TestCase):
    """推導腳本：字集必須真的從題庫的 zh-Hans / zh-Hant 字頻算出來。

    用真的函式跑一份小型題庫，不 mock——它只讀記憶體裡的 dict。
    """

    def test_char_appearing_in_both_scripts_is_not_simplified_only(self):
        qs = [{'prompt': {'zh-Hant': '面' * 9, 'zh-Hans': '面' * 9}}]
        self.assertEqual(dsoc.derive(qs, min_hans_count=5), [])

    def test_char_only_in_hans_and_frequent_enough_is_collected(self):
        qs = [{'prompt': {'zh-Hant': '長', 'zh-Hans': '长' * 6}}]
        self.assertEqual(dsoc.derive(qs, min_hans_count=5), ['长'])

    def test_rare_hans_only_char_is_ignored(self):
        """只出現一兩次的字可能是既有題的漏網錯字，收進來會變成用髒資料驗髒資料。"""
        qs = [{'prompt': {'zh-Hant': '長', 'zh-Hans': '长长'}}]
        self.assertEqual(dsoc.derive(qs, min_hans_count=5), [])

    def test_committed_char_file_matches_what_the_script_derives_now(self):
        self.assertEqual(sorted(vqp.load_simplified_only_chars()),
                         dsoc.derive(dsoc.load_questions()))


class ValidatorReportsSimplifiedInTraditionalTest(unittest.TestCase):
    """整合測試：驗證器本身要把 zh-Hant 裡的簡體字當成錯誤擋下來。

    複製真實題目到暫存目錄、把 zh-Hant 換成 zh-Hans 的內容，再跑真的驗證器子行程。
    """

    def test_validator_flags_a_pack_whose_traditional_field_is_simplified(self):
        helper = ValidatorReportsOptionLengthLeakTest()
        q = helper._real_question('geometry_grade4_foundation_001')
        q['prompt']['zh-Hant'] = q['prompt']['zh-Hans']
        with tempfile.TemporaryDirectory() as tmp:
            helper._build_tree(tmp, q)
            r = subprocess.run(
                [sys.executable, os.path.join(ROOT, 'scripts',
                                              'validate_question_packs.py')],
                capture_output=True, text=True, cwd=tmp)
        self.assertNotEqual(r.returncode, 0, r.stdout)
        self.assertIn('簡體', r.stdout)


class SimplifiedTermsTest(unittest.TestCase):
    """validate_question_packs.check_simplified_terms：zh-Hans 不得用台灣用語。

    題庫的 zh-Hans 多由繁中轉換而來，沿用「公分」「机率」等台灣用語。
    2026-10-02 統一成大陸用法（docs/plans/2026-10-02-zh-hans-terms-design.md），
    這條檢查擋住之後補題又寫回去。
    """

    def _q(self, hans, grade='grade6', field='prompt'):
        q = {'levelStage': grade,
             'prompt': {'zh-Hant': '題目', 'zh-Hans': '题目', 'en': 'Q', 'ja': '問題'}}
        if field == 'solutionSteps':
            q['solutionSteps'] = {'zh-Hant': ['步驟'], 'zh-Hans': [hans], 'en': ['s'], 'ja': ['s']}
        elif field == 'options':
            q['options'] = {'A': {'zh-Hant': '選項', 'zh-Hans': hans, 'en': 'o', 'ja': 'o'}}
        else:
            q[field] = {'zh-Hant': '題目', 'zh-Hans': hans, 'en': 'Q', 'ja': '問題'}
        return q

    def test_mainland_terms_report_nothing(self):
        q = self._q('长 5 厘米、宽 3 米，重 2 千克，概率是 1/2，坐标 (1, 2)。')
        self.assertEqual(vqp.check_simplified_terms(q), [])

    def test_taiwan_unit_is_reported_with_its_replacement(self):
        msgs = vqp.check_simplified_terms(self._q('边长 4 公分。'))
        self.assertEqual(len(msgs), 1)
        self.assertIn('公分', msgs[0])
        self.assertIn('厘米', msgs[0])

    def test_taiwan_math_term_is_reported(self):
        self.assertTrue(vqp.check_simplified_terms(self._q('抽到红球的机率是多少？')))

    def test_term_in_solution_steps_is_reported(self):
        msgs = vqp.check_simplified_terms(self._q('在座标平面上', field='solutionSteps'))
        self.assertEqual(len(msgs), 1)
        self.assertIn('solutionSteps', msgs[0])

    def test_term_in_options_is_reported(self):
        msgs = vqp.check_simplified_terms(self._q('3 公尺', field='options'))
        self.assertEqual(len(msgs), 1)
        self.assertIn('options', msgs[0])

    def test_words_shared_with_mainland_are_not_reported(self):
        """公里、公顷、毫升、方程式、最大公约数在大陸也這樣寫。"""
        q = self._q('走了 3 公里，2 公顷，5 毫升，解方程式，最大公约数是 6。')
        self.assertEqual(vqp.check_simplified_terms(q), [])

    def test_odd_even_colloquial_words_allowed_up_to_grade4(self):
        self.assertEqual(vqp.check_simplified_terms(self._q('单数和双数', grade='grade4')), [])

    def test_odd_even_colloquial_words_reported_from_grade5(self):
        msgs = vqp.check_simplified_terms(self._q('单数和双数', grade='grade5'))
        self.assertTrue(any('奇数' in m for m in msgs), msgs)

    def test_taiwan_logic_and_sequence_terms_are_reported(self):
        msgs = vqp.check_simplified_terms(self._q('若且唯若 n 是质数；由递回式可得'))
        self.assertEqual(len(msgs), 1)
        self.assertIn('当且仅当', msgs[0])
        self.assertIn('递推', msgs[0])

    def test_mistranslated_equation_is_reported(self):
        """繁轉簡把「方程式」的「程式」轉成「程序」，變成「方程序」。"""
        msgs = vqp.check_simplified_terms(self._q('解二次方程序 x² = 4'))
        self.assertTrue(any('方程序' in m for m in msgs), msgs)

    def test_traditional_field_is_not_inspected(self):
        q = {'levelStage': 'grade6',
             'prompt': {'zh-Hant': '邊長 4 公分', 'zh-Hans': '边长 4 厘米', 'en': 'Q', 'ja': '問題'}}
        self.assertEqual(vqp.check_simplified_terms(q), [])


class SimplifiedTermsOnRealPacksTest(unittest.TestCase):
    """整合測試：真實題庫每一題的 zh-Hans 都不可含台灣用語。"""

    def test_no_real_question_uses_taiwan_terms_in_simplified(self):
        import glob
        offenders = []
        for path in sorted(glob.glob('assets/questions/*/*.json')):
            with open(path) as fh:
                pack = json.load(fh)
            for q in pack['questions']:
                offenders.extend('%s: %s' % (q['id'], e)
                                 for e in vqp.check_simplified_terms(q))
        self.assertEqual(offenders, [], '\n'.join(offenders[:20]))


class ValidatorReportsSimplifiedTermsTest(unittest.TestCase):
    """整合測試：驗證器本身要把 zh-Hans 的台灣用語當成錯誤擋下來。"""

    def test_validator_flags_taiwan_term_in_simplified_field(self):
        helper = ValidatorReportsOptionLengthLeakTest()
        q = helper._real_question('geometry_grade4_foundation_001')
        q['prompt']['zh-Hans'] = q['prompt']['zh-Hans'] + '（单位：公分）'
        with tempfile.TemporaryDirectory() as tmp:
            helper._build_tree(tmp, q)
            r = subprocess.run(
                [sys.executable, os.path.join(ROOT, 'scripts',
                                              'validate_question_packs.py')],
                capture_output=True, text=True, cwd=tmp)
        self.assertNotEqual(r.returncode, 0, r.stdout)
        self.assertIn('公分', r.stdout)


class CheckFigureParamsTest(unittest.TestCase):
    """validate_question_packs.check_figure_params：三種 kind 的 params 過去完全沒被檢查。

    只有 geometry_scene 有 scene_checks。shape_diagram / coordinate_plane /
    composite_grid_shape 的 params 寫錯時，畫面只會靜默畫錯或一片空白，
    不報錯、不留 log。開放起草代理附圖之後這個缺口變得重要。

    每條規則都對應 renderer 實際的行為（lib/src/diagram_painters.dart 的 painter）。
    """

    def _fig(self, kind, **params):
        return {'type': 'custom', 'kind': kind, 'params': params}

    # --- 共通 ---

    def test_kind_none_must_have_empty_params(self):
        msgs = vqp.check_figure_params(self._fig('none', rows=3))
        self.assertEqual(len(msgs), 1)
        self.assertIn('none', msgs[0])

    def test_kind_none_with_empty_params_is_fine(self):
        self.assertEqual(vqp.check_figure_params(self._fig('none')), [])

    def test_unknown_param_key_is_reported(self):
        """renderer 只讀白名單裡的鍵，多寫的鍵靜默被丟掉——例如 highlightInterval。"""
        msgs = vqp.check_figure_params(
            self._fig('coordinate_plane', maxX=5, maxY=5,
                      points=[{'x': 1, 'y': 1}], highlightInterval=['-4', '4']))
        self.assertEqual(len(msgs), 1)
        self.assertIn('highlightInterval', msgs[0])

    def test_geometry_scene_stray_key_from_another_kind_is_reported(self):
        msgs = vqp.check_figure_params(
            self._fig('geometry_scene', bounds={'minX': 0, 'minY': 0, 'maxX': 1, 'maxY': 1},
                      points=[], rows=4, cols=5, filledCells=[[0, 0]]))
        self.assertEqual(len(msgs), 1)
        for key in ('rows', 'cols', 'filledCells'):
            self.assertIn(key, msgs[0])

    # --- shape_diagram ---

    def test_shape_diagram_accepts_a_supported_shape(self):
        self.assertEqual(vqp.check_figure_params(
            self._fig('shape_diagram', shape='trapezoid',
                      labels={'top': '4', 'bottom': '10'})), [])

    def test_shape_diagram_unsupported_shape_is_reported(self):
        """renderer 的 switch 沒有 default 以外的處理，寫錯就靜默畫成 rectangle。"""
        msgs = vqp.check_figure_params(self._fig('shape_diagram', shape='rhombus'))
        self.assertEqual(len(msgs), 1)
        self.assertIn('rhombus', msgs[0])

    def test_shape_diagram_unknown_label_key_is_reported(self):
        msgs = vqp.check_figure_params(
            self._fig('shape_diagram', shape='square', labels={'topLeft': '3'}))
        self.assertEqual(len(msgs), 1)
        self.assertIn('topLeft', msgs[0])

    def test_shape_diagram_circle_cannot_paint_left_or_bottom_labels(self):
        """circle 這一支只畫 center / top / right，其餘標籤靜默消失。"""
        msgs = vqp.check_figure_params(
            self._fig('shape_diagram', shape='circle',
                      labels={'center': 'O', 'bottom': 'r'}))
        self.assertEqual(len(msgs), 1)
        self.assertIn('bottom', msgs[0])

    # --- coordinate_plane ---

    def test_coordinate_plane_valid_figure_reports_nothing(self):
        self.assertEqual(vqp.check_figure_params(
            self._fig('coordinate_plane', minX=-5, maxX=5, minY=-5, maxY=5,
                      showGrid=True,
                      points=[{'x': 1, 'y': 2, 'label': 'A'}],
                      path=[{'x': -5, 'y': 0}, {'x': 5, 'y': 0}],
                      highlightPoint={'x': 1, 'y': 2, 'label': 'A'})), [])

    def test_coordinate_plane_point_outside_bounds_is_reported(self):
        """省略 minY 時預設是 0，負座標的點會畫到繪圖區外面去。"""
        msgs = vqp.check_figure_params(
            self._fig('coordinate_plane', maxX=6, maxY=8,
                      points=[{'x': 4, 'y': -7, 'label': "P'"}]))
        self.assertEqual(len(msgs), 1)
        self.assertIn('-7', msgs[0])

    def test_coordinate_plane_path_outside_bounds_is_reported(self):
        msgs = vqp.check_figure_params(
            self._fig('coordinate_plane', maxX=8, maxY=6,
                      points=[{'x': 3, 'y': 5}],
                      path=[{'x': 1, 'y': -5}, {'x': 3, 'y': 5}]))
        self.assertEqual(len(msgs), 1)
        self.assertIn('path', msgs[0])

    def test_coordinate_plane_non_integer_coordinate_is_reported(self):
        """_intFromDynamic 對 0.4 會 parse 失敗、fallback 成 0，點默默跑到別的地方。"""
        msgs = vqp.check_figure_params(
            self._fig('coordinate_plane', maxX=6, maxY=11,
                      points=[{'x': -1, 'y': 0.4, 'label': 'C'}, {'x': 0, 'y': 0}],
                      minX=-6, minY=0))
        self.assertEqual(len(msgs), 1)
        self.assertIn('0.4', msgs[0])

    def test_coordinate_plane_highlight_point_not_matching_any_point_is_reported(self):
        """highlightPoint 不會自己畫點，只把 points 裡座標相同的那一點改紅；不匹配就毫無效果。"""
        msgs = vqp.check_figure_params(
            self._fig('coordinate_plane', maxX=6, maxY=6,
                      points=[{'x': 1, 'y': 1, 'label': 'A'}],
                      highlightPoint={'x': 2, 'y': 2}))
        self.assertEqual(len(msgs), 1)
        self.assertIn('highlightPoint', msgs[0])

    def test_coordinate_plane_reversed_bounds_are_reported(self):
        msgs = vqp.check_figure_params(
            self._fig('coordinate_plane', minX=5, maxX=1, minY=0, maxY=6,
                      points=[{'x': 2, 'y': 2}]))
        self.assertEqual(len(msgs), 1)
        self.assertIn('minX', msgs[0])

    # --- composite_grid_shape ---

    def test_composite_grid_shape_valid_figure_reports_nothing(self):
        self.assertEqual(vqp.check_figure_params(
            self._fig('composite_grid_shape', rows=2, cols=3,
                      filledCells=[[0, 0], [1, 2]],
                      cellLabels={'0,0': '甲'})), [])

    def test_composite_grid_shape_filled_cell_out_of_range_is_reported(self):
        """超出 rows/cols 的格子不會被畫，也不會報錯。"""
        msgs = vqp.check_figure_params(
            self._fig('composite_grid_shape', rows=2, cols=2,
                      filledCells=[[0, 0], [2, 0]]))
        self.assertEqual(len(msgs), 1)
        self.assertIn('[2, 0]', msgs[0])

    def test_composite_grid_shape_malformed_cell_is_reported(self):
        msgs = vqp.check_figure_params(
            self._fig('composite_grid_shape', rows=2, cols=2, filledCells=[[1]]))
        self.assertEqual(len(msgs), 1)

    def test_composite_grid_shape_cell_label_key_out_of_range_is_reported(self):
        msgs = vqp.check_figure_params(
            self._fig('composite_grid_shape', rows=2, cols=2,
                      filledCells=[[0, 0]], cellLabels={'5,5': '甲'}))
        self.assertEqual(len(msgs), 1)
        self.assertIn('5,5', msgs[0])

    def test_composite_grid_shape_rows_must_be_positive(self):
        msgs = vqp.check_figure_params(
            self._fig('composite_grid_shape', rows=0, cols=2, filledCells=[]))
        self.assertTrue(msgs)


class CircleQuadrantsParamsTest(unittest.TestCase):
    """circle_quadrants_point 的 shadedRegion / regionLabels 只認得四個象限名。

    renderer 現在四個區域都上得了色，但填錯字仍然是靜默不上色，驗證器要擋。
    """

    def _fig(self, **params):
        return {'type': 'custom', 'kind': 'circle_quadrants_point', 'params': params}

    def test_accepts_the_four_quadrants(self):
        for region in ('topLeft', 'topRight', 'bottomLeft', 'bottomRight'):
            self.assertEqual(
                vqp.check_figure_params(self._fig(shadedRegion=region)), [],
                region)

    def test_rejects_an_unknown_shaded_region(self):
        msgs = vqp.check_figure_params(self._fig(shadedRegion='middle'))
        self.assertEqual(len(msgs), 1)
        self.assertIn('middle', msgs[0])

    def test_rejects_an_unknown_region_label_key(self):
        msgs = vqp.check_figure_params(
            self._fig(shadedRegion='topRight',
                      regionLabels={'topRight': '?', 'centre': '5'}))
        self.assertEqual(len(msgs), 1)
        self.assertIn('centre', msgs[0])


class CheckFigureLeaksTest(unittest.TestCase):
    """圖不得把答案畫出來。

    驗證器本來只擋一種情形（問「在起點的哪個方向」卻把終點標在圖上）。
    2026-09-04 掃全部 coordinate_plane 題時發現同一族還有兩題：
    問「求點 C 的坐標」，圖上就把 C 畫在答案的位置還標紅；
    問「A 平移後到了哪一點」，圖上就把 A' 畫在答案的位置。
    """

    def _q(self, prompt, answer, points, **params):
        params.setdefault('maxX', 10)
        params.setdefault('maxY', 10)
        params['points'] = points
        return {
            'prompt': {'zh-Hant': prompt},
            'answer': {'zh-Hant': answer},
            'figure': {'type': 'custom', 'kind': 'coordinate_plane', 'params': params},
        }

    def test_clean_question_reports_nothing(self):
        q = self._q('點 A 在 (2,3)，向右移 4 格後到了哪一點？', '答案是 (6,3)。',
                    [{'x': 2, 'y': 3, 'label': 'A'}])
        self.assertEqual(vqp.check_figure_leaks(q), [])

    def test_point_plotted_at_the_answer_coordinate_is_reported(self):
        q = self._q('點 A 在 (2,3)。向右移 4 格、向上移 1 格後，A 到了哪一點？',
                    '答案是 (6,4)。',
                    [{'x': 2, 'y': 3, 'label': 'A'}, {'x': 6, 'y': 4, 'label': "A'"}])
        msgs = vqp.check_figure_leaks(q)
        self.assertEqual(len(msgs), 1)
        self.assertIn('(6, 4)', msgs[0])

    def test_matches_the_answer_even_with_a_space_after_the_comma(self):
        q = self._q('求點 C 的坐標。', '答案是 (6, 9) 或 (6, -9)。',
                    [{'x': 6, 'y': 9, 'label': 'C'}])
        self.assertEqual(len(vqp.check_figure_leaks(q)), 1)

    def test_matches_the_answer_written_with_a_unicode_minus(self):
        q = self._q('求點 C 的坐標。', '答案是 (6, \u22129)。',
                    [{'x': 6, 'y': -9, 'label': 'C'}], minY=-10)
        self.assertEqual(len(vqp.check_figure_leaks(q)), 1)

    def test_a_point_given_in_the_prompt_is_not_a_leak(self):
        """題目自己給的點當然可以畫，即使答案又把它抄一遍。"""
        q = self._q('點 A 在 (2,3)，它在第幾象限？答案請寫出該點座標所在的象限。',
                    '答案是第一象限，因為 (2,3) 的兩個座標都是正的。',
                    [{'x': 2, 'y': 3, 'label': 'A'}])
        self.assertEqual(vqp.check_figure_leaks(q), [])

    def test_still_catches_the_original_endpoint_direction_leak(self):
        q = {
            'prompt': {'zh-Hant': '小明從起點出發，終點在起點的哪個方向？'},
            'answer': {'zh-Hant': '答案是東北方。'},
            'figure': {'type': 'custom', 'kind': 'coordinate_plane', 'params': {
                'maxX': 6, 'maxY': 6,
                'points': [{'x': 1, 'y': 1, 'label': '起點'},
                           {'x': 4, 'y': 4, 'label': '終點'}]}},
        }
        msgs = vqp.check_figure_leaks(q)
        self.assertEqual(len(msgs), 1)
        self.assertIn('終點', msgs[0])

    def test_non_coordinate_figures_are_ignored(self):
        q = {'prompt': {'zh-Hant': '求面積。'}, 'answer': {'zh-Hant': '答案是 (6, 4)。'},
             'figure': {'type': 'custom', 'kind': 'none', 'params': {}}}
        self.assertEqual(vqp.check_figure_leaks(q), [])


class FigureLeaksOnRealPacksTest(unittest.TestCase):
    """整合測試：真實題庫沒有任何一張圖把答案畫出來。"""

    def test_no_real_figure_gives_the_answer_away(self):
        import glob
        offenders = []
        for path in sorted(glob.glob('assets/questions/*/*.json')):
            with open(path) as fh:
                pack = json.load(fh)
            for q in pack['questions']:
                offenders.extend('%s: %s' % (q['id'], e)
                                 for e in vqp.check_figure_leaks(q))
        self.assertEqual(offenders, [], '\n'.join(offenders))


class FigureParamsOnRealPacksTest(unittest.TestCase):
    """整合測試：真實題庫每一張圖的 params 都要符合 renderer 讀得懂的形狀。"""

    def test_every_real_figure_has_valid_params(self):
        import glob
        offenders = []
        for path in sorted(glob.glob('assets/questions/*/*.json')):
            with open(path) as fh:
                pack = json.load(fh)
            for q in pack['questions']:
                offenders.extend('%s: %s' % (q['id'], e)
                                 for e in vqp.check_figure_params(q.get('figure') or {}))
        self.assertEqual(offenders, [], '\n'.join(offenders))


class ValidatorKindsMatchRendererTest(unittest.TestCase):
    """驗證器的 KINDS 白名單不可以放行 renderer 畫不出來的 kind。

    兩份清單分屬 Python 與 Dart，沒有共用的真實來源，只能靠測試防漂移。
    反方向（renderer 有、白名單沒有）是允許的：trig_plane 就是那樣，
    它畫的是寫死的 sin / cos 曲線，只給內建展示畫面用。
    """

    def _renderer_kinds(self):
        with open('lib/src/question_figures.dart') as fh:
            src = fh.read()
        start = src.index('FigureRenderSpec? buildFigureRenderSpec(')
        body = src[start:src.index('class _FigurePreviewDialog', start)]
        import re as _re
        return set(_re.findall(r"^\s*'([a-z_]+)' =>", body, _re.M))

    def test_every_whitelisted_kind_has_a_renderer_branch(self):
        missing = vqp.KINDS - {'none'} - self._renderer_kinds()
        self.assertEqual(missing, set(),
                         'renderer 沒有這些 kind 的分支，題目會一片空白: %s' % missing)


class ValidatorOnRealPacksTest(unittest.TestCase):
    """整合測試：驗證器對真實的 50 個題庫檔要全綠。"""

    def test_real_packs_pass_validation(self):
        r = subprocess.run([sys.executable, 'scripts/validate_question_packs.py'],
                           capture_output=True, text=True, cwd=ROOT)
        self.assertEqual(r.returncode, 0, r.stdout + r.stderr)
        self.assertIn('全部通過', r.stdout)


if __name__ == '__main__':
    unittest.main()


class CaretPowerTest(unittest.TestCase):
    """validate_question_packs：數字冪次不可以寫成 `3^15` 這種程式語法。

    規範（docs/AGENT_PROMPT_question_bank.md「數學排版規則」）明文禁止
    `3^15`，但一直沒有閘門，全庫掃出 7 題共 49 處。

    **只擋純數字指數。** 變數指數（`2^a`、`p₁^e₁`、`a^(p−1)`）不擋：
    Unicode 有 ᵃ ᵏ ˣ 這類上標字母，但字型覆蓋極差，換過去反而更可能變空方塊；
    而 `2^(p−1)` 需要上標括號與上標減號，寫出來沒人讀得懂。
    數字上標 ⁰¹²³⁴⁵⁶⁷⁸⁹ 則是全庫本來就在用、字型覆蓋良好的寫法。
    """

    def _q(self, **fields):
        q = {'prompt': {'zh-Hant': '答案是多少？', 'zh-Hans': '答案是多少？',
                        'en': 'What is it?', 'ja': '答えは？'}}
        q.update(fields)
        return q

    def test_clean_question_reports_nothing(self):
        self.assertEqual(vqp.check_caret_power(self._q()), [])

    def test_numeric_exponent_in_prompt_is_reported(self):
        q = self._q(prompt={'zh-Hant': '求 3^15 的個位數。', 'zh-Hans': '求 3^15 的个位数。',
                            'en': 'Find the units digit of 3^15.', 'ja': '3^15 の一の位は？'})
        msgs = vqp.check_caret_power(q)
        self.assertEqual(len(msgs), 1)
        self.assertIn('prompt', msgs[0])
        self.assertIn('3^15', msgs[0])

    def test_numeric_exponent_in_solution_steps_is_reported(self):
        q = self._q(solutionSteps={'zh-Hant': ['先算 2^10 = 1024。'],
                                   'zh-Hans': ['先算 2^10 = 1024。'],
                                   'en': ['First 2^10 = 1024.'], 'ja': ['まず 2^10 = 1024。']})
        msgs = vqp.check_caret_power(q)
        self.assertEqual(len(msgs), 1)
        self.assertIn('solutionSteps', msgs[0])

    def test_numeric_exponent_in_options_is_reported(self):
        q = self._q(options={'A': {'zh-Hant': '2^5', 'zh-Hans': '2^5',
                                   'en': '2^5', 'ja': '2^5'}})
        self.assertEqual(len(vqp.check_caret_power(q)), 1)

    def test_variable_exponent_is_allowed(self):
        """`2^a` 沒有安全的上標寫法，不擋。"""
        q = self._q(solutionSteps={'zh-Hant': ['設 n = 2^a × 3^b。'],
                                   'zh-Hans': ['设 n = 2^a × 3^b。'],
                                   'en': ['Let n = 2^a × 3^b.'], 'ja': ['n = 2^a × 3^b とする。']})
        self.assertEqual(vqp.check_caret_power(q), [])

    def test_parenthesised_exponent_is_allowed(self):
        q = self._q(solutionSteps={'zh-Hant': ['由費馬小定理 a^(p−1) ≡ 1。'],
                                   'zh-Hans': ['由费马小定理 a^(p−1) ≡ 1。'],
                                   'en': ['By Fermat, a^(p−1) ≡ 1.'], 'ja': ['a^(p−1) ≡ 1。']})
        self.assertEqual(vqp.check_caret_power(q), [])

    def test_superscript_form_is_accepted(self):
        """已經寫成 3¹⁵ 的就是合格寫法。"""
        q = self._q(prompt={'zh-Hant': '求 3¹⁵ 的個位數。', 'zh-Hans': '求 3¹⁵ 的个位数。',
                            'en': 'Units digit of 3¹⁵.', 'ja': '3¹⁵ の一の位は？'})
        self.assertEqual(vqp.check_caret_power(q), [])


class CaretPowerOnRealPacksTest(unittest.TestCase):
    """整合測試：真實題庫不可有純數字的 `^` 冪次寫法。"""

    def test_no_real_question_uses_caret_numeric_power(self):
        import glob
        offenders = []
        for path in sorted(glob.glob('assets/questions/*/*.json')):
            with open(path) as fh:
                pack = json.load(fh)
            for q in pack['questions']:
                for msg in vqp.check_caret_power(q):
                    offenders.append('%s: %s' % (q['id'], msg))
        self.assertEqual(offenders, [], '\n'.join(offenders[:20]))


class TrailingZeroDecimalTest(unittest.TestCase):
    """validate_question_packs：小數不可以補一串沒有意義的尾零。

    2026-09-04 真機目視時發現的一族：詳解的驗算步驟寫著
    「∠BAE = 35.00°」「最小值恰為 12.000000」「f(0.3) + f(0.7) = 1.0000000000」，
    看起來像是把程式的浮點輸出直接貼上去。數學沒錯，只是讀起來像 debug 訊息。

    判準是**小數部分結尾有 ≥2 個零**。這條剛好放行真正的近似值
    （`6.7082`、`4.429`、`3.818182`）與真正的步長（`0.0001`）——
    它們的小數部分都不是以零結尾。
    """

    def _q(self, **fields):
        q = {'prompt': {'zh-Hant': '答案是多少？', 'zh-Hans': '答案是多少？',
                        'en': 'What is it?', 'ja': '答えは？'}}
        q.update(fields)
        return q

    def test_clean_question_reports_nothing(self):
        self.assertEqual(vqp.check_trailing_zero_decimal(self._q()), [])

    def test_padded_angle_is_reported(self):
        q = self._q(solutionSteps={'zh-Hant': ['實測 ∠BAE = 35.00°。'],
                                   'zh-Hans': ['实测 ∠BAE = 35.00°。'],
                                   'en': ['Measured angle BAE = 35.00.'],
                                   'ja': ['実測 ∠BAE = 35.00°。']})
        msgs = vqp.check_trailing_zero_decimal(q)
        self.assertEqual(len(msgs), 1)
        self.assertIn('solutionSteps', msgs[0])
        self.assertIn('35.00', msgs[0])

    def test_long_float_tail_is_reported(self):
        q = self._q(answer={'zh-Hant': '答案是 1.0000000000。', 'zh-Hans': '答案是 1.0000000000。',
                            'en': 'The answer is 1.0000000000.', 'ja': '答えは 1.0000000000 です。'})
        self.assertEqual(len(vqp.check_trailing_zero_decimal(q)), 1)

    def test_genuine_approximation_is_allowed(self):
        """`6.7082`、`4.429` 是真的近似值，不可誤報。"""
        q = self._q(solutionSteps={'zh-Hant': ['算出 A ≈ (4.429, 6.7082)。'],
                                   'zh-Hans': ['算出 A ≈ (4.429, 6.7082)。'],
                                   'en': ['A is about (4.429, 6.7082).'],
                                   'ja': ['A ≈ (4.429, 6.7082)。']})
        self.assertEqual(vqp.check_trailing_zero_decimal(q), [])

    def test_step_size_is_allowed(self):
        """`0.0001` 是掃描步長，小數部分不以零結尾。"""
        q = self._q(solutionSteps={'zh-Hant': ['以 0.0001 為步長掃描。'],
                                   'zh-Hans': ['以 0.0001 为步长扫描。'],
                                   'en': ['Scan in steps of 0.0001.'],
                                   'ja': ['0.0001 刻みで調べる。']})
        self.assertEqual(vqp.check_trailing_zero_decimal(q), [])

    def test_single_trailing_zero_is_allowed(self):
        """`12.50` 只有一個尾零，屬正常的兩位小數，不擋。"""
        q = self._q(answer={'zh-Hant': '共 12.50 公斤。', 'zh-Hans': '共 12.50 公斤。',
                            'en': '12.50 kg in total.', 'ja': '合計 12.50 kg。'})
        self.assertEqual(vqp.check_trailing_zero_decimal(q), [])

    def test_integers_are_untouched(self):
        q = self._q(answer={'zh-Hant': '答案是 100。', 'zh-Hans': '答案是 100。',
                            'en': 'The answer is 100.', 'ja': '答えは 100 です。'})
        self.assertEqual(vqp.check_trailing_zero_decimal(q), [])


class TrailingZeroDecimalOnRealPacksTest(unittest.TestCase):
    """整合測試：真實題庫不可有補零的小數。"""

    def test_no_real_question_has_padded_decimal(self):
        import glob
        offenders = []
        for path in sorted(glob.glob('assets/questions/*/*.json')):
            with open(path) as fh:
                pack = json.load(fh)
            for q in pack['questions']:
                for msg in vqp.check_trailing_zero_decimal(q):
                    offenders.append('%s: %s' % (q['id'], msg))
        self.assertEqual(offenders, [], '\n'.join(offenders[:20]))


import build_question_preview as bqp


class PreviewNewestFirstTest(unittest.TestCase):
    """build_question_preview：依題目第一次出現在 git 的時間，新題排最前面。"""

    LOG = '\n'.join([
        '__C 100',
        '+      "id": "logic_grade1_foundation_001",',
        '__C 200',
        '+      "id": "logic_grade1_foundation_001",',
        '+      "id": "logic_grade1_foundation_002",',
        '-      "id": "logic_grade1_foundation_003",',
    ])

    def test_parse_keeps_earliest_time_for_reappearing_id(self):
        added = bqp.parse_first_added(self.LOG)
        self.assertEqual(added['logic_grade1_foundation_001'], 100)
        self.assertEqual(added['logic_grade1_foundation_002'], 200)

    def test_parse_ignores_removed_lines(self):
        self.assertNotIn('logic_grade1_foundation_003', bqp.parse_first_added(self.LOG))

    def test_real_bank_lists_newest_questions_first(self):
        rows = bqp.load()
        self.assertEqual(rows[0]['ad'], max(r['ad'] for r in rows))
        order = [r['id'] for r in rows]
        # logic_grade7_foundation_072 是第十輪才補的圖形題，001 是最早的題
        self.assertLess(order.index('logic_grade7_foundation_072'),
                        order.index('logic_grade7_foundation_001'))


class CheckProgramMentionsTest(unittest.TestCase):
    """validate_question_packs.check_program_mentions：詳解不得出現「用程式驗算」。

    學生看不到也跑不了程式，這類句子是起草時留下的驗算紀錄（2026-10-24 清掉 354 題）。
    """

    def _q(self, zh='先列出所有情形，共 8 種。', en='List every case: 8 in all.'):
        return {'solutionSteps': {'zh-Hant': [zh], 'zh-Hans': [zh], 'en': [en], 'ja': ['全部で 8 通り。']}}

    def test_accepts_plain_solution(self):
        self.assertEqual(vqp.check_program_mentions(self._q()), [])

    def test_equation_word_is_not_a_program(self):
        self.assertEqual(vqp.check_program_mentions(self._q(zh='列出方程式 2x + 1 = 9，得 x = 4。')), [])

    def test_rejects_chinese_program_check(self):
        msgs = vqp.check_program_mentions(self._q(zh='用程式窮舉也得到 8 種 ✓。'))
        self.assertTrue(any('zh-Hant' in m for m in msgs))
        self.assertTrue(any('zh-Hans' in m for m in msgs))

    def test_rejects_english_computer_check(self):
        self.assertTrue(vqp.check_program_mentions(self._q(en='A computer search also gives 8.')))

    def test_whole_bank_is_clean(self):
        import glob
        for path in glob.glob('assets/questions/*/*.json'):
            for q in json.load(open(path))['questions']:
                self.assertEqual(vqp.check_program_mentions(q), [], q['id'])
