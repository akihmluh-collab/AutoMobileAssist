import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vehicle_model.dart';

class VehicleService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add vehicle
  Future<void> addVehicle(VehicleModel vehicle) async {
    try {
      await _firestore.collection('vehicles').doc(vehicle.id).set(vehicle.toJson());
    } catch (e) {
      print('Error adding vehicle: $e');
      rethrow;
    }
  }

  // Get all vehicles for an owner
  Future<List<VehicleModel>> getVehicles(String ownerUid) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('vehicles')
          .where('ownerUid', isEqualTo: ownerUid)
          .orderBy('createdAt', descending: true)
          .get();
      
      return snapshot.docs.map((doc) {
        return VehicleModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Error getting vehicles: $e');
      return [];
    }
  }

  // Update vehicle
  Future<void> updateVehicle(VehicleModel vehicle) async {
    try {
      await _firestore.collection('vehicles').doc(vehicle.id).update(vehicle.toJson());
    } catch (e) {
      print('Error updating vehicle: $e');
      rethrow;
    }
  }

  // Delete vehicle
  Future<void> deleteVehicle(String vehicleId) async {
    try {
      await _firestore.collection('vehicles').doc(vehicleId).delete();
    } catch (e) {
      print('Error deleting vehicle: $e');
      rethrow;
    }
  }

  // Set default vehicle
  Future<void> setDefaultVehicle(String ownerUid, String vehicleId) async {
    try {
      // Get all vehicles for this owner
      QuerySnapshot snapshot = await _firestore
          .collection('vehicles')
          .where('ownerUid', isEqualTo: ownerUid)
          .get();
      
      // Batch update: set all isDefault = false
      WriteBatch batch = _firestore.batch();
      for (var doc in snapshot.docs) {
        batch.update(doc.reference, {'isDefault': false});
      }
      
      // Set selected vehicle as default
      batch.update(
        _firestore.collection('vehicles').doc(vehicleId),
        {'isDefault': true},
      );
      
      await batch.commit();
    } catch (e) {
      print('Error setting default vehicle: $e');
      rethrow;
    }
  }
}