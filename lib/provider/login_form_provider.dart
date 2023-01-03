import 'package:flutter/material.dart';

class LoginFormProvider extends ChangeNotifier {
//Hacemos referencias a Widgets específicos
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  String email = '';
  String password = '';

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm() {
    //print(formKey.currentState?.validate());
    //print('$email - $password');
    //Puede ser nulo y puede regresar bool true/false
    return formKey.currentState?.validate() ?? false;
  }
}
