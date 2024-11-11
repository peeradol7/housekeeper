import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart'; // สำหรับแสดงข้อความ

import '../DatabaseHelper/CustomerjobDB.dart'; // ชื่อไฟล์ DB ของคุณ

class DisplayMyjobScreen extends StatefulWidget {
  final int userid;
  final String fullName;
  final String contactNumber;

  const DisplayMyjobScreen({
    Key? key,
    required this.userid,
    required this.fullName,
    required this.contactNumber,
  }) : super(key: key);

  @override
  _DisplayMyjobScreenState createState() => _DisplayMyjobScreenState();
}

class _DisplayMyjobScreenState extends State<DisplayMyjobScreen> {
  final DatabasejobHelper _databaseHelper = DatabasejobHelper();
  bool _isLoading = false;
  List<Map<String, dynamic>> _jobs = [];

  @override
  void initState() {
    super.initState();
    _fetchJobs();
  }

  Future<void> _fetchJobs() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final jobs = await _databaseHelper.fetchJobsByUserId(widget.userid);
      setState(() {
        _jobs = jobs;
      });
    } catch (e) {
      print("Error fetching jobs: $e");
      Fluttertoast.showToast(msg: "ไม่สามารถโหลดข้อมูลงานได้");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _showDeleteDialog(int jobId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("ยืนยันการลบ"),
          content: Text("คุณต้องการลบงานนี้หรือไม่?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("ปิด"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await _deleteJob(jobId);
              },
              child: Text("ลบ"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteJob(int jobId) async {
    try {
      await _databaseHelper.deleteJob(jobId);
      Fluttertoast.showToast(msg: "ลบงานสำเร็จ");
      _fetchJobs();
    } catch (e) {
      print("Error deleting job: $e");
      Fluttertoast.showToast(msg: "ไม่สามารถลบงานได้");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("งานที่ฉันประกาศ"),
        backgroundColor: Colors.green[100],
        foregroundColor: Colors.green[800],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _jobs.length,
              itemBuilder: (context, index) {
                final job = _jobs[index];
                String fullName = job['fullName'] ?? 'ไม่มีชื่อ';
                String contactNumber = job['contactNumber'] ?? 'ไม่มีเบอร์';
                String category = job['category'] ?? 'ไม่มีหมวดหมู่';
                String address = job['address'] ?? 'ไม่มีที่อยู่';
                String details = job['details'] ?? 'ไม่มีรายละเอียด';
                print('fullName: ${job['fullName']}');
                print('เบอร์: ${job['contactNumber']}');
                print('address: ${job['address']}');
                print('caregory: ${job['categories']}');
                print('รายละเอียด: ${job['details']}');

                return InkWell(
                  onTap: () {
                    _showDeleteDialog(job['jobcustomerId']);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ชื่อลูกค้า: ${job['fullName'] ?? 'ชื่อไม่ระบุ'}',
                          // ถ้า 'fullName' เป็น null จะใช้ 'ชื่อไม่ระบุ'
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'เบอร์ติดต่อ: ${job['contactNumber'] ?? 'ไม่มีข้อมูล'}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'หมวดหมู่งาน: ' + job['categories'],
                          style:
                              TextStyle(fontSize: 14, color: Colors.green[600]),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'ที่อยู่: ' + job['address'],
                          style:
                              TextStyle(fontSize: 14, color: Colors.green[600]),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'รายละเอียด: ' + job['details'],
                          style:
                              TextStyle(fontSize: 14, color: Colors.green[600]),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
