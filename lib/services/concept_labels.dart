import 'package:flutter/widgets.dart';

/// 概念標籤（`c:`）的顯示名稱。繁中與 docs/question-bank-tags.json 的 zh 相同。
const Map<String, (String, String, String, String)> _conceptLabels =
    <String, (String, String, String, String)>{
  // 標籤: (zh-Hant, zh-Hans, en, ja)
  'c:fraction': ('分數', '分数', 'Fractions', '分数'),
  'c:decimal': ('小數', '小数', 'Decimals', '小数'),
  'c:percent': ('百分比', '百分比', 'Percentages', '百分率'),
  'c:ratio': ('比與比例', '比与比例', 'Ratios and proportions', '比と比例'),
  'c:mean': ('平均數', '平均数', 'Averages', '平均'),
  'c:median_mode': (
    '中位數眾數全距',
    '中位数众数极差',
    'Median, mode and range',
    '中央値・最頻値・範囲'
  ),
  'c:stdev': ('標準差', '标准差', 'Standard deviation', '標準偏差'),
  'c:factor_multiple': ('因數與倍數', '因数与倍数', 'Factors and multiples', '約数と倍数'),
  'c:modular': ('餘數與同餘', '余数与同余', 'Remainders and congruence', '余りと合同式'),
  'c:place_value': ('位值與數字', '数位与数字', 'Place value and digits', '位取りと数字'),
  'c:sequence': ('數列', '数列', 'Sequences', '数列'),
  'c:recurrence': ('遞迴關係', '递推关系', 'Recurrence relations', '漸化式'),
  'c:linear_eq': ('一次方程與應用', '一次方程与应用', 'Linear equations', '一次方程式'),
  'c:quadratic': ('二次式與二次方程', '二次式与二次方程', 'Quadratics', '二次式と二次方程式'),
  'c:inequality': ('不等式', '不等式', 'Inequalities', '不等式'),
  'c:function': ('函數', '函数', 'Functions', '関数'),
  'c:exponent': ('指數', '指数', 'Exponents', '指数'),
  'c:logarithm': ('對數', '对数', 'Logarithms', '対数'),
  'c:polynomial': ('多項式', '多项式', 'Polynomials', '多項式'),
  'c:complex': ('複數', '复数', 'Complex numbers', '複素数'),
  'c:vector': ('向量', '向量', 'Vectors', 'ベクトル'),
  'c:matrix': ('矩陣', '矩阵', 'Matrices', '行列'),
  'c:calculus': ('微積分', '微积分', 'Calculus', '微積分'),
  'c:coordinate': ('座標', '坐标', 'Coordinates', '座標'),
  'c:line_slope': ('直線與斜率', '直线与斜率', 'Lines and slope', '直線と傾き'),
  'c:perimeter': ('周長', '周长', 'Perimeter', '周の長さ'),
  'c:area': ('面積', '面积', 'Area', '面積'),
  'c:volume': ('體積', '体积', 'Volume', '体積'),
  'c:surface_area': ('表面積', '表面积', 'Surface area', '表面積'),
  'c:angle': ('角度', '角度', 'Angles', '角度'),
  'c:triangle': ('三角形', '三角形', 'Triangles', '三角形'),
  'c:quadrilateral': ('四邊形', '四边形', 'Quadrilaterals', '四角形'),
  'c:polygon': ('多邊形', '多边形', 'Polygons', '多角形'),
  'c:circle': ('圓與扇形', '圆与扇形', 'Circles and sectors', '円とおうぎ形'),
  'c:solid': ('立體圖形', '立体图形', '3D shapes', '立体図形'),
  'c:similar': ('相似', '相似', 'Similarity', '相似'),
  'c:congruent': ('全等', '全等', 'Congruence', '合同'),
  'c:symmetry': ('對稱與旋轉', '对称与旋转', 'Symmetry and rotation', '対称と回転'),
  'c:pythagoras': ('畢氏定理', '勾股定理', 'Pythagorean theorem', '三平方の定理'),
  'c:trigonometry': ('三角比', '三角比', 'Trigonometry', '三角比'),
  'c:probability': ('機率', '概率', 'Probability', '確率'),
  'c:expectation': ('期望值', '期望值', 'Expected value', '期待値'),
  'c:inclusion_exclusion': ('排容原理', '容斥原理', 'Inclusion–exclusion', '包除原理'),
  'c:graph_theory': ('圖論', '图论', 'Graph theory', 'グラフ理論'),
  'c:game_theory': (
    '博弈與必勝策略',
    '博弈与必胜策略',
    'Games and winning strategies',
    'ゲームと必勝法'
  ),
  'c:permutation_combination': (
    '排列組合',
    '排列组合',
    'Permutations and combinations',
    '順列と組合せ'
  ),
  'c:basic_counting': ('基礎計數', '基础计数', 'Basic counting', '基本の数え上げ'),
  'c:add_sub': ('加減與和差', '加减与和差', 'Addition and subtraction', 'たし算とひき算'),
  'c:mul_div': ('乘除與等分', '乘除与等分', 'Multiplication and division', 'かけ算とわり算'),
  'c:compare_order': ('比較與排序', '比较与排序', 'Comparing and ordering', '比較と順序'),
  'c:pattern': ('規律與樣式', '规律与模式', 'Patterns', '規則性'),
  'c:position_direction': ('位置與方向', '位置与方向', 'Position and direction', '位置と方向'),
  'c:balance': ('天秤與等量', '天平与等量', 'Balances and equal amounts', 'てんびんと等しい量'),
  'c:logic_deduction': ('邏輯推理', '逻辑推理', 'Logical reasoning', '論理的推理'),
  'c:rate_speed': ('速率與行程', '速度与行程', 'Speed and distance', '速さと道のり'),
  'c:work_rate': ('工作效率', '工作效率', 'Work rates', '仕事算'),
  'c:mixture': ('濃度與混合', '浓度与混合', 'Concentration and mixtures', '濃度と混合'),
  'c:radical': (
    '根號與無理數',
    '根号与无理数',
    'Radicals and irrational numbers',
    '根号と無理数'
  ),
  'c:absolute_value': ('絕對值', '绝对值', 'Absolute value', '絶対値'),
  'c:number_base': ('進位制', '进位制', 'Number bases', '記数法（n進法）'),
  'c:binomial': ('二項式與展開式', '二项式与展开式', 'Binomial expansion', '二項定理と展開'),
  'c:algebraic_identity': (
    '代數恆等式與變形',
    '代数恒等式与变形',
    'Algebraic identities',
    '式の恒等変形'
  ),
};

/// 回傳概念的顯示名稱；不認得的標籤原樣回傳。
String conceptLabel(String concept, Locale locale) {
  final (String, String, String, String)? labels = _conceptLabels[concept];
  if (labels == null) {
    return concept;
  }
  if (locale.languageCode == 'zh') {
    return locale.countryCode == 'CN' ? labels.$2 : labels.$1;
  }
  if (locale.languageCode == 'ja') {
    return labels.$4;
  }
  return labels.$3;
}
