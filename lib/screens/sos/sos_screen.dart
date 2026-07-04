import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../providers/auth_provider.dart';
import '../../services/sos_service.dart';
import '../../services/vehicle_service.dart';
import '../../models/sos_request_model.dart';
import '../../models/vehicle_model.dart';
import '../../l10n/app_localizations.dart';

class SOSScreen extends StatefulWidget {
  const SOSScreen({super.key});

  @override
  State<SOSScreen> createState() => _SOSScreenState();
}

class _SOSScreenState extends State<SOSScreen> {
  final SOSService _sosService = SOSService();
  final VehicleService _vehicleService = VehicleService();
  bool _isLoading = false;
  bool _isSending = false;
  String? _selectedVehicleId;
  String _description = '';
  List<VehicleModel> _vehicles = [];
  LatLng? _currentLocation;

  @override
  void initState() {
    super.initState();
    _loadVehicles();
    _getLocation();
  }

  Future<void> _loadVehicles() async {
    setState(() => _isLoading = true);
    try {
      final authProvider = context.read<AuthProvider>();
      final uid = authProvider.user?.uid;
      if (uid != null) {
        _vehicles = await _vehicleService.getVehicles(uid);
      }
    } catch (e) {
      print('Error loading vehicles: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> _sendSOS() async {
    if (_selectedVehicleId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.translate('select_vehicle')),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_currentLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.translate('location_error')),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSending = true);

    try {
      final authProvider = context.read<AuthProvider>();
      final uid = authProvider.user?.uid;

      if (uid == null) return;

      final sosRequest = SOSRequest(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        ownerUid: uid,
        vehicleId: _selectedVehicleId!,
        description: _description.isEmpty ? 'Emergency assistance needed' : _description,
        latitude: _currentLocation!.latitude,
        longitude: _currentLocation!.longitude,
        createdAt: DateTime.now(),
      );

      await _sosService.createSOSRequest(sosRequest);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.translate('sos_sent')),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.translate('sos_error')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!.translate;

    return Scaffold(
      appBar: AppBar(
        title: Text(t('sos_emergency')),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Warning Icon
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.warning, size: 60, color: Colors.red),
                        const SizedBox(height: 8),
                        Text(
                          t('sos_warning'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          t('sos_subtitle'),
                          style: TextStyle(color: Colors.grey.shade700),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Vehicle Selection
                  Text(
                    t('select_vehicle'),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedVehicleId,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: t('select_vehicle_hint'),
                    ),
                    items: _vehicles.map((vehicle) {
                      return DropdownMenuItem(
                        value: vehicle.id,
                        child: Text('${vehicle.make} ${vehicle.model} (${vehicle.plateNumber})'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedVehicleId = value);
                    },
                  ),
                  const SizedBox(height: 16),

                  // Description
                  TextFormField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: t('problem_description'),
                      hintText: t('describe_problem_hint'),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => _description = value,
                  ),
                  const SizedBox(height: 24),

                  // SOS Button
                  SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _isSending ? null : _sendSOS,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isSending
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              t('send_sos'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    t('sos_disclaimer'),
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
    );
  }
}