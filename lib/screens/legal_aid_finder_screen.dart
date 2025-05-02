import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class LegalAidFinderScreen extends StatefulWidget {
  @override
  _LegalAidFinderScreenState createState() => _LegalAidFinderScreenState();
}

class _LegalAidFinderScreenState extends State<LegalAidFinderScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _advocates = [
    {
      'name': 'John Doe',
      'specialty': 'Human Rights',
      'contact': 'john.doe@example.com',
    },
    {
      'name': 'Jane Smith',
      'specialty': 'Criminal Law',
      'contact': 'jane.smith@example.com',
    },
    {
      'name': 'Alice Johnson',
      'specialty': 'Family Law',
      'contact': 'alice.johnson@example.com',
    },
  ];

  List<Map<String, String>> _filteredAdvocates = [];

  @override
  void initState() {
    super.initState();
    _filteredAdvocates = _advocates;
    _searchController.addListener(_filterAdvocates);
  }

  void _filterAdvocates() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredAdvocates = _advocates.where((advocate) {
        return advocate['name']!.toLowerCase().contains(query) ||
            advocate['specialty']!.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result != null) {
      // Handle the selected document
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selected document: ${result.files.single.name}')),
      );
    }
  }

  void _scheduleAppointment(String advocateName) {
    // Placeholder for appointment scheduling logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Appointment scheduled with $advocateName')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Legal Aid Finder"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Advocates',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: _filteredAdvocates.isEmpty
                  ? Center(child: Text('No advocates found'))
                  : ListView.builder(
                      itemCount: _filteredAdvocates.length,
                      itemBuilder: (context, index) {
                        final advocate = _filteredAdvocates[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(advocate['name']!),
                            subtitle: Text(advocate['specialty']!),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.calendar_today),
                                  tooltip: 'Schedule Appointment',
                                  onPressed: () => _scheduleAppointment(advocate['name']!),
                                ),
                                IconButton(
                                  icon: Icon(Icons.upload_file),
                                  tooltip: 'Upload Document',
                                  onPressed: _pickDocument,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
