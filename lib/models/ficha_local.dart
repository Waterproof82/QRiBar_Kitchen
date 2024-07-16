import 'dart:convert';
class FichaLocal {
  FichaLocal({
    this.categoriaProductos,
    this.descripcion,
    required this.lat,
    required this.long,
    required this.radio,
    this.url,
  });

  Map<String, CategoriaProducto>? categoriaProductos;
  String? descripcion;
  double lat;
  double long;
  int radio;
  String? url;

  factory FichaLocal.fromJson(String str) => FichaLocal.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FichaLocal.fromMap(Map<String, dynamic> json) => FichaLocal(
        categoriaProductos: Map.from(json["categoria_productos"]).map((k, v) => MapEntry<String, CategoriaProducto>(k, CategoriaProducto.fromMap(v))),
        descripcion: json["descripcion"],
        lat: json["lat"].toDouble(),
        long: json["long"].toDouble(),
        radio: json["radio"],
        url: json["url"],
      );

  Map<String, dynamic> toMap() => {
        "categoria_productos": Map.from(categoriaProductos!).map((k, v) => MapEntry<String, dynamic>(k, v.toMap())),
        "descripcion": descripcion,
        "lat": lat,
        "long": long,
        "radio": radio,
        "url": url,
      };
}

class CategoriaProducto {
  CategoriaProducto({required this.categoria, this.categoriaEn, this.categoriaDe, this.envio = 'barra', this.icono, this.imgVertical = false, this.orden = 1, this.id = ''});

  String categoria;
  String? categoriaEn;
  String? categoriaDe;
  String envio;
  String? icono;
  bool imgVertical;
  int orden;
  String? id;

  factory CategoriaProducto.fromJson(String str) => CategoriaProducto.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CategoriaProducto.fromMap(Map<String, dynamic> json) => CategoriaProducto(
        categoria: json["categoria"],
        categoriaEn: json["categoria_en"] ?? '',
        categoriaDe: json["categoria_de"] ?? '',
        envio: json["envio"],
        icono: json["icono"],
        imgVertical: json["img_vertical"],
        orden: json["orden"],
      );

  Map<String, dynamic> toMap() => {
        "categoria": categoria,
        "categoria_en": categoriaEn,
        "categoria_de": categoriaDe,
        "envio": envio,
        "icono": icono,
        "img_vertical": imgVertical,
        "orden": orden,
      };
}
