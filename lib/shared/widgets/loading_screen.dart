import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'QR iBar Cocina',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Builder(builder: (context) {
        return Center(
            child: CircularProgressIndicator(
          color: Colors.green,
        ));
      }),
    );
  }
}
