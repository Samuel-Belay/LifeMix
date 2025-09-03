import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PremiumService extends ChangeNotifier {
  final InAppPurchase _iap = InAppPurchase.instance;

  bool _isPremium = false;
  bool get isPremium => forcePremium || _isPremium;

  /// For testing purposes: set to true to simulate premium user
  bool forcePremium = false;

  late final Stream<List<PurchaseDetails>> _purchaseStream;
  final List<ProductDetails> _products = [];
  List<ProductDetails> get products => _products;

  PremiumService() {
    _purchaseStream = _iap.purchaseStream;
    _purchaseStream.listen(_onPurchaseUpdated, onDone: () {
      // Optional: clean up
    }, onError: (error) {
      debugPrint('Purchase stream error: $error');
    });
    _init();
  }

  Future<void> _init() async {
    final available = await _iap.isAvailable();
    if (!available) {
      debugPrint('In-app purchases not available.');
      return;
    }

    const ids = <String>['premium_monthly', 'premium_yearly']; // Replace with your IDs
    final response = await _iap.queryProductDetails(ids.toSet());
    _products.addAll(response.productDetails);

    await restorePurchases();
  }

  Future<void> purchase(ProductDetails product) async {
    if (forcePremium) {
      _isPremium = true;
      notifyListeners();
      debugPrint('Premium granted via forcePremium toggle.');
      return;
    }

    final purchaseParam = PurchaseParam(productDetails: product);
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }

  void _onPurchaseUpdated(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        if (purchase.productID.startsWith('premium')) {
          _isPremium = true;
          notifyListeners();
        }
      } else if (purchase.status == PurchaseStatus.error) {
        debugPrint('Purchase error: ${purchase.error}');
      }
    }
  }
}
