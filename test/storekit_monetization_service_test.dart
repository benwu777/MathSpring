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

  test('keeps an existing entitlement when products cannot load offline',
      () async {
    final _FakeStorefrontGateway gateway = _FakeStorefrontGateway(
      restoreOnRequest: true,
      throwOnLoadProducts: true,
    );
    final StoreKitMonetizationService service =
        StoreKitMonetizationService(gateway: gateway);

    await service.initialize();
    await _settle();

    expect(gateway.restoreCalls, 1);
    expect(service.value.hasFullUnlock, isTrue);
  });

  test('keeps an existing entitlement when the product is not listed',
      () async {
    final _FakeStorefrontGateway gateway = _FakeStorefrontGateway(
      restoreOnRequest: true,
      returnNoProducts: true,
    );
    final StoreKitMonetizationService service =
        StoreKitMonetizationService(gateway: gateway);

    await service.initialize();
    await _settle();

    expect(gateway.restoreCalls, 1);
    expect(service.value.hasFullUnlock, isTrue);
  });

  test('restore still runs when the product could not be loaded', () async {
    final _FakeStorefrontGateway gateway =
        _FakeStorefrontGateway(returnNoProducts: true);
    final StoreKitMonetizationService service =
        StoreKitMonetizationService(gateway: gateway);
    await service.initialize();
    gateway.restoreOnRequest = true;

    await service.restorePurchases();
    await _settle();

    expect(gateway.restoreCalls, 2);
    expect(service.value.hasFullUnlock, isTrue);
  });

  test('restore without a previous purchase reports nothing to restore',
      () async {
    final _FakeStorefrontGateway gateway = _FakeStorefrontGateway();
    final StoreKitMonetizationService service =
        StoreKitMonetizationService(gateway: gateway);
    await service.initialize();

    await service.restorePurchases();

    expect(service.value.status, MonetizationStatus.ready);
    expect(service.value.hasFullUnlock, isFalse);
    expect(service.value.restoreFoundNothing, isTrue);
  });

  test('restore that finds the purchase does not report nothing to restore',
      () async {
    final _FakeStorefrontGateway gateway = _FakeStorefrontGateway();
    final StoreKitMonetizationService service =
        StoreKitMonetizationService(gateway: gateway);
    await service.initialize();
    gateway.restoreOnRequest = true;

    await service.restorePurchases();

    expect(service.value.hasFullUnlock, isTrue);
    expect(service.value.restoreFoundNothing, isFalse);
  });

  test('starting a purchase clears a previous nothing-to-restore notice',
      () async {
    final _FakeStorefrontGateway gateway = _FakeStorefrontGateway();
    final StoreKitMonetizationService service =
        StoreKitMonetizationService(gateway: gateway);
    await service.initialize();
    await service.restorePurchases();

    await service.purchaseFullUnlock();

    expect(service.value.restoreFoundNothing, isFalse);
  });
}

Future<void> _settle() => Future<void>.delayed(Duration.zero);

// StoreKit 只能在實機或模擬器的原生層執行，flutter test 叫不到，
// 所以只替換最外層的 StorefrontGateway；狀態機本身走真的實作。
class _FakeStorefrontGateway implements StorefrontGateway {
  _FakeStorefrontGateway({
    this.throwOnAvailability = false,
    this.restoreOnRequest = false,
    this.throwOnLoadProducts = false,
    this.returnNoProducts = false,
  });

  final bool throwOnAvailability;
  bool restoreOnRequest;
  final bool throwOnLoadProducts;
  final bool returnNoProducts;
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
    if (throwOnLoadProducts) throw StateError('The Internet is offline.');
    if (returnNoProducts) return const <StorefrontProduct>[];
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
