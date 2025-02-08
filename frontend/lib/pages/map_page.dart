import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:google_maps_webservice/directions.dart' as gmaps;
import 'dart:async';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController _controller;
  Location _location = Location();
  LatLng _initialPosition = const LatLng(37.4223, -122.0848);
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  final Completer<GoogleMapController> _controllerCompleter = Completer();

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    final locationData = await _location.getLocation();
    setState(() {
      _initialPosition = LatLng(locationData.latitude!, locationData.longitude!);
      _markers.add(
        Marker(
          markerId: const MarkerId("userLocation"),
          position: _initialPosition,
          infoWindow: const InfoWindow(title: "Your Location"),
        ),
      );
    });

    _location.onLocationChanged.listen((newLoc) {
      setState(() {
        _initialPosition = LatLng(newLoc.latitude!, newLoc.longitude!);
        _markers.add(
          Marker(
            markerId: const MarkerId("updatedLocation"),
            position: _initialPosition,
          ),
        );
      });
      _controller.animateCamera(
        CameraUpdate.newLatLng(_initialPosition),
      );
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
          _controllerCompleter.complete(controller);
          _controller = controller;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getUserLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}

