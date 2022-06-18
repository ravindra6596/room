//@dart=2.9
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_strategy/url_strategy.dart';

import 'login/login_form.dart';
import 'widgets/tabbar.dart';

var username;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  var prefs = await SharedPreferences.getInstance();
  username = prefs.getString('email');
  setPathUrlStrategy();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: LandingScreen(),);
  }
}

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => username == null ? LoginScreen() : TabBars(),
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      body: Center(
        child: Image.asset(
          'assets/images/splash.gif',
        ),
      ),
    );
  }
}
