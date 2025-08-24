import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String role;
  final String? displayName;
  final DateTime createdAt;
  final DateTime lastLoginAt;

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    this.displayName,
    required this.createdAt,
    required this.lastLoginAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      email: map['email'] ?? '',
      role: map['role'] ?? 'user',
      displayName: map['displayName'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      lastLoginAt: (map['lastLoginAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'role': role,
      'displayName': displayName,
      'createdAt': createdAt,
      'lastLoginAt': lastLoginAt,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? role,
    String? displayName,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      role: role ?? this.role,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  bool get isAdmin => role == 'admin';
  bool get isUser => role == 'user';
}
