import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleModel {
  final String id;
  final String ownerUid;
  final String make;
  final String model;
  final int year;
  final String plateNumber;
  final bool isDefault;
  final DateTime createdAt;

  VehicleModel({
    required this.id,
    required this.ownerUid,
    required this.make,
    required this.model,
    required this.year,
    required this.plateNumber,
    this.isDefault = false,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerUid': ownerUid,
      'make': make,
      'model': model,
      'year': year,
      'plateNumber': plateNumber,
      'isDefault': isDefault,
      'createdAt': createdAt,
    };
  }

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'] ?? '',
      ownerUid: json['ownerUid'] ?? '',
      make: json['make'] ?? '',
      model: json['model'] ?? '',
      year: json['year'] ?? 0,
      plateNumber: json['plateNumber'] ?? '',
      isDefault: json['isDefault'] ?? false,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}