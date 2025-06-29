import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'GiaoDich.dart';

class ThemGiaoDichScreen extends StatefulWidget {
  const ThemGiaoDichScreen({super.key});

  @override
  State<ThemGiaoDichScreen> createState() => _ThemGiaoDichScreenState();
}

class _ThemGiaoDichScreenState extends State<ThemGiaoDichScreen> {
  final _tenController = TextEditingController();
  final _sdtController = TextEditingController();
  final _slController = TextEditingController(text: '1');

  String? _maDon = '#AT';
  int _donGia = 50000;
  DateTime _ngay = DateTime.now();

  final List<Map<String, dynamic>> _sanPhamList = [
    {'code': '#AT', 'name': 'Áo Thun', 'price': 50000},
    {'code': '#AK', 'name': 'Áo Khoác', 'price': 120000},
    {'code': '#QJ', 'name': 'Quần Jean', 'price': 150000},
    {'code': '#QK', 'name': 'Quần Kaki', 'price': 100000},
    {'code': '#QJN', 'name': 'Quần Jean Nữ', 'price': 130000},
  ];

  int get _tongTien {
    final sl = int.tryParse(_slController.text) ?? 0;
    return sl * _donGia;
  }

  void _chonNgay() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _ngay,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => _ngay = picked);
    }
  }

  Future<void> _luu() async {
    if (_tenController.text.isEmpty || _sdtController.text.isEmpty) return;

    final id = const Uuid().v4();
    final gd = GiaoDich(
      id: id,
      ten: _tenController.text,
      sdt: _sdtController.text,
      maDon: _maDon ?? '',
      soLuong: int.tryParse(_slController.text) ?? 0,
      ngay: _ngay,
      donGia: _donGia,
    );

    await FirebaseFirestore.instance
        .collection('giao_dich')
        .doc(id)
        .set(gd.toMap());

    if (!mounted) return;
    Navigator.pop(context);
  }

  void _capNhatDonGia(String? ma) {
    final sanPham = _sanPhamList.firstWhere(
      (sp) => sp['code'] == ma,
      orElse: () => _sanPhamList[0],
    );
    setState(() {
      _maDon = ma;
      _donGia = sanPham['price'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm Giao Dịch')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _tenController,
              decoration: const InputDecoration(labelText: 'Tên khách hàng'),
            ),
            TextField(
              controller: _sdtController,
              decoration: const InputDecoration(labelText: 'Số điện thoại'),
            ),

            DropdownButtonFormField<String>(
              value: _maDon,
              decoration: const InputDecoration(labelText: 'Chọn mã sản phẩm'),
              items:
                  _sanPhamList.map((sp) {
                    return DropdownMenuItem<String>(
                      value: sp['code'],
                      child: Text('${sp['code']} - ${sp['name']}'),
                    );
                  }).toList(),
              onChanged: _capNhatDonGia,
            ),

            TextField(
              controller: _slController,
              decoration: const InputDecoration(labelText: 'Số lượng'),
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Ngày: '),
                TextButton(
                  onPressed: _chonNgay,
                  child: Text('${_ngay.day}/${_ngay.month}/${_ngay.year}'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text('Đơn giá: $_donGia đ'),
            Text(
              'Tổng tiền: $_tongTien đ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _luu,
              icon: const Icon(Icons.save),
              label: const Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }
}
