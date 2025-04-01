import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qribar_cocina/providers/products_provider.dart';
import 'package:qribar_cocina/services/audio_manager.dart';

final AudioManager _audioManager = AudioManager();

void timbre() async {
  try {
    await _audioManager.play('Bell.mp3');
  } catch (e) {
    print(e);
  }
}

Future<void> salirApp({bool? animated}) async {
  await SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop', animated);
}

Future<bool> onBackPressed(BuildContext context) async {
  return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Container(
          child: new AlertDialog(
            alignment: Alignment.center,
            title: new Text(
              'Salir de la Carta',
              textAlign: TextAlign.center,
            ),
            content: new Text(
              '¿Quieres cerrar la aplicación?',
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  new MaterialButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    disabledColor: Colors.grey,
                    elevation: 1,
                    color: Colors.black26,
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                      child: Text('Sí', style: TextStyle(color: Color.fromARGB(255, 255, 0, 0), fontSize: 18)),
                    ),
                  ),
                  new MaterialButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    disabledColor: Colors.grey,
                    elevation: 1,
                    color: Colors.black26,
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                      child: Text('No', style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ) ??
      false;
}

String obtenerNombreProducto(BuildContext context, String idProducto, bool racion) {
  final itemElemento = Provider.of<ProductsService>(context, listen: false).products;

  final producto = itemElemento.firstWhere((item) => item.id == idProducto);

  String nombreProducto = racion ? producto.nombreProducto : '${producto.nombreProducto} (${producto.nombreRacionMedia})';

  return nombreProducto;
}

String obtenerCategoriaProducto(ProductsService productsService, String idProducto) {
  final itemElemento = productsService.products;

  final producto = itemElemento.firstWhere((item) => item.id == idProducto);

  return producto.categoriaProducto;
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: capitalize(newValue.text),
      selection: newValue.selection,
    );
  }
}

String capitalize(String value) {
  if (value.trim().isEmpty) return "";
  return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
}

Future<String?> obtenerEnvioPorProducto(ProductsService productService, String idProd) async {
  final categoriaMap = {for (var categoria in productService.categoriasProdLocal) categoria.categoria: categoria};

  final categoria = categoriaMap[obtenerCategoriaProducto(productService, idProd)];
  return categoria?.envio;
}
