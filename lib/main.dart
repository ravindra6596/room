//@dart=2.9
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';

import 'login/login_form.dart';
import 'widgets/tabbar.dart';

var username;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  var prefs = await SharedPreferences.getInstance();
  username = prefs.getString('email');
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Modern Boys',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: SplashScreen(
        image: Image.asset(
          'assets/images/cycle.png',
          width: 200,
          //height: 300,
        ),
        backgroundColor: Colors.green[300],
        seconds: 5,
        navigateAfterSeconds: username == null ? LoginScreen() : TabBars(),
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 150.0,
        loaderColor: Colors.white,
        loadingText: Text(
          'Welcome To Our App',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}