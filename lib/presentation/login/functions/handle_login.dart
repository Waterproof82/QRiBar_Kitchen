import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qribar_cocina/data/extensions/string_extension.dart';
import 'package:qribar_cocina/presentation/login/provider/login_form_provider.dart';
import 'package:qribar_cocina/providers/products_provider.dart';

Future<void> handleLogin(
  BuildContext context,
  LoginFormProvider loginForm,
  ProductsService productsService,
) async {
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
  } on FirebaseAuthException catch (e) {
    print('Error de autenticación: $e');
  } finally {
    loginForm.isLoading = false;
  }
}
