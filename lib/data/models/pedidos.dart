import 'dart:convert';

import 'package:qribar_cocina/data/models/modifier.dart';

class Pedidos {
  Pedidos({
    required this.cantidad,
    this.categoriaProducto,
    required this.fecha,
    required this.hora,
    this.titulo,
    this.tituloOriginal,
    this.precioProducto,
    required this.mesa,
    required this.numPedido,
    required this.idProducto,
    this.estadoLinea,
    this.nota,
    this.orden = 1,
    this.envio = 'barra',
    this.fechaHora,
    this.id,
    this.enMarcha,
    this.notaExtra,
    this.modifiers,
    this.racion,
  });

  int cantidad;
  String? categoriaProducto;
  String fecha;
  String hora;
  String mesa;
  String? titulo;
  double? precioProducto;
  int numPedido;
  String? idProducto;
  String? nota;
  num orden;
  String? envio;
  String? estadoLinea;
  String? id;
  String? fechaHora;
  String? tituloOriginal;
  bool? enMarcha;
  List<String>? notaExtra;
  List<Modifier>? modifiers;
  bool? racion;

  factory Pedidos.fromJson(String str) => Pedidos.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Pedidos.fromMap(Map<String, dynamic> json) => Pedidos(
      cantidad: json["cantidad"],
      categoriaProducto: json["categoria_producto"],
      fecha: json["fecha"],
      hora: json["hora"],
      mesa: json["mesa"],
      titulo: json["titulo"],
      tituloOriginal: json["titulo_original"],
      precioProducto: json["precio_producto"].toDouble(),
      numPedido: json["numPedido"],
      idProducto: json["idProducto"],
      nota: json["nota"],
      estadoLinea: json["estado_linea"] ?? '',
      racion: json['racion'],
      modifiers: json['modifiers'] != null ? List<Modifier>.from(json["modifiers"].map((x) => Modifier.fromMap(x))) : [],
      id: json["id"]);

  Map<String, dynamic> toMap() => {
        "cantidad": cantidad,
        "categoria_producto": categoriaProducto,
        "fecha": fecha,
        "hora": hora,
        "mesa": mesa,
        "titulo": titulo,
        "titulo_original": tituloOriginal,
        "precio_producto": precioProducto,
        "numPedido": numPedido,
        "idProducto": idProducto,
        "nota": nota,
        "estado_linea": estadoLinea,
        'racion': racion,
        "modifiers": modifiers,
        "id": id,
      };

  Pedidos copy() => Pedidos(
        cantidad: this.cantidad,
        categoriaProducto: this.categoriaProducto,
        fecha: this.fecha,
        hora: this.hora,
        fechaHora: this.fechaHora,
        titulo: this.titulo,
        tituloOriginal: this.tituloOriginal,
        precioProducto: this.precioProducto,
        mesa: this.mesa,
        numPedido: this.numPedido,
        nota: this.nota,
        estadoLinea: this.estadoLinea,
        id: this.id,
        enMarcha: this.enMarcha,
        racion: racion,
        modifiers: this.modifiers,
        idProducto: this.idProducto,
      );
}
