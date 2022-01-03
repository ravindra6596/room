import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:room/register/register.dart';
import 'package:room/services/base.dart';
import 'package:room/widgets/tabbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'design_widgets/header.dart';

class LoginScreen extends StatefulWidget {
  // final AppBar appBar;

  // LoginScreen({key, this.appBar}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true;
  bool _validate = false;
  final double circleRadius = 100.0;
  final double circleBorderWidth = 1.0;
  final emailValidator = GlobalKey<FormState>();
  final passwordValidator = GlobalKey<FormState>();
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  signIn(String email, password) async {
    Map data = {'email': email, 'password': password};
    String body = json.encode(data);
    var jsonData;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var response = await http.post(
      Uri.parse(BaseURL().baseAPIUrl + "user/login"),
      body: body,
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
      },
    );
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      if (jsonData != null) {
        
        sharedPreferences.setString("token", jsonData['token']);
        getUserData(email, jsonData['token']).then((userData) {
          if (userData != null) {
            sharedPreferences.setString("email", email);
            sharedPreferences.setString("_id", jsonData['message'][0]['_id']);
            /*  sharedPreferences.setString("name", jsonData['message'][0]['name']);
            sharedPreferences.setString("email", jsonData['message'][0]['email']);
            sharedPreferences.setString("contact", jsonData['message'][0]['contact']);
            sharedPreferences.setString("dob", jsonData['message'][0]['dob']);
           */
          }
        });

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (BuildContext context) => TabBars(),
            ),
            (Route<dynamic> route) => false);
      }
    } else {
      Alert(
        context: context,
        type: AlertType.error,
        title: "Sorry",
        desc: "Invalid email or Password.",
        buttons: [
          DialogButton(
            color: Colors.red,
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future getUserData(email, token) async {
    var url = BaseURL().baseAPIUrl + "user/email/" + email;
    var userData = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    if (userData.statusCode == 200) {
      return json.decode(userData.body);
    }
    return null;
  }

  List<Widget> _buildChildern() {
    return [
      SizedBox(
        height: 30.0,
      ),
      _buildEmailTextField(),
      SizedBox(
        height: 15.0,
      ),
      _buildPasswordTextField(),
      SizedBox(
        height: 15.0,
      ),
      _buildLoginButtonField(),
      TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => Register(),
            ),
          );
        },
        child: Text('Sign Up'),
      ),
    ];
  }

  _buildEmailTextField() {
    return Form(
      key: emailValidator,
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Email Can\`t Be Empty.';
          }
          return null;
        },
        controller: emailController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Email',
          prefixIcon: Icon(Icons.mail, color: Colors.black),
          enabled: _isLoading == false,
          errorText: _validate ? 'Email Can\`t Be Empty.' : null,
        ),
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
      ),
    );
  }

  _buildPasswordTextField() {
    return Form(
      key: passwordValidator,
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Password Can\`t Be Empty.';
          }
          return null;
        },
        obscureText: _obscureText,
        controller: passwordController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Password',
          enabled: _isLoading == false,
          prefixIcon: Icon(
            Icons.lock,
            color: Colors.black,
          ),
          suffixIcon: InkWell(
            onTap: _toggle,
            child: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              size: 25.0,
              color: Colors.black,
            ),
          ),
          errorText: _validate ? 'Password Can\`t Be Empty' : null,
        ),
        textInputAction: TextInputAction.done,
      ),
    );
  }

  Container _buildLoginButtonField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.only(
        right: 30.0,
        left: 30,
      ),
      child: !_isLoading
          ? Container(
              height: 50.0,
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              margin: EdgeInsets.only(top: 15.0),
              // ignore: deprecated_member_use
              child: RaisedButton(
                focusColor: Colors.green[200],
                highlightColor: Colors.green[900],
                hoverColor: Colors.greenAccent,
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    if (emailValidator.currentState.validate() &&
                        passwordValidator.currentState.validate()) {
                      signIn(emailController.text, passwordController.text);
                    }
                  });
                },
                color: Colors.green,
                child: Text(
                  "Sign In",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
              ),
            )
          //CircularProgressIndicator()
          : SpinKitDualRing(
              color: Colors.green,
              size: 50.0,
            ),
    );
  }

  Widget loginCardUI() {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: circleRadius / 2.0),
          child: Container(
            height: 370,
            width: 400,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: Colors.grey[200],
                ),
              ),
              color: Colors.white,
              margin: EdgeInsets.all(
                16,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: _buildChildern(),
                ),
              ),
            ),
          ),
        ),
        Container(
          width: circleRadius,
          height: circleRadius,
          decoration: ShapeDecoration(
            shape: CircleBorder(),
            color: Colors.green,
          ),
          child: Padding(
            padding: EdgeInsets.all(circleBorderWidth),
            child: DecoratedBox(
              decoration: ShapeDecoration(
                shape: CircleBorder(),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    'assets/images/grocery.png',
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            header(),
            SizedBox(height: 20),
            loginCardUI(),
          ],
        ),
      ),
    );
  }
}
