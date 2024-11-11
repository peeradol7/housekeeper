import 'package:flutter/material.dart';
import 'package:housekeeper/DatabaseHelper/dbhelper.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/jobModel.dart';

class EditJobScreen extends StatefulWidget {
  final int jobid;
  final String category;
  final double price;
  final String details;

  const EditJobScreen({
    Key? key,
    required this.jobid,
    required this.category,
    required this.price,
    required this.details,
  }) : super(key: key);

  @override
  _EditJobScreenState createState() => _EditJobScreenState();
}

class _EditJobScreenState extends State<EditJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final JobsDatabaseHelper dbhelper = JobsDatabaseHelper();

  List<JobData> _jobs = []; // Declare _jobs as an empty list of JobData
  bool _isJobLoaded = false; // To track if jobs are loaded
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  List<String> jobCategories = [
    'Laundry',
    'Chores',
    'Painter',
    'Car Wash',
    'Technical',
    'Electric Repair',
    'Vehicle Repair',
  ];

  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _initializeDb();
    _loadJobData();
  }

  Future<Database> _initializeDb() async {
    return openDatabase(
      join(await getDatabasesPath(), 'sqlite.db'),
      version: 1,
    );
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _priceController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _updateJob(BuildContext context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(child: CircularProgressIndicator());
        },
      );

      final updatedCategory = _categoryController.text.trim();
      final updatedPrice = double.tryParse(_priceController.text);
      final updatedDetails = _detailsController.text.trim();

      if (updatedCategory.isEmpty || updatedDetails.isEmpty) {
        throw 'Please fill in all required fields';
      }

      if (updatedPrice == null || updatedPrice < 0) {
        throw 'Please enter a valid price';
      }

      final dbHelper = JobsDatabaseHelper();
      final success = await dbHelper.updateJob(
          widget.jobid, updatedCategory, updatedPrice, updatedDetails);

      if (!mounted) return;
      Navigator.pop(context);

      if (success) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Job updated successfully'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate back
        Navigator.pop(context, true);
      } else {
        throw 'Failed to update job';
      }
    } catch (e) {
      // Hide loading indicator if showing
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      // Show error message
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _loadJobData() async {
    final db = await _initializeDb();

    final List<Map<String, dynamic>> jobData = await db.query(
      'jobs',
      where: 'userid = ?',
      whereArgs: [widget.jobid], // Assuming widget.id is the userId
    );

    if (jobData.isNotEmpty) {
      setState(() {
        // Assuming JobData.fromMap() can handle multiple rows of job data.
        _jobs = jobData
            .map((job) => JobData.fromMap(job))
            .toList(); // Change this to handle multiple jobs
        _isJobLoaded = true; // Set to true when data is loaded
      });
    } else {
      print('No jobs found for userId: ${widget.jobid}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Job'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                hint: Text('เลือกประเภทงาน'),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                    _categoryController.text = newValue ?? '';
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
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _detailsController,
                decoration: InputDecoration(labelText: 'Details'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter details';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _updateJob(context),
                child: Text('Update Job'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
