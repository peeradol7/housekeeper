import 'package:flutter/material.dart';
import 'package:housekeeper/model/jobModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'EditJobScreen.dart';

class MyJobScreen extends StatefulWidget {
  final String fullName;
  final String email;
  final int userid;
  final int jobid;

  const MyJobScreen(
      {Key? key,
      required this.fullName,
      required this.email,
      required this.userid,
      required this.jobid})
      : super(key: key);

  @override
  _MyJobScreenState createState() => _MyJobScreenState();
}

class _MyJobScreenState extends State<MyJobScreen> {
  late Future<List<JobDataList>> _jobs;
  late Database _database;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'sqlite.db');

      print("Opening database at: $path");

      _database = await openDatabase(
        path,
        version: 1,
      );

      print("Database opened successfully");
      _loadJobs();
    } catch (e) {
      print("Error initializing database: $e");
    }
  }

  void _loadJobs() {
    setState(() {
      _jobs = _getJobs();
    });
  }

  Future<List<JobDataList>> _getJobs() async {
    try {
      print('Fetching jobs for userid: ${widget.userid}');

      final List<Map<String, dynamic>> maps = await _database.query(
        'jobs',
        where: 'userid = ?', // เปลี่ยนจาก email เป็น userid
        whereArgs: [widget.userid],
      );

      print('Found ${maps.length} jobs');

      return List.generate(maps.length, (i) {
        final job = JobDataList.fromMap(maps[i]);
        print('Job ${i + 1}: ${job.toMap()}');
        return job;
      });
    } catch (e) {
      print('Error getting jobs: $e');
      return [];
    }
  }

  Future<void> _deleteJob(int jobid, BuildContext context) async {
    try {
      print('Attempting to delete job with ID: $jobid');

      final result = await _database.delete(
        'jobs',
        where: 'jobid = ?',
        whereArgs: [jobid],
      );

      print('Delete result: $result');

      if (result > 0) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('ลบงานสำเร็จ')),
          );
        }
        _loadJobs();
      } else {
        throw Exception('No job found with ID: $jobid');
      }
    } catch (e) {
      print('Error deleting job: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาดในการลบงาน: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('งานของฉัน'),
      ),
      body: FutureBuilder<List<JobDataList>>(
        future: _jobs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('เกิดข้อผิดพลาด: ${snapshot.error}'),
                  ElevatedButton(
                    onPressed: _loadJobs,
                    child: Text('ลองใหม่'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('ไม่พบงานที่คุณสร้าง'),
                  SizedBox(height: 16),
                  Text(
                      'userid: ${widget.userid}'), // แสดง userid เพื่อการตรวจสอบ
                ],
              ),
            );
          }

          final jobs = snapshot.data!;
          return ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    onTap: () => _showJobOptionsDialog(context, job),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.category,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'ราคา: ฿${job.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            job.details,
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showJobOptionsDialog(BuildContext context, JobDataList job) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('ตัวเลือก'),
          content: const Text('คุณต้องการทำอะไรกับงานนี้?'),
          actions: <Widget>[
            TextButton(
              child: const Text('แก้ไข'),
              onPressed: () {
                print(
                    'Editing job: ${job.userid}'); // Use job.userid or any unique field
                Navigator.pop(dialogContext);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditJobScreen(
                      jobid:
                          job.userid, // Pass the correct field to EditJobScreen
                      category: job.category,
                      price: job.price,
                      details: job.details,
                    ),
                  ),
                ).then((_) => _loadJobs());
              },
            ),
            TextButton(
              child: const Text('ลบ'),
              onPressed: () {
                Navigator.pop(dialogContext);
                _confirmDelete(context, job);
              },
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, JobDataList job) {
    showDialog(
      context: context,
      builder: (BuildContext confirmContext) {
        return AlertDialog(
          title: const Text('ยืนยันการลบ'),
          content: const Text('คุณแน่ใจหรือไม่ที่จะลบงานนี้?'),
          actions: <Widget>[
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () => Navigator.pop(confirmContext),
            ),
            TextButton(
              child: Text(
                'ลบ',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.pop(confirmContext);
                _deleteJob(job.userid, context); // Pass job.userid or job.jobid
              },
            ),
          ],
        );
      },
    );
  }
}
