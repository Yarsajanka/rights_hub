import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
// Import the LoginScreen

class HumanRightsReportingScreen extends StatelessWidget {
  Future<void> _pickFile(String fileType) async {
    FilePickerResult? result;
    switch (fileType) {
      case 'audio':
        result = await FilePicker.platform.pickFiles(type: FileType.audio);
        break;
      case 'video':
        result = await FilePicker.platform.pickFiles(type: FileType.video);
        break;
      case 'pdf':
        result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
        break;
      case 'image':
        result = await FilePicker.platform.pickFiles(type: FileType.image);
        break;
      case 'document':
        result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['doc', 'docx']);
        break;
    }
    if (result != null) {
      // Handle the selected file
      print("File selected: ${result.files.single.name}");
    } else {
      // User canceled the picker
      print("No file selected");
    }
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text("Human Rights Violation Reporting"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Report an Incident",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: "Description of the incident",
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await _pickFile('audio');
                  },
                  child: Text("Upload Audio"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _pickFile('video');
                  },
                  child: Text("Upload Video"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _pickFile('pdf');
                  },
                  child: Text("Upload PDF"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _pickFile('image');
                  },
                  child: Text("Upload Image"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _pickFile('document');
                  },
                  child: Text("Upload Document"),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle submission logic here
                print("Report submitted");
              },
              child: Text("Submit"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.grey),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.file_copy, color: Colors.blue),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gavel, color: Colors.grey),
            label: 'Legal Aid',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book, color: Colors.grey),
            label: 'Resources',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.grey),
            label: 'Profile',
          ),
        ],
        currentIndex: 1, // Set the current index to Reports
        onTap: (index) {
          // Handle navigation based on the selected index
          if (index == 0) {
            Navigator.pop(context); // Navigate back to Home
          } else if (index == 1) {
            // Stay on the current screen
          } else if (index == 2) {
            // Navigate to Legal Aid screen (not implemented yet)
          } else if (index == 3) {
            // Navigate to Resources screen (not implemented yet)
          } else if (index == 4) {
            // Navigate to Profile screen (not implemented yet)
          }
        },
      ),
    );
  }
}
