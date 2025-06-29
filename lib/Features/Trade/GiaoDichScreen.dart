import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'GiaoDich.dart';
import 'ThemGiaoDichScreen.dart';
import 'ChiTietScreen.dart';

class GiaoDichScreen extends StatelessWidget {
  const GiaoDichScreen({super.key});

  Stream<List<GiaoDich>> _loadGiaoDich() {
    return FirebaseFirestore.instance
        .collection('giao_dich')
        .orderBy('ngay', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => GiaoDich.fromFirestore(doc.data(), doc.id))
                  .toList(),
        );
  }

  void _moThem(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ThemGiaoDichScreen()),
    );
  }

  void _moChiTiet(BuildContext context, GiaoDich giaoDich) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ChiTietScreen(giaoDich: giaoDich)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giao Dịch'),
        actions: [
          IconButton(
            onPressed: () => _moThem(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: StreamBuilder<List<GiaoDich>>(
        stream: _loadGiaoDich(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          final data = snapshot.data ?? [];
          if (data.isEmpty)
            return const Center(child: Text('Không có giao dịch nào'));
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final gd = data[index];
              return ListTile(
                onTap: () => _moChiTiet(context, gd),
                leading: const Icon(Icons.swap_horiz),
                title: Text(gd.ten),
                subtitle: Text('${gd.sdt} - SL: ${gd.soLuong}'),
                trailing: Text('${gd.tongTien}đ'),
              );
            },
          );
        },
      ),
    );
  }
}
