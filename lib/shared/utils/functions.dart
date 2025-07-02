import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qribar_cocina/app/extensions/l10n.dart';
import 'package:qribar_cocina/data/models/categoria_producto.dart';
import 'package:qribar_cocina/data/models/product.dart';
import 'package:qribar_cocina/features/app/bloc/listener_bloc.dart';
import 'package:qribar_cocina/shared/utils/audio_manager.dart';

final AudioManager _audioManager = AudioManager();

void timbre() async {
  try {
    await _audioManager.play('sounds/bell.mp3');
  } catch (e) {
    print(e);
  }
}

Future<void> salirApp({bool? animated}) async {
  await SystemChannels.platform.invokeMethod<void>(
    'SystemNavigator.pop',
    animated,
  );
}

Future<bool> onBackPressed(BuildContext context) async {
  final listenerBloc = context.read<ListenerBloc>();

  return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Container(
          child: AlertDialog(
            alignment: Alignment.center,
            title: Text(context.l10n.exitMenu, textAlign: TextAlign.center),
            content: Text(context.l10n.closeApp, textAlign: TextAlign.center),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    disabledColor: Colors.grey,
                    elevation: 1,
                    color: Colors.black26,
                    onPressed: () async {
                      await listenerBloc.close();
                      SystemNavigator.pop();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 8,
                      ),
                      child: Text(
                        context.l10n.yes,
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 0, 0),
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    disabledColor: Colors.grey,
                    elevation: 1,
                    color: Colors.black26,
                    onPressed: () {
                      context.pop(false);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 8,
                      ),
                      child: Text(
                        context.l10n.no,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
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

String obtenerNombreProducto(
  List<Product> itemElemento,
  String idProducto,
  bool racion,
) {
  final producto = itemElemento.firstWhere((item) => item.id == idProducto);

  String nombreProducto = racion
      ? producto.nombreProducto
      : '${producto.nombreProducto} (${(producto.nombreRacionMedia) ?? 'Media Ración'})';

  return nombreProducto;
}

String obtenerCategoriaProducto(List<Product> product, String idProducto) {
  try {
    final producto = product.firstWhere(
      (item) => item.id == idProducto,
      orElse: () => Product(
        id: '',
        categoriaProducto: 'Categoría no encontrada',
        nombreProducto: '',
      ),
    );

    return producto.categoriaProducto;
  } catch (e) {
    return 'Categoría no encontrada';
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
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

Future<String?> obtenerEnvioPorProducto(
  List<CategoriaProducto> categoriasProdLocal,
  String idProd,
  List<Product> product,
) async {
  final categoriaMap = {
    for (var categoria in categoriasProdLocal) categoria.categoria: categoria,
  };

  final categoria = categoriaMap[obtenerCategoriaProducto(product, idProd)];
  return categoria?.envio;
}
