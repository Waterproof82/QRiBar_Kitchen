import 'dart:convert';

class Usuarios {
  Usuarios({
    required this.mesa,
    required this.uid,
  });

  String mesa;
  String uid;

  factory Usuarios.fromJson(String str) => Usuarios.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Usuarios.fromMap(Map<String, dynamic> json) => Usuarios(
        mesa: json["mesa"],
        uid: json["uid"],
      );

  Map<String, dynamic> toMap() => {
        "mesa": mesa,
        "uid": uid,
      };

  Usuarios copy() => Usuarios(
        mesa: this.mesa,
        uid: this.uid,
      );
}
