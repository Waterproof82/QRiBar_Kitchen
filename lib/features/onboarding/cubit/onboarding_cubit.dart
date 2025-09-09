import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qribar_cocina/features/onboarding/domain/usecases/first_time_usecase.dart';

/// Maneja el estado del Onboarding y garantiza consistencia entre memoria y almacenamiento local.
/// - Usa caché en memoria para evitar lecturas repetidas y problemas de sincronización.
/// - Solo permite marcar `setFirstTime()` una vez y actualiza la caché inmediatamente.
class OnboardingCubit extends Cubit<int> {
  OnboardingCubit({required FirstTimeUseCase firstTimeUseCase})
    : _firstTimeUseCase = firstTimeUseCase,
      super(0);

  final FirstTimeUseCase _firstTimeUseCase;

  bool?
  _cachedFirstTime; // cache en memoria para evitar lecturas inconsistentes

  /// Cambia de página en el Onboarding
  void goTo(int number) => emit(number);

  /// Marca que el Onboarding ya fue mostrado (se guarda en memoria y disco).
  Future<void> setFirstTime() async {
    // Solo actualizamos si aún no está seteado en memoria
    if (_cachedFirstTime == null || _cachedFirstTime == true) {
      await _firstTimeUseCase.setFirstTime();
      _cachedFirstTime = false;
    }
  }

  /// Devuelve si es la primera vez que el usuario entra a la app.
  /// Usa caché en memoria si ya se consultó antes.
  Future<bool> isFirstTime() async {
    if (_cachedFirstTime != null) return _cachedFirstTime!;
    final value = await _firstTimeUseCase.isFirstTime();
    _cachedFirstTime = value;
    return value;
  }

  /// Método auxiliar (opcional) para resetear manualmente el flag → útil en testing.
  Future<void> resetFirstTime() async {
    _cachedFirstTime = true;
  }
}
