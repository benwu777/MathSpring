import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mathspring/services/monetization_service.dart';
import 'package:mathspring/services/storekit_monetization_service.dart';

void main() {
  test('loads only the declared full unlock product', () async {
    final _FakeStorefrontGateway gateway = _FakeStorefrontGateway();
    final StoreKitMonetizationService service =
        StoreKitMonetizationService(gateway: gateway);

    await service.initialize();

    expect(gateway.requestedProductIds,
        <String>{MonetizationProduct.fullUnlock.id});
    expect(service.value.status, MonetizationStatus.ready);
    expect(service.value.product?.price, r'$1.99');
  });

  test('verified purchase grants entitlement and completes transaction',
      () async {
    final _FakeStorefrontGateway gateway = _FakeStorefrontGateway();
    final StoreKitMonetizationService service =
        StoreKitMonetizationService(gateway: gateway);
    await service.initialize();

    await service.purchaseFullUnlock();
    gateway.publish(const StorePurchaseEvent.purchased(
      productId: 'com.benwu.mathspring.full_unlock',
      transactionId: 'purchase-1',
    ));
    await _settle();

    expect(service.value.hasFullUnlock, isTrue);
    expect(gateway.completedTransactionIds, <String>['purchase-1']);
  });

  test('cancelled purchase returns to ready without granting entitlement',
      () async {
    final _FakeStorefrontGateway gateway = _FakeStorefrontGateway();
    final StoreKitMonetizationService service =
        StoreKitMonetizationService(gateway: gateway);
    await service.initialize();

    await service.purchaseFullUnlock();
    gateway.publish(const StorePurchaseEvent.cancelled());
    await _settle();

    expect(service.value.status, MonetizationStatus.ready);
    expect(service.value.hasFullUnlock, isFalse);
  });

  test('restore grants entitlement for the declared product', () async {
    final _FakeStorefrontGateway gateway = _FakeStorefrontGateway();
    final StoreKitMonetizationService service =
        StoreKitMonetizationService(gateway: gateway);
    await service.initialize();

    await service.restorePurchases();
    gateway.publish(const StorePurchaseEvent.restored(
      productId: 'com.benwu.mathspring.full_unlock',
      transactionId: 'restore-1',
    ));
    await _settle();

    expect(service.value.hasFullUnlock, isTrue);
    expect(gateway.completedTransactionIds, <String>['restore-1']);
  });

  test('re-establishes an existing entitlement at app launch', () async {
    final _FakeStorefrontGateway gateway =
        _FakeStorefrontGateway(restoreOnRequest: true);
    final StoreKitMonetizationService service =
        StoreKitMonetizationService(gateway: gateway);

    await service.initialize();
    await _settle();

    expect(gateway.restoreCalls, 1);
    expect(service.value.hasFullUnlock, isTrue);
    expect(gateway.completedTransactionIds, <String>['launch-restore-1']);
  });

  test('unavailable native storefront is exposed as a safe error state',
      () async {
    final _FakeStorefrontGateway gateway =
        _FakeStorefrontGateway(throwOnAvailability: true);
    final StoreKitMonetizationService service =
        StoreKitMonetizationService(gateway: gateway);

    await service.initialize();

    expect(service.value.status, MonetizationStatus.error);
    expect(service.value.hasFullUnlock, isFalse);
  });
}

Future<void> _settle() => Future<void>.delayed(Duration.zero);

class _FakeStorefrontGateway implements StorefrontGateway {
  _FakeStorefrontGateway({
    this.throwOnAvailability = false,
    this.restoreOnRequest = false,
  });

  final bool throwOnAvailability;
  final bool restoreOnRequest;
  final StreamController<StorePurchaseEvent> _events =
      StreamController<StorePurchaseEvent>.broadcast();
  Set<String>? requestedProductIds;
  final List<String> completedTransactionIds = <String>[];
  int restoreCalls = 0;

  @override
  Stream<StorePurchaseEvent> get purchaseUpdates => _events.stream;

  @override
  Future<bool> isAvailable() async {
    if (throwOnAvailability) throw StateError('No native storefront');
    return true;
  }

  @override
  Future<List<StorefrontProduct>> loadProducts(Set<String> productIds) async {
    requestedProductIds = productIds;
    return const <StorefrontProduct>[
      StorefrontProduct(
        id: 'com.benwu.mathspring.full_unlock',
        title: 'MathSpring Full Unlock',
        price: r'$1.99',
      ),
    ];
  }

  @override
  Future<void> purchase(String productId) async {}

  @override
  Future<void> restore() async {
    restoreCalls += 1;
    if (restoreOnRequest) {
      publish(const StorePurchaseEvent.restored(
        productId: 'com.benwu.mathspring.full_unlock',
        transactionId: 'launch-restore-1',
      ));
    }
  }

  @override
  Future<void> complete(String transactionId) async {
    completedTransactionIds.add(transactionId);
  }

  void publish(StorePurchaseEvent event) => _events.add(event);
}
