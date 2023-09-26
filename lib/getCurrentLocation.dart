import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;
  final Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps Flutter Example'),
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          setState(() {
            _controller = controller;
          });
        },
        initialCameraPosition: const CameraPosition(
          target:
              LatLng(24.860966, 66.990501), // Set initial location to (0, 0)
          zoom: 15.0,
        ),
        markers: _markers,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addCurrentLocationMarker(); // Function to add a marker
        },
        child: const Icon(Icons.add_location),
      ),
    );
  }

  void _addCurrentLocationMarker() async {
    final location = Location();

    try {
      LocationData userLocation = await location.getLocation();
      final coordinates =
          Coordinates(userLocation.latitude, userLocation.longitude);
      var address =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = address.first;
      var userAddress = first.addressLine;

      final marker = Marker(
        markerId: const MarkerId('1'),
        position:
            LatLng(userLocation.latitude ?? 0.0, userLocation.longitude ?? 0.0),
        infoWindow: InfoWindow(
          title: userAddress.toString(),
          snippet: 'Tap to See Details',
        ),
      );
      if (kDebugMode) {
        print("My Current Location");
        print(
            " lat : ${userLocation.latitude} lang : ${userLocation.longitude} ");
      }
      setState(() {
        _markers.add(marker);
      });

      _controller?.animateCamera(CameraUpdate.newLatLng(marker.position));
    } catch (e) {
      if (kDebugMode) {
        print("Error getting location: $e");
      }
    }
  }
}
