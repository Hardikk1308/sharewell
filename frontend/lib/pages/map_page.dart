import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Location _location = Location(
    latitude: 0.0,
    longitude: 0.0,
    timestamp: DateTime.now(),
  );
  LatLng _initialPosition = const LatLng(37.4223, -122.0848);
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  GoogleMapController? _mapController; // Added nullable controller
  final Completer<GoogleMapController> _controllerCompleter = Completer();

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Check location services
    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    // Check location permissions
    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // Get user location
    final locationData = await _location.getLocation();
    if (locationData.latitude == null || locationData.longitude == null) return;

    // Update location
    setState(() {
      _initialPosition = LatLng(locationData.latitude!, locationData.longitude!);
      _markers = {
        Marker(
          markerId: const MarkerId("userLocation"),
          position: _initialPosition,
          infoWindow: const InfoWindow(title: "Your Location"),
        ),
      };
    });

    // Listen for location updates
    _location.onLocationChanged.listen((newLoc) async {
      if (newLoc.latitude == null || newLoc.longitude == null) return;

      setState(() {
        _initialPosition = LatLng(newLoc.latitude!, newLoc.longitude!);
        _markers = {
          Marker(
            markerId: const MarkerId("updatedLocation"),
            position: _initialPosition,
          ),
        };
      });

      if (_mapController != null) {
        _mapController!.animateCamera(CameraUpdate.newLatLng(_initialPosition));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Google Maps with Flutter")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 13,
        ),
        markers: _markers,
        polylines: _polylines,
        onMapCreated: (GoogleMapController controller) {
          if (!_controllerCompleter.isCompleted) {
            _controllerCompleter.complete(controller);
          }
          _mapController = controller;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getUserLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}

extension on Location {
  get onLocationChanged => null;

  requestPermission() {}
  
  getLocation() {}
  
  hasPermission() {}
  
  serviceEnabled() {}
  
  requestService() {}
}
