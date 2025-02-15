import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:route_tracker/model/place_autocomplete_model/place_autocomplete_model.dart';

class CustomListView extends StatelessWidget {
  const CustomListView({
    super.key,
    required this.places,
  });

  final List<PlaceAutocompleteModel> places;

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
              onPressed: (){}, 
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