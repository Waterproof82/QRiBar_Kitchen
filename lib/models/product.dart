import 'dart:convert';

import 'package:qribar_cocina/models/modifier.dart';

class Product {
  String categoriaProducto;
  double? costeProducto;
  String? descripcionProducto;
  String? descripcionProductoEn;
  String? descripcionProductoDe;
  bool? disponible;
  String? fotoUrl;
  String? fotoUrlVideo;
  String nombreProducto;
  String? nombreProductoOriginal;
  String? nombreProductoEn;
  String? nombreProductoDe;
  double? precioProducto;
  double? precioProducto2;
  List<String>? alergogenos;
  // String idBar;
  String? id;
  int cantidad;
  String? nota;
  bool? racion;
  num? orden;
  bool? imgVertical;
  String? nombreRacion;
  String? nombreRacionEn;
  String? nombreRacionDe;
  String? nombreRacionMedia;
  String? nombreRacionMediaEn;
  String? nombreRacionMediaDe;
  List<Complemento>? complementos;
  List<Modifier>? modifiers;

  Product({
    required this.categoriaProducto,
    this.costeProducto,
    this.descripcionProducto,
    this.descripcionProductoEn,
    this.descripcionProductoDe,
    this.disponible,
    this.fotoUrl,
    this.fotoUrlVideo,
    required this.nombreProducto,
    this.nombreProductoOriginal,
    this.nombreProductoEn,
    this.nombreProductoDe,
    this.precioProducto,
    this.precioProducto2 = 0,
    this.alergogenos,
    // required this.idBar,
    this.cantidad = 0,
    this.nota,
    this.racion,
    this.orden = 1,
    this.imgVertical,
    this.id,
    this.nombreRacion,
    this.nombreRacionEn,
    this.nombreRacionDe,
    this.nombreRacionMedia,
    this.nombreRacionMediaEn,
    this.nombreRacionMediaDe,
    this.complementos,
    this.modifiers,
  });

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        alergogenos: List<String>.from(json["alergogenos"].toList()),
        //list.map((i) => Image.fromJson(i)).toList();
        categoriaProducto: json["categoria_producto"],
        costeProducto: json["coste_producto"].toDouble(),
        disponible: json["disponible"],
        descripcionProducto: json["descripcion_producto"],
        descripcionProductoEn: json["descripcion_producto_en"],
        descripcionProductoDe: json["descripcion_producto_de"],
        fotoUrl: json["foto_url"],
        fotoUrlVideo: json["foto_url_video"],
        nombreProducto: json["nombre_producto"],
        nombreProductoEn: json["nombre_producto_en"],
        nombreProductoDe: json["nombre_producto_de"],
        precioProducto: json["precio_producto"].toDouble(),
        precioProducto2: json["precio_producto2"].toDouble(),
        nota: json["nota"],
        racion: json["racion"],
        // idBar: json["id_bar"],
        nombreRacion: json["nombre_racion"],
        nombreRacionMedia: json["nombre_racion_media"],
        nombreRacionEn: json["nombre_racion_en"],
        nombreRacionMediaEn: json["nombre_racion_media_en"],
        nombreRacionDe: json["nombre_racion_de"],
        nombreRacionMediaDe: json["nombre_racion_media_de"],
        complementos: List<Complemento>.from(json["complementos"]).toList(),
        modifiers: List<Modifier>.from(json["modifiers"]).toList(),
      );

  Map<String, dynamic> toMap() => {
        "alergogenos": alergogenos,
        "categoria_producto": categoriaProducto,
        "coste_producto": costeProducto,
        "descripcion_producto": descripcionProducto,
        "descripcion_producto_en": descripcionProductoEn,
        "descripcion_producto_de": descripcionProductoDe,
        "disponible": disponible,
        "foto_url": fotoUrl,
        "foto_url_video": fotoUrlVideo,
        "nombre_producto": nombreProducto,
        "nombre_producto_en": nombreProductoEn,
        "nombre_producto_de": nombreProductoDe,
        "precio_producto": precioProducto,
        "precio_producto2": precioProducto2,
        // "id_bar": idBar,
        "nota": nota,
        //"racion": racion,
        "nombre_racion": nombreRacion,
        "nombre_racion_media": nombreRacionMedia,
        "nombre_racion_en": nombreRacionEn,
        "nombre_racion_media_en": nombreRacionMediaEn,
        "nombre_racion_de": nombreRacionDe,
        "nombre_racion_media_de": nombreRacionMediaDe,
        "complementos": complementos,
        "modifiers": modifiers,
        "id": id,
      };

//Copiamos modelo para el selectedProduct
  Product copy() => Product(
      alergogenos: this.alergogenos,
      categoriaProducto: this.categoriaProducto,
      descripcionProducto: this.descripcionProducto,
      descripcionProductoEn: this.descripcionProductoEn,
      descripcionProductoDe: this.descripcionProductoDe,
      costeProducto: this.costeProducto,
      disponible: this.disponible,
      fotoUrl: this.fotoUrl,
      fotoUrlVideo: this.fotoUrlVideo,
      nombreProducto: this.nombreProducto,
      nombreProductoOriginal: this.nombreProductoOriginal,
      nombreProductoEn: this.nombreProductoEn,
      nombreProductoDe: this.nombreProductoDe,
      precioProducto: this.precioProducto,
      precioProducto2: this.precioProducto2 ?? 0,
      // idBar: this.idBar,
      nota: this.nota,
      //racion: this.racion,
      nombreRacion: this.nombreRacion,
      nombreRacionMedia: this.nombreRacionMedia,
      nombreRacionEn: this.nombreRacionEn,
      nombreRacionMediaEn: this.nombreRacionMediaEn,
      nombreRacionDe: this.nombreRacionDe,
      nombreRacionMediaDe: this.nombreRacionMediaDe,
      complementos: this.complementos,
      modifiers: this.modifiers,
      id: this.id);
}

class Complemento {
  Complemento({
    this.activo,
    this.incremento,
    this.nombre,
    this.id,
  });

  bool? activo;
  bool? incremento;
  String? id;
  String? nombre;

  factory Complemento.fromJson(String str) => Complemento.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Complemento.fromMap(Map<String, dynamic> json) => Complemento(
        activo: json["activo"],
        incremento: json["incremento"],
      );

  Map<String, dynamic> toMap() => {
        "activo": activo,
        "incremento": incremento,
      };
}
