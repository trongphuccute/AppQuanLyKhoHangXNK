import 'product_model.dart';

class ProductService {
  static Future<List<Product>> fetchProducts() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      Product(
        code: '#AT001',
        name: 'Áo Thun',
        quantity: 20,
        imagePath: 'assets/ao_thun.png',
      ),
      Product(
        code: '#QJ001',
        name: 'Quần Jean',
        quantity: 40,
        imagePath: 'assets/quan_jean.png',
      ),
      Product(
        code: '#AK001',
        name: 'Áo Khoác Dù',
        quantity: 60,
        imagePath: 'assets/ao_khoac.png',
      ),
    ];
  }
}
