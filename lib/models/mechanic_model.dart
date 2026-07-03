import 'package:cloud_firestore/cloud_firestore.dart';

class MechanicModel {
  final String uid;
  final String garageName;
  final String bio;
  final double latitude;
  final double longitude;
  final List<String> specializations;
  final double averageRating;
  final int reviewCount;
  final bool onlineStatus;
  final String? profilePhotoUrl;

  MechanicModel({
    required this.uid,
    required this.garageName,
    required this.bio,
    required this.latitude,
    required this.longitude,
    required this.specializations,
    this.averageRating = 0.0,
    this.reviewCount = 0,
    this.onlineStatus = false,
    this.profilePhotoUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'garageName': garageName,
      'bio': bio,
      'latitude': latitude,
      'longitude': longitude,
      'specializations': specializations,
      'averageRating': averageRating,
      'reviewCount': reviewCount,
      'onlineStatus': onlineStatus,
      'profilePhotoUrl': profilePhotoUrl,
    };
  }

  factory MechanicModel.fromJson(Map<String, dynamic> json) {
    return MechanicModel(
      uid: json['uid'] ?? '',
      garageName: json['garageName'] ?? '',
      bio: json['bio'] ?? '',
      latitude: json['latitude'] ?? 0.0,
      longitude: json['longitude'] ?? 0.0,
      specializations: List<String>.from(json['specializations'] ?? []),
      averageRating: (json['averageRating'] ?? 0.0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      onlineStatus: json['onlineStatus'] ?? false,
      profilePhotoUrl: json['profilePhotoUrl'],
    );
  }

  GeoPoint get location => GeoPoint(latitude, longitude);
}