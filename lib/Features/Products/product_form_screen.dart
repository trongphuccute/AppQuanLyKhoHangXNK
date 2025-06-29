import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'product_model.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product;

  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codeController;
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _imagePathController;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: widget.product?.code ?? '');
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _quantityController = TextEditingController(
      text: widget.product?.quantity.toString() ?? '',
    );
    _imagePathController = TextEditingController(
      text: widget.product?.imagePath ?? '',
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _quantityController.dispose();
    _imagePathController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      final newData = {
        'code': _codeController.text,
        'name': _nameController.text,
        'quantity': int.tryParse(_quantityController.text) ?? 0,
        'imagePath': _imagePathController.text,
      };

      final collection = FirebaseFirestore.instance.collection('products');

      if (widget.product == null) {
        await collection.add(newData);
      } else {
        await collection.doc(widget.product!.id).update(newData);
      }

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Thêm sản phẩm' : 'Sửa sản phẩm'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(labelText: 'Mã sản phẩm'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Không để trống'
                            : null,
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Tên sản phẩm'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Không để trống'
                            : null,
              ),
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Số lượng'),
              ),
              TextFormField(
                controller: _imagePathController,
                decoration: const InputDecoration(labelText: 'Đường dẫn ảnh'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _saveProduct, child: const Text('Lưu')),
            ],
          ),
        ),
      ),
    );
  }
}
