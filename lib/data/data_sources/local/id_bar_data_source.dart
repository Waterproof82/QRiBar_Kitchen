class IdBarDataSource {
  // Singleton privado con instancia (lazy)
  IdBarDataSource._();

  static final IdBarDataSource _instance = IdBarDataSource._();

  static IdBarDataSource get instance => _instance;

  String? _idBar;

  String get idBar {
    if (_idBar == null) {
      throw StateError('idBar no ha sido inicializado');
    }
    return _idBar!;
  }

  void setIdBar(String newIdBar) {
    _idBar = newIdBar;
  }

  // Solo para test
  void setIdBarForTest(String id) {
    _idBar = id;
  }

  // Solo para test: limpia el idBar
  void clearIdBarForTest() {
    _idBar = null;
  }

  bool get hasIdBar => _idBar != null;
}
