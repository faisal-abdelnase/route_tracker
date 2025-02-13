import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:route_tracker/utils/location_service.dart';

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({super.key});

  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {

  late CameraPosition initalCameraPosition;

  late LocationService locationService;

  late GoogleMapController googleMapController;
  Set<Marker> markers = {};


  @override
  void initState() {
    initalCameraPosition = const CameraPosition(
      target: LatLng(0,0),
      );

      locationService = LocationService();
      
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      markers: markers,
      zoomControlsEnabled: false,
      initialCameraPosition: initalCameraPosition,
      onMapCreated: (controller) {
        googleMapController = controller;
        updatecurrentLocation();
      },
      );
  }








  
  void updatecurrentLocation() async {

    try {

        var locationData = await locationService.getLocation();

        LatLng currentPostion = LatLng(
          locationData.latitude!, locationData.longitude!);

          Marker currentLocationMarker = Marker(
            markerId: MarkerId("my location"),
            position: currentPostion,
            );

            markers.add(currentLocationMarker);

            setState(() {});

        CameraPosition myCurrentCameraPosition = CameraPosition(
          target: currentPostion,
          zoom: 16,
          );

        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(myCurrentCameraPosition),
          );

  } on LocationServiceException catch (e) {
  
  
  } on LocationPermissionException catch(e){

  } catch(e){

  }
    
  }
}


// create text field
// listen to the text field
// search place
// display results