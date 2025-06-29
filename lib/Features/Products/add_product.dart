import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _imagePathController = TextEditingController();

  bool _isSaving = false;

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);

      await FirebaseFirestore.instance.collection('products').add({
        'code': _codeController.text.trim(),
        'name': _nameController.text.trim(),
        'quantity': int.tryParse(_quantityController.text) ?? 0,
        'imagePath': _imagePathController.text.trim(),
      });

      setState(() => _isSaving = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã thêm sản phẩm thành công!')),
      );
      Navigator.pop(context); // quay về màn hình trước
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm sản phẩm')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(labelText: 'Mã sản phẩm'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Nhập mã sản phẩm'
                            : null,
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Tên sản phẩm'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Nhập tên sản phẩm'
                            : null,
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Số lượng'),
                keyboardType: TextInputType.number,
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Nhập số lượng' : null,
              ),
              TextFormField(
                controller: _imagePathController,
                decoration: const InputDecoration(
                  labelText: 'Đường dẫn ảnh (VD: assets/ao_thun.png)',
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Nhập đường dẫn ảnh'
                            : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _isSaving ? null : _saveProduct,
                icon: const Icon(Icons.save),
                label:
                    _isSaving
                        ? const CircularProgressIndicator()
                        : const Text('Lưu sản phẩm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
