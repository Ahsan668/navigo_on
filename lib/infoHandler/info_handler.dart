
import 'package:flutter/material.dart';
import 'package:navigo_on/models/directions.dart';

import '../models/trip_history_model.dart';

class AppInfo extends ChangeNotifier{
  Directions? userPickUpLocation, userDropOffLocation;
  int countTotalTrips = 0;
  List<String> historyTripsKeyList = [];
  List<TripHistoryModel> allTripsHistoryInformationList = [];

  void updatePickUpLocationAddress(Directions userPickUoAddress){
    userPickUpLocation = userPickUoAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Directions dropOffAddress){
    userDropOffLocation = dropOffAddress;
    notifyListeners();
  }

  updateOverallTripCounter(int overAllTripCounter){
    countTotalTrips = overAllTripCounter;
    notifyListeners();
  }

  updateOverAllTripKeys(List<String> tripsKeysList){
    historyTripsKeyList = tripsKeysList;
    notifyListeners();
  }

  updateOverAllTripHistoryInformation(TripHistoryModel eachTripHistory){
    allTripsHistoryInformationList.add(eachTripHistory);
    notifyListeners();
  }
}