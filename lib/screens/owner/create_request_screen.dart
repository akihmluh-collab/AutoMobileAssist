import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../../providers/auth_provider.dart';
import '../../services/service_request_service.dart';
import '../../services/vehicle_service.dart';
import '../../models/service_request_model.dart';
import '../../models/vehicle_model.dart';
import '../../l10n/app_localizations.dart';

class CreateRequestScreen extends StatefulWidget {
  const CreateRequestScreen({super.key});

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  final ServiceRequestService _service = ServiceRequestService();
  final VehicleService _vehicleService = VehicleService();
  bool _isLoading = false;
  bool _isSending = false;
  String? _selectedVehicleId;
  final TextEditingController _descriptionController = TextEditingController();
  List<VehicleModel> _vehicles = [];
  double? _latitude;
  double? _longitude;

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
        if (_vehicles.isNotEmpty) {
          setState(() => _selectedVehicleId = _vehicles.first.id);
        }
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
        _latitude = position.latitude;
        _longitude = position.longitude;
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> _sendRequest() async {
    if (_selectedVehicleId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.translate('select_vehicle'))),
      );
      return;
    }

    if (_latitude == null || _longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.translate('location_error'))),
      );
      return;
    }

    setState(() => _isSending = true);

    try {
      final authProvider = context.read<AuthProvider>();
      final uid = authProvider.user?.uid;

      if (uid == null) return;

      final request = ServiceRequest(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        ownerUid: uid,
        vehicleId: _selectedVehicleId!,
        description: _descriptionController.text.trim(),
        latitude: _latitude!,
        longitude: _longitude!,
        createdAt: DateTime.now(),
      );

      await _service.createRequest(request);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.translate('request_sent')),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.translate('request_error')),
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
        title: Text(t('request_service')),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    t('request_service_subtitle'),
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 20),

                  // Vehicle Selection
                  Text(
                    t('select_vehicle'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedVehicleId,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: _vehicles.map((vehicle) {
                      return DropdownMenuItem(
                        value: vehicle.id,
                        child: Text('${vehicle.make} ${vehicle.model} (${vehicle.plateNumber})'),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedVehicleId = value),
                  ),
                  const SizedBox(height: 16),

                  // Description
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: t('problem_description'),
                      hintText: t('describe_problem_hint'),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Location info
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.blue),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _latitude != null && _longitude != null
                                ? '${t('location')}: ${_latitude!.toStringAsFixed(6)}, ${_longitude!.toStringAsFixed(6)}'
                                : t('getting_location'),
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Send Button
                  SizedBox(
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isSending ? null : _sendRequest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isSending
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              t('send_request'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}