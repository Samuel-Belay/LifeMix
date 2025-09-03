import 'package:flutter/material.dart';
import '../screens/premium_page.dart';

class PremiumButton extends StatelessWidget {
  final ProductDetails product;
  final VoidCallback onTap;
  const PremiumButton({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(title: Text(product.title), subtitle: Text(product.description), trailing: Text(product.price), onTap: onTap),
    );
  }
}
