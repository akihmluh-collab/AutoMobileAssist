import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../../providers/auth_provider.dart';
import '../../services/vehicle_service.dart';
import '../../models/vehicle_model.dart';
import '../../l10n/app_localizations.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final VehicleService _vehicleService = VehicleService();
  
  final TextEditingController _makeController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _plateController = TextEditingController();
  
  bool _isLoading = false;

  Future<void> _saveVehicle() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    try {
      final authProvider = context.read<AuthProvider>();
      final uid = authProvider.user?.uid;
      
      if (uid == null) return;
      
      final vehicle = VehicleModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        ownerUid: uid,
        make: _makeController.text.trim(),
        model: _modelController.text.trim(),
        year: int.parse(_yearController.text.trim()),
        plateNumber: _plateController.text.trim().toUpperCase(),
        isDefault: false,
        createdAt: DateTime.now(),
      );
      
      await _vehicleService.addVehicle(vehicle);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.translate('vehicle_added')),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.translate('vehicle_add_error')),
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
        title: Text(t('add_vehicle')),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _makeController,
                decoration: InputDecoration(
                  labelText: t('make'),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.car_repair),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return t('make_required');
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _modelController,
                decoration: InputDecoration(
                  labelText: t('model'),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.directions_car),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return t('model_required');
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _yearController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: t('year'),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return t('year_required');
                  }
                  if (int.tryParse(value) == null) {
                    return t('year_invalid');
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _plateController,
                decoration: InputDecoration(
                  labelText: t('plate_number'),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.confirmation_number),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return t('plate_required');
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveVehicle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          t('save_vehicle'),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
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