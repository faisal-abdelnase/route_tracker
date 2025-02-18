import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:route_tracker/model/place_autocomplete_model/place_autocomplete_model.dart';
import 'package:route_tracker/utils/google_maps_places_service.dart';
import 'package:route_tracker/utils/location_service.dart';
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

  late LocationService locationService;

  late GoogleMapController googleMapController;

  late TextEditingController textEditingController;

  late GooglMapsPlacesService googlMapsPlacesService;

  late Uuid uuid;

  String? sessiontoken;

  Set<Marker> markers = {};
  
  List<PlaceAutocompleteModel> places = [];

  @override
  void initState() {
    initalCameraPosition = const CameraPosition(
      target: LatLng(0,0),
      );

      uuid = Uuid();

      locationService = LocationService();

      googlMapsPlacesService = GooglMapsPlacesService();

      textEditingController = TextEditingController();
      fetchPredictions();
      
    super.initState();
  }

  void fetchPredictions() {
    textEditingController.addListener(() async {
      sessiontoken ??= uuid.v4();
      if(textEditingController.text.isNotEmpty){
        var result = await googlMapsPlacesService.getPrediction(
          sessiontoken: sessiontoken!,
          input: textEditingController.text);

        places.clear();
        places.addAll(result);
        setState(() {
          
        });
      }

      else{
        places.clear();
        setState(() {
          
        });
      }

      
    });
  }


  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    print(sessiontoken);
    return Stack(
      children: [
        GoogleMap(
          markers: markers,
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
                  googlMapsPlacesService: googlMapsPlacesService,

                  onPlaceSelect: (placeAutocompleteModel) {
                    textEditingController.clear();
                    places.clear();

                    sessiontoken = null;
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