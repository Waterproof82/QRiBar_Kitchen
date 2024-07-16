import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qribar/models/ficha_local.dart';
import 'package:qribar/models/pedidos.dart';
import 'package:audioplayers/audioplayers.dart';

void timbre() async {
  final player = AudioPlayer();
  await player.play(AssetSource('Bell.mp3'));
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

void ordenaCategorias(List<CategoriaProducto> catProductos, List<CategoriaProducto> unicaCategoriaFiltro, List<Pedidos> itemPedidos) {
  for (var i = 0; i < catProductos.length; i++) {
    catProductos.sort((a, b) => a.orden.compareTo(b.orden));
    unicaCategoriaFiltro = catProductos.toList();
  }
  for (var i = 0; i < itemPedidos.length; i++) {
    for (var ind = 0; ind < unicaCategoriaFiltro.length; ind++) {
      if (itemPedidos[i].categoriaProducto == unicaCategoriaFiltro[ind].categoria) {
        itemPedidos[i].orden = unicaCategoriaFiltro[ind].orden;
        itemPedidos[i].envio = unicaCategoriaFiltro[ind].envio;
      }
    }
  }
}
