import 'package:flutter/material.dart';
import 'package:room/services/base.dart';

String token = "";
String userId = '';
String email = '';
isLoggedIn() async {
  Map<String, dynamic>  sessionObj = await BaseURL().checkIfLoggedIn();
  // ignore: unused_local_variable
  BuildContext context;
  /* if (sessionObj == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
          (Route<dynamic> route) => false);
    } */
  token = sessionObj ["token"];
  userId = sessionObj["_id"];
  email = sessionObj['email'];
 
}
