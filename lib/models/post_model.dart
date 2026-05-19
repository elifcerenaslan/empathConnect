import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String userId;
  final String username;
  final String userProfileImage;
  final String text;
  final List<String> likes;
  final List<String> reposts;
  final DateTime createdAt;

  PostModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.userProfileImage,
    required this.text,
    required this.likes,
    required this.reposts,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'userProfileImage': userProfileImage,
      'text': text,
      'likes': likes,
      'reposts': reposts,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map, String documentId) {
    return PostModel(
      id: documentId,
      userId: map['userId'] ?? '',
      username: map['username'] ?? '',
      userProfileImage: map['userProfileImage'] ?? '',
      text: map['text'] ?? map['caption'] ?? '',
      likes: List<String>.from(map['likes'] ?? []),
      reposts: List<String>.from(map['reposts'] ?? []),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
