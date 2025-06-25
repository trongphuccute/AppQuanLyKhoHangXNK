import 'dart:io';
import 'package:flutter/material.dart';
import 'customer_model.dart';

class CustomerDetailScreen extends StatefulWidget {
  final Customer customer;
  const CustomerDetailScreen({Key? key, required this.customer}) : super(key: key);

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  final _emailController = TextEditingController();
  final _facebookController = TextEditingController();
  final _addressController = TextEditingController();
  final _staffController = TextEditingController();
  final _referrerController = TextEditingController();
  final _companyController = TextEditingController();
  final _taxController = TextEditingController();
  final _idController = TextEditingController();
  final _noteController = TextEditingController();

  String? _customerType;
  String? _customerGroup;
  String? _gender;
  String? _city;
  String? _district;
  String? _ward;
  DateTime? _birthDate;
  File? _avatar;

  final List<String> customerTypes = ['Khách lẻ', 'Khách buôn'];
  final List<String> customerGroups = ['VIP', 'Thân thiết', 'Khách mới'];
  final List<String> genders = ['Nam', 'Nữ'];
  final List<String> cities = ['Hà Nội', 'Hồ Chí Minh', 'Đà Nẵng'];
  final List<String> districts = ['Quận 1', 'Quận 2', 'Quận 3'];
  final List<String> wards = ['Phường A', 'Phường B', 'Phường C'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.customer.name);
    _phoneController = TextEditingController(text: widget.customer.phone);
    // Nếu Customer mở rộng thêm trường, hãy prefill các trường đó ở đây
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Vui lòng nhập số điện thoại';
    final cleaned = value.replaceAll(RegExp(r'\D'), '');
    if (cleaned.length == 10 && !cleaned.startsWith('0')) {
      _phoneController.text = '0' + cleaned;
    }
    final phone = _phoneController.text;
    if (phone.length < 10 || phone.length > 11) return 'Số điện thoại phải 10-11 số';
    if (!phone.startsWith('0')) return 'Số điện thoại phải bắt đầu bằng số 0';
    if (!RegExp(r'^[0-9]+$').hasMatch(phone)) return 'Chỉ nhập số';
    return null;
  }

  String? _validateRequired(String? value) {
    if (value == null || value.isEmpty) return 'Không được bỏ trống';
    return null;
  }

  Future<void> _pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(1990, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  // Tạo InputDecoration đồng bộ
  InputDecoration _inputDecoration(String label) => InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết khách hàng'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Loại khách
              DropdownButtonFormField<String>(
                decoration: _inputDecoration('Loại khách'),
                value: _customerType,
                items: customerTypes.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => _customerType = val),
              ),
              SizedBox(height: 12),
              // Nhóm khách hàng
              DropdownButtonFormField<String>(
                decoration: _inputDecoration('Nhóm khách hàng'),
                value: _customerGroup,
                items: customerGroups.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => _customerGroup = val),
              ),
              SizedBox(height: 12),
              // Họ tên
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration('Họ tên khách hàng'),
                validator: _validateRequired,
              ),
              SizedBox(height: 12),
              // Số điện thoại
              TextFormField(
                controller: _phoneController,
                decoration: _inputDecoration('Số điện thoại'),
                keyboardType: TextInputType.phone,
                validator: _validatePhone,
              ),
              SizedBox(height: 12),
              // Email
              TextFormField(
                controller: _emailController,
                decoration: _inputDecoration('Email'),
              ),
              SizedBox(height: 12),
              // Facebook
              TextFormField(
                controller: _facebookController,
                decoration: _inputDecoration('Facebook'),
              ),
              SizedBox(height: 12),
              // Ngày sinh
              InkWell(
                onTap: _pickBirthDate,
                child: InputDecorator(
                  decoration: _inputDecoration('Ngày sinh'),
                  child: Text(_birthDate == null
                      ? 'Chọn ngày sinh'
                      : '${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}'),
                ),
              ),
              SizedBox(height: 12),
              // Giới tính
              DropdownButtonFormField<String>(
                decoration: _inputDecoration('Giới tính'),
                value: _gender,
                items: genders.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => _gender = val),
              ),
              SizedBox(height: 12),
              // Thành phố
              DropdownButtonFormField<String>(
                decoration: _inputDecoration('Thành phố'),
                value: _city,
                items: cities.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => _city = val),
              ),
              SizedBox(height: 12),
              // Quận huyện
              DropdownButtonFormField<String>(
                decoration: _inputDecoration('Quận huyện'),
                value: _district,
                items: districts.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => _district = val),
              ),
              SizedBox(height: 12),
              // Phường xã
              DropdownButtonFormField<String>(
                decoration: _inputDecoration('Phường xã'),
                value: _ward,
                items: wards.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => _ward = val),
              ),
              SizedBox(height: 12),
              // Địa chỉ
              TextFormField(
                controller: _addressController,
                decoration: _inputDecoration('Địa chỉ'),
              ),
              SizedBox(height: 12),
              // Nhân viên phụ trách
              TextFormField(
                controller: _staffController,
                decoration: _inputDecoration('Nhân viên phụ trách'),
              ),
              SizedBox(height: 12),
              // Khách giới thiệu
              TextFormField(
                controller: _referrerController,
                decoration: _inputDecoration('Khách giới thiệu'),
              ),
              SizedBox(height: 16),
            
              SizedBox(height: 16),
              // Thông tin bổ sung
              Text('Thông tin bổ sung', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              // Công ty
              TextFormField(
                controller: _companyController,
                decoration: _inputDecoration('Công ty'),
              ),
              SizedBox(height: 12),
              // Mã số thuế
              TextFormField(
                controller: _taxController,
                decoration: _inputDecoration('Mã số thuế'),
              ),
              SizedBox(height: 12),
              // Số CMND
              TextFormField(
                controller: _idController,
                decoration: _inputDecoration('Số CMND'),
              ),
              SizedBox(height: 12),
              // Ghi chú
              TextFormField(
                controller: _noteController,
                decoration: _inputDecoration('Ghi chú'),
                maxLines: 2,
              ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 48, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Lưu', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Xử lý cập nhật dữ liệu ở đây nếu muốn
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
