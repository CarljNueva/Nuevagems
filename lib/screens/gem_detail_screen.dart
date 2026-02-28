import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/gem.dart';
import '../models/cart_service.dart';

class GemDetailScreen extends StatefulWidget {
  final Gem gem;

  const GemDetailScreen({super.key, required this.gem});

  @override
  State<GemDetailScreen> createState() => _GemDetailScreenState();
}

class _GemDetailScreenState extends State<GemDetailScreen> {
  int _quantity = 1;
  static const int _maxQuantity = 5;

  void _increaseQuantity() {
    setState(() {
      if (_quantity < _maxQuantity) _quantity++;
    });
  }

  void _decreaseQuantity() {
    setState(() {
      if (_quantity > 1) _quantity--;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartService = CartService();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.gem.name,
          style: GoogleFonts.dancingScript(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.gem.imagePath.isNotEmpty)
              Image.asset(
                widget.gem.imagePath,
                height: MediaQuery.of(context).size.height * 0.5,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 16),
            Text(
              widget.gem.name,
              style: GoogleFonts.dancingScript(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Price: \$${widget.gem.price}',
              style: GoogleFonts.roboto(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              widget.gem.description,
              style: GoogleFonts.roboto(fontSize: 14, height: 1.6, color: Colors.white),
            ),
            const Spacer(),
            Row(
              children: [
                // Quantity Selector
                Row(
                  children: [
                    Text(
                      'Qty:',
                      style: GoogleFonts.roboto(fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: _decreaseQuantity,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '$_quantity',
                        style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _increaseQuantity,
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      for (int i = 0; i < _quantity; i++) {
                        cartService.addItem(widget.gem);
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${widget.gem.name} x$_quantity added to cart!')),
                      );
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text('Add to Cart'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}