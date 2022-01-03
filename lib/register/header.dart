import 'package:flutter/material.dart';

Widget header() {
  return  Container(
      height: 200,
      color: Colors.white,
      child: Center(
        child: Image.asset(
          'assets/images/register.png',
          alignment: Alignment.center,
          width: 250,
          height: 200,
        ),
      ),
    
  );
}
