import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class PolylinePage extends StatefulWidget {
  const PolylinePage({super.key});

  @override
  State<PolylinePage> createState() => _PolylinePageState();
}

class _PolylinePageState extends State<PolylinePage> {
  GoogleMapController? _controller;
  final _customInfoWindowController = CustomInfoWindowController();

  Marker destinationMarker(
      {required double lat,
      required double long,
      required String id,
      required String url,
      required String title,
      required String description,
      required BuildContext context}) {
    Size size = MediaQuery.of(context).size;
    return Marker(
      markerId: MarkerId(id),
      position: LatLng(lat, long),
      icon: BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(
        title: title,
        snippet: 'Tap to See Details',
      ),
      onTap: () {
        _customInfoWindowController.addInfoWindow!(
            Expanded(
              child: Container(
                height: size.height * .1,
                width: size.width * .4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: size.width * .3,
                      height: size.height * .15,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(url),
                              fit: BoxFit.fitHeight,
                              filterQuality: FilterQuality.high),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black54),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Padding(
                          padding: const EdgeInsets.only(left: 18.0, top: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                description,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.fade,
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ),
            LatLng(lat, long));
      },
    );
  }

  final Set<Marker> _markers = {};


  final cameraPosition = const CameraPosition(
    target: LatLng(24.860966, 66.990501), // Set initial location to (0, 0)
    zoom: 15.0,
  );
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: size.height * .07,
        backgroundColor: Colors.black,
        title: const Text("Google Maps"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: size.height * .7,
            child: Stack(
              children: [
                GoogleMap(
                  onMapCreated: (controller) {
                    _customInfoWindowController.googleMapController =
                        controller;
                    setState(() {
                      _controller = controller;
                    });
                  },
                  onCameraMove: (position) {
                    _customInfoWindowController.onCameraMove!();
                  },
                  initialCameraPosition: cameraPosition,
                  onTap: (position) {
                    _customInfoWindowController.hideInfoWindow!();
                  },
                  polylines: {
                    Polyline(
                        polylineId: const PolylineId("route"),
                        points: polyLineCoOrdinates,
                        color: Colors.black54,
                        width: 4)
                  },
                  markers: _markers,
                ),
                CustomInfoWindow(
                  controller: _customInfoWindowController,
                  height: 120,
                  width: 330,
                  offset: 35,
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
          DestinationButton(
              ontap: () {
                _addCurrentLocationMarker();
                setState(() {});
              },
              title: "My Location"),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DestinationButton(
                    ontap: () {
                      _markers.add(destinationMarker(
                          id: "5",
                          lat: 24.917084,
                          context: context,
                          long: 67.096916,
                          title: 'KFC',
                          description: 'Its Finger Licking Good',
                          url:
                              "https://th.bing.com/th/id/R.ddaaaa6732a3075cea29b50d52bfa760?rik=FaM3R94bpXAg%2bw&riu=http%3a%2f%2f104.244.122.169%2f%7ediylogodesigns%2fwp-content%2fuploads%2f2017%2f07%2fkfc-logo-vector-1.png&ehk=y9fhG2v47zMupLH4eM6XPWBHEl7VvFLY56HFaTYK5%2bs%3d&risl=&pid=ImgRaw&r=0"));
                      destinationLat = 24.917084;
                      destinationLong = 67.096916;

                      getPolyPoints();
                      setState(() {});
                    },
                    title: "KFC"),
                DestinationButton(
                    ontap: () {
                      _markers.add(destinationMarker(
                          id: "2",
                          lat: 24.909572,
                          context: context,
                          long: 67.084685,
                          title: 'McDonalds',
                          description: "I am Loving It",
                          url:
                              "https://yt3.ggpht.com/-avTHbIvvjKY/AAAAAAAAAAI/AAAAAAAAAAA/GtO4B-SrWkA/s900-c-k-no-mo-rj-c0xffffff/photo.jpg"));
                      destinationLat = 24.909572;
                      destinationLong = 67.084685;
                      getPolyPoints();

                      setState(() {});
                    },
                    title: "McDonalds"),
                DestinationButton(
                    ontap: () {
                      _markers.add(destinationMarker(
                          id: "3",
                          lat: 24.912647,
                          context: context,
                          long: 67.103053,
                          title: 'Chase Up',
                          description: "Your Shopping Partner",
                          url:
                              "https://th.bing.com/th/id/R.742951d782fbecd60f7736da51ff8a5c?rik=0jcbFqhTJbCE6g&riu=http%3a%2f%2fpakistansms.com%2fwp-content%2fthemes%2fpakistansms%2fimages%2fpartners%2f11.jpg&ehk=MkP186%2fFlga2fgEr9XZj8e5lA1EeS%2bqMUA5L4EARFSs%3d&risl=&pid=ImgRaw&r=0"));
                      destinationLat = 24.912647;
                      destinationLong = 67.103053;

                      getPolyPoints();

                      setState(() {});
                    },
                    title: "Chase Up"),
                ElevatedButton(
                  onPressed: () {
                    _markers.clear();
                    polyLineCoOrdinates.clear();
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: const StadiumBorder(
                          side: BorderSide(color: Colors.black, width: 2))),
                  child: const Text(
                    "Clear",
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<Marker> _addCurrentLocationMarker() async {
    final location = Location();

    try {
      LocationData userLocation = await location.getLocation();
      final coordinates =
          Coordinates(userLocation.latitude, userLocation.longitude);
      var address =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = address.first;
      var userAddress = first.addressLine;

      final usermarker = Marker(
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
        _markers.add(usermarker);
      });

      _controller?.animateCamera(CameraUpdate.newLatLng(usermarker.position));
      return usermarker;
    } catch (e) {
      if (kDebugMode) {
        print("Error getting location: $e");
      }
      return const Marker(
          markerId: MarkerId('000'), position: LatLng(0.0, 0.0));
    }
  }

  late double destinationLat;
  late double destinationLong;

  List<LatLng> polyLineCoOrdinates = [];
  Future<void> getPolyPoints() async {
    polyLineCoOrdinates.clear();
    Location location = Location();
    LocationData userLocation = await location.getLocation();
    double userLatitude = userLocation.latitude as double;
    double userLongitude = userLocation.longitude as double;
// final userCoordinates =
//           Coordinates(userLocation.latitude, userLocation.longitude);
    const googleApiKey = 'AIzaSyD_oHrVzqFOs5jGAOAH-w33x4I7_cZwl1I';
    final polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey,
        PointLatLng(userLatitude, userLongitude),
        PointLatLng(destinationLat, destinationLong));
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) =>
          polyLineCoOrdinates.add(LatLng(point.latitude, point.longitude)));
      setState(() {});
    }
  }
}

class DestinationButton extends StatelessWidget {
  final String title;
  final void Function()? ontap;
  const DestinationButton({
    super.key,
    required this.title,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: ontap,
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: const StadiumBorder(
              side: BorderSide(color: Colors.black, width: 2))),
      child: Text(
        title,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
