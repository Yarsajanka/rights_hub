import 'package:flutter/material.dart';

class ViolationReportingScreen extends StatelessWidget {
  final List<Map<String, dynamic>> sampleReports = [
    {
      'id': '1',
      'text': 'Unauthorized detention reported near city center.',
      'photoUrl': 'https://via.placeholder.com/150',
      'videoUrl': null,
      'audioUrl': null,
    },
    {
      'id': '2',
      'text': 'Physical abuse reported in detention facility.',
      'photoUrl': null,
      'videoUrl': 'https://sample-videos.com/video123/mp4/240/big_buck_bunny_240p_1mb.mp4',
      'audioUrl': null,
    },
    {
      'id': '3',
      'text': 'Verbal threats recorded during protest.',
      'photoUrl': null,
      'videoUrl': null,
      'audioUrl': 'https://sample-videos.com/audio/mp3/crowd-cheering.mp3',
    },
    {
      'id': '4',
      'text': 'Protesters holding banners in the city square.',
      'photoUrl': 'https://via.placeholder.com/150',
      'videoUrl': null,
      'audioUrl': null,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Violation Reporting"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: sampleReports.length,
        itemBuilder: (context, index) {
          final report = sampleReports[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    report['text'] ?? '',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8),
                  if (report['photoUrl'] != null)
                    Image.network(report['photoUrl']),
                  if (report['videoUrl'] != null)
                    Container(
                      height: 150,
                      color: Colors.black12,
                      child: Center(
                        child: Icon(Icons.videocam, size: 50, color: Colors.grey),
                      ),
                    ),
                  if (report['audioUrl'] != null)
                    Container(
                      height: 50,
                      color: Colors.black12,
                      child: Center(
                        child: Icon(Icons.audiotrack, size: 30, color: Colors.grey),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
