class Modifier {
  final String name;
  final double increment;

  Modifier({
    this.name = '',
    this.increment = 0.0,
  });

  /// Método para crear una copia con posibilidad de modificar cualquier atributo
  Modifier copyWith({
    String? name,
    double? increment,
  }) {
    return Modifier(
      name: name ?? this.name,
      increment: increment ?? this.increment,
    );
  }

  // Método para comparar si dos modificadores son iguales
  bool isEqual(Modifier other) {
    return name == other.name && increment == other.increment;
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is Modifier && runtimeType == other.runtimeType && name == other.name && increment == other.increment;

  @override
  int get hashCode => name.hashCode ^ increment.hashCode;

  /// Método para convertir la instancia en un Map (útil para Firebase)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'increment': increment,
    };
  }

  /// Método para crear una instancia desde un Map (útil para Firebase)
  factory Modifier.fromMap(Map<String, dynamic> map) {
    return Modifier(
      name: map['name'] ?? '',
      increment: (map['increment'] ?? 0.0).toDouble(),
    );
  }
}
