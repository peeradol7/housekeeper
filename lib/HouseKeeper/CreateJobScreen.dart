import 'package:flutter/material.dart';
import 'package:housekeeper/model/jobModel.dart';

import '../DatabaseHelper/dbhelper.dart';

class CreateJobScreen extends StatefulWidget {
  final String fullName;
  final String email;
  final int userid;
  final String contactNumber;

  const CreateJobScreen({
    Key? key,
    required this.fullName,
    required this.email,
    required this.userid,
    required this.contactNumber,
  }) : super(key: key);

  @override
  _CreateJobScreenState createState() => _CreateJobScreenState();
}

class _CreateJobScreenState extends State<CreateJobScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;
  double _price = 0;
  String _details = '';

  final JobsDatabaseHelper dbHelper = JobsDatabaseHelper();

  List<String> jobCategories = [
    'Laundry',
    'Chores',
    'Painter',
    'Car Wash',
    'Technical',
    'Electric Repair',
    'Vehicle Repair',
  ];
  @override
  void initState() {
    super.initState();
    dbHelper.checkDatabase();
    _checkDatabase();
  }

  Future<void> _checkDatabase() async {
    try {
      await dbHelper.checkDatabase();
    } catch (e) {
      print("Error checking database: $e");
    }
  }

  Future<void> _saveJob(JobData job, BuildContext context) async {
    try {
      if (dbHelper == null) {
        print("Database helper is not initialized.");
        return;
      }
      await dbHelper.saveJob(job);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Job created successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating job: $e')),
      );
      print("Error saving job: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ประกาศหางาน'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'ประกาศหางาน',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                hint: Text('เลือกประเภทงาน'),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                items: jobCategories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'กรุณาเลือกประเภทงาน';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'ราคา',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _price = double.tryParse(value) ?? 0;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกราคา';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'รายละเอียด',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _details = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกรายละเอียด';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  // เพิ่ม async
                  if (_formKey.currentState!.validate()) {
                    try {
                      JobData newJob = JobData(
                        userid: widget.userid,
                        fullName: widget.fullName,
                        email: widget.email,
                        contactNumber: widget.contactNumber,
                        category: _selectedCategory!,
                        price: _price,
                        details: _details,
                      );

                      print('Creating job with data: ${newJob.toMap()}');
                      await _saveJob(newJob, context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('บันทึกข้อมูลสำเร็จ')),
                      );
                      Navigator.pop(context);
                    } catch (e) {
                      print('Error in button press: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
                      );
                    }
                  }
                },
                child: Text('บันทึกงาน'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
