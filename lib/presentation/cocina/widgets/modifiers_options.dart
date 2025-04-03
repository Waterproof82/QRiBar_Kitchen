import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qribar_cocina/data/models/modifier.dart';
import 'package:qribar_cocina/services/functions.dart';

class ModifiersOptions extends StatelessWidget {
  const ModifiersOptions({
    Key? key,
    required this.ancho,
    required this.modifiers,
    this.mainModifierName,
    this.tipo,
  }) : super(key: key);

  final double ancho;
  final List<Modifier> modifiers;
  final String? mainModifierName;
  final int? tipo;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: modifiers.map((opcion) {
        bool showModifiers = opcion.mainProduct == '' || (mainModifierName == null || obtenerNombreProducto(context, opcion.mainProduct, true) == mainModifierName);

        return showModifiers
            ? Container(
                width: ancho,
                height: 30,
                padding: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 5,
                      spreadRadius: -5,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: const Icon(
                          Icons.navigate_next,
                          size: 20,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Text(
                              opcion.name,
                              maxLines: 1,
                              textAlign: TextAlign.left,
                              style: GoogleFonts.notoSans(
                                color: Colors.black,
                                fontSize: (ancho > 450) ? 24 : 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Incremento al final en negrita
                  ],
                ),
              )
            : SizedBox.shrink();
      }).toList(),
    );
  }
}
