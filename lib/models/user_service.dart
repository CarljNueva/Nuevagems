import 'package:flutter/foundation.dart';
import 'user.dart';

class UserService extends ChangeNotifier {
  static final UserService _instance = UserService._internal();

  late User _user;

  UserService._internal() {
    _user = User(
      name: 'Carl Nueva',
      profileImagePath: 'assets/images/profilepicture.png',
      shippingAddress: '406 Dama De Noche, Nieves Hills, San-Isidro, Angono, Rizal, 1930',
      orderHistory: [],
      likedGems: [],
    );
  }


  factory UserService() {
    return _instance;
  }

  User get user => _user;

  void toggleLikeGem(String gemName) {
    if (_user.likedGems.contains(gemName)) {
      _user.likedGems.remove(gemName);
    } else {
      _user.likedGems.add(gemName);
    }
    notifyListeners();
  }

  void updateShippingAddress(String newAddress) {
    _user.shippingAddress = newAddress;
    notifyListeners();
  }

  void updateUserName(String newName) {
    _user.name = newName;
    notifyListeners();
  }

  bool isGemLiked(String gemName) {
    return _user.likedGems.contains(gemName);
  }

  void addOrders(List<Order> orders) {
    // insert orders as accepted and notify; then schedule phase transitions
    _user.orderHistory.insertAll(0, orders);
    notifyListeners();

    for (final order in orders) {
      // ensure status is accepted
      order.status = OrderStatus.accepted;
      
      // transition to packaged after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        final idx = _user.orderHistory.indexWhere((o) => o.id == order.id);
        if (idx >= 0) {
          _user.orderHistory[idx].status = OrderStatus.packaged;
          notifyListeners();
        }
      });
      
      // transition to beingShipped after 6 seconds (3 + 3)
      Future.delayed(const Duration(seconds: 6), () {
        final idx = _user.orderHistory.indexWhere((o) => o.id == order.id);
        if (idx >= 0) {
          _user.orderHistory[idx].status = OrderStatus.beingShipped;
          notifyListeners();
        }
      });
      
      // transition to completed after 9 seconds (3 + 3 + 3)
      Future.delayed(const Duration(seconds: 9), () {
        final idx = _user.orderHistory.indexWhere((o) => o.id == order.id);
        if (idx >= 0) {
          _user.orderHistory[idx].status = OrderStatus.completed;
          notifyListeners();
        }
      });
    }
  }

  void cancelOrder(String orderId) {
    _user.orderHistory.removeWhere((order) => order.id == orderId);
    notifyListeners();
  }
}

