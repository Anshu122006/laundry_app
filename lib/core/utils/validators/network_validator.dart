import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkValidator{
  // ctreating singleton onject of the class
  static NetworkValidator? _instance;
  NetworkValidator._();
  static NetworkValidator get instance {
    _instance ??= NetworkValidator._();
    return _instance!;
  }

  // initializing objects of the connectivity and internet connection package
  final Connectivity _connectivity = Connectivity();
  final InternetConnection _internetChecker = InternetConnection();

  // function to check if the device is connected to the internet
  Future<bool> hasInternetConnection() async{
    final connectivityResult = await _connectivity.checkConnectivity();
    if(connectivityResult.isEmpty || connectivityResult.contains(ConnectivityResult.none)){
      return false;
    }
    return await _internetChecker.hasInternetAccess;
  }

  // once called it retures a boolean denoting whether the client is connected
  // to the internet or not wherver the connection ststus changes
  Stream<bool> onInternetStatusChange(){
    return _connectivity.onConnectivityChanged.asyncMap((results) async{
      if(results.isEmpty || results.contains(ConnectivityResult.none)){
        return false;
      }
      return await _internetChecker.hasInternetAccess;
    }).distinct();
  }
}