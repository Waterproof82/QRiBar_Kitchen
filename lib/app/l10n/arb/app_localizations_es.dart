// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'QR iBar Cocina';

  @override
  String get skip => 'Saltar';

  @override
  String get next => 'Siguiente';

  @override
  String get start => 'Empezar';

  @override
  String get welcomeToCivilProtection =>
      '¡Te damos la bienvenida a tu App de Protección Civil!';

  @override
  String get learnAboutDifferentRisks =>
      'Infórmate sobre los diferentes riesgos y protégete a ti y a tus seres queridos. ¡Empecemos!';

  @override
  String get alertsTailoredToYourWorld => 'Alertas adaptadas a tu mundo';

  @override
  String get withCivilProtectionYouCan =>
      'Con Protección Civil, puedes recibir Alertas sobre los diferentes riesgos en las zonas que te interesan.';

  @override
  String get aShieldAgainstTheElements => '¡Un escudo ante los elementos!';

  @override
  String get fromVitalLinksToExpertAdvice =>
      'Desde enlaces vitales hasta consejos expertos, estamos aquí para fortalecer tu preparación ante cualquier fenómeno.';

  @override
  String get yourAlerts => 'Tus alertas';

  @override
  String get canActivateAlerts =>
      'Puedes activar las notificaciones para los lugares en los que te gustaría recibir las alertas';

  @override
  String get noActiveAlerts =>
      'No tienes las alertas de ningún lugar activadas';

  @override
  String get noActiveAlertsInfo =>
      'Podrás añadir los lugares sobre los que te gustaría estar informado.';

  @override
  String get activeAlerts => '¡Estás al día de todo!';

  @override
  String get alertDetail => 'Detalle de la alerta';

  @override
  String get alertModalAreYouSure => '¿Estás seguro?';

  @override
  String alertModalAreYouSureSubtitle(String address) {
    return 'Si eliminas la suscripción a $address, no recibirás más alertas en esta zona. Para volver a activar este lugar, haz click en el botón \"+\" para añadir una nueva suscripción.';
  }

  @override
  String get alertModalDeleteButton => 'Eliminar suscripción';

  @override
  String get alertSuscriptionTrashButton => 'Eliminar alerta de';

  @override
  String get activeAlertsInfo =>
      'Asegúrate de haber activado las alertas en los lugares donde te gustaría ser notificado.';

  @override
  String get subscribedPlaces => 'Lugares suscritos';

  @override
  String get activeAlert => 'Activa';

  @override
  String get inactiveAlert => 'Finalizada';

  @override
  String get endedAlerts => 'Alertas finalizadas';

  @override
  String get alertNow => 'Ahora';

  @override
  String alertMinutes(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: 'Hace $value minutos',
      one: 'Hace $value minuto',
    );
    return '$_temp0';
  }

  @override
  String alertHours(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: 'Hace $value horas',
      one: 'Hace $value hora',
    );
    return '$_temp0';
  }

  @override
  String alertDays(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: 'Hace $value días',
      one: 'Hace $value día',
    );
    return '$_temp0';
  }

  @override
  String alertMonths(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: 'Hace $value meses',
      one: 'Hace $value mes',
    );
    return '$_temp0';
  }

  @override
  String alertYears(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: 'Hace $value años',
      one: 'Hace $value año',
    );
    return '$_temp0';
  }

  @override
  String endedDateAlert(String value) {
    return 'Fecha final de la alerta: $value';
  }

  @override
  String get youHave => 'Tienes ';

  @override
  String activeNumAlerts(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value alertas',
      one: '$value alerta',
    );
    return '$_temp0 ';
  }

  @override
  String alertsNum(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: 'activas',
      one: 'activa',
    );
    return '$_temp0';
  }

  @override
  String get accept => 'Aceptar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get iHaveReadPrivacy =>
      'He leído y estoy de acuerdo con la Política de Privacidad';

  @override
  String get iHaveReadTerms =>
      'He leído y estoy de acuerdo con el Aviso Legal y los Términos y Condiciones de Uso';

  @override
  String get acceptanceOfConditions => 'Aceptación de condiciones';

  @override
  String get civilProtectionLogo => 'Logo de Protección Civil';

  @override
  String get myProfile => 'Mi perfil';

  @override
  String get settings => 'Ajustes';

  @override
  String get configuration => 'Configuración';

  @override
  String get language => 'Idioma';

  @override
  String get help => 'Ayuda';

  @override
  String get frequentAskedQuestions => 'Preguntas Frecuentes';

  @override
  String get support => 'Soporte';

  @override
  String get generalInformation => 'Información General';

  @override
  String get accesibilityStatement => 'Declaración de Accesibilidad';

  @override
  String get legalNotice => 'Aviso Legal';

  @override
  String get privacyPolicy => 'Política de Privacidad';

  @override
  String version(String version) {
    return 'Versión v.$version';
  }

  @override
  String get spanish => 'Español';

  @override
  String get english => 'Ingles';

  @override
  String get catalan => 'Català';

  @override
  String get galician => 'Galego';

  @override
  String get basque => 'Euskera';

  @override
  String get mapViewer => 'Mapa Visor';

  @override
  String get alerts => 'Alertas';

  @override
  String get files => 'Fichas';

  @override
  String get interest => 'Interés';

  @override
  String get yourNationalAlertNetwork => 'Tu red de alerta nacional';

  @override
  String todayIs(String date) {
    return 'Hoy es $date';
  }

  @override
  String get newSubscription => 'Nueva suscripción';

  @override
  String get addNewSubscription => 'Añadir nueva suscripción';

  @override
  String get autonomousCommunity => 'Comunidad Autónoma';

  @override
  String get province => 'Provincia';

  @override
  String get municipality => 'Municipio';

  @override
  String get useCurrentLocation => 'Utilizar ubicación actual';

  @override
  String get createNewSubscription => 'Crear nueva suscripción';

  @override
  String get readyExclamations => '¡Listo!';

  @override
  String get understood => 'Entendido';

  @override
  String youHaveJustAddedAddress(String address) {
    return 'Acabas de añadir \"“$address”\" a tus Lugares suscritos. Ahora recibirás todas las alertas que afecten a este lugar.';
  }

  @override
  String get information => 'Información';

  @override
  String get theAlertsWillBeAvailableForOneYear =>
      'Las alertas estarán a tu disposición en la aplicación durante un año. Al finalizar este tiempo, las alertas se eliminarán.';

  @override
  String get magnitude3OrMore => 'Magnitud: 3 o más';

  @override
  String get magnitudeLessThan3 => 'Magnitud: menos de 3 y sentido';

  @override
  String recommendationsX(String x) {
    return 'Recomendaciones $x';
  }

  @override
  String get meteo => 'Meteo';

  @override
  String get earthquakes => 'Terremotos';

  @override
  String get extremeRisk => 'Riesgo extremo';

  @override
  String get veryHighRisk => 'Riesgo muy alto';

  @override
  String get highRisk => 'Riesgo alto';

  @override
  String get moderateRisk => 'Riesgo moderado';

  @override
  String get lowRisk => 'Riesgo bajo';

  @override
  String get wildfire => 'Incendios forestales';

  @override
  String get extreme => 'Extremo';

  @override
  String get important => 'Importante';

  @override
  String get dependsOnActivity => 'Depende actividad';

  @override
  String get summary => 'Resumen';

  @override
  String get coastalHazards => 'Fenómenos costeros';

  @override
  String get rainwaterAccumulation => 'Acum. de lluvia 1h';

  @override
  String get snowAccumulation => 'Acum. de nieve 24h';

  @override
  String get minimumTemperatures => 'Temperaturas mínimas';

  @override
  String get errorStartingApp => 'Error iniciando la aplicación';

  @override
  String get errorStartingAppText =>
      'Se ha detectado un error de conexión.\nNuestros servicios podrían no están disponibles en este momento, compruebe que tiene conexión a internet, e inténtelo más tarde.';

  @override
  String get retryText => 'Reintentar';

  @override
  String get appLogo => 'Logo de Protección Civil, Ministerio del Interior';

  @override
  String peninsulaMapShowing(String x) {
    return 'Mapa de la península mostrando alertas de $x';
  }

  @override
  String canariesMapShowing(Object x) {
    return 'Mapa de las Islas Canarias mostrando alertas de $x';
  }

  @override
  String get close => 'Close';

  @override
  String pageXofY(int x, int y) {
    return 'Página $x de $y';
  }

  @override
  String get gpsRequired => 'Se requiere GPS';

  @override
  String unorderedListSemantic(num size, String type) {
    return 'Lista no ordenada de $size $type';
  }

  @override
  String get recommendations => 'Recomendaciones';

  @override
  String get highWinds => 'Vientos fuertes';

  @override
  String get heavyRains => 'Lluvias intensas';

  @override
  String get highTemperatures => 'Altas temperaturas';

  @override
  String get coastal => 'Costeros';

  @override
  String get stormsAndLightningStrikes => 'Tormentas y rayos';

  @override
  String get forestFires => 'Incendios forestales';

  @override
  String get back => 'Volver';

  @override
  String elementXInListSemantic(num x, num y) {
    return 'Elemento $x de $y';
  }

  @override
  String get nextGenLogo =>
      'Logo de NextGenerationEU, Financiado por la Unión Europea';

  @override
  String get recoveryPlanLogo =>
      'Logo del Plan de Recuperación, Transformación y Resiliencia';

  @override
  String get digitalSpainLogo => 'Logo de España Digital 2026';

  @override
  String get entries => 'Entradas';

  @override
  String get opensExternalLink => 'Abre un enlace externo';

  @override
  String get newVersionAvailable => 'Nueva versión disponible';

  @override
  String get newVersionAvailableText =>
      'Hay disponible una nueva actualización de Protección Civil.';

  @override
  String get omit => 'Omitir';

  @override
  String forcedUpdate(String version) {
    return 'Actualización obligatoria Protección Civil v.$version';
  }

  @override
  String get forcedUpdateText =>
      'Para poder continuar actualizando la aplicación, debes actualizarla.';

  @override
  String get update => 'Actualizar';

  @override
  String get civilProtectionAlert => 'Alerta de Protección Civil';

  @override
  String get errorPopUp => '¡Error!';

  @override
  String get anErrorOccurredDuringTheQuery =>
      'Se ha producido un error durante la consulta. Por favor, inténtelo de nuevo.';

  @override
  String get tryAgain => 'Reintentar';

  @override
  String get backToHome => 'Volver al inicio';

  @override
  String get authenticationExpired => 'Autenticación expirada';

  @override
  String get badRequest => 'Solicitud incorrecta';

  @override
  String get unauthorized => 'No autorizado';

  @override
  String get forbidden => 'Prohibido';

  @override
  String get notFound => 'No encontrado';

  @override
  String get conflict => 'Conflicto';

  @override
  String get internalServerError => 'Error interno del servidor';

  @override
  String get unknownError => 'Error desconocido';

  @override
  String get noInternetConnection => 'No hay conexión a internet';

  @override
  String get infoNotMatch => 'La información no coincide';

  @override
  String get noAccess => 'Sin acceso';

  @override
  String get securityError => 'Error de seguridad';

  @override
  String get searchByAutonomousCommunity => 'Buscar por Comunidad Autónoma';

  @override
  String get searchByProvince => 'Buscar por Provincia';

  @override
  String get searchByMunicipality => 'Buscar por Municipio';

  @override
  String get select => 'Seleccionar';

  @override
  String get semanticMinMap =>
      'Mapa de las Islas Canarias mostrando alertas de meteo';

  @override
  String get semanticMap => 'Mapa de la península mostrando alertas de meteo';

  @override
  String get clear => 'Borrar';

  @override
  String get userNotFound => 'No existe el usuario';

  @override
  String get wrongPassword => 'Contraseña incorrecta';

  @override
  String get generalView => 'Cocina Vista General';

  @override
  String get tablesView => 'Cocina Vista Mesas';

  @override
  String get cocinaPedidosPorMesa => 'Cocina Pedidos Por Mesa';

  @override
  String get cocinaEstadoPedidos => 'Cocina Estado Pedidos';

  @override
  String get cancelOrder => 'Se cancela en Barra';

  @override
  String get served => 'SERVIDO';

  @override
  String get email => 'Correo electrónico';

  @override
  String get emailError => 'El correo no es correcto';

  @override
  String get password => 'Contraseña';

  @override
  String get passwordError => 'La contraseña tiene que ser de 6 caracteres';

  @override
  String get wait => 'Espere...';

  @override
  String get enter => 'Entrar';

  @override
  String get exitMenu => 'Salir de la Carta';

  @override
  String get closeApp => '¿Quieres cerrar la aplicación?';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get exitApp => 'Salir de la aplicación';
}
