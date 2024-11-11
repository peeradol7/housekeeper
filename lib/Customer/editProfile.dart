import 'package:flutter/material.dart';
import 'package:housekeeper/DatabaseHelper/dbhelper.dart';

class EditProfileScreen extends StatefulWidget {
  final int userid;
  final String fullName;

  const EditProfileScreen(
      {Key? key, required this.userid, required this.fullName})
      : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;
  late JobsDatabaseHelper _dbHelper;

  @override
  void initState() {
    super.initState();
    _dbHelper = JobsDatabaseHelper();

    _loadUserData();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    super.dispose();
    _loadUserData();
    _dbHelper = JobsDatabaseHelper();
  }

  Future<void> _loadUserData() async {
    try {
      setState(() => _isLoading = true);
      final db = await _dbHelper.database;
      final result = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [widget.userid],
      );
      if (result.isNotEmpty) {
        var userData = result.first;
        setState(() {
          _fullNameController.text = userData['fullName'] as String;
          _emailController.text = userData['email'] as String;
        });
      }
    } catch (e) {
      setState(
          () => _errorMessage = 'Failed to load user data: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    // ตรวจสอบว่า _fullNameController.text และ _emailController.text ไม่เป็น null หรือว่าง
    String fullName = _fullNameController.text.trim();
    String email = _emailController.text.trim();

    if (fullName.isEmpty || email.isEmpty) {
      setState(() {
        _errorMessage = 'Full Name and Email cannot be empty';
      });
      return;
    }

    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      await _dbHelper.updateUser(
        widget.userid,
        fullName,
        email,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.green[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _fullNameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text('Save'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[300],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
