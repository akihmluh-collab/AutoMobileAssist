import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/sos_request_model.dart';

class SOSService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create SOS request
  Future<void> createSOSRequest(SOSRequest request) async {
    try {
      await _firestore.collection('sos_requests').doc(request.id).set(request.toJson());
    } catch (e) {
      print('Error creating SOS: $e');
      rethrow;
    }
  }

  // Get SOS requests for a user
  Future<List<SOSRequest>> getUserSOSRequests(String ownerUid) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('sos_requests')
          .where('ownerUid', isEqualTo: ownerUid)
          .orderBy('createdAt', descending: true)
          .get();
      
      return snapshot.docs.map((doc) {
        return SOSRequest.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Error getting SOS: $e');
      return [];
    }
  }

  // Get pending SOS requests for mechanics
  Stream<QuerySnapshot> getPendingSOSRequests() {
    return _firestore
        .collection('sos_requests')
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Accept SOS request
  Future<void> acceptSOSRequest(String requestId, String mechanicUid) async {
    try {
      await _firestore.collection('sos_requests').doc(requestId).update({
        'mechanicUid': mechanicUid,
        'status': 'accepted',
        'acceptedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error accepting SOS: $e');
      rethrow;
    }
  }

  // Update SOS status
  Future<void> updateSOSStatus(String requestId, String status) async {
    try {
      await _firestore.collection('sos_requests').doc(requestId).update({
        'status': status,
      });
    } catch (e) {
      print('Error updating SOS: $e');
      rethrow;
    }
  }
}