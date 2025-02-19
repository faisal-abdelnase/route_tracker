import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:route_tracker/model/location_info/lat_lng.dart';
import 'package:route_tracker/model/location_info/location.dart';
import 'package:route_tracker/model/location_info/location_info.dart';
import 'package:route_tracker/model/place_autocomplete_model/place_autocomplete_model.dart';
import 'package:route_tracker/model/routes_model/route.dart';
import 'package:route_tracker/model/routes_model/routes_model.dart';
import 'package:route_tracker/utils/google_maps_places_service.dart';
import 'package:route_tracker/utils/location_service.dart';
import 'package:route_tracker/utils/routes_service.dart';
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

  late RoutesService routesService;

  late LatLng currentLocation;

  late LatLng destinationLocation;

  String? sessiontoken;

  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  
  List<PlaceAutocompleteModel> places = [];

  @override
  void initState() {
    initalCameraPosition = const CameraPosition(
      target: LatLng(0,0),
      );

      uuid = Uuid();

      routesService = RoutesService();

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
                  googlMapsPlacesService: googlMapsPlacesService,

                  onPlaceSelect: (placeAutocompleteModel) async {
                    textEditingController.clear();
                    places.clear();

                    sessiontoken = null;
                    setState(() {});

                    destinationLocation = LatLng(
                      placeAutocompleteModel.geometry!.location!.lat!, 
                      placeAutocompleteModel.geometry!.location!.lng!);

                      var points = await getRouteData();
                      displayRoute(points);

                    
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

        currentLocation = LatLng(
          locationData.latitude!, locationData.longitude!);

          Marker currentLocationMarker = Marker(
            markerId: MarkerId("my location"),
            position: currentLocation,
            );

            markers.add(currentLocationMarker);

            setState(() {});

        CameraPosition myCurrentCameraPosition = CameraPosition(
          target: currentLocation,
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



  
  Future<List<LatLng>> getRouteData() async {

    LocationInfoModel origin = LocationInfoModel(
      location: LocationModel(
        latLng: LatLngModel(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        )
      );


      LocationInfoModel destination = LocationInfoModel(
        location: LocationModel(
          latLng: LatLngModel(latitude: destinationLocation.latitude, longitude: destinationLocation.longitude)
        )
      );

    RoutesModel routes = await routesService.fetchRoutes(origin: origin, destination: destination);

    List<LatLng> points = getDecodedRoute(routes);

    return points;
  }



  List<LatLng> getDecodedRoute(RoutesModel routes) {
      PolylinePoints polylinePoints = PolylinePoints();
      List<PointLatLng> result = polylinePoints.decodePolyline(routes.routes!.first.polyline!.encodedPolyline!);
    
    List<LatLng> points = result.map((e) => LatLng(e.latitude, e.longitude)).toList();
    return points;
  }




  
  void displayRoute(List<LatLng> points) {
    Polyline route = Polyline(
      polylineId: PolylineId("route"), 
      points: points,
      color: Colors.blue,
      width: 5,

      );

      polylines.add(route);
      setState(() {});
  }
}










// create text field
// listen to the text field
// search place
// display results