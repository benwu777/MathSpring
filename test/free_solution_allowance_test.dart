import 'package:flutter_test/flutter_test.dart';
import 'package:mathspring/services/free_solution_allowance.dart';

void main() {
  final DateTime today = DateTime(2026, 10, 17, 9);

  test('a fresh day offers three free solutions', () {
    final FreeSolutionAllowance allowance =
        FreeSolutionAllowance.decode(null, now: today);

    expect(FreeSolutionAllowance.dailyLimit, 3);
    expect(allowance.remaining, 3);
    expect(allowance.isUnlocked('q1'), isFalse);
  });

  test('unlocking spends one and keeps that question open', () {
    final FreeSolutionAllowance after =
        FreeSolutionAllowance.decode(null, now: today).unlock('q1')!;

    expect(after.remaining, 2);
    expect(after.isUnlocked('q1'), isTrue);
  });

  test('reopening an unlocked question does not spend again', () {
    final FreeSolutionAllowance after =
        FreeSolutionAllowance.decode(null, now: today)
            .unlock('q1')!
            .unlock('q1')!;

    expect(after.remaining, 2);
  });

  test('a fourth question cannot be unlocked on the same day', () {
    final FreeSolutionAllowance used =
        FreeSolutionAllowance.decode(null, now: today)
            .unlock('q1')!
            .unlock('q2')!
            .unlock('q3')!;

    expect(used.remaining, 0);
    expect(used.unlock('q4'), isNull);
    expect(used.unlock('q2'), isNotNull, reason: '已解鎖的題目當天仍可重看');
  });

  test('the allowance survives encoding within the same day', () {
    final FreeSolutionAllowance used =
        FreeSolutionAllowance.decode(null, now: today).unlock('q1')!;

    final FreeSolutionAllowance restored = FreeSolutionAllowance.decode(
      used.encode(),
      now: today.add(const Duration(hours: 10)),
    );

    expect(restored.remaining, 2);
    expect(restored.isUnlocked('q1'), isTrue);
  });

  test('the next local day resets the allowance', () {
    final FreeSolutionAllowance used =
        FreeSolutionAllowance.decode(null, now: today)
            .unlock('q1')!
            .unlock('q2')!
            .unlock('q3')!;

    final FreeSolutionAllowance tomorrow = FreeSolutionAllowance.decode(
      used.encode(),
      now: DateTime(2026, 10, 18, 0, 1),
    );

    expect(tomorrow.remaining, 3);
    expect(tomorrow.isUnlocked('q1'), isFalse);
  });

  test('corrupted stored data falls back to a fresh day', () {
    final FreeSolutionAllowance allowance =
        FreeSolutionAllowance.decode('not json', now: today);

    expect(allowance.remaining, 3);
  });
}
