// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   GoogleMapController? _mapController;
//   Position? _currentPosition;
//   final Set<Marker> _markers = {};
//   final Set<Polyline> _polylines = {};
//   final List<LatLng> _polylineCoordinates = [];
//
//
//   @override
//   void initState() {
//     super.initState();
//     _initCurrentLocation();
//     _listenCurrentLocation();
//   }
//
//   Future<void> _initCurrentLocation() async {
//     bool isEnable = await Geolocator.isLocationServiceEnabled();
//     if (!isEnable) {
//       // Handle disabled location service
//     }
//
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied ||
//         permission == LocationPermission.deniedForever) {
//       permission = await Geolocator.requestPermission();
//     }
//
//     if (permission == LocationPermission.whileInUse ||
//         permission == LocationPermission.always) {
//       Position position = await Geolocator.getCurrentPosition();
//       _currentPosition = position;
//       _updatePositionMarker(position);
//     } else {
//       print("Location permission denied");
//     }
//
//   }
//
//   void _listenCurrentLocation() {
//     Geolocator.getPositionStream(
//       locationSettings: const LocationSettings(
//         accuracy: LocationAccuracy.best,
//
//       ),
//     ).listen((position) {
//       _currentPosition = position;
//       _updateCameraPosition(position);
//       _updatePositionMarker(position);
//       _updatePolylines();
//     }, onError: (e) {
//       log(">>>>>>>>>>>>>>>> Error >>>>>>>>>>>>>>>>>>>>>>>>>>> $e");
//     });
//   }
//
//   void _updatePolylines() {
//     _polylines.add(Polyline(
//       polylineId: const PolylineId("route"),
//       visible: true,
//       points: _polylineCoordinates,
//       color: Colors.blue,
//       width: 5,
//     ));
//   }
//
//   void _updatePositionMarker(Position position) {
//     final marker = Marker(
//       markerId: const MarkerId("currentLocation"),
//       position: LatLng(position.latitude, position.longitude),
//       infoWindow: InfoWindow(
//           title: "Your Location",
//           snippet:
//               "Latitude: ${position.latitude}, Longitude: ${position.longitude}"),
//       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//     );
//
//     setState(() {
//       _markers.add(marker);
//     });
//   }
//
//   void _updateCameraPosition(Position position) {
//     if (_mapController != null) {
//       _mapController!.animateCamera(
//         CameraUpdate.newCameraPosition(
//           CameraPosition(
//               target: LatLng(position.latitude, position.longitude),
//           zoom: 15,
//           ),
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Google Map'),
//       ),
//       body: GoogleMap(
//         onMapCreated: (GoogleMapController controller) {
//           _mapController = controller;
//         },
//         initialCameraPosition: CameraPosition(
//           target: LatLng(_currentPosition?.latitude ?? 23.39267443826321,
//               _currentPosition?.longitude ?? 90.42583864875947),
//         ),
//         markers: _markers,
//         myLocationEnabled: true,
//         myLocationButtonEnabled: true,
//         trafficEnabled: true,
//         compassEnabled: true,
//         zoomGesturesEnabled: true,
//       ),
//     );
//   }
// }


import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final List<LatLng> _polylineCoordinates = [];
  bool _showPolylines = true;  // State to toggle polyline visibility

  @override
  void initState() {
    super.initState();
    _initCurrentLocation();
    _listenCurrentLocation();
  }

  Future<void> _initCurrentLocation() async {
    bool isEnable = await Geolocator.isLocationServiceEnabled();
    if (!isEnable) {
      // Handle disabled location service
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition();
      _currentPosition = position;
      _updatePositionMarker(position);
    } else {
      print("Location permission denied");
    }
  }

  void _listenCurrentLocation() {
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
      ),
    ).listen((position) {
      _currentPosition = position;
      _updateCameraPosition(position);
      _updatePositionMarker(position);
      if (_showPolylines) {
        _polylineCoordinates.add(LatLng(position.latitude, position.longitude));
        _updatePolylines();
      }
    }, onError: (e) {
      log("Error: $e");
    });
  }

  void _updatePolylines() {
    setState(() {
      _polylines.add(Polyline(
        polylineId: const PolylineId("route"),
        visible: _showPolylines,
        points: _polylineCoordinates,
        color: Colors.blue,
        width: 5,
      ));
    });
  }

  void _updatePositionMarker(Position position) {
    final marker = Marker(
      markerId: const MarkerId("currentLocation"),
      position: LatLng(position.latitude, position.longitude),
      infoWindow: InfoWindow(
          title: "Your Location",
          snippet:
          "Latitude: ${position.latitude}, Longitude: ${position.longitude}"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      _markers.add(marker);
    });
  }

  void _updateCameraPosition(Position position) {
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 15,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Map'),
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(_currentPosition?.latitude ?? 23.39267443826321,
              _currentPosition?.longitude ?? 90.42583864875947),
        ),
        markers: _markers,
        polylines: _polylines,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        trafficEnabled: true,
        compassEnabled: true,
        zoomGesturesEnabled: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _showPolylines = !_showPolylines;
            _updatePolylines();
          });
        },
        tooltip: 'Toggle Polylines',
        child: Icon(_showPolylines ? Icons.directions: Icons.stop_circle),
      ),
    );
  }
}
