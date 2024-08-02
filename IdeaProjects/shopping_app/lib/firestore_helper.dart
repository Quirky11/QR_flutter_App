// FirestoreHelper.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHelper {
  final CollectionReference _historyCollection =
  FirebaseFirestore.instance.collection('grocery_history');

  Future<void> addHistory(String action, String itemName, DateTime timestamp) async {
    try {
      await _historyCollection.add({
        'action': action,
        'itemName': itemName,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('History added: $action - $itemName at $timestamp');
    } catch (e) {
      print('Error adding history: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    try {
      final thirtyDaysAgo = DateTime.now().subtract(Duration(days: 30));

      final snapshot = await _historyCollection
          .where('timestamp', isGreaterThanOrEqualTo: thirtyDaysAgo)
          .orderBy('timestamp', descending: true)
          .get();

      List<Map<String, dynamic>> historyData = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        print('Fetched history: $data'); // Debug output
        return {
          'action': data['action'] ?? 'Unknown Action',
          'item': data['itemName'] ?? 'Unknown Item', // Ensure field names match
          'timestamp': (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
        };
      }).toList();

      return historyData;
    } catch (e) {
      print('Failed to fetch history: $e');
      return [];
    }
  }
}
