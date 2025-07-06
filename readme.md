# Qribar Cocina App

## Overview

Qribar Cocina is a mobile application designed to optimize order management in professional kitchen environments. It facilitates real-time visualization and handling of orders by table and order number, allowing kitchen teams efficient management and fluid communication.

The application is built with Flutter and Dart, following Clean Architecture principles and leveraging the latest features and optimizations of Dart 3 to ensure optimal performance, maintainability, and scalability.

## Key Features

* **Real-time Order Management:** Instant visualization and updating of orders and their statuses.
* **Organization by Table and Order:** Intuitive navigation between specific tables and orders.
* **Line Item Status Management:** Control over the status of each order item (e.g., "in progress," "cooked").
* **User Authentication:** Secure access to the application.
* **Multi-language Support:** User interface adaptable to different languages.
* **Responsive Design:** Adaptability to various screen sizes and device orientations.

## Architecture and Design Principles

The project follows a clean layered architecture, promoting separation of concerns and facilitating testability and maintenance:

1.  **Presentation Layer:**
    * **Widgets:** UI components responsible for rendering the interface.
    * **BLoC/Cubit:** Manages UI state and presentation logic. BLoCs (`LoginFormBloc`, `ListenerBloc`) and Cubits (`LanguageCubit`) are `abstract class`es that define contracts, and their concrete implementations (`LoginFormBlocImpl`, `ListenerBlocImpl`, `LanguageCubitImpl`) are `final class`es.

2.  **Domain Layer:**
    * **Models (Entities):** Representations of business entities (e.g., `Pedido`, `Producto`).
    * **Use Cases:** Contain the application's specific business logic. They are `abstract class`es (e.g., `LoginUseCase`) and their implementations are `final class`es (e.g., `LoginUseCaseImpl`).
    * **Repository Contracts:** Abstract interfaces that define how the domain layer interacts with the data layer (e.g., `LoginRepositoryContract`, `ListenerRepository`).

3.  **Data Layer:**
    * **Repositories:** Implement domain repository contracts, orchestrating access to different data sources. Their implementations are `final class`es (e.g., `LoginRepositoryImpl`, `ListenerRepositoryImpl`).
    * **Data Sources:** Interact directly with external APIs (remote) or local storage. Their contracts are `abstract class`es (e.g., `AuthRemoteDataSourceContract`, `ListenersRemoteDataSourceContract`, `PreferencesLocalDataSourceContract`, `LocalizationLocalDataSourceContract`) and their implementations are `final class`es (e.g., `AuthRemoteDataSourceImpl`, `ListenersRemoteDataSource`, `Preferences`, `LocalizationLocalDataSource`).

## Dart 3 Optimization and Best Practices

* **Class Modifiers (`final class`, `abstract class`):**
    * **`final class`:** Used for all utility classes (e.g., `AppColors`, `AppTheme`, `IdBarDataSource`) and concrete contract implementations (e.g., `*Impl` classes, `*RepositoryImpl`, `*DataSource`). This ensures that these classes cannot be extended, implemented, or mixed in outside their own library, providing strict control over the codebase and guaranteeing the immutability and "finality" of their design.
    * **`abstract class`:** Used to define contracts (interfaces) in the Domain and Data layers (e.g., `LoginUseCase`, `ListenerBloc`, `LoginRepositoryContract`). This is crucial for **Dependency Inversion** and **testability**, allowing high-level components to depend on abstractions rather than concrete implementations.
* **Dependency Injection (DI):**
    * `GetIt` is used for global dependency registration and resolution.
    * Dependencies are injected via **constructors**, promoting cleaner and more testable code.
* **`const` Constructors and `static const` Fields:** Applied whenever possible to optimize performance by creating objects at compile time (e.g., in `AppColors`, `AppTheme`).
* **Concurrent Initialization:** Use of `Future.wait` in `initDi()` to execute multiple initialization tasks asynchronously and in parallel, improving application startup time.
* **UI State Management:**
    * Use of `BlocListener`, `BlocBuilder`, `BlocSelector` for granular and optimized UI rebuilds, avoiding unnecessary renders.
    * Conversion of `StatelessWidget`s to `StatefulWidget`s (e.g., `PedidosListMenu`, `PedidosMesasListMenu`) when necessary to manage a `ScrollController` and its lifecycle, ensuring controllers persist and scroll animations work correctly.
    * Implementation of listeners in `ChangeNotifier` (`NavegacionProvider`) and `WidgetsBinding.instance.addPostFrameCallback` to ensure UI operations (like scrolling) are performed after the widget tree is fully built.

## Key Component: ListenersRemoteDataSource

### Description

`ListenersRemoteDataSource` is a key implementation in the QRiBar Cocina project that acts as a remote data source for listening and handling real-time events from Firebase Realtime Database. Its main purpose is to manage changes in data related to products, categories, and orders, and to notify higher layers of the application so they can react accordingly.

### Core Functionality

The `ListenersRemoteDataSource` class is responsible for:

* Connecting to Firebase Realtime Database.
* Listening for real-time changes (additions, modifications, deletions) in specific database nodes (products, categories, orders).
* Transforming raw data received from Firebase into domain objects (`Pedido`, `Product`, `CategoriaProducto`).
* Emitting events (`ListenerEvent`) through a `Stream` to notify repositories or BLoCs about detected changes.

### Main Methods

1.  **`addProduct()`**: Initiates listening and managing changes for product data.
2.  **`addCategoriaMenu()`**: Initiates listening and managing changes for product category data.
3.  **`addSalaMesas()`**: Performs an initial read and updates the status of tables/rooms.
4.  **`addAndChangedPedidos()`**: Initiates listening for new and changed order data.
5.  **`removePedidos()`**: Initiates listening for removed order data from the database.
6.  **`dispose()`**: Stops all active listeners in Firebase and closes the event stream to prevent memory leaks and release resources.

### Project Integration

`ListenersRemoteDataSource` is used in conjunction with:

* **`ListenerRepositoryImpl`**: Acts as an intermediary between this data source (`ListenersRemoteDataSource`) and the business logic (`ListenerBloc`), orchestrating initialization and data flow.
* **`ListenerBloc`**: Receives events (`ListenerEvent`) generated by the `eventsStream` of `ListenersRemoteDataSource` (via `ListenerRepository`) and emits states that update the UI.

### Example Usage

The following example shows how `ListenersRemoteDataSource` is initialized and integrated into the project (typically via dependency injection):

```dart
final listenersRemoteDataSource = ListenersRemoteDataSource(
  database: FirebaseDatabase.instance,
);

final listenerRepo = ListenerRepositoryImpl(
  database: FirebaseDatabase.instance, // Or injected from GetIt
  dataSource: listenersRemoteDataSource,
);

final listenerBloc = ListenerBlocImpl( // Using the concrete implementation
  repository: listenerRepo,
  authRemoteDataSourceContract: /* your AuthRemoteDataSourceContract implementation */,
)
  ..add(const ListenerEvent.startListening());