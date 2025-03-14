import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qribar_cocina/data/const/const.dart';
import 'package:qribar_cocina/data/extensions/string_extension.dart';
import 'package:qribar_cocina/presentation/login/provider/login_form_provider.dart';
import 'package:qribar_cocina/presentation/login/ui/auth_background.dart';
import 'package:qribar_cocina/presentation/login/ui/input_decoration.dart';
import 'package:qribar_cocina/presentation/login/ui/login_container.dart';
import 'package:qribar_cocina/providers/products_provider.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 250),
              LoginContainer(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text('Login', style: Theme.of(context).textTheme.headlineMedium),
                    SizedBox(height: 30),
                    _LoginForm(),
                  ],
                ),
              ),
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'ejemplo@dominio.es',
                labelText: 'Correo electrónico',
                prefixIcon: Icons.alternate_email_rounded,
              ),
              onChanged: (value) => loginForm.email = value,
              validator: (value) {
                final regExp = RegExp(Const.emailPattern);
                return regExp.hasMatch(value ?? '') ? null : 'El correo no es correcto';
              },
              style: TextStyle(fontSize: 22),
            ),
            SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.text,
              decoration: InputDecorations.authInputDecoration(
                hintText: '*****',
                labelText: 'Contraseña',
                prefixIcon: Icons.lock_clock_outlined,
              ),
              onChanged: (value) => loginForm.password = value,
              validator: (value) {
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
              onPressed: loginForm.isLoading
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      if (!loginForm.isValidForm()) return;

                      loginForm.isLoading = true;

                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: loginForm.email,
                          password: loginForm.password,
                        );

                        String result = loginForm.email.substring(0, loginForm.email.indexOf('@'));
                        String capitalizeResult = result.toTitleCase();

                        await productsService.loadMesas(capitalizeResult);

                        Navigator.pushReplacementNamed(context, 'home');
                      } on FirebaseAuthException {
                        loginForm.isLoading = false;
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }
}


