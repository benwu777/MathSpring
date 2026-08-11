import 'package:flutter_test/flutter_test.dart';
import 'package:mathspring/services/math_text_formatter.dart';

void main() {
  test('normalizes common exponent notation into readable math text', () {
    expect(normalizeMathText('x^2 - 4x + 7'), 'x² - 4x + 7');
    expect(normalizeMathText('(7.2)^x = 3'), '(7.2)ˣ = 3');
    expect(normalizeMathText('3^15 除以 8'), '3¹⁵ 除以 8');
    expect(normalizeMathText('a^2r = 675'), 'a²r = 675');
    expect(normalizeMathText('2^(1+2+3)'), '2⁽¹⁺²⁺³⁾');
    expect(normalizeMathText('x^(log x) = 10^6 x'), 'x⁽ˡᵒᵍˣ⁾ = 10⁶ x');
  });

  test('normalizes basic inequality operators without disturbing unicode math', () {
    expect(normalizeMathText('-1 <= x <= a'), '-1 ≤ x ≤ a');
    expect(normalizeMathText('a >= 5'), 'a ≥ 5');
    expect(normalizeMathText('π/2 < π'), 'π/2 < π');
  });
}
