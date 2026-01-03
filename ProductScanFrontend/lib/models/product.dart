class Product {
  final int id;
  final String barcode;
  final String name;
  final String? brand;
  final String? nutriscore;
  final String? imageUrl;
  final String? quantity;
  final String? ingredients;
  final String? allergens;
  final String? categories;
  final String? novaGroup;

  Product({
    required this.id,
    required this.barcode,
    required this.name,
    this.brand,
    this.nutriscore,
    this.imageUrl,
    this.quantity,
    this.ingredients,
    this.allergens,
    this.categories,
    this.novaGroup,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Helper to safely access nested data
    final data = json['data'] ?? {};

    return Product(
      id: json['id'],
      barcode: json['barcode'],
      name: json['name'] ?? 'Unknown Product',
      brand: json['brand'],
      nutriscore: json['nutriscore'],
      imageUrl: json['image_url'],
      quantity: data['quantity'],
      ingredients: data['ingredients_text'],
      allergens: data['allergens'],
      categories: data['categories'],
      novaGroup: data['nova_group']
          ?.toString(), // OpenFoodFacts might return int or string
    );
  }

  get calories => null;

  get score => null;
}
