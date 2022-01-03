import 'package:flutter/material.dart';

Widget header() {
  return  Container(
      height: 150,
      color: Colors.white,
      child: Center(
        child: Image.asset(
          'assets/images/shop.png',
          alignment: Alignment.center,
          width: 250,
          height: 250,
        ),
      ),
    
  );
}
