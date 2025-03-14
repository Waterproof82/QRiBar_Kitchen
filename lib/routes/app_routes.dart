import 'package:qribar_cocina/presentation/cocina/cocina_general_screen.dart';
import 'package:qribar_cocina/presentation/cocina/cocina_pedidos_screen.dart';
import 'package:qribar_cocina/presentation/home/home_screen.dart';
import 'package:qribar_cocina/presentation/login/login_screen.dart';
import 'package:qribar_cocina/presentation/splash/splash_screen.dart';

class AppRoutes {
  static const String splash = 'splash';
  static const String login = 'login';
  static const String home = 'home';
  static const String cocinaPedidos = 'cuentasCocina';
  static const String cocinaGeneral = 'cuentasCocinaGeneral';

  static final routes = {
    splash: (_) => Splash(),
    login: (_) => LoginScreen(),
    home: (_) => HomeScreen(),
    cocinaPedidos: (_) => CocinaPedidosScreen(),
    cocinaGeneral: (_) => CocinaGeneralScreen(),
  };
}
