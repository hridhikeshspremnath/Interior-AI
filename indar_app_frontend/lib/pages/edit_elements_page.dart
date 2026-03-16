import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/bottom_nav.dart';
import 'cart_page.dart';

class EditElementsPage extends StatefulWidget {
  final List<dynamic> elements;
  final Map<String, dynamic> design;
  final Map<String, dynamic>? bundle;
  final String themeName;

  const EditElementsPage({
    super.key,
    required this.elements,
    required this.design,
    required this.bundle,
    required this.themeName,
  });

  @override
  State<EditElementsPage> createState() => _EditElementsPageState();
}

class _EditElementsPageState extends State<EditElementsPage> {
  late List<Map<String, dynamic>> _elements;

  @override
  void initState() {
    super.initState();
    _elements = widget.elements
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  Future<void> _openAmazonCart() async {
    final cartUrl = widget.bundle?['amazon_cart_url'];
    if (cartUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No cart available.'),
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
    final items = widget.bundle?['items'] as List? ?? [];

    return Scaffold(
      backgroundColor: const Color(0xfff3f3f3),
      bottomNavigationBar: buildBottomNav(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black12),
                        ),
                        child: const Icon(Icons.arrow_back, size: 18),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Edit Mode',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.black45)),
                          Text('${widget.themeName} Elements',
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                const Text('Design Preview',
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 10),

                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    height: 160,
                    width: double.infinity,
                    color: Colors.grey.shade200,
                    child: widget.design['design_image_url'] != null
                        ? Image.network(
                            widget.design['design_image_url'],
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Center(
                              child: Icon(Icons.image_outlined,
                                  color: Colors.black26, size: 32),
                            ),
                          )
                        : const Center(
                            child: Icon(Icons.image_outlined,
                                color: Colors.black26, size: 32),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Detected Elements (${_elements.length})',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'AR coming soon',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black.withOpacity(0.4)),
                      ),
                      const SizedBox(height: 16),
                      ..._elements.asMap().entries.map(
                            (entry) => _elementCard(
                                entry.key, entry.value, items),
                          ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                if (items.isNotEmpty) ...[
                  const Text('Matched Products',
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  ...items.map<Widget>((item) {
                    final product = item['product'] ?? {};
                    final name = (product['name'] ?? '') as String;
                    final shortName = name.split(' ').take(5).join(' ');
                    final price = product['price'];
                    final imageUrl = product['image_url'];
                    final category = product['category'] ?? '';
                    final productUrl = product['product_url'] as String?;
                    final asin = product['asin'] as String?;
                    final amazonUrl =
                        (productUrl != null && productUrl.isNotEmpty)
                            ? productUrl
                            : asin != null
                                ? 'https://www.amazon.in/dp/$asin'
                                : null;

                    return GestureDetector(
                      onTap: () async {
                        if (amazonUrl != null) {
                          final uri = Uri.parse(amazonUrl);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri,
                                mode: LaunchMode.externalApplication);
                          }
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.black12),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: imageUrl != null &&
                                      imageUrl.toString().isNotEmpty
                                  ? Image.network(imageUrl,
                                      width: 52,
                                      height: 52,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          _smallPlaceholder())
                                  : _smallPlaceholder(),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(shortName,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        price != null
                                            ? '₹${(price as num).toStringAsFixed(0)}'
                                            : '',
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight:
                                                FontWeight.w600),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets
                                            .symmetric(
                                                horizontal: 6,
                                                vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.black
                                              .withOpacity(0.06),
                                          borderRadius:
                                              BorderRadius.circular(
                                                  4),
                                        ),
                                        child: Text(category,
                                            style: const TextStyle(
                                                fontSize: 10,
                                                color: Color(
                                                    0xFF555555))),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.open_in_new,
                                size: 16, color: Colors.black38),
                          ],
                        ),
                      ),
                    );
                  }),
                ],

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CartPage(bundle: widget.bundle),
                            ),
                          );
                        },
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.black12),
                          ),
                          child: const Center(
                            child: Text('View Cart',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: _openAmazonCart,
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Center(
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Icon(Icons.shopping_cart_outlined,
                                    color: Colors.white, size: 18),
                                SizedBox(width: 8),
                                Text('Buy on Amazon',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _elementCard(
      int index, Map<String, dynamic> el, List<dynamic> items) {
    final name = (el['name'] ?? 'Unknown') as String;
    final category = (el['category'] ?? '') as String;
    final posY = el['pos_y'] ?? 0.0;

    String placement = 'Floor';
    if ((posY as num) > 2.0) placement = 'Ceiling';
    else if ((posY as num) > 0.5) placement = 'Wall';

    final matchedProduct = items.isNotEmpty && index < items.length
        ? (items[index]['product'] as Map<String, dynamic>?) ?? {}
        : <String, dynamic>{};
    final productImageUrl = matchedProduct['image_url'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xfff3f3f3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: productImageUrl != null &&
                    productImageUrl.toString().isNotEmpty
                ? Image.network(productImageUrl,
                    width: 56, height: 56, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        _categoryIcon(category))
                : _categoryIcon(category),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.07),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(category,
                          style: const TextStyle(fontSize: 10)),
                    ),
                    const SizedBox(width: 6),
                    Text('· $placement',
                        style: const TextStyle(
                            fontSize: 11, color: Colors.black45)),
                  ],
                ),
              ],
            ),
          ),
          // AR placeholder button
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.view_in_ar,
                    color: Colors.white, size: 18),
                SizedBox(height: 2),
                Text('AR Soon',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryIcon(String category) {
    return Container(
      width: 56, height: 56,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.07),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        category == 'Hanging'
            ? Icons.light_outlined
            : category == 'Wall'
                ? Icons.wallpaper_outlined
                : Icons.weekend_outlined,
        size: 24,
        color: Colors.black45,
      ),
    );
  }

  Widget _smallPlaceholder() {
    return Container(
      width: 52, height: 52,
      color: const Color(0xFFF0F0F0),
      child: const Icon(Icons.image_outlined,
          color: Colors.black26, size: 18),
    );
  }
}