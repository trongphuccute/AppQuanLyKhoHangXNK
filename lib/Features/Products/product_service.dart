import 'package:cloud_firestore/cloud_firestore.dart';
import 'product_model.dart';

class ProductService {
  static Future<List<Product>> fetchProducts() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('products').get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Product.fromFirestore(data, doc.id);
    }).toList();
  }

  static Future<void> addProduct(Product product) async {
    await FirebaseFirestore.instance
        .collection('products')
        .add(product.toMap());
  }

  static Future<void> deleteProduct(String productId) async {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .delete();
  }
}
