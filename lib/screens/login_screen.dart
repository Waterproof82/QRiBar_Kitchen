import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qribar/provider/login_form_provider.dart';
import 'package:provider/provider.dart';
import 'package:qribar/provider/products_provider.dart';
import 'package:qribar/widgets/card_container.dart';

import 'package:qribar/widgets/widgets.dart';
import 'package:qribar/ui/input_decoration.dart';

class LoginScreen extends StatelessWidget {
  static final String routeName = 'login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 250),
              CardContainer(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text('Login', style: Theme.of(context).textTheme.headline4),
                    SizedBox(height: 30),
//Crea instancia de LoginForm y puede redibujar los widgets
//Solo que esta en LoginForm tendra acceso al Provider
                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: _LoginForm(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
/*               TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, 'register'),
                style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.indigo.withOpacity(0.1)), shape: MaterialStateProperty.all(StadiumBorder())),
                child: Text('Crear una nueva cuenta', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
              ), */
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    final productsService = Provider.of<ProductsService>(context, listen: false);
    //final navegacionModel = Provider.of<NavegacionModel>(context, listen: false);
    //final authService = Provider.of<AuthService>(context, listen: false);
    return Container(
      child: Form(
        //Para coger argumento GlobalKey y vincularlo
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              //Accedemos a variable static
              decoration: InputDecorations.authInputDecoration(
                hintText: 'xxx@xxx',
                labelText: 'Correo electrónico',
                prefixIcon: Icons.alternate_email_rounded,
              ),
              onChanged: (value) => loginForm.email = value,
              validator: (value) {
                //Patrón para validar emails
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

                RegExp regExp = new RegExp(pattern);

                return regExp.hasMatch(value ?? '') ? null : 'El correo no es correcto';
              },
              style: TextStyle(fontSize: 22),
            ),
            SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              //Accedemos a variable static
              decoration: InputDecorations.authInputDecoration(
                hintText: '*****',
                labelText: 'Contraseña',
                prefixIcon: Icons.lock_clock_outlined,
              ),
              onChanged: (value) => loginForm.password = value,
              validator: (value) {
                //Evalúan ambas condiciones. Con || puede ser solo una.
                return (value != null && value.length >= 6) ? null : 'La contraseña tiene que ser de 6 caracteres';
              },
              style: TextStyle(fontSize: 22),
            ),
            SizedBox(height: 30),
            MaterialButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.black26,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(
                  loginForm.isLoading ? 'Espere...' : 'Ingresar',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              //Para desactivar boton el onPressed tiene que ser null
              onPressed: loginForm.isLoading
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();

                      if (!loginForm.isValidForm()) return;

                      loginForm.isLoading = true;
                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(email: loginForm.email, password: loginForm.password);
                        // productsService.idBar = 'Test';
                        String result = loginForm.email.substring(0, loginForm.email.indexOf('@'));
                        String capitalizeResult = '$result'.toTitleCase();
                        // print(capitalizeResult);
                        //  productsService.idBar = '$result';
                        await productsService.loadMesas('$capitalizeResult');
                        //productsService.idBar = 'Test';
                        //loginForm.email;
                        Navigator.pushReplacementNamed(context, 'home');
                      } on FirebaseAuthException /* catch (e) */ {
                        //print('Failed with error code: ${e.code}');
                        // ignore: deprecated_member_use
                        /*         Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(
                            e.code,
                            style: TextStyle(fontSize: 20),
                          ),
                        )); */
                        //print(e.message);
                        loginForm.isLoading = false;
                      }

                      //UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: loginForm.email, password: loginForm.password);

                      //final String? errorMessage = await authService.login(loginForm.email, loginForm.password);
                      //?email=${loginForm.email}&pass=${loginForm.password}
                      //if (errorMessage) {

                      // NotificationService.showSnackbar(errorMessage);
                      //loginForm.isLoading = false;
                    },
            )
          ],
        ),
      ),
    );
  }
}

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}
