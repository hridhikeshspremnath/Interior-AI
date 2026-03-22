import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ARViewPage extends StatelessWidget {
  final String assetName;
  final String elementName;
  final String category;

  const ARViewPage({
    super.key,
    required this.assetName,
    required this.elementName,
    required this.category,
  });

  String get _modelUrl {
    final encoded = Uri.encodeComponent(assetName);
    return 'https://ivvpwwzlseboyumapyai.supabase.co/storage/v1/object/public/assets/3d/$encoded.glb';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [

          // ── 3D Model Viewer ──────────────────────────────────
          ModelViewer(
  src: _modelUrl,          // ← your Supabase HTTPS URL directly
  alt: elementName,
  ar: true,
  arModes: const ['scene-viewer', 'webxr', 'quick-look'],
  autoRotate: true,
  cameraControls: true,
  backgroundColor: const Color(0xFF1a1a1a),
  arScale: ArScale.auto,
  arPlacement: ArPlacement.floor,  // ← add this
  relatedJs: '''
    const modelViewer = document.querySelector('model-viewer');
    modelViewer.addEventListener('ar-status', (event) => {
      console.log('AR status:', event.detail.status);
    });
  ''',
),

          // ── Top bar ──────────────────────────────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            right: 16,
            child: Row(
              children: [
                // Back button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 18),
                  ),
                ),
                const SizedBox(width: 12),

                // Title
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          category == 'Hanging'
                              ? Icons.light_outlined
                              : category == 'Wall'
                                  ? Icons.wallpaper_outlined
                                  : Icons.weekend_outlined,
                          color: Colors.white54,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                elementName,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                category,
                                style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── AR hint at bottom ─────────────────────────────────
          
        ],
      ),
    );
  }
}