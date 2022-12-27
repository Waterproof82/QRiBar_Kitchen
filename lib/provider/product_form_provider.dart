import 'package:flutter/material.dart';
import 'package:qribar/models/models.dart';

class ProductFormProvider extends ChangeNotifier {
  //Mantenemos la referencia del formulario globalmente
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  Product product;

  //Constructor de la copia
  ProductFormProvider(this.product);

  updateAvailability(bool value) {
    //print(value);
    this.product.disponible = value;
    notifyListeners();
  }

  bool isValidForm() {
    print(product.nombreProducto);
    print(product.precioProducto);

    return formKey.currentState?.validate() ?? false;
  }
}
