

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:route_tracker/model/place_autocomplete_model/place_autocomplete_model.dart';
import 'package:route_tracker/utils/location_service.dart';
import 'package:route_tracker/utils/map_services.dart';
import 'package:route_tracker/widgets/custom_list_view.dart';
import 'package:route_tracker/widgets/custom_text_filed.dart';
import 'package:uuid/uuid.dart';

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({super.key});

  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {

  late CameraPosition initalCameraPosition;

  late GoogleMapController googleMapController;

  late MapServices mapsServices;

  late TextEditingController textEditingController;

  late Uuid uuid;

  late LatLng currentLocation;

  late LatLng destinationLocation;

  String? sessiontoken;

  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  
  List<PlaceAutocompleteModel> places = [];

  Timer? debounce;

  @override
  void initState() {
    initalCameraPosition = const CameraPosition(
      target: LatLng(0,0),
      );

      uuid = Uuid();

      mapsServices = MapServices();

      textEditingController = TextEditingController();
      fetchPredictions();
      
    super.initState();
  }

  void fetchPredictions() {
    textEditingController.addListener(() {
      if(debounce?.isActive ?? false){
        debounce?.cancel();
      }
      debounce = Timer(Duration(milliseconds: 100), () async {
        sessiontoken ??= uuid.v4();
        await mapsServices.getPrediction(
        sessiontoken: sessiontoken!, 
        input: textEditingController.text, 
        places: places);

      setState(() {});

      });
      
      
    });
  }


  @override
  void dispose() {
    textEditingController.dispose();
    debounce?.cancel();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    
    return Stack(
      children: [
        GoogleMap(
          markers: markers,
          polylines: polylines,
          zoomControlsEnabled: false,
          initialCameraPosition: initalCameraPosition,
          onMapCreated: (controller) {
            googleMapController = controller;
            updatecurrentLocation();
          },
          ),

          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Column(
              children: [
                CustomTextField(textEditingController: textEditingController,),

                SizedBox(height: 16,),

                CustomListView(
                  places: places, 
                  mapServices: mapsServices,

                  onPlaceSelect: (placeAutocompleteModel) async {
                    textEditingController.clear();
                    places.clear();

                    sessiontoken = null;
                    setState(() {});

                    destinationLocation = LatLng(
                      placeAutocompleteModel.geometry!.location!.lat!, 
                      placeAutocompleteModel.geometry!.location!.lng!);

                      var points = await mapsServices.getRouteData(currentLocation: currentLocation, destinationLocation: destinationLocation);
                      mapsServices.displayRoute(points, polylines: polylines, googleMapController: googleMapController);
                      setState(() {});

                    
                  },

                  ),
              ],
            )),
      ],
    );
  }







  
  void updatecurrentLocation() async {

    try {

        currentLocation = await mapsServices.updatecurrentLocation(googleMapController: googleMapController, markers: markers);
        setState(() {});

  } on LocationServiceException catch (e) {
    print(e);
  
  } on LocationPermissionException catch(e){

    print(e);

  } catch(e){

    print(e);

  }
    
  }



  
}











// create text field
// listen to the text field
// search place
// display results