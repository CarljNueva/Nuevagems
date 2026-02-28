import 'package:flutter/material.dart';
import '../models/cart_service.dart';
import '../models/user_service.dart';
import '../models/user.dart' show Order;

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartService = CartService();

    return ListenableBuilder(
      listenable: cartService,
      builder: (context, _) {
        return Scaffold(
          body: cartService.items.isEmpty
              ? Center(
                  child: Text('Your cart is empty',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white, fontSize: 18)),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartService.items.length,
                        itemBuilder: (context, index) {
                          final cartItem = cartService.items[index];
                          return Card(
                            margin: const EdgeInsets.all(8),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(color: Colors.orange, width: 1.5),
                            ),
                            child: ListTile(
                              leading: cartItem.gem.imagePath.isNotEmpty
                                  ? Image.asset(
                                      cartItem.gem.imagePath,
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    )
                                  : const SizedBox(width: 60),
                              title: Text(cartItem.gem.name),
                              subtitle: Text(
                                'Price: \$${cartItem.gem.price} x ${cartItem.quantity}',
                              ),
                              trailing: SizedBox(
                                width: 100,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () {
                                        cartService
                                            .decreaseQuantity(cartItem.gem.name);
                                      },
                                    ),
                                    Text('${cartItem.quantity}'),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        cartService
                                            .increaseQuantity(cartItem.gem.name);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Total: \$${cartService.getTotalPrice().toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                final userService = UserService();
                                final messenger = ScaffoldMessenger.of(context);
                                final confirmed = await showGeneralDialog<bool>(
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
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text('Confirm Order', style: Theme.of(context).textTheme.headlineSmall),
                                              const SizedBox(height: 16),
                                              const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
                                              const SizedBox(height: 8),
                                              ...cartService.items.map((cartItem) => ListTile(
                                                    contentPadding: EdgeInsets.zero,
                                                    leading: cartItem.gem.imagePath.isNotEmpty
                                                        ? Image.asset(
                                                            cartItem.gem.imagePath,
                                                            width: 40,
                                                            height: 40,
                                                            fit: BoxFit.cover,
                                                          )
                                                        : null,
                                                    title: Text(cartItem.gem.name),
                                                    subtitle: Text('Qty: ${cartItem.quantity}'),
                                                    trailing: Text('\$${(cartItem.gem.price * cartItem.quantity).toStringAsFixed(2)}'),
                                                  )),
                                              const Divider(),
                                              const SizedBox(height: 8),
                                              const Text('Shipping to:', style: TextStyle(fontWeight: FontWeight.bold)),
                                              const SizedBox(height: 4),
                                              Text(userService.user.shippingAddress),
                                              const SizedBox(height: 12),
                                              Text('Total: \$${cartService.getTotalPrice().toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleMedium),
                                              const SizedBox(height: 20),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
                                                  const SizedBox(width: 8),
                                                  ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Place Order')),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );

                                if (confirmed == true) {
                                  final now = DateTime.now();
                                  final orders = cartService.items.map((ci) => Order(
                                        id: '${now.millisecondsSinceEpoch}-${ci.gem.name}',
                                        gemName: ci.gem.name,
                                        quantity: ci.quantity,
                                        totalPrice: ci.gem.price * ci.quantity.toDouble(),
                                        orderDate: now,
                                      )).toList();
                                  userService.addOrders(orders);
                                  cartService.clearCart();
                                  messenger.showSnackBar(const SnackBar(content: Text('Order placed!')));
                                }
                              },
                              child: const Text('Checkout'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

