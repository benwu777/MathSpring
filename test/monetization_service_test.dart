import 'package:flutter_test/flutter_test.dart';
import 'package:mathspring/services/monetization_service.dart';

void main() {
  test('defines the single non-consumable full unlock product', () {
    expect(
        MonetizationProduct.fullUnlock.id, 'com.benwu.mathspring.full_unlock');
    expect(MonetizationProduct.fullUnlock.isNonConsumable, isTrue);
  });

  test('full unlock enables every promised benefit', () {
    const MonetizationState unlocked = MonetizationState.unlocked();

    expect(unlocked.hasFullUnlock, isTrue);
    expect(unlocked.canViewSolutionSteps, isTrue);
    expect(unlocked.canUsePremiumAvatarOptions, isTrue);
    expect(unlocked.maxLearnerProfiles, 5);
  });

  test('unavailable service never claims a purchasable product', () async {
    final NoopMonetizationService service = NoopMonetizationService();

    await service.initialize();

    expect(service.value.status, MonetizationStatus.unavailable);
    expect(service.value.hasFullUnlock, isFalse);
    expect(service.value.maxLearnerProfiles, 1);
    expect(service.value.product, isNull);
  });

  test('in-memory purchase and restore publish full unlock entitlement',
      () async {
    final InMemoryMonetizationService service =
        InMemoryMonetizationService.withProduct();

    await service.initialize();
    expect(service.value.status, MonetizationStatus.ready);
    expect(service.value.hasFullUnlock, isFalse);

    await service.purchaseFullUnlock();
    expect(service.value.hasFullUnlock, isTrue);

    await service.resetForTest();
    expect(service.value.hasFullUnlock, isFalse);

    await service.restorePurchases();
    expect(service.value.hasFullUnlock, isTrue);
  });
}
