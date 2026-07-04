import 'package:cloud_firestore/cloud_firestore.dart';

class SOSRequest {
  final String id;
  final String ownerUid;
  final String? mechanicUid;
  final String vehicleId;
  final String description;
  final double latitude;
  final double longitude;
  final String status; // pending, accepted, in_progress, completed, cancelled
  final DateTime createdAt;
  final DateTime? acceptedAt;

  SOSRequest({
    required this.id,
    required this.ownerUid,
    this.mechanicUid,
    required this.vehicleId,
    required this.description,
    required this.latitude,
    required this.longitude,
    this.status = 'pending',
    required this.createdAt,
    this.acceptedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerUid': ownerUid,
      'mechanicUid': mechanicUid,
      'vehicleId': vehicleId,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'createdAt': createdAt,
      'acceptedAt': acceptedAt,
    };
  }

  factory SOSRequest.fromJson(Map<String, dynamic> json) {
    return SOSRequest(
      id: json['id'] ?? '',
      ownerUid: json['ownerUid'] ?? '',
      mechanicUid: json['mechanicUid'],
      vehicleId: json['vehicleId'] ?? '',
      description: json['description'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'pending',
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      acceptedAt: (json['acceptedAt'] as Timestamp?)?.toDate(),
    );
  }
}