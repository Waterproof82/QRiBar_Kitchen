import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qribar_cocina/screens/screens.dart';
import 'package:qribar_cocina/services/auth_service.dart';

class CheckAuthScreen extends StatelessWidget {
  static final String routeName = 'checking';

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: authService.readToken(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (!snapshot.hasData) return Text('Espere');
//Si no tengo la data
            if (snapshot.data == '') {
              //microtask al ejecutarse en medio de la app para que no falle
              Future.microtask(() {
                //Creamos una transición de páginas manual
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(pageBuilder: (_, __, ___) => LoginScreen(), transitionDuration: Duration(seconds: 100)),
                );
              });
            } else {
              //Xa q lo haga tan pronto pueda cuando finalice la contruccion del widget
              Future.microtask(() {
                //Creamos una transición de páginas manual
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(pageBuilder: (_, __, ___) => PrinterestScreen(), transitionDuration: Duration(seconds: 100)),
                );
              });
            }
            return Container();
          },
        ),
      ),
    );
  }
}
