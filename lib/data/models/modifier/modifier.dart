import 'package:freezed_annotation/freezed_annotation.dart';

part 'modifier.freezed.dart';
part 'modifier.g.dart';

@freezed
sealed class Modifier with _$Modifier {
  const factory Modifier({
    @Default('') String name,
    @Default(0.0) double increment,
    @Default('') String mainProduct,
  }) = _Modifier;

  factory Modifier.fromJson(Map<String, dynamic> json) =>
      _$ModifierFromJson(json);
}

extension ModifierMapper on Modifier {
  static Modifier fromMap(Map<String, dynamic> map) {
    return Modifier(
      name: map['name'] as String? ?? '',
      increment: (map['increment'] as num?)?.toDouble() ?? 0.0,
      mainProduct: map['mainProduct'] as String? ?? '',
    );
  }
}
