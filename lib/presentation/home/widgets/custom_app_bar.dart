import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qribar_cocina/providers/navegacion_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(60);
  const CustomAppBar({
    super.key,
    required this.nav,
    required this.screenWidthSize,
  });

  final NavegacionProvider nav;
  final double screenWidthSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 60,
      backgroundColor: Colors.black,
      iconTheme: IconThemeData(color: Colors.white),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '· ${nav.categoriaSelected} ·',
                style: GoogleFonts.poiretOne(
                  color: Color.fromARGB(255, 240, 240, 21),
                  fontSize: (screenWidthSize > 450) ? 35 : 28,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
