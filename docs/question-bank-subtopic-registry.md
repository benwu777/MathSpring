# MathSpring Canonical Subtopic Registry

這份文件是 phase-1 正式的 `subtopic` 規範：規定目前允許的 subtopic、
與四類主題的對應、以及新增規則。與 `question-bank-taxonomy.md`（概念層）
和 `question-bank-expansion-guidelines.md`（操作規範）搭配使用。

快照基準日：2026-07-24（依當時題庫實際狀態抽出）。

## 主題對應（四類）

每個 `subtopic` 只屬於一個 shipped `topicCode`：`arithmetic` / `geometry` / `logic` / `mixed`。
六大數學技能家族（算術／數論／代數／幾何／組合／邏輯）是分類層，映射到這四類，
不另設 topic 或資料夾（詳見 taxonomy）。

## 命名規則（BLOCKING）

- 一律小寫 snake_case 英文，語意描述題型（如 `work_backwards`、`pigeonhole`）。
- 同義寫法必須統一，不可並存（例如 `shapes_properties` 與 `shape_properties` 只能留一個）。
- 單複數、`-ing`／名詞化等表面差異視為同一 subtopic，取既有的。
- 新增 subtopic 前，必須先確認下方清單沒有語意等價的既有項；有就沿用。

## 何時可新增 subtopic

同時滿足才可新增：

1. 該題型的推理核心與所有既有 subtopic 都不同（非換數字弱變形）。
2. 找不到語意等價的既有 subtopic 可沿用。
3. 預期會有多題使用，而非只為單題臨時發明。
4. 命名符合上方規則，並同步加進本檔對應主題清單。

## 目前允許的 subtopic（依主題）

以下為快照。要重新產生目前實際集合，於 repo 根目錄執行：

```bash
python3 - <<'EOF'
import json, glob; from collections import defaultdict
s=defaultdict(set)
for f in glob.glob('assets/questions/*/*.json'):
    t=f.split('/')[2]
    for q in json.load(open(f))['questions']: s[t].add(q['subtopic'])
for t in ['arithmetic','geometry','logic','mixed']: print(t, sorted(s[t]))
EOF
```

### arithmetic（含數論、代數的算術型） — 82 種

- `age_problem`（3 題）
- `arrangements`（4 題）
- `arrangements_count`（2 題）
- `average_difference`（1 題）
- `averages_system`（1 題）
- `balance`（2 題）
- `balance_transfer`（7 題）
- `calendar_counting`（4 題）
- `coin_systems`（1 題）
- `comparison`（2 題）
- `comparison_system`（1 題）
- `congruences`（2 題）
- `consecutive`（1 題）
- `consecutive_numbers`（2 題）
- `consecutive_odds`（1 題）
- `counting_groups`（3 題）
- `decomposition`（1 題）
- `difference`（1 題）
- `digit_arrangement`（5 題）
- `digit_arrangement_sum`（2 題）
- `digit_counting`（3 題）
- `digit_process`（2 題）
- `digit_reasoning`（1 題）
- `digit_string`（1 題）
- `digit_sum`（1 題）
- `divisibility`（4 題）
- `division_remainder`（2 題）
- `divisor_sum`（1 題）
- `double`（1 題）
- `elimination_count`（1 題）
- `equal_groups`（4 題）
- `equivalent_fractions`（1 題）
- `exchange_chain`（5 題）
- `factors_and_rectangles`（4 題）
- `factors_counting`（4 題）
- `four_operations`（3 題）
- `fraction_addition`（1 題）
- `fractions`（1 題）
- `gcd_lcm`（2 題）
- `grouping`（4 題）
- `handshake_counting`（1 題）
- `hidden_card`（1 題）
- `inclusion_exclusion`（6 題）
- `lcm_schedule`（3 題）
- `maximization`（1 題）
- `minimization`（1 題）
- `missing_addend`（1 題）
- `missing_card`（1 題）
- `multi_step`（2 題）
- `multi_step_subtraction`（1 題）
- `multiples_counting`（3 題）
- `multiples_filtering`（2 題）
- `number_line`（5 題）
- `number_patterns`（1 題）
- `overlap_counting`（4 題）
- `page_numbering`（4 題）
- `pair_counting`（5 題）
- `pair_sum`（3 題）
- `pairing`（1 題）
- `pairing_counting`（1 題）
- `pairing_remainder`（1 題）
- `parity_counting`（2 題）
- `pattern`（8 題）
- `pattern_sum`（1 題）
- `piece_value`（3 題）
- `quotient_and_remainder`（1 題）
- `ratio`（4 題）
- `ratio_transfer`（1 題）
- `remainders`（9 題）
- `route_counting`（5 題）
- `scoring`（1 題）
- `sequence`（3 題）
- `sequence_sum`（1 題）
- `sharing`（2 題）
- `square_sum`（1 題）
- `staircase_counting`（3 題）
- `subtraction`（1 題）
- `successive_changes`（1 題）
- `sum_difference`（3 題）
- `sum_ratio_equalize`（1 題）
- `two_step`（2 題）
- `work_backwards`（6 題）

