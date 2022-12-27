import 'dart:convert';

class GestionLocal {
  GestionLocal({this.qrLink, this.estado, this.hora, this.horaUltimaActiva, this.horaUltimoPago, this.horaUltimoPedido, this.personas, this.sala, this.nombre});

  String? estado;
  String? hora;
  String? horaUltimaActiva;
  String? horaUltimoPago;
  String? horaUltimoPedido;
  int? personas;
  String? sala;
  String? nombre;
  String? qrLink;

  factory GestionLocal.fromJson(String str) => GestionLocal.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GestionLocal.fromMap(Map<String, dynamic> json) => GestionLocal(
        estado: json["estado"],
        hora: json["hora"],
        horaUltimaActiva: json["horaUltimaActiva"],
        horaUltimoPago: json["horaUltimoPago"],
        horaUltimoPedido: json["horaUltimoPedido"],
        personas: json["personas"],
        sala: json["sala"],
        nombre: json["nombre"],
        qrLink: json["qr_link"],
      );

  Map<String, dynamic> toMap() => {
        "estado": estado,
        "hora": hora,
        "horaUltimaActiva": horaUltimaActiva,
        "horaUltimoPago": horaUltimoPago,
        "horaUltimoPedido": horaUltimoPedido,
        "personas": personas,
        "sala": sala,
        "nombre": nombre,
        "qr_link": qrLink,
      };
  GestionLocal copy() => GestionLocal(
      hora: this.hora,
      horaUltimaActiva: this.horaUltimaActiva,
      horaUltimoPago: this.horaUltimoPago,
      horaUltimoPedido: this.horaUltimoPedido,
      estado: this.estado,
      sala: this.sala,
      personas: this.personas,
      nombre: this.nombre,
      qrLink: this.qrLink);
}
