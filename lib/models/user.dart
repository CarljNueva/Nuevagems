enum OrderStatus { accepted, packaged, beingShipped, completed }

class Order {
  final String id;
  final String gemName;
  final int quantity;
  final double totalPrice;
  final DateTime orderDate;
  OrderStatus status;

  Order({
    required this.id,
    required this.gemName,
    required this.quantity,
    required this.totalPrice,
    required this.orderDate,
    this.status = OrderStatus.accepted,
  });
}


class User {
  String name;
  final String profileImagePath;
  String shippingAddress;
  final List<Order> orderHistory;
  final List<String> likedGems;

  User({
    required this.name,
    required this.profileImagePath,
    required this.shippingAddress,
    this.orderHistory = const [],
    this.likedGems = const [],
  });
}
