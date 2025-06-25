import 'package:flutter/widgets.dart';
import 'package:qribar_cocina/app/enums/selection_type_enum.dart';
import 'package:qribar_cocina/app/l10n/l10n.dart';

extension SelectionTypeEnumL10n on SelectionTypeEnum {
  String localizedLabel(BuildContext context) {
    switch (this) {
      case SelectionTypeEnum.pedidosScreen:
        return context.l10n.cocinaPedidosPorMesa;
      case SelectionTypeEnum.generalScreen:
        return context.l10n.cocinaEstadoPedidos;
    }
  }
}
