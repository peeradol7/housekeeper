import 'package:flutter/material.dart';

class EmployeeHomeScreen extends StatelessWidget {
  final String fullName;

  const EmployeeHomeScreen({Key? key, required this.fullName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(automaticallyImplyLeading: false, title: const Text("Home")),
      backgroundColor: Colors.green[100],
      body: Column(
        children: [
          // Image at the top, taking up 1/4 of the screen height
          Container(
            height: MediaQuery.of(context).size.height / 4,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/housekeeper.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
