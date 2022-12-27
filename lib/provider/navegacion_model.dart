import 'package:flutter/material.dart';

class NavegacionModel with ChangeNotifier {
  PageController _pageController = new PageController();
  late AnimationController _bounceController;
  // GlobalKey<FormState> iconKey = new GlobalKey<FormState>();
  // late AnimationController _bounceController;
/*   String idBar=ProductsService.idBar ; //Viene de URL
  String idMesa=ProductsService.idBar ;  */
  int _paginaActual = 0;
  int _numero = 0;
  String _categoriaSelected = "Cocina Estado Pedidos";
  Color _color = Colors.white70;
  Color _activeColor = Color.fromARGB(172, 2, 210, 58).withOpacity(0.5);
  Color _activeColorBorder = Color.fromARGB(240, 255, 217, 0);
  Color _inactiveColor = Colors.black;
  int _itemSeleccionado = 99;
  double _precioTotal = 0;
  double _precioTotalPedidos = 0;
  bool _filtroCantidad = false;
  bool _mostrar = true;
  int _itemSeleccionadoMenu = 1;
  Color backgroundColor = Colors.white;
  int _idPedidoSelected = 1;
  String _url = '';
  bool _isSelected = false;
  int _addDelButton = 0;
  int _numPedido = 0;
  int _mesasActivas = 0;
  String _mesaActual = '0';
  String _idPedidoSelectedMesas = '1';
  List _mesasActivasBar = [];
  String _tipoMesa = 'nulo';
  int _mesaVacia = 0;
  int _mesaActiva = 0;
  int _mesaPendiente = 0;
  int _mesaProcesada = 0;
  int _mesaPagada = 0;
  bool _valRecargaWidget = false;
  bool _mediaRacion = false;
  bool _cancelado = false;
  Color _colorPed = Color.fromARGB(255, 0, 0, 0);
  Color _colorTema = Color.fromARGB(255, 255, 255, 255);
  String _nombreCliente = '';
  String _nombreSala = '';
  bool _dialogNota = false;
  bool _pedidoMiDispositivo = false;
  bool _cambioEstadoProducto = false;
  String _notas = '';
  int _numTotalUsers = 0;
  String _nombreIcon = '';
  String _nombreCategoria = '';
  String _nombreCategoriaEn = '';
  String _nombreCategoriaDe = '';
  String _envio = '';
  int _orden = 1;
  bool disponible = false;
  int _avisoSala = 0;
  String _clave = '';
  double _precioTotalPedidosSala = 0;

  double get precioTotalPedidosSala => this._precioTotalPedidosSala;
  set precioTotalPedidosSala(double valor) {
    this._precioTotalPedidosSala = valor;
    notifyListeners();
  }

  String get clave => this._clave;
  set clave(String clave) {
    this._clave = clave;
    notifyListeners();
  }

  updateAvailability(bool value) {
    //print(value);
    disponible = value;
    notifyListeners();
  }

/*   bool get disponible => this._disponible;
  set disponible(bool valor) {
    this._disponible = valor;
    notifyListeners();
  }
 */
  int get avisoSala => this._avisoSala;
  set avisoSala(int index) {
    this._avisoSala = index;
    notifyListeners();
  }

  AnimationController get bounceController => this._bounceController;
  set bounceController(AnimationController controller) {
    this._bounceController = controller;
    //notifyListeners();
  }

  int get orden => this._orden;
  set orden(int index) {
    this._orden = index;
    notifyListeners();
  }

  String get envio => this._envio;
  set envio(String envio) {
    this._envio = envio;
    notifyListeners();
  }

  String get nombreCategoriaEn => this._nombreCategoriaEn;
  set nombreCategoriaEn(String nombreCategoriaEn) {
    this._nombreCategoriaEn = nombreCategoriaEn;
    notifyListeners();
  }

