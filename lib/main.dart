import 'package:flutter/material.dart';
import 'package:weather_app/views/newCity.dart';
import 'views/homePage.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.grey,
    ),
    home: HomePage(),
  ));
}
