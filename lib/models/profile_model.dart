class ProfileModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String phone;
  final String? profilePhotoUrl;
  final String role; // owner, mechanic, shop, distributor, admin

  ProfileModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.profilePhotoUrl,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'profilePhotoUrl': profilePhotoUrl,
      'role': role,
    };
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      uid: json['uid'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      phone: json['phone'] ?? '',
      profilePhotoUrl: json['profilePhotoUrl'],
      role: json['role'] ?? 'owner',
    );
  }
}