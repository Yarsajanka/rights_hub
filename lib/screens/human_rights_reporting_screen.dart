import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/reporting_screen_model.dart';
import 'package:http/http.dart' as http;


class HumanRightsReportingScreen extends StatefulWidget {
  const HumanRightsReportingScreen({Key? key}) : super(key: key);

  @override
  _HumanRightsReportingScreenState createState() => _HumanRightsReportingScreenState();
}

class _HumanRightsReportingScreenState extends State<HumanRightsReportingScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  bool _isAnonymous = false;

  String? _audioUrl;
  String? _videoUrl;
  String? _photoUrl;
  String? _documentUrl;

  bool _isFileUploaded = false;
  bool _isAcknowledged = false;

  Future<String> _uploadFileToBackend(String filePath, String fileType) async {
    final uri = Uri.parse('http://localhost:3000/reports/upload');
    final request = http.MultipartRequest('POST', uri);
    final file = await http.MultipartFile.fromPath('file', filePath);
    request.files.add(file);

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final url = RegExp(r'"url":"(.*?)"').firstMatch(respStr)?.group(1);
        if (url != null) {
          return url;
        }
      }
      throw Exception('Failed to upload file');
    } catch (e) {
      print('File upload error: $e');
      return '';
    }
  }

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
      final filePath = result.files.single.path;
      print('Selected file path: $filePath');
      if (filePath != null) {
        String uploadedUrl = '';
        try {
          uploadedUrl = await _uploadFileToBackend(filePath, fileType);
          if (uploadedUrl.isNotEmpty) {
            setState(() {
              switch (fileType) {
                case 'audio':
                  _audioUrl = uploadedUrl;
                  break;
                case 'video':
                  _videoUrl = uploadedUrl;
                  break;
                case 'pdf':
                  _documentUrl = uploadedUrl;
                  break;
                case 'image':
                  _photoUrl = uploadedUrl;
                  break;
                case 'document':
                  _documentUrl = uploadedUrl;
                  break;
              }
              _isFileUploaded = true;
              _isAcknowledged = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("File uploaded successfully. Please acknowledge before submitting.")),
            );
          } else {
            throw Exception('Upload returned empty URL');
          }
        } catch (e) {
          print('File upload error: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("File upload failed: $e")),
          );
        }
      }
    }
  }

  void _submitReport() async {
    if (!_isAcknowledged && _isFileUploaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please acknowledge the file upload before submitting the report.")),
      );
      return;
    }

    final description = _descriptionController.text.trim();
    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a description")),
      );
      return;
    }

    final report = ReportingScreenModel(
      id: '',
      text: description,
      photoUrl: _photoUrl,
      videoUrl: _videoUrl,
      audioUrl: _audioUrl,
      documentUrl: _documentUrl,
      isAnonymous: _isAnonymous,
    );

    print('Submitting report: ${report.toMap()}');

    try {
      await FirebaseFirestore.instance.collection('reports').add(report.toMap());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Report submitted successfully")),
      );
      _descriptionController.clear();
      setState(() {
        _isAnonymous = false;
        _photoUrl = null;
        _videoUrl = null;
        _audioUrl = null;
        _documentUrl = null;
        _isFileUploaded = false;
        _isAcknowledged = false;
      });
    } catch (e) {
      print('Report submission error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to submit report: $e")),
      );
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Human Rights Violation Reporting"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Report an Incident",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: "Description of the incident",
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  value: _isAnonymous,
                  onChanged: (value) {
                    setState(() {
                      _isAnonymous = value ?? false;
                    });
                  },
                ),
                Flexible(child: Text("Report Anonymously")),
              ],
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await _pickFile('audio');
                    },
                    child: Text("Upload Audio"),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      await _pickFile('video');
                    },
                    child: Text("Upload Video"),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      await _pickFile('pdf');
                    },
                    child: Text("Upload PDF"),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      await _pickFile('image');
                    },
                    child: Text("Upload Image"),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      await _pickFile('document');
                    },
                    child: Text("Upload Document"),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            if (_isFileUploaded)
              Row(
                children: [
                  Checkbox(
                    value: _isAcknowledged,
                    onChanged: (value) {
                      setState(() {
                        _isAcknowledged = value ?? false;
                      });
                    },
                  ),
                  Expanded(child: Text("I acknowledge that the file has been uploaded")),
                ],
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: (_isFileUploaded && !_isAcknowledged) ? null : _submitReport,
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
