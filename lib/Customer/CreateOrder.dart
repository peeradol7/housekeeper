import 'package:flutter/material.dart';
import 'package:housekeeper/DatabaseHelper/CreateOrderDatabase.dart';
import 'package:housekeeper/model/Ordermodel.dart';

class CreateOrderScreen extends StatelessWidget {
  final Map<String, dynamic> job;
  final fullname;

  CreateOrderScreen({required this.job, required this.fullname});

  Future<void> _createOrder(OrderData order) async {
    await CreateOrder.createOrder(order);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Order"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "รายละเอียดงานที่เลือก",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            SizedBox(height: 16),
            Text(
              "ชื่องาน: ${job['category']}",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              "รายละเอียด: ${job['details']}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              "ข้อมูลผู้ให้บริการ:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            SizedBox(height: 8),
            Text(
              "ชื่อผู้ให้บริการ: ${job['fullName']}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              "เบอร์โทร: ${job['contactNumber']}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final order = OrderData(
                  jobid: job['jobid'] ?? 0,
                  fullName: job['fullName'] ?? 'Unknown',
                  contactNumber: job['contactNumber'] ?? 'Unknown',
                  details: job['details'] ?? 'No details provided',
                  timestamp: DateTime.now().toString(),
                );

                if (order.fullName.isNotEmpty &&
                    order.contactNumber.isNotEmpty) {
                  _createOrder(order); // Pass the created order to the method
                } else {
                  print(
                      "Error: Missing required fields (fullName or contactNumber)");
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text("ยืนยันการใช้บริการ"),
            ),
          ],
        ),
      ),
    );
  }
}
