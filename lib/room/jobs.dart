 import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Jobs extends StatefulWidget {
  @override
  _JobsState createState() => _JobsState();
}

class _JobsState extends State<Jobs> {
  Future<List<dynamic>> getJobsData() async {
    String url = 'https://hospitality92.com/api/jobsbycategory/All';
    var response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
    return json.decode(response.body)['jobs'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: FutureBuilder<List<dynamic>>(
                future: getJobsData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          var title = snapshot.data[index]['title'];
                          var company = snapshot.data[index]['company_name'];
                          var skills = snapshot.data[index]['skills'];
                          var description = snapshot.data[index]['description'];
                          var positions = snapshot.data[index]['positions'];
                          return Card(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Colors.green.shade300
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  leading: Text(skills),
                                  title: Text(title),
                                  subtitle: Text(
                                    company + '\n' + description,
                                  ),
                                  trailing: Text(positions),
                                ),
                                ListTile(
                                  leading: Icon(Icons.check),
                                  title: Text('User Name'),
                                  subtitle: Text('User Type'),
                                  trailing: FlutterLogo(size: 100),
                                ),
                                ButtonBar(
                                  alignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(5.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.green),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text('Skill 0'),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(5.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.green),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text('Skill 1'),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(5.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.green),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text('Skill 2'),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(5.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.green),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text('Skill 3'),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }
                  return CircularProgressIndicator();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
 
/* 
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class Jobs extends StatefulWidget {
  Jobs() : super();

  @override
  JobsState createState() => JobsState();
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class JobsState extends State<Jobs> {
  final _debouncer = Debouncer(milliseconds: 500);

  List<Subject> subjects = [];
  List<Subject> filteredSubjects = [];
  //API call for All Subject List
  static String url = 'https://hospitality92.com/api/jobsbycategory/All';
  static Future<List<Subject>> getAllSubjectsList() async {
    try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print(response.body);
      List<Subject> list = parseAgents(response.body);

      return list;
    } else {
      throw Exception('Error');
    }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static List<Subject> parseAgents(String responseBody) {
    final parsed =
        json.decode(responseBody)['jobs'].cast<Map<String, dynamic>>();
    return parsed.map<Subject>((json) => Subject.fromJson(json)).toList();
  }

  @override
  void initState() {
    super.initState();
    getAllSubjectsList().then((subjectFromServer) {
      setState(() {
        subjects = subjectFromServer;
        filteredSubjects = subjects;
      });
    });
  }

  //Main Widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Subjects',
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: Column(
        children: <Widget>[
          //Search Bar to List of typed Subject
          Container(
            padding: EdgeInsets.all(15),
            child: TextField(
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(
                    color: Colors.blue,
                  ),
                ),
                suffixIcon: InkWell(
                  child: Icon(Icons.search),
                ),
                contentPadding: EdgeInsets.all(15.0),
                hintText: 'Search ',
              ),
              onChanged: (string) {
                _debouncer.run(() {
                  setState(() {
                    filteredSubjects = subjects
                        .where((u) => (u.title
                            .toLowerCase()
                            .contains(string.toLowerCase())))
                        .toList();
                  });
                });
              },
            ),
          ),
          //Lists of Subjects
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              itemCount: filteredSubjects.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: Colors.grey[300],
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          leading: Text(
                            filteredSubjects[index].skills,
                          ),
                          title: Text(
                            filteredSubjects[index].title,
                            style: TextStyle(fontSize: 16),
                          ),
                          trailing: Text(filteredSubjects[index].position.toString()),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

//Class For Subject
class Subject {
  String title;
  int id;
  String skills;
  String position;
  Subject({
    this.id,
    this.title,
    this.skills,
    this.position,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
        title: json['title'] as String,
        id: json['id'],
        skills: json['skills'],
        position: json['positions']);
  }
}
 */