import 'package:flutter/material.dart';
import '../models/user_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userService = UserService();
    return ListenableBuilder(
      listenable: userService,
      builder: (context, _) {
        final user = userService.user;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture
              CircleAvatar(
                radius: 60,
                backgroundImage: user.profileImagePath.isNotEmpty
                    ? AssetImage(user.profileImagePath)
                    : null,
                child: user.profileImagePath.isEmpty
                    ? const Icon(Icons.person, size: 60)
                    : null,
              ),
              const SizedBox(height: 16),
              // User Name
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    user.name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.orange),
                    onPressed: () => _showEditNameDialog(context, userService, user.name),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Order History
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Order History',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
              ),
              const SizedBox(height: 12),
              user.orderHistory.isEmpty
                  ? Text('No orders yet', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white))
                  : Column(
                      children: user.orderHistory.map((order) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(color: Colors.orange, width: 1.5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order.gemName,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Quantity: ${order.quantity} | Total: \$${order.totalPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Date: ${order.orderDate.toLocal().toString().split(' ')[0]}',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
              const SizedBox(height: 32),
              // Liked Gems
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Liked Gems',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
              ),
              const SizedBox(height: 12),
              user.likedGems.isEmpty
                  ? Text('No liked gems yet', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white))
                  : Wrap(
                      spacing: 8,
                      children: user.likedGems.map((gemName) {
                        return Chip(
                          label: Text(gemName, style: const TextStyle(color: Colors.white)),
                          backgroundColor: Colors.grey.shade700,
                          deleteIcon: const Icon(Icons.close, size: 18, color: Colors.white),
                          onDeleted: () =>
                              userService.toggleLikeGem(gemName),
                        );
                      }).toList(),
                    ),
              const SizedBox(height: 32),
              // Shipping Address
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Shipping Address',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Colors.orange, width: 1.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.shippingAddress),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _showEditAddressDialog(
                            context,
                            userService,
                            user.shippingAddress,
                          ),
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit Address'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditNameDialog(
    BuildContext context,
    UserService userService,
    String currentName,
  ) {
    final nameParts = currentName.split(' ');
    final firstNameController = TextEditingController(text: nameParts.isNotEmpty ? nameParts[0] : '');
    final middleNameController = TextEditingController(text: nameParts.length > 2 ? nameParts[1] : '');
    final lastNameController = TextEditingController(text: nameParts.length > 1 ? nameParts[nameParts.length - 1] : '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Name'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: middleNameController,
              decoration: const InputDecoration(
                labelText: 'Middle Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final name = [
                firstNameController.text,
                middleNameController.text,
                lastNameController.text,
              ].where((e) => e.isNotEmpty).join(' ');
              
              if (name.isNotEmpty) {
                userService.updateUserName(name);
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Name updated')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showEditAddressDialog(
    BuildContext context,
    UserService userService,
    String currentAddress,
  ) {
    final houseController = TextEditingController();
    final streetController = TextEditingController();
    final subdivisionController = TextEditingController();
    final barangayController = TextEditingController();
    final cityController = TextEditingController();
    final provinceController = TextEditingController();
    final zipController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Shipping Address'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: houseController,
                decoration: const InputDecoration(
                  labelText: 'House Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: streetController,
                decoration: const InputDecoration(
                  labelText: 'Street Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: subdivisionController,
                decoration: const InputDecoration(
                  labelText: 'Subdivision',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: barangayController,
                decoration: const InputDecoration(
                  labelText: 'Barangay',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: cityController,
                decoration: const InputDecoration(
                  labelText: 'City',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: provinceController,
                decoration: const InputDecoration(
                  labelText: 'Province',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: zipController,
                decoration: const InputDecoration(
                  labelText: 'ZIP Code',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final address = [
                houseController.text,
                streetController.text,
                subdivisionController.text,
                barangayController.text,
                cityController.text,
                provinceController.text,
                zipController.text,
              ].where((e) => e.isNotEmpty).join(', ');
              
              userService.updateShippingAddress(address);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Address updated')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
