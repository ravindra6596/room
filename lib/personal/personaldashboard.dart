import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:room/services/base.dart';
import 'package:http/http.dart' as http;
import 'package:room/services/log.dart';

import 'addIPersonaltem.dart';

class PersonalDashBoard extends StatefulWidget {
  const PersonalDashBoard({Key key}) : super(key: key);

  @override
  _PersonalDashBoardState createState() => _PersonalDashBoardState();
}

DateTime now = DateTime.now();
String month = DateFormat('MMMM').format(now);

class _PersonalDashBoardState extends State<PersonalDashBoard> {
  var items;
  var price;
  var name;
  String date = '';
  int todayTotal = 0;

  Future<List<dynamic>> getTodaysData() async {
    String url = BaseURL().baseAPIUrl + 'personal/month/';

    var response = await http.get(Uri.parse(url + userId), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      "Access-Control-Allow-Origin": "*", // Required for CORS support to work
      "Access-Control-Allow-Credentials":
          'true', // Required for cookies, authorization headers with HTTPS
      "Access-Control-Allow-Headers":
          "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      "Access-Control-Allow-Methods": "*",
      'Authorization': 'Bearer $token',
    });
    setState(() {});
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    getTodaysData();
  }

  @override
  Widget build(BuildContext context) {
    isLoggedIn();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Personal Dashboard'),
          actions: [
            IconButton(
              iconSize: 30,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddPersonalItem(),
                  ),
                );
              },
              icon: Icon(
                Icons.add,
              ),
            )
          ],
        ),
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.greenAccent,
                border: Border.all(color: Colors.green),
              ),
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.all(16),
              height: 100,
              width: double.infinity,
              child: Text(
                '$month' + '\n₹${todayTotal.toString()}.0',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                  future: getTodaysData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.length > 0) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              todayTotal = snapshot.data
                                  .map<int>((m) => m["price"])
                                  .reduce((a, b) => a + b);
                              items = snapshot.data[index]['item'];
                              price = snapshot.data[index]['price'];
                              name = snapshot.data[index]['uid']['name'];
                              DateTime dateTime = DateTime.tryParse(
                                  snapshot.data[index]['createdAt']);

                              date = DateFormat('dd-MM-yyyy').format(dateTime);
                              return Card(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Colors.green.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    child: Text(items[0]),
                                  ),
                                  title: Text(items),
                                  subtitle: Text(
                                    date.substring(0, 10),
                                  ),
                                  trailing: Text(
                                    '₹ ${price.toString()}.0',
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return Center(
                          child: Text(
                            'No Items found for Current Month',
                          ),
                        );
                      }
                    }
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 70,
                            width: 70,
                            child: CircularProgressIndicator(),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text('Awaiting Result'),
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}