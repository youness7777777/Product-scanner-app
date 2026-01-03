import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  final String baseUrl = "http://192.168.137.1:8000/api/products";

  Future<Product> getProduct(String barcode) async {
    final url = Uri.parse("$baseUrl/$barcode");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Produit introuvable");
    }
  }
}
