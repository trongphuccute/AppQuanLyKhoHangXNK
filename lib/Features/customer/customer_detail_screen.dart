import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'customer_model.dart';

class CustomerDetailScreen extends StatefulWidget {
  final Customer? customer;

  const CustomerDetailScreen({Key? key, this.customer}) : super(key: key);

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  bool get isEditing => widget.customer != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.customer?.name ?? '');
    _phoneController = TextEditingController(
      text: widget.customer?.phone ?? '',
    );
  }

  InputDecoration _inputDecoration(String label) => InputDecoration(
    labelText: label,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    filled: true,
    fillColor: Colors.grey.shade100,
  );

  String? _validateRequired(String? value) =>
      value == null || value.isEmpty ? 'Không được để trống' : null;

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Vui lòng nhập số điện thoại';
    final cleaned = value.replaceAll(RegExp(r'\D'), '');
    if (cleaned.length < 10 || cleaned.length > 11)
      return 'Số điện thoại không hợp lệ';
    if (!cleaned.startsWith('0')) return 'Số điện thoại phải bắt đầu bằng số 0';
    return null;
  }

  Future<void> _saveCustomer() async {
    if (!_formKey.currentState!.validate()) return;

    final id = widget.customer?.id ?? const Uuid().v4();
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();

    // Kiểm tra trùng số điện thoại
    final snapshot =
        await FirebaseFirestore.instance
            .collection('customers')
            .where('phone', isEqualTo: phone)
            .get();

    final isDuplicate = snapshot.docs.any((doc) => doc.id != id);

    if (isDuplicate) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Số điện thoại đã tồn tại!')),
      );
      return;
    }

    final customer = Customer(id: id, name: name, phone: phone);

    await FirebaseFirestore.instance
        .collection('customers')
        .doc(id)
        .set(customer.toMap());

    Navigator.pop(context, customer); // Trả về customer vừa lưu
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Chỉnh sửa khách hàng' : 'Thêm khách hàng'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration('Họ tên khách hàng'),
                validator: _validateRequired,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: _inputDecoration('Số điện thoại'),
                keyboardType: TextInputType.phone,
                validator: _validatePhone,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveCustomer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Lưu',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
