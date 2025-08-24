import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/app_constants.dart';

class AdminUtils {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get all users (for admin management)
  static Stream<QuerySnapshot> getAllUsers() {
    return _firestore
        .collection(AppConstants.usersCollection)
        .snapshots();
  }

  /// Check if a user is admin
  static Future<bool> isUserAdmin(String userId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .get();
      
      if (doc.exists) {
        final data = doc.data();
        return data?['role'] == AppConstants.roleAdmin;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Get user data by ID
  static Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .get();
      
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
