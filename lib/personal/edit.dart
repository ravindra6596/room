// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:room/services/base.dart';
import 'package:room/services/log.dart';

class EditPersonal extends StatefulWidget {
  EditPersonal({
    Key key,
  }) : super(key: key);

  @override
  State<EditPersonal> createState() => _EditPersonalState();
  var itemID;
  var itemName;
  var itemPrice;
  EditPersonal.withItemData(String id, name, price) {
    itemID = id;
    itemName = name;
    itemPrice = price;
  }
}

class _EditPersonalState extends State<EditPersonal> {
  TextEditingController itemNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  updateItem(String itemId, item, price) async {
    Map data = {
      'item': item,
      'price': price,
    };
    String body = json.encode(data);
    var response = await http.put(
      Uri.parse(BaseURL().baseAPIUrl + "personal/month/item/" + itemId),
      body: body,
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'Item Data Updated Successfully!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else {
      print(
        "Error",
      );
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      itemNameController.text = widget.itemName;
      priceController.text = widget.itemPrice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: itemNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  updateItem(
                    widget.itemID,
                    itemNameController.text,
                    priceController.text.toString(),
                  );
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Update',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
