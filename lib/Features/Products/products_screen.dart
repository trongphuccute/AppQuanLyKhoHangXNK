import 'package:flutter/material.dart';
import 'product_model.dart';
import 'product_service.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final products = await ProductService.fetchProducts();
    setState(() {
      _allProducts = products;
      _filteredProducts = products;
    });
  }

  void _filterProducts(String keyword) {
    setState(() {
      _filteredProducts =
          _allProducts
              .where(
                (product) =>
                    product.code.toLowerCase().contains(keyword.toLowerCase()),
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Danh sách sản phẩm')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Tìm kiếm theo mã sản phẩm (VD: #AT)',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filterProducts,
            ),
          ),
          Expanded(
            child:
                _filteredProducts.isEmpty
                    ? const Center(child: Text('Không có sản phẩm nào'))
                    : ListView.builder(
                      itemCount: _filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = _filteredProducts[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          child: ListTile(
                            leading: Image.asset(
                              product.imagePath,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            ),
                            title: Text(product.name),
                            subtitle: Text('Mã: ${product.code}'),
                            trailing: Text('${product.quantity} cái'),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
