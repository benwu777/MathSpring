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
    try {
      if (!await _gateway.isAvailable()) {
        value = const MonetizationState.unavailable();
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
        value = const MonetizationState.unavailable();
        return;
      }
      value = MonetizationState(
        status: MonetizationStatus.ready,
        product: MonetizationProduct(
          id: fullUnlock.id,
          displayName: fullUnlock.title,
          price: fullUnlock.price,
        ),
      );
      // Re-establish a non-consumable purchase on every app launch. This is
      // deliberately best-effort: a temporary restore failure must not stop a
      // new customer from seeing the product and making a purchase.
      try {
        await _gateway.restore();
      } catch (_) {}
    } catch (error) {
      value = MonetizationState(
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
    if (value.product == null) {
      return;
    }
    value = value.copyWith(
      status: MonetizationStatus.restoring,
      clearError: true,
    );
    try {
      await _gateway.restore();
      if (value.status == MonetizationStatus.restoring) {
        value = value.copyWith(status: MonetizationStatus.ready);
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
