import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart'; // Add this import for location services

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(24.910435343421018, 67.0973043795392),
    zoom: 14.4746,
  );
  final Location _location = Location();
  bool _permissionGranted = false;
  final List<Marker> _marker = [];
  final List<Marker> _list = const [
    Marker(
        markerId: MarkerId("2"),
        position: LatLng(24.94568130844296, 67.11537126573981),
        infoWindow: InfoWindow(title: "university")),
    Marker(
        markerId: MarkerId("3"),
        position: LatLng(24.919698021187436, 67.09731481920615),
        infoWindow: InfoWindow(title: "Mudassir bhai Uni")),
  ];

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _marker.addAll(_list);
  }

  // Function to request location permissions
  Future<void> _requestLocationPermission() async {
    final locationPermission = await _location.requestPermission();
    if (locationPermission == PermissionStatus.granted) {
      setState(() {
        _permissionGranted = true;
      });
    }
  }

//* Function to get the user's current location and add it as a marker

  Future<void> getUserLocationAndAddMarker() async {
    final LocationData userLocation = await _location.getLocation();
    final LatLng userLatLng = LatLng(
      userLocation.latitude ?? 0.0,
      userLocation.longitude ?? 0.0,
    );
    final Marker userMarker = Marker(
      markerId: const MarkerId("user"),
      position: userLatLng,
      infoWindow: const InfoWindow(title: "My Location"),
    );

    GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: userLatLng, zoom: 14)));
    _marker.add(userMarker);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: size.height * .5,
                width: size.width * .75,
                child: GoogleMap(
                  initialCameraPosition: kGooglePlex,
                  mapType: MapType.normal,
                  compassEnabled: true,
                  markers: Set<Marker>.of(_marker),
                  myLocationEnabled:
                      _permissionGranted, // Enable MyLocation layer
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  getUserLocationAndAddMarker()
                      .then((value) => setState(() {}));
                },
                style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                child: const Text("My Location"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
