import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import '../widgets/bottom_nav.dart';
import 'cart_page.dart';
import 'edit_elements_page.dart';

class GeneratedPage extends StatefulWidget {
  final Map<String, dynamic> design;
  final Map<String, dynamic>? bundle;
  final String themeName;

  const GeneratedPage({
    super.key,
    required this.design,
    required this.bundle,
    required this.themeName,
  });

  @override
  State<GeneratedPage> createState() => _GeneratedPageState();
}

class _GeneratedPageState extends State<GeneratedPage> {
  late List<dynamic> _elements;
  late List<dynamic> _items;
  bool _purchasing = false;

  @override
  void initState() {
    super.initState();
    _elements = widget.design['elements'] as List? ?? [];
    _items = widget.bundle?['items'] as List? ?? [];
  }

  Future<void> _openAmazonCart() async {
    final cartUrl = widget.bundle?['amazon_cart_url'];
    if (cartUrl == null) {
      _showSnack('No cart available.');
      return;
    }
    setState(() => _purchasing = true);
    try {
      final token =
          Supabase.instance.client.auth.currentSession?.accessToken;
      final bundleId = widget.bundle?['bundle_id'];
      if (token != null && bundleId != null) {
        await http.post(
          Uri.parse(
              'http://10.0.2.2:8000/api/products/bundles/$bundleId/purchase'),
          headers: {'Authorization': 'Bearer $token'},
        );
      }
    } catch (e) {
      print('Transaction record failed: $e');
    } finally {
      if (mounted) setState(() => _purchasing = false);
    }
    final uri = Uri.parse(cartUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _showSnack('Could not open Amazon.');
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final designImageUrl = widget.design['design_image_url'];
    final totalPrice = widget.bundle?['total_price'];

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
                          const Text('Step 3 of 3',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.black45)),
                          Text('${widget.themeName} Design',
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: 1.0,
                    minHeight: 6,
                    backgroundColor: Colors.grey.shade200,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 20),

                const Text('Generated Design',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500)),
                const SizedBox(height: 10),

                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 260,
                    width: double.infinity,
                    color: Colors.grey.shade200,
                    child: designImageUrl != null
                        ? Image.network(
                            designImageUrl,
                            fit: BoxFit.cover,
                            loadingBuilder: (_, child, progress) {
                              if (progress == null) return child;
                              return Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const CircularProgressIndicator(
                                        color: Colors.black,
                                        strokeWidth: 2),
                                    const SizedBox(height: 12),
                                    Text('Loading image...',
                                        style: TextStyle(
                                            color: Colors.black
                                                .withOpacity(0.4),
                                            fontSize: 12)),
                                  ],
                                ),
                              );
                            },
                            errorBuilder: (_, __, ___) =>
                                _imagePlaceholder(),
                          )
                        : _imagePlaceholder(),
                  ),
                ),

                const SizedBox(height: 20),

                // Elements box
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Elements (${_elements.length})',
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditElementsPage(
                                    elements: _elements,
                                    design: widget.design,
                                    bundle: widget.bundle,
                                    themeName: widget.themeName,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.edit_outlined,
                                      color: Colors.white, size: 14),
                                  SizedBox(width: 4),
                                  Text('Edit + AR',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (_elements.isEmpty)
                        Text('No elements detected.',
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.4),
                                fontSize: 13))
                      else
                        ..._elements.map((el) =>
                            _elementRow(el as Map<String, dynamic>)),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                if (_items.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Your Bundle',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600)),
                      if (totalPrice != null)
                        Text(
                          '₹${(totalPrice as num).toStringAsFixed(0)} total',
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ..._items.map<Widget>((item) => _bundleItem(item)),
                  const SizedBox(height: 8),
                ],

                const SizedBox(height: 16),

                GestureDetector(
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
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_cart_outlined, size: 18),
                          SizedBox(width: 8),
                          Text('View Cart',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.black12),
                          ),
                          child: const Center(
                            child: Text('Try Again',
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
                        onTap: _purchasing ? null : _openAmazonCart,
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color: _purchasing
                                ? Colors.grey.shade300
                                : Colors.black,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: _purchasing
                                ? const SizedBox(
                                    width: 20, height: 20,
                                    child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2),
                                  )
                                : const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                          Icons.shopping_cart_outlined,
                                          color: Colors.white,
                                          size: 18),
                                      SizedBox(width: 8),
                                      Text('Buy on Amazon',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight:
                                                  FontWeight.w600)),
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

  Widget _elementRow(Map<String, dynamic> el) {
    final name = (el['name'] ?? 'Unknown') as String;
    final category = (el['category'] ?? '') as String;
    final posY = el['pos_y'] ?? 0.0;

    String placement = 'Floor';
    if ((posY as num) > 2.0) placement = 'Ceiling';
    else if ((posY as num) > 0.5) placement = 'Wall';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
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
              size: 18,
              color: Colors.black54,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500)),
                Text('$category · $placement',
                    style: const TextStyle(
                        fontSize: 11, color: Colors.black45)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.06),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text('AR',
                style: TextStyle(
                    fontSize: 11, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget _bundleItem(Map<String, dynamic> item) {
    final product = item['product'] ?? {};
    final name = (product['name'] ?? '') as String;
    final shortName = name.split(' ').take(4).join(' ');
    final price = product['price'];
    final imageUrl = product['image_url'];
    final category = product['category'] ?? '';

    return Container(
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
            child: imageUrl != null && imageUrl.toString().isNotEmpty
                ? Image.network(imageUrl,
                    width: 52, height: 52, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _smallPlaceholder())
                : _smallPlaceholder(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(shortName,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500),
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
                          fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(category,
                          style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF555555))),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_awesome,
              size: 36, color: Colors.black.withOpacity(0.2)),
          const SizedBox(height: 10),
          const Text('Design generated!',
              style: TextStyle(fontSize: 14, color: Colors.black45)),
          const SizedBox(height: 4),
          const Text('Image appears after AI warms up',
              style: TextStyle(fontSize: 11, color: Colors.black26)),
        ],
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