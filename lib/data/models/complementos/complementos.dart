import 'dart:convert';

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
        activo: json['activo'],
        incremento: json['incremento'],
      );

  Map<String, dynamic> toMap() => {
        'activo': activo,
        'incremento': incremento,
      };
}
