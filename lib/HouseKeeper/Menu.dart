import 'package:flutter/material.dart';
import 'package:housekeeper/HouseKeeper/DisplayJob.dart';
import 'package:housekeeper/HouseKeeper/MyjobScreen.dart';

import 'CreateJobScreen.dart';

class MenuScreen extends StatelessWidget {
  final String fullName;
  final String email;
  final int userid;

  final String contactNumber;
  const MenuScreen(
      {Key? key,
      required this.fullName,
      required this.email,
      required this.userid,
      required this.contactNumber})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Menu'),
        backgroundColor: Colors.green, // AppBar color
      ),
      body: Container(
        color: Colors.green[50], // Light green background
        padding: EdgeInsets.all(16), // Add padding around the content
        child: ListView(
          children: <Widget>[
            // Display full name at the top
            Text(
              '',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30), // Add space between name and buttons

            // Button 1: Create Job
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Button color
                padding:
                    EdgeInsets.symmetric(vertical: 15), // Padding inside button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateJobScreen(
                      userid: userid,
                      contactNumber: contactNumber,
                      fullName: fullName,
                      email: email,
                    ),
                  ),
                );
              },
              child: Text(
                '1. ประกาศหางาน',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DisplayjobScreen(fullName: fullName),
                  ),
                );
              },
              child: Text(
                '2. แสดงงานทั้งหมด',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(height: 20), // Space between buttons

            // Button 3: My Jobs
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Button color
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyJobScreen(
                      jobid: 0,
                      userid: userid,
                      fullName: fullName,
                      email: email,
                    ),
                  ),
                );
              },
              child: Text(
                '3. งานของฉัน',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
