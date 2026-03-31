import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/bottom_nav.dart';
import 'cart_page.dart';
import 'ar_view_page.dart';

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
  late List<Map<String, dynamic>> _bundleItems;

  final Set<String> _cartElementNames = {};

  @override
  void initState() {
    super.initState();
    _elements = widget.elements
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
    final rawItems = widget.bundle?['items'] as List? ?? [];
    _bundleItems = rawItems
        .map((i) => Map<String, dynamic>.from(i as Map))
        .toList();
  }

  // ─── Helpers ────────────────────────────────────────────────────────────────

  String? _amazonUrl(Map<String, dynamic> product) {
    final productUrl = product['product_url'] as String?;
    if (productUrl != null && productUrl.isNotEmpty) return productUrl;
    final asin = product['asin'] as String?;
    if (asin != null && asin.isNotEmpty) return 'https://www.amazon.in/dp/$asin';
    return null;
  }

  /// Used only for product image + price display — NOT for 3D asset resolution.
  Map<String, dynamic>? _matchedBundleItem(Map<String, dynamic> element) {
    if (_bundleItems.isEmpty) return null;
    final elName = (element['name'] as String? ?? '').toLowerCase();
    final elCategory = (element['category'] as String? ?? '').toLowerCase();

    for (final item in _bundleItems) {
      final product = item['product'] as Map<String, dynamic>? ?? {};
      if ((product['name'] as String? ?? '').toLowerCase() == elName) return item;
    }
    for (final item in _bundleItems) {
      final product = item['product'] as Map<String, dynamic>? ?? {};
      if ((product['category'] as String? ?? '').toLowerCase() == elCategory) return item;
    }
    return null;
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open link.'), behavior: SnackBarBehavior.floating),
        );
      }
    }
  }

  Future<void> _downloadDesignImage(String format) async {
    final imageUrl = widget.design['design_image_url'] as String?;
    if (imageUrl == null || imageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No design image available to download.'), behavior: SnackBarBehavior.floating),
      );
      return;
    }
    final downloadUrl = format == 'pdf'
        ? 'https://docs.google.com/viewerng/viewer?url=${Uri.encodeComponent(imageUrl)}'
        : imageUrl;
    await _launchUrl(downloadUrl);
  }

  void _showDownloadOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Download Design', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text('Choose your preferred format', style: TextStyle(fontSize: 13, color: Colors.black.withOpacity(0.45))),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: _downloadOptionTile(icon: Icons.image_outlined, label: 'JPEG', subtitle: 'Best for sharing', onTap: () { Navigator.pop(context); _downloadDesignImage('jpeg'); })),
                  const SizedBox(width: 12),
                  Expanded(child: _downloadOptionTile(icon: Icons.picture_as_pdf_outlined, label: 'PDF', subtitle: 'Best for printing', onTap: () { Navigator.pop(context); _downloadDesignImage('pdf'); })),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _downloadOptionTile({required IconData icon, required String label, required String subtitle, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(color: const Color(0xfff3f3f3), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.black12)),
        child: Column(children: [
          Icon(icon, size: 28, color: Colors.black87),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.black.withOpacity(0.45))),
        ]),
      ),
    );
  }

  void _toggleCart(String elementName) {
    setState(() {
      if (_cartElementNames.contains(elementName)) {
        _cartElementNames.remove(elementName);
      } else {
        _cartElementNames.add(elementName);
      }
    });
  }

  // ─── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
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
                _buildHeader(),
                const SizedBox(height: 20),
                _buildDesignPreview(),
                const SizedBox(height: 20),
                _buildElementsList(),
                const SizedBox(height: 20),
                if (_bundleItems.isNotEmpty) ...[_buildMatchedProducts(), const SizedBox(height: 20)],
                _buildActionButtons(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
            child: const Icon(Icons.arrow_back, size: 18),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Edit Mode', style: TextStyle(fontSize: 12, color: Colors.black45)),
              Text('${widget.themeName} Elements', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CartPage(bundle: widget.bundle))),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
                child: const Icon(Icons.shopping_cart_outlined, size: 18),
              ),
              if (_cartElementNames.isNotEmpty)
                Positioned(
                  top: -4, right: -4,
                  child: Container(
                    width: 18, height: 18,
                    decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                    child: Center(child: Text('${_cartElementNames.length}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700))),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesignPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Design Preview', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 160, width: double.infinity, color: Colors.grey.shade200,
            child: widget.design['design_image_url'] != null
                ? Image.network(widget.design['design_image_url'], fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.image_outlined, color: Colors.black26, size: 32)))
                : const Center(child: Icon(Icons.image_outlined, color: Colors.black26, size: 32)),
          ),
        ),
      ],
    );
  }

  Widget _buildElementsList() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Detected Elements (${_elements.length})', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text('Tap AR to preview in your room • + to add to cart', style: TextStyle(fontSize: 12, color: Colors.black.withOpacity(0.4))),
          const SizedBox(height: 16),
          ..._elements.map((el) => _elementCard(el)),
        ],
      ),
    );
  }

  Widget _buildMatchedProducts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Matched Products', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        ..._bundleItems.map<Widget>((item) {
          final product = item['product'] as Map<String, dynamic>? ?? {};
          final name = (product['name'] as String? ?? '');
          final shortName = name.split(' ').take(5).join(' ');
          final price = product['price'];
          final imageUrl = product['image_url'] as String?;
          final category = (product['category'] as String? ?? '');
          final url = _amazonUrl(product);

          return GestureDetector(
            onTap: () async { if (url != null) await _launchUrl(url); },
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.black12)),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: (imageUrl != null && imageUrl.isNotEmpty)
                        ? Image.network(imageUrl, width: 52, height: 52, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _smallPlaceholder())
                        : _smallPlaceholder(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(shortName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Row(children: [
                          if (price != null) Text('₹${(price as num).toStringAsFixed(0)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          if (price != null) const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: Colors.black.withOpacity(0.06), borderRadius: BorderRadius.circular(4)),
                            child: Text(category, style: const TextStyle(fontSize: 10, color: Color(0xFF555555))),
                          ),
                        ]),
                      ],
                    ),
                  ),
                  if (url != null) const Icon(Icons.open_in_new, size: 16, color: Colors.black38),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CartPage(bundle: widget.bundle))),
            child: Container(
              height: 52,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.black12)),
              child: const Center(child: Text('View Cart', style: TextStyle(fontWeight: FontWeight.w500))),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: GestureDetector(
            onTap: _showDownloadOptions,
            child: Container(
              height: 52,
              decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(14)),
              child: const Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.download_outlined, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text('Download Image', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─── Element card ─────────────────────────────────────────────────────────────

  Widget _elementCard(Map<String, dynamic> el) {
    final name = (el['name'] as String? ?? 'Unknown');
    final category = (el['category'] as String? ?? '');
    final posY = (el['pos_y'] as num? ?? 0.0).toDouble();

    String placement = 'Floor';
    if (posY > 2.0) placement = 'Ceiling';
    else if (posY > 0.5) placement = 'Wall';

    // ✅ asset_3d_name comes DIRECTLY from the element — set by backend during product matching.
    // No fuzzy matching needed; each element now carries its own unique 3D asset.
    final assetName = (el['asset_3d_name'] as String?)?.trim();

    // Bundle item used only for display (image + price), not for 3D asset resolution.
    final matchedItem = _matchedBundleItem(el);
    final product = matchedItem?['product'] as Map<String, dynamic>? ?? {};
    final productImageUrl = product['image_url'] as String?;
    final price = product['price'];
    final amazonUrl = _amazonUrl(product);
    final inCart = _cartElementNames.contains(name);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xfff3f3f3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: inCart ? Colors.black : Colors.black12, width: inCart ? 1.5 : 1.0),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: amazonUrl != null ? () => _launchUrl(amazonUrl) : null,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: (productImageUrl != null && productImageUrl.isNotEmpty)
                  ? Image.network(productImageUrl, width: 56, height: 56, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _categoryIcon(category))
                  : _categoryIcon(category),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.07), borderRadius: BorderRadius.circular(4)),
                    child: Text(category.isEmpty ? 'Item' : category, style: const TextStyle(fontSize: 10)),
                  ),
                  const SizedBox(width: 6),
                  Text('· $placement', style: const TextStyle(fontSize: 11, color: Colors.black45)),
                ]),
                if (price != null) ...[
                  const SizedBox(height: 4),
                  Text('₹${(price as num).toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // AR button
              GestureDetector(
                onTap: () {
                  if (assetName == null || assetName.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No 3D model available for this item.'), behavior: SnackBarBehavior.floating),
                    );
                    return;
                  }
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => ARViewPage(assetName: assetName, elementName: name, category: category),
                  ));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.view_in_ar, color: Colors.white, size: 18),
                      SizedBox(height: 2),
                      Text('AR', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 6),
              // Cart button
              GestureDetector(
                onTap: () => _toggleCart(name),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: inCart ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: inCart ? Colors.black : Colors.black26),
                  ),
                  child: Icon(inCart ? Icons.check : Icons.add_shopping_cart_outlined, color: inCart ? Colors.white : Colors.black, size: 18),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _categoryIcon(String category) {
    return Container(
      width: 56, height: 56,
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.07), borderRadius: BorderRadius.circular(10)),
      child: Icon(
        category == 'Hanging' ? Icons.light_outlined : category == 'Wall' ? Icons.wallpaper_outlined : Icons.weekend_outlined,
        size: 24, color: Colors.black45,
      ),
    );
  }

  Widget _smallPlaceholder() {
    return Container(
      width: 52, height: 52, color: const Color(0xFFF0F0F0),
      child: const Icon(Icons.image_outlined, color: Colors.black26, size: 18),
    );
  }
}