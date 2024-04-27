import '../models/active_nearby_available_drivers.dart';

class GeoFireAssistant {
  static List<ActiveNearByAvailableDrivers> activeNearByAvailableDriversList = [];

    //remove offline driver from online list
  static void deleteOfflineDriverFromList(String driverId){
    int indexNumber = activeNearByAvailableDriversList.indexWhere((element) => element.driverId == driverId);

    activeNearByAvailableDriversList.removeAt(indexNumber);
  }
  
  //update nearby active drivers
  static void updateActiveNearByAvailableDriverLocation(ActiveNearByAvailableDrivers driverWhoMove) {
    int indexNumber = activeNearByAvailableDriversList.indexWhere((element) => element.driverId == driverWhoMove.driverId);

    activeNearByAvailableDriversList[indexNumber].locationLattitude = driverWhoMove.locationLattitude;
    activeNearByAvailableDriversList[indexNumber].locationLongitude = driverWhoMove.locationLongitude;
  }
}
