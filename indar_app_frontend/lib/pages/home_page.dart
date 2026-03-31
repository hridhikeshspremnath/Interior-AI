import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import '../data/templates.dart';
import '../services/api_service.dart';
import 'template_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _bannerController = PageController();
  int _currentBanner = 0;
  String _userName = '';
  String _searchQuery = '';
  final _searchController = TextEditingController();

  final List<Map<String, String>> _banners = [
    {'image': 'assets/images/Onam.jpg', 'label': 'Onam'},
    {'image': 'assets/images/Christmas.jpg', 'label': 'Christmas'},
    {'image': 'assets/images/Diwali.jpg', 'label': 'Diwali'},
    {'image': 'assets/images/Halloween.jpg', 'label': 'Halloween'},
    {'image': 'assets/images/Bday.jpg', 'label': 'Birthday'},
  ];

  // Active filter chips
  String? _activeFilter;
  final List<String> _filterOptions = [
    'All',
    'Festive',
    'Seasonal',
    'Party',
    'Traditional',
    'Modern',
  ];

  static String _imageForTemplate(String title) {
    const map = {
      'Halloween': 'assets/images/Halloween.jpg',
      'Christmas': 'assets/images/Christmas.jpg',
      'Diwali': 'assets/images/Diwali.jpg',
      'Wedding': 'assets/images/room.jpg',
      'Onam': 'assets/images/Onam.jpg',
      'Birthday': 'assets/images/Bday.jpg',
    };
    return map[title] ?? 'assets/images/room.jpg';
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final user = await ApiService.get('/api/auth/me');
      if (mounted) {
        setState(() {
          // Use name if set, otherwise use part before @ in email
          final name = user['name'];
          final email = user['email'] ?? '';
          _userName = (name != null && name.toString().isNotEmpty)
              ? name.toString().split(' ')[0] // first name only
              : email.split('@')[0];
        });
      }
    } catch (e) {
      // Silently fail — just show fallback
    }
  }

  @override
  void dispose() {
    _bannerController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Filter popup
  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFEFEEED),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
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
              const SizedBox(height: 20),

              const Text('Filter Templates',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text('Choose a category to filter by',
                  style: TextStyle(
                      fontSize: 13, color: Colors.black.withOpacity(0.45))),

              const SizedBox(height: 20),

              // Category chips
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _filterOptions.map((f) {
                  final isSelected = _activeFilter == f ||
                      (f == 'All' && _activeFilter == null);
                  return GestureDetector(
                    onTap: () {
                      setSheetState(() {});
                      setState(() {
                        _activeFilter = f == 'All' ? null : f;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF111111)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF111111)
                              : Colors.black12,
                        ),
                      ),
                      child: Text(
                        f,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontSize: 14,
                          fontWeight: isSelected
                              ? FontWeight.w500
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // Sort section
              const Text('Sort By',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500)),
              const SizedBox(height: 12),

              Row(
                children: ['Popular', 'Newest', 'A-Z'].map((sort) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: sort == 'Popular'
                            ? const Color(0xFF111111)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Text(
                        sort,
                        style: TextStyle(
                          color: sort == 'Popular'
                              ? Colors.white
                              : Colors.black87,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // Apply button
              GestureDetector(
                onTap: () => Navigator.pop(ctx),
                child: Container(
                  height: 52,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF111111),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: Text(
                      'Apply Filters',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  // Filtered templates based on search query
  List get _filteredTemplates {
    if (_searchQuery.isEmpty) return templates;
    return templates.where((t) {
      final title = t.title.toString().toLowerCase();
      return title.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEEED),
      bottomNavigationBar: buildBottomNav(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              // Header row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'INDAR',
                    style: TextStyle(
                      fontSize: 46,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 6,
                      color: Color(0xFF111111),
                    ),
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: const Icon(
                      Icons.notifications_none_rounded,
                      color: Color(0xFF111111),
                      size: 22,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 4),

              // ← Real username from API
              Text(
                _userName.isEmpty ? 'Hi there ' : 'Hi, $_userName ',
                style: const TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 65, 64, 64),
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 22),

              // Search bar — now functional
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 14),
                          const Icon(Icons.search,
                              color: Color(0xFF999999), size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: (v) =>
                                  setState(() => _searchQuery = v),
                              style: const TextStyle(
                                  fontSize: 14, color: Color(0xFF111111)),
                              decoration: const InputDecoration(
                                hintText: 'Search templates...',
                                hintStyle: TextStyle(
                                    color: Color(0xFF999999), fontSize: 14),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                          // Clear button
                          if (_searchQuery.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                              child: const Padding(
                                padding: EdgeInsets.only(right: 12),
                                child: Icon(Icons.close,
                                    color: Color(0xFF999999), size: 18),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Filter button — opens sheet
                  GestureDetector(
                    onTap: _showFilterSheet,
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: _activeFilter != null
                            ? const Color(0xFF111111)
                            : const Color(0xFF111111),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(Icons.tune_rounded,
                              color: Colors.white, size: 20),
                          // Dot indicator when filter is active
                          if (_activeFilter != null)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.orange,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Active filter chip
              if (_activeFilter != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF111111),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _activeFilter!,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 13),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () =>
                                setState(() => _activeFilter = null),
                            child: const Icon(Icons.close,
                                color: Colors.white, size: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 26),

              // Only show banners and Featured when not searching
              if (_searchQuery.isEmpty) ...[
                const Text(
                  'Featured',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF111111),
                  ),
                ),
                const SizedBox(height: 12),

                SizedBox(
                  height: 200,
                  child: PageView.builder(
                    controller: _bannerController,
                    itemCount: _banners.length,
                    onPageChanged: (i) =>
                        setState(() => _currentBanner = i),
                    itemBuilder: (context, index) {
                      final banner = _banners[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          right: index < _banners.length - 1 ? 12 : 0,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(banner['image']!,
                                  fit: BoxFit.cover),
                              Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: [0.4, 1.0],
                                    colors: [
                                      Colors.transparent,
                                      Color(0xCC000000),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 16,
                                left: 16,
                                child: Text(
                                  banner['label']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_banners.length, (i) {
                    final active = i == _currentBanner;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: active ? 18 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: active
                            ? const Color(0xFF111111)
                            : const Color(0xFFCCCCCC),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 26),
              ],

              // Templates label — shows result count when searching
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Templates',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF111111),
                    ),
                  ),
                  if (_searchQuery.isNotEmpty)
                    Text(
                      '${_filteredTemplates.length} results',
                      style: const TextStyle(
                          fontSize: 13, color: Color(0xFF999999)),
                    ),
                ],
              ),

              const SizedBox(height: 14),

              // No results
              if (_filteredTemplates.isEmpty)
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off,
                            size: 28,
                            color: Colors.black.withOpacity(0.25)),
                        const SizedBox(height: 8),
                        Text(
                          'No templates found for "$_searchQuery"',
                          style: const TextStyle(
                              color: Color(0xFF999999), fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _filteredTemplates.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.85,
                  ),
                  itemBuilder: (context, index) {
                    return _templateCard(
                        context, _filteredTemplates[index]);
                  },
                ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _templateCard(BuildContext context, dynamic template) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TemplatePage(template: template),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              _imageForTemplate(template.title),
              fit: BoxFit.cover,
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.45, 1.0],
                  colors: [Colors.transparent, Color(0xCC000000)],
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 12,
              child: Text(
                template.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
