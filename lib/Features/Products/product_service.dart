import 'package:cloud_firestore/cloud_firestore.dart';
import 'product_model.dart';

class ProductService {
  final CollectionReference _productRef = FirebaseFirestore.instance.collection(
    'products',
  );

  Future<void> addProduct(Product product) async {
    await _productRef.add(product.toMap());
  }

  Future<void> updateProduct(Product product) async {
    await _productRef.doc(product.id).update(product.toMap());
  }

  Future<void> deleteProduct(String id) async {
    await _productRef.doc(id).delete();
  }

  Stream<List<Product>> getProducts() {
    return _productRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Product.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
}
