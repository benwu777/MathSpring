import 'package:flutter/foundation.dart';

enum MonetizationStatus {
  unavailable,
  loading,
  ready,
  purchasing,
  restoring,
  error
}

class MonetizationProduct {
  const MonetizationProduct({
    required this.id,
    required this.displayName,
    required this.price,
    this.isNonConsumable = true,
  });

  static const MonetizationProduct fullUnlock = MonetizationProduct(
    id: 'com.benwu.mathspring.full_unlock',
    displayName: 'MathSpring Full Unlock',
    price: r'$1.99',
  );

  final String id;
  final String displayName;
  final String price;
  final bool isNonConsumable;
}

class MonetizationState {
  const MonetizationState({
    required this.status,
    this.product,
    this.hasFullUnlock = false,
    this.errorMessage,
    this.restoreFoundNothing = false,
  });

  const MonetizationState.unavailable()
      : status = MonetizationStatus.unavailable,
        product = null,
        hasFullUnlock = false,
        errorMessage = null,
        restoreFoundNothing = false;

  const MonetizationState.unlocked()
      : status = MonetizationStatus.ready,
        product = MonetizationProduct.fullUnlock,
        hasFullUnlock = true,
        errorMessage = null,
        restoreFoundNothing = false;

  final MonetizationStatus status;
  final MonetizationProduct? product;
  final bool hasFullUnlock;
  final String? errorMessage;

  /// True after a user-initiated restore finished without finding a purchase.
  final bool restoreFoundNothing;

  bool get canViewSolutionSteps => hasFullUnlock;
  bool get canUsePremiumAvatarOptions => hasFullUnlock;
  int get maxLearnerProfiles => hasFullUnlock ? 5 : 1;

  MonetizationState copyWith({
    MonetizationStatus? status,
    MonetizationProduct? product,
    bool? hasFullUnlock,
    String? errorMessage,
    bool clearError = false,
    bool? restoreFoundNothing,
  }) =>
      MonetizationState(
        status: status ?? this.status,
        product: product ?? this.product,
        hasFullUnlock: hasFullUnlock ?? this.hasFullUnlock,
        errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
        restoreFoundNothing: restoreFoundNothing ?? false,
      );
}

abstract interface class MonetizationService
    implements ValueListenable<MonetizationState> {
  Future<void> initialize();
  Future<void> purchaseFullUnlock();
  Future<void> restorePurchases();
  void dispose();
}

class NoopMonetizationService extends ValueNotifier<MonetizationState>
    implements MonetizationService {
  NoopMonetizationService() : super(const MonetizationState.unavailable());

  @override
  Future<void> initialize() async {}

  @override
  Future<void> purchaseFullUnlock() async {}

  @override
  Future<void> restorePurchases() async {}
}

class InMemoryMonetizationService extends ValueNotifier<MonetizationState>
    implements MonetizationService {
  InMemoryMonetizationService.withProduct()
      : super(const MonetizationState(
          status: MonetizationStatus.loading,
          product: MonetizationProduct.fullUnlock,
        ));

  bool _canRestore = false;

  @override
  Future<void> initialize() async {
    value = value.copyWith(status: MonetizationStatus.ready, clearError: true);
  }

  @override
  Future<void> purchaseFullUnlock() async {
    value =
        value.copyWith(status: MonetizationStatus.purchasing, clearError: true);
    _canRestore = true;
    value = value.copyWith(
      status: MonetizationStatus.ready,
      hasFullUnlock: true,
    );
  }

  @override
  Future<void> restorePurchases() async {
    value =
        value.copyWith(status: MonetizationStatus.restoring, clearError: true);
    value = value.copyWith(
      status: MonetizationStatus.ready,
      hasFullUnlock: _canRestore,
    );
  }

  Future<void> resetForTest() async {
    value = value.copyWith(
      status: MonetizationStatus.ready,
      hasFullUnlock: false,
      clearError: true,
    );
  }
}
