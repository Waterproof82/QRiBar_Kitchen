import 'package:qribar_cocina/data/data_sources/local/localization_local_datasource_contract.dart';
import 'package:qribar_cocina/app/localization/cubit/language_cubit.dart';

/// A final class that provides the concrete implementation for [LanguageCubit].
///
/// This class extends the abstract [LanguageCubit] and simply passes
/// its required dependencies to the super constructor.
final class LanguageCubitImpl extends LanguageCubit {
  /// Creates a constant instance of [LanguageCubitImpl].
  ///
  /// Delegates the injection of [localization] to the superclass constructor.
  LanguageCubitImpl(LocalizationLocalDataSourceContract localization)
    : super(localization);
}
