import 'package:flutter/material.dart';
import '../models/user_service.dart';
import '../models/user.dart' show OrderStatus;

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.accepted:
        return 'Order accepted';
      case OrderStatus.packaged:
        return 'Order packaged';
      case OrderStatus.beingShipped:
        return 'Order being shipped';
      case OrderStatus.completed:
        return 'Order completed';
    }
  }

  void _showCancelDialog(BuildContext context, UserService userService, String orderId) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (ctx, animation, secondaryAnimation) {
        return Dialog(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Cancel Order', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                const Text('Are you sure you want to cancel this order?'),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('No'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        userService.cancelOrder(orderId);
                        Navigator.of(ctx).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Order cancelled')),
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Yes, Cancel Order', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userService = UserService();
    return ListenableBuilder(
      listenable: userService,
      builder: (context, _) {
        final orders = userService.user.orderHistory;
        if (orders.isEmpty) return Center(child: Text('No orders yet', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white)));

        final ongoing = orders.where((o) => o.status != OrderStatus.completed).toList();
        final completed = orders.where((o) => o.status == OrderStatus.completed).toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Ongoing Orders', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 8),
              if (ongoing.isEmpty) const Text('No ongoing orders', style: TextStyle(color: Colors.white)),
              ...ongoing.map((order) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.orange, width: 1.5),
                    ),
                    child: ListTile(
                      title: Text(order.gemName),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Qty: ${order.quantity}'),
                          const SizedBox(height: 4),
                          Text(_getStatusText(order.status), style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      trailing: SizedBox(
                        width: 120,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const SizedBox(
                              width: 50,
                              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () => _showCancelDialog(context, userService, order.id),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
              const SizedBox(height: 16),
              const Text('Completed Orders', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 8),
              if (completed.isEmpty) const Text('No completed orders yet', style: TextStyle(color: Colors.white)),
              ...completed.map((order) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.orange, width: 1.5),
                    ),
                    child: ListTile(
                      title: Text(order.gemName),
                      subtitle: Text('Qty: ${order.quantity} • ${order.orderDate.toLocal().toString().split(' ')[0]}'),
                      trailing: Text('\$${order.totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  )),
            ],
          ),
        );
      },
    );
  }
}
