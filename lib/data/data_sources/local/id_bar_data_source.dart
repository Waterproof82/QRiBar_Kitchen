/// A final class implementing the Singleton pattern to manage a single,
/// application-wide ID for a bar or similar entity.
///
/// This class ensures that only one instance of `IdBarDataSource` exists
/// throughout the application, providing a centralized point to set and retrieve
/// the bar's ID.
final class IdBarDataSource {
  IdBarDataSource._();

  /// The single, static instance of [IdBarDataSource].
  /// It's initialized eagerly when the class is first accessed.
  static final IdBarDataSource _instance = IdBarDataSource._();

  /// Provides the global singleton instance of [IdBarDataSource].
  /// This is the primary way to access the class's functionality.
  static IdBarDataSource get instance => _instance;

  /// The private, nullable string that holds the bar's ID.
  /// It can be null if the ID has not yet been set.
  String? _idBar;

  /// Retrieves the bar's ID.
  ///
  /// Throws a [StateError] if the ID has not been initialized (i.e., is null).
  /// This indicates a programming error where the ID is accessed before being set.
  String get idBar {
    if (_idBar == null) {
      throw StateError('idBar has not been initialized.');
    }
    return _idBar!;
  }

  /// Sets the bar's ID to a new value.
  ///
  /// This method updates the internal `_idBar` field.
  void setIdBar(String newIdBar) {
    _idBar = newIdBar;
  }

  /// Checks if the bar's ID has been set.
  ///
  /// Returns `true` if `_idBar` is not null, `false` otherwise.
  bool get hasIdBar => _idBar != null;

  // --- Test-specific methods ---
  // These methods are typically used only in testing environments to manipulate
  // the singleton's state for isolated test cases.

  /// Sets the bar's ID specifically for testing purposes.
  /// This allows tests to control the state of the singleton.
  void setIdBarForTest(String id) {
    _idBar = id;
  }

  /// Clears the bar's ID specifically for testing purposes.
  /// This helps in resetting the singleton's state between tests.
  void clearIdBarForTest() {
    _idBar = null;
  }
}
