class Modifier {
  final String name;
  final double increment;
  final String mainProduct;

  const Modifier({
    this.name = '',
    this.increment = 0.0,
    this.mainProduct = '',
  });

  /// Crear una copia modificada de la instancia
  Modifier copyWith({
    String? name,
    double? increment,
    String? mainProduct,
  }) {
    return Modifier(
      name: name ?? this.name,
      increment: increment ?? this.increment,
      mainProduct: mainProduct ?? this.mainProduct,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Modifier &&
          name == other.name &&
          increment == other.increment &&
          mainProduct == other.mainProduct);

  @override
  int get hashCode => Object.hash(name, increment, mainProduct);

  /// Convertir a Map (para Firebase, JSON, etc.)
  Map<String, dynamic> toMap() => {
        'name': name,
        'increment': increment,
        'mainProduct': mainProduct,
      };

  /// Alias de `toMap()` para convertir a JSON
  Map<String, dynamic> toJson() => toMap();

  /// Crear una instancia desde un Map (para Firebase, JSON, etc.)
  factory Modifier.fromMap(Map<String, dynamic> map) {
    return Modifier(
      name: map['name'] as String? ?? '',
      increment: (map['increment'] as num?)?.toDouble() ?? 0.0,
      mainProduct: map['mainProduct'] as String? ?? '',
    );
  }
}
