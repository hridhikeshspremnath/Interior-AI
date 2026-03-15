import 'package:flutter/material.dart';
import '../models/template_model.dart';
import '../widgets/bottom_nav.dart';
import 'rating_page.dart';
import 'package:provider/provider.dart';
import '../providers/image_provider.dart';

class ElementsPage extends StatelessWidget {

  final TemplateModel template;

  const ElementsPage({super.key, required this.template});

  @override
  Widget build(BuildContext context) {
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
      bottomNavigationBar: buildBottomNav(context),

      body: Column(
        children: [

          Image.asset(
            template.image,
            height: 350,
            width: double.infinity,
            fit: BoxFit.cover,
          ),

          const SizedBox(height: 20),

          Wrap(
            spacing: 15,
            runSpacing: 15,
            children: template.elements.map((e) {

              return Container(
                height: 80,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(child: Text(e)),
              );

            }).toList(),
          ),

          const SizedBox(height: 20),

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
          )
        ],
      ),
    );
  }
}