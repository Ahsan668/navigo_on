import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:navigo_on/Assistants/request_assistant.dart';
import 'package:navigo_on/global/global.dart';
import 'package:navigo_on/global/map_key.dart';
import 'package:navigo_on/models/trip_history_model.dart';
import 'package:navigo_on/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../infoHandler/info_handler.dart';
import '../models/direction_detail_info.dart';
import '../models/directions.dart';
import '../models/trips_history_model.dart';

class AssistantMethods {
  
  //current_user_info
  static void readCurrentOnlineUserInfo() async {
    currentUser = firebaseAuth.currentUser;
    CollectionReference userRef = FirebaseFirestore.instance.collection("users");
    userRef.doc(firebaseAuth.currentUser!.uid).get().then((snap){
      if(snap != null){
        userModelCurrentInfo = UserModel.fromDocument(snap);
      }
    });
  }

  //search address for geographic location
  static Future<String> searchAddressForGeographicCoOrdinates(Position position, context) async {

    String apiUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
    String humanReadableAddress = "";

    var requestResponse = await RequestAssistant.receiveRequest(apiUrl);

    if(requestResponse != "Error Occured. Failed. No Response."){
      humanReadableAddress = requestResponse["results"][0]["formatted_address"];

      Directions userPickUpAddress = Directions();
      userPickUpAddress.locationLatitiude = position.latitude;
      userPickUpAddress.locationLongitiude = position.longitude;
      userPickUpAddress.locationName = humanReadableAddress;

      Provider.of<AppInfo>(context, listen: false).updatePickUpLocationAddress(userPickUpAddress);
    }

    return humanReadableAddress;
  }
  
//origin to destination details
  static Future<DirectionDetailsInfo> obtainOriginToDestinationDirectionDetails(LatLng originPosition, LatLng destinationPosition) async {

    String urlOriginToDestinationDirectionDetails = "https://maps.googleapis.com/maps/api/directions/json?origin=${originPosition.latitude},${originPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=$mapKey";
    var responseDirectionApi = await RequestAssistant.receiveRequest(urlOriginToDestinationDirectionDetails);

    DirectionDetailsInfo directionDetailsInfo = DirectionDetailsInfo();
    directionDetailsInfo.e_points = responseDirectionApi["routes"][0]["overview_polyline"]["points"];

    directionDetailsInfo.distance_text = responseDirectionApi["routes"][0]["legs"][0]["distance"]["text"];
    directionDetailsInfo.distance_value = responseDirectionApi["routes"][0]["legs"][0]["distance"]["value"];

    directionDetailsInfo.duration_text = responseDirectionApi["routes"][0]["legs"][0]["duration"]["text"];
    directionDetailsInfo.duration_value = responseDirectionApi["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetailsInfo;
  }

  //fare calculation from origin to destination
  static double calculateFareAmountFromOriginToDestination(DirectionDetailsInfo directionDetailsInfo){
    double timeTraveledFareAmountPerMinute = (directionDetailsInfo.duration_value! /60) * 0.1;
    double distanceTraveledFareAmountPerKilometer = (directionDetailsInfo.duration_value! / 1000) * 0.1;

    //USD
    double totalFareAmount = timeTraveledFareAmountPerMinute + distanceTraveledFareAmountPerKilometer;

    return double.parse(totalFareAmount.toStringAsFixed(1));
  }

  static sendNotificationToDriverNow(String deviceRegistrationToken, String userRideRequestId, context) async {
    String destinationAddress = userDropOffAddress;

    Map<String, String> headerNotification = {
      'Content-Type': 'application/json',
      'Authorization': cloudMessagingServerToken,
    };

    Map bodyNotification = {
      "body":"Destination Address: \n$destinationAddress.",
      "title":"New Trip Request"
    };

    Map dataMap = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "rideRequestId": userRideRequestId
    };

    Map officialNotificationFormat = {
      "notification": bodyNotification,
      "data": dataMap,
      "priority": "high",
      "to": deviceRegistrationToken,
    };

    var responseNotification = http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: headerNotification,
      body: jsonEncode(officialNotificationFormat),
    );
  }

  //retrieve the trips Keys for online user
  //trip key = ride request key
  static void readTripsKeysForOnlineUser(context){
    FirebaseDatabase.instance.ref().child("All Ride Requests").orderByChild("userName").equalTo(userModelCurrentInfo!.name).once().then((snap) {
      if(snap.snapshot.value != null){
        Map keysTripsId = snap.snapshot.value as Map;

        //count total number of trips and share it with Provider
        int overAllTripsCounter = keysTripsId.length;
        Provider.of<AppInfo>(context, listen: false).updateOverallTripCounter(overAllTripsCounter);

        //share trips keys with Provider
        List<String> tripsKeysList = [];
        keysTripsId.forEach((key, value) {
          tripsKeysList.add(key);
        });
        Provider.of<AppInfo>(context, listen: false).updateOverAllTripKeys(tripsKeysList);

        //get trips keys data - read trips complete information
        readTripsHistoryInformation(context);
      }
    });
  }

  static void readTripsHistoryInformation(context){
    var tripsAllKeys = Provider.of<AppInfo>(context, listen: false).historyTripsKeyList;

    for(String eachKey in tripsAllKeys){
      FirebaseDatabase.instance.ref()
          .child("All Ride Requests")
          .child(eachKey)
          .once()
          .then((snap)
      {
        var eachTripHistory = TripsHistoryModel.fromSnapshot(snap.snapshot);

        if((snap.snapshot.value as Map)["status"] == "ended"){
          //update or add each history to OverAllTrips History data list
          Provider.of<AppInfo>(context, listen: false).updateOverAllTripHistoryInformation(eachTripHistory as TripHistoryModel);
        }
      });
    }
  }

}
