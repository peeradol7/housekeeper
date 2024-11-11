import 'package:flutter/material.dart';

import 'EmployeeProfile.dart';
import 'HomeScreen.dart';
import 'Menu.dart';

class NextScreenEmployee extends StatefulWidget {
  final String fullName;
  final String email;
  final int userid;
  final String contactNumber;

  const NextScreenEmployee({
    Key? key,
    required this.fullName,
    required this.email,
    required this.userid,
    required this.contactNumber,
  }) : super(key: key);

  @override
  _NextScreenEmployeeState createState() => _NextScreenEmployeeState();
}

class _NextScreenEmployeeState extends State<NextScreenEmployee> {
  int _selectedIndex = 0;

  // สร้าง list ของ pages และส่งข้อมูลจาก widget ไปที่หน้าต่างๆ
  final List<Widget> _pages = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    // สร้าง pages ให้ตรงกับข้อมูลที่ถูกส่งมา
    _pages.add(EmployeeHomeScreen(fullName: widget.fullName));
    _pages.add(MenuScreen(
      fullName: widget.fullName,
      email: widget.email,
      userid: widget.userid,
      contactNumber: widget.contactNumber,
    ));
    _pages.add(EmployeeProfileScreen(
      fullName: widget.fullName,
      contactNumber: widget.contactNumber,
      userid: widget.userid,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${widget.fullName}'),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages, // ใช้ IndexedStack เพื่อไม่ให้มีการทำ animation
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'หน้าหลัก',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'งาน',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'โปรไฟล์',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue, // สีเมื่อเลือก
        unselectedItemColor: Colors.grey, // สีเมื่อไม่ได้เลือก (สีเทา)
        onTap: _onItemTapped, // ฟังก์ชันในการเปลี่ยนหน้า
      ),
    );
  }
}
