import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/product_service.dart';
import 'product_page.dart';

class ScanPage extends StatelessWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan")),
      body: MobileScanner(
        onDetect: (barcode) async {
          final code = barcode.barcodes.first.rawValue;

          if (code == null) return;

          final product = await ProductService().getProduct(code);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductPage(product: product),
            ),
          );
        },
      ),
    );
  }
}
