import 'package:flutter/material.dart';
import '../models/template_model.dart';
import '../widgets/bottom_nav.dart';

class RatingPage extends StatelessWidget {

  final TemplateModel template;

  const RatingPage({super.key, required this.template});

  @override
  Widget build(BuildContext context) {

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

          Text(
            "${template.title} Rating",
            style: const TextStyle(fontSize: 20),
          ),

          const SizedBox(height: 10),

          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star),
              Icon(Icons.star),
              Icon(Icons.star),
              Icon(Icons.star),
              Icon(Icons.star_border),
            ],
          ),
        ],
      ),
    );
  }
}
