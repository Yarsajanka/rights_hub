import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';


class ReportingScreen extends StatelessWidget {
  const ReportingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String incidentDescription = '';
    String imagePath = '';
    String audioPath = '';
    String videoPath = '';

    return Scaffold(
      appBar: AppBar(
        title: Text("Report Incident"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Incident Description"),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onChanged: (value) {
                  incidentDescription = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.image,
                  );
                  if (result != null) {
                    imagePath = result.files.single.path!;
                  }
                },
                child: Text("Select Image (PNG)"),
              ),
              ElevatedButton(
                onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.audio,
                  );
                  if (result != null) {
                    audioPath = result.files.single.path!;
                  }
                },
                child: Text("Select Audio (MP3)"),
              ),
              ElevatedButton(
                onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.video,
                  );
                  if (result != null) {
                    videoPath = result.files.single.path!;
                  }
                },
                child: Text("Select Video (MP4)"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    // Handle form submission
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Incident Description: $incidentDescription")),
                    );
                    // Here you can also handle the paths for image, audio, and video
                  }
                },
                child: Text("Submit Report"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
