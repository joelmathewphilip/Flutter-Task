import 'package:flutter/material.dart';
import 'package:flutter_task/Network/network.dart';
import 'package:flutter_task/home.dart';
import 'package:provider/provider.dart';
import 'package:flutter_task/Network/network_status.dart';

void main() {
  runApp(Home_Page());
}

class Home_Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<NetworkStatus>(
      builder: (context) => NetworkService().connectionStatusController,
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      home: Home(),
      ),
    );

  }
}
