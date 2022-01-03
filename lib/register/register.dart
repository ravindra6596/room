import 'dart:convert';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:room/login/login_form.dart';
import 'package:room/services/base.dart';
import 'package:http/http.dart' as http;
import 'header.dart';

class Register extends StatefulWidget {
  const Register({Key key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final format = DateFormat("dd-MM-yyyy");
  DateTime date;
  register(String name, email, contact, sel, pass) async {
    Map data = {
      'name': name,
      'email': email,
      'contact': contact,
      'dob': sel.toString(),
      'password': pass,
    };
    print(data);

    String body = json.encode(data);
    var response = await http.post(
      Uri.parse(BaseURL().baseAPIUrl + "user/register"),
      body: body,
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
        "Access-Control-Allow-Origin": "*"
      },
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 201) {
      showAlert();
    } else {
      Alert(
        context: context,
        type: AlertType.error,
        title: "Sorry",
        desc: "Something Went Wrong!.",
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

  showAlert() {
    Alert(
      context: context,
      type: AlertType.success,
      title: "Success",
      desc: "You Are Successfully Register.",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => LoginScreen()),
              (Route<dynamic> route) => false),
          width: 120,
        )
      ],
    ).show();
    setState(() {
      _isLoading = false;
    });
  }

  DateTime selectdate;
  var sel;
  bool _isLoading = false;
  bool _obscureText = true;
  final TextEditingController name = new TextEditingController();
  final TextEditingController email = new TextEditingController();
  final TextEditingController contact = new TextEditingController();
  final TextEditingController dob = new TextEditingController();
  final TextEditingController password = new TextEditingController();
  final nameValidator = GlobalKey<FormState>();
  final emailValidator = GlobalKey<FormState>();
  final contactValidator = GlobalKey<FormState>();
  final dobValidator = GlobalKey<FormState>();
  final passwordValidator = GlobalKey<FormState>();
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              header(),
              Form(
                key: nameValidator,
                child: TextFormField(
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name Can\`t Be Empty.';
                    }
                    return null;
                  },
                  controller: name,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Form(
                key: emailValidator,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email Can\`t Be Empty.';
                    }
                    return null;
                  },
                  controller: email,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.black,
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Form(
                key: contactValidator,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Contact Can\`t Be Empty.';
                    }
                    return null;
                  },
                  controller: contact,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Contact',
                    prefixIcon: Icon(
                      Icons.phone,
                      color: Colors.black,
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Form(
                key: dobValidator,
                child: DateTimeField(
                  validator: (value) {
                    if (value == null) {
                      return 'DOB Can\`t Be Empty.';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.datetime,
                  textInputAction: TextInputAction.next,
                  format: format,
                  onShowPicker: (context, currentValue) {
                    return showDatePicker(
                      context: context,
                      firstDate: DateTime(1950),
                      initialDate: DateTime.now(),
                      lastDate: DateTime(2099),
                    );
                  },
                  onChanged: (dt) {
                    setState(() {
                      selectdate = dt;
                      sel = DateFormat('dd-MM-yyyy').format(selectdate);
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'DOB',
                    prefixIcon: Icon(
                      Icons.date_range,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              /* Form(
                key: dobValidator,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'DOB Can\`t Be Empty.';
                    }
                    return null;
                  },
                  controller: dob,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Date Of Birth',
                    prefixIcon: Icon(
                      Icons.date_range,
                      color: Colors.black,
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                ),
              ), */
              SizedBox(
                height: 10,
              ),
              Form(
                key: passwordValidator,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password Can\`t Be Empty.';
                    }
                    return null;
                  },
                  obscureText: _obscureText,
                  controller: password,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
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
                  ),
                  textInputAction: TextInputAction.done,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              !_isLoading
                  ? Container(
                      width: 250,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            // _isLoading = true;
                            if (nameValidator.currentState.validate() &&
                                emailValidator.currentState.validate() &&
                                contactValidator.currentState.validate() &&
                                dobValidator.currentState.validate() &&
                                passwordValidator.currentState.validate()) {
                              register(name.text, email.text, contact.text,
                                  sel, password.text);
                            }
                          });
                        },
                        child: Text('Register'),
                      ),
                    )
                  : SpinKitDualRing(
                      color: Colors.green,
                      size: 50.0,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
