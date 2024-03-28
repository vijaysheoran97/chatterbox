class Status {
  final String id;
  final String text;
  final String? imageUrl; // Nullable for image URL
  final String? videoUrl; // Nullable for video URL
  final DateTime timestamp;

  Status({
    required this.id,
    required this.text,
    this.imageUrl,
    this.videoUrl,
    required this.timestamp,
  });

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      id: json['id'],
      text: json['text'],
      imageUrl: json['imageUrl'],
      videoUrl: json['videoUrl'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
