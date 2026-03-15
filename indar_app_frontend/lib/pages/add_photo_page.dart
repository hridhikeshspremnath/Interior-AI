import 'dart:io';
import 'package:flutter/material.dart';
import 'theme_page.dart';
import '../widgets/bottom_nav.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/image_provider.dart';
import 'package:flutter/foundation.dart';

class AddPhotoPage extends StatefulWidget {
  const AddPhotoPage({super.key});

  @override
  State<AddPhotoPage> createState() => _AddPhotoPageState();
}

class _AddPhotoPageState extends State<AddPhotoPage> {

  final TransformationController _controller = TransformationController();
  File? selectedImage;
  final ImagePicker picker = ImagePicker();

  void _handleDoubleTap() {
    if (_controller.value != Matrix4.identity()) {
      // Reset zoom
      _controller.value = Matrix4.identity();
    } else {
      // Zoom in
      _controller.value = Matrix4.identity()..scale(2.0);
    }
  }

  /// Pick from camera
  Future pickFromCamera() async {
    final photo =
        await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      /*File img = File(photo.path);

      setState(() {
        selectedImage = img;
      });*/

      Provider.of<ImageProviderModel>(context, listen: false)
          .setImage(photo);
      
      setState(() {});
    }
  }

  /// Pick from gallery
  Future pickFromGallery() async {
    final photo =
        await picker.pickImage(source: ImageSource.gallery);

    if (photo != null) {
      /*File img = File(photo.path);

      setState(() {
        selectedImage = img;
      });*/

      Provider.of<ImageProviderModel>(context, listen: false)
          .setImage(photo);

      setState(() {});
    }
  }

  /// Show options
  void showImageOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 160,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Take Photo"),
                onTap: () {
                  Navigator.pop(context);
                  pickFromCamera();
                },
              ),

              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Choose from Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  pickFromGallery();
                },
              ),
            ],
          ),
        );
      },
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

              const Center(
                child: Text(
                  "Step 1/3",
                  style: TextStyle(fontSize: 18),
                ),
              ),

              const SizedBox(height: 15),

              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: 0.25,
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade300,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 10),

              const Text("add a photo"),

              const SizedBox(height: 30),

              /// PHOTO BOX
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade400),
                  ),

                  child: image == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            const Text(
                              "Start Decorating",
                              style: TextStyle(fontSize: 16),
                            ),

                            const SizedBox(height: 15),

                            const Text(
                              "ADD PHOTOS",
                              style: TextStyle(
                                fontSize: 26,
                                letterSpacing: 2,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const SizedBox(height: 25),

                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.black,
                              child: IconButton(
                                icon: const Icon(Icons.add, color: Colors.white),
                                onPressed: showImageOptions,
                              ),
                            ),
                          ],
                        )

                      /// IMAGE DISPLAYED INSIDE BOX
                      : ClipRRect(
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
                                    ? Image.network(
                                        image.path,
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.contain,
                                      )
                                    : Image.file(
                                        File(image.path),
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.contain,
                                      ),
                                ),
                              ),

                              Positioned(
                                bottom: 15,
                                right: 15,
                                child: CircleAvatar(
                                  backgroundColor: Colors.black,
                                  child: IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.white),
                                    onPressed: showImageOptions,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 30),

              /// CONTINUE BUTTON
              GestureDetector(
                onTap: () {
                  if (image == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please upload a photo first"),
                        ),
                      );
                      return;
                    }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ThemePage(),
                    ),
                  );
                },
                child: Container(
                  height: 55,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: image == null ?  Colors.grey.shade300 : Colors.black,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      "Continue",
                      style: TextStyle(fontSize: 18,color: image == null ? Colors.black45 : Colors.white),
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
}
  /*static Widget _buildBottomNav(BuildContext context) {
    return Container(
      height: 70,
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(35),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Icon(Icons.home, color: Colors.white),

          GestureDetector(
            onTap: () {}, // already on this page
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white24,
              ),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),

          const Icon(Icons.star_border, color: Colors.white),
          const Icon(Icons.person_outline, color: Colors.white),
        ],
      ),
    );
  }*/
