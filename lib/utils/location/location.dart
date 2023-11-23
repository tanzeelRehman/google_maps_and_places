import 'package:location/location.dart';


abstract class LocationInfo{
  Future<LocationData>  getLocation();
  Stream<LocationData>  getLocationStream();
}

class LocationImp extends LocationInfo{
  Location location = Location();
  
  @override
  Future<LocationData> getLocation() async{
    return await location.getLocation();
  }
  
  @override
  Stream<LocationData> getLocationStream() {
    return location.onLocationChanged.first.asStream();
  }

}