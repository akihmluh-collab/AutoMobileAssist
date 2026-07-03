import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/vehicle_service.dart';
import '../../models/vehicle_model.dart';
import '../../l10n/app_localizations.dart';
import 'add_vehicle_screen.dart';

class VehicleListScreen extends StatefulWidget {
  const VehicleListScreen({super.key});

  @override
  State<VehicleListScreen> createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> {
  final VehicleService _vehicleService = VehicleService();
  List<VehicleModel> _vehicles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVehicles();
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

  Future<void> _deleteVehicle(String vehicleId) async {
    final t = AppLocalizations.of(context)!.translate;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t('delete_vehicle')),
        content: Text(t('delete_confirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(t('cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(t('delete')),
          ),
        ],
      ),
    );
    
    if (confirm == true) {
      try {
        await _vehicleService.deleteVehicle(vehicleId);
        _loadVehicles();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(t('vehicle_deleted')),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(t('delete_error')),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _setDefaultVehicle(String vehicleId) async {
    try {
      final authProvider = context.read<AuthProvider>();
      final uid = authProvider.user?.uid;
      if (uid != null) {
        await _vehicleService.setDefaultVehicle(uid, vehicleId);
        _loadVehicles();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.translate('default_set')),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      print('Error setting default: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!.translate;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(t('my_vehicles')),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddVehicleScreen()),
              );
              if (result == true) _loadVehicles();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _vehicles.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.directions_car, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        t('no_vehicles'),
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        t('tap_add_vehicle'),
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _vehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = _vehicles[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: vehicle.isDefault ? Colors.blue : Colors.grey,
                          child: Icon(
                            Icons.directions_car,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          '${vehicle.make} ${vehicle.model}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${t('year')}: ${vehicle.year}'),
                            Text('${t('plate_number')}: ${vehicle.plateNumber}'),
                            if (vehicle.isDefault)
                              Chip(
                                label: Text(t('default')),
                                backgroundColor: Colors.blue,
                                labelStyle: TextStyle(color: Colors.white),
                                padding: EdgeInsets.zero,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                          ],
                        ),
                        isThreeLine: true,
                        trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              child: Text(t('set_default')),
                              onTap: () => _setDefaultVehicle(vehicle.id),
                            ),
                            PopupMenuItem(
                              child: Text(t('delete')),
                              onTap: () => _deleteVehicle(vehicle.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}