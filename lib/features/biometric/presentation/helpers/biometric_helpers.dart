import 'package:flutter/material.dart';
import 'package:qribar_cocina/app/enums/snack_bar_enum.dart';
import 'package:qribar_cocina/app/l10n/app_localizations.dart';
import 'package:qribar_cocina/shared/utils/custom_snack_bar.dart';

void showBiometricsEnabledSnackBar(
  BuildContext context,
  AppLocalizations l10n,
) {
  CustomSnackBar.show(
    l10n.biometricsEnabledMessage,
    type: SnackBarTypeEnum.success,
  );
}
