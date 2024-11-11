import 'package:flutter/material.dart';
import 'package:housekeeper/Customer/CategoryAll.dart';
import 'package:housekeeper/Customer/FindHouseKeeper.dart';
import 'package:housekeeper/Customer/Profile.dart';
import 'package:housekeeper/Customer/jobCategory/CarWash.dart';
import 'package:housekeeper/Customer/jobCategory/Chores.dart';
import 'package:housekeeper/Customer/jobCategory/ElectricRepair.dart';
import 'package:housekeeper/Customer/jobCategory/Laundry.dart';
import 'package:housekeeper/Customer/jobCategory/Painting.dart';
import 'package:housekeeper/Customer/jobCategory/Technical.dart';
import 'package:housekeeper/Customer/myJobFindid.dart';

class HomePage extends StatefulWidget {
  final int userid;
  final String fullName;
  final String contactNumber;
  HomePage(
      {required this.userid,
      required this.fullName,
      required this.contactNumber});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void navigateToCategoryDetail(BuildContext context, String category) {
    switch (category) {
      case 'Car wash':
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CategoryCarWashScreen(
                    userid: widget.userid,
                    fullName: widget.fullName,
                    contactNumber: widget.contactNumber,
                  )),
        );
        break;
      case 'Chores':
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CategoryChoresScreen(
                    userid: widget.userid,
                    fullName: widget.fullName,
                    contactNumber: widget.contactNumber,
                  )),
        );
        break;
      case 'Painting':
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CategoryPaintingScreen(
                    userid: widget.userid,
                    fullName: widget.fullName,
                    contactNumber: widget.contactNumber,
                  )),
        );
        break;
      case 'Laundry':
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CategoryLaundryScreen(
                    userid: widget.userid,
                    fullName: widget.fullName,
                    contactNumber: widget.contactNumber,
                  )),
        );
        break;
      case 'Technical':
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CategoryTechnicalScreen(
                    userid: widget.userid,
                    fullName: widget.fullName,
                    contactNumber: widget.contactNumber,
                  )),
        );
        break;
      case 'Electric Repair':
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CategoryElectricRepairScreen(
                    userid: widget.userid,
                    fullName: widget.fullName,
                    contactNumber: widget.contactNumber,
                  )),
        );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      HomePage(
        userid: widget.userid,
        fullName: widget.fullName,
        contactNumber: widget.contactNumber,
      ),
      ShowCategoryAll(
        userid: widget.userid,
        fullName: widget.fullName,
        contactNumber: widget.contactNumber,
      ), // Show all categories
      ProfileScreen(
        fullName: widget.fullName,
        contactNumber: widget.contactNumber, // Pass the actual fullName value
        userid: widget.userid, // Pass the actual id value
      ), // Profile screen
    ];

    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: _currentIndex == 0
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "รายการแนะนำ",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CategoryItem(
                        icon: Icons.local_car_wash,
                        label: 'Car wash',
                        onTap: () =>
                            navigateToCategoryDetail(context, 'Car wash'),
                      ),
                      CategoryItem(
                        icon: Icons.home,
                        label: 'Chores',
                        onTap: () =>
                            navigateToCategoryDetail(context, 'Chores'),
                      ),
                      CategoryItem(
                        icon: Icons.format_paint,
                        label: 'Painting',
                        onTap: () =>
                            navigateToCategoryDetail(context, 'Painting'),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FindHouseKeeperScreen(
                            userid: widget.userid,
                            fullName: widget.fullName,
                            contactNumber: widget.contactNumber,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      margin: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
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
                      child: Text(
                        "ประกาศหาแม่บ้าน",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DisplayMyjobScreen(
                            userid: widget.userid,
                            fullName: widget.fullName,
                            contactNumber: widget.contactNumber,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      margin: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
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
                      child: Text(
                        "งานที่ฉันประกาศ",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShowCategoryAll(
                                      userid: widget.userid,
                                      fullName: widget.fullName,
                                      contactNumber: widget.contactNumber,
                                    )),
                          );
                        },
                        child: Text("ดูรายการทั้งหมด"),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _currentIndex, // Track the selected index
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped, // Handle the tap event
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const CategoryItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 30,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
