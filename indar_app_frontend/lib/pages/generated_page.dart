import 'package:flutter/material.dart';
import '../models/cart_model.dart';
import 'cart_page.dart';
import 'edit_elements_page.dart';
import '../widgets/bottom_nav.dart';
import 'package:provider/provider.dart';
import '../providers/image_provider.dart';
import '../providers/theme_provider.dart';
import '../services/ai_service.dart';
import '../services/image_upload_service.dart';
import 'package:image_picker/image_picker.dart';

class GeneratedPage extends StatefulWidget {
  const GeneratedPage({super.key});

  @override
  State<GeneratedPage> createState() => _GeneratedPageState();
}

class _GeneratedPageState extends State<GeneratedPage> {

  String? generatedImage;
  bool loading = true;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      generateAI();
    });
  }

Future<void> generateAI() async {

  final theme = context.read<ThemeProviderModel>();
  final imageProvider = context.read<ImageProviderModel>();

  final XFile? image = imageProvider.image;

  if (image == null) {
    print("No image selected");
    return;
  }

  setState(() {
    loading = true;
  });

  /// Convert XFile → File
 // File file = File(image.path);

  /// Upload image
  final uploadedUrl =
      await ImageUploadService.uploadImage(image);
  print(uploadedUrl);
  
  if (uploadedUrl == null) {

    setState(() {
      loading = false;
    });

    print("Image upload failed");
    return;
  }

  /// Generate decorated room
  final result = await AIService.generateImage(
    prompt: theme.description ?? "",
    imageUrl: uploadedUrl,
  );

  setState(() {
    generatedImage = result;
    loading = false;
  });
}

  @override
  Widget build(BuildContext context) {

    final theme = context.watch<ThemeProviderModel>();
    final image = context.watch<ImageProviderModel>().image;

    return Scaffold(
      backgroundColor: const Color(0xfff3f3f3),
      bottomNavigationBar: buildBottomNav(context),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),

            child: Column(
              children: [

                const SizedBox(height: 20),

                const Text(
                  "Step 3/3",
                  style: TextStyle(fontSize: 18),
                ),

                const SizedBox(height: 20),

                /// Uploaded Image
                Image.network(
                  image!.path,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),

                const SizedBox(height: 20),

                /// Theme Description
                Text(
                  theme.description ?? "No theme selected",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 15),

                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: 1,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade300,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 15),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("image generated"),
                ),

                const SizedBox(height: 10),

                /// Generated Image
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey.shade300,
                  ),

                  child: loading
                      ? const Center(child: CircularProgressIndicator())
                      : generatedImage == null
                          ? const Center(child: Text("Generating AI design..."))
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                generatedImage!,
                                fit: BoxFit.contain,
                              ),
                            )
                ),

                const SizedBox(height: 20),

                /// Elements Box
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [

                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Elements"),
                          Text("view in AR"),
                        ],
                      ),

                      const SizedBox(height: 15),

                      _elementRow(context),

                      const SizedBox(height: 10),

                      _elementRow(context),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                /// Buttons
                Row(
                  children: [

                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const EditElementsPage(),
                            ),
                          );
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(child: Text("Edit")),
                        ),
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CartPage(),
                            ),
                          );
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(child: Text("Finish")),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30)
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _elementRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        const Text("some element"),

        Row(
          children: [

            GestureDetector(
              onTap: () {
                CartModel.addItem("Chair",120);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditElementsPage(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),

            const SizedBox(width: 10),

            GestureDetector(
              onTap: () {
                CartModel.removeItem("Chair");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditElementsPage(),
                  ),
                );
              },
              child: const Icon(Icons.remove),
            ),

            const SizedBox(width: 10),

            const Icon(Icons.remove_red_eye),
          ],
        ),
      ],
    );
  }
}