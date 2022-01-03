import 'package:flutter/material.dart';
import 'package:room/personal/personaldashboard.dart';
import 'package:room/profile/profile.dart';
import 'package:room/room/roomdashboard.dart';

import 'months.dart';

class TabBars extends StatefulWidget {
  const TabBars({Key key}) : super(key: key);

  @override
  _TabBarsState createState() => _TabBarsState();
}

class _TabBarsState extends State<TabBars> {
  int _selectedIndex = 0;
  List<Widget> _screen = [
    DashBoard(),
    PersonalDashBoard(),
    Months(),
    Profile(
      post: fetchPost(),
    ),
    
  ];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex == 0) return true;
        setState(() {
          _selectedIndex = 0;
        });
        return false;
      },
      child: Scaffold(
        body: _screen[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Theme.of(context).colorScheme.secondary,
          showUnselectedLabels: false,
          currentIndex: _selectedIndex,
          onTap: (value) {
            setState(() => _selectedIndex = value);
          },
          backgroundColor: Colors.white,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.shifting,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.group,
              ),
              label: 'Room',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              label: 'Personal',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.date_range,
              ),
              label: 'Month',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle,
              ),
              label: 'Account',
            ),
            
            
          ],
        ),
      ),
    );
  }
}
