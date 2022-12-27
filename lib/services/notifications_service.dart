import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//Podemos llamarla desde cualquier parte, se vincula con el Scaffold para tener referencia
class NotificationService {
  static GlobalKey<ScaffoldMessengerState> messengerKey = new GlobalKey<ScaffoldMessengerState>();

  static showSnackbar(String message, numElmentos) {
    final snackbar = new SnackBar(
      content: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: GestureDetector(
          onTap: () {
            // numElmentos.categoriaSelected = 'Cuenta';
            //numElmentos.itemSeleccionado = 99;
          },
          child: Container(
            margin: EdgeInsets.all(2),
            color: Colors.greenAccent[400],
            height: 100,
            child: Center(
              child: Text(
                message,
                style: GoogleFonts.poiretOne(color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
      //backgroundColor: Colors.greenAccent[300],
      /*  action: SnackBarAction(
        label: 'Deshacer',
        textColor: Colors.white,
        onPressed: () {
          // Algo de código para ¡deshacer el cambio!
        },

        //behavior: SnackBarBehavior.floating,
      ), */
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(2.00),
        ),
      ),

      //backgroundColor: Colors.greenAccent[300],
      duration: Duration(seconds: 3),
      //behavior: SnackBarBehavior.floating,
    );

    messengerKey.currentState?.showSnackBar(snackbar);
  }
}
