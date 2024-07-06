import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ConnectivityService {
  ConnectivityService() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        Fluttertoast.showToast(msg: "No Internet Connection");
      } else {
        Fluttertoast.showToast(msg: "Connected to the Internet");
      }
    });
  }
}
