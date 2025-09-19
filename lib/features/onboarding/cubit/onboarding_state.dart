import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:qribar_cocina/app/types/repository_error.dart';

part 'onboarding_state.freezed.dart';

@freezed
sealed class OnboardingState with _$OnboardingState {
  /// Initial state, starts on page 0
  const factory OnboardingState.initial({@Default(0) int page}) = _Initial;

  /// Normal page navigation
  //const factory OnboardingState.pageChanged(int page) = _PageChanged;

  const factory OnboardingState.error({required RepositoryError error}) =
      _Error;
}
