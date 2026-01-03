import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductPage extends StatelessWidget {
  final Product product;

  const ProductPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nom : ${product.name}", style: const TextStyle(fontSize: 20)),
            Text("Marque : ${product.brand}", style: const TextStyle(fontSize: 20)),
            Text("Calories : ${product.calories}", style: const TextStyle(fontSize: 20)),
            Text("Score : ${product.score}", style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
