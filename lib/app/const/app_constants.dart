import 'package:flutter/material.dart';

class AppConstants {
  static const String emailPattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  static const List<Map<String, dynamic>> tiempos = [
    {'texto': '0-10 min', 'color': Color.fromARGB(0, 255, 255, 255)},
    {'texto': '10-20 min', 'color': Color.fromARGB(255, 255, 193, 7)},
    {'texto': '20-30 min', 'color': Color.fromRGBO(242, 132, 64, 1)},
    {'texto': '+ 30 min', 'color': Color.fromARGB(255, 255, 0, 0)},
  ];
}
