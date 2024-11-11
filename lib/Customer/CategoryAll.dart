import 'package:flutter/material.dart';
import 'package:housekeeper/Customer/jobCategory/CarWash.dart';
import 'package:housekeeper/Customer/jobCategory/ElectricRepair.dart';
import 'package:housekeeper/Customer/jobCategory/Laundry.dart';
import 'package:housekeeper/Customer/jobCategory/Painting.dart';
import 'package:housekeeper/Customer/jobCategory/Technical.dart';
import 'package:housekeeper/Customer/jobCategory/VihicleRepair.dart';

class ShowCategoryAll extends StatelessWidget {
  final int userid;
  final String fullName;
  final String contactNumber;

  ShowCategoryAll({
    Key? key,
    required this.userid,
    required this.fullName,
    required this.contactNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            CategoryItem(
              icon: Icons.local_laundry_service,
              label: 'Laundry',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CategoryLaundryScreen(
                          userid: userid,
                          fullName: fullName,
                          contactNumber: contactNumber,
                        )),
              ),
            ),
            CategoryItem(
              icon: Icons.format_paint,
              label: 'Painter',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CategoryPaintingScreen(
                          userid: userid,
                          fullName: fullName,
                          contactNumber: contactNumber,
                        )),
              ),
            ),
            CategoryItem(
              icon: Icons.local_car_wash,
              label: 'Car Wash',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CategoryCarWashScreen(
                          userid: userid,
                          fullName: fullName,
                          contactNumber: contactNumber,
                        )),
              ),
            ),
            CategoryItem(
              icon: Icons.settings,
              label: 'Technical',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CategoryTechnicalScreen(
                          userid: userid,
                          fullName: fullName,
                          contactNumber: contactNumber,
                        )),
              ),
            ),
            CategoryItem(
              icon: Icons.build_circle,
              label: 'Vehicle Repair',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CategoryVihicleRepairScreen(
                          userid: userid,
                          fullName: fullName,
                          contactNumber: contactNumber,
                        )),
              ),
            ),
            CategoryItem(
              icon: Icons.electrical_services,
              label: 'Electric Repair',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CategoryElectricRepairScreen(
                          userid: userid,
                          fullName: fullName,
                          contactNumber: contactNumber,
                        )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap; // เพิ่ม onTap callback

  const CategoryItem(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // เมื่อคลิกที่ CategoryItem จะเรียก onTap
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.black54,
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

// class ShowCategoryAll extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: GridView.count(
//           crossAxisCount: 2,
//           mainAxisSpacing: 16,
//           crossAxisSpacing: 16,
//           childAspectRatio: 1.5,
//           children: [
//             CategoryItem(icon: Icons.local_laundry_service, label: 'Laundry'),
//             CategoryItem(icon: Icons.home, label: 'Chores'),
//             CategoryItem(icon: Icons.brush, label: 'Painter'),
//             CategoryItem(icon: Icons.local_car_wash, label: 'Car Wash'),
//             CategoryItem(icon: Icons.carpenter, label: 'Technical'),
//             CategoryItem(
//                 icon: Icons.electrical_services, label: 'Electric Repair'),
//             CategoryItem(icon: Icons.build, label: 'AC Repair'),
//             CategoryItem(icon: Icons.plumbing, label: 'Plumbing'),
//             CategoryItem(icon: Icons.settings, label: 'Vehicle Repair'),
//           ],
//         ),
//       ),
//     );
//   }
// }

