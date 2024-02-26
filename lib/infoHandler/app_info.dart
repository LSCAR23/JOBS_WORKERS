import 'package:flutter/cupertino.dart';
import 'package:jobs_workers/models/directions.dart';
import 'package:jobs_workers/models/trips_history_model.dart';

class AppInfo extends ChangeNotifier{
  Directions? userPickUpLocation, userDropOffLocation;
  int countTotalTrips=0;
  String workerTotalEarnings="0";
  String workerAverageRatings= "0";
  List <String> historyTripsKeyList=[];
  List<TripHistoryModel>allTripHistoryInformationList=[];

  void updatePickUpLocationAddress(Directions userPickUpddress){
    userPickUpLocation= userPickUpddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Directions userDropOffAddress){
    userDropOffLocation=userDropOffAddress;
    notifyListeners();
  }

   updateOverAllTripsCounter(int overAllTripsCounter){
    countTotalTrips= overAllTripsCounter;
    notifyListeners();
  }
  updateOverAllTripsKeys(List<String> tripsKeysList){
    historyTripsKeyList= tripsKeysList;
    notifyListeners();
  }
  updateOverAllTripsHistoryInformation(TripHistoryModel eachTripHistory){
    allTripHistoryInformationList.add(eachTripHistory);
    notifyListeners();
  }

  updateWorkerTotalEarnings(String workerEarnings){
    workerTotalEarnings=workerEarnings;
  }

  updateWorkerAverageRatings(String workerRatins){
    workerAverageRatings= workerRatins;
  }
}