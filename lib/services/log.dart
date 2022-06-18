import 'package:room/services/base.dart';

String token = "";
String userId = '';
String email = '';
isLoggedIn() async {
  Map<String, dynamic> sessionObj = await BaseURL().checkIfLoggedIn();
  token = sessionObj["token"];
  userId = sessionObj["_id"];
  email = sessionObj['email'];
}
