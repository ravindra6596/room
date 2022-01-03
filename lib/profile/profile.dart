import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:room/login/login_form.dart';
import 'package:room/services/base.dart';
import 'package:room/services/log.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  final Future<Post> post;
  const Profile({Key key, this.post}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

Future<Post> fetchPost() async {
  String url = BaseURL().baseAPIUrl + "user/" + userId;
  var response = await http.get(Uri.parse(url), headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  });

  return Post.fromJson(
    json.decode(response.body),
  );
}

class Post {
  String name;
  String email;
  var contact;
  String dob;

  Post({
    this.name,
    this.email,
    this.contact,
    this.dob,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      name: json['name'],
      email: json['email'],
      contact: json['contact'],
      dob: json['dob'],
    );
  }
}

class _ProfileState extends State<Profile> {
  // ignore: unused_field
  bool _isLoading = false;
  showAlert() {
    Alert(
      onWillPopActive: true,
      context: context,
      type: AlertType.warning,
      title: "Warning",
      desc: "Are You Sure You Want To Logout?",
      buttons: [
        DialogButton(
          child: Text(
            "Yes",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          onPressed: () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen(),
              ),
              (Route<dynamic> route) => false),
          width: 120,
        ),
        DialogButton(
          child: Text(
            'No',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(false),
          color: Colors.red,
        )
      ],
    ).show();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final _signOutRequest = await showAlert();
    if (_signOutRequest == true) {
      await logout();
    }
  }

  logout() async {
    // ignore: omit_local_variable_types
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // ignore: unawaited_futures
    sharedPreferences.remove('email');
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) => LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Profile'),
        actions: [
          TextButton(
            onPressed: () => _confirmSignOut(context),
            /* () async {
              SharedPreferences sharedPreferences =
                  await SharedPreferences.getInstance();
              sharedPreferences.remove('token');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext ctx) => LoginScreen(),
                ),
              );
            }, */
            child: Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<Post>(
            future: fetchPost(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CircleAvatar(
                      child: Icon(
                        Icons.person,
                        size: 75,
                      ),
                      radius: 40,
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    ListTile(
                      leading: Icon(Icons.person_outlined),
                      title: Text(snapshot.data.name),
                    ),
                    ListTile(
                      leading: Icon(Icons.email),
                      title: Text(snapshot.data.email),
                    ),
                    ListTile(
                      leading: Icon(Icons.phone),
                      title: Text(snapshot.data.contact.toString()),
                    ),
                    ListTile(
                      leading: Icon(Icons.date_range),
                      title: Text(snapshot.data.dob),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner
              return CircularProgressIndicator();
            },
            /* child:  */
          ),
        ),
      ),
    );
  }
}
