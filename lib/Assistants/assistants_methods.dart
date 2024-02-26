import 'dart:developer';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jobs_workers/Assistants/request_assistant.dart';
import 'package:jobs_workers/global/global.dart';
import 'package:jobs_workers/global/map_key.dart';
import 'package:jobs_workers/infoHandler/app_info.dart';
import 'package:jobs_workers/models/direction_details_info.dart';
import 'package:jobs_workers/models/directions.dart';
import 'package:jobs_workers/models/trips_history_model.dart';
import 'package:jobs_workers/models/user_model.dart';
import 'package:provider/provider.dart';

class AssistandMethods {
  static void readCurrentOnlineUserInfo() async {
    currentUser = firebaseAuth.currentUser;
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child("users").child(currentUser!.uid);

    userRef.once().then((snap) {
      if (snap.snapshot.value != null) {
        userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot);
      }
    });
  }

  static Future<String> searchAddressForGeographicCoordinates(
      Position position, context) async {
        String apiUrl= "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
        String humanReadableAddress="";
        var requestResponse= await RequestAssistant.receiveRequest(apiUrl);
        if(requestResponse!= "Error Occured. Failed. No response."){
          humanReadableAddress= requestResponse["results"][0]["formatted_address"];

          Directions userPickUpAddress= Directions();
          userPickUpAddress.locationLatitude= position.latitude;
          userPickUpAddress.locationLongitude= position.longitude;
          userPickUpAddress.locationName= humanReadableAddress;

          Provider.of<AppInfo>(context,listen:false).updatePickUpLocationAddress(userPickUpAddress);
        }
        return humanReadableAddress;
      }
  
  static Future <DirectionsDetailsInfo> obtainOriginToDestinationDirectionDetails(LatLng originPosition, LatLng destinationPosition) async{
   String urlOriginToDestinationDirectionDetails= "https://maps.googleapis.com/maps/api/directions/json?origin=${originPosition.latitude},${originPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=$mapKey";
  var responseDirectionApi = await RequestAssistant.receiveRequest(urlOriginToDestinationDirectionDetails);

  DirectionsDetailsInfo directionsDetailsInfo= DirectionsDetailsInfo();
  directionsDetailsInfo.e_points = responseDirectionApi["routes"][0]["overview_polyline"]["points"];

  directionsDetailsInfo.distance_text= responseDirectionApi["routes"][0]["legs"][0]["distance"]["text"];
  directionsDetailsInfo.distance_value= responseDirectionApi["routes"][0]["legs"][0]["distance"]["value"];
  directionsDetailsInfo.duration_text= responseDirectionApi["routes"][0]["legs"][0]["duration"]["text"];
  directionsDetailsInfo.duration_value= responseDirectionApi["routes"][0]["legs"][0]["duration"]["value"];

  return directionsDetailsInfo;
  }

  static pauseLiveLocationUpdates(){
    streamSubscriptionPosition!.pause();
    print("entroooooo aqui");
    Geofire.removeLocation(firebaseAuth.currentUser!.uid);
  }

  static double calculateFareAmountFromOriginToDestination(DirectionsDetailsInfo directionsDetailsInfo){
    double timeTravelledFareAmountPerMinute = (directionsDetailsInfo.distance_value!/60)*0.1;
    double distanceTravelledFareAmountPerKilometer = (directionsDetailsInfo.duration_value!/1000)*0.1;

    double totalFareAmount = timeTravelledFareAmountPerMinute * distanceTravelledFareAmountPerKilometer;
    double localCurrencyTotalFare= totalFareAmount*107;

    if(workerVehicleType=="Bike"){
      double resultFareAmount = ((localCurrencyTotalFare.truncate())*0.8);
      resultFareAmount;
    }
    else if(workerVehicleType=="CNG"){
      double resultFareAmount = ((localCurrencyTotalFare.truncate())*1.5);
      resultFareAmount;
    }
    else if(workerVehicleType=="Car"){
      double resultFareAmount = ((localCurrencyTotalFare.truncate())*2);
      resultFareAmount;
    }
    else{
      return localCurrencyTotalFare.truncate().toDouble();
    }
    return localCurrencyTotalFare.truncate().toDouble();
  }

  static void readTripsKeysForOnlineWorker(context){
    FirebaseDatabase.instance.ref().child("All Ride Request").orderByChild("workerId").equalTo(firebaseAuth.currentUser!.uid).once().then((snap){
      if(snap.snapshot.value != null){
        Map keysTripsId= snap.snapshot.value as Map;


        int overAllTripsCounter = keysTripsId.length;
        Provider.of<AppInfo>(context,listen: false).updateOverAllTripsCounter(overAllTripsCounter);

        List<String> tripsKeysList=[];

        keysTripsId.forEach((key, value) {
          tripsKeysList.add(key);
        });

        Provider.of<AppInfo>(context,listen: false).updateOverAllTripsKeys(tripsKeysList);

        readTripsHistoryInformation(context);
      }
    });
  }

  static void readTripsHistoryInformation(context){
    var tripAllKeys= Provider.of<AppInfo>(context, listen: false).historyTripsKeyList;

    for(String eachKey in tripAllKeys){
    FirebaseDatabase.instance.ref().child("All Ride Request").child(eachKey).once().then((snap){
      var eachTripHistory= TripHistoryModel.fromSnapshot(snap.snapshot);

      if((snap.snapshot.value as Map)["status"]== "ended"){
        Provider.of<AppInfo>(context,listen: false).updateOverAllTripsHistoryInformation(eachTripHistory);
      }
    });
    }
  }

  static void readWorkerEarnings(context){
    FirebaseDatabase.instance.ref().child("workers").child(firebaseAuth.currentUser!.uid).child("earnings").once().then((snap){
      if(snap.snapshot.value!= null){
        String workerEarnings = snap.snapshot.value.toString();
        Provider.of(context,listen: false).updateWorkerTotalEarnings(workerEarnings);
      }
    });

    readTripsKeysForOnlineWorker(context);
  }

  static void readWorkerRatings(context){
    FirebaseDatabase.instance.ref().child("workers").child(firebaseAuth.currentUser!.uid).child("ratings").once().then((snap){
      if(snap.snapshot.value!= null){
        String workerRatings= snap.snapshot.value.toString();
        Provider.of<AppInfo>(context,listen: false).updateWorkerAverageRatings(workerRatings);
      }
    });
  }
}
