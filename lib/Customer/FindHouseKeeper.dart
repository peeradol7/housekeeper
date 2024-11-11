import 'package:flutter/material.dart';

import '../DatabaseHelper/CustomerjobDB.dart';

class FindHouseKeeperScreen extends StatefulWidget {
  final int userid;
  final String fullName;
  final String contactNumber;

  const FindHouseKeeperScreen({
    Key? key,
    required this.userid,
    required this.fullName,
    required this.contactNumber,
  }) : super(key: key);

  @override
  _FindHouseKeeperScreenState createState() => _FindHouseKeeperScreenState();
}

class _FindHouseKeeperScreenState extends State<FindHouseKeeperScreen> {
  final DatabasejobHelper _databaseHelper = DatabasejobHelper();
  bool _isLoading = false;

  final List<String> jobCategories = [
    'Laundry',
    'Chores',
    'Painter',
    'Car Wash',
    'Technical',
    'Electric Repair',
    'Vehicle Repair',
  ];

  String? selectedCategory;
  final TextEditingController addressController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  Future<void> _saveJob() async {
    if (selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('กรุณาเลือกประเภทงาน')),
      );
      return;
    }
    if (addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('กรุณากรอกที่อยู่')),
      );
      return;
    }
    if (detailsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('กรุณากรอกรายละเอียดเพิ่มเติม')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final jobData = {
        'userid': widget.userid,
        'fullName': widget.fullName,
        'contactNumber': widget.contactNumber,
        'categories': selectedCategory!,
        'address': addressController.text,
        'details': detailsController.text,
      };

      final jobcustomerId = await _databaseHelper.insertJob(jobData);
      print("Job ID: $jobcustomerId");

      if (jobcustomerId > 0) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('บันทึกข้อมูลสำเร็จ')),
          );
          setState(() {
            selectedCategory = null;
            addressController.clear();
            detailsController.clear();
          });
          Navigator.pop(context);
        }
      }
    } catch (e) {
      print(e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ประกาศหาแม่บ้าน"),
        backgroundColor: Colors.green[100],
        foregroundColor: Colors.green[800],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "เลือกประเภทงาน",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: jobCategories.map((category) {
                  final isSelected = selectedCategory == category;
                  return FilterChip(
                    selected: isSelected,
                    label: Text(category),
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = selected ? category : null;
                      });
                    },
                    selectedColor: Colors.green[200],
                    checkmarkColor: Colors.green[800],
                    backgroundColor: Colors.green[50],
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.green[800] : Colors.green[900],
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 24),
              Text(
                "ที่อยู่",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: addressController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "กรุณากรอกที่อยู่",
                  filled: true,
                  fillColor: Colors.green[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.green.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.green.shade400),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Text(
                "รายละเอียดเพิ่มเติม",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: detailsController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "กรุณากรอกรายละเอียดเพิ่มเติม",
                  filled: true,
                  fillColor: Colors.green[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.green.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.green.shade400),
                  ),
                ),
              ),
              SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveJob,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[400],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          "ยืนยัน",
                          style: TextStyle(fontSize: 18),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
