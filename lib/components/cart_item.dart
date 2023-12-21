import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trendtrove/models/cart.dart';
import 'package:trendtrove/models/shoe.dart';

class CartItem extends StatefulWidget {
  final Shoe shoe;

  CartItem({Key? key, required this.shoe}) : super(key: key);

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  void addItemToCart() {
    Provider.of<Cart>(context, listen: false).addItemToCart(widget.shoe);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: addItemToCart, // Add this line to handle item click
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.only(bottom: 10),
        child: ListTile(
          leading: Image.network(widget.shoe.imagePath),
          title: Text(widget.shoe.name),
          subtitle: Text(widget.shoe.price),
          trailing: IconButton(
            icon: const Icon(Icons.add_shopping_cart),
            onPressed: addItemToCart,
          ),
        ),
      ),
    );
  }
}
