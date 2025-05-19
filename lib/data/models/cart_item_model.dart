// <start of data/models/cart_item_model.dart>
import 'package:net_app/data/models/product_model.dart';

class CartItemModel {
  final ProductModel product;
  int quantity;

  CartItemModel({required this.product, this.quantity = 1});

  double get totalPrice => product.price * quantity;
}
// <end of data/models/cart_item_model.dart>