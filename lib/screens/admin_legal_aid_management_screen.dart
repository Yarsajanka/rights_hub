import 'package:flutter/material.dart';

class AdminLegalAidManagementScreen extends StatefulWidget {
  @override
  _AdminLegalAidManagementScreenState createState() => _AdminLegalAidManagementScreenState();
}

class _AdminLegalAidManagementScreenState extends State<AdminLegalAidManagementScreen> {
  final List<Map<String, String>> _advocates = [
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
  ];

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _specialtyController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  void _addAdvocate() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _advocates.add({
          'name': _nameController.text,
          'specialty': _specialtyController.text,
          'contact': _contactController.text,
        });
        _nameController.clear();
        _specialtyController.clear();
        _contactController.clear();
      });
      Navigator.of(context).pop();
    }
  }

  void _showAddAdvocateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Advocate'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) => value == null || value.isEmpty ? 'Enter name' : null,
                ),
                TextFormField(
                  controller: _specialtyController,
                  decoration: InputDecoration(labelText: 'Specialty'),
                  validator: (value) => value == null || value.isEmpty ? 'Enter specialty' : null,
                ),
                TextFormField(
                  controller: _contactController,
                  decoration: InputDecoration(labelText: 'Contact'),
                  validator: (value) => value == null || value.isEmpty ? 'Enter contact' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _addAdvocate,
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _removeAdvocate(int index) {
    setState(() {
      _advocates.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Legal Aid Advocates'),
      ),
      body: ListView.builder(
        itemCount: _advocates.length,
        itemBuilder: (context, index) {
          final advocate = _advocates[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(advocate['name'] ?? ''),
              subtitle: Text('${advocate['specialty'] ?? ''}\n${advocate['contact'] ?? ''}'),
              isThreeLine: true,
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => _removeAdvocate(index),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddAdvocateDialog,
        child: Icon(Icons.add),
        tooltip: 'Add Advocate',
      ),
    );
  }
}
