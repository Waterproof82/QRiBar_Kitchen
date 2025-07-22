import 'package:flutter/widgets.dart';
import 'package:qribar_cocina/app/enums/selection_type_enum.dart';
import 'package:qribar_cocina/app/l10n/app_localizations.dart';

extension SelectionTypeEnumL10n on SelectionTypeEnum {
  String localizedLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    switch (this) {
      case SelectionTypeEnum.pedidosScreen:
        return l10n.cocinaPedidosPorMesa;
      case SelectionTypeEnum.generalScreen:
        return l10n.cocinaEstadoPedidos;
    }
  }
}
