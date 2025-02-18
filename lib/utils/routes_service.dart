import 'dart:convert';

import 'package:route_tracker/model/location_info/location_info.dart';
import 'package:route_tracker/model/routes_model/routes_model.dart';
import "package:http/http.dart" as http;
import 'package:route_tracker/model/routes_modifiers.dart';

class RoutesService{

  final String baseUrl = "https://routes.googleapis.com/directions/v2:computeRoutes";
  final String apiKey = 'AIzaSyAf2EPgR-xW0UwC-o5ziJfntYbNOi8dbWM';

  Future<RoutesModel> fetchRoutes({required LocationInfo origin, required LocationInfo destination, RoutesModifiers? routeModifiers}) async {

    Uri url = Uri.parse(baseUrl);

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "X-Goog-Api-Key": apiKey,
      "X-Goog-FieldMask": "routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline"

    };


    Map<String, dynamic> body = {
        "origin": origin.toJson(),
        "destination": destination.toJson(),
        "travelMode": "DRIVE",
        "routingPreference": "TRAFFIC_AWARE",
        "computeAlternativeRoutes": false,
        "routeModifiers": routeModifiers != null ? routeModifiers.toJson() : RoutesModifiers().toJson(),
        "languageCode": "en-US",
        "units": "IMPERIAL"
      };


    var response = await http.post(url, headers: headers, body: body);

    if(response.statusCode == 200){

      var data = jsonDecode(response.body);

      return RoutesModel.fromJson(data);

    }

    else{
      throw Exception("No routes found");
    }
  }
}