class CartItem {
  String name;
  double price;
  int quantity;

  CartItem({
    required this.name,
    required this.price,
    this.quantity = 1,
  });
}

class CartModel {
  static List<CartItem> cartItems = [];

  static void addItem(String name, double price) {
    for (var item in cartItems) {
      if (item.name == name) {
        item.quantity++;
        return;
      }
    }

    cartItems.add(CartItem(name: name, price: price));
  }

  static void removeItem(String name) {
    for (var item in cartItems) {
      if (item.name == name) {
        if (item.quantity > 1) {
          item.quantity--;
        } else {
          cartItems.remove(item);
        }
        return;
      }
    }
  }

  static double get totalPrice {
    double total = 0;
    for (var item in cartItems) {
      total += item.price * item.quantity;
    }
    return total;
  }
}
