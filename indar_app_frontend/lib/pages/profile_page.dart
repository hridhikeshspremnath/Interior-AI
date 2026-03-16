import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';
import 'onboarding_page.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? _user;
  List<dynamic> _rooms = [];
  bool _isLoading = true;

  bool _accountExpanded = false;
  bool _historyExpanded = false;
  bool _settingsExpanded = false;
  bool _faqExpanded = false;
  bool _policyExpanded = false;

  // Track which FAQ item is open
  int? _openFaqIndex;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final user = await ApiService.get('/api/auth/me');
      final rooms = await ApiService.get('/api/rooms/');
      if (mounted) {
        setState(() {
          _user = user;
          _rooms = rooms is List ? rooms : [];
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Profile load error: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleLogout() async {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: const Color(0xfff3f3f3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Sign out?',
          style: TextStyle(fontWeight: FontWeight.w600)),
      content: const Text(
        'You will need to sign in again to access your designs.',
        style: TextStyle(color: Colors.black54),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel', style: TextStyle(color: Colors.black54)),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(ctx);
            await AuthService.logout();
            // Navigate to onboarding after logout
            if (mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const OnboardingPage()),
                (route) => false,
              );
            }
          },
          child: const Text('Sign out', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}

  static const List<Map<String, String>> _faqItems = [
    {
      'q': 'How does Indar generate room designs?',
      'a':
          'Indar uses AI to analyse your room photo and detect wall, floor, and ceiling surfaces. It then suggests festive decorations from our curated product catalogue and generates a visualised decorated room image.',
    },
    {
      'q': 'What themes are available?',
      'a':
          'We currently support Onam, Christmas, Diwali, Halloween, Birthday, and Pop-Culture themes. We regularly update our catalogue with new products and themes.',
    },
    {
      'q': 'How do I buy the products in my design?',
      'a':
          'After generating a design, tap "View Bundle" to see all matched products. Tap "Buy on Amazon" to open your cart on Amazon India with all items pre-added — just proceed to checkout.',
    },
    {
      'q': 'Can I use AR to preview decorations?',
      'a':
          'Yes! Each product in your bundle includes 3D model data. Use the AR view to place items in your real room using your phone camera before purchasing.',
    },
    {
      'q': 'Is my room photo stored?',
      'a':
          'Yes — your room photos are securely stored in your personal account and are never shared with other users. You can delete any room from your board at any time.',
    },
    {
      'q': 'Why is the generated image sometimes missing?',
      'a':
          'Image generation uses AI models that occasionally take time to warm up. If the image is null, try regenerating the design — it usually succeeds on a second attempt.',
    },
    {
      'q': 'How do I change my display name?',
      'a':
          'Go to Profile → Account → Edit Name. Changes are saved immediately to your account.',
    },
  ];

  static const String _privacyPolicy = '''
Last updated: March 2026

1. Information We Collect
We collect your email address and name when you create an account. We also store room photos you upload, generated designs, and purchase history associated with your account.

2. How We Use Your Information
Your data is used to provide personalised room design recommendations, generate AI-powered décor suggestions, and facilitate product purchases via Amazon India.

3. Data Storage
All user data is stored securely using Supabase infrastructure with encryption at rest and in transit. Room photos are stored in private cloud storage accessible only to your account.

4. Third-Party Services
We use the following third-party services:
- Supabase — authentication and database
- HuggingFace — AI image analysis and generation
- Amazon India — product fulfilment and cart
- Supabase Storage — image and 3D asset hosting

5. Data Sharing
We do not sell or share your personal data with third parties except as necessary to provide the services listed above.

6. Your Rights
You may request deletion of your account and all associated data at any time by contacting us. Upon deletion, your room photos, designs, and personal information will be permanently removed within 30 days.

7. Cookies
We use session tokens to keep you logged in. No advertising or tracking cookies are used.

8. Contact
For privacy-related queries, contact us at privacy@indar.app
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f3f3),
      bottomNavigationBar: buildBottomNav(context),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.black))
          : RefreshIndicator(
              onRefresh: _loadData,
              color: Colors.black,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _buildHeader()),
                  SliverToBoxAdapter(child: _buildBoardSection()),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        children: [
                          const SizedBox(height: 30),

                          // ── Account ──────────────────────────────
                          _buildCollapsibleItem(
                            title: 'Account',
                            icon: Icons.person_outline,
                            isExpanded: _accountExpanded,
                            onTap: () => setState(
                                () => _accountExpanded = !_accountExpanded),
                            children: [
                              _expandedTile(Icons.badge_outlined, 'Name',
                                  _user?['name'] ?? 'Not set'),
                              _expandedTile(Icons.email_outlined, 'Email',
                                  _user?['email'] ?? '—'),
                              _expandedTile(Icons.fingerprint, 'User ID',
                                  _shortId(_user?['user_id'])),
                              _expandedTile(
                                  Icons.calendar_today_outlined,
                                  'Member since',
                                  _formatDate(_user?['created_at'])),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: _showEditNameDialog,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.edit_outlined,
                                          color: Colors.white, size: 16),
                                      SizedBox(width: 8),
                                      Text('Edit Name',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),

                          const Divider(thickness: 1),

                          // ── Transaction History ───────────────────
                          _buildCollapsibleItem(
                            title: 'Transaction History',
                            icon: Icons.receipt_long_outlined,
                            isExpanded: _historyExpanded,
                            onTap: () => setState(
                                () => _historyExpanded = !_historyExpanded),
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: Center(
                                  child: Text(
                                    'No transactions yet.',
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.4),
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const Divider(thickness: 1),

                          // ── Settings ──────────────────────────────
                          _buildCollapsibleItem(
                            title: 'Settings',
                            icon: Icons.settings_outlined,
                            isExpanded: _settingsExpanded,
                            onTap: () => setState(
                                () => _settingsExpanded = !_settingsExpanded),
                            children: [
                              _settingsTile(
                                Icons.notifications_outlined,
                                'Notifications',
                                trailing: Switch(
                                    value: true,
                                    onChanged: (_) {},
                                    activeColor: Colors.black),
                              ),
                              _settingsTile(
                                Icons.dark_mode_outlined,
                                'Dark Mode',
                                trailing: Switch(
                                    value: false,
                                    onChanged: (_) {},
                                    activeColor: Colors.black),
                              ),
                            ],
                          ),

                          const Divider(thickness: 1),

                          // ── FAQ ───────────────────────────────────
                          _buildCollapsibleItem(
                            title: 'FAQ',
                            icon: Icons.help_outline,
                            isExpanded: _faqExpanded,
                            onTap: () => setState(
                                () => _faqExpanded = !_faqExpanded),
                            children: List.generate(
                              _faqItems.length,
                              (i) => _buildFaqItem(i),
                            ),
                          ),

                          const Divider(thickness: 1),

                          // ── Privacy Policy ────────────────────────
                          _buildCollapsibleItem(
                            title: 'Privacy Policy',
                            icon: Icons.privacy_tip_outlined,
                            isExpanded: _policyExpanded,
                            onTap: () => setState(
                                () => _policyExpanded = !_policyExpanded),
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 4, bottom: 12),
                                child: Text(
                                  _privacyPolicy,
                                  style: TextStyle(
                                    fontSize: 13,
                                    height: 1.7,
                                    color: Colors.black.withOpacity(0.65),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const Divider(thickness: 1),

                          const SizedBox(height: 28),

                          // ── Logout Button ─────────────────────────
                          GestureDetector(
                            onTap: _handleLogout,
                            child: Container(
                              height: 52,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                    color: Colors.red.shade200),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.logout,
                                      color: Colors.red.shade400, size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Sign Out',
                                    style: TextStyle(
                                      color: Colors.red.shade400,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // App version
                          Center(
                            child: Text(
                              'Indar v1.0.0',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black.withOpacity(0.25),
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // ── FAQ individual item (nested collapsible) ────────────────────
  Widget _buildFaqItem(int index) {
    final item = _faqItems[index];
    final isOpen = _openFaqIndex == index;
    return Column(
      children: [
        GestureDetector(
          onTap: () =>
              setState(() => _openFaqIndex = isOpen ? null : index),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item['q']!,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: isOpen ? 0.25 : 0,
                  duration: const Duration(milliseconds: 150),
                  child: Icon(Icons.arrow_forward_ios,
                      size: 12,
                      color: Colors.black.withOpacity(0.4)),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              item['a']!,
              style: TextStyle(
                fontSize: 13,
                height: 1.6,
                color: Colors.black.withOpacity(0.55),
              ),
            ),
          ),
          crossFadeState:
              isOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 150),
        ),
        if (index < _faqItems.length - 1)
          Divider(thickness: 0.5, color: Colors.black.withOpacity(0.08)),
      ],
    );
  }

  // ── Header ──────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(
        left: 25,
        right: 25,
        top: MediaQuery.of(context).padding.top + 20,
        bottom: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PROFILE',
            style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    _getInitials(
                        _user?['name'] ?? _user?['email'] ?? '?'),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _user?['name'] ?? 'No name set',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _user?['email'] ?? '—',
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.black.withOpacity(0.45)),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.07),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Member since ${_formatDate(_user?['created_at'])}',
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.black.withOpacity(0.5)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Board section ───────────────────────────────────────────────
  Widget _buildBoardSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Your Board',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500)),
              Text('${_rooms.length} rooms',
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.black.withOpacity(0.4))),
            ],
          ),
          const SizedBox(height: 15),
          _rooms.isEmpty
              ? Container(
                  height: 90,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Center(
                    child: Text(
                      'No rooms yet. Upload your first room!',
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.4),
                          fontSize: 13),
                    ),
                  ),
                )
              : SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _rooms.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(width: 12),
                    itemBuilder: (_, i) {
                      final room = _rooms[i];
                      final imageUrl = room['image_url'];
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          children: [
                            imageUrl != null
                                ? Image.network(
                                    imageUrl,
                                    height: 100,
                                    width: 140,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        _roomPlaceholder(),
                                  )
                                : _roomPlaceholder(),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 5),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.7),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                                child: Text(
                                  room['room_name'] ?? '',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget _roomPlaceholder() {
    return Container(
      height: 100,
      width: 140,
      color: Colors.black.withOpacity(0.08),
      child: Center(
        child: Icon(Icons.meeting_room_outlined,
            color: Colors.black.withOpacity(0.3), size: 28),
      ),
    );
  }

  // ── Collapsible section ─────────────────────────────────────────
  Widget _buildCollapsibleItem({
    required String title,
    required IconData icon,
    required bool isExpanded,
    required VoidCallback onTap,
    required List<Widget> children,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              children: [
                Icon(icon, size: 20, color: Colors.black87),
                const SizedBox(width: 12),
                Expanded(
                    child: Text(title,
                        style: const TextStyle(fontSize: 16))),
                AnimatedRotation(
                  turns: isExpanded ? 0.25 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(Icons.arrow_forward_ios, size: 16),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 32, bottom: 8),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children),
          ),
          crossFadeState: isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
      ],
    );
  }

  Widget _expandedTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.black45),
          const SizedBox(width: 10),
          Text('$label:',
              style: TextStyle(
                  fontSize: 13, color: Colors.black.withOpacity(0.45))),
          const SizedBox(width: 8),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Widget _settingsTile(IconData icon, String title, {Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.black54),
          const SizedBox(width: 10),
          Expanded(
              child: Text(title, style: const TextStyle(fontSize: 14))),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  void _showEditNameDialog() {
    final controller =
        TextEditingController(text: _user?['name'] ?? '');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xfff3f3f3),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: const Text('Edit Name',
            style: TextStyle(fontWeight: FontWeight.w600)),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Your name',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.black54)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final name = controller.text.trim();
              if (name.isEmpty) return;
              await AuthService.updateName(name);
              await _loadData();
            },
            child: const Text('Save',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  String _getInitials(String input) {
    final parts = input.split(RegExp(r'[\s@]'));
    if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return input.isNotEmpty ? input[0].toUpperCase() : '?';
  }

  String _shortId(String? id) {
    if (id == null || id.length < 8) return '—';
    return '${id.substring(0, 8)}...';
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '—';
    try {
      final dt = DateTime.parse(dateStr);
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return '—';
    }
  }
}
