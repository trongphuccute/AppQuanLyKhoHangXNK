import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'product_model.dart';
import 'add_product.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProductsFromFirestore();
  }

  Future<void> _loadProductsFromFirestore() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('products').get();

      final products =
          snapshot.docs.map((doc) {
            final data = doc.data();
            return Product.fromFirestore(data, doc.id);
          }).toList();

      setState(() {
        _allProducts = products;
        _filteredProducts = products;
        _isLoading = false;
      });
    } catch (e) {
      print('Lỗi khi tải sản phẩm: $e');
      setState(() => _isLoading = false);
    }
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

  Future<void> _deleteProduct(String docId) async {
    await FirebaseFirestore.instance.collection('products').doc(docId).delete();
    _loadProductsFromFirestore();
  }

  void _showDeleteConfirm(Product product) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Xác nhận xoá'),
            content: Text('Bạn có chắc muốn xoá "${product.name}" không?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Huỷ'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _deleteProduct(product.id);
                },
                child: const Text('Xoá', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  void _showEditDialog(Product product) {
    final nameController = TextEditingController(text: product.name);
    final quantityController = TextEditingController(
      text: product.quantity.toString(),
    );

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Sửa sản phẩm'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Tên sản phẩm'),
                ),
                TextField(
                  controller: quantityController,
                  decoration: const InputDecoration(labelText: 'Số lượng'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Huỷ'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final newName = nameController.text.trim();
                  final newQty = int.tryParse(quantityController.text) ?? 0;

                  await FirebaseFirestore.instance
                      .collection('products')
                      .doc(product.id)
                      .update({'name': newName, 'quantity': newQty});

                  Navigator.pop(context);
                  _loadProductsFromFirestore();
                },
                child: const Text('Lưu'),
              ),
            ],
          ),
    );
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
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredProducts.isEmpty
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
                              errorBuilder:
                                  (_, __, ___) =>
                                      const Icon(Icons.image_not_supported),
                            ),
                            title: Text(product.name),
                            subtitle: Text('Mã: ${product.code}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('${product.quantity} cái'),
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () => _showEditDialog(product),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _showDeleteConfirm(product),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddProductScreen()),
          ).then((_) => _loadProductsFromFirestore());
        },
        icon: const Icon(Icons.add),
        label: const Text('Thêm sản phẩm'),
      ),
    );
  }
}
