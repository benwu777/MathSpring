import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mathspring/services/monetization_service.dart';

enum StorePurchaseStatus { pending, purchased, restored, cancelled, error }

class StorefrontProduct {
  const StorefrontProduct({
    required this.id,
    required this.title,
    required this.price,
  });

  final String id;
  final String title;
  final String price;
}

class StorePurchaseEvent {
  const StorePurchaseEvent._({
    required this.status,
    this.productId,
    this.transactionId,
    this.errorMessage,
  });

  const StorePurchaseEvent.pending()
      : this._(status: StorePurchaseStatus.pending);

  const StorePurchaseEvent.purchased({
    required String productId,
    required String transactionId,
  }) : this._(
          status: StorePurchaseStatus.purchased,
          productId: productId,
          transactionId: transactionId,
        );

  const StorePurchaseEvent.restored({
    required String productId,
    required String transactionId,
  }) : this._(
          status: StorePurchaseStatus.restored,
          productId: productId,
          transactionId: transactionId,
        );

  const StorePurchaseEvent.cancelled()
      : this._(status: StorePurchaseStatus.cancelled);

  const StorePurchaseEvent.error(String message)
      : this._(status: StorePurchaseStatus.error, errorMessage: message);

  final StorePurchaseStatus status;
  final String? productId;
  final String? transactionId;
  final String? errorMessage;
}

abstract interface class StorefrontGateway {
  Stream<StorePurchaseEvent> get purchaseUpdates;
  Future<bool> isAvailable();
  Future<List<StorefrontProduct>> loadProducts(Set<String> productIds);
  Future<void> purchase(String productId);
  Future<void> restore();
  Future<void> complete(String transactionId);
}

class StoreKitMonetizationService extends ValueNotifier<MonetizationState>
    implements MonetizationService {
  StoreKitMonetizationService({required StorefrontGateway gateway})
      : _gateway = gateway,
        super(const MonetizationState(status: MonetizationStatus.loading));

  final StorefrontGateway _gateway;
  StreamSubscription<StorePurchaseEvent>? _purchaseSubscription;

  @override
  Future<void> initialize() async {
    await _purchaseSubscription?.cancel();
    _purchaseSubscription = _gateway.purchaseUpdates.listen(_handleEvent);
    value = const MonetizationState(status: MonetizationStatus.loading);
    // Re-establish a non-consumable purchase before touching the network.
    // StoreKit 2 answers from its local entitlement cache, so a paying
    // customer keeps the unlock offline even when the product query below
    // fails. Best-effort: a restore failure must not hide the product.
    try {
      await _gateway.restore();
    } catch (_) {}
    try {
      if (!await _gateway.isAvailable()) {
        value = value.copyWith(status: MonetizationStatus.unavailable);
        return;
      }
      final List<StorefrontProduct> products = await _gateway
          .loadProducts(<String>{MonetizationProduct.fullUnlock.id});
      StorefrontProduct? fullUnlock;
      for (final StorefrontProduct item in products) {
        if (item.id == MonetizationProduct.fullUnlock.id) {
          fullUnlock = item;
          break;
        }
      }
      if (fullUnlock == null) {
        value = value.copyWith(status: MonetizationStatus.unavailable);
        return;
      }
      value = value.copyWith(
        status: MonetizationStatus.ready,
        product: MonetizationProduct(
          id: fullUnlock.id,
          displayName: fullUnlock.title,
          price: fullUnlock.price,
        ),
      );
    } catch (error) {
      value = value.copyWith(
        status: MonetizationStatus.error,
        errorMessage: error.toString(),
      );
    }
  }

  @override
  Future<void> purchaseFullUnlock() async {
    if (value.product == null || value.hasFullUnlock) {
      return;
    }
    value = value.copyWith(
      status: MonetizationStatus.purchasing,
      clearError: true,
    );
    try {
      await _gateway.purchase(MonetizationProduct.fullUnlock.id);
    } catch (error) {
      value = value.copyWith(
        status: MonetizationStatus.error,
        errorMessage: error.toString(),
      );
    }
  }

  @override
  Future<void> restorePurchases() async {
    // Restore must stay reachable even when the product failed to load, so
    // that a paying customer is never locked out by a storefront hiccup.
    final MonetizationStatus settledStatus = value.product == null
        ? MonetizationStatus.unavailable
        : MonetizationStatus.ready;
    value = value.copyWith(
      status: MonetizationStatus.restoring,
      clearError: true,
    );
    try {
      await _gateway.restore();
      // Restored transactions arrive on the purchase stream; let them land
      // before deciding that nothing was found.
      await Future<void>.delayed(Duration.zero);
      if (value.status == MonetizationStatus.restoring) {
        value = value.copyWith(
          status: settledStatus,
          restoreFoundNothing: !value.hasFullUnlock,
        );
      }
    } catch (error) {
      value = value.copyWith(
        status: MonetizationStatus.error,
        errorMessage: error.toString(),
      );
    }
  }

  Future<void> _handleEvent(StorePurchaseEvent event) async {
    switch (event.status) {
      case StorePurchaseStatus.pending:
        value = value.copyWith(status: MonetizationStatus.purchasing);
      case StorePurchaseStatus.cancelled:
        value =
            value.copyWith(status: MonetizationStatus.ready, clearError: true);
      case StorePurchaseStatus.error:
        value = value.copyWith(
          status: MonetizationStatus.error,
          errorMessage: event.errorMessage ?? 'Purchase failed.',
        );
      case StorePurchaseStatus.purchased:
      case StorePurchaseStatus.restored:
        final bool isFullUnlock =
            event.productId == MonetizationProduct.fullUnlock.id;
        if (isFullUnlock) {
          value = value.copyWith(
            status: MonetizationStatus.ready,
            hasFullUnlock: true,
            clearError: true,
          );
        }
        final String? transactionId = event.transactionId;
        if (transactionId != null) {
          await _gateway.complete(transactionId);
        }
    }
  }

  @override
  void dispose() {
    _purchaseSubscription?.cancel();
    super.dispose();
  }
}

