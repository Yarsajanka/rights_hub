import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add this import

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    String displayName = user?.displayName ?? 'No Name';
    String email = user?.email ?? 'No Email';

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>( // Specify the generic type
          future: FirebaseFirestore.instance.collection('users').doc(user?.uid).get(),
          builder: (context, snapshot) {
            String username = 'Loading...';
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData && snapshot.data!.exists) {
                var data = snapshot.data!.data()!;
                username = data['username'] ?? 'No Username';
              } else {
                username = 'No Username';
              }
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: $displayName', style: TextStyle(fontSize: 18)),
                SizedBox(height: 8),
                Text('Email: $email', style: TextStyle(fontSize: 18)),
                SizedBox(height: 8),
                Text('Username: $username', style: TextStyle(fontSize: 18)),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement change password functionality
                  },
                  child: Text('Change Password'),
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement change email functionality
                  },
                  child: Text('Change Email'),
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement change username functionality
                  },
                  child: Text('Change Username'),
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    // After logout, navigate to login screen and remove all previous routes
                    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                  },
                  child: Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
