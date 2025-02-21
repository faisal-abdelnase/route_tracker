import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:route_tracker/model/place_autocomplete_model/place_autocomplete_model.dart';
import 'package:route_tracker/model/place_details_model/place_details_model.dart';
import 'package:route_tracker/utils/map_services.dart';

class CustomListView extends StatelessWidget {
  const CustomListView({
    super.key,
    required this.places, required this.mapServices, required this.onPlaceSelect,
  });

  final List<PlaceAutocompleteModel> places;
  final void Function(PlaceDetailsModel) onPlaceSelect;
  final MapServices mapServices;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: places.length,
        itemBuilder: (context, index){
          return ListTile(
            title: Text(places[index].description!),
            leading: Icon(FontAwesomeIcons.mapPin),
            trailing: IconButton(
              onPressed: () async {
                var placeDetails = await mapServices.getPlaceDetails(placeId: places[index].placeId!);
                  onPlaceSelect(placeDetails);


              }, 
              icon: Icon(Icons.arrow_circle_right_outlined)),

          );
        }, 
        separatorBuilder: (context, index){
          return Divider(
            height: 0,
          );
        }, 
        ),
    );
  }
}