  String get nombreCategoriaDe => this._nombreCategoriaDe;
  set nombreCategoriaDe(String nombreCategoriaDe) {
    this._nombreCategoriaDe = nombreCategoriaDe;
    notifyListeners();
  }

  String get nombreCategoria => this._nombreCategoria;
  set nombreCategoria(String nombreCategoria) {
    this._nombreCategoria = nombreCategoria;
    notifyListeners();
  }

  String get nombreIcon => this._nombreIcon;
  set nombreIcon(String nombreIcon) {
    this._nombreIcon = nombreIcon;
    notifyListeners();
  }

  Color get colorTema => this._colorTema;
  set colorTema(Color valor) {
    this._colorTema = valor;
    notifyListeners(); //Redibuja Listener cuando set recibe un cambio de valor
  }

  int get numTotalUsers => this._numTotalUsers;
  set numTotalUsers(int index) {
    this._numTotalUsers = index;
    notifyListeners();
  }

  String get notas => this._notas;
  set notas(String notas) {
    this._notas = notas;
    notifyListeners();
  }

  bool get cambioEstadoProducto => this._cambioEstadoProducto;
  set cambioEstadoProducto(bool valor) {
    this._cambioEstadoProducto = valor;
    notifyListeners();
  }

  bool get pedidoMiDispositivo => this._pedidoMiDispositivo;
  set pedidoMiDispositivo(bool valor) {
    this._pedidoMiDispositivo = valor;
    notifyListeners();
  }

  bool get dialogNota => this._dialogNota;
  set dialogNota(bool valor) {
    this._dialogNota = valor;
    notifyListeners();
  }

  String get nombreCliente => this._nombreCliente;
  set nombreCliente(String nombreCliente) {
    this._nombreCliente = nombreCliente;
    notifyListeners();
  }

  String get nombreSala => this._nombreSala;
  set nombreSala(String nombreSala) {
    this._nombreSala = nombreSala;
    notifyListeners();
  }

  Color get colorPed => this._colorPed;
  set colorPed(Color valor) {
    this._colorPed = valor;
    notifyListeners(); //Redibuja Listener cuando set recibe un cambio de valor
  }

  bool get cancelado => this._cancelado;
  set cancelado(bool valor) {
    this._cancelado = valor;
    notifyListeners();
  }

  bool get mediaRacion => this._mediaRacion;
  set mediaRacion(bool valor) {
    this._mediaRacion = valor;
    notifyListeners();
  }

  bool get valRecargaWidget => this._valRecargaWidget;
  set valRecargaWidget(bool valor) {
    this._valRecargaWidget = valor;
    notifyListeners();
  }

  int get mesaVacia => this._mesaVacia;
  set mesaVacia(int index) {
    this._mesaVacia = index;
    notifyListeners();
  }

  int get mesaActiva => this._mesaActiva;
  set mesaActiva(int index) {
    this._mesaActiva = index;
    notifyListeners();
  }

  int get mesaPendiente => this._mesaPendiente;
  set mesaPendiente(int index) {
    this._mesaPendiente = index;
    notifyListeners();
  }

  int get mesaProcesada => this._mesaProcesada;
  set mesaProcesada(int index) {
    this._mesaProcesada = index;
    notifyListeners();
  }

  int get mesaPagada => this._mesaPagada;
  set mesaPagada(int index) {
    this._mesaPagada = index;
    notifyListeners();
  }

  String get tipoMesa => this._tipoMesa;
  set tipoMesa(String tipoMesa) {
    this._tipoMesa = tipoMesa;
    notifyListeners();
  }

  List get mesasActivasBar => this._mesasActivasBar;
  set mesasActivasBar(List index) {
    this._mesasActivasBar = index;
    notifyListeners();
  }

  String get mesaActual => this._mesaActual;
  set mesaActual(String index) {
    this._mesaActual = index;
    notifyListeners();
  }

  String get idPedidoSelectedMesas => this._idPedidoSelectedMesas;
  set idPedidoSelectedMesas(String index) {
    this._idPedidoSelectedMesas = index;
    notifyListeners();
  }

