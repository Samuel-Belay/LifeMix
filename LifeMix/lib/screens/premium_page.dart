import 'package:flutter/material.dart';
import '../services/payment_service.dart';
import '../widgets/premium_button.dart';

class ProductDetails {
  final String id;
  final String title;
  final String description;
  final String price;

  ProductDetails({required this.id, required this.title, required this.description, required this.price});
}

class PremiumPage extends StatefulWidget {
  const PremiumPage({super.key});

  @override
  PremiumPageState createState() => PremiumPageState();
}

class PremiumPageState extends State<PremiumPage> {
  final PaymentService paymentService = PaymentService();
  List<ProductDetails> products = [];

  @override
  void initState() {
    super.initState();
    _initProducts();
  }

  Future<void> _initProducts() async {
    products = [
      ProductDetails(id: 'monthly', title: 'Premium Monthly', description: 'Unlock monthly premium features', price: '\$4.99'),
      ProductDetails(id: 'yearly', title: 'Premium Yearly', description: 'Unlock yearly premium features', price: '\$49.99'),
    ];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Premium')),
      body: ListView(
        children: products.map((product) => PremiumButton(product: product, onTap: () => paymentService.buy(product))).toList(),
      ),
    );
  }
}
