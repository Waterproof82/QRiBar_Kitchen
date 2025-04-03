class IdBarDataSource {
  // Private constructor to prevent external instantiation. Singleton pattern
  static final IdBarDataSource _instance = IdBarDataSource._internal();

  // Public getter to access the singleton instance
  static IdBarDataSource get instance => _instance;

  // Private constructor
  IdBarDataSource._internal();

  late String idBar;

  // Getter to access idBar
  String getIdBar() {
    return idBar;
  }

  // Setter to update idBar
  void setIdBar(String newIdBar) {
    idBar = newIdBar;
  }
}
