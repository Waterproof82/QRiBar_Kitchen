import 'dart:convert';

class SalaEstado {
  SalaEstado({
    this.cantidad,
    this.categoria,
    this.estado,
    this.hora,
    this.horaUltimaActiva,
    this.fecha,
    this.idBar,
    this.mesa,
    this.numPedido,
    this.sala,
    this.titulo,
    this.id,
    this.personas,
    this.dibujo,
    this.horaUltimoPedido,
    this.horaUltimoPago,
    this.callCamarero,
    this.callPago,
    this.nombre,
    this.positionMap,
    this.qrLink,
  });

  int? cantidad;
  String? categoria;
  String? estado;
  String? hora;
  String? horaUltimaActiva;
  String? fecha;
  int? numPedido;
  String? idBar;
  String? mesa;
  String? sala;
  String? titulo;
  int? personas;
  String? dibujo;
  String? id;
  String? horaUltimoPedido;
  String? horaUltimoPago;
  bool? callCamarero;
  bool? callPago;
  String? nombre;
  int? positionMap;
  String? qrLink;

  factory SalaEstado.fromJson(String str) => SalaEstado.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SalaEstado.fromMap(Map<String, dynamic> json) => SalaEstado(
        cantidad: json['cantidad'],
        categoria: json['categoria'],
        fecha: json['fecha'],
        hora: json['hora'],
        horaUltimaActiva: json['horaUltimaActiva'],
        titulo: json['titulo'],
        numPedido: json['numPedido'],
        estado: json['estado'],
        sala: json['sala'],
        idBar: json['id_bar'],
        mesa: json['mesa'],
        personas: json['personas'],
        horaUltimoPedido: json['horaUltimoPedido'],
        horaUltimoPago: json['horaUltimoPago'],
        callCamarero: json['callCamarero'],
        callPago: json['callPago'],
        nombre: json['nombre'],
        positionMap: json['positionMap'],
        qrLink: json['qr_link'],
      );

  Map<String, dynamic> toMap() => {
        'cantidad': cantidad,
        'categoria_producto': categoria,
        'fecha': fecha,
        'hora': hora,
        'horaUltimaActiva': horaUltimaActiva,
        'titulo': titulo,
        'numPedido': numPedido,
        'id': id,
        'id_bar': idBar,
        'mesa': mesa,
        'personas': personas,
        'horaUltimoPedido': horaUltimoPedido,
        'horaUltimoPago': horaUltimoPago,
        'callCamarero': callCamarero,
        'callPago': callPago,
        'nombre': nombre,
        'positionMap': positionMap,
        'qr_link': qrLink,
      };

  SalaEstado copy() => SalaEstado(
      cantidad: cantidad,
      categoria: categoria,
      fecha: fecha,
      hora: hora,
      horaUltimaActiva: horaUltimaActiva,
      titulo: titulo,
      numPedido: numPedido,
      id: id,
      estado: estado,
      sala: sala,
      idBar: idBar,
      mesa: mesa,
      personas: personas,
      horaUltimoPedido: horaUltimoPedido,
      horaUltimoPago: horaUltimoPago,
      callCamarero: callCamarero,
      callPago: callPago,
      nombre: nombre,
      positionMap: positionMap,
      qrLink: qrLink);
}
