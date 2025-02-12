import 'package:flutter/material.dart';
import 'package:route_tracker/views/google_map_view.dart';


void main() {
  runApp(const RouteTrackerApp());
}

class RouteTrackerApp extends StatelessWidget {
  const RouteTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GoogleMapView(),
    
    );
  }
}