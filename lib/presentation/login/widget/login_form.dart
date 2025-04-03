import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qribar_cocina/data/const/app_constants.dart';
import 'package:qribar_cocina/data/const/app_sizes.dart';
import 'package:qribar_cocina/presentation/login/functions/handle_login.dart';
import 'package:qribar_cocina/presentation/login/provider/login_form_provider.dart';
import 'package:qribar_cocina/presentation/login/ui/input_decoration.dart';
import 'package:qribar_cocina/providers/products_provider.dart';

class LoginForm extends StatelessWidget {
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
                final regExp = RegExp(AppConstants.emailPattern);
                return regExp.hasMatch(value ?? '') ? null : 'El correo no es correcto';
              },
              style: TextStyle(fontSize: 22),
            ),
            Gap.h32,
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
            Gap.h32,
            MaterialButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.black26,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                child: Text(
                  loginForm.isLoading ? 'Espere...' : 'Ingresar',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              onPressed: loginForm.isLoading
                  ? null
                  : () async => handleLogin(
                        context,
                        loginForm,
                        productsService,
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
