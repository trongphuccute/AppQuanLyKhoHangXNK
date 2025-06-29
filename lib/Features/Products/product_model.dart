class Product {
  final String id;
  final String code;
  final String name;
  final int quantity;
  final String imagePath;

  Product({
    required this.id,
    required this.code,
    required this.name,
    required this.quantity,
    required this.imagePath,
  });

  factory Product.fromFirestore(Map<String, dynamic> data, String docId) {
    return Product(
      id: docId,
      code: data['code'] ?? '',
      name: data['name'] ?? '',
      quantity: data['quantity'] ?? 0,
      imagePath: data['imagePath'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'quantity': quantity,
      'imagePath': imagePath,
    };
  }
}
