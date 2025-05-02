import 'package:flutter/material.dart';
import 'violation_reporting_screen.dart';
import 'admin_chat_list_screen.dart';
import 'admin_legal_aid_management_screen.dart';
import 'prisoner_management_screen.dart';
import 'awareness_training_screen.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Dashboard"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Welcome to the Admin Dashboard"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to Violation Reporting Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViolationReportingScreen()),
                );
              },
              child: Text("View Violation Reports"),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to Admin Chat List Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminChatListScreen()),
                );
              },
              child: Text("Chat with Users"),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to Admin Legal Aid Management Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminLegalAidManagementScreen()),
                );
              },
              child: Text("Manage Legal Aid"),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to Prisoner Management Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PrisonerManagementScreen()),
                );
              },
              child: Text("Manage Prisoners"),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to Awareness and Training Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AwarenessTrainingScreen()),
                );
              },
              child: Text("Manage Awareness & Training"),
            ),
          ],
        ),
      ),
    );
  }
}
