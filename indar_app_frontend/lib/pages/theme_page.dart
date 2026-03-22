import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/bottom_nav.dart';
import '../providers/image_provider.dart';
import '../providers/theme_provider.dart';
import '../data/themes.dart';
import 'GeneratedPage.dart';

class ThemePage extends StatefulWidget {
  const ThemePage({super.key});

  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  bool _isGenerating = false;
  String _status = '';

// Update this line in ThemePage.dart
static const String _baseUrl = 'http://192.168.1.103:8000';

  // Map theme title to API theme name
  String _apiThemeName(String title) {
    const map = {
      'Diwali': 'Diwali',
      'Christmas': 'Christmas',
      'Halloween': 'Halloween',
      'Birthday': 'Birthday',
      'Onam': 'onam',
      'Party': 'Birthday',    // fallback
      'Wedding': 'onam',      // fallback
    };
    return map[title] ?? title;
  }

  Future<void> _handleContinue() async {
    final themeProvider =
        Provider.of<ThemeProviderModel>(context, listen: false);
    final imageProvider =
        Provider.of<ImageProviderModel>(context, listen: false);

    if (themeProvider.selectedTheme == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a theme first.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (imageProvider.image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No image found. Please go back and add a photo.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final token =
        Supabase.instance.client.auth.currentSession?.accessToken;
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not logged in.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final themeName = _apiThemeName(themeProvider.selectedTheme!);
    setState(() {
      _isGenerating = true;
      _status = 'Uploading your room photo...';
    });

    try {
      // Step 1: Upload room photo
      final uploadRequest = http.MultipartRequest(
        'POST', Uri.parse('$_baseUrl/api/rooms/'),
      );
      uploadRequest.headers['Authorization'] = 'Bearer $token';
      uploadRequest.fields['room_name'] = '${themeProvider.selectedTheme} Room';
      uploadRequest.fields['type'] = 'living_room';
      uploadRequest.files.add(
        await http.MultipartFile.fromPath(
            'image', imageProvider.image!.path),
      );

      final uploadResponse = await uploadRequest.send();
      final uploadBody = await uploadResponse.stream.bytesToString();

      if (uploadResponse.statusCode != 201) {
        throw Exception('Upload failed: $uploadBody');
      }
      final room = jsonDecode(uploadBody);
      final roomId = room['room_id'];

      // Step 2: Generate design
      setState(() =>
          _status = 'AI is analysing your room...\n(~30 seconds)');

      final designResponse = await http.post(
        Uri.parse('$_baseUrl/api/designs/generate'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'room_id': roomId,
          'theme_name': themeName,
          'style': null,
        }),
      );

      if (designResponse.statusCode != 201) {
        throw Exception('Design generation failed: ${designResponse.body}');
      }
      final design = jsonDecode(designResponse.body);

      // Step 3: Get bundle
      setState(() => _status = 'Building your product bundle...');

      final bundleResponse = await http.get(
        Uri.parse(
            '$_baseUrl/api/designs/${design['design_id']}/bundle'),
        headers: {'Authorization': 'Bearer $token'},
      );

      Map<String, dynamic>? bundle;
      if (bundleResponse.statusCode == 200) {
        bundle = jsonDecode(bundleResponse.body);
      }

      // Step 4: Navigate to GeneratedPage
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => GeneratedPage(
              design: design,
              bundle: bundle,
              themeName: themeProvider.selectedTheme!,
            ),
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
      if (mounted) {
        setState(() => _isGenerating = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red.shade800,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProviderModel>();

    return Scaffold(
      backgroundColor: const Color(0xfff3f3f3),
      bottomNavigationBar: buildBottomNav(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Header
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
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Step 2 of 3',
                          style: TextStyle(
                              fontSize: 12, color: Colors.black45)),
                      Text('Choose a Theme',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: 0.66,
                  minHeight: 6,
                  backgroundColor: Colors.grey.shade200,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 6),
              Text(
                'Select a theme to transform your room',
                style: TextStyle(
                    fontSize: 13, color: Colors.black.withOpacity(0.45)),
              ),

              const SizedBox(height: 20),

              // Theme grid — or loading state
              Expanded(
                child: _isGenerating
                    ? _buildGeneratingState()
                    : GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 1.1,
                        children: [
                          'Diwali',
                          'Christmas',
                          'Halloween',
                          'Birthday',
                          'Onam',
                          'Wedding',
                        ]
                            .map((t) => _ThemeCard(
                                  title: t,
                                  isSelected:
                                      themeProvider.selectedTheme == t,
                                ))
                            .toList(),
                      ),
              ),

              // Description box
              if (!_isGenerating &&
                  themeProvider.selectedTheme != null) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.auto_awesome,
                            color: Colors.white, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          themeProvider.description ??
                              'Selected: ${themeProvider.selectedTheme}',
                          style: const TextStyle(
                              fontSize: 13, height: 1.4),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 14),

              // Continue button
              GestureDetector(
                onTap: _isGenerating ? null : _handleContinue,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 55,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: _isGenerating ||
                            themeProvider.selectedTheme == null
                        ? Colors.grey.shade300
                        : Colors.black,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      _isGenerating ? 'Generating...' : 'Continue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _isGenerating ||
                                themeProvider.selectedTheme == null
                            ? Colors.black38
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGeneratingState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
              color: Colors.black, strokeWidth: 2),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              _status,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 14, color: Colors.black54, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Theme Card ──────────────────────────────────────────────────
class _ThemeCard extends StatelessWidget {
  final String title;
  final bool isSelected;

  const _ThemeCard({required this.title, required this.isSelected});

  static String _imageForTheme(String title) {
    const map = {
      'Halloween': 'assets/images/Halloween.jpg',
      'Christmas': 'assets/images/Christmas.jpg',
      'Diwali': 'assets/images/Diwali.jpg',
      'Onam': 'assets/images/Onam.jpg',
      'Birthday': 'assets/images/Bday.jpg',
      'Wedding': 'assets/images/room.jpg',
      'Party': 'assets/images/Bday.jpg',
    };
    return map[title] ?? 'assets/images/room.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<ThemeProviderModel>().setTheme(
              title,
              themes[title] ?? '',
            );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.transparent,
            width: 3,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(13),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                _imageForTheme(title),
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(
                          isSelected ? 0.75 : 0.5),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Container(
                        width: 22, height: 22,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check,
                            color: Colors.black, size: 14),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}