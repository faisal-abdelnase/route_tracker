import 'package:location/location.dart';

class LocationService {
  Location location = Location();


  Future<bool> checkAndRequestLocationService() async {
    var isServiceEnable = await location.serviceEnabled();

    if(!isServiceEnable){
      isServiceEnable = await location.requestService();
      if(!isServiceEnable){
        return false;
      }
    }

    return true;

  }





  Future<bool> checkAndRequestLocationPermission() async {
    var permissionStatus = await location.hasPermission();

    if(permissionStatus == PermissionStatus.denied){
      permissionStatus = await location.requestPermission();
      return permissionStatus == PermissionStatus.granted;
    }

    if(permissionStatus == PermissionStatus.deniedForever){
      return false;
    }

    return true;
  }





  void getRealTimeLocationData(void Function(LocationData)? onData){
    location.onLocationChanged.listen(onData);
  }




  Future<LocationData> getLocation()async{
    return await location.getLocation();
  }



}