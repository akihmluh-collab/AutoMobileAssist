import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../../models/vehicle_model.dart';
import '../../services/vehicle_service.dart';
import '../../l10n/app_localizations.dart';

class EditVehicleScreen extends StatefulWidget {
  final VehicleModel vehicle;
  const EditVehicleScreen({super.key, required this.vehicle});

  @override
  State<EditVehicleScreen> createState() => _EditVehicleScreenState();
}

class _EditVehicleScreenState extends State<EditVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final VehicleService _vehicleService = VehicleService();
  
  late TextEditingController _makeController;
  late TextEditingController _modelController;
  late TextEditingController _yearController;
  late TextEditingController _plateController;
  
  XFile? _selectedImage;
  String? _imageUrl;
  bool _isLoading = false;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _makeController = TextEditingController(text: widget.vehicle.make);
    _modelController = TextEditingController(text: widget.vehicle.model);
    _yearController = TextEditingController(text: widget.vehicle.year.toString());
    _plateController = TextEditingController(text: widget.vehicle.plateNumber);
    _imageUrl = widget.vehicle.photoUrl;
  }

  @override
  void dispose() {
    _makeController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _plateController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 500,
      maxHeight: 500,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() => _selectedImage = image);
    }
  }

  Future<void> _updateVehicle() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);

    try {
      // Upload new photo if selected
      if (_selectedImage != null) {
        setState(() => _isUploading = true);
        String fileName = 'vehicles/${DateTime.now().millisecondsSinceEpoch}.jpg';
        Reference ref = FirebaseStorage.instance.ref().child(fileName);
        await ref.putFile(File(_selectedImage!.path));
        _imageUrl = await ref.getDownloadURL();
        setState(() => _isUploading = false);
      }

      final updatedVehicle = VehicleModel(
        id: widget.vehicle.id,
        ownerUid: widget.vehicle.ownerUid,
        make: _makeController.text.trim(),
        model: _modelController.text.trim(),
        year: int.parse(_yearController.text.trim()),
        plateNumber: _plateController.text.trim().toUpperCase(),
        isDefault: widget.vehicle.isDefault,
        photoUrl: _imageUrl,
        createdAt: widget.vehicle.createdAt,
      );

      await _vehicleService.updateVehicle(updatedVehicle);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.translate('vehicle_updated')),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.translate('vehicle_update_error')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!.translate;

    return Scaffold(
      appBar: AppBar(
        title: Text(t('edit_vehicle')),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Photo
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(_selectedImage!.path),
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        )
                      : _imageUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                _imageUrl!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_photo_alternate, size: 40, color: Colors.grey.shade600),
                                const SizedBox(height: 8),
                                Text(
                                  t('tap_to_change_photo'),
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _makeController,
                decoration: InputDecoration(
                  labelText: t('make'),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.car_repair),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return t('make_required');
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _modelController,
                decoration: InputDecoration(
                  labelText: t('model'),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.directions_car),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return t('model_required');
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _yearController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: t('year'),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return t('year_required');
                  if (int.tryParse(value) == null) return t('year_invalid');
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _plateController,
                decoration: InputDecoration(
                  labelText: t('plate_number'),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.confirmation_number),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return t('plate_required');
                  return null;
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _updateVehicle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          t('update_vehicle'),
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}