### geometry — 37 種

- `angle_chase`（1 題）
- `angle_ratio`（2 題）
- `angle_sum_polygon`（2 題）
- `angles`（1 題）
- `area_counting`（7 題）
- `border_counting`（4 題）
- `circle_region_balance`（1 題）
- `circle_square_area`（2 題）
- `composite_area`（3 題）
- `composite_perimeter`（5 題）
- `coordinate_distance`（2 題）
- `coordinate_geometry`（4 題）
- `coordinate_midpoint_style`（2 題）
- `coordinate_rectangle`（2 題）
- `half_turn`（1 題）
- `isosceles`（2 題）
- `lines_angles`（3 題）
- `overlap_area`（2 題）
- `parallel_lines`（2 題）
- `perimeter_area`（21 題）
- `perimeter_change`（2 題）
- `perimeter_invariance`（4 題）
- `position_direction`（5 題）
- `reflection`（3 題）
- `reflection_x_axis`（2 題）
- `rotation`（3 題）
- `scale_factor`（2 題）
- `shape_composition`（6 題）
- `shape_cutting`（9 題）
- `shapes_properties`（17 題）
- `square_triangle`（1 題）
- `symmetry`（6 題）
- `translation`（1 題）
- `trapezoid_area`（2 題）
- `triangle_angles`（4 題）
- `triangle_area`（5 題）
- `triangle_comparison`（1 題）

### logic — 52 種

- `arrangement`（2 題）
- `case_reasoning`（4 題）
- `column_row`（1 題）
- `comparison`（2 題）
- `counterexample_reasoning`（1 題）
- `counting_choices`（1 題）
- `deduction_chain`（2 題）
- `direction`（1 題）
- `elimination`（13 題）
- `filtering`（1 題）
- `grid_elimination`（2 題）
- `grouping_balance`（1 題）
- `left_right`（1 題）
- `matching`（9 題）
- `middle_position`（1 題）
- `middle_rank`（1 題）
- `minimal_case`（5 題）
- `minimal_number`（1 題）
- `mislabeled_boxes`（1 題）
- `multi_condition_arrangement`（1 題）
- `neighbor_constraint`（1 題）
- `one_true_one_false`（1 題）
- `ordering`（21 題）
- `paired_conditions`（1 題）
- `paired_positions`（1 題）
- `pairing`（1 題）
- `pairwise_sums`（1 題）
- `parity_reasoning`（1 題）
- `partial_order`（1 題）
- `path_counting`（1 題）
- `pattern`（3 題）
- `pigeonhole`（10 題）
- `position`（14 題）
- `possible_impossible`（1 題）
- `queue_order`（1 題）
- `ranking`（2 題）
- `ratio_inference`（1 題）
- `schedule_constraints`（2 題）
- `schedule_grid`（1 題）
- `scheduling`（1 題）
- `seating`（2 題）
- `selection`（1 題）
- `set_filtering`（1 題）
- `set_intersection`（1 題）
- `sieve_elimination`（1 題）
- `state_tracking`（6 題）
- `truth_and_lie`（1 題）
- `truth_deduction`（3 題）
- `truth_network`（1 題）
- `two_condition_filter`（1 題）
- `two_step_elimination`（1 題）
- `venn_diagram`（1 題）

### mixed（跨家族競賽題） — 25 種

- `average_reasoning`（1 題）
- `balance_relations`（1 題）
- `balance_substitution`（1 題）
- `calendar_cycle_reasoning`（1 題）
- `coin_combinations`（1 題）
- `consecutive_integer_sum`（1 題）
- `counting_squares`（1 題）
- `digit_arrangement`（1 題）
- `digit_reversal_difference`（1 題）
- `digit_sequence`（1 題）
- `double_sided_cards`（1 題）
- `elimination_matching`（1 題）
- `fractions_capacity`（1 題）
- `grid_paths`（1 題）
- `handshake_counting`（1 題）
- `ordering`（1 題）
- `overlap_area`（1 題）
- `paper_folding`（1 題）
- `perimeter_area`（1 題）
- `perimeter_invariance`（1 題）
- `remainders`（1 題）
- `sequential_pattern_climbing`（1 題）
- `symmetry_counting`（1 題）
- `trial_and_improve_age`（1 題）
- `truth_statements`（1 題）

## 已知待整併（技術債）

目前 subtopic 數量偏多（多次擴充與多模型生成累積），部分仍是語意相近的近義項或
單題一次性標籤。後續補題時應優先沿用既有項、逐步收斂，不要再擴大同義 subtopic 的分裂。
