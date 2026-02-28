import 'package:flutter/foundation.dart';
import 'gem.dart';

class CartItem {
  final Gem gem;
  int quantity;

  CartItem({required this.gem, this.quantity = 1});
}

class CartService extends ChangeNotifier {
  static final CartService _instance = CartService._internal();

  final List<CartItem> _items = [];

  CartService._internal();

  factory CartService() {
    return _instance;
  }

  List<CartItem> get items => _items;

  void addItem(Gem gem) {
    final index = _items.indexWhere((item) => item.gem.name == gem.name);
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(gem: gem));
    }
    notifyListeners();
  }

  void removeItem(String gemName) {
    _items.removeWhere((item) => item.gem.name == gemName);
    notifyListeners();
  }

  void increaseQuantity(String gemName) {
    final index = _items.indexWhere((item) => item.gem.name == gemName);
    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity(String gemName) {
    final index = _items.indexWhere((item) => item.gem.name == gemName);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        removeItem(gemName);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  double getTotalPrice() {
    return _items.fold(0, (sum, item) => sum + (item.gem.price * item.quantity));
  }
}

