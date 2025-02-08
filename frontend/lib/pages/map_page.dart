import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_maps_webservices/geolocation.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _controller;
  LatLng _currentPosition = LatLng(28.6139, 77.2090); // Default: Delhi
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  String locationText = "Fetching location...";

  // Google Maps API Key Hardcoding this shit idc
  final String _apiKey = "AIzaSyA54kELek3k5YRbmU5THEC32UyQWlnnELY";

  @override
  void initState() {
    super.initState();
    fetchLocation();
  }

  /// Fetches user's current location using Google Maps Web Services
  Future<void> fetchLocation() async {
    final googleGeolocation = GoogleMapsGeolocation(apiKey: _apiKey);

    try {
      final response = await googleGeolocation.getGeolocation();
      if (response.isOkay) {
        final lat = response.location.lat;
        final lng = response.location.lng;

        setState(() {
          _currentPosition = LatLng(lat, lng);
          locationText = "Latitude: $lat, Longitude: $lng";

          _markers.add(
            Marker(
              markerId: MarkerId("currentLocation"),
              position: _currentPosition,
              infoWindow: InfoWindow(title: "You are here"),
            ),
          );

          _controller?.animateCamera(
            CameraUpdate.newLatLngZoom(_currentPosition, 14),
          );
        });
      } else {
        setState(() {
          locationText = "Failed to fetch location: ${response.errorMessage}";
        });
      }
    } catch (e) {
      setState(() {
        locationText = "Error fetching location: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Google Maps - Delhi Default")),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentPosition, // Default to Delhi
              zoom: 14,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Container(
              padding: EdgeInsets.all(10),
              color: Colors.white,
              child: Text(locationText, style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
