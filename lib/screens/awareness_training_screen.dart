import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class AwarenessTrainingScreen extends StatefulWidget {
  @override
  _AwarenessTrainingScreenState createState() => _AwarenessTrainingScreenState();
}

class _AwarenessTrainingScreenState extends State<AwarenessTrainingScreen> {
  final List<Map<String, dynamic>> _posts = [
    {
      'id': '1',
      'description': 'Human rights awareness campaign video.',
      'mediaType': 'video',
      'mediaUrl': 'https://sample-videos.com/video123/mp4/240/big_buck_bunny_240p_1mb.mp4',
      'likes': 10,
      'comments': ['Great initiative!', 'Very informative.'],
    },
    {
      'id': '2',
      'description': 'Photo from recent legal aid workshop.',
      'mediaType': 'photo',
      'mediaUrl': 'https://via.placeholder.com/300',
      'likes': 7,
      'comments': ['Thanks for sharing!', 'Helpful session.'],
    },
    {
      'id': '3',
      'description': 'Training session on prisoner rights.',
      'mediaType': 'video',
      'mediaUrl': 'https://sample-videos.com/video123/mp4/240/big_buck_bunny_240p_1mb.mp4',
      'likes': 5,
      'comments': ['Important topic.', 'Well presented.'],
    },
    {
      'id': '4',
      'description': 'Awareness poster on legal rights.',
      'mediaType': 'photo',
      'mediaUrl': 'https://via.placeholder.com/300',
      'likes': 12,
      'comments': ['Very useful.', 'Thanks!'],
    },
    {
      'id': '5',
      'description': 'Community outreach event highlights.',
      'mediaType': 'photo',
      'mediaUrl': 'https://via.placeholder.com/300',
      'likes': 8,
      'comments': ['Great work!', 'Keep it up!'],
    },
  ];

  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedMediaType;
  String? _selectedMediaUrl;

  Future<void> _pickMedia() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.media,
    );
    if (result != null) {
      setState(() {
        _selectedMediaUrl = result.files.single.path;
        final extension = result.files.single.extension?.toLowerCase();
        if (extension == 'mp4' || extension == 'mov' || extension == 'avi') {
          _selectedMediaType = 'video';
        } else if (extension == 'jpg' || extension == 'jpeg' || extension == 'png' || extension == 'gif') {
          _selectedMediaType = 'photo';
        } else {
          _selectedMediaType = null;
        }
      });
    }
  }

  void _addPost() {
    if (_descriptionController.text.isEmpty || _selectedMediaUrl == null || _selectedMediaType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please provide description and select media')),
      );
      return;
    }
    setState(() {
      _posts.insert(0, {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'description': _descriptionController.text,
        'mediaType': _selectedMediaType,
        'mediaUrl': _selectedMediaUrl,
        'likes': 0,
        'comments': [],
      });
      _descriptionController.clear();
      _selectedMediaType = null;
      _selectedMediaUrl = null;
    });
  }

  void _deletePost(String id) {
    setState(() {
      _posts.removeWhere((post) => post['id'] == id);
    });
  }

  void _likePost(int index) {
    setState(() {
      _posts[index]['likes'] = (_posts[index]['likes'] ?? 0) + 1;
    });
  }

  void _addComment(int index, String comment) {
    setState(() {
      _posts[index]['comments'].add(comment);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Awareness & Training'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _pickMedia,
                  icon: Icon(Icons.upload_file),
                  label: Text('Upload Photo/Video'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _addPost,
                  child: Text('Add Post'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: _posts.isEmpty
                  ? Center(child: Text('No posts available'))
                  : ListView.builder(
                      itemCount: _posts.length,
                      itemBuilder: (context, index) {
                        final post = _posts[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(post['description'] ?? '', style: TextStyle(fontSize: 16)),
                                SizedBox(height: 8),
                                if (post['mediaType'] == 'photo')
                                  Image.network(post['mediaUrl'] ?? '', height: 200, fit: BoxFit.cover),
                                if (post['mediaType'] == 'video')
                                  Container(
                                    height: 200,
                                    color: Colors.black12,
                                    child: Center(
                                      child: Icon(Icons.videocam, size: 50, color: Colors.grey),
                                    ),
                                  ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.thumb_up),
                                      onPressed: () => _likePost(index),
                                    ),
                                    Text('${post['likes']}'),
                                    SizedBox(width: 16),
                                    Icon(Icons.comment),
                                    SizedBox(width: 4),
                                    Text('${post['comments'].length}'),
                                    Spacer(),
                                    IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => _deletePost(post['id']),
                                    ),
                                  ],
                                ),
                                Divider(),
                                Column(
                                  children: [
                                    for (var comment in post['comments'])
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                                          child: Text('- $comment'),
                                        ),
                                      ),
                                    TextField(
                                      decoration: InputDecoration(
                                        hintText: 'Add a comment',
                                      ),
                                      onSubmitted: (value) {
                                        if (value.trim().isNotEmpty) {
                                          _addComment(index, value.trim());
                                        }
                                      },
                                    ),
                                  ],
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
