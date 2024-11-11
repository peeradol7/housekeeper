import 'package:flutter/material.dart';

import '../../Customer/CreateOrder.dart';
import '../../DatabaseHelper/dbhelper.dart'; // นำเข้าไฟล์ JobsDatabaseHelper

class CategoryCarWashScreen extends StatelessWidget {
  final int userid;
  final String fullName;
  final String contactNumber;

  CategoryCarWashScreen({
    Key? key,
    required this.userid,
    required this.fullName,
    required this.contactNumber,
  }) : super(key: key);
  final JobsDatabaseHelper dbHelper = JobsDatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        textTheme: TextTheme(
          headline6:
              TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold),
          subtitle1: TextStyle(color: Colors.green[600]),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Car Wash Services",
          ),
          backgroundColor: Color.fromARGB(249, 72, 148, 76),
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: dbHelper.getJobsByCategory("Car Wash"),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("No jobs found for Car Wash"));
            } else {
              final jobs = snapshot.data!;
              return ListView.builder(
                padding: EdgeInsets.all(8.0),
                itemCount: jobs.length,
                itemBuilder: (context, index) {
                  final job = jobs[index];
                  return Card(
                    elevation: 4,
                    margin:
                        EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
                    child: ListTile(
                      title: Text(
                        'คุณ${job['fullName']}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job['category'],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.green[600],
                            ),
                          ),
                          SizedBox(
                              height:
                                  4), // เพิ่มระยะห่างเล็กน้อยระหว่างหมวดหมู่กับรายละเอียด
                          Text(
                            'รายละเอียด: ${job['details']}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      trailing: Text(
                        'ราคา \$${job['price']}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('รายละเอียดของงาน'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('ชื่อผู้ให้บริการ: ${job['fullName']}'),
                                  SizedBox(height: 8),
                                  Text('หมวดหมู่: ${job['category']}'),
                                  SizedBox(height: 8),
                                  Text('ราคา: \$${job['price']}'),
                                  SizedBox(height: 8),
                                  Text(
                                      'รายละเอียดเพิ่มเติม: ${job['details']}'),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CreateOrderScreen(
                                          fullname: fullName,
                                          job: job, // ส่งข้อมูล job
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text('ใช้บริการ',
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0))),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('ปิด',
                                      style: TextStyle(color: Colors.green)),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
