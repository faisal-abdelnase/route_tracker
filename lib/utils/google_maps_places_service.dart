import 'dart:convert';

import 'package:route_tracker/model/place_autocomplete_model/place_autocomplete_model.dart';
import 'package:http/http.dart' as http;
import 'package:route_tracker/model/place_details_model/place_details_model.dart';

class GooglMapsPlacesService{
  final String baseUrl = "https://maps.googleapis.com/maps/api/place";
  final String apiKey = 'AIzaSyAf2EPgR-xW0UwC-o5ziJfntYbNOi8dbWM';
  Future<List<PlaceAutocompleteModel>> getPrediction({required String input}) async {

    var response = await http.get(
      Uri.parse("$baseUrl/autocomplete/json?key=$apiKey&input=$input"));

      if(response.statusCode == 200){

        var data = jsonDecode(response.body)["predictions"];
        List<PlaceAutocompleteModel> places = [];

        for(var item in data){
          places.add(PlaceAutocompleteModel.fromJson(item));
        }

        return places;

      }else{
        throw Exception();
      }

  }








  Future<PlaceDetailsModel> getPlaceDetails({required String placeId}) async {

    var response = await http.get(
      Uri.parse("$baseUrl/details/json?key=$apiKey&place_id=$placeId"));

      if(response.statusCode == 200){

        var data = jsonDecode(response.body)["result"];
        

        return PlaceDetailsModel.fromJson(data);

      }else{
        throw Exception();
      }

  }
}