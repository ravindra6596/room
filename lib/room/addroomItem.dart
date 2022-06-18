// ignore_for_file: unnecessary_statements

import 'dart:convert';

import 'package:flutter/material.dart';
 import 'package:room/services/base.dart';
import 'package:http/http.dart' as http;
import 'package:room/services/log.dart';
 
class AddRoomItem extends StatefulWidget {
  const AddRoomItem({Key key}) : super(key: key);

  @override
  _AddRoomItemState createState() => _AddRoomItemState();
}

class _AddRoomItemState extends State<AddRoomItem> {
  // ignore: unused_field
  bool _isLoading = false;
  final TextEditingController itemName = new TextEditingController();
  final TextEditingController price = new TextEditingController();
  final itemValid = GlobalKey<FormState>();
  final priceValid = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    isLoggedIn();
    return AlertDialog(
      content: SingleChildScrollView(
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
                minLines: 3,
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
                        addItem(userId, itemName.text, price.text);
                      }
                    },
                    child: Text('Submit'),
                  )
                : CircularProgressIndicator(),
          ],
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
      Uri.parse(BaseURL().baseAPIUrl + "room/addItem"),
      body: body,
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 201) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'Item Added Successfully!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } else {
      print(
        "Error",
      );
    }
  }
}
