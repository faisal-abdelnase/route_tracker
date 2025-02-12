import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(29.86398403496827, 31.302744328217248)),));
  }
}