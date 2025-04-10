# QRiBar Cocina - ListenersDataSourceImpl

## Descripción
`ListenersDataSourceImpl` es una implementación clave en el proyecto QRiBar Cocina que actúa como una fuente de datos remota para escuchar y manejar eventos en tiempo real provenientes de Firebase Realtime Database. Su propósito principal es gestionar los cambios en los datos relacionados con los pedidos y notificar a las capas superiores de la aplicación para que puedan reaccionar en consecuencia.

## Funcionalidad principal
La clase `ListenersDataSourceImpl` se encarga de:
- Conectarse a Firebase Realtime Database.
- Escuchar cambios en tiempo real en nodos específicos de la base de datos.
- Transformar los datos recibidos en objetos del dominio (`Pedido`, `Producto`, etc.).
- Notificar a los repositorios o bloques (`Bloc`) sobre los cambios detectados.

## Métodos principales
### 1. `startListening()`
Inicia la escucha de cambios en los nodos relevantes de Firebase. Este método establece los listeners necesarios para detectar actualizaciones, eliminaciones o adiciones de datos.

### 2. `onPedidosUpdated()`
Se ejecuta cuando se detectan cambios en los pedidos. Convierte los datos recibidos de Firebase en una lista de objetos `Pedido` y los envía al repositorio o bloque correspondiente.

### 3. `onPedidoRemoved()`
Se ejecuta cuando un pedido es eliminado de la base de datos. Notifica a las capas superiores para que puedan actualizar la UI o realizar otras acciones necesarias.

### 4. `stopListening()`
Detiene todos los listeners activos en Firebase para evitar fugas de memoria o actualizaciones innecesarias cuando ya no se necesita escuchar cambios.

## Integración en el proyecto
`ListenersDataSourceImpl` se utiliza en conjunto con:
- **`ListenerRepositoryImpl`**: Actúa como intermediario entre la fuente de datos (`ListenersDataSourceImpl`) y la lógica de negocio (`ListenerBloc`).
- **`ListenerBloc`**: Recibe los eventos generados por `ListenersDataSourceImpl` y emite estados que actualizan la UI.

## Ejemplo de uso
El siguiente ejemplo muestra cómo se inicializa e integra `ListenersDataSourceImpl` en el proyecto:

```dart
final listenerDataSource = ListenersDataSourceImpl(
  database: FirebaseDatabase.instance,
  productService: productsService,
  nav: navegacionProvider,
);

final listenerRepo = ListenerRepositoryImpl(dataSource: listenerDataSource);

final listenerBloc = ListenerBloc(repository: listenerRepo)
  ..add(const ListenerEvent.startListening());