class InAppPurchaseStorefrontGateway implements StorefrontGateway {
  InAppPurchaseStorefrontGateway({InAppPurchase? store})
      : _store = store ?? InAppPurchase.instance;

  final InAppPurchase _store;
  final Map<String, ProductDetails> _products = <String, ProductDetails>{};
  final Map<String, PurchaseDetails> _transactions =
      <String, PurchaseDetails>{};

  @override
  Stream<StorePurchaseEvent> get purchaseUpdates =>
      _store.purchaseStream.expand((List<PurchaseDetails> purchases) sync* {
        for (final PurchaseDetails purchase in purchases) {
          final String transactionId = purchase.purchaseID ??
              purchase.verificationData.serverVerificationData;
          if (purchase.pendingCompletePurchase) {
            _transactions[transactionId] = purchase;
          }
          switch (purchase.status) {
            case PurchaseStatus.pending:
              yield const StorePurchaseEvent.pending();
            case PurchaseStatus.purchased:
              yield StorePurchaseEvent.purchased(
                productId: purchase.productID,
                transactionId: transactionId,
              );
            case PurchaseStatus.restored:
              yield StorePurchaseEvent.restored(
                productId: purchase.productID,
                transactionId: transactionId,
              );
            case PurchaseStatus.canceled:
              yield const StorePurchaseEvent.cancelled();
            case PurchaseStatus.error:
              yield StorePurchaseEvent.error(
                purchase.error?.message ?? 'Purchase failed.',
              );
          }
        }
      });

  @override
  Future<bool> isAvailable() => _store.isAvailable();

  @override
  Future<List<StorefrontProduct>> loadProducts(Set<String> productIds) async {
    final ProductDetailsResponse response =
        await _store.queryProductDetails(productIds);
    if (response.error != null) {
      throw StateError(response.error!.message);
    }
    _products
      ..clear()
      ..addEntries(response.productDetails.map(
        (ProductDetails item) =>
            MapEntry<String, ProductDetails>(item.id, item),
      ));
    return response.productDetails
        .map(
          (ProductDetails item) => StorefrontProduct(
            id: item.id,
            title: item.title,
            price: item.price,
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<void> purchase(String productId) async {
    final ProductDetails? product = _products[productId];
    if (product == null) {
      throw StateError('Product $productId is not loaded.');
    }
    await _store.buyNonConsumable(
      purchaseParam: PurchaseParam(productDetails: product),
    );
  }

  @override
  Future<void> restore() => _store.restorePurchases();

  @override
  Future<void> complete(String transactionId) async {
    final PurchaseDetails? transaction = _transactions.remove(transactionId);
    if (transaction != null) {
      await _store.completePurchase(transaction);
    }
  }
}
