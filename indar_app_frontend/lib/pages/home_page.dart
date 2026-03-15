import 'package:flutter/material.dart';
//import 'add_photo_page.dart';
import '../widgets/bottom_nav.dart';
import '../data/templates.dart';
import 'template_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f3f3),
      bottomNavigationBar: buildBottomNav(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 20),

              // Header
              const Text(
                "INDAR",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 5),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Hi, Username",
                    style: TextStyle(fontSize: 20),
                  ),
                  Icon(Icons.notifications_none, size: 28),
                ],
              ),

              const SizedBox(height: 20),

              // Search Bar
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Row(
                        children: [
                          SizedBox(width: 15),
                          Icon(Icons.search),
                          SizedBox(width: 10),
                          Text("Search Template"),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.tune, color: Colors.white),
                  )
                ],
              ),

              const SizedBox(height: 25),

              // Banner Slider (Static version for now)
              Container(
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/room.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.all(15),
                child: const Text(
                  "New Template",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 10),

              const Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.circle, size: 8),
                    SizedBox(width: 5),
                    Icon(Icons.circle_outlined, size: 8),
                    SizedBox(width: 5),
                    Icon(Icons.circle_outlined, size: 8),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                "Templates",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 15),

              // Grid Templates
              GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: templates.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                  ),
                  itemBuilder: (context, index) {
                    return _templateCard(context, templates[index]);
                  },
                ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

static Widget _templateCard(BuildContext context, template) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TemplatePage(template: template),
        ),
      );
    },
    child: ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(template.image, fit: BoxFit.cover),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: Text(
              template.title,
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

  /*Widget _buildBottomNav(BuildContext context) {
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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddPhotoPage(),
              ),
            );
          },
          child:
              const Icon(Icons.add_circle_outline, color: Colors.white),
        ),

        const Icon(Icons.star_border, color: Colors.white),
        const Icon(Icons.person_outline, color: Colors.white),
      ],
    ),
  );
  }*/
}