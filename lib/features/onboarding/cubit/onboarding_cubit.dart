import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qribar_cocina/app/types/errors/network_error.dart';
import 'package:qribar_cocina/app/types/repository_error.dart';
import 'package:qribar_cocina/features/onboarding/cubit/onboarding_state.dart';
import 'package:qribar_cocina/features/onboarding/domain/usecases/first_time_usecase.dart';

/// Handles onboarding state and ensures consistency between memory and local storage.
/// - Uses in-memory cache to avoid repeated reads.
/// - Only allows setting `setFirstTime()` once and updates cache immediately.
class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit({required FirstTimeUseCase firstTimeUseCase})
    : _firstTimeUseCase = firstTimeUseCase,
      super(const OnboardingState.initial());

  final FirstTimeUseCase _firstTimeUseCase;
  bool? _cachedFirstTime; // memory cache to avoid inconsistent reads

  /// Navigate to a specific onboarding page
  //void goTo(int number) => emit(OnboardingState.pageChanged(number));

  /// Marks onboarding as shown (updates memory + disk).
  Future<void> setFirstTime() async {
    try {
      if (_cachedFirstTime == null || _cachedFirstTime == true) {
        await _firstTimeUseCase.setFirstTime();
        _cachedFirstTime = false;
      }
    } catch (e) {
      emit(
        OnboardingState.error(
          error: RepositoryError.fromDataSourceError(
            NetworkError.fromException(e),
          ),
        ),
      );
    }
  }

  /// Returns whether it is the first app entry.
  Future<bool> isFirstTime() async {
    if (_cachedFirstTime != null) return _cachedFirstTime!;
    try {
      final value = await _firstTimeUseCase.isFirstTime();
      _cachedFirstTime = value;
      return value;
    } catch (e) {
      emit(
        OnboardingState.error(
          error: RepositoryError.fromDataSourceError(
            NetworkError.fromException(e),
          ),
        ),
      );
      return true; // fallback
    }
  }

  /// Resets onboarding flag manually (for testing).
  Future<void> resetFirstTime() async {
    _cachedFirstTime = true;
  }
}
