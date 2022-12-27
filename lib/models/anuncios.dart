// To parse this JSON data, do
//
//     final anunciosLocal = anunciosLocalFromMap(jsonString);

import 'dart:convert';

class AnunciosLocal {
  AnunciosLocal({
    required this.fichaAnuncio,
    this.historialAnuncios,
  });

  FichaAnuncio fichaAnuncio;
  HistorialAnuncios? historialAnuncios;

  factory AnunciosLocal.fromJson(String str) => AnunciosLocal.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AnunciosLocal.fromMap(Map<String, dynamic> json) => AnunciosLocal(
        fichaAnuncio: FichaAnuncio.fromMap(json["ficha_anuncio"]),
        historialAnuncios: HistorialAnuncios.fromMap(json["historial_anuncios"]),
      );

  Map<String, dynamic> toMap() => {
        "ficha_anuncio": fichaAnuncio.toMap(),
        "historial_anuncios": historialAnuncios?.toMap(),
      };
}

class FichaAnuncio {
  FichaAnuncio({
    this.categoria,
    this.contador,
    this.fotoUrl,
    this.limiteAnuncios,
    this.nuevoAnuncio,
  });

  String? categoria;
  int? contador;
  String? fotoUrl;
  int? limiteAnuncios;
  String? nuevoAnuncio;

  factory FichaAnuncio.fromJson(String str) => FichaAnuncio.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FichaAnuncio.fromMap(Map<String, dynamic> json) => FichaAnuncio(
        categoria: json["categoria"],
        contador: json["contador"],
        fotoUrl: json["foto_url"],
        limiteAnuncios: json["limite_anuncios"],
        nuevoAnuncio: json["nuevo_anuncio"],
      );

  Map<String, dynamic> toMap() => {
        "categoria": categoria,
        "contador": contador,
        "foto_url": fotoUrl,
        "limite_anuncios": limiteAnuncios,
        "nuevo_anuncio": nuevoAnuncio,
      };
}

class HistorialAnuncios {
  HistorialAnuncios({
    this.fecha,
    this.hora,
    this.nombreProducto,
  });

  String? fecha;
  int? hora;
  String? nombreProducto;

  factory HistorialAnuncios.fromJson(String str) => HistorialAnuncios.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory HistorialAnuncios.fromMap(Map<String, dynamic> json) => HistorialAnuncios(
        fecha: json["fecha"],
        hora: json["hora"],
        nombreProducto: json["nombre_prodcuto"],
      );

  Map<String, dynamic> toMap() => {
        "fecha": fecha,
        "hora": hora,
        "nombre_prodcuto": nombreProducto,
      };
}
