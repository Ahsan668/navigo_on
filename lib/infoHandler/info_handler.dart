
import 'package:flutter/material.dart';
import 'package:navigo_on/models/directions.dart';

import '../models/trip_history_model.dart';

class AppInfo extends ChangeNotifier{
  Directions? userPickUpLocation, userDropOffLocation;
  int countTotalTrips = 0;
  List<String> historyTripsKeyList = [];
  List<TripHistoryModel> allTripsHistoryInformationList = [];
  
  //update pickup location 
  void updatePickUpLocationAddress(Directions userPickUoAddress){
    userPickUpLocation = userPickUoAddress;
    notifyListeners();
  }
  
  //update dropoff location
  void updateDropOffLocationAddress(Directions dropOffAddress){
    userDropOffLocation = dropOffAddress;
    notifyListeners();
  }

  //update all trip counter
  updateOverallTripCounter(int overAllTripCounter){
    countTotalTrips = overAllTripCounter;
    notifyListeners();
  }

  //update all trip keys
  updateOverAllTripKeys(List<String> tripsKeysList){
    historyTripsKeyList = tripsKeysList;
    notifyListeners();
  }
  
  //update all trip history info
  updateOverAllTripHistoryInformation(TripHistoryModel eachTripHistory){
    allTripsHistoryInformationList.add(eachTripHistory);
    notifyListeners();
  }
}
