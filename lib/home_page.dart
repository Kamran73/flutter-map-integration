import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Completer<GoogleMapController> _controller = Completer();

  List<Marker> _markers = [];
  final List<Marker> _list = const [
    Marker(
      markerId: MarkerId('1'),
      position: LatLng(31.177813, 71.207230),
      infoWindow: InfoWindow(
        title: 'My Location',
      ),
    ),
    Marker(
      markerId: MarkerId('2'),
      position: LatLng(28.81284, 70.52341),
      infoWindow: InfoWindow(
        title: 'Zahir Pir',
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _markers.addAll(_list);
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission _permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('location service are disabled');
    }

    _permission = await Geolocator.checkPermission();
    if (_permission == LocationPermission.denied) {
      _permission = await Geolocator.requestPermission();
      if (_permission == LocationPermission.denied) {
        return Future.error('location permission is denied');
      }
    }

    if (_permission == LocationPermission.deniedForever) {
      return Future.error('permission denied forever');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  static const _initialCameraPosition =
  CameraPosition(target: LatLng(31.177813, 71.207230), zoom: 14);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.location_disabled_outlined),
          onPressed: () async {

            var responseLocation = await _determinePosition();
            debugPrint(responseLocation.toString());

            _markers.add(Marker(markerId: const MarkerId('3'),
              infoWindow: const InfoWindow(title: 'my current location'),
              position: LatLng(responseLocation.latitude, responseLocation.longitude), ),);

            GoogleMapController controller = await _controller.future;

            controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(responseLocation.latitude, responseLocation.longitude),zoom: 14),),);
            setState(() {

            });

          },

        ),
        body: GoogleMap(
          markers: Set.of(_markers),
          initialCameraPosition: _initialCameraPosition,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
    );
  }
}
