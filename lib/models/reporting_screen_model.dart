class ReportingScreenModel {
  final String id;
  final String text;
  final String? photoUrl;
  final String? videoUrl;
  final String? audioUrl;
  final String? documentUrl;
  final bool isAnonymous;

  ReportingScreenModel({
    required this.id,
    required this.text,
    this.photoUrl,
    this.videoUrl,
    this.audioUrl,
    this.documentUrl,
    this.isAnonymous = false,
  });

  factory ReportingScreenModel.fromMap(Map<String, dynamic> map, String documentId) {
    return ReportingScreenModel(
      id: documentId,
      text: map['text'] ?? '',
      photoUrl: map['photoUrl'],
      videoUrl: map['videoUrl'],
      audioUrl: map['audioUrl'],
      documentUrl: map['documentUrl'],
      isAnonymous: map['isAnonymous'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'photoUrl': photoUrl,
      'videoUrl': videoUrl,
      'audioUrl': audioUrl,
      'documentUrl': documentUrl,
      'isAnonymous': isAnonymous,
    };
  }
}
