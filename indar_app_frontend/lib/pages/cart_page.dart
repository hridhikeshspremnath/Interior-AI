import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f3f3),
      bottomNavigationBar: buildBottomNav(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              const SizedBox(height: 10),

              const Text(
                "CART",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: ListView(
                  children: [
                    _cartItem("Standard Chair"),
                    _cartItem("Comfy Cushion"),
                    _cartItem("Stools"),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              _priceRow("Sub Total", "\$2700"),
              _priceRow("Discount", "-\$690"),

              const Divider(),

              _priceRow("TOTAL", "\$2010", bold: true),

              const SizedBox(height: 15),

              Container(
                height: 55,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    "Import to Amazon",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }

  static Widget _cartItem(String name) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        color: Colors.grey.shade300,
      ),
      title: Text(name),
      trailing: const Text("1 +"),
    );
  }

  static Widget _priceRow(String title, String price, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              )),
          Text(price,
              style: TextStyle(
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              )),
        ],
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
          Icon(Icons.refresh, color: Colors.white),
          Icon(Icons.shopping_cart, color: Colors.white),
          Icon(Icons.person_outline, color: Colors.white),
        ],
      ),
    );
  }*/
}