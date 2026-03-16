import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/bottom_nav.dart';

class CartPage extends StatelessWidget {
  final Map<String, dynamic>? bundle;

  const CartPage({super.key, this.bundle});

  Future<void> _openAmazon(BuildContext context) async {
    final cartUrl = bundle?['amazon_cart_url'];
    if (cartUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No cart available. Generate a design first.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    final uri = Uri.parse(cartUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = bundle?['items'] as List? ?? [];
    final totalPrice = bundle?['total_price'];

    return Scaffold(
      backgroundColor: const Color(0xfff3f3f3),
      bottomNavigationBar: buildBottomNav(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Header
              const Text(
                'CART',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                items.isEmpty
                    ? 'No items yet'
                    : '${items.length} items in your bundle',
                style: const TextStyle(
                    fontSize: 13, color: Colors.black45),
              ),

              const SizedBox(height: 20),

              // Items list
              Expanded(
                child: items.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.shopping_cart_outlined,
                                size: 48,
                                color: Colors.black.withOpacity(0.2)),
                            const SizedBox(height: 16),
                            const Text(
                              'No bundle yet.',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black45),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Generate a design from a template\nto build your cart.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black38,
                                  height: 1.5),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        itemCount: items.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 10),
                        itemBuilder: (_, i) =>
                            _cartItem(items[i]),
                      ),
              ),

              // Price summary — only show if items exist
              if (items.isNotEmpty) ...[
                const Divider(thickness: 1),
                const SizedBox(height: 8),

                _priceRow('Subtotal',
                    totalPrice != null
                        ? '₹${(totalPrice as num).toStringAsFixed(0)}'
                        : '—'),
                _priceRow('Delivery', 'Free via Amazon'),

                const Divider(thickness: 1),

                _priceRow(
                  'TOTAL',
                  totalPrice != null
                      ? '₹${(totalPrice as num).toStringAsFixed(0)}'
                      : '—',
                  bold: true,
                ),

                const SizedBox(height: 16),

                // Buy on Amazon button
                GestureDetector(
                  onTap: () => _openAmazon(context),
                  child: Container(
                    height: 55,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_cart_outlined,
                              color: Colors.white, size: 18),
                          SizedBox(width: 10),
                          Text(
                            'Buy on Amazon',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cartItem(Map<String, dynamic> item) {
    final product = item['product'] ?? {};
    final name = (product['name'] ?? '') as String;
    final shortName = name.split(' ').take(5).join(' ');
    final price = product['price'];
    final imageUrl = product['image_url'];
    final category = product['category'] ?? '';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          // Product image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: imageUrl != null && imageUrl.toString().isNotEmpty
                ? Image.network(
                    imageUrl,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholder(),
                  )
                : _placeholder(),
          ),
          const SizedBox(width: 12),

          // Name + category
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shortName,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w500),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    category,
                    style: const TextStyle(
                        fontSize: 10, color: Color(0xFF555555)),
                  ),
                ),
              ],
            ),
          ),

          // Price
          Text(
            price != null ? '₹${(price as num).toStringAsFixed(0)}' : '',
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 56,
      height: 56,
      color: const Color(0xFFF0F0F0),
      child: const Icon(Icons.image_outlined,
          color: Colors.black26, size: 20),
    );
  }

  Widget _priceRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                fontSize: bold ? 15 : 13,
                fontWeight:
                    bold ? FontWeight.w600 : FontWeight.normal,
                color: bold ? Colors.black : Colors.black54,
              )),
          Text(value,
              style: TextStyle(
                fontSize: bold ? 15 : 13,
                fontWeight:
                    bold ? FontWeight.w600 : FontWeight.normal,
              )),
        ],
      ),
    );
  }
}