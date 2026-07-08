import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceRequest {
  final String id;
  final String ownerUid;
  final String? mechanicUid;
  final String vehicleId;
  final String description;
  final double latitude;
  final double longitude;
  final String status; // pending, accepted, in_progress, completed, cancelled
  final double? estimatedPrice;
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final DateTime? completedAt;

  ServiceRequest({
    required this.id,
    required this.ownerUid,
    this.mechanicUid,
    required this.vehicleId,
    required this.description,
    required this.latitude,
    required this.longitude,
    this.status = 'pending',
    this.estimatedPrice,
    required this.createdAt,
    this.acceptedAt,
    this.completedAt,
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
      'estimatedPrice': estimatedPrice,
      'createdAt': createdAt,
      'acceptedAt': acceptedAt,
      'completedAt': completedAt,
    };
  }

  factory ServiceRequest.fromJson(Map<String, dynamic> json) {
    return ServiceRequest(
      id: json['id'] ?? '',
      ownerUid: json['ownerUid'] ?? '',
      mechanicUid: json['mechanicUid'],
      vehicleId: json['vehicleId'] ?? '',
      description: json['description'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'pending',
      estimatedPrice: (json['estimatedPrice'] as num?)?.toDouble(),
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      acceptedAt: (json['acceptedAt'] as Timestamp?)?.toDate(),
      completedAt: (json['completedAt'] as Timestamp?)?.toDate(),
    );
  }
}