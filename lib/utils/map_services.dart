import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:route_tracker/model/location_info/lat_lng.dart';
import 'package:route_tracker/model/location_info/location.dart';
import 'package:route_tracker/model/location_info/location_info.dart';
import 'package:route_tracker/model/place_autocomplete_model/place_autocomplete_model.dart';
import 'package:route_tracker/model/place_details_model/place_details_model.dart';
import 'package:route_tracker/model/routes_model/routes_model.dart';
import 'package:route_tracker/utils/google_maps_places_service.dart';
import 'package:route_tracker/utils/location_service.dart';
import 'package:route_tracker/utils/routes_service.dart';

class MapServices {
  late PlacesService placesService = PlacesService();
  late LocationService locationService = LocationService();
  late RoutesService routesService = RoutesService();


  Future<void> getPrediction({required String sessiontoken, required String input, required List<PlaceAutocompleteModel> places}) async {
    if(input.isNotEmpty){
        var result = await placesService.getPrediction(
          sessiontoken: sessiontoken,
          input: input);

        places.clear();
        places.addAll(result);
        
      }

      else{
        places.clear();
        
      }

  }


  Future<List<LatLng>> getRouteData({required LatLng currentLocation, required LatLng destinationLocation}) async {

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




  void displayRoute(List<LatLng> points, 
  {required Set<Polyline> polylines, required GoogleMapController googleMapController}) {
    Polyline route = Polyline(
      polylineId: PolylineId("route"), 
      points: points,
      color: Colors.blue,
      width: 5,

      );

      polylines.add(route);

      LatLngBounds bounds = getLatLngBounds(points);

      googleMapController.animateCamera(
        CameraUpdate.newLatLngBounds(
          bounds, 32
        )
      );
      
  }




  LatLngBounds getLatLngBounds(List<LatLng> points) {
    var southWestLatitude = points.first.latitude;
    var southWestLongitude = points.first.longitude;

    var northEastLatitude = points.first.latitude;
    var northEastLongitude = points.first.longitude;

    for(var point in points){
      southWestLatitude = min(southWestLatitude, point.latitude);
      southWestLongitude = min(southWestLongitude, point.longitude);

      northEastLongitude = max(northEastLongitude, point.longitude);
      northEastLatitude = max(northEastLatitude, point.latitude);
    }

    return LatLngBounds(southwest: LatLng(southWestLatitude, southWestLongitude), 
                        northeast: LatLng(northEastLatitude, northEastLongitude));
  }



  Future<LatLng> updatecurrentLocation(
    {required GoogleMapController googleMapController, required Set<Marker> markers}) async{

    var locationData = await locationService.getLocation();

        var currentLocation = LatLng(
          locationData.latitude!, locationData.longitude!);

          Marker currentLocationMarker = Marker(
            markerId: MarkerId("my location"),
            position: currentLocation,
            );

            markers.add(currentLocationMarker);

            

        CameraPosition myCurrentCameraPosition = CameraPosition(
          target: currentLocation,
          zoom: 16,
          );

        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(myCurrentCameraPosition),
          );


          return currentLocation;
  }


  Future<PlaceDetailsModel> getPlaceDetails({required String placeId}) async{
    return await placesService.getPlaceDetails(
                  placeId: placeId);
  }



}