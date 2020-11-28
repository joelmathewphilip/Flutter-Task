  import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_task/Network/network_status.dart';

class NetworkService
{
  StreamController<NetworkStatus> connectionStatusController = StreamController<NetworkStatus>();
  NetworkService()
  {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      connectionStatusController.add(_getStatusFromResult(result));
    });
  }

  NetworkStatus _getStatusFromResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.mobile:
        return NetworkStatus.Cellular;
      case ConnectivityResult.wifi:
        return NetworkStatus.WiFi;
      case ConnectivityResult.none:
        return NetworkStatus.Offline;
      default:
        return NetworkStatus.Offline;
    }
  }
}