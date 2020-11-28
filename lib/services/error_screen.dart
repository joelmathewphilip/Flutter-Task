import 'package:flutter/material.dart';

class Error_Screen extends StatelessWidget {
  String error_message;
  Error_Screen({this.error_message});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 290,),
            Icon(Icons.error_rounded),
            Text(error_message),
          ],
        ),
      ),
    );
  }
}
