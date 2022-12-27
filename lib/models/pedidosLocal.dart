import 'dart:convert';

class PedidosLocal {
  PedidosLocal(
      {this.cantidad,
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
      this.qrLink});

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

  factory PedidosLocal.fromJson(String str) => PedidosLocal.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PedidosLocal.fromMap(Map<String, dynamic> json) => PedidosLocal(
        cantidad: json["cantidad"],
        categoria: json["categoria"],
        fecha: json["fecha"],
        hora: json["hora"],
        horaUltimaActiva: json["horaUltimaActiva"],
        titulo: json["titulo"],
        numPedido: json["numPedido"],
        estado: json["estado"],
        sala: json["sala"],
        idBar: json["id_bar"],
        mesa: json["mesa"],
        personas: json["personas"],
        horaUltimoPedido: json["horaUltimoPedido"],
        horaUltimoPago: json["horaUltimoPago"],
        callCamarero: json["callCamarero"],
        callPago: json["callPago"],
        nombre: json["nombre"],
        positionMap: json["positionMap"],
        qrLink: json["qr_link"],
      );

  Map<String, dynamic> toMap() => {
        "cantidad": cantidad,
        "categoria_producto": categoria,
        "fecha": fecha,
        "hora": hora,
        "horaUltimaActiva": horaUltimaActiva,
        "titulo": titulo,
        "numPedido": numPedido,
        "id": id,
        "id_bar": idBar,
        "mesa": mesa,
        "personas": personas,
        "horaUltimoPedido": horaUltimoPedido,
        "horaUltimoPago": horaUltimoPago,
        "callCamarero": callCamarero,
        "callPago": callPago,
        "nombre": nombre,
        "positionMap": positionMap,
        "qr_link": qrLink,
      };

  PedidosLocal copy() => PedidosLocal(
      cantidad: this.cantidad,
      categoria: this.categoria,
      fecha: this.fecha,
      hora: this.hora,
      horaUltimaActiva: this.horaUltimaActiva,
      titulo: this.titulo,
      numPedido: this.numPedido,
      id: this.id,
      estado: this.estado,
      sala: this.sala,
      idBar: this.idBar,
      mesa: this.mesa,
      personas: this.personas,
      horaUltimoPedido: this.horaUltimoPedido,
      horaUltimoPago: this.horaUltimoPago,
      callCamarero: this.callCamarero,
      callPago: this.callPago,
      nombre: this.nombre,
      positionMap: this.positionMap,
      qrLink: this.qrLink);
}
