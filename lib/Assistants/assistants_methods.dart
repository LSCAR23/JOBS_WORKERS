import 'dart:developer';

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
    Geofire.removeLocation(firebaseAuth.currentUser!.uid);
  }
}
