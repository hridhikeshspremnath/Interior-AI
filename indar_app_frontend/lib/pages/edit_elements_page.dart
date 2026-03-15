import 'package:flutter/material.dart';
import 'cart_page.dart';
import '../widgets/bottom_nav.dart';

class EditElementsPage extends StatelessWidget {
  const EditElementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f3f3),
      bottomNavigationBar: buildBottomNav(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 20),

                const Center(
                  child: Text(
                    "Step 3/3",
                    style: TextStyle(fontSize: 18),
                  ),
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

                const SizedBox(height: 10),

                const Align(
                  alignment: Alignment.centerRight,
                  child: Text("Edit"),
                ),

                const SizedBox(height: 15),

                const Text("image generated"),

                const SizedBox(height: 10),

                /// Generated Image
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey.shade300,
                  ),
                ),

                const SizedBox(height: 20),

                /// Elements Box
                _elementsBox(),

                const SizedBox(height: 20),

                /// Suggested Elements
                _suggestedBox(),

                const SizedBox(height: 30),

                /// Buttons
                Row(
                  children: [

                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(child: Text("Edit")),
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
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

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Elements container
  static Widget _elementsBox() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text("Elements"),

          const SizedBox(height: 15),

          _elementRow(),
          const SizedBox(height: 10),
          _elementRow(),
        ],
      ),
    );
  }

  /// Suggested container
  static Widget _suggestedBox() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Suggested Alternative Elements"),
          SizedBox(height: 10),
          Text("some Element"),
        ],
      ),
    );
  }

  static Widget _elementRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        /// Element image
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.shade300,
          ),
          child: const Center(child: Text("some\nElement")),
        ),

        /// + -
        const Row(
          children: [
            Icon(Icons.add),
            SizedBox(width: 10),
            Icon(Icons.remove),
          ],
        ),

        /// AR button
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Column(
            children: [
              Icon(Icons.remove_red_eye, color: Colors.white),
              Text(
                "AR Viewer",
                style: TextStyle(color: Colors.white, fontSize: 10),
              )
            ],
          ),
        ),
      ],
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