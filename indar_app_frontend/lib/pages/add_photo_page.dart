import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../widgets/bottom_nav.dart';
import '../providers/image_provider.dart';
import 'theme_page.dart';

class AddPhotoPage extends StatefulWidget {
  const AddPhotoPage({super.key});

  @override
  State<AddPhotoPage> createState() => _AddPhotoPageState();
}

class _AddPhotoPageState extends State<AddPhotoPage> {
  final TransformationController _controller = TransformationController();
  final ImagePicker _picker = ImagePicker();

  void _handleDoubleTap() {
    if (_controller.value != Matrix4.identity()) {
      _controller.value = Matrix4.identity();
    } else {
      _controller.value = Matrix4.identity()..scale(2.0);
    }
  }

  Future<void> _pickFromCamera() async {
    final photo = await _picker.pickImage(
        source: ImageSource.camera, imageQuality: 85);
    if (photo != null && mounted) {
      Provider.of<ImageProviderModel>(context, listen: false).setImage(photo);
      setState(() {});
    }
  }

  Future<void> _pickFromGallery() async {
    final photo = await _picker.pickImage(
        source: ImageSource.gallery, imageQuality: 85);
    if (photo != null && mounted) {
      Provider.of<ImageProviderModel>(context, listen: false).setImage(photo);
      setState(() {});
    }
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xfff3f3f3),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.camera_alt_outlined, size: 20),
              ),
              title: const Text('Take Photo',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              onTap: () { Navigator.pop(context); _pickFromCamera(); },
            ),
            ListTile(
              leading: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.photo_library_outlined, size: 20),
              ),
              title: const Text('Choose from Gallery',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              onTap: () { Navigator.pop(context); _pickFromGallery(); },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final image = context.watch<ImageProviderModel>().image;

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
                      Text('Step 1 of 3',
                          style: TextStyle(
                              fontSize: 12, color: Colors.black45)),
                      Text('Add a Room Photo',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: 0.33,
                  minHeight: 6,
                  backgroundColor: Colors.grey.shade200,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 8),
              Text('Upload a clear photo of your room',
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.black.withOpacity(0.45))),

              const SizedBox(height: 20),

              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: image == null
                      ? _buildEmptyState()
                      : _buildImageState(image),
                ),
              ),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: image == null
                    ? null
                    : () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ThemePage()),
                        ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 55,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: image == null
                        ? Colors.grey.shade300
                        : Colors.black,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: image == null
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

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 64, height: 64,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.06),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(Icons.add_photo_alternate_outlined,
              size: 28, color: Colors.black45),
        ),
        const SizedBox(height: 16),
        const Text('Add a room photo',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Text('Take a photo or choose from gallery',
            style: TextStyle(
                fontSize: 13, color: Colors.black.withOpacity(0.4))),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: _showImageOptions,
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Text('Add Photo',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500)),
          ),
        ),
      ],
    );
  }

  Widget _buildImageState(dynamic image) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          GestureDetector(
            onDoubleTap: _handleDoubleTap,
            child: InteractiveViewer(
              transformationController: _controller,
              minScale: 0.5,
              maxScale: 4,
              child: kIsWeb
                  ? Image.network(image.path,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.contain)
                  : Image.file(File(image.path),
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.contain),
            ),
          ),
          Positioned(
            bottom: 15, right: 15,
            child: GestureDetector(
              onTap: _showImageOptions,
              child: Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.edit_outlined,
                    color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}