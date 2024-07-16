import 'dart:convert';

class Pedidos {
  Pedidos({
    required this.cantidad,
    required this.categoriaProducto,
    required this.fecha,
    required this.hora,
    required this.titulo,
    this.tituloOriginal,
    required this.precioProducto,
    required this.idBar,
    required this.mesa,
    required this.mesaAbierta,
    required this.numPedido,
    required this.idProducto,
    required this.estadoLinea,
    this.nota,
    this.orden = 1,
    this.envio = 'barra',
    this.fechaHora,
    this.id,
    this.enMarcha,
    this.notaExtra,
  });

  int cantidad;
  String categoriaProducto;
  String fecha;
  String hora;
  String idBar;
  String mesa;
  bool mesaAbierta;
  String titulo;
  double precioProducto;
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

  factory Pedidos.fromJson(String str) => Pedidos.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Pedidos.fromMap(Map<String, dynamic> json) => Pedidos(
      cantidad: json["cantidad"],
      categoriaProducto: json["categoria_producto"],
      fecha: json["fecha"],
      hora: json["hora"],
      idBar: json["id_bar"],
      mesa: json["mesa"],
      mesaAbierta: json["mesaAbierta"],
      titulo: json["titulo"],
      tituloOriginal: json["titulo_original"],
      precioProducto: json["precio_producto"].toDouble(),
      numPedido: json["numPedido"],
      idProducto: json["idProducto"],
      nota: json["nota"],
      estadoLinea: json["estado_linea"] ?? '',
      id: json["id"]);

  Map<String, dynamic> toMap() => {
        "cantidad": cantidad,
        "categoria_producto": categoriaProducto,
        "fecha": fecha,
        "hora": hora,
        "id_bar": idBar,
        "mesa": mesa,
        "mesaAbierta": mesaAbierta,
        "titulo": titulo,
        "titulo_original": tituloOriginal,
        "precio_producto": precioProducto,
        "numPedido": numPedido,
        "idProducto": idProducto,
        "nota": nota,
        "estado_linea": estadoLinea,
        "id": id,
      };

  Pedidos copy() => Pedidos(
      cantidad: this.cantidad,
      categoriaProducto: this.categoriaProducto,
      fecha: this.fecha,
      hora: this.hora,
      fechaHora: this.fechaHora,
      idBar: this.idBar,
      titulo: this.titulo,
      tituloOriginal: this.tituloOriginal,
      precioProducto: this.precioProducto,
      mesa: this.mesa,
      mesaAbierta: this.mesaAbierta,
      numPedido: this.numPedido,
      nota: this.nota,
      estadoLinea: this.estadoLinea,
      id: this.id,
      enMarcha: this.enMarcha,
      idProducto: this.idProducto);
}
