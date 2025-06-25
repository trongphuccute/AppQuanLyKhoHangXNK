import 'package:flutter/material.dart';
import 'package:flutter_application_1/Features/Trade/ChiTietScreen.dart';
import 'package:flutter_application_1/Features/Trade/GiaoDich.dart';
import 'package:flutter_application_1/Features/Trade/ThemGiaoDichScreen.dart';

class GiaoDichScreen extends StatefulWidget {
  const GiaoDichScreen({super.key});

  @override
  State<GiaoDichScreen> createState() => _GiaoDichScreenState();
}

class _GiaoDichScreenState extends State<GiaoDichScreen> {
  final TextEditingController _searchController = TextEditingController();
  DateTime? _ngayDaChon;

  final List<GiaoDich> _danhSach = [
    GiaoDich(
      ten: 'Nguyễn Văn A',
      sdt: '0912523456',
      maDon: '#AT',
      soLuong: 1,
      ngay: DateTime(2025, 2, 20),
      donGia: 50000,
    ),
    GiaoDich(
      ten: 'Nguyễn Văn A',
      sdt: '0912523456',
      maDon: '#AT',
      soLuong: 9,
      ngay: DateTime(2025, 2, 20),
      donGia: 50000,
    ),
    GiaoDich(
      ten: 'Nguyễn Văn A',
      sdt: '0912523456',
      maDon: '#AT',
      soLuong: 5,
      ngay: DateTime(2025, 2, 20),
      donGia: 50000,
    ),
  ];

  List<GiaoDich> get _danhSachLoc {
    final keyword = _searchController.text.toLowerCase();
    return _danhSach.where((gd) {
      final matchName = gd.ten.toLowerCase().contains(keyword);
      final matchDate = _ngayDaChon == null ||
          (gd.ngay.year == _ngayDaChon!.year &&
              gd.ngay.month == _ngayDaChon!.month &&
              gd.ngay.day == _ngayDaChon!.day);
      return matchName && matchDate;
    }).toList();
  }

  void _chonNgay() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _ngayDaChon ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _ngayDaChon = picked;
      });
    }
  }

  void _moThemGiaoDich() async {
    final ketQua = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ThemGiaoDichScreen()),
    );

    if (ketQua != null && ketQua is GiaoDich) {
      setState(() {
        _danhSach.add(ketQua);
      });
    }
  }

  void _xemChiTiet(GiaoDich giaoDich) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChiTietScreen(giaoDich: giaoDich),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giao Dịch', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.calendar_month), onPressed: _chonNgay),
          IconButton(icon: const Icon(Icons.add), onPressed: _moThemGiaoDich),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Tìm kiếm',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _danhSachLoc.isEmpty
                  ? const Center(child: Text('Không có giao dịch nào'))
                  : ListView.builder(
                      itemCount: _danhSachLoc.length,
                      itemBuilder: (context, index) {
                        final gd = _danhSachLoc[index];
                        return Card(
                          color: Colors.grey[200],
                          child: ListTile(
                            onTap: () => _xemChiTiet(gd),
                            leading: const Icon(Icons.calendar_month),
                            title: Text(gd.ten),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(gd.sdt),
                                Text('${gd.maDon} - SL: ${gd.soLuong}'),
                              ],
                            ),
                            trailing: Text(
                              '${gd.ngay.day.toString().padLeft(2, '0')}-${gd.ngay.month.toString().padLeft(2, '0')}-${gd.ngay.year}',
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
