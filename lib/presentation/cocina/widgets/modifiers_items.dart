import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qribar_cocina/data/models/modifier.dart';

class ModifiersItems extends StatelessWidget {
  const ModifiersItems({
    Key? key,
    required this.ancho,
    required this.modifiers,
  }) : super(key: key);

  final double ancho;
  final List<Modifier> modifiers;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(modifiers.length, (index) {
        final opcion = modifiers[index];
        return Container(
          width: ancho * 0.95,
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
                        style: GoogleFonts.poiretOne(color: Colors.black, fontSize: (ancho > 450) ? 22 : 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
