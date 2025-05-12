import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';  // Added import for FirebaseAuth
// Added Firestore import
import 'screens/human_rights_reporting_screen.dart'; // Importing the reporting screen
// Importing the Admin Dashboard
import 'screens/legal_aid_finder_screen.dart'; // Importing the Legal Aid Finder Screen
import 'screens/chat_screen.dart'; // Importing the Chat Screen
import 'screens/login_screen.dart'; // Importing the Login Screen
import 'screens/profile_screen.dart'; // Importing the Profile Screen

import 'package:flutter/foundation.dart' show kIsWeb;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('Starting Firebase initialization...');
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "YOUR_API_KEY",
        authDomain: "YOUR_AUTH_DOMAIN",
        projectId: "YOUR_PROJECT_ID",
        storageBucket: "YOUR_STORAGE_BUCKET",
        messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
        appId: "YOUR_APP_ID",
        measurementId: "YOUR_MEASUREMENT_ID",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  print('Firebase initialization completed.');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SHARP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0; // Track the selected index for bottom navigation

      void _onItemTapped(int index) {
    if (index == 1) {
      // Navigate to reporting screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HumanRightsReportingScreen()),
      );
    } else if (index == 2) {
      // Navigate to legal aid finder screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LegalAidFinderScreen()),
      );
    } else if (index == 3) {
      // Navigate to chat screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChatScreen()),
      );
    } else if (index == 4) {
      // Navigate to profile screen or login if not logged in
      var user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
      }
    }
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
  }

  // Sample posts data
  final List<Map<String, String>> posts = List.generate(5, (index) => {
        'image': 'assets/sharp_logo.png', // Use existing sharp_logo.png instead of missing images
        'description': 'This is post number ${index + 1}. Sharing important information about human rights.',
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search violations...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            // Navigation buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Column(
                    children: [
                      Text(
                        'Home',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        height: 2,
                        width: 20,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HumanRightsReportingScreen()),
                    );
                  },
                  child: Text(
                    'Report Violation',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Legal Aid',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // SHARP Logo and Mission
            Center(
              child: Column(
                children: [
                  Image.asset('assets/sharp_logo.png'),
                  SizedBox(height: 10),
                  Text(
                    "SHARP's mission is to provide accurate information and resources to empower individuals and communities.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Posts section
            // Add a label
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Recent Posts',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
              ),
            ),
            // List of posts
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return PostWidget(
                  imagePath: post['image']!,
                  description: post['description']!,
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.blue),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.file_copy, color: Colors.grey),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gavel, color: Colors.grey),
            label: 'Legal Aid',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat, color: Colors.grey),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.grey),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

// Widget for individual post
class PostWidget extends StatelessWidget {
  final String imagePath;
  final String description;

  const PostWidget({Key? key, required this.imagePath, required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post image or video thumbnail
            // For demonstration, using just an Image asset
            Image.asset(
              imagePath,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 8),
            // Description text
            Text(description),
            SizedBox(height: 8),
            // Buttons for Like and Comment
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                  onPressed: () {
                    // Handle like action
                  },
                  icon: Icon(Icons.thumb_up_alt_outlined),
                  label: Text('Like'),
                ),
                TextButton.icon(
                  onPressed: () {
                    // Handle comment action
                  },
                  icon: Icon(Icons.comment_outlined),
                  label: Text('Comment'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
