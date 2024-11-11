import 'package:flutter/material.dart';

import '../DatabaseHelper/CustomerjobDB.dart';

class DisplayjobScreen extends StatelessWidget {
  final String fullName;

  const DisplayjobScreen({Key? key, required this.fullName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DatabasejobHelper _databaseHelper = DatabasejobHelper();

    return Scaffold(
      appBar: AppBar(
        title: Text("รายการงานทั้งหมด"),
        backgroundColor: Colors.green[100],
        foregroundColor: Colors.green[800],
      ),
      body: FutureBuilder(
        future: _databaseHelper.getAllJobs(),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('ไม่มีงาน'));
          }

          final jobs = snapshot.data!;

          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];

              return Card(
                margin: EdgeInsets.only(bottom: 16.0),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ชื่อลูกค้า: ' + job['fullName'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'เบอร์ติดต่อ: ${job['contactNumber']}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green[700],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'หมวดหมู่งาน: ${job['categories']}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green[700],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'ที่อยู่: ${job['address']}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green[700],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'รายละเอียด: ${job['details']}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
