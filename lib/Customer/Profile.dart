import 'package:flutter/material.dart';
import 'package:housekeeper/Customer/editProfile.dart';
import 'package:housekeeper/Login.dart';

class ProfileScreen extends StatelessWidget {
  final int userid;
  final String fullName;
  final String contactNumber;
  const ProfileScreen(
      {Key? key,
      required this.fullName,
      required this.userid,
      required this.contactNumber})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.green[300], // สีเขียวอ่อน
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // เพิ่ม padding รอบๆ
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                'Welcome Customer $fullName',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700], // ใช้สีเขียวเข้ม
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  // ปุ่มแก้ไขข้อมูล
                  ListTile(
                    tileColor: Colors.green[50], // พื้นหลังปุ่มเป็นสีเขียวอ่อน
                    title: Text(
                      'Edit Profile',
                      style: TextStyle(fontSize: 18, color: Colors.green[700]),
                    ),
                    leading: Icon(
                      Icons.edit,
                      color: Colors.green[700],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(
                            userid: userid,
                            fullName: fullName,
                          ),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    tileColor: Colors.green[50],
                    title: Text(
                      'Logout',
                      style: TextStyle(fontSize: 18, color: Colors.green[700]),
                    ),
                    leading: Icon(
                      Icons.logout,
                      color: Colors.green[700],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
