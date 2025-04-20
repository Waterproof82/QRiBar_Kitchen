class IdBarDataSource {
  // Private constructor to prevent external instantiation. Singleton pattern
  static final IdBarDataSource _instance = IdBarDataSource._internal();

  // Public getter to access the singleton instance
  static IdBarDataSource get instance => _instance;

  // Private constructor
  IdBarDataSource._internal();

  late String idBar;

  String getIdBar() {
    return idBar;
  }

  void setIdBar(String newIdBar) {
    idBar = newIdBar;
  }
}
