import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../l10n/app_localizations.dart';
import '../../models/mechanic_model.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  LatLng _currentPosition = const LatLng(3.8480, 11.5021); // Default: Yaoundé
  bool _isLoading = true;
  Set<Marker> _markers = {};
  List<MechanicModel> _mechanics = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _loadNearbyMechanics() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('mechanics')
          .where('onlineStatus', isEqualTo: true)
          .get();
      
      setState(() {
        _mechanics = snapshot.docs.map((doc) {
          return MechanicModel.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();
        
        _updateMarkers();
      });
    } catch (e) {
      print('Error loading mechanics: $e');
    }
  }

  void _updateMarkers() {
    Set<Marker> markers = {};
    
    for (var mechanic in _mechanics) {
      markers.add(
        Marker(
          markerId: MarkerId(mechanic.uid),
          position: LatLng(mechanic.latitude, mechanic.longitude),
          infoWindow: InfoWindow(
            title: mechanic.garageName,
            snippet: '⭐ ${mechanic.averageRating} (${mechanic.reviewCount} reviews)',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        ),
      );
    }
    
    // Add current location marker
    markers.add(
      Marker(
        markerId: const MarkerId('current_location'),
        position: _currentPosition,
        infoWindow: InfoWindow(
          title: AppLocalizations.of(context)!.translate('your_location'),
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueBlue,
        ),
      ),
    );
    
    setState(() {
      _markers = markers;
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return;
      }

      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });

      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _currentPosition,
            zoom: 14,
          ),
        ),
      );
      
      // Load nearby mechanics after getting location
      await _loadNearbyMechanics();
    } catch (e) {
      print('Error getting location: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!.translate;

    return Scaffold(
      appBar: AppBar(
        title: Text(t('find_mechanics')),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _getCurrentLocation,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: (controller) => _mapController = controller,
              initialCameraPosition: CameraPosition(
                target: _currentPosition,
                zoom: 14,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
              markers: _markers,
            ),
    );
  }
}