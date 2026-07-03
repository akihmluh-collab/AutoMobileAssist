import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/profile_model.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Get user profile
  Future<ProfileModel?> getProfile(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return ProfileModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting profile: $e');
      return null;
    }
  }

  // Update profile
  Future<void> updateProfile(ProfileModel profile) async {
    try {
      await _firestore.collection('users').doc(profile.uid).update(profile.toJson());
    } catch (e) {
      print('Error updating profile: $e');
      rethrow;
    }
  }

  // Upload profile photo
  Future<String?> uploadProfilePhoto(String uid, XFile image) async {
    try {
      File file = File(image.path);
      String fileName = 'profile_photos/$uid.jpg';
      Reference ref = _storage.ref().child(fileName);
      await ref.putFile(file);
      String downloadUrl = await ref.getDownloadURL();
      
      await _firestore.collection('users').doc(uid).update({
        'profilePhotoUrl': downloadUrl,
      });
      
      return downloadUrl;
    } catch (e) {
      print('Error uploading photo: $e');
      return null;
    }
  }

  // Pick image from gallery
  Future<XFile?> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 80,
      );
      return image;
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  // Mechanic specific
  Future<void> updateMechanicProfile(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('mechanics').doc(uid).set(data, SetOptions(merge: true));
    } catch (e) {
      print('Error updating mechanic profile: $e');
      rethrow;
    }
  }

  // Shop specific
  Future<void> updateShopProfile(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('shops').doc(uid).set(data, SetOptions(merge: true));
    } catch (e) {
      print('Error updating shop profile: $e');
      rethrow;
    }
  }

  // Distributor specific
  Future<void> updateDistributorProfile(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('distributors').doc(uid).set(data, SetOptions(merge: true));
    } catch (e) {
      print('Error updating distributor profile: $e');
      rethrow;
    }
  }
}