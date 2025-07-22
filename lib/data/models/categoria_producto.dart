import 'dart:convert';

class CategoriaProducto {
  CategoriaProducto({
    required this.categoria,
    this.categoriaEn,
    this.categoriaDe,
    this.envio = 'barra',
    this.icono,
    this.imgVertical = false,
    this.orden = 1,
    this.id = '',
  });

  String categoria;
  String? categoriaEn;
  String? categoriaDe;
  String envio;
  String? icono;
  bool imgVertical;
  int orden;
  String? id;

  factory CategoriaProducto.fromJson(String str) =>
      CategoriaProducto.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CategoriaProducto.fromMap(Map<String, dynamic> json) =>
      CategoriaProducto(
        categoria: json['categoria'],
        categoriaEn: json['categoria_en'] ?? '',
        categoriaDe: json['categoria_de'] ?? '',
        envio: json['envio'],
        icono: json['icono'],
        imgVertical: json['img_vertical'],
        orden: json['orden'],
      );

  Map<String, dynamic> toMap() => {
    'categoria': categoria,
    'categoria_en': categoriaEn,
    'categoria_de': categoriaDe,
    'envio': envio,
    'icono': icono,
    'img_vertical': imgVertical,
    'orden': orden,
  };
}
