import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:room/services/base.dart';
import 'package:room/services/log.dart';

deleteItem(String itemId, BuildContext context) async {
  var response = await http.delete(
    Uri.parse(BaseURL().baseAPIUrl + "room/month/item/" + itemId),
    headers: {
      "Content-Type": "application/json",
      "accept": "application/json",
      'Authorization': 'Bearer $token',
    },
  );
  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Item Deleted Successfully!',
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

showDeleteAlert(BuildContext context, String id) {
  return Alert(
    context: context,
    type: AlertType.warning,
    title: "Warning", 
    desc: "Are you sure you want to delete this Item?.",
    buttons: [
      DialogButton(
        child: Text(
          "NO",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () => Navigator.of(context).pop(),
        width: 120,
      ),
      DialogButton(
        color: Colors.red,
        child: Text(
          "YES",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () {
          deleteItem(id, context);
          Navigator.of(context).pop();
        },
        width: 120,
      ),
    ],
  ).show();
}
