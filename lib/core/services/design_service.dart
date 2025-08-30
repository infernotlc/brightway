// Create this file: lib/core/services/design_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/grid_models.dart';

class DesignService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Save a design to Firebase - only save to user's designs subcollection
  static Future<String> saveDesign({
    required String name,
    required String description,
    required int rows,
    required int cols,
    required List<List<GridCell>> grid,
    required String createdBy,
  }) async {
    try {
      // Convert grid to design items
      final items = <DesignItem>[];

      for (int row = 0; row < grid.length; row++) {
        for (int col = 0; col < grid[row].length; col++) {
          final cell = grid[row][col];
          if (cell.item != null) {
            items.add(DesignItem(
              name: cell.item!.name,
              type: cell.item!.type,
              icon: cell.item!.icon,
              color: cell.item!.color,
              row: row,
              col: col,
              rotation: cell.item!.rotation,
            ));
          }
        }
      }

      final design = Design(
        id: '', // Will be set by Firestore
        name: name,
        description: description,
        rows: rows,
        cols: cols,
        items: items,
        createdBy: createdBy,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save only to user's designs subcollection
      final docRef = await _firestore
          .collection('users')
          .doc(createdBy)
          .collection('designs')
          .add(design.toMap());

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to save design: $e');
    }
  }

  /// Get designs for a specific user
  static Stream<List<Design>> getUserDesigns(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('designs')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Design.fromMap(doc.data(), doc.id))
        .toList());
  }

  /// Get a specific design by ID from user's designs
  static Future<Design?> getUserDesign(String userId, String designId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('designs')
          .doc(designId)
          .get();
      if (doc.exists) {
        return Design.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get design: $e');
    }
  }

  /// Get a specific design by ID (legacy method for backward compatibility)
  static Future<Design?> getDesign(String designId) async {
    try {
      final doc = await _firestore.collection('designs').doc(designId).get();
      if (doc.exists) {
        return Design.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get design: $e');
    }
  }

  /// Update a design in user's designs subcollection
  static Future<void> updateUserDesign(String userId, String designId, Map<String, dynamic> updates) async {
    try {
      updates['updatedAt'] = DateTime.now();
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('designs')
          .doc(designId)
          .update(updates);
    } catch (e) {
      throw Exception('Failed to update design: $e');
    }
  }

  /// Update a design (legacy method for backward compatibility)
  static Future<void> updateDesign(String designId, Map<String, dynamic> updates) async {
    try {
      updates['updatedAt'] = DateTime.now();
      await _firestore.collection('designs').doc(designId).update(updates);
    } catch (e) {
      throw Exception('Failed to update design: $e');
    }
  }

  /// Delete a design from user's designs subcollection
  static Future<void> deleteUserDesign(String userId, String designId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('designs')
          .doc(designId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete design: $e');
    }
  }

  /// Delete a design (legacy method for backward compatibility)
  static Future<void> deleteDesign(String designId, String userId) async {
    try {
      await _firestore.collection('designs').doc(designId).delete();
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('designs')
          .doc(designId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete design: $e');
    }
  }

  /// Get all admin designs (these are the places that users see)
  static Stream<List<Design>> getAdminDesigns() {
    return _firestore
        .collectionGroup('designs')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Design.fromMap(doc.data(), doc.id))
        .toList());
  }

  /// Get admin user display name by user ID
  static Future<String> getAdminDisplayName(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        final data = doc.data();
        return data?['displayName'] ?? data?['email'] ?? 'Unknown Admin';
      }
      return 'Unknown Admin';
    } catch (e) {
      return 'Unknown Admin';
    }
  }

  static Future<String> getPlaceDisplayName(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        final data = doc.data();
        return data?['displayName'] ?? data?['email'] ?? 'Unknown Admin';
      }
      return 'Unknown Admin';
    } catch (e) {
      return 'Unknown Admin';
    }
  }


}