  int get mesasActivas => this._mesasActivas;
  set mesasActivas(int index) {
    this._mesasActivas = index;
    notifyListeners();
  }
/*
  bool get pedidoRealizado => this._pedidoRealizado;
  set pedidoRealizado(bool valor) {
    this._pedidoRealizado = valor;
    notifyListeners();
  } */

  /* Color _colorFont = Colors.black; */
  int get addDelButton => this._addDelButton;
  set addDelButton(int index) {
    this._addDelButton = index;
    notifyListeners();
  }

  int get numPedido => this._numPedido;
  set numPedido(int index) {
    this._numPedido = index;
    notifyListeners();
  }

  ///////////////////////////////////
  String get url => this._url;
  set url(String url) {
    this._url = url;
    notifyListeners();
  }

  bool get isSelected => this._isSelected;
  set isSelected(bool valor) {
    this._isSelected = valor;
    notifyListeners();
  }

//MenuInferior
  bool get mostrar => this._mostrar;
  set mostrar(bool valor) {
    this._mostrar = valor;
    notifyListeners();
  }

  int get idPedidoSelected => this._idPedidoSelected;
  set idPedidoSelected(int index) {
    this._idPedidoSelected = index;
    notifyListeners();
  }

  int get itemSeleccionadoMenu => this._itemSeleccionadoMenu;
  set itemSeleccionadoMenu(int index) {
    this._itemSeleccionadoMenu = index;
    notifyListeners();
  }

//
  int get itemSeleccionado => this._itemSeleccionado;
  set itemSeleccionado(int index) {
    this._itemSeleccionado = index;
    notifyListeners();
  }

  bool get filtroCantidad => this._filtroCantidad;
  set filtroCantidad(bool valor) {
    this._filtroCantidad = valor;
    notifyListeners(); //Redibuja Listener cuando set recibe un cambio de valor
  }

  Color get color => this._color;
  set color(Color valor) {
    this._color = valor;
    notifyListeners(); //Redibuja Listener cuando set recibe un cambio de valor
  }

  Color get activeColor => this._activeColor;
  set activeColor(Color valor) {
    this._activeColor = valor;
    notifyListeners(); //Redibuja Listener cuando set recibe un cambio de valor
  }

  Color get activeColorBorder => this._activeColorBorder;
  set activeColorBorder(Color valor) {
    this._activeColorBorder = valor;
    notifyListeners(); //Redibuja Listener cuando set recibe un cambio de valor
  }

  Color get inactiveColor => this._inactiveColor;
  set inactiveColor(Color valor) {
    this._inactiveColor = valor;
    notifyListeners(); //Redibuja Listener cuando set recibe un cambio de valor
  }

  String get categoriaSelected => this._categoriaSelected;
  set categoriaSelected(String name) {
    this._categoriaSelected = name;
    notifyListeners();
  }

  int get numero => this._numero;
  set numero(int valor) {
    this._numero = valor;
    notifyListeners(); //Redibuja Listener cuando set recibe un cambio de valor
  }

  double get precioTotal => this._precioTotal;
  set precioTotal(double valor) {
    this._precioTotal = valor;
    notifyListeners();
  }

  double get precioTotalPedidos => this._precioTotalPedidos;
  set precioTotalPedidos(double valor) {
    this._precioTotalPedidos = valor;
    notifyListeners();
  }

/*   AnimationController get bounceController => this._bounceController;
  set bounceController(AnimationController controller) {
    this._bounceController = controller;
    //notifyListeners();
  } */

  int get paginaActual => this._paginaActual;
  set paginaActual(int valor) {
    this._paginaActual = valor;
    _pageController.animateToPage(valor, duration: Duration(milliseconds: 350), curve: Curves.decelerate);
    //Asi cuando recibo valor recibo un aviso que se controla
    notifyListeners();
  }

//Actualiza los cambios
  PageController get pageController => this._pageController;
}
