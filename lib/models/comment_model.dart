import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String id;
  final String postId;
  final String userId;
  final String username;
  final String userProfileImage;
  final String text;
  final DateTime createdAt;

  CommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.username,
    required this.userProfileImage,
    required this.text,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'postId': postId,
      'userId': userId,
      'username': username,
      'userProfileImage': userProfileImage,
      'text': text,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map, String documentId) {
    return CommentModel(
      id: documentId,
      postId: map['postId'] ?? '',
      userId: map['userId'] ?? '',
      username: map['username'] ?? '',
      userProfileImage: map['userProfileImage'] ?? '',
      text: map['text'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
