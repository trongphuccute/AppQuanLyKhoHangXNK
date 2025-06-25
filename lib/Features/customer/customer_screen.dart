import 'package:flutter/material.dart';
import 'customer_model.dart';
import 'add_customer_screen.dart';
import 'customer_detail_screen.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({Key? key}) : super(key: key);

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  List<Customer> customers = [
    Customer(id: '1', name: 'Nguyễn Văn A', phone: '0901234567'),
    Customer(id: '2', name: 'Trần Thị B', phone: '0912345678'),
    Customer(id: '3', name: 'Lê Văn C', phone: '0923456789'),
  ];

  String searchText = '';

  void _confirmDeleteCustomer(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa khách hàng này không?'),
        actions: [
          TextButton(
            child: Text('Hủy'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text('Xóa'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                customers.removeAt(index);
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Customer> filteredCustomers = customers
        .where((customer) =>
            customer.name.toLowerCase().contains(searchText.toLowerCase()) ||
            customer.phone.contains(searchText))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Khách hàng',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Quay lại màn hình trước
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person_add_alt_1, color: Colors.blueAccent),
            tooltip: 'Thêm khách hàng',
            onPressed: () async {
              final newCustomer = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddCustomerScreen()),
              );
              if (newCustomer != null && newCustomer is Customer) {
                setState(() {
                  customers.add(newCustomer);
                });
              }
            },
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm khách hàng',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              itemCount: filteredCustomers.length,
              separatorBuilder: (context, index) => SizedBox(height: 8),
              itemBuilder: (context, index) {
                final customer = filteredCustomers[index];
                final realIndex = customers.indexOf(customer);
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, color: Colors.blueAccent),
                    ),
                    title: Text(
                      customer.name,
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    subtitle: Text(
                      customer.phone,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.redAccent),
                      tooltip: 'Xóa khách hàng',
                      onPressed: () => _confirmDeleteCustomer(realIndex),
                    ),
                    onTap: () async {
                      final updatedCustomer = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CustomerDetailScreen(customer: customer),
                        ),
                      );
                      if (updatedCustomer != null && updatedCustomer is Customer) {
                        setState(() {
                          customers[realIndex] = updatedCustomer;
                        });
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: null, // Đã có nút thêm trên AppBar
    );
  }
}
