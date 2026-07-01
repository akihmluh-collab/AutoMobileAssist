class UserModel {
  final String uid;
  final String email;
  final String name;
  final String phone;
  final String role; // 'owner', 'mechanic', 'shop', 'distributor', 'admin'
  final String? profilePhoto;
  final DateTime createdAt;
  final bool isActive;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.phone,
    required this.role,
    this.profilePhoto,
    required this.createdAt,
    required this.isActive,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      role: data['role'] ?? 'owner',
      profilePhoto: data['profilePhoto'],
      createdAt: (data['createdAt'] as dynamic).toDate(),
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'phone': phone,
      'role': role,
      'profilePhoto': profilePhoto,
      'createdAt': createdAt,
      'isActive': isActive,
    };
  }
}