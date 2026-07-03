import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/profile_service.dart';
import '../../models/profile_model.dart';
import '../../l10n/app_localizations.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService _profileService = ProfileService();
  bool _isLoading = true;
  ProfileModel? _profile;
  String? _photoUrl;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final authProvider = context.read<AuthProvider>();
    final uid = authProvider.user?.uid;
    
    if (uid != null) {
      final profile = await _profileService.getProfile(uid);
      setState(() {
        _profile = profile;
        _photoUrl = profile?.profilePhotoUrl;
        _isLoading = false;
      });
    }
  }

  Future<void> _pickAndUploadPhoto() async {
    final XFile? image = await _profileService.pickImage();
    if (image != null && context.mounted) {
      final authProvider = context.read<AuthProvider>();
      final uid = authProvider.user?.uid;
      
      if (uid != null) {
        setState(() => _isLoading = true);
        final url = await _profileService.uploadProfilePhoto(uid, image);
        setState(() {
          _photoUrl = url;
          _isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.translate('photo_updated')),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!.translate;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(t('profile')),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _profile == null
              ? Center(child: Text(t('profile_not_found')))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Profile Photo
                      GestureDetector(
                        onTap: _pickAndUploadPhoto,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage: _photoUrl != null
                              ? NetworkImage(_photoUrl!)
                              : null,
                          child: _photoUrl == null
                              ? Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.grey.shade600,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        t('tap_to_change_photo'),
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Name
                      _buildInfoRow(
                        context,
                        t('full_name'),
                        '${_profile!.firstName} ${_profile!.lastName}',
                      ),
                      
                      // Email
                      _buildInfoRow(
                        context,
                        t('email'),
                        context.read<AuthProvider>().user?.email ?? 'No email',
                      ),
                      
                      // Phone
                      _buildInfoRow(
                        context,
                        t('phone'),
                        _profile!.phone,
                      ),
                      
                      // Role
                      _buildInfoRow(
                        context,
                        t('role'),
                        t(_profile!.role.toLowerCase()),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Edit Profile Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfileScreen(profile: _profile!),
                              ),
                            ).then((result) {
                              if (result == true) {
                                _loadProfile();
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            t('edit_profile'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}