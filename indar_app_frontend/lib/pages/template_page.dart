import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/template_model.dart';
import '../widgets/bottom_nav.dart';
import '../services/api_service.dart';
import 'add_photo_page.dart';

class TemplatePage extends StatefulWidget {
  final TemplateModel template;
  const TemplatePage({super.key, required this.template});

  @override
  State<TemplatePage> createState() => _TemplatePageState();
}

class _TemplatePageState extends State<TemplatePage> {
  int _tab = 0;
  List<dynamic> _products = [];
  bool _loadingProducts = false;
  double _userRating = 0;

  String get _themeName {
    const map = {
      'Halloween': 'Halloween',
      'Christmas': 'Christmas',
      'Diwali': 'Diwali',
      'Onam': 'onam',
      'Birthday': 'Birthday',
      'Wedding': 'onam',
    };
    return map[widget.template.title] ?? widget.template.title;
  }

  Future<void> _loadProducts() async {
    if (_products.isNotEmpty) return;
    setState(() => _loadingProducts = true);
    try {
      final result = await ApiService.get('/api/products/theme/$_themeName');
      if (mounted) {
        setState(() {
          _products = result is List ? result : [];
          _loadingProducts = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _loadingProducts = false);
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open link.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  static const List<Map<String, dynamic>> _sampleReviews = [
    {
      'name': 'Priya S.',
      'rating': 5,
      'comment': 'Absolutely loved the decorations! The AR preview made it so easy to visualise everything before buying.',
      'date': 'March 2026',
    },
    {
      'name': 'Rahul M.',
      'rating': 4,
      'comment': 'Great selection of products. The bundle cart was super convenient — everything added to Amazon in one tap.',
      'date': 'February 2026',
    },
    {
      'name': 'Ananya K.',
      'rating': 5,
      'comment': 'The AI-generated design looked stunning. Exactly what I wanted for the living room.',
      'date': 'January 2026',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEEED),
      bottomNavigationBar: buildBottomNav(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                  child: Image.asset(
                    widget.template.image,
                    height: 340,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                  child: Container(
                    height: 340,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.3, 1.0],
                        colors: [Colors.transparent, Color(0xCC000000)],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 12,
                  left: 16,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.35),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: const Icon(Icons.arrow_back,
                          color: Colors.white, size: 18),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 24,
                  left: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.template.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          const Text('4.5',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 13)),
                          const SizedBox(width: 12),
                          const Icon(Icons.inventory_2_outlined,
                              color: Colors.white54, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.template.elements.length} elements',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.black12),
                ),
                child: Row(
                  children: [
                    _tabButton('Description', 0),
                    _tabButton('Elements', 1),
                    _tabButton('Rating', 2),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (_tab == 0) _buildDescription(),
            if (_tab == 1) _buildElements(),
            if (_tab == 2) _buildRating(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _tabButton(String label, int index) {
    final active = _tab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _tab = index);
          if (index == 1) _loadProducts();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF111111) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: active ? Colors.white : const Color(0xFF888888),
                fontSize: 13,
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('About this theme',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Text(
            widget.template.description,
            style: const TextStyle(
                fontSize: 14, color: Color(0xFF555555), height: 1.7),
          ),
          const SizedBox(height: 24),
          const Text("What's included",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          ...widget.template.elements.map((el) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFF111111),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.check,
                          color: Colors.white, size: 16),
                    ),
                    const SizedBox(width: 12),
                    Text(el, style: const TextStyle(fontSize: 14)),
                  ],
                ),
              )),
          const SizedBox(height: 24),

          // ← FIXED: now navigates to AddPhotoPage with theme
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddPhotoPage(),
                ),
              );
            },
            child: Container(
              height: 54,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF111111),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(
                child: Text(
                  'Decorate My Room',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildElements() {
    if (_loadingProducts) {
      return const Padding(
        padding: EdgeInsets.all(60),
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFF111111)),
        ),
      );
    }

    if (_products.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.inventory_2_outlined,
                  size: 32, color: Colors.black.withOpacity(0.25)),
              const SizedBox(height: 12),
              const Text('No products found for this theme.',
                  style: TextStyle(color: Color(0xFF888888), fontSize: 14)),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_products.length} products from your dataset',
            style: const TextStyle(fontSize: 13, color: Color(0xFF888888)),
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (_, i) => _productCard(_products[i]),
          ),
        ],
      ),
    );
  }

  Widget _productCard(Map<String, dynamic> product) {
    final name = (product['name'] ?? '') as String;
    final shortName = name.split(' ').take(4).join(' ');
    final price = product['price'];
    final imageUrl = product['image_url'];
    final category = (product['category'] ?? '') as String;
    final productUrl = product['product_url'] as String?;
    final asin = product['asin'] as String?;

    final amazonUrl = (productUrl != null && productUrl.isNotEmpty)
        ? productUrl
        : asin != null
            ? 'https://www.amazon.in/dp/$asin'
            : null;

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: const Color(0xFFEFEEED),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          builder: (sheetContext) => Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(name,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.07),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(category,
                          style: const TextStyle(fontSize: 12)),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      price != null ? '₹${price.toStringAsFixed(0)}' : '',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () async {
                    Navigator.pop(sheetContext);
                    if (amazonUrl != null) {
                      await _openUrl(amazonUrl);
                    } else {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No Amazon link available.'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    }
                  },
                  child: Container(
                    height: 48,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF111111),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.open_in_new,
                              color: Colors.white, size: 16),
                          SizedBox(width: 8),
                          Text('View on Amazon',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: imageUrl != null && imageUrl.toString().isNotEmpty
                    ? Image.network(
                        imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholder(category),
                        loadingBuilder: (_, child, progress) {
                          if (progress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                                color: Color(0xFF111111)),
                          );
                        },
                      )
                    : _placeholder(category),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      shortName,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF111111),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          price != null
                              ? '₹${price.toStringAsFixed(0)}'
                              : '',
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(category,
                              style: const TextStyle(
                                  fontSize: 9, color: Color(0xFF555555))),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder(String category) {
    return Container(
      color: const Color(0xFFF0F0F0),
      child: Center(
        child: Icon(
          category == 'Hanging'
              ? Icons.light_outlined
              : category == 'Wall'
                  ? Icons.wallpaper_outlined
                  : Icons.weekend_outlined,
          size: 32,
          color: Colors.black26,
        ),
      ),
    );
  }

  Widget _buildRating() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black12),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('4.5',
                        style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111111))),
                    Row(
                      children: List.generate(
                        5,
                        (i) => Icon(
                          i < 4
                              ? Icons.star_rounded
                              : Icons.star_half_rounded,
                          color: Colors.amber,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text('128 reviews',
                        style: TextStyle(
                            color: Color(0xFF888888), fontSize: 12)),
                  ],
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    children: [
                      _ratingBar(5, 0.72),
                      _ratingBar(4, 0.18),
                      _ratingBar(3, 0.06),
                      _ratingBar(2, 0.02),
                      _ratingBar(1, 0.02),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          const Text('Rate this theme',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.black12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) {
                    return GestureDetector(
                      onTap: () => setState(() => _userRating = i + 1.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          i < _userRating
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          color:
                              i < _userRating ? Colors.amber : Colors.black26,
                          size: 36,
                        ),
                      ),
                    );
                  }),
                ),
                if (_userRating > 0) ...[
                  const SizedBox(height: 10),
                  Text(_ratingLabel(_userRating),
                      style: const TextStyle(
                          color: Color(0xFF888888), fontSize: 13)),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Rating submitted! Thank you. 🌟'),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      setState(() => _userRating = 0);
                    },
                    child: Container(
                      height: 44,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFF111111),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text('Submit Rating',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500)),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 24),

          const Text('Reviews',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),

          ..._sampleReviews.map((r) => _reviewCard(r)),
        ],
      ),
    );
  }

  Widget _ratingBar(int star, double fraction) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text('$star',
              style:
                  const TextStyle(fontSize: 11, color: Color(0xFF888888))),
          const SizedBox(width: 6),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: fraction,
                backgroundColor: Colors.black12,
                valueColor: const AlwaysStoppedAnimation(Colors.amber),
                minHeight: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _reviewCard(Map<String, dynamic> review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(review['name'],
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 14)),
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    i < (review['rating'] as int)
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    color: Colors.amber,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(review['comment'],
              style: const TextStyle(
                  fontSize: 13, color: Color(0xFF555555), height: 1.5)),
          const SizedBox(height: 4),
          Text(review['date'],
              style:
                  const TextStyle(fontSize: 11, color: Color(0xFF999999))),
        ],
      ),
    );
  }

  String _ratingLabel(double r) {
    if (r == 5) return 'Excellent! 🌟';
    if (r == 4) return 'Really good 👍';
    if (r == 3) return "It's okay";
    if (r == 2) return 'Could be better';
    return 'Not great';
  }
}