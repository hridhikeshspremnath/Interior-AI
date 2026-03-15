import 'package:flutter/material.dart';
import 'generated_page.dart';
import '../widgets/bottom_nav.dart';
import 'package:provider/provider.dart';
import '../providers/image_provider.dart';
import '../providers/theme_provider.dart';
import '../data/themes.dart';

class ThemePage extends StatelessWidget {
   const ThemePage({super.key});

  

  @override
  Widget build(BuildContext context) {

        final themeProvider = context.watch<ThemeProviderModel>();

        Consumer<ImageProviderModel>(
      builder: (context, provider, child) {

        if (provider.image == null) {
          return const Text("No image selected");
        }

        return Image.network(
          provider.image!.path,
          fit: BoxFit.cover,
        );
      },
    );
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
                  "Step 2/3",
                  style: TextStyle(fontSize: 18),
                ),
              ),

              const SizedBox(height: 15),

              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: 0.75,
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade300,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 10),

              const Center(child: Text("Choose Theme")),

              const SizedBox(height: 5),

              const Center(
                child: Text(
                  "Select a Theme to decorate and see its transformed",
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 25),

              /// Theme Grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  children: const [
                    ThemeCard(title: "Diwali"),
                    ThemeCard(title: "Christmas"),
                    ThemeCard(title: "Halloween"),
                    ThemeCard(title: "Birthday"),
                    ThemeCard(title: "Party"),
                    ThemeCard(title: "Wedding"),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              /// Paragraph Input
             /* Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Describe how you want the room to look...",
                    border: InputBorder.none,
                  ),
                ),
              ),*/

              /*Consumer<ThemeProviderModel>(
                  builder: (context, themeProvider, child) {

                    return*/ Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: TextField(
                        maxLines: 3,

                        controller: TextEditingController(
                          text: themeProvider.description ??
                              "Select a theme to see description",
                        ),

                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  //},
                //),

              const SizedBox(height: 15),

              /// Continue Button
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GeneratedPage(),
                      ),
                    );
                },
                child: Container(
                  height: 55,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Center(
                    child: Text(
                      "Continue",
                      style: TextStyle(fontSize: 18),
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

  /*static Widget _buildBottomNav() {
    return Container(
      height: 70,
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(35),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.add_circle_outline, color: Colors.white),
          Icon(Icons.star_border, color: Colors.white),
          Icon(Icons.person_outline, color: Colors.white),
        ],
      ),
    );
  }*/
}

/// Theme Card Widget
class ThemeCard extends StatelessWidget {
  final String title;

  const ThemeCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {

        context.read<ThemeProviderModel>().setTheme(
          title,
          themes[title]!,
        );

      },

      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),

        child: Stack(
          children: [

            Positioned.fill(
              child: Image.asset(
                'assets/images/room.jpg',
                fit: BoxFit.cover,
              ),
            ),

            Positioned(
              bottom: 10,
              left: 10,
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
