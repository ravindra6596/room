import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:room/services/base.dart';
import 'package:http/http.dart' as http;
import 'package:room/services/log.dart';
import 'package:room/widgets/tabbar.dart';

class AddPersonalItem extends StatefulWidget {
  const AddPersonalItem({Key key}) : super(key: key);

  @override
  _AddPersonalItemState createState() => _AddPersonalItemState();
}

class _AddPersonalItemState extends State<AddPersonalItem> {
  // ignore: unused_field
  bool _isLoading = false;
  final TextEditingController itemName = new TextEditingController();
  final TextEditingController price = new TextEditingController();
  final itemValid = GlobalKey<FormState>();
  final priceValid = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    isLoggedIn();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Personal Item'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: itemValid,
                  child: TextFormField(
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Item Name Can\`t Be Empty.';
                      }
                      return null;
                    },
                    minLines: 6,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: itemName,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Item',
                      hintText: 'Items Name',
                      prefixIcon: Icon(
                        Icons.local_grocery_store,
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Form(
                  key: priceValid,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Price Can\`t Be Empty.';
                      }
                      return null;
                    },
                    controller: price,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Price',
                      hintText: 'MRP',
                      prefixIcon: Icon(
                        Icons.money,
                      ),
                    ),
                    textInputAction: TextInputAction.done,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                !_isLoading
                    ? ElevatedButton(
                        onPressed: () {
                          if (itemValid.currentState.validate() &&
                              priceValid.currentState.validate()) {
                            setState(() {
                              _isLoading = true;
                            });
                            addItem(
                              userId,
                              itemName.text,
                              price.text,
                            );
                          }
                        },
                        child: Text('Submit'),
                      )
                    : CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  addItem(String uid, item, price) async {
    Map data = {
      'userId': uid,
      'item': item,
      'price': price,
    };

    String body = json.encode(data);
    var response = await http.post(
      Uri.parse(BaseURL().baseAPIUrl + "personal/addItem"),
      body: body,
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials":
            'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers":
            "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "*",
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 201) {
      showAlert();
    } else {
      print(
        "Error",
      );
    }
  }

  showAlert() {
    Alert(
      context: context,
      type: AlertType.success,
      title: "Success",
      desc: "Data Saved Successfully.",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => TabBars()),
              (Route<dynamic> route) => false),
          width: 120,
        )
      ],
    ).show();
    setState(() {
      _isLoading = false;
    });
  }
}
