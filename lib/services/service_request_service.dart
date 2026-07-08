import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/service_request_model.dart';

class ServiceRequestService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create service request
  Future<void> createRequest(ServiceRequest request) async {
    try {
      await _firestore.collection('service_requests').doc(request.id).set(request.toJson());
    } catch (e) {
      print('Error creating request: $e');
      rethrow;
    }
  }

  // Get requests for an owner
  Future<List<ServiceRequest>> getOwnerRequests(String ownerUid) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('service_requests')
          .where('ownerUid', isEqualTo: ownerUid)
          .orderBy('createdAt', descending: true)
          .get();
      
      return snapshot.docs.map((doc) {
        return ServiceRequest.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Error getting owner requests: $e');
      return [];
    }
  }

  // Get pending requests for mechanics
  Stream<QuerySnapshot> getPendingRequests() {
    return _firestore
        .collection('service_requests')
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Accept request
  Future<void> acceptRequest(String requestId, String mechanicUid) async {
    try {
      await _firestore.collection('service_requests').doc(requestId).update({
        'mechanicUid': mechanicUid,
        'status': 'accepted',
        'acceptedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error accepting request: $e');
      rethrow;
    }
  }

  // Update request status
  Future<void> updateStatus(String requestId, String status) async {
    try {
      Map<String, dynamic> data = {'status': status};
      if (status == 'completed') {
        data['completedAt'] = FieldValue.serverTimestamp();
      }
      await _firestore.collection('service_requests').doc(requestId).update(data);
    } catch (e) {
      print('Error updating status: $e');
      rethrow;
    }
  }

  // Update estimated price
  Future<void> updatePrice(String requestId, double price) async {
    try {
      await _firestore.collection('service_requests').doc(requestId).update({
        'estimatedPrice': price,
      });
    } catch (e) {
      print('Error updating price: $e');
      rethrow;
    }
  }

  // Get single request
  Future<ServiceRequest?> getRequest(String requestId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('service_requests').doc(requestId).get();
      if (doc.exists) {
        return ServiceRequest.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting request: $e');
      return null;
    }
  }
}