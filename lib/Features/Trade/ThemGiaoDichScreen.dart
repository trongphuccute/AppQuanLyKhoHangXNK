import 'package:flutter/material.dart';
import 'package:flutter_application_1/Features/Trade/GiaoDich.dart';


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

  int get _tongTien {
    final sl = int.tryParse(_slController.text) ?? 0;
    return sl * _donGia;
  }

  void _chonNgay() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _ngay,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _ngay = picked;
      });
    }
  }

  void _luu() {
    if (_tenController.text.isEmpty || _sdtController.text.isEmpty) return;

    final gd = GiaoDich(
      ten: _tenController.text,
      sdt: _sdtController.text,
      maDon: _maDon ?? '#AT',
      soLuong: int.tryParse(_slController.text) ?? 0,
      ngay: _ngay,
      donGia: _donGia,
    );

    Navigator.pop(context, gd);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm Giao Dịch')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(controller: _tenController, decoration: const InputDecoration(labelText: 'Tên khách hàng')),
            TextField(controller: _sdtController, decoration: const InputDecoration(labelText: 'Số điện thoại')),
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
            Text('Tổng tiền: $_tongTien đ', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton.icon(onPressed: _luu, icon: const Icon(Icons.save), label: const Text('Lưu')),
          ],
        ),
      ),
    );
  }
}
