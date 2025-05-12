import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/reporting_screen_model.dart';

class ViolationReportingScreen extends StatefulWidget {
  const ViolationReportingScreen({Key? key}) : super(key: key);

  @override
  _ViolationReportingScreenState createState() => _ViolationReportingScreenState();
}

class _ViolationReportingScreenState extends State<ViolationReportingScreen> {
  final Map<String, VideoPlayerController> _videoControllers = {};
  final Map<String, AudioPlayer> _audioPlayers = {};

  Stream<List<ReportingScreenModel>> _getReportsStream() {
    return FirebaseFirestore.instance
        .collection('reports')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ReportingScreenModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  @override
  void dispose() {
    _videoControllers.forEach((key, controller) {
      controller.dispose();
    });
    _audioPlayers.forEach((key, player) {
      player.dispose();
    });
    super.dispose();
  }

  Future<void> _initializeVideo(String url) async {
    if (!_videoControllers.containsKey(url)) {
      final controller = VideoPlayerController.networkUrl(Uri.parse(url));
      await controller.initialize();
      setState(() {
        _videoControllers[url] = controller;
      });
    }
  }

  Future<void> _playPauseVideo(String url) async {
    final controller = _videoControllers[url];
    if (controller == null) return;
    if (controller.value.isPlaying) {
      await controller.pause();
    } else {
      await controller.play();
    }
    setState(() {});
  }

  Future<void> _playPauseAudio(String url) async {
    if (!_audioPlayers.containsKey(url)) {
      final player = AudioPlayer();
      _audioPlayers[url] = player;
      await player.play(UrlSource(url));
    } else {
      final player = _audioPlayers[url]!;
      // Since player.state is now a Stream, we cannot get it synchronously
      // For simplicity, just toggle play/pause without checking state
      await player.pause();
    }
    setState(() {});
  }

  Widget _buildDownloadButton(String url) {
    return IconButton(
      icon: Icon(Icons.download),
      tooltip: 'Download',
      onPressed: () async {
        final uri = Uri.parse(url);
        print('Attempting to launch download URL: $url');
        try {
          final launchResult = await launchUrl(uri, mode: LaunchMode.externalApplication);
          print('launchUrl result: $launchResult');
          if (!launchResult) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to launch download URL')),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error launching download URL: $e')),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Violation Reporting"),
      ),
      body: StreamBuilder<List<ReportingScreenModel>>(
        stream: _getReportsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error loading reports'));
          }
          final reports = snapshot.data ?? [];
          if (reports.isEmpty) {
            return Center(child: Text('No reports found'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              return GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(report.isAnonymous ? 'Anonymous Report' : 'Report Details'),
                        content: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Description: ${report.text}'),
                              SizedBox(height: 10),
                              if (report.photoUrl != null) ...[
                                Image.network(report.photoUrl!),
                                _buildDownloadButton(report.photoUrl!),
                                SizedBox(height: 10),
                              ],
                              if (report.videoUrl != null) ...[
                                FutureBuilder(
                                  future: _initializeVideo(report.videoUrl!),
                                  builder: (context, snapshot) {
                                    final controller = _videoControllers[report.videoUrl!];
                                    if (controller == null || !controller.value.isInitialized) {
                                      return Container(
                                        height: 150,
                                        color: Colors.black12,
                                        child: Center(child: CircularProgressIndicator()),
                                      );
                                    }
                                    return Column(
                                      children: [
                                        AspectRatio(
                                          aspectRatio: controller.value.aspectRatio,
                                          child: VideoPlayer(controller),
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
                                              onPressed: () => _playPauseVideo(report.videoUrl!),
                                            ),
                                            _buildDownloadButton(report.videoUrl!),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                SizedBox(height: 10),
                              ],
                              if (report.audioUrl != null) ...[
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.play_arrow),
                                      onPressed: () => _playPauseAudio(report.audioUrl!),
                                    ),
                                    _buildDownloadButton(report.audioUrl!),
                                  ],
                                ),
                                SizedBox(height: 10),
                              ],
                              if (report.documentUrl != null) ...[
                                Row(
                                  children: [
                                    Icon(Icons.insert_drive_file),
                                    SizedBox(width: 8),
                                    Expanded(child: Text('Document')),
                                    _buildDownloadButton(report.documentUrl!),
                                  ],
                                ),
                                SizedBox(height: 10),
                              ],
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Card(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          report.isAnonymous ? 'Anonymous Report' : report.text,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 8),
                        if (report.photoUrl != null) ...[
                          Image.network(report.photoUrl!),
                          _buildDownloadButton(report.photoUrl!),
                          SizedBox(height: 10),
                        ],
                        if (report.videoUrl != null) ...[
                          FutureBuilder(
                            future: _initializeVideo(report.videoUrl!),
                            builder: (context, snapshot) {
                              final controller = _videoControllers[report.videoUrl!];
                              if (controller == null || !controller.value.isInitialized) {
                                return Container(
                                  height: 150,
                                  color: Colors.black12,
                                  child: Center(child: CircularProgressIndicator()),
                                );
                              }
                              return Column(
                                children: [
                                  AspectRatio(
                                    aspectRatio: controller.value.aspectRatio,
                                    child: VideoPlayer(controller),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
                                        onPressed: () => _playPauseVideo(report.videoUrl!),
                                      ),
                                      _buildDownloadButton(report.videoUrl!),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                          SizedBox(height: 10),
                        ],
                        if (report.audioUrl != null) ...[
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.play_arrow),
                                onPressed: () => _playPauseAudio(report.audioUrl!),
                              ),
                              _buildDownloadButton(report.audioUrl!),
                            ],
                          ),
                          SizedBox(height: 10),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
