import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

Future<List> getGPS(gpsObject) async {
    var newLocation = await gpsObject.getlocation();
    return [newLocation.latitude, newLocation.longitude];
  }


  Future<bool> isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return (await DataConnectionChecker().hasConnection);
    } 
    else if (connectivityResult == ConnectivityResult.wifi) {
      return (await DataConnectionChecker().hasConnection);
    } 
    else {
      return false;
    }
  }