import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_page.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/images/OnBoarding.jpg',
            fit: BoxFit.cover,
          ),

          // Subtle dark gradient only at the bottom for button readability
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.5, 1.0],
                  colors: [
                    Colors.transparent,
                    Color(0xCC000000),
                  ],
                ),
              ),
            ),
          ),

          // Slide button pinned to bottom
          Positioned(
            left: 24,
            right: 24,
            bottom: 60,
            child: _SlideToStart(
              onSlideComplete: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginPage(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SlideToStart extends StatefulWidget {
  final VoidCallback onSlideComplete;
  const _SlideToStart({required this.onSlideComplete});

  @override
  State<_SlideToStart> createState() => _SlideToStartState();
}

class _SlideToStartState extends State<_SlideToStart> {
  double _dragX = 0;
  bool _triggered = false;

  static const double _thumbSize = 52;
  static const double _padding = 5;
  static const double _trackHeight = 62;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxDrag = constraints.maxWidth - _thumbSize - _padding * 2;
        final progress = (_dragX / maxDrag).clamp(0.0, 1.0);

        return Container(
          height: _trackHeight,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.18),
            borderRadius: BorderRadius.circular(_trackHeight / 2),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 0.8,
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Subtle fill trail behind thumb
              Positioned.fill(
                child: LayoutBuilder(
                  builder: (_, c) => AnimatedContainer(
                    duration: _dragX == 0
                        ? const Duration(milliseconds: 350)
                        : Duration.zero,
                    curve: Curves.easeOut,
                    width: (_padding + _dragX + _thumbSize)
                        .clamp(0.0, c.maxWidth),
                    decoration: BoxDecoration(
                      color:
                          Colors.white.withOpacity((0.08 * progress * 5).clamp(0.0, 0.15)),
                      borderRadius: BorderRadius.circular(_trackHeight / 2),
                    ),
                  ),
                ),
              ),

              // Label fades as thumb moves right
              Center(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 80),
                  opacity: (1.0 - progress * 2.2).clamp(0.0, 1.0),
                  child: Text(
                    'slide to get started',
                    style: GoogleFonts.dmSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.85),
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ),

              // Draggable thumb
              AnimatedPositioned(
                duration: _dragX == 0
                    ? const Duration(milliseconds: 350)
                    : Duration.zero,
                curve: Curves.easeOut,
                left: _padding + _dragX,
                top: _padding,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    if (_triggered) return;
                    setState(() {
                      _dragX =
                          (_dragX + details.delta.dx).clamp(0.0, maxDrag);
                    });
                  },
                  onHorizontalDragEnd: (_) {
                    if (_triggered) return;
                    if (_dragX >= maxDrag * 0.82) {
                      setState(() {
                        _dragX = maxDrag;
                        _triggered = true;
                      });
                      widget.onSlideComplete();
                      Future.delayed(const Duration(milliseconds: 700), () {
                        if (mounted) {
                          setState(() {
                            _dragX = 0;
                            _triggered = false;
                          });
                        }
                      });
                    } else {
                      setState(() => _dragX = 0);
                    }
                  },
                  child: Container(
                    width: _thumbSize,
                    height: _thumbSize,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(_thumbSize / 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Color(0xFF1A1208),
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
