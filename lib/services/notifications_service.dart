import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationService {
  static GlobalKey<ScaffoldMessengerState> messengerKey = new GlobalKey<ScaffoldMessengerState>();

  static showSnackbar(String message, numElmentos) {
    final snackbar = new SnackBar(
      content: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: GestureDetector(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.all(2),
              color: Colors.greenAccent[400],
              height: 100,
              child: Center(child: Text(message, style: GoogleFonts.poiretOne(color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold))),
            ))
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2.00)),
      ),
      duration: Duration(seconds: 3),
    );
    messengerKey.currentState?.showSnackBar(snackbar);
  }
}
