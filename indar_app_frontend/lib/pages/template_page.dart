import 'package:flutter/material.dart';
import '../models/template_model.dart';
import '../widgets/bottom_nav.dart';
import 'elements_page.dart';
import 'rating_page.dart';

class TemplatePage extends StatelessWidget {

  final TemplateModel template;

  const TemplatePage({super.key, required this.template});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: buildBottomNav(context),

      body: SingleChildScrollView(
        child: Column(
          children: [

            Stack(
              children: [

                Image.asset(
                  template.image,
                  height: 350,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),

                Positioned(
                  top: 60,
                  left: 20,
                  child: Text(
                    template.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                const Text("Description"),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ElementsPage(template: template),
                      ),
                    );
                  },
                  child: const Text("Elements"),
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RatingPage(template: template),
                      ),
                    );
                  },
                  child: const Text("Rating"),
                ),
              ],
            ),

            const Divider(),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(template.description),
            ),
          ],
        ),
      ),
    );
  }
}