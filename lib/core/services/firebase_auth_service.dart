import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../constants/app_constants.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(
    String email, 
    String password,
  ) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update last login time
      await _updateLastLoginTime(credential.user!.uid);
      
      return credential;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Create user with email and password
  Future<UserCredential> createUserWithEmailAndPassword(
    String email, 
    String password,
    String? displayName,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user document in Firestore
      await _createUserDocument(credential.user!, displayName);

      return credential;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get user data from Firestore
  Future<UserModel?> getUserData(String uid) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .get();
      
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user data: $e');
    }
  }

  // Create user document in Firestore
  Future<void> _createUserDocument(User user, String? displayName) async {
    final userData = {
      'email': user.email,
      'role': AppConstants.defaultRole,
      'displayName': displayName,
      'createdAt': FieldValue.serverTimestamp(),
      'lastLoginAt': FieldValue.serverTimestamp(),
    };

    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(user.uid)
        .set(userData);
  }

  // Update last login time
  Future<void> _updateLastLoginTime(String uid) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .update({
      'lastLoginAt': FieldValue.serverTimestamp(),
    });
  }

  // Handle Firebase auth errors
  String _handleAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No user found with this email.';
        case 'wrong-password':
          return 'Wrong password provided.';
        case 'email-already-in-use':
          return 'An account already exists with this email.';
        case 'weak-password':
          return 'The password provided is too weak.';
        case 'invalid-email':
          return 'The email address is invalid.';
        case 'user-disabled':
          return 'This user account has been disabled.';
        case 'too-many-requests':
          return 'Too many requests. Please try again later.';
        default:
          return 'Authentication failed: ${error.message}';
      }
    }
    return 'An unexpected error occurred.';
  }
}
